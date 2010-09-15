require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Source::Projection
  module ProjectionSupportImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Source::Projection
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :JavaList
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Custom, :StyledText
      include_const ::Org::Eclipse::Swt::Custom, :StyledTextContent
      include_const ::Org::Eclipse::Swt::Graphics, :Color
      include_const ::Org::Eclipse::Swt::Graphics, :FontMetrics
      include_const ::Org::Eclipse::Swt::Graphics, :SwtGC
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Graphics, :RGB
      include_const ::Org::Eclipse::Swt::Widgets, :Display
      include_const ::Org::Eclipse::Jface::Text, :IInformationControlCreator
      include_const ::Org::Eclipse::Jface::Text::Source, :Annotation
      include_const ::Org::Eclipse::Jface::Text::Source, :AnnotationPainter
      include_const ::Org::Eclipse::Jface::Text::Source, :IAnnotationAccess
      include_const ::Org::Eclipse::Jface::Text::Source, :IAnnotationHover
      include_const ::Org::Eclipse::Jface::Text::Source, :IAnnotationModel
      include_const ::Org::Eclipse::Jface::Text::Source, :ISharedTextColors
      include_const ::Org::Eclipse::Jface::Text::Source, :ISourceViewer
    }
  end
  
  # Supports the configuration of projection capabilities a {@link org.eclipse.jface.text.source.projection.ProjectionViewer}.
  # <p>
  # This class is not intended to be subclassed. Clients are supposed to configure and use it as is.</p>
  # 
  # @since 3.0
  # @noextend This class is not intended to be subclassed by clients.
  class ProjectionSupport 
    include_class_members ProjectionSupportImports
    
    class_module.module_eval {
      # Key of the projection annotation model inside the visual annotation
      # model. Also internally used as key for the projection drawing strategy.
      const_set_lazy(:PROJECTION) { Object.new }
      const_attr_reader  :PROJECTION
      
      const_set_lazy(:ProjectionAnnotationsPainter) { Class.new(AnnotationPainter) do
        include_class_members ProjectionSupport
        
        typesig { [class_self::ISourceViewer, class_self::IAnnotationAccess] }
        # Creates a new painter indicating the location of collapsed regions.
        # 
        # @param sourceViewer the source viewer for the painter
        # @param access the annotation access
        def initialize(source_viewer, access)
          super(source_viewer, access)
        end
        
        typesig { [class_self::ISourceViewer] }
        # @see org.eclipse.jface.text.source.AnnotationPainter#findAnnotationModel(org.eclipse.jface.text.source.ISourceViewer)
        def find_annotation_model(source_viewer)
          if (source_viewer.is_a?(self.class::ProjectionViewer))
            projection_viewer = source_viewer
            return projection_viewer.get_projection_annotation_model
          end
          return nil
        end
        
        typesig { [class_self::Annotation] }
        # @see org.eclipse.jface.text.source.AnnotationPainter#skip(org.eclipse.jface.text.source.Annotation)
        def skip(annotation)
          if (annotation.is_a?(self.class::ProjectionAnnotation))
            return !(annotation).is_collapsed
          end
          return super(annotation)
        end
        
        private
        alias_method :initialize__projection_annotations_painter, :initialize
      end }
      
      const_set_lazy(:ProjectionDrawingStrategy) { Class.new do
        include_class_members ProjectionSupport
        include AnnotationPainter::IDrawingStrategy
        
        typesig { [class_self::Annotation, SwtGC, class_self::StyledText, ::Java::Int, ::Java::Int, class_self::Color] }
        # @see org.eclipse.jface.text.source.AnnotationPainter.IDrawingStrategy#draw(org.eclipse.swt.graphics.GC, org.eclipse.swt.custom.StyledText, int, int, org.eclipse.swt.graphics.Color)
        def draw(annotation, gc, text_widget, offset, length, color)
          if (annotation.is_a?(self.class::ProjectionAnnotation))
            projection_annotation = annotation
            if (projection_annotation.is_collapsed)
              if (!(gc).nil?)
                content = text_widget.get_content
                line = content.get_line_at_offset(offset)
                line_start = content.get_offset_at_line(line)
                text = content.get_line(line)
                line_length = (text).nil? ? 0 : text.length
                line_end = line_start + line_length
                p = text_widget.get_location_at_offset(line_end)
                c = gc.get_foreground
                gc.set_foreground(color)
                metrics = gc.get_font_metrics
                # baseline: where the dots are drawn
                baseline = text_widget.get_baseline(offset)
                # descent: number of pixels that the box extends over baseline
                descent = Math.min(2, text_widget.get_line_height(offset) - baseline)
                # ascent: so much does the box stand up from baseline
                ascent = metrics.get_ascent
                # leading: free space from line top to box upper line
                leading = baseline - ascent
                # height: height of the box
                height = ascent + descent
                width = metrics.get_average_char_width
                gc.draw_rectangle(p.attr_x, p.attr_y + leading, width, height)
                third = width / 3
                dots_vertical = p.attr_y + baseline - 1
                gc.draw_point(p.attr_x + third, dots_vertical)
                gc.draw_point(p.attr_x + width - third, dots_vertical)
                gc.set_foreground(c)
              else
                text_widget.redraw_range(offset, length, true)
              end
            end
          end
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__projection_drawing_strategy, :initialize
      end }
      
      const_set_lazy(:ProjectionListener) { Class.new do
        local_class_in ProjectionSupport
        include_class_members ProjectionSupport
        include IProjectionListener
        
        typesig { [] }
        # @see org.eclipse.jface.text.source.projection.IProjectionListener#projectionEnabled()
        def projection_enabled
          do_enable_projection
        end
        
        typesig { [] }
        # @see org.eclipse.jface.text.source.projection.IProjectionListener#projectionDisabled()
        def projection_disabled
          do_disable_projection
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__projection_listener, :initialize
      end }
    }
    
    attr_accessor :f_viewer
    alias_method :attr_f_viewer, :f_viewer
    undef_method :f_viewer
    alias_method :attr_f_viewer=, :f_viewer=
    undef_method :f_viewer=
    
    attr_accessor :f_annotation_access
    alias_method :attr_f_annotation_access, :f_annotation_access
    undef_method :f_annotation_access
    alias_method :attr_f_annotation_access=, :f_annotation_access=
    undef_method :f_annotation_access=
    
    attr_accessor :f_shared_text_colors
    alias_method :attr_f_shared_text_colors, :f_shared_text_colors
    undef_method :f_shared_text_colors
    alias_method :attr_f_shared_text_colors=, :f_shared_text_colors=
    undef_method :f_shared_text_colors=
    
    attr_accessor :f_summarizable_types
    alias_method :attr_f_summarizable_types, :f_summarizable_types
    undef_method :f_summarizable_types
    alias_method :attr_f_summarizable_types=, :f_summarizable_types=
    undef_method :f_summarizable_types=
    
    attr_accessor :f_information_control_creator
    alias_method :attr_f_information_control_creator, :f_information_control_creator
    undef_method :f_information_control_creator
    alias_method :attr_f_information_control_creator=, :f_information_control_creator=
    undef_method :f_information_control_creator=
    
    attr_accessor :f_information_presenter_control_creator
    alias_method :attr_f_information_presenter_control_creator, :f_information_presenter_control_creator
    undef_method :f_information_presenter_control_creator
    alias_method :attr_f_information_presenter_control_creator=, :f_information_presenter_control_creator=
    undef_method :f_information_presenter_control_creator=
    
    attr_accessor :f_projection_listener
    alias_method :attr_f_projection_listener, :f_projection_listener
    undef_method :f_projection_listener
    alias_method :attr_f_projection_listener=, :f_projection_listener=
    undef_method :f_projection_listener=
    
    attr_accessor :f_painter
    alias_method :attr_f_painter, :f_painter
    undef_method :f_painter
    alias_method :attr_f_painter=, :f_painter=
    undef_method :f_painter=
    
    attr_accessor :f_column
    alias_method :attr_f_column, :f_column
    undef_method :f_column
    alias_method :attr_f_column=, :f_column=
    undef_method :f_column=
    
    # @since 3.1
    attr_accessor :f_drawing_strategy
    alias_method :attr_f_drawing_strategy, :f_drawing_strategy
    undef_method :f_drawing_strategy
    alias_method :attr_f_drawing_strategy=, :f_drawing_strategy=
    undef_method :f_drawing_strategy=
    
    typesig { [ProjectionViewer, IAnnotationAccess, ISharedTextColors] }
    # Creates new projection support for the given projection viewer. Initially,
    # no annotation types are summarized. A default hover control creator and a
    # default drawing strategy are used.
    # 
    # @param viewer the projection viewer
    # @param annotationAccess the annotation access
    # @param sharedTextColors the shared text colors to use
    def initialize(viewer, annotation_access, shared_text_colors)
      @f_viewer = nil
      @f_annotation_access = nil
      @f_shared_text_colors = nil
      @f_summarizable_types = nil
      @f_information_control_creator = nil
      @f_information_presenter_control_creator = nil
      @f_projection_listener = nil
      @f_painter = nil
      @f_column = nil
      @f_drawing_strategy = nil
      @f_viewer = viewer
      @f_annotation_access = annotation_access
      @f_shared_text_colors = shared_text_colors
    end
    
    typesig { [String] }
    # Marks the given annotation type to be considered when creating summaries for
    # collapsed regions of the projection viewer.
    # <p>
    # A summary is an annotation that gets created out of all annotations with a
    # type that has been registered through this method and that are inside the
    # folded region.
    # </p>
    # 
    # @param annotationType the annotation type to consider
    def add_summarizable_annotation_type(annotation_type)
      if ((@f_summarizable_types).nil?)
        @f_summarizable_types = ArrayList.new
        @f_summarizable_types.add(annotation_type)
      else
        if (!@f_summarizable_types.contains(annotation_type))
          @f_summarizable_types.add(annotation_type)
        end
      end
    end
    
    typesig { [String] }
    # Marks the given annotation type to be ignored when creating summaries for
    # collapsed regions of the projection viewer. This method has only an effect
    # when <code>addSummarizableAnnotationType</code> has been called before for
    # the give annotation type.
    # <p>
    # A summary is an annotation that gets created out of all annotations with a
    # type that has been registered through this method and that are inside the
    # folded region.
    # </p>
    # 
    # @param annotationType the annotation type to remove
    def remove_summarizable_annotation_type(annotation_type)
      if (!(@f_summarizable_types).nil?)
        @f_summarizable_types.remove(annotation_type)
      end
      if ((@f_summarizable_types.size).equal?(0))
        @f_summarizable_types = nil
      end
    end
    
    typesig { [IInformationControlCreator] }
    # Sets the hover control creator that is used for the annotation hovers
    # that are shown in the projection viewer's projection ruler column.
    # 
    # @param creator the hover control creator
    def set_hover_control_creator(creator)
      @f_information_control_creator = creator
    end
    
    typesig { [IInformationControlCreator] }
    # Sets the information presenter control creator that is used for the annotation
    # hovers that are shown in the projection viewer's projection ruler column.
    # 
    # @param creator the information presenter control creator
    # @since 3.3
    def set_information_presenter_control_creator(creator)
      @f_information_presenter_control_creator = creator
    end
    
    typesig { [AnnotationPainter::IDrawingStrategy] }
    # Sets the drawing strategy that the projection support's annotation
    # painter uses to draw the indication of collapsed regions onto the
    # projection viewer's text widget. When <code>null</code> is passed in,
    # the drawing strategy is reset to the default. In order to avoid any
    # representation use {@link org.eclipse.jface.text.source.AnnotationPainter.NullStrategy}.
    # 
    # @param strategy the drawing strategy or <code>null</code> to reset the
    # strategy to the default
    # @since 3.1
    def set_annotation_painter_drawing_strategy(strategy)
      @f_drawing_strategy = strategy
    end
    
    typesig { [] }
    # Returns the drawing strategy to be used by the support's annotation painter.
    # 
    # @return the drawing strategy to be used by the support's annotation painter
    # @since 3.1
    def get_drawing_strategy
      if ((@f_drawing_strategy).nil?)
        @f_drawing_strategy = ProjectionDrawingStrategy.new
      end
      return @f_drawing_strategy
    end
    
    typesig { [] }
    # Installs this projection support on its viewer.
    def install
      @f_viewer.set_projection_summary(create_projection_summary)
      @f_projection_listener = ProjectionListener.new_local(self)
      @f_viewer.add_projection_listener(@f_projection_listener)
    end
    
    typesig { [] }
    # Disposes this projection support.
    def dispose
      if (!(@f_projection_listener).nil?)
        @f_viewer.remove_projection_listener(@f_projection_listener)
        @f_projection_listener = nil
      end
    end
    
    typesig { [] }
    # Enables projection mode. If not yet done, installs the projection ruler
    # column in the viewer's vertical ruler and installs a painter that
    # indicate the locations of collapsed regions.
    def do_enable_projection
      if ((@f_painter).nil?)
        @f_painter = ProjectionAnnotationsPainter.new(@f_viewer, @f_annotation_access)
        @f_painter.add_drawing_strategy(PROJECTION, get_drawing_strategy)
        @f_painter.add_annotation_type(ProjectionAnnotation::TYPE, PROJECTION)
        @f_painter.set_annotation_type_color(ProjectionAnnotation::TYPE, @f_shared_text_colors.get_color(get_color))
        @f_viewer.add_painter(@f_painter)
      end
      if ((@f_column).nil?)
        @f_column = ProjectionRulerColumn.new(9, @f_annotation_access)
        @f_column.add_annotation_type(ProjectionAnnotation::TYPE)
        @f_column.set_hover(create_projection_annotation_hover)
        @f_viewer.add_vertical_ruler_column(@f_column)
      end
      @f_column.set_model(@f_viewer.get_visual_annotation_model)
    end
    
    typesig { [] }
    # Removes the projection ruler column and the painter from the projection
    # viewer.
    def do_disable_projection
      if (!(@f_painter).nil?)
        @f_viewer.remove_painter(@f_painter)
        @f_painter.dispose
        @f_painter = nil
      end
      if (!(@f_column).nil?)
        @f_viewer.remove_vertical_ruler_column(@f_column)
        @f_column = nil
      end
    end
    
    typesig { [] }
    def create_projection_summary
      summary = ProjectionSummary.new(@f_viewer, @f_annotation_access)
      if (!(@f_summarizable_types).nil?)
        size_ = @f_summarizable_types.size
        i = 0
        while i < size_
          summary.add_annotation_type(@f_summarizable_types.get(i))
          i += 1
        end
      end
      return summary
    end
    
    typesig { [] }
    def create_projection_annotation_hover
      hover = ProjectionAnnotationHover.new
      hover.set_hover_control_creator(@f_information_control_creator)
      hover.set_information_presenter_control_creator(@f_information_presenter_control_creator)
      return hover
    end
    
    typesig { [ISourceViewer, Class] }
    # Implements the contract of {@link org.eclipse.core.runtime.IAdaptable#getAdapter(java.lang.Class)}
    # by forwarding the adapter requests to the given viewer.
    # 
    # @param viewer the viewer
    # @param required the required class of the adapter
    # @return the adapter or <code>null</code>
    def get_adapter(viewer, required)
      if ((ProjectionAnnotationModel == required))
        if (viewer.is_a?(ProjectionViewer))
          projection_viewer = viewer
          return projection_viewer.get_projection_annotation_model
        end
      end
      return nil
    end
    
    typesig { [] }
    def get_color
      # TODO read out preference settings
      c = Display.get_default.get_system_color(SWT::COLOR_DARK_GRAY)
      return c.get_rgb
    end
    
    private
    alias_method :initialize__projection_support, :initialize
  end
  
end
