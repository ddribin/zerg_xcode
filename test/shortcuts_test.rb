# Author:: Victor Costan
# Copyright:: Copyright (C) 2009 Zergling.Net
# License:: MIT

require 'zerg_xcode'
require 'test/unit'

class ShortcutsTest < Test::Unit::TestCase
  def test_load
    proj = ZergXcode.load 'test/fixtures/ZergSupport'
    assert_equal ['ZergSupport', 'ZergTestSupport', 'ZergSupportTests'].sort,
                 proj['targets'].map { |target| target['name'] }.sort
    assert_equal 'test/fixtures/ZergSupport.xcodeproj/project.pbxproj',
                 proj.source_filename, 'Loading did not set project source'
  end
  
  def test_plugin
    ls_instance = ZergXcode.plugin 'ls'
    ls_class = ZergXcode::Plugins::Ls
    assert ls_instance.kind_of?(ls_class), 'plugin retrieves wrong object'    
  end
end
