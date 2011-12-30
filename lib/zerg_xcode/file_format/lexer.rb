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
    @string = string
    @i = 0
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
    if @i == 0
      encoding_match = @string.match(/^\/\/ \!\$\*(.*?)\*\$\!/)
      raise "No encoding - #{@string[0, 20]}" unless encoding_match
      
      @i = encoding_match[0].length
      return [:encoding, encoding_match[1]]
    end

    while @i < @string.length
      # skip comments
      if @string[@i, 2] == '/*'
        @i += 2
        @i += 1 while @string[@i, 2] != '*/'
        @i += 2
        next
      end
      
      case @string[@i, 1]
      when /\s/
        @i += 1
      when '(', ')', '{', '}', '=', ';', ','
        token = {'(' => :begin_array, ')' => :end_array,
                 '{' => :begin_hash, '}' => :end_hash,
                 '=' => :assign, ';' => :stop, ',' => :comma}[@string[@i, 1]]
        @i += 1
        return token
      when '"'
        # string
        @i += 1
        token = ''
        while @string[@i, 1] != '"'
          if @string[@i, 1] == '\\'
            @i += 1
            case @string[@i, 1]            
            when 'n', 'r', 't'
              token << { 'n' => "\n", 't' => "\t", 'r' => "\r" }[@string[@i, 1]]
              @i += 1 
            when '"', "'", '\\'
              token << @string[@i]
              @i += 1
            else
              raise "Uknown escape sequence \\#{@string[@i, 20]}"
            end
          else
            token << @string[@i]
            @i += 1
          end
        end
        @i += 1
        return [:string, token]
      else
        # something
        len = 0
        len += 1 while /[^\s\t\r\n\f(){}=;,]/ =~ @string[@i + len, 1]
        token = [:symbol, @string[@i, len]]
        @i += len
        return token
      end
    end
  end
  private :next_token

  def self.tokenize(string)
    Lexer.new(string).tokenize
  end

end

end
