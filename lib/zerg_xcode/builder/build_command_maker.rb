
module ZergXcode::Builder

class BuildCommandMaker
  def initialize(sdk)
    @sdk = sdk
  end

  def make
    ['xcodebuild', '-sdk', @sdk.arg, '-alltargets']
  end
end

end
