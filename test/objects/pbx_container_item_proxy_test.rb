require 'test/unit'

require 'zerg_xcode'

class PBXContainerItemProxyTest < Test::Unit::TestCase
  PBXContainerItemProxy = ZergXcode::Objects::PBXContainerItemProxy
  
  def test_target
    proj = ZergXcode.load 'testdata/ZergSupport.xcodeproj/project.pbxproj'    
    proxy = proj['targets'][2]['dependencies'].first['targetProxy']
    assert_equal PBXContainerItemProxy, proxy.class
    assert_equal proj['targets'][1], proxy.target
  end
end
