require 'zerg_xcode'

describe FileReferenceBuilder = ZergXcode::FileReferenceBuilder do

  describe 'the built file reference object' do
    subject {FileReferenceBuilder.new('Foo/Bar/baz.cpp').build}
    it 'is a PBXFileReference' do
      subject['isa'].should eq :PBXFileReference
    end
    it 'has an xref_name containing only the file part' do
      subject.xref_name.should eq 'baz.cpp'
    end
    it 'has a path containing only the file part' do
      subject['path'].should eq 'baz.cpp'
    end
    it 'has a fileEncoding of 4' do
      subject['fileEncoding'].should eq 4
    end
    it 'has a sourceTree of <group>' do
      subject['sourceTree'].should eq '<group>'
    end
  end

  describe "the lastKnownFileType of the built file reference object" do
    context 'when the file has a .h extension' do
      subject {FileReferenceBuilder.new('Slime/file.h').build['lastKnownFileType']}
      it {should eq 'sourcecode.c.h'}
    end
    context 'when the file has a .m extension' do
      subject {FileReferenceBuilder.new('Slime/file.m').build['lastKnownFileType']}
      it {should eq 'sourcecode.c.objc'}
    end
    context 'when the file has a weird extension' do
      subject {FileReferenceBuilder.new('Slime/file.weird').build['lastKnownFileType']}
      it {should eq 'file.weird'}
    end
  end

end
