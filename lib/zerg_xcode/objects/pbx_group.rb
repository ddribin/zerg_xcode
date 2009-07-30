# A group of files.
class ZergXcode::Objects::PBXGroup < ZergXcode::XcodeObject
  
  def find_group_named group_name
    self["children"].each do |child|
      if child.isa == :PBXGroup
        if child.xref_name == group_name
          return child
        elsif grandchild = child.find_group_named(group_name)
          return grandchild
        end
      end
    end
    return nil
  end
  
  def children
    self["children"]
  end
  
  def create_group path_name, group_name=nil, source_tree='<group>'
    group_name = group_name || path_name
    unless group = find_group_named(group_name)
      group = ZergXcode::Objects::PBXGroup.new("name" => group_name, 
                                               "path" => path_name, 
                                               "children" => [], 
                                               "sourceTree" => source_tree)
      self.children << group
    end
    group
  end
  
end
