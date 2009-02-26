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
    
    import_project! source, target
    target.save!
  end
  
  def import_project!(source, target)
    # duplicate the source, because the duplicate's object graph will be warped
    source = ZergXcode::XcodeObject.from source
    
    mappings = cross_reference source, target
    bins = bin_mappings mappings, source
    
    # special case for merging targets
    map! source, mappings
    merge! source['targets'], target['targets']
    
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
    return mappings if source.merge_key != target.merge_key
    
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
      source_keys[value.merge_key] = value
    end
    target.each do |value|
      next unless value.kind_of? ZergXcode::XcodeObject
      next unless source_value = source_keys[value.merge_key]
      cross_reference source_value, value, mappings
    end
    mappings
  end
  private :cross_reference_enumerables  
end

class ZergXcode::XcodeObject
  def merge_key
    # If the object doesn't have a merge name, use its (unique) object_id.
    [isa, merge_name || object_id]
  end
  
  def merge_name
    # Do not use this to override merge_name for specific objects. Only use
    # it for object families.
    case isa.to_s
    when /BuildPhase$/
      isa.to_s
    else
      self['name'] || self['explicitPath'] || self['path'] 
    end
  end  
end

class ZergXcode::Objects::PBXBuildFile
  def merge_name
    self['fileRef'].merge_name
  end
end

class ZergXcode::Objects::PBXProject
  def merge_name
    isa.to_s
  end
end

class ZergXcode::Objects::XCConfigurationList
  def merge_name
    isa.to_s
  end
end

class ZergXcode::Objects::PBXContainerItemProxy
  def merge_name
    self['remoteInfo']
  end
end

class ZergXcode::Objects::PBXTargetDependency
  def merge_name
    target.merge_name
  end
end
