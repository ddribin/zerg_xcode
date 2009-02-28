# The configurations associated with an object.
class ZergXcode::Objects::XCConfigurationList < ZergXcode::XcodeObject
  # :nodoc: override xref_name because there's always a single list in a context
  def xref_name
    isa.to_s
  end
end
