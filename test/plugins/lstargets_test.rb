require 'stringio'
require 'test/unit'
require 'test/plugins/helper.rb'

require 'zerg_xcode'

module Plugins; end
  
class Plugins::LstargetsTest < Test::Unit::TestCase
  include Plugins::TestHelper
  
  def setup
    @plugin = ZergXcode.plugin 'lstargets'
  end
  
  def test_list
    golden_list = [
      ["ZergSupport", "ZergSupport", "com.apple.product-type.library.static"],
      ["ZergTestSupport", "ZergTestSupport",
       "com.apple.product-type.library.static"],
      ["ZergSupportTests", "ZergSupportTests",
       "com.apple.product-type.application"],
    ]
    file_list = @plugin.list_for 'testdata/ZergSupport'
    assert_equal golden_list.sort, file_list.sort
  end  
  
  def test_run
    output = capture_output { @plugin.run(['testdata/ZergSupport']) }
    assert_equal "library.static       ZergSupport > ZergSupport",
                 output[/^(.*?)$/]
  end
end
