require "rjava"

# Copyright (c) 2008, 2009 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Core::Internal::Runtime
  module PrintStackUtilImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Internal::Runtime
      include_const ::Java::Io, :PrintStream
      include_const ::Java::Io, :PrintWriter
      include_const ::Org::Eclipse::Core::Runtime, :IStatus
    }
  end
  
  class PrintStackUtil 
    include_class_members PrintStackUtilImports
    
    class_module.module_eval {
      typesig { [IStatus, PrintStream] }
      def print_children(status, output)
        children = status.get_children
        if ((children).nil? || (children.attr_length).equal?(0))
          return
        end
        i = 0
        while i < children.attr_length
          output.println("Contains: " + RJava.cast_to_string(children[i].get_message)) # $NON-NLS-1$
          exception = children[i].get_exception
          if (!(exception).nil?)
            exception.print_stack_trace(output)
          end
          print_children(children[i], output)
          i += 1
        end
      end
      
      typesig { [IStatus, PrintWriter] }
      def print_children(status, output)
        children = status.get_children
        if ((children).nil? || (children.attr_length).equal?(0))
          return
        end
        i = 0
        while i < children.attr_length
          output.println("Contains: " + RJava.cast_to_string(children[i].get_message)) # $NON-NLS-1$
          output.flush # call to synchronize output
          exception = children[i].get_exception
          if (!(exception).nil?)
            exception.print_stack_trace(output)
          end
          print_children(children[i], output)
          i += 1
        end
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__print_stack_util, :initialize
  end
  
end
