require 'zerg_xcode'

describe BuildCommandMaker = ZergXcode::Builder::BuildCommandMaker do
  
  describe "its result" do
    let(:sdk) {ZergXcode::Builder::Sdk.new 'iPhone SDKs', 'iOS 5.1', 'iphone5.1'}
    subject {BuildCommandMaker.new(sdk).make}

    it {should be_kind_of(Array)}
    it {should include('xcodebuild')}
    it {should include('-alltargets')}
    it 'passes the sdk' do
      i = subject.index('-sdk')
      subject[i+1].should == 'iphone5.1'
    end
  end

end
