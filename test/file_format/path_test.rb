# Author:: Victor Costan
# Copyright:: Copyright (C) 2009 Zergling.Net
# License:: MIT

require 'zerg_xcode'
require 'test/unit'

class PathTest < Test::Unit::TestCase
  Paths = ZergXcode::Paths
  
  def test_project_file_at
    assert_equal 'test/fixtures/ZergSupport.xcodeproj/project.pbxproj',
                 Paths.project_file_at('test/fixtures/ZergSupport'), 'short'
    assert_equal 'test/fixtures/ZergSupport.xcodeproj/project.pbxproj',
                 Paths.project_file_at('test/fixtures/ZergSupport.xcodeproj'),
                 'full project name'
    assert_equal 'test/fixtures/project.pbxproj',
                 Paths.project_file_at('test/fixtures'),
                 'enclosing dir with weird name'
    assert_equal 'test/fixtures/project.pbxproj',
                 Paths.project_file_at('test'),
                 'subdir with weird name'
    assert_equal 'test/fixtures/TestApp/TestApp.xcodeproj/project.pbxproj',
                 Paths.project_file_at('test/fixtures/TestApp'),
                 'project in subdir'
    assert_equal 'test/fixtures/TestApp/TestApp.xcodeproj/project.pbxproj',
        Paths.project_file_at('test/fixtures/TestApp/TestApp.xcodeproj'),
        'full project name in subdir'
  end
  
  def test_project_root_at
    assert_equal 'test/fixtures',
                 Paths.project_root_at('test/fixtures/ZergSupport'),
                 'short project name'
    assert_equal 'test/fixtures',
                 Paths.project_root_at('test/fixtures/ZergSupport.xcodeproj'),
                 'full project name'
    assert_equal 'test', Paths.project_root_at('test/fixtures'),
                 'enclosing dir with weird name'
    assert_equal 'test', Paths.project_root_at('test'), 'subdir with weird name'    
    assert_equal 'test/fixtures/TestApp',
                 Paths.project_root_at('test/fixtures/TestApp'), 'project dir'
    assert_equal 'test/fixtures/TestApp',
        Paths.project_root_at('test/fixtures/TestApp/TestApp.xcodeproj'),
        'full project name in subdir'
  end
end
