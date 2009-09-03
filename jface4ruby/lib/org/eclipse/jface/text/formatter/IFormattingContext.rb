require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Formatter
  module IFormattingContextImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Formatter
      include_const ::Java::Util, :Map
      include_const ::Org::Eclipse::Jface::Preference, :IPreferenceStore
    }
  end
  
  # Formatting context used in formatting strategies implementing interface
  # <code>IFormattingStrategyExtension</code>.
  # 
  # @see IFormattingStrategyExtension
  # @since 3.0
  module IFormattingContext
    include_class_members IFormattingContextImports
    
    typesig { [] }
    # Dispose of the formatting context.
    # <p>
    # Must be called after the formatting context has been used in a formatting process.
    def dispose
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the preference keys used for the retrieval of formatting preferences.
    # 
    # @return The preference keys for formatting
    def get_preference_keys
      raise NotImplementedError
    end
    
    typesig { [Object] }
    # Retrieves the property <code>key</code> from the formatting context
    # 
    # @param key the key of the property to store in the context
    # @return the property <code>key</code> if available, <code>null</code> otherwise
    def get_property(key)
      raise NotImplementedError
    end
    
    typesig { [String] }
    # Is this preference key for a boolean preference?
    # 
    # @param key the preference key to query its type
    # @return <code>true</code> iff this key is for a boolean preference, <code>false</code>
    # otherwise.
    def is_boolean_preference(key)
      raise NotImplementedError
    end
    
    typesig { [String] }
    # Is this preference key for a double preference?
    # 
    # @param key the preference key to query its type
    # @return <code>true</code> iff this key is for a double preference, <code>false</code>
    # otherwise.
    def is_double_preference(key)
      raise NotImplementedError
    end
    
    typesig { [String] }
    # Is this preference key for a float preference?
    # 
    # @param key The preference key to query its type
    # @return <code>true</code> iff this key is for a float preference, <code>false</code>
    # otherwise.
    def is_float_preference(key)
      raise NotImplementedError
    end
    
    typesig { [String] }
    # Is this preference key for an integer preference?
    # 
    # @param key The preference key to query its type
    # @return <code>true</code> iff this key is for an integer preference, <code>false</code>
    # otherwise.
    def is_integer_preference(key)
      raise NotImplementedError
    end
    
    typesig { [String] }
    # Is this preference key for a long preference?
    # 
    # @param key The preference key to query its type
    # @return <code>true</code> iff this key is for a long preference, <code>false</code>
    # otherwise.
    def is_long_preference(key)
      raise NotImplementedError
    end
    
    typesig { [String] }
    # Is this preference key for a string preference?
    # 
    # @param key The preference key to query its type
    # @return <code>true</code> iff this key is for a string preference, <code>false</code>
    # otherwise.
    def is_string_preference(key)
      raise NotImplementedError
    end
    
    typesig { [Map, IPreferenceStore] }
    # Stores the preferences from a map to a preference store.
    # <p>
    # Note that the preference keys returned by {@link #getPreferenceKeys()} must not be used in
    # the preference store. Otherwise the preferences are overwritten.
    # </p>
    # 
    # @param map Map to retrieve the preferences from
    # @param store Preference store to store the preferences in
    def map_to_store(map, store)
      raise NotImplementedError
    end
    
    typesig { [Object, Object] }
    # Stores the property <code>key</code> in the formatting context.
    # 
    # @param key Key of the property to store in the context
    # @param property Property to store in the context. If already present, the new property
    # overwrites the present one.
    def set_property(key, property)
      raise NotImplementedError
    end
    
    typesig { [IPreferenceStore, Map, ::Java::Boolean] }
    # Retrieves the preferences from a preference store in a map.
    # <p>
    # Note that the preference keys returned by {@link #getPreferenceKeys()} must not be used in
    # the map. Otherwise the preferences are overwritten.
    # </p>
    # 
    # @param store Preference store to retrieve the preferences from
    # @param map Map to store the preferences in
    # @param useDefault <code>true</code> if the default preferences should be used,
    # <code>false</code> otherwise
    def store_to_map(store, map, use_default)
      raise NotImplementedError
    end
  end
  
end
