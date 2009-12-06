# Plugin management logic.
#
# Author:: Victor Costan
# Copyright:: Copyright (C) 2009 Zergling.Net
# License:: MIT

require 'set'

# :nodoc: namespace
module ZergXcode
  

# Plugin management logic.
module Plugins
  def self.all
    plugin_dir = File.join(File.dirname(__FILE__), '..')
    plugins = Dir.entries(plugin_dir).select { |entry|
      /^[^_].*\.rb$/ =~ entry 
    }.map { |entry| entry[0..-4] }
    return Set.new(plugins)
  end 
  
  def self.require_all
    all.each { |plugin| self.require plugin }
  end
  
  def self.require(plugin_name)
    Kernel.require "zerg_xcode/plugins/#{plugin_name}.rb"
  end
  
  def self.get(plugin_name)
    self.require plugin_name
    Plugins.const_get(plugin_name.capitalize).new
  end
  
  def self.run(plugin_name, args)
    self.get(plugin_name).run args
  end
  
  def self.help(plugin_name)
    self.get(plugin_name).help
  end
end  # module ZergXcode::Plugins

end  # namespace ZergXcode
