# Author:: Christopher Garrett
# Copyright:: Copyright (C) 2009 Zergling.Net
# License:: MIT

require 'zerg_xcode'
require 'test/unit'

class PBXGroupTest < Test::Unit::TestCase
  PBXGroup = ZergXcode::Objects::PBXGroup
  
  def setup
    @proj = ZergXcode.load 'test/fixtures/project.pbxproj'
    @main_group = @proj['mainGroup']
  end
  
  def test_instantiation
    assert_equal PBXGroup, @main_group.class
  end
  
  def test_find_group_named
    found_group = @main_group.find_group_named 'Classes'
    assert_not_nil found_group
    assert_equal PBXGroup, found_group.class
    assert_equal 'Classes', found_group.xref_name
  end
  
  def test_create_group
    assert_nil @main_group.find_group_named('Foo'), 'Found inexistent group Foo'

    created_group = @main_group.create_group 'Foo'
    assert_not_nil created_group, 'Newly created group Foo'    
    assert_not_nil created_group.children,
                   "Newly created group's children attribute"
    
    new_group = @main_group.find_group_named 'Foo'
    assert_not_nil new_group, 'Did not find group Foo after creating it'
    
    # Should return the existing group if it is already there
    assert_operator created_group, :equal?, @main_group.create_group('Foo'),
                    "create_group should return an existing group if it's there"
    
    assert_equal "<group>", new_group["sourceTree"]    
  end  
end
