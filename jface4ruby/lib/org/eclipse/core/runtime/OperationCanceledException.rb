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
  module OperationCanceledExceptionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Runtime
    }
  end
  
  # This exception is thrown to blow out of a long-running method
  # when the user cancels it.
  # <p>
  # This class can be used without OSGi running.
  # </p><p>
  # This class is not intended to be subclassed by clients but
  # may be instantiated.
  # </p>
  class OperationCanceledException < OperationCanceledExceptionImports.const_get :RuntimeException
    include_class_members OperationCanceledExceptionImports
    
    class_module.module_eval {
      # All serializable objects should have a stable serialVersionUID
      const_set_lazy(:SerialVersionUID) { 1 }
      const_attr_reader  :SerialVersionUID
    }
    
    typesig { [] }
    # Creates a new exception.
    def initialize
      super()
    end
    
    typesig { [String] }
    # Creates a new exception with the given message.
    # 
    # @param message the message for the exception
    def initialize(message)
      super(message)
    end
    
    private
    alias_method :initialize__operation_canceled_exception, :initialize
  end
  
end
