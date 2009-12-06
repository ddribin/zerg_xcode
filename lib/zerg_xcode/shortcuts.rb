# Convenience methods for core ZergXcode functionality.
#
# Author:: Victor Costan
# Copyright:: Copyright (C) 2009 Zergling.Net
# License:: MIT


# :nodoc: namespace
module ZergXcode
  # Reads an Xcode project from the filesystem.
  def self.load(path)
    file = ZergXcode::Paths.project_file_at path
    pbx_contents = File.read file
    project = Archiver.unarchive pbx_contents
    project.source_filename = file
    return project
  end
  
  # Dumps an Xcode project to the filesystem.
  def self.dump(project, path)
    file = ZergXcode::Paths.project_file_at path
    pbx_contents = Archiver.archive project
    File.open(file, 'w') { |f| f.write pbx_contents }
  end
  
  # Instantiate a plug-in.
  def self.plugin(plugin_name)
    ZergXcode::Plugins.get(plugin_name)
  end
end  # namespace ZergXcode
