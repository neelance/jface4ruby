require "rjava"

# Copyright (c) 2000, 2007 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Viewers
  module IStructuredSelectionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :JavaList
    }
  end
  
  # A selection containing elements.
  module IStructuredSelection
    include_class_members IStructuredSelectionImports
    include ISelection
    
    typesig { [] }
    # Returns the first element in this selection, or <code>null</code>
    # if the selection is empty.
    # 
    # @return an element, or <code>null</code> if none
    def get_first_element
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns an iterator over the elements of this selection.
    # 
    # @return an iterator over the selected elements
    def iterator
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the number of elements selected in this selection.
    # 
    # @return the number of elements selected
    def size
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the elements in this selection as an array.
    # 
    # @return the selected elements as an array
    def to_array
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the elements in this selection as a <code>List</code>.
    # <strong>Note</strong> In the default implementation of {@link #toList()} in
    # {@link StructuredSelection} the returned list is not a copy of the elements of the
    # receiver and modifying it will modify the contents of the selection.
    # 
    # @return the selected elements as a list
    def to_list
      raise NotImplementedError
    end
  end
  
end
