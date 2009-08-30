require "rjava"

# Copyright (c) 2005, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Core::Commands
  module ParameterValueConversionExceptionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Commands
      include_const ::Org::Eclipse::Core::Commands::Common, :CommandException
    }
  end
  
  # Signals that a problem occurred while converting a command parameter value
  # from string to object, or object to string.
  # 
  # @see AbstractParameterValueConverter
  # @since 3.2
  class ParameterValueConversionException < ParameterValueConversionExceptionImports.const_get :CommandException
    include_class_members ParameterValueConversionExceptionImports
    
    class_module.module_eval {
      # Generated serial version UID for this class.
      const_set_lazy(:SerialVersionUID) { 4703077729505066104 }
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
    alias_method :initialize__parameter_value_conversion_exception, :initialize
  end
  
end
