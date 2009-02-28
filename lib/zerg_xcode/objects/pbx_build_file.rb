# A file used for building. Points to a PBXFileRef.
class ZergXcode::Objects::PBXBuildFile < ZergXcode::XcodeObject
  # The name of the referenced file.
  def filename
    self['fileRef']['path']
  end
  
  # The type of the referenced file.
  def file_type
    self['fileRef']['explicitFileType'] || self['fileRef']['lastKnownFileType']
  end
  
  # Guesses the type of the build phase that this file should belong to.
  # This can be useful when figuring out which build phase to add a file to.
  def guessed_build_phase_type
    case file_type
    when /\.h$/
      return 'PBXHeadersBuildPhase'
    when /^sourcecode/
      return 'PBXSourcesBuildPhase'
    when /\.framework$/, /\.ar$/
      return 'PBXFrameworksBuildPhase'
    else
      return 'PBXResourcesBuildPhase'
    end
  end
  
  # Creates a build file for the given file reference.
  def self.for(file_ref)
    self.new 'fileRef' => file_ref
  end
  
  # :nodoc: override xref_name to borrow the referenced object's name
  def xref_name
    self['fileRef'].xref_name
  end  
end
