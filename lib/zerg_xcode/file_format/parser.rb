# Parser for flattened object graphs stored in .pbxproj files.
#
# Author:: Victor Costan
# Copyright:: Copyright (C) 2009 Zergling.Net
# License:: MIT

# :nodoc: namespace
module ZergXcode


# Parser for flattened object graphs stored in .xcodeproj files.
module Parser
  def self.parse(project_string)
    tokens = ZergXcode::Lexer.tokenize project_string
    
    stack = [[]]
    tokens.each do |token|
      case token
      when '('
        stack << Array.new
      when '{'
        stack << Hash.new
      when ')', '}'
        last_object = stack.pop
        if stack.last.kind_of? Array
          stack.last << last_object
        elsif stack.last.kind_of? String
          hash_key = stack.pop
          stack.last[hash_key] = last_object
        end
      when Array
        token_string = token.first
        if stack.last.kind_of? Hash
          stack << token_string
        elsif stack.last.kind_of? Array
          stack.last << token_string
        elsif stack.last.kind_of? String
          key = stack.pop
          stack.last[key] = token_string
        else
          p stack
          raise 'WTFed'
        end
      when '=', ';', ','
      else
        raise "Unknown token #{token}"
      end
    end
    return stack[0][0]
  end  
end

end
