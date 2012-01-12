# A group of files (shown as a folder) in an Xcode project.
#
# Author:: Christopher Garrett
# Copyright:: Copyright (C) 2009 Zergling.Net
# License:: MIT

# :nodoc: namespace
module ZergXcode::Objects


# A group of files (shown as a folder) in an Xcode project.
class PBXGroup < ZergXcode::XcodeObject
  def find_group_named(group_name)
    self['children'].each do |child|
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
    self['children']
  end
  
  def mkdir name
    raise Errno::ENOTNAM if name =~ /\//
    raise Errno::EEXIST if exists? name
    group = ZergXcode::Objects::PBXGroup.new 'name' => name, 
                                             'path' => name, 
                                             'children' => [], 
                                             'sourceTree' => '<group>'
    self.children << group
    group
  end

  def mkdir_f name
    child_named(name) || mkdir(name)
  end

  def mkdir_p path
    path.split('/').inject(self) do |group, path_element|
      group.mkdir_f path_element
    end
  end

  def exists? path
    current_group = self
    path.split('/').each do |path_element|
      next_group = current_group.child_named path_element
      return false unless next_group
      current_group = next_group
    end
    true
  end

  def child_named name
    children.detect {|child| child.xref_name == name}
  end

  def to_s
    "PBXGroup<#{xref_name}>"
  end

end  # class ZergXcode::Objects::PBXGroup

end  # namespace ZergXcode::Objects
