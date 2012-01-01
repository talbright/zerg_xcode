require 'zerg_xcode'

describe ZergXcode::Archiver do
  Parser = ZergXcode::Parser
  Archiver = ZergXcode::Archiver
  XcodeObject = ZergXcode::XcodeObject

  let(:archived_hash) do
    { "archiveVersion" => '1',
      "rootObject" => '49',
      "classes" => {},
      "objectVersion" => '45',
      "objects" => {
        "49" => { :sub1 => "39", :sub2 => "42" },
        "39" => { :array => ["a", "b", "c"], :string => "s" },
        "42" => { :hash => { :k => "v", :k2 => "v2" }, :sub1 => "39" }
      }
    }
  end

  let(:sub1) do
    sub1 = XcodeObject.new :array => ['a', 'b', 'c'], :string => 's'
    sub1.archive_id = '39'
    sub1
  end

  let(:sub2) do
    sub2 = XcodeObject.new :hash => { :k => 'v', :k2 => 'v2' }, :sub1 => sub1
    sub2.archive_id = '42'
    sub2
  end

  let(:root) do
    root = XcodeObject.new :sub1 => sub1, :sub2 => sub2
    root.archive_id = '49'
    root.version = 45
    root
  end
  
  context 'when archiving' do
    it 'produces the expected hash for a sample object graph' do
      Archiver.archive_to_hash(root).should == archived_hash
    end
  end

  context 'when unarchiving' do
    let(:pbxdata) {File.read 'test/fixtures/project.pbxproj'}
  
    context 'from a hash' do
      it 'produces the expected object graph' do
        unarchived_root = Archiver.unarchive_hash archived_hash
        unarchived_root[:sub1][:s].should == sub1[:s]
        unarchived_root[:sub1][:array].should == sub1[:array]
        unarchived_root[:sub2][:hash].should == sub2[:hash]
        unarchived_root[:sub2][:sub1].should == unarchived_root[:sub1]
      end
    end

    context 'from our fixture' do
      it 'does not raise an error' do
        lambda {Archiver.unarchive pbxdata}.should_not raise_error
      end

      it 'produces a project with a valid product path' do
        project = Archiver.unarchive pbxdata
        project['targets'][0]['productReference']['path'].should == 'TestApp.app'
      end
    end

  end

  describe 'archiving then unarchiving our fixture' do
    let(:pbxdata) {File.read 'test/fixtures/project.pbxproj'}

    it "should produce the same hash" do
      golden_hash = Parser.parse pbxdata
      project = Archiver.unarchive pbxdata
      dupdata = Archiver.archive project
      Parser.parse(dupdata).should == golden_hash
    end
  end
  
end
