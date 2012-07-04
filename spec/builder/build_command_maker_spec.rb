require 'zerg_xcode'

RSpec::Matchers.define :have_argument_with_value do |argument, value|
  match do |actual|
    i = subject.index(argument)
    subject[i+1] == value
  end
  description do
    "have an argument '#{argument}' with value '#{value}'"
  end
end

describe BuildCommandMaker = ZergXcode::Builder::BuildCommandMaker do
  
  describe "the resulting command" do
    let(:sdk) {ZergXcode::Builder::Sdk.new 'iPhone SDKs', 'iOS 5.1', 'iphone5.1'}
    let(:configuration) {'Twiddled-Release'}
    subject {BuildCommandMaker.new(sdk, configuration).make}

    it {should be_kind_of(Array)}
    it {should include('xcodebuild')}
    it {should include('-alltargets')}
    it {should have_argument_with_value('-sdk', 'iphone5.1')}
    it {should have_argument_with_value('-configuration', configuration)}
  end

end
