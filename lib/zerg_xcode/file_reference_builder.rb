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
    type = FILE_TYPES[File.extname(@path)] || "file#{File.extname(@path)}"
    ZergXcode::XcodeObject.new 'isa' => :PBXFileReference,
                               'path' => File.basename(@path),
                               'fileEncoding' => 4,
                               'sourceTree' => '<group>',
                               'lastKnownFileType' => type
  end
end


end
