# Author:: Victor Costan
# Copyright:: Copyright (C) 2009 Zergling.Net
# License:: MIT

require 'zerg_xcode'
require 'test/unit'

class PBXContainerItemProxyTest < Test::Unit::TestCase
  PBXContainerItemProxy = ZergXcode::Objects::PBXContainerItemProxy
  
  def setup
    @project = ZergXcode.load(
        'test/fixtures/ZergSupport.xcodeproj/project.pbxproj')
    @proxy = @project['targets'][2]['dependencies'].first['targetProxy']
    @target = @project['targets'][1] 
  end
  
  def test_target
    assert_equal PBXContainerItemProxy, @proxy.class
    assert_equal @target, @proxy.target
  end
  
  def test_xref_name
    assert_equal 'ZergTestSupport', @proxy.xref_name
  end
  
  def test_for
    new_proxy = PBXContainerItemProxy.for @target, @project
    assert_equal @proxy._attr_hash, new_proxy._attr_hash
  end
end
