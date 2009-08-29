require "rjava"

# Copyright (c) 2000, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Resource
  module DataFormatExceptionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Resource
    }
  end
  
  # An exception indicating that a string value could not be
  # converted into the requested data type.
  # 
  # @see StringConverter
  class DataFormatException < DataFormatExceptionImports.const_get :IllegalArgumentException
    include_class_members DataFormatExceptionImports
    
    class_module.module_eval {
      # Generated serial version UID for this class.
      # @since 3.1
      const_set_lazy(:SerialVersionUID) { 3544955467404031538 }
      const_attr_reader  :SerialVersionUID
    }
    
    typesig { [] }
    # Creates a new exception.
    def initialize
      super()
    end
    
    typesig { [String] }
    # Creates a new exception.
    # 
    # @param message the message
    def initialize(message)
      super(message)
    end
    
    private
    alias_method :initialize__data_format_exception, :initialize
  end
  
end
