require "rjava"

# Copyright (c) 2005, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text
  module DefaultTextHoverImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
      include_const ::Java::Util, :Iterator
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Jface::Text::Source, :Annotation
      include_const ::Org::Eclipse::Jface::Text::Source, :IAnnotationModel
      include_const ::Org::Eclipse::Jface::Text::Source, :ISourceViewer
      include_const ::Org::Eclipse::Jface::Text::Source, :ISourceViewerExtension2
    }
  end
  
  # Standard implementation of {@link org.eclipse.jface.text.ITextHover}.
  # 
  # @since 3.2
  class DefaultTextHover 
    include_class_members DefaultTextHoverImports
    include ITextHover
    
    # This hover's source viewer
    attr_accessor :f_source_viewer
    alias_method :attr_f_source_viewer, :f_source_viewer
    undef_method :f_source_viewer
    alias_method :attr_f_source_viewer=, :f_source_viewer=
    undef_method :f_source_viewer=
    
    typesig { [ISourceViewer] }
    # Creates a new annotation hover.
    # 
    # @param sourceViewer this hover's annotation model
    def initialize(source_viewer)
      @f_source_viewer = nil
      Assert.is_not_null(source_viewer)
      @f_source_viewer = source_viewer
    end
    
    typesig { [ITextViewer, IRegion] }
    # {@inheritDoc}
    # 
    # @deprecated As of 3.4, replaced by {@link ITextHoverExtension2#getHoverInfo2(ITextViewer, IRegion)}
    def get_hover_info(text_viewer, hover_region)
      model = get_annotation_model(@f_source_viewer)
      if ((model).nil?)
        return nil
      end
      e = model.get_annotation_iterator
      while (e.has_next)
        a = e.next_
        if (is_included(a))
          p = model.get_position(a)
          if (!(p).nil? && p.overlaps_with(hover_region.get_offset, hover_region.get_length))
            msg = a.get_text
            if (!(msg).nil? && msg.trim.length > 0)
              return msg
            end
          end
        end
      end
      return nil
    end
    
    typesig { [ITextViewer, ::Java::Int] }
    # @see org.eclipse.jface.text.ITextHover#getHoverRegion(org.eclipse.jface.text.ITextViewer, int)
    def get_hover_region(text_viewer, offset)
      return find_word(text_viewer.get_document, offset)
    end
    
    typesig { [Annotation] }
    # Tells whether the annotation should be included in
    # the computation.
    # 
    # @param annotation the annotation to test
    # @return <code>true</code> if the annotation is included in the computation
    def is_included(annotation)
      return true
    end
    
    typesig { [ISourceViewer] }
    def get_annotation_model(viewer)
      if (viewer.is_a?(ISourceViewerExtension2))
        extension = viewer
        return extension.get_visual_annotation_model
      end
      return viewer.get_annotation_model
    end
    
    typesig { [IDocument, ::Java::Int] }
    def find_word(document, offset)
      start = -2
      end_ = -1
      begin
        pos = offset
        c = 0
        while (pos >= 0)
          c = document.get_char(pos)
          if (!Character.is_unicode_identifier_part(c))
            break
          end
          (pos -= 1)
        end
        start = pos
        pos = offset
        length = document.get_length
        while (pos < length)
          c = document.get_char(pos)
          if (!Character.is_unicode_identifier_part(c))
            break
          end
          (pos += 1)
        end
        end_ = pos
      rescue BadLocationException => x
      end
      if (start >= -1 && end_ > -1)
        if ((start).equal?(offset) && (end_).equal?(offset))
          return Region.new(offset, 0)
        else
          if ((start).equal?(offset))
            return Region.new(start, end_ - start)
          else
            return Region.new(start + 1, end_ - start - 1)
          end
        end
      end
      return nil
    end
    
    private
    alias_method :initialize__default_text_hover, :initialize
  end
  
end
