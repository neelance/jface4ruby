require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Viewers
  module StructuredSelectionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
      include_const ::Java::Util, :Arrays
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :JavaList
      include_const ::Org::Eclipse::Jface::Resource, :JFaceResources
      include_const ::Org::Eclipse::Core::Runtime, :Assert
    }
  end
  
  # A concrete implementation of the <code>IStructuredSelection</code> interface,
  # suitable for instantiating.
  # <p>
  # This class is not intended to be subclassed.
  # </p>
  # @noextend This class is not intended to be subclassed by clients.
  class StructuredSelection 
    include_class_members StructuredSelectionImports
    include IStructuredSelection
    
    # The element that make up this structured selection.
    attr_accessor :elements
    alias_method :attr_elements, :elements
    undef_method :elements
    alias_method :attr_elements=, :elements=
    undef_method :elements=
    
    # The element comparer, or <code>null</code>
    attr_accessor :comparer
    alias_method :attr_comparer, :comparer
    undef_method :comparer
    alias_method :attr_comparer=, :comparer=
    undef_method :comparer=
    
    class_module.module_eval {
      # The canonical empty selection. This selection should be used instead of
      # <code>null</code>.
      const_set_lazy(:EMPTY) { StructuredSelection.new }
      const_attr_reader  :EMPTY
    }
    
    typesig { [] }
    # Creates a new empty selection.
    # See also the static field <code>EMPTY</code> which contains an empty selection singleton.
    # 
    # @see #EMPTY
    def initialize
      @elements = nil
      @comparer = nil
    end
    
    typesig { [Array.typed(Object)] }
    # Creates a structured selection from the given elements.
    # The given element array must not be <code>null</code>.
    # 
    # @param elements an array of elements
    def initialize(elements)
      @elements = nil
      @comparer = nil
      Assert.is_not_null(elements)
      @elements = Array.typed(Object).new(elements.attr_length) { nil }
      System.arraycopy(elements, 0, @elements, 0, elements.attr_length)
    end
    
    typesig { [Object] }
    # Creates a structured selection containing a single object.
    # The object must not be <code>null</code>.
    # 
    # @param element the element
    def initialize(element)
      @elements = nil
      @comparer = nil
      Assert.is_not_null(element)
      @elements = Array.typed(Object).new([element])
    end
    
    typesig { [JavaList] }
    # Creates a structured selection from the given <code>List</code>.
    # @param elements list of selected elements
    def initialize(elements)
      initialize__structured_selection(elements, nil)
    end
    
    typesig { [JavaList, IElementComparer] }
    # Creates a structured selection from the given <code>List</code> and
    # element comparer. If an element comparer is provided, it will be used to
    # determine equality between structured selection objects provided that
    # they both are based on the same (identical) comparer. See bug
    # 
    # @param elements
    # list of selected elements
    # @param comparer
    # the comparer, or null
    # @since 3.4
    def initialize(elements, comparer)
      @elements = nil
      @comparer = nil
      Assert.is_not_null(elements)
      @elements = elements.to_array
      @comparer = comparer
    end
    
    typesig { [Object] }
    # Returns whether this structured selection is equal to the given object.
    # Two structured selections are equal if they contain the same elements
    # in the same order.
    # 
    # @param o the other object
    # @return <code>true</code> if they are equal, and <code>false</code> otherwise
    def ==(o)
      if ((self).equal?(o))
        return true
      end
      # null and other classes
      if (!(o.is_a?(StructuredSelection)))
        return false
      end
      s2 = o
      # either or both empty?
      if (is_empty)
        return s2.is_empty
      end
      if (s2.is_empty)
        return false
      end
      use_comparer = !(@comparer).nil? && (@comparer).equal?(s2.attr_comparer)
      # size
      my_len = @elements.attr_length
      if (!(my_len).equal?(s2.attr_elements.attr_length))
        return false
      end
      # element comparison
      i = 0
      while i < my_len
        if (use_comparer)
          if (!(@comparer == @elements[i]))
            return false
          end
        else
          if (!(@elements[i] == s2.attr_elements[i]))
            return false
          end
        end
        i += 1
      end
      return true
    end
    
    typesig { [] }
    # (non-Javadoc)
    # Method declared in IStructuredSelection.
    def get_first_element
      return is_empty ? nil : @elements[0]
    end
    
    typesig { [] }
    # (non-Javadoc)
    # Method declared in ISelection.
    def is_empty
      return (@elements).nil? || (@elements.attr_length).equal?(0)
    end
    
    typesig { [] }
    # (non-Javadoc)
    # Method declared in IStructuredSelection.
    def iterator
      return Arrays.as_list((@elements).nil? ? Array.typed(Object).new(0) { nil } : @elements).iterator
    end
    
    typesig { [] }
    # (non-Javadoc)
    # Method declared in IStructuredSelection.
    def size
      return (@elements).nil? ? 0 : @elements.attr_length
    end
    
    typesig { [] }
    # (non-Javadoc)
    # Method declared in IStructuredSelection.
    def to_array
      return (@elements).nil? ? Array.typed(Object).new(0) { nil } : @elements.clone
    end
    
    typesig { [] }
    # (non-Javadoc)
    # Method declared in IStructuredSelection.
    def to_list
      return Arrays.as_list((@elements).nil? ? Array.typed(Object).new(0) { nil } : @elements)
    end
    
    typesig { [] }
    # Internal method which returns a string representation of this
    # selection suitable for debug purposes only.
    # 
    # @return debug string
    def to_s
      return is_empty ? JFaceResources.get_string("<empty_selection>") : to_list.to_s # $NON-NLS-1$
    end
    
    private
    alias_method :initialize__structured_selection, :initialize
  end
  
end
