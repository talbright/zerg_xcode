# Lexer for flattened object graphs stored in .pbxproj files.
#
# Author:: Victor Costan
# Copyright:: Copyright (C) 2009 Zergling.Net
# License:: MIT

# :nodoc: namespace
module ZergXcode


# Lexer for flattened object graphs stored in .xcodeproj files.
class Lexer

  def initialize(string)
    @scan_buffer = ScanBuffer.new(string)
  end

  def tokenize
    tokens = []
    while true
      token = next_token
      break unless token
      tokens << token
    end
    tokens
  end

  def next_token
    return parse_encoding if @scan_buffer.at_beginning?

    while @scan_buffer.before_the_end?
      skip_comment
      
      case @scan_buffer.peek
      when /\s/
        @scan_buffer.advance
      when '(', ')', '{', '}', '=', ';', ','
        token = {'(' => :begin_array, ')' => :end_array,
                 '{' => :begin_hash, '}' => :end_hash,
                 '=' => :assign, ';' => :stop, ',' => :comma}[@scan_buffer.take]
        return token
      when '"'
        return parse_string
      else
        return parse_symbol
      end
    end
  end
  private :next_token

  def parse_encoding
    encoding_match = @scan_buffer.match_and_advance(/^\/\/ \!\$\*(.*?)\*\$\!/)
    raise "No encoding - #{peek(20)}" unless encoding_match
    return [:encoding, encoding_match[1]]
  end
  private :parse_encoding

  def skip_comment
    if @scan_buffer.peek(2) == '/*'
      @scan_buffer.advance(2)
      @scan_buffer.advance while @scan_buffer.peek(2) != '*/'
      @scan_buffer.advance(2)
    end
  end
  private :skip_comment

  def parse_string
    @scan_buffer.advance
    token = ''
    while @scan_buffer.peek != '"'
      if @scan_buffer.peek == '\\'
        @scan_buffer.advance
        case @scan_buffer.peek
        when 'n', 'r', 't'
          token << { 'n' => "\n", 't' => "\t", 'r' => "\r" }[@scan_buffer.take]
        when '"', "'", '\\'
          token << @scan_buffer.take
        else
          raise "Uknown escape sequence \\#{@scan_buffer.peek 20}"
        end
      else
        token << @scan_buffer.take
      end
    end
    @scan_buffer.advance
    return [:string, token]
  end
  private :parse_string

  def parse_symbol
    symbol = ""
    symbol << @scan_buffer.take while @scan_buffer.peek(1) =~ /[^\s\t\r\n\f(){}=;,]/
    return [:symbol, symbol]
  end
  private :parse_symbol

  def self.tokenize(string)
    Lexer.new(string).tokenize
  end

end

end
