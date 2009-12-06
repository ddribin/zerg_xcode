# The superclass for all the phases of the Xcode build process.
#
# Author:: Victor Costan
# Copyright:: Copyright (C) 2009 Zergling.Net
# License:: MIT

# :nodoc: namespace
module ZergXcode::Objects


# Superclass for all the Xcode build phases.
#
# Subclasses include PBXHeadersBuildPhase, PBXSourcesBuildPhase,
# PBXFrameworksBuildPhase, and PBXResourcesBuildPhase.
class PBXBuildPhase < ZergXcode::XcodeObject  
  # Creates a new build phase with the given isa type.
  def self.new_phase(isa_type)
    self.new 'isa' => isa_type.to_s, 'dependencies' => [], 'files' => [],
             'buildActionMask' => '2147483647',
             'runOnlyForDeploymentPostprocessing' => '0' 
  end
end  # class ZergXcode::Objects::PBXBuildPhase

end  # namespace ZergXcode::Objects
