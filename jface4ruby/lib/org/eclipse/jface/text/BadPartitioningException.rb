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
  module BadPartitioningExceptionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
    }
  end
  
  # Represents the attempt to refer to a non-existing document partitioning.
  # <p>
  # This class is not intended to be serialized.
  # </p>
  # 
  # @see org.eclipse.jface.text.IDocument
  # @see org.eclipse.jface.text.IDocumentExtension3
  # @since 3.0
  class BadPartitioningException < BadPartitioningExceptionImports.const_get :JavaException
    include_class_members BadPartitioningExceptionImports
    
    class_module.module_eval {
      # Serial version UID for this class.
      # <p>
      # Note: This class is not intended to be serialized.
      # </p>
      # @since 3.1
      const_set_lazy(:SerialVersionUID) { 3256439205327876408 }
      const_attr_reader  :SerialVersionUID
    }
    
    typesig { [] }
    # Creates a new bad partitioning exception.
    def initialize
      super()
    end
    
    typesig { [String] }
    # Creates a new bad partitioning exception.
    # 
    # @param message message describing the exception
    def initialize(message)
      super(message)
    end
    
    private
    alias_method :initialize__bad_partitioning_exception, :initialize
  end
  
end
