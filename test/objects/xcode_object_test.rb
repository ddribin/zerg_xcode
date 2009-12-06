# Author:: Victor Costan
# Copyright:: Copyright (C) 2009 Zergling.Net
# License:: MIT

require 'zerg_xcode'
require 'set'
require 'test/unit'

class ObjectTest < Test::Unit::TestCase
  XcodeObject = ZergXcode::XcodeObject
  PBXProject = ZergXcode::Objects::PBXProject
  
  def setup
    @sub1 = XcodeObject.new :array => ['a', 'b', 'c'], :string => 's'
    @sub1.archive_id = 39   
    @sub2 = XcodeObject.new :hash => { :k => 'v', :k2 => 'v2' }, :sub1 => @sub1
    @sub2.archive_id = 42
    @root = XcodeObject.new :sub1 => @sub1, :sub2 => @sub2
    @root.archive_id = 49
    @root.version = 45
  end
  
  def test_readonly_visit    
    golden_visited = [
      [49, 'sub1', @sub1],
      [39, 'array', @sub1[:array]],
      [39, '0', 'a'],
      [39, '1', 'b'],
      [39, '2', 'c'],
      [39, 'string', 's'],
      [49, 'sub2', @sub2],
      [42, 'hash', @sub2[:hash]],
      [42, 'k', 'v'],
      [42, 'k2', 'v2'],
      [42, 'sub1', @sub1],
    ]

    visited = []
    visited_objects = Set.new
    @root.visit do |object, parent, key, value|
      assert_equal value, parent[key], 'Parent/Key/Value check'
      
      visited << [object.archive_id, key.to_s, value]
      next true unless value.kind_of? XcodeObject
      next false if visited_objects.include? value
      visited_objects << value
      next true
    end
    assert_equal golden_visited.sort, visited.sort
  end
  
  def test_visit_once
    golden_visited = [
      [49, 'sub1', @sub1],      
      [39, 'array', @sub1[:array]],
      [39, '0', 'a'],
      [39, '1', 'b'],
      [39, '2', 'c'],
      [39, 'string', 's'],
      [39, 'root', @root],
      [49, 'sub2', @sub2],
      [42, 'hash', @sub2[:hash]],
      [42, 'k', 'v'],
      [42, 'k2', 'v2'],
      [42, 'sub1', @sub1],
    ]
    @sub1['root'] = @root
    
    visited = []
    @root.visit_once do |object, parent, key, value|
      assert_equal value, parent[key], 'Parent/Key/Value check'
      visited << [object.archive_id, key.to_s, value]
      next true
    end
    assert_equal golden_visited.sort, visited.sort
  end
  
  def test_mutating_visit
    golden_visited = [
      [49, 'sub1', @sub1],
      [39, 'array', @sub1[:array]],
      [39, '0', 'a'],
      [39, '1', 'b'],
      [39, '2', 'c'],
      [39, '3', 'a'],
      [39, '4', 'b'],
      [39, '5', 'c'],
      [39, 'string', 's'],
      [49, 'sub2', @sub2],
      [42, 'hash', @sub2[:hash]],
      [42, 'k', 'v'],
      [42, 'k2', 'v2'],
      [42, 'sub1', @sub1],
    ]

    visited = []
    visited_objects = Set.new
    @root.visit do |object, parent, key, value|
      assert_equal value, parent[key], 'Parent/Key/Value check'
    
      visited << [object.archive_id, key.to_s, value]
      case value
      when XcodeObject
        next false if visited_objects.include? value
        visited_objects << value
        next true
      when Array, String
        next value * 2
      when Hash
        next true
      end
    end
    
    assert_equal golden_visited.sort, visited.sort
    assert_equal @sub1[:array], ['aa', 'bb', 'cc', 'aa', 'bb', 'cc']
    assert_equal @sub1[:string], 'ss'
  end
  
  def test_xref_name_and_key
    @obj1 = XcodeObject.from 'isa' => 'Alien', 'name' => 'Name',
                             'path' => 'Path'
    @obj2 = XcodeObject.from 'isa' => 'Alien', 'name' => 'Name',
                             'path' => 'Path', 'explicitPath' => 'XPath'
    @obj3 = XcodeObject.from 'isa' => 'Alien', 'path' => 'Path'
    @obj4 = XcodeObject.from 'isa' => 'Alien',
                             'path' => 'Path', 'explicitPath' => 'XPath'
                             
    assert_equal 'Name', @obj1.xref_name
    assert_equal 'Name', @obj2.xref_name
    assert_equal 'Path', @obj3.xref_name
    assert_equal 'XPath', @obj4.xref_name
    
    assert_equal [:Alien, 'Name'], @obj1.xref_key
  end
  
  def test_deep_copy
    root = XcodeObject.from @root
    assert_equal root[:sub2][:sub1], root[:sub1], 'Deep copy tracks objects'

    root[:sub1] = 'break'
    assert @root[:sub1] != 'break', 'Deep copy duplicates object attributes'
    root[:sub2][:hash][:k] = 'break'
    assert @root[:sub2][:hash] != 'break', 'Deep copy duplicates hashes'
    root[:sub2][:sub1][:array][0] = 'break'
    assert @root[:sub2][:sub1][:array][0] != 'break',
           'Deep copy duplicates hashes'    
  end
  
  def test_messed_up_inheritance
    assert_equal XcodeObject, @root.class
    
    p = XcodeObject.new 'isa' => 'PBXProject', 'name' => 'awesome'
    assert_equal PBXProject, p.class
    
    root = XcodeObject.from @root
    assert_equal XcodeObject, root.class, 'After deep copy'
    assert_equal PBXProject, XcodeObject.from(p).class, 'After deep copy'
    
    p = PBXProject.new 'name' => 'boo'
    assert_equal 'PBXProject', p['isa'], 'Subclass creation does not set isa.'
    assert_equal 'boo', p['name'], 'Subclass creation corrupts attributes'
  end
end
