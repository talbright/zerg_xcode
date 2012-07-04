require 'zerg_xcode'

describe BuildCommandMaker = ZergXcode::Builder::BuildCommandMaker do
  it {should respond_to(:make)}
  
  describe 'result of making a command' do
    subject {BuildCommandMaker.new.make}
    it {should be_kind_of(Array)}
    it {should include('xcodebuild')}
  end

end
