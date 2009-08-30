require "rjava"

# Copyright (c) 2004, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Core::Commands
  module SerializationExceptionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Commands
      include_const ::Org::Eclipse::Core::Commands::Common, :CommandException
    }
  end
  
  # Signals that an exception occured while serializing a
  # {@link ParameterizedCommand} to a string or deserializing a String to a
  # {@link ParameterizedCommand}.
  # <p>
  # This class is not intended to be extended by clients.
  # </p>
  # 
  # @since 3.2
  class SerializationException < SerializationExceptionImports.const_get :CommandException
    include_class_members SerializationExceptionImports
    
    class_module.module_eval {
      # Generated serial version UID for this class.
      const_set_lazy(:SerialVersionUID) { 2691599674561684949 }
      const_attr_reader  :SerialVersionUID
    }
    
    typesig { [String] }
    # Creates a new instance of this class with the specified detail message.
    # 
    # @param message
    # the detail message; may be <code>null</code>.
    def initialize(message)
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
      super(message, cause)
    end
    
    private
    alias_method :initialize__serialization_exception, :initialize
  end
  
end
