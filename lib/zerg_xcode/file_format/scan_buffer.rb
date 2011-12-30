module ZergXcode

class ScanBuffer
  def initialize(string)
    @string = string
    @i = 0
  end

  def at_beginning?
    @i == 0
  end

  def before_the_end?
    @i < @string.length
  end

  def advance(n=1)
    @i += n
  end

  def peek(n=1)
    @string[@i, n]
  end

  def take(n=1)
    result = peek(n)
    advance(n)
    result
  end

  def match_and_advance(pattern)
    match = @string[@i..-1].match(pattern)
    @i += match[0].length if match
    match
  end
end

end
