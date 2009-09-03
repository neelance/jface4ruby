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
  module ListLineTrackerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :JavaList
      include_const ::Org::Eclipse::Jface::Text::AbstractLineTracker, :DelimiterInfo
    }
  end
  
  # Abstract, read-only implementation of <code>ILineTracker</code>. It lets the definition of
  # line delimiters to subclasses. Assuming that '\n' is the only line delimiter, this abstract
  # implementation defines the following line scheme:
  # <ul>
  # <li> "" -> [0,0]
  # <li> "a" -> [0,1]
  # <li> "\n" -> [0,1], [1,0]
  # <li> "a\n" -> [0,2], [2,0]
  # <li> "a\nb" -> [0,2], [2,1]
  # <li> "a\nbc\n" -> [0,2], [2,3], [5,0]
  # </ul>
  # This class must be subclassed.
  # 
  # @since 3.2
  class ListLineTracker 
    include_class_members ListLineTrackerImports
    include ILineTracker
    
    # The line information
    attr_accessor :f_lines
    alias_method :attr_f_lines, :f_lines
    undef_method :f_lines
    alias_method :attr_f_lines=, :f_lines=
    undef_method :f_lines=
    
    # The length of the tracked text
    attr_accessor :f_text_length
    alias_method :attr_f_text_length, :f_text_length
    undef_method :f_text_length
    alias_method :attr_f_text_length=, :f_text_length=
    undef_method :f_text_length=
    
    typesig { [] }
    # Creates a new line tracker.
    def initialize
      @f_lines = ArrayList.new
      @f_text_length = 0
    end
    
    typesig { [::Java::Int] }
    # Binary search for the line at a given offset.
    # 
    # @param offset the offset whose line should be found
    # @return the line of the offset
    def find_line(offset)
      if ((@f_lines.size).equal?(0))
        return -1
      end
      left = 0
      right = @f_lines.size - 1
      mid = 0
      line = nil
      while (left < right)
        mid = (left + right) / 2
        line = @f_lines.get(mid)
        if (offset < line.attr_offset)
          if ((left).equal?(mid))
            right = left
          else
            right = mid - 1
          end
        else
          if (offset > line.attr_offset)
            if ((right).equal?(mid))
              left = right
            else
              left = mid + 1
            end
          else
            if ((offset).equal?(line.attr_offset))
              left = right = mid
            end
          end
        end
      end
      line = @f_lines.get(left)
      if (line.attr_offset > offset)
        (left -= 1)
      end
      return left
    end
    
    typesig { [::Java::Int, ::Java::Int, ::Java::Int] }
    # Returns the number of lines covered by the specified text range.
    # 
    # @param startLine the line where the text range starts
    # @param offset the start offset of the text range
    # @param length the length of the text range
    # @return the number of lines covered by this text range
    # @exception BadLocationException if range is undefined in this tracker
    def get_number_of_lines(start_line, offset, length)
      if ((length).equal?(0))
        return 1
      end
      target = offset + length
      l = @f_lines.get(start_line)
      if ((l.attr_delimiter).nil?)
        return 1
      end
      if (l.attr_offset + l.attr_length > target)
        return 1
      end
      if ((l.attr_offset + l.attr_length).equal?(target))
        return 2
      end
      return get_line_number_of_offset(target) - start_line + 1
    end
    
    typesig { [::Java::Int] }
    # @see org.eclipse.jface.text.ILineTracker#getLineLength(int)
    def get_line_length(line)
      lines = @f_lines.size
      if (line < 0 || line > lines)
        raise BadLocationException.new
      end
      if ((lines).equal?(0) || (lines).equal?(line))
        return 0
      end
      l = @f_lines.get(line)
      return l.attr_length
    end
    
    typesig { [::Java::Int] }
    # @see org.eclipse.jface.text.ILineTracker#getLineNumberOfOffset(int)
    def get_line_number_of_offset(position)
      if (position < 0 || position > @f_text_length)
        raise BadLocationException.new
      end
      if ((position).equal?(@f_text_length))
        last_line = @f_lines.size - 1
        if (last_line < 0)
          return 0
        end
        l = @f_lines.get(last_line)
        return (!(l.attr_delimiter).nil? ? last_line + 1 : last_line)
      end
      return find_line(position)
    end
    
    typesig { [::Java::Int] }
    # @see org.eclipse.jface.text.ILineTracker#getLineInformationOfOffset(int)
    def get_line_information_of_offset(position)
      if (position > @f_text_length)
        raise BadLocationException.new
      end
      if ((position).equal?(@f_text_length))
        size_ = @f_lines.size
        if ((size_).equal?(0))
          return Region.new(0, 0)
        end
        l = @f_lines.get(size_ - 1)
        return (!(l.attr_delimiter).nil? ? Line.new(@f_text_length, 0) : Line.new(@f_text_length - l.attr_length, l.attr_length))
      end
      return get_line_information(find_line(position))
    end
    
    typesig { [::Java::Int] }
    # @see org.eclipse.jface.text.ILineTracker#getLineInformation(int)
    def get_line_information(line)
      lines = @f_lines.size
      if (line < 0 || line > lines)
        raise BadLocationException.new
      end
      if ((lines).equal?(0))
        return Line.new(0, 0)
      end
      if ((line).equal?(lines))
        l = @f_lines.get(line - 1)
        return Line.new(l.attr_offset + l.attr_length, 0)
      end
      l = @f_lines.get(line)
      return (!(l.attr_delimiter).nil? ? Line.new(l.attr_offset, l.attr_length - l.attr_delimiter.length) : l)
    end
    
    typesig { [::Java::Int] }
    # @see org.eclipse.jface.text.ILineTracker#getLineOffset(int)
    def get_line_offset(line)
      lines = @f_lines.size
      if (line < 0 || line > lines)
        raise BadLocationException.new
      end
      if ((lines).equal?(0))
        return 0
      end
      if ((line).equal?(lines))
        l = @f_lines.get(line - 1)
        if (!(l.attr_delimiter).nil?)
          return l.attr_offset + l.attr_length
        end
        raise BadLocationException.new
      end
      l = @f_lines.get(line)
      return l.attr_offset
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.ILineTracker#getNumberOfLines()
    def get_number_of_lines
      lines = @f_lines.size
      if ((lines).equal?(0))
        return 1
      end
      l = @f_lines.get(lines - 1)
      return (!(l.attr_delimiter).nil? ? lines + 1 : lines)
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # @see org.eclipse.jface.text.ILineTracker#getNumberOfLines(int, int)
    def get_number_of_lines(position, length_)
      if (position < 0 || position + length_ > @f_text_length)
        raise BadLocationException.new
      end
      if ((length_).equal?(0))
        # optimization
        return 1
      end
      return get_number_of_lines(get_line_number_of_offset(position), position, length_)
    end
    
    typesig { [String] }
    # @see org.eclipse.jface.text.ILineTracker#computeNumberOfLines(java.lang.String)
    def compute_number_of_lines(text)
      count = 0
      start = 0
      delimiter_info = next_delimiter_info(text, start)
      while (!(delimiter_info).nil? && delimiter_info.attr_delimiter_index > -1)
        (count += 1)
        start = delimiter_info.attr_delimiter_index + delimiter_info.attr_delimiter_length
        delimiter_info = next_delimiter_info(text, start)
      end
      return count
    end
    
    typesig { [::Java::Int] }
    # @see org.eclipse.jface.text.ILineTracker#getLineDelimiter(int)
    def get_line_delimiter(line)
      lines = @f_lines.size
      if (line < 0 || line > lines)
        raise BadLocationException.new
      end
      if ((lines).equal?(0))
        return nil
      end
      if ((line).equal?(lines))
        return nil
      end
      l = @f_lines.get(line)
      return l.attr_delimiter
    end
    
    typesig { [String, ::Java::Int] }
    # Returns the information about the first delimiter found in the given text starting at the
    # given offset.
    # 
    # @param text the text to be searched
    # @param offset the offset in the given text
    # @return the information of the first found delimiter or <code>null</code>
    def next_delimiter_info(text, offset)
      raise NotImplementedError
    end
    
    typesig { [String, ::Java::Int, ::Java::Int] }
    # Creates the line structure for the given text. Newly created lines are inserted into the line
    # structure starting at the given position. Returns the number of newly created lines.
    # 
    # @param text the text for which to create a line structure
    # @param insertPosition the position at which the newly created lines are inserted into the
    # tracker's line structure
    # @param offset the offset of all newly created lines
    # @return the number of newly created lines
    def create_lines(text, insert_position, offset)
      count = 0
      start = 0
      delimiter_info = next_delimiter_info(text, 0)
      while (!(delimiter_info).nil? && delimiter_info.attr_delimiter_index > -1)
        index = delimiter_info.attr_delimiter_index + (delimiter_info.attr_delimiter_length - 1)
        if (insert_position + count >= @f_lines.size)
          @f_lines.add(Line.new(offset + start, offset + index, delimiter_info.attr_delimiter))
        else
          @f_lines.add(insert_position + count, Line.new(offset + start, offset + index, delimiter_info.attr_delimiter))
        end
        (count += 1)
        start = index + 1
        delimiter_info = next_delimiter_info(text, start)
      end
      if (start < text.length)
        if (insert_position + count < @f_lines.size)
          # there is a line below the current
          l = @f_lines.get(insert_position + count)
          delta = text.length - start
          l.attr_offset -= delta
          l.attr_length += delta
        else
          @f_lines.add(Line.new(offset + start, offset + text.length - 1, nil))
          (count += 1)
        end
      end
      return count
    end
    
    typesig { [::Java::Int, ::Java::Int, String] }
    # @see org.eclipse.jface.text.ILineTracker#replace(int, int, java.lang.String)
    def replace(position, length_, text)
      raise UnsupportedOperationException.new
    end
    
    typesig { [String] }
    # @see org.eclipse.jface.text.ILineTracker#set(java.lang.String)
    def set(text)
      @f_lines.clear
      if (!(text).nil?)
        @f_text_length = text.length
        create_lines(text, 0, 0)
      end
    end
    
    typesig { [] }
    # Returns the internal data structure, a {@link List} of {@link Line}s. Used only by
    # {@link TreeLineTracker#TreeLineTracker(ListLineTracker)}.
    # 
    # @return the internal list of lines.
    def get_lines
      return @f_lines
    end
    
    private
    alias_method :initialize__list_line_tracker, :initialize
  end
  
end
