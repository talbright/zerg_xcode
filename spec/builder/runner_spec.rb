require 'zerg_xcode'

describe ZergXcode::Builder::Runner do
  before do
    @project = ZergXcode.load 'spec/fixtures/ClosedLib'
    @configuration = 'Release'
    @sdk = ZergXcode::Builder::Sdk.all.
        detect { |s| /i(?:OS|Phone) .*$/ =~ s.name }
    @golden_build_path = 'spec/fixtures/ClosedLib/build/Release-iphoneos'
    @product = @golden_build_path + '/libClosedLib.a'
    ZergXcode::Builder::Runner.clean(@project, @sdk, @configuration)
  end
  
  after do
    ZergXcode::Builder::Runner.clean @project, @sdk, @configuration
  end
  
  it "builds and cleans the project" do
    build_path = ZergXcode::Builder::Runner.build @project, @sdk, @configuration
    build_path.should be_true
    build_path.should == @golden_build_path
    File.exist?(@product).should be_true

    ZergXcode::Builder::Runner.clean(@project, @sdk, @configuration).should be_true
    File.exist?(@product).should be_false
  end
end
