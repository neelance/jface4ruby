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
  module ChangeRulerColumnImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Source
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Custom, :StyledText
      include_const ::Org::Eclipse::Swt::Events, :DisposeEvent
      include_const ::Org::Eclipse::Swt::Events, :DisposeListener
      include_const ::Org::Eclipse::Swt::Events, :MouseEvent
      include_const ::Org::Eclipse::Swt::Events, :MouseListener
      include_const ::Org::Eclipse::Swt::Events, :MouseMoveListener
      include_const ::Org::Eclipse::Swt::Events, :PaintEvent
      include_const ::Org::Eclipse::Swt::Events, :PaintListener
      include_const ::Org::Eclipse::Swt::Graphics, :Color
      include_const ::Org::Eclipse::Swt::Graphics, :Font
      include_const ::Org::Eclipse::Swt::Graphics, :GC
      include_const ::Org::Eclipse::Swt::Graphics, :Image
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Graphics, :Rectangle
      include_const ::Org::Eclipse::Swt::Widgets, :Canvas
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Display
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Jface::Internal::Text::Revisions, :RevisionPainter
      include_const ::Org::Eclipse::Jface::Internal::Text::Source, :DiffPainter
      include_const ::Org::Eclipse::Jface::Viewers, :ISelectionProvider
      include_const ::Org::Eclipse::Jface::Text, :BadLocationException
      include_const ::Org::Eclipse::Jface::Text, :IDocument
      include_const ::Org::Eclipse::Jface::Text, :IRegion
      include_const ::Org::Eclipse::Jface::Text, :ITextListener
      include_const ::Org::Eclipse::Jface::Text, :ITextViewer
      include_const ::Org::Eclipse::Jface::Text, :ITextViewerExtension5
      include_const ::Org::Eclipse::Jface::Text, :IViewportListener
      include_const ::Org::Eclipse::Jface::Text, :JFaceTextUtil
      include_const ::Org::Eclipse::Jface::Text, :TextEvent
      include_const ::Org::Eclipse::Jface::Text::Revisions, :IRevisionRulerColumn
      include_const ::Org::Eclipse::Jface::Text::Revisions, :RevisionInformation
    }
  end
  
  # A vertical ruler column displaying line numbers and serving as a UI for quick diff.
  # Clients instantiate and configure object of this class.
  # 
  # @since 3.0
  class ChangeRulerColumn 
    include_class_members ChangeRulerColumnImports
    include IVerticalRulerColumn
    include IVerticalRulerInfo
    include IVerticalRulerInfoExtension
    include IChangeRulerColumn
    include IRevisionRulerColumn
    
    class_module.module_eval {
      # Handles all the mouse interaction in this line number ruler column.
      const_set_lazy(:MouseHandler) { Class.new do
        extend LocalClass
        include_class_members ChangeRulerColumn
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
      
      # Internal listener class.
      const_set_lazy(:InternalListener) { Class.new do
        extend LocalClass
        include_class_members ChangeRulerColumn
        include IViewportListener
        include ITextListener
        
        typesig { [::Java::Int] }
        # @see IViewportListener#viewportChanged(int)
        def viewport_changed(vertical_position)
          if (!(vertical_position).equal?(self.attr_f_scroll_pos))
            redraw
          end
        end
        
        typesig { [class_self::TextEvent] }
        # @see ITextListener#textChanged(TextEvent)
        def text_changed(event)
          if (!event.get_viewer_redraw_state)
            return
          end
          if (self.attr_f_sensitive_to_text_changes || (event.get_document_event).nil?)
            post_redraw
          end
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__internal_listener, :initialize
      end }
    }
    
    # The view(port) listener.
    attr_accessor :f_internal_listener
    alias_method :attr_f_internal_listener, :f_internal_listener
    undef_method :f_internal_listener
    alias_method :attr_f_internal_listener=, :f_internal_listener=
    undef_method :f_internal_listener=
    
    # The mouse handler.
    # @since 3.2
    attr_accessor :f_mouse_handler
    alias_method :attr_f_mouse_handler, :f_mouse_handler
    undef_method :f_mouse_handler
    alias_method :attr_f_mouse_handler=, :f_mouse_handler=
    undef_method :f_mouse_handler=
    
    # The revision painter.
    # @since 3.2
    attr_accessor :f_revision_painter
    alias_method :attr_f_revision_painter, :f_revision_painter
    undef_method :f_revision_painter
    alias_method :attr_f_revision_painter=, :f_revision_painter=
    undef_method :f_revision_painter=
    
    # The diff info painter.
    # @since 3.2
    attr_accessor :f_diff_painter
    alias_method :attr_f_diff_painter, :f_diff_painter
    undef_method :f_diff_painter
    alias_method :attr_f_diff_painter=, :f_diff_painter=
    undef_method :f_diff_painter=
    
    # This column's parent ruler
    attr_accessor :f_parent_ruler
    alias_method :attr_f_parent_ruler, :f_parent_ruler
    undef_method :f_parent_ruler
    alias_method :attr_f_parent_ruler=, :f_parent_ruler=
    undef_method :f_parent_ruler=
    
    # Cached text viewer
    attr_accessor :f_cached_text_viewer
    alias_method :attr_f_cached_text_viewer, :f_cached_text_viewer
    undef_method :f_cached_text_viewer
    alias_method :attr_f_cached_text_viewer=, :f_cached_text_viewer=
    undef_method :f_cached_text_viewer=
    
    # Cached text widget
    attr_accessor :f_cached_text_widget
    alias_method :attr_f_cached_text_widget, :f_cached_text_widget
    undef_method :f_cached_text_widget
    alias_method :attr_f_cached_text_widget=, :f_cached_text_widget=
    undef_method :f_cached_text_widget=
    
    # The columns canvas
    attr_accessor :f_canvas
    alias_method :attr_f_canvas, :f_canvas
    undef_method :f_canvas
    alias_method :attr_f_canvas=, :f_canvas=
    undef_method :f_canvas=
    
    # The background color
    attr_accessor :f_background
    alias_method :attr_f_background, :f_background
    undef_method :f_background
    alias_method :attr_f_background=, :f_background=
    undef_method :f_background=
    
    # The ruler's annotation model.
    attr_accessor :f_annotation_model
    alias_method :attr_f_annotation_model, :f_annotation_model
    undef_method :f_annotation_model
    alias_method :attr_f_annotation_model=, :f_annotation_model=
    undef_method :f_annotation_model=
    
    # The width of the change ruler column.
    attr_accessor :f_width
    alias_method :attr_f_width, :f_width
    undef_method :f_width
    alias_method :attr_f_width=, :f_width=
    undef_method :f_width=
    
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
    
    # Indicates whether this column reacts on text change events
    attr_accessor :f_sensitive_to_text_changes
    alias_method :attr_f_sensitive_to_text_changes, :f_sensitive_to_text_changes
    undef_method :f_sensitive_to_text_changes
    alias_method :attr_f_sensitive_to_text_changes=, :f_sensitive_to_text_changes=
    undef_method :f_sensitive_to_text_changes=
    
    typesig { [] }
    # Creates a new ruler column.
    # 
    # @deprecated since 3.2 use {@link #ChangeRulerColumn(ISharedTextColors)} instead
    def initialize
      @f_internal_listener = InternalListener.new_local(self)
      @f_mouse_handler = MouseHandler.new_local(self)
      @f_revision_painter = nil
      @f_diff_painter = nil
      @f_parent_ruler = nil
      @f_cached_text_viewer = nil
      @f_cached_text_widget = nil
      @f_canvas = nil
      @f_background = nil
      @f_annotation_model = nil
      @f_width = 5
      @f_scroll_pos = 0
      @f_buffer = nil
      @f_sensitive_to_text_changes = false
      @f_revision_painter = nil
      @f_diff_painter = DiffPainter.new(self, nil)
    end
    
    typesig { [ISharedTextColors] }
    # Creates a new revision ruler column.
    # 
    # @param sharedColors the colors to look up RGBs
    # @since 3.2
    def initialize(shared_colors)
      @f_internal_listener = InternalListener.new_local(self)
      @f_mouse_handler = MouseHandler.new_local(self)
      @f_revision_painter = nil
      @f_diff_painter = nil
      @f_parent_ruler = nil
      @f_cached_text_viewer = nil
      @f_cached_text_widget = nil
      @f_canvas = nil
      @f_background = nil
      @f_annotation_model = nil
      @f_width = 5
      @f_scroll_pos = 0
      @f_buffer = nil
      @f_sensitive_to_text_changes = false
      Assert.is_not_null(shared_colors)
      @f_revision_painter = RevisionPainter.new(self, shared_colors)
      @f_diff_painter = DiffPainter.new(self, nil) # no shading
    end
    
    typesig { [] }
    # Returns the System background color for list widgets.
    # 
    # @return the System background color for list widgets
    def get_background
      if ((@f_background).nil?)
        return @f_cached_text_widget.get_display.get_system_color(SWT::COLOR_LIST_BACKGROUND)
      end
      return @f_background
    end
    
    typesig { [CompositeRuler, Composite] }
    # @see IVerticalRulerColumn#createControl(CompositeRuler, Composite)
    def create_control(parent_ruler, parent_control)
      @f_parent_ruler = parent_ruler
      @f_cached_text_viewer = parent_ruler.get_text_viewer
      @f_cached_text_widget = @f_cached_text_viewer.get_text_widget
      @f_canvas = Canvas.new(parent_control, SWT::NONE)
      @f_canvas.set_background(get_background)
      @f_canvas.add_paint_listener(Class.new(PaintListener.class == Class ? PaintListener : Object) do
        extend LocalClass
        include_class_members ChangeRulerColumn
        include PaintListener if PaintListener.class == Module
        
        typesig { [PaintEvent] }
        define_method :paint_control do |event|
          if (!(self.attr_f_cached_text_viewer).nil?)
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
        include_class_members ChangeRulerColumn
        include DisposeListener if DisposeListener.class == Module
        
        typesig { [DisposeEvent] }
        define_method :widget_disposed do |e|
          handle_dispose
          self.attr_f_cached_text_viewer = nil
          self.attr_f_cached_text_widget = nil
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
      if (!(@f_cached_text_viewer).nil?)
        @f_cached_text_viewer.add_viewport_listener(@f_internal_listener)
        @f_cached_text_viewer.add_text_listener(@f_internal_listener)
      end
      @f_revision_painter.set_parent_ruler(parent_ruler)
      @f_diff_painter.set_parent_ruler(parent_ruler)
      return @f_canvas
    end
    
    typesig { [] }
    # Disposes the column's resources.
    def handle_dispose
      if (!(@f_cached_text_viewer).nil?)
        @f_cached_text_viewer.remove_viewport_listener(@f_internal_listener)
        @f_cached_text_viewer.remove_text_listener(@f_internal_listener)
      end
      if (!(@f_buffer).nil?)
        @f_buffer.dispose
        @f_buffer = nil
      end
    end
    
    typesig { [GC] }
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
      gc = GC.new(@f_buffer)
      gc.set_font(@f_canvas.get_font)
      begin
        gc.set_background(get_background)
        gc.fill_rectangle(0, 0, size.attr_x, size.attr_y)
        do_paint(gc)
      ensure
        gc.dispose
      end
      dest.draw_image(@f_buffer, 0, 0)
    end
    
    typesig { [] }
    # Returns the view port height in lines.
    # 
    # @return the view port height in lines
    # @deprecated as of 3.2 the number of lines in the viewport cannot be computed because
    # StyledText supports variable line heights
    def get_visible_lines_in_viewport
      # Hack to reduce amount of copied code.
      return LineNumberRulerColumn.get_visible_lines_in_viewport(@f_cached_text_widget)
    end
    
    typesig { [] }
    # Returns <code>true</code> if the viewport displays the entire viewer contents, i.e. the
    # viewer is not vertically scrollable.
    # 
    # @return <code>true</code> if the viewport displays the entire contents, <code>false</code> otherwise
    # @since 3.2
    def is_viewer_completely_shown
      return JFaceTextUtil.is_showing_entire_contents(@f_cached_text_widget)
    end
    
    typesig { [GC] }
    # Draws the ruler column.
    # 
    # @param gc the GC to draw into
    def do_paint(gc)
      visible_model_lines = compute_visible_model_lines
      if ((visible_model_lines).nil?)
        return
      end
      @f_sensitive_to_text_changes = is_viewer_completely_shown
      @f_scroll_pos = @f_cached_text_widget.get_top_pixel
      @f_revision_painter.paint(gc, visible_model_lines)
      if (!@f_revision_painter.has_information)
        # don't paint quick diff colors if revisions are painted
        @f_diff_painter.paint(gc, visible_model_lines)
      end
    end
    
    typesig { [] }
    # @see IVerticalRulerColumn#redraw()
    def redraw
      if (!(@f_cached_text_viewer).nil? && !(@f_canvas).nil? && !@f_canvas.is_disposed)
        gc = GC.new(@f_canvas)
        double_buffer_paint(gc)
        gc.dispose
      end
    end
    
    typesig { [Font] }
    # @see IVerticalRulerColumn#setFont(Font)
    def set_font(font)
    end
    
    typesig { [] }
    # Returns the parent (composite) ruler of this ruler column.
    # 
    # @return the parent ruler
    # @since 3.0
    def get_parent_ruler
      return @f_parent_ruler
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
    
    typesig { [] }
    # @see org.eclipse.jface.text.source.IVerticalRulerInfoExtension#getHover()
    def get_hover
      active_line = get_parent_ruler.get_line_of_last_mouse_button_activity
      if (@f_revision_painter.has_hover(active_line))
        return @f_revision_painter.get_hover
      end
      if (@f_diff_painter.has_hover(active_line))
        return @f_diff_painter.get_hover
      end
      return nil
    end
    
    typesig { [IAnnotationHover] }
    # @see org.eclipse.jface.text.source.IChangeRulerColumn#setHover(org.eclipse.jface.text.source.IAnnotationHover)
    def set_hover(hover)
      @f_revision_painter.set_hover(hover)
      @f_diff_painter.set_hover(hover)
    end
    
    typesig { [IAnnotationModel] }
    # @see IVerticalRulerColumn#setModel(IAnnotationModel)
    def set_model(model)
      set_annotation_model(model)
      @f_revision_painter.set_model(model)
      @f_diff_painter.set_model(model)
    end
    
    typesig { [IAnnotationModel] }
    def set_annotation_model(model)
      if (!(@f_annotation_model).equal?(model))
        @f_annotation_model = model
      end
    end
    
    typesig { [Color] }
    # @see org.eclipse.jface.text.source.IChangeRulerColumn#setBackground(org.eclipse.swt.graphics.Color)
    def set_background(background)
      @f_background = background
      if (!(@f_canvas).nil? && !@f_canvas.is_disposed)
        @f_canvas.set_background(get_background)
      end
      @f_revision_painter.set_background(background)
      @f_diff_painter.set_background(background)
    end
    
    typesig { [Color] }
    # @see org.eclipse.jface.text.source.IChangeRulerColumn#setAddedColor(org.eclipse.swt.graphics.Color)
    def set_added_color(added_color)
      @f_diff_painter.set_added_color(added_color)
    end
    
    typesig { [Color] }
    # @see org.eclipse.jface.text.source.IChangeRulerColumn#setChangedColor(org.eclipse.swt.graphics.Color)
    def set_changed_color(changed_color)
      @f_diff_painter.set_changed_color(changed_color)
    end
    
    typesig { [Color] }
    # @see org.eclipse.jface.text.source.IChangeRulerColumn#setDeletedColor(org.eclipse.swt.graphics.Color)
    def set_deleted_color(deleted_color)
      @f_diff_painter.set_deleted_color(deleted_color)
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.source.IVerticalRulerInfoExtension#getModel()
    def get_model
      return @f_annotation_model
    end
    
    typesig { [] }
    # @see IVerticalRulerColumn#getControl()
    def get_control
      return @f_canvas
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.source.IVerticalRulerInfo#getWidth()
    def get_width
      return @f_width
    end
    
    typesig { [] }
    # Triggers a redraw in the display thread.
    def post_redraw
      if (!(@f_canvas).nil? && !@f_canvas.is_disposed)
        d = @f_canvas.get_display
        if (!(d).nil?)
          d.async_exec(Class.new(Runnable.class == Class ? Runnable : Object) do
            extend LocalClass
            include_class_members ChangeRulerColumn
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
    
    typesig { [] }
    # Computes the document based line range visible in the text widget.
    # 
    # @return the document based line range visible in the text widget
    # @since 3.2
    def compute_visible_model_lines
      doc = @f_cached_text_viewer.get_document
      if ((doc).nil?)
        return nil
      end
      top_line = 0
      coverage = nil
      if (@f_cached_text_viewer.is_a?(ITextViewerExtension5))
        extension = @f_cached_text_viewer
        # ITextViewer.getTopIndex returns the fully visible line, but we want the partially
        # visible one
        widget_top_line = JFaceTextUtil.get_partial_top_index(@f_cached_text_widget)
        top_line = extension.widget_line2model_line(widget_top_line)
        coverage = extension.get_model_coverage
      else
        top_line = JFaceTextUtil.get_partial_top_index(@f_cached_text_viewer)
        coverage = @f_cached_text_viewer.get_visible_region
      end
      bottom_line = @f_cached_text_viewer.get_bottom_index
      if (!(bottom_line).equal?(-1))
        (bottom_line += 1)
      end
      # clip by coverage window
      begin
        first_line = doc.get_line_of_offset(coverage.get_offset)
        if (first_line > top_line)
          top_line = first_line
        end
        last_line = doc.get_line_of_offset(coverage.get_offset + coverage.get_length)
        if (last_line < bottom_line || (bottom_line).equal?(-1))
          bottom_line = last_line
        end
      rescue BadLocationException => x
        x.print_stack_trace
        return nil
      end
      visible_model_lines = LineRange.new(top_line, bottom_line - top_line + 1)
      return visible_model_lines
    end
    
    typesig { [RevisionInformation] }
    # @see org.eclipse.jface.text.revisions.IRevisionRulerColumn#setRevisionInformation(org.eclipse.jface.text.revisions.RevisionInformation)
    def set_revision_information(info)
      @f_revision_painter.set_revision_information(info)
      @f_revision_painter.set_background(get_background)
    end
    
    typesig { [] }
    # Returns the revision selection provider.
    # 
    # @return the revision selection provider
    # @since 3.2
    def get_revision_selection_provider
      return @f_revision_painter.get_revision_selection_provider
    end
    
    private
    alias_method :initialize__change_ruler_column, :initialize
  end
  
end
