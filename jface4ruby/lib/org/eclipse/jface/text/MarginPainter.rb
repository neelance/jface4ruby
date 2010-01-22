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
  module MarginPainterImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Custom, :StyledText
      include_const ::Org::Eclipse::Swt::Events, :PaintEvent
      include_const ::Org::Eclipse::Swt::Events, :PaintListener
      include_const ::Org::Eclipse::Swt::Graphics, :Color
      include_const ::Org::Eclipse::Swt::Graphics, :SwtGC
      include_const ::Org::Eclipse::Swt::Graphics, :Rectangle
    }
  end
  
  # Paints a vertical line (margin line) after a given column respecting the text
  # viewer's font.
  # <p>
  # Clients usually instantiate and configure objects of this class.</p>
  # <p>
  # This class is not intended to be subclassed.</p>
  # 
  # @since 2.1
  # @noextend This class is not intended to be subclassed by clients.
  class MarginPainter 
    include_class_members MarginPainterImports
    include IPainter
    include PaintListener
    
    # The widget of the text viewer
    attr_accessor :f_text_widget
    alias_method :attr_f_text_widget, :f_text_widget
    undef_method :f_text_widget
    alias_method :attr_f_text_widget=, :f_text_widget=
    undef_method :f_text_widget=
    
    # The column after which to paint the line, default value <code>80</code>
    attr_accessor :f_margin_width
    alias_method :attr_f_margin_width, :f_margin_width
    undef_method :f_margin_width
    alias_method :attr_f_margin_width=, :f_margin_width=
    undef_method :f_margin_width=
    
    # The color in which to paint the line
    attr_accessor :f_color
    alias_method :attr_f_color, :f_color
    undef_method :f_color
    alias_method :attr_f_color=, :f_color=
    undef_method :f_color=
    
    # The line style of the line to be painted, default value <code>SWT.LINE_SOLID</code>
    attr_accessor :f_line_style
    alias_method :attr_f_line_style, :f_line_style
    undef_method :f_line_style
    alias_method :attr_f_line_style=, :f_line_style=
    undef_method :f_line_style=
    
    # The line width of the line to be painted, default value <code>1</code>
    attr_accessor :f_line_width
    alias_method :attr_f_line_width, :f_line_width
    undef_method :f_line_width
    alias_method :attr_f_line_width=, :f_line_width=
    undef_method :f_line_width=
    
    # NOTE: 0 means width is 1 but with optimized performance
    # The cached x-offset of the <code>fMarginWidth</code> for the current font
    attr_accessor :f_cached_widget_x
    alias_method :attr_f_cached_widget_x, :f_cached_widget_x
    undef_method :f_cached_widget_x
    alias_method :attr_f_cached_widget_x=, :f_cached_widget_x=
    undef_method :f_cached_widget_x=
    
    # The active state of this painter
    attr_accessor :f_is_active
    alias_method :attr_f_is_active, :f_is_active
    undef_method :f_is_active
    alias_method :attr_f_is_active=, :f_is_active=
    undef_method :f_is_active=
    
    typesig { [ITextViewer] }
    # Creates a new painter for the given text viewer.
    # 
    # @param textViewer the text viewer
    def initialize(text_viewer)
      @f_text_widget = nil
      @f_margin_width = 80
      @f_color = nil
      @f_line_style = SWT::LINE_SOLID
      @f_line_width = 0
      @f_cached_widget_x = -1
      @f_is_active = false
      @f_text_widget = text_viewer.get_text_widget
    end
    
    typesig { [::Java::Int] }
    # Sets the column after which to draw the margin line.
    # 
    # @param width the column
    def set_margin_ruler_column(width)
      @f_margin_width = width
      initialize_
    end
    
    typesig { [::Java::Int] }
    # Sets the line style of the margin line.
    # 
    # @param lineStyle a <code>SWT</code> style constant describing the line style
    def set_margin_ruler_style(line_style)
      @f_line_style = line_style
    end
    
    typesig { [::Java::Int] }
    # Sets the line width of the margin line.
    # 
    # @param lineWidth the line width
    def set_margin_ruler_width(line_width)
      if ((line_width).equal?(1))
        line_width = 0
      end # NOTE: 0 means width is 1 but with optimized performance
      @f_line_width = line_width
    end
    
    typesig { [Color] }
    # Sets the color of the margin line. Must be called before <code>paint</code> is called the first time.
    # 
    # @param color the color
    def set_margin_ruler_color(color)
      @f_color = color
    end
    
    typesig { [] }
    # Initializes this painter, by flushing and recomputing all caches and causing
    # the widget to be redrawn. Must be called explicitly when font of text widget changes.
    def initialize_
      compute_widget_x
      @f_text_widget.redraw
    end
    
    typesig { [] }
    # Computes and remembers the x-offset of the margin column for the
    # current widget font.
    def compute_widget_x
      gc = SwtGC.new(@f_text_widget)
      pixels = gc.get_font_metrics.get_average_char_width
      gc.dispose
      @f_cached_widget_x = pixels * @f_margin_width
    end
    
    typesig { [::Java::Boolean] }
    # @see IPainter#deactivate(boolean)
    def deactivate(redraw_)
      if (@f_is_active)
        @f_is_active = false
        @f_cached_widget_x = -1
        @f_text_widget.remove_paint_listener(self)
        if (redraw_)
          @f_text_widget.redraw
        end
      end
    end
    
    typesig { [] }
    # @see IPainter#dispose()
    def dispose
      @f_text_widget = nil
    end
    
    typesig { [::Java::Int] }
    # @see IPainter#paint(int)
    def paint(reason)
      if (!@f_is_active)
        @f_is_active = true
        @f_text_widget.add_paint_listener(self)
        if ((@f_cached_widget_x).equal?(-1))
          compute_widget_x
        end
        @f_text_widget.redraw
      else
        if ((CONFIGURATION).equal?(reason) || (INTERNAL).equal?(reason))
          @f_text_widget.redraw
        end
      end
    end
    
    typesig { [PaintEvent] }
    # @see org.eclipse.swt.events.PaintListener#paintControl(org.eclipse.swt.events.PaintEvent)
    def paint_control(e)
      if (!(@f_text_widget).nil?)
        x = @f_cached_widget_x - @f_text_widget.get_horizontal_pixel
        if (x >= 0)
          area = @f_text_widget.get_client_area
          e.attr_gc.set_foreground(@f_color)
          e.attr_gc.set_line_style(@f_line_style)
          e.attr_gc.set_line_width(@f_line_width)
          e.attr_gc.draw_line(x, 0, x, area.attr_height)
        end
      end
    end
    
    typesig { [IPaintPositionManager] }
    # @see org.eclipse.jface.text.IPainter#setPositionManager(org.eclipse.jface.text.IPaintPositionManager)
    def set_position_manager(manager)
    end
    
    private
    alias_method :initialize__margin_painter, :initialize
  end
  
end
