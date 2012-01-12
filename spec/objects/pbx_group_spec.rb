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
      it { should be_found_within main_group }
    end
  end

  describe "a newly created group" do
    subject { main_group.mkdir 'New Group' }
    it 'should have children' do
      subject.children.should_not be_nil
    end
    it { should_not be_nil }
    it 'should have a "sourceTree" of "<group>"' do
      subject['sourceTree'].should eq "<group>"
    end
    it { should be_found_within main_group } 
  end
  Rspec::Matchers.define :be_found_within do |expected|
    match do |actual| 
      expected.find_group_named(actual.xref_name).equal? actual 
    end
    failure_message_for_should do |actual|
      "expected #{expected.xref_name} to be found within #{actual.xref_name}"
    end
  end

  context 'when checking whether a path exists' do
    context 'with a one-element path' do
      subject {main_group.exists?('Foo')}
      context 'when the element does not exist' do
        it {should be_false}
      end

      context 'when the element exists' do
        before {main_group.mkdir 'Foo'}
        it {should be_true}
      end
    end

    context 'with a multiple element path' do
      subject {main_group.exists?('Foo/Bar/Baz')}
      context 'when no elements of the path exist' do
        it {should be_false}
      end
      context 'when part of the path exists' do
        before {main_group.mkdir('Foo').mkdir('Bar')}
        it {should be_false}
      end
      context 'when all of the path exists' do
        before {main_group.mkdir('Foo').mkdir('Bar').mkdir('Baz')}
        it {should be_true}
      end
    end
  end

end

