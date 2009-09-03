require "rjava"

# Copyright (c) 2006, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Source
  module AbstractRulerColumnImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Source
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Custom, :StyledText
      include_const ::Org::Eclipse::Swt::Events, :MouseEvent
      include_const ::Org::Eclipse::Swt::Events, :MouseListener
      include_const ::Org::Eclipse::Swt::Events, :MouseMoveListener
      include_const ::Org::Eclipse::Swt::Events, :PaintEvent
      include_const ::Org::Eclipse::Swt::Events, :PaintListener
      include_const ::Org::Eclipse::Swt::Graphics, :Color
      include_const ::Org::Eclipse::Swt::Graphics, :Font
      include_const ::Org::Eclipse::Swt::Graphics, :GC
      include_const ::Org::Eclipse::Swt::Widgets, :Canvas
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Display
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Jface::Resource, :JFaceResources
      include_const ::Org::Eclipse::Jface::Text, :ITextListener
      include_const ::Org::Eclipse::Jface::Text, :ITextViewer
      include_const ::Org::Eclipse::Jface::Text, :IViewportListener
      include_const ::Org::Eclipse::Jface::Text, :JFaceTextUtil
      include_const ::Org::Eclipse::Jface::Text, :TextEvent
    }
  end
  
  # Abstract implementation of a {@link IVerticalRulerColumn} that
  # uses a {@link Canvas} to draw the ruler contents and which
  # handles scrolling and mouse selection.
  # 
  # <h3>Painting</h3>
  # Subclasses can hook into the paint loop at three levels:
  # <ul>
  # <li>Override <strong>{@link #paint(GC, ILineRange)}</strong> to control the entire painting of
  # the ruler.</li>
  # <li>Override <strong>{@link #paintLine(GC, int, int, int, int)}</strong> to control the
  # painting of a line.</li>
  # <li>Leave the painting to the default implementation, but override <strong>{@link #computeBackground(int)}</strong>,
  # <strong>{@link #computeForeground(int)}</strong> and <strong>{@link #computeText(int)}</strong>
  # to specify the ruler appearance for a line.</li>
  # </ul>
  # 
  # <h3>Invalidation</h3>
  # Subclasses may call {@link #redraw()} to mark the entire ruler as needing to be redrawn.
  # Alternatively, use {@link #redraw(ILineRange)} to only invalidate a certain line range, for
  # example due to changes to the display model.
  # 
  # <h3>Configuration</h3>
  # Subclasses can set the following properties. Setting them may trigger redrawing.
  # <ul>
  # <li>The {@link #setFont(Font) font} used to draw text in {@link #paintLine(GC, int, int, int, int)}.</li>
  # <li>The horizontal {@link #setTextInset(int) text inset} for text drawn.</li>
  # <li>The {@link #setDefaultBackground(Color) default background color} of the ruler.</li>
  # <li>The {@link #setWidth(int) width} of the ruler.</li>
  # </ul>
  # 
  # @since 3.3
  class AbstractRulerColumn 
    include_class_members AbstractRulerColumnImports
    include IVerticalRulerColumn
    include IVerticalRulerInfo
    include IVerticalRulerInfoExtension
    
    class_module.module_eval {
      const_set_lazy(:DEFAULT_WIDTH) { 12 }
      const_attr_reader  :DEFAULT_WIDTH
      
      const_set_lazy(:DEFAULT_TEXT_INSET) { 2 }
      const_attr_reader  :DEFAULT_TEXT_INSET
      
      # Handles all the mouse interaction in this line number ruler column.
      const_set_lazy(:MouseHandler) { Class.new do
        extend LocalClass
        include_class_members AbstractRulerColumn
        include MouseListener
        include MouseMoveListener
        
        typesig { [class_self::MouseEvent] }
        # @see org.eclipse.swt.events.MouseListener#mouseUp(org.eclipse.swt.events.MouseEvent)
        def mouse_up(event)
        end
        
        typesig { [class_self::MouseEvent] }
        # @see org.eclipse.swt.events.MouseListener#mouseDown(org.eclipse.swt.events.MouseEvent)
        def mouse_down(event)
          self.attr_f_parent_ruler.set_location_of_last_mouse_button_activity(event.attr_x, event.attr_y)
        end
        
        typesig { [class_self::MouseEvent] }
        # @see org.eclipse.swt.events.MouseListener#mouseDoubleClick(org.eclipse.swt.events.MouseEvent)
        def mouse_double_click(event)
          self.attr_f_parent_ruler.set_location_of_last_mouse_button_activity(event.attr_x, event.attr_y)
        end
        
        typesig { [class_self::MouseEvent] }
        # @see org.eclipse.swt.events.MouseMoveListener#mouseMove(org.eclipse.swt.events.MouseEvent)
        def mouse_move(event)
          self.attr_f_parent_ruler.set_location_of_last_mouse_button_activity(event.attr_x, event.attr_y)
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__mouse_handler, :initialize
      end }
      
      # Internal listener class that updates the ruler upon scrolling and text modifications.
      const_set_lazy(:InternalListener) { Class.new do
        extend LocalClass
        include_class_members AbstractRulerColumn
        include IViewportListener
        include ITextListener
        
        typesig { [::Java::Int] }
        # @see IViewportListener#viewportChanged(int)
        def viewport_changed(top_pixel)
          delta = top_pixel - self.attr_f_last_top_pixel
          if (scroll_vertical(delta))
            self.attr_f_canvas.update
          end # force update the invalidated regions
        end
        
        typesig { [class_self::TextEvent] }
        # @see ITextListener#textChanged(TextEvent)
        def text_changed(event)
          # Redraw: - when the viewer is drawing, and any of the following - the widget was not
          # full before the change - the widget is not full after the change - the document event
          # was a visual modification (no document event attached) - for example when the
          # projection changes.
          if (!event.get_viewer_redraw_state)
            return
          end
          if (self.attr_f_was_showing_entire_contents || (event.get_document_event).nil? || JFaceTextUtil.is_showing_entire_contents(self.attr_f_styled_text))
            redraw
          end
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__internal_listener, :initialize
      end }
    }
    
    # Listeners
    # The viewport listener.
    attr_accessor :f_internal_listener
    alias_method :attr_f_internal_listener, :f_internal_listener
    undef_method :f_internal_listener
    alias_method :attr_f_internal_listener=, :f_internal_listener=
    undef_method :f_internal_listener=
    
    # The mouse handler.
    attr_accessor :f_mouse_handler
    alias_method :attr_f_mouse_handler, :f_mouse_handler
    undef_method :f_mouse_handler
    alias_method :attr_f_mouse_handler=, :f_mouse_handler=
    undef_method :f_mouse_handler=
    
    # Implementation and context of this ruler - created and set in createControl(), disposed of in
    # columnRemoved().
    # 
    # The parent ruler, possibly <code>null</code>.
    attr_accessor :f_parent_ruler
    alias_method :attr_f_parent_ruler, :f_parent_ruler
    undef_method :f_parent_ruler
    alias_method :attr_f_parent_ruler=, :f_parent_ruler=
    undef_method :f_parent_ruler=
    
    # The canvas, the only widget used to draw this ruler, possibly <code>null</code>.
    attr_accessor :f_canvas
    alias_method :attr_f_canvas, :f_canvas
    undef_method :f_canvas
    alias_method :attr_f_canvas=, :f_canvas=
    undef_method :f_canvas=
    
    # The text viewer, possibly <code>null</code>.
    attr_accessor :f_text_viewer
    alias_method :attr_f_text_viewer, :f_text_viewer
    undef_method :f_text_viewer
    alias_method :attr_f_text_viewer=, :f_text_viewer=
    undef_method :f_text_viewer=
    
    # The text viewer's widget, possibly <code>null</code>.
    attr_accessor :f_styled_text
    alias_method :attr_f_styled_text, :f_styled_text
    undef_method :f_styled_text
    alias_method :attr_f_styled_text=, :f_styled_text=
    undef_method :f_styled_text=
    
    # State when the canvas was last painted.
    # The text widget's top pixel when the ruler was last painted.
    attr_accessor :f_last_top_pixel
    alias_method :attr_f_last_top_pixel, :f_last_top_pixel
    undef_method :f_last_top_pixel
    alias_method :attr_f_last_top_pixel=, :f_last_top_pixel=
    undef_method :f_last_top_pixel=
    
    # Whether the text widget was showing the entire contents when the ruler was last painted.
    attr_accessor :f_was_showing_entire_contents
    alias_method :attr_f_was_showing_entire_contents, :f_was_showing_entire_contents
    undef_method :f_was_showing_entire_contents
    alias_method :attr_f_was_showing_entire_contents=, :f_was_showing_entire_contents=
    undef_method :f_was_showing_entire_contents=
    
    # Configuration
    # The width of this ruler.
    attr_accessor :f_width
    alias_method :attr_f_width, :f_width
    undef_method :f_width
    alias_method :attr_f_width=, :f_width=
    undef_method :f_width=
    
    # The text inset.
    attr_accessor :f_text_inset
    alias_method :attr_f_text_inset, :f_text_inset
    undef_method :f_text_inset
    alias_method :attr_f_text_inset=, :f_text_inset=
    undef_method :f_text_inset=
    
    # The default background color, <code>null</code> to use the text viewer's background color.
    attr_accessor :f_background
    alias_method :attr_f_background, :f_background
    undef_method :f_background
    alias_method :attr_f_background=, :f_background=
    undef_method :f_background=
    
    # The font, <code>null</code> to use the default font.
    attr_accessor :f_font
    alias_method :attr_f_font, :f_font
    undef_method :f_font
    alias_method :attr_f_font=, :f_font=
    undef_method :f_font=
    
    # The annotation model, possibly <code>null</code>.
    attr_accessor :f_model
    alias_method :attr_f_model, :f_model
    undef_method :f_model
    alias_method :attr_f_model=, :f_model=
    undef_method :f_model=
    
    # The annotation hover, possibly <code>null</code>.
    attr_accessor :f_hover
    alias_method :attr_f_hover, :f_hover
    undef_method :f_hover
    alias_method :attr_f_hover=, :f_hover=
    undef_method :f_hover=
    
    typesig { [] }
    # Creates a new ruler.
    def initialize
      @f_internal_listener = InternalListener.new_local(self)
      @f_mouse_handler = MouseHandler.new_local(self)
      @f_parent_ruler = nil
      @f_canvas = nil
      @f_text_viewer = nil
      @f_styled_text = nil
      @f_last_top_pixel = -1
      @f_was_showing_entire_contents = false
      @f_width = DEFAULT_WIDTH
      @f_text_inset = DEFAULT_TEXT_INSET
      @f_background = nil
      @f_font = nil
      @f_model = nil
      @f_hover = nil
    end
    
    typesig { [CompositeRuler, Composite] }
    # @see org.eclipse.jface.text.source.IVerticalRulerColumn#createControl(org.eclipse.jface.text.source.CompositeRuler,
    # org.eclipse.swt.widgets.Composite)
    def create_control(parent_ruler, parent_control)
      Assert.is_legal(!(parent_control).nil?)
      Assert.is_legal(!(parent_ruler).nil?)
      Assert.is_legal((@f_parent_ruler).nil?) # only call when not yet initialized!
      @f_parent_ruler = parent_ruler
      @f_text_viewer = get_parent_ruler.get_text_viewer
      @f_text_viewer.add_viewport_listener(@f_internal_listener)
      @f_text_viewer.add_text_listener(@f_internal_listener)
      @f_styled_text = @f_text_viewer.get_text_widget
      @f_canvas = Canvas.new(parent_control, get_canvas_style)
      @f_canvas.set_background(get_default_background)
      @f_canvas.set_font(get_font)
      @f_canvas.add_paint_listener(Class.new(PaintListener.class == Class ? PaintListener : Object) do
        extend LocalClass
        include_class_members AbstractRulerColumn
        include PaintListener if PaintListener.class == Module
        
        typesig { [PaintEvent] }
        define_method :paint_control do |event|
          @local_class_parent.paint_control(event)
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      @f_canvas.add_mouse_listener(@f_mouse_handler)
      @f_canvas.add_mouse_move_listener(@f_mouse_handler)
      return @f_canvas
    end
    
    typesig { [] }
    # Returns the SWT style bits used when creating the ruler canvas.
    # <p>
    # The default implementation returns <code>SWT.NO_BACKGROUND</code>.</p>
    # <p>
    # Clients may reimplement this method to create a canvas with their
    # desired style bits.</p>
    # 
    # @return the SWT style bits, or <code>SWT.NONE</code> if none
    def get_canvas_style
      return SWT::NO_BACKGROUND
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.source.IVerticalRulerColumn#getControl()
    def get_control
      return @f_canvas
    end
    
    typesig { [::Java::Int] }
    # The new width in pixels. The <code>DEFAULT_WIDTH</code> constant
    # specifies the default width.
    # 
    # @param width the new width
    def set_width(width)
      Assert.is_legal(width >= 0)
      if (!(@f_width).equal?(width))
        @f_width = width
        composite = get_parent_ruler
        if (!(composite).nil?)
          composite.relayout
        end
      end
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.source.IVerticalRulerColumn#getWidth()
    def get_width
      return @f_width
    end
    
    typesig { [] }
    # Returns the parent ruler, <code>null</code> before
    # {@link #createControl(CompositeRuler, Composite)} has been called.
    # 
    # @return the parent ruler or <code>null</code>
    def get_parent_ruler
      return @f_parent_ruler
    end
    
    typesig { [Font] }
    # {@inheritDoc}
    # 
    # @param font the font or <code>null</code> to use the default font
    def set_font(font)
      if (!(@f_font).equal?(font))
        @f_font = font
        redraw
      end
    end
    
    typesig { [] }
    # Returns the current font. If a font has not been explicitly set, the widget's font is
    # returned.
    # 
    # @return the font used to render text on the ruler.
    def get_font
      if (!(@f_font).nil?)
        return @f_font
      end
      if (!(@f_styled_text).nil? && !@f_styled_text.is_disposed)
        return @f_styled_text.get_font
      end
      return JFaceResources.get_text_font
    end
    
    typesig { [::Java::Int] }
    # Sets the text inset (padding) used to draw text in {@link #paintLine(GC, int, int, int, int)}.
    # 
    # @param textInset the new text inset
    def set_text_inset(text_inset)
      if (!(text_inset).equal?(@f_text_inset))
        @f_text_inset = text_inset
        redraw
      end
    end
    
    typesig { [] }
    # Returns the text inset for text drawn by {@link #paintLine(GC, int, int, int, int)}. The
    # <code>DEFAULT_TEXT_INSET</code> constant specifies the default inset in pixels.
    # 
    # @return the text inset for text
    def get_text_inset
      return @f_text_inset
    end
    
    typesig { [IAnnotationModel] }
    # @see org.eclipse.jface.text.source.IVerticalRulerColumn#setModel(org.eclipse.jface.text.source.IAnnotationModel)
    def set_model(model)
      if (!(@f_model).equal?(model))
        @f_model = model
        redraw
      end
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.source.IVerticalRulerInfoExtension#getModel()
    def get_model
      return @f_model
    end
    
    typesig { [Color] }
    # Sets the default background color for this column. The default background is used as default
    # implementation of {@link #computeBackground(int)} and also to paint the area of the ruler
    # that does not correspond to any lines (when the viewport is not entirely filled with lines).
    # 
    # @param background the default background color, <code>null</code> to use the text widget's
    # background
    def set_default_background(background)
      if (!(@f_background).equal?(background))
        @f_background = background
        if (!(@f_canvas).nil? && !@f_canvas.is_disposed)
          @f_canvas.set_background(get_default_background)
        end
        redraw
      end
    end
    
    typesig { [] }
    # Returns the background color. May return <code>null</code> if the system is shutting down.
    # 
    # @return the background color
    def get_default_background
      if (!(@f_background).nil?)
        return @f_background
      end
      if (!(@f_styled_text).nil? && !@f_styled_text.is_disposed)
        return @f_styled_text.get_background
      end
      display = nil
      if (!(@f_canvas).nil? && !@f_canvas.is_disposed)
        display = @f_canvas.get_display
      else
        display = Display.get_current
      end
      if (!(display).nil?)
        return display.get_system_color(SWT::COLOR_LIST_BACKGROUND)
      end
      return nil
    end
    
    typesig { [IAnnotationHover] }
    # Sets the annotation hover.
    # 
    # @param hover the annotation hover, <code>null</code> for no hover
    def set_hover(hover)
      if (!(@f_hover).equal?(hover))
        @f_hover = hover
      end
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.source.IVerticalRulerInfoExtension#getHover()
    def get_hover
      return @f_hover
    end
    
    typesig { [] }
    # Disposes this ruler column.
    # <p>
    # Subclasses may extend this method.</p>
    # <p>
    # Clients who created this column are responsible to call this method
    # once the column is no longer used.</p>
    def dispose
      if (!(@f_text_viewer).nil?)
        @f_text_viewer.remove_viewport_listener(@f_internal_listener)
        @f_text_viewer.remove_text_listener(@f_internal_listener)
        @f_text_viewer = nil
      end
      if (!(@f_styled_text).nil?)
        @f_styled_text = nil
      end
      if (!(@f_canvas).nil?)
        @f_canvas.dispose
        @f_canvas = nil
      end
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.source.IVerticalRulerColumn#redraw()
    def redraw
      if (!(@f_canvas).nil? && !@f_canvas.is_disposed)
        @f_canvas.redraw
      end
    end
    
    typesig { [ILineRange] }
    # Marks the region covered by <code>lines</code> as needing to be redrawn.
    # 
    # @param lines the lines to be redrawn in document coordinates
    def redraw(lines)
      if ((@f_canvas).nil? || @f_canvas.is_disposed)
        return
      end
      first_model_line = lines.get_start_line
      last_model_line = first_model_line + lines.get_number_of_lines
      first_widget_line = JFaceTextUtil.model_line_to_widget_line(@f_text_viewer, first_model_line)
      last_widget_line = JFaceTextUtil.model_line_to_widget_line(@f_text_viewer, last_model_line)
      from = Math.max(0, @f_styled_text.get_line_pixel(first_widget_line))
      # getLinePixel will return the last pixel of the last line if line == lineCount
      to = Math.min(@f_canvas.get_size.attr_y, @f_styled_text.get_line_pixel(last_widget_line + 1))
      @f_canvas.redraw(0, from, @f_width, to - from, false)
    end
    
    typesig { [PaintEvent] }
    # Paints the ruler column.
    # 
    # @param event the paint event
    def paint_control(event)
      if ((@f_text_viewer).nil?)
        return
      end
      @f_was_showing_entire_contents = JFaceTextUtil.is_showing_entire_contents(@f_styled_text)
      @f_last_top_pixel = @f_styled_text.get_top_pixel
      lines = compute_dirty_widget_lines(event)
      gc = event.attr_gc
      paint(gc, lines)
      if (!((@f_canvas.get_style & SWT::NO_BACKGROUND)).equal?(0))
        # fill empty area below any lines
        first_empty = Math.max(event.attr_y, @f_styled_text.get_line_pixel(@f_styled_text.get_line_count))
        last_empty = event.attr_y + event.attr_height
        if (last_empty > first_empty)
          gc.set_background(get_default_background)
          gc.fill_rectangle(0, first_empty, get_width, last_empty - first_empty)
        end
      end
    end
    
    typesig { [PaintEvent] }
    # Computes the widget lines that need repainting given the clipping region of a paint event.
    # 
    # @param event the paint event
    # @return the lines in widget coordinates that need repainting
    def compute_dirty_widget_lines(event)
      first_line = @f_styled_text.get_line_index(event.attr_y)
      last_line = @f_styled_text.get_line_index(event.attr_y + event.attr_height - 1)
      return LineRange.new(first_line, last_line - first_line + 1)
    end
    
    typesig { [GC, ILineRange] }
    # Paints the ruler. Note that <code>lines</code> reference widget line indices, and that
    # <code>lines</code> may not cover the entire viewport, but only the lines that need to be
    # painted. The lines may not be entirely visible.
    # <p>
    # Subclasses may replace or extend. The default implementation calls
    # {@link #paintLine(GC, int, int, int, int)} for every visible line.
    # </p>
    # 
    # @param gc the graphics context to paint on
    # @param lines the lines to paint in widget coordinates
    def paint(gc, lines)
      first_line = lines.get_start_line
      last_line = first_line + lines.get_number_of_lines
      line = first_line
      while line < last_line
        model_line = JFaceTextUtil.widget_line2model_line(@f_text_viewer, line)
        if ((model_line).equal?(-1))
          line += 1
          next
        end
        line_pixel = @f_styled_text.get_line_pixel(line)
        line_height = @f_styled_text.get_line_height(@f_styled_text.get_offset_at_line(line))
        paint_line(gc, model_line, line, line_pixel, line_height)
        line += 1
      end
    end
    
    typesig { [GC, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int] }
    # Paints the ruler representation of a single line.
    # <p>
    # Subclasses may replace or extend. The default implementation draws the text obtained by
    # {@link #computeText(int)} in the {@link #computeForeground(int) foreground color} and fills
    # the entire width using the {@link #computeBackground(int) background color}. The text is
    # drawn {@link #getTextInset()} pixels to the right of the left border.
    # </p>
    # 
    # @param gc the graphics context to paint on
    # @param modelLine the model line (based on document coordinates)
    # @param widgetLine the line in the text widget corresponding to <code>modelLine</code>
    # @param linePixel the first y-pixel of the widget line
    # @param lineHeight the line height in pixels
    def paint_line(gc, model_line, widget_line, line_pixel, line_height)
      gc.set_background(compute_background(model_line))
      gc.fill_rectangle(0, line_pixel, get_width, line_height)
      text = compute_text(model_line)
      if (!(text).nil?)
        gc.set_foreground(compute_foreground(model_line))
        gc.draw_string(text, get_text_inset, line_pixel, true)
      end
    end
    
    typesig { [::Java::Int] }
    # Returns the text to be drawn for a certain line by {@link #paintLine(GC, int, int, int, int)},
    # <code>null</code> for no text. The default implementation returns <code>null</code>.
    # <p>
    # Subclasses may replace or extend.
    # </p>
    # 
    # @param line the document line number
    # @return the text to be drawn for the given line, <code>null</code> for no text
    def compute_text(line)
      return nil
    end
    
    typesig { [::Java::Int] }
    # Returns the background color drawn for a certain line by
    # {@link #paintLine(GC, int, int, int, int)}. The default implementation returns
    # {@link #getDefaultBackground()}.
    # <p>
    # Subclasses may replace or extend.
    # </p>
    # 
    # @param line the document line number
    # @return the background color for drawn for the given line
    def compute_background(line)
      return get_default_background
    end
    
    typesig { [::Java::Int] }
    # Returns the foreground color drawn for a certain line by
    # {@link #paintLine(GC, int, int, int, int)}. The default implementation returns a
    # {@link SWT#COLOR_DARK_GRAY} color.
    # <p>
    # Subclasses may replace or extend.
    # </p>
    # 
    # @param line the document line number
    # @return the foreground color for drawn for the given line
    def compute_foreground(line)
      return @f_styled_text.get_display.get_system_color(SWT::COLOR_DARK_GRAY)
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.source.IVerticalRulerInfo#getLineOfLastMouseButtonActivity()
    def get_line_of_last_mouse_button_activity
      return get_parent_ruler.get_line_of_last_mouse_button_activity
    end
    
    typesig { [::Java::Int] }
    # @see org.eclipse.jface.text.source.IVerticalRulerInfo#toDocumentLineNumber(int)
    def to_document_line_number(y_coordinate)
      return get_parent_ruler.to_document_line_number(y_coordinate)
    end
    
    typesig { [IVerticalRulerListener] }
    # @see org.eclipse.jface.text.source.IVerticalRulerInfoExtension#addVerticalRulerListener(org.eclipse.jface.text.source.IVerticalRulerListener)
    def add_vertical_ruler_listener(listener)
      raise UnsupportedOperationException.new
    end
    
    typesig { [IVerticalRulerListener] }
    # @see org.eclipse.jface.text.source.IVerticalRulerInfoExtension#removeVerticalRulerListener(org.eclipse.jface.text.source.IVerticalRulerListener)
    def remove_vertical_ruler_listener(listener)
      raise UnsupportedOperationException.new
    end
    
    typesig { [::Java::Int] }
    # Scrolls the canvas vertically (adapted from
    # {@linkplain StyledText StyledText.scrollVertical()}).
    # 
    # @param pixels the number of pixels to scroll (negative to scroll upwards)
    # @return <code>true</code> if the widget was scrolled, <code>false</code> if the widget
    # was not scrolled
    def scroll_vertical(pixels)
      if ((pixels).equal?(0) || (@f_canvas).nil? || @f_canvas.is_disposed)
        return false
      end
      width = get_width
      client_area_height = @f_styled_text.get_client_area.attr_height
      top_margin = 0
      left_margin = 0
      bottom_margin = 0
      if (pixels > 0)
        # downwards scrolling - content moves upwards
        source_y = top_margin + pixels
        scroll_height = client_area_height - source_y - bottom_margin
        if (scroll_height > 0)
          # scroll recycled area
          @f_canvas.scroll(left_margin, top_margin, left_margin, source_y, width, scroll_height, true)
        end
        if (source_y > scroll_height)
          # redraw in-between area
          redraw_y = Math.max(0, top_margin + scroll_height)
          redraw_height = Math.min(client_area_height, pixels - scroll_height)
          @f_canvas.redraw(left_margin, redraw_y, width, redraw_height, true)
        end
      else
        # upwards scrolling - content moves downwards
        destination_y = top_margin - pixels
        scroll_height = client_area_height - destination_y - bottom_margin
        if (scroll_height > 0)
          # scroll recycled area
          @f_canvas.scroll(left_margin, destination_y, left_margin, top_margin, width, scroll_height, true)
        end
        if (destination_y > scroll_height)
          # redraw in-between area
          redraw_y = Math.max(0, top_margin + scroll_height)
          redraw_height = Math.min(client_area_height, -pixels - scroll_height)
          @f_canvas.redraw(left_margin, redraw_y, width, redraw_height, true)
        end
      end
      return true
    end
    
    private
    alias_method :initialize__abstract_ruler_column, :initialize
  end
  
end
