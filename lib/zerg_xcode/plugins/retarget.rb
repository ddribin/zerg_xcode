# Adds files to a build target, and removes them from all the other targets.
#
# Author:: Victor Costan
# Copyright:: Copyright (C) 2009 Zergling.Net
# License:: MIT

# :nodoc: namespace
module ZergXcode::Plugins


# Adds files to a build target, and removes them from all the other targets.
class Retarget
  include ZergXcode::Objects
  
  def help
    {:short => 'reassign files to a target or set of targets',
     :long => <<"END" }
Usage: retarget project_path pattern [target target..]

Reassigns all the files matching a pattern to a target or set of targets. The
files matching the pattern will be removed from all other targets. If no target
is specified, the files are removed from all targets.
END
  end
  
  def run(args)
    path = args.shift
    pattern = args.shift
    regexp = Regexp.compile pattern
    project = ZergXcode.load path
    retarget! project, regexp, args
    project.save!
  end
  
  def retarget!(project, regexp, targets)
    # maps each file type to the type of the phase it's in
    file_type_phases = {}
    # maps each file to the phase it's in
    file_phases = {}
    # maps each PBXFileRef to the PBXBuildFile pointing to it
    build_files = {}
    
    # populate the maps
    project['targets'].each do |target|
      target.all_files.each do |file|
        build_file = file[:build_object]
        phase_type = file[:phase]['isa']
        build_files[file[:object]] = build_file
        file_type_phases[build_file.file_type] = phase_type
        file_phases[file[:object]] = phase_type
      end
    end
    
    # compute target sets
    in_targets = project['targets'].select do |target|
      targets.include? target['name']
    end
    out_targets = project['targets'] - in_targets
    
    # clean up targets outside the args
    out_targets.each do |target|
      target['buildPhases'].each do |phase|
        phase['files'].reject! { |build_file| regexp =~ build_file.filename }
      end
    end

    # build a list of the files in the project matching the pattern
    new_files = project.all_files.map { |file| file[:object] }.select do |file|
      regexp =~ file['path']
    end
    # build PBXBuildFile wrappers around files that don't have them
    new_files.each do |file|
      next if build_files[file]
      
      build_file = PBXBuildFile.new 'fileRef' => file
      build_files[file] = build_file
      file_phases[file] = file_type_phases[build_file.file_type] ||
          build_file.guessed_build_phase_type
    end
    
    # add files to targets matching the args
    in_targets.each do |target|
      already_in = Set.new(target.all_files.map { |file| file[:object] })      
      new_files.each do |file|
        file_ref = file[:object]
        next if already_in.include? file
        phase_type = file_phases[file]
        phase = target['buildPhases'].find { |p| p['isa'] ==  phase_type }
        unless phase
          phase = PBXBuildPhase.new_phase phase_type
          target['buildPhases'] << phase
        end
        phase['files'] << build_files[file]
      end
    end
  end
end  # class ZergXcode::Plugins::Retarget

end  # namespace ZergXcode::Plugins
