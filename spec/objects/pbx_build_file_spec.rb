require 'zerg_xcode'

describe PBXBuildFile = ZergXcode::Objects::PBXBuildFile do

  let(:target) {ZergXcode.load('spec/fixtures/project.pbxproj')['targets'].first}
  let(:sources_phase) {target['buildPhases'][1]}
  let(:loaded_build_file) {sources_phase['files'].first}

  describe 'the first build file in the fixture' do
    subject {loaded_build_file}

    it {should be_kind_of(PBXBuildFile)}

    it 'is named "main.m"' do
      subject.filename.should == 'main.m' 
    end

    it 'has type "sourcecode.c.objc"' do
      subject.file_type.should == 'sourcecode.c.objc'
    end

    it 'has an xref_name matching the filename' do
      subject.xref_name.should == subject.filename
    end
  end

  describe 'PBXBuildFile for the same fileRef as loaded' do
    subject {PBXBuildFile.for loaded_build_file['fileRef']}

    it {should be_kind_of(PBXBuildFile)}

    it 'has the same attributes' do
      subject._attr_hash.should == loaded_build_file._attr_hash
    end
  end

end
