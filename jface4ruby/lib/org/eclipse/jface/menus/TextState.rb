require "rjava"

# Copyright (c) 2005, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Menus
  module TextStateImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Menus
      include_const ::Org::Eclipse::Core::Commands, :INamedHandleStateIds
      include_const ::Org::Eclipse::Jface::Commands, :PersistentState
      include_const ::Org::Eclipse::Jface::Preference, :IPreferenceStore
    }
  end
  
  # <p>
  # A piece of state carrying a single {@link String}.
  # </p>
  # <p>
  # If this state is registered using {@link INamedHandleStateIds#NAME} or
  # {@link INamedHandleStateIds#DESCRIPTION}, then this allows the handler to
  # communicate a textual change for a given command. This is typically used by
  # graphical applications to allow more specific text to be displayed in the
  # menus. For example, "Undo" might become "Undo Typing" through the use of a
  # {@link TextState}.
  # </p>
  # <p>
  # Clients may instantiate this class, but must not extend.
  # </p>
  # 
  # @since 3.2
  # @see INamedHandleStateIds
  class TextState < TextStateImports.const_get :PersistentState
    include_class_members TextStateImports
    
    typesig { [IPreferenceStore, String] }
    def load(store, preference_key)
      value = store.get_string(preference_key)
      set_value(value)
    end
    
    typesig { [IPreferenceStore, String] }
    def save(store, preference_key)
      value = get_value
      if (value.is_a?(String))
        store.set_value(preference_key, (value))
      end
    end
    
    typesig { [Object] }
    def set_value(value)
      if (!(value.is_a?(String)) && !(value).nil?)
        raise IllegalArgumentException.new("TextState takes a String as a value") # $NON-NLS-1$
      end
      super(value)
    end
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__text_state, :initialize
  end
  
end
