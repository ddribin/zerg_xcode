# A build target's dependency on another build target.
#
# Author:: Victor Costan
# Copyright:: Copyright (C) 2009 Zergling.Net
# License:: MIT

# :nodoc: namespace
module ZergXcode::Objects


# Expresses a build target's dependency on another build target.
class PBXTargetDependency < ZergXcode::XcodeObject
  PBXContainerItemProxy = ZergXcode::Objects::PBXContainerItemProxy
  
  # The target that this target depends on.
  def target
    self['target']
  end
  
  # Creates a new dependency on the given target
  def self.for(target, project)
    self.new 'target' => target,
             'targetProxy' => PBXContainerItemProxy.for(target, project)
  end

  # :nodoc: override xref_name to use the name of the target in the dependency
  def xref_name
    target.xref_name
  end
end  # class ZergXcode::Objects::PBXTargetDependency

end  # namespace ZergXcode::Objects
