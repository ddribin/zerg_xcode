# Author:: Victor Costan
# Copyright:: Copyright (C) 2009 Zergling.Net
# License:: MIT

require 'zerg_xcode'
require 'test/unit'

class SdkTest < Test::Unit::TestCase
  def test_all
    all_sdks = ZergXcode::Builder::Sdk.all
    mac105 = { :group => 'Mac OS X SDKs', :name => 'Mac OS X 10.5',
               :arg => 'macosx10.5' }
    assert_operator all_sdks, :include?, mac105, 'MacOS 10.5 SDK included'

    assert_operator all_sdks, :equal?, all_sdks, 'SDKs are cached'
  end
end
