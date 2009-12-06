# Author:: Victor Costan
# Copyright:: Copyright (C) 2009 Zergling.Net
# License:: MIT

require 'zerg_xcode'
require 'test/unit'
require 'test/plugins/helper.rb'

require 'rubygems'
require 'flexmock/test_unit'
require 'irb'

module Plugins; end
  
class Plugins::IrbTest < Test::Unit::TestCase
  include Plugins::TestHelper
  
  def setup
    super
    @plugin = ZergXcode.plugin 'irb'
  end
  
  def test_irb_call
    test_project = ZergXcode.load 'test'
    
    flexmock(IRB).should_receive(:start).and_return(nil)
    output = Dir.chdir('test') do
      capture_output { @plugin.run([]) }
    end
    assert_equal test_project.attrs, $p.attrs, 'Loaded incorrect project'
    assert output.index("'quit'"), 'Missing instructions on how to leave IRB'
    assert_equal "\n", output[-1, 1], 'Instructions missing trailing newline'
    $p = nil
  end
end
