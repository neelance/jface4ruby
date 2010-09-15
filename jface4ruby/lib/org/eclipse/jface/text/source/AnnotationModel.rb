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
  module AnnotationModelImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Source
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :IdentityHashMap
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :Map
      include_const ::Java::Util, :NoSuchElementException
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Jface::Text, :AbstractDocument
      include_const ::Org::Eclipse::Jface::Text, :BadLocationException
      include_const ::Org::Eclipse::Jface::Text, :BadPositionCategoryException
      include_const ::Org::Eclipse::Jface::Text, :DocumentEvent
      include_const ::Org::Eclipse::Jface::Text, :IDocument
      include_const ::Org::Eclipse::Jface::Text, :IDocumentListener
      include_const ::Org::Eclipse::Jface::Text, :ISynchronizable
      include_const ::Org::Eclipse::Jface::Text, :Position
    }
  end
  
  # Standard implementation of {@link IAnnotationModel} and its extension
  # interfaces. This class can directly be used by clients. Subclasses may adapt
  # this annotation model to other existing annotation mechanisms. This class
  # also implements {@link org.eclipse.jface.text.ISynchronizable}. All
  # modifications of the model's internal annotation map are synchronized using
  # the model's lock object.
  class AnnotationModel 
    include_class_members AnnotationModelImports
    include IAnnotationModel
    include IAnnotationModelExtension
    include IAnnotationModelExtension2
    include ISynchronizable
    
    class_module.module_eval {
      # Iterator that returns the annotations for a given region.
      # 
      # @since 3.4
      # @see AnnotationModel.RegionIterator#RegionIterator(Iterator, IAnnotationModel, int, int, boolean, boolean)
      const_set_lazy(:RegionIterator) { Class.new do
        include_class_members AnnotationModel
        include Iterator
        
        attr_accessor :f_parent_iterator
        alias_method :attr_f_parent_iterator, :f_parent_iterator
        undef_method :f_parent_iterator
        alias_method :attr_f_parent_iterator=, :f_parent_iterator=
        undef_method :f_parent_iterator=
        
        attr_accessor :f_can_end_after
        alias_method :attr_f_can_end_after, :f_can_end_after
        undef_method :f_can_end_after
        alias_method :attr_f_can_end_after=, :f_can_end_after=
        undef_method :f_can_end_after=
        
        attr_accessor :f_can_start_before
        alias_method :attr_f_can_start_before, :f_can_start_before
        undef_method :f_can_start_before
        alias_method :attr_f_can_start_before=, :f_can_start_before=
        undef_method :f_can_start_before=
        
        attr_accessor :f_model
        alias_method :attr_f_model, :f_model
        undef_method :f_model
        alias_method :attr_f_model=, :f_model=
        undef_method :f_model=
        
        attr_accessor :f_next
        alias_method :attr_f_next, :f_next
        undef_method :f_next
        alias_method :attr_f_next=, :f_next=
        undef_method :f_next=
        
        attr_accessor :f_region
        alias_method :attr_f_region, :f_region
        undef_method :f_region
        alias_method :attr_f_region=, :f_region=
        undef_method :f_region=
        
        typesig { [class_self::Iterator, class_self::IAnnotationModel, ::Java::Int, ::Java::Int, ::Java::Boolean, ::Java::Boolean] }
        # Iterator that returns all annotations from the parent iterator which
        # have a position in the given model inside the given region.
        # <p>
        # See {@link IAnnotationModelExtension2} for a definition of inside.
        # </p>
        # 
        # @param parentIterator iterator containing all annotations
        # @param model the model to use to retrieve positions from for each
        # annotation
        # @param offset start position of the region
        # @param length length of the region
        # @param canStartBefore include annotations starting before region
        # @param canEndAfter include annotations ending after region
        # @see IAnnotationModelExtension2
        def initialize(parent_iterator, model, offset, length, can_start_before, can_end_after)
          @f_parent_iterator = nil
          @f_can_end_after = false
          @f_can_start_before = false
          @f_model = nil
          @f_next = nil
          @f_region = nil
          @f_parent_iterator = parent_iterator
          @f_model = model
          @f_region = self.class::Position.new(offset, length)
          @f_can_end_after = can_end_after
          @f_can_start_before = can_start_before
          @f_next = find_next
        end
        
        typesig { [] }
        # @see java.util.Iterator#hasNext()
        def has_next
          return !(@f_next).nil?
        end
        
        typesig { [] }
        # @see java.util.Iterator#next()
        def next_
          if (!has_next)
            raise self.class::NoSuchElementException.new
          end
          result = @f_next
          @f_next = find_next
          return result
        end
        
        typesig { [] }
        # @see java.util.Iterator#remove()
        def remove
          raise self.class::UnsupportedOperationException.new
        end
        
        typesig { [] }
        def find_next
          while (@f_parent_iterator.has_next)
            next__ = @f_parent_iterator.next_
            position = @f_model.get_position(next__)
            if (!(position).nil?)
              offset = position.get_offset
              if (is_within_region(offset, position.get_length))
                return next__
              end
            end
          end
          return nil
        end
        
        typesig { [::Java::Int, ::Java::Int] }
        def is_within_region(start, length)
          if (@f_can_start_before && @f_can_end_after)
            return @f_region.overlaps_with(start, length)
          else
            if (@f_can_start_before)
              return @f_region.includes(start + length - 1)
            else
              if (@f_can_end_after)
                return @f_region.includes(start)
              else
                return @f_region.includes(start) && @f_region.includes(start + length - 1)
              end
            end
          end
        end
        
        private
        alias_method :initialize__region_iterator, :initialize
      end }
      
      # An iterator iteration over a Positions and mapping positions to
      # annotations using a provided map if the provided map contains the element.
      # 
      # @since 3.4
      const_set_lazy(:AnnotationsInterator) { Class.new do
        include_class_members AnnotationModel
        include Iterator
        
        attr_accessor :f_next
        alias_method :attr_f_next, :f_next
        undef_method :f_next
        alias_method :attr_f_next=, :f_next=
        undef_method :f_next=
        
        attr_accessor :f_positions
        alias_method :attr_f_positions, :f_positions
        undef_method :f_positions
        alias_method :attr_f_positions=, :f_positions=
        undef_method :f_positions=
        
        attr_accessor :f_index
        alias_method :attr_f_index, :f_index
        undef_method :f_index
        alias_method :attr_f_index=, :f_index=
        undef_method :f_index=
        
        attr_accessor :f_map
        alias_method :attr_f_map, :f_map
        undef_method :f_map
        alias_method :attr_f_map=, :f_map=
        undef_method :f_map=
        
        typesig { [Array.typed(class_self::Position), class_self::Map] }
        # @param positions positions to iterate over
        # @param map a map to map positions to annotations
        def initialize(positions, map)
          @f_next = nil
          @f_positions = nil
          @f_index = 0
          @f_map = nil
          @f_positions = positions
          @f_index = 0
          @f_map = map
          @f_next = find_next
        end
        
        typesig { [] }
        # (non-Javadoc)
        # @see java.util.Iterator#hasNext()
        def has_next
          return !(@f_next).nil?
        end
        
        typesig { [] }
        # (non-Javadoc)
        # @see java.util.Iterator#next()
        def next_
          result = @f_next
          @f_next = find_next
          return result
        end
        
        typesig { [] }
        # (non-Javadoc)
        # @see java.util.Iterator#remove()
        def remove
          raise self.class::UnsupportedOperationException.new
        end
        
        typesig { [] }
        def find_next
          while (@f_index < @f_positions.attr_length)
            position = @f_positions[@f_index]
            @f_index += 1
            if (@f_map.contains_key(position))
              return @f_map.get(position)
            end
          end
          return nil
        end
        
        private
        alias_method :initialize__annotations_interator, :initialize
      end }
      
      # A single iterator builds its behavior based on a sequence of iterators.
      # 
      # @since 3.1
      const_set_lazy(:MetaIterator) { Class.new do
        include_class_members AnnotationModel
        include Iterator
        
        # The iterator over a list of iterators.
        attr_accessor :f_super_iterator
        alias_method :attr_f_super_iterator, :f_super_iterator
        undef_method :f_super_iterator
        alias_method :attr_f_super_iterator=, :f_super_iterator=
        undef_method :f_super_iterator=
        
        # The current iterator.
        attr_accessor :f_current
        alias_method :attr_f_current, :f_current
        undef_method :f_current
        alias_method :attr_f_current=, :f_current=
        undef_method :f_current=
        
        # The current element.
        attr_accessor :f_current_element
        alias_method :attr_f_current_element, :f_current_element
        undef_method :f_current_element
        alias_method :attr_f_current_element=, :f_current_element=
        undef_method :f_current_element=
        
        typesig { [class_self::Iterator] }
        def initialize(iterator)
          @f_super_iterator = nil
          @f_current = nil
          @f_current_element = nil
          @f_super_iterator = iterator
          @f_current = @f_super_iterator.next_ # there is at least one.
        end
        
        typesig { [] }
        def remove
          raise self.class::UnsupportedOperationException.new
        end
        
        typesig { [] }
        def has_next
          if (!(@f_current_element).nil?)
            return true
          end
          if (@f_current.has_next)
            @f_current_element = @f_current.next_
            return true
          else
            if (@f_super_iterator.has_next)
              @f_current = @f_super_iterator.next_
              return has_next
            else
              return false
            end
          end
        end
        
        typesig { [] }
        def next_
          if (!has_next)
            raise self.class::NoSuchElementException.new
          end
          element = @f_current_element
          @f_current_element = nil
          return element
        end
        
        private
        alias_method :initialize__meta_iterator, :initialize
      end }
      
      # Internal annotation model listener for forwarding annotation model changes from the attached models to the
      # registered listeners of the outer most annotation model.
      # 
      # @since 3.0
      const_set_lazy(:InternalModelListener) { Class.new do
        local_class_in AnnotationModel
        include_class_members AnnotationModel
        include IAnnotationModelListener
        include IAnnotationModelListenerExtension
        
        typesig { [class_self::IAnnotationModel] }
        # @see org.eclipse.jface.text.source.IAnnotationModelListener#modelChanged(org.eclipse.jface.text.source.IAnnotationModel)
        def model_changed(model)
          @local_class_parent.fire_model_changed(self.class::AnnotationModelEvent.new(model, true))
        end
        
        typesig { [class_self::AnnotationModelEvent] }
        # @see org.eclipse.jface.text.source.IAnnotationModelListenerExtension#modelChanged(org.eclipse.jface.text.source.AnnotationModelEvent)
        def model_changed(event)
          @local_class_parent.fire_model_changed(event)
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__internal_model_listener, :initialize
      end }
    }
    
    # The list of managed annotations
    # @deprecated since 3.0 use <code>getAnnotationMap</code> instead
    attr_accessor :f_annotations
    alias_method :attr_f_annotations, :f_annotations
    undef_method :f_annotations
    alias_method :attr_f_annotations=, :f_annotations=
    undef_method :f_annotations=
    
    # The map which maps {@link Position} to {@link Annotation}.
    # @since 3.4
    attr_accessor :f_positions
    alias_method :attr_f_positions, :f_positions
    undef_method :f_positions
    alias_method :attr_f_positions=, :f_positions=
    undef_method :f_positions=
    
    # The list of annotation model listeners
    attr_accessor :f_annotation_model_listeners
    alias_method :attr_f_annotation_model_listeners, :f_annotation_model_listeners
    undef_method :f_annotation_model_listeners
    alias_method :attr_f_annotation_model_listeners=, :f_annotation_model_listeners=
    undef_method :f_annotation_model_listeners=
    
    # The document connected with this model
    attr_accessor :f_document
    alias_method :attr_f_document, :f_document
    undef_method :f_document
    alias_method :attr_f_document=, :f_document=
    undef_method :f_document=
    
    # The number of open connections to the same document
    attr_accessor :f_open_connections
    alias_method :attr_f_open_connections, :f_open_connections
    undef_method :f_open_connections
    alias_method :attr_f_open_connections=, :f_open_connections=
    undef_method :f_open_connections=
    
    # The document listener for tracking whether document positions might have been changed.
    attr_accessor :f_document_listener
    alias_method :attr_f_document_listener, :f_document_listener
    undef_method :f_document_listener
    alias_method :attr_f_document_listener=, :f_document_listener=
    undef_method :f_document_listener=
    
    # The flag indicating whether the document positions might have been changed.
    attr_accessor :f_document_changed
    alias_method :attr_f_document_changed, :f_document_changed
    undef_method :f_document_changed
    alias_method :attr_f_document_changed=, :f_document_changed=
    undef_method :f_document_changed=
    
    # The model's attachment.
    # @since 3.0
    attr_accessor :f_attachments
    alias_method :attr_f_attachments, :f_attachments
    undef_method :f_attachments
    alias_method :attr_f_attachments=, :f_attachments=
    undef_method :f_attachments=
    
    # The annotation model listener on attached sub-models.
    # @since 3.0
    attr_accessor :f_model_listener
    alias_method :attr_f_model_listener, :f_model_listener
    undef_method :f_model_listener
    alias_method :attr_f_model_listener=, :f_model_listener=
    undef_method :f_model_listener=
    
    # The current annotation model event.
    # @since 3.0
    attr_accessor :f_model_event
    alias_method :attr_f_model_event, :f_model_event
    undef_method :f_model_event
    alias_method :attr_f_model_event=, :f_model_event=
    undef_method :f_model_event=
    
    # The modification stamp.
    # @since 3.0
    attr_accessor :f_modification_stamp
    alias_method :attr_f_modification_stamp, :f_modification_stamp
    undef_method :f_modification_stamp
    alias_method :attr_f_modification_stamp=, :f_modification_stamp=
    undef_method :f_modification_stamp=
    
    typesig { [] }
    # Creates a new annotation model. The annotation is empty, i.e. does not
    # manage any annotations and is not connected to any document.
    def initialize
      @f_annotations = nil
      @f_positions = nil
      @f_annotation_model_listeners = nil
      @f_document = nil
      @f_open_connections = 0
      @f_document_listener = nil
      @f_document_changed = true
      @f_attachments = HashMap.new
      @f_model_listener = InternalModelListener.new_local(self)
      @f_model_event = nil
      @f_modification_stamp = Object.new
      @f_annotations = AnnotationMap.new(10)
      @f_positions = IdentityHashMap.new(10)
      @f_annotation_model_listeners = ArrayList.new(2)
      @f_document_listener = Class.new(IDocumentListener.class == Class ? IDocumentListener : Object) do
        local_class_in AnnotationModel
        include_class_members AnnotationModel
        include IDocumentListener if IDocumentListener.class == Module
        
        typesig { [DocumentEvent] }
        define_method :document_about_to_be_changed do |event|
        end
        
        typesig { [DocumentEvent] }
        define_method :document_changed do |event|
          self.attr_f_document_changed = true
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
    end
    
    typesig { [] }
    # Returns the annotation map internally used by this annotation model.
    # 
    # @return the annotation map internally used by this annotation model
    # @since 3.0
    def get_annotation_map
      return @f_annotations
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.ISynchronizable#getLockObject()
    # @since 3.0
    def get_lock_object
      return get_annotation_map.get_lock_object
    end
    
    typesig { [Object] }
    # @see org.eclipse.jface.text.ISynchronizable#setLockObject(java.lang.Object)
    # @since 3.0
    def set_lock_object(lock_object)
      get_annotation_map.set_lock_object(lock_object)
    end
    
    typesig { [] }
    # Returns the current annotation model event. This is the event that will be sent out
    # when calling <code>fireModelChanged</code>.
    # 
    # @return the current annotation model event
    # @since 3.0
    def get_annotation_model_event
      synchronized((get_lock_object)) do
        if ((@f_model_event).nil?)
          @f_model_event = create_annotation_model_event
          @f_model_event.mark_world_change(false)
          @f_modification_stamp = @f_model_event
        end
        return @f_model_event
      end
    end
    
    typesig { [Annotation, Position] }
    # @see org.eclipse.jface.text.source.IAnnotationModel#addAnnotation(org.eclipse.jface.text.source.Annotation, org.eclipse.jface.text.Position)
    def add_annotation(annotation, position)
      begin
        add_annotation(annotation, position, true)
      rescue BadLocationException => e
        # ignore invalid position
      end
    end
    
    typesig { [Array.typed(Annotation), Map] }
    # @see org.eclipse.jface.text.source.IAnnotationModelExtension#replaceAnnotations(org.eclipse.jface.text.source.Annotation[], java.util.Map)
    # @since 3.0
    def replace_annotations(annotations_to_remove, annotations_to_add)
      begin
        replace_annotations(annotations_to_remove, annotations_to_add, true)
      rescue BadLocationException => x
      end
    end
    
    typesig { [Array.typed(Annotation), Map, ::Java::Boolean] }
    # Replaces the given annotations in this model and if advised fires a
    # model change event.
    # 
    # @param annotationsToRemove the annotations to be removed
    # @param annotationsToAdd the annotations to be added
    # @param fireModelChanged <code>true</code> if a model change event
    # should be fired, <code>false</code> otherwise
    # @throws BadLocationException in case an annotation should be added at an
    # invalid position
    # @since 3.0
    def replace_annotations(annotations_to_remove, annotations_to_add, fire_model_changed)
      if (!(annotations_to_remove).nil?)
        i = 0
        length = annotations_to_remove.attr_length
        while i < length
          remove_annotation(annotations_to_remove[i], false)
          i += 1
        end
      end
      if (!(annotations_to_add).nil?)
        iter = annotations_to_add.entry_set.iterator
        while (iter.has_next)
          map_entry = iter.next_
          annotation = map_entry.get_key
          position = map_entry.get_value
          add_annotation(annotation, position, false)
        end
      end
      if (fire_model_changed)
        fire_model_changed
      end
    end
    
    typesig { [Annotation, Position, ::Java::Boolean] }
    # Adds the given annotation to this model. Associates the
    # annotation with the given position. If requested, all annotation
    # model listeners are informed about this model change. If the annotation
    # is already managed by this model nothing happens.
    # 
    # @param annotation the annotation to add
    # @param position the associate position
    # @param fireModelChanged indicates whether to notify all model listeners
    # @throws BadLocationException if the position is not a valid document position
    def add_annotation(annotation, position, fire_model_changed_)
      if (!@f_annotations.contains_key(annotation))
        add_position(@f_document, position)
        @f_annotations.put(annotation, position)
        @f_positions.put(position, annotation)
        synchronized((get_lock_object)) do
          get_annotation_model_event.annotation_added(annotation)
        end
        if (fire_model_changed_)
          fire_model_changed
        end
      end
    end
    
    typesig { [IAnnotationModelListener] }
    # @see org.eclipse.jface.text.source.IAnnotationModel#addAnnotationModelListener(org.eclipse.jface.text.source.IAnnotationModelListener)
    def add_annotation_model_listener(listener)
      if (!@f_annotation_model_listeners.contains(listener))
        @f_annotation_model_listeners.add(listener)
        if (listener.is_a?(IAnnotationModelListenerExtension))
          extension = listener
          event = create_annotation_model_event
          event.mark_sealed
          extension.model_changed(event)
        else
          listener.model_changed(self)
        end
      end
    end
    
    typesig { [IDocument, Position] }
    # Adds the given position to the default position category of the
    # given document.
    # 
    # @param document the document to which to add the position
    # @param position the position to add
    # @throws BadLocationException if the position is not a valid document position
    def add_position(document, position)
      if (!(document).nil?)
        document.add_position(position)
      end
    end
    
    typesig { [IDocument, Position] }
    # Removes the given position from the default position category of the
    # given document.
    # 
    # @param document the document to which to add the position
    # @param position the position to add
    # 
    # @since 3.0
    def remove_position(document, position)
      if (!(document).nil?)
        document.remove_position(position)
      end
    end
    
    typesig { [IDocument] }
    # @see org.eclipse.jface.text.source.IAnnotationModel#connect(org.eclipse.jface.text.IDocument)
    def connect(document)
      Assert.is_true((@f_document).nil? || (@f_document).equal?(document))
      if ((@f_document).nil?)
        @f_document = document
        e = get_annotation_map.values_iterator
        while (e.has_next)
          begin
            add_position(document, e.next_)
          rescue BadLocationException => x
            # ignore invalid position
          end
        end
      end
      (@f_open_connections += 1)
      if ((@f_open_connections).equal?(1))
        document.add_document_listener(@f_document_listener)
        connected
      end
      it = @f_attachments.key_set.iterator
      while it.has_next
        model = @f_attachments.get(it.next_)
        model.connect(document)
      end
    end
    
    typesig { [] }
    # Hook method. Is called as soon as this model becomes connected to a document.
    # Subclasses may re-implement.
    def connected
    end
    
    typesig { [] }
    # Hook method. Is called as soon as this model becomes disconnected from its document.
    # Subclasses may re-implement.
    def disconnected
    end
    
    typesig { [IDocument] }
    # @see org.eclipse.jface.text.source.IAnnotationModel#disconnect(org.eclipse.jface.text.IDocument)
    def disconnect(document)
      Assert.is_true((@f_document).equal?(document))
      it = @f_attachments.key_set.iterator
      while it.has_next
        model = @f_attachments.get(it.next_)
        model.disconnect(document)
      end
      (@f_open_connections -= 1)
      if ((@f_open_connections).equal?(0))
        disconnected
        document.remove_document_listener(@f_document_listener)
        e = get_annotation_map.values_iterator
        while (e.has_next)
          p = e.next_
          remove_position(document, p)
        end
        @f_document = nil
      end
    end
    
    typesig { [] }
    # Informs all annotation model listeners that this model has been changed.
    def fire_model_changed
      model_event = nil
      synchronized((get_lock_object)) do
        if (!(@f_model_event).nil?)
          model_event = @f_model_event
          @f_model_event = nil
        end
      end
      if (!(model_event).nil?)
        fire_model_changed(model_event)
      end
    end
    
    typesig { [] }
    # Creates and returns a new annotation model event. Subclasses may override.
    # 
    # @return a new and empty annotation model event
    # @since 3.0
    def create_annotation_model_event
      return AnnotationModelEvent.new(self)
    end
    
    typesig { [AnnotationModelEvent] }
    # Informs all annotation model listeners that this model has been changed
    # as described in the annotation model event. The event is sent out
    # to all listeners implementing <code>IAnnotationModelListenerExtension</code>.
    # All other listeners are notified by just calling <code>modelChanged(IAnnotationModel)</code>.
    # 
    # @param event the event to be sent out to the listeners
    # @since 2.0
    def fire_model_changed(event)
      event.mark_sealed
      if (event.is_empty)
        return
      end
      v = ArrayList.new(@f_annotation_model_listeners)
      e = v.iterator
      while (e.has_next)
        l = e.next_
        if (l.is_a?(IAnnotationModelListenerExtension))
          (l).model_changed(event)
        else
          if (!(l).nil?)
            l.model_changed(self)
          end
        end
      end
    end
    
    typesig { [JavaList, ::Java::Boolean, ::Java::Boolean] }
    # Removes the given annotations from this model. If requested all
    # annotation model listeners will be informed about this change.
    # <code>modelInitiated</code> indicates whether the deletion has
    # been initiated by this model or by one of its clients.
    # 
    # @param annotations the annotations to be removed
    # @param fireModelChanged indicates whether to notify all model listeners
    # @param modelInitiated indicates whether this changes has been initiated by this model
    def remove_annotations(annotations, fire_model_changed_, model_initiated)
      if (annotations.size > 0)
        e = annotations.iterator
        while (e.has_next)
          remove_annotation(e.next_, false)
        end
        if (fire_model_changed_)
          fire_model_changed
        end
      end
    end
    
    typesig { [::Java::Boolean] }
    # Removes all annotations from the model whose associated positions have been
    # deleted. If requested inform all model listeners about the change.
    # 
    # @param fireModelChanged indicates whether to notify all model listeners
    def cleanup(fire_model_changed_)
      cleanup(fire_model_changed_, true)
    end
    
    typesig { [::Java::Boolean, ::Java::Boolean] }
    # Removes all annotations from the model whose associated positions have been
    # deleted. If requested inform all model listeners about the change. If requested
    # a new thread is created for the notification of the model listeners.
    # 
    # @param fireModelChanged indicates whether to notify all model listeners
    # @param forkNotification <code>true</code> iff notification should be done in a new thread
    # @since 3.0
    def cleanup(fire_model_changed_, fork_notification)
      if (@f_document_changed)
        @f_document_changed = false
        deleted = ArrayList.new
        e = get_annotation_map.key_set_iterator
        while (e.has_next)
          a = e.next_
          p = @f_annotations.get(a)
          if ((p).nil? || p.is_deleted)
            deleted.add(a)
          end
        end
        if (fire_model_changed_ && fork_notification)
          remove_annotations(deleted, false, false)
          synchronized((get_lock_object)) do
            if (!(@f_model_event).nil?)
              Class.new(JavaThread.class == Class ? JavaThread : Object) do
                local_class_in AnnotationModel
                include_class_members AnnotationModel
                include JavaThread if JavaThread.class == Module
                
                typesig { [] }
                define_method :run do
                  fire_model_changed
                end
                
                typesig { [Vararg.new(Object)] }
                define_method :initialize do |*args|
                  super(*args)
                end
                
                private
                alias_method :initialize_anonymous, :initialize
              end.new_local(self).start
            end
          end
        else
          remove_annotations(deleted, fire_model_changed_, false)
        end
      end
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.source.IAnnotationModel#getAnnotationIterator()
    def get_annotation_iterator
      return get_annotation_iterator(true, true)
    end
    
    typesig { [::Java::Int, ::Java::Int, ::Java::Boolean, ::Java::Boolean] }
    # {@inheritDoc}
    # 
    # @since 3.4
    def get_annotation_iterator(offset, length, can_start_before, can_end_after)
      region_iterator = get_region_annotation_iterator(offset, length, can_start_before, can_end_after)
      if (@f_attachments.is_empty)
        return region_iterator
      end
      iterators = ArrayList.new(@f_attachments.size + 1)
      iterators.add(region_iterator)
      it = @f_attachments.key_set.iterator
      while (it.has_next)
        attachment = @f_attachments.get(it.next_)
        if (attachment.is_a?(IAnnotationModelExtension2))
          iterators.add((attachment).get_annotation_iterator(offset, length, can_start_before, can_end_after))
        else
          iterators.add(RegionIterator.new(attachment.get_annotation_iterator, attachment, offset, length, can_start_before, can_end_after))
        end
      end
      return MetaIterator.new(iterators.iterator)
    end
    
    typesig { [::Java::Int, ::Java::Int, ::Java::Boolean, ::Java::Boolean] }
    # Returns an iterator as specified in {@link IAnnotationModelExtension2#getAnnotationIterator(int, int, boolean, boolean)}
    # 
    # @param offset region start
    # @param length region length
    # @param canStartBefore position can start before region
    # @param canEndAfter position can end after region
    # @return an iterator to iterate over annotations in region
    # @see IAnnotationModelExtension2#getAnnotationIterator(int, int, boolean, boolean)
    # @since 3.4
    def get_region_annotation_iterator(offset, length, can_start_before, can_end_after)
      if (!(@f_document.is_a?(AbstractDocument)))
        return RegionIterator.new(get_annotation_iterator(true), self, offset, length, can_start_before, can_end_after)
      end
      document = @f_document
      cleanup(true)
      begin
        positions = document.get_positions(IDocument::DEFAULT_CATEGORY, offset, length, can_start_before, can_end_after)
        return AnnotationsInterator.new(positions, @f_positions)
      rescue BadPositionCategoryException => e
        # can not happen
        Assert.is_true(false)
        return nil
      end
    end
    
    typesig { [::Java::Boolean, ::Java::Boolean] }
    # Returns all annotations managed by this model. <code>cleanup</code>
    # indicates whether all annotations whose associated positions are
    # deleted should previously be removed from the model. <code>recurse</code> indicates
    # whether annotations of attached sub-models should also be returned.
    # 
    # @param cleanup indicates whether annotations with deleted associated positions are removed
    # @param recurse whether to return annotations managed by sub-models.
    # @return all annotations managed by this model
    # @since 3.0
    def get_annotation_iterator(cleanup_, recurse)
      iter = get_annotation_iterator(cleanup_)
      if (!recurse || @f_attachments.is_empty)
        return iter
      end
      iterators = ArrayList.new(@f_attachments.size + 1)
      iterators.add(iter)
      it = @f_attachments.key_set.iterator
      while (it.has_next)
        iterators.add((@f_attachments.get(it.next_)).get_annotation_iterator)
      end
      return MetaIterator.new(iterators.iterator)
    end
    
    typesig { [::Java::Boolean] }
    # Returns all annotations managed by this model. <code>cleanup</code>
    # indicates whether all annotations whose associated positions are
    # deleted should previously be removed from the model.
    # 
    # @param cleanup indicates whether annotations with deleted associated positions are removed
    # @return all annotations managed by this model
    def get_annotation_iterator(cleanup_)
      if (cleanup_)
        cleanup(true)
      end
      return get_annotation_map.key_set_iterator
    end
    
    typesig { [Annotation] }
    # @see org.eclipse.jface.text.source.IAnnotationModel#getPosition(org.eclipse.jface.text.source.Annotation)
    def get_position(annotation)
      position = @f_annotations.get(annotation)
      if (!(position).nil?)
        return position
      end
      it = @f_attachments.values.iterator
      while ((position).nil? && it.has_next)
        position = (it.next_).get_position(annotation)
      end
      return position
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.source.IAnnotationModelExtension#removeAllAnnotations()
    # @since 3.0
    def remove_all_annotations
      remove_all_annotations(true)
    end
    
    typesig { [::Java::Boolean] }
    # Removes all annotations from the annotation model. If requested
    # inform all model change listeners about this change.
    # 
    # @param fireModelChanged indicates whether to notify all model listeners
    def remove_all_annotations(fire_model_changed_)
      if (!(@f_document).nil?)
        e = get_annotation_map.key_set_iterator
        while (e.has_next)
          a = e.next_
          p = @f_annotations.get(a)
          remove_position(@f_document, p)
          # p.delete();
          synchronized((get_lock_object)) do
            get_annotation_model_event.annotation_removed(a, p)
          end
        end
      end
      @f_annotations.clear
      @f_positions.clear
      if (fire_model_changed_)
        fire_model_changed
      end
    end
    
    typesig { [Annotation] }
    # @see org.eclipse.jface.text.source.IAnnotationModel#removeAnnotation(org.eclipse.jface.text.source.Annotation)
    def remove_annotation(annotation)
      remove_annotation(annotation, true)
    end
    
    typesig { [Annotation, ::Java::Boolean] }
    # Removes the given annotation from the annotation model.
    # If requested inform all model change listeners about this change.
    # 
    # @param annotation the annotation to be removed
    # @param fireModelChanged indicates whether to notify all model listeners
    def remove_annotation(annotation, fire_model_changed_)
      if (@f_annotations.contains_key(annotation))
        p = nil
        p = @f_annotations.get(annotation)
        if (!(@f_document).nil?)
          remove_position(@f_document, p)
          # p.delete();
        end
        @f_annotations.remove(annotation)
        @f_positions.remove(p)
        synchronized((get_lock_object)) do
          get_annotation_model_event.annotation_removed(annotation, p)
        end
        if (fire_model_changed_)
          fire_model_changed
        end
      end
    end
    
    typesig { [Annotation, Position] }
    # @see org.eclipse.jface.text.source.IAnnotationModelExtension#modifyAnnotationPosition(org.eclipse.jface.text.source.Annotation, org.eclipse.jface.text.Position)
    # @since 3.0
    def modify_annotation_position(annotation, position)
      modify_annotation_position(annotation, position, true)
    end
    
    typesig { [Annotation, Position, ::Java::Boolean] }
    # Modifies the associated position of the given annotation to the given
    # position. If the annotation is not yet managed by this annotation model,
    # the annotation is added. When the position is <code>null</code>, the
    # annotation is removed from the model.
    # <p>
    # If requested, all annotation model change listeners will be informed
    # about the change.
    # 
    # @param annotation the annotation whose associated position should be
    # modified
    # @param position the position to whose values the associated position
    # should be changed
    # @param fireModelChanged indicates whether to notify all model listeners
    # @since 3.0
    def modify_annotation_position(annotation, position, fire_model_changed_)
      if ((position).nil?)
        remove_annotation(annotation, fire_model_changed_)
      else
        p = @f_annotations.get(annotation)
        if (!(p).nil?)
          if (!(position.get_offset).equal?(p.get_offset) || !(position.get_length).equal?(p.get_length))
            @f_document.remove_position(p)
            p.set_offset(position.get_offset)
            p.set_length(position.get_length)
            begin
              @f_document.add_position(p)
            rescue BadLocationException => e
              # ignore invalid position
            end
          end
          synchronized((get_lock_object)) do
            get_annotation_model_event.annotation_changed(annotation)
          end
          if (fire_model_changed_)
            fire_model_changed
          end
        else
          begin
            add_annotation(annotation, position, fire_model_changed_)
          rescue BadLocationException => x
            # ignore invalid position
          end
        end
      end
    end
    
    typesig { [Annotation, ::Java::Boolean] }
    # Modifies the given annotation if the annotation is managed by this
    # annotation model.
    # <p>
    # If requested, all annotation model change listeners will be informed
    # about the change.
    # 
    # @param annotation the annotation to be modified
    # @param fireModelChanged indicates whether to notify all model listeners
    # @since 3.0
    def modify_annotation(annotation, fire_model_changed_)
      if (@f_annotations.contains_key(annotation))
        synchronized((get_lock_object)) do
          get_annotation_model_event.annotation_changed(annotation)
        end
        if (fire_model_changed_)
          fire_model_changed
        end
      end
    end
    
    typesig { [IAnnotationModelListener] }
    # @see IAnnotationModel#removeAnnotationModelListener(IAnnotationModelListener)
    def remove_annotation_model_listener(listener)
      @f_annotation_model_listeners.remove(listener)
    end
    
    typesig { [Object, IAnnotationModel] }
    # @see org.eclipse.jface.text.source.IAnnotationModelExtension#attach(java.lang.Object, java.lang.Object)
    # @since 3.0
    def add_annotation_model(key, attachment)
      Assert.is_not_null(attachment)
      if (!@f_attachments.contains_value(attachment))
        @f_attachments.put(key, attachment)
        i = 0
        while i < @f_open_connections
          attachment.connect(@f_document)
          i += 1
        end
        attachment.add_annotation_model_listener(@f_model_listener)
      end
    end
    
    typesig { [Object] }
    # @see org.eclipse.jface.text.source.IAnnotationModelExtension#get(java.lang.Object)
    # @since 3.0
    def get_annotation_model(key)
      return @f_attachments.get(key)
    end
    
    typesig { [Object] }
    # @see org.eclipse.jface.text.source.IAnnotationModelExtension#detach(java.lang.Object)
    # @since 3.0
    def remove_annotation_model(key)
      ret = @f_attachments.remove(key)
      if (!(ret).nil?)
        i = 0
        while i < @f_open_connections
          ret.disconnect(@f_document)
          i += 1
        end
        ret.remove_annotation_model_listener(@f_model_listener)
      end
      return ret
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.source.IAnnotationModelExtension#getModificationStamp()
    # @since 3.0
    def get_modification_stamp
      return @f_modification_stamp
    end
    
    private
    alias_method :initialize__annotation_model, :initialize
  end
  
end
