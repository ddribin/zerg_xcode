require 'test/unit'

require 'zerg_xcode'

class PBXTargetDependencyTest < Test::Unit::TestCase
  PBXTargetDependency = ZergXcode::Objects::PBXTargetDependency
  
  def test_target
    proj = ZergXcode.load 'testdata/ZergSupport.xcodeproj/project.pbxproj'    
    dependency = proj['targets'][2]['dependencies'].first
    assert_equal PBXTargetDependency, dependency.class
    assert_equal proj['targets'][1], dependency.target
  end
end
