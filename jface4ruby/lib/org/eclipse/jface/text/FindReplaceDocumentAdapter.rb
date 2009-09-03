require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
# Cagatay Calli <ccalli@gmail.com> - [find/replace] retain caps when replacing - https://bugs.eclipse.org/bugs/show_bug.cgi?id=28949
# Cagatay Calli <ccalli@gmail.com> - [find/replace] define & fix behavior of retain caps with other escapes and text before \C - https://bugs.eclipse.org/bugs/show_bug.cgi?id=217061
module Org::Eclipse::Jface::Text
  module FindReplaceDocumentAdapterImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
      include_const ::Java::Util::Regex, :Matcher
      include_const ::Java::Util::Regex, :Pattern
      include_const ::Java::Util::Regex, :PatternSyntaxException
      include_const ::Org::Eclipse::Core::Runtime, :Assert
    }
  end
  
  # Provides search and replace operations on
  # {@link org.eclipse.jface.text.IDocument}.
  # <p>
  # Replaces
  # {@link org.eclipse.jface.text.IDocument#search(int, String, boolean, boolean, boolean)}.
  # 
  # @since 3.0
  class FindReplaceDocumentAdapter 
    include_class_members FindReplaceDocumentAdapterImports
    include CharSequence
    
    class_module.module_eval {
      # Internal type for operation codes.
      const_set_lazy(:FindReplaceOperationCode) { Class.new do
        include_class_members FindReplaceDocumentAdapter
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__find_replace_operation_code, :initialize
      end }
      
      # Find/replace operation codes.
      const_set_lazy(:FIND_FIRST) { FindReplaceOperationCode.new }
      const_attr_reader  :FIND_FIRST
      
      const_set_lazy(:FIND_NEXT) { FindReplaceOperationCode.new }
      const_attr_reader  :FIND_NEXT
      
      const_set_lazy(:REPLACE) { FindReplaceOperationCode.new }
      const_attr_reader  :REPLACE
      
      const_set_lazy(:REPLACE_FIND_NEXT) { FindReplaceOperationCode.new }
      const_attr_reader  :REPLACE_FIND_NEXT
      
      # Retain case mode constants.
      # @since 3.4
      const_set_lazy(:RC_MIXED) { 0 }
      const_attr_reader  :RC_MIXED
      
      const_set_lazy(:RC_UPPER) { 1 }
      const_attr_reader  :RC_UPPER
      
      const_set_lazy(:RC_LOWER) { 2 }
      const_attr_reader  :RC_LOWER
      
      const_set_lazy(:RC_FIRSTUPPER) { 3 }
      const_attr_reader  :RC_FIRSTUPPER
    }
    
    # The adapted document.
    attr_accessor :f_document
    alias_method :attr_f_document, :f_document
    undef_method :f_document
    alias_method :attr_f_document=, :f_document=
    undef_method :f_document=
    
    # State for findReplace.
    attr_accessor :f_find_replace_state
    alias_method :attr_f_find_replace_state, :f_find_replace_state
    undef_method :f_find_replace_state
    alias_method :attr_f_find_replace_state=, :f_find_replace_state=
    undef_method :f_find_replace_state=
    
    # The matcher used in findReplace.
    attr_accessor :f_find_replace_matcher
    alias_method :attr_f_find_replace_matcher, :f_find_replace_matcher
    undef_method :f_find_replace_matcher
    alias_method :attr_f_find_replace_matcher=, :f_find_replace_matcher=
    undef_method :f_find_replace_matcher=
    
    # The match offset from the last findReplace call.
    attr_accessor :f_find_replace_match_offset
    alias_method :attr_f_find_replace_match_offset, :f_find_replace_match_offset
    undef_method :f_find_replace_match_offset
    alias_method :attr_f_find_replace_match_offset=, :f_find_replace_match_offset=
    undef_method :f_find_replace_match_offset=
    
    # Retain case mode
    attr_accessor :f_retain_case_mode
    alias_method :attr_f_retain_case_mode, :f_retain_case_mode
    undef_method :f_retain_case_mode
    alias_method :attr_f_retain_case_mode=, :f_retain_case_mode=
    undef_method :f_retain_case_mode=
    
    typesig { [IDocument] }
    # Constructs a new find replace document adapter.
    # 
    # @param document the adapted document
    def initialize(document)
      @f_document = nil
      @f_find_replace_state = nil
      @f_find_replace_matcher = nil
      @f_find_replace_match_offset = 0
      @f_retain_case_mode = 0
      Assert.is_not_null(document)
      @f_document = document
    end
    
    typesig { [::Java::Int, String, ::Java::Boolean, ::Java::Boolean, ::Java::Boolean, ::Java::Boolean] }
    # Returns the location of a given string in this adapter's document based on a set of search criteria.
    # 
    # @param startOffset document offset at which search starts
    # @param findString the string to find
    # @param forwardSearch the search direction
    # @param caseSensitive indicates whether lower and upper case should be distinguished
    # @param wholeWord indicates whether the findString should be limited by white spaces as
    # defined by Character.isWhiteSpace. Must not be used in combination with <code>regExSearch</code>.
    # @param regExSearch if <code>true</code> findString represents a regular expression
    # Must not be used in combination with <code>wholeWord</code>.
    # @return the find or replace region or <code>null</code> if there was no match
    # @throws BadLocationException if startOffset is an invalid document offset
    # @throws PatternSyntaxException if a regular expression has invalid syntax
    def find(start_offset, find_string, forward_search, case_sensitive, whole_word, reg_ex_search)
      Assert.is_true(!(reg_ex_search && whole_word))
      # Adjust offset to special meaning of -1
      if ((start_offset).equal?(-1) && forward_search)
        start_offset = 0
      end
      if ((start_offset).equal?(-1) && !forward_search)
        start_offset = length - 1
      end
      return find_replace(FIND_FIRST, start_offset, find_string, nil, forward_search, case_sensitive, whole_word, reg_ex_search)
    end
    
    typesig { [FindReplaceOperationCode, ::Java::Int, String, String, ::Java::Boolean, ::Java::Boolean, ::Java::Boolean, ::Java::Boolean] }
    # Stateful findReplace executes a FIND, REPLACE, REPLACE_FIND or FIND_FIRST operation.
    # In case of REPLACE and REPLACE_FIND it sends a <code>DocumentEvent</code> to all
    # registered <code>IDocumentListener</code>.
    # 
    # @param startOffset document offset at which search starts
    # this value is only used in the FIND_FIRST operation and otherwise ignored
    # @param findString the string to find
    # this value is only used in the FIND_FIRST operation and otherwise ignored
    # @param replaceText the string to replace the current match
    # this value is only used in the REPLACE and REPLACE_FIND operations and otherwise ignored
    # @param forwardSearch the search direction
    # @param caseSensitive indicates whether lower and upper case should be distinguished
    # @param wholeWord indicates whether the findString should be limited by white spaces as
    # defined by Character.isWhiteSpace. Must not be used in combination with <code>regExSearch</code>.
    # @param regExSearch if <code>true</code> this operation represents a regular expression
    # Must not be used in combination with <code>wholeWord</code>.
    # @param operationCode specifies what kind of operation is executed
    # @return the find or replace region or <code>null</code> if there was no match
    # @throws BadLocationException if startOffset is an invalid document offset
    # @throws IllegalStateException if a REPLACE or REPLACE_FIND operation is not preceded by a successful FIND operation
    # @throws PatternSyntaxException if a regular expression has invalid syntax
    def find_replace(operation_code, start_offset, find_string, replace_text, forward_search, case_sensitive, whole_word, reg_ex_search)
      # Validate option combinations
      Assert.is_true(!(reg_ex_search && whole_word))
      # Validate state
      if (((operation_code).equal?(REPLACE) || (operation_code).equal?(REPLACE_FIND_NEXT)) && (!(@f_find_replace_state).equal?(FIND_FIRST) && !(@f_find_replace_state).equal?(FIND_NEXT)))
        raise IllegalStateException.new("illegal findReplace state: cannot replace without preceding find")
      end # $NON-NLS-1$
      if ((operation_code).equal?(FIND_FIRST))
        # Reset
        if ((find_string).nil? || (find_string.length).equal?(0))
          return nil
        end
        # Validate start offset
        if (start_offset < 0 || start_offset >= length)
          raise BadLocationException.new
        end
        pattern_flags = 0
        if (reg_ex_search)
          pattern_flags |= Pattern::MULTILINE
          find_string = RJava.cast_to_string(substitute_linebreak(find_string))
        end
        if (!case_sensitive)
          pattern_flags |= Pattern::CASE_INSENSITIVE | Pattern::UNICODE_CASE
        end
        if (whole_word)
          find_string = "\\b" + find_string + "\\b"
        end # $NON-NLS-1$ //$NON-NLS-2$
        if (!reg_ex_search && !whole_word)
          find_string = RJava.cast_to_string(as_reg_pattern(find_string))
        end
        @f_find_replace_match_offset = start_offset
        if (!(@f_find_replace_matcher).nil? && (@f_find_replace_matcher.pattern.pattern == find_string) && (@f_find_replace_matcher.pattern.flags).equal?(pattern_flags))
          # Commented out for optimization:
          # The call is not needed since FIND_FIRST uses find(int) which resets the matcher
          # 
          # fFindReplaceMatcher.reset();
        else
          pattern_ = Pattern.compile(find_string, pattern_flags)
          @f_find_replace_matcher = pattern_.matcher(self)
        end
      end
      # Set state
      @f_find_replace_state = operation_code
      if ((operation_code).equal?(REPLACE) || (operation_code).equal?(REPLACE_FIND_NEXT))
        if (reg_ex_search)
          pattern_ = @f_find_replace_matcher.pattern
          prev_match = @f_find_replace_matcher.group
          begin
            replace_text = RJava.cast_to_string(interpret_replace_escapes(replace_text, prev_match))
            replace_text_matcher = pattern_.matcher(prev_match)
            replace_text = RJava.cast_to_string(replace_text_matcher.replace_first(replace_text))
          rescue IndexOutOfBoundsException => ex
            raise PatternSyntaxException.new(ex.get_localized_message, replace_text, -1)
          end
        end
        offset = @f_find_replace_matcher.start
        length_ = @f_find_replace_matcher.group.length
        if (@f_document.is_a?(IRepairableDocumentExtension) && (@f_document).is_line_information_repair_needed(offset, length_, replace_text))
          message = TextMessages.get_string("FindReplaceDocumentAdapter.incompatibleLineDelimiter") # $NON-NLS-1$
          raise PatternSyntaxException.new(message, replace_text, offset)
        end
        @f_document.replace(offset, length_, replace_text)
        if ((operation_code).equal?(REPLACE))
          return Region.new(offset, replace_text.length)
        end
      end
      if (!(operation_code).equal?(REPLACE))
        begin
          if (forward_search)
            found = false
            if ((operation_code).equal?(FIND_FIRST))
              found = @f_find_replace_matcher.find(start_offset)
            else
              found = @f_find_replace_matcher.find
            end
            if ((operation_code).equal?(REPLACE_FIND_NEXT))
              @f_find_replace_state = FIND_NEXT
            end
            if (found && @f_find_replace_matcher.group.length > 0)
              return Region.new(@f_find_replace_matcher.start, @f_find_replace_matcher.group.length)
            end
            return nil
          end
          # backward search
          found = @f_find_replace_matcher.find(0)
          index = -1
          length_ = -1
          while (found && @f_find_replace_matcher.start + @f_find_replace_matcher.group.length <= @f_find_replace_match_offset + 1)
            index = @f_find_replace_matcher.start
            length_ = @f_find_replace_matcher.group.length
            found = @f_find_replace_matcher.find(index + 1)
          end
          @f_find_replace_match_offset = index
          if (index > -1)
            # must set matcher to correct position
            @f_find_replace_matcher.find(index)
            return Region.new(index, length_)
          end
          return nil
        rescue StackOverflowError => e
          message = TextMessages.get_string("FindReplaceDocumentAdapter.patternTooComplex") # $NON-NLS-1$
          raise PatternSyntaxException.new(message, find_string, -1)
        end
      end
      return nil
    end
    
    typesig { [String] }
    # Substitutes \R in a regex find pattern with (?>\r\n?|\n)
    # 
    # @param findString the original find pattern
    # @return the transformed find pattern
    # @throws PatternSyntaxException if \R is added at an illegal position (e.g. in a character set)
    # @since 3.4
    def substitute_linebreak(find_string)
      length_ = find_string.length
      buf = StringBuffer.new(length_)
      in_char_group = 0
      in_braces = 0
      in_quote = false
      i = 0
      while i < length_
        ch = find_string.char_at(i)
        case (ch)
        when Character.new(?[.ord)
          buf.append(ch)
          if (!in_quote)
            in_char_group += 1
          end
        when Character.new(?].ord)
          buf.append(ch)
          if (!in_quote)
            in_char_group -= 1
          end
        when Character.new(?{.ord)
          buf.append(ch)
          if (!in_quote && (in_char_group).equal?(0))
            in_braces += 1
          end
        when Character.new(?}.ord)
          buf.append(ch)
          if (!in_quote && (in_char_group).equal?(0))
            in_braces -= 1
          end
        when Character.new(?\\.ord)
          if (i + 1 < length_)
            ch1 = find_string.char_at(i + 1)
            if (in_quote)
              if ((ch1).equal?(Character.new(?E.ord)))
                in_quote = false
              end
              buf.append(ch).append(ch1)
              i += 1
            else
              if ((ch1).equal?(Character.new(?R.ord)))
                if (in_char_group > 0 || in_braces > 0)
                  msg = TextMessages.get_string("FindReplaceDocumentAdapter.illegalLinebreak") # $NON-NLS-1$
                  raise PatternSyntaxException.new(msg, find_string, i)
                end
                buf.append("(?>\\r\\n?|\\n)") # $NON-NLS-1$
                i += 1
              else
                if ((ch1).equal?(Character.new(?Q.ord)))
                  in_quote = true
                end
                buf.append(ch).append(ch1)
                i += 1
              end
            end
          else
            buf.append(ch)
          end
        else
          buf.append(ch)
        end
        i += 1
      end
      return buf.to_s
    end
    
    typesig { [StringBuffer, ::Java::Char] }
    # Interprets current Retain Case mode (all upper-case,all lower-case,capitalized or mixed)
    # and appends the character <code>ch</code> to <code>buf</code> after processing.
    # 
    # @param buf the output buffer
    # @param ch the character to process
    # @since 3.4
    def interpret_retain_case(buf, ch)
      if ((@f_retain_case_mode).equal?(RC_UPPER))
        buf.append(Character.to_upper_case(ch))
      else
        if ((@f_retain_case_mode).equal?(RC_LOWER))
          buf.append(Character.to_lower_case(ch))
        else
          if ((@f_retain_case_mode).equal?(RC_FIRSTUPPER))
            buf.append(Character.to_upper_case(ch))
            @f_retain_case_mode = RC_MIXED
          else
            buf.append(ch)
          end
        end
      end
    end
    
    typesig { [String, String] }
    # Interprets escaped characters in the given replace pattern.
    # 
    # @param replaceText the replace pattern
    # @param foundText the found pattern to be replaced
    # @return a replace pattern with escaped characters substituted by the respective characters
    # @since 3.4
    def interpret_replace_escapes(replace_text, found_text)
      length_ = replace_text.length
      in_escape = false
      buf = StringBuffer.new(length_)
      # every string we did not check looks mixed at first
      # so initialize retain case mode with RC_MIXED
      @f_retain_case_mode = RC_MIXED
      i = 0
      while i < length_
        ch = replace_text.char_at(i)
        if (in_escape)
          i = interpret_replace_escape(ch, i, buf, replace_text, found_text)
          in_escape = false
        else
          if ((ch).equal?(Character.new(?\\.ord)))
            in_escape = true
          else
            if ((ch).equal?(Character.new(?$.ord)))
              buf.append(ch)
              # Feature in java.util.regex.Matcher#replaceFirst(String):
              # $00, $000, etc. are interpreted as $0 and
              # $01, $001, etc. are interpreted as $1, etc. .
              # If we support \0 as replacement pattern for capturing group 0,
              # it would not be possible any more to write a replacement pattern
              # that appends 0 to a capturing group (like $0\0).
              # The fix is to interpret \00 and $00 as $0\0, and
              # \01 and $01 as $0\1, etc.
              if (i + 2 < length_)
                ch1 = replace_text.char_at(i + 1)
                ch2 = replace_text.char_at(i + 2)
                if ((ch1).equal?(Character.new(?0.ord)) && Character.new(?0.ord) <= ch2 && ch2 <= Character.new(?9.ord))
                  buf.append("0\\") # $NON-NLS-1$
                  i += 1 # consume the 0
                end
              end
            else
              interpret_retain_case(buf, ch)
            end
          end
        end
        i += 1
      end
      if (in_escape)
        # '\' as last character is invalid, but we still add it to get an error message
        buf.append(Character.new(?\\.ord))
      end
      return buf.to_s
    end
    
    typesig { [::Java::Char, ::Java::Int, StringBuffer, String, String] }
    # Interprets the escaped character <code>ch</code> at offset <code>i</code>
    # of the <code>replaceText</code> and appends the interpretation to <code>buf</code>.
    # 
    # @param ch the escaped character
    # @param i the offset
    # @param buf the output buffer
    # @param replaceText the original replace pattern
    # @param foundText the found pattern to be replaced
    # @return the new offset
    # @since 3.4
    def interpret_replace_escape(ch, i, buf, replace_text, found_text)
      length_ = replace_text.length
      case (ch)
      # \0 for octal is not supported in replace string, since it
      # would conflict with capturing group \0, etc.
      when Character.new(?r.ord)
        buf.append(Character.new(?\r.ord))
      when Character.new(?n.ord)
        buf.append(Character.new(?\n.ord))
      when Character.new(?t.ord)
        buf.append(Character.new(?\t.ord))
      when Character.new(?f.ord)
        buf.append(Character.new(?\f.ord))
      when Character.new(?a.ord)
        buf.append(Character.new(0x0007))
      when Character.new(?e.ord)
        buf.append(Character.new(0x001B))
      when Character.new(?R.ord)
        # see http://www.unicode.org/unicode/reports/tr18/#Line_Boundaries
        buf.append(TextUtilities.get_default_line_delimiter(@f_document))
      when Character.new(?0.ord)
        buf.append(Character.new(?$.ord)).append(ch)
        # See explanation in "Feature in java.util.regex.Matcher#replaceFirst(String)"
        # in interpretReplaceEscape(String) above.
        if (i + 1 < length_)
          ch1 = replace_text.char_at(i + 1)
          if (Character.new(?0.ord) <= ch1 && ch1 <= Character.new(?9.ord))
            buf.append(Character.new(?\\.ord))
          end
        end
      when Character.new(?1.ord), Character.new(?2.ord), Character.new(?3.ord), Character.new(?4.ord), Character.new(?5.ord), Character.new(?6.ord), Character.new(?7.ord), Character.new(?8.ord), Character.new(?9.ord)
        buf.append(Character.new(?$.ord)).append(ch)
      when Character.new(?c.ord)
        if (i + 1 < length_)
          ch1 = replace_text.char_at(i + 1)
          interpret_retain_case(buf, RJava.cast_to_char((ch1 ^ 64)))
          i += 1
        else
          msg = TextMessages.get_formatted_string("FindReplaceDocumentAdapter.illegalControlEscape", "\\c") # $NON-NLS-1$ //$NON-NLS-2$
          raise PatternSyntaxException.new(msg, replace_text, i)
        end
      when Character.new(?x.ord)
        if (i + 2 < length_)
          parsed_int = 0
          begin
            parsed_int = JavaInteger.parse_int(replace_text.substring(i + 1, i + 3), 16)
            if (parsed_int < 0)
              raise NumberFormatException.new
            end
          rescue NumberFormatException => e
            msg = TextMessages.get_formatted_string("FindReplaceDocumentAdapter.illegalHexEscape", replace_text.substring(i - 1, i + 3)) # $NON-NLS-1$
            raise PatternSyntaxException.new(msg, replace_text, i)
          end
          interpret_retain_case(buf, RJava.cast_to_char(parsed_int))
          i += 2
        else
          msg = TextMessages.get_formatted_string("FindReplaceDocumentAdapter.illegalHexEscape", replace_text.substring(i - 1, length_)) # $NON-NLS-1$
          raise PatternSyntaxException.new(msg, replace_text, i)
        end
      when Character.new(?u.ord)
        if (i + 4 < length_)
          parsed_int = 0
          begin
            parsed_int = JavaInteger.parse_int(replace_text.substring(i + 1, i + 5), 16)
            if (parsed_int < 0)
              raise NumberFormatException.new
            end
          rescue NumberFormatException => e
            msg = TextMessages.get_formatted_string("FindReplaceDocumentAdapter.illegalUnicodeEscape", replace_text.substring(i - 1, i + 5)) # $NON-NLS-1$
            raise PatternSyntaxException.new(msg, replace_text, i)
          end
          interpret_retain_case(buf, RJava.cast_to_char(parsed_int))
          i += 4
        else
          msg = TextMessages.get_formatted_string("FindReplaceDocumentAdapter.illegalUnicodeEscape", replace_text.substring(i - 1, length_)) # $NON-NLS-1$
          raise PatternSyntaxException.new(msg, replace_text, i)
        end
      when Character.new(?C.ord)
        if ((found_text.to_upper_case == found_text))
          # is whole match upper-case?
          @f_retain_case_mode = RC_UPPER
        else
          if ((found_text.to_lower_case == found_text))
            # is whole match lower-case?
            @f_retain_case_mode = RC_LOWER
          else
            if (Character.is_upper_case(found_text.char_at(0)))
              # is first character upper-case?
              @f_retain_case_mode = RC_FIRSTUPPER
            else
              @f_retain_case_mode = RC_MIXED
            end
          end
        end
      else
        # unknown escape k: append uninterpreted \k
        buf.append(Character.new(?\\.ord)).append(ch)
      end
      return i
    end
    
    typesig { [String] }
    # Converts a non-regex string to a pattern
    # that can be used with the regex search engine.
    # 
    # @param string the non-regex pattern
    # @return the string converted to a regex pattern
    def as_reg_pattern(string)
      out = StringBuffer.new(string.length)
      quoting = false
      i = 0
      length_ = string.length
      while i < length_
        ch = string.char_at(i)
        if ((ch).equal?(Character.new(?\\.ord)))
          if (quoting)
            out.append("\\E") # $NON-NLS-1$
            quoting = false
          end
          out.append("\\\\") # $NON-NLS-1$
          i += 1
          next
        end
        if (!quoting)
          out.append("\\Q") # $NON-NLS-1$
          quoting = true
        end
        out.append(ch)
        i += 1
      end
      if (quoting)
        out.append("\\E")
      end # $NON-NLS-1$
      return out.to_s
    end
    
    typesig { [String, ::Java::Boolean] }
    # Substitutes the previous match with the given text.
    # Sends a <code>DocumentEvent</code> to all registered <code>IDocumentListener</code>.
    # 
    # @param text the substitution text
    # @param regExReplace if <code>true</code> <code>text</code> represents a regular expression
    # @return the replace region or <code>null</code> if there was no match
    # @throws BadLocationException if startOffset is an invalid document offset
    # @throws IllegalStateException if a REPLACE or REPLACE_FIND operation is not preceded by a successful FIND operation
    # @throws PatternSyntaxException if a regular expression has invalid syntax
    # 
    # @see DocumentEvent
    # @see IDocumentListener
    def replace(text, reg_ex_replace)
      return find_replace(REPLACE, -1, nil, text, false, false, false, reg_ex_replace)
    end
    
    typesig { [] }
    # ---------- CharSequence implementation ----------
    # 
    # @see java.lang.CharSequence#length()
    def length
      return @f_document.get_length
    end
    
    typesig { [::Java::Int] }
    # @see java.lang.CharSequence#charAt(int)
    def char_at(index)
      begin
        return @f_document.get_char(index)
      rescue BadLocationException => e
        raise IndexOutOfBoundsException.new
      end
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # @see java.lang.CharSequence#subSequence(int, int)
    def sub_sequence(start_, end_)
      begin
        return @f_document.get(start_, end_ - start_)
      rescue BadLocationException => e
        raise IndexOutOfBoundsException.new
      end
    end
    
    typesig { [] }
    # @see java.lang.Object#toString()
    def to_s
      return @f_document.get
    end
    
    class_module.module_eval {
      typesig { [String] }
      # Escapes special characters in the string, such that the resulting pattern
      # matches the given string.
      # 
      # @param string the string to escape
      # @return a regex pattern that matches the given string
      # @since 3.5
      def escape_for_reg_ex_pattern(string)
        # implements https://bugs.eclipse.org/bugs/show_bug.cgi?id=44422
        pattern_ = StringBuffer.new(string.length + 16)
        length_ = string.length
        if (length_ > 0 && (string.char_at(0)).equal?(Character.new(?^.ord)))
          pattern_.append(Character.new(?\\.ord))
        end
        i = 0
        while i < length_
          ch = string.char_at(i)
          case (ch)
          # $FALL-THROUGH$
          when Character.new(?\\.ord), Character.new(?(.ord), Character.new(?).ord), Character.new(?[.ord), Character.new(?].ord), Character.new(?{.ord), Character.new(?}.ord), Character.new(?..ord), Character.new(??.ord), Character.new(?*.ord), Character.new(?+.ord), Character.new(?|.ord)
            pattern_.append(Character.new(?\\.ord)).append(ch)
          when Character.new(?\r.ord)
            if (i + 1 < length_ && (string.char_at(i + 1)).equal?(Character.new(?\n.ord)))
              i += 1
            end
            pattern_.append("\\R") # $NON-NLS-1$
          when Character.new(?\n.ord)
            pattern_.append("\\R") # $NON-NLS-1$
          when Character.new(?\t.ord)
            pattern_.append("\\t") # $NON-NLS-1$
          when Character.new(?\f.ord)
            pattern_.append("\\f") # $NON-NLS-1$
          when 0x7
            pattern_.append("\\a") # $NON-NLS-1$
          when 0x1b
            pattern_.append("\\e") # $NON-NLS-1$
          else
            if (0 <= ch && ch < 0x20)
              pattern_.append("\\x") # $NON-NLS-1$
              pattern_.append(JavaInteger.to_hex_string(ch).to_upper_case)
            else
              pattern_.append(ch)
            end
          end
          i += 1
        end
        if (length_ > 0 && (string.char_at(length_ - 1)).equal?(Character.new(?$.ord)))
          pattern_.insert(pattern_.length - 1, Character.new(?\\.ord))
        end
        return pattern_.to_s
      end
    }
    
    private
    alias_method :initialize__find_replace_document_adapter, :initialize
  end
  
end
