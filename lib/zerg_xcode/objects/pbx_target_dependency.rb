# Expresses a target's dependency on another target.
class ZergXcode::Objects::PBXTargetDependency < ZergXcode::XcodeObject
  # The target that this target depends on.
  def target
    self['target']
  end
end
