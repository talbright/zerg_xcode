
module ZergXcode::Builder

class BuildCommandMaker
  def initialize(project, sdk, configuration, options)
    @project = project
    @sdk = sdk
    @configuration = configuration
    @options = options
  end

  def make_command(verb)
    start_xcodebuild_command
    add_option '-project', File.dirname(@project.source_filename)
    add_option '-sdk', @sdk.arg
    add_option '-configuration', @configuration
    add_option '-alltargets'
    add_option *formatted_options
    add_option verb
    return @command
  end

  def start_xcodebuild_command
    @command = ['xcodebuild']
  end
  private :start_xcodebuild_command

  def add_option *args
    @command += args
  end
  private :add_option

  def formatted_options
    @options.map {|name, value| "#{name}=#{value}"}
  end
  private :formatted_options

end

end
