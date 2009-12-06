# Logic for the multiple SDKs in an Xcode installation. 
#
# Author:: Victor Costan
# Copyright:: Copyright (C) 2009 Zergling.Net
# License:: MIT

# :nodoc: namespace
module ZergXcode::Builder


# Logic for the multiple SDKs in an Xcode installation. 
module Sdk
  @all = nil
  
  # All the SDKs installed.
  def self.all
    return @all if @all
    
    output = `xcodebuild -showsdks`
    @all = []
    group = ''
    output.each_line do |line|
      if line.index '-sdk '
        name, arg = *line.split('-sdk ').map { |token| token.strip }
        @all << { :group => group, :name => name, :arg => arg }
      elsif line.index ':'
        group = line.split(':').first.strip
      end
    end
    @all
  end
end  # module ZergXcode::Builder::Sdk

end  # namespace ZergXcode::Builder
