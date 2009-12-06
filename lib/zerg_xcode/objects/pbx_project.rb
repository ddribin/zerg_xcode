# The root object in the Xcode object graph.
#
# Author:: Victor Costan
# Copyright:: Copyright (C) 2009 Zergling.Net
# License:: MIT

# :nodoc: namespace
module ZergXcode::Objects


# The root object in the Xcode object graph.
class PBXProject < ZergXcode::XcodeObject
  # Used to implement save!
  attr_accessor :source_filename
  
  # :nodoc: override to copy the new metadata
  def copy_metadata(source)
    super
    self.source_filename = source.source_filename
  end

  # Saves a project that was loaded by ZergXcode.load
  def save!
    raise 'Project not loaded by ZergXcode.load' unless @source_filename
    ZergXcode.dump self, @source_filename
  end
  
  # The root path of the project.
  def root_path
    ZergXcode::Paths.project_root_at source_filename
  end
  
  # All the files referenced by the project.
  def all_files
    files = []
    project_root = self['projectRoot'].empty? ? '.' : self['projectRoot']
    FileVisitor.visit self['mainGroup'], project_root, files
    files
  end
  
  # :nodoc: override xref_name because PBXProject is a singleton
  def xref_name
    isa.to_s
  end  

  # Container for the visitor that lists all files in a project.
  module FileVisitor
    def self.visit(object, root_path, files)
      case object.isa
      when :PBXGroup
        visit_group(object, root_path, files)
      when :PBXFileReference
        visit_file(object, root_path, files)
      end
    end
    
    def self.visit_group(group, root_path, files)
      path = merge_path(root_path, group['sourceTree'], group)
      
      group['children'].each do |child|
        visit child, path, files
      end
    end
    
    def self.visit_file(file, root_path, files)
      path = merge_path(root_path, file['sourceTree'], file)
      
      files << { :path => path, :object => file } 
    end
    
    def self.merge_path(old_path, source_tree, object)
      case source_tree
      when '<group>'
        base_path = old_path
      else
        base_path = source_tree
      end
      if object['path']
        path = File.join(base_path, object['path'])
      else
        path = old_path
      end
      return path
    end
  end
end  # class ZergXcode::Objects::PBXProject

end  # namespace class ZergXcode::Objects
