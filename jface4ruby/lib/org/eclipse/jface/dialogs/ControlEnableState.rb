require "rjava"

# Copyright (c) 2000, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Dialogs
  module ControlEnableStateImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Dialogs
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :JavaList
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Control
    }
  end
  
  # Helper class to save the enable/disable state of a control including all its
  # descendent controls.
  class ControlEnableState 
    include_class_members ControlEnableStateImports
    
    # List of exception controls (element type: <code>Control</code>);
    # <code>null</code> if none.
    attr_accessor :exceptions
    alias_method :attr_exceptions, :exceptions
    undef_method :exceptions
    alias_method :attr_exceptions=, :exceptions=
    undef_method :exceptions=
    
    # List of saved states (element type: <code>ItemState</code>).
    attr_accessor :states
    alias_method :attr_states, :states
    undef_method :states
    alias_method :attr_states=, :states=
    undef_method :states=
    
    class_module.module_eval {
      # Internal class for recording the enable/disable state of a single
      # control.
      const_set_lazy(:ItemState) { Class.new do
        local_class_in ControlEnableState
        include_class_members ControlEnableState
        
        # the control
        attr_accessor :item
        alias_method :attr_item, :item
        undef_method :item
        alias_method :attr_item=, :item=
        undef_method :item=
        
        # the state
        attr_accessor :state
        alias_method :attr_state, :state
        undef_method :state
        alias_method :attr_state=, :state=
        undef_method :state=
        
        typesig { [class_self::Control, ::Java::Boolean] }
        # Create a new instance of the receiver.
        # 
        # @param item
        # @param state
        def initialize(item, state)
          @item = nil
          @state = false
          @item = item
          @state = state
        end
        
        typesig { [] }
        # Restore the enabled state to the original value.
        def restore
          if ((@item).nil? || @item.is_disposed)
            return
          end
          @item.set_enabled(@state)
        end
        
        private
        alias_method :initialize__item_state, :initialize
      end }
    }
    
    typesig { [Control] }
    # Creates a new object and saves in it the current enable/disable state of
    # the given control and its descendents; the controls that are saved are
    # also disabled.
    # 
    # @param w
    # the control
    def initialize(w)
      initialize__control_enable_state(w, nil)
    end
    
    typesig { [Control, JavaList] }
    # Creates a new object and saves in it the current enable/disable state of
    # the given control and its descendents except for the given list of
    # exception cases; the controls that are saved are also disabled.
    # 
    # @param w
    # the control
    # @param exceptions
    # the list of controls to not disable (element type:
    # <code>Control</code>), or <code>null</code> if none
    def initialize(w, exceptions)
      @exceptions = nil
      @states = nil
      @states = ArrayList.new
      @exceptions = exceptions
      read_state_for_and_disable(w)
    end
    
    class_module.module_eval {
      typesig { [Control] }
      # Saves the current enable/disable state of the given control and its
      # descendents in the returned object; the controls are all disabled.
      # 
      # @param w
      # the control
      # @return an object capturing the enable/disable state
      def disable(w)
        return ControlEnableState.new(w)
      end
      
      typesig { [Control, JavaList] }
      # Saves the current enable/disable state of the given control and its
      # descendents in the returned object except for the given list of exception
      # cases; the controls that are saved are also disabled.
      # 
      # @param w
      # the control
      # @param exceptions
      # the list of controls to not disable (element type:
      # <code>Control</code>)
      # @return an object capturing the enable/disable state
      def disable(w, exceptions)
        return ControlEnableState.new(w, exceptions)
      end
    }
    
    typesig { [Control] }
    # Recursively reads the enable/disable state for the given window and
    # disables all controls.
    # @param control Control
    def read_state_for_and_disable(control)
      if ((!(@exceptions).nil? && @exceptions.contains(control)))
        return
      end
      if (control.is_a?(Composite))
        c = control
        children = c.get_children
        i = 0
        while i < children.attr_length
          read_state_for_and_disable(children[i])
          i += 1
        end
      end
      # XXX: Workaround for 1G2Q8SS: ITPUI:Linux - Combo box is not enabled
      # in "File->New->Solution"
      @states.add(ItemState.new_local(self, control, control.get_enabled))
      control.set_enabled(false)
    end
    
    typesig { [] }
    # Restores the window enable state saved in this object.
    def restore
      size_ = @states.size
      i = 0
      while i < size_
        (@states.get(i)).restore
        i += 1
      end
    end
    
    private
    alias_method :initialize__control_enable_state, :initialize
  end
  
end
