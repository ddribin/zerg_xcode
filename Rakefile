# Rakefile for the zerg_xcode gem.
#
# Author:: Victor Costan
# Copyright:: Copyright (C) 2009 Zergling.Net
# License:: MIT

require 'rubygems'
require 'echoe'

Echoe.new('zerg_xcode') do |p|
  p.project = 'zerglings' # rubyforge project
  
  p.author = 'Victor Costan'
  p.email = 'victor@zergling.net'
  p.summary = 'Automated modifications for Xcode project files'
  p.url = 'http://www.zergling.net/'
  p.runtime_dependencies = []
  p.dependencies = []
  # remove echoe, because it becomes a runtime dependency for rubygems < 1.2
  p.development_dependencies = []
  p.eval = proc do |p|
    p.default_executable = 'bin/zerg-xcode'
  end
  
  p.need_tar_gz = true
  p.need_zip = true
  p.rdoc_pattern = /^(lib|bin|tasks|ext)|^BUILD|^README|^CHANGELOG|^LICENSE$/  
end

if $0 == __FILE__
  Rake.application = Rake::Application.new
  Rake.application.run
end
