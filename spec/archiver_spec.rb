require 'zerg_xcode'

describe ZergXcode::Archiver do
  Parser = ZergXcode::Parser
  Archiver = ZergXcode::Archiver
  XcodeObject = ZergXcode::XcodeObject
  
  before do
    @sub1 = XcodeObject.new :array => ['a', 'b', 'c'], :string => 's'
    @sub1.archive_id = '39'
    @sub2 = XcodeObject.new :hash => { :k => 'v', :k2 => 'v2' }, :sub1 => @sub1
    @sub2.archive_id = '42'
    @root = XcodeObject.new :sub1 => @sub1, :sub2 => @sub2
    @root.archive_id = '49'
    @root.version = 45
    
    @archived = {
      "archiveVersion" => '1',
      "rootObject" => '49',
      "classes" => {},
      "objectVersion" => '45',
      "objects" => {
        "49" => { :sub1 => "39", :sub2 => "42" },
        "39" => { :array => ["a", "b", "c"], :string => "s" },
        "42" => { :hash => { :k => "v", :k2 => "v2" }, :sub1 => "39" }
      }
    }
    
    @pbxdata = File.read 'test/fixtures/project.pbxproj'     
  end
  
  it "archives to a hash" do
    hash = Archiver.archive_to_hash @root
    hash.should == @archived
  end
  
  it "unarchives a hash" do
    root = Archiver.unarchive_hash @archived
    root[:sub1][:s].should == @sub1[:s]
    root[:sub1][:array].should == @sub1[:array]
    root[:sub2][:hash].should == @sub2[:hash]
    root[:sub2][:sub1].should == root[:sub1]
  end

  describe Archiver::IdGenerator do
    it "works" do
      generator = Archiver::IdGenerator.new
      generator.id_for(@root).should == '49'
      generator.id_for(@sub2).should == '42'
      new_id = generator.id_for @root
      new_id.should_not == '49'
      newer_id = generator.id_for @root
      ['49', new_id].should_not include(newer_id)
    end 
  end
 
  describe 'unarchiving an archive' do
    it "should produce the same hash" do
      golden_hash = Parser.parse @pbxdata
      project = Archiver.unarchive @pbxdata
      dupdata = Archiver.archive project
      Parser.parse(dupdata).should == golden_hash
    end
  end
  
  it "unarchives our fixture" do
    project = Archiver.unarchive @pbxdata
    project['targets'][0]['productReference']['path'].should == 'TestApp.app'
  end

end
