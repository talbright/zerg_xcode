require 'zerg_xcode'

describe CommandRunner = ZergXcode::Builder::CommandRunner do
  it {should respond_to(:run)}
  it 'accepts an array of shell words' do
    subject.run(['ls', '/'])
  end
end
