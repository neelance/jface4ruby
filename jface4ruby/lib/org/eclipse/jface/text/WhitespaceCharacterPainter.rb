require "rjava"

# Copyright (c) 2006, 2009 Wind River Systems, Inc., IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# Anton Leherbauer (Wind River Systems) - initial API and implementation - https://bugs.eclipse.org/bugs/show_bug.cgi?id=22712
# Anton Leherbauer (Wind River Systems) - [painting] Long lines take too long to display when "Show Whitespace Characters" is enabled - https://bugs.eclipse.org/bugs/show_bug.cgi?id=196116
# Anton Leherbauer (Wind River Systems) - [painting] Whitespace characters not drawn when scrolling to right slowly - https://bugs.eclipse.org/bugs/show_bug.cgi?id=206633
# Tom Eicher (Avaloq Evolution AG) - block selection mode
module Org::Eclipse::Jface::Text
  module WhitespaceCharacterPainterImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
      include_const ::Org::Eclipse::Swt::Custom, :StyleRange
      include_const ::Org::Eclipse::Swt::Custom, :StyledText
      include_const ::Org::Eclipse::Swt::Custom, :StyledTextContent
      include_const ::Org::Eclipse::Swt::Events, :PaintEvent
      include_const ::Org::Eclipse::Swt::Events, :PaintListener
      include_const ::Org::Eclipse::Swt::Graphics, :Color
      include_const ::Org::Eclipse::Swt::Graphics, :FontMetrics
      include_const ::Org::Eclipse::Swt::Graphics, :SwtGC
      include_const ::Org::Eclipse::Swt::Graphics, :Point
    }
  end
  
  # A painter for drawing visible characters for (invisible) whitespace
  # characters.
  # 
  # @since 3.3
  class WhitespaceCharacterPainter 
    include_class_members WhitespaceCharacterPainterImports
    include IPainter
    include PaintListener
    
    class_module.module_eval {
      const_set_lazy(:SPACE_SIGN) { Character.new(0x00b7) }
      const_attr_reader  :SPACE_SIGN
      
      const_set_lazy(:IDEOGRAPHIC_SPACE_SIGN) { Character.new(0x00b0) }
      const_attr_reader  :IDEOGRAPHIC_SPACE_SIGN
      
      const_set_lazy(:TAB_SIGN) { Character.new(0x00bb) }
      const_attr_reader  :TAB_SIGN
      
      const_set_lazy(:CARRIAGE_RETURN_SIGN) { Character.new(0x00a4) }
      const_attr_reader  :CARRIAGE_RETURN_SIGN
      
      const_set_lazy(:LINE_FEED_SIGN) { Character.new(0x00b6) }
      const_attr_reader  :LINE_FEED_SIGN
    }
    
    # Indicates whether this painter is active.
    attr_accessor :f_is_active
    alias_method :attr_f_is_active, :f_is_active
    undef_method :f_is_active
    alias_method :attr_f_is_active=, :f_is_active=
    undef_method :f_is_active=
    
    # The source viewer this painter is attached to.
    attr_accessor :f_text_viewer
    alias_method :attr_f_text_viewer, :f_text_viewer
    undef_method :f_text_viewer
    alias_method :attr_f_text_viewer=, :f_text_viewer=
    undef_method :f_text_viewer=
    
    # The viewer's widget.
    attr_accessor :f_text_widget
    alias_method :attr_f_text_widget, :f_text_widget
    undef_method :f_text_widget
    alias_method :attr_f_text_widget=, :f_text_widget=
    undef_method :f_text_widget=
    
    # Tells whether the advanced graphics sub system is available.
    attr_accessor :f_is_advanced_graphics_present
    alias_method :attr_f_is_advanced_graphics_present, :f_is_advanced_graphics_present
    undef_method :f_is_advanced_graphics_present
    alias_method :attr_f_is_advanced_graphics_present=, :f_is_advanced_graphics_present=
    undef_method :f_is_advanced_graphics_present=
    
    typesig { [ITextViewer] }
    # Creates a new painter for the given text viewer.
    # 
    # @param textViewer  the text viewer the painter should be attached to
    def initialize(text_viewer)
      @f_is_active = false
      @f_text_viewer = nil
      @f_text_widget = nil
      @f_is_advanced_graphics_present = false
      @f_text_viewer = text_viewer
      @f_text_widget = text_viewer.get_text_widget
      gc = SwtGC.new(@f_text_widget)
      gc.set_advanced(true)
      @f_is_advanced_graphics_present = gc.get_advanced
      gc.dispose
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.IPainter#dispose()
    def dispose
      @f_text_viewer = nil
      @f_text_widget = nil
    end
    
    typesig { [::Java::Int] }
    # @see org.eclipse.jface.text.IPainter#paint(int)
    def paint(reason)
      document = @f_text_viewer.get_document
      if ((document).nil?)
        deactivate(false)
        return
      end
      if (!@f_is_active)
        @f_is_active = true
        @f_text_widget.add_paint_listener(self)
        redraw_all
      else
        if ((reason).equal?(CONFIGURATION) || (reason).equal?(INTERNAL))
          redraw_all
        else
          if ((reason).equal?(TEXT_CHANGE))
            # redraw current line only
            begin
              line_region = document.get_line_information_of_offset(get_document_offset(@f_text_widget.get_caret_offset))
              widget_offset = get_widget_offset(line_region.get_offset)
              char_count = @f_text_widget.get_char_count
              redraw_length = Math.min(line_region.get_length, char_count - widget_offset)
              if (widget_offset >= 0 && redraw_length > 0)
                @f_text_widget.redraw_range(widget_offset, redraw_length, true)
              end
            rescue BadLocationException => e
              # ignore
            end
          end
        end
      end
    end
    
    typesig { [::Java::Boolean] }
    # @see org.eclipse.jface.text.IPainter#deactivate(boolean)
    def deactivate(redraw)
      if (@f_is_active)
        @f_is_active = false
        @f_text_widget.remove_paint_listener(self)
        if (redraw)
          redraw_all
        end
      end
    end
    
    typesig { [IPaintPositionManager] }
    # @see org.eclipse.jface.text.IPainter#setPositionManager(org.eclipse.jface.text.IPaintPositionManager)
    def set_position_manager(manager)
      # no need for a position manager
    end
    
    typesig { [PaintEvent] }
    # @see org.eclipse.swt.events.PaintListener#paintControl(org.eclipse.swt.events.PaintEvent)
    def paint_control(event)
      if (!(@f_text_widget).nil?)
        handle_draw_request(event.attr_gc, event.attr_x, event.attr_y, event.attr_width, event.attr_height)
      end
    end
    
    typesig { [SwtGC, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int] }
    # Draw characters in view range.
    def handle_draw_request(gc, x, y, w, h)
      start_line = @f_text_widget.get_line_index(y)
      end_line = @f_text_widget.get_line_index(y + h - 1)
      if (start_line <= end_line && start_line < @f_text_widget.get_line_count)
        if (@f_is_advanced_graphics_present)
          alpha = gc.get_alpha
          gc.set_alpha(100)
          draw_line_range(gc, start_line, end_line, x, w)
          gc.set_alpha(alpha)
        else
          draw_line_range(gc, start_line, end_line, x, w)
        end
      end
    end
    
    typesig { [SwtGC, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int] }
    # Draw the given line range.
    # 
    # @param gc the GC
    # @param startLine first line number
    # @param endLine last line number (inclusive)
    # @param x the X-coordinate of the drawing range
    # @param w the width of the drawing range
    def draw_line_range(gc, start_line, end_line, x, w)
      view_port_width = @f_text_widget.get_client_area.attr_width
      line = start_line
      while line <= end_line
        line_offset = @f_text_widget.get_offset_at_line(line)
        # line end offset including line delimiter
        line_end_offset = 0
        if (line < @f_text_widget.get_line_count - 1)
          line_end_offset = @f_text_widget.get_offset_at_line(line + 1)
        else
          line_end_offset = @f_text_widget.get_char_count
        end
        # line length excluding line delimiter
        line_length = line_end_offset - line_offset
        while (line_length > 0)
          c = @f_text_widget.get_text_range(line_offset + line_length - 1, 1).char_at(0)
          if (!(c).equal?(Character.new(?\r.ord)) && !(c).equal?(Character.new(?\n.ord)))
            break
          end
          (line_length -= 1)
        end
        # compute coordinates of last character on line
        end_of_line = @f_text_widget.get_location_at_offset(line_offset + line_length)
        if (x - end_of_line.attr_x > view_port_width)
          # line is not visible
          line += 1
          next
        end
        # Y-coordinate of line
        y = @f_text_widget.get_line_pixel(line)
        # compute first visible char offset
        start_offset = 0
        begin
          start_offset = @f_text_widget.get_offset_at_location(Point.new(x, y)) - 1
          if (start_offset - 2 <= line_offset)
            start_offset = line_offset
          end
        rescue IllegalArgumentException => iae
          start_offset = line_offset
        end
        # compute last visible char offset
        end_offset = 0
        if (x + w >= end_of_line.attr_x)
          # line end is visible
          end_offset = line_end_offset
        else
          begin
            end_offset = @f_text_widget.get_offset_at_location(Point.new(x + w - 1, y)) + 1
            if (end_offset + 2 >= line_end_offset)
              end_offset = line_end_offset
            end
          rescue IllegalArgumentException => iae
            end_offset = line_end_offset
          end
        end
        # draw character range
        if (end_offset > start_offset)
          draw_char_range(gc, start_offset, end_offset)
        end
        line += 1
      end
    end
    
    typesig { [SwtGC, ::Java::Int, ::Java::Int] }
    # Draw characters of content range.
    # 
    # @param gc the GC
    # @param startOffset inclusive start index
    # @param endOffset exclusive end index
    def draw_char_range(gc, start_offset, end_offset)
      content = @f_text_widget.get_content
      length = end_offset - start_offset
      text = content.get_text_range(start_offset, length)
      style_range = nil
      fg = nil
      visible_char = StringBuffer.new(10)
      text_offset = 0
      while text_offset <= length
        delta = 0
        eol = false
        if (text_offset < length)
          delta = 1
          c = text.char_at(text_offset)
          catch(:break_case) do
            case (c)
            when Character.new(?\s.ord)
              visible_char.append(SPACE_SIGN)
              # 'continue' would improve performance but may produce drawing errors
              # for long runs of space if width of space and dot differ
            when Character.new(0x3000)
              # ideographic whitespace
              visible_char.append(IDEOGRAPHIC_SPACE_SIGN)
              # 'continue' would improve performance but may produce drawing errors
              # for long runs of space if width of space and dot differ
            when Character.new(?\t.ord)
              visible_char.append(TAB_SIGN)
            when Character.new(?\r.ord)
              visible_char.append(CARRIAGE_RETURN_SIGN)
              if (text_offset >= length - 1 || !(text.char_at(text_offset + 1)).equal?(Character.new(?\n.ord)))
                eol = true
                throw :break_case, :thrown
              end
              (text_offset += 1)
              next
              visible_char.append(LINE_FEED_SIGN)
              eol = true
            when Character.new(?\n.ord)
              visible_char.append(LINE_FEED_SIGN)
              eol = true
            else
              delta = 0
            end
          end == :thrown or break
        end
        if (visible_char.length > 0)
          widget_offset = start_offset + text_offset - visible_char.length + delta
          if (!eol || !is_folded_line(content.get_line_at_offset(widget_offset)))
            # Block selection is drawn using alpha and no selection-inverting
            # takes place, we always draw as 'unselected' in block selection mode.
            if (!@f_text_widget.get_block_selection && is_offset_selected(@f_text_widget, widget_offset))
              fg = @f_text_widget.get_selection_foreground
            else
              if ((style_range).nil? || style_range.attr_start + style_range.attr_length <= widget_offset)
                style_range = @f_text_widget.get_style_range_at_offset(widget_offset)
                if ((style_range).nil? || (style_range.attr_foreground).nil?)
                  fg = @f_text_widget.get_foreground
                else
                  fg = style_range.attr_foreground
                end
              end
            end
            draw(gc, widget_offset, visible_char.to_s, fg)
          end
          visible_char.delete(0, visible_char.length)
        end
        (text_offset += 1)
      end
    end
    
    class_module.module_eval {
      typesig { [StyledText, ::Java::Int] }
      # Returns <code>true</code> if <code>offset</code> is selection in <code>widget</code>,
      # <code>false</code> otherwise.
      # 
      # @param widget the widget
      # @param offset the offset
      # @return <code>true</code> if <code>offset</code> is selection, <code>false</code> otherwise
      # @since 3.5
      def is_offset_selected(widget, offset)
        selection = widget.get_selection
        return offset >= selection.attr_x && offset < selection.attr_y
      end
    }
    
    typesig { [::Java::Int] }
    # Check if the given widget line is a folded line.
    # 
    # @param widgetLine  the widget line number
    # @return <code>true</code> if the line is folded
    def is_folded_line(widget_line)
      if (@f_text_viewer.is_a?(ITextViewerExtension5))
        extension = @f_text_viewer
        model_line = extension.widget_line2model_line(widget_line)
        widget_line2 = extension.model_line2widget_line(model_line + 1)
        return (widget_line2).equal?(-1)
      end
      return false
    end
    
    typesig { [] }
    # Redraw all of the text widgets visible content.
    def redraw_all
      @f_text_widget.redraw
    end
    
    typesig { [SwtGC, ::Java::Int, String, Color] }
    # Draw string at widget offset.
    # 
    # @param gc the GC
    # @param offset the widget offset
    # @param s the string to be drawn
    # @param fg the foreground color
    def draw(gc, offset, s, fg)
      # Compute baseline delta (see https://bugs.eclipse.org/bugs/show_bug.cgi?id=165640)
      baseline = @f_text_widget.get_baseline(offset)
      font_metrics = gc.get_font_metrics
      font_baseline = font_metrics.get_ascent + font_metrics.get_leading
      basline_delta = baseline - font_baseline
      pos = @f_text_widget.get_location_at_offset(offset)
      gc.set_foreground(fg)
      gc.draw_string(s, pos.attr_x, pos.attr_y + basline_delta, true)
    end
    
    typesig { [::Java::Int] }
    # Convert a document offset to the corresponding widget offset.
    # 
    # @param documentOffset the document offset
    # @return widget offset
    def get_widget_offset(document_offset)
      if (@f_text_viewer.is_a?(ITextViewerExtension5))
        extension = @f_text_viewer
        return extension.model_offset2widget_offset(document_offset)
      end
      visible = @f_text_viewer.get_visible_region
      widget_offset = document_offset - visible.get_offset
      if (widget_offset > visible.get_length)
        return -1
      end
      return widget_offset
    end
    
    typesig { [::Java::Int] }
    # Convert a widget offset to the corresponding document offset.
    # 
    # @param widgetOffset the widget offset
    # @return document offset
    def get_document_offset(widget_offset)
      if (@f_text_viewer.is_a?(ITextViewerExtension5))
        extension = @f_text_viewer
        return extension.widget_offset2model_offset(widget_offset)
      end
      visible = @f_text_viewer.get_visible_region
      if (widget_offset > visible.get_length)
        return -1
      end
      return widget_offset + visible.get_offset
    end
    
    private
    alias_method :initialize__whitespace_character_painter, :initialize
  end
  
end
