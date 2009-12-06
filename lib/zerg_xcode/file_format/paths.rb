# Xcode project path resolver.
#
# Author:: Victor Costan
# Copyright:: Copyright (C) 2009 Zergling.Net
# License:: MIT

# :nodoc: namespace
module ZergXcode
  

# Finds the .pbxproj file inside an Xcode project.
module Paths
  # The most likely project file name for the given path. 
  def self.project_file_at(base_path)
    return base_path if File.exist?(base_path) and File.file?(base_path)
    pbxfile = 'project.pbxproj'
    
    # naively assume the user gave the right name
    path = base_path
    path = path[0...-1] if path[-1, 1] == '/' || path[-1, 1] == '\\'
    path = path + '.xcodeproj' unless /\.xcodeproj$/ =~ path
    if File.exist? path
      file = File.join(path, pbxfile)
      return file
    end
    
    # didn't work, perhaps user gave us a path into their root
    entries = Dir.entries(base_path).sort_by do |entry|
      File.file?(File.join(base_path, entry)) ? 0 : 1
    end
    
    entries.each do |entry|
      next if entry == '..'
      path = File.join(base_path, entry)      
      case entry
      when /\.pbxproj$/
        return path
      when /\.xcodeproj$/
        return File.join(path, pbxfile)
      else
        if File.directory?(path) && File.exist?(File.join(path, pbxfile))
          return File.join(path, pbxfile)
        end
      end
    end
    
    raise "Could not find Xcode project at #{base_path}"
  end
  
  # The most likely project root dir for the given path.
  def self.project_root_at(base_path)
    file = project_file_at base_path
    File.dirname File.dirname(file)
  end
end  # module ZergXcode::Paths

end  # module ZergXcode
