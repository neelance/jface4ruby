require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Rules
  module WordRuleImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Rules
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :Map
      include_const ::Org::Eclipse::Core::Runtime, :Assert
    }
  end
  
  # An implementation of {@link IRule} capable of detecting words. A word rule also allows to
  # associate a token to a word. That is, not only can the rule be used to provide tokens for exact
  # matches, but also for the generalized notion of a word in the context in which it is used. A word
  # rule uses a word detector to determine what a word is.
  # 
  # @see IWordDetector
  class WordRule 
    include_class_members WordRuleImports
    include IRule
    
    class_module.module_eval {
      # Internal setting for the un-initialized column constraint.
      const_set_lazy(:UNDEFINED) { -1 }
      const_attr_reader  :UNDEFINED
    }
    
    # The word detector used by this rule.
    attr_accessor :f_detector
    alias_method :attr_f_detector, :f_detector
    undef_method :f_detector
    alias_method :attr_f_detector=, :f_detector=
    undef_method :f_detector=
    
    # The default token to be returned on success and if nothing else has been specified.
    attr_accessor :f_default_token
    alias_method :attr_f_default_token, :f_default_token
    undef_method :f_default_token
    alias_method :attr_f_default_token=, :f_default_token=
    undef_method :f_default_token=
    
    # The column constraint.
    attr_accessor :f_column
    alias_method :attr_f_column, :f_column
    undef_method :f_column
    alias_method :attr_f_column=, :f_column=
    undef_method :f_column=
    
    # The table of predefined words and token for this rule.
    attr_accessor :f_words
    alias_method :attr_f_words, :f_words
    undef_method :f_words
    alias_method :attr_f_words=, :f_words=
    undef_method :f_words=
    
    # Buffer used for pattern detection.
    attr_accessor :f_buffer
    alias_method :attr_f_buffer, :f_buffer
    undef_method :f_buffer
    alias_method :attr_f_buffer=, :f_buffer=
    undef_method :f_buffer=
    
    # Tells whether this rule is case sensitive.
    # @since 3.3
    attr_accessor :f_ignore_case
    alias_method :attr_f_ignore_case, :f_ignore_case
    undef_method :f_ignore_case
    alias_method :attr_f_ignore_case=, :f_ignore_case=
    undef_method :f_ignore_case=
    
    typesig { [IWordDetector] }
    # Creates a rule which, with the help of an word detector, will return the token
    # associated with the detected word. If no token has been associated, the scanner
    # will be rolled back and an undefined token will be returned in order to allow
    # any subsequent rules to analyze the characters.
    # 
    # @param detector the word detector to be used by this rule, may not be <code>null</code>
    # @see #addWord(String, IToken)
    def initialize(detector)
      initialize__word_rule(detector, Token::UNDEFINED, false)
    end
    
    typesig { [IWordDetector, IToken] }
    # Creates a rule which, with the help of a word detector, will return the token
    # associated with the detected word. If no token has been associated, the
    # specified default token will be returned.
    # 
    # @param detector the word detector to be used by this rule, may not be <code>null</code>
    # @param defaultToken the default token to be returned on success
    # if nothing else is specified, may not be <code>null</code>
    # @see #addWord(String, IToken)
    def initialize(detector, default_token)
      initialize__word_rule(detector, default_token, false)
    end
    
    typesig { [IWordDetector, IToken, ::Java::Boolean] }
    # Creates a rule which, with the help of a word detector, will return the token
    # associated with the detected word. If no token has been associated, the
    # specified default token will be returned.
    # 
    # @param detector the word detector to be used by this rule, may not be <code>null</code>
    # @param defaultToken the default token to be returned on success
    # if nothing else is specified, may not be <code>null</code>
    # @param ignoreCase the case sensitivity associated with this rule
    # @see #addWord(String, IToken)
    # @since 3.3
    def initialize(detector, default_token, ignore_case)
      @f_detector = nil
      @f_default_token = nil
      @f_column = UNDEFINED
      @f_words = HashMap.new
      @f_buffer = StringBuffer.new
      @f_ignore_case = false
      Assert.is_not_null(detector)
      Assert.is_not_null(default_token)
      @f_detector = detector
      @f_default_token = default_token
      @f_ignore_case = ignore_case
    end
    
    typesig { [String, IToken] }
    # Adds a word and the token to be returned if it is detected.
    # 
    # @param word the word this rule will search for, may not be <code>null</code>
    # @param token the token to be returned if the word has been found, may not be <code>null</code>
    def add_word(word, token)
      Assert.is_not_null(word)
      Assert.is_not_null(token)
      @f_words.put(word, token)
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
    # @see IRule#evaluate(ICharacterScanner)
    def evaluate(scanner)
      c = scanner.read
      if (!(c).equal?(ICharacterScanner::EOF) && @f_detector.is_word_start(RJava.cast_to_char(c)))
        if ((@f_column).equal?(UNDEFINED) || ((@f_column).equal?(scanner.get_column - 1)))
          @f_buffer.set_length(0)
          begin
            @f_buffer.append(RJava.cast_to_char(c))
            c = scanner.read
          end while (!(c).equal?(ICharacterScanner::EOF) && @f_detector.is_word_part(RJava.cast_to_char(c)))
          scanner.unread
          buffer = @f_buffer.to_s
          token = @f_words.get(buffer)
          if ((token).nil? && @f_ignore_case)
            iter = @f_words.key_set.iterator
            while (iter.has_next)
              key = iter.next_
              if (buffer.equals_ignore_case(key))
                token = @f_words.get(key)
                break
              end
            end
          end
          if (!(token).nil?)
            return token
          end
          if (@f_default_token.is_undefined)
            unread_buffer(scanner)
          end
          return @f_default_token
        end
      end
      scanner.unread
      return Token::UNDEFINED
    end
    
    typesig { [ICharacterScanner] }
    # Returns the characters in the buffer to the scanner.
    # 
    # @param scanner the scanner to be used
    def unread_buffer(scanner)
      i = @f_buffer.length - 1
      while i >= 0
        scanner.unread
        i -= 1
      end
    end
    
    private
    alias_method :initialize__word_rule, :initialize
  end
  
end
