require 'zerg_xcode'

describe PBXContainerItemProxy = ZergXcode::Objects::PBXContainerItemProxy do

  context 'loaded from fixture' do
    let(:project) {ZergXcode.load 'spec/fixtures/ZergSupport.xcodeproj/project.pbxproj'}
    let(:target) {project['targets'][1]}
    subject {project['targets'][2]['dependencies'].first['targetProxy']}

    it {should be_kind_of(PBXContainerItemProxy)}
    it 'should have the right target' do
      subject.target.should == target 
    end

    it 'should have an xref name of "ZergTestSupport"' do
      subject.xref_name.should == 'ZergTestSupport'
    end
  end

end
