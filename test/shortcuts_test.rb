require 'test/unit'
require 'zerg_xcode'

class ShortcutsTest < Test::Unit::TestCase
  def test_load
    proj = ZergXcode.load 'testdata/ZergSupport'
    assert_equal ['ZergSupport', 'ZergTestSupport', 'ZergSupportTests'].sort,
                 proj['targets'].map { |target| target['name'] }.sort
    assert_equal 'testdata/ZergSupport.xcodeproj/project.pbxproj',
                 proj.source_filename, 'Loading did not set project source'
  end
  
  def test_plugin
    ls_instance = ZergXcode.plugin 'ls'
    ls_class = ZergXcode::Plugins::Ls
    assert ls_instance.kind_of?(ls_class), 'plugin retrieves wrong object'    
  end
end
