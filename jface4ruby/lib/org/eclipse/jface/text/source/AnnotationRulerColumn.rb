require "rjava"

# Copyright (c) 2000, 2009 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
# Nikolay Botev <bono8106@hotmail.com> - [projection] Editor loses keyboard focus when expanding folded region - https://bugs.eclipse.org/bugs/show_bug.cgi?id=184255
module Org::Eclipse::Jface::Text::Source
  module AnnotationRulerColumnImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Source
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :Collections
      include_const ::Java::Util, :Comparator
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :HashSet
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :Map
      include_const ::Java::Util, :JavaSet
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Custom, :StyledText
      include_const ::Org::Eclipse::Swt::Events, :DisposeEvent
      include_const ::Org::Eclipse::Swt::Events, :DisposeListener
      include_const ::Org::Eclipse::Swt::Events, :MouseEvent
      include_const ::Org::Eclipse::Swt::Events, :MouseListener
      include_const ::Org::Eclipse::Swt::Events, :MouseMoveListener
      include_const ::Org::Eclipse::Swt::Events, :PaintEvent
      include_const ::Org::Eclipse::Swt::Events, :PaintListener
      include_const ::Org::Eclipse::Swt::Graphics, :Cursor
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
      include_const ::Org::Eclipse::Jface::Text, :TextEvent
    }
  end
  
  # A vertical ruler column showing graphical representations of annotations.
  # Will become final.
  # <p>
  # Do not subclass.
  # </p>
  # 
  # @since 2.0
  class AnnotationRulerColumn 
    include_class_members AnnotationRulerColumnImports
    include IVerticalRulerColumn
    include IVerticalRulerInfo
    include IVerticalRulerInfoExtension
    
    class_module.module_eval {
      # Internal listener class.
      const_set_lazy(:InternalListener) { Class.new do
        local_class_in AnnotationRulerColumn
        include_class_members AnnotationRulerColumn
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
          post_redraw
        end
        
        typesig { [class_self::TextEvent] }
        # @see ITextListener#textChanged(TextEvent)
        def text_changed(e)
          if (e.get_viewer_redraw_state)
            post_redraw
          end
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__internal_listener, :initialize
      end }
      
      # Implementation of <code>IRegion</code> that can be reused
      # by setting the offset and the length.
      const_set_lazy(:ReusableRegion) { Class.new(Position) do
        include_class_members AnnotationRulerColumn
        overload_protected {
          include IRegion
        }
        
        typesig { [] }
        def initialize
          super()
        end
        
        private
        alias_method :initialize__reusable_region, :initialize
      end }
      
      # Pair of an annotation and their associated position. Used inside the paint method
      # for sorting annotations based on the offset of their position.
      # @since 3.0
      const_set_lazy(:Tuple) { Class.new do
        include_class_members AnnotationRulerColumn
        
        attr_accessor :annotation
        alias_method :attr_annotation, :annotation
        undef_method :annotation
        alias_method :attr_annotation=, :annotation=
        undef_method :annotation=
        
        attr_accessor :position
        alias_method :attr_position, :position
        undef_method :position
        alias_method :attr_position=, :position=
        undef_method :position=
        
        typesig { [class_self::Annotation, class_self::Position] }
        def initialize(annotation, position)
          @annotation = nil
          @position = nil
          @annotation = annotation
          @position = position
        end
        
        private
        alias_method :initialize__tuple, :initialize
      end }
      
      # Comparator for <code>Tuple</code>s.
      # @since 3.0
      const_set_lazy(:TupleComparator) { Class.new do
        include_class_members AnnotationRulerColumn
        include Comparator
        
        typesig { [Object, Object] }
        # @see java.util.Comparator#compare(java.lang.Object, java.lang.Object)
        def compare(o1, o2)
          p1 = (o1).attr_position
          p2 = (o2).attr_position
          return p1.get_offset - p2.get_offset
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__tuple_comparator, :initialize
      end }
    }
    
    # This column's parent ruler
    attr_accessor :f_parent_ruler
    alias_method :attr_f_parent_ruler, :f_parent_ruler
    undef_method :f_parent_ruler
    alias_method :attr_f_parent_ruler=, :f_parent_ruler=
    undef_method :f_parent_ruler=
    
    # The cached text viewer
    attr_accessor :f_cached_text_viewer
    alias_method :attr_f_cached_text_viewer, :f_cached_text_viewer
    undef_method :f_cached_text_viewer
    alias_method :attr_f_cached_text_viewer=, :f_cached_text_viewer=
    undef_method :f_cached_text_viewer=
    
    # The cached text widget
    attr_accessor :f_cached_text_widget
    alias_method :attr_f_cached_text_widget, :f_cached_text_widget
    undef_method :f_cached_text_widget
    alias_method :attr_f_cached_text_widget=, :f_cached_text_widget=
    undef_method :f_cached_text_widget=
    
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
    
    # Switch for enabling/disabling the setModel method.
    attr_accessor :f_allow_set_model
    alias_method :attr_f_allow_set_model, :f_allow_set_model
    undef_method :f_allow_set_model
    alias_method :attr_f_allow_set_model=, :f_allow_set_model=
    undef_method :f_allow_set_model=
    
    # The list of annotation types to be shown in this ruler.
    # @since 3.0
    attr_accessor :f_configured_annotation_types
    alias_method :attr_f_configured_annotation_types, :f_configured_annotation_types
    undef_method :f_configured_annotation_types
    alias_method :attr_f_configured_annotation_types=, :f_configured_annotation_types=
    undef_method :f_configured_annotation_types=
    
    # The list of allowed annotation types to be shown in this ruler.
    # An allowed annotation type maps to <code>true</code>, a disallowed
    # to <code>false</code>.
    # @since 3.0
    attr_accessor :f_allowed_annotation_types
    alias_method :attr_f_allowed_annotation_types, :f_allowed_annotation_types
    undef_method :f_allowed_annotation_types
    alias_method :attr_f_allowed_annotation_types=, :f_allowed_annotation_types=
    undef_method :f_allowed_annotation_types=
    
    # The annotation access extension.
    # @since 3.0
    attr_accessor :f_annotation_access_extension
    alias_method :attr_f_annotation_access_extension, :f_annotation_access_extension
    undef_method :f_annotation_access_extension
    alias_method :attr_f_annotation_access_extension=, :f_annotation_access_extension=
    undef_method :f_annotation_access_extension=
    
    # The hover for this column.
    # @since 3.0
    attr_accessor :f_hover
    alias_method :attr_f_hover, :f_hover
    undef_method :f_hover
    alias_method :attr_f_hover=, :f_hover=
    undef_method :f_hover=
    
    # The cached annotations.
    # @since 3.0
    attr_accessor :f_cached_annotations
    alias_method :attr_f_cached_annotations, :f_cached_annotations
    undef_method :f_cached_annotations
    alias_method :attr_f_cached_annotations=, :f_cached_annotations=
    undef_method :f_cached_annotations=
    
    # The comparator for sorting annotations according to the offset of their position.
    # @since 3.0
    attr_accessor :f_tuple_comparator
    alias_method :attr_f_tuple_comparator, :f_tuple_comparator
    undef_method :f_tuple_comparator
    alias_method :attr_f_tuple_comparator=, :f_tuple_comparator=
    undef_method :f_tuple_comparator=
    
    # The hit detection cursor. Do not dispose.
    # @since 3.0
    attr_accessor :f_hit_detection_cursor
    alias_method :attr_f_hit_detection_cursor, :f_hit_detection_cursor
    undef_method :f_hit_detection_cursor
    alias_method :attr_f_hit_detection_cursor=, :f_hit_detection_cursor=
    undef_method :f_hit_detection_cursor=
    
    # The last cursor. Do not dispose.
    # @since 3.0
    attr_accessor :f_last_cursor
    alias_method :attr_f_last_cursor, :f_last_cursor
    undef_method :f_last_cursor
    alias_method :attr_f_last_cursor=, :f_last_cursor=
    undef_method :f_last_cursor=
    
    # This ruler's mouse listener.
    # @since 3.0
    attr_accessor :f_mouse_listener
    alias_method :attr_f_mouse_listener, :f_mouse_listener
    undef_method :f_mouse_listener
    alias_method :attr_f_mouse_listener=, :f_mouse_listener=
    undef_method :f_mouse_listener=
    
    typesig { [IAnnotationModel, ::Java::Int, IAnnotationAccess] }
    # Constructs this column with the given arguments.
    # 
    # @param model the annotation model to get the annotations from
    # @param width the width of the vertical ruler
    # @param annotationAccess the annotation access
    # @since 3.0
    def initialize(model, width, annotation_access)
      initialize__annotation_ruler_column(width, annotation_access)
      @f_allow_set_model = false
      @f_model = model
      @f_model.add_annotation_model_listener(@f_internal_listener)
    end
    
    typesig { [::Java::Int, IAnnotationAccess] }
    # Constructs this column with the given arguments.
    # 
    # @param width the width of the vertical ruler
    # @param annotationAccess the annotation access
    # @since 3.0
    def initialize(width, annotation_access)
      @f_parent_ruler = nil
      @f_cached_text_viewer = nil
      @f_cached_text_widget = nil
      @f_canvas = nil
      @f_model = nil
      @f_scroll_pos = 0
      @f_buffer = nil
      @f_internal_listener = InternalListener.new_local(self)
      @f_width = 0
      @f_allow_set_model = true
      @f_configured_annotation_types = HashSet.new
      @f_allowed_annotation_types = HashMap.new
      @f_annotation_access_extension = nil
      @f_hover = nil
      @f_cached_annotations = ArrayList.new
      @f_tuple_comparator = TupleComparator.new
      @f_hit_detection_cursor = nil
      @f_last_cursor = nil
      @f_mouse_listener = nil
      @f_width = width
      if (annotation_access.is_a?(IAnnotationAccessExtension))
        @f_annotation_access_extension = annotation_access
      end
    end
    
    typesig { [IAnnotationModel, ::Java::Int] }
    # Constructs this column with the given arguments.
    # 
    # @param model the annotation model to get the annotations from
    # @param width the width of the vertical ruler
    def initialize(model, width)
      @f_parent_ruler = nil
      @f_cached_text_viewer = nil
      @f_cached_text_widget = nil
      @f_canvas = nil
      @f_model = nil
      @f_scroll_pos = 0
      @f_buffer = nil
      @f_internal_listener = InternalListener.new_local(self)
      @f_width = 0
      @f_allow_set_model = true
      @f_configured_annotation_types = HashSet.new
      @f_allowed_annotation_types = HashMap.new
      @f_annotation_access_extension = nil
      @f_hover = nil
      @f_cached_annotations = ArrayList.new
      @f_tuple_comparator = TupleComparator.new
      @f_hit_detection_cursor = nil
      @f_last_cursor = nil
      @f_mouse_listener = nil
      @f_width = width
      @f_allow_set_model = false
      @f_model = model
      @f_model.add_annotation_model_listener(@f_internal_listener)
    end
    
    typesig { [::Java::Int] }
    # Constructs this column with the given width.
    # 
    # @param width the width of the vertical ruler
    def initialize(width)
      @f_parent_ruler = nil
      @f_cached_text_viewer = nil
      @f_cached_text_widget = nil
      @f_canvas = nil
      @f_model = nil
      @f_scroll_pos = 0
      @f_buffer = nil
      @f_internal_listener = InternalListener.new_local(self)
      @f_width = 0
      @f_allow_set_model = true
      @f_configured_annotation_types = HashSet.new
      @f_allowed_annotation_types = HashMap.new
      @f_annotation_access_extension = nil
      @f_hover = nil
      @f_cached_annotations = ArrayList.new
      @f_tuple_comparator = TupleComparator.new
      @f_hit_detection_cursor = nil
      @f_last_cursor = nil
      @f_mouse_listener = nil
      @f_width = width
    end
    
    typesig { [] }
    # @see IVerticalRulerColumn#getControl()
    def get_control
      return @f_canvas
    end
    
    typesig { [] }
    # @see IVerticalRulerColumn#getWidth()
    def get_width
      return @f_width
    end
    
    typesig { [CompositeRuler, Composite] }
    # @see IVerticalRulerColumn#createControl(CompositeRuler, Composite)
    def create_control(parent_ruler, parent_control)
      @f_parent_ruler = parent_ruler
      @f_cached_text_viewer = parent_ruler.get_text_viewer
      @f_cached_text_widget = @f_cached_text_viewer.get_text_widget
      @f_hit_detection_cursor = parent_control.get_display.get_system_cursor(SWT::CURSOR_HAND)
      @f_canvas = create_canvas(parent_control)
      @f_canvas.add_paint_listener(Class.new(PaintListener.class == Class ? PaintListener : Object) do
        local_class_in AnnotationRulerColumn
        include_class_members AnnotationRulerColumn
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
        local_class_in AnnotationRulerColumn
        include_class_members AnnotationRulerColumn
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
      @f_mouse_listener = Class.new(MouseListener.class == Class ? MouseListener : Object) do
        local_class_in AnnotationRulerColumn
        include_class_members AnnotationRulerColumn
        include MouseListener if MouseListener.class == Module
        
        typesig { [MouseEvent] }
        define_method :mouse_up do |event|
          line_number = 0
          if (is_propagating_mouse_listener)
            self.attr_f_parent_ruler.set_location_of_last_mouse_button_activity(event.attr_x, event.attr_y)
            line_number = self.attr_f_parent_ruler.get_line_of_last_mouse_button_activity
          else
            line_number = self.attr_f_parent_ruler.to_document_line_number(event.attr_y)
          end
          if ((1).equal?(event.attr_button))
            mouse_clicked(line_number)
          end
        end
        
        typesig { [MouseEvent] }
        define_method :mouse_down do |event|
          line_number = 0
          if (is_propagating_mouse_listener)
            self.attr_f_parent_ruler.set_location_of_last_mouse_button_activity(event.attr_x, event.attr_y)
            line_number = self.attr_f_parent_ruler.get_line_of_last_mouse_button_activity
          else
            line_number = self.attr_f_parent_ruler.to_document_line_number(event.attr_y)
          end
          if ((1).equal?(event.attr_button))
            @local_class_parent.mouse_down(line_number)
          end
        end
        
        typesig { [MouseEvent] }
        define_method :mouse_double_click do |event|
          line_number = 0
          if (is_propagating_mouse_listener)
            self.attr_f_parent_ruler.set_location_of_last_mouse_button_activity(event.attr_x, event.attr_y)
            line_number = self.attr_f_parent_ruler.get_line_of_last_mouse_button_activity
          else
            line_number = self.attr_f_parent_ruler.to_document_line_number(event.attr_y)
          end
          if ((1).equal?(event.attr_button))
            mouse_double_clicked(line_number)
          end
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
      @f_canvas.add_mouse_listener(@f_mouse_listener)
      @f_canvas.add_mouse_move_listener(Class.new(MouseMoveListener.class == Class ? MouseMoveListener : Object) do
        local_class_in AnnotationRulerColumn
        include_class_members AnnotationRulerColumn
        include MouseMoveListener if MouseMoveListener.class == Module
        
        typesig { [MouseEvent] }
        # @see org.eclipse.swt.events.MouseMoveListener#mouseMove(org.eclipse.swt.events.MouseEvent)
        # @since 3.0
        define_method :mouse_move do |e|
          handle_mouse_move(e)
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      if (!(@f_cached_text_viewer).nil?)
        @f_cached_text_viewer.add_viewport_listener(@f_internal_listener)
        @f_cached_text_viewer.add_text_listener(@f_internal_listener)
      end
      return @f_canvas
    end
    
    typesig { [Composite] }
    # Creates a canvas with the given parent.
    # 
    # @param parent the parent
    # @return the created canvas
    def create_canvas(parent)
      return Class.new(Canvas.class == Class ? Canvas : Object) do
        local_class_in AnnotationRulerColumn
        include_class_members AnnotationRulerColumn
        include Canvas if Canvas.class == Module
        
        typesig { [MouseListener] }
        # @see org.eclipse.swt.widgets.Control#addMouseListener(org.eclipse.swt.events.MouseListener)
        # @since 3.0
        define_method :add_mouse_listener do |listener|
          if (is_propagating_mouse_listener || (listener).equal?(self.attr_f_mouse_listener))
            super(listener)
          end
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self, parent, SWT::NO_BACKGROUND | SWT::NO_FOCUS)
    end
    
    typesig { [] }
    # Tells whether this ruler column propagates mouse listener
    # events to its parent.
    # 
    # @return <code>true</code> if propagating to parent
    # @since 3.0
    def is_propagating_mouse_listener
      return true
    end
    
    typesig { [::Java::Int] }
    # Hook method for a mouse down event on the given ruler line.
    # 
    # @param rulerLine the ruler line
    # @since 3.5
    def mouse_down(ruler_line)
    end
    
    typesig { [::Java::Int] }
    # Hook method for a mouse double click event on the given ruler line.
    # 
    # @param rulerLine the ruler line
    def mouse_double_clicked(ruler_line)
    end
    
    typesig { [::Java::Int] }
    # Hook method for a mouse click event on the given ruler line.
    # <p>
    # <strong>Note:</strong> The event is sent on mouse up.
    # </p>
    # 
    # @param rulerLine the ruler line
    # @since 3.0
    def mouse_clicked(ruler_line)
    end
    
    typesig { [MouseEvent] }
    # Handles mouse moves.
    # 
    # @param event the mouse move event
    def handle_mouse_move(event)
      @f_parent_ruler.set_location_of_last_mouse_button_activity(event.attr_x, event.attr_y)
      if (!(@f_cached_text_viewer).nil?)
        line = to_document_line_number(event.attr_y)
        cursor = (has_annotation(line) ? @f_hit_detection_cursor : nil)
        if (!(cursor).equal?(@f_last_cursor))
          @f_canvas.set_cursor(cursor)
          @f_last_cursor = cursor
        end
      end
    end
    
    typesig { [::Java::Int] }
    # Tells whether the given line contains an annotation.
    # 
    # @param lineNumber the line number
    # @return <code>true</code> if the given line contains an annotation
    def has_annotation(line_number)
      model = @f_model
      if (@f_model.is_a?(IAnnotationModelExtension))
        model = (@f_model).get_annotation_model(SourceViewer::MODEL_ANNOTATION_MODEL)
      end
      if ((model).nil?)
        return false
      end
      line = nil
      begin
        d = @f_cached_text_viewer.get_document
        if ((d).nil?)
          return false
        end
        line = d.get_line_information(line_number)
      rescue BadLocationException => ex
        return false
      end
      line_start = line.get_offset
      line_length = line.get_length
      e = nil
      if (@f_model.is_a?(IAnnotationModelExtension2))
        e = (@f_model).get_annotation_iterator(line_start, line_length + 1, true, true)
      else
        e = model.get_annotation_iterator
      end
      while (e.has_next)
        a = e.next_
        if (a.is_marked_deleted)
          next
        end
        if (skip(a))
          next
        end
        p = model.get_position(a)
        if ((p).nil? || p.is_deleted)
          next
        end
        if (p.overlaps_with(line_start, line_length) || (p.attr_length).equal?(0) && (p.attr_offset).equal?(line_start + line_length))
          return true
        end
      end
      return false
    end
    
    typesig { [] }
    # Disposes the ruler's resources.
    def handle_dispose
      if (!(@f_cached_text_viewer).nil?)
        @f_cached_text_viewer.remove_viewport_listener(@f_internal_listener)
        @f_cached_text_viewer.remove_text_listener(@f_internal_listener)
      end
      if (!(@f_model).nil?)
        @f_model.remove_annotation_model_listener(@f_internal_listener)
      end
      if (!(@f_buffer).nil?)
        @f_buffer.dispose
        @f_buffer = nil
      end
      @f_configured_annotation_types.clear
      @f_allowed_annotation_types.clear
      @f_annotation_access_extension = nil
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
      gc.set_font(@f_cached_text_widget.get_font)
      begin
        gc.set_background(@f_canvas.get_background)
        gc.fill_rectangle(0, 0, size.attr_x, size.attr_y)
        if (@f_cached_text_viewer.is_a?(ITextViewerExtension5))
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
    # Returns the document offset of the upper left corner of the source viewer's
    # view port, possibly including partially visible lines.
    # 
    # @return document offset of the upper left corner including partially visible lines
    def get_inclusive_top_index_start_offset
      if ((@f_cached_text_widget).nil? || @f_cached_text_widget.is_disposed)
        return -1
      end
      document = @f_cached_text_viewer.get_document
      if ((document).nil?)
        return -1
      end
      top = JFaceTextUtil.get_partial_top_index(@f_cached_text_viewer)
      begin
        return document.get_line_offset(top)
      rescue BadLocationException => x
        return -1
      end
    end
    
    typesig { [] }
    # Returns the first invisible document offset of the lower right corner of the source viewer's view port,
    # possibly including partially visible lines.
    # 
    # @return the first invisible document offset of the lower right corner of the view port
    def get_exclusive_bottom_index_end_offset
      if ((@f_cached_text_widget).nil? || @f_cached_text_widget.is_disposed)
        return -1
      end
      document = @f_cached_text_viewer.get_document
      if ((document).nil?)
        return -1
      end
      bottom = JFaceTextUtil.get_partial_bottom_index(@f_cached_text_viewer)
      begin
        if (bottom >= document.get_number_of_lines)
          bottom = document.get_number_of_lines - 1
        end
        return document.get_line_offset(bottom) + document.get_line_length(bottom)
      rescue BadLocationException => x
        return -1
      end
    end
    
    typesig { [SwtGC] }
    # Draws the vertical ruler w/o drawing the Canvas background.
    # 
    # @param gc the GC to draw into
    def do_paint(gc)
      if ((@f_model).nil? || (@f_cached_text_viewer).nil?)
        return
      end
      top_left = get_inclusive_top_index_start_offset
      # http://dev.eclipse.org/bugs/show_bug.cgi?id=14938
      # http://dev.eclipse.org/bugs/show_bug.cgi?id=22487
      # we want the exclusive offset (right after the last character)
      bottom_right = get_exclusive_bottom_index_end_offset
      view_port = bottom_right - top_left
      @f_scroll_pos = @f_cached_text_widget.get_top_pixel
      dimension = @f_canvas.get_size
      doc = @f_cached_text_viewer.get_document
      if ((doc).nil?)
        return
      end
      top_line = -1
      bottom_line = -1
      begin
        region = @f_cached_text_viewer.get_visible_region
        top_line = doc.get_line_of_offset(region.get_offset)
        bottom_line = doc.get_line_of_offset(region.get_offset + region.get_length)
      rescue BadLocationException => x
        return
      end
      # draw Annotations
      r = Rectangle.new(0, 0, 0, 0)
      max_layer = 1 # loop at least once through layers.
      layer = 0
      while layer < max_layer
        iter = nil
        if (@f_model.is_a?(IAnnotationModelExtension2))
          iter = (@f_model).get_annotation_iterator(top_left, view_port + 1, true, true)
        else
          iter = @f_model.get_annotation_iterator
        end
        while (iter.has_next)
          annotation = iter.next_
          lay = IAnnotationAccessExtension::DEFAULT_LAYER
          if (!(@f_annotation_access_extension).nil?)
            lay = @f_annotation_access_extension.get_layer(annotation)
          end
          max_layer = Math.max(max_layer, lay + 1) # dynamically update layer maximum
          if (!(lay).equal?(layer))
            # wrong layer: skip annotation
            next
          end
          if (skip(annotation))
            next
          end
          position = @f_model.get_position(annotation)
          if ((position).nil?)
            next
          end
          # https://bugs.eclipse.org/bugs/show_bug.cgi?id=20284
          # Position.overlapsWith returns false if the position just starts at the end
          # of the specified range. If the position has zero length, we want to include it anyhow
          view_port_size = (position.get_length).equal?(0) ? view_port + 1 : view_port
          if (!position.overlaps_with(top_left, view_port_size))
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
            r.attr_y = JFaceTextUtil.compute_line_height(@f_cached_text_widget, 0, start_line, start_line) - @f_scroll_pos
            r.attr_width = dimension.attr_x
            lines = end_line - start_line
            r.attr_height = JFaceTextUtil.compute_line_height(@f_cached_text_widget, start_line, end_line + 1, lines + 1)
            if (r.attr_y < dimension.attr_y && !(@f_annotation_access_extension).nil?)
              # annotation within visible area
              @f_annotation_access_extension.paint(annotation, gc, @f_canvas, r)
            end
          rescue BadLocationException => x
          end
        end
        layer += 1
      end
    end
    
    typesig { [SwtGC] }
    # Draws the vertical ruler w/o drawing the Canvas background. Implementation based
    # on <code>ITextViewerExtension5</code>. Will replace <code>doPaint(GC)</code>.
    # 
    # @param gc the GC to draw into
    def do_paint1(gc)
      if ((@f_model).nil? || (@f_cached_text_viewer).nil?)
        return
      end
      extension = @f_cached_text_viewer
      @f_scroll_pos = @f_cached_text_widget.get_top_pixel
      dimension = @f_canvas.get_size
      v_offset = get_inclusive_top_index_start_offset
      v_length = get_exclusive_bottom_index_end_offset - v_offset
      # draw Annotations
      r = Rectangle.new(0, 0, 0, 0)
      range = ReusableRegion.new
      min_layer = JavaInteger::MAX_VALUE
      max_layer = JavaInteger::MIN_VALUE
      @f_cached_annotations.clear
      iter = nil
      if (@f_model.is_a?(IAnnotationModelExtension2))
        iter = (@f_model).get_annotation_iterator(v_offset, v_length + 1, true, true)
      else
        iter = @f_model.get_annotation_iterator
      end
      while (iter.has_next)
        annotation = iter.next_
        if (skip(annotation))
          next
        end
        position = @f_model.get_position(annotation)
        if ((position).nil?)
          next
        end
        # https://bugs.eclipse.org/bugs/show_bug.cgi?id=217710
        extended_vlength = (position.get_length).equal?(0) ? v_length + 1 : v_length
        if (!position.overlaps_with(v_offset, extended_vlength))
          next
        end
        lay = IAnnotationAccessExtension::DEFAULT_LAYER
        if (!(@f_annotation_access_extension).nil?)
          lay = @f_annotation_access_extension.get_layer(annotation)
        end
        min_layer = Math.min(min_layer, lay)
        max_layer = Math.max(max_layer, lay)
        @f_cached_annotations.add(Tuple.new(annotation, position))
      end
      Collections.sort(@f_cached_annotations, @f_tuple_comparator)
      layer = min_layer
      while layer <= max_layer
        i = 0
        n = @f_cached_annotations.size
        while i < n
          tuple = @f_cached_annotations.get(i)
          annotation = tuple.attr_annotation
          position = tuple.attr_position
          lay = IAnnotationAccessExtension::DEFAULT_LAYER
          if (!(@f_annotation_access_extension).nil?)
            lay = @f_annotation_access_extension.get_layer(annotation)
          end
          if (!(lay).equal?(layer))
            # wrong layer: skip annotation
            i += 1
            next
          end
          range.set_offset(position.get_offset)
          range.set_length(position.get_length)
          widget_region = extension.model_range2widget_range(range)
          if ((widget_region).nil?)
            i += 1
            next
          end
          start_line = extension.widget_line_of_widget_offset(widget_region.get_offset)
          if ((start_line).equal?(-1))
            i += 1
            next
          end
          end_line = extension.widget_line_of_widget_offset(widget_region.get_offset + Math.max(widget_region.get_length - 1, 0))
          if ((end_line).equal?(-1))
            i += 1
            next
          end
          r.attr_x = 0
          r.attr_y = JFaceTextUtil.compute_line_height(@f_cached_text_widget, 0, start_line, start_line) - @f_scroll_pos
          r.attr_width = dimension.attr_x
          lines = end_line - start_line
          r.attr_height = JFaceTextUtil.compute_line_height(@f_cached_text_widget, start_line, end_line + 1, lines + 1)
          if (r.attr_y < dimension.attr_y && !(@f_annotation_access_extension).nil?)
            # annotation within visible area
            @f_annotation_access_extension.paint(annotation, gc, @f_canvas, r)
          end
          i += 1
        end
        layer += 1
      end
      @f_cached_annotations.clear
    end
    
    typesig { [] }
    # Post a redraw request for this column into the UI thread.
    def post_redraw
      if (!(@f_canvas).nil? && !@f_canvas.is_disposed)
        d = @f_canvas.get_display
        if (!(d).nil?)
          d.async_exec(Class.new(Runnable.class == Class ? Runnable : Object) do
            local_class_in AnnotationRulerColumn
            include_class_members AnnotationRulerColumn
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
    # @see IVerticalRulerColumn#redraw()
    def redraw
      if (!(@f_canvas).nil? && !@f_canvas.is_disposed)
        gc = SwtGC.new(@f_canvas)
        double_buffer_paint(gc)
        gc.dispose
      end
    end
    
    typesig { [IAnnotationModel] }
    # @see IVerticalRulerColumn#setModel
    def set_model(model)
      if (@f_allow_set_model && !(model).equal?(@f_model))
        if (!(@f_model).nil?)
          @f_model.remove_annotation_model_listener(@f_internal_listener)
        end
        @f_model = model
        if (!(@f_model).nil?)
          @f_model.add_annotation_model_listener(@f_internal_listener)
        end
        post_redraw
      end
    end
    
    typesig { [Font] }
    # @see IVerticalRulerColumn#setFont(Font)
    def set_font(font)
    end
    
    typesig { [] }
    # Returns the cached text viewer.
    # 
    # @return the cached text viewer
    def get_cached_text_viewer
      return @f_cached_text_viewer
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.source.IVerticalRulerInfoExtension#getModel()
    def get_model
      return @f_model
    end
    
    typesig { [Object] }
    # Adds the given annotation type to this annotation ruler column. Starting
    # with this call, annotations of the given type are shown in this annotation
    # ruler column.
    # 
    # @param annotationType the annotation type
    # @since 3.0
    def add_annotation_type(annotation_type)
      @f_configured_annotation_types.add(annotation_type)
      @f_allowed_annotation_types.clear
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.source.IVerticalRulerInfo#getLineOfLastMouseButtonActivity()
    # @since 3.0
    def get_line_of_last_mouse_button_activity
      return @f_parent_ruler.get_line_of_last_mouse_button_activity
    end
    
    typesig { [::Java::Int] }
    # @see org.eclipse.jface.text.source.IVerticalRulerInfo#toDocumentLineNumber(int)
    # @since 3.0
    def to_document_line_number(y_coordinate)
      return @f_parent_ruler.to_document_line_number(y_coordinate)
    end
    
    typesig { [Object] }
    # Removes the given annotation type from this annotation ruler column.
    # Annotations of the given type are no longer shown in this annotation
    # ruler column.
    # 
    # @param annotationType the annotation type
    # @since 3.0
    def remove_annotation_type(annotation_type)
      @f_configured_annotation_types.remove(annotation_type)
      @f_allowed_annotation_types.clear
    end
    
    typesig { [Annotation] }
    # Returns whether the given annotation should be skipped by the drawing
    # routine.
    # 
    # @param annotation the annotation
    # @return <code>true</code> if annotation of the given type should be
    # skipped, <code>false</code> otherwise
    # @since 3.0
    def skip(annotation)
      annotation_type = annotation.get_type
      allowed = @f_allowed_annotation_types.get(annotation_type)
      if (!(allowed).nil?)
        return !allowed.boolean_value
      end
      skip_ = skip(annotation_type)
      @f_allowed_annotation_types.put(annotation_type, !skip_ ? Boolean::TRUE : Boolean::FALSE)
      return skip_
    end
    
    typesig { [Object] }
    # Computes whether the annotation of the given type should be skipped or
    # not.
    # 
    # @param annotationType the annotation type
    # @return <code>true</code> if annotation should be skipped, <code>false</code>
    # otherwise
    # @since 3.0
    def skip(annotation_type)
      if (!(@f_annotation_access_extension).nil?)
        e = @f_configured_annotation_types.iterator
        while (e.has_next)
          if (@f_annotation_access_extension.is_subtype(annotation_type, e.next_))
            return false
          end
        end
        return true
      end
      return !@f_configured_annotation_types.contains(annotation_type)
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.source.IVerticalRulerInfoExtension#getHover()
    # @since 3.0
    def get_hover
      return @f_hover
    end
    
    typesig { [IAnnotationHover] }
    # @param hover The hover to set.
    # @since 3.0
    def set_hover(hover)
      @f_hover = hover
    end
    
    typesig { [IVerticalRulerListener] }
    # @see org.eclipse.jface.text.source.IVerticalRulerInfoExtension#addVerticalRulerListener(org.eclipse.jface.text.source.IVerticalRulerListener)
    # @since 3.0
    def add_vertical_ruler_listener(listener)
      raise UnsupportedOperationException.new
    end
    
    typesig { [IVerticalRulerListener] }
    # @see org.eclipse.jface.text.source.IVerticalRulerInfoExtension#removeVerticalRulerListener(org.eclipse.jface.text.source.IVerticalRulerListener)
    # @since 3.0
    def remove_vertical_ruler_listener(listener)
      raise UnsupportedOperationException.new
    end
    
    private
    alias_method :initialize__annotation_ruler_column, :initialize
  end
  
end
