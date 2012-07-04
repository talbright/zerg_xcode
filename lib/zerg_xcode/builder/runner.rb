# Runs the Xcode build process.
#
# Author:: Victor Costan
# Copyright:: Copyright (C) 2009 Zergling.Net
# License:: MIT

require 'fileutils'
require 'shellwords'

# :nodoc: namespace
module ZergXcode::Builder


# Runs the Xcode build process.
module Runner
  # Builds an Xcode project.
  #
  # Returns the directory containing the build products, or nil if the build
  # failed.
  def self.build(project, sdk, configuration, options = {}, command_runner = CommandRunner.new)
    return nil unless action(project, sdk, configuration, options, 'build', command_runner)
    Dir.glob(File.join(project.root_path, 'build', configuration + '-*')).first
  end
  
  # Removes the build products for an Xcode project.
  #
  # Returns true for success, or false if the removal failed.
  def self.clean(project, sdk, configuration, options = {}, command_runner = CommandRunner.new)
    return_value = action(project, sdk, configuration, options, 'clean', command_runner)
    FileUtils.rm_rf File.join(project.root_path, 'build')
    return_value
  end
  
  # Executes an action using the Xcode builder.
  #
  # Returns true if the action suceeded, and false otherwise.
  def self.action(project, sdk, configuration, options, verb, command_runner = CommandRunner.new)
    build_command_maker = BuildCommandMaker.new(project, sdk, configuration, options)
    command = build_command_maker.make_command(verb)
    output = command_runner.run(command)
    /\*\* .* SUCCEEDED \*\*/ =~ output
  end
end

end
