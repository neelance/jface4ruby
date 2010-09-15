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
  module ProjectionAnnotationHoverImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Source::Projection
      include_const ::Java::Util, :Iterator
      include_const ::Org::Eclipse::Swt::Widgets, :Shell
      include_const ::Org::Eclipse::Jface::Resource, :JFaceResources
      include_const ::Org::Eclipse::Jface::Text, :BadLocationException
      include_const ::Org::Eclipse::Jface::Text, :IDocument
      include_const ::Org::Eclipse::Jface::Text, :IInformationControl
      include_const ::Org::Eclipse::Jface::Text, :IInformationControlCreator
      include_const ::Org::Eclipse::Jface::Text, :IRegion
      include_const ::Org::Eclipse::Jface::Text, :Position
      include_const ::Org::Eclipse::Jface::Text::Information, :IInformationProviderExtension2
      include_const ::Org::Eclipse::Jface::Text::Source, :IAnnotationHover
      include_const ::Org::Eclipse::Jface::Text::Source, :IAnnotationHoverExtension
      include_const ::Org::Eclipse::Jface::Text::Source, :IAnnotationModel
      include_const ::Org::Eclipse::Jface::Text::Source, :IAnnotationModelExtension
      include_const ::Org::Eclipse::Jface::Text::Source, :ILineRange
      include_const ::Org::Eclipse::Jface::Text::Source, :ISourceViewer
      include_const ::Org::Eclipse::Jface::Text::Source, :ISourceViewerExtension2
      include_const ::Org::Eclipse::Jface::Text::Source, :LineRange
    }
  end
  
  # Annotation hover for projection annotations.
  # 
  # @since 3.0
  class ProjectionAnnotationHover 
    include_class_members ProjectionAnnotationHoverImports
    include IAnnotationHover
    include IAnnotationHoverExtension
    include IInformationProviderExtension2
    
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
    
    typesig { [IInformationControlCreator] }
    # Sets the hover control creator for this projection annotation hover.
    # 
    # @param creator the creator
    def set_hover_control_creator(creator)
      @f_information_control_creator = creator
    end
    
    typesig { [IInformationControlCreator] }
    # Sets the information presenter control creator for this projection annotation hover.
    # 
    # @param creator the creator
    # @since 3.3
    def set_information_presenter_control_creator(creator)
      @f_information_presenter_control_creator = creator
    end
    
    typesig { [ISourceViewer, ::Java::Int] }
    # @see org.eclipse.jface.text.source.IAnnotationHover#getHoverInfo(org.eclipse.jface.text.source.ISourceViewer, int)
    def get_hover_info(source_viewer, line_number)
      # this is a no-op as semantics is defined by the implementation of the annotation hover extension
      return nil
    end
    
    typesig { [Position, IDocument, ::Java::Int] }
    # @since 3.1
    def is_caption_line(position, document, line)
      if (position.get_offset > -1 && position.get_length > -1)
        begin
          caption_offset = 0
          if (position.is_a?(IProjectionPosition))
            caption_offset = (position).compute_caption_offset(document)
          else
            caption_offset = 0
          end
          start_line = document.get_line_of_offset(position.get_offset + caption_offset)
          return (line).equal?(start_line)
        rescue BadLocationException => x
        end
      end
      return false
    end
    
    typesig { [ISourceViewer, ::Java::Int, ::Java::Int] }
    def get_projection_text_at_line(viewer, line, number_of_lines)
      model = nil
      if (viewer.is_a?(ISourceViewerExtension2))
        viewer_extension = viewer
        visual = viewer_extension.get_visual_annotation_model
        if (visual.is_a?(IAnnotationModelExtension))
          model_extension = visual
          model = model_extension.get_annotation_model(ProjectionSupport::PROJECTION)
        end
      end
      if (!(model).nil?)
        begin
          document = viewer.get_document
          e = model.get_annotation_iterator
          while (e.has_next)
            annotation = e.next_
            if (!annotation.is_collapsed)
              next
            end
            position = model.get_position(annotation)
            if ((position).nil?)
              next
            end
            if (is_caption_line(position, document, line))
              return get_text(document, position.get_offset, position.get_length, number_of_lines)
            end
          end
        rescue BadLocationException => x
        end
      end
      return nil
    end
    
    typesig { [IDocument, ::Java::Int, ::Java::Int, ::Java::Int] }
    def get_text(document, offset, length, number_of_lines)
      end_offset = offset + length
      begin
        end_line = document.get_line_of_offset(offset) + Math.max(0, number_of_lines - 1)
        line_info = document.get_line_information(end_line)
        end_offset = Math.min(end_offset, line_info.get_offset + line_info.get_length)
      rescue BadLocationException => x
      end
      return document.get(offset, end_offset - offset)
    end
    
    typesig { [ISourceViewer, ILineRange, ::Java::Int] }
    # @see org.eclipse.jface.text.source.IAnnotationHoverExtension#getHoverInfo(org.eclipse.jface.text.source.ISourceViewer, org.eclipse.jface.text.source.ILineRange, int)
    def get_hover_info(source_viewer, line_range, visible_lines)
      return get_projection_text_at_line(source_viewer, line_range.get_start_line, visible_lines)
    end
    
    typesig { [ISourceViewer, ::Java::Int] }
    # @see org.eclipse.jface.text.source.IAnnotationHoverExtension#getHoverLineRange(org.eclipse.jface.text.source.ISourceViewer, int)
    def get_hover_line_range(viewer, line_number)
      return LineRange.new(line_number, 1)
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.source.IAnnotationHoverExtension#canHandleMouseCursor()
    def can_handle_mouse_cursor
      return false
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.source.IAnnotationHoverExtension#getHoverControlCreator()
    def get_hover_control_creator
      if ((@f_information_control_creator).nil?)
        @f_information_control_creator = Class.new(IInformationControlCreator.class == Class ? IInformationControlCreator : Object) do
          local_class_in ProjectionAnnotationHover
          include_class_members ProjectionAnnotationHover
          include IInformationControlCreator if IInformationControlCreator.class == Module
          
          typesig { [Shell] }
          define_method :create_information_control do |parent|
            return self.class::SourceViewerInformationControl.new(parent, false, JFaceResources::TEXT_FONT, nil)
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self)
      end
      return @f_information_control_creator
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.information.IInformationProviderExtension2#getInformationPresenterControlCreator()
    # @since 3.3
    def get_information_presenter_control_creator
      if ((@f_information_presenter_control_creator).nil?)
        @f_information_presenter_control_creator = Class.new(IInformationControlCreator.class == Class ? IInformationControlCreator : Object) do
          local_class_in ProjectionAnnotationHover
          include_class_members ProjectionAnnotationHover
          include IInformationControlCreator if IInformationControlCreator.class == Module
          
          typesig { [Shell] }
          define_method :create_information_control do |parent|
            return self.class::SourceViewerInformationControl.new(parent, true, JFaceResources::TEXT_FONT, nil)
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self)
      end
      return @f_information_presenter_control_creator
    end
    
    typesig { [] }
    def initialize
      @f_information_control_creator = nil
      @f_information_presenter_control_creator = nil
    end
    
    private
    alias_method :initialize__projection_annotation_hover, :initialize
  end
  
end
