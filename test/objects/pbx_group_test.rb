require 'test/unit'

require 'zerg_xcode'

class PBXGroupTest < Test::Unit::TestCase
  PBXGroup = ZergXcode::Objects::PBXGroup
  
  def setup
    @proj = ZergXcode.load 'testdata/project.pbxproj'
    @main_group = @proj['mainGroup']
  end
  
  def test_instantiation
    assert_equal PBXGroup, @main_group.class
  end
  
  def test_find_group_named
    found_group = @main_group.find_group_named("Classes")
    assert_not_nil found_group
    assert_equal PBXGroup, found_group.class
    assert_equal "Classes", found_group.xref_name
  end
  
  def test_create_group
    proj = ZergXcode.load 'testdata/project.pbxproj'
    parent = proj['mainGroup']

    # Shouldn't be there to start
    assert_nil parent.find_group_named "Foo"

    created_group = parent.create_group "Foo"

    assert_not_nil created_group
    
    assert_not_nil created_group.children
    
    new_group = parent.find_group_named "Foo"

    assert_not_nil new_group
    
    # Should return the existing group if it is already there
    assert created_group.equal?(parent.create_group("Foo")), "create_group should return an existing group if it's there"
    
    assert_equal "<group>", new_group["sourceTree"]
    
  end
  
end
