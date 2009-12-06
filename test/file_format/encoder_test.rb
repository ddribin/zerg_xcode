# Author:: Victor Costan
# Copyright:: Copyright (C) 2009 Zergling.Net
# License:: MIT

require 'zerg_xcode'
require 'test/unit'

class EncoderTest < Test::Unit::TestCase
  def test_encoder
    pbxdata = File.read 'test/fixtures/project.pbxproj'
    golden_encoded_proj = File.read 'test/fixtures/project.pbxproj.compat'
    proj = ZergXcode::Parser.parse pbxdata
    assert_equal golden_encoded_proj, ZergXcode::Encoder.encode(proj)
  end  
end
