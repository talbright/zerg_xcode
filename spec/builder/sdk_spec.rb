require 'zerg_xcode'

describe ZergXcode::Builder::Sdk do
  describe '::all' do
    it "should find a Mac OS SDK" do
      all_sdks = ZergXcode::Builder::Sdk.all
      macsdk = all_sdks.detect{|sdk| sdk[:arg] =~ /^macosx[0-9\.]+$/}
      macsdk.should_not be_nil
    end
  end
end
