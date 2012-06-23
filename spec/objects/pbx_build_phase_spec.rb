require 'zerg_xcode'

describe PBXBuildPhase = ZergXcode::Objects::PBXBuildPhase do

  describe "a new phase" do
    subject {PBXBuildPhase.new_phase('FooPhase')._attr_hash}
    it 'should have the given phase type as "isa"' do
      should include('isa' => 'FooPhase')
    end
    it 'should have the expected magic number for buildActionMask' do
      should include('buildActionMask' => '2147483647')
    end
    it 'should not run only for deployment postprocessing' do
      should include('runOnlyForDeploymentPostprocessing' => '0')
    end
    it 'should start with an empty list of files' do
      should include('files' => [])
    end
    it 'shoudl start with an empty list of dependencies' do
      should include('dependencies' => [])
    end
  end

end
