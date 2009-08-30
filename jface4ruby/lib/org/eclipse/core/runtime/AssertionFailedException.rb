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
  module AssertionFailedExceptionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Runtime
    }
  end
  
  # <code>AssertionFailedException</code> is a runtime exception thrown
  # by some of the methods in <code>Assert</code>.
  # <p>
  # This class can be used without OSGi running.
  # </p><p>
  # This class is not intended to be instantiated or sub-classed by clients.
  # </p>
  # @see Assert
  # @since org.eclipse.equinox.common 3.2
  # @noextend This class is not intended to be subclassed by clients.
  # @noinstantiate This class is not intended to be instantiated by clients.
  class AssertionFailedException < AssertionFailedExceptionImports.const_get :RuntimeException
    include_class_members AssertionFailedExceptionImports
    
    class_module.module_eval {
      # All serializable objects should have a stable serialVersionUID
      const_set_lazy(:SerialVersionUID) { 1 }
      const_attr_reader  :SerialVersionUID
    }
    
    typesig { [String] }
    # Constructs a new exception with the given message.
    # 
    # @param detail the message
    def initialize(detail)
      super(detail)
    end
    
    private
    alias_method :initialize__assertion_failed_exception, :initialize
  end
  
end
