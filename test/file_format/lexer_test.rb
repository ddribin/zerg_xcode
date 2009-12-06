# Author:: Victor Costan
# Copyright:: Copyright (C) 2009 Zergling.Net
# License:: MIT

require 'zerg_xcode'
require 'test/unit'

class LexerTest < Test::Unit::TestCase
  def test_lexer
    pbxdata = File.read 'test/fixtures/project.pbxproj'
    golden_starts = [[:encoding, "UTF8"],
                     :begin_hash,
                       [:symbol, "archiveVersion"], :assign, [:symbol, "1"],
                       :stop,
                       [:symbol, "classes"], :assign, :begin_hash, :end_hash,
                       :stop,
                       [:symbol, "objectVersion"], :assign, [:symbol, "45"],
                       :stop,
                       [:symbol, "objects"], :assign, :begin_hash,
                         [:symbol, "1D3623260D0F684500981E51"], :assign,
                         :begin_hash,
                           [:symbol, "isa"], :assign, [:symbol, "PBXBuildFile"],
                           :stop,
                           [:symbol, "fileRef"], :assign,
                             [:symbol, "1D3623250D0F684500981E51"],
                           :stop,
                         :end_hash,
                         :stop,
                         [:symbol, "1D60589B0D05DD56006BFB54"], :assign,
                         :begin_hash,
                           [:symbol, "isa"], :assign, [:symbol, "PBXBuildFile"],
                           :stop,
                           [:symbol, "fileRef"], :assign,
                             [:symbol, "29B97316FDCFA39411CA2CEA"],
                           :stop,
                         :end_hash,
                         :stop,
                         [:symbol, "1D60589F0D05DD5A006BFB54"], :assign,
                         :begin_hash,
                           [:symbol, "isa"], :assign, [:symbol, "PBXBuildFile"],
                           :stop,
                           [:symbol, "fileRef"], :assign,
                             [:symbol, "1D30AB110D05D00D00671497"],
                           :stop,
                         :end_hash,
                         :stop]
    
    tokens = ZergXcode::Lexer.tokenize pbxdata
    assert_equal golden_starts, tokens[0, golden_starts.length]
    #p tokens.length
    #p tokens[197, 50]
  end
  
  def test_escaped_string
    pbxdata = File.read 'test/fixtures/ZergSupport.xcodeproj/project.pbxproj'
    tokens = ZergXcode::Lexer.tokenize pbxdata
    assert tokens.include?([:string,
                            "\"$(SRCROOT)/build/Debug-iphonesimulator\""])
  end
end
