require "rjava"

# Copyright (c) 2000, 2009 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Source::Projection
  module ProjectionRulerColumnImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Source::Projection
      include_const ::Java::Util, :Iterator
      include_const ::Org::Eclipse::Swt::Events, :MouseEvent
      include_const ::Org::Eclipse::Swt::Events, :MouseMoveListener
      include_const ::Org::Eclipse::Swt::Events, :MouseTrackAdapter
      include_const ::Org::Eclipse::Swt::Graphics, :Color
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Jface::Text, :BadLocationException
      include_const ::Org::Eclipse::Jface::Text, :IDocument
      include_const ::Org::Eclipse::Jface::Text, :Position
      include_const ::Org::Eclipse::Jface::Text::Source, :AnnotationRulerColumn
      include_const ::Org::Eclipse::Jface::Text::Source, :CompositeRuler
      include_const ::Org::Eclipse::Jface::Text::Source, :IAnnotationAccess
      include_const ::Org::Eclipse::Jface::Text::Source, :IAnnotationModel
      include_const ::Org::Eclipse::Jface::Text::Source, :IAnnotationModelExtension
    }
  end
  
  # A ruler column for controlling the behavior of a
  # {@link org.eclipse.jface.text.source.projection.ProjectionViewer}.
  # 
  # @since 3.0
  class ProjectionRulerColumn < ProjectionRulerColumnImports.const_get :AnnotationRulerColumn
    include_class_members ProjectionRulerColumnImports
    
    attr_accessor :f_current_annotation
    alias_method :attr_f_current_annotation, :f_current_annotation
    undef_method :f_current_annotation
    alias_method :attr_f_current_annotation=, :f_current_annotation=
    undef_method :f_current_annotation=
    
    # Line number recorded on mouse down.
    # @since 3.5
    attr_accessor :f_mouse_down_line
    alias_method :attr_f_mouse_down_line, :f_mouse_down_line
    undef_method :f_mouse_down_line
    alias_method :attr_f_mouse_down_line=, :f_mouse_down_line=
    undef_method :f_mouse_down_line=
    
    typesig { [IAnnotationModel, ::Java::Int, IAnnotationAccess] }
    # Creates a new projection ruler column.
    # 
    # @param model the column's annotation model
    # @param width the width in pixels
    # @param annotationAccess the annotation access
    def initialize(model, width, annotation_access)
      @f_current_annotation = nil
      @f_mouse_down_line = 0
      super(model, width, annotation_access)
    end
    
    typesig { [::Java::Int, IAnnotationAccess] }
    # Creates a new projection ruler column.
    # 
    # @param width the width in pixels
    # @param annotationAccess the annotation access
    def initialize(width, annotation_access)
      @f_current_annotation = nil
      @f_mouse_down_line = 0
      super(width, annotation_access)
    end
    
    typesig { [::Java::Int] }
    # @see org.eclipse.jface.text.source.AnnotationRulerColumn#mouseClicked(int)
    def mouse_clicked(line)
      clear_current_annotation
      if (!(@f_mouse_down_line).equal?(line))
        return
      end
      annotation = find_annotation(line, true)
      if (!(annotation).nil?)
        model = get_model
        model.toggle_expansion_state(annotation)
      end
    end
    
    typesig { [::Java::Int] }
    # @see org.eclipse.jface.text.source.AnnotationRulerColumn#mouseDown(int)
    # @since 3.5
    def mouse_down(ruler_line)
      @f_mouse_down_line = ruler_line
    end
    
    typesig { [::Java::Int] }
    # @see org.eclipse.jface.text.source.AnnotationRulerColumn#mouseDoubleClicked(int)
    # @since 3.5
    def mouse_double_clicked(ruler_line)
      if (!(find_annotation(ruler_line, true)).nil?)
        return
      end
      annotation = find_annotation(ruler_line, false)
      if (!(annotation).nil?)
        model = get_model
        model.toggle_expansion_state(annotation)
      end
    end
    
    typesig { [::Java::Int, ::Java::Boolean] }
    # Returns the projection annotation of the column's annotation
    # model that contains the given line.
    # 
    # @param line the line
    # @param exact <code>true</code> if the annotation range must match exactly
    # @return the projection annotation containing the given line
    def find_annotation(line, exact)
      previous_annotation = nil
      model = get_model
      if (!(model).nil?)
        document = get_cached_text_viewer.get_document
        previous_distance = JavaInteger::MAX_VALUE
        e = model.get_annotation_iterator
        while (e.has_next)
          next__ = e.next_
          if (next__.is_a?(ProjectionAnnotation))
            annotation = next__
            p = model.get_position(annotation)
            if ((p).nil?)
              next
            end
            distance = get_distance(annotation, p, document, line)
            if ((distance).equal?(-1))
              next
            end
            if (!exact)
              if (distance < previous_distance)
                previous_annotation = annotation
                previous_distance = distance
              end
            else
              if ((distance).equal?(0))
                previous_annotation = annotation
              end
            end
          end
        end
      end
      return previous_annotation
    end
    
    typesig { [ProjectionAnnotation, Position, IDocument, ::Java::Int] }
    # Returns the distance of the given line to the start line of the given position in the given document. The distance is
    # <code>-1</code> when the line is not included in the given position.
    # 
    # @param annotation the annotation
    # @param position the position
    # @param document the document
    # @param line the line
    # @return <code>-1</code> if line is not contained, a position number otherwise
    def get_distance(annotation, position, document, line)
      if (position.get_offset > -1 && position.get_length > -1)
        begin
          start_line = document.get_line_of_offset(position.get_offset)
          end_line = document.get_line_of_offset(position.get_offset + position.get_length)
          if (start_line <= line && line < end_line)
            if (annotation.is_collapsed)
              caption_offset = 0
              if (position.is_a?(IProjectionPosition))
                caption_offset = (position).compute_caption_offset(document)
              else
                caption_offset = 0
              end
              caption_line = document.get_line_of_offset(position.get_offset + caption_offset)
              if (start_line <= caption_line && caption_line < end_line)
                return Math.abs(line - caption_line)
              end
            end
            return line - start_line
          end
        rescue BadLocationException => x
        end
      end
      return -1
    end
    
    typesig { [] }
    def clear_current_annotation
      if (!(@f_current_annotation).nil?)
        @f_current_annotation.set_range_indication(false)
        @f_current_annotation = nil
        return true
      end
      return false
    end
    
    typesig { [CompositeRuler, Composite] }
    # @see org.eclipse.jface.text.source.IVerticalRulerColumn#createControl(org.eclipse.jface.text.source.CompositeRuler, org.eclipse.swt.widgets.Composite)
    def create_control(parent_ruler, parent_control)
      control = super(parent_ruler, parent_control)
      # set background
      background = get_cached_text_viewer.get_text_widget.get_background
      control.set_background(background)
      control.add_mouse_track_listener(# install hover listener
      Class.new(MouseTrackAdapter.class == Class ? MouseTrackAdapter : Object) do
        extend LocalClass
        include_class_members ProjectionRulerColumn
        include MouseTrackAdapter if MouseTrackAdapter.class == Module
        
        typesig { [MouseEvent] }
        define_method :mouse_exit do |e|
          if (clear_current_annotation)
            redraw
          end
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      control.add_mouse_move_listener(# install mouse move listener
      Class.new(MouseMoveListener.class == Class ? MouseMoveListener : Object) do
        extend LocalClass
        include_class_members ProjectionRulerColumn
        include MouseMoveListener if MouseMoveListener.class == Module
        
        typesig { [MouseEvent] }
        define_method :mouse_move do |e|
          redraw = false
          annotation = find_annotation(to_document_line_number(e.attr_y), false)
          if (!(annotation).equal?(self.attr_f_current_annotation))
            if (!(self.attr_f_current_annotation).nil?)
              self.attr_f_current_annotation.set_range_indication(false)
              redraw = true
            end
            self.attr_f_current_annotation = annotation
            if (!(self.attr_f_current_annotation).nil? && !self.attr_f_current_annotation.is_collapsed)
              self.attr_f_current_annotation.set_range_indication(true)
              redraw = true
            end
          end
          if (redraw)
            redraw
          end
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      return control
    end
    
    typesig { [IAnnotationModel] }
    # @see org.eclipse.jface.text.source.AnnotationRulerColumn#setModel(org.eclipse.jface.text.source.IAnnotationModel)
    def set_model(model)
      if (model.is_a?(IAnnotationModelExtension))
        extension = model
        model = extension.get_annotation_model(ProjectionSupport::PROJECTION)
      end
      super(model)
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.source.AnnotationRulerColumn#isPropagatingMouseListener()
    def is_propagating_mouse_listener
      return false
    end
    
    typesig { [::Java::Int] }
    # @see org.eclipse.jface.text.source.AnnotationRulerColumn#hasAnnotation(int)
    def has_annotation(line_number)
      return !(find_annotation(line_number, true)).nil?
    end
    
    private
    alias_method :initialize__projection_ruler_column, :initialize
  end
  
end
