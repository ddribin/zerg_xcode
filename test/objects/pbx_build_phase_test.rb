# Author:: Victor Costan
# Copyright:: Copyright (C) 2009 Zergling.Net
# License:: MIT

require 'zerg_xcode'
require 'test/unit'

class PBXBuildPhaseTest < Test::Unit::TestCase
  PBXBuildPhase = ZergXcode::Objects::PBXBuildPhase
  
  def setup
    @target = ZergXcode.load('test/fixtures/project.pbxproj')['targets'].first
    @sources_phase = @target['buildPhases'][1]
  end
  
  def test_new_phase
    gold_attrs = @sources_phase._attr_hash.reject { |k, v|
      ['files', 'dependencies'].include? k
    }.merge 'files' => [], 'dependencies' => []
    new_phase = PBXBuildPhase.new_phase('PBXSourcesBuildPhase')
    assert_equal gold_attrs, new_phase._attr_hash
  end
end
