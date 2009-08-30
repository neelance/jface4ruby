require "rjava"

# Copyright (c) 2005, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Core::Commands
  module AbstractHandlerWithStateImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Commands
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :Map
      include_const ::Java::Util, :JavaSet
    }
  end
  
  # <p>
  # An abstract implementation of {@link IObjectWithState}. This provides basic
  # handling for adding and remove state. When state is added, the handler
  # attaches itself as a listener and fire a handleStateChange event to notify
  # this handler. When state is removed, the handler removes itself as a
  # listener.
  # </p>
  # <p>
  # Clients may extend this class.
  # </p>
  # 
  # @since 3.2
  class AbstractHandlerWithState < AbstractHandlerWithStateImports.const_get :AbstractHandler
    include_class_members AbstractHandlerWithStateImports
    overload_protected {
      include IObjectWithState
      include IStateListener
    }
    
    # The map of states currently held by this handler. If this handler has no
    # state (generally, when inactive), then this will be <code>null</code>.
    attr_accessor :states
    alias_method :attr_states, :states
    undef_method :states
    alias_method :attr_states=, :states=
    undef_method :states=
    
    typesig { [String, State] }
    # <p>
    # Adds a state to this handler. This will add this handler as a listener to
    # the state, and then fire a handleStateChange so that the handler can
    # respond to the incoming state.
    # </p>
    # <p>
    # Clients may extend this method, but they should call this super method
    # first before doing anything else.
    # </p>
    # 
    # @param stateId
    # The identifier indicating the type of state being added; must
    # not be <code>null</code>.
    # @param state
    # The state to add; must not be <code>null</code>.
    def add_state(state_id, state)
      if ((state).nil?)
        raise NullPointerException.new("Cannot add a null state") # $NON-NLS-1$
      end
      if ((@states).nil?)
        @states = HashMap.new(3)
      end
      @states.put(state_id, state)
      state.add_listener(self)
      handle_state_change(state, nil)
    end
    
    typesig { [String] }
    def get_state(state_id)
      if (((@states).nil?) || (@states.is_empty))
        return nil
      end
      return @states.get(state_id)
    end
    
    typesig { [] }
    def get_state_ids
      if (((@states).nil?) || (@states.is_empty))
        return nil
      end
      state_ids = @states.key_set
      return state_ids.to_array(Array.typed(String).new(state_ids.size) { nil })
    end
    
    typesig { [String] }
    # <p>
    # Removes a state from this handler. This will remove this handler as a
    # listener to the state. No event is fired to notify the handler of this
    # change.
    # </p>
    # <p>
    # Clients may extend this method, but they should call this super method
    # first before doing anything else.
    # </p>
    # 
    # @param stateId
    # The identifier of the state to remove; must not be
    # <code>null</code>.
    def remove_state(state_id)
      if ((state_id).nil?)
        raise NullPointerException.new("Cannot remove a null state") # $NON-NLS-1$
      end
      state = @states.get(state_id)
      if (!(state).nil?)
        state.remove_listener(self)
        if (!(@states).nil?)
          @states.remove(state)
          if (@states.is_empty)
            @states = nil
          end
        end
      end
    end
    
    typesig { [] }
    def initialize
      @states = nil
      super()
      @states = nil
    end
    
    private
    alias_method :initialize__abstract_handler_with_state, :initialize
  end
  
end
