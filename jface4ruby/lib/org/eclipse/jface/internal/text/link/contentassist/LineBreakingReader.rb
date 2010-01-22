require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Internal::Text::Link::Contentassist
  module LineBreakingReaderImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Internal::Text::Link::Contentassist
      include_const ::Java::Io, :BufferedReader
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :Reader
      include_const ::Com::Ibm::Icu::Text, :BreakIterator
      include_const ::Org::Eclipse::Swt::Graphics, :SwtGC
    }
  end
  
  # Not a real reader. Could change if requested
  class LineBreakingReader 
    include_class_members LineBreakingReaderImports
    
    attr_accessor :f_reader
    alias_method :attr_f_reader, :f_reader
    undef_method :f_reader
    alias_method :attr_f_reader=, :f_reader=
    undef_method :f_reader=
    
    attr_accessor :f_gc
    alias_method :attr_f_gc, :f_gc
    undef_method :f_gc
    alias_method :attr_f_gc=, :f_gc=
    undef_method :f_gc=
    
    attr_accessor :f_max_width
    alias_method :attr_f_max_width, :f_max_width
    undef_method :f_max_width
    alias_method :attr_f_max_width=, :f_max_width=
    undef_method :f_max_width=
    
    attr_accessor :f_line
    alias_method :attr_f_line, :f_line
    undef_method :f_line
    alias_method :attr_f_line=, :f_line=
    undef_method :f_line=
    
    attr_accessor :f_offset
    alias_method :attr_f_offset, :f_offset
    undef_method :f_offset
    alias_method :attr_f_offset=, :f_offset=
    undef_method :f_offset=
    
    attr_accessor :f_line_break_iterator
    alias_method :attr_f_line_break_iterator, :f_line_break_iterator
    undef_method :f_line_break_iterator
    alias_method :attr_f_line_break_iterator=, :f_line_break_iterator=
    undef_method :f_line_break_iterator=
    
    attr_accessor :f_break_words
    alias_method :attr_f_break_words, :f_break_words
    undef_method :f_break_words
    alias_method :attr_f_break_words=, :f_break_words=
    undef_method :f_break_words=
    
    typesig { [Reader, SwtGC, ::Java::Int] }
    # Creates a reader that breaks an input text to fit in a given width.
    # 
    # @param reader Reader of the input text
    # @param gc The graphic context that defines the currently used font sizes
    # @param maxLineWidth The max width (pixels) where the text has to fit in
    def initialize(reader, gc, max_line_width)
      @f_reader = nil
      @f_gc = nil
      @f_max_width = 0
      @f_line = nil
      @f_offset = 0
      @f_line_break_iterator = nil
      @f_break_words = false
      @f_reader = BufferedReader.new(reader)
      @f_gc = gc
      @f_max_width = max_line_width
      @f_offset = 0
      @f_line = RJava.cast_to_string(nil)
      @f_line_break_iterator = BreakIterator.get_line_instance
      @f_break_words = true
    end
    
    typesig { [] }
    def is_formatted_line
      return !(@f_line).nil?
    end
    
    typesig { [] }
    # Reads the next line. The lengths of the line will not exceed the given maximum width.
    # 
    # @return the next line
    # @throws IOException if an I/O error occurs
    def read_line
      if ((@f_line).nil?)
        line = @f_reader.read_line
        if ((line).nil?)
          return nil
        end
        line_len = @f_gc.text_extent(line).attr_x
        if (line_len < @f_max_width)
          return line
        end
        @f_line = line
        @f_line_break_iterator.set_text(line)
        @f_offset = 0
      end
      break_offset = find_next_break_offset(@f_offset)
      res = nil
      if (!(break_offset).equal?(BreakIterator::DONE))
        res = RJava.cast_to_string(@f_line.substring(@f_offset, break_offset))
        @f_offset = find_word_begin(break_offset)
        if ((@f_offset).equal?(@f_line.length))
          @f_line = RJava.cast_to_string(nil)
        end
      else
        res = RJava.cast_to_string(@f_line.substring(@f_offset))
        @f_line = RJava.cast_to_string(nil)
      end
      return res
    end
    
    typesig { [::Java::Int] }
    def find_next_break_offset(curr_offset)
      curr_width = 0
      next_offset = @f_line_break_iterator.following(curr_offset)
      while (!(next_offset).equal?(BreakIterator::DONE))
        word = @f_line.substring(curr_offset, next_offset)
        word_width = @f_gc.text_extent(word).attr_x
        next_width = word_width + curr_width
        if (next_width > @f_max_width)
          if (curr_width > 0)
            return curr_offset
          end
          if (!@f_break_words)
            return next_offset
          end
          # need to fit into fMaxWidth
          length_ = word.length
          while (length_ >= 0)
            length_ -= 1
            word = RJava.cast_to_string(word.substring(0, length_))
            word_width = @f_gc.text_extent(word).attr_x
            if (word_width + curr_width < @f_max_width)
              return curr_offset + length_
            end
          end
          return next_offset
        end
        curr_width = next_width
        curr_offset = next_offset
        next_offset = @f_line_break_iterator.next_
      end
      return next_offset
    end
    
    typesig { [::Java::Int] }
    def find_word_begin(idx)
      while (idx < @f_line.length && Character.is_whitespace(@f_line.char_at(idx)))
        idx += 1
      end
      return idx
    end
    
    private
    alias_method :initialize__line_breaking_reader, :initialize
  end
  
end
