require 'shellwords'

module ZergXcode::Builder

class CommandRunner
  def run(command_words)
    Kernel.send(:`, format_command(command_words))
  end

  def format_command(command_words)
    command_words.shelljoin + ' 2>&1'
  end
  private :format_command
end

end
