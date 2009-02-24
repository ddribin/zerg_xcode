require 'test/unit'
require 'test/plugins/test_helper.rb'

require 'zerg_xcode'

require 'rubygems'
require 'flexmock/test_unit'

module Plugins; end

class Plugins::ImportTest < Test::Unit::TestCase
  include Plugins::TestHelper
  
  def setup
    super
    @plugin = ZergXcode.plugin 'import'
  end
  
  def test_plugin
    flunk
  end
end
