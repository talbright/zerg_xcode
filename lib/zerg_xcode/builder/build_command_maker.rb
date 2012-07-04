
module ZergXcode::Builder

class BuildCommandMaker
  def initialize(sdk, configuration)
    @sdk = sdk
    @configuration = configuration
  end

  def make(verb)
    ['xcodebuild', '-sdk', @sdk.arg, '-configuration', @configuration, '-alltargets', verb]
  end
end

end
