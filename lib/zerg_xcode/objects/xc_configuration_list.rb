# The configurations associated with an object.
#
# Author:: Victor Costan
# Copyright:: Copyright (C) 2009 Zergling.Net
# License:: MIT

# :nodoc: namespace
module ZergXcode::Objects


# The configurations associated with an object.
class XCConfigurationList < ZergXcode::XcodeObject
  # :nodoc: override xref_name because there's always a single list in a context
  def xref_name
    isa.to_s
  end
end  # class ZergXcode::Objects::XCConfigurationList

end  # namespace ZergXcode::Objects
