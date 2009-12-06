# An Xcode build target.
#
# Author:: Victor Costan
# Copyright:: Copyright (C) 2009 Zergling.Net
# License:: MIT

# :nodoc: namespace
module ZergXcode::Objects


# An Xcode build target.
class PBXNativeTarget < ZergXcode::XcodeObject
  # All the files referenced by this target.
  # Returns:
  #   an array containing a hash for each file with
  #     :phase - the build phase referencing the file
  #     :build_object - the build object referencing the file
  #     :object - the file object
  def all_files
    files = []
    self['buildPhases'].each do |phase|
      phase['files'].each do |build_file|
        files << { :phase => phase, :build_object => build_file,
                   :object => build_file['fileRef'] }
      end
    end
    files
  end
end  # class ZergXcode::Objects::PBXNativeTarget

end  # namespace class ZergXcode::Objects
