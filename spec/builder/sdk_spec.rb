require 'zerg_xcode'

TEST_SHOWSDKS_OUTPUT = <<EOF
Mac OS X SDKs:
        Mac OS X 10.6                   -sdk macosx10.6
        Mac OS X 10.7                   -sdk macosx10.7

iOS SDKs:
        iOS 5.1                         -sdk iphoneos5.1

iOS Simulator SDKs:
        Simulator - iOS 5.1             -sdk iphonesimulator5.1
EOF

describe ZergXcode::Builder::Sdk do
  describe '::all' do

    let(:runner) {mock :run => TEST_SHOWSDKS_OUTPUT}

    subject {ZergXcode::Builder::Sdk.all(runner)}

    it "should find a Mac OS SDK" do
      subject.detect{|sdk| sdk.arg == 'macosx10.6'}.should_not be_nil
    end

    it "should find an iPhone SDK" do
      subject.detect{|sdk| sdk.arg == 'iphoneos5.1'}.should_not be_nil
    end

    it "should find a simulator SDK" do
      subject.detect{|sdk| sdk.arg == 'iphonesimulator5.1'}.should_not be_nil
    end
  end
end
