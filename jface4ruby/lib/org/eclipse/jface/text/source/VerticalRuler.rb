require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Source
  module VerticalRulerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Source
      include_const ::Java::Util, :Iterator
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Custom, :StyledText
      include_const ::Org::Eclipse::Swt::Events, :DisposeEvent
      include_const ::Org::Eclipse::Swt::Events, :DisposeListener
      include_const ::Org::Eclipse::Swt::Events, :MouseEvent
      include_const ::Org::Eclipse::Swt::Events, :MouseListener
      include_const ::Org::Eclipse::Swt::Events, :PaintEvent
      include_const ::Org::Eclipse::Swt::Events, :PaintListener
      include_const ::Org::Eclipse::Swt::Graphics, :Font
      include_const ::Org::Eclipse::Swt::Graphics, :SwtGC
      include_const ::Org::Eclipse::Swt::Graphics, :Image
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Graphics, :Rectangle
      include_const ::Org::Eclipse::Swt::Widgets, :Canvas
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Display
      include_const ::Org::Eclipse::Jface::Text, :BadLocationException
      include_const ::Org::Eclipse::Jface::Text, :IDocument
      include_const ::Org::Eclipse::Jface::Text, :IRegion
      include_const ::Org::Eclipse::Jface::Text, :ITextListener
      include_const ::Org::Eclipse::Jface::Text, :ITextViewer
      include_const ::Org::Eclipse::Jface::Text, :ITextViewerExtension5
      include_const ::Org::Eclipse::Jface::Text, :IViewportListener
      include_const ::Org::Eclipse::Jface::Text, :JFaceTextUtil
      include_const ::Org::Eclipse::Jface::Text, :Position
      include_const ::Org::Eclipse::Jface::Text, :Region
      include_const ::Org::Eclipse::Jface::Text, :TextEvent
    }
  end
  
  # A vertical ruler which is connected to a text viewer. Single column standard
  # implementation of {@link org.eclipse.jface.text.source.IVerticalRuler}.
  # <p>
  # The same can be achieved by using <code>CompositeRuler</code> configured
  # with an <code>AnnotationRulerColumn</code>. Clients may use this class as
  # is.
  # 
  # @see org.eclipse.jface.text.ITextViewer
  class VerticalRuler 
    include_class_members VerticalRulerImports
    include IVerticalRuler
    include IVerticalRulerExtension
    
    class_module.module_eval {
      # Internal listener class.
      const_set_lazy(:InternalListener) { Class.new do
        extend LocalClass
        include_class_members VerticalRuler
        include IViewportListener
        include IAnnotationModelListener
        include ITextListener
        
        typesig { [::Java::Int] }
        # @see IViewportListener#viewportChanged(int)
        def viewport_changed(vertical_position)
          if (!(vertical_position).equal?(self.attr_f_scroll_pos))
            redraw
          end
        end
        
        typesig { [class_self::IAnnotationModel] }
        # @see IAnnotationModelListener#modelChanged(IAnnotationModel)
        def model_changed(model)
          update
        end
        
        typesig { [class_self::TextEvent] }
        # @see ITextListener#textChanged(TextEvent)
        def text_changed(e)
          if (!(self.attr_f_text_viewer).nil? && e.get_viewer_redraw_state)
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
    
    # The vertical ruler's text viewer
    attr_accessor :f_text_viewer
    alias_method :attr_f_text_viewer, :f_text_viewer
    undef_method :f_text_viewer
    alias_method :attr_f_text_viewer=, :f_text_viewer=
    undef_method :f_text_viewer=
    
    # The ruler's canvas
    attr_accessor :f_canvas
    alias_method :attr_f_canvas, :f_canvas
    undef_method :f_canvas
    alias_method :attr_f_canvas=, :f_canvas=
    undef_method :f_canvas=
    
    # The vertical ruler's model
    attr_accessor :f_model
    alias_method :attr_f_model, :f_model
    undef_method :f_model
    alias_method :attr_f_model=, :f_model=
    undef_method :f_model=
    
    # Cache for the actual scroll position in pixels
    attr_accessor :f_scroll_pos
    alias_method :attr_f_scroll_pos, :f_scroll_pos
    undef_method :f_scroll_pos
    alias_method :attr_f_scroll_pos=, :f_scroll_pos=
    undef_method :f_scroll_pos=
    
    # The buffer for double buffering
    attr_accessor :f_buffer
    alias_method :attr_f_buffer, :f_buffer
    undef_method :f_buffer
    alias_method :attr_f_buffer=, :f_buffer=
    undef_method :f_buffer=
    
    # The line of the last mouse button activity
    attr_accessor :f_last_mouse_button_activity_line
    alias_method :attr_f_last_mouse_button_activity_line, :f_last_mouse_button_activity_line
    undef_method :f_last_mouse_button_activity_line
    alias_method :attr_f_last_mouse_button_activity_line=, :f_last_mouse_button_activity_line=
    undef_method :f_last_mouse_button_activity_line=
    
    # The internal listener
    attr_accessor :f_internal_listener
    alias_method :attr_f_internal_listener, :f_internal_listener
    undef_method :f_internal_listener
    alias_method :attr_f_internal_listener=, :f_internal_listener=
    undef_method :f_internal_listener=
    
    # The width of this vertical ruler
    attr_accessor :f_width
    alias_method :attr_f_width, :f_width
    undef_method :f_width
    alias_method :attr_f_width=, :f_width=
    undef_method :f_width=
    
    # The annotation access of this vertical ruler
    # @since 3.0
    attr_accessor :f_annotation_access
    alias_method :attr_f_annotation_access, :f_annotation_access
    undef_method :f_annotation_access
    alias_method :attr_f_annotation_access=, :f_annotation_access=
    undef_method :f_annotation_access=
    
    typesig { [::Java::Int] }
    # Constructs a vertical ruler with the given width.
    # 
    # @param width the width of the vertical ruler
    def initialize(width)
      initialize__vertical_ruler(width, nil)
    end
    
    typesig { [::Java::Int, IAnnotationAccess] }
    # Constructs a vertical ruler with the given width and the given annotation
    # access.
    # 
    # @param width the width of the vertical ruler
    # @param annotationAcccess the annotation access
    # @since 3.0
    def initialize(width, annotation_acccess)
      @f_text_viewer = nil
      @f_canvas = nil
      @f_model = nil
      @f_scroll_pos = 0
      @f_buffer = nil
      @f_last_mouse_button_activity_line = -1
      @f_internal_listener = InternalListener.new_local(self)
      @f_width = 0
      @f_annotation_access = nil
      @f_width = width
      @f_annotation_access = annotation_acccess
    end
    
    typesig { [] }
    # @see IVerticalRuler#getControl()
    def get_control
      return @f_canvas
    end
    
    typesig { [Composite, ITextViewer] }
    # @see IVerticalRuler#createControl(Composite, ITextViewer)
    def create_control(parent, text_viewer)
      @f_text_viewer = text_viewer
      @f_canvas = Canvas.new(parent, SWT::NO_BACKGROUND)
      @f_canvas.add_paint_listener(Class.new(PaintListener.class == Class ? PaintListener : Object) do
        extend LocalClass
        include_class_members VerticalRuler
        include PaintListener if PaintListener.class == Module
        
        typesig { [PaintEvent] }
        define_method :paint_control do |event|
          if (!(self.attr_f_text_viewer).nil?)
            double_buffer_paint(event.attr_gc)
          end
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      @f_canvas.add_dispose_listener(Class.new(DisposeListener.class == Class ? DisposeListener : Object) do
        extend LocalClass
        include_class_members VerticalRuler
        include DisposeListener if DisposeListener.class == Module
        
        typesig { [DisposeEvent] }
        define_method :widget_disposed do |e|
          handle_dispose
          self.attr_f_text_viewer = nil
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      @f_canvas.add_mouse_listener(Class.new(MouseListener.class == Class ? MouseListener : Object) do
        extend LocalClass
        include_class_members VerticalRuler
        include MouseListener if MouseListener.class == Module
        
        typesig { [MouseEvent] }
        define_method :mouse_up do |event|
        end
        
        typesig { [MouseEvent] }
        define_method :mouse_down do |event|
          self.attr_f_last_mouse_button_activity_line = to_document_line_number(event.attr_y)
        end
        
        typesig { [MouseEvent] }
        define_method :mouse_double_click do |event|
          self.attr_f_last_mouse_button_activity_line = to_document_line_number(event.attr_y)
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      if (!(@f_text_viewer).nil?)
        @f_text_viewer.add_viewport_listener(@f_internal_listener)
        @f_text_viewer.add_text_listener(@f_internal_listener)
      end
      return @f_canvas
    end
    
    typesig { [] }
    # Disposes the ruler's resources.
    def handle_dispose
      if (!(@f_text_viewer).nil?)
        @f_text_viewer.remove_viewport_listener(@f_internal_listener)
        @f_text_viewer.remove_text_listener(@f_internal_listener)
        @f_text_viewer = nil
      end
      if (!(@f_model).nil?)
        @f_model.remove_annotation_model_listener(@f_internal_listener)
      end
      if (!(@f_buffer).nil?)
        @f_buffer.dispose
        @f_buffer = nil
      end
    end
    
    typesig { [SwtGC] }
    # Double buffer drawing.
    # 
    # @param dest the GC to draw into
    def double_buffer_paint(dest)
      size = @f_canvas.get_size
      if (size.attr_x <= 0 || size.attr_y <= 0)
        return
      end
      if (!(@f_buffer).nil?)
        r = @f_buffer.get_bounds
        if (!(r.attr_width).equal?(size.attr_x) || !(r.attr_height).equal?(size.attr_y))
          @f_buffer.dispose
          @f_buffer = nil
        end
      end
      if ((@f_buffer).nil?)
        @f_buffer = Image.new(@f_canvas.get_display, size.attr_x, size.attr_y)
      end
      gc = SwtGC.new(@f_buffer)
      gc.set_font(@f_text_viewer.get_text_widget.get_font)
      begin
        gc.set_background(@f_canvas.get_background)
        gc.fill_rectangle(0, 0, size.attr_x, size.attr_y)
        if (@f_text_viewer.is_a?(ITextViewerExtension5))
          do_paint1(gc)
        else
          do_paint(gc)
        end
      ensure
        gc.dispose
      end
      dest.draw_image(@f_buffer, 0, 0)
    end
    
    typesig { [] }
    # Returns the document offset of the upper left corner of the
    # widgets view port, possibly including partially visible lines.
    # 
    # @return the document offset of the upper left corner including partially visible lines
    # @since 2.0
    def get_inclusive_top_index_start_offset
      text_widget = @f_text_viewer.get_text_widget
      if (!(text_widget).nil? && !text_widget.is_disposed)
        top = JFaceTextUtil.get_partial_top_index(@f_text_viewer)
        begin
          document = @f_text_viewer.get_document
          return document.get_line_offset(top)
        rescue BadLocationException => x
        end
      end
      return -1
    end
    
    typesig { [SwtGC] }
    # Draws the vertical ruler w/o drawing the Canvas background.
    # 
    # @param gc  the GC to draw into
    def do_paint(gc)
      if ((@f_model).nil? || (@f_text_viewer).nil?)
        return
      end
      annotation_access_extension = nil
      if (@f_annotation_access.is_a?(IAnnotationAccessExtension))
        annotation_access_extension = @f_annotation_access
      end
      styled_text = @f_text_viewer.get_text_widget
      doc = @f_text_viewer.get_document
      top_left = get_inclusive_top_index_start_offset
      bottom_right = @f_text_viewer.get_bottom_index_end_offset
      view_port = bottom_right - top_left
      d = @f_canvas.get_size
      @f_scroll_pos = styled_text.get_top_pixel
      top_line = -1
      bottom_line = -1
      begin
        region = @f_text_viewer.get_visible_region
        top_line = doc.get_line_of_offset(region.get_offset)
        bottom_line = doc.get_line_of_offset(region.get_offset + region.get_length)
      rescue BadLocationException => x
        return
      end
      # draw Annotations
      r = Rectangle.new(0, 0, 0, 0)
      max_layer = 1 # loop at least once though layers.
      layer = 0
      while layer < max_layer
        iter = @f_model.get_annotation_iterator
        while (iter.has_next)
          annotation_presentation = nil
          annotation = iter.next_
          lay = IAnnotationAccessExtension::DEFAULT_LAYER
          if (!(annotation_access_extension).nil?)
            lay = annotation_access_extension.get_layer(annotation)
          else
            if (annotation.is_a?(IAnnotationPresentation))
              annotation_presentation = annotation
              lay = annotation_presentation.get_layer
            end
          end
          max_layer = Math.max(max_layer, lay + 1) # dynamically update layer maximum
          if (!(lay).equal?(layer))
            # wrong layer: skip annotation
            next
          end
          position = @f_model.get_position(annotation)
          if ((position).nil?)
            next
          end
          if (!position.overlaps_with(top_left, view_port))
            next
          end
          begin
            offset = position.get_offset
            length = position.get_length
            start_line = doc.get_line_of_offset(offset)
            if (start_line < top_line)
              start_line = top_line
            end
            end_line = start_line
            if (length > 0)
              end_line = doc.get_line_of_offset(offset + length - 1)
            end
            if (end_line > bottom_line)
              end_line = bottom_line
            end
            start_line -= top_line
            end_line -= top_line
            r.attr_x = 0
            r.attr_y = JFaceTextUtil.compute_line_height(styled_text, 0, start_line, start_line) - @f_scroll_pos
            r.attr_width = d.attr_x
            lines = end_line - start_line
            r.attr_height = JFaceTextUtil.compute_line_height(styled_text, start_line, end_line + 1, (lines + 1))
            if (r.attr_y < d.attr_y && !(annotation_access_extension).nil?)
              # annotation within visible area
              annotation_access_extension.paint(annotation, gc, @f_canvas, r)
            else
              if (!(annotation_presentation).nil?)
                annotation_presentation.paint(gc, @f_canvas, r)
              end
            end
          rescue BadLocationException => e
          end
        end
        layer += 1
      end
    end
    
    typesig { [SwtGC] }
    # Draws the vertical ruler w/o drawing the Canvas background. Uses
    # <code>ITextViewerExtension5</code> for its implementation. Will replace
    # <code>doPaint(GC)</code>.
    # 
    # @param gc  the GC to draw into
    def do_paint1(gc)
      if ((@f_model).nil? || (@f_text_viewer).nil?)
        return
      end
      annotation_access_extension = nil
      if (@f_annotation_access.is_a?(IAnnotationAccessExtension))
        annotation_access_extension = @f_annotation_access
      end
      extension = @f_text_viewer
      text_widget = @f_text_viewer.get_text_widget
      @f_scroll_pos = text_widget.get_top_pixel
      dimension = @f_canvas.get_size
      # draw Annotations
      r = Rectangle.new(0, 0, 0, 0)
      max_layer = 1 # loop at least once through layers.
      layer = 0
      while layer < max_layer
        iter = @f_model.get_annotation_iterator
        while (iter.has_next)
          annotation_presentation = nil
          annotation = iter.next_
          lay = IAnnotationAccessExtension::DEFAULT_LAYER
          if (!(annotation_access_extension).nil?)
            lay = annotation_access_extension.get_layer(annotation)
          else
            if (annotation.is_a?(IAnnotationPresentation))
              annotation_presentation = annotation
              lay = annotation_presentation.get_layer
            end
          end
          max_layer = Math.max(max_layer, lay + 1) # dynamically update layer maximum
          if (!(lay).equal?(layer))
            # wrong layer: skip annotation
            next
          end
          position = @f_model.get_position(annotation)
          if ((position).nil?)
            next
          end
          widget_region = extension.model_range2widget_range(Region.new(position.get_offset, position.get_length))
          if ((widget_region).nil?)
            next
          end
          start_line = extension.widget_line_of_widget_offset(widget_region.get_offset)
          if ((start_line).equal?(-1))
            next
          end
          end_line = extension.widget_line_of_widget_offset(widget_region.get_offset + Math.max(widget_region.get_length - 1, 0))
          if ((end_line).equal?(-1))
            next
          end
          r.attr_x = 0
          r.attr_y = JFaceTextUtil.compute_line_height(text_widget, 0, start_line, start_line) - @f_scroll_pos
          r.attr_width = dimension.attr_x
          lines = end_line - start_line
          r.attr_height = JFaceTextUtil.compute_line_height(text_widget, start_line, end_line + 1, lines + 1)
          if (r.attr_y < dimension.attr_y && !(annotation_access_extension).nil?)
            # annotation within visible area
            annotation_access_extension.paint(annotation, gc, @f_canvas, r)
          else
            if (!(annotation_presentation).nil?)
              annotation_presentation.paint(gc, @f_canvas, r)
            end
          end
        end
        layer += 1
      end
    end
    
    typesig { [] }
    # Thread-safe implementation.
    # Can be called from any thread.
    # 
    # 
    # @see IVerticalRuler#update()
    def update
      if (!(@f_canvas).nil? && !@f_canvas.is_disposed)
        d = @f_canvas.get_display
        if (!(d).nil?)
          d.async_exec(Class.new(Runnable.class == Class ? Runnable : Object) do
            extend LocalClass
            include_class_members VerticalRuler
            include Runnable if Runnable.class == Module
            
            typesig { [] }
            define_method :run do
              redraw
            end
            
            typesig { [Vararg.new(Object)] }
            define_method :initialize do |*args|
              super(*args)
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
        end
      end
    end
    
    typesig { [] }
    # Redraws the vertical ruler.
    def redraw
      if (!(@f_canvas).nil? && !@f_canvas.is_disposed)
        gc = SwtGC.new(@f_canvas)
        double_buffer_paint(gc)
        gc.dispose
      end
    end
    
    typesig { [IAnnotationModel] }
    # @see IVerticalRuler#setModel(IAnnotationModel)
    def set_model(model)
      if (!(model).equal?(@f_model))
        if (!(@f_model).nil?)
          @f_model.remove_annotation_model_listener(@f_internal_listener)
        end
        @f_model = model
        if (!(@f_model).nil?)
          @f_model.add_annotation_model_listener(@f_internal_listener)
        end
        update
      end
    end
    
    typesig { [] }
    # @see IVerticalRuler#getModel()
    def get_model
      return @f_model
    end
    
    typesig { [] }
    # @see IVerticalRulerInfo#getWidth()
    def get_width
      return @f_width
    end
    
    typesig { [] }
    # @see IVerticalRulerInfo#getLineOfLastMouseButtonActivity()
    def get_line_of_last_mouse_button_activity
      doc = @f_text_viewer.get_document
      if ((doc).nil? || @f_last_mouse_button_activity_line >= @f_text_viewer.get_document.get_number_of_lines)
        @f_last_mouse_button_activity_line = -1
      end
      return @f_last_mouse_button_activity_line
    end
    
    typesig { [::Java::Int] }
    # @see IVerticalRulerInfo#toDocumentLineNumber(int)
    def to_document_line_number(y_coordinate)
      if ((@f_text_viewer).nil? || (y_coordinate).equal?(-1))
        return -1
      end
      text = @f_text_viewer.get_text_widget
      line = text.get_line_index(y_coordinate)
      if ((line).equal?(text.get_line_count - 1))
        # check whether y_coordinate exceeds last line
        if (y_coordinate > text.get_line_pixel(line + 1))
          return -1
        end
      end
      return widget_line2model_line(@f_text_viewer, line)
    end
    
    class_module.module_eval {
      typesig { [ITextViewer, ::Java::Int] }
      # Returns the line of the viewer's document that corresponds to the given widget line.
      # 
      # @param viewer the viewer
      # @param widgetLine the widget line
      # @return the corresponding line of the viewer's document
      # @since 2.1
      def widget_line2model_line(viewer, widget_line)
        if (viewer.is_a?(ITextViewerExtension5))
          extension = viewer
          return extension.widget_line2model_line(widget_line)
        end
        begin
          r = viewer.get_visible_region
          d = viewer.get_document
          return widget_line += d.get_line_of_offset(r.get_offset)
        rescue BadLocationException => x
        end
        return widget_line
      end
    }
    
    typesig { [Font] }
    # @see IVerticalRulerExtension#setFont(Font)
    # @since 2.0
    def set_font(font)
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # @see IVerticalRulerExtension#setLocationOfLastMouseButtonActivity(int, int)
    # @since 2.0
    def set_location_of_last_mouse_button_activity(x, y)
      @f_last_mouse_button_activity_line = to_document_line_number(y)
    end
    
    typesig { [MouseListener] }
    # Adds the given mouse listener.
    # 
    # @param listener the listener to be added
    # @deprecated will be removed
    # @since 2.0
    def add_mouse_listener(listener)
      if (!(@f_canvas).nil? && !@f_canvas.is_disposed)
        @f_canvas.add_mouse_listener(listener)
      end
    end
    
    typesig { [MouseListener] }
    # Removes the given mouse listener.
    # 
    # @param listener the listener to be removed
    # @deprecated will be removed
    # @since 2.0
    def remove_mouse_listener(listener)
      if (!(@f_canvas).nil? && !@f_canvas.is_disposed)
        @f_canvas.remove_mouse_listener(listener)
      end
    end
    
    private
    alias_method :initialize__vertical_ruler, :initialize
  end
  
end
