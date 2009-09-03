require "rjava"

# Copyright (c) 2006, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Internal::Text::Revisions
  module RangeImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Internal::Text::Revisions
      include_const ::Org::Eclipse::Jface::Text::Source, :ILineRange
    }
  end
  
  # A variable {@link org.eclipse.jface.text.source.ILineRange} with the following invariant:
  # <ul>
  # <li>{@link #start() start} &gt;= 0
  # <li>{@link #length() length} &gt; 0, i.e. a range cannot be empty
  # </ul>
  # <p>
  # Attempts to create or modify a <code>Range</code> such that this invariant would be violated
  # result in a {@link LineIndexOutOfBoundsException} being
  # thrown.
  # </p>
  # 
  # @since 3.2
  class Range 
    include_class_members RangeImports
    include ILineRange
    include Cloneable
    
    class_module.module_eval {
      typesig { [ILineRange] }
      # Creates a new range with the same start and length as the passed line range.
      # 
      # @param range the range to copy
      # @return a <code>Range</code> with the same start and length as <code>range</code>
      # @throws LineIndexOutOfBoundsException if the passed {@link ILineRange} does not adhere to the
      # contract of {@link Range}
      def copy(range)
        return create_relative(range.get_start_line, range.get_number_of_lines)
      end
      
      typesig { [Range] }
      # Creates a new range equal to the passed line range.
      # 
      # @param range the range to copy
      # @return a <code>Range</code> equal to <code>range</code>
      def copy(range)
        return create_relative(range.start, range.length)
      end
      
      typesig { [::Java::Int, ::Java::Int] }
      # Creates a new range with the given start offset and length.
      # 
      # @param start the first line of the new range, must be &gt;= 0
      # @param length the number of lines included in the new range, must be &gt; 0
      # @return a <code>Range</code> with the given start and length
      # @throws LineIndexOutOfBoundsException if the parameters violate the invariant of
      # {@link Range}
      def create_relative(start_, length_)
        return Range.new(start_, length_)
      end
      
      typesig { [::Java::Int, ::Java::Int] }
      # Creates a new range with the given start and end offsets.
      # 
      # @param start the first line of the new range, must be &gt;= 0
      # @param end the first line not in the range any more (exclusive), must be &gt; <code>start</code>
      # @return a <code>Range</code> with the given start and end offsets
      # @throws LineIndexOutOfBoundsException if the parameters violate the invariant of
      # {@link Range}
      def create_absolute(start_, end_)
        return Range.new(start_, end_ - start_)
      end
    }
    
    attr_accessor :f_start
    alias_method :attr_f_start, :f_start
    undef_method :f_start
    alias_method :attr_f_start=, :f_start=
    undef_method :f_start=
    
    attr_accessor :f_length
    alias_method :attr_f_length, :f_length
    undef_method :f_length
    alias_method :attr_f_length=, :f_length=
    undef_method :f_length=
    
    typesig { [::Java::Int, ::Java::Int] }
    # Private constructor.
    def initialize(start_, length_)
      @f_start = 0
      @f_length = 0
      move_to(start_)
      set_length(length_)
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.source.ILineRange#getStartLine()
    def get_start_line
      return start
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.source.ILineRange#getNumberOfLines()
    def get_number_of_lines
      return length
    end
    
    typesig { [] }
    # Returns the first line contained in this range. Short equivalent of {@link #getStartLine()}.
    # 
    # @return the first line contained in this range
    def start
      return @f_start
    end
    
    typesig { [] }
    # Returns the number of lines contained in this range. Short equivalent of {@link #getNumberOfLines()}.
    # 
    # @return the number of lines contained in this range
    def length
      return @f_length
    end
    
    typesig { [] }
    # Returns the first line after this range. Equivalent to {@linkplain #start() start} + {@linkplain #length() length}.
    # 
    # @return the first line after this range
    def end_
      return start + length
    end
    
    typesig { [::Java::Int] }
    # Moves the receiver to <code>start</code>, keeping {@link #length()} constant.
    # 
    # @param start the new start, must be &gt;= 0
    # @throws LineIndexOutOfBoundsException if <code>start</code> &lt; 0
    def move_to(start_)
      if (!(start_ >= 0))
        raise LineIndexOutOfBoundsException.new("Cannot set a negative start: " + RJava.cast_to_string(start_))
      end # $NON-NLS-1$
      @f_start = start_
    end
    
    typesig { [::Java::Int] }
    # Moves this range such that the {@link #end()} is at <code>end</code>, keeping
    # {@link #length()} constant.
    # 
    # @param end the new end
    # @throws LineIndexOutOfBoundsException if <code>end</code> &lt;= {@link #start()}
    def move_end_to(end_)
      move_to(end_ - length)
    end
    
    typesig { [::Java::Int] }
    # Moves the range by <code>delta</code> lines, keeping {@link #length()} constant. The
    # resulting start line must be &gt;= 0.
    # 
    # @param delta the number of lines to shift the range
    # @throws LineIndexOutOfBoundsException if <code>-delta</code> &gt; {@link #start()}
    def move_by(delta)
      move_to(start + delta)
    end
    
    typesig { [::Java::Int] }
    # Moves the start offset to <code>start</code>, keeping {@link #end()} constant.
    # 
    # @param start the new start, must be &gt;= 0 and &lt; {@link #end()}
    # @throws LineIndexOutOfBoundsException if <code>start</code> &lt; 0 or &gt;= {@link #end()}
    def set_start(start_)
      end__ = end_
      if (!(start_ >= 0 && start_ < end__))
        raise LineIndexOutOfBoundsException.new("Cannot set a negative start: " + RJava.cast_to_string(start_))
      end # $NON-NLS-1$
      move_to(start_)
      set_end(end__)
    end
    
    typesig { [::Java::Int] }
    # Sets the end of this range, keeping {@link #start()} constant.
    # 
    # @param end the new end, must be &gt; {@link #start()}
    # @throws LineIndexOutOfBoundsException if <code>end</code> &lt;= {@link #start()}
    def set_end(end__)
      set_length(end__ - start)
    end
    
    typesig { [::Java::Int] }
    # Sets the length of this range, keeping {@link #start()} constant.
    # 
    # @param length the new length, must be &gt; 0
    # @throws LineIndexOutOfBoundsException if <code>length</code> &lt;= 0
    def set_length(length_)
      if (!(length_ > 0))
        raise LineIndexOutOfBoundsException.new("Cannot set length <= 0: " + RJava.cast_to_string(length_))
      end # $NON-NLS-1$
      @f_length = length_
    end
    
    typesig { [::Java::Int] }
    # Sets the length of this range, keeping {@link #end()} constant.
    # 
    # @param length the new length, must be &gt; 0 and &lt;= {@link #end()}
    # @throws LineIndexOutOfBoundsException if <code>length</code> &lt;= 0
    def set_length_and_move(length_)
      set_start(end_ - length_)
    end
    
    typesig { [::Java::Int] }
    # Resizes the range by <code>delta</code> lines, keeping {@link #start()} constant.
    # 
    # @param delta the number of lines to resize the range
    # @throws LineIndexOutOfBoundsException if <code>-delta</code> &gt;= {@link #length()}
    def resize_by(delta)
      set_length(length + delta)
    end
    
    typesig { [::Java::Int] }
    # Resizes the range by <code>delta</code> lines by moving the start offset, {@link #end()} remains unchanged.
    # 
    # @param delta the number of lines to resize the range
    # @throws LineIndexOutOfBoundsException if <code>-delta</code> &gt;= {@link #length()}
    def resize_and_move_by(delta)
      set_start(start + delta)
    end
    
    typesig { [::Java::Int] }
    # Splits a range off the end of the receiver. The receiver is shortened to only include
    # <code>remaining</code> lines after the split.
    # 
    # @param remaining the number of lines to remain in the receiver, must be in [1, {@link #length() length})
    # @return the split off range
    # @throws LineIndexOutOfBoundsException if <code>remaining</code>&gt;= {@link #length()} or <code>remaining</code>&ltt;= 0
    def split(remaining)
      if (!(remaining < length))
        # assert before modification
        raise LineIndexOutOfBoundsException.new("Remaining must be less than length: " + RJava.cast_to_string(length))
      end # $NON-NLS-1$
      split_length = length - remaining
      set_length(remaining)
      return Range.new(end_, split_length)
    end
    
    typesig { [ILineRange] }
    # Returns <code>true</code> if the passed range has the same offset and length as the receiver.
    # 
    # @param range another line range to compare the receiver to
    # @return <code>true</code> if <code>range</code> has the same offset and length as the receiver
    def equal_range(range)
      if ((range).equal?(self))
        return true
      end
      if ((range).nil?)
        return false
      end
      return (range.get_start_line).equal?(start) && (range.get_number_of_lines).equal?(length)
    end
    
    typesig { [] }
    # @see java.lang.Object#clone()
    def clone
      return Range.copy(self)
    end
    
    private
    alias_method :initialize__range, :initialize
  end
  
end
