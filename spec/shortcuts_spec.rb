require 'zerg_xcode'

describe ZergXcode do

  context "when loading a file" do

    subject {ZergXcode.load 'test/fixtures/ZergSupport'}

    it "should find the targets" do
      targets = subject['targets'].map{ |target| target['name'] }.sort
      targets.should == ['ZergSupport', 'ZergTestSupport', 'ZergSupportTests'].sort
    end

    it "should set the project's source filename" do
      subject.source_filename.should == 'test/fixtures/ZergSupport.xcodeproj/project.pbxproj'
    end
  end

end
