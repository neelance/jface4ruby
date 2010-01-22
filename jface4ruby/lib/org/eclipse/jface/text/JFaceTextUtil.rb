require "rjava"

# Copyright (c) 2006, 2009 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
# Tom Eicher (Avaloq Evolution AG) - block selection mode
module Org::Eclipse::Jface::Text
  module JFaceTextUtilImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
      include_const ::Org::Eclipse::Swt::Custom, :StyledText
      include_const ::Org::Eclipse::Swt::Graphics, :SwtGC
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Graphics, :Rectangle
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Display
      include_const ::Org::Eclipse::Jface::Internal::Text, :SelectionProcessor
      include_const ::Org::Eclipse::Jface::Text::Source, :ILineRange
      include_const ::Org::Eclipse::Jface::Text::Source, :LineRange
    }
  end
  
  # A collection of JFace Text functions.
  # <p>
  # This class is neither intended to be instantiated nor subclassed.
  # </p>
  # 
  # @since 3.3
  # @noinstantiate This class is not intended to be instantiated by clients.
  class JFaceTextUtil 
    include_class_members JFaceTextUtilImports
    
    typesig { [] }
    def initialize
      # Do not instantiate
    end
    
    class_module.module_eval {
      typesig { [StyledText, ::Java::Int, ::Java::Int, ::Java::Int] }
      # Computes the line height for the given line range.
      # 
      # @param textWidget the <code>StyledText</code> widget
      # @param startLine the start line
      # @param endLine the end line (exclusive)
      # @param lineCount the line count used by the old API
      # @return the height of all lines starting with <code>startLine</code> and ending above <code>endLime</code>
      def compute_line_height(text_widget, start_line, end_line, line_count)
        return get_line_pixel(text_widget, end_line) - get_line_pixel(text_widget, start_line)
      end
      
      typesig { [StyledText] }
      # Returns the last fully visible line of the widget. The exact semantics of "last fully visible
      # line" are:
      # <ul>
      # <li>the last line of which the last pixel is visible, if any
      # <li>otherwise, the only line that is partially visible
      # </ul>
      # 
      # @param widget the widget
      # @return the last fully visible line
      def get_bottom_index(widget)
        last_pixel = compute_last_visible_pixel(widget)
        # bottom is in [0 .. lineCount - 1]
        bottom = widget.get_line_index(last_pixel)
        # bottom is the first line - no more checking
        if ((bottom).equal?(0))
          return bottom
        end
        pixel = widget.get_line_pixel(bottom)
        # bottom starts on or before the client area start - bottom is the only visible line
        if (pixel <= 0)
          return bottom
        end
        offset = widget.get_offset_at_line(bottom)
        height = widget.get_line_height(offset)
        # bottom is not showing entirely - use the previous line
        if (pixel + height - 1 > last_pixel)
          return bottom - 1
        end
        # bottom is fully visible and its last line is exactly the last pixel
        return bottom
      end
      
      typesig { [StyledText] }
      # Returns the index of the first (possibly only partially) visible line of the widget
      # 
      # @param widget the widget
      # @return the index of the first line of which a pixel is visible
      def get_partial_top_index(widget)
        # see StyledText#getPartialTopIndex()
        top = widget.get_top_index
        pixels = widget.get_line_pixel(top)
        # FIXME remove when https://bugs.eclipse.org/bugs/show_bug.cgi?id=123770 is fixed
        if ((pixels).equal?(-widget.get_line_height(widget.get_offset_at_line(top))))
          top += 1
          pixels = 0
        end
        if (pixels > 0)
          top -= 1
        end
        return top
      end
      
      typesig { [StyledText] }
      # Returns the index of the last (possibly only partially) visible line of the widget
      # 
      # @param widget the text widget
      # @return the index of the last line of which a pixel is visible
      def get_partial_bottom_index(widget)
        # @see StyledText#getPartialBottomIndex()
        last_pixel = compute_last_visible_pixel(widget)
        bottom = widget.get_line_index(last_pixel)
        return bottom
      end
      
      typesig { [StyledText] }
      # Returns the last visible pixel in the widget's client area.
      # 
      # @param widget the widget
      # @return the last visible pixel in the widget's client area
      def compute_last_visible_pixel(widget)
        ca_height = widget.get_client_area.attr_height
        last_pixel = ca_height - 1
        # XXX: what if there is a margin? can't take trim as this includes the scrollbars which are not part of the client area
        # if ((textWidget.getStyle() & SWT.BORDER) != 0)
        # lastPixel -= 4;
        return last_pixel
      end
      
      typesig { [ITextViewer] }
      # Returns the line index of the first visible model line in the viewer. The line may be only
      # partially visible.
      # 
      # @param viewer the text viewer
      # @return the first line of which a pixel is visible, or -1 for no line
      def get_partial_top_index(viewer)
        widget = viewer.get_text_widget
        widget_top = get_partial_top_index(widget)
        return widget_line2model_line(viewer, widget_top)
      end
      
      typesig { [ITextViewer] }
      # Returns the last, possibly partially, visible line in the view port.
      # 
      # @param viewer the text viewer
      # @return the last, possibly partially, visible line in the view port
      def get_partial_bottom_index(viewer)
        text_widget = viewer.get_text_widget
        widget_bottom = get_partial_bottom_index(text_widget)
        return widget_line2model_line(viewer, widget_bottom)
      end
      
      typesig { [ITextViewer] }
      # Returns the range of lines that is visible in the viewer, including any partially visible
      # lines.
      # 
      # @param viewer the viewer
      # @return the range of lines that is visible in the viewer, <code>null</code> if no lines are
      # visible
      def get_visible_model_lines(viewer)
        top = get_partial_top_index(viewer)
        bottom = get_partial_bottom_index(viewer)
        if ((top).equal?(-1) || (bottom).equal?(-1))
          return nil
        end
        return LineRange.new(top, bottom - top + 1)
      end
      
      typesig { [ITextViewer, ::Java::Int] }
      # Converts a widget line into a model (i.e. {@link IDocument}) line using the
      # {@link ITextViewerExtension5} if available, otherwise by adapting the widget line to the
      # viewer's {@link ITextViewer#getVisibleRegion() visible region}.
      # 
      # @param viewer the viewer
      # @param widgetLine the widget line to convert.
      # @return the model line corresponding to <code>widgetLine</code> or -1 to signal that there
      # is no corresponding model line
      def widget_line2model_line(viewer, widget_line)
        model_line = 0
        if (viewer.is_a?(ITextViewerExtension5))
          extension = viewer
          model_line = extension.widget_line2model_line(widget_line)
        else
          begin
            r = viewer.get_visible_region
            d = viewer.get_document
            model_line = widget_line + d.get_line_of_offset(r.get_offset)
          rescue BadLocationException => x
            model_line = widget_line
          end
        end
        return model_line
      end
      
      typesig { [ITextViewer, ::Java::Int] }
      # Converts a model (i.e. {@link IDocument}) line into a widget line using the
      # {@link ITextViewerExtension5} if available, otherwise by adapting the model line to the
      # viewer's {@link ITextViewer#getVisibleRegion() visible region}.
      # 
      # @param viewer the viewer
      # @param modelLine the model line to convert.
      # @return the widget line corresponding to <code>modelLine</code> or -1 to signal that there
      # is no corresponding widget line
      def model_line_to_widget_line(viewer, model_line)
        widget_line = 0
        if (viewer.is_a?(ITextViewerExtension5))
          extension = viewer
          widget_line = extension.model_line2widget_line(model_line)
        else
          region = viewer.get_visible_region
          document = viewer.get_document
          begin
            visible_start_line = document.get_line_of_offset(region.get_offset)
            visible_end_line = document.get_line_of_offset(region.get_offset + region.get_length)
            if (model_line < visible_start_line || model_line > visible_end_line)
              widget_line = -1
            else
              widget_line = model_line - visible_start_line
            end
          rescue BadLocationException => x
            # ignore and return -1
            widget_line = -1
          end
        end
        return widget_line
      end
      
      typesig { [StyledText] }
      # Returns the number of hidden pixels of the first partially visible line. If there is no
      # partially visible line, zero is returned.
      # 
      # @param textWidget the widget
      # @return the number of hidden pixels of the first partial line, always &gt;= 0
      def get_hidden_top_line_pixels(text_widget)
        top = get_partial_top_index(text_widget)
        return -text_widget.get_line_pixel(top)
      end
      
      typesig { [StyledText, ::Java::Int] }
      # @see StyledText#getLinePixel(int)
      def get_line_pixel(text_widget, line)
        return text_widget.get_line_pixel(line)
      end
      
      typesig { [StyledText, ::Java::Int] }
      # @see StyledText#getLineIndex(int)
      def get_line_index(text_widget, y)
        line_index = text_widget.get_line_index(y)
        return line_index
      end
      
      typesig { [StyledText] }
      # Returns <code>true</code> if the widget displays the entire contents, i.e. it cannot
      # be vertically scrolled.
      # 
      # @param widget the widget
      # @return <code>true</code> if the widget displays the entire contents, i.e. it cannot
      # be vertically scrolled, <code>false</code> otherwise
      def is_showing_entire_contents(widget)
        if (!(widget.get_top_pixel).equal?(0))
          # more efficient shortcut
          return false
        end
        last_visible_pixel = compute_last_visible_pixel(widget)
        last_possible_pixel = widget.get_line_pixel(widget.get_line_count)
        return last_possible_pixel <= last_visible_pixel
      end
      
      typesig { [IRegion, ITextViewer] }
      # Determines the graphical area covered by the given text region in
      # the given viewer.
      # 
      # @param region the region whose graphical extend must be computed
      # @param textViewer the text viewer containing the region
      # @return the graphical extend of the given region in the given viewer
      # 
      # @since 3.4
      def compute_area(region, text_viewer)
        start = 0
        end_ = 0
        widget_region = model_range2widget_range(region, text_viewer)
        if (!(widget_region).nil?)
          start = widget_region.get_offset
          end_ = start + widget_region.get_length
        end
        styled_text = text_viewer.get_text_widget
        bounds = nil
        if (end_ > 0 && start < end_)
          bounds = styled_text.get_text_bounds(start, end_ - 1)
        else
          loc = styled_text.get_location_at_offset(start)
          bounds = Rectangle.new(loc.attr_x, loc.attr_y, get_average_char_width(text_viewer.get_text_widget), styled_text.get_line_height(start))
        end
        return Rectangle.new(bounds.attr_x, bounds.attr_y, bounds.attr_width, bounds.attr_height)
      end
      
      typesig { [IRegion, ITextViewer] }
      # Translates a given region of the text viewer's document into
      # the corresponding region of the viewer's widget.
      # 
      # @param region the document region
      # @param textViewer the viewer containing the region
      # @return the corresponding widget region
      # 
      # @since 3.4
      def model_range2widget_range(region, text_viewer)
        if (text_viewer.is_a?(ITextViewerExtension5))
          extension = text_viewer
          return extension.model_range2widget_range(region)
        end
        visible_region = text_viewer.get_visible_region
        start = region.get_offset - visible_region.get_offset
        end_ = start + region.get_length
        if (end_ > visible_region.get_length)
          end_ = visible_region.get_length
        end
        return Region.new(start, end_ - start)
      end
      
      typesig { [Control] }
      # Returns the average character width of the given control's font.
      # 
      # @param control the control to calculate the average char width for
      # @return the average character width of the controls font
      # 
      # @since 3.4
      def get_average_char_width(control)
        gc = SwtGC.new(control)
        gc.set_font(control.get_font)
        increment = gc.get_font_metrics.get_average_char_width
        gc.dispose
        return increment
      end
      
      typesig { [ITextViewer, ITextSelection] }
      # Returns <code>true</code> if the text covered by <code>selection</code> does not contain any
      # characters in the given viewer. Note the difference to {@link ITextSelection#isEmpty()},
      # which returns <code>true</code> only for invalid selections.
      # 
      # @param viewer the viewer
      # @param selection the selection
      # @return <code>true</code> if <code>selection</code> does not contain any text,
      # <code>false</code> otherwise
      # @throws BadLocationException if accessing the document failed
      # @since 3.5
      def is_empty(viewer, selection)
        return SelectionProcessor.new(viewer).is_empty(selection)
      end
      
      typesig { [ITextViewer, ITextSelection] }
      # Returns the text regions covered by the given selection in the given viewer.
      # 
      # @param viewer the viewer
      # @param selection the selection
      # @return the text regions corresponding to <code>selection</code>
      # @throws BadLocationException if accessing the document failed
      # @since 3.5
      def get_covered_ranges(viewer, selection)
        return SelectionProcessor.new(viewer).get_ranges(selection)
      end
      
      typesig { [ITextViewer] }
      # Returns the offset in the given viewer that corresponds to the current cursor location.
      # 
      # @param viewer the viewer
      # @return the offset for the current cursor location or -1 if not available
      # @since 3.5
      def get_offset_for_cursor_location(viewer)
        begin
          text = viewer.get_text_widget
          if ((text).nil? || text.is_disposed)
            return -1
          end
          display = text.get_display
          absolute_position = display.get_cursor_location
          relative_position = text.to_control(absolute_position)
          widget_offset = text.get_offset_at_location(relative_position)
          p = text.get_location_at_offset(widget_offset)
          if (p.attr_x > relative_position.attr_x)
            widget_offset -= 1
          end
          if (viewer.is_a?(ITextViewerExtension5))
            extension = viewer
            return extension.widget_offset2model_offset(widget_offset)
          end
          return widget_offset + viewer.get_visible_region.get_offset
        rescue IllegalArgumentException => e
          return -1
        end
      end
    }
    
    private
    alias_method :initialize__jface_text_util, :initialize
  end
  
end
