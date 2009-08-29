require "rjava"

# Copyright (c) 2005, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Commands
  module RadioStateImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Commands
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :HashSet
      include_const ::Java::Util, :Map
      include_const ::Java::Util, :JavaSet
      include_const ::Org::Eclipse::Core::Commands, :IStateListener
      include_const ::Org::Eclipse::Core::Commands, :State
      include_const ::Org::Eclipse::Jface::Menus, :IMenuStateIds
    }
  end
  
  # <p>
  # A piece of boolean state grouped with other boolean states. Of these states,
  # only one may have a value of {@link Boolean#TRUE} at any given point in time.
  # The values of all other states must be {@link Boolean#FALSE}.
  # </p>
  # <p>
  # If this state is registered using {@link IMenuStateIds#STYLE}, then it will
  # control the presentation of the command if displayed in the menus, tool bars
  # or status line.
  # </p>
  # <p>
  # Clients may instantiate or extend this interface.
  # </p>
  # 
  # @since 3.2
  class RadioState < RadioStateImports.const_get :ToggleState
    include_class_members RadioStateImports
    
    class_module.module_eval {
      # The manager of radio groups within the application. This ensures that
      # only one member of a radio group is active at any one time, and tracks
      # group memberships.
      const_set_lazy(:RadioStateManager) { Class.new do
        include_class_members RadioState
        
        class_module.module_eval {
          # A group of radio states with the same identifier.
          const_set_lazy(:RadioGroup) { Class.new do
            include_class_members RadioStateManager
            include class_self::IStateListener
            
            # The active state. If there is no active state, then this value is
            # <code>null</code>.
            attr_accessor :active
            alias_method :attr_active, :active
            undef_method :active
            alias_method :attr_active=, :active=
            undef_method :active=
            
            # The current members in this group. If there are no members, then
            # this value is <code>nlistenerull</code>.
            attr_accessor :members
            alias_method :attr_members, :members
            undef_method :members
            alias_method :attr_members=, :members=
            undef_method :members=
            
            typesig { [class_self::RadioState] }
            # Activates a memeber. This checks to see if there are any other
            # active members. If there are, they are deactivated.
            # 
            # @param state
            # The state that should become active; must not be
            # <code>null</code>.
            def activate_member(state)
              if (!(@active).nil? && !(@active).equal?(state))
                @active.set_value(Boolean::FALSE)
              end
              @active = state
            end
            
            typesig { [class_self::RadioState] }
            # Adds a member to this radio group. If the state being added is
            # active, then it replaces the currently active group memeber as
            # the active state.
            # 
            # @param state
            # The state to add; must not be <code>null</code>.
            def add_member(state)
              if ((@members).nil?)
                @members = self.class::HashSet.new(5)
              end
              @members.add(state)
              state.add_listener(self)
              value = state.get_value
              if (value.is_a?(Boolean))
                if ((value).boolean_value)
                  activate_member(state)
                end
              end
            end
            
            typesig { [class_self::State, Object] }
            def handle_state_change(state, old_value)
              new_value = state.get_value
              if (new_value.is_a?(Boolean))
                if ((new_value).boolean_value)
                  activate_member(state)
                end
              end
            end
            
            typesig { [class_self::RadioState] }
            # Removes a member from this radio group. If the state was the
            # active state, then there will be no active state.
            # 
            # @param state
            # The state to remove; must not be <code>null</code>.
            def remove_member(state)
              state.remove_listener(self)
              if ((@active).equal?(state))
                @active = nil
              end
              if ((@members).nil?)
                return
              end
              @members.remove(state)
            end
            
            typesig { [] }
            def initialize
              @active = nil
              @members = nil
            end
            
            private
            alias_method :initialize__radio_group, :initialize
          end }
          
          # The map of radio states indexed by identifier (<code>String</code>).
          # The radio states is either a single <code>RadioState</code>
          # instance or a <code>Collection</code> of <code>RadioState</code>
          # instances.
          
          def radio_states_by_id
            defined?(@@radio_states_by_id) ? @@radio_states_by_id : @@radio_states_by_id= nil
          end
          alias_method :attr_radio_states_by_id, :radio_states_by_id
          
          def radio_states_by_id=(value)
            @@radio_states_by_id = value
          end
          alias_method :attr_radio_states_by_id=, :radio_states_by_id=
          
          typesig { [String, class_self::RadioState] }
          # Activates a particular state within a given group.
          # 
          # @param identifier
          # The identifier of the group to which the state belongs;
          # must not be <code>null</code>.
          # @param state
          # The state to activate; must not be <code>null</code>.
          def activate_group(identifier, state)
            if ((self.attr_radio_states_by_id).nil?)
              return
            end
            current_value = self.attr_radio_states_by_id.get(identifier)
            if (current_value.is_a?(class_self::RadioGroup))
              radio_group = current_value
              radio_group.activate_member(state)
            end
          end
          
          typesig { [String, class_self::RadioState] }
          # Registers a piece of state with the radio manager.
          # 
          # @param identifier
          # The identifier of the radio group; must not be
          # <code>null</code>.
          # @param state
          # The state to register; must not be <code>null</code>.
          def register_state(identifier, state)
            if ((self.attr_radio_states_by_id).nil?)
              self.attr_radio_states_by_id = class_self::HashMap.new
            end
            current_value = self.attr_radio_states_by_id.get(identifier)
            radio_group = nil
            if (current_value.is_a?(class_self::RadioGroup))
              radio_group = current_value
            else
              radio_group = class_self::RadioGroup.new
              self.attr_radio_states_by_id.put(identifier, radio_group)
            end
            radio_group.add_member(state)
          end
          
          typesig { [String, class_self::RadioState] }
          # Unregisters a piece of state from the radio manager.
          # 
          # @param identifier
          # The identifier of the radio group; must not be
          # <code>null</code>.
          # @param state
          # The state to unregister; must not be <code>null</code>.
          def unregister_state(identifier, state)
            if ((self.attr_radio_states_by_id).nil?)
              return
            end
            current_value = self.attr_radio_states_by_id.get(identifier)
            if (current_value.is_a?(class_self::RadioGroup))
              radio_group = current_value
              radio_group.remove_member(state)
            end
          end
        }
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__radio_state_manager, :initialize
      end }
    }
    
    # The identifier of the radio group to which this state belongs. This value
    # may be <code>null</code> if this state doesn't really belong to a group
    # (yet).
    attr_accessor :radio_group_identifier
    alias_method :attr_radio_group_identifier, :radio_group_identifier
    undef_method :radio_group_identifier
    alias_method :attr_radio_group_identifier=, :radio_group_identifier=
    undef_method :radio_group_identifier=
    
    typesig { [] }
    # Unregisters this state from the manager, which detaches the listeners.
    def dispose
      set_radio_group_identifier(nil)
    end
    
    typesig { [String] }
    # Sets the identifier of the radio group for this piece of state. If the
    # identifier is cleared, then the state is unregistered.
    # 
    # @param identifier
    # The identifier of the radio group for this state; may be
    # <code>null</code> if the identifier is being cleared.
    def set_radio_group_identifier(identifier)
      if ((identifier).nil?)
        RadioStateManager.unregister_state(@radio_group_identifier, self)
        @radio_group_identifier = RJava.cast_to_string(nil)
      else
        @radio_group_identifier = identifier
        RadioStateManager.register_state(identifier, self)
      end
    end
    
    typesig { [Object] }
    # Sets the value for this object. This notifies the radio state manager of
    # the change.
    # 
    # @param value
    # The new value; should be a <code>Boolean</code>.
    def set_value(value)
      if (!(value.is_a?(Boolean)))
        raise IllegalArgumentException.new("RadioState takes a Boolean as a value") # $NON-NLS-1$
      end
      if ((value).boolean_value && (!(@radio_group_identifier).nil?))
        RadioStateManager.activate_group(@radio_group_identifier, self)
      end
      super(value)
    end
    
    typesig { [] }
    def initialize
      @radio_group_identifier = nil
      super()
      @radio_group_identifier = nil
    end
    
    private
    alias_method :initialize__radio_state, :initialize
  end
  
end
