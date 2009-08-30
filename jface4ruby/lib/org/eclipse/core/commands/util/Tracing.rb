require "rjava"

# Copyright (c) 2005, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Core::Commands::Util
  module TracingImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Commands::Util
    }
  end
  
  # <p>
  # A utility class for printing tracing output to the console.
  # </p>
  # <p>
  # Clients must not extend or instantiate this class.
  # </p>
  # 
  # @since 3.2
  class Tracing 
    include_class_members TracingImports
    
    class_module.module_eval {
      # The separator to place between the component and the message.
      const_set_lazy(:SEPARATOR) { " >>> " }
      const_attr_reader  :SEPARATOR
      
      typesig { [String, String] }
      # $NON-NLS-1$
      # 
      # <p>
      # Prints a tracing message to standard out. The message is prefixed by a
      # component identifier and some separator. See the example below.
      # </p>
      # 
      # <pre>
      # BINDINGS &gt;&gt; There are 4 deletion markers
      # </pre>
      # 
      # @param component
      # The component for which this tracing applies; may be
      # <code>null</code>
      # @param message
      # The message to print to standard out; may be <code>null</code>.
      def print_trace(component, message)
        buffer = StringBuffer.new
        if (!(component).nil?)
          buffer.append(component)
        end
        if ((!(component).nil?) && (!(message).nil?))
          buffer.append(SEPARATOR)
        end
        if (!(message).nil?)
          buffer.append(message)
        end
        System.out.println(buffer.to_s)
      end
    }
    
    typesig { [] }
    # This class is not intended to be instantiated.
    def initialize
      # Do nothing.
    end
    
    private
    alias_method :initialize__tracing, :initialize
  end
  
end
