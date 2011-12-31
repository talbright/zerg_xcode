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
    
    context = [[]]
    tokens.each do |token|
      case token
      when '('
        context << Array.new
      when '{'
        context << Hash.new
      when ')', '}'
        last_object = context.pop
        if context.last.kind_of? Array
          context.last << last_object
        elsif context.last.kind_of? String
          hash_key = context.pop
          context.last[hash_key] = last_object
        end
      when '=', ';', ','
        
      when Array
        token_string = token.first
        if context.last.kind_of? Hash
          context << token_string
        elsif context.last.kind_of? Array
          context.last << token_string
        elsif context.last.kind_of? String
          key = context.pop
          context.last[key] = token_string
        else
          p context
          raise 'WTFed'
        end
      else
        raise "Unknown token #{token}"
      end
    end
    return context[0][0]
  end  
end

end
