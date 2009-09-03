require "rjava"

# Copyright (c) 2000, 2007 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Rules
  module WordPatternRuleImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Rules
      include_const ::Org::Eclipse::Core::Runtime, :Assert
    }
  end
  
  # A specific single line rule which stipulates that the start
  # and end sequence occur within a single word, as defined by a word detector.
  # 
  # @see IWordDetector
  class WordPatternRule < WordPatternRuleImports.const_get :SingleLineRule
    include_class_members WordPatternRuleImports
    
    # The word detector used by this rule
    attr_accessor :f_detector
    alias_method :attr_f_detector, :f_detector
    undef_method :f_detector
    alias_method :attr_f_detector=, :f_detector=
    undef_method :f_detector=
    
    # The internal buffer used for pattern detection
    attr_accessor :f_buffer
    alias_method :attr_f_buffer, :f_buffer
    undef_method :f_buffer
    alias_method :attr_f_buffer=, :f_buffer=
    undef_method :f_buffer=
    
    typesig { [IWordDetector, String, String, IToken] }
    # Creates a rule for the given starting and ending word
    # pattern which, if detected, will return the specified token.
    # A word detector is used to identify words.
    # 
    # @param detector the word detector to be used
    # @param startSequence the start sequence of the word pattern
    # @param endSequence the end sequence of the word pattern
    # @param token the token to be returned on success
    def initialize(detector, start_sequence, end_sequence, token)
      initialize__word_pattern_rule(detector, start_sequence, end_sequence, token, RJava.cast_to_char(0))
    end
    
    typesig { [IWordDetector, String, String, IToken, ::Java::Char] }
    # Creates a rule for the given starting and ending word
    # pattern which, if detected, will return the specified token.
    # A word detector is used to identify words.
    # Any character which follows the given escapeCharacter will be ignored.
    # 
    # @param detector the word detector to be used
    # @param startSequence the start sequence of the word pattern
    # @param endSequence the end sequence of the word pattern
    # @param token the token to be returned on success
    # @param escapeCharacter the escape character
    def initialize(detector, start_sequence, end_sequence, token, escape_character)
      @f_detector = nil
      @f_buffer = nil
      super(start_sequence, end_sequence, token, escape_character)
      @f_buffer = StringBuffer.new
      Assert.is_not_null(detector)
      @f_detector = detector
    end
    
    typesig { [ICharacterScanner] }
    # Returns whether the end sequence was detected.
    # The rule acquires the rest of the word, using the
    # provided word detector, and tests to determine if
    # it ends with the end sequence.
    # 
    # @param scanner the scanner to be used
    # @return <code>true</code> if the word ends on the given end sequence
    def end_sequence_detected(scanner)
      @f_buffer.set_length(0)
      c = scanner.read
      while (@f_detector.is_word_part(RJava.cast_to_char(c)))
        @f_buffer.append(RJava.cast_to_char(c))
        c = scanner.read
      end
      scanner.unread
      if (@f_buffer.length >= self.attr_f_end_sequence.attr_length)
        i = self.attr_f_end_sequence.attr_length - 1
        j = @f_buffer.length - 1
        while i >= 0
          if (!(self.attr_f_end_sequence[i]).equal?(@f_buffer.char_at(j)))
            unread_buffer(scanner)
            return false
          end
          i -= 1
          j -= 1
        end
        return true
      end
      unread_buffer(scanner)
      return false
    end
    
    typesig { [ICharacterScanner] }
    # Returns the characters in the buffer to the scanner.
    # Note that the rule must also return the characters
    # read in as part of the start sequence expect the first one.
    # 
    # @param scanner the scanner to be used
    def unread_buffer(scanner)
      @f_buffer.insert(0, self.attr_f_start_sequence)
      i = @f_buffer.length - 1
      while i > 0
        scanner.unread
        i -= 1
      end
    end
    
    private
    alias_method :initialize__word_pattern_rule, :initialize
  end
  
end
