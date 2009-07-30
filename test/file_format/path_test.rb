require 'test/unit'
require 'zerg_xcode'

class PathTest < Test::Unit::TestCase
  Paths = ZergXcode::Paths
  
  def test_project_file_at
    assert_equal 'testdata/ZergSupport.xcodeproj/project.pbxproj',
                 Paths.project_file_at('testdata/ZergSupport'), 'short'
    assert_equal 'testdata/ZergSupport.xcodeproj/project.pbxproj',
                 Paths.project_file_at('testdata/ZergSupport.xcodeproj'),
                 'full project name'
    assert_equal 'testdata/project.pbxproj',
                 Paths.project_file_at('testdata'),
                 'enclosing dir with weird name'
    assert_equal './testdata/project.pbxproj',
                 Paths.project_file_at('.'),
                 'subdir with weird name'
    assert_equal 'testdata/TestApp/TestApp.xcodeproj/project.pbxproj',
                 Paths.project_file_at('testdata/TestApp'), 'project in subdir'
    assert_equal 'testdata/TestApp/TestApp.xcodeproj/project.pbxproj',
                 Paths.project_file_at('testdata/TestApp/TestApp.xcodeproj'),
                 'full project name in subdir'
  end
  
  def test_project_root_at
    assert_equal 'testdata', Paths.project_root_at('testdata/ZergSupport'),
                 'short project name'
    assert_equal 'testdata',
                 Paths.project_root_at('testdata/ZergSupport.xcodeproj'),
                 'full project name'
    assert_equal '.', Paths.project_root_at('testdata'),
                 'enclosing dir with weird name'
    assert_equal '.', Paths.project_root_at('.'), 'subdir with weird name'    
    assert_equal 'testdata/TestApp',
                 Paths.project_root_at('testdata/TestApp'), 'project dir'
    assert_equal 'testdata/TestApp',
                 Paths.project_root_at('testdata/TestApp/TestApp.xcodeproj'),
                 'full project name in subdir'
  end
end
