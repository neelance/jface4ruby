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
  module TextPresentationImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :NoSuchElementException
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Custom, :StyleRange
      include_const ::Org::Eclipse::Swt::Custom, :StyledText
      include_const ::Org::Eclipse::Core::Runtime, :Assert
    }
  end
  
  # Describes the presentation styles for a section of an indexed text such as a
  # document or string. A text presentation defines a default style for the whole
  # section and in addition style differences for individual subsections. Text
  # presentations can be narrowed down to a particular result window. All methods
  # are result window aware, i.e. ranges outside the result window are always
  # ignored.
  # <p>
  # All iterators provided by a text presentation assume that they enumerate non
  # overlapping, consecutive ranges inside the default range. Thus, all these
  # iterators do not include the default range. The default style range must be
  # explicitly asked for using <code>getDefaultStyleRange</code>.
  class TextPresentation 
    include_class_members TextPresentationImports
    
    class_module.module_eval {
      typesig { [TextPresentation, StyledText] }
      # Applies the given presentation to the given text widget. Helper method.
      # 
      # @param presentation the style information
      # @param text the widget to which to apply the style information
      # @since 2.0
      def apply_text_presentation(presentation, text)
        ranges = Array.typed(StyleRange).new(presentation.get_denumerable_ranges) { nil }
        i = 0
        e = presentation.get_all_style_range_iterator
        while (e.has_next)
          ranges[((i += 1) - 1)] = e.next_
        end
        text.set_style_ranges(ranges)
      end
      
      # Enumerates all the <code>StyleRange</code>s included in the presentation.
      const_set_lazy(:FilterIterator) { Class.new do
        local_class_in TextPresentation
        include_class_members TextPresentation
        include Iterator
        
        # The index of the next style range to be enumerated
        attr_accessor :f_index
        alias_method :attr_f_index, :f_index
        undef_method :f_index
        alias_method :attr_f_index=, :f_index=
        undef_method :f_index=
        
        # The upper bound of the indices of style ranges to be enumerated
        attr_accessor :f_length
        alias_method :attr_f_length, :f_length
        undef_method :f_length
        alias_method :attr_f_length=, :f_length=
        undef_method :f_length=
        
        # Indicates whether ranges similar to the default range should be enumerated
        attr_accessor :f_skip_defaults
        alias_method :attr_f_skip_defaults, :f_skip_defaults
        undef_method :f_skip_defaults
        alias_method :attr_f_skip_defaults=, :f_skip_defaults=
        undef_method :f_skip_defaults=
        
        # The result window
        attr_accessor :f_window
        alias_method :attr_f_window, :f_window
        undef_method :f_window
        alias_method :attr_f_window=, :f_window=
        undef_method :f_window=
        
        typesig { [::Java::Boolean] }
        # <code>skipDefaults</code> tells the enumeration to skip all those style ranges
        # which define the same style as the presentation's default style range.
        # 
        # @param skipDefaults <code>false</code> if ranges similar to the default range should be enumerated
        def initialize(skip_defaults)
          @f_index = 0
          @f_length = 0
          @f_skip_defaults = false
          @f_window = nil
          @f_skip_defaults = skip_defaults
          @f_window = self.attr_f_result_window
          @f_index = get_first_index_in_window(@f_window)
          @f_length = get_first_index_after_window(@f_window)
          if (@f_skip_defaults)
            compute_index
          end
        end
        
        typesig { [] }
        # @see Iterator#next()
        def next_
          begin
            r = self.attr_f_ranges.get(((@f_index += 1) - 1))
            return create_window_relative_range(@f_window, r)
          rescue self.class::ArrayIndexOutOfBoundsException => x
            raise self.class::NoSuchElementException.new
          ensure
            if (@f_skip_defaults)
              compute_index
            end
          end
        end
        
        typesig { [] }
        # @see Iterator#hasNext()
        def has_next
          return @f_index < @f_length
        end
        
        typesig { [] }
        # @see Iterator#remove()
        def remove
          raise self.class::UnsupportedOperationException.new
        end
        
        typesig { [Object] }
        # Returns whether the given object should be skipped.
        # 
        # @param o the object to be checked
        # @return <code>true</code> if the object should be skipped by the iterator
        def skip(o)
          r = o
          return r.similar_to(self.attr_f_default_range)
        end
        
        typesig { [] }
        # Computes the index of the styled range that is the next to be enumerated.
        def compute_index
          while (@f_index < @f_length && skip(self.attr_f_ranges.get(@f_index)))
            (@f_index += 1)
          end
        end
        
        private
        alias_method :initialize__filter_iterator, :initialize
      end }
    }
    
    # The style information for the range covered by the whole presentation
    attr_accessor :f_default_range
    alias_method :attr_f_default_range, :f_default_range
    undef_method :f_default_range
    alias_method :attr_f_default_range=, :f_default_range=
    undef_method :f_default_range=
    
    # The member ranges of the presentation
    attr_accessor :f_ranges
    alias_method :attr_f_ranges, :f_ranges
    undef_method :f_ranges
    alias_method :attr_f_ranges=, :f_ranges=
    undef_method :f_ranges=
    
    # A clipping region against which the presentation can be clipped when asked for results
    attr_accessor :f_result_window
    alias_method :attr_f_result_window, :f_result_window
    undef_method :f_result_window
    alias_method :attr_f_result_window=, :f_result_window=
    undef_method :f_result_window=
    
    # The optional extent for this presentation.
    # @since 3.0
    attr_accessor :f_extent
    alias_method :attr_f_extent, :f_extent
    undef_method :f_extent
    alias_method :attr_f_extent=, :f_extent=
    undef_method :f_extent=
    
    typesig { [] }
    # Creates a new empty text presentation.
    def initialize
      @f_default_range = nil
      @f_ranges = nil
      @f_result_window = nil
      @f_extent = nil
      @f_ranges = ArrayList.new(50)
    end
    
    typesig { [::Java::Int] }
    # Creates a new empty text presentation. <code>sizeHint</code>  tells the
    # expected size of this presentation.
    # 
    # @param sizeHint the expected size of this presentation
    def initialize(size_hint)
      @f_default_range = nil
      @f_ranges = nil
      @f_result_window = nil
      @f_extent = nil
      Assert.is_true(size_hint > 0)
      @f_ranges = ArrayList.new(size_hint)
    end
    
    typesig { [IRegion, ::Java::Int] }
    # Creates a new empty text presentation with the given extent.
    # <code>sizeHint</code>  tells the expected size of this presentation.
    # 
    # @param extent the extent of the created <code>TextPresentation</code>
    # @param sizeHint the expected size of this presentation
    # @since 3.0
    def initialize(extent, size_hint)
      initialize__text_presentation(size_hint)
      Assert.is_not_null(extent)
      @f_extent = extent
    end
    
    typesig { [IRegion] }
    # Sets the result window for this presentation. When dealing with
    # this presentation all ranges which are outside the result window
    # are ignored. For example, the size of the presentation is 0
    # when there is no range inside the window even if there are ranges
    # outside the window. All methods are aware of the result window.
    # 
    # @param resultWindow the result window
    def set_result_window(result_window)
      @f_result_window = result_window
    end
    
    typesig { [StyleRange] }
    # Set the default style range of this presentation.
    # The default style range defines the overall area covered
    # by this presentation and its style information.
    # 
    # @param range the range describing the default region
    def set_default_style_range(range)
      @f_default_range = range
    end
    
    typesig { [] }
    # Returns this presentation's default style range. The returned <code>StyleRange</code>
    # is relative to the start of the result window.
    # 
    # @return this presentation's default style range
    def get_default_style_range
      range = create_window_relative_range(@f_result_window, @f_default_range)
      if ((range).nil?)
        return nil
      end
      return range.clone
    end
    
    typesig { [StyleRange] }
    # Add the given range to the presentation. The range must be a
    # subrange of the presentation's default range.
    # 
    # @param range the range to be added
    def add_style_range(range)
      check_consistency(range)
      @f_ranges.add(range)
    end
    
    typesig { [StyleRange] }
    # Replaces the given range in this presentation. The range must be a
    # subrange of the presentation's default range.
    # 
    # @param range the range to be added
    # @since 3.0
    def replace_style_range(range)
      apply_style_range(range, false)
    end
    
    typesig { [StyleRange] }
    # Merges the given range into this presentation. The range must be a
    # subrange of the presentation's default range.
    # 
    # @param range the range to be added
    # @since 3.0
    def merge_style_range(range)
      apply_style_range(range, true)
    end
    
    typesig { [StyleRange, ::Java::Boolean] }
    # Applies the given range to this presentation. The range must be a
    # subrange of the presentation's default range.
    # 
    # @param range the range to be added
    # @param merge <code>true</code> if the style should be merged instead of replaced
    # @since 3.0
    def apply_style_range(range, merge)
      if ((range.attr_length).equal?(0))
        return
      end
      check_consistency(range)
      start = range.attr_start
      length = range.attr_length
      end_ = start + length
      if ((@f_ranges.size).equal?(0))
        default_range = get_default_style_range
        if ((default_range).nil?)
          default_range = range
        end
        default_range.attr_start = start
        default_range.attr_length = length
        apply_style(range, default_range, merge)
        @f_ranges.add(default_range)
      else
        range_region = Region.new(start, length)
        first = get_first_index_in_window(range_region)
        if ((first).equal?(@f_ranges.size))
          default_range = get_default_style_range
          if ((default_range).nil?)
            default_range = range
          end
          default_range.attr_start = start
          default_range.attr_length = length
          apply_style(range, default_range, merge)
          @f_ranges.add(default_range)
          return
        end
        last = get_first_index_after_window(range_region)
        i = first
        while i < last && length > 0
          current = @f_ranges.get(i)
          current_start = current.attr_start
          current_end = current_start + current.attr_length
          if (end_ <= current_start)
            @f_ranges.add(i, range)
            return
          end
          if (start >= current_end)
            i += 1
            next
          end
          current_copy = nil
          if (end_ < current_end)
            current_copy = current.clone
          end
          if (start < current_start)
            # Apply style to new default range and add it
            default_range = get_default_style_range
            if ((default_range).nil?)
              default_range = StyleRange.new
            end
            default_range.attr_start = start
            default_range.attr_length = current_start - start
            apply_style(range, default_range, merge)
            @f_ranges.add(i, default_range)
            i += 1
            last += 1
            # Apply style to first part of current range
            current.attr_length = Math.min(end_, current_end) - current_start
            apply_style(range, current, merge)
          end
          if (start >= current_start)
            # Shorten the current range
            current.attr_length = start - current_start
            # Apply the style to the rest of the current range and add it
            if (current.attr_length > 0)
              current = current.clone
              i += 1
              last += 1
              @f_ranges.add(i, current)
            end
            apply_style(range, current, merge)
            current.attr_start = start
            current.attr_length = Math.min(end_, current_end) - start
          end
          if (end_ < current_end)
            # Add rest of current range
            current_copy.attr_start = end_
            current_copy.attr_length = current_end - end_
            i += 1
            last += 1
            @f_ranges.add(i, current_copy)
          end
          # Update range
          range.attr_start = current_end
          range.attr_length = Math.max(end_ - current_end, 0)
          start = range.attr_start
          length = range.attr_length
          i += 1
        end
        if (length > 0)
          # Apply style to new default range and add it
          default_range = get_default_style_range
          if ((default_range).nil?)
            default_range = range
          end
          default_range.attr_start = start
          default_range.attr_length = end_ - start
          apply_style(range, default_range, merge)
          @f_ranges.add(last, default_range)
        end
      end
    end
    
    typesig { [Array.typed(StyleRange)] }
    # Replaces the given ranges in this presentation. Each range must be a
    # subrange of the presentation's default range. The ranges must be ordered
    # by increasing offset and must not overlap (but may be adjacent).
    # 
    # @param ranges the ranges to be added
    # @since 3.0
    def replace_style_ranges(ranges)
      apply_style_ranges(ranges, false)
    end
    
    typesig { [Array.typed(StyleRange)] }
    # Merges the given ranges into this presentation. Each range must be a
    # subrange of the presentation's default range. The ranges must be ordered
    # by increasing offset and must not overlap (but may be adjacent).
    # 
    # @param ranges the ranges to be added
    # @since 3.0
    def merge_style_ranges(ranges)
      apply_style_ranges(ranges, true)
    end
    
    typesig { [Array.typed(StyleRange), ::Java::Boolean] }
    # Applies the given ranges to this presentation. Each range must be a
    # subrange of the presentation's default range. The ranges must be ordered
    # by increasing offset and must not overlap (but may be adjacent).
    # 
    # @param ranges the ranges to be added
    # @param merge <code>true</code> if the style should be merged instead of replaced
    # @since 3.0
    def apply_style_ranges(ranges, merge)
      j = 0
      old_ranges = @f_ranges
      new_ranges = ArrayList.new(2 * ranges.attr_length + old_ranges.size)
      i = 0
      n = ranges.attr_length
      while i < n
        range = ranges[i]
        @f_ranges = old_ranges # for getFirstIndexAfterWindow(...)
        m = get_first_index_after_window(Region.new(range.attr_start, range.attr_length))
        while j < m
          new_ranges.add(old_ranges.get(j))
          j += 1
        end
        @f_ranges = new_ranges # for mergeStyleRange(...)
        apply_style_range(range, merge)
        i += 1
      end
      m = old_ranges.size
      while j < m
        new_ranges.add(old_ranges.get(j))
        j += 1
      end
      @f_ranges = new_ranges
    end
    
    typesig { [StyleRange, StyleRange, ::Java::Boolean] }
    # Applies the template's style to the target.
    # 
    # @param template the style range to be used as template
    # @param target the style range to which to apply the template
    # @param merge <code>true</code> if the style should be merged instead of replaced
    # @since 3.0
    def apply_style(template, target, merge)
      if (merge)
        if (!(template.attr_font).nil?)
          target.attr_font = template.attr_font
        end
        target.attr_font_style |= template.attr_font_style
        if (!(template.attr_metrics).nil?)
          target.attr_metrics = template.attr_metrics
        end
        if (!(template.attr_foreground).nil? || (template.attr_underline_style).equal?(SWT::UNDERLINE_LINK))
          target.attr_foreground = template.attr_foreground
        end
        if (!(template.attr_background).nil?)
          target.attr_background = template.attr_background
        end
        target.attr_strikeout |= template.attr_strikeout
        if (!(template.attr_strikeout_color).nil?)
          target.attr_strikeout_color = template.attr_strikeout_color
        end
        target.attr_underline |= template.attr_underline
        if (!(template.attr_underline_style).equal?(SWT::NONE) && !(target.attr_underline_style).equal?(SWT::UNDERLINE_LINK))
          target.attr_underline_style = template.attr_underline_style
        end
        if (!(template.attr_underline_color).nil?)
          target.attr_underline_color = template.attr_underline_color
        end
        if (!(template.attr_border_style).equal?(SWT::NONE))
          target.attr_border_style = template.attr_border_style
        end
        if (!(template.attr_border_color).nil?)
          target.attr_border_color = template.attr_border_color
        end
      else
        target.attr_font = template.attr_font
        target.attr_font_style = template.attr_font_style
        target.attr_metrics = template.attr_metrics
        target.attr_foreground = template.attr_foreground
        target.attr_background = template.attr_background
        target.attr_strikeout = template.attr_strikeout
        target.attr_strikeout_color = template.attr_strikeout_color
        target.attr_underline = template.attr_underline
        target.attr_underline_style = template.attr_underline_style
        target.attr_underline_color = template.attr_underline_color
        target.attr_border_style = template.attr_border_style
        target.attr_border_color = template.attr_border_color
      end
    end
    
    typesig { [StyleRange] }
    # Checks whether the given range is a subrange of the presentation's
    # default style range.
    # 
    # @param range the range to be checked
    # @exception IllegalArgumentException if range is not a subrange of the presentation's default range
    def check_consistency(range)
      if ((range).nil?)
        raise IllegalArgumentException.new
      end
      if (!(@f_default_range).nil?)
        if (range.attr_start < @f_default_range.attr_start)
          range.attr_start = @f_default_range.attr_start
        end
        default_end = @f_default_range.attr_start + @f_default_range.attr_length
        end_ = range.attr_start + range.attr_length
        if (end_ > default_end)
          range.attr_length -= (end_ - default_end)
        end
      end
    end
    
    typesig { [IRegion] }
    # Returns the index of the first range which overlaps with the
    # specified window.
    # 
    # @param window the window to be used for searching
    # @return the index of the first range overlapping with the window
    def get_first_index_in_window(window)
      if (!(window).nil?)
        start = window.get_offset
        i = -1
        j = @f_ranges.size
        while (j - i > 1)
          k = (i + j) >> 1
          r = @f_ranges.get(k)
          if (r.attr_start + r.attr_length > start)
            j = k
          else
            i = k
          end
        end
        return j
      end
      return 0
    end
    
    typesig { [IRegion] }
    # Returns the index of the first range which comes after the specified window and does
    # not overlap with this window.
    # 
    # @param window the window to be used for searching
    # @return the index of the first range behind the window and not overlapping with the window
    def get_first_index_after_window(window)
      if (!(window).nil?)
        end_ = window.get_offset + window.get_length
        i = -1
        j = @f_ranges.size
        while (j - i > 1)
          k = (i + j) >> 1
          r = @f_ranges.get(k)
          if (r.attr_start < end_)
            i = k
          else
            j = k
          end
        end
        return j
      end
      return @f_ranges.size
    end
    
    typesig { [IRegion, StyleRange] }
    # Returns a style range which is relative to the specified window and
    # appropriately clipped if necessary. The original style range is not
    # modified.
    # 
    # @param window the reference window
    # @param range the absolute range
    # @return the window relative range based on the absolute range
    def create_window_relative_range(window, range)
      if ((window).nil? || (range).nil?)
        return range
      end
      start = range.attr_start - window.get_offset
      if (start < 0)
        start = 0
      end
      range_end = range.attr_start + range.attr_length
      window_end = window.get_offset + window.get_length
      end_ = (range_end > window_end ? window_end : range_end)
      end_ -= window.get_offset
      new_range = range.clone
      new_range.attr_start = start
      new_range.attr_length = end_ - start
      return new_range
    end
    
    typesig { [IRegion] }
    # Returns the region which is relative to the specified window and
    # appropriately clipped if necessary.
    # 
    # @param coverage the absolute coverage
    # @return the window relative region based on the absolute coverage
    # @since 3.0
    def create_window_relative_region(coverage)
      if ((@f_result_window).nil? || (coverage).nil?)
        return coverage
      end
      start = coverage.get_offset - @f_result_window.get_offset
      if (start < 0)
        start = 0
      end
      range_end = coverage.get_offset + coverage.get_length
      window_end = @f_result_window.get_offset + @f_result_window.get_length
      end_ = (range_end > window_end ? window_end : range_end)
      end_ -= @f_result_window.get_offset
      return Region.new(start, end_ - start)
    end
    
    typesig { [] }
    # Returns an iterator which enumerates all style ranged which define a style
    # different from the presentation's default style range. The default style range
    # is not enumerated.
    # 
    # @return a style range iterator
    def get_non_default_style_range_iterator
      return FilterIterator.new_local(self, !(@f_default_range).nil?)
    end
    
    typesig { [] }
    # Returns an iterator which enumerates all style ranges of this presentation
    # except the default style range. The returned <code>StyleRange</code>s
    # are relative to the start of the presentation's result window.
    # 
    # @return a style range iterator
    def get_all_style_range_iterator
      return FilterIterator.new_local(self, false)
    end
    
    typesig { [] }
    # Returns whether this collection contains any style range including
    # the default style range.
    # 
    # @return <code>true</code> if there is no style range in this presentation
    def is_empty
      return ((@f_default_range).nil? && (get_denumerable_ranges).equal?(0))
    end
    
    typesig { [] }
    # Returns the number of style ranges in the presentation not counting the default
    # style range.
    # 
    # @return the number of style ranges in the presentation excluding the default style range
    def get_denumerable_ranges
      size_ = get_first_index_after_window(@f_result_window) - get_first_index_in_window(@f_result_window)
      return (size_ < 0 ? 0 : size_)
    end
    
    typesig { [] }
    # Returns the style range with the smallest offset ignoring the default style range or null
    # if the presentation is empty.
    # 
    # @return the style range with the smallest offset different from the default style range
    def get_first_style_range
      begin
        range = @f_ranges.get(get_first_index_in_window(@f_result_window))
        return create_window_relative_range(@f_result_window, range)
      rescue NoSuchElementException => x
      rescue IndexOutOfBoundsException => x
      end
      return nil
    end
    
    typesig { [] }
    # Returns the style range with the highest offset ignoring the default style range.
    # 
    # @return the style range with the highest offset different from the default style range
    def get_last_style_range
      begin
        range = @f_ranges.get(get_first_index_after_window(@f_result_window) - 1)
        return create_window_relative_range(@f_result_window, range)
      rescue NoSuchElementException => x
        return nil
      rescue IndexOutOfBoundsException => x
        return nil
      end
    end
    
    typesig { [] }
    # Returns the coverage of this presentation as clipped by the presentation's
    # result window.
    # 
    # @return the coverage of this presentation
    def get_coverage
      if (!(@f_default_range).nil?)
        range = get_default_style_range
        return Region.new(range.attr_start, range.attr_length)
      end
      first = get_first_style_range
      last = get_last_style_range
      if ((first).nil? || (last).nil?)
        return nil
      end
      return Region.new(first.attr_start, last.attr_start - first.attr_start + last.attr_length)
    end
    
    typesig { [] }
    # Returns the extent of this presentation clipped by the
    # presentation's result window.
    # 
    # @return the clipped extent
    # @since 3.0
    def get_extent
      if (!(@f_extent).nil?)
        return create_window_relative_region(@f_extent)
      end
      return get_coverage
    end
    
    typesig { [] }
    # Clears this presentation by resetting all applied changes.
    # @since 2.0
    def clear
      @f_default_range = nil
      @f_result_window = nil
      @f_ranges.clear
    end
    
    private
    alias_method :initialize__text_presentation, :initialize
  end
  
end
