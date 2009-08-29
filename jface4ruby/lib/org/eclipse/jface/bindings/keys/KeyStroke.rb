require "rjava"

# Copyright (c) 2004, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Bindings::Keys
  module KeyStrokeImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Bindings::Keys
      include_const ::Java::Util, :StringTokenizer
      include_const ::Org::Eclipse::Jface::Bindings, :Trigger
      include_const ::Org::Eclipse::Jface::Bindings::Keys::Formatting, :KeyFormatterFactory
      include_const ::Org::Eclipse::Jface::Util, :Util
    }
  end
  
  # <p>
  # A <code>KeyStroke</code> is defined as an optional set of modifier keys
  # followed optionally by a natural key. A <code>KeyStroke</code> is said to
  # be complete if it contains a natural key. A natural key is any Unicode
  # character (e.g., "backspace", etc.), any character belonging to a natural
  # language (e.g., "A", "1", "[", etc.), or any special control character
  # specific to computers (e.g., "F10", "PageUp", etc.).
  # </p>
  # <p>
  # All <code>KeyStroke</code> objects have a formal string representation
  # available via the <code>toString()</code> method. There are a number of
  # methods to get instances of <code>KeyStroke</code> objects, including one
  # which can parse this formal string representation.
  # </p>
  # <p>
  # All <code>KeyStroke</code> objects, via the <code>format()</code> method,
  # provide a version of their formal string representation translated by
  # platform and locale, suitable for display to a user.
  # </p>
  # <p>
  # <code>KeyStroke</code> objects are immutable. Clients are not permitted to
  # extend this class.
  # </p>
  # 
  # @since 3.1
  class KeyStroke < KeyStrokeImports.const_get :Trigger
    include_class_members KeyStrokeImports
    overload_protected {
      include JavaComparable
    }
    
    class_module.module_eval {
      # The delimiter between multiple keys in a single key strokes -- expressed
      # in the formal key stroke grammar. This is not to be displayed to the
      # user. It is only intended as an internal representation.
      const_set_lazy(:KEY_DELIMITER) { ("".to_u << 0x002B << "") }
      const_attr_reader  :KEY_DELIMITER
      
      # $NON-NLS-1$
      # 
      # The set of delimiters for <code>Key</code> objects allowed during
      # parsing of the formal string representation.
      const_set_lazy(:KEY_DELIMITERS) { KEY_DELIMITER }
      const_attr_reader  :KEY_DELIMITERS
      
      # The representation for no key.
      const_set_lazy(:NO_KEY) { 0 }
      const_attr_reader  :NO_KEY
      
      typesig { [::Java::Int] }
      # Creates an instance of <code>KeyStroke</code> given a natural key.
      # 
      # @param naturalKey
      # the natural key. The format of this integer is defined by
      # whichever widget toolkit you are using; <code>NO_KEY</code>
      # always means no natural key.
      # @return a key stroke. This key stroke will have no modifier keys.
      # Guaranteed not to be <code>null</code>.
      # @see SWTKeySupport
      def get_instance(natural_key)
        return KeyStroke.new(NO_KEY, natural_key)
      end
      
      typesig { [::Java::Int, ::Java::Int] }
      # Creates an instance of <code>KeyStroke</code> given a set of modifier keys
      # and a natural key.
      # 
      # @param modifierKeys
      # the modifier keys. The format of this integer is defined by
      # whichever widget toolkit you are using; <code>NO_KEY</code>
      # always means no modifier keys.
      # @param naturalKey
      # the natural key. The format of this integer is defined by
      # whichever widget toolkit you are using; <code>NO_KEY</code>
      # always means no natural key.
      # @return a key stroke. Guaranteed not to be <code>null</code>.
      # @see SWTKeySupport
      def get_instance(modifier_keys, natural_key)
        return KeyStroke.new(modifier_keys, natural_key)
      end
      
      typesig { [String] }
      # Creates an instance of <code>KeyStroke</code> by parsing a given a formal
      # string representation.
      # 
      # @param string
      # the formal string representation to parse.
      # @return a key stroke. Guaranteed not to be <code>null</code>.
      # @throws ParseException
      # if the given formal string representation could not be parsed
      # to a valid key stroke.
      def get_instance(string)
        if ((string).nil?)
          raise NullPointerException.new("Cannot parse a null string") # $NON-NLS-1$
        end
        lookup = KeyLookupFactory.get_default
        modifier_keys = NO_KEY
        natural_key = NO_KEY
        string_tokenizer = StringTokenizer.new(string, KEY_DELIMITERS, true)
        i = 0
        while (string_tokenizer.has_more_tokens)
          token = string_tokenizer.next_token
          if ((i % 2).equal?(0))
            if (string_tokenizer.has_more_tokens)
              token = RJava.cast_to_string(token.to_upper_case)
              modifier_key = lookup.formal_modifier_lookup(token)
              if ((modifier_key).equal?(NO_KEY))
                # $NON-NLS-1$
                raise ParseException.new("Cannot create key stroke with duplicate or non-existent modifier key: " + token)
              end
              modifier_keys |= modifier_key
            else
              if ((token.length).equal?(1))
                natural_key = token.char_at(0)
              else
                token = RJava.cast_to_string(token.to_upper_case)
                natural_key = lookup.formal_key_lookup(token)
              end
            end
          end
          i += 1
        end
        return KeyStroke.new(modifier_keys, natural_key)
      end
    }
    
    # An integer representation of the modifier keys; <code>NO_KEY</code>
    # means that there is no modifier key.
    attr_accessor :modifier_keys
    alias_method :attr_modifier_keys, :modifier_keys
    undef_method :modifier_keys
    alias_method :attr_modifier_keys=, :modifier_keys=
    undef_method :modifier_keys=
    
    # The natural key for this key stroke. This value is <code>NO_KEY</code>
    # if the key stroke is incomplete (i.e., has no natural key).
    attr_accessor :natural_key
    alias_method :attr_natural_key, :natural_key
    undef_method :natural_key
    alias_method :attr_natural_key=, :natural_key=
    undef_method :natural_key=
    
    typesig { [::Java::Int, ::Java::Int] }
    # Constructs an instance of <code>KeyStroke</code> given a set of
    # modifier keys and a natural key.
    # 
    # @param modifierKeys
    # the modifier keys. The format of this integer is defined by
    # whichever widget toolkit you are using; <code>NO_KEY</code>
    # always means no modifier keys.
    # @param naturalKey
    # the natural key. The format of this integer is defined by
    # whichever widget toolkit you are using; <code>NO_KEY</code>
    # always means no natural key.
    # @see SWTKeySupport
    def initialize(modifier_keys, natural_key)
      @modifier_keys = 0
      @natural_key = 0
      super()
      @modifier_keys = modifier_keys
      @natural_key = natural_key
    end
    
    typesig { [Object] }
    # (non-Javadoc)
    # 
    # @see java.lang.Comparable#compareTo(java.lang.Object)
    def compare_to(object)
      key_stroke = object
      compare_to = Util.compare(@modifier_keys, key_stroke.attr_modifier_keys)
      if ((compare_to).equal?(0))
        compare_to = Util.compare(@natural_key, key_stroke.attr_natural_key)
      end
      return compare_to
    end
    
    typesig { [Object] }
    # (non-Javadoc)
    # 
    # @see java.lang.Object#equals(java.lang.Object)
    def ==(object)
      if (!(object.is_a?(KeyStroke)))
        return false
      end
      key_stroke = object
      if (!(@modifier_keys).equal?(key_stroke.attr_modifier_keys))
        return false
      end
      return ((@natural_key).equal?(key_stroke.attr_natural_key))
    end
    
    typesig { [] }
    # Formats this key stroke into the current default look.
    # 
    # @return A string representation for this key stroke using the default
    # look; never <code>null</code>.
    def format
      return KeyFormatterFactory.get_default.format(self)
    end
    
    typesig { [] }
    # Returns the modifier keys for this key stroke.
    # 
    # @return the bit mask of modifier keys; <code>NO_KEY</code> means that
    # there is no modifier key.
    def get_modifier_keys
      return @modifier_keys
    end
    
    typesig { [] }
    # Returns the natural key for this key stroke.
    # 
    # @return The natural key for this key stroke. This value is
    # <code>NO_KEY</code> if the key stroke is incomplete (i.e., has
    # no natural key).
    def get_natural_key
      return @natural_key
    end
    
    typesig { [] }
    # (non-Javadoc)
    # 
    # @see java.lang.Object#hashCode()
    def hash_code
      return @modifier_keys << 4 + @natural_key
    end
    
    typesig { [] }
    # Returns whether or not this key stroke is complete. Key strokes are
    # complete iff they have a natural key which is not <code>NO_KEY</code>.
    # 
    # @return <code>true</code>, iff the key stroke is complete.
    def is_complete
      return (!(@natural_key).equal?(NO_KEY))
    end
    
    typesig { [] }
    # Returns the formal string representation for this key stroke.
    # 
    # @return The formal string representation for this key stroke. Guaranteed
    # not to be <code>null</code>.
    # @see java.lang.Object#toString()
    def to_s
      return KeyFormatterFactory.get_formal_key_formatter.format(self)
    end
    
    private
    alias_method :initialize__key_stroke, :initialize
  end
  
end
