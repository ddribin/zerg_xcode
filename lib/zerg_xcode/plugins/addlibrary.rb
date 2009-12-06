# Adds a library target as a dependence to another Xcode target.
#
# Author:: Victor Costan
# Copyright:: Copyright (C) 2009 Zergling.Net
# License:: MIT

# :nodoc: namespace
module ZergXcode::Plugins


# Adds a library target as a dependence to another Xcode target.
class Addlibrary
  include ZergXcode::Objects
  
  def help
    {:short => 'adds a library to a target',
     :long => <<"END" }
Usage: addlibrary library_target target [path]

Adds a library as a dependency to a target, in the project at the given path.
If no path is given, looks for a project in the current directory.

library_target should be a static library. If library_target contains ObjectiveC
files, the "-ObjC" option is added to the target linker options.
END
  end
  
  def run(args)
    lib_target_name = args.shift
    target_name = args.shift
    project = ZergXcode.load(args.shift || '.')

    ad = "'zerg-xcode lstargets' can list project targets."
    unless lib_target = find_target(lib_target_name, project)
      print "#{lib_target_name} not found. #{ad}"
      return
    end
    unless target = find_target(target_name, project)      
      print "#{target_name} not found. #{ad}"
      return
    end

    add_library! lib_target, target, project
    project.save!
  end
  
  def find_target(name, project)
    project['targets'].find { |target| target['name'] == name }
  end
  
  # Adds a library to a project.
  def add_library!(library_target, target, project)
    add_target_dependency! library_target, target, project
    add_target_to_build_phases! library_target, target
    
    add_linker_option! '-ObjC', target if has_objc_files? target
  end
      
  # Adds a target as a dependency of another target.
  def add_target_dependency!(dependency, dependent, project)
    return if has_target_dependency? dependency, dependent
    dependent['dependencies'] << PBXTargetDependency.for(dependency, project)
  end
  
  # True if the given target is dependent on the other given target.
  def has_target_dependency?(dependency, target)
    target['dependencies'].any? do |dep|
      dep.kind_of?(PBXTargetDependency) && dep.target == dependency 
    end
  end

  # Adds a target to the build phases of another target.
  def add_target_to_build_phases!(dependency, dependent)
    return if has_target_in_build_phases? dependency, dependent
    
    # find or create the frameworks build phase
    frameworks_phase = dependent['buildPhases'].find do |phase|
      phase['isa'] == 'PBXFrameworksBuildPhase'
    end
    unless frameworks_phase
      frameworks_phase = PBXBuildPhase.new_phase 'PBXFrameworksBuildPhase'
      target['buildPhases'] << frameworks_phase
    end
    
    dep_file = dependency['productReference']
    frameworks_phase['files'] << PBXBuildFile.for(dep_file)
  end
  
  def has_target_in_build_phases?(dependency, dependent)
    frameworks_phase = dependent['buildPhases'].find do |phase|
      phase['isa'] == 'PBXFrameworksBuildPhase'
    end
    return false unless frameworks_phase
    
    frameworks_phase['files'].any? do |file|
      file['fileRef'] == dependency['productReference']
    end
  end
  
  # True if the target builds any objective C files.
  def has_objc_files?(target)
    target.all_files.any? do |file|
      file[:build_object].file_type == 'sourcecode.c.objc'
    end
  end
  
  # Adds a linker option to the given project.
  def add_linker_option!(option, target)
    key = 'OTHER_LDFLAGS' 
    target['buildConfigurationList']['buildConfigurations'].each do |config|
      config['buildSettings'] ||= {}
      settings = config['buildSettings']
      if settings[key]
        settings[key] = [settings[key]] if settings[key].kind_of? String
        settings[key] << option unless settings[key].include? option
      else
        settings[key] = option
      end
    end
  end
  
  # True if a target has the given linker option.
  def has_linker_option?(option, target)
    key = 'OTHER_LDFLAGS'
    target['buildConfigurationList']['buildConfigurations'].all? do |config|
      next false unless settings = config['buildSettings']
      setting = settings[key]
      setting && (setting == option ||
          (setting.kind_of?(Enumerable) && setting.include?(option)))
    end
  end
end  # class ZergXcode::Plugins::Addlibrary

end  # namespace ZergXcode::Plugins
