require "rjava"

# Copyright (c) 2004, 2005 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Bindings::Keys::Formatting
  module EmacsKeyFormatterImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Bindings::Keys::Formatting
      include_const ::Java::Util, :ResourceBundle
      include_const ::Org::Eclipse::Jface::Bindings::Keys, :IKeyLookup
      include_const ::Org::Eclipse::Jface::Bindings::Keys, :KeyLookupFactory
      include_const ::Org::Eclipse::Jface::Bindings::Keys, :KeySequence
      include_const ::Org::Eclipse::Jface::Bindings::Keys, :KeyStroke
      include_const ::Org::Eclipse::Jface::Util, :Util
    }
  end
  
  # <p>
  # A key formatter providing the Emacs-style accelerators using single letters
  # to represent the modifier keys.
  # </p>
  # 
  # @since 3.1
  class EmacsKeyFormatter < EmacsKeyFormatterImports.const_get :AbstractKeyFormatter
    include_class_members EmacsKeyFormatterImports
    
    class_module.module_eval {
      # The resource bundle used by <code>format()</code> to translate formal
      # string representations by locale.
      const_set_lazy(:RESOURCE_BUNDLE) { ResourceBundle.get_bundle(EmacsKeyFormatter.get_name) }
      const_attr_reader  :RESOURCE_BUNDLE
    }
    
    typesig { [::Java::Int] }
    # Formats an individual key into a human readable format. This converts the
    # key into a format similar to Xemacs.
    # 
    # @param key
    # The key to format; must not be <code>null</code>.
    # @return The key formatted as a string; should not be <code>null</code>.
    def format(key)
      lookup = KeyLookupFactory.get_default
      if (lookup.is_modifier_key(key))
        formatted_name = Util.translate_string(RESOURCE_BUNDLE, lookup.formal_name_lookup(key), nil)
        if (!(formatted_name).nil?)
          return formatted_name
        end
      end
      return super(key).to_lower_case
    end
    
    typesig { [] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.bindings.keys.AbstractKeyFormatter#getKeyDelimiter()
    def get_key_delimiter
      return Util.translate_string(RESOURCE_BUNDLE, KEY_DELIMITER_KEY, KeyStroke::KEY_DELIMITER)
    end
    
    typesig { [] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.bindings.keys.AbstractKeyFormatter#getKeyStrokeDelimiter()
    def get_key_stroke_delimiter
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
      if (!((modifier_keys & lookup.get_alt)).equal?(0))
        sorted_keys[((index += 1) - 1)] = lookup.get_alt
      end
      if (!((modifier_keys & lookup.get_command)).equal?(0))
        sorted_keys[((index += 1) - 1)] = lookup.get_command
      end
      if (!((modifier_keys & lookup.get_ctrl)).equal?(0))
        sorted_keys[((index += 1) - 1)] = lookup.get_ctrl
      end
      if (!((modifier_keys & lookup.get_shift)).equal?(0))
        sorted_keys[((index += 1) - 1)] = lookup.get_shift
      end
      return sorted_keys
    end
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__emacs_key_formatter, :initialize
  end
  
end
