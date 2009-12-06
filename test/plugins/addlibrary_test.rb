# Author:: Victor Costan
# Copyright:: Copyright (C) 2009 Zergling.Net
# License:: MIT

require 'zerg_xcode'
require 'test/unit'
require 'test/plugins/helper.rb'

module Plugins; end

class Plugins::AddlibraryTest < Test::Unit::TestCase
  include Plugins::TestHelper
  
  def setup
    super
    @plugin = ZergXcode.plugin 'addlibrary'
    @project = ZergXcode.load 'test/fixtures/ZergSupport'
    
    @lib, @test_lib, @test_app = *@project['targets']
  end
  
  def test_find_target
    assert_equal @test_lib, @plugin.find_target('ZergTestSupport', @project)
    assert_nil @plugin.find_target('Zergness', @project)
  end
  
  def test_has_target_dependency
    [[true, @test_lib, @lib], [false, @lib, @test_lib],
     [true, @test_app, @test_lib], [false, @test_lib, @test_app],
     [false, @test_app, @lib]
    ].each do |scenario|
      assert_equal scenario[0],
                   @plugin.has_target_dependency?(scenario[2], scenario[1]),
                   "Failed #{scenario[1]['name']} depends on " +
                   scenario[2]['name']
    end
  end
  
  def test_add_target_dependency
    @plugin.add_target_dependency! @test_lib, @lib, @project
    assert @plugin.has_target_dependency?(@test_lib, @lib),
           "Add failed"
    @plugin.add_target_dependency! @test_app, @lib, @project
    assert @plugin.has_target_dependency?(@test_app, @lib),
           "Add failed"
  end
  
  def test_has_target_in_build_phases
    [[true, @test_lib, @lib], [false, @lib, @test_lib],
     [true, @test_app, @test_lib], [false, @test_lib, @test_app],
     [false, @test_app, @lib]     
    ].each do |scenario|
      assert_equal scenario[0],
                   @plugin.has_target_in_build_phases?(scenario[2],
                                                       scenario[1]),
                   "Failed #{scenario[1]['name']} has " +
                   scenario[2]['name'] + " in build phases"
    end    
  end
  
  def test_add_target_to_build_phases
    @plugin.add_target_to_build_phases! @test_lib, @lib
    assert @plugin.has_target_in_build_phases?(@test_lib, @lib),
           "Add failed"
    @plugin.add_target_to_build_phases! @test_app, @lib
    assert @plugin.has_target_in_build_phases?(@test_app, @lib),
           "Add failed"    
  end
  
  def test_has_objc_files
    assert_equal true, @plugin.has_objc_files?(@lib),
                 "ZergSupport has ObjC files"
                 
    ZergXcode.plugin('retarget').retarget! @project, /\.m$/, []
    assert_equal false, @plugin.has_objc_files?(@lib),
                 "ZergSupport doesn't have ObjC files after retargeting"
  end
  
  def test_has_linker_option
    assert_equal false, @plugin.has_linker_option?('-ObjC', @lib)
    assert_equal true, @plugin.has_linker_option?('-ObjC', @test_app)
  end
  
  def test_add_linker_option
    @plugin.add_linker_option! '-ObjC', @lib
    assert_equal true, @plugin.has_linker_option?('-ObjC', @lib)
  end
  
  def test_add_library
    @plugin.add_library! @test_app, @lib, @project
    
    assert @plugin.has_target_dependency?(@test_app, @lib),
           "Not on dependency list"
    assert @plugin.has_target_in_build_phases?(@test_app, @lib),
           "Not in build phases"    
    assert_equal true, @plugin.has_linker_option?('-ObjC', @lib),
                 "Linker option unset"    
  end
end
