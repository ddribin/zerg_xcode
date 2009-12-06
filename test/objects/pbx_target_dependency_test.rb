# Author:: Victor Costan
# Copyright:: Copyright (C) 2009 Zergling.Net
# License:: MIT

require 'zerg_xcode'
require 'test/unit'

class PBXTargetDependencyTest < Test::Unit::TestCase
  PBXTargetDependency = ZergXcode::Objects::PBXTargetDependency
  
  def setup
    @project = ZergXcode.load(
        'test/fixtures/ZergSupport.xcodeproj/project.pbxproj')
    @dependency = @project['targets'][2]['dependencies'].first
    @target = @project['targets'][1]
  end
  
  def test_target
    assert_equal PBXTargetDependency, @dependency.class
    assert_equal @target, @dependency.target
  end
  
  def test_xref_name
    assert_equal 'ZergTestSupport', @dependency.xref_name
  end
  
  def test_for
    new_dependency = PBXTargetDependency.for @target, @project
    assert_equal @dependency._attr_hash.reject { |k, v| k == 'targetProxy' },
                 new_dependency._attr_hash.reject { |k, v| k == 'targetProxy' }
    assert_equal @dependency['targetProxy']._attr_hash,
                 new_dependency['targetProxy']._attr_hash
  end
end
