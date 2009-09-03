require "rjava"

# Copyright (c) 2000, 2009 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
# Tom Eicher (Avaloq Evolution AG) - block selection mode
module Org::Eclipse::Jface::Text
  module TextSelectionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Core::Runtime, :Platform
    }
  end
  
  # Standard implementation of {@link org.eclipse.jface.text.ITextSelection}.
  # <p>
  # Takes advantage of the weak contract of correctness of its interface. If
  # generated from a selection provider, it only remembers its offset and length
  # and computes the remaining information on request.</p>
  class TextSelection 
    include_class_members TextSelectionImports
    include ITextSelection
    
    class_module.module_eval {
      # Debug option for asserting valid offset and length.
      # 
      # @since 3.5
      const_set_lazy(:ASSERT_INVLID_SELECTION_NULL) { "true".equals_ignore_case(Platform.get_debug_option("org.eclipse.jface.text/assert/TextSelection/validConstructorArguments")) }
      const_attr_reader  :ASSERT_INVLID_SELECTION_NULL
      
      # $NON-NLS-1$ //$NON-NLS-2$
      # Internal empty text selection
      const_set_lazy(:NULL) { TextSelection.new }
      const_attr_reader  :NULL
      
      typesig { [] }
      # Returns the shared instance of the empty text selection.
      # 
      # @return the shared instance of an empty text selection
      def empty_selection
        return NULL
      end
    }
    
    # Document which delivers the data of the selection, possibly <code>null</code>.
    attr_accessor :f_document
    alias_method :attr_f_document, :f_document
    undef_method :f_document
    alias_method :attr_f_document=, :f_document=
    undef_method :f_document=
    
    # Offset of the selection
    attr_accessor :f_offset
    alias_method :attr_f_offset, :f_offset
    undef_method :f_offset
    alias_method :attr_f_offset=, :f_offset=
    undef_method :f_offset=
    
    # Length of the selection
    attr_accessor :f_length
    alias_method :attr_f_length, :f_length
    undef_method :f_length
    alias_method :attr_f_length=, :f_length=
    undef_method :f_length=
    
    typesig { [] }
    # Creates an empty text selection.
    def initialize
      @f_document = nil
      @f_offset = 0
      @f_length = 0
      @f_offset = -1
      @f_length = -1
      @f_document = nil
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Creates a text selection for the given range. This
    # selection object describes generically a text range and
    # is intended to be an argument for the <code>setSelection</code>
    # method of selection providers.
    # 
    # @param offset the offset of the range, must not be negative
    # @param length the length of the range, must not be negative
    def initialize(offset, length)
      initialize__text_selection(nil, offset, length)
    end
    
    typesig { [IDocument, ::Java::Int, ::Java::Int] }
    # Creates a text selection for the given range of the given document.
    # This selection object is created by selection providers in responds
    # <code>getSelection</code>.
    # 
    # @param document the document whose text range is selected in a viewer
    # @param offset the offset of the selected range, must not be negative
    # @param length the length of the selected range, must not be negative
    def initialize(document, offset, length)
      @f_document = nil
      @f_offset = 0
      @f_length = 0
      if (ASSERT_INVLID_SELECTION_NULL)
        Assert.is_legal(offset >= 0)
        Assert.is_legal(length >= 0)
      end
      @f_document = document
      @f_offset = offset
      @f_length = length
    end
    
    typesig { [] }
    # Tells whether this text selection is the empty selection.
    # <p>
    # A selection of length 0 is not an empty text selection as it
    # describes, e.g., the cursor position in a viewer.</p>
    # 
    # @return <code>true</code> if this selection is empty
    # @see #emptySelection()
    def is_empty
      # backwards compatibility:
      return (self).equal?(NULL) || @f_offset < 0 || @f_length < 0
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.ITextSelection#getOffset()
    def get_offset
      return @f_offset
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.ITextSelection#getLength()
    def get_length
      return @f_length
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.ITextSelection#getStartLine()
    def get_start_line
      begin
        if (!(@f_document).nil?)
          return @f_document.get_line_of_offset(@f_offset)
        end
      rescue BadLocationException => x
      end
      return -1
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.ITextSelection#getEndLine()
    def get_end_line
      begin
        if (!(@f_document).nil?)
          end_offset = @f_offset + @f_length
          if (!(@f_length).equal?(0))
            end_offset -= 1
          end
          return @f_document.get_line_of_offset(end_offset)
        end
      rescue BadLocationException => x
      end
      return -1
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.ITextSelection#getText()
    def get_text
      begin
        if (!(@f_document).nil?)
          return @f_document.get(@f_offset, @f_length)
        end
      rescue BadLocationException => x
      end
      return nil
    end
    
    typesig { [Object] }
    # @see java.lang.Object#equals(Object)
    def ==(obj)
      if ((obj).equal?(self))
        return true
      end
      if ((obj).nil? || !(get_class).equal?(obj.get_class))
        return false
      end
      s = obj
      same_range = ((s.attr_f_offset).equal?(@f_offset) && (s.attr_f_length).equal?(@f_length))
      if (same_range)
        if ((s.attr_f_document).nil? && (@f_document).nil?)
          return true
        end
        if ((s.attr_f_document).nil? || (@f_document).nil?)
          return false
        end
        begin
          s_content = s.attr_f_document.get(@f_offset, @f_length)
          content = @f_document.get(@f_offset, @f_length)
          return (s_content == content)
        rescue BadLocationException => x
        end
      end
      return false
    end
    
    typesig { [] }
    # @see java.lang.Object#hashCode()
    def hash_code
      low = !(@f_document).nil? ? @f_document.hash_code : 0
      return (@f_offset << 24) | (@f_length << 16) | low
    end
    
    typesig { [] }
    # Returns the document underlying the receiver, possibly <code>null</code>.
    # 
    # @return the document underlying the receiver, possibly <code>null</code>
    # @since 3.5
    def get_document
      return @f_document
    end
    
    private
    alias_method :initialize__text_selection, :initialize
  end
  
end
