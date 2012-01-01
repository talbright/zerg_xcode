# Author:: Victor Costan
# Copyright:: Copyright (C) 2009 Zergling.Net
# License:: MIT

require 'zerg_xcode'

describe ZergXcode::Paths do

  include ZergXcode::Paths
  
  describe '#project_file_at' do
    context "when given 'spec/fixtures/ZergSupport'" do
      subject {project_file_at('spec/fixtures/ZergSupport')}
      it {should == 'spec/fixtures/ZergSupport.xcodeproj/project.pbxproj'}
    end

    context "when given 'spec/fixtures/ZergSupport.xcodeproj'" do
      subject {project_file_at('spec/fixtures/ZergSupport.xcodeproj')}
      it {should == 'spec/fixtures/ZergSupport.xcodeproj/project.pbxproj'}
    end

    context "when given 'spec/fixtures'" do
      subject {project_file_at('spec/fixtures')}
      it {should == 'spec/fixtures/project.pbxproj'}
    end

    context "when given 'spec'" do
      subject {project_file_at('spec')}
      it {should == 'spec/fixtures/project.pbxproj'}
    end

    context "when given 'spec/fixtures/TestApp'" do
      subject {project_file_at('spec/fixtures/TestApp')}
      it {should == 'spec/fixtures/TestApp/TestApp.xcodeproj/project.pbxproj'}
    end

    context "when given 'spec/fixtures/TestApp/TestApp.xcodeproj'" do
      subject {project_file_at('spec/fixtures/TestApp/TestApp.xcodeproj')}
      it {should == 'spec/fixtures/TestApp/TestApp.xcodeproj/project.pbxproj'}
    end
  end

  describe '#project_root_at' do
    context "when given 'spec/fixtures/ZergSupport'" do
      subject {project_root_at('spec/fixtures/ZergSupport')}
      it {should == 'spec/fixtures'}
    end

    context "when given 'spec/fixtures/ZergSupport.xcodeproj'" do
      subject {project_root_at('spec/fixtures/ZergSupport.xcodeproj')}
      it {should == 'spec/fixtures'}
    end

    context "when given 'spec/fixtures'" do
      subject {project_root_at('spec/fixtures')}
      it {should == 'spec'}
    end

    context "when given 'spec'" do
      subject {project_root_at('spec')}
      it {should == 'spec'}
    end

    context "when given 'spec/fixtures/TestApp'" do
      subject {project_root_at('spec/fixtures/TestApp')}
      it {should == 'spec/fixtures/TestApp'}
    end

    context "when given 'spec/fixtures/TestApp/TestApp.xcodeproj'" do
      subject {project_root_at('spec/fixtures/TestApp/TestApp.xcodeproj')}
      it {should == 'spec/fixtures/TestApp'}
    end
  end

end
