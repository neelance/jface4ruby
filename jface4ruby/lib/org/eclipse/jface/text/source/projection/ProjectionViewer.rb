require "rjava"

# Copyright (c) 2000, 2009 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
# Tom Eicher (Avaloq Evolution AG) - block selection mode
module Org::Eclipse::Jface::Text::Source::Projection
  module ProjectionViewerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Source::Projection
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :JavaList
      include_const ::Org::Eclipse::Swt, :SWTError
      include_const ::Org::Eclipse::Swt::Custom, :ST
      include_const ::Org::Eclipse::Swt::Custom, :StyledText
      include_const ::Org::Eclipse::Swt::Dnd, :Clipboard
      include_const ::Org::Eclipse::Swt::Dnd, :DND
      include_const ::Org::Eclipse::Swt::Dnd, :TextTransfer
      include_const ::Org::Eclipse::Swt::Dnd, :Transfer
      include_const ::Org::Eclipse::Swt::Events, :VerifyEvent
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Display
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Jface::Internal::Text, :SelectionProcessor
      include_const ::Org::Eclipse::Jface::Text, :BadLocationException
      include_const ::Org::Eclipse::Jface::Text, :DocumentEvent
      include_const ::Org::Eclipse::Jface::Text, :FindReplaceDocumentAdapter
      include_const ::Org::Eclipse::Jface::Text, :IDocument
      include_const ::Org::Eclipse::Jface::Text, :IDocumentInformationMappingExtension
      include_const ::Org::Eclipse::Jface::Text, :IDocumentListener
      include_const ::Org::Eclipse::Jface::Text, :IRegion
      include_const ::Org::Eclipse::Jface::Text, :ISlaveDocumentManager
      include_const ::Org::Eclipse::Jface::Text, :ITextSelection
      include_const ::Org::Eclipse::Jface::Text, :ITextViewerExtension5
      include_const ::Org::Eclipse::Jface::Text, :Position
      include_const ::Org::Eclipse::Jface::Text, :Region
      include_const ::Org::Eclipse::Jface::Text, :TextSelection
      include_const ::Org::Eclipse::Jface::Text, :TextUtilities
      include_const ::Org::Eclipse::Jface::Text::Projection, :ProjectionDocument
      include_const ::Org::Eclipse::Jface::Text::Projection, :ProjectionDocumentEvent
      include_const ::Org::Eclipse::Jface::Text::Projection, :ProjectionDocumentManager
      include_const ::Org::Eclipse::Jface::Text::Source, :Annotation
      include_const ::Org::Eclipse::Jface::Text::Source, :AnnotationModelEvent
      include_const ::Org::Eclipse::Jface::Text::Source, :CompositeRuler
      include_const ::Org::Eclipse::Jface::Text::Source, :IAnnotationModel
      include_const ::Org::Eclipse::Jface::Text::Source, :IAnnotationModelExtension
      include_const ::Org::Eclipse::Jface::Text::Source, :IAnnotationModelListener
      include_const ::Org::Eclipse::Jface::Text::Source, :IAnnotationModelListenerExtension
      include_const ::Org::Eclipse::Jface::Text::Source, :IOverviewRuler
      include_const ::Org::Eclipse::Jface::Text::Source, :IVerticalRuler
      include_const ::Org::Eclipse::Jface::Text::Source, :IVerticalRulerColumn
      include_const ::Org::Eclipse::Jface::Text::Source, :SourceViewer
    }
  end
  
  # A projection source viewer is a source viewer which supports multiple visible
  # regions which can dynamically be changed.
  # <p>
  # A projection source viewer uses a <code>ProjectionDocumentManager</code>
  # for the management of the visible document.</p>
  # <p>
  # NOTE: The <code>ProjectionViewer</code> only supports projections that cover full lines.
  # </p>
  # <p>
  # This class should not be subclassed.</p>
  # 
  # @since 3.0
  # @noextend This class is not intended to be subclassed by clients.
  class ProjectionViewer < ProjectionViewerImports.const_get :SourceViewer
    include_class_members ProjectionViewerImports
    overload_protected {
      include ITextViewerExtension5
    }
    
    class_module.module_eval {
      const_set_lazy(:BASE) { INFORMATION }
      const_attr_reader  :BASE
      
      # see ISourceViewer.INFORMATION
      # Operation constant for the expand operation.
      const_set_lazy(:EXPAND) { BASE + 1 }
      const_attr_reader  :EXPAND
      
      # Operation constant for the collapse operation.
      const_set_lazy(:COLLAPSE) { BASE + 2 }
      const_attr_reader  :COLLAPSE
      
      # Operation constant for the toggle projection operation.
      const_set_lazy(:TOGGLE) { BASE + 3 }
      const_attr_reader  :TOGGLE
      
      # Operation constant for the expand all operation.
      const_set_lazy(:EXPAND_ALL) { BASE + 4 }
      const_attr_reader  :EXPAND_ALL
      
      # Operation constant for the collapse all operation.
      # 
      # @since 3.2
      const_set_lazy(:COLLAPSE_ALL) { BASE + 5 }
      const_attr_reader  :COLLAPSE_ALL
      
      # Internal listener to changes of the annotation model.
      const_set_lazy(:AnnotationModelListener) { Class.new do
        extend LocalClass
        include_class_members ProjectionViewer
        include IAnnotationModelListener
        include IAnnotationModelListenerExtension
        
        typesig { [class_self::IAnnotationModel] }
        # @see org.eclipse.jface.text.source.IAnnotationModelListener#modelChanged(org.eclipse.jface.text.source.IAnnotationModel)
        def model_changed(model)
          process_model_changed(model, nil)
        end
        
        typesig { [class_self::AnnotationModelEvent] }
        # @see org.eclipse.jface.text.source.IAnnotationModelListenerExtension#modelChanged(org.eclipse.jface.text.source.AnnotationModelEvent)
        def model_changed(event)
          process_model_changed(event.get_annotation_model, event)
        end
        
        typesig { [class_self::IAnnotationModel, class_self::AnnotationModelEvent] }
        def process_model_changed(model, event)
          if ((model).equal?(self.attr_f_projection_annotation_model))
            if (!(self.attr_f_projection_summary).nil?)
              self.attr_f_projection_summary.update_summaries
            end
            process_catchup_request(event)
          else
            if ((model).equal?(get_annotation_model) && !(self.attr_f_projection_summary).nil?)
              self.attr_f_projection_summary.update_summaries
            end
          end
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__annotation_model_listener, :initialize
      end }
      
      # Executes the 'replaceVisibleDocument' operation when called the first time. Self-destructs afterwards.
      const_set_lazy(:ReplaceVisibleDocumentExecutor) { Class.new do
        extend LocalClass
        include_class_members ProjectionViewer
        include IDocumentListener
        
        attr_accessor :f_slave_document
        alias_method :attr_f_slave_document, :f_slave_document
        undef_method :f_slave_document
        alias_method :attr_f_slave_document=, :f_slave_document=
        undef_method :f_slave_document=
        
        attr_accessor :f_execution_trigger
        alias_method :attr_f_execution_trigger, :f_execution_trigger
        undef_method :f_execution_trigger
        alias_method :attr_f_execution_trigger=, :f_execution_trigger=
        undef_method :f_execution_trigger=
        
        typesig { [class_self::IDocument] }
        # Creates a new executor in order to free the given slave document.
        # 
        # @param slaveDocument the slave document to free
        def initialize(slave_document)
          @f_slave_document = nil
          @f_execution_trigger = nil
          @f_slave_document = slave_document
        end
        
        typesig { [class_self::IDocument] }
        # Installs this executor on the given trigger document.
        # 
        # @param executionTrigger the trigger document
        def install(execution_trigger)
          if (!(execution_trigger).nil? && !(@f_slave_document).nil?)
            @f_execution_trigger = execution_trigger
            @f_execution_trigger.add_document_listener(self)
          end
        end
        
        typesig { [class_self::DocumentEvent] }
        # @see org.eclipse.jface.text.IDocumentListener#documentAboutToBeChanged(org.eclipse.jface.text.DocumentEvent)
        def document_about_to_be_changed(event)
        end
        
        typesig { [class_self::DocumentEvent] }
        # @see org.eclipse.jface.text.IDocumentListener#documentChanged(org.eclipse.jface.text.DocumentEvent)
        def document_changed(event)
          @f_execution_trigger.remove_document_listener(self)
          execute_replace_visible_document(@f_slave_document)
        end
        
        private
        alias_method :initialize__replace_visible_document_executor, :initialize
      end }
      
      # A command representing a change of the projection document. This can be either
      # adding a master document range, removing a master document change, or invalidating
      # the viewer text presentation.
      const_set_lazy(:ProjectionCommand) { Class.new do
        include_class_members ProjectionViewer
        
        class_module.module_eval {
          const_set_lazy(:ADD) { 0 }
          const_attr_reader  :ADD
          
          const_set_lazy(:REMOVE) { 1 }
          const_attr_reader  :REMOVE
          
          const_set_lazy(:INVALIDATE_PRESENTATION) { 2 }
          const_attr_reader  :INVALIDATE_PRESENTATION
        }
        
        attr_accessor :f_projection
        alias_method :attr_f_projection, :f_projection
        undef_method :f_projection
        alias_method :attr_f_projection=, :f_projection=
        undef_method :f_projection=
        
        attr_accessor :f_type
        alias_method :attr_f_type, :f_type
        undef_method :f_type
        alias_method :attr_f_type=, :f_type=
        undef_method :f_type=
        
        attr_accessor :f_offset
        alias_method :attr_f_offset, :f_offset
        undef_method :f_offset
        alias_method :attr_f_offset=, :f_offset=
        undef_method :f_offset=
        
        attr_accessor :f_length
        alias_method :attr_f_length, :f_length
        undef_method :f_length
        alias_method :attr_f_length=, :f_length=
        undef_method :f_length=
        
        typesig { [class_self::ProjectionDocument, ::Java::Int, ::Java::Int, ::Java::Int] }
        def initialize(projection, type, offset, length)
          @f_projection = nil
          @f_type = 0
          @f_offset = 0
          @f_length = 0
          @f_projection = projection
          @f_type = type
          @f_offset = offset
          @f_length = length
        end
        
        typesig { [::Java::Int, ::Java::Int] }
        def initialize(offset, length)
          @f_projection = nil
          @f_type = 0
          @f_offset = 0
          @f_length = 0
          @f_type = self.class::INVALIDATE_PRESENTATION
          @f_offset = offset
          @f_length = length
        end
        
        typesig { [] }
        def compute_expected_costs
          case (@f_type)
          when self.class::ADD
            begin
              gaps = @f_projection.compute_unprojected_master_regions(@f_offset, @f_length)
              return (gaps).nil? ? 0 : gaps.attr_length
            rescue self.class::BadLocationException => x
            end
          when self.class::REMOVE
            begin
              fragments = @f_projection.compute_projected_master_regions(@f_offset, @f_length)
              return (fragments).nil? ? 0 : fragments.attr_length
            rescue self.class::BadLocationException => x
            end
          end
          return 0
        end
        
        private
        alias_method :initialize__projection_command, :initialize
      end }
      
      # The queue of projection command objects.
      const_set_lazy(:ProjectionCommandQueue) { Class.new do
        include_class_members ProjectionViewer
        
        class_module.module_eval {
          const_set_lazy(:REDRAW_COSTS) { 15 }
          const_attr_reader  :REDRAW_COSTS
          
          const_set_lazy(:INVALIDATION_COSTS) { 10 }
          const_attr_reader  :INVALIDATION_COSTS
        }
        
        attr_accessor :f_list
        alias_method :attr_f_list, :f_list
        undef_method :f_list
        alias_method :attr_f_list=, :f_list=
        undef_method :f_list=
        
        attr_accessor :f_expected_execution_costs
        alias_method :attr_f_expected_execution_costs, :f_expected_execution_costs
        undef_method :f_expected_execution_costs
        alias_method :attr_f_expected_execution_costs=, :f_expected_execution_costs=
        undef_method :f_expected_execution_costs=
        
        typesig { [class_self::ProjectionCommand] }
        def add(command)
          @f_list.add(command)
        end
        
        typesig { [] }
        def iterator
          return @f_list.iterator
        end
        
        typesig { [] }
        def clear
          @f_list.clear
          @f_expected_execution_costs = -1
        end
        
        typesig { [] }
        def passed_redraw_costs_threshold
          if ((@f_expected_execution_costs).equal?(-1))
            compute_expected_execution_costs
          end
          return @f_expected_execution_costs > self.class::REDRAW_COSTS
        end
        
        typesig { [] }
        def passed_invalidation_costs_threshold
          if ((@f_expected_execution_costs).equal?(-1))
            compute_expected_execution_costs
          end
          return @f_expected_execution_costs > self.class::INVALIDATION_COSTS
        end
        
        typesig { [] }
        def compute_expected_execution_costs
          max_costs = Math.max(self.class::REDRAW_COSTS, self.class::INVALIDATION_COSTS)
          @f_expected_execution_costs = @f_list.size
          if (@f_expected_execution_costs <= max_costs)
            command = nil
            e = @f_list.iterator
            while (e.has_next)
              command = e.next_
              @f_expected_execution_costs += command.compute_expected_costs
              if (@f_expected_execution_costs > max_costs)
                break
              end
            end
          end
        end
        
        typesig { [] }
        def initialize
          @f_list = self.class::ArrayList.new(15)
          @f_expected_execution_costs = -1
        end
        
        private
        alias_method :initialize__projection_command_queue, :initialize
      end }
    }
    
    # The projection annotation model used by this viewer.
    attr_accessor :f_projection_annotation_model
    alias_method :attr_f_projection_annotation_model, :f_projection_annotation_model
    undef_method :f_projection_annotation_model
    alias_method :attr_f_projection_annotation_model=, :f_projection_annotation_model=
    undef_method :f_projection_annotation_model=
    
    # The annotation model listener
    attr_accessor :f_annotation_model_listener
    alias_method :attr_f_annotation_model_listener, :f_annotation_model_listener
    undef_method :f_annotation_model_listener
    alias_method :attr_f_annotation_model_listener=, :f_annotation_model_listener=
    undef_method :f_annotation_model_listener=
    
    # The projection summary.
    attr_accessor :f_projection_summary
    alias_method :attr_f_projection_summary, :f_projection_summary
    undef_method :f_projection_summary
    alias_method :attr_f_projection_summary=, :f_projection_summary=
    undef_method :f_projection_summary=
    
    # Indication that an annotation world change has not yet been processed.
    attr_accessor :f_pending_annotation_world_change
    alias_method :attr_f_pending_annotation_world_change, :f_pending_annotation_world_change
    undef_method :f_pending_annotation_world_change
    alias_method :attr_f_pending_annotation_world_change=, :f_pending_annotation_world_change=
    undef_method :f_pending_annotation_world_change=
    
    # Indication whether projection changes in the visible document should be considered.
    attr_accessor :f_handle_projection_changes
    alias_method :attr_f_handle_projection_changes, :f_handle_projection_changes
    undef_method :f_handle_projection_changes
    alias_method :attr_f_handle_projection_changes=, :f_handle_projection_changes=
    undef_method :f_handle_projection_changes=
    
    # The list of projection listeners.
    attr_accessor :f_projection_listeners
    alias_method :attr_f_projection_listeners, :f_projection_listeners
    undef_method :f_projection_listeners
    alias_method :attr_f_projection_listeners=, :f_projection_listeners=
    undef_method :f_projection_listeners=
    
    # Internal lock for protecting the list of pending requests
    attr_accessor :f_lock
    alias_method :attr_f_lock, :f_lock
    undef_method :f_lock
    alias_method :attr_f_lock=, :f_lock=
    undef_method :f_lock=
    
    # The list of pending requests
    attr_accessor :f_pending_requests
    alias_method :attr_f_pending_requests, :f_pending_requests
    undef_method :f_pending_requests
    alias_method :attr_f_pending_requests=, :f_pending_requests=
    undef_method :f_pending_requests=
    
    # The replace-visible-document execution trigger
    attr_accessor :f_replace_visible_document_execution_trigger
    alias_method :attr_f_replace_visible_document_execution_trigger, :f_replace_visible_document_execution_trigger
    undef_method :f_replace_visible_document_execution_trigger
    alias_method :attr_f_replace_visible_document_execution_trigger=, :f_replace_visible_document_execution_trigger=
    undef_method :f_replace_visible_document_execution_trigger=
    
    # <code>true</code> if projection was on the last time we switched to segmented mode.
    attr_accessor :f_was_projection_enabled
    alias_method :attr_f_was_projection_enabled, :f_was_projection_enabled
    undef_method :f_was_projection_enabled
    alias_method :attr_f_was_projection_enabled=, :f_was_projection_enabled=
    undef_method :f_was_projection_enabled=
    
    # The queue of projection commands used to assess the costs of projection changes.
    attr_accessor :f_command_queue
    alias_method :attr_f_command_queue, :f_command_queue
    undef_method :f_command_queue
    alias_method :attr_f_command_queue=, :f_command_queue=
    undef_method :f_command_queue=
    
    # The amount of lines deleted by the last document event issued by the
    # visible document event.
    # @since 3.1
    attr_accessor :f_deleted_lines
    alias_method :attr_f_deleted_lines, :f_deleted_lines
    undef_method :f_deleted_lines
    alias_method :attr_f_deleted_lines=, :f_deleted_lines=
    undef_method :f_deleted_lines=
    
    typesig { [Composite, IVerticalRuler, IOverviewRuler, ::Java::Boolean, ::Java::Int] }
    # Creates a new projection source viewer.
    # 
    # @param parent the SWT parent control
    # @param ruler the vertical ruler
    # @param overviewRuler the overview ruler
    # @param showsAnnotationOverview <code>true</code> if the overview ruler should be shown
    # @param styles the SWT style bits
    def initialize(parent, ruler, overview_ruler, shows_annotation_overview, styles)
      @f_projection_annotation_model = nil
      @f_annotation_model_listener = nil
      @f_projection_summary = nil
      @f_pending_annotation_world_change = false
      @f_handle_projection_changes = false
      @f_projection_listeners = nil
      @f_lock = nil
      @f_pending_requests = nil
      @f_replace_visible_document_execution_trigger = nil
      @f_was_projection_enabled = false
      @f_command_queue = nil
      @f_deleted_lines = 0
      super(parent, ruler, overview_ruler, shows_annotation_overview, styles)
      @f_annotation_model_listener = AnnotationModelListener.new_local(self)
      @f_pending_annotation_world_change = false
      @f_handle_projection_changes = true
      @f_lock = Object.new
      @f_pending_requests = ArrayList.new
    end
    
    typesig { [ProjectionSummary] }
    # Sets the projection summary for this viewer.
    # 
    # @param projectionSummary the projection summary.
    def set_projection_summary(projection_summary)
      @f_projection_summary = projection_summary
    end
    
    typesig { [IAnnotationModel] }
    # Adds the projection annotation model to the given annotation model.
    # 
    # @param model the model to which the projection annotation model is added
    def add_projection_annotation_model(model)
      if (model.is_a?(IAnnotationModelExtension))
        extension = model
        extension.add_annotation_model(ProjectionSupport::PROJECTION, @f_projection_annotation_model)
        model.add_annotation_model_listener(@f_annotation_model_listener)
      end
    end
    
    typesig { [IAnnotationModel] }
    # Removes the projection annotation model from the given annotation model.
    # 
    # @param model the mode from which the projection annotation model is removed
    # @return the removed projection annotation model or <code>null</code> if there was none
    def remove_projection_annotation_model(model)
      if (model.is_a?(IAnnotationModelExtension))
        model.remove_annotation_model_listener(@f_annotation_model_listener)
        extension = model
        return extension.remove_annotation_model(ProjectionSupport::PROJECTION)
      end
      return nil
    end
    
    typesig { [IDocument, IAnnotationModel, ::Java::Int, ::Java::Int] }
    # @see org.eclipse.jface.text.source.SourceViewer#setDocument(org.eclipse.jface.text.IDocument, org.eclipse.jface.text.source.IAnnotationModel, int, int)
    def set_document(document, annotation_model, model_range_offset, model_range_length)
      was_projection_enabled = false
      synchronized((@f_lock)) do
        @f_pending_requests.clear
      end
      if (!(@f_projection_annotation_model).nil?)
        was_projection_enabled = !(remove_projection_annotation_model(get_visual_annotation_model)).nil?
        @f_projection_annotation_model = nil
      end
      super(document, annotation_model, model_range_offset, model_range_length)
      if (was_projection_enabled && !(document).nil?)
        enable_projection
      end
    end
    
    typesig { [IAnnotationModel] }
    # @see org.eclipse.jface.text.source.SourceViewer#createVisualAnnotationModel(org.eclipse.jface.text.source.IAnnotationModel)
    def create_visual_annotation_model(annotation_model)
      model = super(annotation_model)
      @f_projection_annotation_model = ProjectionAnnotationModel.new
      return model
    end
    
    typesig { [] }
    # Returns the projection annotation model.
    # 
    # @return the projection annotation model
    def get_projection_annotation_model
      model = get_visual_annotation_model
      if (model.is_a?(IAnnotationModelExtension))
        extension = model
        return extension.get_annotation_model(ProjectionSupport::PROJECTION)
      end
      return nil
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.TextViewer#createSlaveDocumentManager()
    def create_slave_document_manager
      return ProjectionDocumentManager.new
    end
    
    typesig { [IDocument, ::Java::Int, ::Java::Int] }
    # @see org.eclipse.jface.text.TextViewer#updateSlaveDocument(org.eclipse.jface.text.IDocument, int, int)
    def update_slave_document(slave_document, model_range_offset, model_range_length)
      if (slave_document.is_a?(ProjectionDocument))
        projection = slave_document
        offset = model_range_offset
        length = model_range_length
        if (!is_projection_mode)
          # mimic original TextViewer behavior
          master = projection.get_master_document
          line = master.get_line_of_offset(model_range_offset)
          offset = master.get_line_offset(line)
          length = (model_range_offset - offset) + model_range_length
        end
        begin
          @f_handle_projection_changes = false
          projection.replace_master_document_ranges(offset, length)
        ensure
          @f_handle_projection_changes = true
        end
        return true
      end
      return false
    end
    
    typesig { [IProjectionListener] }
    # Adds a projection annotation listener to this viewer. The listener may
    # not be <code>null</code>. If the listener is already registered, this method
    # does not have any effect.
    # 
    # @param listener the listener to add
    def add_projection_listener(listener)
      Assert.is_not_null(listener)
      if ((@f_projection_listeners).nil?)
        @f_projection_listeners = ArrayList.new
      end
      if (!@f_projection_listeners.contains(listener))
        @f_projection_listeners.add(listener)
      end
    end
    
    typesig { [IProjectionListener] }
    # Removes the given listener from this viewer. The listener may not be
    # <code>null</code>. If the listener is not registered with this viewer,
    # this method is without effect.
    # 
    # @param listener the listener to remove
    def remove_projection_listener(listener)
      Assert.is_not_null(listener)
      if (!(@f_projection_listeners).nil?)
        @f_projection_listeners.remove(listener)
        if ((@f_projection_listeners.size).equal?(0))
          @f_projection_listeners = nil
        end
      end
    end
    
    typesig { [] }
    # Notifies all registered projection listeners
    # that projection mode has been enabled.
    def fire_projection_enabled
      if (!(@f_projection_listeners).nil?)
        e = ArrayList.new(@f_projection_listeners).iterator
        while (e.has_next)
          l = e.next_
          l.projection_enabled
        end
      end
    end
    
    typesig { [] }
    # Notifies all registered projection listeners
    # that projection mode has been disabled.
    def fire_projection_disabled
      if (!(@f_projection_listeners).nil?)
        e = ArrayList.new(@f_projection_listeners).iterator
        while (e.has_next)
          l = e.next_
          l.projection_disabled
        end
      end
    end
    
    typesig { [] }
    # Returns whether this viewer is in projection mode.
    # 
    # @return <code>true</code> if this viewer is in projection mode,
    # <code>false</code> otherwise
    def is_projection_mode
      return !(get_projection_annotation_model).nil?
    end
    
    typesig { [] }
    # Disables the projection mode.
    def disable_projection
      if (is_projection_mode)
        remove_projection_annotation_model(get_visual_annotation_model)
        @f_projection_annotation_model.remove_all_annotations
        self.attr_f_find_replace_document_adapter = nil
        fire_projection_disabled
      end
    end
    
    typesig { [] }
    # Enables the projection mode.
    def enable_projection
      if (!is_projection_mode)
        add_projection_annotation_model(get_visual_annotation_model)
        self.attr_f_find_replace_document_adapter = nil
        fire_projection_enabled
      end
    end
    
    typesig { [] }
    def expand_all
      offset = 0
      doc = get_document
      length = (doc).nil? ? 0 : doc.get_length
      if (is_projection_mode)
        @f_projection_annotation_model.expand_all(offset, length)
      end
    end
    
    typesig { [] }
    def expand
      if (is_projection_mode)
        found = nil
        best_match = nil
        selection = get_selected_range
        e = @f_projection_annotation_model.get_annotation_iterator
        while e.has_next
          annotation = e.next_
          if (annotation.is_collapsed)
            position = @f_projection_annotation_model.get_position(annotation)
            # take the first most fine grained match
            if (!(position).nil? && touches(selection, position))
              if ((found).nil? || position.includes(found.attr_offset) && position.includes(found.attr_offset + found.attr_length))
                found = position
                best_match = annotation
              end
            end
          end
        end
        if (!(best_match).nil?)
          @f_projection_annotation_model.expand(best_match)
          reveal_range(selection.attr_x, selection.attr_y)
        end
      end
    end
    
    typesig { [Point, Position] }
    def touches(selection, position)
      return position.overlaps_with(selection.attr_x, selection.attr_y) || (selection.attr_y).equal?(0) && (position.attr_offset + position.attr_length).equal?(selection.attr_x + selection.attr_y)
    end
    
    typesig { [] }
    def collapse
      if (is_projection_mode)
        found = nil
        best_match = nil
        selection = get_selected_range
        e = @f_projection_annotation_model.get_annotation_iterator
        while e.has_next
          annotation = e.next_
          if (!annotation.is_collapsed)
            position = @f_projection_annotation_model.get_position(annotation)
            # take the first most fine grained match
            if (!(position).nil? && touches(selection, position))
              if ((found).nil? || found.includes(position.attr_offset) && found.includes(position.attr_offset + position.attr_length))
                found = position
                best_match = annotation
              end
            end
          end
        end
        if (!(best_match).nil?)
          @f_projection_annotation_model.collapse(best_match)
          reveal_range(selection.attr_x, selection.attr_y)
        end
      end
    end
    
    typesig { [] }
    # @since 3.2
    def collapse_all
      offset = 0
      doc = get_document
      length = (doc).nil? ? 0 : doc.get_length
      if (is_projection_mode)
        @f_projection_annotation_model.collapse_all(offset, length)
      end
    end
    
    typesig { [ProjectionDocument, ::Java::Int, ::Java::Int] }
    # Adds the given master range to the given projection document. While the
    # modification is processed, the viewer no longer handles projection
    # changes, as it is causing them.
    # 
    # @param projection the projection document
    # @param offset the offset in the master document
    # @param length the length in the master document
    # @throws BadLocationException in case the specified range is invalid
    # 
    # @see ProjectionDocument#addMasterDocumentRange(int, int)
    def add_master_document_range(projection, offset, length)
      if (!(@f_command_queue).nil?)
        @f_command_queue.add(ProjectionCommand.new(projection, ProjectionCommand::ADD, offset, length))
      else
        begin
          @f_handle_projection_changes = false
          # https://bugs.eclipse.org/bugs/show_bug.cgi?id=108258
          # make sure the document range is strictly line based
          end_ = offset + length
          offset = to_line_start(projection.get_master_document, offset, false)
          length = to_line_start(projection.get_master_document, end_, true) - offset
          projection.add_master_document_range(offset, length)
        ensure
          @f_handle_projection_changes = true
        end
      end
    end
    
    typesig { [ProjectionDocument, ::Java::Int, ::Java::Int] }
    # Removes the given master range from the given projection document. While the
    # modification is processed, the viewer no longer handles projection
    # changes, as it is causing them.
    # 
    # @param projection the projection document
    # @param offset the offset in the master document
    # @param length the length in the master document
    # @throws BadLocationException in case the specified range is invalid
    # 
    # @see ProjectionDocument#removeMasterDocumentRange(int, int)
    def remove_master_document_range(projection, offset, length)
      if (!(@f_command_queue).nil?)
        @f_command_queue.add(ProjectionCommand.new(projection, ProjectionCommand::REMOVE, offset, length))
      else
        begin
          @f_handle_projection_changes = false
          # https://bugs.eclipse.org/bugs/show_bug.cgi?id=108258
          # make sure the document range is strictly line based
          end_ = offset + length
          offset = to_line_start(projection.get_master_document, offset, false)
          length = to_line_start(projection.get_master_document, end_, true) - offset
          projection.remove_master_document_range(offset, length)
        ensure
          @f_handle_projection_changes = true
        end
      end
    end
    
    typesig { [IDocument, ::Java::Int, ::Java::Boolean] }
    # Returns the first line offset &lt;= <code>offset</code>. If <code>testLastLine</code>
    # is <code>true</code> and the offset is on last line then <code>offset</code> is returned.
    # 
    # @param document the document
    # @param offset the master document offset
    # @param testLastLine <code>true</code> if the test for the last line should be performed
    # @return the closest line offset &gt;= <code>offset</code>
    # @throws BadLocationException if the offset is invalid
    # @since 3.2
    def to_line_start(document, offset, test_last_line)
      if ((document).nil?)
        return offset
      end
      if (test_last_line && offset >= document.get_line_information_of_offset(document.get_length - 1).get_offset)
        return offset
      end
      return document.get_line_information_of_offset(offset).get_offset
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # @see org.eclipse.jface.text.TextViewer#setVisibleRegion(int, int)
    def set_visible_region(start, length)
      @f_was_projection_enabled = is_projection_mode
      disable_projection
      super(start, length)
    end
    
    typesig { [IDocument] }
    # @see org.eclipse.jface.text.TextViewer#setVisibleDocument(org.eclipse.jface.text.IDocument)
    def set_visible_document(document)
      if (!is_projection_mode)
        super(document)
        return
      end
      # In projection mode we don't want to throw away the find/replace document adapter
      adapter = self.attr_f_find_replace_document_adapter
      super(document)
      self.attr_f_find_replace_document_adapter = adapter
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.TextViewer#resetVisibleRegion()
    def reset_visible_region
      super
      if (@f_was_projection_enabled)
        enable_projection
      end
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.ITextViewer#getVisibleRegion()
    def get_visible_region
      disable_projection
      visible_region = get_model_coverage
      if ((visible_region).nil?)
        visible_region = Region.new(0, 0)
      end
      return visible_region
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # @see org.eclipse.jface.text.ITextViewer#overlapsWithVisibleRegion(int,int)
    def overlaps_with_visible_region(offset, length)
      disable_projection
      coverage = get_model_coverage
      if ((coverage).nil?)
        return false
      end
      appending = ((offset).equal?(coverage.get_offset + coverage.get_length)) && (length).equal?(0)
      return appending || TextUtilities.overlaps(coverage, Region.new(offset, length))
    end
    
    typesig { [IDocument] }
    # Replace the visible document with the given document. Maintains the
    # scroll offset and the selection.
    # 
    # @param slave the visible document
    def replace_visible_document(slave)
      if (!(@f_replace_visible_document_execution_trigger).nil?)
        executor = ReplaceVisibleDocumentExecutor.new_local(self, slave)
        executor.install(@f_replace_visible_document_execution_trigger)
      else
        execute_replace_visible_document(slave)
      end
    end
    
    typesig { [IDocument] }
    def execute_replace_visible_document(visible_document)
      text_widget = get_text_widget
      begin
        if (!(text_widget).nil? && !text_widget.is_disposed)
          text_widget.set_redraw(false)
        end
        top_index = get_top_index
        selection = get_selected_range
        set_visible_document(visible_document)
        current_selection = get_selected_range
        if (!(current_selection.attr_x).equal?(selection.attr_x) || !(current_selection.attr_y).equal?(selection.attr_y))
          set_selected_range(selection.attr_x, selection.attr_y)
        end
        set_top_index(top_index)
      ensure
        if (!(text_widget).nil? && !text_widget.is_disposed)
          text_widget.set_redraw(true)
        end
      end
    end
    
    typesig { [::Java::Int, ::Java::Int, ::Java::Boolean] }
    # Hides the given range by collapsing it. If requested, a redraw request is issued.
    # 
    # @param offset the offset of the range to hide
    # @param length the length of the range to hide
    # @param fireRedraw <code>true</code> if a redraw request should be issued, <code>false</code> otherwise
    # @throws BadLocationException in case the range is invalid
    def collapse(offset, length, fire_redraw)
      projection = nil
      visible_document = get_visible_document
      if (visible_document.is_a?(ProjectionDocument))
        projection = visible_document
      else
        master = get_document
        slave = create_slave_document(get_document)
        if (slave.is_a?(ProjectionDocument))
          projection = slave
          add_master_document_range(projection, 0, master.get_length)
          replace_visible_document(projection)
        end
      end
      if (!(projection).nil?)
        remove_master_document_range(projection, offset, length)
      end
      if (!(projection).nil? && fire_redraw)
        # repaint line above to get the folding box
        document = get_document
        line = document.get_line_of_offset(offset)
        if (line > 0)
          info = document.get_line_information(line - 1)
          internal_invalidate_text_presentation(info.get_offset, info.get_length)
        end
      end
    end
    
    typesig { [::Java::Int, ::Java::Int, ::Java::Boolean] }
    # Makes the given range visible again while not changing the folding state of any contained
    # ranges. If requested, a redraw request is issued.
    # 
    # @param offset the offset of the range to be expanded
    # @param length the length of the range to be expanded
    # @param fireRedraw <code>true</code> if a redraw request should be issued,
    # <code>false</code> otherwise
    # @throws BadLocationException in case the range is invalid
    def expand(offset, length, fire_redraw)
      slave = get_visible_document
      if (slave.is_a?(ProjectionDocument))
        projection = slave
        # expand
        add_master_document_range(projection, offset, length)
        # collapse contained regions
        collapsed = compute_collapsed_nested_annotations(offset, length)
        if (!(collapsed).nil?)
          i = 0
          while i < collapsed.attr_length
            regions = compute_collapsed_regions(@f_projection_annotation_model.get_position(collapsed[i]))
            if (!(regions).nil?)
              j = 0
              while j < regions.attr_length
                remove_master_document_range(projection, regions[j].get_offset, regions[j].get_length)
                j += 1
              end
            end
            i += 1
          end
        end
        # redraw if requested
        if (fire_redraw)
          internal_invalidate_text_presentation(offset, length)
        end
      end
    end
    
    typesig { [AnnotationModelEvent] }
    # Processes the request for catch up with the annotation model in the UI thread. If the current
    # thread is not the UI thread or there are pending catch up requests, a new request is posted.
    # 
    # @param event the annotation model event
    def process_catchup_request(event)
      if (!(Display.get_current).nil?)
        run = false
        synchronized((@f_lock)) do
          run = @f_pending_requests.is_empty
        end
        if (run)
          begin
            catchup_with_projection_annotation_model(event)
          rescue BadLocationException => x
            raise IllegalArgumentException.new
          end
        else
          post_catchup_request(event)
        end
      else
        post_catchup_request(event)
      end
    end
    
    typesig { [AnnotationModelEvent] }
    # Posts the request for catch up with the annotation model into the UI thread.
    # 
    # @param event the annotation model event
    def post_catchup_request(event)
      synchronized((@f_lock)) do
        @f_pending_requests.add(event)
        if ((@f_pending_requests.size).equal?(1))
          widget = get_text_widget
          if (!(widget).nil?)
            display = widget.get_display
            if (!(display).nil?)
              display.async_exec(Class.new(Runnable.class == Class ? Runnable : Object) do
                extend LocalClass
                include_class_members ProjectionViewer
                include Runnable if Runnable.class == Module
                
                typesig { [] }
                define_method :run do
                  begin
                    while (true)
                      ame = nil
                      synchronized((self.attr_f_lock)) do
                        if ((self.attr_f_pending_requests.size).equal?(0))
                          return
                        end
                        ame = self.attr_f_pending_requests.remove(0)
                      end
                      catchup_with_projection_annotation_model(ame)
                    end
                  rescue self.class::BadLocationException => x
                    begin
                      catchup_with_projection_annotation_model(nil)
                    rescue self.class::BadLocationException => x1
                      raise self.class::IllegalArgumentException.new
                    ensure
                      synchronized((self.attr_f_lock)) do
                        self.attr_f_pending_requests.clear
                      end
                    end
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
        end
      end
    end
    
    typesig { [] }
    # Tests whether the visible document's master document
    # is identical to this viewer's document.
    # 
    # @return <code>true</code> if the visible document's master is
    # identical to this viewer's document
    # @since 3.1
    def is_visible_master_document_same_as_document
      visible_document = get_visible_document
      return (visible_document.is_a?(ProjectionDocument)) && ((visible_document).get_master_document).equal?(get_document)
    end
    
    typesig { [AnnotationModelEvent] }
    # Adapts the slave visual document of this viewer to the changes described
    # in the annotation model event. When the event is <code>null</code>,
    # this is identical to a world change event.
    # 
    # @param event the annotation model event or <code>null</code>
    # @exception BadLocationException in case the annotation model event is no longer in synchronization with the document
    def catchup_with_projection_annotation_model(event)
      if ((event).nil? || !is_visible_master_document_same_as_document)
        @f_pending_annotation_world_change = false
        reinitialize_projection
      else
        if (event.is_world_change)
          if (event.is_valid)
            @f_pending_annotation_world_change = false
            reinitialize_projection
          else
            @f_pending_annotation_world_change = true
          end
        else
          if (@f_pending_annotation_world_change)
            if (event.is_valid)
              @f_pending_annotation_world_change = false
              reinitialize_projection
            end
          else
            added_annotations = event.get_added_annotations
            changed_annotation = event.get_changed_annotations
            removed_annotations = event.get_removed_annotations
            @f_command_queue = ProjectionCommandQueue.new
            is_redrawing = redraws
            top_index = is_redrawing ? get_top_index : -1
            process_deletions(event, removed_annotations, true)
            coverage = ArrayList.new
            process_changes(added_annotations, true, coverage)
            process_changes(changed_annotation, true, coverage)
            command_queue = @f_command_queue
            @f_command_queue = nil
            if (command_queue.passed_redraw_costs_threshold)
              set_redraw(false)
              begin
                execute_projection_commands(command_queue, false)
              rescue IllegalArgumentException => x
                reinitialize_projection
              ensure
                set_redraw(true, top_index)
              end
            else
              begin
                fire_redraw = !command_queue.passed_invalidation_costs_threshold
                execute_projection_commands(command_queue, fire_redraw)
                if (!fire_redraw)
                  invalidate_text_presentation
                end
              rescue IllegalArgumentException => x
                reinitialize_projection
              end
            end
          end
        end
      end
    end
    
    typesig { [ProjectionCommandQueue, ::Java::Boolean] }
    def execute_projection_commands(command_queue, fire_redraw)
      command = nil
      e = command_queue.iterator
      while (e.has_next)
        command = e.next_
        case (command.attr_f_type)
        when ProjectionCommand::ADD
          add_master_document_range(command.attr_f_projection, command.attr_f_offset, command.attr_f_length)
        when ProjectionCommand::REMOVE
          remove_master_document_range(command.attr_f_projection, command.attr_f_offset, command.attr_f_length)
        when ProjectionCommand::INVALIDATE_PRESENTATION
          if (fire_redraw)
            invalidate_text_presentation(command.attr_f_offset, command.attr_f_length)
          end
        end
      end
      command_queue.clear
    end
    
    typesig { [::Java::Int, ::Java::Int, Position] }
    def covers(offset, length, position)
      if (!((position.attr_offset).equal?(offset) && (position.attr_length).equal?(length)) && !position.is_deleted)
        return offset <= position.get_offset && position.get_offset + position.get_length <= offset + length
      end
      return false
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    def compute_collapsed_nested_annotations(offset, length)
      annotations = ArrayList.new(5)
      e = @f_projection_annotation_model.get_annotation_iterator
      while (e.has_next)
        annotation = e.next_
        if (annotation.is_collapsed)
          position = @f_projection_annotation_model.get_position(annotation)
          if ((position).nil?)
            # annotation might already be deleted, we will be informed later on about this deletion
            next
          end
          if (covers(offset, length, position))
            annotations.add(annotation)
          end
        end
      end
      if (annotations.size > 0)
        result = Array.typed(ProjectionAnnotation).new(annotations.size) { nil }
        annotations.to_array(result)
        return result
      end
      return nil
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    def internal_invalidate_text_presentation(offset, length)
      if (!(@f_command_queue).nil?)
        @f_command_queue.add(ProjectionCommand.new(offset, length))
      else
        invalidate_text_presentation(offset, length)
      end
    end
    
    typesig { [AnnotationModelEvent, Array.typed(Annotation), ::Java::Boolean] }
    # We pass the removed annotation into this method for performance reasons only. Otherwise, they could be fetch from the event.
    def process_deletions(event, removed_annotations, fire_redraw)
      i = 0
      while i < removed_annotations.attr_length
        annotation = removed_annotations[i]
        if (annotation.is_collapsed)
          expanded = event.get_position_of_removed_annotation(annotation)
          expand(expanded.get_offset, expanded.get_length, fire_redraw)
        end
        i += 1
      end
    end
    
    typesig { [Position] }
    # Computes the region that must be collapsed when the given position is the
    # position of an expanded projection annotation.
    # 
    # @param position the position
    # @return the range that must be collapsed
    def compute_collapsed_region(position)
      begin
        document = get_document
        if ((document).nil?)
          return nil
        end
        line = document.get_line_of_offset(position.get_offset)
        offset = document.get_line_offset(line + 1)
        length = position.get_length - (offset - position.get_offset)
        if (length > 0)
          return Region.new(offset, length)
        end
      rescue BadLocationException => x
      end
      return nil
    end
    
    typesig { [Position] }
    # Computes the regions that must be collapsed when the given position is
    # the position of an expanded projection annotation.
    # 
    # @param position the position
    # @return the ranges that must be collapsed, or <code>null</code> if
    # there are none
    # @since 3.1
    def compute_collapsed_regions(position)
      begin
        document = get_document
        if ((document).nil?)
          return nil
        end
        if (position.is_a?(IProjectionPosition))
          proj_position = position
          return proj_position.compute_projection_regions(document)
        end
        line = document.get_line_of_offset(position.get_offset)
        offset = document.get_line_offset(line + 1)
        length = position.get_length - (offset - position.get_offset)
        if (length > 0)
          return Array.typed(IRegion).new([Region.new(offset, length)])
        end
        return nil
      rescue BadLocationException => x
        return nil
      end
    end
    
    typesig { [Position] }
    # Computes the collapsed region anchor for the given position. Assuming
    # that the position is the position of an expanded projection annotation,
    # the anchor is the region that is still visible after the projection
    # annotation has been collapsed.
    # 
    # @param position the position
    # @return the collapsed region anchor
    def compute_collapsed_region_anchor(position)
      begin
        document = get_document
        if ((document).nil?)
          return nil
        end
        caption_offset = position.get_offset
        if (position.is_a?(IProjectionPosition))
          caption_offset += (position).compute_caption_offset(document)
        end
        line_info = document.get_line_information_of_offset(caption_offset)
        return Position.new(line_info.get_offset + line_info.get_length, 0)
      rescue BadLocationException => x
      end
      return nil
    end
    
    typesig { [Array.typed(Annotation), ::Java::Boolean, JavaList] }
    def process_changes(annotations, fire_redraw, coverage)
      i = 0
      while i < annotations.attr_length
        annotation = annotations[i]
        position = @f_projection_annotation_model.get_position(annotation)
        if ((position).nil?)
          i += 1
          next
        end
        if (!covers(coverage, position))
          if (annotation.is_collapsed)
            coverage.add(position)
            regions = compute_collapsed_regions(position)
            if (!(regions).nil?)
              j = 0
              while j < regions.attr_length
                collapse(regions[j].get_offset, regions[j].get_length, fire_redraw)
                j += 1
              end
            end
          else
            expand(position.get_offset, position.get_length, fire_redraw)
          end
        end
        i += 1
      end
    end
    
    typesig { [JavaList, Position] }
    def covers(coverage, position)
      e = coverage.iterator
      while (e.has_next)
        p = e.next_
        if (p.get_offset <= position.get_offset && position.get_offset + position.get_length <= p.get_offset + p.get_length)
          return true
        end
      end
      return false
    end
    
    typesig { [] }
    # Forces this viewer to throw away any old state and to initialize its content
    # from its projection annotation model.
    # 
    # @throws BadLocationException in case something goes wrong during initialization
    def reinitialize_projection
      projection = nil
      manager = get_slave_document_manager
      if (!(manager).nil?)
        master = get_document
        if (!(master).nil?)
          slave = manager.create_slave_document(master)
          if (slave.is_a?(ProjectionDocument))
            projection = slave
            add_master_document_range(projection, 0, master.get_length)
          end
        end
      end
      if (!(projection).nil?)
        e = @f_projection_annotation_model.get_annotation_iterator
        while (e.has_next)
          annotation = e.next_
          if (annotation.is_collapsed)
            position = @f_projection_annotation_model.get_position(annotation)
            if (!(position).nil?)
              regions = compute_collapsed_regions(position)
              if (!(regions).nil?)
                i = 0
                while i < regions.attr_length
                  remove_master_document_range(projection, regions[i].get_offset, regions[i].get_length)
                  i += 1
                end
              end
            end
          end
        end
      end
      replace_visible_document(projection)
    end
    
    typesig { [VerifyEvent] }
    # @see org.eclipse.jface.text.TextViewer#handleVerifyEvent(org.eclipse.swt.events.VerifyEvent)
    def handle_verify_event(e)
      if (get_text_widget.get_block_selection)
        selection = get_selection
        if (expose_model_range(Region.new(selection.get_offset, selection.get_length)))
          set_selection(selection)
        end
        super(e)
      end
      selection = get_selected_range
      model_range = event2_model_range(e)
      if (expose_model_range(model_range))
        e.attr_doit = false
        begin
          if ((selection.attr_y).equal?(0) && e.attr_text.length <= 1 && (model_range.get_length).equal?(1))
            selection.attr_y = 1
            if ((selection.attr_x - 1).equal?(model_range.get_offset))
              selection.attr_x -= 1
            end
          end
          get_document.replace(selection.attr_x, selection.attr_y, e.attr_text)
          set_selected_range(selection.attr_x + e.attr_text.length, 0)
        rescue BadLocationException => e1
          # ignore as nothing bad happens (no log at this level)
        end
      else
        super(e)
      end
    end
    
    typesig { [IVerticalRulerColumn] }
    # Adds the give column as last column to this viewer's vertical ruler.
    # 
    # @param column the column to be added
    def add_vertical_ruler_column(column)
      ruler = get_vertical_ruler
      if (ruler.is_a?(CompositeRuler))
        composite_ruler = ruler
        composite_ruler.add_decorator(99, column)
      end
    end
    
    typesig { [IVerticalRulerColumn] }
    # Removes the give column from this viewer's vertical ruler.
    # 
    # @param column the column to be removed
    def remove_vertical_ruler_column(column)
      ruler = get_vertical_ruler
      if (ruler.is_a?(CompositeRuler))
        composite_ruler = ruler
        composite_ruler.remove_decorator(column)
      end
    end
    
    typesig { [IRegion] }
    # @see org.eclipse.jface.text.ITextViewerExtension5#exposeModelRange(org.eclipse.jface.text.IRegion)
    def expose_model_range(model_range)
      if (is_projection_mode)
        return @f_projection_annotation_model.expand_all(model_range.get_offset, model_range.get_length)
      end
      if (!overlaps_with_visible_region(model_range.get_offset, model_range.get_length))
        reset_visible_region
        return true
      end
      return false
    end
    
    typesig { [::Java::Int, ::Java::Int, ::Java::Boolean] }
    # @see org.eclipse.jface.text.source.SourceViewer#setRangeIndication(int, int, boolean)
    def set_range_indication(offset, length_, move_cursor)
      range_indication = get_range_indication
      if (move_cursor && !(@f_projection_annotation_model).nil? && ((range_indication).nil? || !(offset).equal?(range_indication.get_offset) || !(length_).equal?(range_indication.get_length)))
        expand_ = ArrayList.new(2)
        # expand the immediate effected collapsed regions
        iterator_ = @f_projection_annotation_model.get_annotation_iterator
        while (iterator_.has_next)
          annotation = iterator_.next_
          if (annotation.is_collapsed && will_auto_expand(@f_projection_annotation_model.get_position(annotation), offset, length_))
            expand_.add(annotation)
          end
        end
        if (!expand_.is_empty)
          e = expand_.iterator
          while (e.has_next)
            @f_projection_annotation_model.expand(e.next_)
          end
        end
      end
      super(offset, length_, move_cursor)
    end
    
    typesig { [Position, ::Java::Int, ::Java::Int] }
    def will_auto_expand(position, offset, length_)
      if ((position).nil? || position.is_deleted)
        return false
      end
      # right or left boundary
      if ((position.get_offset).equal?(offset) || (position.get_offset + position.get_length).equal?(offset + length_))
        return true
      end
      # completely embedded in given position
      if (position.get_offset < offset && offset + length_ < position.get_offset + position.get_length)
        return true
      end
      return false
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.source.SourceViewer#handleDispose()
    # @since 3.0
    def handle_dispose
      @f_was_projection_enabled = false
      super
    end
    
    typesig { [DocumentEvent] }
    # @see org.eclipse.jface.text.TextViewer#handleVisibleDocumentAboutToBeChanged(org.eclipse.jface.text.DocumentEvent)
    def handle_visible_document_changed(event)
      if (@f_handle_projection_changes && event.is_a?(ProjectionDocumentEvent) && is_projection_mode)
        e = event
        master = e.get_master_event
        if (!(master).nil?)
          @f_replace_visible_document_execution_trigger = master.get_document
        end
        begin
          replace_length = (e.get_text).nil? ? 0 : e.get_text.length
          if ((ProjectionDocumentEvent::PROJECTION_CHANGE).equal?(e.get_change_type))
            if ((e.get_length).equal?(0) && !(replace_length).equal?(0))
              @f_projection_annotation_model.expand_all(e.get_master_offset, e.get_master_length)
            end
          else
            if (!(master).nil? && (replace_length > 0 || @f_deleted_lines > 1))
              begin
                number_of_lines = e.get_document.get_number_of_lines(e.get_offset, replace_length)
                if (number_of_lines > 1 || @f_deleted_lines > 1)
                  @f_projection_annotation_model.expand_all(master.get_offset, master.get_length)
                end
              rescue BadLocationException => x
              end
            end
          end
        ensure
          @f_replace_visible_document_execution_trigger = nil
        end
      end
    end
    
    typesig { [DocumentEvent] }
    # @see org.eclipse.jface.text.TextViewer#handleVisibleDocumentAboutToBeChanged(org.eclipse.jface.text.DocumentEvent)
    # @since 3.1
    def handle_visible_document_about_to_be_changed(event)
      if (@f_handle_projection_changes && event.is_a?(ProjectionDocumentEvent) && is_projection_mode)
        deleted_lines = 0
        begin
          deleted_lines = event.get_document.get_number_of_lines(event.get_offset, event.get_length)
        rescue BadLocationException => e1
          deleted_lines = 0
        end
        @f_deleted_lines = deleted_lines
      end
    end
    
    typesig { [IRegion] }
    # @see org.eclipse.jface.text.ITextViewerExtension5#getCoveredModelRanges(org.eclipse.jface.text.IRegion)
    def get_covered_model_ranges(model_range)
      if ((self.attr_f_information_mapping).nil?)
        return Array.typed(IRegion).new([Region.new(model_range.get_offset, model_range.get_length)])
      end
      if (self.attr_f_information_mapping.is_a?(IDocumentInformationMappingExtension))
        extension = self.attr_f_information_mapping
        begin
          return extension.get_exact_coverage(model_range)
        rescue BadLocationException => x
        end
      end
      return nil
    end
    
    typesig { [::Java::Int] }
    # @see org.eclipse.jface.text.ITextOperationTarget#doOperation(int)
    def do_operation(operation)
      case (operation)
      when TOGGLE
        if (can_do_operation(TOGGLE))
          if (!is_projection_mode)
            enable_projection
          else
            expand_all
            disable_projection
          end
          return
        end
      end
      if (!is_projection_mode)
        super(operation)
        return
      end
      text_widget = get_text_widget
      if ((text_widget).nil?)
        return
      end
      selection = nil
      case (operation)
      when CUT
        if (redraws)
          selection = get_selection
          if (expose_model_range(Region.new(selection.get_offset, selection.get_length)))
            return
          end
          if ((selection.get_length).equal?(0))
            copy_marked_region(true)
          else
            copy_to_clipboard(selection, true, text_widget)
          end
          range = text_widget.get_selection_range
          fire_selection_changed(range.attr_x, range.attr_y)
        end
      when COPY
        if (redraws)
          selection = get_selection
          if ((selection.get_length).equal?(0))
            copy_marked_region(false)
          else
            copy_to_clipboard(selection, false, text_widget)
          end
        end
      when DELETE
        if (redraws)
          begin
            selection = get_selection
            length_ = selection.get_length
            if (!text_widget.get_block_selection && ((length_).equal?(0) || (length_).equal?(text_widget.get_selection_range.attr_y)))
              get_text_widget.invoke_action(ST::DELETE_NEXT)
            else
              delete_selection(selection, text_widget)
            end
            range = text_widget.get_selection_range
            fire_selection_changed(range.attr_x, range.attr_y)
          rescue BadLocationException => x
            # ignore
          end
        end
      when EXPAND_ALL
        if (redraws)
          expand_all
        end
      when EXPAND
        if (redraws)
          expand
        end
      when COLLAPSE_ALL
        if (redraws)
          collapse_all
        end
      when COLLAPSE
        if (redraws)
          collapse
        end
      else
        super(operation)
      end
    end
    
    typesig { [::Java::Int] }
    # @see org.eclipse.jface.text.source.SourceViewer#canDoOperation(int)
    def can_do_operation(operation)
      case (operation)
      when COLLAPSE, COLLAPSE_ALL, EXPAND, EXPAND_ALL
        return is_projection_mode
      when TOGGLE
        return is_projection_mode || !is_segmented
      end
      return super(operation)
    end
    
    typesig { [] }
    def is_segmented
      document = get_document
      length_ = (document).nil? ? 0 : document.get_length
      visible = get_model_coverage
      is_segmented_ = !(visible).nil? && !(visible == Region.new(0, length_))
      return is_segmented_
    end
    
    typesig { [] }
    def get_marked_region
      if ((get_text_widget).nil?)
        return nil
      end
      if ((self.attr_f_mark_position).nil? || self.attr_f_mark_position.is_deleted)
        return nil
      end
      start = self.attr_f_mark_position.get_offset
      end_ = get_selected_range.attr_x
      return start > end_ ? Region.new(end_, start - end_) : Region.new(start, end_ - start)
    end
    
    typesig { [::Java::Boolean] }
    # @see org.eclipse.jface.text.TextViewer#copyMarkedRegion(boolean)
    def copy_marked_region(delete)
      marked_region = get_marked_region
      if (!(marked_region).nil?)
        copy_to_clipboard(TextSelection.new(get_document, marked_region.get_offset, marked_region.get_length), delete, get_text_widget)
      end
    end
    
    typesig { [ITextSelection, ::Java::Boolean, StyledText] }
    def copy_to_clipboard(selection, delete, text_widget)
      copy_text = selection.get_text
      if ((copy_text).nil?)
        # selection.getText failed - backup using widget
        text_widget.copy
      end
      if (!(copy_text).nil? && (copy_text == text_widget.get_selection_text))
        # XXX: Reduce pain of https://bugs.eclipse.org/bugs/show_bug.cgi?id=64498
        # by letting the widget handle the copy operation in this special case.
        text_widget.copy
      else
        if (!(copy_text).nil?)
          clipboard = Clipboard.new(text_widget.get_display)
          begin
            data_types = Array.typed(Transfer).new([TextTransfer.get_instance])
            data = Array.typed(Object).new([copy_text])
            begin
              clipboard.set_contents(data, data_types)
            rescue SWTError => e
              if (!(e.attr_code).equal?(DND::ERROR_CANNOT_SET_CLIPBOARD))
                raise e
              end
              # TODO see https://bugs.eclipse.org/bugs/show_bug.cgi?id=59459
              # we should either log and/or inform the user
              # silently fail for now.
              return
            end
          ensure
            clipboard.dispose
          end
        end
      end
      if (delete)
        begin
          delete_selection(selection, text_widget)
        rescue BadLocationException => x
          # XXX: should log here, but JFace Text has no Log
        end
      end
    end
    
    typesig { [ITextSelection, StyledText] }
    # Deletes the selection and sets the caret before the deleted range.
    # 
    # @param selection the selection to delete
    # @param textWidget the widget
    # @throws BadLocationException on document access failure
    # @since 3.5
    def delete_selection(selection, text_widget)
      SelectionProcessor.new(self).do_delete(selection)
    end
    
    typesig { [Point] }
    # Adapts the behavior of the super class to respect line based folding.
    # 
    # @param widgetSelection the widget selection
    # @return the model selection while respecting line based folding
    def widget_selection2model_selection(widget_selection)
      if (!is_projection_mode)
        return super(widget_selection)
      end
      # There is one requirement that governs preservation of logical
      # positions:
      # 
      # 1) a selection with widget_length == 0 should never expand to have
      # model_length > 0.
      # 
      # There are a number of ambiguities to resolve with projection regions.
      # A projected region P has a widget-length of zero. Its widget offset
      # may interact with the selection S in various ways:
      # 
      # A) P.widget_offset lies at the caret, S.widget_length is zero.
      # Requirement 1 applies. S is *behind* P (done so by widgetRange2ModelRange).
      # 
      # B) P.widget_offset lies inside the widget selection. This case is
      # easy: P is included in S, which is automatically done so by
      # widgetRange2ModelRange.
      # 
      # C) P.widget_offset lies at S.widget_end: This is
      # arguable - our policy is to include P if it belongs to a projection
      # annotation that overlaps with the widget selection.
      # 
      # D) P.widget_offset lies at S.widget_offset: Arguable - our policy
      # is to include P if it belongs to a projection annotation that
      # overlaps with the widget selection
      model_selection = widget_range2model_range(Region.new(widget_selection.attr_x, widget_selection.attr_y))
      if ((model_selection).nil?)
        return nil
      end
      model_offset = model_selection.get_offset
      model_end_offset = model_offset + model_selection.get_length
      # Case A: never expand a zero-length selection. S is *behind* P.
      if ((widget_selection.attr_y).equal?(0))
        return Point.new(model_end_offset, 0)
      end
      widget_selection_exclusive_end = widget_selection.attr_x + widget_selection.attr_y
      annotation_positions = compute_overlapping_annotation_positions(model_selection)
      i = 0
      while i < annotation_positions.attr_length
        regions = compute_collapsed_regions(annotation_positions[i])
        if ((regions).nil?)
          i += 1
          next
        end
        j = 0
        while j < regions.attr_length
          model_range = regions[j]
          widget_range = model_range2closest_widget_range(model_range)
          # only take collapsed ranges, i.e. widget length is 0
          if (!(widget_range).nil? && (widget_range.get_length).equal?(0))
            widget_offset = widget_range.get_offset
            # D) region is collapsed at S.widget_offset
            if ((widget_offset).equal?(widget_selection.attr_x))
              model_offset = Math.min(model_offset, model_range.get_offset)
            # C) region is collapsed at S.widget_end
            else
              if ((widget_offset).equal?(widget_selection_exclusive_end))
                model_end_offset = Math.max(model_end_offset, model_range.get_offset + model_range.get_length)
              end
            end
          end
          j += 1
        end
        i += 1
      end
      return Point.new(model_offset, model_end_offset - model_offset)
    end
    
    typesig { [IRegion] }
    # Returns the positions of all annotations that intersect with
    # <code>modelSelection</code> and that are at least partly visible.
    # @param modelSelection a model range
    # @return the positions of all annotations that intersect with
    # <code>modelSelection</code>
    # @since 3.1
    def compute_overlapping_annotation_positions(model_selection)
      positions = ArrayList.new
      e = @f_projection_annotation_model.get_annotation_iterator
      while e.has_next
        annotation = e.next_
        position = @f_projection_annotation_model.get_position(annotation)
        if (!(position).nil? && position.overlaps_with(model_selection.get_offset, model_selection.get_length) && !(model_range2widget_range(position)).nil?)
          positions.add(position)
        end
      end
      return positions.to_array(Array.typed(Position).new(positions.size) { nil })
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.TextViewer#getFindReplaceDocumentAdapter()
    def get_find_replace_document_adapter
      if ((self.attr_f_find_replace_document_adapter).nil?)
        document = is_projection_mode ? get_document : get_visible_document
        self.attr_f_find_replace_document_adapter = FindReplaceDocumentAdapter.new(document)
      end
      return self.attr_f_find_replace_document_adapter
    end
    
    typesig { [::Java::Int, String, ::Java::Boolean, ::Java::Boolean, ::Java::Boolean, ::Java::Boolean] }
    # @see org.eclipse.jface.text.TextViewer#findAndSelect(int, java.lang.String, boolean, boolean, boolean, boolean)
    def find_and_select(start_position, find_string, forward_search, case_sensitive, whole_word, reg_ex_search)
      if (!is_projection_mode)
        return super(start_position, find_string, forward_search, case_sensitive, whole_word, reg_ex_search)
      end
      text_widget = get_text_widget
      if ((text_widget).nil?)
        return -1
      end
      begin
        match_region = get_find_replace_document_adapter.find(start_position, find_string, forward_search, case_sensitive, whole_word, reg_ex_search)
        if (!(match_region).nil?)
          expose_model_range(match_region)
          reveal_range(match_region.get_offset, match_region.get_length)
          set_selected_range(match_region.get_offset, match_region.get_length)
          return match_region.get_offset
        end
      rescue BadLocationException => x
      end
      return -1
    end
    
    typesig { [::Java::Int, String, ::Java::Boolean, ::Java::Boolean, ::Java::Boolean, ::Java::Int, ::Java::Int, ::Java::Boolean] }
    # @see org.eclipse.jface.text.TextViewer#findAndSelectInRange(int, java.lang.String, boolean, boolean, boolean, int, int, boolean)
    def find_and_select_in_range(start_position, find_string, forward_search, case_sensitive, whole_word, range_offset, range_length, reg_ex_search)
      if (!is_projection_mode)
        return super(start_position, find_string, forward_search, case_sensitive, whole_word, range_offset, range_length, reg_ex_search)
      end
      text_widget = get_text_widget
      if ((text_widget).nil?)
        return -1
      end
      begin
        model_offset = start_position
        if (forward_search && ((start_position).equal?(-1) || start_position < range_offset))
          model_offset = range_offset
        else
          if (!forward_search && ((start_position).equal?(-1) || start_position > range_offset + range_length))
            model_offset = range_offset + range_length
          end
        end
        match_region = get_find_replace_document_adapter.find(model_offset, find_string, forward_search, case_sensitive, whole_word, reg_ex_search)
        if (!(match_region).nil?)
          offset = match_region.get_offset
          length_ = match_region.get_length
          if (range_offset <= offset && offset + length_ <= range_offset + range_length)
            expose_model_range(match_region)
            reveal_range(offset, length_)
            set_selected_range(offset, length_)
            return offset
          end
        end
      rescue BadLocationException => x
      end
      return -1
    end
    
    private
    alias_method :initialize__projection_viewer, :initialize
  end
  
end
