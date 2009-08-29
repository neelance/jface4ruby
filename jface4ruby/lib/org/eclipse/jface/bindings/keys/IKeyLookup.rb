require "rjava"

# Copyright (c) 2005 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Bindings::Keys
  module IKeyLookupImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Bindings::Keys
    }
  end
  
  # <p>
  # A facilitiy for converting the formal representation for key strokes
  # (i.e., used in persistence) into real key stroke instances.
  # </p>
  # 
  # @since 3.1
  module IKeyLookup
    include_class_members IKeyLookupImports
    
    class_module.module_eval {
      # The formal name of the 'Alt' key.
      const_set_lazy(:ALT_NAME) { "ALT" }
      const_attr_reader  :ALT_NAME
      
      # $NON-NLS-1$
      # 
      # The formal name of the 'Arrow Down' key.
      const_set_lazy(:ARROW_DOWN_NAME) { "ARROW_DOWN" }
      const_attr_reader  :ARROW_DOWN_NAME
      
      # $NON-NLS-1$
      # 
      # The formal name of the 'Arrow Left' key.
      const_set_lazy(:ARROW_LEFT_NAME) { "ARROW_LEFT" }
      const_attr_reader  :ARROW_LEFT_NAME
      
      # $NON-NLS-1$
      # 
      # The formal name of the 'Arrow Right' key.
      const_set_lazy(:ARROW_RIGHT_NAME) { "ARROW_RIGHT" }
      const_attr_reader  :ARROW_RIGHT_NAME
      
      # $NON-NLS-1$
      # 
      # The formal name of the 'Arrow Up' key.
      const_set_lazy(:ARROW_UP_NAME) { "ARROW_UP" }
      const_attr_reader  :ARROW_UP_NAME
      
      # $NON-NLS-1$
      # 
      # An alternate name for the backspace key.
      const_set_lazy(:BACKSPACE_NAME) { "BACKSPACE" }
      const_attr_reader  :BACKSPACE_NAME
      
      # $NON-NLS-1$
      # 
      # The formal name for the 'Break' key.
      const_set_lazy(:BREAK_NAME) { "BREAK" }
      const_attr_reader  :BREAK_NAME
      
      # $NON-NLS-1$
      # 
      # The formal name of the backspace key.
      const_set_lazy(:BS_NAME) { "BS" }
      const_attr_reader  :BS_NAME
      
      # $NON-NLS-1$
      # 
      # The formal name for the 'Caps Lock' key.
      const_set_lazy(:CAPS_LOCK_NAME) { "CAPS_LOCK" }
      const_attr_reader  :CAPS_LOCK_NAME
      
      # $NON-NLS-1$
      # 
      # The formal name of the 'Command' key.
      const_set_lazy(:COMMAND_NAME) { "COMMAND" }
      const_attr_reader  :COMMAND_NAME
      
      # $NON-NLS-1$
      # 
      # The formal name of the carriage return (U+000D)
      const_set_lazy(:CR_NAME) { "CR" }
      const_attr_reader  :CR_NAME
      
      # $NON-NLS-1$
      # 
      # The formal name of the 'Ctrl' key.
      const_set_lazy(:CTRL_NAME) { "CTRL" }
      const_attr_reader  :CTRL_NAME
      
      # $NON-NLS-1$
      # 
      # The formal name of the delete (U+007F) key
      const_set_lazy(:DEL_NAME) { "DEL" }
      const_attr_reader  :DEL_NAME
      
      # $NON-NLS-1$
      # 
      # An alternative name for the delete key.
      const_set_lazy(:DELETE_NAME) { "DELETE" }
      const_attr_reader  :DELETE_NAME
      
      # $NON-NLS-1$
      # 
      # The formal name of the 'End' key.
      const_set_lazy(:END_NAME) { "END" }
      const_attr_reader  :END_NAME
      
      # $NON-NLS-1$
      # 
      # An alternative name for the enter key.
      const_set_lazy(:ENTER_NAME) { "ENTER" }
      const_attr_reader  :ENTER_NAME
      
      # $NON-NLS-1$
      # 
      # The formal name of the escape (U+001B) key.
      const_set_lazy(:ESC_NAME) { "ESC" }
      const_attr_reader  :ESC_NAME
      
      # $NON-NLS-1$
      # 
      # An alternative name for the escape key.
      const_set_lazy(:ESCAPE_NAME) { "ESCAPE" }
      const_attr_reader  :ESCAPE_NAME
      
      # $NON-NLS-1$
      # 
      # The formal name of the 'F1' key.
      const_set_lazy(:F1_NAME) { "F1" }
      const_attr_reader  :F1_NAME
      
      # $NON-NLS-1$
      # 
      # The formal name of the 'F10' key.
      const_set_lazy(:F10_NAME) { "F10" }
      const_attr_reader  :F10_NAME
      
      # $NON-NLS-1$
      # 
      # The formal name of the 'F11' key.
      const_set_lazy(:F11_NAME) { "F11" }
      const_attr_reader  :F11_NAME
      
      # $NON-NLS-1$
      # 
      # The formal name of the 'F12' key.
      const_set_lazy(:F12_NAME) { "F12" }
      const_attr_reader  :F12_NAME
      
      # $NON-NLS-1$
      # 
      # The formal name of the 'F13' key.
      const_set_lazy(:F13_NAME) { "F13" }
      const_attr_reader  :F13_NAME
      
      # $NON-NLS-1$
      # 
      # The formal name of the 'F14' key.
      const_set_lazy(:F14_NAME) { "F14" }
      const_attr_reader  :F14_NAME
      
      # $NON-NLS-1$
      # 
      # The formal name of the 'F15' key.
      const_set_lazy(:F15_NAME) { "F15" }
      const_attr_reader  :F15_NAME
      
      # $NON-NLS-1$
      # 
      # The formal name of the 'F2' key.
      const_set_lazy(:F2_NAME) { "F2" }
      const_attr_reader  :F2_NAME
      
      # $NON-NLS-1$
      # 
      # The formal name of the 'F3' key.
      const_set_lazy(:F3_NAME) { "F3" }
      const_attr_reader  :F3_NAME
      
      # $NON-NLS-1$
      # 
      # The formal name of the 'F4' key.
      const_set_lazy(:F4_NAME) { "F4" }
      const_attr_reader  :F4_NAME
      
      # $NON-NLS-1$
      # 
      # The formal name of the 'F5' key.
      const_set_lazy(:F5_NAME) { "F5" }
      const_attr_reader  :F5_NAME
      
      # $NON-NLS-1$
      # 
      # The formal name of the 'F6' key.
      const_set_lazy(:F6_NAME) { "F6" }
      const_attr_reader  :F6_NAME
      
      # $NON-NLS-1$
      # 
      # The formal name of the 'F7' key.
      const_set_lazy(:F7_NAME) { "F7" }
      const_attr_reader  :F7_NAME
      
      # $NON-NLS-1$
      # 
      # The formal name of the 'F8' key.
      const_set_lazy(:F8_NAME) { "F8" }
      const_attr_reader  :F8_NAME
      
      # $NON-NLS-1$
      # 
      # The formal name of the 'F9' key.
      const_set_lazy(:F9_NAME) { "F9" }
      const_attr_reader  :F9_NAME
      
      # $NON-NLS-1$
      # 
      # The formal name of the form feed (U+000C) key.
      const_set_lazy(:FF_NAME) { "FF" }
      const_attr_reader  :FF_NAME
      
      # $NON-NLS-1$
      # 
      # The formal name of the 'Home' key.
      const_set_lazy(:HOME_NAME) { "HOME" }
      const_attr_reader  :HOME_NAME
      
      # $NON-NLS-1$
      # 
      # The formal name of the 'Insert' key.
      const_set_lazy(:INSERT_NAME) { "INSERT" }
      const_attr_reader  :INSERT_NAME
      
      # $NON-NLS-1$
      # 
      # The formal name of the line feed (U+000A) key.
      const_set_lazy(:LF_NAME) { "LF" }
      const_attr_reader  :LF_NAME
      
      # $NON-NLS-1$
      # 
      # The formal name of the 'M1' key.
      const_set_lazy(:M1_NAME) { "M1" }
      const_attr_reader  :M1_NAME
      
      # $NON-NLS-1$
      # 
      # The formal name of the 'M2' key.
      const_set_lazy(:M2_NAME) { "M2" }
      const_attr_reader  :M2_NAME
      
      # $NON-NLS-1$
      # 
      # The formal name of the 'M3' key.
      const_set_lazy(:M3_NAME) { "M3" }
      const_attr_reader  :M3_NAME
      
      # $NON-NLS-1$
      # 
      # The formal name of the 'M4' key.
      const_set_lazy(:M4_NAME) { "M4" }
      const_attr_reader  :M4_NAME
      
      # $NON-NLS-1$
      # 
      # The formal name of the null (U+0000) key.
      const_set_lazy(:NUL_NAME) { "NUL" }
      const_attr_reader  :NUL_NAME
      
      # $NON-NLS-1$
      # 
      # The formal name of the 'NumLock' key.
      const_set_lazy(:NUM_LOCK_NAME) { "NUM_LOCK" }
      const_attr_reader  :NUM_LOCK_NAME
      
      # $NON-NLS-1$
      # 
      # The formal name of the '0' key on the numpad.
      const_set_lazy(:NUMPAD_0_NAME) { "NUMPAD_0" }
      const_attr_reader  :NUMPAD_0_NAME
      
      # $NON-NLS-1$
      # 
      # The formal name of the '1' key on the numpad.
      const_set_lazy(:NUMPAD_1_NAME) { "NUMPAD_1" }
      const_attr_reader  :NUMPAD_1_NAME
      
      # $NON-NLS-1$
      # 
      # The formal name of the '2' key on the numpad.
      const_set_lazy(:NUMPAD_2_NAME) { "NUMPAD_2" }
      const_attr_reader  :NUMPAD_2_NAME
      
      # $NON-NLS-1$
      # 
      # The formal name of the '3' key on the numpad.
      const_set_lazy(:NUMPAD_3_NAME) { "NUMPAD_3" }
      const_attr_reader  :NUMPAD_3_NAME
      
      # $NON-NLS-1$
      # 
      # The formal name of the '4' key on the numpad.
      const_set_lazy(:NUMPAD_4_NAME) { "NUMPAD_4" }
      const_attr_reader  :NUMPAD_4_NAME
      
      # $NON-NLS-1$
      # 
      # The formal name of the '5' key on the numpad.
      const_set_lazy(:NUMPAD_5_NAME) { "NUMPAD_5" }
      const_attr_reader  :NUMPAD_5_NAME
      
      # $NON-NLS-1$
      # 
      # The formal name of the '6' key on the numpad.
      const_set_lazy(:NUMPAD_6_NAME) { "NUMPAD_6" }
      const_attr_reader  :NUMPAD_6_NAME
      
      # $NON-NLS-1$
      # 
      # The formal name of the '7' key on the numpad.
      const_set_lazy(:NUMPAD_7_NAME) { "NUMPAD_7" }
      const_attr_reader  :NUMPAD_7_NAME
      
      # $NON-NLS-1$
      # 
      # The formal name of the '8' key on the numpad.
      const_set_lazy(:NUMPAD_8_NAME) { "NUMPAD_8" }
      const_attr_reader  :NUMPAD_8_NAME
      
      # $NON-NLS-1$
      # 
      # The formal name of the '9' key on the numpad.
      const_set_lazy(:NUMPAD_9_NAME) { "NUMPAD_9" }
      const_attr_reader  :NUMPAD_9_NAME
      
      # $NON-NLS-1$
      # 
      # The formal name of the 'Add' key on the numpad.
      const_set_lazy(:NUMPAD_ADD_NAME) { "NUMPAD_ADD" }
      const_attr_reader  :NUMPAD_ADD_NAME
      
      # $NON-NLS-1$
      # 
      # The formal name of the 'Decimal' key on the numpad.
      const_set_lazy(:NUMPAD_DECIMAL_NAME) { "NUMPAD_DECIMAL" }
      const_attr_reader  :NUMPAD_DECIMAL_NAME
      
      # $NON-NLS-1$
      # 
      # The formal name of the 'Divide' key on the numpad.
      const_set_lazy(:NUMPAD_DIVIDE_NAME) { "NUMPAD_DIVIDE" }
      const_attr_reader  :NUMPAD_DIVIDE_NAME
      
      # $NON-NLS-1$
      # 
      # The formal name of the 'Enter' key on the numpad.
      const_set_lazy(:NUMPAD_ENTER_NAME) { "NUMPAD_ENTER" }
      const_attr_reader  :NUMPAD_ENTER_NAME
      
      # $NON-NLS-1$
      # 
      # The formal name of the '=' key on the numpad.
      const_set_lazy(:NUMPAD_EQUAL_NAME) { "NUMPAD_EQUAL" }
      const_attr_reader  :NUMPAD_EQUAL_NAME
      
      # $NON-NLS-1$
      # 
      # The formal name of the 'Multiply' key on the numpad.
      const_set_lazy(:NUMPAD_MULTIPLY_NAME) { "NUMPAD_MULTIPLY" }
      const_attr_reader  :NUMPAD_MULTIPLY_NAME
      
      # $NON-NLS-1$
      # 
      # The formal name of the 'Subtract' key on the numpad.
      const_set_lazy(:NUMPAD_SUBTRACT_NAME) { "NUMPAD_SUBTRACT" }
      const_attr_reader  :NUMPAD_SUBTRACT_NAME
      
      # $NON-NLS-1$
      # 
      # The formal name of the 'Page Down' key.
      const_set_lazy(:PAGE_DOWN_NAME) { "PAGE_DOWN" }
      const_attr_reader  :PAGE_DOWN_NAME
      
      # $NON-NLS-1$
      # 
      # The formal name of the 'Page Up' key.
      const_set_lazy(:PAGE_UP_NAME) { "PAGE_UP" }
      const_attr_reader  :PAGE_UP_NAME
      
      # $NON-NLS-1$
      # 
      # The formal name for the 'Pause' key.
      const_set_lazy(:PAUSE_NAME) { "PAUSE" }
      const_attr_reader  :PAUSE_NAME
      
      # $NON-NLS-1$
      # 
      # The formal name for the 'Print Screen' key.
      const_set_lazy(:PRINT_SCREEN_NAME) { "PRINT_SCREEN" }
      const_attr_reader  :PRINT_SCREEN_NAME
      
      # $NON-NLS-1$
      # 
      # An alternative name for the enter key.
      const_set_lazy(:RETURN_NAME) { "RETURN" }
      const_attr_reader  :RETURN_NAME
      
      # $NON-NLS-1$
      # 
      # The formal name for the 'Scroll Lock' key.
      const_set_lazy(:SCROLL_LOCK_NAME) { "SCROLL_LOCK" }
      const_attr_reader  :SCROLL_LOCK_NAME
      
      # $NON-NLS-1$
      # 
      # The formal name of the 'Shift' key.
      const_set_lazy(:SHIFT_NAME) { "SHIFT" }
      const_attr_reader  :SHIFT_NAME
      
      # $NON-NLS-1$
      # 
      # The formal name of the space (U+0020) key.
      const_set_lazy(:SPACE_NAME) { "SPACE" }
      const_attr_reader  :SPACE_NAME
      
      # $NON-NLS-1$
      # 
      # The formal name of the tab (U+0009) key.
      const_set_lazy(:TAB_NAME) { "TAB" }
      const_attr_reader  :TAB_NAME
      
      # $NON-NLS-1$
      # 
      # The formal name of the vertical tab (U+000B) key.
      const_set_lazy(:VT_NAME) { "VT" }
      const_attr_reader  :VT_NAME
    }
    
    typesig { [String] }
    # $NON-NLS-1$
    # 
    # Looks up a single natural key by its formal name, and returns the integer
    # representation for this natural key
    # 
    # @param name
    # The formal name of the natural key to look-up; must not be
    # <code>null</code>.
    # @return The integer representation of this key. If the natural key cannot
    # be found, then this method returns <code>0</code>.
    def formal_key_lookup(name)
      raise NotImplementedError
    end
    
    typesig { [String] }
    # Looks up a single natural key by its formal name, and returns the integer
    # representation for this natural key
    # 
    # @param name
    # The formal name of the natural key to look-up; must not be
    # <code>null</code>.
    # @return The integer representation of this key. If the natural key cannot
    # be found, then this method returns <code>0</code>.
    def formal_key_lookup_integer(name)
      raise NotImplementedError
    end
    
    typesig { [String] }
    # Looks up a single modifier key by its formal name, and returns the integer
    # representation for this modifier key
    # 
    # @param name
    # The formal name of the modifier key to look-up; must not be
    # <code>null</code>.
    # @return The integer representation of this key. If the modifier key
    # cannot be found, then this method returns <code>0</code>.
    def formal_modifier_lookup(name)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    # Looks up a key value, and returns the formal string representation for
    # that key
    # 
    # @param key
    # The key to look-up.
    # @return The formal string representation of this key. If this key cannot
    # be found, then it is simply the character corresponding to that
    # integer value.
    def formal_name_lookup(key)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the integer representation of the ALT key.
    # 
    # @return The ALT key
    def get_alt
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the integer representation of the COMMAND key.
    # 
    # @return The COMMAND key
    def get_command
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the integer representation of the CTRL key.
    # 
    # @return The CTRL key
    def get_ctrl
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the integer representation of the SHIFT key.
    # 
    # @return The SHIFT key
    def get_shift
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    # Returns whether the given key is a modifier key.
    # 
    # @param key
    # The integer value of the key to check.
    # @return <code>true</code> if the key is one of the modifier keys;
    # <code>false</code> otherwise.
    def is_modifier_key(key)
      raise NotImplementedError
    end
  end
  
end
