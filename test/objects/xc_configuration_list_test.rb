# Author:: Victor Costan
# Copyright:: Copyright (C) 2009 Zergling.Net
# License:: MIT

require 'zerg_xcode'
require 'test/unit'

class XCConfigurationListTest < Test::Unit::TestCase
  XCConfigurationList = ZergXcode::Objects::XCConfigurationList
  
  def test_xref_name
    proj = ZergXcode.load 'test/fixtures/project.pbxproj'
    list = proj['buildConfigurationList']
    assert_equal XCConfigurationList, list.class
    assert_equal 'XCConfigurationList', list.xref_name
  end
end
