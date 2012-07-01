require 'zerg_xcode'

describe ZergXcode::Builder::Sdk do
  describe '::all' do
    it "should find a Mac OS SDK" do
      ZergXcode::Builder::Sdk.stub(:output_of_xcodebuild_showsdks).and_return <<EOF
Mac OS X SDKs:
        Mac OS X 10.6                   -sdk macosx10.6
        Mac OS X 10.7                   -sdk macosx10.7

iOS SDKs:
        iOS 5.1                         -sdk iphoneos5.1

iOS Simulator SDKs:
        Simulator - iOS 5.1             -sdk iphonesimulator5.1
EOF

      all_sdks = ZergXcode::Builder::Sdk.all
      macsdk = all_sdks.detect{|sdk| sdk.arg == 'macosx10.6'}
      macsdk.should_not be_nil
    end
  end
end
