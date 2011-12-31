# Lexer for flattened object graphs stored in .pbxproj files.
#
# Author:: Victor Costan
# Copyright:: Copyright (C) 2009 Zergling.Net
# License:: MIT

# :nodoc: namespace
module ZergXcode


# Lexer for flattened object graphs stored in .xcodeproj files.
class Lexer

  SIMPLE_TOKENS = [ '(', ')', '{', '}', '=', ';', ',' ]

  def initialize(string)
    @scan_buffer = ScanBuffer.new(string)
  end

  def tokenize
    tokens, token = [], nil
    tokens << token until (token = scan_token).nil?
    tokens
  end

  def scan_token
    skip_encodings_comments_and_whitespace

    return nil if at_end_of_buffer?
    return scan_simple_token if at_simple_token?
    return scan_quoted_string if at_quoted_string?
    return scan_bare_string
  end
  private :scan_token

  def skip_encodings_comments_and_whitespace
    nil while skip_encoding_comment_or_whitespace
  end
  private :skip_encodings_comments_and_whitespace

  def skip_encoding_comment_or_whitespace
    if at_encoding?
      skip_encoding
      true
    elsif @scan_buffer.peek =~ /\s/
      @scan_buffer.advance
      true
    elsif @scan_buffer.at?('/*')
      skip_comment
      true
    else
      false
    end
  end
  private :skip_encoding_comment_or_whitespace

  def skip_comment
    @scan_buffer.advance(2)
    @scan_buffer.advance until @scan_buffer.at?('*/')
    @scan_buffer.advance(2)
  end
  private :skip_comment

  def at_end_of_buffer?
    @scan_buffer.at_end?
  end
  private :at_end_of_buffer?

  def at_encoding?
    @scan_buffer.at?('// !$*')
  end
  private :at_encoding?

  def skip_encoding
    @scan_buffer.match_and_advance(/^\/\/ \!\$\*(.*?)\*\$\!/)
  end
  private :skip_encoding

  def at_quoted_string?
    @scan_buffer.at?('"')
  end
  private :at_quoted_string?

  def scan_quoted_string
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
  private :scan_quoted_string

  def at_simple_token?
    SIMPLE_TOKENS.include?(@scan_buffer.peek)
  end
  private :at_simple_token?

  def scan_simple_token
    @scan_buffer.take
  end
  private :scan_simple_token

  def scan_bare_string
    text = ""
    text << @scan_buffer.take while @scan_buffer.peek(1) =~ /[^\s\t\r\n\f(){}=;,]/
    return [:string, text]
  end
  private :scan_bare_string

  def self.tokenize(string)
    Lexer.new(string).tokenize
  end

end

end
