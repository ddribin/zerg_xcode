require 'fileutils'
require 'pathname'

class ZergXcode::Plugins::Import
  include ZergXcode::Objects
  
  def help
    {:short => 'imports the objects from a project into another project',
     :long => <<"END" }
Usage: import source_path [target_path]

Imports the objects (build targets, files) from a source project into another
target project. Useful when the source project wraps code that can be used as a
library.
END
  end
  
  def run(args)
    source = ZergXcode.load args.shift
    target = ZergXcode.load(args.shift || '.')
    
    file_ops = import_project! source, target
    target.save!
    execute_file_ops! file_ops 
  end
  
  # Executes the given file operations.
  def execute_file_ops!(file_ops)
    file_ops.each do |op|
      case op[:op]
      when :delete
        FileUtils.rm_r op[:path] if File.exist? op[:path]
      when :copy
        target_dir = File.dirname op[:to]
        FileUtils.mkdir_p  target_dir unless File.exist? target_dir
        if File.exist? op[:from]
          FileUtils.cp_r op[:from], op[:to]
        else
          print "Source does not have file #{op[:from]}\n"
        end
      end
    end
  end
  
  # Imports the objects of the source project into the target project.
  # 
  # Attempts to preserve reference integrity in the target project, as follows.
  # If the source objects have counterparts in the target, their contents is
  # merged into the target project's objects.
  #
  # Returns an array of file operations that need to be performed to migrate the
  # files associated with the two projects.
  #
  # The target project is modified in place.
  def import_project!(source, target)
    old_target_paths = target.all_files.map { |file| file[:path] } 
    
    # duplicate the source, because the duplicate's object graph will be warped
    scrap_source = ZergXcode::XcodeObject.from source
    
    mappings = cross_reference scrap_source, target
    bins = bin_mappings mappings, scrap_source
    
    # special case for merging targets
    map! scrap_source, mappings
    merge! scrap_source['targets'], target['targets']
    
    # merge the object graphs
    bins[:merge].each do |object|
      map! object, mappings
      merge! object, mappings[object]
    end
    bins[:overwrite].each do |object|
      map! object, mappings
      overwrite! object, mappings[object]
    end
    
    # make sure all the mappings point in the right place 
    target.visit_once do |object, parent, key, value|
      if mappings[value]
        next mappings[value]
      else
        next true
      end
    end
    
    new_target_paths = target.all_files.map { |file| file[:path] }
    source_paths = source.all_files.map { |file| file[:path] }
    return compute_deletes(target.root_path, old_target_paths,
                           new_target_paths) +
           compute_copies(source.root_path, source_paths, target.root_path)
  end

  # Computes the file delete operations in a merge.
  #
  # Deletes all the files that aren't in the target project anymore. 
  def compute_deletes(root, old_paths, new_paths)
    new_path_set = Set.new(new_paths)
    old_paths.select { |path| path[0, 2] == './' }.
              reject { |path| new_path_set.include? path }.
              map { |path| { :op => :delete, :path => clean_join(root, path) } }
  end

  # Computes the file copy operations in a merge.
  #
  # Copies all the files from the source project assuming they received the same
  # path in the target project. The assumption is correct if source was imported
  # into target.
  def compute_copies(source_root, source_paths, target_root)
    source_paths.select { |path| path[0, 2] == './' }.map do |path|
      { :op => :copy, :from => clean_join(source_root, path),
        :to => clean_join(target_root, path) }
    end
  end
  
  def clean_join(root, path)
    Pathname.new(File.join(root, path)).cleanpath.to_s
  end
  
  # Bins merge mappings for a project into mappings to be merged and mappings to
  # be overwritten.
  def bin_mappings(mappings, source)
    merge_set = Set.new
    overwrite_set = Set.new

    # the project's top-level attributes are always merged
    source.attrs.each do |attr|
      merge_set << source[attr] if mappings[source[attr]]
    end
        
    mappings.each do |source_object, target_object|
      next if source_object == target_object
      next if merge_set.include? source_object
      
      if source_object.kind_of?(PBXGroup) && source_object['path'].nil?
        merge_set << source_object
      elsif source_object.kind_of? XCConfigurationList
        merge_set << source_object
      else
        overwrite_set << source_object
      end
    end
    
    overwrite_set.delete source
    { :merge => merge_set, :overwrite => overwrite_set }
  end
  
  # Modifies an object's attributes according to the given mappings.
  # This explores the object graph, but does not go into sub-objects.
  def map!(object, mappings)
    object.visit_once do |object, parent, key, value|
      if mappings[value]
        parent[key] = mappings[value]
        next false
      end
      next true
    end
  end
  
  # Merges the contents of a source object into the target object.
  #
  # Warning: the target will share internal objects with the source. This is
  # intended to be used in a bigger-level opration, where the source will be
  # thrown away afterwards.
  def merge!(source, target)
    if source.class != target.class
      raise "Attempting to merge-combine different kinds of objects - " +
            "#{source.class} != #{target.class}"
    end
    
    case source
    when ZergXcode::XcodeObject
      merge! source._attr_hash, target._attr_hash
    when Hash
      source.each_key do |key|
        if !target.has_key?(key)
          target[key] = source[key]          
        elsif source[key].kind_of? ZergXcode::XcodeObject
          target[key] = source[key]
        elsif source[key].kind_of?(String)
          target[key] = source[key]
        elsif !source[key].kind_of?(Enumerable)
          target[key] = source[key]
        else
          merge! source[key], target[key]
        end
      end
    when Enumerable
      target_set = Set.new(target.to_a)
      source.each do |value|
        next if target_set.include? value
        target << value
      end
    end   
  end
  
  # Overwrites the contents of the target object with the source object.
  #
  # Warning: the target will share internal objects with the source. This is
  # intended to be used in a bigger-level opration, where the source will be
  # thrown away afterwards.  
  def overwrite!(source, target)
    if source.class != target.class    
      raise "Attempting to overwrite-combine different kinds of objects - " +
            "#{source.class} != #{target.class}"
    end
    
    case source
    when ZergXcode::XcodeObject
      overwrite! source._attr_hash, target._attr_hash
    when Hash
      target.clear
      target.merge! source
    when Enumerable
      target.clear
      source.each { |value| target << value }      
    end
  end
  
  # Cross-references the objects in two object graphs that are to be merged.
  # Returns a Hash associating objects in both the source and the target object
  # graphs with the corresponding objects in the 
  def cross_reference(source, target, mappings = {})
    if source.class != target.class
      raise "Attempting to cross-reference different kinds of objects - " +
            "#{source.class} != #{target.class}"
    end
    
    case target
    when ZergXcode::XcodeObject
      cross_op = :cross_reference_objects
    when Hash
      cross_op = :cross_reference_hashes
    when Enumerable
      cross_op = :cross_reference_enumerables
    else
      return mappings
    end
    
    self.send cross_op, source, target, mappings
  end
    
  def cross_reference_objects(source, target, mappings)
    return mappings if mappings[source] || mappings[target]    
    return mappings if source.xref_key != target.xref_key
    
    mappings[target] = target
    mappings[source] = target
    cross_reference source._attr_hash, target._attr_hash, mappings
  end
  private :cross_reference_objects
  
  def cross_reference_hashes(source, target, mappings)
    source.each_key do |key|
      p [source.keys, key] if source[key].nil? 
      cross_reference source[key], target[key], mappings if target[key]
    end
    mappings
  end
  private :cross_reference_hashes
  
  def cross_reference_enumerables(source, target, mappings)
    source_keys = {}
    source.each do |value|
      next unless value.kind_of? ZergXcode::XcodeObject
      source_keys[value.xref_key] = value
    end
    target.each do |value|
      next unless value.kind_of? ZergXcode::XcodeObject
      next unless source_value = source_keys[value.xref_key]
      cross_reference source_value, value, mappings
    end
    mappings
  end
  private :cross_reference_enumerables  
end
