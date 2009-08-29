require "rjava"

# Copyright (c) 2004, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Bindings::Keys::Formatting
  module AbstractKeyFormatterImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Bindings::Keys::Formatting
      include_const ::Java::Util, :Enumeration
      include_const ::Java::Util, :HashSet
      include_const ::Java::Util, :ResourceBundle
      include_const ::Java::Util, :JavaSet
      include_const ::Org::Eclipse::Jface::Bindings::Keys, :IKeyLookup
      include_const ::Org::Eclipse::Jface::Bindings::Keys, :KeyLookupFactory
      include_const ::Org::Eclipse::Jface::Bindings::Keys, :KeySequence
      include_const ::Org::Eclipse::Jface::Bindings::Keys, :KeyStroke
      include_const ::Org::Eclipse::Jface::Util, :Util
    }
  end
  
  # <p>
  # An abstract implementation of a key formatter that provides a lot of common
  # key formatting functionality. It is recommended that implementations of
  # <code>IKeyFormatter</code> subclass from here, rather than implementing
  # <code>IKeyFormatter</code> directly.
  # </p>
  # 
  # @since 3.1
  class AbstractKeyFormatter 
    include_class_members AbstractKeyFormatterImports
    include IKeyFormatter
    
    class_module.module_eval {
      # The key for the delimiter between keys. This is used in the
      # internationalization bundles.
      const_set_lazy(:KEY_DELIMITER_KEY) { "KEY_DELIMITER" }
      const_attr_reader  :KEY_DELIMITER_KEY
      
      # $NON-NLS-1$
      # 
      # The key for the delimiter between key strokes. This is used in the
      # internationalization bundles.
      const_set_lazy(:KEY_STROKE_DELIMITER_KEY) { "KEY_STROKE_DELIMITER" }
      const_attr_reader  :KEY_STROKE_DELIMITER_KEY
      
      # $NON-NLS-1$
      # 
      # An empty integer array that can be used in
      # <code>sortModifierKeys(int)</code>.
      const_set_lazy(:NO_MODIFIER_KEYS) { Array.typed(::Java::Int).new(0) { 0 } }
      const_attr_reader  :NO_MODIFIER_KEYS
      
      # The bundle in which to look up the internationalized text for all of the
      # individual keys in the system. This is the platform-agnostic version of
      # the internationalized strings. Some platforms (namely Carbon) provide
      # special Unicode characters and glyphs for some keys.
      const_set_lazy(:RESOURCE_BUNDLE) { ResourceBundle.get_bundle(AbstractKeyFormatter.get_name) }
      const_attr_reader  :RESOURCE_BUNDLE
      
      # The keys in the resource bundle. This is used to avoid missing resource
      # exceptions when they aren't necessary.
      const_set_lazy(:ResourceBundleKeys) { HashSet.new }
      const_attr_reader  :ResourceBundleKeys
      
      when_class_loaded do
        key_enumeration = RESOURCE_BUNDLE.get_keys
        while (key_enumeration.has_more_elements)
          element = key_enumeration.next_element
          ResourceBundleKeys.add(element)
        end
      end
    }
    
    typesig { [::Java::Int] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.bindings.keysKeyFormatter#format(org.eclipse.jface.bindings.keys.KeySequence)
    def format(key)
      lookup = KeyLookupFactory.get_default
      name = lookup.formal_name_lookup(key)
      if (ResourceBundleKeys.contains(name))
        return Util.translate_string(RESOURCE_BUNDLE, name, name)
      end
      return name
    end
    
    typesig { [KeySequence] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.bindings.keys.KeyFormatter#format(org.eclipse.jface.bindings.keys.KeySequence)
    def format(key_sequence)
      string_buffer = StringBuffer.new
      key_strokes = key_sequence.get_key_strokes
      key_strokes_length = key_strokes.attr_length
      i = 0
      while i < key_strokes_length
        string_buffer.append(format(key_strokes[i]))
        if (i + 1 < key_strokes_length)
          string_buffer.append(get_key_stroke_delimiter)
        end
        i += 1
      end
      return string_buffer.to_s
    end
    
    typesig { [KeyStroke] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.bindings.keys.KeyFormatter#formatKeyStroke(org.eclipse.jface.bindings.keys.KeyStroke)
    def format(key_stroke)
      key_delimiter = get_key_delimiter
      # Format the modifier keys, in sorted order.
      modifier_keys = key_stroke.get_modifier_keys
      sorted_modifier_keys = sort_modifier_keys(modifier_keys)
      string_buffer = StringBuffer.new
      if (!(sorted_modifier_keys).nil?)
        i = 0
        while i < sorted_modifier_keys.attr_length
          modifier_key = sorted_modifier_keys[i]
          if (!(modifier_key).equal?(KeyStroke::NO_KEY))
            string_buffer.append(format(modifier_key))
            string_buffer.append(key_delimiter)
          end
          i += 1
        end
      end
      # Format the natural key, if any.
      natural_key = key_stroke.get_natural_key
      if (!(natural_key).equal?(0))
        string_buffer.append(format(natural_key))
      end
      return string_buffer.to_s
    end
    
    typesig { [] }
    # An accessor for the delimiter you wish to use between keys. This is used
    # by the default format implementations to determine the key delimiter.
    # 
    # @return The delimiter to use between keys; should not be
    # <code>null</code>.
    def get_key_delimiter
      raise NotImplementedError
    end
    
    typesig { [] }
    # An accessor for the delimiter you wish to use between key strokes. This
    # used by the default format implementations to determine the key stroke
    # delimiter.
    # 
    # @return The delimiter to use between key strokes; should not be
    # <code>null</code>.
    def get_key_stroke_delimiter
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    # Separates the modifier keys from each other, and then places them in an
    # array in some sorted order. The sort order is dependent on the type of
    # formatter.
    # 
    # @param modifierKeys
    # The modifier keys from the key stroke.
    # @return An array of modifier key values -- separated and sorted in some
    # order. Any values in this array that are
    # <code>KeyStroke.NO_KEY</code> should be ignored.
    def sort_modifier_keys(modifier_keys)
      raise NotImplementedError
    end
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__abstract_key_formatter, :initialize
  end
  
end
