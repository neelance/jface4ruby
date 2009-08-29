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
  module CheckStateChangedEventImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
      include_const ::Java::Util, :EventObject
    }
  end
  
  # Event object describing a change to the checked state
  # of a viewer element.
  # 
  # @see ICheckStateListener
  class CheckStateChangedEvent < CheckStateChangedEventImports.const_get :EventObject
    include_class_members CheckStateChangedEventImports
    
    class_module.module_eval {
      # Generated serial version UID for this class.
      # @since 3.1
      const_set_lazy(:SerialVersionUID) { 3256443603340244789 }
      const_attr_reader  :SerialVersionUID
    }
    
    # The viewer element.
    attr_accessor :element
    alias_method :attr_element, :element
    undef_method :element
    alias_method :attr_element=, :element=
    undef_method :element=
    
    # The checked state.
    attr_accessor :state
    alias_method :attr_state, :state
    undef_method :state
    alias_method :attr_state=, :state=
    undef_method :state=
    
    typesig { [ICheckable, Object, ::Java::Boolean] }
    # Creates a new event for the given source, element, and checked state.
    # 
    # @param source the source
    # @param element the element
    # @param state the checked state
    def initialize(source, element, state)
      @element = nil
      @state = false
      super(source)
      @element = element
      @state = state
    end
    
    typesig { [] }
    # Returns the checkable that is the source of this event.
    # 
    # @return the originating checkable
    def get_checkable
      return self.attr_source
    end
    
    typesig { [] }
    # Returns the checked state of the element.
    # 
    # @return the checked state
    def get_checked
      return @state
    end
    
    typesig { [] }
    # Returns the element whose check state changed.
    # 
    # @return the element
    def get_element
      return @element
    end
    
    private
    alias_method :initialize__check_state_changed_event, :initialize
  end
  
end
