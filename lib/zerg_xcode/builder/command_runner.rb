
module ZergXcode::Builder

class CommandRunner
  def run(command_words)
    Kernel.`(command_words.join(' ') + ' 2>&1')
  end
end

end
