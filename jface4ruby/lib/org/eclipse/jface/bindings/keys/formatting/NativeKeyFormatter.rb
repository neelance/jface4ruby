require "rjava"

# Copyright (c) 2004, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Bindings::Keys::Formatting
  module NativeKeyFormatterImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Bindings::Keys::Formatting
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :ResourceBundle
      include_const ::Org::Eclipse::Jface::Bindings::Keys, :IKeyLookup
      include_const ::Org::Eclipse::Jface::Bindings::Keys, :KeyLookupFactory
      include_const ::Org::Eclipse::Jface::Bindings::Keys, :KeySequence
      include_const ::Org::Eclipse::Jface::Bindings::Keys, :KeyStroke
      include_const ::Org::Eclipse::Jface::Util, :Util
    }
  end
  
  # <p>
  # Formats the key sequences and key strokes into the native human-readable
  # format. This is typically what you would see on the menus for the given
  # platform and locale.
  # </p>
  # 
  # @since 3.1
  class NativeKeyFormatter < NativeKeyFormatterImports.const_get :AbstractKeyFormatter
    include_class_members NativeKeyFormatterImports
    
    class_module.module_eval {
      # The key into the internationalization resource bundle for the delimiter
      # to use between keys (on the Carbon platform).
      const_set_lazy(:CARBON_KEY_DELIMITER_KEY) { "CARBON_KEY_DELIMITER" }
      const_attr_reader  :CARBON_KEY_DELIMITER_KEY
      
      # $NON-NLS-1$
      # 
      # A look-up table for the string representations of various carbon keys.
      const_set_lazy(:CARBON_KEY_LOOK_UP) { HashMap.new }
      const_attr_reader  :CARBON_KEY_LOOK_UP
      
      # The key into the internationalization resource bundle for the delimiter
      # to use between key strokes (on the Win32 platform).
      const_set_lazy(:WIN32_KEY_STROKE_DELIMITER_KEY) { "WIN32_KEY_STROKE_DELIMITER" }
      const_attr_reader  :WIN32_KEY_STROKE_DELIMITER_KEY
      
      # $NON-NLS-1$
      when_class_loaded do
        const_set :RESOURCE_BUNDLE, ResourceBundle.get_bundle(NativeKeyFormatter.get_name)
        carbon_backspace = ("".to_u << 0x232B << "") # $NON-NLS-1$
        CARBON_KEY_LOOK_UP.put(IKeyLookup::BS_NAME, carbon_backspace)
        CARBON_KEY_LOOK_UP.put(IKeyLookup::BACKSPACE_NAME, carbon_backspace)
        CARBON_KEY_LOOK_UP.put(IKeyLookup::CR_NAME, ("".to_u << 0x21A9 << "")) # $NON-NLS-1$
        carbon_delete = ("".to_u << 0x2326 << "") # $NON-NLS-1$
        CARBON_KEY_LOOK_UP.put(IKeyLookup::DEL_NAME, carbon_delete)
        CARBON_KEY_LOOK_UP.put(IKeyLookup::DELETE_NAME, carbon_delete)
        CARBON_KEY_LOOK_UP.put(IKeyLookup::SPACE_NAME, ("".to_u << 0x2423 << "")) # $NON-NLS-1$
        CARBON_KEY_LOOK_UP.put(IKeyLookup::ALT_NAME, ("".to_u << 0x2325 << "")) # $NON-NLS-1$
        CARBON_KEY_LOOK_UP.put(IKeyLookup::COMMAND_NAME, ("".to_u << 0x2318 << "")) # $NON-NLS-1$
        CARBON_KEY_LOOK_UP.put(IKeyLookup::CTRL_NAME, ("".to_u << 0x2303 << "")) # $NON-NLS-1$
        CARBON_KEY_LOOK_UP.put(IKeyLookup::SHIFT_NAME, ("".to_u << 0x21E7 << "")) # $NON-NLS-1$
        CARBON_KEY_LOOK_UP.put(IKeyLookup::ARROW_DOWN_NAME, ("".to_u << 0x2193 << "")) # $NON-NLS-1$
        CARBON_KEY_LOOK_UP.put(IKeyLookup::ARROW_LEFT_NAME, ("".to_u << 0x2190 << "")) # $NON-NLS-1$
        CARBON_KEY_LOOK_UP.put(IKeyLookup::ARROW_RIGHT_NAME, ("".to_u << 0x2192 << "")) # $NON-NLS-1$
        CARBON_KEY_LOOK_UP.put(IKeyLookup::ARROW_UP_NAME, ("".to_u << 0x2191 << "")) # $NON-NLS-1$
        CARBON_KEY_LOOK_UP.put(IKeyLookup::END_NAME, ("".to_u << 0x2198 << "")) # $NON-NLS-1$
        CARBON_KEY_LOOK_UP.put(IKeyLookup::NUMPAD_ENTER_NAME, ("".to_u << 0x2324 << "")) # $NON-NLS-1$
        CARBON_KEY_LOOK_UP.put(IKeyLookup::HOME_NAME, ("".to_u << 0x2196 << "")) # $NON-NLS-1$
        CARBON_KEY_LOOK_UP.put(IKeyLookup::PAGE_DOWN_NAME, ("".to_u << 0x21DF << "")) # $NON-NLS-1$
        CARBON_KEY_LOOK_UP.put(IKeyLookup::PAGE_UP_NAME, ("".to_u << 0x21DE << "")) # $NON-NLS-1$
      end
    }
    
    typesig { [::Java::Int] }
    # Formats an individual key into a human readable format. This uses an
    # internationalization resource bundle to look up the key. This does the
    # platform-specific formatting for Carbon.
    # 
    # @param key
    # The key to format.
    # @return The key formatted as a string; should not be <code>null</code>.
    def format(key)
      lookup = KeyLookupFactory.get_default
      name = lookup.formal_name_lookup(key)
      # TODO consider platform-specific resource bundles
      if (Util.is_mac)
        formatted_name = CARBON_KEY_LOOK_UP.get(name)
        if (!(formatted_name).nil?)
          return formatted_name
        end
      end
      return super(key)
    end
    
    typesig { [] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.bindings.keys.AbstractKeyFormatter#getKeyDelimiter()
    def get_key_delimiter
      # We must do the look up every time, as our locale might change.
      if (Util.is_mac)
        return Util.translate_string(RESOURCE_BUNDLE, CARBON_KEY_DELIMITER_KEY, Util::ZERO_LENGTH_STRING)
      end
      return Util.translate_string(RESOURCE_BUNDLE, KEY_DELIMITER_KEY, KeyStroke::KEY_DELIMITER)
    end
    
    typesig { [] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.bindings.keys.AbstractKeyFormatter#getKeyStrokeDelimiter()
    def get_key_stroke_delimiter
      # We must do the look up every time, as our locale might change.
      if (Util.is_windows)
        return Util.translate_string(RESOURCE_BUNDLE, WIN32_KEY_STROKE_DELIMITER_KEY, KeySequence::KEY_STROKE_DELIMITER)
      end
      return Util.translate_string(RESOURCE_BUNDLE, KEY_STROKE_DELIMITER_KEY, KeySequence::KEY_STROKE_DELIMITER)
    end
    
    typesig { [::Java::Int] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.bindings.keys.AbstractKeyFormatter#sortModifierKeys(int)
    def sort_modifier_keys(modifier_keys)
      lookup = KeyLookupFactory.get_default
      sorted_keys = Array.typed(::Java::Int).new(4) { 0 }
      index = 0
      if (Util.is_windows)
        if (!((modifier_keys & lookup.get_ctrl)).equal?(0))
          sorted_keys[((index += 1) - 1)] = lookup.get_ctrl
        end
        if (!((modifier_keys & lookup.get_alt)).equal?(0))
          sorted_keys[((index += 1) - 1)] = lookup.get_alt
        end
        if (!((modifier_keys & lookup.get_shift)).equal?(0))
          sorted_keys[((index += 1) - 1)] = lookup.get_shift
        end
      else
        if (Util.is_gtk || Util.is_motif)
          if (!((modifier_keys & lookup.get_shift)).equal?(0))
            sorted_keys[((index += 1) - 1)] = lookup.get_shift
          end
          if (!((modifier_keys & lookup.get_ctrl)).equal?(0))
            sorted_keys[((index += 1) - 1)] = lookup.get_ctrl
          end
          if (!((modifier_keys & lookup.get_alt)).equal?(0))
            sorted_keys[((index += 1) - 1)] = lookup.get_alt
          end
        else
          if (Util.is_mac)
            if (!((modifier_keys & lookup.get_shift)).equal?(0))
              sorted_keys[((index += 1) - 1)] = lookup.get_shift
            end
            if (!((modifier_keys & lookup.get_ctrl)).equal?(0))
              sorted_keys[((index += 1) - 1)] = lookup.get_ctrl
            end
            if (!((modifier_keys & lookup.get_alt)).equal?(0))
              sorted_keys[((index += 1) - 1)] = lookup.get_alt
            end
            if (!((modifier_keys & lookup.get_command)).equal?(0))
              sorted_keys[((index += 1) - 1)] = lookup.get_command
            end
          end
        end
      end
      return sorted_keys
    end
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__native_key_formatter, :initialize
  end
  
end
