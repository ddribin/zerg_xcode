require 'test/unit'

class EncoderTest < Test::Unit::TestCase
  def test_encoder
    pbxdata = File.read 'testdata/project.pbxproj'
    golden_encoded_proj = File.read 'testdata/project.pbxproj.compat'
    proj = ZergXcode::Parser.parse pbxdata
    assert_equal golden_encoded_proj, ZergXcode::Encoder.encode(proj)
  end  
end
