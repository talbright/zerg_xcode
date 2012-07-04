
module ZergXcode::Builder

class BuildCommandMaker
  def initialize(sdk, configuration, options)
    @sdk = sdk
    @configuration = configuration
    @options = options
  end

  def make(verb)
    ['xcodebuild', '-sdk', @sdk.arg, '-configuration', @configuration, '-alltargets'] +
    formatted_options +
    [verb]
  end

  def formatted_options
    @options.map {|name, value| "#{name}=#{value}"}
  end
  private :formatted_options

end

end
