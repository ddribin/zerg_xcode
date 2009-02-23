module ZergXcode::Encoder  
  def self.encode(project)
    "// !$*UTF8*$!\n" + encode_hash(project, 0) + "\n"
  end

  def self.encode_hash(hash, indentation)
    "{\n" + hash.map { |key, value|
      encode_indentation(indentation + 1) + 
      encode_value(key, indentation + 1) + " = " +
      encode_object(value, indentation + 1) + ";\n"
    }.join + encode_indentation(indentation) + "}"
  end
  
  def self.encode_object(object, indentation)
    case object
    when Hash
      encode_hash object, indentation
    when Array
      encode_array object, indentation
    when String
      encode_value object, indentation
    end
  end

  def self.encode_array(array, indentation)
    "(\n" + array.map { |value|
      encode_indentation(indentation + 1) +
      encode_object(value, indentation + 1) + ",\n"
    }.join + encode_indentation(indentation) + ")"
  end
  
  def self.encode_value(value, indentation)
    # This escapes what needs to be escaped.
    value.to_s.inspect
  end
  
  def self.encode_indentation(indentation)
    "\t" * indentation
  end
end
