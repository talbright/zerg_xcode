require 'zerg_xcode'

describe ZergXcode::Builder::Runner do
  let(:project) {ZergXcode.load 'spec/fixtures/ClosedLib'}
  let(:sdk) {ZergXcode::Builder::Sdk.new 'iOS SDKs', 'iOS 5.1', 'iphoneos5.1'}
  let(:configuration) {'Release'}
  
  describe '::action' do

    it 'reports success if output contains "SUCCEEDED"' do
      runner = mock :run => "Hello\n** BUILD SUCCEEDED **\n\n"
      ZergXcode::Builder::Runner.action(project, sdk, configuration, {}, 'build', runner).should be_true
    end

    it 'reports failure if output does not contain "SUCEEDED"' do
      runner = mock :run => "Hello\n** BUILD FAILED **\n\n"
      ZergXcode::Builder::Runner.action(project, sdk, configuration, {}, 'build', runner).should be_false
    end

  end

end
