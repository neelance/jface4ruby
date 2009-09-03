require "rjava"

# Copyright (c) 2000, 2005 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Formatter
  module FormattingContextImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Formatter
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :Map
      include_const ::Org::Eclipse::Jface::Preference, :IPreferenceStore
    }
  end
  
  # Default implementation of <code>IFormattingContext</code>.
  # 
  # @since 3.0
  class FormattingContext 
    include_class_members FormattingContextImports
    include IFormattingContext
    
    # Map to store the properties
    attr_accessor :f_map
    alias_method :attr_f_map, :f_map
    undef_method :f_map
    alias_method :attr_f_map=, :f_map=
    undef_method :f_map=
    
    typesig { [] }
    # @see org.eclipse.jface.text.formatter.IFormattingContext#dispose()
    def dispose
      @f_map.clear
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.formatter.IFormattingContext#getPreferenceKeys()
    def get_preference_keys
      return Array.typed(String).new([])
    end
    
    typesig { [Object] }
    # @see org.eclipse.jface.text.formatter.IFormattingContext#getProperty(java.lang.Object)
    def get_property(key)
      return @f_map.get(key)
    end
    
    typesig { [String] }
    # @see org.eclipse.jface.text.formatter.IFormattingContext#isBooleanPreference(java.lang.String)
    def is_boolean_preference(key)
      return false
    end
    
    typesig { [String] }
    # @see org.eclipse.jface.text.formatter.IFormattingContext#isDoublePreference(java.lang.String)
    def is_double_preference(key)
      return false
    end
    
    typesig { [String] }
    # @see org.eclipse.jface.text.formatter.IFormattingContext#isFloatPreference(java.lang.String)
    def is_float_preference(key)
      return false
    end
    
    typesig { [String] }
    # @see org.eclipse.jface.text.formatter.IFormattingContext#isIntegerPreference(java.lang.String)
    def is_integer_preference(key)
      return false
    end
    
    typesig { [String] }
    # @see org.eclipse.jface.text.formatter.IFormattingContext#isLongPreference(java.lang.String)
    def is_long_preference(key)
      return false
    end
    
    typesig { [String] }
    # @see org.eclipse.jface.text.formatter.IFormattingContext#isStringPreference(java.lang.String)
    def is_string_preference(key)
      return false
    end
    
    typesig { [Map, IPreferenceStore] }
    # @see org.eclipse.jface.text.formatter.IFormattingContext#mapToStore(java.util.Map, org.eclipse.jface.preference.IPreferenceStore)
    def map_to_store(map, store)
      preferences = get_preference_keys
      result = nil
      preference = nil
      index = 0
      while index < preferences.attr_length
        preference = RJava.cast_to_string(preferences[index])
        result = RJava.cast_to_string(map.get(preference))
        if (!(result).nil?)
          begin
            if (is_boolean_preference(preference))
              store.set_value(preference, (result == IPreferenceStore::TRUE))
            else
              if (is_integer_preference(preference))
                store.set_value(preference, JavaInteger.parse_int(result))
              else
                if (is_string_preference(preference))
                  store.set_value(preference, result)
                else
                  if (is_double_preference(preference))
                    store.set_value(preference, Double.parse_double(result))
                  else
                    if (is_float_preference(preference))
                      store.set_value(preference, Float.parse_float(result))
                    else
                      if (is_long_preference(preference))
                        store.set_value(preference, Long.parse_long(result))
                      end
                    end
                  end
                end
              end
            end
          rescue NumberFormatException => exception
            # Do nothing
          end
        end
        index += 1
      end
    end
    
    typesig { [Object, Object] }
    # @see org.eclipse.jface.text.formatter.IFormattingContext#setProperty(java.lang.Object, java.lang.Object)
    def set_property(key, property)
      @f_map.put(key, property)
    end
    
    typesig { [IPreferenceStore, Map, ::Java::Boolean] }
    # @see org.eclipse.jface.text.formatter.IFormattingContext#storeToMap(org.eclipse.jface.preference.IPreferenceStore, java.util.Map, boolean)
    def store_to_map(store, map, use_default)
      preferences = get_preference_keys
      preference = nil
      index = 0
      while index < preferences.attr_length
        preference = RJava.cast_to_string(preferences[index])
        if (is_boolean_preference(preference))
          map.put(preference, (use_default ? store.get_default_boolean(preference) : store.get_boolean(preference)) ? IPreferenceStore::TRUE : IPreferenceStore::FALSE)
        else
          if (is_integer_preference(preference))
            map.put(preference, String.value_of(use_default ? store.get_default_int(preference) : store.get_int(preference)))
          else
            if (is_string_preference(preference))
              map.put(preference, use_default ? store.get_default_string(preference) : store.get_string(preference))
            else
              if (is_double_preference(preference))
                map.put(preference, String.value_of(use_default ? store.get_default_double(preference) : store.get_double(preference)))
              else
                if (is_float_preference(preference))
                  map.put(preference, String.value_of(use_default ? store.get_default_float(preference) : store.get_float(preference)))
                else
                  if (is_long_preference(preference))
                    map.put(preference, String.value_of(use_default ? store.get_default_long(preference) : store.get_long(preference)))
                  end
                end
              end
            end
          end
        end
        index += 1
      end
    end
    
    typesig { [] }
    def initialize
      @f_map = HashMap.new
    end
    
    private
    alias_method :initialize__formatting_context, :initialize
  end
  
end
