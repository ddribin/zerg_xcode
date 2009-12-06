# Lists the files in an Xcode project.
#
# Author:: Victor Costan
# Copyright:: Copyright (C) 2009 Zergling.Net
# License:: MIT

# :nodoc: namespace
module ZergXcode::Plugins


# Lists the files in an Xcode project.
class Ls
  def help
    {:short => 'shows the files in a project',
     :long => <<"END" }
Usage: ls [path]

Lists all the files in the project at the given path. If no path is given, looks
for a project in the current directory.
END
  end
  
  def run(args)
    list = list_for(args.shift || '.')
    output = ""
    list.each do |entry|
      output << "%-20s %s\n" % [entry.last, entry.first]
    end
    print output
    output
  end
  
  def list_for(project_name)    
    ZergXcode.load(project_name).all_files.map do |file|
      [file[:path], file[:object]['lastKnownFileType']]
    end
  end  
end  # class ZergXcode::Plugins::Ls

end  # namespace ZergXcode::Plugins
