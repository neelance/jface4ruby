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
  module FormalKeyFormatterImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Bindings::Keys::Formatting
      include_const ::Org::Eclipse::Jface::Bindings::Keys, :IKeyLookup
      include_const ::Org::Eclipse::Jface::Bindings::Keys, :KeyLookupFactory
      include_const ::Org::Eclipse::Jface::Bindings::Keys, :KeySequence
      include_const ::Org::Eclipse::Jface::Bindings::Keys, :KeyStroke
    }
  end
  
  # <p>
  # Formats the keys in the internal key sequence grammar. This is used for
  # persistence, and is not really intended for display to the user.
  # </p>
  # 
  # @since 3.1
  class FormalKeyFormatter < FormalKeyFormatterImports.const_get :AbstractKeyFormatter
    include_class_members FormalKeyFormatterImports
    
    typesig { [::Java::Int] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.bindings.keys.KeyFormatter#format(org.eclipse.ui.keys.KeySequence)
    def format(key)
      lookup = KeyLookupFactory.get_default
      return lookup.formal_name_lookup(key)
    end
    
    typesig { [] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.bindings.keys.AbstractKeyFormatter#getKeyDelimiter()
    def get_key_delimiter
      return KeyStroke::KEY_DELIMITER
    end
    
    typesig { [] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.bindings.keys.AbstractKeyFormatter#getKeyStrokeDelimiter()
    def get_key_stroke_delimiter
      return KeySequence::KEY_STROKE_DELIMITER
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
    alias_method :initialize__formal_key_formatter, :initialize
  end
  
end
