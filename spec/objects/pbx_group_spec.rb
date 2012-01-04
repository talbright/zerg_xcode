require 'zerg_xcode'

describe PBXGroup = ZergXcode::Objects::PBXGroup do
  let(:proj) { ZergXcode.load 'spec/fixtures/project.pbxproj' } 
  let(:main_group) { proj['mainGroup'] }
  
  context "when the meta data says it should be a pbx group" do
    subject { main_group }
    it { should be_a PBXGroup }
  end
  
  describe "finding a group by name" do
    context "when the group exists" do
      subject { main_group.find_group_named 'Classes' }
      it { should_not be_nil }
      it { should be_a(PBXGroup) }
      it 'should find the group by name' do
        subject.xref_name.should eq 'Classes'
      end
    end
    context "when the group does not exist" do
      subject { main_group.find_group_named "Foo" }
      it { should be_nil }
    end
  end

  describe "newly created group" do
    subject { main_group.create_group 'New Group' }
    it 'should have children' do
      subject.children.should_not be_nil
    end
    it { should_not be_nil }
    it 'should have a "sourceTree" of "<group>"' do
      subject['sourceTree'].should eq "<group>"
    end
    it 'should be findable' do
      subject.should be main_group.find_group_named('New Group')
    end
  end
  
end
