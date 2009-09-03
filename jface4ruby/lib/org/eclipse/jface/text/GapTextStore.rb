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
  module GapTextStoreImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
      include_const ::Org::Eclipse::Core::Runtime, :Assert
    }
  end
  
  # Implements a gap managing text store. The gap text store relies on the assumption that
  # consecutive changes to a document are co-located. The start of the gap is always moved to the
  # location of the last change.
  # <p>
  # <strong>Performance:</strong> Typing-style changes perform in constant time unless re-allocation
  # becomes necessary. Generally, a change that does not cause re-allocation will cause at most one
  # {@linkplain System#arraycopy(Object, int, Object, int, int) arraycopy} operation of a length of
  # about <var>d</var>, where <var>d</var> is the distance from the previous change. Let <var>a(x)</var>
  # be the algorithmic performance of an <code>arraycopy</code> operation of the length <var>x</var>,
  # then such a change then performs in <i>O(a(x))</i>,
  # {@linkplain #get(int, int) get(int, <var>length</var>)} performs in <i>O(a(length))</i>,
  # {@link #get(int)} in <i>O(1)</i>.
  # <p>
  # How frequently the array needs re-allocation is controlled by the constructor parameters.
  # </p>
  # <p>
  # This class is not intended to be subclassed.
  # </p>
  # 
  # @see CopyOnWriteTextStore for a copy-on-write text store wrapper
  # @noextend This class is not intended to be subclassed by clients.
  class GapTextStore 
    include_class_members GapTextStoreImports
    include ITextStore
    
    # The minimum gap size allocated when re-allocation occurs.
    # @since 3.3
    attr_accessor :f_min_gap_size
    alias_method :attr_f_min_gap_size, :f_min_gap_size
    undef_method :f_min_gap_size
    alias_method :attr_f_min_gap_size=, :f_min_gap_size=
    undef_method :f_min_gap_size=
    
    # The maximum gap size allocated when re-allocation occurs.
    # @since 3.3
    attr_accessor :f_max_gap_size
    alias_method :attr_f_max_gap_size, :f_max_gap_size
    undef_method :f_max_gap_size
    alias_method :attr_f_max_gap_size=, :f_max_gap_size=
    undef_method :f_max_gap_size=
    
    # The multiplier to compute the array size from the content length
    # (1&nbsp;&lt;=&nbsp;fSizeMultiplier&nbsp;&lt;=&nbsp;2).
    # 
    # @since 3.3
    attr_accessor :f_size_multiplier
    alias_method :attr_f_size_multiplier, :f_size_multiplier
    undef_method :f_size_multiplier
    alias_method :attr_f_size_multiplier=, :f_size_multiplier=
    undef_method :f_size_multiplier=
    
    # The store's content
    attr_accessor :f_content
    alias_method :attr_f_content, :f_content
    undef_method :f_content
    alias_method :attr_f_content=, :f_content=
    undef_method :f_content=
    
    # Starting index of the gap
    attr_accessor :f_gap_start
    alias_method :attr_f_gap_start, :f_gap_start
    undef_method :f_gap_start
    alias_method :attr_f_gap_start=, :f_gap_start=
    undef_method :f_gap_start=
    
    # End index of the gap
    attr_accessor :f_gap_end
    alias_method :attr_f_gap_end, :f_gap_end
    undef_method :f_gap_end
    alias_method :attr_f_gap_end=, :f_gap_end=
    undef_method :f_gap_end=
    
    # The current high water mark. If a change would cause the gap to grow larger than this, the
    # array is re-allocated.
    # @since 3.3
    attr_accessor :f_threshold
    alias_method :attr_f_threshold, :f_threshold
    undef_method :f_threshold
    alias_method :attr_f_threshold=, :f_threshold=
    undef_method :f_threshold=
    
    typesig { [::Java::Int, ::Java::Int] }
    # Creates a new empty text store using the specified low and high watermarks.
    # 
    # @param lowWatermark unused - at the lower bound, the array is only resized when the content
    # does not fit
    # @param highWatermark if the gap is ever larger than this, it will automatically be shrunken
    # (&gt;=&nbsp;0)
    # @deprecated use {@link GapTextStore#GapTextStore(int, int, float)} instead
    def initialize(low_watermark, high_watermark)
      # Legacy constructor. The API contract states that highWatermark is the upper bound for the
      # gap size. Albeit this contract was not previously adhered to, it is now: The allocated
      # gap size is fixed at half the highWatermark. Since the threshold is always twice the
      # allocated gap size, the gap will never grow larger than highWatermark. Previously, the
      # gap size was initialized to highWatermark, causing re-allocation if the content length
      # shrunk right after allocation. The fixed gap size is now only half of the previous value,
      # circumventing that problem (there was no API contract specifying the initial gap size).
      # 
      # The previous implementation did not allow the gap size to become smaller than
      # lowWatermark, which doesn't make any sense: that area of the gap was simply never ever
      # used.
      initialize__gap_text_store(high_watermark / 2, high_watermark / 2, 0)
    end
    
    typesig { [] }
    # Equivalent to
    # {@linkplain GapTextStore#GapTextStore(int, int, float) new GapTextStore(256, 4096, 0.1f)}.
    # 
    # @since 3.3
    def initialize
      initialize__gap_text_store(256, 4096, 0.1)
    end
    
    typesig { [::Java::Int, ::Java::Int, ::Java::Float] }
    # Creates an empty text store that uses re-allocation thresholds relative to the content
    # length. Re-allocation is controlled by the <em>gap factor</em>, which is the quotient of
    # the gap size and the array size. Re-allocation occurs if a change causes the gap factor to go
    # outside <code>[0,&nbsp;maxGapFactor]</code>. When re-allocation occurs, the array is sized
    # such that the gap factor is <code>0.5 * maxGapFactor</code>. The gap size computed in this
    # manner is bounded by the <code>minSize</code> and <code>maxSize</code> parameters.
    # <p>
    # A <code>maxGapFactor</code> of <code>0</code> creates a text store that never has a gap
    # at all (if <code>minSize</code> is 0); a <code>maxGapFactor</code> of <code>1</code>
    # creates a text store that doubles its size with every re-allocation and that never shrinks.
    # </p>
    # <p>
    # The <code>minSize</code> and <code>maxSize</code> parameters are absolute bounds to the
    # allocated gap size. Use <code>minSize</code> to avoid frequent re-allocation for small
    # documents. Use <code>maxSize</code> to avoid a huge gap being allocated for large
    # documents.
    # </p>
    # 
    # @param minSize the minimum gap size to allocate (&gt;=&nbsp;0; use 0 for no minimum)
    # @param maxSize the maximum gap size to allocate (&gt;=&nbsp;minSize; use
    # {@link Integer#MAX_VALUE} for no maximum)
    # @param maxGapFactor is the maximum fraction of the array that is occupied by the gap (<code>0&nbsp;&lt;=&nbsp;maxGapFactor&nbsp;&lt;=&nbsp;1</code>)
    # @since 3.3
    def initialize(min_size, max_size, max_gap_factor)
      @f_min_gap_size = 0
      @f_max_gap_size = 0
      @f_size_multiplier = 0.0
      @f_content = CharArray.new(0)
      @f_gap_start = 0
      @f_gap_end = 0
      @f_threshold = 0
      Assert.is_legal(0 <= max_gap_factor && max_gap_factor <= 1)
      Assert.is_legal(0 <= min_size && min_size <= max_size)
      @f_min_gap_size = min_size
      @f_max_gap_size = max_size
      @f_size_multiplier = 1 / (1 - max_gap_factor / 2)
    end
    
    typesig { [::Java::Int] }
    # @see org.eclipse.jface.text.ITextStore#get(int)
    def get(offset)
      if (offset < @f_gap_start)
        return @f_content[offset]
      end
      return @f_content[offset + gap_size]
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # @see org.eclipse.jface.text.ITextStore#get(int, int)
    def get(offset, length)
      if (@f_gap_start <= offset)
        return String.new(@f_content, offset + gap_size, length)
      end
      end_ = offset + length
      if (end_ <= @f_gap_start)
        return String.new(@f_content, offset, length)
      end
      buf = StringBuffer.new(length)
      buf.append(@f_content, offset, @f_gap_start - offset)
      buf.append(@f_content, @f_gap_end, end_ - @f_gap_start)
      return buf.to_s
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.ITextStore#getLength()
    def get_length
      return @f_content.attr_length - gap_size
    end
    
    typesig { [String] }
    # @see org.eclipse.jface.text.ITextStore#set(java.lang.String)
    def set(text)
      # Moves the gap to the end of the content. There is no sensible prediction of where the
      # next change will occur, but at least the next change will not trigger re-allocation. This
      # is especially important when using the GapTextStore within a CopyOnWriteTextStore, where
      # the GTS is only initialized right before a modification.
      replace(0, get_length, text)
    end
    
    typesig { [::Java::Int, ::Java::Int, String] }
    # @see org.eclipse.jface.text.ITextStore#replace(int, int, java.lang.String)
    def replace(offset, length, text)
      if ((text).nil?)
        adjust_gap(offset, length, 0)
      else
        text_length = text.length
        adjust_gap(offset, length, text_length)
        if (!(text_length).equal?(0))
          text.get_chars(0, text_length, @f_content, offset)
        end
      end
    end
    
    typesig { [::Java::Int, ::Java::Int, ::Java::Int] }
    # Moves the gap to <code>offset + add</code>, moving any content after
    # <code>offset + remove</code> behind the gap. The gap size is kept between 0 and
    # {@link #fThreshold}, leading to re-allocation if needed. The content between
    # <code>offset</code> and <code>offset + add</code> is undefined after this operation.
    # 
    # @param offset the offset at which a change happens
    # @param remove the number of character which are removed or overwritten at <code>offset</code>
    # @param add the number of character which are inserted or overwriting at <code>offset</code>
    def adjust_gap(offset, remove, add)
      old_gap_size = gap_size
      new_gap_size = old_gap_size - add + remove
      reuse_array = 0 <= new_gap_size && new_gap_size <= @f_threshold
      new_gap_start = offset + add
      new_gap_end = 0
      if (reuse_array)
        new_gap_end = move_gap(offset, remove, old_gap_size, new_gap_size, new_gap_start)
      else
        new_gap_end = reallocate(offset, remove, old_gap_size, new_gap_size, new_gap_start)
      end
      @f_gap_start = new_gap_start
      @f_gap_end = new_gap_end
    end
    
    typesig { [::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int] }
    # Moves the gap to <code>newGapStart</code>.
    # 
    # @param offset the change offset
    # @param remove the number of removed / overwritten characters
    # @param oldGapSize the old gap size
    # @param newGapSize the gap size after the change
    # @param newGapStart the offset in the array to move the gap to
    # @return the new gap end
    # @since 3.3
    def move_gap(offset, remove, old_gap_size, new_gap_size, new_gap_start)
      # No re-allocation necessary. The area between the change offset and gap can be copied
      # in at most one operation. Don't copy parts that will be overwritten anyway.
      new_gap_end = new_gap_start + new_gap_size
      if (offset < @f_gap_start)
        after_remove = offset + remove
        if (after_remove < @f_gap_start)
          between_size = @f_gap_start - after_remove
          array_copy(after_remove, @f_content, new_gap_end, between_size)
        end
        # otherwise, only the gap gets enlarged
      else
        offset_shifted = offset + old_gap_size
        between_size = offset_shifted - @f_gap_end # in the typing case, betweenSize is 0
        array_copy(@f_gap_end, @f_content, @f_gap_start, between_size)
      end
      return new_gap_end
    end
    
    typesig { [::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int] }
    # Reallocates a new array and copies the data from the previous one.
    # 
    # @param offset the change offset
    # @param remove the number of removed / overwritten characters
    # @param oldGapSize the old gap size
    # @param newGapSize the gap size after the change if no re-allocation would occur (can be negative)
    # @param newGapStart the offset in the array to move the gap to
    # @return the new gap end
    # @since 3.3
    def reallocate(offset, remove, old_gap_size, new_gap_size, new_gap_start)
      # the new content length (without any gap)
      new_length = @f_content.attr_length - new_gap_size
      # the new array size based on the gap factor
      new_array_size = RJava.cast_to_int((new_length * @f_size_multiplier))
      new_gap_size = new_array_size - new_length
      # bound the gap size within min/max
      if (new_gap_size < @f_min_gap_size)
        new_gap_size = @f_min_gap_size
        new_array_size = new_length + new_gap_size
      else
        if (new_gap_size > @f_max_gap_size)
          new_gap_size = @f_max_gap_size
          new_array_size = new_length + new_gap_size
        end
      end
      # the upper threshold is always twice the gapsize
      @f_threshold = new_gap_size * 2
      new_content = allocate(new_array_size)
      new_gap_end = new_gap_start + new_gap_size
      # Re-allocation: The old content can be copied in at most 3 operations to the newly allocated
      # array. Either one of change offset and the gap may come first.
      # - unchanged area before the change offset / gap
      # - area between the change offset and the gap (either one may be first)
      # - rest area after the change offset / after the gap
      if (offset < @f_gap_start)
        # change comes before gap
        array_copy(0, new_content, 0, offset)
        after_remove = offset + remove
        if (after_remove < @f_gap_start)
          # removal is completely before the gap
          between_size = @f_gap_start - after_remove
          array_copy(after_remove, new_content, new_gap_end, between_size)
          rest_size = @f_content.attr_length - @f_gap_end
          array_copy(@f_gap_end, new_content, new_gap_end + between_size, rest_size)
        else
          # removal encompasses the gap
          after_remove += old_gap_size
          rest_size = @f_content.attr_length - after_remove
          array_copy(after_remove, new_content, new_gap_end, rest_size)
        end
      else
        # gap comes before change
        array_copy(0, new_content, 0, @f_gap_start)
        offset_shifted = offset + old_gap_size
        between_size = offset_shifted - @f_gap_end
        array_copy(@f_gap_end, new_content, @f_gap_start, between_size)
        after_remove = offset_shifted + remove
        rest_size = @f_content.attr_length - after_remove
        array_copy(after_remove, new_content, new_gap_end, rest_size)
      end
      @f_content = new_content
      return new_gap_end
    end
    
    typesig { [::Java::Int] }
    # Allocates a new <code>char[size]</code>.
    # 
    # @param size the length of the new array.
    # @return a newly allocated char array
    # @since 3.3
    def allocate(size)
      return CharArray.new(size)
    end
    
    typesig { [::Java::Int, Array.typed(::Java::Char), ::Java::Int, ::Java::Int] }
    # Executes System.arraycopy if length != 0. A length < 0 cannot happen -> don't hide coding
    # errors by checking for negative lengths.
    # @since 3.3
    def array_copy(src_pos, dest, dest_pos, length_)
      if (!(length_).equal?(0))
        System.arraycopy(@f_content, src_pos, dest, dest_pos, length_)
      end
    end
    
    typesig { [] }
    # Returns the gap size.
    # 
    # @return the gap size
    # @since 3.3
    def gap_size
      return @f_gap_end - @f_gap_start
    end
    
    typesig { [] }
    # Returns a copy of the content of this text store.
    # For internal use only.
    # 
    # @return a copy of the content of this text store
    def get_content_as_string
      return String.new(@f_content)
    end
    
    typesig { [] }
    # Returns the start index of the gap managed by this text store.
    # For internal use only.
    # 
    # @return the start index of the gap managed by this text store
    def get_gap_start_index
      return @f_gap_start
    end
    
    typesig { [] }
    # Returns the end index of the gap managed by this text store.
    # For internal use only.
    # 
    # @return the end index of the gap managed by this text store
    def get_gap_end_index
      return @f_gap_end
    end
    
    private
    alias_method :initialize__gap_text_store, :initialize
  end
  
end
