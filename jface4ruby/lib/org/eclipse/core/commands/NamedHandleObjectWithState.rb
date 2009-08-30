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
  module NamedHandleObjectWithStateImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Commands
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :Map
      include_const ::Java::Util, :JavaSet
      include_const ::Org::Eclipse::Core::Commands::Common, :NamedHandleObject
      include_const ::Org::Eclipse::Core::Commands::Common, :NotDefinedException
    }
  end
  
  # <p>
  # A named handle object that can carry state with it. This state can be used to
  # override the name or description.
  # </p>
  # <p>
  # Clients may neither instantiate nor extend this class.
  # </p>
  # 
  # @since 3.2
  class NamedHandleObjectWithState < NamedHandleObjectWithStateImports.const_get :NamedHandleObject
    include_class_members NamedHandleObjectWithStateImports
    overload_protected {
      include IObjectWithState
    }
    
    class_module.module_eval {
      # An empty string array, which can be returned from {@link #getStateIds()}
      # if there is no state.
      const_set_lazy(:NO_STATE) { Array.typed(String).new(0) { nil } }
      const_attr_reader  :NO_STATE
    }
    
    # The map of states currently held by this command. If this command has no
    # state, then this will be <code>null</code>.
    attr_accessor :states
    alias_method :attr_states, :states
    undef_method :states
    alias_method :attr_states=, :states=
    undef_method :states=
    
    typesig { [String] }
    # Constructs a new instance of <code>NamedHandleObject<WithState/code>.
    # 
    # @param id
    # The identifier for this handle; must not be <code>null</code>.
    def initialize(id)
      @states = nil
      super(id)
      @states = nil
    end
    
    typesig { [String, State] }
    def add_state(state_id, state)
      if ((state).nil?)
        raise NullPointerException.new("Cannot add a null state") # $NON-NLS-1$
      end
      if ((@states).nil?)
        @states = HashMap.new(3)
      end
      @states.put(state_id, state)
    end
    
    typesig { [] }
    def get_description
      description = super # Trigger a NDE.
      description_state = get_state(INamedHandleStateIds::DESCRIPTION)
      if (!(description_state).nil?)
        value = description_state.get_value
        if (!(value).nil?)
          return value.to_s
        end
      end
      return description
    end
    
    typesig { [] }
    def get_name
      name = super # Trigger a NDE, if necessary.
      name_state = get_state(INamedHandleStateIds::NAME)
      if (!(name_state).nil?)
        value = name_state.get_value
        if (!(value).nil?)
          return value.to_s
        end
      end
      return name
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
        return NO_STATE
      end
      state_ids = @states.key_set
      return state_ids.to_array(Array.typed(String).new(state_ids.size) { nil })
    end
    
    typesig { [String] }
    def remove_state(id)
      if ((id).nil?)
        raise NullPointerException.new("Cannot remove a null id") # $NON-NLS-1$
      end
      if (!(@states).nil?)
        @states.remove(id)
        if (@states.is_empty)
          @states = nil
        end
      end
    end
    
    private
    alias_method :initialize__named_handle_object_with_state, :initialize
  end
  
end
