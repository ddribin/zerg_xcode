# Author:: Victor Costan
# Copyright:: Copyright (C) 2009 Zergling.Net
# License:: MIT

require 'zerg_xcode'
require 'test/unit'

class PBXGroupTest < Test::Unit::TestCase
  PBXGroup = ZergXcode::Objects::PBXGroup
  
  def test_instantiation
    proj = ZergXcode.load 'test/fixtures/project.pbxproj'
    assert_equal PBXGroup, proj['mainGroup'].class
  end
end
