require 'test/unit'

require 'zerg_xcode'

class XCConfigurationListTest < Test::Unit::TestCase
  XCConfigurationList = ZergXcode::Objects::XCConfigurationList
  
  def test_xref_name
    proj = ZergXcode.load 'testdata/project.pbxproj'
    list = proj['buildConfigurationList']
    assert_equal XCConfigurationList, list.class
    assert_equal 'XCConfigurationList', list.xref_name
  end
end
