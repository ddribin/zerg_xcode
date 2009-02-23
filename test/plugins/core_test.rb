require 'stringio'
require 'test/unit'
require 'test/plugins/test_helper.rb'

require 'zerg_xcode'

class Plugins::CoreTest < Test::Unit::TestCase  
  include Plugins::TestHelper

  def test_all
    assert ZergXcode::Plugins.all.include?('ls'), 'Incomplete list'
  end
  
  def test_get
    ls_instance = ZergXcode::Plugins.get 'ls'
    ls_class = ZergXcode::Plugins::Ls
    assert ls_instance.kind_of?(ls_class), 'Get retrieves wrong object'
  end
    
  def test_help
    help = ZergXcode::Plugins.help 'ls'
    assert help[:short], 'Help object does not contain short description'
    assert help[:long], 'Help object does not contain long description'
  end
  
  def test_run
    help_output = capture_output { ZergXcode::Plugins.run('help', []) }
    
    assert help_output.index('Xcode Project Modifier brought to you by '),
           'The result of running help does not match the expected result'
  end
end
