require 'zerg_xcode'

describe PBXBuildFile = ZergXcode::Objects::PBXBuildFile do

  let(:target) {ZergXcode.load('spec/fixtures/project.pbxproj')['targets'].first}
  let(:sources_phase) {target['buildPhases'][1]}

  describe 'the first build file in the fixture' do
    subject {sources_phase['files'].first}
    it {should be_kind_of(PBXBuildFile)}
  end

end
