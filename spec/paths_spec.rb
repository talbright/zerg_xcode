# Author:: Victor Costan
# Copyright:: Copyright (C) 2009 Zergling.Net
# License:: MIT

require 'zerg_xcode'
require 'test/unit'

describe ZergXcode::Paths do

  include ZergXcode::Paths
  
  describe '#project_file_at' do
    context "when given 'test/fixtures/ZergSupport'" do
      subject {project_file_at('test/fixtures/ZergSupport')}
      it {should == 'test/fixtures/ZergSupport.xcodeproj/project.pbxproj'}
    end

    context "when given 'test/fixtures/ZergSupport.xcodeproj'" do
      subject {project_file_at('test/fixtures/ZergSupport.xcodeproj')}
      it {should == 'test/fixtures/ZergSupport.xcodeproj/project.pbxproj'}
    end

    context "when given 'test/fixtures'" do
      subject {project_file_at('test/fixtures')}
      it {should == 'test/fixtures/project.pbxproj'}
    end

    context "when given 'test'" do
      subject {project_file_at('test')}
      it {should == 'test/fixtures/project.pbxproj'}
    end

    context "when given 'test/fixtures/TestApp'" do
      subject {project_file_at('test/fixtures/TestApp')}
      it {should == 'test/fixtures/TestApp/TestApp.xcodeproj/project.pbxproj'}
    end

    context "when given 'test/fixtures/TestApp/TestApp.xcodeproj'" do
      subject {project_file_at('test/fixtures/TestApp/TestApp.xcodeproj')}
      it {should == 'test/fixtures/TestApp/TestApp.xcodeproj/project.pbxproj'}
    end
  end

  describe '#project_root_at' do
    context "when given 'test/fixtures/ZergSupport'" do
      subject {project_root_at('test/fixtures/ZergSupport')}
      it {should == 'test/fixtures'}
    end

    context "when given 'test/fixtures/ZergSupport.xcodeproj'" do
      subject {project_root_at('test/fixtures/ZergSupport.xcodeproj')}
      it {should == 'test/fixtures'}
    end

    context "when given 'test/fixtures'" do
      subject {project_root_at('test/fixtures')}
      it {should == 'test'}
    end

    context "when given 'test'" do
      subject {project_root_at('test')}
      it {should == 'test'}
    end

    context "when given 'test/fixtures/TestApp'" do
      subject {project_root_at('test/fixtures/TestApp')}
      it {should == 'test/fixtures/TestApp'}
    end

    context "when given 'test/fixtures/TestApp/TestApp.xcodeproj'" do
      subject {project_root_at('test/fixtures/TestApp/TestApp.xcodeproj')}
      it {should == 'test/fixtures/TestApp'}
    end
  end

end
