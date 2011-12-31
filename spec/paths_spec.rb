# Author:: Victor Costan
# Copyright:: Copyright (C) 2009 Zergling.Net
# License:: MIT

require 'zerg_xcode'
require 'test/unit'

describe ZergXcode::Paths do

  include ZergXcode::Paths
  
  it "should ??" do
    project_file_at('test/fixtures/ZergSupport').should == 'test/fixtures/ZergSupport.xcodeproj/project.pbxproj'
    project_file_at('test/fixtures/ZergSupport.xcodeproj').should == 'test/fixtures/ZergSupport.xcodeproj/project.pbxproj'
    project_file_at('test/fixtures').should == 'test/fixtures/project.pbxproj'
    project_file_at('test').should == 'test/fixtures/project.pbxproj'
    project_file_at('test/fixtures/TestApp').should == 'test/fixtures/TestApp/TestApp.xcodeproj/project.pbxproj'
    project_file_at('test/fixtures/TestApp/TestApp.xcodeproj').should == 'test/fixtures/TestApp/TestApp.xcodeproj/project.pbxproj'
  end
  
  it "should ??" do
    project_root_at('test/fixtures/ZergSupport').should == 'test/fixtures'
    project_root_at('test/fixtures/ZergSupport.xcodeproj').should == 'test/fixtures'
    project_root_at('test/fixtures').should == 'test'
    project_root_at('test').should == 'test'
    project_root_at('test/fixtures/TestApp').should == 'test/fixtures/TestApp'
    project_root_at('test/fixtures/TestApp/TestApp.xcodeproj').should == 'test/fixtures/TestApp'
  end

end
