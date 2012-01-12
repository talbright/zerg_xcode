# A group of files (shown as a folder) in an Xcode project.
#
# Author:: Christopher Garrett
# Copyright:: Copyright (C) 2009 Zergling.Net
# License:: MIT

# :nodoc: namespace
module ZergXcode::Objects


# A group of files (shown as a folder) in an Xcode project.
class PBXGroup < ZergXcode::XcodeObject

  # An array of all immediate children of this node
  attr_reader :children
  def children
    self['children']
  end

  # call-seq:
  #  mkdir(name) ⇒ aGroup
  #
  # Creates a child group with name _name_.  Raises Errno::EEXIST if a child
  # with that name already exists.
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

  # call-seq:
  #  mkdir_f(name) ⇒ aGroup
  #
  # If a child with name _name_ already exists, that child is returned;
  # otherwise, a new child group is created and returned.
  def mkdir_f name
    child_with_name(name) || mkdir(name)
  end

  # call-seq:
  #  mkdir_p(path) ⇒ aGroup
  #
  # If a child with path _path_ exists, that child is returned; otherwise,
  # groups are created to make the path exist and the deepest group is
  # returned.
  def mkdir_p path
    path_elements(path).inject(self) do |group, path_element|
      group.mkdir_f path_element
    end
  end

  # call-seq:
  #  child_with_path(path) ⇒ aChild
  #
  # If a child exists at the specified path (which may contain slashes), that
  # child is returned.  Otherwise, nil is returned.
  def child_with_path path
    path_elements(path).inject(self) do |group, path_element|
      group.child_with_name(path_element) if group
    end
  end
  alias_method :exist?, :child_with_path
  alias_method :exists?, :child_with_path

  # call-seq:
  #  child_with_name(path) ⇒ aChild
  #
  # If this group has an _immediate_ child with the specified name, it is
  # returned; otherwise, nil is returned.
  def child_with_name name
    children.detect {|child| child.xref_name == name}
  end

  # call-seq:
  #  add_file_reference(path) ⇒ aFileReference
  #
  # Creates a file reference in the group tree at _path_ and returns the
  # created reference.
  def add_file_reference path
    group = mkdir_p(File.dirname(path))
    file_reference = ZergXcode::XcodeObject.new 'isa' => :PBXFileReference,
                                                'path' => File.basename(path),
                                                'fileEncoding' => 4,
                                                'sourceTree' => '<group>'
    group.children << file_reference
    file_reference
  end

  # :nodoc:
  def to_s
    "PBXGroup<#{xref_name}>"
  end

private
  def path_elements path
    path.split('/')
  end

end

end
