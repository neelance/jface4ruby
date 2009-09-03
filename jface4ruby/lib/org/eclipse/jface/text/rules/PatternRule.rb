require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
# Christopher Lenz (cmlenz@gmx.de) - support for line continuation
module Org::Eclipse::Jface::Text::Rules
  module PatternRuleImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Rules
      include_const ::Java::Util, :Arrays
      include_const ::Java::Util, :Comparator
      include_const ::Org::Eclipse::Core::Runtime, :Assert
    }
  end
  
  # Standard implementation of <code>IPredicateRule</code>.
  # Is is capable of detecting a pattern which begins with a given start
  # sequence and ends with a given end sequence. If the end sequence is
  # not specified, it can be either end of line, end or file, or both. Additionally,
  # the pattern can be constrained to begin in a certain column. The rule can also
  # be used to check whether the text to scan covers half of the pattern, i.e. contains
  # the end sequence required by the rule.
  class PatternRule 
    include_class_members PatternRuleImports
    include IPredicateRule
    
    class_module.module_eval {
      # Comparator that orders <code>char[]</code> in decreasing array lengths.
      # 
      # @since 3.1
      const_set_lazy(:DecreasingCharArrayLengthComparator) { Class.new do
        include_class_members PatternRule
        include Comparator
        
        typesig { [Object, Object] }
        def compare(o1, o2)
          return (o2).attr_length - (o1).attr_length
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__decreasing_char_array_length_comparator, :initialize
      end }
      
      # Internal setting for the un-initialized column constraint
      const_set_lazy(:UNDEFINED) { -1 }
      const_attr_reader  :UNDEFINED
    }
    
    # The token to be returned on success
    attr_accessor :f_token
    alias_method :attr_f_token, :f_token
    undef_method :f_token
    alias_method :attr_f_token=, :f_token=
    undef_method :f_token=
    
    # The pattern's start sequence
    attr_accessor :f_start_sequence
    alias_method :attr_f_start_sequence, :f_start_sequence
    undef_method :f_start_sequence
    alias_method :attr_f_start_sequence=, :f_start_sequence=
    undef_method :f_start_sequence=
    
    # The pattern's end sequence
    attr_accessor :f_end_sequence
    alias_method :attr_f_end_sequence, :f_end_sequence
    undef_method :f_end_sequence
    alias_method :attr_f_end_sequence=, :f_end_sequence=
    undef_method :f_end_sequence=
    
    # The pattern's column constrain
    attr_accessor :f_column
    alias_method :attr_f_column, :f_column
    undef_method :f_column
    alias_method :attr_f_column=, :f_column=
    undef_method :f_column=
    
    # The pattern's escape character
    attr_accessor :f_escape_character
    alias_method :attr_f_escape_character, :f_escape_character
    undef_method :f_escape_character
    alias_method :attr_f_escape_character=, :f_escape_character=
    undef_method :f_escape_character=
    
    # Indicates whether the escape character continues a line
    # @since 3.0
    attr_accessor :f_escape_continues_line
    alias_method :attr_f_escape_continues_line, :f_escape_continues_line
    undef_method :f_escape_continues_line
    alias_method :attr_f_escape_continues_line=, :f_escape_continues_line=
    undef_method :f_escape_continues_line=
    
    # Indicates whether end of line terminates the pattern
    attr_accessor :f_breaks_on_eol
    alias_method :attr_f_breaks_on_eol, :f_breaks_on_eol
    undef_method :f_breaks_on_eol
    alias_method :attr_f_breaks_on_eol=, :f_breaks_on_eol=
    undef_method :f_breaks_on_eol=
    
    # Indicates whether end of file terminates the pattern
    attr_accessor :f_breaks_on_eof
    alias_method :attr_f_breaks_on_eof, :f_breaks_on_eof
    undef_method :f_breaks_on_eof
    alias_method :attr_f_breaks_on_eof=, :f_breaks_on_eof=
    undef_method :f_breaks_on_eof=
    
    # Line delimiter comparator which orders according to decreasing delimiter length.
    # @since 3.1
    attr_accessor :f_line_delimiter_comparator
    alias_method :attr_f_line_delimiter_comparator, :f_line_delimiter_comparator
    undef_method :f_line_delimiter_comparator
    alias_method :attr_f_line_delimiter_comparator=, :f_line_delimiter_comparator=
    undef_method :f_line_delimiter_comparator=
    
    # Cached line delimiters.
    # @since 3.1
    attr_accessor :f_line_delimiters
    alias_method :attr_f_line_delimiters, :f_line_delimiters
    undef_method :f_line_delimiters
    alias_method :attr_f_line_delimiters=, :f_line_delimiters=
    undef_method :f_line_delimiters=
    
    # Cached sorted {@linkplain #fLineDelimiters}.
    # @since 3.1
    attr_accessor :f_sorted_line_delimiters
    alias_method :attr_f_sorted_line_delimiters, :f_sorted_line_delimiters
    undef_method :f_sorted_line_delimiters
    alias_method :attr_f_sorted_line_delimiters=, :f_sorted_line_delimiters=
    undef_method :f_sorted_line_delimiters=
    
    typesig { [String, String, IToken, ::Java::Char, ::Java::Boolean] }
    # Creates a rule for the given starting and ending sequence.
    # When these sequences are detected the rule will return the specified token.
    # Alternatively, the sequence can also be ended by the end of the line.
    # Any character which follows the given escapeCharacter will be ignored.
    # 
    # @param startSequence the pattern's start sequence
    # @param endSequence the pattern's end sequence, <code>null</code> is a legal value
    # @param token the token which will be returned on success
    # @param escapeCharacter any character following this one will be ignored
    # @param breaksOnEOL indicates whether the end of the line also terminates the pattern
    def initialize(start_sequence, end_sequence, token, escape_character, breaks_on_eol)
      @f_token = nil
      @f_start_sequence = nil
      @f_end_sequence = nil
      @f_column = UNDEFINED
      @f_escape_character = 0
      @f_escape_continues_line = false
      @f_breaks_on_eol = false
      @f_breaks_on_eof = false
      @f_line_delimiter_comparator = DecreasingCharArrayLengthComparator.new
      @f_line_delimiters = nil
      @f_sorted_line_delimiters = nil
      Assert.is_true(!(start_sequence).nil? && start_sequence.length > 0)
      Assert.is_true(!(end_sequence).nil? || breaks_on_eol)
      Assert.is_not_null(token)
      @f_start_sequence = start_sequence.to_char_array
      @f_end_sequence = ((end_sequence).nil? ? CharArray.new(0) : end_sequence.to_char_array)
      @f_token = token
      @f_escape_character = escape_character
      @f_breaks_on_eol = breaks_on_eol
    end
    
    typesig { [String, String, IToken, ::Java::Char, ::Java::Boolean, ::Java::Boolean] }
    # Creates a rule for the given starting and ending sequence.
    # When these sequences are detected the rule will return the specified token.
    # Alternatively, the sequence can also be ended by the end of the line or the end of the file.
    # Any character which follows the given escapeCharacter will be ignored.
    # 
    # @param startSequence the pattern's start sequence
    # @param endSequence the pattern's end sequence, <code>null</code> is a legal value
    # @param token the token which will be returned on success
    # @param escapeCharacter any character following this one will be ignored
    # @param breaksOnEOL indicates whether the end of the line also terminates the pattern
    # @param breaksOnEOF indicates whether the end of the file also terminates the pattern
    # @since 2.1
    def initialize(start_sequence, end_sequence, token, escape_character, breaks_on_eol, breaks_on_eof)
      initialize__pattern_rule(start_sequence, end_sequence, token, escape_character, breaks_on_eol)
      @f_breaks_on_eof = breaks_on_eof
    end
    
    typesig { [String, String, IToken, ::Java::Char, ::Java::Boolean, ::Java::Boolean, ::Java::Boolean] }
    # Creates a rule for the given starting and ending sequence.
    # When these sequences are detected the rule will return the specified token.
    # Alternatively, the sequence can also be ended by the end of the line or the end of the file.
    # Any character which follows the given escapeCharacter will be ignored. An end of line
    # immediately after the given <code>lineContinuationCharacter</code> will not cause the
    # pattern to terminate even if <code>breakOnEOL</code> is set to true.
    # 
    # @param startSequence the pattern's start sequence
    # @param endSequence the pattern's end sequence, <code>null</code> is a legal value
    # @param token the token which will be returned on success
    # @param escapeCharacter any character following this one will be ignored
    # @param breaksOnEOL indicates whether the end of the line also terminates the pattern
    # @param breaksOnEOF indicates whether the end of the file also terminates the pattern
    # @param escapeContinuesLine indicates whether the specified escape character is used for line
    # continuation, so that an end of line immediately after the escape character does not
    # terminate the pattern, even if <code>breakOnEOL</code> is set
    # @since 3.0
    def initialize(start_sequence, end_sequence, token, escape_character, breaks_on_eol, breaks_on_eof, escape_continues_line)
      initialize__pattern_rule(start_sequence, end_sequence, token, escape_character, breaks_on_eol, breaks_on_eof)
      @f_escape_continues_line = escape_continues_line
    end
    
    typesig { [::Java::Int] }
    # Sets a column constraint for this rule. If set, the rule's token
    # will only be returned if the pattern is detected starting at the
    # specified column. If the column is smaller then 0, the column
    # constraint is considered removed.
    # 
    # @param column the column in which the pattern starts
    def set_column_constraint(column)
      if (column < 0)
        column = UNDEFINED
      end
      @f_column = column
    end
    
    typesig { [ICharacterScanner] }
    # Evaluates this rules without considering any column constraints.
    # 
    # @param scanner the character scanner to be used
    # @return the token resulting from this evaluation
    def do_evaluate(scanner)
      return do_evaluate(scanner, false)
    end
    
    typesig { [ICharacterScanner, ::Java::Boolean] }
    # Evaluates this rules without considering any column constraints. Resumes
    # detection, i.e. look sonly for the end sequence required by this rule if the
    # <code>resume</code> flag is set.
    # 
    # @param scanner the character scanner to be used
    # @param resume <code>true</code> if detection should be resumed, <code>false</code> otherwise
    # @return the token resulting from this evaluation
    # @since 2.0
    def do_evaluate(scanner, resume)
      if (resume)
        if (end_sequence_detected(scanner))
          return @f_token
        end
      else
        c = scanner.read
        if ((c).equal?(@f_start_sequence[0]))
          if (sequence_detected(scanner, @f_start_sequence, false))
            if (end_sequence_detected(scanner))
              return @f_token
            end
          end
        end
      end
      scanner.unread
      return Token::UNDEFINED
    end
    
    typesig { [ICharacterScanner] }
    # @see IRule#evaluate(ICharacterScanner)
    def evaluate(scanner)
      return evaluate(scanner, false)
    end
    
    typesig { [ICharacterScanner] }
    # Returns whether the end sequence was detected. As the pattern can be considered
    # ended by a line delimiter, the result of this method is <code>true</code> if the
    # rule breaks on the end of the line, or if the EOF character is read.
    # 
    # @param scanner the character scanner to be used
    # @return <code>true</code> if the end sequence has been detected
    def end_sequence_detected(scanner)
      original_delimiters = scanner.get_legal_line_delimiters
      count = original_delimiters.attr_length
      if ((@f_line_delimiters).nil? || !(original_delimiters.attr_length).equal?(count))
        @f_sorted_line_delimiters = Array.typed(Array.typed(::Java::Char)).new(count) { nil }
      else
        while (count > 0 && (@f_line_delimiters[count - 1]).equal?(original_delimiters[count - 1]))
          count -= 1
        end
      end
      if (!(count).equal?(0))
        @f_line_delimiters = original_delimiters
        System.arraycopy(@f_line_delimiters, 0, @f_sorted_line_delimiters, 0, @f_line_delimiters.attr_length)
        Arrays.sort(@f_sorted_line_delimiters, @f_line_delimiter_comparator)
      end
      read_count = 1
      c = 0
      while (!((c = scanner.read)).equal?(ICharacterScanner::EOF))
        if ((c).equal?(@f_escape_character))
          # Skip escaped character(s)
          if (@f_escape_continues_line)
            c = scanner.read
            i = 0
            while i < @f_sorted_line_delimiters.attr_length
              if ((c).equal?(@f_sorted_line_delimiters[i][0]) && sequence_detected(scanner, @f_sorted_line_delimiters[i], true))
                break
              end
              i += 1
            end
          else
            scanner.read
          end
        else
          if (@f_end_sequence.attr_length > 0 && (c).equal?(@f_end_sequence[0]))
            # Check if the specified end sequence has been found.
            if (sequence_detected(scanner, @f_end_sequence, true))
              return true
            end
          else
            if (@f_breaks_on_eol)
              # Check for end of line since it can be used to terminate the pattern.
              i = 0
              while i < @f_sorted_line_delimiters.attr_length
                if ((c).equal?(@f_sorted_line_delimiters[i][0]) && sequence_detected(scanner, @f_sorted_line_delimiters[i], true))
                  return true
                end
                i += 1
              end
            end
          end
        end
        read_count += 1
      end
      if (@f_breaks_on_eof)
        return true
      end
      while read_count > 0
        scanner.unread
        read_count -= 1
      end
      return false
    end
    
    typesig { [ICharacterScanner, Array.typed(::Java::Char), ::Java::Boolean] }
    # Returns whether the next characters to be read by the character scanner
    # are an exact match with the given sequence. No escape characters are allowed
    # within the sequence. If specified the sequence is considered to be found
    # when reading the EOF character.
    # 
    # @param scanner the character scanner to be used
    # @param sequence the sequence to be detected
    # @param eofAllowed indicated whether EOF terminates the pattern
    # @return <code>true</code> if the given sequence has been detected
    def sequence_detected(scanner, sequence, eof_allowed)
      i = 1
      while i < sequence.attr_length
        c = scanner.read
        if ((c).equal?(ICharacterScanner::EOF) && eof_allowed)
          return true
        else
          if (!(c).equal?(sequence[i]))
            # Non-matching character detected, rewind the scanner back to the start.
            # Do not unread the first character.
            scanner.unread
            j = i - 1
            while j > 0
              scanner.unread
              j -= 1
            end
            return false
          end
        end
        i += 1
      end
      return true
    end
    
    typesig { [ICharacterScanner, ::Java::Boolean] }
    # @see IPredicateRule#evaluate(ICharacterScanner, boolean)
    # @since 2.0
    def evaluate(scanner, resume)
      if ((@f_column).equal?(UNDEFINED))
        return do_evaluate(scanner, resume)
      end
      c = scanner.read
      scanner.unread
      if ((c).equal?(@f_start_sequence[0]))
        return ((@f_column).equal?(scanner.get_column) ? do_evaluate(scanner, resume) : Token::UNDEFINED)
      end
      return Token::UNDEFINED
    end
    
    typesig { [] }
    # @see IPredicateRule#getSuccessToken()
    # @since 2.0
    def get_success_token
      return @f_token
    end
    
    private
    alias_method :initialize__pattern_rule, :initialize
  end
  
end
