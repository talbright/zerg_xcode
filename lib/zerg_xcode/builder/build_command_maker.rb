
module ZergXcode::Builder

class BuildCommandMaker
  def initialize(sdk, configuration, options)
    @sdk = sdk
    @configuration = configuration
    @options = options
  end

  def make(verb)
    ['xcodebuild', '-sdk', @sdk.arg, '-configuration', @configuration, '-alltargets'] +
    @options.map {|name, value| "#{name}=#{value}"} +
    [verb]
  end

end

end
