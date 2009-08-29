require "rjava"

# Copyright (c) 2005, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Action
  module LegacyActionToolsImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Action
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :Map
      include_const ::Java::Util, :StringTokenizer
      include_const ::Org::Eclipse::Jface::Resource, :JFaceResources
      include_const ::Org::Eclipse::Swt, :SWT
    }
  end
  
  # <p>
  # Some static utility methods for handling labels on actions. This includes
  # mnemonics and accelerators.
  # </p>
  # <p>
  # Clients may neither instantiate this class nor extend.
  # </p>
  # 
  # @since 3.2
  class LegacyActionTools 
    include_class_members LegacyActionToolsImports
    
    class_module.module_eval {
      # Table of key codes (key type: <code>String</code>, value type:
      # <code>Integer</code>); <code>null</code> if not yet initialized.
      # 
      # @see #findKeyCode
      
      def key_codes
        defined?(@@key_codes) ? @@key_codes : @@key_codes= nil
      end
      alias_method :attr_key_codes, :key_codes
      
      def key_codes=(value)
        @@key_codes = value
      end
      alias_method :attr_key_codes=, :key_codes=
      
      # Table of string representations of keys (key type: <code>Integer</code>,
      # value type: <code>String</code>); <code>null</code>> if not yet
      # initialized.
      # 
      # @see #findKeyString
      
      def key_strings
        defined?(@@key_strings) ? @@key_strings : @@key_strings= nil
      end
      alias_method :attr_key_strings, :key_strings
      
      def key_strings=(value)
        @@key_strings = value
      end
      alias_method :attr_key_strings=, :key_strings=
      
      # The localized uppercase version of ALT
      
      def localized_alt
        defined?(@@localized_alt) ? @@localized_alt : @@localized_alt= nil
      end
      alias_method :attr_localized_alt, :localized_alt
      
      def localized_alt=(value)
        @@localized_alt = value
      end
      alias_method :attr_localized_alt=, :localized_alt=
      
      # The localized uppercase version of COMMAND
      
      def localized_command
        defined?(@@localized_command) ? @@localized_command : @@localized_command= nil
      end
      alias_method :attr_localized_command, :localized_command
      
      def localized_command=(value)
        @@localized_command = value
      end
      alias_method :attr_localized_command=, :localized_command=
      
      # The localized uppercase version of CTRL
      
      def localized_ctrl
        defined?(@@localized_ctrl) ? @@localized_ctrl : @@localized_ctrl= nil
      end
      alias_method :attr_localized_ctrl, :localized_ctrl
      
      def localized_ctrl=(value)
        @@localized_ctrl = value
      end
      alias_method :attr_localized_ctrl=, :localized_ctrl=
      
      # Table of key codes (key type: <code>String</code>, value type:
      # <code>Integer</code>); <code>null</code> if not yet initialized. The
      # key is the localalized name of the key as it appears in menus.
      # 
      # @see #findLocalizedKeyCode
      
      def localized_key_codes
        defined?(@@localized_key_codes) ? @@localized_key_codes : @@localized_key_codes= nil
      end
      alias_method :attr_localized_key_codes, :localized_key_codes
      
      def localized_key_codes=(value)
        @@localized_key_codes = value
      end
      alias_method :attr_localized_key_codes=, :localized_key_codes=
      
      # The localized uppercase version of SHIFT
      
      def localized_shift
        defined?(@@localized_shift) ? @@localized_shift : @@localized_shift= nil
      end
      alias_method :attr_localized_shift, :localized_shift
      
      def localized_shift=(value)
        @@localized_shift = value
      end
      alias_method :attr_localized_shift=, :localized_shift=
      
      # The constant to use if there is no mnemonic for this location.
      const_set_lazy(:MNEMONIC_NONE) { 0 }
      const_attr_reader  :MNEMONIC_NONE
      
      typesig { [::Java::Int] }
      # Converts an accelerator key code to a string representation.
      # 
      # @param keyCode
      # the key code to be translated
      # @return a string representation of the key code
      def convert_accelerator(key_code)
        modifier = get_modifier_string(key_code)
        full_key = nil
        if ((modifier == ""))
          # $NON-NLS-1$
          full_key = RJava.cast_to_string(find_key_string(key_code))
        else
          full_key = modifier + "+" + RJava.cast_to_string(find_key_string(key_code)) # $NON-NLS-1$
        end
        return full_key
      end
      
      typesig { [String] }
      # Parses the given accelerator text, and converts it to an accelerator key
      # code.
      # 
      # @param acceleratorText
      # the accelerator text
      # @return the SWT key code, or 0 if there is no accelerator
      def convert_accelerator(accelerator_text)
        accelerator = 0
        stok = StringTokenizer.new(accelerator_text, "+") # $NON-NLS-1$
        key_code = -1
        has_more_tokens_ = stok.has_more_tokens
        while (has_more_tokens_)
          token = stok.next_token
          has_more_tokens_ = stok.has_more_tokens
          # Every token except the last must be one of the modifiers
          # Ctrl, Shift, Alt, or Command
          if (has_more_tokens_)
            modifier = find_modifier(token)
            if (!(modifier).equal?(0))
              accelerator |= modifier
            else
              # Leave if there are none
              return 0
            end
          else
            key_code = find_key_code(token)
          end
        end
        if (!(key_code).equal?(-1))
          accelerator |= key_code
        end
        return accelerator
      end
      
      typesig { [String] }
      # Parses the given accelerator text, and converts it to an accelerator key
      # code.
      # 
      # Support for localized modifiers is for backwards compatibility with 1.0.
      # Use setAccelerator(int) to set accelerators programatically or the
      # <code>accelerator</code> tag in action definitions in plugin.xml.
      # 
      # @param acceleratorText
      # the accelerator text localized to the current locale
      # @return the SWT key code, or 0 if there is no accelerator
      def convert_localized_accelerator(accelerator_text)
        accelerator = 0
        stok = StringTokenizer.new(accelerator_text, "+") # $NON-NLS-1$
        key_code = -1
        has_more_tokens_ = stok.has_more_tokens
        while (has_more_tokens_)
          token = stok.next_token
          has_more_tokens_ = stok.has_more_tokens
          # Every token except the last must be one of the modifiers
          # Ctrl, Shift, Alt, or Command
          if (has_more_tokens_)
            modifier = find_localized_modifier(token)
            if (!(modifier).equal?(0))
              accelerator |= modifier
            else
              # Leave if there are none
              return 0
            end
          else
            key_code = find_localized_key_code(token)
          end
        end
        if (!(key_code).equal?(-1))
          accelerator |= key_code
        end
        return accelerator
      end
      
      typesig { [String] }
      # Extracts the accelerator text from the given text. Returns
      # <code>null</code> if there is no accelerator text, and the empty string
      # if there is no text after the accelerator delimeter (tab or '@').
      # 
      # @param text
      # the text for the action; may be <code>null</code>.
      # @return the accelerator text, or <code>null</code>
      def extract_accelerator_text(text)
        if ((text).nil?)
          return nil
        end
        index = text.last_index_of(Character.new(?\t.ord))
        if ((index).equal?(-1))
          index = text.last_index_of(Character.new(?@.ord))
        end
        if (index >= 0)
          return text.substring(index + 1)
        end
        return nil
      end
      
      typesig { [String] }
      # Extracts the mnemonic text from the given string.
      # 
      # @param text
      # The text from which the mnemonic should be extracted; may be
      # <code>null</code>
      # @return The text of the mnemonic; will be {@link #MNEMONIC_NONE} if there
      # is no mnemonic;
      def extract_mnemonic(text)
        if ((text).nil?)
          return MNEMONIC_NONE
        end
        index = text.index_of(Character.new(?&.ord))
        if ((index).equal?(-1))
          return MNEMONIC_NONE
        end
        text_length = text.length
        # Ignore '&' at the end of the string.
        if ((index).equal?(text_length - 1))
          return MNEMONIC_NONE
        end
        # Ignore two consecutive ampersands.
        while ((text.char_at(index + 1)).equal?(Character.new(?&.ord)))
          index = text.index_of(Character.new(?&.ord), (index += 1))
          if ((index).equal?(text_length - 1))
            return MNEMONIC_NONE
          end
        end
        return text.char_at(index + 1)
      end
      
      typesig { [String] }
      # Maps a standard keyboard key name to an SWT key code. Key names are
      # converted to upper case before comparison. If the key name is a single
      # letter, for example "S", its character code is returned.
      # <p>
      # The following key names are known (case is ignored):
      # <ul>
      # <li><code>"BACKSPACE"</code></li>
      # <li><code>"TAB"</code></li>
      # <li><code>"RETURN"</code></li>
      # <li><code>"ENTER"</code></li>
      # <li><code>"ESC"</code></li>
      # <li><code>"ESCAPE"</code></li>
      # <li><code>"DELETE"</code></li>
      # <li><code>"SPACE"</code></li>
      # <li><code>"ARROW_UP"</code>, <code>"ARROW_DOWN"</code>,
      # <code>"ARROW_LEFT"</code>, and <code>"ARROW_RIGHT"</code></li>
      # <li><code>"PAGE_UP"</code> and <code>"PAGE_DOWN"</code></li>
      # <li><code>"HOME"</code></li>
      # <li><code>"END"</code></li>
      # <li><code>"INSERT"</code></li>
      # <li><code>"F1"</code>, <code>"F2"</code> through <code>"F12"</code></li>
      # </ul>
      # </p>
      # 
      # @param token
      # the key name
      # @return the SWT key code, <code>-1</code> if no match was found
      # @see SWT
      def find_key_code(token)
        if ((self.attr_key_codes).nil?)
          init_key_codes
        end
        token = RJava.cast_to_string(token.to_upper_case)
        i = self.attr_key_codes.get(token)
        if (!(i).nil?)
          return i.int_value
        end
        if ((token.length).equal?(1))
          return token.char_at(0)
        end
        return -1
      end
      
      typesig { [::Java::Int] }
      # Maps an SWT key code to a standard keyboard key name. The key code is
      # stripped of modifiers (SWT.CTRL, SWT.ALT, SWT.SHIFT, and SWT.COMMAND). If
      # the key code is not an SWT code (for example if it a key code for the key
      # 'S'), a string containing a character representation of the key code is
      # returned.
      # 
      # @param keyCode
      # the key code to be translated
      # @return the string representation of the key code
      # @see SWT
      # @since 2.0
      def find_key_string(key_code)
        if ((self.attr_key_strings).nil?)
          init_key_strings
        end
        i = key_code & ~(SWT::CTRL | SWT::ALT | SWT::SHIFT | SWT::COMMAND)
        integer = i
        result = self.attr_key_strings.get(integer)
        if (!(result).nil?)
          return result
        end
        result = RJava.cast_to_string(String.new(Array.typed(::Java::Char).new([RJava.cast_to_char(i)])))
        return result
      end
      
      typesig { [String] }
      # Find the supplied code for a localized key. As #findKeyCode but localized
      # to the current locale.
      # 
      # Support for localized modifiers is for backwards compatibility with 1.0.
      # Use setAccelerator(int) to set accelerators programatically or the
      # <code>accelerator</code> tag in action definitions in plugin.xml.
      # 
      # @param token
      # the localized key name
      # @return the SWT key code, <code>-1</code> if no match was found
      # @see #findKeyCode
      def find_localized_key_code(token)
        if ((self.attr_localized_key_codes).nil?)
          init_localized_key_codes
        end
        token = RJava.cast_to_string(token.to_upper_case)
        i = self.attr_localized_key_codes.get(token)
        if (!(i).nil?)
          return i.int_value
        end
        if ((token.length).equal?(1))
          return token.char_at(0)
        end
        return -1
      end
      
      typesig { [String] }
      # Maps the localized modifier names to a code in the same manner as
      # #findModifier.
      # 
      # Support for localized modifiers is for backwards compatibility with 1.0.
      # Use setAccelerator(int) to set accelerators programatically or the
      # <code>accelerator</code> tag in action definitions in plugin.xml.
      # 
      # @see #findModifier
      def find_localized_modifier(token)
        if ((self.attr_localized_ctrl).nil?)
          init_localized_modifiers
        end
        token = RJava.cast_to_string(token.to_upper_case)
        if ((token == self.attr_localized_ctrl))
          return SWT::CTRL
        end
        if ((token == self.attr_localized_shift))
          return SWT::SHIFT
        end
        if ((token == self.attr_localized_alt))
          return SWT::ALT
        end
        if ((token == self.attr_localized_command))
          return SWT::COMMAND
        end
        return 0
      end
      
      typesig { [String] }
      # Maps standard keyboard modifier key names to the corresponding SWT
      # modifier bit. The following modifier key names are recognized (case is
      # ignored): <code>"CTRL"</code>, <code>"SHIFT"</code>,
      # <code>"ALT"</code>, and <code>"COMMAND"</code>. The given modifier
      # key name is converted to upper case before comparison.
      # 
      # @param token
      # the modifier key name
      # @return the SWT modifier bit, or <code>0</code> if no match was found
      # @see SWT
      def find_modifier(token)
        token = RJava.cast_to_string(token.to_upper_case)
        if ((token == "CTRL"))
          # $NON-NLS-1$
          return SWT::CTRL
        end
        if ((token == "SHIFT"))
          # $NON-NLS-1$
          return SWT::SHIFT
        end
        if ((token == "ALT"))
          # $NON-NLS-1$
          return SWT::ALT
        end
        if ((token == "COMMAND"))
          # $NON-NLS-1$
          return SWT::COMMAND
        end
        return 0
      end
      
      typesig { [::Java::Int] }
      # Returns a string representation of an SWT modifier bit (SWT.CTRL,
      # SWT.ALT, SWT.SHIFT, and SWT.COMMAND). Returns <code>null</code> if the
      # key code is not an SWT modifier bit.
      # 
      # @param keyCode
      # the SWT modifier bit to be translated
      # @return the string representation of the SWT modifier bit, or
      # <code>null</code> if the key code was not an SWT modifier bit
      # @see SWT
      def find_modifier_string(key_code)
        if ((key_code).equal?(SWT::CTRL))
          return JFaceResources.get_string("Ctrl") # $NON-NLS-1$
        end
        if ((key_code).equal?(SWT::ALT))
          return JFaceResources.get_string("Alt") # $NON-NLS-1$
        end
        if ((key_code).equal?(SWT::SHIFT))
          return JFaceResources.get_string("Shift") # $NON-NLS-1$
        end
        if ((key_code).equal?(SWT::COMMAND))
          return JFaceResources.get_string("Command") # $NON-NLS-1$
        end
        return nil
      end
      
      typesig { [::Java::Int] }
      # Returns the string representation of the modifiers (Ctrl, Alt, Shift,
      # Command) of the key event.
      # 
      # @param keyCode
      # The key code for which the modifier string is desired.
      # @return The string representation of the key code; never
      # <code>null</code>.
      def get_modifier_string(key_code)
        mod_string = "" # $NON-NLS-1$
        if (!((key_code & SWT::CTRL)).equal?(0))
          mod_string = RJava.cast_to_string(find_modifier_string(key_code & SWT::CTRL))
        end
        if (!((key_code & SWT::ALT)).equal?(0))
          if ((mod_string == ""))
            # $NON-NLS-1$
            mod_string = RJava.cast_to_string(find_modifier_string(key_code & SWT::ALT))
          else
            mod_string = mod_string + "+" + RJava.cast_to_string(find_modifier_string(key_code & SWT::ALT)) # $NON-NLS-1$
          end
        end
        if (!((key_code & SWT::SHIFT)).equal?(0))
          if ((mod_string == ""))
            # $NON-NLS-1$
            mod_string = RJava.cast_to_string(find_modifier_string(key_code & SWT::SHIFT))
          else
            mod_string = mod_string + "+" + RJava.cast_to_string(find_modifier_string(key_code & SWT::SHIFT)) # $NON-NLS-1$
          end
        end
        if (!((key_code & SWT::COMMAND)).equal?(0))
          if ((mod_string == ""))
            # $NON-NLS-1$
            mod_string = RJava.cast_to_string(find_modifier_string(key_code & SWT::COMMAND))
          else
            mod_string = mod_string + "+" + RJava.cast_to_string(find_modifier_string(key_code & SWT::COMMAND)) # $NON-NLS-1$
          end
        end
        return mod_string
      end
      
      typesig { [] }
      # Initializes the internal key code table.
      def init_key_codes
        self.attr_key_codes = HashMap.new(40)
        self.attr_key_codes.put("BACKSPACE", 8) # $NON-NLS-1$
        self.attr_key_codes.put("TAB", 9) # $NON-NLS-1$
        self.attr_key_codes.put("RETURN", 13) # $NON-NLS-1$
        self.attr_key_codes.put("ENTER", 13) # $NON-NLS-1$
        self.attr_key_codes.put("ESCAPE", 27) # $NON-NLS-1$
        self.attr_key_codes.put("ESC", 27) # $NON-NLS-1$
        self.attr_key_codes.put("DELETE", 127) # $NON-NLS-1$
        self.attr_key_codes.put("SPACE", Character.new(?\s.ord)) # $NON-NLS-1$
        self.attr_key_codes.put("ARROW_UP", SWT::ARROW_UP) # $NON-NLS-1$
        self.attr_key_codes.put("ARROW_DOWN", SWT::ARROW_DOWN) # $NON-NLS-1$
        self.attr_key_codes.put("ARROW_LEFT", SWT::ARROW_LEFT) # $NON-NLS-1$
        self.attr_key_codes.put("ARROW_RIGHT", SWT::ARROW_RIGHT) # $NON-NLS-1$
        self.attr_key_codes.put("PAGE_UP", SWT::PAGE_UP) # $NON-NLS-1$
        self.attr_key_codes.put("PAGE_DOWN", SWT::PAGE_DOWN) # $NON-NLS-1$
        self.attr_key_codes.put("HOME", SWT::HOME) # $NON-NLS-1$
        self.attr_key_codes.put("END", SWT::END_) # $NON-NLS-1$
        self.attr_key_codes.put("INSERT", SWT::INSERT) # $NON-NLS-1$
        self.attr_key_codes.put("F1", SWT::F1) # $NON-NLS-1$
        self.attr_key_codes.put("F2", SWT::F2) # $NON-NLS-1$
        self.attr_key_codes.put("F3", SWT::F3) # $NON-NLS-1$
        self.attr_key_codes.put("F4", SWT::F4) # $NON-NLS-1$
        self.attr_key_codes.put("F5", SWT::F5) # $NON-NLS-1$
        self.attr_key_codes.put("F6", SWT::F6) # $NON-NLS-1$
        self.attr_key_codes.put("F7", SWT::F7) # $NON-NLS-1$
        self.attr_key_codes.put("F8", SWT::F8) # $NON-NLS-1$
        self.attr_key_codes.put("F9", SWT::F9) # $NON-NLS-1$
        self.attr_key_codes.put("F10", SWT::F10) # $NON-NLS-1$
        self.attr_key_codes.put("F11", SWT::F11) # $NON-NLS-1$
        self.attr_key_codes.put("F12", SWT::F12) # $NON-NLS-1$
      end
      
      typesig { [] }
      # Initializes the internal key string table.
      def init_key_strings
        self.attr_key_strings = HashMap.new(40)
        self.attr_key_strings.put(8, JFaceResources.get_string("Backspace")) # $NON-NLS-1$
        self.attr_key_strings.put(9, JFaceResources.get_string("Tab")) # $NON-NLS-1$
        self.attr_key_strings.put(13, JFaceResources.get_string("Return")) # $NON-NLS-1$
        self.attr_key_strings.put(13, JFaceResources.get_string("Enter")) # $NON-NLS-1$
        self.attr_key_strings.put(27, JFaceResources.get_string("Escape")) # $NON-NLS-1$
        self.attr_key_strings.put(27, JFaceResources.get_string("Esc")) # $NON-NLS-1$
        self.attr_key_strings.put(127, JFaceResources.get_string("Delete")) # $NON-NLS-1$
        self.attr_key_strings.put(Character.new(?\s.ord), JFaceResources.get_string("Space")) # $NON-NLS-1$
        self.attr_key_strings.put(SWT::ARROW_UP, JFaceResources.get_string("Arrow_Up")) # $NON-NLS-1$
        self.attr_key_strings.put(SWT::ARROW_DOWN, JFaceResources.get_string("Arrow_Down")) # $NON-NLS-1$
        self.attr_key_strings.put(SWT::ARROW_LEFT, JFaceResources.get_string("Arrow_Left")) # $NON-NLS-1$
        self.attr_key_strings.put(SWT::ARROW_RIGHT, JFaceResources.get_string("Arrow_Right")) # $NON-NLS-1$
        self.attr_key_strings.put(SWT::PAGE_UP, JFaceResources.get_string("Page_Up")) # $NON-NLS-1$
        self.attr_key_strings.put(SWT::PAGE_DOWN, JFaceResources.get_string("Page_Down")) # $NON-NLS-1$
        self.attr_key_strings.put(SWT::HOME, JFaceResources.get_string("Home")) # $NON-NLS-1$
        self.attr_key_strings.put(SWT::END_, JFaceResources.get_string("End")) # $NON-NLS-1$
        self.attr_key_strings.put(SWT::INSERT, JFaceResources.get_string("Insert")) # $NON-NLS-1$
        self.attr_key_strings.put(SWT::F1, JFaceResources.get_string("F1")) # $NON-NLS-1$
        self.attr_key_strings.put(SWT::F2, JFaceResources.get_string("F2")) # $NON-NLS-1$
        self.attr_key_strings.put(SWT::F3, JFaceResources.get_string("F3")) # $NON-NLS-1$
        self.attr_key_strings.put(SWT::F4, JFaceResources.get_string("F4")) # $NON-NLS-1$
        self.attr_key_strings.put(SWT::F5, JFaceResources.get_string("F5")) # $NON-NLS-1$
        self.attr_key_strings.put(SWT::F6, JFaceResources.get_string("F6")) # $NON-NLS-1$
        self.attr_key_strings.put(SWT::F7, JFaceResources.get_string("F7")) # $NON-NLS-1$
        self.attr_key_strings.put(SWT::F8, JFaceResources.get_string("F8")) # $NON-NLS-1$
        self.attr_key_strings.put(SWT::F9, JFaceResources.get_string("F9")) # $NON-NLS-1$
        self.attr_key_strings.put(SWT::F10, JFaceResources.get_string("F10")) # $NON-NLS-1$
        self.attr_key_strings.put(SWT::F11, JFaceResources.get_string("F11")) # $NON-NLS-1$
        self.attr_key_strings.put(SWT::F12, JFaceResources.get_string("F12")) # $NON-NLS-1$
      end
      
      typesig { [] }
      # Initializes the localized internal key code table.
      def init_localized_key_codes
        self.attr_localized_key_codes = HashMap.new(40)
        self.attr_localized_key_codes.put(JFaceResources.get_string("Backspace").to_upper_case, 8) # $NON-NLS-1$
        self.attr_localized_key_codes.put(JFaceResources.get_string("Tab").to_upper_case, 9) # $NON-NLS-1$
        self.attr_localized_key_codes.put(JFaceResources.get_string("Return").to_upper_case, 13) # $NON-NLS-1$
        self.attr_localized_key_codes.put(JFaceResources.get_string("Enter").to_upper_case, 13) # $NON-NLS-1$
        self.attr_localized_key_codes.put(JFaceResources.get_string("Escape").to_upper_case, 27) # $NON-NLS-1$
        self.attr_localized_key_codes.put(JFaceResources.get_string("Esc").to_upper_case, 27) # $NON-NLS-1$
        self.attr_localized_key_codes.put(JFaceResources.get_string("Delete").to_upper_case, 127) # $NON-NLS-1$
        self.attr_localized_key_codes.put(JFaceResources.get_string("Space").to_upper_case, Character.new(?\s.ord)) # $NON-NLS-1$
        self.attr_localized_key_codes.put(JFaceResources.get_string("Arrow_Up").to_upper_case, SWT::ARROW_UP) # $NON-NLS-1$
        self.attr_localized_key_codes.put(JFaceResources.get_string("Arrow_Down").to_upper_case, SWT::ARROW_DOWN) # $NON-NLS-1$
        self.attr_localized_key_codes.put(JFaceResources.get_string("Arrow_Left").to_upper_case, SWT::ARROW_LEFT) # $NON-NLS-1$
        self.attr_localized_key_codes.put(JFaceResources.get_string("Arrow_Right").to_upper_case, SWT::ARROW_RIGHT) # $NON-NLS-1$
        self.attr_localized_key_codes.put(JFaceResources.get_string("Page_Up").to_upper_case, SWT::PAGE_UP) # $NON-NLS-1$
        self.attr_localized_key_codes.put(JFaceResources.get_string("Page_Down").to_upper_case, SWT::PAGE_DOWN) # $NON-NLS-1$
        self.attr_localized_key_codes.put(JFaceResources.get_string("Home").to_upper_case, SWT::HOME) # $NON-NLS-1$
        self.attr_localized_key_codes.put(JFaceResources.get_string("End").to_upper_case, SWT::END_) # $NON-NLS-1$
        self.attr_localized_key_codes.put(JFaceResources.get_string("Insert").to_upper_case, SWT::INSERT) # $NON-NLS-1$
        self.attr_localized_key_codes.put(JFaceResources.get_string("F1").to_upper_case, SWT::F1) # $NON-NLS-1$
        self.attr_localized_key_codes.put(JFaceResources.get_string("F2").to_upper_case, SWT::F2) # $NON-NLS-1$
        self.attr_localized_key_codes.put(JFaceResources.get_string("F3").to_upper_case, SWT::F3) # $NON-NLS-1$
        self.attr_localized_key_codes.put(JFaceResources.get_string("F4").to_upper_case, SWT::F4) # $NON-NLS-1$
        self.attr_localized_key_codes.put(JFaceResources.get_string("F5").to_upper_case, SWT::F5) # $NON-NLS-1$
        self.attr_localized_key_codes.put(JFaceResources.get_string("F6").to_upper_case, SWT::F6) # $NON-NLS-1$
        self.attr_localized_key_codes.put(JFaceResources.get_string("F7").to_upper_case, SWT::F7) # $NON-NLS-1$
        self.attr_localized_key_codes.put(JFaceResources.get_string("F8").to_upper_case, SWT::F8) # $NON-NLS-1$
        self.attr_localized_key_codes.put(JFaceResources.get_string("F9").to_upper_case, SWT::F9) # $NON-NLS-1$
        self.attr_localized_key_codes.put(JFaceResources.get_string("F10").to_upper_case, SWT::F10) # $NON-NLS-1$
        self.attr_localized_key_codes.put(JFaceResources.get_string("F11").to_upper_case, SWT::F11) # $NON-NLS-1$
        self.attr_localized_key_codes.put(JFaceResources.get_string("F12").to_upper_case, SWT::F12) # $NON-NLS-1$
      end
      
      typesig { [] }
      # Initialize the list of localized modifiers
      def init_localized_modifiers
        self.attr_localized_ctrl = RJava.cast_to_string(JFaceResources.get_string("Ctrl").to_upper_case) # $NON-NLS-1$
        self.attr_localized_shift = RJava.cast_to_string(JFaceResources.get_string("Shift").to_upper_case) # $NON-NLS-1$
        self.attr_localized_alt = RJava.cast_to_string(JFaceResources.get_string("Alt").to_upper_case) # $NON-NLS-1$
        self.attr_localized_command = RJava.cast_to_string(JFaceResources.get_string("Command").to_upper_case) # $NON-NLS-1$
      end
      
      typesig { [String] }
      # Convenience method for removing any optional accelerator text from the
      # given string. The accelerator text appears at the end of the text, and is
      # separated from the main part by a single tab character <code>'\t'</code>.
      # 
      # @param text
      # the text
      # @return the text sans accelerator
      def remove_accelerator_text(text)
        index = text.last_index_of(Character.new(?\t.ord))
        if ((index).equal?(-1))
          index = text.last_index_of(Character.new(?@.ord))
        end
        if (index >= 0)
          return text.substring(0, index)
        end
        return text
      end
      
      typesig { [String] }
      # Convenience method for removing any mnemonics from the given string. For
      # example, <code>removeMnemonics("&Open")</code> will return
      # <code>"Open"</code>.
      # 
      # @param text
      # the text
      # @return the text sans mnemonics
      def remove_mnemonics(text)
        index = text.index_of(Character.new(?&.ord))
        if ((index).equal?(-1))
          return text
        end
        len = text.length
        sb = StringBuffer.new(len)
        last_index = 0
        while (!(index).equal?(-1))
          # ignore & at the end
          if ((index).equal?(len - 1))
            break
          end
          # handle the && case
          if ((text.char_at(index + 1)).equal?(Character.new(?&.ord)))
            (index += 1)
          end
          # DBCS languages use "(&X)" format
          if (index > 0 && (text.char_at(index - 1)).equal?(Character.new(?(.ord)) && text.length >= index + 3 && (text.char_at(index + 2)).equal?(Character.new(?).ord)))
            sb.append(text.substring(last_index, index - 1))
            index += 3
          else
            sb.append(text.substring(last_index, index))
            # skip the &
            (index += 1)
          end
          last_index = index
          index = text.index_of(Character.new(?&.ord), index)
        end
        if (last_index < len)
          sb.append(text.substring(last_index, len))
        end
        return sb.to_s
      end
    }
    
    typesig { [] }
    # This class cannot be instantiated.
    def initialize
      # Does nothing
    end
    
    private
    alias_method :initialize__legacy_action_tools, :initialize
  end
  
end
