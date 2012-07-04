require 'zerg_xcode'

describe PBXBuildFile = ZergXcode::Objects::PBXBuildFile do

  let(:target) {ZergXcode.load('spec/fixtures/project.pbxproj')['targets'].first}
  let(:sources_phase) {target['buildPhases'][1]}

  describe 'the first build file in the fixture' do
    subject {sources_phase['files'].first}

    it {should be_kind_of(PBXBuildFile)}

    it 'should be named "main.m"' do
      subject.filename.should == 'main.m' 
    end

    it 'should have type "sourcecode.c.objc"' do
      subject.file_type.should == 'sourcecode.c.objc'
    end
  end

end
