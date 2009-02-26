# Proxy for another object.
#
# Unsure these are useful, since each object has an unique ID. They are probably
# implementation artifacts.
class ZergXcode::Objects::PBXContainerItemProxy < ZergXcode::XcodeObject
  # The proxied object.
  def target
    self['remoteGlobalIDString']
  end
end
