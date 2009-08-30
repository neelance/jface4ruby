require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Core::Runtime
  module CoreExceptionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Runtime
      include_const ::Java::Io, :PrintStream
      include_const ::Java::Io, :PrintWriter
      include_const ::Org::Eclipse::Core::Internal::Runtime, :PrintStackUtil
    }
  end
  
  # A checked exception representing a failure.
  # <p>
  # Core exceptions contain a status object describing the
  # cause of the exception.
  # </p><p>
  # This class can be used without OSGi running.
  # </p>
  # @see IStatus
  class CoreException < CoreExceptionImports.const_get :JavaException
    include_class_members CoreExceptionImports
    
    class_module.module_eval {
      # All serializable objects should have a stable serialVersionUID
      const_set_lazy(:SerialVersionUID) { 1 }
      const_attr_reader  :SerialVersionUID
    }
    
    # Status object.
    attr_accessor :status
    alias_method :attr_status, :status
    undef_method :status
    alias_method :attr_status=, :status=
    undef_method :status=
    
    typesig { [IStatus] }
    # Creates a new exception with the given status object.  The message
    # of the given status is used as the exception message.
    # 
    # @param status the status object to be associated with this exception
    def initialize(status)
      @status = nil
      super(status.get_message)
      @status = status
    end
    
    typesig { [] }
    # Returns the cause of this exception, or <code>null</code> if none.
    # 
    # @return the cause for this exception
    # @since 3.4
    def get_cause
      return @status.get_exception
    end
    
    typesig { [] }
    # Returns the status object for this exception.
    # <p>
    # <b>IMPORTANT:</b><br>
    # The result must NOT be used to log a <code>CoreException</code>
    # (e.g., using <code>yourPlugin.getLog().log(status);</code>),
    # since that code pattern hides the original stacktrace.
    # Instead, create a new {@link Status} with your plug-in ID and
    # this <code>CoreException</code>, and log that new status.
    # </p>
    # 
    # @return a status object
    def get_status
      return @status
    end
    
    typesig { [] }
    # Prints a stack trace out for the exception, and
    # any nested exception that it may have embedded in
    # its Status object.
    def print_stack_trace
      print_stack_trace(System.err)
    end
    
    typesig { [PrintStream] }
    # Prints a stack trace out for the exception, and
    # any nested exception that it may have embedded in
    # its Status object.
    # 
    # @param output the stream to write to
    def print_stack_trace(output)
      synchronized((output)) do
        super(output)
        PrintStackUtil.print_children(@status, output)
      end
    end
    
    typesig { [PrintWriter] }
    # Prints a stack trace out for the exception, and
    # any nested exception that it may have embedded in
    # its Status object.
    # 
    # @param output the stream to write to
    def print_stack_trace(output)
      synchronized((output)) do
        super(output)
        PrintStackUtil.print_children(@status, output)
      end
    end
    
    private
    alias_method :initialize__core_exception, :initialize
  end
  
end
