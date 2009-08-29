require "rjava"

# Copyright (c) 2005, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Bindings::Keys
  module SWTKeyLookupImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Bindings::Keys
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :Map
      include_const ::Org::Eclipse::Jface::Util, :Util
      include_const ::Org::Eclipse::Swt, :SWT
    }
  end
  
  # <p>
  # A look-up table for the formal grammar for keys, and the integer values they
  # represent. This look-up table is hard-coded to use SWT representations. By
  # replacing this class (and
  # {@link org.eclipse.jface.bindings.keys.SWTKeySupport}), you can remove the
  # dependency on SWT.
  # </p>
  # 
  # @since 3.1
  # @see org.eclipse.jface.bindings.keys.KeyLookupFactory
  class SWTKeyLookup 
    include_class_members SWTKeyLookupImports
    include IKeyLookup
    
    # The look-up table for modifier keys. This is a map of formal name (<code>String</code>)
    # to integer value (<code>Integer</code>).
    attr_accessor :modifier_key_table
    alias_method :attr_modifier_key_table, :modifier_key_table
    undef_method :modifier_key_table
    alias_method :attr_modifier_key_table=, :modifier_key_table=
    undef_method :modifier_key_table=
    
    # The look-up table for formal names. This is a map of integer value (<code>Integer</code>)
    # to formal name (<code>String</code>).
    attr_accessor :name_table
    alias_method :attr_name_table, :name_table
    undef_method :name_table
    alias_method :attr_name_table=, :name_table=
    undef_method :name_table=
    
    # The look-up table for natural keys. This is a map of formal name (<code>String</code>)
    # to integer value (<code>Integer</code>).
    attr_accessor :natural_key_table
    alias_method :attr_natural_key_table, :natural_key_table
    undef_method :natural_key_table
    alias_method :attr_natural_key_table=, :natural_key_table=
    undef_method :natural_key_table=
    
    typesig { [] }
    # Constructs a new look-up class. This should only be done by the look-up
    # factory.
    # 
    # @see KeyLookupFactory
    def initialize
      @modifier_key_table = HashMap.new
      @name_table = HashMap.new
      @natural_key_table = HashMap.new
      alt = SWT::ALT
      command = SWT::COMMAND
      ctrl = SWT::CTRL
      shift = SWT::SHIFT
      @modifier_key_table.put(ALT_NAME, alt)
      @name_table.put(alt, ALT_NAME)
      @modifier_key_table.put(COMMAND_NAME, command)
      @name_table.put(command, COMMAND_NAME)
      @modifier_key_table.put(CTRL_NAME, ctrl)
      @name_table.put(ctrl, CTRL_NAME)
      @modifier_key_table.put(SHIFT_NAME, shift)
      @name_table.put(shift, SHIFT_NAME)
      @modifier_key_table.put(M1_NAME, Util.is_mac ? command : ctrl)
      @modifier_key_table.put(M2_NAME, shift)
      @modifier_key_table.put(M3_NAME, alt)
      @modifier_key_table.put(M4_NAME, Util.is_mac ? ctrl : command)
      arrow_down = SWT::ARROW_DOWN
      @natural_key_table.put(ARROW_DOWN_NAME, arrow_down)
      @name_table.put(arrow_down, ARROW_DOWN_NAME)
      arrow_left = SWT::ARROW_LEFT
      @natural_key_table.put(ARROW_LEFT_NAME, arrow_left)
      @name_table.put(arrow_left, ARROW_LEFT_NAME)
      arrow_right = SWT::ARROW_RIGHT
      @natural_key_table.put(ARROW_RIGHT_NAME, arrow_right)
      @name_table.put(arrow_right, ARROW_RIGHT_NAME)
      arrow_up = SWT::ARROW_UP
      @natural_key_table.put(ARROW_UP_NAME, arrow_up)
      @name_table.put(arrow_up, ARROW_UP_NAME)
      break_key = SWT::BREAK
      @natural_key_table.put(BREAK_NAME, break_key)
      @name_table.put(break_key, BREAK_NAME)
      bs = SWT::BS
      @natural_key_table.put(BS_NAME, bs)
      @name_table.put(bs, BS_NAME)
      @natural_key_table.put(BACKSPACE_NAME, bs)
      caps_lock = SWT::CAPS_LOCK
      @natural_key_table.put(CAPS_LOCK_NAME, caps_lock)
      @name_table.put(caps_lock, CAPS_LOCK_NAME)
      cr = SWT::CR
      @natural_key_table.put(CR_NAME, cr)
      @name_table.put(cr, CR_NAME)
      @natural_key_table.put(ENTER_NAME, cr)
      @natural_key_table.put(RETURN_NAME, cr)
      del = SWT::DEL
      @natural_key_table.put(DEL_NAME, del)
      @name_table.put(del, DEL_NAME)
      @natural_key_table.put(DELETE_NAME, del)
      end_ = SWT::END_
      @natural_key_table.put(END_NAME, end_)
      @name_table.put(end_, END_NAME)
      esc = SWT::ESC
      @natural_key_table.put(ESC_NAME, esc)
      @name_table.put(esc, ESC_NAME)
      @natural_key_table.put(ESCAPE_NAME, esc)
      f1 = SWT::F1
      @natural_key_table.put(F1_NAME, f1)
      @name_table.put(f1, F1_NAME)
      f2 = SWT::F2
      @natural_key_table.put(F2_NAME, SWT::F2)
      @name_table.put(f2, F2_NAME)
      f3 = SWT::F3
      @natural_key_table.put(F3_NAME, SWT::F3)
      @name_table.put(f3, F3_NAME)
      f4 = SWT::F4
      @natural_key_table.put(F4_NAME, SWT::F4)
      @name_table.put(f4, F4_NAME)
      f5 = SWT::F5
      @natural_key_table.put(F5_NAME, SWT::F5)
      @name_table.put(f5, F5_NAME)
      f6 = SWT::F6
      @natural_key_table.put(F6_NAME, SWT::F6)
      @name_table.put(f6, F6_NAME)
      f7 = SWT::F7
      @natural_key_table.put(F7_NAME, SWT::F7)
      @name_table.put(f7, F7_NAME)
      f8 = SWT::F8
      @natural_key_table.put(F8_NAME, SWT::F8)
      @name_table.put(f8, F8_NAME)
      f9 = SWT::F9
      @natural_key_table.put(F9_NAME, SWT::F9)
      @name_table.put(f9, F9_NAME)
      f10 = SWT::F10
      @natural_key_table.put(F10_NAME, SWT::F10)
      @name_table.put(f10, F10_NAME)
      f11 = SWT::F11
      @natural_key_table.put(F11_NAME, SWT::F11)
      @name_table.put(f11, F11_NAME)
      f12 = SWT::F12
      @natural_key_table.put(F12_NAME, SWT::F12)
      @name_table.put(f12, F12_NAME)
      f13 = SWT::F13
      @natural_key_table.put(F13_NAME, SWT::F13)
      @name_table.put(f13, F13_NAME)
      f14 = SWT::F14
      @natural_key_table.put(F14_NAME, SWT::F14)
      @name_table.put(f14, F14_NAME)
      f15 = SWT::F15
      @natural_key_table.put(F15_NAME, SWT::F15)
      @name_table.put(f15, F15_NAME)
      ff = 12 # ASCII 0x0C
      @natural_key_table.put(FF_NAME, ff)
      @name_table.put(ff, FF_NAME)
      home = SWT::HOME
      @natural_key_table.put(HOME_NAME, home)
      @name_table.put(home, HOME_NAME)
      insert = SWT::INSERT
      @natural_key_table.put(INSERT_NAME, insert)
      @name_table.put(insert, INSERT_NAME)
      lf = SWT::LF
      @natural_key_table.put(LF_NAME, lf)
      @name_table.put(lf, LF_NAME)
      nul = SWT::NULL
      @natural_key_table.put(NUL_NAME, nul)
      @name_table.put(nul, NUL_NAME)
      num_lock = SWT::NUM_LOCK
      @natural_key_table.put(NUM_LOCK_NAME, num_lock)
      @name_table.put(num_lock, NUM_LOCK_NAME)
      keypad0 = SWT::KEYPAD_0
      @natural_key_table.put(NUMPAD_0_NAME, keypad0)
      @name_table.put(keypad0, NUMPAD_0_NAME)
      keypad1 = SWT::KEYPAD_1
      @natural_key_table.put(NUMPAD_1_NAME, keypad1)
      @name_table.put(keypad1, NUMPAD_1_NAME)
      keypad2 = SWT::KEYPAD_2
      @natural_key_table.put(NUMPAD_2_NAME, keypad2)
      @name_table.put(keypad2, NUMPAD_2_NAME)
      keypad3 = SWT::KEYPAD_3
      @natural_key_table.put(NUMPAD_3_NAME, keypad3)
      @name_table.put(keypad3, NUMPAD_3_NAME)
      keypad4 = SWT::KEYPAD_4
      @natural_key_table.put(NUMPAD_4_NAME, keypad4)
      @name_table.put(keypad4, NUMPAD_4_NAME)
      keypad5 = SWT::KEYPAD_5
      @natural_key_table.put(NUMPAD_5_NAME, keypad5)
      @name_table.put(keypad5, NUMPAD_5_NAME)
      keypad6 = SWT::KEYPAD_6
      @natural_key_table.put(NUMPAD_6_NAME, keypad6)
      @name_table.put(keypad6, NUMPAD_6_NAME)
      keypad7 = SWT::KEYPAD_7
      @natural_key_table.put(NUMPAD_7_NAME, keypad7)
      @name_table.put(keypad7, NUMPAD_7_NAME)
      keypad8 = SWT::KEYPAD_8
      @natural_key_table.put(NUMPAD_8_NAME, keypad8)
      @name_table.put(keypad8, NUMPAD_8_NAME)
      keypad9 = SWT::KEYPAD_9
      @natural_key_table.put(NUMPAD_9_NAME, keypad9)
      @name_table.put(keypad9, NUMPAD_9_NAME)
      keypad_add = SWT::KEYPAD_ADD
      @natural_key_table.put(NUMPAD_ADD_NAME, keypad_add)
      @name_table.put(keypad_add, NUMPAD_ADD_NAME)
      keypad_decimal = SWT::KEYPAD_DECIMAL
      @natural_key_table.put(NUMPAD_DECIMAL_NAME, keypad_decimal)
      @name_table.put(keypad_decimal, NUMPAD_DECIMAL_NAME)
      keypad_divide = SWT::KEYPAD_DIVIDE
      @natural_key_table.put(NUMPAD_DIVIDE_NAME, keypad_divide)
      @name_table.put(keypad_divide, NUMPAD_DIVIDE_NAME)
      keypad_cr = SWT::KEYPAD_CR
      @natural_key_table.put(NUMPAD_ENTER_NAME, keypad_cr)
      @name_table.put(keypad_cr, NUMPAD_ENTER_NAME)
      keypad_equal = SWT::KEYPAD_EQUAL
      @natural_key_table.put(NUMPAD_EQUAL_NAME, keypad_equal)
      @name_table.put(keypad_equal, NUMPAD_EQUAL_NAME)
      keypad_multiply = SWT::KEYPAD_MULTIPLY
      @natural_key_table.put(NUMPAD_MULTIPLY_NAME, keypad_multiply)
      @name_table.put(keypad_multiply, NUMPAD_MULTIPLY_NAME)
      keypad_subtract = SWT::KEYPAD_SUBTRACT
      @natural_key_table.put(NUMPAD_SUBTRACT_NAME, keypad_subtract)
      @name_table.put(keypad_subtract, NUMPAD_SUBTRACT_NAME)
      page_down = SWT::PAGE_DOWN
      @natural_key_table.put(PAGE_DOWN_NAME, page_down)
      @name_table.put(page_down, PAGE_DOWN_NAME)
      page_up = SWT::PAGE_UP
      @natural_key_table.put(PAGE_UP_NAME, page_up)
      @name_table.put(page_up, PAGE_UP_NAME)
      pause = SWT::PAUSE
      @natural_key_table.put(PAUSE_NAME, pause)
      @name_table.put(pause, PAUSE_NAME)
      print_screen = SWT::PRINT_SCREEN
      @natural_key_table.put(PRINT_SCREEN_NAME, print_screen)
      @name_table.put(print_screen, PRINT_SCREEN_NAME)
      scroll_lock = SWT::SCROLL_LOCK
      @natural_key_table.put(SCROLL_LOCK_NAME, scroll_lock)
      @name_table.put(scroll_lock, SCROLL_LOCK_NAME)
      space = Character.new(?\s.ord)
      @natural_key_table.put(SPACE_NAME, space)
      @name_table.put(space, SPACE_NAME)
      tab = SWT::TAB
      @natural_key_table.put(TAB_NAME, tab)
      @name_table.put(tab, TAB_NAME)
      vt = 11 # ASCII 0x0B
      @natural_key_table.put(VT_NAME, vt)
      @name_table.put(vt, VT_NAME)
    end
    
    typesig { [String] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.bindings.keys.IKeyLookup#formalKeyLookup(java.lang.String)
    def formal_key_lookup(name)
      value = @natural_key_table.get(name)
      if (value.is_a?(JavaInteger))
        return (value).int_value
      end
      if (name.length > 0)
        # $NON-NLS-1$
        raise IllegalArgumentException.new("Unrecognized formal key name: " + name)
      end
      return name.char_at(0)
    end
    
    typesig { [String] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.bindings.keys.IKeyLookup#formalKeyLookupInteger(java.lang.String)
    def formal_key_lookup_integer(name)
      value = @natural_key_table.get(name)
      if (value.is_a?(JavaInteger))
        return value
      end
      return name.char_at(0)
    end
    
    typesig { [String] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.bindings.keys.IKeyLookup#formalModifierLookup(java.lang.String)
    def formal_modifier_lookup(name)
      value = @modifier_key_table.get(name)
      if (value.is_a?(JavaInteger))
        return (value).int_value
      end
      return 0
    end
    
    typesig { [::Java::Int] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.bindings.keys.IKeyLookup#formalNameLookup(int)
    def formal_name_lookup(key)
      key_object = key
      value = @name_table.get(key_object)
      if (value.is_a?(String))
        return value
      end
      return Util::ZERO_LENGTH_STRING + (RJava.cast_to_char(key))
    end
    
    typesig { [] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.bindings.keys.IKeyLookup#getAlt()
    def get_alt
      return SWT::ALT
    end
    
    typesig { [] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.bindings.keys.IKeyLookup#getCommand()
    def get_command
      return SWT::COMMAND
    end
    
    typesig { [] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.bindings.keys.IKeyLookup#getCtrl()
    def get_ctrl
      return SWT::CTRL
    end
    
    typesig { [] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.bindings.keys.IKeyLookup#getShift()
    def get_shift
      return SWT::SHIFT
    end
    
    typesig { [::Java::Int] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.bindings.keys.IKeyLookup#isModifierKey(int)
    def is_modifier_key(key)
      return (!((key & SWT::MODIFIER_MASK)).equal?(0))
    end
    
    private
    alias_method :initialize__swtkey_lookup, :initialize
  end
  
end
