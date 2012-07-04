
module ZergXcode::Builder

class BuildCommandMaker
  def initialize(project, sdk, configuration, options)
    @project = project
    @sdk = sdk
    @configuration = configuration
    @options = options
  end

  def make(verb)
    ['xcodebuild', '-project', File.dirname(@project.source_filename), '-sdk', @sdk.arg, '-configuration', @configuration, '-alltargets'] +
    formatted_options +
    [verb]
  end

  def formatted_options
    @options.map {|name, value| "#{name}=#{value}"}
  end
  private :formatted_options

end

end
