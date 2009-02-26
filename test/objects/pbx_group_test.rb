require 'test/unit'

require 'zerg_xcode'

class PBXGroupTest < Test::Unit::TestCase
  PBXGroup = ZergXcode::Objects::PBXGroup
  
  def test_instantiation
    proj = ZergXcode.load 'testdata/project.pbxproj'
    assert_equal PBXGroup, proj['mainGroup'].class
  end
end
