require 'zerg_xcode'

describe ZergXcode::Encoder do

  describe 'encoded and reparsed project' do

    let(:fixture_contents) {File.read 'spec/fixtures/project.pbxproj'}
    let(:original_parsed_project) {ZergXcode::Parser.parse(fixture_contents)}
    let(:reencoded_project) {ZergXcode::Encoder.encode(original_parsed_project)}
    subject {ZergXcode::Parser.parse(reencoded_project)}

    it 'should be identical to the originally parsed project' do
      should == original_parsed_project
    end
  end

end
