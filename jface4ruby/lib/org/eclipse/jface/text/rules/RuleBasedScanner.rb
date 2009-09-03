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
  module RuleBasedScannerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Rules
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Jface::Text, :BadLocationException
      include_const ::Org::Eclipse::Jface::Text, :IDocument
    }
  end
  
  # A generic scanner which can be "programmed" with a sequence of rules.
  # The scanner is used to get the next token by evaluating its rule in sequence until
  # one is successful. If a rule returns a token which is undefined, the scanner will proceed to
  # the next rule. Otherwise the token provided by the rule will be returned by
  # the scanner. If no rule returned a defined token, this scanner returns a token
  # which returns <code>true</code> when calling <code>isOther</code>, unless the end
  # of the file is reached. In this case the token returns <code>true</code> when calling
  # <code>isEOF</code>.
  # 
  # @see IRule
  class RuleBasedScanner 
    include_class_members RuleBasedScannerImports
    include ICharacterScanner
    include ITokenScanner
    
    # The list of rules of this scanner
    attr_accessor :f_rules
    alias_method :attr_f_rules, :f_rules
    undef_method :f_rules
    alias_method :attr_f_rules=, :f_rules=
    undef_method :f_rules=
    
    # The token to be returned by default if no rule fires
    attr_accessor :f_default_return_token
    alias_method :attr_f_default_return_token, :f_default_return_token
    undef_method :f_default_return_token
    alias_method :attr_f_default_return_token=, :f_default_return_token=
    undef_method :f_default_return_token=
    
    # The document to be scanned
    attr_accessor :f_document
    alias_method :attr_f_document, :f_document
    undef_method :f_document
    alias_method :attr_f_document=, :f_document=
    undef_method :f_document=
    
    # The cached legal line delimiters of the document
    attr_accessor :f_delimiters
    alias_method :attr_f_delimiters, :f_delimiters
    undef_method :f_delimiters
    alias_method :attr_f_delimiters=, :f_delimiters=
    undef_method :f_delimiters=
    
    # The offset of the next character to be read
    attr_accessor :f_offset
    alias_method :attr_f_offset, :f_offset
    undef_method :f_offset
    alias_method :attr_f_offset=, :f_offset=
    undef_method :f_offset=
    
    # The end offset of the range to be scanned
    attr_accessor :f_range_end
    alias_method :attr_f_range_end, :f_range_end
    undef_method :f_range_end
    alias_method :attr_f_range_end=, :f_range_end=
    undef_method :f_range_end=
    
    # The offset of the last read token
    attr_accessor :f_token_offset
    alias_method :attr_f_token_offset, :f_token_offset
    undef_method :f_token_offset
    alias_method :attr_f_token_offset=, :f_token_offset=
    undef_method :f_token_offset=
    
    # The cached column of the current scanner position
    attr_accessor :f_column
    alias_method :attr_f_column, :f_column
    undef_method :f_column
    alias_method :attr_f_column=, :f_column=
    undef_method :f_column=
    
    class_module.module_eval {
      # Internal setting for the un-initialized column cache.
      const_set_lazy(:UNDEFINED) { -1 }
      const_attr_reader  :UNDEFINED
    }
    
    typesig { [] }
    # Creates a new rule based scanner which does not have any rule.
    def initialize
      @f_rules = nil
      @f_default_return_token = nil
      @f_document = nil
      @f_delimiters = nil
      @f_offset = 0
      @f_range_end = 0
      @f_token_offset = 0
      @f_column = 0
    end
    
    typesig { [Array.typed(IRule)] }
    # Configures the scanner with the given sequence of rules.
    # 
    # @param rules the sequence of rules controlling this scanner
    def set_rules(rules)
      if (!(rules).nil?)
        @f_rules = Array.typed(IRule).new(rules.attr_length) { nil }
        System.arraycopy(rules, 0, @f_rules, 0, rules.attr_length)
      else
        @f_rules = nil
      end
    end
    
    typesig { [IToken] }
    # Configures the scanner's default return token. This is the token
    # which is returned when none of the rules fired and EOF has not been
    # reached.
    # 
    # @param defaultReturnToken the default return token
    # @since 2.0
    def set_default_return_token(default_return_token)
      Assert.is_not_null(default_return_token.get_data)
      @f_default_return_token = default_return_token
    end
    
    typesig { [IDocument, ::Java::Int, ::Java::Int] }
    # @see ITokenScanner#setRange(IDocument, int, int)
    def set_range(document, offset, length)
      Assert.is_legal(!(document).nil?)
      document_length = document.get_length
      check_range(offset, length, document_length)
      @f_document = document
      @f_offset = offset
      @f_column = UNDEFINED
      @f_range_end = offset + length
      delimiters = @f_document.get_legal_line_delimiters
      @f_delimiters = Array.typed(Array.typed(::Java::Char)).new(delimiters.attr_length) { nil }
      i = 0
      while i < delimiters.attr_length
        @f_delimiters[i] = delimiters[i].to_char_array
        i += 1
      end
      if ((@f_default_return_token).nil?)
        @f_default_return_token = Token.new(nil)
      end
    end
    
    typesig { [::Java::Int, ::Java::Int, ::Java::Int] }
    # Checks that the given range is valid.
    # See https://bugs.eclipse.org/bugs/show_bug.cgi?id=69292
    # 
    # @param offset the offset of the document range to scan
    # @param length the length of the document range to scan
    # @param documentLength the document's length
    # @since 3.3
    def check_range(offset, length, document_length)
      Assert.is_legal(offset > -1)
      Assert.is_legal(length > -1)
      Assert.is_legal(offset + length <= document_length)
    end
    
    typesig { [] }
    # @see ITokenScanner#getTokenOffset()
    def get_token_offset
      return @f_token_offset
    end
    
    typesig { [] }
    # @see ITokenScanner#getTokenLength()
    def get_token_length
      if (@f_offset < @f_range_end)
        return @f_offset - get_token_offset
      end
      return @f_range_end - get_token_offset
    end
    
    typesig { [] }
    # @see ICharacterScanner#getColumn()
    def get_column
      if ((@f_column).equal?(UNDEFINED))
        begin
          line = @f_document.get_line_of_offset(@f_offset)
          start = @f_document.get_line_offset(line)
          @f_column = @f_offset - start
        rescue BadLocationException => ex
        end
      end
      return @f_column
    end
    
    typesig { [] }
    # @see ICharacterScanner#getLegalLineDelimiters()
    def get_legal_line_delimiters
      return @f_delimiters
    end
    
    typesig { [] }
    # @see ITokenScanner#nextToken()
    def next_token
      @f_token_offset = @f_offset
      @f_column = UNDEFINED
      if (!(@f_rules).nil?)
        i = 0
        while i < @f_rules.attr_length
          token = (@f_rules[i].evaluate(self))
          if (!token.is_undefined)
            return token
          end
          i += 1
        end
      end
      if ((read).equal?(EOF))
        return Token::EOF
      end
      return @f_default_return_token
    end
    
    typesig { [] }
    # @see ICharacterScanner#read()
    def read
      begin
        if (@f_offset < @f_range_end)
          begin
            return @f_document.get_char(@f_offset)
          rescue BadLocationException => e
          end
        end
        return EOF
      ensure
        (@f_offset += 1)
        @f_column = UNDEFINED
      end
    end
    
    typesig { [] }
    # @see ICharacterScanner#unread()
    def unread
      (@f_offset -= 1)
      @f_column = UNDEFINED
    end
    
    private
    alias_method :initialize__rule_based_scanner, :initialize
  end
  
end
