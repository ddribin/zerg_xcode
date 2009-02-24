class ZergXcode::Plugins::Import
  def help
    {:short => 'imports the objects from a project into another project',
     :long => <<"END" }
Usage: import source_path [target_path]

Imports the objects (build targets, files) from a source project into another
target project. Useful when the source project wraps code that can be used as a
library.
END
  end
  
  def run(args)
    source = ZergXcode.load args.shift
    target = ZergXcode.load(args.shift || '.')
    
    print "Import is not yet implemented."
  end
end
