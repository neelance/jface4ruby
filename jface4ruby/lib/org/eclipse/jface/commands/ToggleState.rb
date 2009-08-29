require "rjava"

# Copyright (c) 2005, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Commands
  module ToggleStateImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Commands
      include_const ::Org::Eclipse::Jface::Menus, :IMenuStateIds
      include_const ::Org::Eclipse::Jface::Preference, :IPreferenceStore
    }
  end
  
  # <p>
  # A piece of state storing a {@link Boolean}.
  # </p>
  # <p>
  # If this state is registered using {@link IMenuStateIds#STYLE}, then it will
  # control the presentation of the command if displayed in the menus, tool bars
  # or status line.
  # </p>
  # <p>
  # Clients may instantiate this class, but must not extend.
  # </p>
  # 
  # @since 3.2
  class ToggleState < ToggleStateImports.const_get :PersistentState
    include_class_members ToggleStateImports
    
    typesig { [] }
    # Constructs a new <code>ToggleState</code>. By default, the toggle is
    # off (e.g., <code>false</code>).
    def initialize
      super()
      set_value(Boolean::FALSE)
    end
    
    typesig { [IPreferenceStore, String] }
    def load(store, preference_key)
      current_value = (get_value).boolean_value
      store.set_default(preference_key, current_value)
      if (should_persist && (store.contains(preference_key)))
        value = store.get_boolean(preference_key)
        set_value(value ? Boolean::TRUE : Boolean::FALSE)
      end
    end
    
    typesig { [IPreferenceStore, String] }
    def save(store, preference_key)
      if (should_persist)
        value = get_value
        if (value.is_a?(Boolean))
          store.set_value(preference_key, (value).boolean_value)
        end
      end
    end
    
    typesig { [Object] }
    def set_value(value)
      if (!(value.is_a?(Boolean)))
        raise IllegalArgumentException.new("ToggleState takes a Boolean as a value") # $NON-NLS-1$
      end
      super(value)
    end
    
    private
    alias_method :initialize__toggle_state, :initialize
  end
  
end
