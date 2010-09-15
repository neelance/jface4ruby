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
  module ProjectionSummaryImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Source::Projection
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :Map
      include_const ::Org::Eclipse::Core::Runtime, :IProgressMonitor
      include_const ::Org::Eclipse::Core::Runtime, :NullProgressMonitor
      include_const ::Org::Eclipse::Jface::Text, :IDocument
      include_const ::Org::Eclipse::Jface::Text, :IRegion
      include_const ::Org::Eclipse::Jface::Text, :ISynchronizable
      include_const ::Org::Eclipse::Jface::Text, :Position
      include_const ::Org::Eclipse::Jface::Text::Source, :Annotation
      include_const ::Org::Eclipse::Jface::Text::Source, :IAnnotationAccess
      include_const ::Org::Eclipse::Jface::Text::Source, :IAnnotationAccessExtension
      include_const ::Org::Eclipse::Jface::Text::Source, :IAnnotationModel
      include_const ::Org::Eclipse::Jface::Text::Source, :IAnnotationModelExtension
    }
  end
  
  # Strategy for managing annotation summaries for collapsed ranges.
  # 
  # @since 3.0
  class ProjectionSummary 
    include_class_members ProjectionSummaryImports
    
    class_module.module_eval {
      const_set_lazy(:Summarizer) { Class.new(JavaThread) do
        local_class_in ProjectionSummary
        include_class_members ProjectionSummary
        
        attr_accessor :f_reset
        alias_method :attr_f_reset, :f_reset
        undef_method :f_reset
        alias_method :attr_f_reset=, :f_reset=
        undef_method :f_reset=
        
        typesig { [] }
        # Creates a new thread.
        def initialize
          @f_reset = false
          super()
          @f_reset = true
          self.attr_f_progress_monitor = self.class::NullProgressMonitor.new # might be given by client in the future
          set_daemon(true)
          start
        end
        
        typesig { [] }
        # Resets the thread.
        def reset
          synchronized((self.attr_f_lock)) do
            @f_reset = true
            self.attr_f_progress_monitor.set_canceled(true)
          end
        end
        
        typesig { [] }
        # @see java.lang.Thread#run()
        def run
          while (true)
            synchronized((self.attr_f_lock)) do
              if (!@f_reset)
                break
              end
              @f_reset = false
              self.attr_f_progress_monitor.set_canceled(false)
            end
            internal_update_summaries(self.attr_f_progress_monitor)
          end
          synchronized((self.attr_f_lock)) do
            self.attr_f_summarizer = nil
          end
        end
        
        private
        alias_method :initialize__summarizer, :initialize
      end }
    }
    
    attr_accessor :f_projection_viewer
    alias_method :attr_f_projection_viewer, :f_projection_viewer
    undef_method :f_projection_viewer
    alias_method :attr_f_projection_viewer=, :f_projection_viewer=
    undef_method :f_projection_viewer=
    
    attr_accessor :f_annotation_model
    alias_method :attr_f_annotation_model, :f_annotation_model
    undef_method :f_annotation_model
    alias_method :attr_f_annotation_model=, :f_annotation_model=
    undef_method :f_annotation_model=
    
    attr_accessor :f_annotation_access
    alias_method :attr_f_annotation_access, :f_annotation_access
    undef_method :f_annotation_access
    alias_method :attr_f_annotation_access=, :f_annotation_access=
    undef_method :f_annotation_access=
    
    attr_accessor :f_configured_annotation_types
    alias_method :attr_f_configured_annotation_types, :f_configured_annotation_types
    undef_method :f_configured_annotation_types
    alias_method :attr_f_configured_annotation_types=, :f_configured_annotation_types=
    undef_method :f_configured_annotation_types=
    
    attr_accessor :f_lock
    alias_method :attr_f_lock, :f_lock
    undef_method :f_lock
    alias_method :attr_f_lock=, :f_lock=
    undef_method :f_lock=
    
    attr_accessor :f_progress_monitor
    alias_method :attr_f_progress_monitor, :f_progress_monitor
    undef_method :f_progress_monitor
    alias_method :attr_f_progress_monitor=, :f_progress_monitor=
    undef_method :f_progress_monitor=
    
    attr_accessor :f_summarizer
    alias_method :attr_f_summarizer, :f_summarizer
    undef_method :f_summarizer
    alias_method :attr_f_summarizer=, :f_summarizer=
    undef_method :f_summarizer=
    
    typesig { [ProjectionViewer, IAnnotationAccess] }
    # Creates a new projection summary.
    # 
    # @param projectionViewer the projection viewer
    # @param annotationAccess the annotation access
    def initialize(projection_viewer, annotation_access)
      @f_projection_viewer = nil
      @f_annotation_model = nil
      @f_annotation_access = nil
      @f_configured_annotation_types = nil
      @f_lock = Object.new
      @f_progress_monitor = nil
      @f_summarizer = nil
      @f_projection_viewer = projection_viewer
      @f_annotation_access = annotation_access
    end
    
    typesig { [String] }
    # Adds the given annotation type. For now on, annotations of that type are
    # also reflected in their enclosing collapsed regions.
    # 
    # @param annotationType the annotation type to add
    def add_annotation_type(annotation_type)
      synchronized((@f_lock)) do
        if ((@f_configured_annotation_types).nil?)
          @f_configured_annotation_types = ArrayList.new
          @f_configured_annotation_types.add(annotation_type)
        else
          if (!@f_configured_annotation_types.contains(annotation_type))
            @f_configured_annotation_types.add(annotation_type)
          end
        end
      end
    end
    
    typesig { [String] }
    # Removes the given annotation. Annotation of that type are no
    # longer reflected in their enclosing collapsed region.
    # 
    # @param annotationType the annotation type to remove
    def remove_annotation_type(annotation_type)
      synchronized((@f_lock)) do
        if (!(@f_configured_annotation_types).nil?)
          @f_configured_annotation_types.remove(annotation_type)
          if ((@f_configured_annotation_types.size).equal?(0))
            @f_configured_annotation_types = nil
          end
        end
      end
    end
    
    typesig { [] }
    # Forces an updated of the annotation summary.
    def update_summaries
      synchronized((@f_lock)) do
        if (!(@f_configured_annotation_types).nil?)
          if ((@f_summarizer).nil?)
            @f_summarizer = Summarizer.new_local(self)
          end
          @f_summarizer.reset
        end
      end
    end
    
    typesig { [IProgressMonitor] }
    def internal_update_summaries(monitor)
      previous_lock_object = nil
      @f_annotation_model = @f_projection_viewer.get_visual_annotation_model
      if ((@f_annotation_model).nil?)
        return
      end
      begin
        document = @f_projection_viewer.get_document
        if (document.is_a?(ISynchronizable) && @f_annotation_model.is_a?(ISynchronizable))
          sync = @f_annotation_model
          previous_lock_object = sync.get_lock_object
          sync.set_lock_object((document).get_lock_object)
        end
        remove_summaries(monitor)
        if (is_canceled(monitor))
          return
        end
        create_summaries(monitor)
      ensure
        if (@f_annotation_model.is_a?(ISynchronizable))
          sync = @f_annotation_model
          sync.set_lock_object(previous_lock_object)
        end
        @f_annotation_model = nil
      end
    end
    
    typesig { [IProgressMonitor] }
    def is_canceled(monitor)
      return !(monitor).nil? && monitor.is_canceled
    end
    
    typesig { [IProgressMonitor] }
    def remove_summaries(monitor)
      extension = nil
      bags = nil
      if (@f_annotation_model.is_a?(IAnnotationModelExtension))
        extension = @f_annotation_model
        bags = ArrayList.new
      end
      e = @f_annotation_model.get_annotation_iterator
      while (e.has_next)
        annotation = e.next_
        if (annotation.is_a?(AnnotationBag))
          if ((bags).nil?)
            @f_annotation_model.remove_annotation(annotation)
          else
            bags.add(annotation)
          end
        end
        if (is_canceled(monitor))
          return
        end
      end
      if (!(bags).nil? && bags.size > 0)
        deletions = Array.typed(Annotation).new(bags.size) { nil }
        bags.to_array(deletions)
        if (!is_canceled(monitor))
          extension.replace_annotations(deletions, nil)
        end
      end
    end
    
    typesig { [IProgressMonitor] }
    def create_summaries(monitor)
      model = @f_projection_viewer.get_projection_annotation_model
      if ((model).nil?)
        return
      end
      additions = HashMap.new
      e = model.get_annotation_iterator
      while (e.has_next)
        projection = e.next_
        if (projection.is_collapsed)
          position = model.get_position(projection)
          if (!(position).nil?)
            summary_regions = @f_projection_viewer.compute_collapsed_regions(position)
            if (!(summary_regions).nil?)
              summary_anchor = @f_projection_viewer.compute_collapsed_region_anchor(position)
              if (!(summary_anchor).nil?)
                create_summary(additions, summary_regions, summary_anchor)
              end
            end
          end
        end
        if (is_canceled(monitor))
          return
        end
      end
      if (additions.size > 0)
        if (@f_annotation_model.is_a?(IAnnotationModelExtension))
          extension = @f_annotation_model
          if (!is_canceled(monitor))
            extension.replace_annotations(nil, additions)
          end
        else
          e1 = additions.key_set.iterator
          while (e1.has_next)
            bag = e1.next_
            position = additions.get(bag)
            if (is_canceled(monitor))
              return
            end
            @f_annotation_model.add_annotation(bag, position)
          end
        end
      end
    end
    
    typesig { [Map, Array.typed(IRegion), Position] }
    def create_summary(additions, summary_regions, summary_anchor)
      size_ = 0
      map = nil
      synchronized((@f_lock)) do
        if (!(@f_configured_annotation_types).nil?)
          size_ = @f_configured_annotation_types.size
          map = HashMap.new
          i = 0
          while i < size_
            type = @f_configured_annotation_types.get(i)
            map.put(type, AnnotationBag.new(type))
            i += 1
          end
        end
      end
      if ((map).nil?)
        return
      end
      model = @f_projection_viewer.get_annotation_model
      if ((model).nil?)
        return
      end
      e = model.get_annotation_iterator
      while (e.has_next)
        annotation = e.next_
        bag = find_bag_for_type(map, annotation.get_type)
        if (!(bag).nil?)
          position = model.get_position(annotation)
          if (includes(summary_regions, position))
            bag.add(annotation)
          end
        end
      end
      i = 0
      while i < size_
        bag = map.get(@f_configured_annotation_types.get(i))
        if (!bag.is_empty)
          additions.put(bag, Position.new(summary_anchor.get_offset, summary_anchor.get_length))
        end
        i += 1
      end
    end
    
    typesig { [Map, String] }
    def find_bag_for_type(bag_map, annotation_type)
      bag = bag_map.get(annotation_type)
      if ((bag).nil? && @f_annotation_access.is_a?(IAnnotationAccessExtension))
        extension = @f_annotation_access
        super_types = extension.get_supertypes(annotation_type)
        i = 0
        while i < super_types.attr_length && (bag).nil?
          bag = bag_map.get(super_types[i])
          i += 1
        end
      end
      return bag
    end
    
    typesig { [Array.typed(IRegion), Position] }
    def includes(regions, position)
      i = 0
      while i < regions.attr_length
        region = regions[i]
        if (!(position).nil? && !position.is_deleted && region.get_offset <= position.get_offset && position.get_offset + position.get_length <= region.get_offset + region.get_length)
          return true
        end
        i += 1
      end
      return false
    end
    
    private
    alias_method :initialize__projection_summary, :initialize
  end
  
end
