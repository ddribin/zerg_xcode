# Proxy for another object.
#
# Unsure these are useful, since each object has an unique ID. They are probably
# implementation artifacts.
class ZergXcode::Objects::PBXContainerItemProxy < ZergXcode::XcodeObject
  # The proxied object.
  def target
    self['remoteGlobalIDString']
  end
  
  # Creates a proxy for an object in the same graph, using the given container.
  #
  # Usually, the container is the project.
  def self.for(object, container)
    self.new 'proxyType' => '1', 'containerPortal' => container,
             'remoteInfo' => object.xref_name, 'remoteGlobalIDString' => object
  end
  
  # :nodoc: override xref_name because Xcode gives us a name in remoteInfo
  def xref_name
    self['remoteInfo']
  end  
end
