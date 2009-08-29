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
  module KeySequenceImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Bindings::Keys
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :StringTokenizer
      include_const ::Org::Eclipse::Jface::Bindings, :TriggerSequence
      include_const ::Org::Eclipse::Jface::Bindings::Keys::Formatting, :KeyFormatterFactory
      include_const ::Org::Eclipse::Jface::Util, :Util
    }
  end
  
  # <p>
  # A <code>KeySequence</code> is defined as a list of zero or more
  # <code>KeyStrokes</code>, with the stipulation that all
  # <code>KeyStroke</code> objects must be complete, save for the last one,
  # whose completeness is optional. A <code>KeySequence</code> is said to be
  # complete if all of its <code>KeyStroke</code> objects are complete.
  # </p>
  # <p>
  # All <code>KeySequence</code> objects have a formal string representation
  # available via the <code>toString()</code> method. There are a number of
  # methods to get instances of <code>KeySequence</code> objects, including one
  # which can parse this formal string representation.
  # </p>
  # <p>
  # All <code>KeySequence</code> objects, via the <code>format()</code>
  # method, provide a version of their formal string representation translated by
  # platform and locale, suitable for display to a user.
  # </p>
  # <p>
  # <code>KeySequence</code> objects are immutable. Clients are not permitted
  # to extend this class.
  # </p>
  # 
  # @since 3.1
  class KeySequence < KeySequenceImports.const_get :TriggerSequence
    include_class_members KeySequenceImports
    overload_protected {
      include JavaComparable
    }
    
    class_module.module_eval {
      # An empty key sequence instance for use by everyone.
      const_set_lazy(:EMPTY_KEY_SEQUENCE) { KeySequence.new(Array.typed(KeyStroke).new(0) { nil }) }
      const_attr_reader  :EMPTY_KEY_SEQUENCE
      
      # The delimiter between multiple key strokes in a single key sequence --
      # expressed in the formal key stroke grammar. This is not to be displayed
      # to the user. It is only intended as an internal representation.
      const_set_lazy(:KEY_STROKE_DELIMITER) { ("".to_u << 0x0020 << "") }
      const_attr_reader  :KEY_STROKE_DELIMITER
      
      # $NON-NLS-1$
      # 
      # The set of delimiters for <code>KeyStroke</code> objects allowed during
      # parsing of the formal string representation.
      const_set_lazy(:KEY_STROKE_DELIMITERS) { KEY_STROKE_DELIMITER + ("\b\r".to_u << 0x007F << "".to_u << 0x001B << "\f\n\0\t".to_u << 0x000B << "") }
      const_attr_reader  :KEY_STROKE_DELIMITERS
      
      typesig { [] }
      # $NON-NLS-1$
      # 
      # Gets an instance of <code>KeySequence</code>.
      # 
      # @return a key sequence. This key sequence will have no key strokes.
      # Guaranteed not to be <code>null</code>.
      def get_instance
        return EMPTY_KEY_SEQUENCE
      end
      
      typesig { [KeySequence, KeyStroke] }
      # Creates an instance of <code>KeySequence</code> given a key sequence
      # and a key stroke.
      # 
      # @param keySequence
      # a key sequence. Must not be <code>null</code>.
      # @param keyStroke
      # a key stroke. Must not be <code>null</code>.
      # @return a key sequence that is equal to the given key sequence with the
      # given key stroke appended to the end. Guaranteed not to be
      # <code>null</code>.
      def get_instance(key_sequence, key_stroke)
        if ((key_sequence).nil? || (key_stroke).nil?)
          raise NullPointerException.new
        end
        old_key_strokes = key_sequence.get_key_strokes
        old_key_stroke_length = old_key_strokes.attr_length
        new_key_strokes = Array.typed(KeyStroke).new(old_key_stroke_length + 1) { nil }
        System.arraycopy(old_key_strokes, 0, new_key_strokes, 0, old_key_stroke_length)
        new_key_strokes[old_key_stroke_length] = key_stroke
        return KeySequence.new(new_key_strokes)
      end
      
      typesig { [KeyStroke] }
      # Creates an instance of <code>KeySequence</code> given a single key
      # stroke.
      # 
      # @param keyStroke
      # a single key stroke. Must not be <code>null</code>.
      # @return a key sequence. Guaranteed not to be <code>null</code>.
      def get_instance(key_stroke)
        return KeySequence.new(Array.typed(KeyStroke).new([key_stroke]))
      end
      
      typesig { [Array.typed(KeyStroke)] }
      # Creates an instance of <code>KeySequence</code> given an array of key
      # strokes.
      # 
      # @param keyStrokes
      # the array of key strokes. This array may be empty, but it must
      # not be <code>null</code>. This array must not contain
      # <code>null</code> elements.
      # @return a key sequence. Guaranteed not to be <code>null</code>.
      def get_instance(key_strokes)
        return KeySequence.new(key_strokes)
      end
      
      typesig { [JavaList] }
      # Creates an instance of <code>KeySequence</code> given a list of key
      # strokes.
      # 
      # @param keyStrokes
      # the list of key strokes. This list may be empty, but it must
      # not be <code>null</code>. If this list is not empty, it
      # must only contain instances of <code>KeyStroke</code>.
      # @return a key sequence. Guaranteed not to be <code>null</code>.
      def get_instance(key_strokes)
        return KeySequence.new(key_strokes.to_array(Array.typed(KeyStroke).new(key_strokes.size) { nil }))
      end
      
      typesig { [String] }
      # Creates an instance of <code>KeySequence</code> by parsing a given
      # formal string representation.
      # 
      # @param string
      # the formal string representation to parse.
      # @return a key sequence. Guaranteed not to be <code>null</code>.
      # @throws ParseException
      # if the given formal string representation could not be parsed
      # to a valid key sequence.
      def get_instance(string)
        if ((string).nil?)
          raise NullPointerException.new
        end
        key_strokes = ArrayList.new
        string_tokenizer = StringTokenizer.new(string, KEY_STROKE_DELIMITERS)
        begin
          while (string_tokenizer.has_more_tokens)
            key_strokes.add(KeyStroke.get_instance(string_tokenizer.next_token))
          end
          key_stroke_array = key_strokes.to_array(Array.typed(KeyStroke).new(key_strokes.size) { nil })
          return KeySequence.new(key_stroke_array)
        rescue IllegalArgumentException => e
          # $NON-NLS-1$
          raise ParseException.new("Could not construct key sequence with these key strokes: " + RJava.cast_to_string(key_strokes))
        rescue NullPointerException => e
          # $NON-NLS-1$
          raise ParseException.new("Could not construct key sequence with these key strokes: " + RJava.cast_to_string(key_strokes))
        end
      end
    }
    
    typesig { [Array.typed(KeyStroke)] }
    # Constructs an instance of <code>KeySequence</code> given a list of key
    # strokes.
    # 
    # @param keyStrokes
    # the list of key strokes. This list may be empty, but it must
    # not be <code>null</code>. If this list is not empty, it
    # must only contain instances of <code>KeyStroke</code>.
    def initialize(key_strokes)
      super(key_strokes)
      i = 0
      while i < self.attr_triggers.attr_length - 1
        key_stroke = self.attr_triggers[i]
        if (!key_stroke.is_complete)
          raise IllegalArgumentException.new
        end
        i += 1
      end
    end
    
    typesig { [Object] }
    # (non-Javadoc)
    # 
    # @see java.lang.Object#compareTo(java.lang.Object)
    def compare_to(object)
      casted_object = object
      return Util.compare(self.attr_triggers, casted_object.attr_triggers)
    end
    
    typesig { [] }
    # Formats this key sequence into the current default look.
    # 
    # @return A string representation for this key sequence using the default
    # look; never <code>null</code>.
    def format
      return KeyFormatterFactory.get_default.format(self)
    end
    
    typesig { [] }
    # Returns the list of key strokes for this key sequence.
    # 
    # @return the list of key strokes keys. This list may be empty, but is
    # guaranteed not to be <code>null</code>. If this list is not
    # empty, it is guaranteed to only contain instances of
    # <code>KeyStroke</code>.
    def get_key_strokes
      trigger_length = self.attr_triggers.attr_length
      key_strokes = Array.typed(KeyStroke).new(trigger_length) { nil }
      System.arraycopy(self.attr_triggers, 0, key_strokes, 0, trigger_length)
      return key_strokes
    end
    
    typesig { [] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.bindings.TriggerSequence#getPrefixes()
    def get_prefixes
      number_of_prefixes = self.attr_triggers.attr_length
      prefixes = Array.typed(TriggerSequence).new(number_of_prefixes) { nil }
      prefixes[0] = KeySequence.get_instance
      i = 0
      while i < number_of_prefixes - 1
        prefix_key_strokes = Array.typed(KeyStroke).new(i + 1) { nil }
        System.arraycopy(self.attr_triggers, 0, prefix_key_strokes, 0, i + 1)
        prefixes[i + 1] = KeySequence.get_instance(prefix_key_strokes)
        i += 1
      end
      return prefixes
    end
    
    typesig { [] }
    # Returns whether or not this key sequence is complete. Key sequences are
    # complete iff all of their key strokes are complete.
    # 
    # @return <code>true</code>, iff the key sequence is complete.
    def is_complete
      triggers_length = self.attr_triggers.attr_length
      i = 0
      while i < triggers_length
        if (!(self.attr_triggers[i]).is_complete)
          return false
        end
        i += 1
      end
      return true
    end
    
    typesig { [] }
    # Returns the formal string representation for this key sequence.
    # 
    # @return The formal string representation for this key sequence.
    # Guaranteed not to be <code>null</code>.
    # @see java.lang.Object#toString()
    def to_s
      return KeyFormatterFactory.get_formal_key_formatter.format(self)
    end
    
    private
    alias_method :initialize__key_sequence, :initialize
  end
  
end
