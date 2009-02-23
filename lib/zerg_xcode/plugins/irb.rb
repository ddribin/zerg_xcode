require 'irb'

class ZergXcode::Plugins::Irb
  def help
    {:short => 'opens up a project in an interactive ruby shell',
     :long => <<"END" }
Usage: irb [path]

Loads the object graph in the Xcode project at the given path. If no path is
given, looks for a project in the current directory. The project object is
available as the global variable $p.
END
  end
  
  def run(args)
    $p = ZergXcode.load(args.shift || '.')
    
    print "This is an IRB shell. Your project is available as $p.\n" + 
          "Use the 'quit' command if you're here by mistake.\n"
    IRB.start __FILE__
  end
end
