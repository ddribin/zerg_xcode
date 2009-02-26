require 'test/unit'

require 'zerg_xcode'

class XCConfigurationListTest < Test::Unit::TestCase
  XCConfigurationList = ZergXcode::Objects::XCConfigurationList
  
  def test_instantiation
    proj = ZergXcode.load 'testdata/project.pbxproj'
    assert_equal XCConfigurationList, proj['buildConfigurationList'].class
  end
end
