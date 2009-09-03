require "rjava"

# Copyright (c) 2000, 2005 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Templates
  module TemplateExceptionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Templates
    }
  end
  
  # Thrown when a template cannot be validated.
  # <p>
  # Clients may instantiate this class.
  # </p>
  # <p>
  # This class is not intended to be serialized.
  # </p>
  # 
  # @since 3.0
  class TemplateException < TemplateExceptionImports.const_get :JavaException
    include_class_members TemplateExceptionImports
    
    class_module.module_eval {
      # Serial version UID for this class.
      # <p>
      # Note: This class is not intended to be serialized.
      # </p>
      # @since 3.1
      const_set_lazy(:SerialVersionUID) { 3906362710416699442 }
      const_attr_reader  :SerialVersionUID
    }
    
    typesig { [] }
    # Creates a new template exception.
    def initialize
      super()
    end
    
    typesig { [String] }
    # Creates a new template exception.
    # 
    # @param message the message describing the problem that arose
    def initialize(message)
      super(message)
    end
    
    typesig { [String, JavaThrowable] }
    # Creates a new template exception.
    # 
    # @param message the message describing the problem that arose
    # @param cause the original exception
    def initialize(message, cause)
      super(message, cause)
    end
    
    typesig { [JavaThrowable] }
    # Creates a new template exception.
    # 
    # @param cause the original exception
    def initialize(cause)
      super(cause)
    end
    
    private
    alias_method :initialize__template_exception, :initialize
  end
  
end
