class ZergXcode::Plugins::Lstargets
  def help
    {:short => 'shows the targets in a project',
     :long => <<"END" }
Usage: ls [path]

Lists all the targets in the project at the given path. If no path is given,
looks for a project in the current directory.
END
  end
  
  def run(args)
    list = list_for(args.shift || '.')
    output = ""
    list.each do |entry|
      type_match = /^com\.apple\.product\-type\.(.*)$/.match entry[2]
      target_type = type_match ? type_match[1] : entry[2]
      output << "%-20s %s > %s\n" % [target_type, entry[0], entry[1]]
    end
    print output
    output
  end
  
  def list_for(project_name)    
    ZergXcode.load(project_name)['targets'].map do |target|
      [target['name'], target['productName'], target['productType']]
    end
  end  
end
