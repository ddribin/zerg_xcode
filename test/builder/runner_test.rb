# Author:: Victor Costan
# Copyright:: Copyright (C) 2009 Zergling.Net
# License:: MIT

require 'zerg_xcode'
require 'test/unit'

class RunnerTest < Test::Unit::TestCase
  def setup
    @project = ZergXcode.load 'test/fixtures/ClosedLib'
    @configuration = 'Release'
    @sdk = ZergXcode::Builder::Sdk.all.
        select { |s| /iPhone .* 3\.0$/ =~ s[:name] }.first
    @golden_build_path = 'test/fixtures/ClosedLib/build/Release-iphoneos'
    @product = @golden_build_path + '/libClosedLib.a'
  end
  
  def teardown
    ZergXcode::Builder::Runner.clean @project, @sdk, @configuration
  end
  
  def test_clean_build_clean
    assert ZergXcode::Builder::Runner.clean(@project, @sdk, @configuration),
           'Initial clean failed'

    build_path = ZergXcode::Builder::Runner.build @project, @sdk, @configuration
    assert build_path, 'Build failed'
    assert_equal @golden_build_path, build_path, 'Build returned incorrect path'
    assert File.exist?(@product), 'Build product not found'

    assert ZergXcode::Builder::Runner.clean(@project, @sdk, @configuration),
           'Post-build clean failed'
    assert !File.exist?(@product), 'Build product not removed by clean'
  end
end
