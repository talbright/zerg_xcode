
module ZergXcode::Builder

class BuildCommandMaker
  def initialize(sdk, configuration)
    @sdk = sdk
    @configuration = configuration
  end

  def make
    ['xcodebuild', '-sdk', @sdk.arg, '-configuration', @configuration, '-alltargets']
  end
end

end
