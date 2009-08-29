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
  module LabelProviderChangedEventImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
      include_const ::Java::Util, :EventObject
    }
  end
  
  # Event object describing a label provider state change.
  # 
  # @see ILabelProviderListener
  class LabelProviderChangedEvent < LabelProviderChangedEventImports.const_get :EventObject
    include_class_members LabelProviderChangedEventImports
    
    class_module.module_eval {
      # Generated serial version UID for this class.
      # @since 3.1
      const_set_lazy(:SerialVersionUID) { 3258410612479309878 }
      const_attr_reader  :SerialVersionUID
    }
    
    # The elements whose labels need to be updated or <code>null</code>.
    attr_accessor :elements
    alias_method :attr_elements, :elements
    undef_method :elements
    alias_method :attr_elements=, :elements=
    undef_method :elements=
    
    typesig { [IBaseLabelProvider] }
    # Creates a new event for the given source, indicating that all labels
    # provided by the source are no longer valid and should be updated.
    # 
    # @param source the label provider
    def initialize(source)
      @elements = nil
      super(source)
    end
    
    typesig { [IBaseLabelProvider, Array.typed(Object)] }
    # Creates a new event for the given source, indicating that the label
    # provided by the source for the given elements is no longer valid and should be updated.
    # 
    # @param source the label provider
    # @param elements the element whose labels have changed
    def initialize(source, elements)
      @elements = nil
      super(source)
      @elements = elements
    end
    
    typesig { [IBaseLabelProvider, Object] }
    # Creates a new event for the given source, indicating that the label
    # provided by the source for the given element is no longer valid and should be updated.
    # 
    # @param source the label provider
    # @param element the element whose label needs to be updated
    def initialize(source, element)
      @elements = nil
      super(source)
      @elements = Array.typed(Object).new(1) { nil }
      @elements[0] = element
    end
    
    typesig { [] }
    # Returns the first element whose label needs to be updated,
    # or <code>null</code> if all labels need to be updated.
    # 
    # @return the element whose label needs to be updated or <code>null</code>
    def get_element
      if ((@elements).nil? || (@elements.attr_length).equal?(0))
        return nil
      else
        return @elements[0]
      end
    end
    
    typesig { [] }
    # Returns the elements whose labels need to be updated,
    # or <code>null</code> if all labels need to be updated.
    # 
    # @return the element whose labels need to be updated or <code>null</code>
    def get_elements
      if ((@elements).nil?)
        return nil
      else
        return @elements
      end
    end
    
    private
    alias_method :initialize__label_provider_changed_event, :initialize
  end
  
end
