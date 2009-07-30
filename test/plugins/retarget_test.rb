require 'stringio'
require 'test/unit'
require 'test/plugins/helper.rb'

require 'zerg_xcode'

require 'rubygems'
require 'flexmock'

module Plugins; end
  
class Plugins::RetargetTest < Test::Unit::TestCase
  def setup
    super
    @plugin = ZergXcode.plugin 'retarget'
    @proj = ZergXcode.load 'testdata/TestApp/TestApp.xcodeproj'
    @regexp = /^Test.*\.[^a]/
    
    @golden_list_for_app = [
      ["PBXResourcesBuildPhase", "MainWindow.xib"],
      ["PBXSourcesBuildPhase", "main.m"],
      ["PBXFrameworksBuildPhase",
       "System/Library/Frameworks/Foundation.framework"],
      ["PBXFrameworksBuildPhase",
       "System/Library/Frameworks/UIKit.framework"],
      ["PBXFrameworksBuildPhase",
       "System/Library/Frameworks/CoreGraphics.framework"],    
    ]
    @golden_list_for_lib = [
      ["PBXHeadersBuildPhase", "TestAppAppDelegate.h"],
      ["PBXHeadersBuildPhase", "TestAppViewController.h"],
      ["PBXHeadersBuildPhase", "TestApp_Prefix.pch"],
      ["PBXSourcesBuildPhase", "TestAppAppDelegate.m"],
      ["PBXSourcesBuildPhase", "TestAppViewController.m"],
      ["PBXResourcesBuildPhase", "TestAppViewController.xib"],
    ]
  end
  
  def file_list_for(target)
    target.all_files.map { |file| [file[:phase]['isa'], file[:object]['path']] }
  end
  
  def test_remove_files    
    @plugin.retarget! @proj, @regexp, []
    app_file_list, lib_file_list = @proj['targets'].map { |t| file_list_for t }
    assert_equal @golden_list_for_app.sort, app_file_list.sort
    assert_equal [], lib_file_list
  end
  
  def test_add_files
    # first remove the files, so they'll be added out of thin air
    @plugin.retarget! @proj, @regexp, []
    @plugin.retarget! @proj, @regexp, ['TestLib']
    app_file_list, lib_file_list = @proj['targets'].map { |t| file_list_for t }
    assert_equal @golden_list_for_app.sort, app_file_list.sort
    assert_equal @golden_list_for_lib, lib_file_list
  end
  
  def test_move_files
    @plugin.retarget! @proj, @regexp, ['TestLib']
    app_file_list, lib_file_list = @proj['targets'].map { |t| file_list_for t }
    assert_equal @golden_list_for_app.sort, app_file_list.sort
    assert_equal @golden_list_for_lib, lib_file_list
  end
end
