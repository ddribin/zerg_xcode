require 'test/unit'

require 'zerg_xcode'

require 'rubygems'
require 'flexmock/test_unit'


class PBXProjectTest < Test::Unit::TestCase
  PBXProject = ZergXcode::Objects::PBXProject
  def test_all_files_small
    golden_list = [
      ["./Classes/TestAppAppDelegate.h", "sourcecode.c.h"],
      ["./Classes/TestAppAppDelegate.m", "sourcecode.c.objc"],
      ["./Classes/TestAppViewController.h", "sourcecode.c.h"],
      ["./Classes/TestAppViewController.m", "sourcecode.c.objc"],
      ["./TestApp_Prefix.pch", "sourcecode.c.h"],
      ["./main.m", "sourcecode.c.objc"],
      ["./TestAppViewController.xib", "file.xib"],
      ["./MainWindow.xib", "file.xib"],
      ["./Info.plist", "text.plist.xml"],
      ["SDKROOT/System/Library/Frameworks/UIKit.framework",
       "wrapper.framework"],
      ["SDKROOT/System/Library/Frameworks/Foundation.framework",
       "wrapper.framework"],
      ["SDKROOT/System/Library/Frameworks/CoreGraphics.framework",
       "wrapper.framework"],
      ["BUILT_PRODUCTS_DIR/TestApp.app", nil],
    ]
    
    project = ZergXcode.load('testdata/project.pbxproj')
    assert_equal PBXProject, project.class 
    files = project.all_files
    file_list = files.map { |f| [f[:path], f[:object]['lastKnownFileType']] }
    assert_equal golden_list.sort, file_list.sort
  end
  
  def test_all_files_large
    golden_entries = [
      ["./ZergSupport/FormatSupport/ZNFormFieldFormatter+Snake2LCamel.m",
       "sourcecode.c.objc"],
      ["./ZergSupport/ModelSupport/ZNModelDefinitionAttributeTest.m",
       "sourcecode.c.objc"],
      ["./ZergSupport/TestSupport/TestSupport.h", "sourcecode.c.h"],
      ["./ZergSupport/TestSupport/GTM/GTMDefines.h", "sourcecode.c.h"],
      ["./ZergSupport/WebSupport/ZNHttpRequest.m", "sourcecode.c.objc"],
    ]
    files = ZergXcode.load('testdata/ZergSupport').all_files
    file_list = files.map { |f| [f[:path], f[:object]['lastKnownFileType']] }
    golden_entries.each do |entry|
      assert file_list.include?(entry), "Missing #{entry.inspect}"
    end
  end
  
  def test_save
    project = ZergXcode.load('testdata') 
    flexmock(ZergXcode).should_receive(:dump).
                        with(project, 'testdata/project.pbxproj').
                        and_return(nil)
    project.save!
  end
  
  def test_root_path
    project = ZergXcode.load('testdata/ZergSupport.xcodeproj') 
    assert_equal 'testdata', project.root_path
  end
  
  def test_copy_metadata
    project = ZergXcode.load('testdata/ZergSupport.xcodeproj')
    clone = ZergXcode::XcodeObject.from project
    
    assert_equal project.source_filename, clone.source_filename
  end
  
  def test_xref_name
    project = ZergXcode.load('testdata/project.pbxproj')
    assert_equal 'PBXProject', project.xref_name
  end
end
