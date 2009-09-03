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
  module BufferedRuleBasedScannerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Rules
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Jface::Text, :BadLocationException
      include_const ::Org::Eclipse::Jface::Text, :IDocument
    }
  end
  
  # A buffered rule based scanner. The buffer always contains a section
  # of a fixed size of the document to be scanned. Completely adheres to
  # the contract of <code>RuleBasedScanner</code>.
  class BufferedRuleBasedScanner < BufferedRuleBasedScannerImports.const_get :RuleBasedScanner
    include_class_members BufferedRuleBasedScannerImports
    
    class_module.module_eval {
      # The default buffer size. Value = 500
      const_set_lazy(:DEFAULT_BUFFER_SIZE) { 500 }
      const_attr_reader  :DEFAULT_BUFFER_SIZE
    }
    
    # The actual size of the buffer. Initially set to <code>DEFAULT_BUFFER_SIZE</code>
    attr_accessor :f_buffer_size
    alias_method :attr_f_buffer_size, :f_buffer_size
    undef_method :f_buffer_size
    alias_method :attr_f_buffer_size=, :f_buffer_size=
    undef_method :f_buffer_size=
    
    # The buffer
    attr_accessor :f_buffer
    alias_method :attr_f_buffer, :f_buffer
    undef_method :f_buffer
    alias_method :attr_f_buffer=, :f_buffer=
    undef_method :f_buffer=
    
    # The offset of the document at which the buffer starts
    attr_accessor :f_start
    alias_method :attr_f_start, :f_start
    undef_method :f_start
    alias_method :attr_f_start=, :f_start=
    undef_method :f_start=
    
    # The offset of the document at which the buffer ends
    attr_accessor :f_end
    alias_method :attr_f_end, :f_end
    undef_method :f_end
    alias_method :attr_f_end=, :f_end=
    undef_method :f_end=
    
    # The cached length of the document
    attr_accessor :f_document_length
    alias_method :attr_f_document_length, :f_document_length
    undef_method :f_document_length
    alias_method :attr_f_document_length=, :f_document_length=
    undef_method :f_document_length=
    
    typesig { [] }
    # Creates a new buffered rule based scanner which does
    # not have any rule and a default buffer size of 500 characters.
    def initialize
      @f_buffer_size = 0
      @f_buffer = nil
      @f_start = 0
      @f_end = 0
      @f_document_length = 0
      super()
      @f_buffer_size = DEFAULT_BUFFER_SIZE
      @f_buffer = CharArray.new(DEFAULT_BUFFER_SIZE)
    end
    
    typesig { [::Java::Int] }
    # Creates a new buffered rule based scanner which does
    # not have any rule. The buffer size is set to the given
    # number of characters.
    # 
    # @param size the buffer size
    def initialize(size)
      @f_buffer_size = 0
      @f_buffer = nil
      @f_start = 0
      @f_end = 0
      @f_document_length = 0
      super()
      @f_buffer_size = DEFAULT_BUFFER_SIZE
      @f_buffer = CharArray.new(DEFAULT_BUFFER_SIZE)
      set_buffer_size(size)
    end
    
    typesig { [::Java::Int] }
    # Sets the buffer to the given number of characters.
    # 
    # @param size the buffer size
    def set_buffer_size(size)
      Assert.is_true(size > 0)
      @f_buffer_size = size
      @f_buffer = CharArray.new(size)
    end
    
    typesig { [::Java::Int] }
    # Shifts the buffer so that the buffer starts at the
    # given document offset.
    # 
    # @param offset the document offset at which the buffer starts
    def shift_buffer(offset)
      @f_start = offset
      @f_end = @f_start + @f_buffer_size
      if (@f_end > @f_document_length)
        @f_end = @f_document_length
      end
      begin
        content = self.attr_f_document.get(@f_start, @f_end - @f_start)
        content.get_chars(0, @f_end - @f_start, @f_buffer, 0)
      rescue BadLocationException => x
      end
    end
    
    typesig { [IDocument, ::Java::Int, ::Java::Int] }
    # @see RuleBasedScanner#setRange(IDocument, int, int)
    def set_range(document, offset, length)
      super(document, offset, length)
      @f_document_length = document.get_length
      shift_buffer(offset)
    end
    
    typesig { [] }
    # @see RuleBasedScanner#read()
    def read
      self.attr_f_column = UNDEFINED
      if (self.attr_f_offset >= self.attr_f_range_end)
        (self.attr_f_offset += 1)
        return EOF
      end
      if ((self.attr_f_offset).equal?(@f_end))
        shift_buffer(@f_end)
      else
        if (self.attr_f_offset < @f_start || @f_end < self.attr_f_offset)
          shift_buffer(self.attr_f_offset)
        end
      end
      return @f_buffer[((self.attr_f_offset += 1) - 1) - @f_start]
    end
    
    typesig { [] }
    # @see RuleBasedScanner#unread()
    def unread
      if ((self.attr_f_offset).equal?(@f_start))
        shift_buffer(Math.max(0, @f_start - (@f_buffer_size / 2)))
      end
      (self.attr_f_offset -= 1)
      self.attr_f_column = UNDEFINED
    end
    
    private
    alias_method :initialize__buffered_rule_based_scanner, :initialize
  end
  
end
