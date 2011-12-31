require 'zerg_xcode'

describe ZergXcode::Parser do

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
