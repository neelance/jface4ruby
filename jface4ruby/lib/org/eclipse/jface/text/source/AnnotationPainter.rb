require "rjava"

# Copyright (c) 2000, 2009 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Source
  module AnnotationPainterImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Source
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :Arrays
      include_const ::Java::Util, :Collection
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :HashSet
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :LinkedList
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :Map
      include_const ::Java::Util, :JavaSet
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt, :SWTException
      include_const ::Org::Eclipse::Swt::Custom, :StyleRange
      include_const ::Org::Eclipse::Swt::Custom, :StyledText
      include_const ::Org::Eclipse::Swt::Events, :PaintEvent
      include_const ::Org::Eclipse::Swt::Events, :PaintListener
      include_const ::Org::Eclipse::Swt::Graphics, :Color
      include_const ::Org::Eclipse::Swt::Graphics, :GC
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Graphics, :Rectangle
      include_const ::Org::Eclipse::Swt::Graphics, :TextStyle
      include_const ::Org::Eclipse::Swt::Widgets, :Display
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Core::Runtime, :Platform
      include_const ::Org::Eclipse::Jface::Text, :BadLocationException
      include_const ::Org::Eclipse::Jface::Text, :IDocument
      include_const ::Org::Eclipse::Jface::Text, :IPaintPositionManager
      include_const ::Org::Eclipse::Jface::Text, :IPainter
      include_const ::Org::Eclipse::Jface::Text, :IRegion
      include_const ::Org::Eclipse::Jface::Text, :ITextInputListener
      include_const ::Org::Eclipse::Jface::Text, :ITextPresentationListener
      include_const ::Org::Eclipse::Jface::Text, :ITextViewerExtension2
      include_const ::Org::Eclipse::Jface::Text, :ITextViewerExtension5
      include_const ::Org::Eclipse::Jface::Text, :JFaceTextUtil
      include_const ::Org::Eclipse::Jface::Text, :Position
      include_const ::Org::Eclipse::Jface::Text, :Region
      include_const ::Org::Eclipse::Jface::Text, :TextPresentation
    }
  end
  
  # Paints decorations for annotations provided by an annotation model and/or
  # highlights them in the associated source viewer.
  # <p>
  # The annotation painter can be configured with drawing strategies. A drawing
  # strategy defines the visual presentation of a particular type of annotation
  # decoration.</p>
  # <p>
  # Clients usually instantiate and configure objects of this class.</p>
  # 
  # @since 2.1
  class AnnotationPainter 
    include_class_members AnnotationPainterImports
    include IPainter
    include PaintListener
    include IAnnotationModelListener
    include IAnnotationModelListenerExtension
    include ITextPresentationListener
    
    class_module.module_eval {
      # A drawing strategy draws the decoration for an annotation onto the text widget.
      # 
      # @since 3.0
      const_set_lazy(:IDrawingStrategy) { Module.new do
        include_class_members AnnotationPainter
        
        typesig { [Annotation, GC, StyledText, ::Java::Int, ::Java::Int, Color] }
        # Draws a decoration for an annotation onto the specified GC at the given text range. There
        # are two different invocation modes of the <code>draw</code> method:
        # <ul>
        # <li><strong>drawing mode:</strong> the passed GC is the graphics context of a paint
        # event occurring on the text widget. The strategy should draw the decoration onto the
        # graphics context, such that the decoration appears at the given range in the text
        # widget.</li>
        # <li><strong>clearing mode:</strong> the passed GC is <code>null</code>. In this case
        # the strategy must invalidate enough of the text widget's client area to cover any
        # decoration drawn in drawing mode. This can usually be accomplished by calling
        # {@linkplain StyledText#redrawRange(int, int, boolean) textWidget.redrawRange(offset, length, true)}.</li>
        # </ul>
        # 
        # @param annotation the annotation to be drawn
        # @param gc the graphics context, <code>null</code> when in clearing mode
        # @param textWidget the text widget to draw on
        # @param offset the offset of the line
        # @param length the length of the line
        # @param color the color of the line
        def draw(annotation, gc, text_widget, offset, length, color)
          raise NotImplementedError
        end
      end }
      
      # Squiggles drawing strategy.
      # 
      # @since 3.0
      # @deprecated As of 3.4, replaced by {@link AnnotationPainter.UnderlineStrategy}
      const_set_lazy(:SquigglesStrategy) { Class.new do
        include_class_members AnnotationPainter
        include IDrawingStrategy
        
        typesig { [class_self::Annotation, class_self::GC, class_self::StyledText, ::Java::Int, ::Java::Int, class_self::Color] }
        # @see org.eclipse.jface.text.source.AnnotationPainter.IDrawingStrategy#draw(org.eclipse.jface.text.source.Annotation, org.eclipse.swt.graphics.GC, org.eclipse.swt.custom.StyledText, int, int, org.eclipse.swt.graphics.Color)
        # @since 3.0
        def draw(annotation, gc, text_widget, offset, length, color)
          if (!(gc).nil?)
            if (length < 1)
              return
            end
            left = text_widget.get_location_at_offset(offset)
            right = text_widget.get_location_at_offset(offset + length)
            rect = text_widget.get_text_bounds(offset, offset + length - 1)
            left.attr_x = rect.attr_x
            right.attr_x = rect.attr_x + rect.attr_width
            polyline = compute_polyline(left, right, text_widget.get_baseline(offset), text_widget.get_line_height(offset))
            gc.set_line_width(0) # NOTE: 0 means width is 1 but with optimized performance
            gc.set_line_style(SWT::LINE_SOLID)
            gc.set_foreground(color)
            gc.draw_polyline(polyline)
          else
            text_widget.redraw_range(offset, length, true)
          end
        end
        
        typesig { [class_self::Point, class_self::Point, ::Java::Int, ::Java::Int] }
        # Computes an array of alternating x and y values which are the corners of the squiggly line of the
        # given height between the given end points.
        # 
        # @param left the left end point
        # @param right the right end point
        # @param baseline the font's baseline
        # @param lineHeight the height of the line
        # @return the array of alternating x and y values which are the corners of the squiggly line
        def compute_polyline(left, right, baseline, line_height)
          width = 4 # must be even
          height = 2 # can be any number
          peaks = (right.attr_x - left.attr_x) / width
          if ((peaks).equal?(0) && right.attr_x - left.attr_x > 2)
            peaks = 1
          end
          left_x = left.attr_x
          # compute (number of point) * 2
          length = ((2 * peaks) + 1) * 2
          if (length < 0)
            return Array.typed(::Java::Int).new(0) { 0 }
          end
          coordinates = Array.typed(::Java::Int).new(length) { 0 }
          # cache peeks' y-coordinates
          top = left.attr_y + Math.min(baseline + 1, line_height - height - 1)
          bottom = top + height
          # populate array with peek coordinates
          i = 0
          while i < peaks
            index = 4 * i
            coordinates[index] = left_x + (width * i)
            coordinates[index + 1] = bottom
            coordinates[index + 2] = coordinates[index] + width / 2
            coordinates[index + 3] = top
            i += 1
          end
          # the last down flank is missing
          coordinates[length - 2] = Math.min(Math.max(0, right.attr_x - 1), left.attr_x + (width * peaks))
          coordinates[length - 1] = bottom
          return coordinates
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__squiggles_strategy, :initialize
      end }
      
      # Drawing strategy that does nothing.
      # 
      # @since 3.0
      const_set_lazy(:NullStrategy) { Class.new do
        include_class_members AnnotationPainter
        include IDrawingStrategy
        
        typesig { [class_self::Annotation, class_self::GC, class_self::StyledText, ::Java::Int, ::Java::Int, class_self::Color] }
        # @see org.eclipse.jface.text.source.AnnotationPainter.IDrawingStrategy#draw(org.eclipse.jface.text.source.Annotation, org.eclipse.swt.graphics.GC, org.eclipse.swt.custom.StyledText, int, int, org.eclipse.swt.graphics.Color)
        # @since 3.0
        def draw(annotation, gc, text_widget, offset, length, color)
          # do nothing
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__null_strategy, :initialize
      end }
      
      # A text style painting strategy draws the decoration for an annotation
      # onto the text widget by applying a {@link TextStyle} on a given
      # {@link StyleRange}.
      # 
      # @since 3.4
      const_set_lazy(:ITextStyleStrategy) { Module.new do
        include_class_members AnnotationPainter
        
        typesig { [StyleRange, Color] }
        # Applies a text style on the given <code>StyleRange</code>.
        # 
        # @param styleRange the style range on which to apply the text style
        # @param annotationColor the color of the annotation
        def apply_text_style(style_range, annotation_color)
          raise NotImplementedError
        end
      end }
      
      # @since 3.4
      const_set_lazy(:HighlightingStrategy) { Class.new do
        include_class_members AnnotationPainter
        include ITextStyleStrategy
        
        typesig { [class_self::StyleRange, class_self::Color] }
        def apply_text_style(style_range, annotation_color)
          style_range.attr_background = annotation_color
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__highlighting_strategy, :initialize
      end }
      
      # Underline text style strategy.
      # 
      # @since 3.4
      const_set_lazy(:UnderlineStrategy) { Class.new do
        include_class_members AnnotationPainter
        include ITextStyleStrategy
        
        attr_accessor :f_underline_style
        alias_method :attr_f_underline_style, :f_underline_style
        undef_method :f_underline_style
        alias_method :attr_f_underline_style=, :f_underline_style=
        undef_method :f_underline_style=
        
        typesig { [::Java::Int] }
        def initialize(style)
          @f_underline_style = 0
          Assert.is_legal((style).equal?(SWT::UNDERLINE_SINGLE) || (style).equal?(SWT::UNDERLINE_DOUBLE) || (style).equal?(SWT::UNDERLINE_ERROR) || (style).equal?(SWT::UNDERLINE_SQUIGGLE))
          @f_underline_style = style
        end
        
        typesig { [class_self::StyleRange, class_self::Color] }
        def apply_text_style(style_range, annotation_color)
          style_range.attr_underline = true
          style_range.attr_underline_style = @f_underline_style
          style_range.attr_underline_color = annotation_color
        end
        
        private
        alias_method :initialize__underline_strategy, :initialize
      end }
      
      # Box text style strategy.
      # 
      # @since 3.4
      const_set_lazy(:BoxStrategy) { Class.new do
        include_class_members AnnotationPainter
        include ITextStyleStrategy
        
        attr_accessor :f_border_style
        alias_method :attr_f_border_style, :f_border_style
        undef_method :f_border_style
        alias_method :attr_f_border_style=, :f_border_style=
        undef_method :f_border_style=
        
        typesig { [::Java::Int] }
        def initialize(style)
          @f_border_style = 0
          Assert.is_legal((style).equal?(SWT::BORDER_DASH) || (style).equal?(SWT::BORDER_DASH) || (style).equal?(SWT::BORDER_SOLID))
          @f_border_style = style
        end
        
        typesig { [class_self::StyleRange, class_self::Color] }
        def apply_text_style(style_range, annotation_color)
          style_range.attr_border_style = @f_border_style
          style_range.attr_border_color = annotation_color
        end
        
        private
        alias_method :initialize__box_strategy, :initialize
      end }
      
      # Implementation of <code>IRegion</code> that can be reused
      # by setting the offset and the length.
      const_set_lazy(:ReusableRegion) { Class.new(Position) do
        include_class_members AnnotationPainter
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
      
      # Tells whether this class is in debug mode.
      # @since 3.0
      
      def debug
        defined?(@@debug) ? @@debug : @@debug= "true".equals_ignore_case(Platform.get_debug_option("org.eclipse.jface.text/debug/AnnotationPainter"))
      end
      alias_method :attr_debug, :debug
      
      def debug=(value)
        @@debug = value
      end
      alias_method :attr_debug=, :debug=
      
      # $NON-NLS-1$//$NON-NLS-2$
      # 
      # The squiggly painter strategy.
      # @since 3.0
      const_set_lazy(:SQUIGGLES_STRATEGY) { SquigglesStrategy.new }
      const_attr_reader  :SQUIGGLES_STRATEGY
      
      # This strategy is used to mark the <code>null</code> value in the chache
      # maps.
      # 
      # @since 3.4
      const_set_lazy(:NULL_STRATEGY) { NullStrategy.new }
      const_attr_reader  :NULL_STRATEGY
      
      # The squiggles painter id.
      # @since 3.0
      const_set_lazy(:SQUIGGLES) { Object.new }
      const_attr_reader  :SQUIGGLES
      
      # The squiggly painter strategy.
      # 
      # @since 3.4
      const_set_lazy(:HIGHLIGHTING_STRATEGY) { HighlightingStrategy.new }
      const_attr_reader  :HIGHLIGHTING_STRATEGY
      
      # The highlighting text style strategy id.
      # 
      # @since 3.4
      const_set_lazy(:HIGHLIGHTING) { Object.new }
      const_attr_reader  :HIGHLIGHTING
      
      # The presentation information (decoration) for an annotation.  Each such
      # object represents one decoration drawn on the text area, such as squiggly lines
      # and underlines.
      const_set_lazy(:Decoration) { Class.new do
        include_class_members AnnotationPainter
        
        # The position of this decoration
        attr_accessor :f_position
        alias_method :attr_f_position, :f_position
        undef_method :f_position
        alias_method :attr_f_position=, :f_position=
        undef_method :f_position=
        
        # The color of this decoration
        attr_accessor :f_color
        alias_method :attr_f_color, :f_color
        undef_method :f_color
        alias_method :attr_f_color=, :f_color=
        undef_method :f_color=
        
        # The annotation's layer
        # @since 3.0
        attr_accessor :f_layer
        alias_method :attr_f_layer, :f_layer
        undef_method :f_layer
        alias_method :attr_f_layer=, :f_layer=
        undef_method :f_layer=
        
        # The painting strategy for this decoration.
        # @since 3.0
        attr_accessor :f_painting_strategy
        alias_method :attr_f_painting_strategy, :f_painting_strategy
        undef_method :f_painting_strategy
        alias_method :attr_f_painting_strategy=, :f_painting_strategy=
        undef_method :f_painting_strategy=
        
        typesig { [] }
        def initialize
          @f_position = nil
          @f_color = nil
          @f_layer = 0
          @f_painting_strategy = nil
        end
        
        private
        alias_method :initialize__decoration, :initialize
      end }
    }
    
    # Indicates whether this painter is active
    attr_accessor :f_is_active
    alias_method :attr_f_is_active, :f_is_active
    undef_method :f_is_active
    alias_method :attr_f_is_active=, :f_is_active=
    undef_method :f_is_active=
    
    # Indicates whether this painter is managing decorations
    attr_accessor :f_is_painting
    alias_method :attr_f_is_painting, :f_is_painting
    undef_method :f_is_painting
    alias_method :attr_f_is_painting=, :f_is_painting=
    undef_method :f_is_painting=
    
    # Indicates whether this painter is setting its annotation model
    attr_accessor :f_is_setting_model
    alias_method :attr_f_is_setting_model, :f_is_setting_model
    undef_method :f_is_setting_model
    alias_method :attr_f_is_setting_model=, :f_is_setting_model=
    undef_method :f_is_setting_model=
    
    # The associated source viewer
    attr_accessor :f_source_viewer
    alias_method :attr_f_source_viewer, :f_source_viewer
    undef_method :f_source_viewer
    alias_method :attr_f_source_viewer=, :f_source_viewer=
    undef_method :f_source_viewer=
    
    # The cached widget of the source viewer
    attr_accessor :f_text_widget
    alias_method :attr_f_text_widget, :f_text_widget
    undef_method :f_text_widget
    alias_method :attr_f_text_widget=, :f_text_widget=
    undef_method :f_text_widget=
    
    # The annotation model providing the annotations to be drawn
    attr_accessor :f_model
    alias_method :attr_f_model, :f_model
    undef_method :f_model
    alias_method :attr_f_model=, :f_model=
    undef_method :f_model=
    
    # The annotation access
    attr_accessor :f_annotation_access
    alias_method :attr_f_annotation_access, :f_annotation_access
    undef_method :f_annotation_access
    alias_method :attr_f_annotation_access=, :f_annotation_access=
    undef_method :f_annotation_access=
    
    # The map with decorations
    # @since 3.0
    attr_accessor :f_decorations_map
    alias_method :attr_f_decorations_map, :f_decorations_map
    undef_method :f_decorations_map
    alias_method :attr_f_decorations_map=, :f_decorations_map=
    undef_method :f_decorations_map=
    
    # see https://bugs.eclipse.org/bugs/show_bug.cgi?id=50767
    # 
    # The map with of highlighted decorations.
    # @since 3.0
    attr_accessor :f_highlighted_decorations_map
    alias_method :attr_f_highlighted_decorations_map, :f_highlighted_decorations_map
    undef_method :f_highlighted_decorations_map
    alias_method :attr_f_highlighted_decorations_map=, :f_highlighted_decorations_map=
    undef_method :f_highlighted_decorations_map=
    
    # see https://bugs.eclipse.org/bugs/show_bug.cgi?id=50767
    # 
    # Mutex for highlighted decorations map.
    # @since 3.0
    attr_accessor :f_decoration_map_lock
    alias_method :attr_f_decoration_map_lock, :f_decoration_map_lock
    undef_method :f_decoration_map_lock
    alias_method :attr_f_decoration_map_lock=, :f_decoration_map_lock=
    undef_method :f_decoration_map_lock=
    
    # Mutex for for decorations map.
    # @since 3.0
    attr_accessor :f_highlighted_decorations_map_lock
    alias_method :attr_f_highlighted_decorations_map_lock, :f_highlighted_decorations_map_lock
    undef_method :f_highlighted_decorations_map_lock
    alias_method :attr_f_highlighted_decorations_map_lock=, :f_highlighted_decorations_map_lock=
    undef_method :f_highlighted_decorations_map_lock=
    
    # Maps an annotation type to its registered color.
    # 
    # @see #setAnnotationTypeColor(Object, Color)
    attr_accessor :f_annotation_type2color
    alias_method :attr_f_annotation_type2color, :f_annotation_type2color
    undef_method :f_annotation_type2color
    alias_method :attr_f_annotation_type2color=, :f_annotation_type2color=
    undef_method :f_annotation_type2color=
    
    # Cache that maps the annotation type to its color.
    # @since 3.4
    attr_accessor :f_cached_annotation_type2color
    alias_method :attr_f_cached_annotation_type2color, :f_cached_annotation_type2color
    undef_method :f_cached_annotation_type2color
    alias_method :attr_f_cached_annotation_type2color=, :f_cached_annotation_type2color=
    undef_method :f_cached_annotation_type2color=
    
    # The range in which the current highlight annotations can be found.
    # @since 3.0
    attr_accessor :f_current_highlight_annotation_range
    alias_method :attr_f_current_highlight_annotation_range, :f_current_highlight_annotation_range
    undef_method :f_current_highlight_annotation_range
    alias_method :attr_f_current_highlight_annotation_range=, :f_current_highlight_annotation_range=
    undef_method :f_current_highlight_annotation_range=
    
    # The range in which all added, removed and changed highlight
    # annotations can be found since the last world change.
    # @since 3.0
    attr_accessor :f_total_highlight_annotation_range
    alias_method :attr_f_total_highlight_annotation_range, :f_total_highlight_annotation_range
    undef_method :f_total_highlight_annotation_range
    alias_method :attr_f_total_highlight_annotation_range=, :f_total_highlight_annotation_range=
    undef_method :f_total_highlight_annotation_range=
    
    # The range in which the currently drawn annotations can be found.
    # @since 3.3
    attr_accessor :f_current_draw_range
    alias_method :attr_f_current_draw_range, :f_current_draw_range
    undef_method :f_current_draw_range
    alias_method :attr_f_current_draw_range=, :f_current_draw_range=
    undef_method :f_current_draw_range=
    
    # The range in which all added, removed and changed drawn
    # annotations can be found since the last world change.
    # @since 3.3
    attr_accessor :f_total_draw_range
    alias_method :attr_f_total_draw_range, :f_total_draw_range
    undef_method :f_total_draw_range
    alias_method :attr_f_total_draw_range=, :f_total_draw_range=
    undef_method :f_total_draw_range=
    
    # The text input listener.
    # @since 3.0
    attr_accessor :f_text_input_listener
    alias_method :attr_f_text_input_listener, :f_text_input_listener
    undef_method :f_text_input_listener
    alias_method :attr_f_text_input_listener=, :f_text_input_listener=
    undef_method :f_text_input_listener=
    
    # Flag which tells that a new document input is currently being set.
    # @since 3.0
    attr_accessor :f_input_document_about_to_be_changed
    alias_method :attr_f_input_document_about_to_be_changed, :f_input_document_about_to_be_changed
    undef_method :f_input_document_about_to_be_changed
    alias_method :attr_f_input_document_about_to_be_changed=, :f_input_document_about_to_be_changed=
    undef_method :f_input_document_about_to_be_changed=
    
    # Maps annotation types to painting strategy identifiers.
    # 
    # @see #addAnnotationType(Object, Object)
    # @since 3.0
    attr_accessor :f_annotation_type2painting_strategy_id
    alias_method :attr_f_annotation_type2painting_strategy_id, :f_annotation_type2painting_strategy_id
    undef_method :f_annotation_type2painting_strategy_id
    alias_method :attr_f_annotation_type2painting_strategy_id=, :f_annotation_type2painting_strategy_id=
    undef_method :f_annotation_type2painting_strategy_id=
    
    # Maps annotation types to painting strategy identifiers.
    # @since 3.4
    attr_accessor :f_cached_annotation_type2painting_strategy
    alias_method :attr_f_cached_annotation_type2painting_strategy, :f_cached_annotation_type2painting_strategy
    undef_method :f_cached_annotation_type2painting_strategy
    alias_method :attr_f_cached_annotation_type2painting_strategy=, :f_cached_annotation_type2painting_strategy=
    undef_method :f_cached_annotation_type2painting_strategy=
    
    # Maps painting strategy identifiers to painting strategies.
    # 
    # @since 3.0
    attr_accessor :f_painting_strategy_id2painting_strategy
    alias_method :attr_f_painting_strategy_id2painting_strategy, :f_painting_strategy_id2painting_strategy
    undef_method :f_painting_strategy_id2painting_strategy
    alias_method :attr_f_painting_strategy_id2painting_strategy=, :f_painting_strategy_id2painting_strategy=
    undef_method :f_painting_strategy_id2painting_strategy=
    
    # Reuse this region for performance reasons.
    # @since 3.3
    attr_accessor :f_reusable_region
    alias_method :attr_f_reusable_region, :f_reusable_region
    undef_method :f_reusable_region
    alias_method :attr_f_reusable_region=, :f_reusable_region=
    undef_method :f_reusable_region=
    
    typesig { [ISourceViewer, IAnnotationAccess] }
    # Creates a new annotation painter for the given source viewer and with the
    # given annotation access. The painter is not initialized, i.e. no
    # annotation types are configured to be painted.
    # 
    # @param sourceViewer the source viewer for this painter
    # @param access the annotation access for this painter
    def initialize(source_viewer, access)
      @f_is_active = false
      @f_is_painting = false
      @f_is_setting_model = false
      @f_source_viewer = nil
      @f_text_widget = nil
      @f_model = nil
      @f_annotation_access = nil
      @f_decorations_map = HashMap.new
      @f_highlighted_decorations_map = HashMap.new
      @f_decoration_map_lock = Object.new
      @f_highlighted_decorations_map_lock = Object.new
      @f_annotation_type2color = HashMap.new
      @f_cached_annotation_type2color = HashMap.new
      @f_current_highlight_annotation_range = nil
      @f_total_highlight_annotation_range = nil
      @f_current_draw_range = nil
      @f_total_draw_range = nil
      @f_text_input_listener = nil
      @f_input_document_about_to_be_changed = false
      @f_annotation_type2painting_strategy_id = HashMap.new
      @f_cached_annotation_type2painting_strategy = HashMap.new
      @f_painting_strategy_id2painting_strategy = HashMap.new
      @f_reusable_region = ReusableRegion.new
      @f_source_viewer = source_viewer
      @f_annotation_access = access
      @f_text_widget = source_viewer.get_text_widget
      # default drawing strategies: squiggles were the only decoration style before version 3.0
      @f_painting_strategy_id2painting_strategy.put(SQUIGGLES, SQUIGGLES_STRATEGY)
      @f_painting_strategy_id2painting_strategy.put(HIGHLIGHTING, HIGHLIGHTING_STRATEGY)
    end
    
    typesig { [] }
    # Returns whether this painter has to draw any squiggles.
    # 
    # @return <code>true</code> if there are squiggles to be drawn, <code>false</code> otherwise
    def has_decorations
      synchronized((@f_decoration_map_lock)) do
        return !@f_decorations_map.is_empty
      end
    end
    
    typesig { [] }
    # Enables painting. This painter registers a paint listener with the
    # source viewer's widget.
    def enable_painting
      if (!@f_is_painting && has_decorations)
        @f_is_painting = true
        @f_text_widget.add_paint_listener(self)
        handle_draw_request(nil)
      end
    end
    
    typesig { [::Java::Boolean] }
    # Disables painting, if is has previously been enabled. Removes
    # any paint listeners registered with the source viewer's widget.
    # 
    # @param redraw <code>true</code> if the widget should be redrawn after disabling
    def disable_painting(redraw)
      if (@f_is_painting)
        @f_is_painting = false
        @f_text_widget.remove_paint_listener(self)
        if (redraw && has_decorations)
          handle_draw_request(nil)
        end
      end
    end
    
    typesig { [IAnnotationModel] }
    # Sets the annotation model for this painter. Registers this painter
    # as listener of the give model, if the model is not <code>null</code>.
    # 
    # @param model the annotation model
    def set_model(model)
      if (!(@f_model).equal?(model))
        if (!(@f_model).nil?)
          @f_model.remove_annotation_model_listener(self)
        end
        @f_model = model
        if (!(@f_model).nil?)
          begin
            @f_is_setting_model = true
            @f_model.add_annotation_model_listener(self)
          ensure
            @f_is_setting_model = false
          end
        end
      end
    end
    
    typesig { [AnnotationModelEvent] }
    # Updates the set of decorations based on the current state of
    # the painter's annotation model.
    # 
    # @param event the annotation model event
    def catchup_with_model(event)
      synchronized((@f_decoration_map_lock)) do
        if ((@f_decorations_map).nil?)
          return
        end
      end
      if ((@f_model).nil?)
        # annotation model is null -> clear all
        synchronized((@f_decoration_map_lock)) do
          @f_decorations_map.clear
        end
        synchronized((@f_highlighted_decorations_map_lock)) do
          @f_highlighted_decorations_map.clear
        end
        return
      end
      clipping_region = compute_clipping_region(nil, true)
      document = @f_source_viewer.get_document
      highlight_annotation_range_start = JavaInteger::MAX_VALUE
      highlight_annotation_range_end = -1
      draw_range_start = JavaInteger::MAX_VALUE
      draw_range_end = -1
      decorations_map = nil
      highlighted_decorations_map = nil
      # Clone decoration maps
      synchronized((@f_decoration_map_lock)) do
        decorations_map = HashMap.new(@f_decorations_map)
      end
      synchronized((@f_highlighted_decorations_map_lock)) do
        highlighted_decorations_map = HashMap.new(@f_highlighted_decorations_map)
      end
      is_world_change = false
      e = nil
      if ((event).nil? || event.is_world_change)
        is_world_change = true
        if (self.attr_debug && (event).nil?)
          System.out.println("AP: INTERNAL CHANGE")
        end # $NON-NLS-1$
        iter = decorations_map.entry_set.iterator
        while (iter.has_next)
          entry = iter.next_
          annotation = entry.get_key
          decoration = entry.get_value
          draw_decoration(decoration, nil, annotation, clipping_region, document)
        end
        decorations_map.clear
        highlighted_decorations_map.clear
        e = @f_model.get_annotation_iterator
      else
        # Remove annotations
        removed_annotations = event.get_removed_annotations
        i = 0
        length = removed_annotations.attr_length
        while i < length
          annotation = removed_annotations[i]
          decoration = highlighted_decorations_map.remove(annotation)
          if (!(decoration).nil?)
            position = decoration.attr_f_position
            if (!(position).nil?)
              highlight_annotation_range_start = Math.min(highlight_annotation_range_start, position.attr_offset)
              highlight_annotation_range_end = Math.max(highlight_annotation_range_end, position.attr_offset + position.attr_length)
            end
          end
          decoration = decorations_map.remove(annotation)
          if (!(decoration).nil?)
            draw_decoration(decoration, nil, annotation, clipping_region, document)
            position = decoration.attr_f_position
            if (!(position).nil?)
              draw_range_start = Math.min(draw_range_start, position.attr_offset)
              draw_range_end = Math.max(draw_range_end, position.attr_offset + position.attr_length)
            end
          end
          i += 1
        end
        # Update existing annotations
        changed_annotations = event.get_changed_annotations
        i_ = 0
        length_ = changed_annotations.attr_length
        while i_ < length_
          annotation = changed_annotations[i_]
          is_highlighting = false
          decoration = highlighted_decorations_map.get(annotation)
          if (!(decoration).nil?)
            is_highlighting = true
            # The call below updates the decoration - no need to create new decoration
            decoration = get_decoration(annotation, decoration)
            if ((decoration).nil?)
              highlighted_decorations_map.remove(annotation)
            end
          else
            decoration = get_decoration(annotation, decoration)
            if (!(decoration).nil? && decoration.attr_f_painting_strategy.is_a?(ITextStyleStrategy))
              highlighted_decorations_map.put(annotation, decoration)
              is_highlighting = true
            end
          end
          uses_drawing_strategy = !is_highlighting && !(decoration).nil?
          position = nil
          if ((decoration).nil?)
            position = @f_model.get_position(annotation)
          else
            position = decoration.attr_f_position
          end
          if (!(position).nil? && !position.is_deleted)
            if (is_highlighting)
              highlight_annotation_range_start = Math.min(highlight_annotation_range_start, position.attr_offset)
              highlight_annotation_range_end = Math.max(highlight_annotation_range_end, position.attr_offset + position.attr_length)
            end
            if (uses_drawing_strategy)
              draw_range_start = Math.min(draw_range_start, position.attr_offset)
              draw_range_end = Math.max(draw_range_end, position.attr_offset + position.attr_length)
            end
          else
            highlighted_decorations_map.remove(annotation)
          end
          if (uses_drawing_strategy)
            old_decoration = decorations_map.get(annotation)
            if (!(old_decoration).nil?)
              draw_decoration(old_decoration, nil, annotation, clipping_region, document)
              if (!(decoration).nil?)
                decorations_map.put(annotation, decoration)
              else
                decorations_map.remove(annotation)
              end
            end
          end
          i_ += 1
        end
        e = Arrays.as_list(event.get_added_annotations).iterator
      end
      # Add new annotations
      while (e.has_next)
        annotation = e.next_
        pp = get_decoration(annotation, nil)
        if (!(pp).nil?)
          if (pp.attr_f_painting_strategy.is_a?(IDrawingStrategy))
            decorations_map.put(annotation, pp)
            draw_range_start = Math.min(draw_range_start, pp.attr_f_position.attr_offset)
            draw_range_end = Math.max(draw_range_end, pp.attr_f_position.attr_offset + pp.attr_f_position.attr_length)
          else
            if (pp.attr_f_painting_strategy.is_a?(ITextStyleStrategy))
              highlighted_decorations_map.put(annotation, pp)
              highlight_annotation_range_start = Math.min(highlight_annotation_range_start, pp.attr_f_position.attr_offset)
              highlight_annotation_range_end = Math.max(highlight_annotation_range_end, pp.attr_f_position.attr_offset + pp.attr_f_position.attr_length)
            end
          end
        end
      end
      synchronized((@f_decoration_map_lock)) do
        @f_decorations_map = decorations_map
        update_draw_ranges(draw_range_start, draw_range_end, is_world_change)
      end
      synchronized((@f_highlighted_decorations_map_lock)) do
        @f_highlighted_decorations_map = highlighted_decorations_map
        update_highlight_ranges(highlight_annotation_range_start, highlight_annotation_range_end, is_world_change)
      end
    end
    
    typesig { [::Java::Int, ::Java::Int, ::Java::Boolean] }
    # Updates the remembered highlight ranges.
    # 
    # @param highlightAnnotationRangeStart the start of the range
    # @param highlightAnnotationRangeEnd	the end of the range
    # @param isWorldChange					tells whether the range belongs to a annotation model event reporting a world change
    # @since 3.0
    def update_highlight_ranges(highlight_annotation_range_start, highlight_annotation_range_end, is_world_change_)
      if (!(highlight_annotation_range_start).equal?(JavaInteger::MAX_VALUE))
        max_range_start = highlight_annotation_range_start
        max_range_end = highlight_annotation_range_end
        if (!(@f_total_highlight_annotation_range).nil?)
          max_range_start = Math.min(max_range_start, @f_total_highlight_annotation_range.attr_offset)
          max_range_end = Math.max(max_range_end, @f_total_highlight_annotation_range.attr_offset + @f_total_highlight_annotation_range.attr_length)
        end
        if ((@f_total_highlight_annotation_range).nil?)
          @f_total_highlight_annotation_range = Position.new(0)
        end
        if ((@f_current_highlight_annotation_range).nil?)
          @f_current_highlight_annotation_range = Position.new(0)
        end
        if (is_world_change_)
          @f_total_highlight_annotation_range.attr_offset = highlight_annotation_range_start
          @f_total_highlight_annotation_range.attr_length = highlight_annotation_range_end - highlight_annotation_range_start
          @f_current_highlight_annotation_range.attr_offset = max_range_start
          @f_current_highlight_annotation_range.attr_length = max_range_end - max_range_start
        else
          @f_total_highlight_annotation_range.attr_offset = max_range_start
          @f_total_highlight_annotation_range.attr_length = max_range_end - max_range_start
          @f_current_highlight_annotation_range.attr_offset = highlight_annotation_range_start
          @f_current_highlight_annotation_range.attr_length = highlight_annotation_range_end - highlight_annotation_range_start
        end
      else
        if (is_world_change_)
          @f_current_highlight_annotation_range = @f_total_highlight_annotation_range
          @f_total_highlight_annotation_range = nil
        else
          @f_current_highlight_annotation_range = nil
        end
      end
      adapt_to_document_length(@f_current_highlight_annotation_range)
      adapt_to_document_length(@f_total_highlight_annotation_range)
    end
    
    typesig { [::Java::Int, ::Java::Int, ::Java::Boolean] }
    # Updates the remembered decoration ranges.
    # 
    # @param drawRangeStart	the start of the range
    # @param drawRangeEnd		the end of the range
    # @param isWorldChange		tells whether the range belongs to a annotation model event reporting a world change
    # @since 3.3
    def update_draw_ranges(draw_range_start, draw_range_end, is_world_change_)
      if (!(draw_range_start).equal?(JavaInteger::MAX_VALUE))
        max_range_start = draw_range_start
        max_range_end = draw_range_end
        if (!(@f_total_draw_range).nil?)
          max_range_start = Math.min(max_range_start, @f_total_draw_range.attr_offset)
          max_range_end = Math.max(max_range_end, @f_total_draw_range.attr_offset + @f_total_draw_range.attr_length)
        end
        if ((@f_total_draw_range).nil?)
          @f_total_draw_range = Position.new(0)
        end
        if ((@f_current_draw_range).nil?)
          @f_current_draw_range = Position.new(0)
        end
        if (is_world_change_)
          @f_total_draw_range.attr_offset = draw_range_start
          @f_total_draw_range.attr_length = draw_range_end - draw_range_start
          @f_current_draw_range.attr_offset = max_range_start
          @f_current_draw_range.attr_length = max_range_end - max_range_start
        else
          @f_total_draw_range.attr_offset = max_range_start
          @f_total_draw_range.attr_length = max_range_end - max_range_start
          @f_current_draw_range.attr_offset = draw_range_start
          @f_current_draw_range.attr_length = draw_range_end - draw_range_start
        end
      else
        if (is_world_change_)
          @f_current_draw_range = @f_total_draw_range
          @f_total_draw_range = nil
        else
          @f_current_draw_range = nil
        end
      end
      adapt_to_document_length(@f_current_draw_range)
      adapt_to_document_length(@f_total_draw_range)
    end
    
    typesig { [Position] }
    # Adapts the given position to the document length.
    # 
    # @param position the position to adapt
    # @since 3.0
    def adapt_to_document_length(position)
      if ((position).nil?)
        return
      end
      length = @f_source_viewer.get_document.get_length
      position.attr_offset = Math.min(position.attr_offset, length)
      position.attr_length = Math.min(position.attr_length, length - position.attr_offset)
    end
    
    typesig { [Annotation, Decoration] }
    # Returns a decoration for the given annotation if this
    # annotation is valid and shown by this painter.
    # 
    # @param annotation 			the annotation
    # @param decoration 			the decoration to be adapted and returned or <code>null</code> if a new one must be created
    # @return the decoration or <code>null</code> if there's no valid one
    # @since 3.0
    def get_decoration(annotation, decoration)
      if (annotation.is_marked_deleted)
        return nil
      end
      type = annotation.get_type
      painting_strategy = get_painting_strategy(type)
      if ((painting_strategy).nil? || painting_strategy.is_a?(NullStrategy))
        return nil
      end
      color = get_color(type)
      if ((color).nil?)
        return nil
      end
      position = @f_model.get_position(annotation)
      if ((position).nil? || position.is_deleted)
        return nil
      end
      if ((decoration).nil?)
        decoration = Decoration.new
      end
      decoration.attr_f_position = position
      decoration.attr_f_color = color
      if (@f_annotation_access.is_a?(IAnnotationAccessExtension))
        extension = @f_annotation_access
        decoration.attr_f_layer = extension.get_layer(annotation)
      else
        decoration.attr_f_layer = IAnnotationAccessExtension::DEFAULT_LAYER
      end
      decoration.attr_f_painting_strategy = painting_strategy
      return decoration
    end
    
    typesig { [String] }
    # Returns the painting strategy for the given annotation.
    # 
    # @param type the annotation type
    # @return the annotation painter
    # @since 3.0
    def get_painting_strategy(type)
      strategy = @f_cached_annotation_type2painting_strategy.get(type)
      if (!(strategy).nil?)
        return strategy
      end
      strategy = @f_painting_strategy_id2painting_strategy.get(@f_annotation_type2painting_strategy_id.get(type))
      if (!(strategy).nil?)
        @f_cached_annotation_type2painting_strategy.put(type, strategy)
        return strategy
      end
      if (@f_annotation_access.is_a?(IAnnotationAccessExtension))
        ext = @f_annotation_access
        sts = ext.get_supertypes(type)
        i = 0
        while i < sts.attr_length
          strategy = @f_painting_strategy_id2painting_strategy.get(@f_annotation_type2painting_strategy_id.get(sts[i]))
          if (!(strategy).nil?)
            @f_cached_annotation_type2painting_strategy.put(type, strategy)
            return strategy
          end
          i += 1
        end
      end
      @f_cached_annotation_type2painting_strategy.put(type, NULL_STRATEGY)
      return nil
    end
    
    typesig { [Object] }
    # Returns the color for the given annotation type
    # 
    # @param annotationType the annotation type
    # @return the color
    # @since 3.0
    def get_color(annotation_type)
      color = @f_cached_annotation_type2color.get(annotation_type)
      if (!(color).nil?)
        return color
      end
      color = @f_annotation_type2color.get(annotation_type)
      if (!(color).nil?)
        @f_cached_annotation_type2color.put(annotation_type, color)
        return color
      end
      if (@f_annotation_access.is_a?(IAnnotationAccessExtension))
        extension = @f_annotation_access
        super_types = extension.get_supertypes(annotation_type)
        if (!(super_types).nil?)
          i = 0
          while i < super_types.attr_length
            color = @f_annotation_type2color.get(super_types[i])
            if (!(color).nil?)
              @f_cached_annotation_type2color.put(annotation_type, color)
              return color
            end
            i += 1
          end
        end
      end
      return nil
    end
    
    typesig { [AnnotationModelEvent] }
    # Recomputes the squiggles to be drawn and redraws them.
    # 
    # @param event the annotation model event
    # @since 3.0
    def update_painting(event)
      disable_painting((event).nil?)
      catchup_with_model(event)
      if (!@f_input_document_about_to_be_changed)
        invalidate_text_presentation
      end
      enable_painting
    end
    
    typesig { [] }
    def invalidate_text_presentation
      r = nil
      synchronized((@f_highlighted_decorations_map_lock)) do
        if (!(@f_current_highlight_annotation_range).nil?)
          r = Region.new(@f_current_highlight_annotation_range.get_offset, @f_current_highlight_annotation_range.get_length)
        end
      end
      if ((r).nil?)
        return
      end
      if (@f_source_viewer.is_a?(ITextViewerExtension2))
        if (self.attr_debug)
          System.out.println("AP: invalidating offset: " + RJava.cast_to_string(r.get_offset) + ", length= " + RJava.cast_to_string(r.get_length))
        end # $NON-NLS-1$ //$NON-NLS-2$
        (@f_source_viewer).invalidate_text_presentation(r.get_offset, r.get_length)
      else
        @f_source_viewer.invalidate_text_presentation
      end
    end
    
    typesig { [TextPresentation] }
    # @see org.eclipse.jface.text.ITextPresentationListener#applyTextPresentation(org.eclipse.jface.text.TextPresentation)
    # @since 3.0
    def apply_text_presentation(tp)
      decorations = nil
      synchronized((@f_highlighted_decorations_map_lock)) do
        if ((@f_highlighted_decorations_map).nil? || @f_highlighted_decorations_map.is_empty)
          return
        end
        decorations = HashSet.new(@f_highlighted_decorations_map.entry_set)
      end
      region = tp.get_extent
      if (self.attr_debug)
        System.out.println("AP: applying text presentation offset: " + RJava.cast_to_string(region.get_offset) + ", length= " + RJava.cast_to_string(region.get_length))
      end # $NON-NLS-1$ //$NON-NLS-2$
      layer = 0
      max_layer = 1
      while layer < max_layer
        iter = decorations.iterator
        while iter.has_next
          entry = iter.next_
          a = entry.get_key
          if (a.is_marked_deleted)
            next
          end
          pp = entry.get_value
          max_layer = Math.max(max_layer, pp.attr_f_layer + 1) # dynamically update layer maximum
          if (!(pp.attr_f_layer).equal?(layer))
            # wrong layer: skip annotation
            next
          end
          p = pp.attr_f_position
          if (@f_source_viewer.is_a?(ITextViewerExtension5))
            extension3 = @f_source_viewer
            if ((nil).equal?(extension3.model_range2widget_range(Region.new(p.get_offset, p.get_length))))
              next
            end
          else
            if (!@f_source_viewer.overlaps_with_visible_region(p.attr_offset, p.attr_length))
              next
            end
          end
          region_end = region.get_offset + region.get_length
          p_end = p.get_offset + p.get_length
          if (p_end >= region.get_offset && region_end > p.get_offset)
            start = Math.max(p.get_offset, region.get_offset)
            end_ = Math.min(region_end, p_end)
            length = Math.max(end_ - start, 0)
            style_range = StyleRange.new(start, length, nil, nil)
            (pp.attr_f_painting_strategy).apply_text_style(style_range, pp.attr_f_color)
            tp.merge_style_range(style_range)
          end
        end
        layer += 1
      end
    end
    
    typesig { [IAnnotationModel] }
    # @see org.eclipse.jface.text.source.IAnnotationModelListener#modelChanged(org.eclipse.jface.text.source.IAnnotationModel)
    def model_changed(model)
      synchronized(self) do
        if (self.attr_debug)
          System.err.println("AP: OLD API of AnnotationModelListener called")
        end # $NON-NLS-1$
        model_changed(AnnotationModelEvent.new(model))
      end
    end
    
    typesig { [AnnotationModelEvent] }
    # @see org.eclipse.jface.text.source.IAnnotationModelListenerExtension#modelChanged(org.eclipse.jface.text.source.AnnotationModelEvent)
    def model_changed(event)
      text_widget_display = nil
      begin
        text_widget = @f_text_widget
        if ((text_widget).nil? || text_widget.is_disposed)
          return
        end
        text_widget_display = text_widget.get_display
      rescue SWTException => ex
        if ((ex.attr_code).equal?(SWT::ERROR_WIDGET_DISPOSED))
          return
        end
        raise ex
      end
      if (@f_is_setting_model)
        # inside the UI thread -> no need for posting
        if ((text_widget_display).equal?(Display.get_current))
          update_painting(event)
        else
          # we can throw away the changes since
          # further update painting will happen
          return
        end
      else
        if (self.attr_debug && !(event).nil? && event.is_world_change)
          System.out.println("AP: WORLD CHANGED, stack trace follows:") # $NON-NLS-1$
          JavaThrowable.new.print_stack_trace(System.out)
        end
        text_widget_display.async_exec(# XXX: posting here is a problem for annotations that are being
        # removed and the positions of which are not updated to document
        # changes any more. If the document gets modified between
        # now and running the posted runnable, the position information
        # is not accurate any longer.
        Class.new(Runnable.class == Class ? Runnable : Object) do
          extend LocalClass
          include_class_members AnnotationPainter
          include Runnable if Runnable.class == Module
          
          typesig { [] }
          define_method :run do
            if (!(self.attr_f_text_widget).nil? && !self.attr_f_text_widget.is_disposed)
              update_painting(event)
            end
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
    
    typesig { [Object, Color] }
    # Sets the color in which the squiggly for the given annotation type should be drawn.
    # 
    # @param annotationType the annotation type
    # @param color the color
    def set_annotation_type_color(annotation_type, color)
      if (!(color).nil?)
        @f_annotation_type2color.put(annotation_type, color)
      else
        @f_annotation_type2color.remove(annotation_type)
      end
      @f_cached_annotation_type2color.clear
    end
    
    typesig { [Object] }
    # Adds the given annotation type to the list of annotation types whose
    # annotations should be painted by this painter using squiggly drawing. If the annotation  type
    # is already in this list, this method is without effect.
    # 
    # @param annotationType the annotation type
    def add_annotation_type(annotation_type)
      add_annotation_type(annotation_type, SQUIGGLES)
    end
    
    typesig { [Object, Object] }
    # Adds the given annotation type to the list of annotation types whose
    # annotations should be painted by this painter using the given drawing strategy.
    # If the annotation type is already in this list, the old drawing strategy gets replaced.
    # 
    # @param annotationType the annotation type
    # @param drawingStrategyID the id of the drawing strategy that should be used for this annotation type
    # @since 3.0
    def add_annotation_type(annotation_type, drawing_strategy_id)
      @f_annotation_type2painting_strategy_id.put(annotation_type, drawing_strategy_id)
      @f_cached_annotation_type2painting_strategy.clear
      if ((@f_text_input_listener).nil?)
        @f_text_input_listener = Class.new(ITextInputListener.class == Class ? ITextInputListener : Object) do
          extend LocalClass
          include_class_members AnnotationPainter
          include ITextInputListener if ITextInputListener.class == Module
          
          typesig { [IDocument, IDocument] }
          # @see org.eclipse.jface.text.ITextInputListener#inputDocumentAboutToBeChanged(org.eclipse.jface.text.IDocument, org.eclipse.jface.text.IDocument)
          define_method :input_document_about_to_be_changed do |old_input, new_input|
            self.attr_f_input_document_about_to_be_changed = true
          end
          
          typesig { [IDocument, IDocument] }
          # @see org.eclipse.jface.text.ITextInputListener#inputDocumentChanged(org.eclipse.jface.text.IDocument, org.eclipse.jface.text.IDocument)
          define_method :input_document_changed do |old_input, new_input|
            self.attr_f_input_document_about_to_be_changed = false
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self)
        @f_source_viewer.add_text_input_listener(@f_text_input_listener)
      end
    end
    
    typesig { [Object, IDrawingStrategy] }
    # Registers a new drawing strategy under the given ID. If there is already a
    # strategy registered under <code>id</code>, the old strategy gets replaced.
    # <p>The given id can be referenced when adding annotation types, see
    # {@link #addAnnotationType(Object, Object)}.</p>
    # 
    # @param id the identifier under which the strategy can be referenced, not <code>null</code>
    # @param strategy the new strategy
    # @since 3.0
    def add_drawing_strategy(id, strategy)
      # don't permit null as null is used to signal that an annotation type is not
      # registered with a specific strategy, and that its annotation hierarchy should be searched
      if ((id).nil?)
        raise IllegalArgumentException.new
      end
      @f_painting_strategy_id2painting_strategy.put(id, strategy)
      @f_cached_annotation_type2painting_strategy.clear
    end
    
    typesig { [Object, ITextStyleStrategy] }
    # Registers a new drawing strategy under the given ID. If there is already
    # a strategy registered under <code>id</code>, the old strategy gets
    # replaced.
    # <p>
    # The given id can be referenced when adding annotation types, see
    # {@link #addAnnotationType(Object, Object)}.
    # </p>
    # 
    # @param id the identifier under which the strategy can be referenced, not <code>null</code>
    # @param strategy the new strategy
    # @since 3.4
    def add_text_style_strategy(id, strategy)
      # don't permit null as null is used to signal that an annotation type is not
      # registered with a specific strategy, and that its annotation hierarchy should be searched
      if ((id).nil?)
        raise IllegalArgumentException.new
      end
      @f_painting_strategy_id2painting_strategy.put(id, strategy)
      @f_cached_annotation_type2painting_strategy.clear
    end
    
    typesig { [Object] }
    # Adds the given annotation type to the list of annotation types whose
    # annotations should be highlighted this painter. If the annotation  type
    # is already in this list, this method is without effect.
    # 
    # @param annotationType the annotation type
    # @since 3.0
    def add_highlight_annotation_type(annotation_type)
      add_annotation_type(annotation_type, HIGHLIGHTING)
    end
    
    typesig { [Object] }
    # Removes the given annotation type from the list of annotation types whose
    # annotations are painted by this painter. If the annotation type is not
    # in this list, this method is without effect.
    # 
    # @param annotationType the annotation type
    def remove_annotation_type(annotation_type)
      @f_cached_annotation_type2painting_strategy.clear
      @f_annotation_type2painting_strategy_id.remove(annotation_type)
      if (@f_annotation_type2painting_strategy_id.is_empty && !(@f_text_input_listener).nil?)
        @f_source_viewer.remove_text_input_listener(@f_text_input_listener)
        @f_text_input_listener = nil
        @f_input_document_about_to_be_changed = false
      end
    end
    
    typesig { [Object] }
    # Removes the given annotation type from the list of annotation types whose
    # annotations are highlighted by this painter. If the annotation type is not
    # in this list, this method is without effect.
    # 
    # @param annotationType the annotation type
    # @since 3.0
    def remove_highlight_annotation_type(annotation_type)
      remove_annotation_type(annotation_type)
    end
    
    typesig { [] }
    # Clears the list of annotation types whose annotations are
    # painted by this painter.
    def remove_all_annotation_types
      @f_cached_annotation_type2painting_strategy.clear
      @f_annotation_type2painting_strategy_id.clear
      if (!(@f_text_input_listener).nil?)
        @f_source_viewer.remove_text_input_listener(@f_text_input_listener)
        @f_text_input_listener = nil
      end
    end
    
    typesig { [] }
    # Returns whether the list of annotation types whose annotations are painted
    # by this painter contains at least on element.
    # 
    # @return <code>true</code> if there is an annotation type whose annotations are painted
    def is_painting_annotations
      return !@f_annotation_type2painting_strategy_id.is_empty
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.IPainter#dispose()
    def dispose
      if (!(@f_annotation_type2color).nil?)
        @f_annotation_type2color.clear
        @f_annotation_type2color = nil
      end
      if (!(@f_cached_annotation_type2color).nil?)
        @f_cached_annotation_type2color.clear
        @f_cached_annotation_type2color = nil
      end
      if (!(@f_cached_annotation_type2painting_strategy).nil?)
        @f_cached_annotation_type2painting_strategy.clear
        @f_cached_annotation_type2painting_strategy = nil
      end
      if (!(@f_annotation_type2painting_strategy_id).nil?)
        @f_annotation_type2painting_strategy_id.clear
        @f_annotation_type2painting_strategy_id = nil
      end
      @f_text_widget = nil
      @f_source_viewer = nil
      @f_annotation_access = nil
      @f_model = nil
      synchronized((@f_decoration_map_lock)) do
        @f_decorations_map = nil
      end
      synchronized((@f_highlighted_decorations_map_lock)) do
        @f_highlighted_decorations_map = nil
      end
    end
    
    typesig { [] }
    # Returns the document offset of the upper left corner of the source viewer's view port,
    # possibly including partially visible lines.
    # 
    # @return the document offset if the upper left corner of the view port
    def get_inclusive_top_index_start_offset
      if (!(@f_text_widget).nil? && !@f_text_widget.is_disposed)
        top = JFaceTextUtil.get_partial_top_index(@f_source_viewer)
        begin
          document = @f_source_viewer.get_document
          return document.get_line_offset(top)
        rescue BadLocationException => x
        end
      end
      return -1
    end
    
    typesig { [] }
    # Returns the first invisible document offset of the lower right corner of the source viewer's view port,
    # possibly including partially visible lines.
    # 
    # @return the first invisible document offset of the lower right corner of the view port
    def get_exclusive_bottom_index_end_offset
      if (!(@f_text_widget).nil? && !@f_text_widget.is_disposed)
        bottom = JFaceTextUtil.get_partial_bottom_index(@f_source_viewer)
        begin
          document = @f_source_viewer.get_document
          if (bottom >= document.get_number_of_lines)
            bottom = document.get_number_of_lines - 1
          end
          return document.get_line_offset(bottom) + document.get_line_length(bottom)
        rescue BadLocationException => x
        end
      end
      return -1
    end
    
    typesig { [PaintEvent] }
    # @see org.eclipse.swt.events.PaintListener#paintControl(org.eclipse.swt.events.PaintEvent)
    def paint_control(event)
      if (!(@f_text_widget).nil?)
        handle_draw_request(event)
      end
    end
    
    typesig { [PaintEvent] }
    # Handles the request to draw the annotations using the given graphical context.
    # 
    # @param event the paint event or <code>null</code>
    def handle_draw_request(event)
      if ((@f_text_widget).nil?)
        # is already disposed
        return
      end
      clipping_region = compute_clipping_region(event, false)
      if ((clipping_region).nil?)
        return
      end
      v_offset = clipping_region.get_offset
      v_length = clipping_region.get_length
      gc = !(event).nil? ? event.attr_gc : nil
      # Clone decorations
      decorations = nil
      synchronized((@f_decoration_map_lock)) do
        decorations = ArrayList.new(@f_decorations_map.size)
        decorations.add_all(@f_decorations_map.entry_set)
      end
      # Create a new list of annotations to be drawn, since removing from decorations is more
      # expensive. One bucket per drawing layer. Use linked lists as addition is cheap here.
      to_be_drawn = ArrayList.new(10)
      e = decorations.iterator
      while e.has_next
        entry = e.next_
        a = entry.get_key
        pp = entry.get_value
        # prune any annotation that is not drawable or does not need drawing
        if (!(a.is_marked_deleted || skip(a) || !pp.attr_f_position.overlaps_with(v_offset, v_length)))
          # ensure sized appropriately
          i = to_be_drawn.size
          while i <= pp.attr_f_layer
            to_be_drawn.add(LinkedList.new)
            i += 1
          end
          (to_be_drawn.get(pp.attr_f_layer)).add(entry)
        end
      end
      document = @f_source_viewer.get_document
      it = to_be_drawn.iterator
      while it.has_next
        layer = it.next_
        e_ = layer.iterator
        while e_.has_next
          entry = e_.next_
          a = entry.get_key
          pp = entry.get_value
          draw_decoration(pp, gc, a, clipping_region, document)
        end
      end
    end
    
    typesig { [Decoration, GC, Annotation, IRegion, IDocument] }
    def draw_decoration(pp, gc, annotation, clipping_region, document)
      if ((clipping_region).nil?)
        return
      end
      if (!(pp.attr_f_painting_strategy.is_a?(IDrawingStrategy)))
        return
      end
      drawing_strategy = pp.attr_f_painting_strategy
      clipping_offset = clipping_region.get_offset
      clipping_length = clipping_region.get_length
      p = pp.attr_f_position
      begin
        start_line = document.get_line_of_offset(p.get_offset)
        last_inclusive = Math.max(p.get_offset, p.get_offset + p.get_length - 1)
        end_line = document.get_line_of_offset(last_inclusive)
        i = start_line
        while i <= end_line
          line_offset = document.get_line_offset(i)
          paint_start = Math.max(line_offset, p.get_offset)
          line_delimiter = document.get_line_delimiter(i)
          delimiter_length = !(line_delimiter).nil? ? line_delimiter.length : 0
          paint_length = Math.min(line_offset + document.get_line_length(i) - delimiter_length, p.get_offset + p.get_length) - paint_start
          if (paint_length >= 0 && overlaps_with(paint_start, paint_length, clipping_offset, clipping_length))
            # otherwise inside a line delimiter
            widget_range = get_widget_range(paint_start, paint_length)
            if (!(widget_range).nil?)
              drawing_strategy.draw(annotation, gc, @f_text_widget, widget_range.get_offset, widget_range.get_length, pp.attr_f_color)
            end
          end
          i += 1
        end
      rescue BadLocationException => x
      end
    end
    
    typesig { [PaintEvent, ::Java::Boolean] }
    # Computes the model (document) region that is covered by the paint event's clipping region. If
    # <code>event</code> is <code>null</code>, the model range covered by the visible editor
    # area (viewport) is returned.
    # 
    # @param event the paint event or <code>null</code> to use the entire viewport
    # @param isClearing tells whether the clipping is need for clearing an annotation
    # @return the model region comprised by either the paint event's clipping region or the
    # viewport
    # @since 3.2
    def compute_clipping_region(event, is_clearing)
      if ((event).nil?)
        if (!is_clearing && !(@f_current_draw_range).nil?)
          return Region.new(@f_current_draw_range.attr_offset, @f_current_draw_range.attr_length)
        end
        # trigger a repaint of the entire viewport
        v_offset = get_inclusive_top_index_start_offset
        if ((v_offset).equal?(-1))
          return nil
        end
        # http://bugs.eclipse.org/bugs/show_bug.cgi?id=17147
        v_length = get_exclusive_bottom_index_end_offset - v_offset
        return Region.new(v_offset, v_length)
      end
      widget_offset = 0
      begin
        widget_clipping_start_offset = @f_text_widget.get_offset_at_location(Point.new(0, event.attr_y))
        first_widget_line = @f_text_widget.get_line_at_offset(widget_clipping_start_offset)
        widget_offset = @f_text_widget.get_offset_at_line(first_widget_line)
      rescue IllegalArgumentException => ex1
        begin
          first_visible_line = JFaceTextUtil.get_partial_top_index(@f_text_widget)
          widget_offset = @f_text_widget.get_offset_at_line(first_visible_line)
        rescue IllegalArgumentException => ex2
          # above try code might fail too
          widget_offset = 0
        end
      end
      widget_end_offset = 0
      begin
        widget_clipping_end_offset = @f_text_widget.get_offset_at_location(Point.new(0, event.attr_y + event.attr_height))
        last_widget_line = @f_text_widget.get_line_at_offset(widget_clipping_end_offset)
        widget_end_offset = @f_text_widget.get_offset_at_line(last_widget_line + 1)
      rescue IllegalArgumentException => ex1
        # happens if the editor is not "full", e.g. the last line of the document is visible in the editor
        begin
          last_visible_line = JFaceTextUtil.get_partial_bottom_index(@f_text_widget)
          if ((last_visible_line).equal?(@f_text_widget.get_line_count - 1))
            # last line
            widget_end_offset = @f_text_widget.get_char_count
          else
            widget_end_offset = @f_text_widget.get_offset_at_line(last_visible_line + 1) - 1
          end
        rescue IllegalArgumentException => ex2
          # above try code might fail too
          widget_end_offset = @f_text_widget.get_char_count
        end
      end
      clipping_region = get_model_range(widget_offset, widget_end_offset - widget_offset)
      return clipping_region
    end
    
    typesig { [Annotation] }
    # Should the given annotation be skipped when handling draw requests?
    # 
    # @param annotation the annotation
    # @return <code>true</code> iff the given annotation should be
    # skipped when handling draw requests
    # @since 3.0
    def skip(annotation)
      return false
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Returns the widget region that corresponds to the
    # given offset and length in the viewer's document.
    # 
    # @param modelOffset the model offset
    # @param modelLength the model length
    # @return the corresponding widget region
    def get_widget_range(model_offset, model_length)
      @f_reusable_region.set_offset(model_offset)
      @f_reusable_region.set_length(model_length)
      if ((@f_reusable_region).nil? || (@f_reusable_region.get_offset).equal?(JavaInteger::MAX_VALUE))
        return nil
      end
      if (@f_source_viewer.is_a?(ITextViewerExtension5))
        extension = @f_source_viewer
        return extension.model_range2widget_range(@f_reusable_region)
      end
      region = @f_source_viewer.get_visible_region
      offset = region.get_offset
      length_ = region.get_length
      if (overlaps_with(@f_reusable_region, region))
        p1 = Math.max(offset, @f_reusable_region.get_offset)
        p2 = Math.min(offset + length_, @f_reusable_region.get_offset + @f_reusable_region.get_length)
        return Region.new(p1 - offset, p2 - p1)
      end
      return nil
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Returns the model region that corresponds to the given region in the
    # viewer's text widget.
    # 
    # @param offset the offset in the viewer's widget
    # @param length the length in the viewer's widget
    # @return the corresponding document region
    # @since 3.2
    def get_model_range(offset, length_)
      if ((offset).equal?(JavaInteger::MAX_VALUE))
        return nil
      end
      if (@f_source_viewer.is_a?(ITextViewerExtension5))
        extension = @f_source_viewer
        return extension.widget_range2model_range(Region.new(offset, length_))
      end
      region = @f_source_viewer.get_visible_region
      return Region.new(region.get_offset + offset, length_)
    end
    
    typesig { [IRegion, IRegion] }
    # Checks whether the intersection of the given text ranges
    # is empty or not.
    # 
    # @param range1 the first range to check
    # @param range2 the second range to check
    # @return <code>true</code> if intersection is not empty
    def overlaps_with(range1, range2)
      return overlaps_with(range1.get_offset, range1.get_length, range2.get_offset, range2.get_length)
    end
    
    typesig { [::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int] }
    # Checks whether the intersection of the given text ranges
    # is empty or not.
    # 
    # @param offset1 offset of the first range
    # @param length1 length of the first range
    # @param offset2 offset of the second range
    # @param length2 length of the second range
    # @return <code>true</code> if intersection is not empty
    def overlaps_with(offset1, length1, offset2, length2)
      end_ = offset2 + length2
      this_end = offset1 + length1
      if (length2 > 0)
        if (length1 > 0)
          return offset1 < end_ && offset2 < this_end
        end
        return offset2 <= offset1 && offset1 < end_
      end
      if (length1 > 0)
        return offset1 <= offset2 && offset2 < this_end
      end
      return (offset1).equal?(offset2)
    end
    
    typesig { [::Java::Boolean] }
    # @see org.eclipse.jface.text.IPainter#deactivate(boolean)
    def deactivate(redraw)
      if (@f_is_active)
        @f_is_active = false
        disable_painting(redraw)
        set_model(nil)
        catchup_with_model(nil)
      end
    end
    
    typesig { [::Java::Int] }
    # Returns whether the given reason causes a repaint.
    # 
    # @param reason the reason
    # @return <code>true</code> if repaint reason, <code>false</code> otherwise
    # @since 3.0
    def is_repaint_reason(reason)
      return (CONFIGURATION).equal?(reason) || (INTERNAL).equal?(reason)
    end
    
    typesig { [ISourceViewer] }
    # Retrieves the annotation model from the given source viewer.
    # 
    # @param sourceViewer the source viewer
    # @return the source viewer's annotation model or <code>null</code> if none can be found
    # @since 3.0
    def find_annotation_model(source_viewer)
      if (!(source_viewer).nil?)
        return source_viewer.get_annotation_model
      end
      return nil
    end
    
    typesig { [::Java::Int] }
    # @see org.eclipse.jface.text.IPainter#paint(int)
    def paint(reason)
      if ((@f_source_viewer.get_document).nil?)
        deactivate(false)
        return
      end
      if (!@f_is_active)
        model = find_annotation_model(@f_source_viewer)
        if (!(model).nil?)
          @f_is_active = true
          set_model(model)
        end
      else
        if (is_repaint_reason(reason))
          update_painting(nil)
        end
      end
    end
    
    typesig { [IPaintPositionManager] }
    # @see org.eclipse.jface.text.IPainter#setPositionManager(org.eclipse.jface.text.IPaintPositionManager)
    def set_position_manager(manager)
    end
    
    private
    alias_method :initialize__annotation_painter, :initialize
  end
  
end
