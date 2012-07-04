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
    let(:project) {mock :source_filename => 'foo/bar/baz.xcodeproj/project.pbxproj'}
    let(:sdk) {ZergXcode::Builder::Sdk.new 'iPhone SDKs', 'iOS 5.1', 'iphone5.1'}
    let(:configuration) {'Twiddled-Release'}
    let(:options) do
      { :FOO => 'bar', 'BAZ' => 'QuX' }
    end
    let(:verb) {'clean'}
    subject {BuildCommandMaker.new(project, sdk, configuration, options).make(verb)}

    it {should be_kind_of(Array)}
    it {should include('xcodebuild')}
    it {should include('-alltargets')}
    it {should have_argument_with_value('-project', 'foo/bar/baz.xcodeproj')}
    it {should have_argument_with_value('-sdk', 'iphone5.1')}
    it {should have_argument_with_value('-configuration', configuration)}
    it {should include('FOO=bar')}
    it {should include('BAZ=QuX')}
    it 'should have the verb last' do
      subject.last.should == verb
    end
  end

end
