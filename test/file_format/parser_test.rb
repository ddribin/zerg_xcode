# Author:: Victor Costan
# Copyright:: Copyright (C) 2009 Zergling.Net
# License:: MIT

require 'zerg_xcode'
require 'test/unit'

class ParserTest < Test::Unit::TestCase
  def test_parser
    pbxdata = File.read 'test/fixtures/project.pbxproj'
    proj = ZergXcode::Parser.parse pbxdata
    
    assert proj.kind_of?(Hash), 'Project structure should be a hash'
    assert_equal '1', proj['archiveVersion'], 'Archive version'
    assert_equal '45', proj['objectVersion'], 'Object version'
    assert_equal '29B97313FDCFA39411CA2CEA', proj['rootObject'], 'Root object'
    
    golden_file_ref = {
      'isa' => 'PBXBuildFile',
      'fileRef' => '28AD733E0D9D9553002E5188'
    }
    assert_equal golden_file_ref, proj['objects']['28AD733F0D9D9553002E5188']
    
    golden_file = {
      'isa' => 'PBXFileReference',
      'fileEncoding' => '4',
      'lastKnownFileType' => 'sourcecode.c.h',
      'path' => 'TestAppViewController.h',
      'sourceTree' => "<group>"
    }
    assert_equal golden_file, proj['objects']['28D7ACF60DDB3853001CB0EB']
    
    golden_config = {
      'isa' => 'XCBuildConfiguration',
      'buildSettings' => {
        'ARCHS' => "$(ARCHS_STANDARD_32_BIT)",
        "CODE_SIGN_IDENTITY[sdk=iphoneos*]" => "iPhone Developer",
        'GCC_C_LANGUAGE_STANDARD' => 'c99',
        'GCC_WARN_ABOUT_RETURN_TYPE' => 'YES',
        'GCC_WARN_UNUSED_VARIABLE' => 'YES',
        'ONLY_ACTIVE_ARCH' => 'YES',
        'PREBINDING' => 'NO',
        'SDKROOT' => 'iphoneos2.2.1'
      },
      'name' => 'Debug'
    }
    assert_equal golden_config, proj['objects']['C01FCF4F08A954540054247B']
  end
end
