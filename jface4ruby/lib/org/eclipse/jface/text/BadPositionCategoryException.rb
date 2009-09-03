require "rjava"

# Copyright (c) 2000, 2005 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text
  module BadPositionCategoryExceptionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
    }
  end
  
  # Indicates the attempt to access a non-existing position
  # category in a document.
  # <p>
  # This class is not intended to be serialized.
  # </p>
  # 
  # @see org.eclipse.jface.text.IDocument
  class BadPositionCategoryException < BadPositionCategoryExceptionImports.const_get :JavaException
    include_class_members BadPositionCategoryExceptionImports
    
    class_module.module_eval {
      # Serial version UID for this class.
      # <p>
      # Note: This class is not intended to be serialized.
      # </p>
      # @since 3.1
      const_set_lazy(:SerialVersionUID) { 3761405300745713206 }
      const_attr_reader  :SerialVersionUID
    }
    
    typesig { [] }
    # Creates a new bad position category exception.
    def initialize
      super()
    end
    
    typesig { [String] }
    # Creates a new bad position category exception.
    # 
    # @param message the exception's message
    def initialize(message)
      super(message)
    end
    
    private
    alias_method :initialize__bad_position_category_exception, :initialize
  end
  
end
