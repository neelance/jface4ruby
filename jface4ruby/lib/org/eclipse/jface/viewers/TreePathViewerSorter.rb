require "rjava"

# Copyright (c) 2006, 2007 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Viewers
  module TreePathViewerSorterImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
      include_const ::Java::Util, :Arrays
      include_const ::Java::Util, :Comparator
    }
  end
  
  # A viewer sorter that is provided extra context in the form of the path of the
  # parent element of the elements being sorted.
  # 
  # @since 3.2
  class TreePathViewerSorter < TreePathViewerSorterImports.const_get :ViewerSorter
    include_class_members TreePathViewerSorterImports
    
    typesig { [TreePath, Object] }
    # Provide a category for the given element that will have the given parent
    # path when it is added to the viewer. The provided path is
    # relative to the viewer input. The parent path will
    # be <code>null</code> when the elements are root elements.
    # <p>
    # By default, the this method calls
    # {@link ViewerSorter#category(Object)}. Subclasses may override.
    # 
    # @param parentPath
    # the parent path for the element
    # @param element
    # the element
    # @return the category of the element
    def category(parent_path, element)
      return category(element)
    end
    
    typesig { [Viewer, TreePath, Object, Object] }
    # Compare the given elements that will have the given parent
    # path when they are added to the viewer. The provided path is
    # relative to the viewer input. The parent path will
    # be <code>null</code> when the elements are root elements.
    # <p>
    # By default, the this method calls
    # {@link ViewerSorter#sort(Viewer, Object[])}. Subclasses may override.
    # @param viewer the viewer
    # @param parentPath the parent path for the two elements
    # @param e1 the first element
    # @param e2 the second element
    # @return a negative number if the first element is less  than the
    # second element; the value <code>0</code> if the first element is
    # equal to the second element; and a positive
    def compare(viewer, parent_path, e1, e2)
      return compare(viewer, e1, e2)
    end
    
    typesig { [TreePath, Object, String] }
    # Returns whether this viewer sorter would be affected
    # by a change to the given property of the given element.
    # The provided path is
    # relative to the viewer input. The parent path will
    # be <code>null</code> when the elements are root elements.
    # <p>
    # The default implementation of this method calls
    # {@link ViewerSorter#isSorterProperty(Object, String)}.
    # Subclasses may reimplement.
    # @param parentPath the parent path of the element
    # @param element the element
    # @param property the property
    # @return <code>true</code> if the sorting would be affected,
    # and <code>false</code> if it would be unaffected
    def is_sorter_property(parent_path, element, property)
      return is_sorter_property(element, property)
    end
    
    typesig { [Viewer, TreePath, Array.typed(Object)] }
    # Sorts the given elements in-place, modifying the given array.
    # The provided path is
    # relative to the viewer input. The parent path will
    # be <code>null</code> when the elements are root elements.
    # <p>
    # The default implementation of this method uses the
    # java.util.Arrays#sort algorithm on the given array,
    # calling {@link #compare(Viewer, TreePath, Object, Object)} to compare elements.
    # </p>
    # <p>
    # Subclasses may reimplement this method to provide a more optimized implementation.
    # </p>
    # 
    # @param viewer the viewer
    # @param parentPath the parent path of the given elements
    # @param elements the elements to sort
    def sort(viewer, parent_path, elements)
      Arrays.sort(elements, Class.new(Comparator.class == Class ? Comparator : Object) do
        extend LocalClass
        include_class_members TreePathViewerSorter
        include Comparator if Comparator.class == Module
        
        typesig { [Object, Object] }
        define_method :compare do |a, b|
          return @local_class_parent.compare(viewer, parent_path, a, b)
        end
        
        typesig { [Object] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
    end
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__tree_path_viewer_sorter, :initialize
  end
  
end
