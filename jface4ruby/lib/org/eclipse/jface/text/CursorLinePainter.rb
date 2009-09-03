require "rjava"

# Copyright (c) 2000, 2009 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
# Tom Eicher (Avaloq Evolution AG) - block selection mode
module Org::Eclipse::Jface::Text
  module CursorLinePainterImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
      include_const ::Org::Eclipse::Swt::Custom, :LineBackgroundEvent
      include_const ::Org::Eclipse::Swt::Custom, :LineBackgroundListener
      include_const ::Org::Eclipse::Swt::Custom, :StyledText
      include_const ::Org::Eclipse::Swt::Graphics, :Color
      include_const ::Org::Eclipse::Swt::Graphics, :Point
    }
  end
  
  # A painter the draws the background of the caret line in a configured color.
  # <p>
  # Clients usually instantiate and configure object of this class.</p>
  # <p>
  # This class is not intended to be subclassed.</p>
  # 
  # @since 2.1
  # @noextend This class is not intended to be subclassed by clients.
  class CursorLinePainter 
    include_class_members CursorLinePainterImports
    include IPainter
    include LineBackgroundListener
    
    # The viewer the painter works on
    attr_accessor :f_viewer
    alias_method :attr_f_viewer, :f_viewer
    undef_method :f_viewer
    alias_method :attr_f_viewer=, :f_viewer=
    undef_method :f_viewer=
    
    # The cursor line back ground color
    attr_accessor :f_highlight_color
    alias_method :attr_f_highlight_color, :f_highlight_color
    undef_method :f_highlight_color
    alias_method :attr_f_highlight_color=, :f_highlight_color=
    undef_method :f_highlight_color=
    
    # The paint position manager for managing the line coordinates
    attr_accessor :f_position_manager
    alias_method :attr_f_position_manager, :f_position_manager
    undef_method :f_position_manager
    alias_method :attr_f_position_manager=, :f_position_manager=
    undef_method :f_position_manager=
    
    # Keeps track of the line to be painted
    attr_accessor :f_current_line
    alias_method :attr_f_current_line, :f_current_line
    undef_method :f_current_line
    alias_method :attr_f_current_line=, :f_current_line=
    undef_method :f_current_line=
    
    # Keeps track of the line to be cleared
    attr_accessor :f_last_line
    alias_method :attr_f_last_line, :f_last_line
    undef_method :f_last_line
    alias_method :attr_f_last_line=, :f_last_line=
    undef_method :f_last_line=
    
    # Keeps track of the line number of the last painted line
    attr_accessor :f_last_line_number
    alias_method :attr_f_last_line_number, :f_last_line_number
    undef_method :f_last_line_number
    alias_method :attr_f_last_line_number=, :f_last_line_number=
    undef_method :f_last_line_number=
    
    # Indicates whether this painter is active
    attr_accessor :f_is_active
    alias_method :attr_f_is_active, :f_is_active
    undef_method :f_is_active
    alias_method :attr_f_is_active=, :f_is_active=
    undef_method :f_is_active=
    
    typesig { [ITextViewer] }
    # Creates a new painter for the given source viewer.
    # 
    # @param textViewer the source viewer for which to create a painter
    def initialize(text_viewer)
      @f_viewer = nil
      @f_highlight_color = nil
      @f_position_manager = nil
      @f_current_line = Position.new(0, 0)
      @f_last_line = Position.new(0, 0)
      @f_last_line_number = -1
      @f_is_active = false
      @f_viewer = text_viewer
    end
    
    typesig { [Color] }
    # Sets the color in which to draw the background of the cursor line.
    # 
    # @param highlightColor the color in which to draw the background of the cursor line
    def set_highlight_color(highlight_color)
      @f_highlight_color = highlight_color
    end
    
    typesig { [LineBackgroundEvent] }
    # @see LineBackgroundListener#lineGetBackground(LineBackgroundEvent)
    def line_get_background(event)
      # don't use cached line information because of asynchronous painting
      text_widget = @f_viewer.get_text_widget
      if (!(text_widget).nil?)
        caret = text_widget.get_caret_offset
        length_ = event.attr_line_text.length
        if (event.attr_line_offset <= caret && caret <= event.attr_line_offset + length_ && !has_multi_line_selection(text_widget))
          event.attr_line_background = @f_highlight_color
        end
      end
    end
    
    typesig { [] }
    # Updates all the cached information about the lines to be painted and to be cleared. Returns <code>true</code>
    # if the line number of the cursor line has changed.
    # 
    # @return <code>true</code> if cursor line changed
    def update_highlight_line
      begin
        document = @f_viewer.get_document
        model_caret = get_model_caret
        line_number = document.get_line_of_offset(model_caret)
        # redraw if the current line number is different from the last line number we painted
        # initially fLastLineNumber is -1
        if (!(line_number).equal?(@f_last_line_number) || !@f_current_line.overlaps_with(model_caret, 0))
          @f_last_line.attr_offset = @f_current_line.attr_offset
          @f_last_line.attr_length = @f_current_line.attr_length
          @f_last_line.attr_is_deleted = @f_current_line.attr_is_deleted
          if (@f_current_line.attr_is_deleted)
            @f_current_line.attr_is_deleted = false
            @f_position_manager.manage_position(@f_current_line)
          end
          @f_current_line.attr_offset = document.get_line_offset(line_number)
          if ((line_number).equal?(document.get_number_of_lines - 1))
            @f_current_line.attr_length = document.get_length - @f_current_line.attr_offset
          else
            @f_current_line.attr_length = document.get_line_offset(line_number + 1) - @f_current_line.attr_offset
          end
          @f_last_line_number = line_number
          return true
        end
      rescue BadLocationException => e
      end
      return false
    end
    
    typesig { [] }
    # Returns the location of the caret as offset in the source viewer's
    # input document.
    # 
    # @return the caret location
    def get_model_caret
      widget_caret = @f_viewer.get_text_widget.get_caret_offset
      if (@f_viewer.is_a?(ITextViewerExtension5))
        extension = @f_viewer
        return extension.widget_offset2model_offset(widget_caret)
      end
      visible = @f_viewer.get_visible_region
      return widget_caret + visible.get_offset
    end
    
    typesig { [Position] }
    # Assumes the given position to specify offset and length of a line to be painted.
    # 
    # @param position the specification of the line  to be painted
    def draw_highlight_line(position)
      # if the position that is about to be drawn was deleted then we can't
      if (position.is_deleted)
        return
      end
      widget_offset = 0
      if (@f_viewer.is_a?(ITextViewerExtension5))
        extension = @f_viewer
        widget_offset = extension.model_offset2widget_offset(position.get_offset)
        if ((widget_offset).equal?(-1))
          return
        end
      else
        visible = @f_viewer.get_visible_region
        widget_offset = position.get_offset - visible.get_offset
        if (widget_offset < 0 || visible.get_length < widget_offset)
          return
        end
      end
      text_widget = @f_viewer.get_text_widget
      # check for https://bugs.eclipse.org/bugs/show_bug.cgi?id=64898
      # this is a guard against the symptoms but not the actual solution
      if (0 <= widget_offset && widget_offset <= text_widget.get_char_count)
        upper_left = text_widget.get_location_at_offset(widget_offset)
        width = text_widget.get_client_area.attr_width + text_widget.get_horizontal_pixel
        height = text_widget.get_line_height(widget_offset)
        text_widget.redraw(0, upper_left.attr_y, width, height, false)
      end
    end
    
    typesig { [::Java::Boolean] }
    # @see IPainter#deactivate(boolean)
    def deactivate(redraw_)
      if (@f_is_active)
        @f_is_active = false
        # on turning off the feature one has to paint the currently
        # highlighted line with the standard background color
        if (redraw_)
          draw_highlight_line(@f_current_line)
        end
        @f_viewer.get_text_widget.remove_line_background_listener(self)
        if (!(@f_position_manager).nil?)
          @f_position_manager.unmanage_position(@f_current_line)
        end
        @f_last_line_number = -1
        @f_current_line.attr_offset = 0
        @f_current_line.attr_length = 0
      end
    end
    
    typesig { [] }
    # @see IPainter#dispose()
    def dispose
    end
    
    typesig { [::Java::Int] }
    # @see IPainter#paint(int)
    def paint(reason)
      if ((@f_viewer.get_document).nil?)
        deactivate(false)
        return
      end
      text_widget = @f_viewer.get_text_widget
      # check selection
      if (has_multi_line_selection(text_widget))
        deactivate(true)
        return
      end
      # initialization
      if (!@f_is_active)
        text_widget.add_line_background_listener(self)
        @f_position_manager.manage_position(@f_current_line)
        @f_is_active = true
      end
      # redraw line highlight only if it hasn't been drawn yet on the respective line
      if (update_highlight_line)
        # clear last line
        draw_highlight_line(@f_last_line)
        # draw new line
        draw_highlight_line(@f_current_line)
      end
    end
    
    typesig { [StyledText] }
    # Returns <code>true</code> if the widget has a selection spanning multiple lines,
    # <code>false</code> otherwise.
    # 
    # @param textWidget the text widget to check
    # @return <code>true</code> if <code>textWidget</code> has a multiline selection,
    # <code>false</code> otherwise
    # @since 3.5
    def has_multi_line_selection(text_widget)
      selection = text_widget.get_selection
      begin
        start_line = text_widget.get_line_at_offset(selection.attr_x)
        end_line = text_widget.get_line_at_offset(selection.attr_y)
        return !(start_line).equal?(end_line)
      rescue IllegalArgumentException => e
        # ignore - apparently, the widget has a stale selection
        # see https://bugs.eclipse.org/bugs/show_bug.cgi?id=273721
        return false
      end
    end
    
    typesig { [IPaintPositionManager] }
    # @see IPainter#setPositionManager(IPaintPositionManager)
    def set_position_manager(manager)
      @f_position_manager = manager
    end
    
    private
    alias_method :initialize__cursor_line_painter, :initialize
  end
  
end
