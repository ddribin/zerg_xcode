require 'test/unit'

require 'zerg_xcode'

class PBXBuildFileTest < Test::Unit::TestCase
  PBXBuildFile = ZergXcode::Objects::PBXBuildFile
  
  def setup
    @target = ZergXcode.load('testdata/project.pbxproj')['targets'].first
  end
  
  def test_attributes
    sources_phase = @target['buildPhases'][1]
    build_file = sources_phase['files'].first
    assert_equal PBXBuildFile, build_file.class
    assert_equal 'main.m', build_file.filename
    assert_equal 'sourcecode.c.objc', build_file.file_type
    
    big_project = ZergXcode.load('testdata/ZergSupport')
    big_project['targets'].map { |t| t.all_files }.flatten.each do |file|
      assert_not_nil file[:build_object].file_type,
                     "No file type for #{file[:build_object].inspect}"
    end
  end
  
  def test_guessed_build_phase_type
    big_project = ZergXcode.load('testdata/ZergSupport')
        
    phases = @target['buildPhases'] +
        big_project['targets'].map { |t| t['buildPhases'] }.flatten
    phases.each do |phase|
      phase['files'].each do |file|
        assert_equal phase['isa'], file.guessed_build_phase_type,
                     "Wrong phase for #{file.inspect}"
      end
    end
  end
  
  def test_xref_name
    sources_phase = @target['buildPhases'][1]
    build_file = sources_phase['files'].first
    assert_equal 'main.m', build_file.xref_name
  end
end
