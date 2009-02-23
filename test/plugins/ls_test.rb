require 'stringio'
require 'test/unit'
require 'test/plugins/test_helper.rb'

require 'zerg_xcode'

module Plugins; end
  
class Plugins::LsTest < Test::Unit::TestCase
  include Plugins::TestHelper
  
  def setup
    @plugin = ZergXcode.plugin 'ls'
  end
  
  def test_list
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
      ["BUILT_PRODUCTS_DIR/TestApp.app", nil]]
    file_list = @plugin.list_for 'testdata/project.pbxproj'
    assert_equal golden_list.sort, file_list.sort
  end  
  
  def test_run
    output = capture_output { @plugin.run(['testdata']) }
    assert_equal "sourcecode.c.h       ./Classes/TestAppAppDelegate.h",
                 output[/^(.*?)$/]
  end
end
