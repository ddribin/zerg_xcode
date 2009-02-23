module ZergXcode::Parser
  def self.parse(project_string)
    tokens = ZergXcode::Lexer.tokenize project_string
    
    context = [[]]
    last_token = nil
    tokens.each do |token|
      case token
      when :begin_array
        context << Array.new
      when :begin_hash
        context << Hash.new
      when :end_array, :end_hash
        last_object = context.pop
        if context.last.kind_of? Array
          context.last << last_object
        elsif context.last.kind_of? String
          hash_key = context.pop
          context.last[hash_key] = last_object
        end
      when :assign, :stop, :comma
        
      when Array
        case token.first
        when :encoding
        when :string, :symbol
          token_string = token.last
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
        end        
      else
        raise "Unknown token #{token}"
      end
    end
    return context[0][0]
  end  
end
