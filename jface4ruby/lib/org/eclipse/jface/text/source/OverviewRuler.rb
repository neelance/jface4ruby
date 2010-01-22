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
  module OverviewRulerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Source
      include_const ::Java::Util, :ArrayList
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
      include_const ::Org::Eclipse::Swt::Events, :MouseAdapter
      include_const ::Org::Eclipse::Swt::Events, :MouseEvent
      include_const ::Org::Eclipse::Swt::Events, :MouseMoveListener
      include_const ::Org::Eclipse::Swt::Events, :MouseTrackAdapter
      include_const ::Org::Eclipse::Swt::Events, :PaintEvent
      include_const ::Org::Eclipse::Swt::Events, :PaintListener
      include_const ::Org::Eclipse::Swt::Graphics, :Color
      include_const ::Org::Eclipse::Swt::Graphics, :Cursor
      include_const ::Org::Eclipse::Swt::Graphics, :SwtGC
      include_const ::Org::Eclipse::Swt::Graphics, :Image
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Graphics, :RGB
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
      include_const ::Org::Eclipse::Jface::Text, :JFaceTextUtil
      include_const ::Org::Eclipse::Jface::Text, :Position
      include_const ::Org::Eclipse::Jface::Text, :Region
      include_const ::Org::Eclipse::Jface::Text, :TextEvent
      include_const ::Org::Eclipse::Jface::Text::Source::Projection, :AnnotationBag
    }
  end
  
  # Ruler presented next to a source viewer showing all annotations of the
  # viewer's annotation model in a compact format. The ruler has the same height
  # as the source viewer.
  # <p>
  # Clients usually instantiate and configure objects of this class.</p>
  # 
  # @since 2.1
  class OverviewRuler 
    include_class_members OverviewRulerImports
    include IOverviewRuler
    
    class_module.module_eval {
      # Internal listener class.
      const_set_lazy(:InternalListener) { Class.new do
        extend LocalClass
        include_class_members OverviewRuler
        include ITextListener
        include IAnnotationModelListener
        include IAnnotationModelListenerExtension
        
        typesig { [class_self::TextEvent] }
        # @see ITextListener#textChanged
        def text_changed(e)
          if (!(self.attr_f_text_viewer).nil? && (e.get_document_event).nil? && e.get_viewer_redraw_state)
            # handle only changes of visible document
            redraw
          end
        end
        
        typesig { [class_self::IAnnotationModel] }
        # @see IAnnotationModelListener#modelChanged(IAnnotationModel)
        def model_changed(model)
          update
        end
        
        typesig { [class_self::AnnotationModelEvent] }
        # @see org.eclipse.jface.text.source.IAnnotationModelListenerExtension#modelChanged(org.eclipse.jface.text.source.AnnotationModelEvent)
        # @since 3.3
        def model_changed(event)
          if (!event.is_valid)
            return
          end
          if (event.is_world_change)
            update
            return
          end
          annotations = event.get_added_annotations
          length = annotations.attr_length
          i = 0
          while i < length
            if (!skip(annotations[i].get_type))
              update
              return
            end
            i += 1
          end
          annotations = event.get_removed_annotations
          length = annotations.attr_length
          i_ = 0
          while i_ < length
            if (!skip(annotations[i_].get_type))
              update
              return
            end
            i_ += 1
          end
          annotations = event.get_changed_annotations
          length = annotations.attr_length
          i__ = 0
          while i__ < length
            if (!skip(annotations[i__].get_type))
              update
              return
            end
            i__ += 1
          end
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__internal_listener, :initialize
      end }
      
      # Enumerates the annotations of a specified type and characteristics
      # of the associated annotation model.
      const_set_lazy(:FilterIterator) { Class.new do
        extend LocalClass
        include_class_members OverviewRuler
        include Iterator
        
        class_module.module_eval {
          const_set_lazy(:TEMPORARY) { 1 << 1 }
          const_attr_reader  :TEMPORARY
          
          const_set_lazy(:PERSISTENT) { 1 << 2 }
          const_attr_reader  :PERSISTENT
          
          const_set_lazy(:IGNORE_BAGS) { 1 << 3 }
          const_attr_reader  :IGNORE_BAGS
        }
        
        attr_accessor :f_iterator
        alias_method :attr_f_iterator, :f_iterator
        undef_method :f_iterator
        alias_method :attr_f_iterator=, :f_iterator=
        undef_method :f_iterator=
        
        attr_accessor :f_type
        alias_method :attr_f_type, :f_type
        undef_method :f_type
        alias_method :attr_f_type=, :f_type=
        undef_method :f_type=
        
        attr_accessor :f_next
        alias_method :attr_f_next, :f_next
        undef_method :f_next
        alias_method :attr_f_next=, :f_next=
        undef_method :f_next=
        
        attr_accessor :f_style
        alias_method :attr_f_style, :f_style
        undef_method :f_style
        alias_method :attr_f_style=, :f_style=
        undef_method :f_style=
        
        typesig { [Object, ::Java::Int] }
        # Creates a new filter iterator with the given specification.
        # 
        # @param annotationType the annotation type
        # @param style the style
        def initialize(annotation_type, style)
          @f_iterator = nil
          @f_type = nil
          @f_next = nil
          @f_style = 0
          @f_type = annotation_type
          @f_style = style
          if (!(self.attr_f_model).nil?)
            @f_iterator = self.attr_f_model.get_annotation_iterator
            skip
          end
        end
        
        typesig { [Object, ::Java::Int, class_self::Iterator] }
        # Creates a new filter iterator with the given specification.
        # 
        # @param annotationType the annotation type
        # @param style the style
        # @param iterator the iterator
        def initialize(annotation_type, style, iterator)
          @f_iterator = nil
          @f_type = nil
          @f_next = nil
          @f_style = 0
          @f_type = annotation_type
          @f_style = style
          @f_iterator = iterator
          skip
        end
        
        typesig { [] }
        def skip
          temp = !((@f_style & self.class::TEMPORARY)).equal?(0)
          pers = !((@f_style & self.class::PERSISTENT)).equal?(0)
          ignr = !((@f_style & self.class::IGNORE_BAGS)).equal?(0)
          while (@f_iterator.has_next)
            next__ = @f_iterator.next_
            if (next__.is_marked_deleted)
              next
            end
            if (ignr && (next__.is_a?(self.class::AnnotationBag)))
              next
            end
            @f_next = next__
            annotation_type = next__.get_type
            if ((@f_type).nil? || (@f_type == annotation_type) || !self.attr_f_configured_annotation_types.contains(annotation_type) && is_subtype(annotation_type))
              if (temp && pers)
                return
              end
              if (pers && next__.is_persistent)
                return
              end
              if (temp && !next__.is_persistent)
                return
              end
            end
          end
          @f_next = nil
        end
        
        typesig { [Object] }
        def is_subtype(annotation_type)
          if (self.attr_f_annotation_access.is_a?(self.class::IAnnotationAccessExtension))
            extension = self.attr_f_annotation_access
            return extension.is_subtype(annotation_type, @f_type)
          end
          return (@f_type == annotation_type)
        end
        
        typesig { [] }
        # @see Iterator#hasNext()
        def has_next
          return !(@f_next).nil?
        end
        
        typesig { [] }
        # @see Iterator#next()
        def next_
          begin
            return @f_next
          ensure
            if (!(@f_iterator).nil?)
              skip
            end
          end
        end
        
        typesig { [] }
        # @see Iterator#remove()
        def remove
          raise self.class::UnsupportedOperationException.new
        end
        
        private
        alias_method :initialize__filter_iterator, :initialize
      end }
      
      # The painter of the overview ruler's header.
      const_set_lazy(:HeaderPainter) { Class.new do
        extend LocalClass
        include_class_members OverviewRuler
        include PaintListener
        
        attr_accessor :f_indicator_color
        alias_method :attr_f_indicator_color, :f_indicator_color
        undef_method :f_indicator_color
        alias_method :attr_f_indicator_color=, :f_indicator_color=
        undef_method :f_indicator_color=
        
        attr_accessor :f_separator_color
        alias_method :attr_f_separator_color, :f_separator_color
        undef_method :f_separator_color
        alias_method :attr_f_separator_color=, :f_separator_color=
        undef_method :f_separator_color=
        
        typesig { [] }
        # Creates a new header painter.
        def initialize
          @f_indicator_color = nil
          @f_separator_color = nil
          @f_separator_color = self.attr_f_header.get_display.get_system_color(SWT::COLOR_WIDGET_NORMAL_SHADOW)
        end
        
        typesig { [class_self::Color] }
        # Sets the header color.
        # 
        # @param color the header color
        def set_color(color)
          @f_indicator_color = color
        end
        
        typesig { [SwtGC, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int, class_self::Color, class_self::Color] }
        def draw_bevel_rect(gc, x, y, w, h, top_left, bottom_right)
          gc.set_foreground((top_left).nil? ? @f_separator_color : top_left)
          gc.draw_line(x, y, x + w - 1, y)
          gc.draw_line(x, y, x, y + h - 1)
          gc.set_foreground((bottom_right).nil? ? @f_separator_color : bottom_right)
          gc.draw_line(x + w, y, x + w, y + h)
          gc.draw_line(x, y + h, x + w, y + h)
        end
        
        typesig { [class_self::PaintEvent] }
        def paint_control(e)
          if ((@f_indicator_color).nil?)
            return
          end
          s = self.attr_f_header.get_size
          e.attr_gc.set_background(@f_indicator_color)
          r = self.class::Rectangle.new(INSET, (s.attr_y - (2 * ANNOTATION_HEIGHT)) / 2, s.attr_x - (2 * INSET), 2 * ANNOTATION_HEIGHT)
          e.attr_gc.fill_rectangle(r)
          d = self.attr_f_header.get_display
          if (!(d).nil?)
            # drawBevelRect(e.gc, r.x, r.y, r.width -1, r.height -1, d.getSystemColor(SWT.COLOR_WIDGET_NORMAL_SHADOW), d.getSystemColor(SWT.COLOR_WIDGET_HIGHLIGHT_SHADOW));
            draw_bevel_rect(e.attr_gc, r.attr_x, r.attr_y, r.attr_width - 1, r.attr_height - 1, nil, nil)
          end
          e.attr_gc.set_foreground(@f_separator_color)
          e.attr_gc.set_line_width(0) # NOTE: 0 means width is 1 but with optimized performance
          e.attr_gc.draw_line(0, s.attr_y - 1, s.attr_x - 1, s.attr_y - 1)
        end
        
        private
        alias_method :initialize__header_painter, :initialize
      end }
      
      const_set_lazy(:INSET) { 2 }
      const_attr_reader  :INSET
      
      const_set_lazy(:ANNOTATION_HEIGHT) { 4 }
      const_attr_reader  :ANNOTATION_HEIGHT
      
      
      def annotation_height_scalable
        defined?(@@annotation_height_scalable) ? @@annotation_height_scalable : @@annotation_height_scalable= true
      end
      alias_method :attr_annotation_height_scalable, :annotation_height_scalable
      
      def annotation_height_scalable=(value)
        @@annotation_height_scalable = value
      end
      alias_method :attr_annotation_height_scalable=, :annotation_height_scalable=
    }
    
    # The model of the overview ruler
    attr_accessor :f_model
    alias_method :attr_f_model, :f_model
    undef_method :f_model
    alias_method :attr_f_model=, :f_model=
    undef_method :f_model=
    
    # The view to which this ruler is connected
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
    
    # The ruler's header
    attr_accessor :f_header
    alias_method :attr_f_header, :f_header
    undef_method :f_header
    alias_method :attr_f_header=, :f_header=
    undef_method :f_header=
    
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
    
    # The hit detection cursor. Do not dispose.
    attr_accessor :f_hit_detection_cursor
    alias_method :attr_f_hit_detection_cursor, :f_hit_detection_cursor
    undef_method :f_hit_detection_cursor
    alias_method :attr_f_hit_detection_cursor=, :f_hit_detection_cursor=
    undef_method :f_hit_detection_cursor=
    
    # The last cursor. Do not dispose.
    attr_accessor :f_last_cursor
    alias_method :attr_f_last_cursor, :f_last_cursor
    undef_method :f_last_cursor
    alias_method :attr_f_last_cursor=, :f_last_cursor=
    undef_method :f_last_cursor=
    
    # The line of the last mouse button activity
    attr_accessor :f_last_mouse_button_activity_line
    alias_method :attr_f_last_mouse_button_activity_line, :f_last_mouse_button_activity_line
    undef_method :f_last_mouse_button_activity_line
    alias_method :attr_f_last_mouse_button_activity_line=, :f_last_mouse_button_activity_line=
    undef_method :f_last_mouse_button_activity_line=
    
    # The actual annotation height
    attr_accessor :f_annotation_height
    alias_method :attr_f_annotation_height, :f_annotation_height
    undef_method :f_annotation_height
    alias_method :attr_f_annotation_height=, :f_annotation_height=
    undef_method :f_annotation_height=
    
    # The annotation access
    attr_accessor :f_annotation_access
    alias_method :attr_f_annotation_access, :f_annotation_access
    undef_method :f_annotation_access
    alias_method :attr_f_annotation_access=, :f_annotation_access=
    undef_method :f_annotation_access=
    
    # The header painter
    attr_accessor :f_header_painter
    alias_method :attr_f_header_painter, :f_header_painter
    undef_method :f_header_painter
    alias_method :attr_f_header_painter=, :f_header_painter=
    undef_method :f_header_painter=
    
    # The list of annotation types to be shown in this ruler.
    # @since 3.0
    attr_accessor :f_configured_annotation_types
    alias_method :attr_f_configured_annotation_types, :f_configured_annotation_types
    undef_method :f_configured_annotation_types
    alias_method :attr_f_configured_annotation_types=, :f_configured_annotation_types=
    undef_method :f_configured_annotation_types=
    
    # The list of annotation types to be shown in the header of this ruler.
    # @since 3.0
    attr_accessor :f_configured_header_annotation_types
    alias_method :attr_f_configured_header_annotation_types, :f_configured_header_annotation_types
    undef_method :f_configured_header_annotation_types
    alias_method :attr_f_configured_header_annotation_types=, :f_configured_header_annotation_types=
    undef_method :f_configured_header_annotation_types=
    
    # The mapping between annotation types and colors
    attr_accessor :f_annotation_types2colors
    alias_method :attr_f_annotation_types2colors, :f_annotation_types2colors
    undef_method :f_annotation_types2colors
    alias_method :attr_f_annotation_types2colors=, :f_annotation_types2colors=
    undef_method :f_annotation_types2colors=
    
    # The color manager
    attr_accessor :f_shared_text_colors
    alias_method :attr_f_shared_text_colors, :f_shared_text_colors
    undef_method :f_shared_text_colors
    alias_method :attr_f_shared_text_colors=, :f_shared_text_colors=
    undef_method :f_shared_text_colors=
    
    # All available annotation types sorted by layer.
    # 
    # @since 3.0
    attr_accessor :f_annotations_sorted_by_layer
    alias_method :attr_f_annotations_sorted_by_layer, :f_annotations_sorted_by_layer
    undef_method :f_annotations_sorted_by_layer
    alias_method :attr_f_annotations_sorted_by_layer=, :f_annotations_sorted_by_layer=
    undef_method :f_annotations_sorted_by_layer=
    
    # All available layers sorted by layer.
    # This list may contain duplicates.
    # @since 3.0
    attr_accessor :f_layers_sorted_by_layer
    alias_method :attr_f_layers_sorted_by_layer, :f_layers_sorted_by_layer
    undef_method :f_layers_sorted_by_layer
    alias_method :attr_f_layers_sorted_by_layer=, :f_layers_sorted_by_layer=
    undef_method :f_layers_sorted_by_layer=
    
    # Map of allowed annotation types.
    # An allowed annotation type maps to <code>true</code>, a disallowed
    # to <code>false</code>.
    # @since 3.0
    attr_accessor :f_allowed_annotation_types
    alias_method :attr_f_allowed_annotation_types, :f_allowed_annotation_types
    undef_method :f_allowed_annotation_types
    alias_method :attr_f_allowed_annotation_types=, :f_allowed_annotation_types=
    undef_method :f_allowed_annotation_types=
    
    # Map of allowed header annotation types.
    # An allowed annotation type maps to <code>true</code>, a disallowed
    # to <code>false</code>.
    # @since 3.0
    attr_accessor :f_allowed_header_annotation_types
    alias_method :attr_f_allowed_header_annotation_types, :f_allowed_header_annotation_types
    undef_method :f_allowed_header_annotation_types
    alias_method :attr_f_allowed_header_annotation_types=, :f_allowed_header_annotation_types=
    undef_method :f_allowed_header_annotation_types=
    
    # The cached annotations.
    # @since 3.0
    attr_accessor :f_cached_annotations
    alias_method :attr_f_cached_annotations, :f_cached_annotations
    undef_method :f_cached_annotations
    alias_method :attr_f_cached_annotations=, :f_cached_annotations=
    undef_method :f_cached_annotations=
    
    # Redraw runnable lock
    # @since 3.3
    attr_accessor :f_runnable_lock
    alias_method :attr_f_runnable_lock, :f_runnable_lock
    undef_method :f_runnable_lock
    alias_method :attr_f_runnable_lock=, :f_runnable_lock=
    undef_method :f_runnable_lock=
    
    # Redraw runnable state
    # @since 3.3
    attr_accessor :f_is_runnable_posted
    alias_method :attr_f_is_runnable_posted, :f_is_runnable_posted
    undef_method :f_is_runnable_posted
    alias_method :attr_f_is_runnable_posted=, :f_is_runnable_posted=
    undef_method :f_is_runnable_posted=
    
    # Redraw runnable
    # @since 3.3
    attr_accessor :f_runnable
    alias_method :attr_f_runnable, :f_runnable
    undef_method :f_runnable
    alias_method :attr_f_runnable=, :f_runnable=
    undef_method :f_runnable=
    
    # Tells whether temporary annotations are drawn with
    # a separate color. This color will be computed by
    # discoloring the original annotation color.
    # 
    # @since 3.4
    attr_accessor :f_is_temporary_annotation_discolored
    alias_method :attr_f_is_temporary_annotation_discolored, :f_is_temporary_annotation_discolored
    undef_method :f_is_temporary_annotation_discolored
    alias_method :attr_f_is_temporary_annotation_discolored=, :f_is_temporary_annotation_discolored=
    undef_method :f_is_temporary_annotation_discolored=
    
    typesig { [IAnnotationAccess, ::Java::Int, ISharedTextColors] }
    # Constructs a overview ruler of the given width using the given annotation access and the given
    # color manager.
    # <p><strong>Note:</strong> As of 3.4, temporary annotations are no longer discolored.
    # Use {@link #OverviewRuler(IAnnotationAccess, int, ISharedTextColors, boolean)} if you
    # want to keep the old behavior.</p>
    # 
    # @param annotationAccess the annotation access
    # @param width the width of the vertical ruler
    # @param sharedColors the color manager
    def initialize(annotation_access, width, shared_colors)
      initialize__overview_ruler(annotation_access, width, shared_colors, false)
    end
    
    typesig { [IAnnotationAccess, ::Java::Int, ISharedTextColors, ::Java::Boolean] }
    # Constructs a overview ruler of the given width using the given annotation
    # access and the given color manager.
    # 
    # @param annotationAccess the annotation access
    # @param width the width of the vertical ruler
    # @param sharedColors the color manager
    # @param discolorTemporaryAnnotation <code>true</code> if temporary annotations should be discolored
    # @since 3.4
    def initialize(annotation_access, width, shared_colors, discolor_temporary_annotation)
      @f_model = nil
      @f_text_viewer = nil
      @f_canvas = nil
      @f_header = nil
      @f_buffer = nil
      @f_internal_listener = InternalListener.new_local(self)
      @f_width = 0
      @f_hit_detection_cursor = nil
      @f_last_cursor = nil
      @f_last_mouse_button_activity_line = -1
      @f_annotation_height = -1
      @f_annotation_access = nil
      @f_header_painter = nil
      @f_configured_annotation_types = HashSet.new
      @f_configured_header_annotation_types = HashSet.new
      @f_annotation_types2colors = HashMap.new
      @f_shared_text_colors = nil
      @f_annotations_sorted_by_layer = ArrayList.new
      @f_layers_sorted_by_layer = ArrayList.new
      @f_allowed_annotation_types = HashMap.new
      @f_allowed_header_annotation_types = HashMap.new
      @f_cached_annotations = ArrayList.new
      @f_runnable_lock = Object.new
      @f_is_runnable_posted = false
      @f_runnable = Class.new(Runnable.class == Class ? Runnable : Object) do
        extend LocalClass
        include_class_members OverviewRuler
        include Runnable if Runnable.class == Module
        
        typesig { [] }
        define_method :run do
          synchronized((self.attr_f_runnable_lock)) do
            self.attr_f_is_runnable_posted = false
          end
          redraw
          update_header
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
      @f_is_temporary_annotation_discolored = false
      @f_annotation_access = annotation_access
      @f_width = width
      @f_shared_text_colors = shared_colors
      @f_is_temporary_annotation_discolored = discolor_temporary_annotation
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.source.IVerticalRulerInfo#getControl()
    def get_control
      return @f_canvas
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.source.IVerticalRulerInfo#getWidth()
    def get_width
      return @f_width
    end
    
    typesig { [IAnnotationModel] }
    # @see org.eclipse.jface.text.source.IVerticalRuler#setModel(org.eclipse.jface.text.source.IAnnotationModel)
    def set_model(model)
      if (!(model).equal?(@f_model) || !(model).nil?)
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
    
    typesig { [Composite, ITextViewer] }
    # @see org.eclipse.jface.text.source.IVerticalRuler#createControl(org.eclipse.swt.widgets.Composite, org.eclipse.jface.text.ITextViewer)
    def create_control(parent, text_viewer)
      @f_text_viewer = text_viewer
      @f_hit_detection_cursor = parent.get_display.get_system_cursor(SWT::CURSOR_HAND)
      @f_header = Canvas.new(parent, SWT::NONE)
      if (@f_annotation_access.is_a?(IAnnotationAccessExtension))
        @f_header.add_mouse_track_listener(Class.new(MouseTrackAdapter.class == Class ? MouseTrackAdapter : Object) do
          extend LocalClass
          include_class_members OverviewRuler
          include MouseTrackAdapter if MouseTrackAdapter.class == Module
          
          typesig { [MouseEvent] }
          # @see org.eclipse.swt.events.MouseTrackAdapter#mouseHover(org.eclipse.swt.events.MouseEvent)
          # @since 3.3
          define_method :mouse_enter do |e|
            update_header_tool_tip_text
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      end
      @f_canvas = Canvas.new(parent, SWT::NO_BACKGROUND)
      @f_canvas.add_paint_listener(Class.new(PaintListener.class == Class ? PaintListener : Object) do
        extend LocalClass
        include_class_members OverviewRuler
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
        include_class_members OverviewRuler
        include DisposeListener if DisposeListener.class == Module
        
        typesig { [DisposeEvent] }
        define_method :widget_disposed do |event|
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
      @f_canvas.add_mouse_listener(Class.new(MouseAdapter.class == Class ? MouseAdapter : Object) do
        extend LocalClass
        include_class_members OverviewRuler
        include MouseAdapter if MouseAdapter.class == Module
        
        typesig { [MouseEvent] }
        define_method :mouse_down do |event|
          handle_mouse_down(event)
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      @f_canvas.add_mouse_move_listener(Class.new(MouseMoveListener.class == Class ? MouseMoveListener : Object) do
        extend LocalClass
        include_class_members OverviewRuler
        include MouseMoveListener if MouseMoveListener.class == Module
        
        typesig { [MouseEvent] }
        define_method :mouse_move do |event|
          handle_mouse_move(event)
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      if (!(@f_text_viewer).nil?)
        @f_text_viewer.add_text_listener(@f_internal_listener)
      end
      return @f_canvas
    end
    
    typesig { [] }
    # Disposes the ruler's resources.
    def handle_dispose
      if (!(@f_text_viewer).nil?)
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
      @f_configured_annotation_types.clear
      @f_allowed_annotation_types.clear
      @f_configured_header_annotation_types.clear
      @f_allowed_header_annotation_types.clear
      @f_annotation_types2colors.clear
      @f_annotations_sorted_by_layer.clear
      @f_layers_sorted_by_layer.clear
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
      begin
        gc.set_background(@f_canvas.get_background)
        gc.fill_rectangle(0, 0, size.attr_x, size.attr_y)
        cache_annotations
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
    
    typesig { [SwtGC] }
    # Draws this overview ruler.
    # 
    # @param gc the GC to draw into
    def do_paint(gc)
      r = Rectangle.new(0, 0, 0, 0)
      yy = 0
      hh = ANNOTATION_HEIGHT
      document = @f_text_viewer.get_document
      visible = @f_text_viewer.get_visible_region
      text_widget = @f_text_viewer.get_text_widget
      max_lines = text_widget.get_line_count
      size = @f_canvas.get_size
      writable = JFaceTextUtil.compute_line_height(text_widget, 0, max_lines, max_lines)
      if (size.attr_y > writable)
        size.attr_y = Math.max(writable - @f_header.get_size.attr_y, 0)
      end
      iterator_ = @f_annotations_sorted_by_layer.iterator
      while iterator_.has_next
        annotation_type = iterator_.next_
        if (skip(annotation_type))
          next
        end
        style = Array.typed(::Java::Int).new([FilterIterator::PERSISTENT, FilterIterator::TEMPORARY])
        t = 0
        while t < style.attr_length
          e = FilterIterator.new_local(self, annotation_type, style[t], @f_cached_annotations.iterator)
          are_colors_computed = false
          fill = nil
          stroke = nil
          i = 0
          while e.has_next
            a = e.next_
            p = @f_model.get_position(a)
            if ((p).nil? || !p.overlaps_with(visible.get_offset, visible.get_length))
              i += 1
              next
            end
            annotation_offset = Math.max(p.get_offset, visible.get_offset)
            annotation_end = Math.min(p.get_offset + p.get_length, visible.get_offset + visible.get_length)
            annotation_length = annotation_end - annotation_offset
            begin
              if (self.attr_annotation_height_scalable)
                numbers_of_lines = document.get_number_of_lines(annotation_offset, annotation_length)
                # don't count empty trailing lines
                last_line = document.get_line_information_of_offset(annotation_offset + annotation_length)
                if ((last_line.get_offset).equal?(annotation_offset + annotation_length))
                  numbers_of_lines -= 2
                  hh = (numbers_of_lines * size.attr_y) / max_lines + ANNOTATION_HEIGHT
                  if (hh < ANNOTATION_HEIGHT)
                    hh = ANNOTATION_HEIGHT
                  end
                else
                  hh = ANNOTATION_HEIGHT
                end
              end
              @f_annotation_height = hh
              start_line = text_widget.get_line_at_offset(annotation_offset - visible.get_offset)
              yy = Math.min((start_line * size.attr_y) / max_lines, size.attr_y - hh)
              if (!are_colors_computed)
                fill = get_fill_color(annotation_type, (style[t]).equal?(FilterIterator::TEMPORARY))
                stroke = get_stroke_color(annotation_type, (style[t]).equal?(FilterIterator::TEMPORARY))
                are_colors_computed = true
              end
              if (!(fill).nil?)
                gc.set_background(fill)
                gc.fill_rectangle(INSET, yy, size.attr_x - (2 * INSET), hh)
              end
              if (!(stroke).nil?)
                gc.set_foreground(stroke)
                r.attr_x = INSET
                r.attr_y = yy
                r.attr_width = size.attr_x - (2 * INSET)
                r.attr_height = hh
                gc.set_line_width(0) # NOTE: 0 means width is 1 but with optimized performance
                gc.draw_rectangle(r)
              end
            rescue BadLocationException => x
            end
            i += 1
          end
          t += 1
        end
      end
    end
    
    typesig { [] }
    def cache_annotations
      @f_cached_annotations.clear
      if (!(@f_model).nil?)
        iter = @f_model.get_annotation_iterator
        while (iter.has_next)
          annotation = iter.next_
          if (annotation.is_marked_deleted)
            next
          end
          if (skip(annotation.get_type))
            next
          end
          @f_cached_annotations.add(annotation)
        end
      end
    end
    
    typesig { [SwtGC] }
    # Draws this overview ruler. Uses <code>ITextViewerExtension5</code> for
    # its implementation. Will replace <code>doPaint(GC)</code>.
    # 
    # @param gc the GC to draw into
    def do_paint1(gc)
      r = Rectangle.new(0, 0, 0, 0)
      yy = 0
      hh = ANNOTATION_HEIGHT
      extension = @f_text_viewer
      document = @f_text_viewer.get_document
      text_widget = @f_text_viewer.get_text_widget
      max_lines = text_widget.get_line_count
      size = @f_canvas.get_size
      writable = JFaceTextUtil.compute_line_height(text_widget, 0, max_lines, max_lines)
      if (size.attr_y > writable)
        size.attr_y = Math.max(writable - @f_header.get_size.attr_y, 0)
      end
      iterator_ = @f_annotations_sorted_by_layer.iterator
      while iterator_.has_next
        annotation_type = iterator_.next_
        if (skip(annotation_type))
          next
        end
        style = Array.typed(::Java::Int).new([FilterIterator::PERSISTENT, FilterIterator::TEMPORARY])
        t = 0
        while t < style.attr_length
          e = FilterIterator.new_local(self, annotation_type, style[t], @f_cached_annotations.iterator)
          are_colors_computed = false
          fill = nil
          stroke = nil
          i = 0
          while e.has_next
            a = e.next_
            p = @f_model.get_position(a)
            if ((p).nil?)
              i += 1
              next
            end
            widget_region = extension.model_range2widget_range(Region.new(p.get_offset, p.get_length))
            if ((widget_region).nil?)
              i += 1
              next
            end
            begin
              if (self.attr_annotation_height_scalable)
                numbers_of_lines = document.get_number_of_lines(p.get_offset, p.get_length)
                # don't count empty trailing lines
                last_line = document.get_line_information_of_offset(p.get_offset + p.get_length)
                if ((last_line.get_offset).equal?(p.get_offset + p.get_length))
                  numbers_of_lines -= 2
                  hh = (numbers_of_lines * size.attr_y) / max_lines + ANNOTATION_HEIGHT
                  if (hh < ANNOTATION_HEIGHT)
                    hh = ANNOTATION_HEIGHT
                  end
                else
                  hh = ANNOTATION_HEIGHT
                end
              end
              @f_annotation_height = hh
              start_line = text_widget.get_line_at_offset(widget_region.get_offset)
              yy = Math.min((start_line * size.attr_y) / max_lines, size.attr_y - hh)
              if (!are_colors_computed)
                fill = get_fill_color(annotation_type, (style[t]).equal?(FilterIterator::TEMPORARY))
                stroke = get_stroke_color(annotation_type, (style[t]).equal?(FilterIterator::TEMPORARY))
                are_colors_computed = true
              end
              if (!(fill).nil?)
                gc.set_background(fill)
                gc.fill_rectangle(INSET, yy, size.attr_x - (2 * INSET), hh)
              end
              if (!(stroke).nil?)
                gc.set_foreground(stroke)
                r.attr_x = INSET
                r.attr_y = yy
                r.attr_width = size.attr_x - (2 * INSET)
                r.attr_height = hh
                gc.set_line_width(0) # NOTE: 0 means width is 1 but with optimized performance
                gc.draw_rectangle(r)
              end
            rescue BadLocationException => x
            end
            i += 1
          end
          t += 1
        end
      end
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.source.IVerticalRuler#update()
    def update
      if (!(@f_canvas).nil? && !@f_canvas.is_disposed)
        d = @f_canvas.get_display
        if (!(d).nil?)
          synchronized((@f_runnable_lock)) do
            if (@f_is_runnable_posted)
              return
            end
            @f_is_runnable_posted = true
          end
          d.async_exec(@f_runnable)
        end
      end
    end
    
    typesig { [] }
    # Redraws the overview ruler.
    def redraw
      if ((@f_text_viewer).nil? || (@f_model).nil?)
        return
      end
      if (!(@f_canvas).nil? && !@f_canvas.is_disposed)
        gc = SwtGC.new(@f_canvas)
        double_buffer_paint(gc)
        gc.dispose
      end
    end
    
    typesig { [::Java::Int] }
    # Translates a given y-coordinate of this ruler into the corresponding
    # document lines. The number of lines depends on the concrete scaling
    # given as the ration between the height of this ruler and the length
    # of the document.
    # 
    # @param y_coordinate the y-coordinate
    # @return the corresponding document lines
    def to_line_numbers(y_coordinate)
      text_widget = @f_text_viewer.get_text_widget
      max_lines = text_widget.get_content.get_line_count
      ruler_length = @f_canvas.get_size.attr_y
      writable = JFaceTextUtil.compute_line_height(text_widget, 0, max_lines, max_lines)
      if (ruler_length > writable)
        ruler_length = Math.max(writable - @f_header.get_size.attr_y, 0)
      end
      if (y_coordinate >= writable || y_coordinate >= ruler_length)
        return Array.typed(::Java::Int).new([-1, -1])
      end
      lines = Array.typed(::Java::Int).new(2) { 0 }
      pixel0 = Math.max(y_coordinate - 1, 0)
      pixel1 = Math.min(ruler_length, y_coordinate + 1)
      ruler_length = Math.max(ruler_length, 1)
      lines[0] = (pixel0 * max_lines) / ruler_length
      lines[1] = (pixel1 * max_lines) / ruler_length
      if (@f_text_viewer.is_a?(ITextViewerExtension5))
        extension = @f_text_viewer
        lines[0] = extension.widget_line2model_line(lines[0])
        lines[1] = extension.widget_line2model_line(lines[1])
      else
        begin
          visible = @f_text_viewer.get_visible_region
          line_number = @f_text_viewer.get_document.get_line_of_offset(visible.get_offset)
          lines[0] += line_number
          lines[1] += line_number
        rescue BadLocationException => x
        end
      end
      return lines
    end
    
    typesig { [Array.typed(::Java::Int)] }
    # Returns the position of the first annotation found in the given line range.
    # 
    # @param lineNumbers the line range
    # @return the position of the first found annotation
    def get_annotation_position(line_numbers)
      if ((line_numbers[0]).equal?(-1))
        return nil
      end
      found = nil
      begin
        d = @f_text_viewer.get_document
        line = d.get_line_information(line_numbers[0])
        start = line.get_offset
        line = d.get_line_information(line_numbers[line_numbers.attr_length - 1])
        end_ = line.get_offset + line.get_length
        i = @f_annotations_sorted_by_layer.size - 1
        while i >= 0
          annotation_type = @f_annotations_sorted_by_layer.get(i)
          e = FilterIterator.new_local(self, annotation_type, FilterIterator::PERSISTENT | FilterIterator::TEMPORARY)
          while (e.has_next && (found).nil?)
            a = e.next_
            if (a.is_marked_deleted)
              next
            end
            if (skip(a.get_type))
              next
            end
            p = @f_model.get_position(a)
            if ((p).nil?)
              next
            end
            pos_offset = p.get_offset
            pos_end = pos_offset + p.get_length
            region = d.get_line_information_of_offset(pos_end)
            # trailing empty lines don't count
            if (pos_end > pos_offset && (region.get_offset).equal?(pos_end))
              pos_end -= 1
              region = d.get_line_information_of_offset(pos_end)
            end
            if (pos_offset <= end_ && pos_end >= start)
              found = p
            end
          end
          i -= 1
        end
      rescue BadLocationException => x
      end
      return found
    end
    
    typesig { [Array.typed(::Java::Int)] }
    # Returns the line which  corresponds best to one of
    # the underlying annotations at the given y-coordinate.
    # 
    # @param lineNumbers the line numbers
    # @return the best matching line or <code>-1</code> if no such line can be found
    def find_best_matching_line_number(line_numbers)
      if ((line_numbers).nil? || line_numbers.attr_length < 1)
        return -1
      end
      begin
        pos = get_annotation_position(line_numbers)
        if ((pos).nil?)
          return -1
        end
        return @f_text_viewer.get_document.get_line_of_offset(pos.get_offset)
      rescue BadLocationException => ex
        return -1
      end
    end
    
    typesig { [MouseEvent] }
    # Handles mouse clicks.
    # 
    # @param event the mouse button down event
    def handle_mouse_down(event)
      if (!(@f_text_viewer).nil?)
        lines = to_line_numbers(event.attr_y)
        p = get_annotation_position(lines)
        if ((p).nil? && (event.attr_button).equal?(1))
          begin
            p = Position.new(@f_text_viewer.get_document.get_line_information(lines[0]).get_offset, 0)
          rescue BadLocationException => e
            # do nothing
          end
        end
        if (!(p).nil?)
          @f_text_viewer.reveal_range(p.get_offset, p.get_length)
          @f_text_viewer.set_selected_range(p.get_offset, p.get_length)
        end
        @f_text_viewer.get_text_widget.set_focus
      end
      @f_last_mouse_button_activity_line = to_document_line_number(event.attr_y)
    end
    
    typesig { [MouseEvent] }
    # Handles mouse moves.
    # 
    # @param event the mouse move event
    def handle_mouse_move(event)
      if (!(@f_text_viewer).nil?)
        lines = to_line_numbers(event.attr_y)
        p = get_annotation_position(lines)
        cursor = (!(p).nil? ? @f_hit_detection_cursor : nil)
        if (!(cursor).equal?(@f_last_cursor))
          @f_canvas.set_cursor(cursor)
          @f_last_cursor = cursor
        end
      end
    end
    
    typesig { [Object] }
    # @see org.eclipse.jface.text.source.IOverviewRuler#addAnnotationType(java.lang.Object)
    def add_annotation_type(annotation_type)
      @f_configured_annotation_types.add(annotation_type)
      @f_allowed_annotation_types.clear
    end
    
    typesig { [Object] }
    # @see org.eclipse.jface.text.source.IOverviewRuler#removeAnnotationType(java.lang.Object)
    def remove_annotation_type(annotation_type)
      @f_configured_annotation_types.remove(annotation_type)
      @f_allowed_annotation_types.clear
    end
    
    typesig { [Object, ::Java::Int] }
    # @see org.eclipse.jface.text.source.IOverviewRuler#setAnnotationTypeLayer(java.lang.Object, int)
    def set_annotation_type_layer(annotation_type, layer)
      j = @f_annotations_sorted_by_layer.index_of(annotation_type)
      if (!(j).equal?(-1))
        @f_annotations_sorted_by_layer.remove(j)
        @f_layers_sorted_by_layer.remove(j)
      end
      if (layer >= 0)
        i = 0
        size_ = @f_layers_sorted_by_layer.size
        while (i < size_ && layer >= (@f_layers_sorted_by_layer.get(i)).int_value)
          i += 1
        end
        layer_obj = layer
        @f_layers_sorted_by_layer.add(i, layer_obj)
        @f_annotations_sorted_by_layer.add(i, annotation_type)
      end
    end
    
    typesig { [Object, Color] }
    # @see org.eclipse.jface.text.source.IOverviewRuler#setAnnotationTypeColor(java.lang.Object, org.eclipse.swt.graphics.Color)
    def set_annotation_type_color(annotation_type, color)
      if (!(color).nil?)
        @f_annotation_types2colors.put(annotation_type, color)
      else
        @f_annotation_types2colors.remove(annotation_type)
      end
    end
    
    typesig { [Object] }
    # Returns whether the given annotation type should be skipped by the drawing routine.
    # 
    # @param annotationType the annotation type
    # @return <code>true</code> if annotation of the given type should be skipped
    def skip(annotation_type)
      return !contains(annotation_type, @f_allowed_annotation_types, @f_configured_annotation_types)
    end
    
    typesig { [Object] }
    # Returns whether the given annotation type should be skipped by the drawing routine of the header.
    # 
    # @param annotationType the annotation type
    # @return <code>true</code> if annotation of the given type should be skipped
    # @since 3.0
    def skip_in_header(annotation_type)
      return !contains(annotation_type, @f_allowed_header_annotation_types, @f_configured_header_annotation_types)
    end
    
    typesig { [Object, Map, JavaSet] }
    # Returns whether the given annotation type is mapped to <code>true</code>
    # in the given <code>allowed</code> map or covered by the <code>configured</code>
    # set.
    # 
    # @param annotationType the annotation type
    # @param allowed the map with allowed annotation types mapped to booleans
    # @param configured the set with configured annotation types
    # @return <code>true</code> if annotation is contained, <code>false</code>
    # otherwise
    # @since 3.0
    def contains(annotation_type, allowed, configured)
      cached = allowed.get(annotation_type)
      if (!(cached).nil?)
        return cached.boolean_value
      end
      covered = is_covered(annotation_type, configured)
      allowed.put(annotation_type, covered ? Boolean::TRUE : Boolean::FALSE)
      return covered
    end
    
    typesig { [Object, JavaSet] }
    # Computes whether the annotations of the given type are covered by the given <code>configured</code>
    # set. This is the case if either the type of the annotation or any of its
    # super types is contained in the <code>configured</code> set.
    # 
    # @param annotationType the annotation type
    # @param configured the set with configured annotation types
    # @return <code>true</code> if annotation is covered, <code>false</code>
    # otherwise
    # @since 3.0
    def is_covered(annotation_type, configured)
      if (@f_annotation_access.is_a?(IAnnotationAccessExtension))
        extension = @f_annotation_access
        e = configured.iterator
        while (e.has_next)
          if (extension.is_subtype(annotation_type, e.next_))
            return true
          end
        end
        return false
      end
      return configured.contains(annotation_type)
    end
    
    class_module.module_eval {
      typesig { [RGB, RGB, ::Java::Double] }
      # Returns a specification of a color that lies between the given
      # foreground and background color using the given scale factor.
      # 
      # @param fg the foreground color
      # @param bg the background color
      # @param scale the scale factor
      # @return the interpolated color
      def interpolate(fg, bg, scale)
        return RGB.new(RJava.cast_to_int(((1.0 - scale) * fg.attr_red + scale * bg.attr_red)), RJava.cast_to_int(((1.0 - scale) * fg.attr_green + scale * bg.attr_green)), RJava.cast_to_int(((1.0 - scale) * fg.attr_blue + scale * bg.attr_blue)))
      end
      
      typesig { [RGB] }
      # Returns the grey value in which the given color would be drawn in grey-scale.
      # 
      # @param rgb the color
      # @return the grey-scale value
      def grey_level(rgb)
        if ((rgb.attr_red).equal?(rgb.attr_green) && (rgb.attr_green).equal?(rgb.attr_blue))
          return rgb.attr_red
        end
        return (0.299 * rgb.attr_red + 0.587 * rgb.attr_green + 0.114 * rgb.attr_blue + 0.5)
      end
      
      typesig { [RGB] }
      # Returns whether the given color is dark or light depending on the colors grey-scale level.
      # 
      # @param rgb the color
      # @return <code>true</code> if the color is dark, <code>false</code> if it is light
      def is_dark(rgb)
        return grey_level(rgb) > 128
      end
    }
    
    typesig { [Object, ::Java::Double] }
    # Returns a color based on the color configured for the given annotation type and the given scale factor.
    # 
    # @param annotationType the annotation type
    # @param scale the scale factor
    # @return the computed color
    def get_color(annotation_type, scale)
      base = find_color(annotation_type)
      if ((base).nil?)
        return nil
      end
      base_rgb = base.get_rgb
      background = @f_canvas.get_background.get_rgb
      dark_base = is_dark(base_rgb)
      dark_background = is_dark(background)
      if (dark_base && dark_background)
        background = RGB.new(255, 255, 255)
      else
        if (!dark_base && !dark_background)
          background = RGB.new(0, 0, 0)
        end
      end
      return @f_shared_text_colors.get_color(interpolate(base_rgb, background, scale))
    end
    
    typesig { [Object] }
    # Returns the color for the given annotation type
    # 
    # @param annotationType the annotation type
    # @return the color
    # @since 3.0
    def find_color(annotation_type)
      color = @f_annotation_types2colors.get(annotation_type)
      if (!(color).nil?)
        return color
      end
      if (@f_annotation_access.is_a?(IAnnotationAccessExtension))
        extension = @f_annotation_access
        super_types = extension.get_supertypes(annotation_type)
        if (!(super_types).nil?)
          i = 0
          while i < super_types.attr_length
            color = @f_annotation_types2colors.get(super_types[i])
            if (!(color).nil?)
              return color
            end
            i += 1
          end
        end
      end
      return nil
    end
    
    typesig { [Object, ::Java::Boolean] }
    # Returns the stroke color for the given annotation type and characteristics.
    # 
    # @param annotationType the annotation type
    # @param temporary <code>true</code> if for temporary annotations
    # @return the stroke color
    def get_stroke_color(annotation_type, temporary)
      return get_color(annotation_type, temporary && @f_is_temporary_annotation_discolored ? 0.5 : 0.2)
    end
    
    typesig { [Object, ::Java::Boolean] }
    # Returns the fill color for the given annotation type and characteristics.
    # 
    # @param annotationType the annotation type
    # @param temporary <code>true</code> if for temporary annotations
    # @return the fill color
    def get_fill_color(annotation_type, temporary)
      return get_color(annotation_type, temporary && @f_is_temporary_annotation_discolored ? 0.9 : 0.75)
    end
    
    typesig { [] }
    # @see IVerticalRulerInfo#getLineOfLastMouseButtonActivity()
    def get_line_of_last_mouse_button_activity
      if (@f_last_mouse_button_activity_line >= @f_text_viewer.get_document.get_number_of_lines)
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
      line_numbers = to_line_numbers(y_coordinate)
      best_line = find_best_matching_line_number(line_numbers)
      if ((best_line).equal?(-1) && line_numbers.attr_length > 0)
        return line_numbers[0]
      end
      return best_line
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.source.IVerticalRuler#getModel()
    def get_model
      return @f_model
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.source.IOverviewRuler#getAnnotationHeight()
    def get_annotation_height
      return @f_annotation_height
    end
    
    typesig { [::Java::Int] }
    # @see org.eclipse.jface.text.source.IOverviewRuler#hasAnnotation(int)
    def has_annotation(y)
      return !(find_best_matching_line_number(to_line_numbers(y))).equal?(-1)
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.source.IOverviewRuler#getHeaderControl()
    def get_header_control
      return @f_header
    end
    
    typesig { [Object] }
    # @see org.eclipse.jface.text.source.IOverviewRuler#addHeaderAnnotationType(java.lang.Object)
    def add_header_annotation_type(annotation_type)
      @f_configured_header_annotation_types.add(annotation_type)
      @f_allowed_header_annotation_types.clear
    end
    
    typesig { [Object] }
    # @see org.eclipse.jface.text.source.IOverviewRuler#removeHeaderAnnotationType(java.lang.Object)
    def remove_header_annotation_type(annotation_type)
      @f_configured_header_annotation_types.remove(annotation_type)
      @f_allowed_header_annotation_types.clear
    end
    
    typesig { [] }
    # Updates the header of this ruler.
    def update_header
      if ((@f_header).nil? || @f_header.is_disposed)
        return
      end
      @f_header.set_tool_tip_text(nil)
      color_type = nil
      catch(:break_outer) do
        i = @f_annotations_sorted_by_layer.size - 1
        while i >= 0
          annotation_type = @f_annotations_sorted_by_layer.get(i)
          if (skip_in_header(annotation_type) || skip(annotation_type))
            i -= 1
            next
          end
          e = FilterIterator.new_local(self, annotation_type, FilterIterator::PERSISTENT | FilterIterator::TEMPORARY | FilterIterator::IGNORE_BAGS, @f_cached_annotations.iterator)
          while (e.has_next)
            if (!(e.next_).nil?)
              color_type = annotation_type
              throw :break_outer, :thrown
            end
          end
          i -= 1
        end
      end
      color = nil
      if (!(color_type).nil?)
        color = find_color(color_type)
      end
      if ((color).nil?)
        if (!(@f_header_painter).nil?)
          @f_header_painter.set_color(nil)
        end
      else
        if ((@f_header_painter).nil?)
          @f_header_painter = HeaderPainter.new_local(self)
          @f_header.add_paint_listener(@f_header_painter)
        end
        @f_header_painter.set_color(color)
      end
      @f_header.redraw
    end
    
    typesig { [] }
    # Updates the header tool tip text of this ruler.
    def update_header_tool_tip_text
      if ((@f_header).nil? || @f_header.is_disposed)
        return
      end
      if (!(@f_header.get_tool_tip_text).nil?)
        return
      end
      overview = "" # $NON-NLS-1$
      i = @f_annotations_sorted_by_layer.size - 1
      while i >= 0
        annotation_type = @f_annotations_sorted_by_layer.get(i)
        if (skip_in_header(annotation_type) || skip(annotation_type))
          i -= 1
          next
        end
        count = 0
        annotation_type_label = nil
        e = FilterIterator.new_local(self, annotation_type, FilterIterator::PERSISTENT | FilterIterator::TEMPORARY | FilterIterator::IGNORE_BAGS, @f_cached_annotations.iterator)
        while (e.has_next)
          annotation = e.next_
          if (!(annotation).nil?)
            if ((annotation_type_label).nil?)
              annotation_type_label = RJava.cast_to_string((@f_annotation_access).get_type_label(annotation))
            end
            count += 1
          end
        end
        if (!(annotation_type_label).nil?)
          if (overview.length > 0)
            overview += "\n"
          end # $NON-NLS-1$
          overview += RJava.cast_to_string(JFaceTextMessages.get_formatted_string("OverviewRulerHeader.toolTipTextEntry", Array.typed(Object).new([annotation_type_label, count]))) # $NON-NLS-1$
        end
        i -= 1
      end
      if (overview.length > 0)
        @f_header.set_tool_tip_text(overview)
      end
    end
    
    private
    alias_method :initialize__overview_ruler, :initialize
  end
  
end
