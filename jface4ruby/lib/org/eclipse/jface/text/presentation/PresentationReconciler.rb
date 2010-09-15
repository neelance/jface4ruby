require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Presentation
  module PresentationReconcilerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Presentation
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :Map
      include_const ::Org::Eclipse::Swt::Custom, :StyleRange
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Jface::Text, :BadLocationException
      include_const ::Org::Eclipse::Jface::Text, :BadPositionCategoryException
      include_const ::Org::Eclipse::Jface::Text, :DefaultPositionUpdater
      include_const ::Org::Eclipse::Jface::Text, :DocumentEvent
      include_const ::Org::Eclipse::Jface::Text, :DocumentPartitioningChangedEvent
      include_const ::Org::Eclipse::Jface::Text, :IDocument
      include_const ::Org::Eclipse::Jface::Text, :IDocumentExtension3
      include_const ::Org::Eclipse::Jface::Text, :IDocumentListener
      include_const ::Org::Eclipse::Jface::Text, :IDocumentPartitioningListener
      include_const ::Org::Eclipse::Jface::Text, :IDocumentPartitioningListenerExtension
      include_const ::Org::Eclipse::Jface::Text, :IDocumentPartitioningListenerExtension2
      include_const ::Org::Eclipse::Jface::Text, :IPositionUpdater
      include_const ::Org::Eclipse::Jface::Text, :IRegion
      include_const ::Org::Eclipse::Jface::Text, :ITextInputListener
      include_const ::Org::Eclipse::Jface::Text, :ITextListener
      include_const ::Org::Eclipse::Jface::Text, :ITextViewer
      include_const ::Org::Eclipse::Jface::Text, :ITextViewerExtension5
      include_const ::Org::Eclipse::Jface::Text, :ITypedRegion
      include_const ::Org::Eclipse::Jface::Text, :Region
      include_const ::Org::Eclipse::Jface::Text, :TextEvent
      include_const ::Org::Eclipse::Jface::Text, :TextPresentation
      include_const ::Org::Eclipse::Jface::Text, :TextUtilities
      include_const ::Org::Eclipse::Jface::Text, :TypedPosition
    }
  end
  
  # Standard implementation of <code>IPresentationReconciler</code>. This
  # implementation assumes that the tasks performed by its presentation damagers
  # and repairers are lightweight and of low cost. This presentation reconciler
  # runs in the UI thread and always repairs the complete damage caused by a
  # document change rather than just the portion overlapping with the viewer's
  # viewport.
  # <p>
  # Usually, clients instantiate this class and configure it before using it.
  # </p>
  class PresentationReconciler 
    include_class_members PresentationReconcilerImports
    include IPresentationReconciler
    include IPresentationReconcilerExtension
    
    class_module.module_eval {
      # Prefix of the name of the position category for tracking damage regions.
      const_set_lazy(:TRACKED_PARTITION) { "__reconciler_tracked_partition" }
      const_attr_reader  :TRACKED_PARTITION
      
      # $NON-NLS-1$
      # 
      # Internal listener class.
      const_set_lazy(:InternalListener) { Class.new do
        local_class_in PresentationReconciler
        include_class_members PresentationReconciler
        include ITextInputListener
        include IDocumentListener
        include ITextListener
        include IDocumentPartitioningListener
        include IDocumentPartitioningListenerExtension
        include IDocumentPartitioningListenerExtension2
        
        # Set to <code>true</code> if between a document about to be changed and a changed event.
        attr_accessor :f_document_changing
        alias_method :attr_f_document_changing, :f_document_changing
        undef_method :f_document_changing
        alias_method :attr_f_document_changing=, :f_document_changing=
        undef_method :f_document_changing=
        
        # The cached redraw state of the text viewer.
        # @since 3.0
        attr_accessor :f_cached_redraw_state
        alias_method :attr_f_cached_redraw_state, :f_cached_redraw_state
        undef_method :f_cached_redraw_state
        alias_method :attr_f_cached_redraw_state=, :f_cached_redraw_state=
        undef_method :f_cached_redraw_state=
        
        typesig { [class_self::IDocument, class_self::IDocument] }
        # @see ITextInputListener#inputDocumentAboutToBeChanged(IDocument, IDocument)
        def input_document_about_to_be_changed(old_document, new_document)
          if (!(old_document).nil?)
            begin
              self.attr_f_viewer.remove_text_listener(self)
              old_document.remove_document_listener(self)
              old_document.remove_document_partitioning_listener(self)
              old_document.remove_position_updater(self.attr_f_position_updater)
              old_document.remove_position_category(self.attr_f_position_category)
            rescue self.class::BadPositionCategoryException => x
              # should not happened for former input documents;
            end
          end
        end
        
        typesig { [class_self::IDocument, class_self::IDocument] }
        # @see ITextInputListener#inputDocumenChanged(IDocument, IDocument)
        def input_document_changed(old_document, new_document)
          @f_document_changing = false
          @f_cached_redraw_state = true
          if (!(new_document).nil?)
            new_document.add_position_category(self.attr_f_position_category)
            new_document.add_position_updater(self.attr_f_position_updater)
            new_document.add_document_partitioning_listener(self)
            new_document.add_document_listener(self)
            self.attr_f_viewer.add_text_listener(self)
            set_document_to_damagers(new_document)
            set_document_to_repairers(new_document)
            process_damage(self.class::Region.new(0, new_document.get_length), new_document)
          end
        end
        
        typesig { [class_self::IDocument] }
        # @see IDocumentPartitioningListener#documentPartitioningChanged(IDocument)
        def document_partitioning_changed(document)
          if (!@f_document_changing && @f_cached_redraw_state)
            process_damage(self.class::Region.new(0, document.get_length), document)
          else
            self.attr_f_document_partitioning_changed = true
          end
        end
        
        typesig { [class_self::IDocument, class_self::IRegion] }
        # @see IDocumentPartitioningListenerExtension#documentPartitioningChanged(IDocument, IRegion)
        # @since 2.0
        def document_partitioning_changed(document, changed_region)
          if (!@f_document_changing && @f_cached_redraw_state)
            process_damage(self.class::Region.new(changed_region.get_offset, changed_region.get_length), document)
          else
            self.attr_f_document_partitioning_changed = true
            self.attr_f_changed_document_partitions = changed_region
          end
        end
        
        typesig { [class_self::DocumentPartitioningChangedEvent] }
        # @see org.eclipse.jface.text.IDocumentPartitioningListenerExtension2#documentPartitioningChanged(org.eclipse.jface.text.DocumentPartitioningChangedEvent)
        # @since 3.0
        def document_partitioning_changed(event)
          changed_region = event.get_changed_region(get_document_partitioning)
          if (!(changed_region).nil?)
            document_partitioning_changed(event.get_document, changed_region)
          end
        end
        
        typesig { [class_self::DocumentEvent] }
        # @see IDocumentListener#documentAboutToBeChanged(DocumentEvent)
        def document_about_to_be_changed(e)
          @f_document_changing = true
          if (@f_cached_redraw_state)
            begin
              offset = e.get_offset + e.get_length
              region = get_partition(e.get_document, offset)
              self.attr_f_remembered_position = self.class::TypedPosition.new(region)
              e.get_document.add_position(self.attr_f_position_category, self.attr_f_remembered_position)
            rescue self.class::BadLocationException => x
              # can not happen
            rescue self.class::BadPositionCategoryException => x
              # should not happen on input elements
            end
          end
        end
        
        typesig { [class_self::DocumentEvent] }
        # @see IDocumentListener#documentChanged(DocumentEvent)
        def document_changed(e)
          if (@f_cached_redraw_state)
            begin
              e.get_document.remove_position(self.attr_f_position_category, self.attr_f_remembered_position)
            rescue self.class::BadPositionCategoryException => x
              # can not happen on input documents
            end
          end
          @f_document_changing = false
        end
        
        typesig { [class_self::TextEvent] }
        # @see ITextListener#textChanged(TextEvent)
        def text_changed(e)
          @f_cached_redraw_state = e.get_viewer_redraw_state
          if (!@f_cached_redraw_state)
            return
          end
          damage = nil
          document = nil
          if ((e.get_document_event).nil?)
            document = self.attr_f_viewer.get_document
            if (!(document).nil?)
              if ((e.get_offset).equal?(0) && (e.get_length).equal?(0) && (e.get_text).nil?)
                # redraw state change, damage the whole document
                damage = self.class::Region.new(0, document.get_length)
              else
                region = widget_region2model_region(e)
                begin
                  text = document.get(region.get_offset, region.get_length)
                  de = self.class::DocumentEvent.new(document, region.get_offset, region.get_length, text)
                  damage = get_damage(de, false)
                rescue self.class::BadLocationException => x
                end
              end
            end
          else
            de = e.get_document_event
            document = de.get_document
            damage = get_damage(de, true)
          end
          if (!(damage).nil? && !(document).nil?)
            process_damage(damage, document)
          end
          self.attr_f_document_partitioning_changed = false
          self.attr_f_changed_document_partitions = nil
        end
        
        typesig { [class_self::TextEvent] }
        # Translates the given text event into the corresponding range of the viewer's document.
        # 
        # @param e the text event
        # @return the widget region corresponding the region of the given event
        # @since 2.1
        def widget_region2model_region(e)
          text = e.get_text
          length_ = (text).nil? ? 0 : text.length
          if (self.attr_f_viewer.is_a?(self.class::ITextViewerExtension5))
            extension = self.attr_f_viewer
            return extension.widget_range2model_range(self.class::Region.new(e.get_offset, length_))
          end
          visible = self.attr_f_viewer.get_visible_region
          region = self.class::Region.new(e.get_offset + visible.get_offset, length_)
          return region
        end
        
        typesig { [] }
        def initialize
          @f_document_changing = false
          @f_cached_redraw_state = true
        end
        
        private
        alias_method :initialize__internal_listener, :initialize
      end }
    }
    
    # The map of presentation damagers.
    attr_accessor :f_damagers
    alias_method :attr_f_damagers, :f_damagers
    undef_method :f_damagers
    alias_method :attr_f_damagers=, :f_damagers=
    undef_method :f_damagers=
    
    # The map of presentation repairers.
    attr_accessor :f_repairers
    alias_method :attr_f_repairers, :f_repairers
    undef_method :f_repairers
    alias_method :attr_f_repairers=, :f_repairers=
    undef_method :f_repairers=
    
    # The target viewer.
    attr_accessor :f_viewer
    alias_method :attr_f_viewer, :f_viewer
    undef_method :f_viewer
    alias_method :attr_f_viewer=, :f_viewer=
    undef_method :f_viewer=
    
    # The internal listener.
    attr_accessor :f_internal_listener
    alias_method :attr_f_internal_listener, :f_internal_listener
    undef_method :f_internal_listener
    alias_method :attr_f_internal_listener=, :f_internal_listener=
    undef_method :f_internal_listener=
    
    # The name of the position category to track damage regions.
    attr_accessor :f_position_category
    alias_method :attr_f_position_category, :f_position_category
    undef_method :f_position_category
    alias_method :attr_f_position_category=, :f_position_category=
    undef_method :f_position_category=
    
    # The position updated for the damage regions' position category.
    attr_accessor :f_position_updater
    alias_method :attr_f_position_updater, :f_position_updater
    undef_method :f_position_updater
    alias_method :attr_f_position_updater=, :f_position_updater=
    undef_method :f_position_updater=
    
    # The positions representing the damage regions.
    attr_accessor :f_remembered_position
    alias_method :attr_f_remembered_position, :f_remembered_position
    undef_method :f_remembered_position
    alias_method :attr_f_remembered_position=, :f_remembered_position=
    undef_method :f_remembered_position=
    
    # Flag indicating the receipt of a partitioning changed notification.
    attr_accessor :f_document_partitioning_changed
    alias_method :attr_f_document_partitioning_changed, :f_document_partitioning_changed
    undef_method :f_document_partitioning_changed
    alias_method :attr_f_document_partitioning_changed=, :f_document_partitioning_changed=
    undef_method :f_document_partitioning_changed=
    
    # The range covering the changed partitioning.
    attr_accessor :f_changed_document_partitions
    alias_method :attr_f_changed_document_partitions, :f_changed_document_partitions
    undef_method :f_changed_document_partitions
    alias_method :attr_f_changed_document_partitions=, :f_changed_document_partitions=
    undef_method :f_changed_document_partitions=
    
    # The partitioning used by this presentation reconciler.
    # @since 3.0
    attr_accessor :f_partitioning
    alias_method :attr_f_partitioning, :f_partitioning
    undef_method :f_partitioning
    alias_method :attr_f_partitioning=, :f_partitioning=
    undef_method :f_partitioning=
    
    typesig { [] }
    # Creates a new presentation reconciler. There are no damagers or repairers
    # registered with this reconciler by default. The default partitioning
    # <code>IDocumentExtension3.DEFAULT_PARTITIONING</code> is used.
    def initialize
      @f_damagers = nil
      @f_repairers = nil
      @f_viewer = nil
      @f_internal_listener = InternalListener.new_local(self)
      @f_position_category = nil
      @f_position_updater = nil
      @f_remembered_position = nil
      @f_document_partitioning_changed = false
      @f_changed_document_partitions = nil
      @f_partitioning = nil
      @f_partitioning = RJava.cast_to_string(IDocumentExtension3::DEFAULT_PARTITIONING)
      @f_position_category = TRACKED_PARTITION + RJava.cast_to_string(hash_code)
      @f_position_updater = DefaultPositionUpdater.new(@f_position_category)
    end
    
    typesig { [String] }
    # Sets the document partitioning for this presentation reconciler.
    # 
    # @param partitioning the document partitioning for this presentation reconciler.
    # @since 3.0
    def set_document_partitioning(partitioning)
      Assert.is_not_null(partitioning)
      @f_partitioning = partitioning
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.presentation.IPresentationReconcilerExtension#geDocumenttPartitioning()
    # @since 3.0
    def get_document_partitioning
      return @f_partitioning
    end
    
    typesig { [IPresentationDamager, String] }
    # Registers the given presentation damager for a particular content type.
    # If there is already a damager registered for this type, the old damager
    # is removed first.
    # 
    # @param damager the presentation damager to register, or <code>null</code> to remove an existing one
    # @param contentType the content type under which to register
    def set_damager(damager, content_type)
      Assert.is_not_null(content_type)
      if ((@f_damagers).nil?)
        @f_damagers = HashMap.new
      end
      if ((damager).nil?)
        @f_damagers.remove(content_type)
      else
        @f_damagers.put(content_type, damager)
      end
    end
    
    typesig { [IPresentationRepairer, String] }
    # Registers the given presentation repairer for a particular content type.
    # If there is already a repairer registered for this type, the old repairer
    # is removed first.
    # 
    # @param repairer the presentation repairer to register, or <code>null</code> to remove an existing one
    # @param contentType the content type under which to register
    def set_repairer(repairer, content_type)
      Assert.is_not_null(content_type)
      if ((@f_repairers).nil?)
        @f_repairers = HashMap.new
      end
      if ((repairer).nil?)
        @f_repairers.remove(content_type)
      else
        @f_repairers.put(content_type, repairer)
      end
    end
    
    typesig { [ITextViewer] }
    # @see IPresentationReconciler#install(ITextViewer)
    def install(viewer)
      Assert.is_not_null(viewer)
      @f_viewer = viewer
      @f_viewer.add_text_input_listener(@f_internal_listener)
      document = viewer.get_document
      if (!(document).nil?)
        @f_internal_listener.input_document_changed(nil, document)
      end
    end
    
    typesig { [] }
    # @see IPresentationReconciler#uninstall()
    def uninstall
      @f_viewer.remove_text_input_listener(@f_internal_listener)
      # Ensure we uninstall all listeners
      @f_internal_listener.input_document_about_to_be_changed(@f_viewer.get_document, nil)
    end
    
    typesig { [String] }
    # @see IPresentationReconciler#getDamager(String)
    def get_damager(content_type)
      if ((@f_damagers).nil?)
        return nil
      end
      return @f_damagers.get(content_type)
    end
    
    typesig { [String] }
    # @see IPresentationReconciler#getRepairer(String)
    def get_repairer(content_type)
      if ((@f_repairers).nil?)
        return nil
      end
      return @f_repairers.get(content_type)
    end
    
    typesig { [IDocument] }
    # Informs all registered damagers about the document on which they will work.
    # 
    # @param document the document on which to work
    def set_document_to_damagers(document)
      if (!(@f_damagers).nil?)
        e = @f_damagers.values.iterator
        while (e.has_next)
          damager = e.next_
          damager.set_document(document)
        end
      end
    end
    
    typesig { [IDocument] }
    # Informs all registered repairers about the document on which they will work.
    # 
    # @param document the document on which to work
    def set_document_to_repairers(document)
      if (!(@f_repairers).nil?)
        e = @f_repairers.values.iterator
        while (e.has_next)
          repairer = e.next_
          repairer.set_document(document)
        end
      end
    end
    
    typesig { [IRegion, IDocument] }
    # Constructs a "repair description" for the given damage and returns this
    # description as a text presentation. For this, it queries the partitioning
    # of the damage region and asks the appropriate presentation repairer for
    # each partition to construct the "repair description" for this partition.
    # 
    # @param damage the damage to be repaired
    # @param document the document whose presentation must be repaired
    # @return the presentation repair description as text presentation or
    # <code>null</code> if the partitioning could not be computed
    def create_presentation(damage, document)
      begin
        if ((@f_repairers).nil? || @f_repairers.is_empty)
          presentation = TextPresentation.new(damage, 100)
          presentation.set_default_style_range(StyleRange.new(damage.get_offset, damage.get_length, nil, nil))
          return presentation
        end
        presentation = TextPresentation.new(damage, 1000)
        partitioning = TextUtilities.compute_partitioning(document, get_document_partitioning, damage.get_offset, damage.get_length, false)
        i = 0
        while i < partitioning.attr_length
          r = partitioning[i]
          repairer = get_repairer(r.get_type)
          if (!(repairer).nil?)
            repairer.create_presentation(presentation, r)
          end
          i += 1
        end
        return presentation
      rescue BadLocationException => x
        return nil
      end
    end
    
    typesig { [DocumentEvent, ::Java::Boolean] }
    # Checks for the first and the last affected partition affected by a
    # document event and calls their damagers. Invalidates everything from the
    # start of the damage for the first partition until the end of the damage
    # for the last partition.
    # 
    # @param e the event describing the document change
    # @param optimize <code>true</code> if partition changes should be
    # considered for optimization
    # @return the damaged caused by the change or <code>null</code> if
    # computing the partitioning failed
    # @since 3.0
    def get_damage(e, optimize)
      length = (e.get_text).nil? ? 0 : e.get_text.length
      if ((@f_damagers).nil? || @f_damagers.is_empty)
        length = Math.max(e.get_length, length)
        length = Math.min(e.get_document.get_length - e.get_offset, length)
        return Region.new(e.get_offset, length)
      end
      is_deletion = (length).equal?(0)
      damage = nil
      begin
        offset = e.get_offset
        if (is_deletion)
          offset = Math.max(0, offset - 1)
        end
        partition = get_partition(e.get_document, offset)
        damager = get_damager(partition.get_type)
        if ((damager).nil?)
          return nil
        end
        r = damager.get_damage_region(partition, e, @f_document_partitioning_changed)
        if (!@f_document_partitioning_changed && optimize && !is_deletion)
          damage = r
        else
          damage_end = get_damage_end_offset(e)
          paritition_damage_end = -1
          if (!(@f_changed_document_partitions).nil?)
            paritition_damage_end = @f_changed_document_partitions.get_offset + @f_changed_document_partitions.get_length
          end
          end_ = Math.max(damage_end, paritition_damage_end)
          damage = (end_).equal?(-1) ? r : Region.new(r.get_offset, end_ - r.get_offset)
        end
      rescue BadLocationException => x
      end
      return damage
    end
    
    typesig { [DocumentEvent] }
    # Returns the end offset of the damage. If a partition has been split by
    # the given document event also the second half of the original
    # partition must be considered. This is achieved by using the remembered
    # partition range.
    # 
    # @param e the event describing the change
    # @return the damage end offset (excluding)
    # @exception BadLocationException if method accesses invalid offset
    def get_damage_end_offset(e)
      d = e.get_document
      length = 0
      if (!(e.get_text).nil?)
        length = e.get_text.length
        if (length > 0)
          (length -= 1)
        end
      end
      partition = get_partition(d, e.get_offset + length)
      end_offset = partition.get_offset + partition.get_length
      if ((end_offset).equal?(e.get_offset))
        return -1
      end
      end_ = (@f_remembered_position).nil? ? -1 : @f_remembered_position.get_offset + @f_remembered_position.get_length
      if (end_offset < end_ && end_ < d.get_length)
        partition = get_partition(d, end_)
      end
      damager = get_damager(partition.get_type)
      if ((damager).nil?)
        return -1
      end
      r = damager.get_damage_region(partition, e, @f_document_partitioning_changed)
      return r.get_offset + r.get_length
    end
    
    typesig { [IRegion, IDocument] }
    # Processes the given damage.
    # @param damage the damage to be repaired
    # @param document the document whose presentation must be repaired
    def process_damage(damage, document)
      if (!(damage).nil? && damage.get_length > 0)
        p = create_presentation(damage, document)
        if (!(p).nil?)
          apply_text_region_collection(p)
        end
      end
    end
    
    typesig { [TextPresentation] }
    # Applies the given text presentation to the text viewer the presentation
    # reconciler is installed on.
    # 
    # @param presentation the text presentation to be applied to the text viewer
    def apply_text_region_collection(presentation)
      @f_viewer.change_text_presentation(presentation, false)
    end
    
    typesig { [IDocument, ::Java::Int] }
    # Returns the partition for the given offset in the given document.
    # 
    # @param document the document
    # @param offset the offset
    # @return the partition
    # @throws BadLocationException if offset is invalid in the given document
    # @since 3.0
    def get_partition(document, offset)
      return TextUtilities.get_partition(document, get_document_partitioning, offset, false)
    end
    
    private
    alias_method :initialize__presentation_reconciler, :initialize
  end
  
end
