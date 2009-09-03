require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text
  module DefaultTextDoubleClickStrategyImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
      include_const ::Java::Text, :CharacterIterator
      include_const ::Com::Ibm::Icu::Text, :BreakIterator
    }
  end
  
  # Standard implementation of
  # {@link org.eclipse.jface.text.ITextDoubleClickStrategy}.
  # <p>
  # Selects words using <code>java.text.BreakIterator</code> for the default
  # locale.</p>
  # 
  # @see java.text.BreakIterator
  class DefaultTextDoubleClickStrategy 
    include_class_members DefaultTextDoubleClickStrategyImports
    include ITextDoubleClickStrategy
    
    class_module.module_eval {
      # Implements a character iterator that works directly on
      # instances of <code>IDocument</code>. Used to collaborate with
      # the break iterator.
      # 
      # @see IDocument
      # @since 2.0
      const_set_lazy(:DocumentCharacterIterator) { Class.new do
        include_class_members DefaultTextDoubleClickStrategy
        include CharacterIterator
        
        # Document to iterate over.
        attr_accessor :f_document
        alias_method :attr_f_document, :f_document
        undef_method :f_document
        alias_method :attr_f_document=, :f_document=
        undef_method :f_document=
        
        # Start offset of iteration.
        attr_accessor :f_offset
        alias_method :attr_f_offset, :f_offset
        undef_method :f_offset
        alias_method :attr_f_offset=, :f_offset=
        undef_method :f_offset=
        
        # End offset of iteration.
        attr_accessor :f_end_offset
        alias_method :attr_f_end_offset, :f_end_offset
        undef_method :f_end_offset
        alias_method :attr_f_end_offset=, :f_end_offset=
        undef_method :f_end_offset=
        
        # Current offset of iteration.
        attr_accessor :f_index
        alias_method :attr_f_index, :f_index
        undef_method :f_index
        alias_method :attr_f_index=, :f_index=
        undef_method :f_index=
        
        typesig { [] }
        # Creates a new document iterator.
        def initialize
          @f_document = nil
          @f_offset = -1
          @f_end_offset = -1
          @f_index = -1
        end
        
        typesig { [class_self::IDocument, class_self::IRegion] }
        # Configures this document iterator with the document section to be visited.
        # 
        # @param document the document to be iterated
        # @param iteratorRange the range in the document to be iterated
        def set_document(document, iterator_range)
          @f_document = document
          @f_offset = iterator_range.get_offset
          @f_end_offset = @f_offset + iterator_range.get_length
        end
        
        typesig { [] }
        # @see CharacterIterator#first()
        def first
          @f_index = @f_offset
          return current
        end
        
        typesig { [] }
        # @see CharacterIterator#last()
        def last
          @f_index = @f_offset < @f_end_offset ? @f_end_offset - 1 : @f_end_offset
          return current
        end
        
        typesig { [] }
        # @see CharacterIterator#current()
        def current
          if (@f_offset <= @f_index && @f_index < @f_end_offset)
            begin
              return @f_document.get_char(@f_index)
            rescue self.class::BadLocationException => x
            end
          end
          return DONE
        end
        
        typesig { [] }
        # @see CharacterIterator#next()
        def next_
          (@f_index += 1)
          end_ = get_end_index
          if (@f_index >= end_)
            @f_index = end_
            return DONE
          end
          return current
        end
        
        typesig { [] }
        # @see CharacterIterator#previous()
        def previous
          if ((@f_index).equal?(@f_offset))
            return DONE
          end
          if (@f_index > @f_offset)
            (@f_index -= 1)
          end
          return current
        end
        
        typesig { [::Java::Int] }
        # @see CharacterIterator#setIndex(int)
        def set_index(index)
          @f_index = index
          return current
        end
        
        typesig { [] }
        # @see CharacterIterator#getBeginIndex()
        def get_begin_index
          return @f_offset
        end
        
        typesig { [] }
        # @see CharacterIterator#getEndIndex()
        def get_end_index
          return @f_end_offset
        end
        
        typesig { [] }
        # @see CharacterIterator#getIndex()
        def get_index
          return @f_index
        end
        
        typesig { [] }
        # @see CharacterIterator#clone()
        def clone
          i = self.class::DocumentCharacterIterator.new
          i.attr_f_document = @f_document
          i.attr_f_index = @f_index
          i.attr_f_offset = @f_offset
          i.attr_f_end_offset = @f_end_offset
          return i
        end
        
        private
        alias_method :initialize__document_character_iterator, :initialize
      end }
    }
    
    # The document character iterator used by this strategy.
    # @since 2.0
    attr_accessor :f_doc_iter
    alias_method :attr_f_doc_iter, :f_doc_iter
    undef_method :f_doc_iter
    alias_method :attr_f_doc_iter=, :f_doc_iter=
    undef_method :f_doc_iter=
    
    typesig { [] }
    # Creates a new default text double click strategy.
    def initialize
      @f_doc_iter = DocumentCharacterIterator.new
    end
    
    typesig { [ITextViewer] }
    # @see org.eclipse.jface.text.ITextDoubleClickStrategy#doubleClicked(org.eclipse.jface.text.ITextViewer)
    def double_clicked(text)
      offset = text.get_selected_range.attr_x
      if (offset < 0)
        return
      end
      document = text.get_document
      region = find_extended_double_click_selection(document, offset)
      if ((region).nil?)
        region = find_word(document, offset)
      end
      if (!(region).nil?)
        text.set_selected_range(region.get_offset, region.get_length)
      end
    end
    
    typesig { [IDocument, ::Java::Int] }
    # Tries to find a suitable double click selection for the given offset.
    # <p>
    # <strong>Note:</> This method must return <code>null</code> if it simply selects the word at
    # the given offset.
    # </p>
    # 
    # @param document the document
    # @param offset the offset
    # @return the selection or <code>null</code> if none to indicate simple word selection
    # @since 3.5
    def find_extended_double_click_selection(document, offset)
      return nil
    end
    
    typesig { [IDocument, ::Java::Int] }
    # Tries to find the word at the given offset.
    # 
    # @param document the document
    # @param offset the offset
    # @return the word or <code>null</code> if none
    # @since 3.5
    def find_word(document, offset)
      line = nil
      begin
        line = document.get_line_information_of_offset(offset)
      rescue BadLocationException => e
        return nil
      end
      if ((offset).equal?(line.get_offset + line.get_length))
        return nil
      end
      @f_doc_iter.set_document(document, line)
      break_iter = BreakIterator.get_word_instance
      break_iter.set_text(@f_doc_iter)
      start = break_iter.preceding(offset)
      if ((start).equal?(BreakIterator::DONE))
        start = line.get_offset
      end
      end_ = break_iter.following(offset)
      if ((end_).equal?(BreakIterator::DONE))
        end_ = line.get_offset + line.get_length
      end
      if (break_iter.is_boundary(offset))
        if (end_ - offset > offset - start)
          start = offset
        else
          end_ = offset
        end
      end
      if ((end_).equal?(start))
        return nil
      end
      return Region.new(start, end_ - start)
    end
    
    private
    alias_method :initialize__default_text_double_click_strategy, :initialize
  end
  
end
