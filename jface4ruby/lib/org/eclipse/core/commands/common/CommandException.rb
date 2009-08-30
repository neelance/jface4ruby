require "rjava"

# Copyright (c) 2004, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Core::Commands::Common
  module CommandExceptionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Commands::Common
    }
  end
  
  # Signals that an exception occured within the command architecture.
  # <p>
  # This class is not intended to be extended by clients.
  # </p>
  # 
  # @since 3.1
  # @noextend This class is not intended to be subclassed by clients.
  class CommandException < CommandExceptionImports.const_get :JavaException
    include_class_members CommandExceptionImports
    
    class_module.module_eval {
      # Generated serial version UID for this class.
      # 
      # @since 3.4
      const_set_lazy(:SerialVersionUID) { 5389763628699257234 }
      const_attr_reader  :SerialVersionUID
    }
    
    # This member variable is required here to allow us to compile against JCL
    # foundation libraries.  The value may be <code>null</code>.
    attr_accessor :cause
    alias_method :attr_cause, :cause
    undef_method :cause
    alias_method :attr_cause=, :cause=
    undef_method :cause=
    
    typesig { [String] }
    # Creates a new instance of this class with the specified detail message.
    # 
    # @param message
    # the detail message; may be <code>null</code>.
    def initialize(message)
      @cause = nil
      super(message)
    end
    
    typesig { [String, JavaThrowable] }
    # Creates a new instance of this class with the specified detail message
    # and cause.
    # 
    # @param message
    # the detail message; may be <code>null</code>.
    # @param cause
    # the cause; may be <code>null</code>.
    def initialize(message, cause)
      @cause = nil
      super(message)
      # don't pass the cause to super, to allow compilation against JCL Foundation
      @cause = cause
    end
    
    typesig { [] }
    # Returns the cause of this throwable or <code>null</code> if the
    # cause is nonexistent or unknown.
    # 
    # @return the cause or <code>null</code>
    def get_cause
      return @cause
    end
    
    private
    alias_method :initialize__command_exception, :initialize
  end
  
end
