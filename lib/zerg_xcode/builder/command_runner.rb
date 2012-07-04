require 'shellwords'

module ZergXcode::Builder

class CommandRunner
  def run(command_words)
    Kernel.send(:`, command_words.shelljoin + ' 2>&1')
  end
end

end
