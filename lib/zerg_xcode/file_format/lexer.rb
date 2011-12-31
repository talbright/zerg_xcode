# Lexer for flattened object graphs stored in .pbxproj files.
#
# Author:: Victor Costan
# Copyright:: Copyright (C) 2009 Zergling.Net
# License:: MIT

# :nodoc: namespace
module ZergXcode


# Lexer for flattened object graphs stored in .xcodeproj files.
class Lexer

  SIMPLE_TOKENS = {
    '(' => :begin_array,
    ')' => :end_array,
    '{' => :begin_hash,
    '}' => :end_hash,
    '=' => :assign,
    ';' => :stop,
    ',' => :comma
  }

  def initialize(string)
    @scan_buffer = ScanBuffer.new(string)
  end

  def tokenize
    tokens = []
    while true
      token = scan_token
      break unless token
      tokens << token
    end
    tokens
  end

  def scan_token
    skip_comments_and_whitespace

    return nil if @scan_buffer.at_end?
    return scan_encoding if @scan_buffer.at?('// !$*')
    return scan_string if @scan_buffer.at?('"')
    return scan_simple_token if at_simple_token?
    return scan_symbol
  end
  private :scan_token

  def scan_encoding
    encoding_match = @scan_buffer.match_and_advance(/^\/\/ \!\$\*(.*?)\*\$\!/)
    return [:encoding, encoding_match[1]]
  end
  private :scan_encoding

  def scan_comment
    @scan_buffer.advance(2)
    @scan_buffer.advance until @scan_buffer.at?('*/')
    @scan_buffer.advance(2)
  end
  private :scan_comment

  def skip_comments_and_whitespace
    true while scan_comment_or_whitespace
  end
  private :skip_comments_and_whitespace

  def scan_comment_or_whitespace
    if @scan_buffer.peek =~ /\s/
      @scan_buffer.advance
      true
    elsif @scan_buffer.at?('/*')
      scan_comment
      true
    else
      false
    end
  end
  private :scan_comment_or_whitespace

  def scan_string
    @scan_buffer.advance
    token = ''
    until @scan_buffer.at?('"')
      if @scan_buffer.at?('\\')
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
  private :scan_string

  def at_simple_token?
    SIMPLE_TOKENS.keys.include?(@scan_buffer.peek)
  end
  private :at_simple_token?

  def scan_simple_token
    SIMPLE_TOKENS[@scan_buffer.take]
  end
  private :scan_simple_token

  def scan_symbol
    symbol = ""
    symbol << @scan_buffer.take while @scan_buffer.peek(1) =~ /[^\s\t\r\n\f(){}=;,]/
    return [:symbol, symbol]
  end
  private :scan_symbol

  def self.tokenize(string)
    Lexer.new(string).tokenize
  end

end

end
