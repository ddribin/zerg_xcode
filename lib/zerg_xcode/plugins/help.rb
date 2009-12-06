# Displays the help strings for other plugins.
#
# Author:: Victor Costan
# Copyright:: Copyright (C) 2009 Zergling.Net
# License:: MIT

# :nodoc: namespace
module ZergXcode::Plugins


# Displays the help strings for other plugins.
class Help
  def help
    {:short => 'command-line usage instructions',
     :long => <<"END" }
Usage: help [command]

Shows the usage for the given command. If no command is  given, shows a list of
commands with a short description for each command.
END
  end
  
  def run(args)
    helpstr = "Xcode Project Modifier brought to you by Zergling.Net.\n"
  
    plugin = args.shift
    if ZergXcode::Plugins.all.include? plugin
      help = ZergXcode::Plugins.get(plugin).help
      helpstr << "#{plugin} - #{help[:short]}\n#{help[:long]}"
    else
      helpstr << "Available commands:\n"
      ZergXcode::Plugins.all.each do |plugin|
        short_help = ZergXcode::Plugins.get(plugin).help[:short]
        helpstr << "  #{plugin}: #{short_help}\n"
      end
    end
    
    print helpstr
    helpstr
  end  
end  # class ZergXcode::Plugins::Help

end  # namespace ZergXcode::Plugins
