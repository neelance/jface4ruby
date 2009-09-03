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
  module AnnotationModelEventImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Source
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :HashSet
      include_const ::Java::Util, :Map
      include_const ::Java::Util, :JavaSet
      include_const ::Org::Eclipse::Jface::Text, :Position
    }
  end
  
  # Specification of changes applied to annotation models. The event carries the
  # changed annotation model as well as added, removed, and modified annotations.
  # <p>
  # An event can be sealed. Afterwards it can not be modified. Thus, the normal
  # process is that an empty event is created, filled with the changed
  # information, and before it is sent to the listeners, the event is sealed.
  # 
  # @see org.eclipse.jface.text.source.IAnnotationModel
  # @see org.eclipse.jface.text.source.IAnnotationModelListenerExtension
  # @since 2.0
  class AnnotationModelEvent 
    include_class_members AnnotationModelEventImports
    
    # The model this event refers to.
    attr_accessor :f_annotation_model
    alias_method :attr_f_annotation_model, :f_annotation_model
    undef_method :f_annotation_model
    alias_method :attr_f_annotation_model=, :f_annotation_model=
    undef_method :f_annotation_model=
    
    # The added annotations.
    # @since 3.0
    attr_accessor :f_added_annotations
    alias_method :attr_f_added_annotations, :f_added_annotations
    undef_method :f_added_annotations
    alias_method :attr_f_added_annotations=, :f_added_annotations=
    undef_method :f_added_annotations=
    
    # The removed annotations.
    # @since 3.0
    attr_accessor :f_removed_annotations
    alias_method :attr_f_removed_annotations, :f_removed_annotations
    undef_method :f_removed_annotations
    alias_method :attr_f_removed_annotations=, :f_removed_annotations=
    undef_method :f_removed_annotations=
    
    # The changed annotations.
    # @since 3.0
    attr_accessor :f_changed_annotations
    alias_method :attr_f_changed_annotations, :f_changed_annotations
    undef_method :f_changed_annotations
    alias_method :attr_f_changed_annotations=, :f_changed_annotations=
    undef_method :f_changed_annotations=
    
    # Indicates that this event does not contain detailed information.
    # @since 3.0
    attr_accessor :f_is_world_change
    alias_method :attr_f_is_world_change, :f_is_world_change
    undef_method :f_is_world_change
    alias_method :attr_f_is_world_change=, :f_is_world_change=
    undef_method :f_is_world_change=
    
    # The modification stamp.
    # @since 3.0
    attr_accessor :f_modification_stamp
    alias_method :attr_f_modification_stamp, :f_modification_stamp
    undef_method :f_modification_stamp
    alias_method :attr_f_modification_stamp=, :f_modification_stamp=
    undef_method :f_modification_stamp=
    
    typesig { [IAnnotationModel] }
    # Creates a new annotation model event for the given model.
    # 
    # @param model the model
    def initialize(model)
      initialize__annotation_model_event(model, true)
    end
    
    typesig { [IAnnotationModel, ::Java::Boolean] }
    # Creates a new annotation model event for the given model.
    # 
    # @param model the model
    # @param isWorldChange <code>true</code> if world change
    # @since 3.0
    def initialize(model, is_world_change)
      @f_annotation_model = nil
      @f_added_annotations = HashSet.new
      @f_removed_annotations = HashMap.new
      @f_changed_annotations = HashSet.new
      @f_is_world_change = false
      @f_modification_stamp = nil
      @f_annotation_model = model
      @f_is_world_change = is_world_change
    end
    
    typesig { [] }
    # Returns the model this event refers to.
    # 
    # @return the model this events belongs to
    def get_annotation_model
      return @f_annotation_model
    end
    
    typesig { [Annotation] }
    # Adds the given annotation to the set of annotations that are reported as
    # being added from the model. If this event is considered a world change,
    # it is no longer so after this method has successfully finished.
    # 
    # @param annotation the added annotation
    # @since 3.0
    def annotation_added(annotation)
      @f_added_annotations.add(annotation)
      @f_is_world_change = false
    end
    
    typesig { [] }
    # Returns the added annotations.
    # 
    # @return the added annotations
    # @since 3.0
    def get_added_annotations
      size_ = @f_added_annotations.size
      added = Array.typed(Annotation).new(size_) { nil }
      @f_added_annotations.to_array(added)
      return added
    end
    
    typesig { [Annotation] }
    # Adds the given annotation to the set of annotations that are reported as
    # being removed from the model. If this event is considered a world
    # change, it is no longer so after this method has successfully finished.
    # 
    # @param annotation the removed annotation
    # @since 3.0
    def annotation_removed(annotation)
      annotation_removed(annotation, nil)
    end
    
    typesig { [Annotation, Position] }
    # Adds the given annotation to the set of annotations that are reported as
    # being removed from the model. If this event is considered a world
    # change, it is no longer so after this method has successfully finished.
    # 
    # @param annotation the removed annotation
    # @param position the position of the removed annotation
    # @since 3.0
    def annotation_removed(annotation, position)
      @f_removed_annotations.put(annotation, position)
      @f_is_world_change = false
    end
    
    typesig { [] }
    # Returns the removed annotations.
    # 
    # @return the removed annotations
    # @since 3.0
    def get_removed_annotations
      size_ = @f_removed_annotations.size
      removed = Array.typed(Annotation).new(size_) { nil }
      @f_removed_annotations.key_set.to_array(removed)
      return removed
    end
    
    typesig { [Annotation] }
    # Returns the position of the removed annotation at that point in time
    # when the annotation has been removed.
    # 
    # @param annotation the removed annotation
    # @return the position of the removed annotation or <code>null</code>
    # @since 3.0
    def get_position_of_removed_annotation(annotation)
      return @f_removed_annotations.get(annotation)
    end
    
    typesig { [Annotation] }
    # Adds the given annotation to the set of annotations that are reported as
    # being changed from the model. If this event is considered a world
    # change, it is no longer so after this method has successfully finished.
    # 
    # @param annotation the changed annotation
    # @since 3.0
    def annotation_changed(annotation)
      @f_changed_annotations.add(annotation)
      @f_is_world_change = false
    end
    
    typesig { [] }
    # Returns the changed annotations.
    # 
    # @return the changed annotations
    # @since 3.0
    def get_changed_annotations
      size_ = @f_changed_annotations.size
      changed = Array.typed(Annotation).new(size_) { nil }
      @f_changed_annotations.to_array(changed)
      return changed
    end
    
    typesig { [] }
    # Returns whether this annotation model event is empty or not. If this
    # event represents a world change, this method returns <code>false</code>
    # although the event does not carry any added, removed, or changed
    # annotations.
    # 
    # @return <code>true</code> if this event is empty
    # @since 3.0
    def is_empty
      return !@f_is_world_change && @f_added_annotations.is_empty && @f_removed_annotations.is_empty && @f_changed_annotations.is_empty
    end
    
    typesig { [] }
    # Returns whether this annotation model events contains detailed
    # information about the modifications applied to the event annotation
    # model or whether it represents a world change. I.e. everything in the
    # model might have changed.
    # 
    # @return <code>true</code> if world change, <code>false</code> otherwise
    # @since 3.0
    def is_world_change
      return @f_is_world_change
    end
    
    typesig { [::Java::Boolean] }
    # Marks this event as world change according to the given flag.
    # 
    # @param isWorldChange <code>true</code> if this event is a world change, <code>false</code> otherwise
    # @since 3.0
    def mark_world_change(is_world_change)
      @f_is_world_change = is_world_change
    end
    
    typesig { [] }
    # Returns whether this annotation model event is still valid.
    # 
    # @return <code>true</code> if this event is still valid, <code>false</code> otherwise
    # @since 3.0
    def is_valid
      if (!(@f_modification_stamp).nil? && @f_annotation_model.is_a?(IAnnotationModelExtension))
        extension = @f_annotation_model
        return (@f_modification_stamp).equal?(extension.get_modification_stamp)
      end
      return true
    end
    
    typesig { [] }
    # Seals this event. Any direct modification to the annotation model after the event has been sealed
    # invalidates this event.
    # 
    # @since 3.0
    def mark_sealed
      if (@f_annotation_model.is_a?(IAnnotationModelExtension))
        extension = @f_annotation_model
        @f_modification_stamp = extension.get_modification_stamp
      end
    end
    
    private
    alias_method :initialize__annotation_model_event, :initialize
  end
  
end
