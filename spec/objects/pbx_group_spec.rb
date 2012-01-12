require 'zerg_xcode'

describe PBXGroup = ZergXcode::Objects::PBXGroup do
  let(:proj) { ZergXcode.load 'spec/fixtures/project.pbxproj' } 
  let(:main_group) { proj['mainGroup'] }
  
  context "when the meta data says it should be a pbx group" do
    subject { main_group }
    it { should be_a PBXGroup }
  end
  
  describe '#mkdir' do
    context 'when the group does not already exist' do
      describe 'the new group' do
        subject { main_group.mkdir 'New Group' }
        it { should_not be_nil }
        it 'should have children' do
          subject.children.should_not be_nil
        end
        it 'should have a "sourceTree" of "<group>"' do
          subject['sourceTree'].should eq "<group>"
        end
        it { should be_found_within main_group } 
      end
    end
    context 'when the group already exists' do
      before {main_group.mkdir 'New Group'}
      describe 'the invocation' do
        subject {lambda {main_group.mkdir 'New Group'}}
        it {should raise_error(Errno::EEXIST)}
      end
    end
    context 'using a group name with a slash' do
      describe 'the invocation' do
        subject {lambda {main_group.mkdir 'Foo/Bar'}}
        it {should raise_error(Errno::ENOTNAM)}
      end
    end
  end

  describe '#mkdir_f' do
    context 'when the group already exists' do
      let(:the_group) {main_group.mkdir 'Foo'}
      subject {main_group.mkdir_f 'Foo'}
      it 'should be that group' do
        should be(the_group)
      end
    end
    context 'when the group does not exist' do
      subject {main_group.mkdir_f 'Foo'}
      it 'should create it' do
        subject.xref_name.should eq 'Foo'
        subject.should be_found_within main_group
      end
    end
  end

  describe '#mkdir_p' do
    before {main_group.mkdir_p 'Foo/Bar'}
    it 'creates the first part of the path' do
      main_group.exists?('Foo').should be_true
    end
    it 'creates the second part of the path' do
      main_group.exists?('Foo/Bar').should be_true
    end
    context 'when the first part of the path exists' do
      before do
        @first = main_group.mkdir 'First'
        @second = main_group.mkdir_p 'First/Second'
      end
      it 'reuses the first part' do
        @second.should be_found_within @first
      end
    end
  end

  describe '#child_with_path' do
    context 'with a one-element path' do
      subject {main_group.exists?('Foo')}
      context 'when the element does not exist' do
        it {should be_nil}
      end

      context 'when the element exists' do
        let(:foo) {main_group.mkdir 'Foo'}
        it 'should be that element' do
          should be(foo)
        end
      end
    end

    context 'with a multiple element path' do
      subject {main_group.exists?('Foo/Bar/Baz')}
      context 'when no elements of the path exist' do
        it {should be_nil}
      end
      context 'when part of the path exists' do
        before {main_group.mkdir('Foo').mkdir('Bar')}
        it {should be_nil}
      end
      context 'when all of the path exists' do
        let(:last_element) {main_group.mkdir('Foo').mkdir('Bar').mkdir('Baz')}
        it 'should be the last element of that path' do
          should be(last_element)
        end
      end
    end
  end

  describe '#child_with_name' do
    subject {main_group.child_with_name 'Foo'}
    context 'when the child does not exist' do
      it {should be_nil}
    end
    context 'when the child exists' do
      let(:the_child) {main_group.mkdir 'Foo'}
      it 'should be that child' do
        should be(the_child)
      end
    end
  end

  describe '#add_file_reference' do
    before {main_group.add_file_reference 'Foo/Bar/baz.cpp'}
    it 'creates the parent group' do
      main_group.child_with_path('Foo/Bar').should be_kind_of(ZergXcode::Objects::PBXGroup)
    end
    describe 'the added file reference object' do
      subject {main_group.child_with_path 'Foo/Bar/baz.cpp'}
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
    end
  end

end

RSpec::Matchers.define :be_found_within do |expected|
  match do |actual| 
    expected.child_with_name(actual.xref_name).equal? actual 
  end
  failure_message_for_should do |actual|
    "expected #{expected.xref_name} to be found within #{actual.xref_name}"
  end
end

