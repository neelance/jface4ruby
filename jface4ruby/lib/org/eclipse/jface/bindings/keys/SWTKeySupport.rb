require "rjava"

# Copyright (c) 2004, 2007 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Bindings::Keys
  module SWTKeySupportImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Bindings::Keys
      include_const ::Org::Eclipse::Jface::Bindings::Keys::Formatting, :IKeyFormatter
      include_const ::Org::Eclipse::Jface::Bindings::Keys::Formatting, :NativeKeyFormatter
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Events, :KeyEvent
      include_const ::Org::Eclipse::Swt::Widgets, :Event
    }
  end
  
  # <p>
  # A utility class for converting SWT events into key strokes.
  # </p>
  # 
  # @since 3.1
  class SWTKeySupport 
    include_class_members SWTKeySupportImports
    
    class_module.module_eval {
      # A formatter that displays key sequences in a style native to the
      # platform.
      const_set_lazy(:NATIVE_FORMATTER) { NativeKeyFormatter.new }
      const_attr_reader  :NATIVE_FORMATTER
      
      typesig { [::Java::Int] }
      # Given an SWT accelerator value, provide the corresponding key stroke.
      # 
      # @param accelerator
      # The accelerator to convert; should be a valid SWT accelerator
      # value.
      # @return The equivalent key stroke; never <code>null</code>.
      def convert_accelerator_to_key_stroke(accelerator)
        modifier_keys = accelerator & SWT::MODIFIER_MASK
        natural_key = 0
        if ((accelerator).equal?(modifier_keys))
          natural_key = KeyStroke::NO_KEY
        else
          natural_key = accelerator - modifier_keys
        end
        return KeyStroke.get_instance(modifier_keys, natural_key)
      end
      
      typesig { [Event] }
      # <p>
      # Converts the given event into an SWT accelerator value -- considering the
      # modified character with the shift modifier. This is the third accelerator
      # value that should be checked when processing incoming key events.
      # </p>
      # <p>
      # For example, on a standard US keyboard, "Ctrl+Shift+5" would be viewed as
      # "Ctrl+Shift+%".
      # </p>
      # 
      # @param event
      # The event to be converted; must not be <code>null</code>.
      # @return The combination of the state mask and the unmodified character.
      def convert_event_to_modified_accelerator(event)
        modifiers = event.attr_state_mask & SWT::MODIFIER_MASK
        character = top_key(event)
        return modifiers + to_upper_case(character)
      end
      
      typesig { [Event] }
      # <p>
      # Converts the given event into an SWT accelerator value -- considering the
      # unmodified character with all modifier keys. This is the first
      # accelerator value that should be checked when processing incoming key
      # events. However, all alphabetic characters are considered as their
      # uppercase equivalents.
      # </p>
      # <p>
      # For example, on a standard US keyboard, "Ctrl+Shift+5" would be viewed as
      # "Ctrl+Shift+5".
      # </p>
      # 
      # @param event
      # The event to be converted; must not be <code>null</code>.
      # @return The combination of the state mask and the unmodified character.
      def convert_event_to_unmodified_accelerator(event)
        return convert_event_to_unmodified_accelerator(event.attr_state_mask, event.attr_key_code)
      end
      
      typesig { [::Java::Int, ::Java::Int] }
      # <p>
      # Converts the given state mask and key code into an SWT accelerator value --
      # considering the unmodified character with all modifier keys. All
      # alphabetic characters are considered as their uppercase equivalents.
      # </p>
      # <p>
      # For example, on a standard US keyboard, "Ctrl+Shift+5" would be viewed as
      # "Ctrl+Shift+5".
      # </p>
      # 
      # @param stateMask
      # The integer mask of modifiers keys depressed when this was
      # pressed.
      # @param keyCode
      # The key that was pressed, before being modified.
      # @return The combination of the state mask and the unmodified character.
      def convert_event_to_unmodified_accelerator(state_mask, key_code)
        modifiers = state_mask & SWT::MODIFIER_MASK
        character = key_code
        return modifiers + to_upper_case(character)
      end
      
      typesig { [KeyEvent] }
      # <p>
      # Converts the given event into an SWT accelerator value -- considering the
      # unmodified character with all modifier keys. This is the first
      # accelerator value that should be checked. However, all alphabetic
      # characters are considered as their uppercase equivalents.
      # </p>
      # <p>
      # For example, on a standard US keyboard, "Ctrl+Shift+5" would be viewed as
      # "Ctrl+%".
      # </p>
      # 
      # @param event
      # The event to be converted; must not be <code>null</code>.
      # @return The combination of the state mask and the unmodified character.
      def convert_event_to_unmodified_accelerator(event)
        return convert_event_to_unmodified_accelerator(event.attr_state_mask, event.attr_key_code)
      end
      
      typesig { [Event] }
      # Converts the given event into an SWT accelerator value -- considering the
      # modified character without the shift modifier. This is the second
      # accelerator value that should be checked when processing incoming key
      # events. Key strokes with alphabetic natural keys are run through
      # <code>convertEventToUnmodifiedAccelerator</code>.
      # 
      # @param event
      # The event to be converted; must not be <code>null</code>.
      # @return The combination of the state mask without shift, and the modified
      # character.
      def convert_event_to_unshifted_modified_accelerator(event)
        # Disregard alphabetic key strokes.
        if (Character.is_letter(RJava.cast_to_char(event.attr_key_code)))
          return convert_event_to_unmodified_accelerator(event)
        end
        modifiers = event.attr_state_mask & (SWT::MODIFIER_MASK ^ SWT::SHIFT)
        character = top_key(event)
        return modifiers + to_upper_case(character)
      end
      
      typesig { [KeyStroke] }
      # Given a key stroke, this method provides the equivalent SWT accelerator
      # value. The functional inverse of
      # <code>convertAcceleratorToKeyStroke</code>.
      # 
      # @param keyStroke
      # The key stroke to convert; must not be <code>null</code>.
      # @return The SWT accelerator value
      def convert_key_stroke_to_accelerator(key_stroke)
        return key_stroke.get_modifier_keys + key_stroke.get_natural_key
      end
      
      typesig { [] }
      # Provides an instance of <code>IKeyFormatter</code> appropriate for the
      # current instance.
      # 
      # @return an instance of <code>IKeyFormatter</code> appropriate for the
      # current instance; never <code>null</code>.
      def get_key_formatter_for_platform
        return NATIVE_FORMATTER
      end
      
      typesig { [Event] }
      # Makes sure that a fully-modified character is converted to the normal
      # form. This means that "Ctrl+" key strokes must reverse the modification
      # caused by control-escaping. Also, all lower case letters are converted to
      # uppercase.
      # 
      # @param event
      # The event from which the fully-modified character should be
      # pulled.
      # @return The modified character, uppercase and without control-escaping.
      def top_key(event)
        character = event.attr_character
        ctrl_down = !((event.attr_state_mask & SWT::CTRL)).equal?(0)
        if (ctrl_down && !(event.attr_character).equal?(event.attr_key_code) && event.attr_character < 0x20 && ((event.attr_key_code & SWT::KEYCODE_BIT)).equal?(0))
          character += 0x40
        end
        return character
      end
      
      typesig { [::Java::Int] }
      # Makes the given character uppercase if it is a letter.
      # 
      # @param keyCode
      # The character to convert.
      # @return The uppercase equivalent, if any; otherwise, the character
      # itself.
      def to_upper_case(key_code)
        # Will this key code be truncated?
        if (key_code > 0xffff)
          return key_code
        end
        # Downcast in safety. Only make characters uppercase.
        character = RJava.cast_to_char(key_code)
        return Character.is_letter(character) ? Character.to_upper_case(character) : key_code
      end
    }
    
    typesig { [] }
    # This class should never be instantiated.
    def initialize
      # This class should never be instantiated.
    end
    
    private
    alias_method :initialize__swtkey_support, :initialize
  end
  
end
