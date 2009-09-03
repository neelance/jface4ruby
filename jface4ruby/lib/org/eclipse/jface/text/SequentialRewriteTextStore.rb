require "rjava"

# Copyright (c) 2000, 2007 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text
  module SequentialRewriteTextStoreImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :LinkedList
    }
  end
  
  # A text store that optimizes a given source text store for sequential rewriting.
  # While rewritten it keeps a list of replace command that serve as patches for
  # the source store. Only on request, the source store is indeed manipulated
  # by applying the patch commands to the source text store.
  # 
  # @since 2.0
  # @deprecated since 3.3 as {@link GapTextStore} performs better even for sequential rewrite scenarios
  class SequentialRewriteTextStore 
    include_class_members SequentialRewriteTextStoreImports
    include ITextStore
    
    class_module.module_eval {
      # A buffered replace command.
      const_set_lazy(:Replace) { Class.new do
        include_class_members SequentialRewriteTextStore
        
        attr_accessor :new_offset
        alias_method :attr_new_offset, :new_offset
        undef_method :new_offset
        alias_method :attr_new_offset=, :new_offset=
        undef_method :new_offset=
        
        attr_accessor :offset
        alias_method :attr_offset, :offset
        undef_method :offset
        alias_method :attr_offset=, :offset=
        undef_method :offset=
        
        attr_accessor :length
        alias_method :attr_length, :length
        undef_method :length
        alias_method :attr_length=, :length=
        undef_method :length=
        
        attr_accessor :text
        alias_method :attr_text, :text
        undef_method :text
        alias_method :attr_text=, :text=
        undef_method :text=
        
        typesig { [::Java::Int, ::Java::Int, ::Java::Int, String] }
        def initialize(offset, new_offset, length, text)
          @new_offset = 0
          @offset = 0
          @length = 0
          @text = nil
          @new_offset = new_offset
          @offset = offset
          @length = length
          @text = text
        end
        
        private
        alias_method :initialize__replace, :initialize
      end }
    }
    
    # The list of buffered replacements.
    attr_accessor :f_replace_list
    alias_method :attr_f_replace_list, :f_replace_list
    undef_method :f_replace_list
    alias_method :attr_f_replace_list=, :f_replace_list=
    undef_method :f_replace_list=
    
    # The source text store
    attr_accessor :f_source
    alias_method :attr_f_source, :f_source
    undef_method :f_source
    alias_method :attr_f_source=, :f_source=
    undef_method :f_source=
    
    class_module.module_eval {
      # A flag to enforce sequential access.
      const_set_lazy(:ASSERT_SEQUENTIALITY) { false }
      const_attr_reader  :ASSERT_SEQUENTIALITY
    }
    
    typesig { [ITextStore] }
    # Creates a new sequential rewrite store for the given source store.
    # 
    # @param source the source text store
    def initialize(source)
      @f_replace_list = nil
      @f_source = nil
      @f_replace_list = LinkedList.new
      @f_source = source
    end
    
    typesig { [] }
    # Returns the source store of this rewrite store.
    # 
    # @return  the source store of this rewrite store
    def get_source_store
      commit
      return @f_source
    end
    
    typesig { [::Java::Int, ::Java::Int, String] }
    # @see org.eclipse.jface.text.ITextStore#replace(int, int, java.lang.String)
    def replace(offset, length, text)
      if ((text).nil?)
        text = ""
      end # $NON-NLS-1$
      if ((@f_replace_list.size).equal?(0))
        @f_replace_list.add(Replace.new(offset, offset, length, text))
      else
        first_replace = @f_replace_list.get_first
        last_replace = @f_replace_list.get_last
        # backward
        if (offset + length <= first_replace.attr_new_offset)
          delta = text.length - length
          if (!(delta).equal?(0))
            i = @f_replace_list.iterator
            while i.has_next
              replace = i.next_
              replace.attr_new_offset += delta
            end
          end
          @f_replace_list.add_first(Replace.new(offset, offset, length, text))
          # forward
        else
          if (offset >= last_replace.attr_new_offset + last_replace.attr_text.length)
            delta = get_delta(last_replace)
            @f_replace_list.add(Replace.new(offset - delta, offset, length, text))
          else
            if (ASSERT_SEQUENTIALITY)
              raise IllegalArgumentException.new
            else
              commit
              @f_source.replace(offset, length, text)
            end
          end
        end
      end
    end
    
    typesig { [String] }
    # @see org.eclipse.jface.text.ITextStore#set(java.lang.String)
    def set(text)
      @f_source.set(text)
      @f_replace_list.clear
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # @see org.eclipse.jface.text.ITextStore#get(int, int)
    def get(offset, length_)
      if (@f_replace_list.is_empty)
        return @f_source.get(offset, length_)
      end
      first_replace = @f_replace_list.get_first
      last_replace = @f_replace_list.get_last
      # before
      if (offset + length_ <= first_replace.attr_new_offset)
        return @f_source.get(offset, length_)
        # after
      else
        if (offset >= last_replace.attr_new_offset + last_replace.attr_text.length)
          delta = get_delta(last_replace)
          return @f_source.get(offset - delta, length_)
        else
          if (ASSERT_SEQUENTIALITY)
            raise IllegalArgumentException.new
          else
            delta = 0
            i = @f_replace_list.iterator
            while i.has_next
              replace_ = i.next_
              if (offset + length_ < replace_.attr_new_offset)
                return @f_source.get(offset - delta, length_)
              else
                if (offset >= replace_.attr_new_offset && offset + length_ <= replace_.attr_new_offset + replace_.attr_text.length)
                  return replace_.attr_text.substring(offset - replace_.attr_new_offset, offset - replace_.attr_new_offset + length_)
                else
                  if (offset >= replace_.attr_new_offset + replace_.attr_text.length)
                    delta = get_delta(replace_)
                    next
                  else
                    commit
                    return @f_source.get(offset, length_)
                  end
                end
              end
            end
            return @f_source.get(offset - delta, length_)
          end
        end
      end
    end
    
    class_module.module_eval {
      typesig { [Replace] }
      # Returns the difference between the offset in the source store and the "same" offset in the
      # rewrite store after the replace operation.
      # 
      # @param replace the replace command
      # @return the difference
      def get_delta(replace_)
        return replace_.attr_new_offset - replace_.attr_offset + replace_.attr_text.length - replace_.attr_length
      end
    }
    
    typesig { [::Java::Int] }
    # @see org.eclipse.jface.text.ITextStore#get(int)
    def get(offset)
      if (@f_replace_list.is_empty)
        return @f_source.get(offset)
      end
      first_replace = @f_replace_list.get_first
      last_replace = @f_replace_list.get_last
      # before
      if (offset < first_replace.attr_new_offset)
        return @f_source.get(offset)
        # after
      else
        if (offset >= last_replace.attr_new_offset + last_replace.attr_text.length)
          delta = get_delta(last_replace)
          return @f_source.get(offset - delta)
        else
          if (ASSERT_SEQUENTIALITY)
            raise IllegalArgumentException.new
          else
            delta = 0
            i = @f_replace_list.iterator
            while i.has_next
              replace_ = i.next_
              if (offset < replace_.attr_new_offset)
                return @f_source.get(offset - delta)
              else
                if (offset < replace_.attr_new_offset + replace_.attr_text.length)
                  return replace_.attr_text.char_at(offset - replace_.attr_new_offset)
                end
              end
              delta = get_delta(replace_)
            end
            return @f_source.get(offset - delta)
          end
        end
      end
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.ITextStore#getLength()
    def get_length
      if (@f_replace_list.is_empty)
        return @f_source.get_length
      end
      last_replace = @f_replace_list.get_last
      return @f_source.get_length + get_delta(last_replace)
    end
    
    typesig { [] }
    # Disposes this rewrite store.
    def dispose
      @f_replace_list = nil
      @f_source = nil
    end
    
    typesig { [] }
    # Commits all buffered replace commands.
    def commit
      if (@f_replace_list.is_empty)
        return
      end
      buffer = StringBuffer.new
      delta = 0
      i = @f_replace_list.iterator
      while i.has_next
        replace_ = i.next_
        offset = buffer.length - delta
        buffer.append(@f_source.get(offset, replace_.attr_offset - offset))
        buffer.append(replace_.attr_text)
        delta = get_delta(replace_)
      end
      offset = buffer.length - delta
      buffer.append(@f_source.get(offset, @f_source.get_length - offset))
      @f_source.set(buffer.to_s)
      @f_replace_list.clear
    end
    
    private
    alias_method :initialize__sequential_rewrite_text_store, :initialize
  end
  
end
