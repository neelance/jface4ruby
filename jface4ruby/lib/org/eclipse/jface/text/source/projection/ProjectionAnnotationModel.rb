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
  module ProjectionAnnotationModelImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Source::Projection
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :Map
      include_const ::Org::Eclipse::Jface::Text, :BadLocationException
      include_const ::Org::Eclipse::Jface::Text, :Position
      include_const ::Org::Eclipse::Jface::Text::Source, :Annotation
      include_const ::Org::Eclipse::Jface::Text::Source, :AnnotationModel
    }
  end
  
  # A projection annotation model. It provides methods for modifying the
  # expansion state of the managed projection annotations.
  # <p>
  # Do not subclass. Use it as is.
  # </p>
  # 
  # @since 3.0
  # @noextend This class is not intended to be subclassed by clients.
  class ProjectionAnnotationModel < ProjectionAnnotationModelImports.const_get :AnnotationModel
    include_class_members ProjectionAnnotationModelImports
    
    typesig { [] }
    # Creates a new, empty projection annotation model.
    def initialize
      super()
    end
    
    typesig { [Annotation] }
    # Changes the state of the given annotation to collapsed. An appropriate
    # annotation model change event is sent out.
    # 
    # @param annotation the annotation
    def collapse(annotation)
      if (annotation.is_a?(ProjectionAnnotation))
        projection = annotation
        if (!projection.is_collapsed)
          projection.mark_collapsed
          modify_annotation(projection, true)
        end
      end
    end
    
    typesig { [Annotation] }
    # Changes the state of the given annotation to expanded. An appropriate
    # annotation model change event is sent out.
    # 
    # @param annotation the annotation
    def expand(annotation)
      if (annotation.is_a?(ProjectionAnnotation))
        projection = annotation
        if (projection.is_collapsed)
          projection.mark_expanded
          modify_annotation(projection, true)
        end
      end
    end
    
    typesig { [Annotation] }
    # Toggles the expansion state of the given annotation. An appropriate
    # annotation model change event is sent out.
    # 
    # @param annotation the annotation
    def toggle_expansion_state(annotation)
      if (annotation.is_a?(ProjectionAnnotation))
        projection = annotation
        if (projection.is_collapsed)
          projection.mark_expanded
        else
          projection.mark_collapsed
        end
        modify_annotation(projection, true)
      end
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Expands all annotations that overlap with the given range and are collapsed.
    # 
    # @param offset the range offset
    # @param length the range length
    # @return <code>true</code> if any annotation has been expanded, <code>false</code> otherwise
    def expand_all(offset, length)
      return expand_all(offset, length, true)
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Collapses all annotations that overlap with the given range and are collapsed.
    # 
    # @param offset the range offset
    # @param length the range length
    # @return <code>true</code> if any annotation has been collapse, <code>false</code>
    # otherwise
    # @since 3.2
    def collapse_all(offset, length)
      collapsing = false
      iterator = get_annotation_iterator
      while (iterator.has_next)
        annotation = iterator.next_
        if (!annotation.is_collapsed)
          position = get_position(annotation)
          # || is a delete at the boundary
          if (!(position).nil? && position.overlaps_with(offset, length))
            annotation.mark_collapsed
            modify_annotation(annotation, false)
            collapsing = true
          end
        end
      end
      if (collapsing)
        fire_model_changed
      end
      return collapsing
    end
    
    typesig { [::Java::Int, ::Java::Int, ::Java::Boolean] }
    # Expands all annotations that overlap with the given range and are collapsed. Fires a model change event if
    # requested.
    # 
    # @param offset the offset of the range
    # @param length the length of the range
    # @param fireModelChanged <code>true</code> if a model change event
    # should be fired, <code>false</code> otherwise
    # @return <code>true</code> if any annotation has been expanded, <code>false</code> otherwise
    def expand_all(offset, length, fire_model_changed_)
      expanding = false
      iterator = get_annotation_iterator
      while (iterator.has_next)
        annotation = iterator.next_
        if (annotation.is_collapsed)
          position = get_position(annotation)
          # || is a delete at the boundary
          if (!(position).nil? && position.overlaps_with(offset, length))
            annotation.mark_expanded
            modify_annotation(annotation, false)
            expanding = true
          end
        end
      end
      if (expanding && fire_model_changed_)
        fire_model_changed
      end
      return expanding
    end
    
    typesig { [Array.typed(Annotation), Map, Array.typed(Annotation)] }
    # Modifies the annotation model.
    # 
    # @param deletions the list of deleted annotations
    # @param additions the set of annotations to add together with their associated position
    # @param modifications the list of modified annotations
    def modify_annotations(deletions, additions, modifications)
      begin
        replace_annotations(deletions, additions, false)
        if (!(modifications).nil?)
          i = 0
          while i < modifications.attr_length
            modify_annotation(modifications[i], false)
            i += 1
          end
        end
      rescue BadLocationException => x
      end
      fire_model_changed
    end
    
    private
    alias_method :initialize__projection_annotation_model, :initialize
  end
  
end
