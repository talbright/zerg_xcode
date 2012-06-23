require 'zerg_xcode'

describe XCConfigurationList = ZergXcode::Objects::XCConfigurationList do

  it 'should have "XCConfigurationList" as its xref name' do
    proj = ZergXcode.load 'spec/fixtures/project.pbxproj'
    list = proj['buildConfigurationList']
    list.should be_kind_of(XCConfigurationList)
    list.xref_name.should == 'XCConfigurationList'
  end

end
