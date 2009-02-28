# Superclass for all the Xcode build phases.
#
# Subclasses include PBXHeadersBuildPhase, PBXSourcesBuildPhase,
# PBXFrameworksBuildPhase, and PBXResourcesBuildPhase.
class ZergXcode::Objects::PBXBuildPhase < ZergXcode::XcodeObject  
  # Creates a new build phase with the given isa type.
  def self.new_phase(isa_type)
    self.new 'isa' => isa_type.to_s, 'dependencies' => [], 'files' => [],
             'buildActionMask' => '2147483647',
             'runOnlyForDeploymentPostprocessing' => '0' 
  end
end
