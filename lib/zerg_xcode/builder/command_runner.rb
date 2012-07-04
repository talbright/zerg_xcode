require 'shellwords'

module ZergXcode::Builder

class CommandRunner
  def run(command_words)
    Kernel.send(:`, make_command(command_words))
  end

  def make_command(command_words)
    command_words.shelljoin + ' 2>&1'
  end
  private :make_command
end

end
