require "rjava"

# Copyright (c) 2004, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Bindings
  module BindingManagerEventImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Bindings
      include_const ::Java::Util, :Collection
      include_const ::Java::Util, :Map
      include_const ::Org::Eclipse::Core::Commands, :ParameterizedCommand
      include_const ::Org::Eclipse::Core::Commands::Common, :AbstractBitSetEvent
      include_const ::Org::Eclipse::Jface::Util, :Util
    }
  end
  
  # An instance of this class describes changes to an instance of
  # <code>BindingManager</code>.
  # <p>
  # This class is not intended to be extended by clients.
  # </p>
  # 
  # @since 3.1
  # @see IBindingManagerListener#bindingManagerChanged(BindingManagerEvent)
  class BindingManagerEvent < BindingManagerEventImports.const_get :AbstractBitSetEvent
    include_class_members BindingManagerEventImports
    
    class_module.module_eval {
      # The bit used to represent whether the map of active bindings has changed.
      const_set_lazy(:CHANGED_ACTIVE_BINDINGS) { 1 }
      const_attr_reader  :CHANGED_ACTIVE_BINDINGS
      
      # The bit used to represent whether the active scheme has changed.
      const_set_lazy(:CHANGED_ACTIVE_SCHEME) { 1 << 1 }
      const_attr_reader  :CHANGED_ACTIVE_SCHEME
      
      # The bit used to represent whether the active locale has changed.
      const_set_lazy(:CHANGED_LOCALE) { 1 << 2 }
      const_attr_reader  :CHANGED_LOCALE
      
      # The bit used to represent whether the active platform has changed.
      const_set_lazy(:CHANGED_PLATFORM) { 1 << 3 }
      const_attr_reader  :CHANGED_PLATFORM
      
      # The bit used to represent whether the scheme's defined state has changed.
      const_set_lazy(:CHANGED_SCHEME_DEFINED) { 1 << 4 }
      const_attr_reader  :CHANGED_SCHEME_DEFINED
    }
    
    # The binding manager that has changed; this value is never
    # <code>null</code>.
    attr_accessor :manager
    alias_method :attr_manager, :manager
    undef_method :manager
    alias_method :attr_manager=, :manager=
    undef_method :manager=
    
    # The map of triggers (<code>Collection</code> of
    # <code>TriggerSequence</code>) by parameterized command (<code>ParameterizedCommand</code>)
    # before the change occurred. This map may be empty and it may be
    # <code>null</code>.
    attr_accessor :previous_triggers_by_parameterized_command
    alias_method :attr_previous_triggers_by_parameterized_command, :previous_triggers_by_parameterized_command
    undef_method :previous_triggers_by_parameterized_command
    alias_method :attr_previous_triggers_by_parameterized_command=, :previous_triggers_by_parameterized_command=
    undef_method :previous_triggers_by_parameterized_command=
    
    # The scheme that became defined or undefined. This value may be
    # <code>null</code> if no scheme changed its defined state.
    attr_accessor :scheme
    alias_method :attr_scheme, :scheme
    undef_method :scheme
    alias_method :attr_scheme=, :scheme=
    undef_method :scheme=
    
    typesig { [BindingManager, ::Java::Boolean, Map, ::Java::Boolean, Scheme, ::Java::Boolean, ::Java::Boolean, ::Java::Boolean] }
    # Creates a new instance of this class.
    # 
    # @param manager
    # the instance of the binding manager that changed; must not be
    # <code>null</code>.
    # @param activeBindingsChanged
    # Whether the active bindings have changed.
    # @param previousTriggersByParameterizedCommand
    # The map of triggers (<code>TriggerSequence</code>) by
    # fully-parameterized command (<code>ParameterizedCommand</code>)
    # before the change occured. This map may be <code>null</code>
    # or empty.
    # @param activeSchemeChanged
    # true, iff the active scheme changed.
    # @param scheme
    # The scheme that became defined or undefined; <code>null</code>
    # if no scheme changed state.
    # @param schemeDefined
    # <code>true</code> if the given scheme became defined;
    # <code>false</code> otherwise.
    # @param localeChanged
    # <code>true</code> iff the active locale changed
    # @param platformChanged
    # <code>true</code> iff the active platform changed
    def initialize(manager, active_bindings_changed, previous_triggers_by_parameterized_command, active_scheme_changed, scheme, scheme_defined, locale_changed, platform_changed)
      @manager = nil
      @previous_triggers_by_parameterized_command = nil
      @scheme = nil
      super()
      if ((manager).nil?)
        raise NullPointerException.new("A binding manager event needs a binding manager") # $NON-NLS-1$
      end
      @manager = manager
      if (scheme_defined && ((scheme).nil?))
        raise NullPointerException.new("If a scheme changed defined state, then there should be a scheme identifier") # $NON-NLS-1$
      end
      @scheme = scheme
      @previous_triggers_by_parameterized_command = previous_triggers_by_parameterized_command
      if (active_bindings_changed)
        self.attr_changed_values |= CHANGED_ACTIVE_BINDINGS
      end
      if (active_scheme_changed)
        self.attr_changed_values |= CHANGED_ACTIVE_SCHEME
      end
      if (locale_changed)
        self.attr_changed_values |= CHANGED_LOCALE
      end
      if (platform_changed)
        self.attr_changed_values |= CHANGED_PLATFORM
      end
      if (scheme_defined)
        self.attr_changed_values |= CHANGED_SCHEME_DEFINED
      end
    end
    
    typesig { [] }
    # Returns the instance of the manager that changed.
    # 
    # @return the instance of the manager that changed. Guaranteed not to be
    # <code>null</code>.
    def get_manager
      return @manager
    end
    
    typesig { [] }
    # Returns the scheme that changed.
    # 
    # @return The changed scheme
    def get_scheme
      return @scheme
    end
    
    typesig { [] }
    # Returns whether the active bindings have changed.
    # 
    # @return <code>true</code> if the active bindings have changed;
    # <code>false</code> otherwise.
    def is_active_bindings_changed
      return (!((self.attr_changed_values & CHANGED_ACTIVE_BINDINGS)).equal?(0))
    end
    
    typesig { [ParameterizedCommand] }
    # Computes whether the active bindings have changed for a given command
    # identifier.
    # 
    # @param parameterizedCommand
    # The fully-parameterized command whose bindings might have
    # changed; must not be <code>null</code>.
    # @return <code>true</code> if the active bindings have changed for the
    # given command identifier; <code>false</code> otherwise.
    def is_active_bindings_changed_for(parameterized_command)
      current_bindings = @manager.get_active_bindings_for(parameterized_command)
      previous_bindings = nil
      if (!(@previous_triggers_by_parameterized_command).nil?)
        previous_binding_collection = @previous_triggers_by_parameterized_command.get(parameterized_command)
        if ((previous_binding_collection).nil?)
          previous_bindings = nil
        else
          previous_bindings = previous_binding_collection.to_array(Array.typed(TriggerSequence).new(previous_binding_collection.size) { nil })
        end
      else
        previous_bindings = nil
      end
      return !(Util == current_bindings)
    end
    
    typesig { [] }
    # Returns whether or not the active scheme changed.
    # 
    # @return true, iff the active scheme property changed.
    def is_active_scheme_changed
      return (!((self.attr_changed_values & CHANGED_ACTIVE_SCHEME)).equal?(0))
    end
    
    typesig { [] }
    # Returns whether the locale has changed
    # 
    # @return <code>true</code> if the locale changed; <code>false</code>
    # otherwise.
    def is_locale_changed
      return (!((self.attr_changed_values & CHANGED_LOCALE)).equal?(0))
    end
    
    typesig { [] }
    # Returns whether the platform has changed
    # 
    # @return <code>true</code> if the platform changed; <code>false</code>
    # otherwise.
    def is_platform_changed
      return (!((self.attr_changed_values & CHANGED_PLATFORM)).equal?(0))
    end
    
    typesig { [] }
    # Returns whether the list of defined scheme identifiers has changed.
    # 
    # @return <code>true</code> if the list of scheme identifiers has
    # changed; <code>false</code> otherwise.
    def is_scheme_changed
      return (!(@scheme).nil?)
    end
    
    typesig { [] }
    # Returns whether or not the scheme became defined
    # 
    # @return <code>true</code> if the scheme became defined.
    def is_scheme_defined
      return ((!((self.attr_changed_values & CHANGED_SCHEME_DEFINED)).equal?(0)) && (!(@scheme).nil?))
    end
    
    private
    alias_method :initialize__binding_manager_event, :initialize
  end
  
end
