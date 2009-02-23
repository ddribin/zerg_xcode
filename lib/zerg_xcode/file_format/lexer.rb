module ZergXcode::Lexer
  def self.tokenize(string)
    
    encoding_match = string.match /^\/\/ \!\$\*(.*?)\*\$\!/
    raise "No encoding - #{string[0, 20]}" unless encoding_match
    
    i = encoding_match[0].length
    tokens = [[:encoding, encoding_match[1]]]
    while i < string.length
      # skip comments
      if string[i, 2] == '/*'
        i += 2
        i += 1 while string[i, 2] != '*/'
        i += 2
        next
      end
      
      case string[i, 1]
      when /\s/
        i += 1
      when '(', ')', '{', '}', '=', ';', ','
        tokens << {'(' => :begin_array, ')' => :end_array,
                   '{' => :begin_hash, '}' => :end_hash,
                   '=' => :assign, ';' => :stop, ',' => :comma}[string[i, 1]]
        i += 1
      when '"'
        # string
        i += 1
        token = ''
        while string[i, 1] != '"'
          if string[i, 1] == '\\'
            i += 1
            case string[i, 1]            
            when 'n', 'r', 't'
              token << { 'n' => "\n", 't' => "\t", 'r' => "\r" }[string[i, 1]]
              i += 1 
            when '"', "'", '\\'
              token << string[i]
              i += 1
            else
              raise "Uknown escape sequence \\#{string[i, 20]}"
            end
          else
            token << string[i]
            i += 1
          end
        end
        tokens << [:string, token]
        i += 1
      else
        # something
        len = 0
        len += 1 while /[^\s\t\r\n\f(){}=;,]/ =~ string[i + len, 1]
        tokens << [:symbol, string[i, len]]
        i += len
      end
    end
    return tokens
  end
end
