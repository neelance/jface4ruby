require "rjava"

# Copyright (c) 2008, 2009 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Viewers
  module StyledStringImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :JavaList
      include_const ::Org::Eclipse::Swt::Custom, :StyleRange
      include_const ::Org::Eclipse::Swt::Graphics, :TextStyle
      include_const ::Org::Eclipse::Jface::Preference, :JFacePreferences
      include_const ::Org::Eclipse::Jface::Resource, :ColorRegistry
      include_const ::Org::Eclipse::Jface::Resource, :JFaceResources
    }
  end
  
  # A mutable string with styled ranges. All ranges mark substrings of the string
  # and do not overlap. Styles are applied using instances of {@link Styler} to
  # compute the result of {@link #getStyleRanges()}.
  # 
  # The styled string can be built in the following two ways:
  # <ul>
  # <li>new strings with stylers can be appended</li>
  # <li>stylers can by applied to ranges of the existing string</li>
  # </ul>
  # 
  # <p>
  # This class may be instantiated; it is not intended to be subclassed.
  # </p>
  # 
  # @since 3.4
  class StyledString 
    include_class_members StyledStringImports
    
    class_module.module_eval {
      # A styler will be asked to apply its styles to one ore more ranges in the
      # {@link StyledString}.
      const_set_lazy(:Styler) { Class.new do
        include_class_members StyledString
        
        typesig { [class_self::TextStyle] }
        # Applies the styles represented by this object to the given textStyle.
        # 
        # @param textStyle
        # the {@link TextStyle} to modify
        def apply_styles(text_style)
          raise NotImplementedError
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__styler, :initialize
      end }
      
      # A built-in styler using the {@link JFacePreferences#QUALIFIER_COLOR}
      # managed in the JFace color registry (See
      # {@link JFaceResources#getColorRegistry()}).
      const_set_lazy(:QUALIFIER_STYLER) { create_color_registry_styler(JFacePreferences::QUALIFIER_COLOR, nil) }
      const_attr_reader  :QUALIFIER_STYLER
      
      # A built-in styler using the {@link JFacePreferences#COUNTER_COLOR}
      # managed in the JFace color registry (See
      # {@link JFaceResources#getColorRegistry()}).
      const_set_lazy(:COUNTER_STYLER) { create_color_registry_styler(JFacePreferences::COUNTER_COLOR, nil) }
      const_attr_reader  :COUNTER_STYLER
      
      # A built-in styler using the {@link JFacePreferences#DECORATIONS_COLOR}
      # managed in the JFace color registry (See
      # {@link JFaceResources#getColorRegistry()}).
      const_set_lazy(:DECORATIONS_STYLER) { create_color_registry_styler(JFacePreferences::DECORATIONS_COLOR, nil) }
      const_attr_reader  :DECORATIONS_STYLER
      
      typesig { [String, String] }
      # Creates a styler that takes the given foreground and background colors
      # from the JFace color registry.
      # 
      # @param foregroundColorName
      # the color name for the foreground color
      # @param backgroundColorName
      # the color name for the background color
      # 
      # @return the created style
      def create_color_registry_styler(foreground_color_name, background_color_name)
        return DefaultStyler.new(foreground_color_name, background_color_name)
      end
      
      const_set_lazy(:EMPTY) { Array.typed(StyleRange).new(0) { nil } }
      const_attr_reader  :EMPTY
    }
    
    attr_accessor :f_buffer
    alias_method :attr_f_buffer, :f_buffer
    undef_method :f_buffer
    alias_method :attr_f_buffer=, :f_buffer=
    undef_method :f_buffer=
    
    attr_accessor :f_style_runs
    alias_method :attr_f_style_runs, :f_style_runs
    undef_method :f_style_runs
    alias_method :attr_f_style_runs=, :f_style_runs=
    undef_method :f_style_runs=
    
    typesig { [] }
    # Creates an empty {@link StyledString}.
    def initialize
      @f_buffer = nil
      @f_style_runs = nil
      @f_buffer = StringBuffer.new
      @f_style_runs = nil
    end
    
    typesig { [String] }
    # Creates an {@link StyledString} initialized with a string without
    # a style associated.
    # 
    # @param string
    # the string
    def initialize(string)
      initialize__styled_string(string, nil)
    end
    
    typesig { [String, Styler] }
    # Creates an {@link StyledString} initialized with a string and a
    # style.
    # 
    # @param string
    # the string
    # @param styler
    # the styler for the string or <code>null</code> to not
    # associated a styler.
    def initialize(string, styler)
      initialize__styled_string()
      append(string, styler)
    end
    
    typesig { [] }
    # Returns the string of this {@link StyledString}.
    # 
    # @return the current string of this {@link StyledString}.
    def get_string
      return @f_buffer.to_s
    end
    
    typesig { [] }
    # Returns the string of this {@link StyledString}.
    # 
    # @return the current string of this {@link StyledString}.
    def to_s
      return get_string
    end
    
    typesig { [] }
    # Returns the length of the string of this {@link StyledString}.
    # 
    # @return the length of the current string
    def length
      return @f_buffer.length
    end
    
    typesig { [String] }
    # Appends a string to the {@link StyledString}. The appended string
    # will have no associated styler.
    # 
    # @param string
    # the string to append
    # @return returns a reference to this object
    def append(string)
      return append(string, nil)
    end
    
    typesig { [Array.typed(::Java::Char)] }
    # Appends the string representation of the given character array
    # to the {@link StyledString}. The appended
    # character array will have no associated styler.
    # 
    # @param chars
    # the character array to append
    # @return returns a reference to this object
    def append(chars)
      return append(chars, nil)
    end
    
    typesig { [::Java::Char] }
    # Appends the string representation of the given character
    # to the {@link StyledString}. The appended
    # character will have no associated styler.
    # 
    # @param ch
    # the character to append
    # @return returns a reference to this object
    def append(ch)
      return append(String.value_of(ch), nil)
    end
    
    typesig { [StyledString] }
    # Appends a string with styles to the {@link StyledString}.
    # 
    # @param string
    # the string to append
    # @return returns a reference to this object
    def append(string)
      if ((string.length).equal?(0))
        return self
      end
      offset = @f_buffer.length
      @f_buffer.append(string.to_s)
      other_runs = string.attr_f_style_runs
      if (!(other_runs).nil? && !other_runs.is_empty)
        i = 0
        while i < other_runs.size
          curr = other_runs.get(i)
          if ((i).equal?(0) && !(curr.attr_offset).equal?(0))
            append_style_run(nil, offset) # appended string will
            # start with the default
            # color
          end
          append_style_run(curr.attr_style, offset + curr.attr_offset)
          i += 1
        end
      else
        append_style_run(nil, offset) # appended string will start with
        # the default color
      end
      return self
    end
    
    typesig { [::Java::Char, Styler] }
    # Appends the string representation of the given character
    # with a style to the {@link StyledString}. The
    # appended character will have the given style associated.
    # 
    # @param ch
    # the character to append
    # @param styler
    # the styler to use for styling the character to append or
    # <code>null</code> if no styler should be associated with the
    # appended character
    # @return returns a reference to this object
    def append(ch, styler)
      return append(String.value_of(ch), styler)
    end
    
    typesig { [String, Styler] }
    # Appends a string with a style to the {@link StyledString}. The
    # appended string will be styled using the given styler.
    # 
    # @param string
    # the string to append
    # @param styler
    # the styler to use for styling the string to append or
    # <code>null</code> if no styler should be associated with the
    # appended string.
    # @return returns a reference to this object
    def append(string, styler)
      if ((string.length).equal?(0))
        return self
      end
      offset = @f_buffer.length # the length before appending
      @f_buffer.append(string)
      append_style_run(styler, offset)
      return self
    end
    
    typesig { [Array.typed(::Java::Char), Styler] }
    # Appends the string representation of the given character array
    # with a style to the {@link StyledString}. The
    # appended character array will be styled using the given styler.
    # 
    # @param chars
    # the character array to append
    # @param styler
    # the styler to use for styling the character array to append or
    # <code>null</code> if no styler should be associated with the
    # appended character array
    # @return returns a reference to this object
    def append(chars, styler)
      if ((chars.attr_length).equal?(0))
        return self
      end
      offset = @f_buffer.length # the length before appending
      @f_buffer.append(chars)
      append_style_run(styler, offset)
      return self
    end
    
    typesig { [::Java::Char, ::Java::Int] }
    # Inserts the character at the given offset. The inserted character will
    # get the styler that is already at the given offset.
    # 
    # @param ch
    # the character to insert
    # @param offset
    # the insertion index
    # @return returns a reference to this object
    # @throws StringIndexOutOfBoundsException
    # if <code>offset</code> is less than zero, or if <code>offset</code>
    # is greater than the length of this object
    # @since 3.5
    def insert(ch, offset)
      if (offset < 0 || offset > @f_buffer.length)
        raise StringIndexOutOfBoundsException.new("Invalid offset (" + RJava.cast_to_string(offset) + ")") # $NON-NLS-1$//$NON-NLS-2$
      end
      if (has_runs)
        run_index = find_run(offset)
        if (run_index < 0)
          run_index = -run_index - 1
        else
          run_index = run_index + 1
        end
        style_runs = get_style_runs
        size_ = style_runs.size
        i = run_index
        while i < size_
          run = style_runs.get_run(i)
          run.attr_offset += 1
          i += 1
        end
      end
      @f_buffer.insert(offset, ch)
      return self
    end
    
    typesig { [::Java::Int, ::Java::Int, Styler] }
    # Sets a styler to use for the given source range. The range must be
    # subrange of actual string of this {@link StyledString}. Stylers
    # previously set for that range will be overwritten.
    # 
    # @param offset
    # the start offset of the range
    # @param length
    # the length of the range
    # @param styler
    # the styler to set
    # 
    # @throws StringIndexOutOfBoundsException
    # if <code>start</code> is less than zero, or if offset plus
    # length is greater than the length of this object.
    def set_style(offset, length_, styler)
      if (offset < 0 || offset + length_ > @f_buffer.length)
        raise StringIndexOutOfBoundsException.new("Invalid offset (" + RJava.cast_to_string(offset) + ") or length (" + RJava.cast_to_string(length_) + ")") # $NON-NLS-1$//$NON-NLS-2$//$NON-NLS-3$
      end
      if ((length_).equal?(0))
        return
      end
      last_run = get_last_run
      if ((last_run).nil? || last_run.attr_offset <= offset)
        last_styler = (last_run).nil? ? nil : last_run.attr_style
        append_style_run(styler, offset)
        if (!(offset + length_).equal?(@f_buffer.length))
          append_style_run(last_styler, offset + length_)
        end
        return
      end
      end_run = find_run(offset + length_)
      if (end_run >= 0)
        # run with the same end index, nothing to change
      else
        end_run = -(end_run + 1)
        if (offset + length_ < @f_buffer.length)
          prev_style = end_run > 0 ? @f_style_runs.get_run(end_run - 1).attr_style : nil
          @f_style_runs.add(end_run, StyleRun.new(offset + length_, prev_style))
        end
      end
      start_run = find_run(offset)
      if (start_run >= 0)
        # run with the same start index
        style_run = @f_style_runs.get_run(start_run)
        style_run.attr_style = styler
      else
        start_run = -(start_run + 1)
        prev_style = start_run > 0 ? @f_style_runs.get_run(start_run - 1).attr_style : nil
        if (is_different_style(prev_style, styler) || ((start_run).equal?(0) && !(styler).nil?))
          @f_style_runs.add(start_run, StyleRun.new(offset, styler))
          end_run += 1 # endrun is moved one back
        else
          start_run -= 1 # we use the previous
        end
      end
      if (start_run + 1 < end_run)
        @f_style_runs.remove_range(start_run + 1, end_run)
      end
    end
    
    typesig { [] }
    # Returns an array of {@link StyleRange} resulting from applying all
    # associated stylers for this string builder.
    # 
    # @return an array of all {@link StyleRange} resulting from applying the
    # stored stylers to this string.
    def get_style_ranges
      if (has_runs)
        res = ArrayList.new
        style_runs = get_style_runs
        offset = 0
        style = nil
        i = 0
        while i < style_runs.size
          curr = style_runs.get(i)
          if (is_different_style(curr.attr_style, style))
            if (curr.attr_offset > offset && !(style).nil?)
              res.add(create_style_range(offset, curr.attr_offset, style))
            end
            offset = curr.attr_offset
            style = curr.attr_style
          end
          i += 1
        end
        if (@f_buffer.length > offset && !(style).nil?)
          res.add(create_style_range(offset, @f_buffer.length, style))
        end
        return res.to_array(Array.typed(StyleRange).new(res.size) { nil })
      end
      return EMPTY
    end
    
    typesig { [::Java::Int] }
    def find_run(offset)
      # method assumes that fStyleRuns is not null
      low = 0
      high = @f_style_runs.size - 1
      while (low <= high)
        mid = (low + high) / 2
        style_run = @f_style_runs.get_run(mid)
        if (style_run.attr_offset < offset)
          low = mid + 1
        else
          if (style_run.attr_offset > offset)
            high = mid - 1
          else
            return mid # key found
          end
        end
      end
      return -(low + 1) # key not found.
    end
    
    typesig { [::Java::Int, ::Java::Int, Styler] }
    def create_style_range(start, end_, style)
      style_range = StyleRange.new
      style_range.attr_start = start
      style_range.attr_length = end_ - start
      style.apply_styles(style_range)
      return style_range
    end
    
    typesig { [] }
    def has_runs
      return !(@f_style_runs).nil? && !@f_style_runs.is_empty
    end
    
    typesig { [Styler, ::Java::Int] }
    def append_style_run(style, offset)
      last_run = get_last_run
      if (!(last_run).nil? && (last_run.attr_offset).equal?(offset))
        last_run.attr_style = style
        return
      end
      if ((last_run).nil? && !(style).nil? || !(last_run).nil? && is_different_style(style, last_run.attr_style))
        get_style_runs.add(StyleRun.new(offset, style))
      end
    end
    
    typesig { [Styler, Styler] }
    def is_different_style(style1, style2)
      if ((style1).nil?)
        return !(style2).nil?
      end
      return !(style1 == style2)
    end
    
    typesig { [] }
    def get_last_run
      if ((@f_style_runs).nil? || @f_style_runs.is_empty)
        return nil
      end
      return @f_style_runs.get_run(@f_style_runs.size - 1)
    end
    
    typesig { [] }
    def get_style_runs
      if ((@f_style_runs).nil?)
        @f_style_runs = StyleRunList.new
      end
      return @f_style_runs
    end
    
    class_module.module_eval {
      const_set_lazy(:StyleRun) { Class.new do
        include_class_members StyledString
        
        attr_accessor :offset
        alias_method :attr_offset, :offset
        undef_method :offset
        alias_method :attr_offset=, :offset=
        undef_method :offset=
        
        attr_accessor :style
        alias_method :attr_style, :style
        undef_method :style
        alias_method :attr_style=, :style=
        undef_method :style=
        
        typesig { [::Java::Int, class_self::Styler] }
        def initialize(offset, style)
          @offset = 0
          @style = nil
          @offset = offset
          @style = style
        end
        
        typesig { [] }
        def to_s
          return "Offset " + RJava.cast_to_string(@offset) + ", style: " + RJava.cast_to_string(@style) # $NON-NLS-1$//$NON-NLS-2$
        end
        
        private
        alias_method :initialize__style_run, :initialize
      end }
      
      const_set_lazy(:StyleRunList) { Class.new(ArrayList) do
        include_class_members StyledString
        
        class_module.module_eval {
          const_set_lazy(:SerialVersionUID) { 123 }
          const_attr_reader  :SerialVersionUID
        }
        
        typesig { [] }
        def initialize
          super(3)
        end
        
        typesig { [::Java::Int] }
        def get_run(index)
          return get(index)
        end
        
        typesig { [::Java::Int, ::Java::Int] }
        def remove_range(from_index, to_index)
          super(from_index, to_index)
        end
        
        private
        alias_method :initialize__style_run_list, :initialize
      end }
      
      const_set_lazy(:DefaultStyler) { Class.new(Styler) do
        include_class_members StyledString
        
        attr_accessor :f_foreground_color_name
        alias_method :attr_f_foreground_color_name, :f_foreground_color_name
        undef_method :f_foreground_color_name
        alias_method :attr_f_foreground_color_name=, :f_foreground_color_name=
        undef_method :f_foreground_color_name=
        
        attr_accessor :f_background_color_name
        alias_method :attr_f_background_color_name, :f_background_color_name
        undef_method :f_background_color_name
        alias_method :attr_f_background_color_name=, :f_background_color_name=
        undef_method :f_background_color_name=
        
        typesig { [String, String] }
        def initialize(foreground_color_name, background_color_name)
          @f_foreground_color_name = nil
          @f_background_color_name = nil
          super()
          @f_foreground_color_name = foreground_color_name
          @f_background_color_name = background_color_name
        end
        
        typesig { [class_self::TextStyle] }
        def apply_styles(text_style)
          color_registry = JFaceResources.get_color_registry
          if (!(@f_foreground_color_name).nil?)
            text_style.attr_foreground = color_registry.get(@f_foreground_color_name)
          end
          if (!(@f_background_color_name).nil?)
            text_style.attr_background = color_registry.get(@f_background_color_name)
          end
        end
        
        private
        alias_method :initialize__default_styler, :initialize
      end }
    }
    
    private
    alias_method :initialize__styled_string, :initialize
  end
  
end
