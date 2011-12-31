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

  context "when parsing '{ foo = ( 42, \"seven and nine\" ) }'" do
    subject {ZergXcode::Parser.parse("{ foo = ( 42, \"seven and nine\" ) }")}
    it {should be_a(Hash)}
    it {should == {'foo' => ['42', 'seven and nine']}}
  end

  context "when parsing '( { foo = 42; bar = 79; }, 42, )'" do
    subject {ZergXcode::Parser.parse("( { foo = 42; bar = 79; }, 42, )")}
    it {should be_an(Array)}
    it {should == [{'foo' => '42', 'bar' => '79'}, '42']}
  end

  it "should ???" do
    pbxdata = File.read 'test/fixtures/project.pbxproj'
    proj = ZergXcode::Parser.parse pbxdata
    
    proj.should be_kind_of(Hash)
    proj['archiveVersion'].should == '1'
    proj['objectVersion'].should == '45'
    proj['rootObject'].should == '29B97313FDCFA39411CA2CEA'

    golden_file_ref = {
      'isa' => 'PBXBuildFile',
      'fileRef' => '28AD733E0D9D9553002E5188'
    }
    proj['objects']['28AD733F0D9D9553002E5188'].should == golden_file_ref

    golden_file = {
      'isa' => 'PBXFileReference',
      'fileEncoding' => '4',
      'lastKnownFileType' => 'sourcecode.c.h',
      'path' => 'TestAppViewController.h',
      'sourceTree' => "<group>"
    }
    proj['objects']['28D7ACF60DDB3853001CB0EB'].should == golden_file
    
    golden_config = {
      'isa' => 'XCBuildConfiguration',
      'buildSettings' => {
        'ARCHS' => "$(ARCHS_STANDARD_32_BIT)",
        "CODE_SIGN_IDENTITY[sdk=iphoneos*]" => "iPhone Developer",
        'GCC_C_LANGUAGE_STANDARD' => 'c99',
        'GCC_WARN_ABOUT_RETURN_TYPE' => 'YES',
        'GCC_WARN_UNUSED_VARIABLE' => 'YES',
        'ONLY_ACTIVE_ARCH' => 'YES',
        'PREBINDING' => 'NO',
        'SDKROOT' => 'iphoneos2.2.1'
      },
      'name' => 'Debug'
    }
    proj['objects']['C01FCF4F08A954540054247B'].should == golden_config
  end

end
