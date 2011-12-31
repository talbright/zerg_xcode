require 'zerg_xcode'

describe ZergXcode::Parser do
  context "when parsing '{ archiveVersion = 1 /* foo */; objectVersion = 45; }'" do
    subject {ZergXcode::Parser.parse("{ archiveVersion = 1 /* foo */; objectVersion = 45; }")}
    it {should be_a(Hash)}
    it {should == {'archiveVersion' => '1', 'objectVersion' => '45'}}
  end

  context "when parsing '( 2342 /* foo */, 789 /* bar */, )'" do
    subject {ZergXcode::Parser.parse("( 2342 /* foo */, 789 /* bar */, )")}
    it {should be_an(Array)}
    it {should == ["2342", "789"]}
  end

  context "when parsing '{ foo = ( 42, \"seven and nine\" ); }'" do
    subject {ZergXcode::Parser.parse("{ foo = ( 42, \"seven and nine\" ); }")}
    it {should be_a(Hash)}
    it {should == {'foo' => ['42', 'seven and nine']}}
  end

  context "when parsing '( { foo = 42; bar = 79; }, 42, )'" do
    subject {ZergXcode::Parser.parse("( { foo = 42; bar = 79; }, 42, )")}
    it {should be_an(Array)}
    it {should == [{'foo' => '42', 'bar' => '79'}, '42']}
  end

  it "should parse our sample fixture" do
    pbxdata = File.read 'test/fixtures/project.pbxproj'
    proj = ZergXcode::Parser.parse pbxdata
    proj['rootObject'].should == '29B97313FDCFA39411CA2CEA'
  end

end
