module Plugins; end
  
module Plugins::TestHelper
  # Captures output produced with print.
  def capture_output
    begin
      output = ""
      Kernel.class_eval do
        alias_method :no_print_for_now, :print
        define_method(:print) { |*args| output << args.join }
      end      
      yield
      return output
    ensure
      Kernel.class_eval do
        alias_method :print, :no_print_for_now
        undef no_print_for_now
      end
    end
  end
end
