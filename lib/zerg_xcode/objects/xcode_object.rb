# Xcode objects
class ZergXcode::XcodeObject
  attr_accessor :version
  attr_accessor :archive_id
  
  # Hash-like behavior
  
  def [](key)
    @attrs[key]
  end
  
  def []=(key, value)
    @attrs[key] = value
  end
  
  # Inheritance based on isa
  
  def initialize(hash)
    @attrs = hash
    if self.class != ZergXcode::XcodeObject
      class_name = self.class.name
      @attrs['isa'] ||= class_name[(class_name.rindex(':') + 1)..-1]
    end
  end
  
  def self.new(*args)
    return super unless self == ZergXcode::XcodeObject
    if hash_isa = args.first['isa']
      classes = ZergXcode::Objects.constants
      if classes.include? hash_isa
        return ZergXcode::Objects.const_get(hash_isa).new(*args)
      end
    end
    super
  end  
  
  # Inspecting the object

  # The names of the object's attributes. 
  def attrs
    @attrs.keys
  end

  # The (internal) hash holding the file's attributes.
  def _attr_hash
    @attrs
  end
  
  # Object type helpers  
  def isa
    return @attrs['isa'].to_sym
  end
  
  # Visitor pattern
  
  # Visits an object's internal structure.
  #
  # The given block is called like this:
  #   yield object, parent, key, value
  # Where
  #   object: the object currently visited (can be a sub-object)
  #   parent: the collection currently visited (an object, hash, or array)
  #   key: 
  #   value:
  # The block can return
  #   false: no recursive visiting for the given value
  #   true: normal recursive visiting for the given value
  #   something else: replace the given value with the return, the recursive
  #                   visiting is done on the new value
  def visit(&accept)
    visit_hash(@attrs, &accept)
    self
  end
  
  # Convenience method mapping over visit and exploring each object once.
  def visit_once(&accept)
    visited = Set.new([self])
    self.visit do |object, parent, key, value|
      visited << object
      next_value = yield object, parent, key, value
      visited.include?(value) ? false : next_value
    end
  end

  def visit_hash(hash, &accept)
    hash.each_key do |key|
      visit_value(hash, key, hash[key], &accept)
    end
    hash
  end
  
  def visit_array(array, &accept)
    array.each_with_index do |value, index|
      visit_value(array, index, value, &accept)
    end
    array
  end
  
  def visit_value(parent, key, value, &accept)
    visit_parent = (parent == @attrs) ? self : parent
    recurse = yield self, visit_parent, key, value
    return if recurse == false
    
    if recurse != true
      value = recurse
      parent[key] = recurse
    end
    
    case value
    when ZergXcode::XcodeObject
      value.visit(&accept)
    when Hash
      visit_hash(value, &accept)
    when Array
      visit_array(value, &accept)
    end
    value    
  end

  # Graph navigating and cross-referencing.

  # Key used for cross-referencing objects in different graphs. If two objects
  # in different graphs have the same key, it is very likely that they represent
  # the same entity.
  def xref_key
    # If the object doesn't have a merge name, use its (unique) object_id.
    [isa, xref_name || object_id]
  end

  # Name used in referencing an object.
  # 
  # An object's name should be unique among objects in the same context. For
  # instance, objects in the same array (e.g. 'children' in a PBXGroup) should
  # have distinct names.
  def xref_name
    # Do not use this to override xref_name for specific objects. Only use
    # it for object families.
    case isa.to_s
    when /BuildPhase$/
      isa.to_s
    else
      self['name'] || self['explicitPath'] || self['path'] 
    end
  end  
  
    
  # Deep copy
  def self.from(object_or_hash)
    new_object = case object_or_hash
    when ZergXcode::XcodeObject
      object_or_hash.shallow_copy
    else
      self.new object_or_hash.dup
    end
    object_map = { object_or_hash => new_object }
    
    new_object.visit do |object, parent, key, value|
      case value
      when Hash, Array
        next value.dup
      when ZergXcode::XcodeObject
        if object_map[value]
          parent[key] = object_map[value]
          next false
        else
          object_map[value] = value.shallow_copy
          next object_map[value]
        end
      else
        next true
      end
    end
  end
  
  def shallow_copy
    new_object = self.class.new @attrs.dup
    new_object.copy_metadata self
    return new_object
  end
  
  def copy_metadata(source)
    self.archive_id, self.version = source.archive_id, source.version 
  end  
    
end

