# Logic for the multiple SDKs in an Xcode installation. 
#
# Author:: Victor Costan
# Copyright:: Copyright (C) 2009 Zergling.Net
# License:: MIT

# :nodoc: namespace
module ZergXcode::Builder

# Logic for the multiple SDKs in an Xcode installation. 
module Sdk
  
  # All the SDKs installed.
  def self.all
    output = output_of_xcodebuild_showsdks
    sdks = []
    group = ''
    output.split(/\n/).each do |line|
      if line.index '-sdk '
        name, arg = *line.split('-sdk ').map { |token| token.strip }
        sdks << { :group => group, :name => name, :arg => arg }
      elsif line.index ':'
        group = line.split(':').first.strip
      end
    end
    sdks
  end

private
  def self.output_of_xcodebuild_showsdks
    `xcodebuild -showsdks`.to_s
  end

end

end
