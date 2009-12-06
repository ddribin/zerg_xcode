# Author:: Victor Costan
# Copyright:: Copyright (C) 2009 Zergling.Net
# License:: MIT

require 'zerg_xcode'
require 'test/unit'

class ArchiverTest < Test::Unit::TestCase
  Parser = ZergXcode::Parser
  Archiver = ZergXcode::Archiver
  XcodeObject = ZergXcode::XcodeObject
  
  def setup
    @sub1 = XcodeObject.new :array => ['a', 'b', 'c'], :string => 's'
    @sub1.archive_id = '39'
    @sub2 = XcodeObject.new :hash => { :k => 'v', :k2 => 'v2' }, :sub1 => @sub1
    @sub2.archive_id = '42'
    @root = XcodeObject.new :sub1 => @sub1, :sub2 => @sub2
    @root.archive_id = '49'
    @root.version = 45
    
    @archived = {
      "archiveVersion" => '1',
      "rootObject" => '49',
      "classes" => {},
      "objectVersion" => '45',
      "objects" => {
        "49" => { :sub1 => "39", :sub2 => "42" },
        "39" => { :array => ["a", "b", "c"], :string => "s" },
        "42" => { :hash => { :k => "v", :k2 => "v2" }, :sub1 => "39" }
      }
    }
    
    @pbxdata = File.read 'test/fixtures/project.pbxproj'     
  end
  
  def test_archive_to_hash    
    hash = Archiver.archive_to_hash @root
    assert_equal @archived, hash
  end
  
  def test_unarchive_hash
    root = Archiver.unarchive_hash @archived
    assert_equal @sub1[:s], root[:sub1][:s]
    assert_equal @sub1[:array], root[:sub1][:array]
    assert_equal @sub2[:hash], root[:sub2][:hash]
    assert_equal root[:sub1], root[:sub2][:sub1], 'Object graph split'
  end

  def test_generator
   generator = Archiver::IdGenerator.new
   assert_equal '49', generator.id_for(@root)
   assert_equal '42', generator.id_for(@sub2)
   new_id = generator.id_for @root
   assert '49' != new_id, 'Initial ID generated twice'
   newer_id = generator.id_for @root
   assert !['49', new_id].include?(newer_id), 'New ID generated twice'
 end
 
 def test_archive_passthrough
   golden_hash = Parser.parse @pbxdata
   project = Archiver.unarchive @pbxdata
   dupdata = Archiver.archive project
   
   assert_equal golden_hash, Parser.parse(dupdata) 
 end
 
 def test_unarchive
   project = Archiver.unarchive @pbxdata
   
   assert_equal 'TestApp.app',
                project['targets'][0]['productReference']['path']
 end
end
