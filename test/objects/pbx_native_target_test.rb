require 'test/unit'

require 'zerg_xcode'

class PBXNativeTargetTest < Test::Unit::TestCase
  PBXNativeTarget = ZergXcode::Objects::PBXNativeTarget
  
  def test_all_files
    golden_list = [
      ["PBXResourcesBuildPhase", "MainWindow.xib"],
      ["PBXResourcesBuildPhase", "TestAppViewController.xib"],
      ["PBXSourcesBuildPhase", "main.m"],
      ["PBXSourcesBuildPhase", "TestAppAppDelegate.m"],
      ["PBXSourcesBuildPhase", "TestAppViewController.m"],
      ["PBXFrameworksBuildPhase",
       "System/Library/Frameworks/Foundation.framework"],
      ["PBXFrameworksBuildPhase",
       "System/Library/Frameworks/UIKit.framework"],
      ["PBXFrameworksBuildPhase",
       "System/Library/Frameworks/CoreGraphics.framework"],    
    ]
    
    project = ZergXcode.load('testdata/project.pbxproj')
    assert_equal PBXNativeTarget, project['targets'].first.class
    files = project['targets'].first.all_files
    file_list = files.map do |file|
      [file[:phase]['isa'], file[:object]['path']]
    end
    assert_equal golden_list.sort, file_list.sort
  end
end