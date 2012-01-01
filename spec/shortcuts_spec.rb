require 'zerg_xcode'

describe ZergXcode do

  context "when loading a file" do
    subject {ZergXcode.load 'spec/fixtures/ZergSupport'}

    it "should find the targets" do
      targets = subject['targets'].map{ |target| target['name'] }.sort
      targets.should == ['ZergSupport', 'ZergTestSupport', 'ZergSupportTests'].sort
    end

    it "should set the project's source filename" do
      subject.source_filename.should == 'spec/fixtures/ZergSupport.xcodeproj/project.pbxproj'
    end
  end

  context "when finding plugins" do
    it "should return the correct class" do
      ZergXcode.plugin('ls').should be_a(ZergXcode::Plugins::Ls)
    end
  end

end
