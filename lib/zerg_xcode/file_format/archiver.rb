# Logic for flattening and restoring  PBX (Xcode project) object graphs.
#
# Author:: Victor Costan
# Copyright:: Copyright (C) 2009 Zergling.Net
# License:: MIT

# :nodoc: namespace
module ZergXcode


# Flattens and restores PBX (Xcode project) object graphs.
module Archiver
  # Unarchives an Xcode object graph from the contents of a file.
  def self.unarchive(string)
    proj_hash = ZergXcode::Parser.parse string
    unarchive_hash proj_hash
  end
  
  # Archives an Xcode object graph to a string to be written to a .pbxproj file.
  def self.archive(project)
    proj_hash = archive_to_hash project
    ZergXcode::Encoder.encode proj_hash
  end    
  
  # Unarchives an Xcode object graph serialized to a hash.
  def self.unarchive_hash(hash)
    raise 'Uknown archive version' unless hash['archiveVersion'] == '1'
    raise 'Classes not implemented' unless hash['classes'] = {}
    version = hash['objectVersion'].to_i
    
    objects = {}
    hash['objects'].each do |archive_id, object_hash|
      object = ZergXcode::XcodeObject.from object_hash
      object.version, object.archive_id = version, archive_id
      objects[archive_id] = object
    end
    objects.each do |object_id, object|
      object.visit do |object, parent, key, value|
        parent[key] = objects[value] if objects.has_key? value
        next true
      end
    end
    return objects[hash['rootObject']]
  end
  
  def self.archive_to_hash(root_object)
    archived = ZergXcode::XcodeObject.from root_object
    id_generator = IdGenerator.new
    visited = Set.new([archived])
    
    archived.visit do |object, parent, key, value|
      next true unless value.kind_of? ZergXcode::XcodeObject
      
      if visited.include? value
        parent[key] = value.archive_id
        next false
      else
        visited << value
        value.archive_id = id_generator.id_for(value)
        parent[key] = value.archive_id
        next true
      end      
    end
    root_object_id = archived.archive_id
  
    objects = {}
    visited.each { |object| objects[object.archive_id] = object._attr_hash }
    return { 'archiveVersion' => '1',
             'objectVersion' => root_object.version.to_s,
             'classes' => Hash.new, 'rootObject' => root_object_id,
             'objects' => objects }
  end
  
end

end
