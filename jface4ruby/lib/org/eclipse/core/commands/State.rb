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
  module StateImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Commands
      include_const ::Org::Eclipse::Core::Commands::Common, :EventManager
      include_const ::Org::Eclipse::Core::Internal::Commands::Util, :Util
    }
  end
  
  # <p>
  # A piece of state information that can be shared between objects, and might be
  # persisted between sessions. This can be used for commands that toggle between
  # two states and wish to pass this state information between different
  # handlers.
  # </p>
  # <p>
  # This state object can either be used as a single state object shared between
  # several commands, or one state object per command -- depending on the needs
  # of the application.
  # </p>
  # <p>
  # Clients may instantiate or extend this class.
  # </p>
  # 
  # @since 3.2
  class State < StateImports.const_get :EventManager
    include_class_members StateImports
    
    # The identifier of the state; may be <code>null</code> if it has not
    # been initialized.
    attr_accessor :id
    alias_method :attr_id, :id
    undef_method :id
    alias_method :attr_id=, :id=
    undef_method :id=
    
    # The value held by this state; may be anything at all.
    attr_accessor :value
    alias_method :attr_value, :value
    undef_method :value
    alias_method :attr_value=, :value=
    undef_method :value=
    
    typesig { [IStateListener] }
    # Adds a listener to changes for this state.
    # 
    # @param listener
    # The listener to add; must not be <code>null</code>.
    def add_listener(listener)
      add_listener_object(listener)
    end
    
    typesig { [] }
    # Disposes of this state. This allows the state to unregister itself with
    # any managers or as a listener.
    def dispose
      # The default implementation does nothing.
    end
    
    typesig { [Object] }
    # Notifies listeners to this state that it has changed in some way.
    # 
    # @param oldValue
    # The old value; may be anything.
    def fire_state_changed(old_value)
      listeners = get_listeners
      i = 0
      while i < listeners.attr_length
        listener = listeners[i]
        listener.handle_state_change(self, old_value)
        i += 1
      end
    end
    
    typesig { [] }
    # Returns the identifier for this state.
    # 
    # @return The id; may be <code>null</code>.
    def get_id
      return @id
    end
    
    typesig { [] }
    # The current value associated with this state. This can be any type of
    # object, but implementations will usually restrict this value to a
    # particular type.
    # 
    # @return The current value; may be anything.
    def get_value
      return @value
    end
    
    typesig { [IStateListener] }
    # Removes a listener to changes from this state.
    # 
    # @param listener
    # The listener to remove; must not be <code>null</code>.
    def remove_listener(listener)
      remove_listener_object(listener)
    end
    
    typesig { [String] }
    # Sets the identifier for this object.  This method should only be called
    # by the command framework.  Clients should not call this method.
    # 
    # @param id
    # The id; must not be <code>null</code>.
    def set_id(id)
      @id = id
    end
    
    typesig { [Object] }
    # Sets the value for this state object.
    # 
    # @param value
    # The value to set; may be anything.
    def set_value(value)
      if (!(Util == @value))
        old_value = @value
        @value = value
        fire_state_changed(old_value)
      end
    end
    
    typesig { [] }
    def initialize
      @id = nil
      @value = nil
      super()
    end
    
    private
    alias_method :initialize__state, :initialize
  end
  
end
