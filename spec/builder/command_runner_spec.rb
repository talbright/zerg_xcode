require 'zerg_xcode'

describe CommandRunner = ZergXcode::Builder::CommandRunner do
  it {should respond_to(:run)}

  it 'accepts an array of shell words' do
    subject.run(['ls', '/'])
  end

  it 'runs the command using ` and captures the error stream' do
    Kernel.should_receive(:`).with('ls / 2>&1').and_return("")
    subject.run(['ls', '/'])
  end

  it "responds with the command's output" do
    Kernel.should_receive(:`).and_return("foo")
    subject.run(['ls', '/']).should == 'foo'
  end
end
