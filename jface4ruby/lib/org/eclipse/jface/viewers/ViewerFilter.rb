require "rjava"

# Copyright (c) 2000, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Viewers
  module ViewerFilterImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
      include_const ::Java::Util, :ArrayList
    }
  end
  
  # A viewer filter is used by a structured viewer to
  # extract a subset of elements provided by its content provider.
  # <p>
  # Subclasses must implement the <code>select</code> method
  # and may implement the <code>isFilterProperty</code> method.
  # </p>
  # @see IStructuredContentProvider
  # @see StructuredViewer
  class ViewerFilter 
    include_class_members ViewerFilterImports
    
    typesig { [] }
    # Creates a new viewer filter.
    def initialize
    end
    
    typesig { [Viewer, Object, Array.typed(Object)] }
    # Filters the given elements for the given viewer.
    # The input array is not modified.
    # <p>
    # The default implementation of this method calls
    # <code>select</code> on each element in the array,
    # and returns only those elements for which <code>select</code>
    # returns <code>true</code>.
    # </p>
    # @param viewer the viewer
    # @param parent the parent element
    # @param elements the elements to filter
    # @return the filtered elements
    def filter(viewer, parent, elements)
      size = elements.attr_length
      out = ArrayList.new(size)
      i = 0
      while i < size
        element = elements[i]
        if (select(viewer, parent, element))
          out.add(element)
        end
        (i += 1)
      end
      return out.to_array
    end
    
    typesig { [Viewer, TreePath, Array.typed(Object)] }
    # Filters the given elements for the given viewer.
    # The input array is not modified.
    # <p>
    # The default implementation of this method calls
    # {@link #filter(Viewer, Object, Object[])} with the
    # parent from the path. Subclasses may override
    # </p>
    # @param viewer the viewer
    # @param parentPath the path of the parent element
    # @param elements the elements to filter
    # @return the filtered elements
    # @since 3.2
    def filter(viewer, parent_path, elements)
      return filter(viewer, parent_path.get_last_segment, elements)
    end
    
    typesig { [Object, String] }
    # Returns whether this viewer filter would be affected
    # by a change to the given property of the given element.
    # <p>
    # The default implementation of this method returns <code>false</code>.
    # Subclasses should reimplement.
    # </p>
    # 
    # @param element the element
    # @param property the property
    # @return <code>true</code> if the filtering would be affected,
    # and <code>false</code> if it would be unaffected
    def is_filter_property(element, property)
      return false
    end
    
    typesig { [Viewer, Object, Object] }
    # Returns whether the given element makes it through this filter.
    # 
    # @param viewer the viewer
    # @param parentElement the parent element
    # @param element the element
    # @return <code>true</code> if element is included in the
    # filtered set, and <code>false</code> if excluded
    def select(viewer, parent_element, element)
      raise NotImplementedError
    end
    
    private
    alias_method :initialize__viewer_filter, :initialize
  end
  
end
