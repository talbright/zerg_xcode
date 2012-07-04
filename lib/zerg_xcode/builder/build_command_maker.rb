
module ZergXcode::Builder

class BuildCommandMaker
  def initialize(project, sdk, configuration, options)
    @project = project
    @sdk = sdk
    @configuration = configuration
    @options = options
  end

  def make(verb)
    cmd = ['xcodebuild']
    cmd += ['-project', File.dirname(@project.source_filename)]
    cmd += ['-sdk', @sdk.arg]
    cmd += ['-configuration', @configuration]
    cmd += ['-alltargets']
    cmd += formatted_options
    cmd += [verb]
  end

  def formatted_options
    @options.map {|name, value| "#{name}=#{value}"}
  end
  private :formatted_options

end

end
