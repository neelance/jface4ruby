require "rjava"

# Copyright (c) 2007, 2009 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
# Michael Krkoska - initial API and implementation (bug 188333)
module Org::Eclipse::Jface::Viewers
  module StyledCellLabelProviderImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Custom, :StyleRange
      include_const ::Org::Eclipse::Swt::Graphics, :Color
      include_const ::Org::Eclipse::Swt::Graphics, :SwtGC
      include_const ::Org::Eclipse::Swt::Graphics, :Image
      include_const ::Org::Eclipse::Swt::Graphics, :Rectangle
      include_const ::Org::Eclipse::Swt::Graphics, :TextLayout
      include_const ::Org::Eclipse::Swt::Widgets, :Display
      include_const ::Org::Eclipse::Swt::Widgets, :Event
      include_const ::Org::Eclipse::Swt::Widgets, :Widget
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Jface::Viewers::StyledString, :Styler
    }
  end
  
  # A {@link StyledCellLabelProvider} supports styled labels by using owner
  # draw.
  # Besides the styles in labels, the label provider preserves native viewer behavior:
  # <ul>
  # <li>similar image and label positioning</li>
  # <li>native drawing of focus and selection</li>
  # </ul>
  # <p>
  # For providing the label's styles, create a subclass and overwrite
  # {@link StyledCellLabelProvider#update(ViewerCell)} to
  # return set all information needed to render a element. Use
  # {@link ViewerCell#setStyleRanges(StyleRange[])} to set style ranges
  # on the label.
  # </p>
  # 
  # @since 3.4
  class StyledCellLabelProvider < StyledCellLabelProviderImports.const_get :OwnerDrawLabelProvider
    include_class_members StyledCellLabelProviderImports
    
    class_module.module_eval {
      # Style constant for indicating that the styled colors are to be applied
      # even it the viewer's item is selected. Default is not to apply colors.
      const_set_lazy(:COLORS_ON_SELECTION) { 1 << 0 }
      const_attr_reader  :COLORS_ON_SELECTION
      
      # Style constant for indicating to draw the focus if requested by the owner
      # draw event. Default is to draw the focus.
      const_set_lazy(:NO_FOCUS) { 1 << 1 }
      const_attr_reader  :NO_FOCUS
      
      # Private constant to indicate if owner draw is enabled for the
      # label provider's column.
      const_set_lazy(:OWNER_DRAW_ENABLED) { 1 << 4 }
      const_attr_reader  :OWNER_DRAW_ENABLED
    }
    
    attr_accessor :style
    alias_method :attr_style, :style
    undef_method :style
    alias_method :attr_style=, :style=
    undef_method :style=
    
    # reused text layout
    attr_accessor :cached_text_layout
    alias_method :attr_cached_text_layout, :cached_text_layout
    undef_method :cached_text_layout
    alias_method :attr_cached_text_layout=, :cached_text_layout=
    undef_method :cached_text_layout=
    
    attr_accessor :viewer
    alias_method :attr_viewer, :viewer
    undef_method :viewer
    alias_method :attr_viewer=, :viewer=
    undef_method :viewer=
    
    attr_accessor :column
    alias_method :attr_column, :column
    undef_method :column
    alias_method :attr_column=, :column=
    undef_method :column=
    
    attr_accessor :item_of_last_measure
    alias_method :attr_item_of_last_measure, :item_of_last_measure
    undef_method :item_of_last_measure
    alias_method :attr_item_of_last_measure=, :item_of_last_measure=
    undef_method :item_of_last_measure=
    
    attr_accessor :element_of_last_measure
    alias_method :attr_element_of_last_measure, :element_of_last_measure
    undef_method :element_of_last_measure
    alias_method :attr_element_of_last_measure=, :element_of_last_measure=
    undef_method :element_of_last_measure=
    
    attr_accessor :delta_of_last_measure
    alias_method :attr_delta_of_last_measure, :delta_of_last_measure
    undef_method :delta_of_last_measure
    alias_method :attr_delta_of_last_measure=, :delta_of_last_measure=
    undef_method :delta_of_last_measure=
    
    typesig { [] }
    # Creates a new StyledCellLabelProvider. By default, owner draw is enabled, focus is drawn and no
    # colors are painted on selected elements.
    def initialize
      initialize__styled_cell_label_provider(0)
    end
    
    typesig { [::Java::Int] }
    # Creates a new StyledCellLabelProvider. By default, owner draw is enabled.
    # 
    # @param style
    # the style bits
    # @see StyledCellLabelProvider#COLORS_ON_SELECTION
    # @see StyledCellLabelProvider#NO_FOCUS
    def initialize(style)
      @style = 0
      @cached_text_layout = nil
      @viewer = nil
      @column = nil
      @item_of_last_measure = nil
      @element_of_last_measure = nil
      @delta_of_last_measure = 0
      super()
      @style = style & (COLORS_ON_SELECTION | NO_FOCUS) | OWNER_DRAW_ENABLED
    end
    
    typesig { [] }
    # Returns <code>true</code> is the owner draw rendering is enabled for this label provider.
    # By default owner draw rendering is enabled. If owner draw rendering is disabled, rending is
    # done by the viewer and no styled ranges (see {@link ViewerCell#getStyleRanges()})
    # are drawn.
    # 
    # @return <code>true</code> is the rendering of styles is enabled.
    def is_owner_draw_enabled
      return !((@style & OWNER_DRAW_ENABLED)).equal?(0)
    end
    
    typesig { [::Java::Boolean] }
    # Specifies whether owner draw rendering is enabled for this label
    # provider. By default owner draw rendering is enabled. If owner draw
    # rendering is disabled, rendering is done by the viewer and no styled
    # ranges (see {@link ViewerCell#getStyleRanges()}) are drawn.
    # It is the caller's responsibility to also call
    # {@link StructuredViewer#refresh()} or similar methods to update the
    # underlying widget.
    # 
    # @param enabled
    # specifies if owner draw rendering is enabled
    def set_owner_draw_enabled(enabled)
      is_enabled = is_owner_draw_enabled
      if (!(is_enabled).equal?(enabled))
        if (enabled)
          @style |= OWNER_DRAW_ENABLED
        else
          @style &= ~OWNER_DRAW_ENABLED
        end
        if (!(@viewer).nil?)
          set_owner_draw_enabled(@viewer, @column, enabled)
        end
      end
    end
    
    typesig { [] }
    # Returns the viewer on which this label provider is installed on or <code>null</code> if the
    # label provider is not installed.
    # 
    # @return the viewer on which this label provider is installed on or <code>null</code> if the
    # label provider is not installed.
    def get_viewer
      return @viewer
    end
    
    typesig { [] }
    # Returns the column on which this label provider is installed on or <code>null</code> if the
    # label provider is not installed.
    # 
    # @return the column on which this label provider is installed on or <code>null</code> if the
    # label provider is not installed.
    def get_column
      return @column
    end
    
    typesig { [ColumnViewer, ViewerColumn] }
    # (non-Javadoc)
    # @see org.eclipse.jface.viewers.OwnerDrawLabelProvider#initialize(org.eclipse.jface.viewers.ColumnViewer, org.eclipse.jface.viewers.ViewerColumn)
    def initialize_(viewer, column)
      Assert.is_true((@viewer).nil? && (@column).nil?, "Label provider instance already in use") # $NON-NLS-1$
      @viewer = viewer
      @column = column
      super(viewer, column, is_owner_draw_enabled)
    end
    
    typesig { [] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.viewers.BaseLabelProvider#dispose()
    def dispose
      if (!(@cached_text_layout).nil?)
        @cached_text_layout.dispose
        @cached_text_layout = nil
      end
      @viewer = nil
      @column = nil
      @item_of_last_measure = nil
      @element_of_last_measure = nil
      super
    end
    
    typesig { [ViewerCell] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.viewers.OwnerDrawLabelProvider#update(org.eclipse.jface.viewers.ViewerCell)
    def update(cell)
      # clients must override and configure the cell and call super
      super(cell) # calls 'repaint' to trigger the paint listener
    end
    
    typesig { [Display] }
    def get_shared_text_layout(display)
      if ((@cached_text_layout).nil?)
        orientation = @viewer.get_control.get_style & (SWT::LEFT_TO_RIGHT | SWT::RIGHT_TO_LEFT)
        @cached_text_layout = TextLayout.new(display)
        @cached_text_layout.set_orientation(orientation)
      end
      return @cached_text_layout
    end
    
    typesig { [Event] }
    def use_colors(event)
      return ((event.attr_detail & SWT::SELECTED)).equal?(0) || !((@style & COLORS_ON_SELECTION)).equal?(0)
    end
    
    typesig { [Event] }
    def draw_focus(event)
      return !((event.attr_detail & SWT::FOCUSED)).equal?(0) && ((@style & NO_FOCUS)).equal?(0)
    end
    
    typesig { [StyleRange, ::Java::Boolean] }
    # Prepares the given style range before it is applied to the label. This method makes sure that
    # no colors are drawn when the element is selected.
    # The current version of the {@link StyledCellLabelProvider} will also ignore all font settings on the
    # style range. Clients can override.
    # 
    # @param styleRange
    # the style range to prepare. the style range element must not be modified
    # @param applyColors
    # specifies if colors should be applied.
    # @return
    # returns the style range to use on the label
    def prepare_style_range(style_range, apply_colors)
      # if no colors apply or font is set, create a clone and clear the
      # colors and font
      if (!apply_colors && (!(style_range.attr_foreground).nil? || !(style_range.attr_background).nil?))
        style_range = style_range.clone
        if (!apply_colors)
          style_range.attr_foreground = nil
          style_range.attr_background = nil
        end
      end
      return style_range
    end
    
    typesig { [Event, Object] }
    def get_viewer_cell(event, element)
      row = @viewer.get_viewer_row_from_item(event.attr_item)
      return ViewerCell.new(row, event.attr_index, element)
    end
    
    typesig { [Event, Object] }
    # Handle the erase event. The default implementation does nothing to ensure
    # keep native selection highlighting working.
    # 
    # @param event
    # the erase event
    # @param element
    # the model object
    # @see SWT#EraseItem
    def erase(event, element)
      # use native erase
      if (is_owner_draw_enabled)
        # info has been set by 'update': announce that we paint ourselves
        event.attr_detail &= ~SWT::FOREGROUND
      end
    end
    
    typesig { [Event, Object] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.viewers.OwnerDrawLabelProvider#measure(org.eclipse.swt.widgets.Event,
    # java.lang.Object)
    def measure(event, element)
      if (!is_owner_draw_enabled)
        return
      end
      cell = get_viewer_cell(event, element)
      apply_colors = use_colors(event) # returns false because of bug 228376
      layout = get_shared_text_layout(event.attr_display)
      text_width_delta = @delta_of_last_measure = update_text_layout(layout, cell, apply_colors)
      # remove-begin if bug 228695 fixed
      @item_of_last_measure = event.attr_item
      @element_of_last_measure = event.attr_item.get_data
      # remove-end if bug 228695 fixed
      event.attr_width += text_width_delta
    end
    
    typesig { [TextLayout, ViewerCell, ::Java::Boolean] }
    # @param layout
    # @param cell
    # @param applyColors
    # @return the text width delta (0 if the text layout contains no other font)
    def update_text_layout(layout, cell, apply_colors)
      layout.set_text("") # $NON-NLS-1$  //make sure all previous ranges are cleared (see bug 226090)
      layout.set_text(cell.get_text)
      layout.set_font(cell.get_font) # set also if null to clear previous usages
      original_text_width = layout.get_bounds.attr_width # text width without any styles
      contains_other_font = false
      style_ranges = cell.get_style_ranges
      if (!(style_ranges).nil?)
        # user didn't fill styled ranges
        i = 0
        while i < style_ranges.attr_length
          curr = prepare_style_range(style_ranges[i], apply_colors)
          layout.set_style(curr, curr.attr_start, curr.attr_start + curr.attr_length - 1)
          if (!(curr.attr_font).nil?)
            contains_other_font = true
          end
          i += 1
        end
      end
      text_width_delta = 0
      if (contains_other_font)
        text_width_delta = layout.get_bounds.attr_width - original_text_width
      end
      return text_width_delta
    end
    
    typesig { [Event, Object] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.viewers.OwnerDrawLabelProvider#paint(org.eclipse.swt.widgets.Event,
    # java.lang.Object)
    def paint(event, element)
      if (!is_owner_draw_enabled)
        return
      end
      cell = get_viewer_cell(event, element)
      apply_colors = use_colors(event)
      gc = event.attr_gc
      # remember colors to restore the GC later
      old_foreground = gc.get_foreground
      old_background = gc.get_background
      if (apply_colors)
        foreground = cell.get_foreground
        if (!(foreground).nil?)
          gc.set_foreground(foreground)
        end
        background = cell.get_background
        if (!(background).nil?)
          gc.set_background(background)
        end
      end
      image = cell.get_image
      if (!(image).nil?)
        image_bounds = cell.get_image_bounds
        if (!(image_bounds).nil?)
          bounds = image.get_bounds
          # center the image in the given space
          x = image_bounds.attr_x + Math.max(0, (image_bounds.attr_width - bounds.attr_width) / 2)
          y = image_bounds.attr_y + Math.max(0, (image_bounds.attr_height - bounds.attr_height) / 2)
          gc.draw_image(image, x, y)
        end
      end
      text_bounds = cell.get_text_bounds
      if (!(text_bounds).nil?)
        text_layout = get_shared_text_layout(event.attr_display)
        # remove-begin if bug 228695 fixed
#        if (!(event.attr_item).equal?(@item_of_last_measure) || !(event.attr_item.get_data).equal?(@element_of_last_measure))
          # fLayout has not been configured in 'measure()'
          @delta_of_last_measure = update_text_layout(text_layout, cell, apply_colors)
          @item_of_last_measure = event.attr_item
          @element_of_last_measure = event.attr_item.get_data
#        end
        # remove-end if bug 228695 fixed
        # remove-begin if bug 228376 fixed
        if (!apply_colors)
          # need to remove colors for selected elements: measure doesn't provide that information, see bug 228376
          style_ranges = cell.get_style_ranges
          if (!(style_ranges).nil?)
            i = 0
            while i < style_ranges.attr_length
              curr = prepare_style_range(style_ranges[i], apply_colors)
              text_layout.set_style(curr, curr.attr_start, curr.attr_start + curr.attr_length - 1)
              i += 1
            end
          end
        end
        # remove-end if bug 228376 fixed
        layout_bounds = text_layout.get_bounds
        x = text_bounds.attr_x
        y = text_bounds.attr_y + Math.max(0, (text_bounds.attr_height - layout_bounds.attr_height) / 2)
        text_layout.draw(gc, x, y)
      end
      if (draw_focus(event))
        focus_bounds = cell.get_viewer_row.get_bounds
        gc.draw_focus(focus_bounds.attr_x, focus_bounds.attr_y, focus_bounds.attr_width + @delta_of_last_measure, focus_bounds.attr_height)
      end
      if (apply_colors)
        gc.set_foreground(old_foreground)
        gc.set_background(old_background)
      end
    end
    
    class_module.module_eval {
      typesig { [String, Styler, StyledString] }
      # Applies decoration styles to the decorated string and adds the styles of the previously
      # undecorated string.
      # <p>
      # If the <code>decoratedString</code> contains the <code>styledString</code>, then the result
      # keeps the styles of the <code>styledString</code> and styles the decorations with the
      # <code>decorationStyler</code>. Otherwise, the decorated string is returned without any
      # styles.
      # 
      # @param decoratedString the decorated string
      # @param decorationStyler the styler to use for the decoration or <code>null</code> for no
      # styles
      # @param styledString the original styled string
      # 
      # @return the styled decorated string (can be the given <code>styledString</code>)
      # @since 3.5
      def style_decorated_string(decorated_string, decoration_styler, styled_string)
        label = styled_string.get_string
        original_start = decorated_string.index_of(label)
        if ((original_start).equal?(-1))
          return StyledString.new(decorated_string) # the decorator did something wild
        end
        if ((decorated_string.length).equal?(label.length))
          return styled_string
        end
        if (original_start > 0)
          new_string = StyledString.new(decorated_string.substring(0, original_start), decoration_styler)
          new_string.append(styled_string)
          styled_string = new_string
        end
        if (decorated_string.length > original_start + label.length)
          # decorator appended something
          return styled_string.append(decorated_string.substring(original_start + label.length), decoration_styler)
        end
        return styled_string # no change
      end
    }
    
    private
    alias_method :initialize__styled_cell_label_provider, :initialize
  end
  
end
