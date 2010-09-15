require "rjava"

# Copyright (c) 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Viewers
  module ViewerComparatorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
      include_const ::Java::Util, :Arrays
      include_const ::Java::Util, :Comparator
      include_const ::Org::Eclipse::Jface::Util, :Policy
    }
  end
  
  # A viewer comparator is used by a {@link StructuredViewer} to
  # reorder the elements provided by its content provider.
  # <p>
  # The default <code>compare</code> method compares elements using two steps.
  # The first step uses the values returned from <code>category</code>.
  # By default, all elements are in the same category.
  # The second level is based on a case insensitive compare of the strings obtained
  # from the content viewer's label provider via <code>ILabelProvider.getText</code>.
  # </p>
  # <p>
  # Subclasses may implement the <code>isSorterProperty</code> method;
  # they may reimplement the <code>category</code> method to provide
  # categorization; and they may override the <code>compare</code> methods
  # to provide a totally different way of sorting elements.
  # </p>
  # @see IStructuredContentProvider
  # @see StructuredViewer
  # 
  # @since 3.2
  class ViewerComparator 
    include_class_members ViewerComparatorImports
    
    # The comparator to use to sort a viewer's contents.
    attr_accessor :comparator
    alias_method :attr_comparator, :comparator
    undef_method :comparator
    alias_method :attr_comparator=, :comparator=
    undef_method :comparator=
    
    typesig { [] }
    # Creates a new {@link ViewerComparator}, which uses the default comparator
    # to sort strings.
    def initialize
      initialize__viewer_comparator(nil)
    end
    
    typesig { [Comparator] }
    # Creates a new {@link ViewerComparator}, which uses the given comparator
    # to sort strings.
    # 
    # @param comparator
    def initialize(comparator)
      @comparator = nil
      @comparator = comparator
    end
    
    typesig { [] }
    # Returns the comparator used to sort strings.
    # 
    # @return the comparator used to sort strings
    def get_comparator
      if ((@comparator).nil?)
        @comparator = Policy.get_comparator
      end
      return @comparator
    end
    
    typesig { [Object] }
    # Returns the category of the given element. The category is a
    # number used to allocate elements to bins; the bins are arranged
    # in ascending numeric order. The elements within a bin are arranged
    # via a second level sort criterion.
    # <p>
    # The default implementation of this framework method returns
    # <code>0</code>. Subclasses may reimplement this method to provide
    # non-trivial categorization.
    # </p>
    # 
    # @param element the element
    # @return the category
    def category(element)
      return 0
    end
    
    typesig { [Viewer, Object, Object] }
    # Returns a negative, zero, or positive number depending on whether
    # the first element is less than, equal to, or greater than
    # the second element.
    # <p>
    # The default implementation of this method is based on
    # comparing the elements' categories as computed by the <code>category</code>
    # framework method. Elements within the same category are further
    # subjected to a case insensitive compare of their label strings, either
    # as computed by the content viewer's label provider, or their
    # <code>toString</code> values in other cases. Subclasses may override.
    # </p>
    # 
    # @param viewer the viewer
    # @param e1 the first element
    # @param e2 the second element
    # @return a negative number if the first element is less  than the
    # second element; the value <code>0</code> if the first element is
    # equal to the second element; and a positive number if the first
    # element is greater than the second element
    def compare(viewer, e1, e2)
      cat1 = category(e1)
      cat2 = category(e2)
      if (!(cat1).equal?(cat2))
        return cat1 - cat2
      end
      name1 = nil
      name2 = nil
      if ((viewer).nil? || !(viewer.is_a?(ContentViewer)))
        name1 = RJava.cast_to_string(e1.to_s)
        name2 = RJava.cast_to_string(e2.to_s)
      else
        prov = (viewer).get_label_provider
        if (prov.is_a?(ILabelProvider))
          lprov = prov
          name1 = RJava.cast_to_string(lprov.get_text(e1))
          name2 = RJava.cast_to_string(lprov.get_text(e2))
        else
          name1 = RJava.cast_to_string(e1.to_s)
          name2 = RJava.cast_to_string(e2.to_s)
        end
      end
      if ((name1).nil?)
        name1 = "" # $NON-NLS-1$
      end
      if ((name2).nil?)
        name2 = "" # $NON-NLS-1$
      end
      # use the comparator to compare the strings
      return get_comparator.compare(name1, name2)
    end
    
    typesig { [Object, String] }
    # Returns whether this viewer sorter would be affected
    # by a change to the given property of the given element.
    # <p>
    # The default implementation of this method returns <code>false</code>.
    # Subclasses may reimplement.
    # </p>
    # 
    # @param element the element
    # @param property the property
    # @return <code>true</code> if the sorting would be affected,
    # and <code>false</code> if it would be unaffected
    def is_sorter_property(element, property)
      return false
    end
    
    typesig { [Viewer, Array.typed(Object)] }
    # Sorts the given elements in-place, modifying the given array.
    # <p>
    # The default implementation of this method uses the
    # java.util.Arrays#sort algorithm on the given array,
    # calling <code>compare</code> to compare elements.
    # </p>
    # <p>
    # Subclasses may reimplement this method to provide a more optimized implementation.
    # </p>
    # 
    # @param viewer the viewer
    # @param elements the elements to sort
    def sort(viewer, elements)
      Arrays.sort(elements, Class.new(Comparator.class == Class ? Comparator : Object) do
        local_class_in ViewerComparator
        include_class_members ViewerComparator
        include Comparator if Comparator.class == Module
        
        typesig { [Object, Object] }
        define_method :compare do |a, b|
          return @local_class_parent.compare(viewer, a, b)
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
    end
    
    private
    alias_method :initialize__viewer_comparator, :initialize
  end
  
end
