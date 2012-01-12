module ZergXcode # :nodoc:


class FileReferenceBuilder

  FILE_TYPES = {
    '.h' => 'sourcecode.c.h',
    '.m' => 'sourcecode.c.objc',
  }

  def initialize(path)
    @path = path
  end

  def build
    ZergXcode::XcodeObject.new 'isa' => :PBXFileReference,
                               'path' => File.basename(@path),
                               'fileEncoding' => 4,
                               'sourceTree' => '<group>',
                               'lastKnownFileType' => last_known_file_type
  end

  def last_known_file_type
    FILE_TYPES[extension] || "file#{extension}"
  end
  private :last_known_file_type

  def extension
    File.extname @path
  end
  private :extension

end


end
