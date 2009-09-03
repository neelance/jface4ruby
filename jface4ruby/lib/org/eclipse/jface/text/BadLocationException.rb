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
  module BadLocationExceptionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
    }
  end
  
  # Indicates the attempt to access a non-existing position. The attempt has been
  # performed on a text store such as a document or string.
  # <p>
  # This class is not intended to be serialized.
  # </p>
  class BadLocationException < BadLocationExceptionImports.const_get :JavaException
    include_class_members BadLocationExceptionImports
    
    class_module.module_eval {
      # Serial version UID for this class.
      # <p>
      # Note: This class is not intended to be serialized.
      # </p>
      # @since 3.1
      const_set_lazy(:SerialVersionUID) { 3257281452776370224 }
      const_attr_reader  :SerialVersionUID
    }
    
    typesig { [] }
    # Creates a new bad location exception.
    def initialize
      super()
    end
    
    typesig { [String] }
    # Creates a new bad location exception.
    # 
    # @param message the exception message
    def initialize(message)
      super(message)
    end
    
    private
    alias_method :initialize__bad_location_exception, :initialize
  end
  
end
