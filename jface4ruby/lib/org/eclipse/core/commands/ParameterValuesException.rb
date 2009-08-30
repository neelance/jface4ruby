require "rjava"

# Copyright (c) 2005 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Core::Commands
  module ParameterValuesExceptionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Commands
      include_const ::Org::Eclipse::Core::Commands::Common, :CommandException
    }
  end
  
  # <p>
  # Signals that a problem has occurred while trying to create an instance of
  # <code>IParameterValues</code>. In applications based on the registry
  # provided by core, this usually indicates a problem creating an
  # <code>IExecutableExtension</code>. For other applications, this exception
  # could be used to signify any general problem during initialization.
  # </p>
  # 
  # @since 3.1
  class ParameterValuesException < ParameterValuesExceptionImports.const_get :CommandException
    include_class_members ParameterValuesExceptionImports
    
    class_module.module_eval {
      # Generated serial version UID for this class.
      const_set_lazy(:SerialVersionUID) { 3618976793520845623 }
      const_attr_reader  :SerialVersionUID
    }
    
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
    alias_method :initialize__parameter_values_exception, :initialize
  end
  
end
