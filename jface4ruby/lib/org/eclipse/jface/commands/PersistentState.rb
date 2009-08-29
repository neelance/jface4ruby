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
  module PersistentStateImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Commands
      include_const ::Org::Eclipse::Core::Commands, :State
      include_const ::Org::Eclipse::Jface::Preference, :IPreferenceStore
    }
  end
  
  # <p>
  # This is a state that can be made persistent. A state is persisted to a
  # preference store.
  # </p>
  # <p>
  # Clients may extend this class.
  # </p>
  # 
  # @since 3.2
  class PersistentState < PersistentStateImports.const_get :State
    include_class_members PersistentStateImports
    
    # Whether this state should be persisted.
    attr_accessor :persisted
    alias_method :attr_persisted, :persisted
    undef_method :persisted
    alias_method :attr_persisted=, :persisted=
    undef_method :persisted=
    
    typesig { [IPreferenceStore, String] }
    # Loads this state from the preference store, given the location at which
    # to look. This method must be symmetric with a call to
    # {@link #save(IPreferenceStore, String)}.
    # 
    # @param store
    # The store from which to read; must not be <code>null</code>.
    # @param preferenceKey
    # The key at which the state is stored; must not be
    # <code>null</code>.
    def load(store, preference_key)
      raise NotImplementedError
    end
    
    typesig { [IPreferenceStore, String] }
    # Saves this state to the preference store, given the location at which to
    # write. This method must be symmetric with a call to
    # {@link #load(IPreferenceStore, String)}.
    # 
    # @param store
    # The store to which the state should be written; must not be
    # <code>null</code>.
    # @param preferenceKey
    # The key at which the state should be stored; must not be
    # <code>null</code>.
    def save(store, preference_key)
      raise NotImplementedError
    end
    
    typesig { [::Java::Boolean] }
    # Sets whether this state should be persisted.
    # 
    # @param persisted
    # Whether this state should be persisted.
    def set_should_persist(persisted)
      @persisted = persisted
    end
    
    typesig { [] }
    # Whether this state should be persisted. Subclasses should check this
    # method before loading or saving.
    # 
    # @return <code>true</code> if this state should be persisted;
    # <code>false</code> otherwise.
    def should_persist
      return @persisted
    end
    
    typesig { [] }
    def initialize
      @persisted = false
      super()
    end
    
    private
    alias_method :initialize__persistent_state, :initialize
  end
  
end
