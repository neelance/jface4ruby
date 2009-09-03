require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text
  module AbstractDocumentImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :Arrays
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :Map
      include_const ::Java::Util::Regex, :PatternSyntaxException
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Core::Runtime, :ListenerList
    }
  end
  
  # Abstract default implementation of <code>IDocument</code> and its extension
  # interfaces {@link org.eclipse.jface.text.IDocumentExtension},
  # {@link org.eclipse.jface.text.IDocumentExtension2},
  # {@link org.eclipse.jface.text.IDocumentExtension3},
  # {@link org.eclipse.jface.text.IDocumentExtension4}, as well as
  # {@link org.eclipse.jface.text.IRepairableDocument}.
  # <p>
  # 
  # An <code>AbstractDocument</code> supports the following implementation
  # plug-ins:
  # <ul>
  # <li>a text store implementing {@link org.eclipse.jface.text.ITextStore} for
  # storing and managing the document's content,</li>
  # <li>a line tracker implementing {@link org.eclipse.jface.text.ILineTracker}
  # to map character positions to line numbers and vice versa</li>
  # </ul>
  # The document can dynamically change the text store when switching between
  # sequential rewrite mode and normal mode.
  # <p>
  # 
  # This class must be subclassed. Subclasses must configure which implementation
  # plug-ins the document instance should use. Subclasses are not intended to
  # overwrite existing methods.
  # 
  # @see org.eclipse.jface.text.ITextStore
  # @see org.eclipse.jface.text.ILineTracker
  class AbstractDocument 
    include_class_members AbstractDocumentImports
    include IDocument
    include IDocumentExtension
    include IDocumentExtension2
    include IDocumentExtension3
    include IDocumentExtension4
    include IRepairableDocument
    include IRepairableDocumentExtension
    
    class_module.module_eval {
      # Tells whether this class is in debug mode.
      # @since 3.1
      const_set_lazy(:DEBUG) { false }
      const_attr_reader  :DEBUG
      
      # Inner class to bundle a registered post notification replace operation together with its
      # owner.
      # 
      # @since 2.0
      const_set_lazy(:RegisteredReplace) { Class.new do
        include_class_members AbstractDocument
        
        # The owner of this replace operation.
        attr_accessor :f_owner
        alias_method :attr_f_owner, :f_owner
        undef_method :f_owner
        alias_method :attr_f_owner=, :f_owner=
        undef_method :f_owner=
        
        # The replace operation
        attr_accessor :f_replace
        alias_method :attr_f_replace, :f_replace
        undef_method :f_replace
        alias_method :attr_f_replace=, :f_replace=
        undef_method :f_replace=
        
        typesig { [class_self::IDocumentListener, class_self::IDocumentExtension::IReplace] }
        # Creates a new bundle object.
        # @param owner the document listener owning the replace operation
        # @param replace the replace operation
        def initialize(owner, replace)
          @f_owner = nil
          @f_replace = nil
          @f_owner = owner
          @f_replace = replace
        end
        
        private
        alias_method :initialize__registered_replace, :initialize
      end }
    }
    
    # The document's text store
    attr_accessor :f_store
    alias_method :attr_f_store, :f_store
    undef_method :f_store
    alias_method :attr_f_store=, :f_store=
    undef_method :f_store=
    
    # The document's line tracker
    attr_accessor :f_tracker
    alias_method :attr_f_tracker, :f_tracker
    undef_method :f_tracker
    alias_method :attr_f_tracker=, :f_tracker=
    undef_method :f_tracker=
    
    # The registered document listeners
    attr_accessor :f_document_listeners
    alias_method :attr_f_document_listeners, :f_document_listeners
    undef_method :f_document_listeners
    alias_method :attr_f_document_listeners=, :f_document_listeners=
    undef_method :f_document_listeners=
    
    # The registered pre-notified document listeners
    attr_accessor :f_prenotified_document_listeners
    alias_method :attr_f_prenotified_document_listeners, :f_prenotified_document_listeners
    undef_method :f_prenotified_document_listeners
    alias_method :attr_f_prenotified_document_listeners=, :f_prenotified_document_listeners=
    undef_method :f_prenotified_document_listeners=
    
    # The registered document partitioning listeners
    attr_accessor :f_document_partitioning_listeners
    alias_method :attr_f_document_partitioning_listeners, :f_document_partitioning_listeners
    undef_method :f_document_partitioning_listeners
    alias_method :attr_f_document_partitioning_listeners=, :f_document_partitioning_listeners=
    undef_method :f_document_partitioning_listeners=
    
    # All positions managed by the document ordered by their start positions.
    attr_accessor :f_positions
    alias_method :attr_f_positions, :f_positions
    undef_method :f_positions
    alias_method :attr_f_positions=, :f_positions=
    undef_method :f_positions=
    
    # All positions managed by the document ordered by there end positions.
    # @since 3.4
    attr_accessor :f_end_positions
    alias_method :attr_f_end_positions, :f_end_positions
    undef_method :f_end_positions
    alias_method :attr_f_end_positions=, :f_end_positions=
    undef_method :f_end_positions=
    
    # All registered document position updaters
    attr_accessor :f_position_updaters
    alias_method :attr_f_position_updaters, :f_position_updaters
    undef_method :f_position_updaters
    alias_method :attr_f_position_updaters=, :f_position_updaters=
    undef_method :f_position_updaters=
    
    # The list of post notification changes
    # @since 2.0
    attr_accessor :f_post_notification_changes
    alias_method :attr_f_post_notification_changes, :f_post_notification_changes
    undef_method :f_post_notification_changes
    alias_method :attr_f_post_notification_changes=, :f_post_notification_changes=
    undef_method :f_post_notification_changes=
    
    # The reentrance count for post notification changes.
    # @since 2.0
    attr_accessor :f_reentrance_count
    alias_method :attr_f_reentrance_count, :f_reentrance_count
    undef_method :f_reentrance_count
    alias_method :attr_f_reentrance_count=, :f_reentrance_count=
    undef_method :f_reentrance_count=
    
    # Indicates whether post notification change processing has been stopped.
    # @since 2.0
    attr_accessor :f_stopped_count
    alias_method :attr_f_stopped_count, :f_stopped_count
    undef_method :f_stopped_count
    alias_method :attr_f_stopped_count=, :f_stopped_count=
    undef_method :f_stopped_count=
    
    # Indicates whether the registration of post notification changes should be ignored.
    # @since 2.1
    attr_accessor :f_accept_post_notification_replaces
    alias_method :attr_f_accept_post_notification_replaces, :f_accept_post_notification_replaces
    undef_method :f_accept_post_notification_replaces
    alias_method :attr_f_accept_post_notification_replaces=, :f_accept_post_notification_replaces=
    undef_method :f_accept_post_notification_replaces=
    
    # Indicates whether the notification of listeners has been stopped.
    # @since 2.1
    attr_accessor :f_stopped_listener_notification
    alias_method :attr_f_stopped_listener_notification, :f_stopped_listener_notification
    undef_method :f_stopped_listener_notification
    alias_method :attr_f_stopped_listener_notification=, :f_stopped_listener_notification=
    undef_method :f_stopped_listener_notification=
    
    # The document event to be sent after listener notification has been resumed.
    # @since 2.1
    attr_accessor :f_deferred_document_event
    alias_method :attr_f_deferred_document_event, :f_deferred_document_event
    undef_method :f_deferred_document_event
    alias_method :attr_f_deferred_document_event=, :f_deferred_document_event=
    undef_method :f_deferred_document_event=
    
    # The registered document partitioners.
    # @since 3.0
    attr_accessor :f_document_partitioners
    alias_method :attr_f_document_partitioners, :f_document_partitioners
    undef_method :f_document_partitioners
    alias_method :attr_f_document_partitioners=, :f_document_partitioners=
    undef_method :f_document_partitioners=
    
    # The partitioning changed event.
    # @since 3.0
    attr_accessor :f_document_partitioning_changed_event
    alias_method :attr_f_document_partitioning_changed_event, :f_document_partitioning_changed_event
    undef_method :f_document_partitioning_changed_event
    alias_method :attr_f_document_partitioning_changed_event=, :f_document_partitioning_changed_event=
    undef_method :f_document_partitioning_changed_event=
    
    # The find/replace document adapter.
    # @since 3.0
    attr_accessor :f_find_replace_document_adapter
    alias_method :attr_f_find_replace_document_adapter, :f_find_replace_document_adapter
    undef_method :f_find_replace_document_adapter
    alias_method :attr_f_find_replace_document_adapter=, :f_find_replace_document_adapter=
    undef_method :f_find_replace_document_adapter=
    
    # The active document rewrite session.
    # @since 3.1
    attr_accessor :f_document_rewrite_session
    alias_method :attr_f_document_rewrite_session, :f_document_rewrite_session
    undef_method :f_document_rewrite_session
    alias_method :attr_f_document_rewrite_session=, :f_document_rewrite_session=
    undef_method :f_document_rewrite_session=
    
    # The registered document rewrite session listeners.
    # @since 3.1
    attr_accessor :f_document_rewrite_session_listeners
    alias_method :attr_f_document_rewrite_session_listeners, :f_document_rewrite_session_listeners
    undef_method :f_document_rewrite_session_listeners
    alias_method :attr_f_document_rewrite_session_listeners=, :f_document_rewrite_session_listeners=
    undef_method :f_document_rewrite_session_listeners=
    
    # The current modification stamp.
    # @since 3.1
    attr_accessor :f_modification_stamp
    alias_method :attr_f_modification_stamp, :f_modification_stamp
    undef_method :f_modification_stamp
    alias_method :attr_f_modification_stamp=, :f_modification_stamp=
    undef_method :f_modification_stamp=
    
    # Keeps track of next modification stamp.
    # @since 3.1.1
    attr_accessor :f_next_modification_stamp
    alias_method :attr_f_next_modification_stamp, :f_next_modification_stamp
    undef_method :f_next_modification_stamp
    alias_method :attr_f_next_modification_stamp=, :f_next_modification_stamp=
    undef_method :f_next_modification_stamp=
    
    # This document's default line delimiter.
    # @since 3.1
    attr_accessor :f_initial_line_delimiter
    alias_method :attr_f_initial_line_delimiter, :f_initial_line_delimiter
    undef_method :f_initial_line_delimiter
    alias_method :attr_f_initial_line_delimiter=, :f_initial_line_delimiter=
    undef_method :f_initial_line_delimiter=
    
    typesig { [] }
    # The default constructor does not perform any configuration
    # but leaves it to the clients who must first initialize the
    # implementation plug-ins and then call <code>completeInitialization</code>.
    # Results in the construction of an empty document.
    def initialize
      @f_store = nil
      @f_tracker = nil
      @f_document_listeners = nil
      @f_prenotified_document_listeners = nil
      @f_document_partitioning_listeners = nil
      @f_positions = nil
      @f_end_positions = nil
      @f_position_updaters = nil
      @f_post_notification_changes = nil
      @f_reentrance_count = 0
      @f_stopped_count = 0
      @f_accept_post_notification_replaces = true
      @f_stopped_listener_notification = 0
      @f_deferred_document_event = nil
      @f_document_partitioners = nil
      @f_document_partitioning_changed_event = nil
      @f_find_replace_document_adapter = nil
      @f_document_rewrite_session = nil
      @f_document_rewrite_session_listeners = nil
      @f_modification_stamp = IDocumentExtension4::UNKNOWN_MODIFICATION_STAMP
      @f_next_modification_stamp = IDocumentExtension4::UNKNOWN_MODIFICATION_STAMP
      @f_initial_line_delimiter = nil
      @f_modification_stamp = get_next_modification_stamp
    end
    
    typesig { [] }
    # Returns the document's text store. Assumes that the
    # document has been initialized with a text store.
    # 
    # @return the document's text store
    def get_store
      Assert.is_not_null(@f_store)
      return @f_store
    end
    
    typesig { [] }
    # Returns the document's line tracker. Assumes that the
    # document has been initialized with a line tracker.
    # 
    # @return the document's line tracker
    def get_tracker
      Assert.is_not_null(@f_tracker)
      return @f_tracker
    end
    
    typesig { [] }
    # Returns the document's document listeners.
    # 
    # @return the document's document listeners
    def get_document_listeners
      return Arrays.as_list(@f_document_listeners.get_listeners)
    end
    
    typesig { [] }
    # Returns the document's partitioning listeners.
    # 
    # @return the document's partitioning listeners
    def get_document_partitioning_listeners
      return Arrays.as_list(@f_document_partitioning_listeners.get_listeners)
    end
    
    typesig { [] }
    # Returns all positions managed by the document grouped by category.
    # 
    # @return the document's positions
    def get_document_managed_positions
      return @f_positions
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.IDocument#getDocumentPartitioner()
    def get_document_partitioner
      return get_document_partitioner(DEFAULT_PARTITIONING)
    end
    
    typesig { [ITextStore] }
    # --- implementation configuration interface ------------
    # 
    # Sets the document's text store.
    # Must be called at the beginning of the constructor.
    # 
    # @param store the document's text store
    def set_text_store(store)
      @f_store = store
    end
    
    typesig { [ILineTracker] }
    # Sets the document's line tracker.
    # Must be called at the beginning of the constructor.
    # 
    # @param tracker the document's line tracker
    def set_line_tracker(tracker)
      @f_tracker = tracker
    end
    
    typesig { [IDocumentPartitioner] }
    # @see org.eclipse.jface.text.IDocument#setDocumentPartitioner(org.eclipse.jface.text.IDocumentPartitioner)
    def set_document_partitioner(partitioner)
      set_document_partitioner(DEFAULT_PARTITIONING, partitioner)
    end
    
    typesig { [] }
    # Initializes document listeners, positions, and position updaters.
    # Must be called inside the constructor after the implementation plug-ins
    # have been set.
    def complete_initialization
      @f_positions = HashMap.new
      @f_end_positions = HashMap.new
      @f_position_updaters = ArrayList.new
      @f_document_listeners = ListenerList.new(ListenerList::IDENTITY)
      @f_prenotified_document_listeners = ListenerList.new(ListenerList::IDENTITY)
      @f_document_partitioning_listeners = ListenerList.new(ListenerList::IDENTITY)
      @f_document_rewrite_session_listeners = ArrayList.new
      add_position_category(DEFAULT_CATEGORY)
      add_position_updater(DefaultPositionUpdater.new(DEFAULT_CATEGORY))
    end
    
    typesig { [IDocumentListener] }
    # -------------------------------------------------------
    # 
    # @see org.eclipse.jface.text.IDocument#addDocumentListener(org.eclipse.jface.text.IDocumentListener)
    def add_document_listener(listener)
      Assert.is_not_null(listener)
      @f_document_listeners.add(listener)
    end
    
    typesig { [IDocumentListener] }
    # @see org.eclipse.jface.text.IDocument#removeDocumentListener(org.eclipse.jface.text.IDocumentListener)
    def remove_document_listener(listener)
      Assert.is_not_null(listener)
      @f_document_listeners.remove(listener)
    end
    
    typesig { [IDocumentListener] }
    # @see org.eclipse.jface.text.IDocument#addPrenotifiedDocumentListener(org.eclipse.jface.text.IDocumentListener)
    def add_prenotified_document_listener(listener)
      Assert.is_not_null(listener)
      @f_prenotified_document_listeners.add(listener)
    end
    
    typesig { [IDocumentListener] }
    # @see org.eclipse.jface.text.IDocument#removePrenotifiedDocumentListener(org.eclipse.jface.text.IDocumentListener)
    def remove_prenotified_document_listener(listener)
      Assert.is_not_null(listener)
      @f_prenotified_document_listeners.remove(listener)
    end
    
    typesig { [IDocumentPartitioningListener] }
    # @see org.eclipse.jface.text.IDocument#addDocumentPartitioningListener(org.eclipse.jface.text.IDocumentPartitioningListener)
    def add_document_partitioning_listener(listener)
      Assert.is_not_null(listener)
      @f_document_partitioning_listeners.add(listener)
    end
    
    typesig { [IDocumentPartitioningListener] }
    # @see org.eclipse.jface.text.IDocument#removeDocumentPartitioningListener(org.eclipse.jface.text.IDocumentPartitioningListener)
    def remove_document_partitioning_listener(listener)
      Assert.is_not_null(listener)
      @f_document_partitioning_listeners.remove(listener)
    end
    
    typesig { [String, Position] }
    # @see org.eclipse.jface.text.IDocument#addPosition(java.lang.String, org.eclipse.jface.text.Position)
    def add_position(category, position)
      if ((0 > position.attr_offset) || (0 > position.attr_length) || (position.attr_offset + position.attr_length > get_length))
        raise BadLocationException.new
      end
      if ((category).nil?)
        raise BadPositionCategoryException.new
      end
      list = @f_positions.get(category)
      if ((list).nil?)
        raise BadPositionCategoryException.new
      end
      list.add(compute_index_in_position_list(list, position.attr_offset), position)
      end_positions = @f_end_positions.get(category)
      if ((end_positions).nil?)
        raise BadPositionCategoryException.new
      end
      end_positions.add(compute_index_in_position_list(end_positions, position.attr_offset + position.attr_length - 1, false), position)
    end
    
    typesig { [Position] }
    # @see org.eclipse.jface.text.IDocument#addPosition(org.eclipse.jface.text.Position)
    def add_position(position)
      begin
        add_position(DEFAULT_CATEGORY, position)
      rescue BadPositionCategoryException => e
      end
    end
    
    typesig { [String] }
    # @see org.eclipse.jface.text.IDocument#addPositionCategory(java.lang.String)
    def add_position_category(category)
      if ((category).nil?)
        return
      end
      if (!contains_position_category(category))
        @f_positions.put(category, ArrayList.new)
        @f_end_positions.put(category, ArrayList.new)
      end
    end
    
    typesig { [IPositionUpdater] }
    # @see org.eclipse.jface.text.IDocument#addPositionUpdater(org.eclipse.jface.text.IPositionUpdater)
    def add_position_updater(updater)
      insert_position_updater(updater, @f_position_updaters.size)
    end
    
    typesig { [String, ::Java::Int, ::Java::Int] }
    # @see org.eclipse.jface.text.IDocument#containsPosition(java.lang.String, int, int)
    def contains_position(category, offset, length)
      if ((category).nil?)
        return false
      end
      list = @f_positions.get(category)
      if ((list).nil?)
        return false
      end
      size_ = list.size
      if ((size_).equal?(0))
        return false
      end
      index = compute_index_in_position_list(list, offset)
      if (index < size_)
        p = list.get(index)
        while (!(p).nil? && (p.attr_offset).equal?(offset))
          if ((p.attr_length).equal?(length))
            return true
          end
          (index += 1)
          p = (index < size_) ? list.get(index) : nil
        end
      end
      return false
    end
    
    typesig { [String] }
    # @see org.eclipse.jface.text.IDocument#containsPositionCategory(java.lang.String)
    def contains_position_category(category)
      if (!(category).nil?)
        return @f_positions.contains_key(category)
      end
      return false
    end
    
    typesig { [JavaList, ::Java::Int] }
    # Computes the index in the list of positions at which a position with the given
    # offset would be inserted. The position is supposed to become the first in this list
    # of all positions with the same offset.
    # 
    # @param positions the list in which the index is computed
    # @param offset the offset for which the index is computed
    # @return the computed index
    # 
    # @see IDocument#computeIndexInCategory(String, int)
    # @deprecated As of 3.4, replaced by {@link #computeIndexInPositionList(List, int, boolean)}
    def compute_index_in_position_list(positions, offset)
      return compute_index_in_position_list(positions, offset, true)
    end
    
    typesig { [JavaList, ::Java::Int, ::Java::Boolean] }
    # Computes the index in the list of positions at which a position with the given
    # position would be inserted. The position to insert is supposed to become the first
    # in this list of all positions with the same position.
    # 
    # @param positions the list in which the index is computed
    # @param offset the offset for which the index is computed
    # @param orderedByOffset <code>true</code> if ordered by offset, false if ordered by end position
    # @return the computed index
    # @since 3.4
    def compute_index_in_position_list(positions, offset, ordered_by_offset)
      if ((positions.size).equal?(0))
        return 0
      end
      left = 0
      right = positions.size - 1
      mid = 0
      p = nil
      while (left < right)
        mid = (left + right) / 2
        p = positions.get(mid)
        p_offset = get_offset(ordered_by_offset, p)
        if (offset < p_offset)
          if ((left).equal?(mid))
            right = left
          else
            right = mid - 1
          end
        else
          if (offset > p_offset)
            if ((right).equal?(mid))
              left = right
            else
              left = mid + 1
            end
          else
            if ((offset).equal?(p_offset))
              left = right = mid
            end
          end
        end
      end
      pos = left
      p = positions.get(pos)
      p_position = get_offset(ordered_by_offset, p)
      if (offset > p_position)
        # append to the end
        pos += 1
      else
        # entry will become the first of all entries with the same offset
        begin
          (pos -= 1)
          if (pos < 0)
            break
          end
          p = positions.get(pos)
          p_position = get_offset(ordered_by_offset, p)
        end while ((offset).equal?(p_position))
        (pos += 1)
      end
      Assert.is_true(0 <= pos && pos <= positions.size)
      return pos
    end
    
    typesig { [::Java::Boolean, Position] }
    # @since 3.4
    def get_offset(ordered_by_offset, position)
      if (ordered_by_offset || (position.get_length).equal?(0))
        return position.get_offset
      end
      return position.get_offset + position.get_length - 1
    end
    
    typesig { [String, ::Java::Int] }
    # @see org.eclipse.jface.text.IDocument#computeIndexInCategory(java.lang.String, int)
    def compute_index_in_category(category, offset)
      if (0 > offset || offset > get_length)
        raise BadLocationException.new
      end
      c = @f_positions.get(category)
      if ((c).nil?)
        raise BadPositionCategoryException.new
      end
      return compute_index_in_position_list(c, offset)
    end
    
    typesig { [] }
    # Fires the document partitioning changed notification to all registered
    # document partitioning listeners. Uses a robust iterator.
    # 
    # @deprecated as of 2.0. Use <code>fireDocumentPartitioningChanged(IRegion)</code> instead.
    def fire_document_partitioning_changed
      if ((@f_document_partitioning_listeners).nil?)
        return
      end
      listeners = @f_document_partitioning_listeners.get_listeners
      i = 0
      while i < listeners.attr_length
        (listeners[i]).document_partitioning_changed(self)
        i += 1
      end
    end
    
    typesig { [IRegion] }
    # Fires the document partitioning changed notification to all registered
    # document partitioning listeners. Uses a robust iterator.
    # 
    # @param region the region in which partitioning has changed
    # 
    # @see IDocumentPartitioningListenerExtension
    # @since 2.0
    # @deprecated as of 3.0. Use
    # <code>fireDocumentPartitioningChanged(DocumentPartitioningChangedEvent)</code>
    # instead.
    def fire_document_partitioning_changed(region)
      if ((@f_document_partitioning_listeners).nil?)
        return
      end
      listeners = @f_document_partitioning_listeners.get_listeners
      i = 0
      while i < listeners.attr_length
        l = listeners[i]
        if (l.is_a?(IDocumentPartitioningListenerExtension))
          (l).document_partitioning_changed(self, region)
        else
          l.document_partitioning_changed(self)
        end
        i += 1
      end
    end
    
    typesig { [DocumentPartitioningChangedEvent] }
    # Fires the document partitioning changed notification to all registered
    # document partitioning listeners. Uses a robust iterator.
    # 
    # @param event the document partitioning changed event
    # 
    # @see IDocumentPartitioningListenerExtension2
    # @since 3.0
    def fire_document_partitioning_changed(event)
      if ((@f_document_partitioning_listeners).nil?)
        return
      end
      listeners = @f_document_partitioning_listeners.get_listeners
      i = 0
      while i < listeners.attr_length
        l = listeners[i]
        if (l.is_a?(IDocumentPartitioningListenerExtension2))
          extension2 = l
          extension2.document_partitioning_changed(event)
        else
          if (l.is_a?(IDocumentPartitioningListenerExtension))
            extension = l
            extension.document_partitioning_changed(self, event.get_coverage)
          else
            l.document_partitioning_changed(self)
          end
        end
        i += 1
      end
    end
    
    typesig { [DocumentEvent] }
    # Fires the given document event to all registers document listeners informing them
    # about the forthcoming document manipulation. Uses a robust iterator.
    # 
    # @param event the event to be sent out
    def fire_document_about_to_be_changed(event)
      # IDocumentExtension
      if ((@f_reentrance_count).equal?(0))
        flush_post_notification_changes
      end
      if (!(@f_document_partitioners).nil?)
        e = @f_document_partitioners.values.iterator
        while (e.has_next)
          p = e.next_
          if (p.is_a?(IDocumentPartitionerExtension3))
            extension = p
            if (!(extension.get_active_rewrite_session).nil?)
              next
            end
          end
          p.document_about_to_be_changed(event)
        end
      end
      listeners = @f_prenotified_document_listeners.get_listeners
      i = 0
      while i < listeners.attr_length
        (listeners[i]).document_about_to_be_changed(event)
        i += 1
      end
      listeners = @f_document_listeners.get_listeners
      i_ = 0
      while i_ < listeners.attr_length
        (listeners[i_]).document_about_to_be_changed(event)
        i_ += 1
      end
    end
    
    typesig { [DocumentEvent] }
    # Updates document partitioning and document positions according to the
    # specification given by the document event.
    # 
    # @param event the document event describing the change to which structures must be adapted
    def update_document_structures(event)
      if (!(@f_document_partitioners).nil?)
        @f_document_partitioning_changed_event = DocumentPartitioningChangedEvent.new(self)
        e = @f_document_partitioners.key_set.iterator
        while (e.has_next)
          partitioning = e.next_
          partitioner = @f_document_partitioners.get(partitioning)
          if (partitioner.is_a?(IDocumentPartitionerExtension3))
            extension = partitioner
            if (!(extension.get_active_rewrite_session).nil?)
              next
            end
          end
          if (partitioner.is_a?(IDocumentPartitionerExtension))
            extension = partitioner
            r = extension.document_changed2(event)
            if (!(r).nil?)
              @f_document_partitioning_changed_event.set_partition_change(partitioning, r.get_offset, r.get_length)
            end
          else
            if (partitioner.document_changed(event))
              @f_document_partitioning_changed_event.set_partition_change(partitioning, 0, event.get_document.get_length)
            end
          end
        end
      end
      if (@f_positions.size > 0)
        update_positions(event)
      end
    end
    
    typesig { [DocumentEvent] }
    # Notifies all listeners about the given document change. Uses a robust
    # iterator.
    # <p>
    # Executes all registered post notification replace operation.
    # 
    # @param event the event to be sent out.
    def do_fire_document_changed(event)
      changed = !(@f_document_partitioning_changed_event).nil? && !@f_document_partitioning_changed_event.is_empty
      change = changed ? @f_document_partitioning_changed_event.get_coverage : nil
      do_fire_document_changed(event, changed, change)
    end
    
    typesig { [DocumentEvent, ::Java::Boolean, IRegion] }
    # Notifies all listeners about the given document change.
    # Uses a robust iterator. <p>
    # Executes all registered post notification replace operation.
    # 
    # @param event the event to be sent out
    # @param firePartitionChange <code>true</code> if a partition change notification should be sent
    # @param partitionChange the region whose partitioning changed
    # @since 2.0
    # @deprecated as of 3.0. Use <code>doFireDocumentChanged2(DocumentEvent)</code> instead; this method will be removed.
    def do_fire_document_changed(event, fire_partition_change, partition_change)
      do_fire_document_changed2(event)
    end
    
    typesig { [DocumentEvent] }
    # Notifies all listeners about the given document change. Uses a robust
    # iterator.
    # <p>
    # Executes all registered post notification replace operation.
    # <p>
    # This method will be renamed to <code>doFireDocumentChanged</code>.
    # 
    # @param event the event to be sent out
    # @since 3.0
    def do_fire_document_changed2(event)
      p = @f_document_partitioning_changed_event
      @f_document_partitioning_changed_event = nil
      if (!(p).nil? && !p.is_empty)
        fire_document_partitioning_changed(p)
      end
      listeners = @f_prenotified_document_listeners.get_listeners
      i = 0
      while i < listeners.attr_length
        (listeners[i]).document_changed(event)
        i += 1
      end
      listeners = @f_document_listeners.get_listeners
      i_ = 0
      while i_ < listeners.attr_length
        (listeners[i_]).document_changed(event)
        i_ += 1
      end
      # IDocumentExtension
      (@f_reentrance_count += 1)
      begin
        if ((@f_reentrance_count).equal?(1))
          execute_post_notification_changes
        end
      ensure
        (@f_reentrance_count -= 1)
      end
    end
    
    typesig { [DocumentEvent] }
    # Updates the internal document structures and informs all document listeners
    # if listener notification has been enabled. Otherwise it remembers the event
    # to be sent to the listeners on resume.
    # 
    # @param event the document event to be sent out
    def fire_document_changed(event)
      update_document_structures(event)
      if ((@f_stopped_listener_notification).equal?(0))
        do_fire_document_changed(event)
      else
        @f_deferred_document_event = event
      end
    end
    
    typesig { [::Java::Int] }
    # @see org.eclipse.jface.text.IDocument#getChar(int)
    def get_char(pos)
      if ((0 > pos) || (pos >= get_length))
        raise BadLocationException.new
      end
      return get_store.get(pos)
    end
    
    typesig { [::Java::Int] }
    # @see org.eclipse.jface.text.IDocument#getContentType(int)
    def get_content_type(offset)
      content_type = nil
      begin
        content_type = RJava.cast_to_string(get_content_type(DEFAULT_PARTITIONING, offset, false))
        Assert.is_not_null(content_type)
      rescue BadPartitioningException => e
        Assert.is_true(false)
      end
      return content_type
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.IDocument#getLegalContentTypes()
    def get_legal_content_types
      content_types = nil
      begin
        content_types = get_legal_content_types(DEFAULT_PARTITIONING)
        Assert.is_not_null(content_types)
      rescue BadPartitioningException => e
        Assert.is_true(false)
      end
      return content_types
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.IDocument#getLength()
    def get_length
      return get_store.get_length
    end
    
    typesig { [::Java::Int] }
    # @see org.eclipse.jface.text.IDocument#getLineDelimiter(int)
    def get_line_delimiter(line)
      return get_tracker.get_line_delimiter(line)
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.IDocument#getLegalLineDelimiters()
    def get_legal_line_delimiters
      return get_tracker.get_legal_line_delimiters
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.IDocumentExtension4#getDefaultLineDelimiter()
    # @since 3.1
    def get_default_line_delimiter
      line_delimiter = nil
      begin
        line_delimiter = RJava.cast_to_string(get_line_delimiter(0))
      rescue BadLocationException => x
      end
      if (!(line_delimiter).nil?)
        return line_delimiter
      end
      if (!(@f_initial_line_delimiter).nil?)
        return @f_initial_line_delimiter
      end
      sys_line_delimiter = System.get_property("line.separator") # $NON-NLS-1$
      delimiters = get_legal_line_delimiters
      Assert.is_true(delimiters.attr_length > 0)
      i = 0
      while i < delimiters.attr_length
        if ((delimiters[i] == sys_line_delimiter))
          line_delimiter = sys_line_delimiter
          break
        end
        i += 1
      end
      if ((line_delimiter).nil?)
        line_delimiter = RJava.cast_to_string(delimiters[0])
      end
      return line_delimiter
    end
    
    typesig { [String] }
    # @see org.eclipse.jface.text.IDocumentExtension4#setInitialLineDelimiter(java.lang.String)
    # @since 3.1
    def set_initial_line_delimiter(line_delimiter)
      Assert.is_not_null(line_delimiter)
      @f_initial_line_delimiter = line_delimiter
    end
    
    typesig { [::Java::Int] }
    # @see org.eclipse.jface.text.IDocument#getLineLength(int)
    def get_line_length(line)
      return get_tracker.get_line_length(line)
    end
    
    typesig { [::Java::Int] }
    # @see org.eclipse.jface.text.IDocument#getLineOfOffset(int)
    def get_line_of_offset(pos)
      return get_tracker.get_line_number_of_offset(pos)
    end
    
    typesig { [::Java::Int] }
    # @see org.eclipse.jface.text.IDocument#getLineOffset(int)
    def get_line_offset(line)
      return get_tracker.get_line_offset(line)
    end
    
    typesig { [::Java::Int] }
    # @see org.eclipse.jface.text.IDocument#getLineInformation(int)
    def get_line_information(line)
      return get_tracker.get_line_information(line)
    end
    
    typesig { [::Java::Int] }
    # @see org.eclipse.jface.text.IDocument#getLineInformationOfOffset(int)
    def get_line_information_of_offset(offset)
      return get_tracker.get_line_information_of_offset(offset)
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.IDocument#getNumberOfLines()
    def get_number_of_lines
      return get_tracker.get_number_of_lines
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # @see org.eclipse.jface.text.IDocument#getNumberOfLines(int, int)
    def get_number_of_lines(offset, length)
      return get_tracker.get_number_of_lines(offset, length)
    end
    
    typesig { [String] }
    # @see org.eclipse.jface.text.IDocument#computeNumberOfLines(java.lang.String)
    def compute_number_of_lines(text)
      return get_tracker.compute_number_of_lines(text)
    end
    
    typesig { [::Java::Int] }
    # @see org.eclipse.jface.text.IDocument#getPartition(int)
    def get_partition(offset)
      partition = nil
      begin
        partition = get_partition(DEFAULT_PARTITIONING, offset, false)
        Assert.is_not_null(partition)
      rescue BadPartitioningException => e
        Assert.is_true(false)
      end
      return partition
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # @see org.eclipse.jface.text.IDocument#computePartitioning(int, int)
    def compute_partitioning(offset, length)
      partitioning = nil
      begin
        partitioning = compute_partitioning(DEFAULT_PARTITIONING, offset, length, false)
        Assert.is_not_null(partitioning)
      rescue BadPartitioningException => e
        Assert.is_true(false)
      end
      return partitioning
    end
    
    typesig { [String] }
    # @see org.eclipse.jface.text.IDocument#getPositions(java.lang.String)
    def get_positions(category)
      if ((category).nil?)
        raise BadPositionCategoryException.new
      end
      c = @f_positions.get(category)
      if ((c).nil?)
        raise BadPositionCategoryException.new
      end
      positions = Array.typed(Position).new(c.size) { nil }
      c.to_array(positions)
      return positions
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.IDocument#getPositionCategories()
    def get_position_categories
      categories = Array.typed(String).new(@f_positions.size) { nil }
      keys = @f_positions.key_set.iterator
      i = 0
      while i < categories.attr_length
        categories[i] = keys.next_
        i += 1
      end
      return categories
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.IDocument#getPositionUpdaters()
    def get_position_updaters
      updaters = Array.typed(IPositionUpdater).new(@f_position_updaters.size) { nil }
      @f_position_updaters.to_array(updaters)
      return updaters
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.IDocument#get()
    def get
      return get_store.get(0, get_length)
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # @see org.eclipse.jface.text.IDocument#get(int, int)
    def get(pos, length)
      my_length = get_length
      if ((0 > pos) || (0 > length) || (pos + length > my_length))
        raise BadLocationException.new
      end
      return get_store.get(pos, length)
    end
    
    typesig { [IPositionUpdater, ::Java::Int] }
    # @see org.eclipse.jface.text.IDocument#insertPositionUpdater(org.eclipse.jface.text.IPositionUpdater, int)
    def insert_position_updater(updater, index)
      i = @f_position_updaters.size - 1
      while i >= 0
        if ((@f_position_updaters.get(i)).equal?(updater))
          return
        end
        i -= 1
      end
      if ((index).equal?(@f_position_updaters.size))
        @f_position_updaters.add(updater)
      else
        @f_position_updaters.add(index, updater)
      end
    end
    
    typesig { [String, Position] }
    # @see org.eclipse.jface.text.IDocument#removePosition(java.lang.String, org.eclipse.jface.text.Position)
    def remove_position(category, position)
      if ((position).nil?)
        return
      end
      if ((category).nil?)
        raise BadPositionCategoryException.new
      end
      c = @f_positions.get(category)
      if ((c).nil?)
        raise BadPositionCategoryException.new
      end
      remove_from_positions_list(c, position, true)
      end_positions = @f_end_positions.get(category)
      if ((end_positions).nil?)
        raise BadPositionCategoryException.new
      end
      remove_from_positions_list(end_positions, position, false)
    end
    
    typesig { [JavaList, Position, ::Java::Boolean] }
    # Remove the given position form the given list of positions based on identity not equality.
    # 
    # @param positions a list of positions
    # @param position the position to remove
    # @param orderedByOffset true if <code>positions</code> is ordered by offset, false if ordered by end position
    # @since 3.4
    def remove_from_positions_list(positions, position, ordered_by_offset)
      size_ = positions.size
      # Assume position is somewhere near it was before
      index = compute_index_in_position_list(positions, ordered_by_offset ? position.attr_offset : position.attr_offset + position.attr_length - 1, ordered_by_offset)
      if (index < size_ && (positions.get(index)).equal?(position))
        positions.remove(index)
        return
      end
      back = index - 1
      forth = index + 1
      while (back >= 0 || forth < size_)
        if (back >= 0)
          if ((position).equal?(positions.get(back)))
            positions.remove(back)
            return
          end
          back -= 1
        end
        if (forth < size_)
          if ((position).equal?(positions.get(forth)))
            positions.remove(forth)
            return
          end
          forth += 1
        end
      end
    end
    
    typesig { [Position] }
    # @see org.eclipse.jface.text.IDocument#removePosition(org.eclipse.jface.text.Position)
    def remove_position(position)
      begin
        remove_position(DEFAULT_CATEGORY, position)
      rescue BadPositionCategoryException => e
      end
    end
    
    typesig { [String] }
    # @see org.eclipse.jface.text.IDocument#removePositionCategory(java.lang.String)
    def remove_position_category(category)
      if ((category).nil?)
        return
      end
      if (!contains_position_category(category))
        raise BadPositionCategoryException.new
      end
      @f_positions.remove(category)
      @f_end_positions.remove(category)
    end
    
    typesig { [IPositionUpdater] }
    # @see org.eclipse.jface.text.IDocument#removePositionUpdater(org.eclipse.jface.text.IPositionUpdater)
    def remove_position_updater(updater)
      i = @f_position_updaters.size - 1
      while i >= 0
        if ((@f_position_updaters.get(i)).equal?(updater))
          @f_position_updaters.remove(i)
          return
        end
        i -= 1
      end
    end
    
    typesig { [] }
    def get_next_modification_stamp
      if ((@f_next_modification_stamp).equal?(Long::MAX_VALUE) || (@f_next_modification_stamp).equal?(IDocumentExtension4::UNKNOWN_MODIFICATION_STAMP))
        @f_next_modification_stamp = 0
      else
        @f_next_modification_stamp = @f_next_modification_stamp + 1
      end
      return @f_next_modification_stamp
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.IDocumentExtension4#getModificationStamp()
    # @since 3.1
    def get_modification_stamp
      return @f_modification_stamp
    end
    
    typesig { [::Java::Int, ::Java::Int, String, ::Java::Long] }
    # @see org.eclipse.jface.text.IDocument#replace(int, int, java.lang.String)
    # @since 3.1
    def replace(pos, length, text, modification_stamp)
      if ((0 > pos) || (0 > length) || (pos + length > get_length))
        raise BadLocationException.new
      end
      e = DocumentEvent.new(self, pos, length, text)
      fire_document_about_to_be_changed(e)
      get_store.replace(pos, length, text)
      get_tracker.replace(pos, length, text)
      @f_modification_stamp = modification_stamp
      @f_next_modification_stamp = Math.max(@f_modification_stamp, @f_next_modification_stamp)
      e.attr_f_modification_stamp = @f_modification_stamp
      fire_document_changed(e)
    end
    
    typesig { [::Java::Int, ::Java::Int, String] }
    # {@inheritDoc}
    # 
    # @since 3.4
    def is_line_information_repair_needed(offset, length, text)
      return false
    end
    
    typesig { [::Java::Int, ::Java::Int, String] }
    # @see org.eclipse.jface.text.IDocument#replace(int, int, java.lang.String)
    def replace(pos, length, text)
      if ((length).equal?(0) && ((text).nil? || (text.length).equal?(0)))
        replace(pos, length, text, get_modification_stamp)
      else
        replace(pos, length, text, get_next_modification_stamp)
      end
    end
    
    typesig { [String] }
    # @see org.eclipse.jface.text.IDocument#set(java.lang.String)
    def set(text)
      set(text, get_next_modification_stamp)
    end
    
    typesig { [String, ::Java::Long] }
    # @see org.eclipse.jface.text.IDocumentExtension4#set(java.lang.String, long)
    # @since 3.1
    def set(text, modification_stamp)
      length_ = get_store.get_length
      e = DocumentEvent.new(self, 0, length_, text)
      fire_document_about_to_be_changed(e)
      get_store.set(text)
      get_tracker.set(text)
      @f_modification_stamp = modification_stamp
      @f_next_modification_stamp = Math.max(@f_modification_stamp, @f_next_modification_stamp)
      e.attr_f_modification_stamp = @f_modification_stamp
      fire_document_changed(e)
    end
    
    typesig { [DocumentEvent] }
    # Updates all positions of all categories to the change described by the
    # document event. All registered document updaters are called in the
    # sequence they have been arranged. Uses a robust iterator.
    # 
    # @param event the document event describing the change to which to adapt
    # the positions
    def update_positions(event)
      list = ArrayList.new(@f_position_updaters)
      e = list.iterator
      while (e.has_next)
        u = e.next_
        u.update(event)
      end
    end
    
    typesig { [::Java::Int, String, ::Java::Boolean, ::Java::Boolean, ::Java::Boolean] }
    # {@inheritDoc}
    # 
    # @deprecated as of 3.0 search is provided by {@link FindReplaceDocumentAdapter}
    def search(start_position, find_string, forward_search, case_sensitive, whole_word)
      begin
        region = get_find_replace_document_adapter.find(start_position, find_string, forward_search, case_sensitive, whole_word, false)
        return (region).nil? ? -1 : region.get_offset
      rescue IllegalStateException => ex
        return -1
      rescue PatternSyntaxException => ex
        return -1
      end
    end
    
    typesig { [] }
    # Returns the find/replace adapter for this document.
    # 
    # @return this document's find/replace document adapter
    # @since 3.0
    def get_find_replace_document_adapter
      if ((@f_find_replace_document_adapter).nil?)
        @f_find_replace_document_adapter = FindReplaceDocumentAdapter.new(self)
      end
      return @f_find_replace_document_adapter
    end
    
    typesig { [] }
    # Flushes all registered post notification changes.
    # 
    # @since 2.0
    def flush_post_notification_changes
      if (!(@f_post_notification_changes).nil?)
        @f_post_notification_changes.clear
      end
    end
    
    typesig { [] }
    # Executes all registered post notification changes. The process is
    # repeated until no new post notification changes are added.
    # 
    # @since 2.0
    def execute_post_notification_changes
      if (@f_stopped_count > 0)
        return
      end
      while (!(@f_post_notification_changes).nil?)
        changes = @f_post_notification_changes
        @f_post_notification_changes = nil
        e = changes.iterator
        while (e.has_next)
          replace_ = e.next_
          replace_.attr_f_replace.perform(self, replace_.attr_f_owner)
        end
      end
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.IDocumentExtension2#acceptPostNotificationReplaces()
    # @since 2.1
    def accept_post_notification_replaces
      @f_accept_post_notification_replaces = true
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.IDocumentExtension2#ignorePostNotificationReplaces()
    # @since 2.1
    def ignore_post_notification_replaces
      @f_accept_post_notification_replaces = false
    end
    
    typesig { [IDocumentListener, IDocumentExtension::IReplace] }
    # @see org.eclipse.jface.text.IDocumentExtension#registerPostNotificationReplace(org.eclipse.jface.text.IDocumentListener, org.eclipse.jface.text.IDocumentExtension.IReplace)
    # @since 2.0
    def register_post_notification_replace(owner, replace_)
      if (@f_accept_post_notification_replaces)
        if ((@f_post_notification_changes).nil?)
          @f_post_notification_changes = ArrayList.new(1)
        end
        @f_post_notification_changes.add(RegisteredReplace.new(owner, replace_))
      end
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.IDocumentExtension#stopPostNotificationProcessing()
    # @since 2.0
    def stop_post_notification_processing
      (@f_stopped_count += 1)
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.IDocumentExtension#resumePostNotificationProcessing()
    # @since 2.0
    def resume_post_notification_processing
      (@f_stopped_count -= 1)
      if ((@f_stopped_count).equal?(0) && (@f_reentrance_count).equal?(0))
        execute_post_notification_changes
      end
    end
    
    typesig { [::Java::Boolean] }
    # {@inheritDoc}
    # 
    # @since 2.0
    # @deprecated since 3.1. Use
    # {@link IDocumentExtension4#startRewriteSession(DocumentRewriteSessionType)}
    # instead.
    def start_sequential_rewrite(normalized)
    end
    
    typesig { [] }
    # {@inheritDoc}
    # 
    # @since 2.0
    # @deprecated As of 3.1, replaced by {@link IDocumentExtension4#stopRewriteSession(DocumentRewriteSession)}
    def stop_sequential_rewrite
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.IDocumentExtension2#resumeListenerNotification()
    # @since 2.1
    def resume_listener_notification
      (@f_stopped_listener_notification -= 1)
      if ((@f_stopped_listener_notification).equal?(0))
        resume_document_listener_notification
      end
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.IDocumentExtension2#stopListenerNotification()
    # @since 2.1
    def stop_listener_notification
      (@f_stopped_listener_notification += 1)
    end
    
    typesig { [] }
    # Resumes the document listener notification by sending out the remembered
    # partition changed and document event.
    # 
    # @since 2.1
    def resume_document_listener_notification
      if (!(@f_deferred_document_event).nil?)
        event = @f_deferred_document_event
        @f_deferred_document_event = nil
        do_fire_document_changed(event)
      end
    end
    
    typesig { [String, ::Java::Int, ::Java::Int, ::Java::Boolean] }
    # @see org.eclipse.jface.text.IDocumentExtension3#computeZeroLengthPartitioning(java.lang.String, int, int)
    # @since 3.0
    def compute_partitioning(partitioning, offset, length_, include_zero_length_partitions)
      if ((0 > offset) || (0 > length_) || (offset + length_ > get_length))
        raise BadLocationException.new
      end
      partitioner = get_document_partitioner(partitioning)
      if (partitioner.is_a?(IDocumentPartitionerExtension2))
        check_state_of_partitioner(partitioner, partitioning)
        return (partitioner).compute_partitioning(offset, length_, include_zero_length_partitions)
      else
        if (!(partitioner).nil?)
          check_state_of_partitioner(partitioner, partitioning)
          return partitioner.compute_partitioning(offset, length_)
        else
          if ((DEFAULT_PARTITIONING == partitioning))
            return Array.typed(TypedRegion).new([TypedRegion.new(offset, length_, DEFAULT_CONTENT_TYPE)])
          else
            raise BadPartitioningException.new
          end
        end
      end
    end
    
    typesig { [String, ::Java::Int, ::Java::Boolean] }
    # @see org.eclipse.jface.text.IDocumentExtension3#getZeroLengthContentType(java.lang.String, int)
    # @since 3.0
    def get_content_type(partitioning, offset, prefer_open_partitions)
      if ((0 > offset) || (offset > get_length))
        raise BadLocationException.new
      end
      partitioner = get_document_partitioner(partitioning)
      if (partitioner.is_a?(IDocumentPartitionerExtension2))
        check_state_of_partitioner(partitioner, partitioning)
        return (partitioner).get_content_type(offset, prefer_open_partitions)
      else
        if (!(partitioner).nil?)
          check_state_of_partitioner(partitioner, partitioning)
          return partitioner.get_content_type(offset)
        else
          if ((DEFAULT_PARTITIONING == partitioning))
            return DEFAULT_CONTENT_TYPE
          else
            raise BadPartitioningException.new
          end
        end
      end
    end
    
    typesig { [String] }
    # @see org.eclipse.jface.text.IDocumentExtension3#getDocumentPartitioner(java.lang.String)
    # @since 3.0
    def get_document_partitioner(partitioning)
      return !(@f_document_partitioners).nil? ? @f_document_partitioners.get(partitioning) : nil
    end
    
    typesig { [String] }
    # @see org.eclipse.jface.text.IDocumentExtension3#getLegalContentTypes(java.lang.String)
    # @since 3.0
    def get_legal_content_types(partitioning)
      partitioner = get_document_partitioner(partitioning)
      if (!(partitioner).nil?)
        return partitioner.get_legal_content_types
      end
      if ((DEFAULT_PARTITIONING == partitioning))
        return Array.typed(String).new([DEFAULT_CONTENT_TYPE])
      end
      raise BadPartitioningException.new
    end
    
    typesig { [String, ::Java::Int, ::Java::Boolean] }
    # @see org.eclipse.jface.text.IDocumentExtension3#getZeroLengthPartition(java.lang.String, int)
    # @since 3.0
    def get_partition(partitioning, offset, prefer_open_partitions)
      if ((0 > offset) || (offset > get_length))
        raise BadLocationException.new
      end
      partitioner = get_document_partitioner(partitioning)
      if (partitioner.is_a?(IDocumentPartitionerExtension2))
        check_state_of_partitioner(partitioner, partitioning)
        return (partitioner).get_partition(offset, prefer_open_partitions)
      else
        if (!(partitioner).nil?)
          check_state_of_partitioner(partitioner, partitioning)
          return partitioner.get_partition(offset)
        else
          if ((DEFAULT_PARTITIONING == partitioning))
            return TypedRegion.new(0, get_length, DEFAULT_CONTENT_TYPE)
          else
            raise BadPartitioningException.new
          end
        end
      end
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.IDocumentExtension3#getPartitionings()
    # @since 3.0
    def get_partitionings
      if ((@f_document_partitioners).nil?)
        return Array.typed(String).new(0) { nil }
      end
      partitionings = Array.typed(String).new(@f_document_partitioners.size) { nil }
      @f_document_partitioners.key_set.to_array(partitionings)
      return partitionings
    end
    
    typesig { [String, IDocumentPartitioner] }
    # @see org.eclipse.jface.text.IDocumentExtension3#setDocumentPartitioner(java.lang.String, org.eclipse.jface.text.IDocumentPartitioner)
    # @since 3.0
    def set_document_partitioner(partitioning, partitioner)
      if ((partitioner).nil?)
        if (!(@f_document_partitioners).nil?)
          @f_document_partitioners.remove(partitioning)
          if ((@f_document_partitioners.size).equal?(0))
            @f_document_partitioners = nil
          end
        end
      else
        if ((@f_document_partitioners).nil?)
          @f_document_partitioners = HashMap.new
        end
        @f_document_partitioners.put(partitioning, partitioner)
      end
      event = DocumentPartitioningChangedEvent.new(self)
      event.set_partition_change(partitioning, 0, get_length)
      fire_document_partitioning_changed(event)
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.IRepairableDocument#repairLineInformation()
    # @since 3.0
    def repair_line_information
      get_tracker.set(get)
    end
    
    typesig { [DocumentRewriteSessionEvent] }
    # Fires the given event to all registered rewrite session listeners. Uses robust iterators.
    # 
    # @param event the event to be fired
    # @since 3.1
    def fire_rewrite_session_changed(event)
      if (@f_document_rewrite_session_listeners.size > 0)
        list = ArrayList.new(@f_document_rewrite_session_listeners)
        e = list.iterator
        while (e.has_next)
          l = e.next_
          l.document_rewrite_session_changed(event)
        end
      end
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.IDocumentExtension4#getActiveRewriteSession()
    def get_active_rewrite_session
      return @f_document_rewrite_session
    end
    
    typesig { [DocumentRewriteSessionType] }
    # @see org.eclipse.jface.text.IDocumentExtension4#startRewriteSession(org.eclipse.jface.text.DocumentRewriteSessionType)
    # @since 3.1
    def start_rewrite_session(session_type)
      if (!(get_active_rewrite_session).nil?)
        raise IllegalStateException.new
      end
      @f_document_rewrite_session = DocumentRewriteSession.new(session_type)
      if (DEBUG)
        System.out.println("AbstractDocument: Starting rewrite session: " + RJava.cast_to_string(@f_document_rewrite_session))
      end # $NON-NLS-1$
      fire_rewrite_session_changed(DocumentRewriteSessionEvent.new(self, @f_document_rewrite_session, DocumentRewriteSessionEvent::SESSION_START))
      start_rewrite_session_on_partitioners(@f_document_rewrite_session)
      tracker = get_tracker
      if (tracker.is_a?(ILineTrackerExtension))
        extension = tracker
        extension.start_rewrite_session(@f_document_rewrite_session)
      end
      if ((DocumentRewriteSessionType::SEQUENTIAL).equal?(session_type))
        start_sequential_rewrite(false)
      else
        if ((DocumentRewriteSessionType::STRICTLY_SEQUENTIAL).equal?(session_type))
          start_sequential_rewrite(true)
        end
      end
      return @f_document_rewrite_session
    end
    
    typesig { [DocumentRewriteSession] }
    # Starts the given rewrite session.
    # 
    # @param session the rewrite session
    # @since 3.1
    def start_rewrite_session_on_partitioners(session)
      if (!(@f_document_partitioners).nil?)
        e = @f_document_partitioners.values.iterator
        while (e.has_next)
          partitioner = e.next_
          if (partitioner.is_a?(IDocumentPartitionerExtension3))
            extension = partitioner
            extension.start_rewrite_session(session)
          end
        end
      end
    end
    
    typesig { [DocumentRewriteSession] }
    # @see org.eclipse.jface.text.IDocumentExtension4#stopRewriteSession(org.eclipse.jface.text.DocumentRewriteSession)
    # @since 3.1
    def stop_rewrite_session(session)
      if ((@f_document_rewrite_session).equal?(session))
        if (DEBUG)
          System.out.println("AbstractDocument: Stopping rewrite session: " + RJava.cast_to_string(session))
        end # $NON-NLS-1$
        session_type = session.get_session_type
        if ((DocumentRewriteSessionType::SEQUENTIAL).equal?(session_type) || (DocumentRewriteSessionType::STRICTLY_SEQUENTIAL).equal?(session_type))
          stop_sequential_rewrite
        end
        tracker = get_tracker
        if (tracker.is_a?(ILineTrackerExtension))
          extension = tracker
          extension.stop_rewrite_session(session, get)
        end
        stop_rewrite_session_on_partitioners(@f_document_rewrite_session)
        @f_document_rewrite_session = nil
        fire_rewrite_session_changed(DocumentRewriteSessionEvent.new(self, session, DocumentRewriteSessionEvent::SESSION_STOP))
      end
    end
    
    typesig { [DocumentRewriteSession] }
    # Stops the given rewrite session.
    # 
    # @param session the rewrite session
    # @since 3.1
    def stop_rewrite_session_on_partitioners(session)
      if (!(@f_document_partitioners).nil?)
        event = DocumentPartitioningChangedEvent.new(self)
        e = @f_document_partitioners.key_set.iterator
        while (e.has_next)
          partitioning = e.next_
          partitioner = @f_document_partitioners.get(partitioning)
          if (partitioner.is_a?(IDocumentPartitionerExtension3))
            extension = partitioner
            extension.stop_rewrite_session(session)
            event.set_partition_change(partitioning, 0, get_length)
          end
        end
        if (!event.is_empty)
          fire_document_partitioning_changed(event)
        end
      end
    end
    
    typesig { [IDocumentRewriteSessionListener] }
    # @see org.eclipse.jface.text.IDocumentExtension4#addDocumentRewriteSessionListener(org.eclipse.jface.text.IDocumentRewriteSessionListener)
    # @since 3.1
    def add_document_rewrite_session_listener(listener)
      Assert.is_not_null(listener)
      if (!@f_document_rewrite_session_listeners.contains(listener))
        @f_document_rewrite_session_listeners.add(listener)
      end
    end
    
    typesig { [IDocumentRewriteSessionListener] }
    # @see org.eclipse.jface.text.IDocumentExtension4#removeDocumentRewriteSessionListener(org.eclipse.jface.text.IDocumentRewriteSessionListener)
    # @since 3.1
    def remove_document_rewrite_session_listener(listener)
      Assert.is_not_null(listener)
      @f_document_rewrite_session_listeners.remove(listener)
    end
    
    typesig { [IDocumentPartitioner, String] }
    # Checks the state for the given partitioner and stops the
    # active rewrite session.
    # 
    # @param partitioner the document partitioner to be checked
    # @param partitioning the document partitioning the partitioner is registered for
    # @since 3.1
    def check_state_of_partitioner(partitioner, partitioning)
      if (!(partitioner.is_a?(IDocumentPartitionerExtension3)))
        return
      end
      extension = partitioner
      session = extension.get_active_rewrite_session
      if (!(session).nil?)
        extension.stop_rewrite_session(session)
        if (DEBUG)
          System.out.println("AbstractDocument: Flushing rewrite session for partition type: " + partitioning)
        end # $NON-NLS-1$
        event = DocumentPartitioningChangedEvent.new(self)
        event.set_partition_change(partitioning, 0, get_length)
        fire_document_partitioning_changed(event)
      end
    end
    
    typesig { [String, ::Java::Int, ::Java::Int, ::Java::Boolean, ::Java::Boolean] }
    # Returns all positions of the given category that are inside the given region.
    # 
    # @param category the position category
    # @param offset the start position of the region, must be >= 0
    # @param length the length of the region, must be >= 0
    # @param canStartBefore if <code>true</code> then positions are included
    # which start before the region if they end at or after the regions start
    # @param canEndAfter if <code>true</code> then positions are included
    # which end after the region if they start at or before the regions end
    # @return all positions inside the region of the given category
    # @throws BadPositionCategoryException if category is undefined in this document
    # @since 3.4
    def get_positions(category, offset, length_, can_start_before, can_end_after)
      if (can_start_before && can_end_after || (!can_start_before && !can_end_after))
        document_positions = nil
        if (can_start_before && can_end_after)
          if (offset < get_length / 2)
            document_positions = get_starting_positions(category, 0, offset + length_)
          else
            document_positions = get_ending_positions(category, offset, get_length - offset + 1)
          end
        else
          document_positions = get_starting_positions(category, offset, length_)
        end
        list = ArrayList.new(document_positions.size)
        region = Position.new(offset, length_)
        iterator_ = document_positions.iterator
        while iterator_.has_next
          position = iterator_.next_
          if (is_within_region(region, position, can_start_before, can_end_after))
            list.add(position)
          end
        end
        positions = Array.typed(Position).new(list.size) { nil }
        list.to_array(positions)
        return positions
      else
        if (can_start_before)
          list = get_ending_positions(category, offset, length_)
          positions = Array.typed(Position).new(list.size) { nil }
          list.to_array(positions)
          return positions
        else
          Assert.is_legal(can_end_after && !can_start_before)
          list = get_starting_positions(category, offset, length_)
          positions = Array.typed(Position).new(list.size) { nil }
          list.to_array(positions)
          return positions
        end
      end
    end
    
    typesig { [Position, Position, ::Java::Boolean, ::Java::Boolean] }
    # @since 3.4
    def is_within_region(region, position, can_start_before, can_end_after)
      if (can_start_before && can_end_after)
        return region.overlaps_with(position.get_offset, position.get_length)
      else
        if (can_start_before)
          return region.includes(position.get_offset + position.get_length - 1)
        else
          if (can_end_after)
            return region.includes(position.get_offset)
          else
            start = position.get_offset
            return region.includes(start) && region.includes(start + position.get_length - 1)
          end
        end
      end
    end
    
    typesig { [String, ::Java::Int, ::Java::Int] }
    # A list of positions in the given category with an offset inside the given
    # region. The order of the positions is arbitrary.
    # 
    # @param category the position category
    # @param offset the offset of the region
    # @param length the length of the region
    # @return a list of the positions in the region
    # @throws BadPositionCategoryException if category is undefined in this document
    # @since 3.4
    def get_starting_positions(category, offset, length_)
      positions = @f_positions.get(category)
      if ((positions).nil?)
        raise BadPositionCategoryException.new
      end
      index_start = compute_index_in_position_list(positions, offset, true)
      index_end = compute_index_in_position_list(positions, offset + length_, true)
      return positions.sub_list(index_start, index_end)
    end
    
    typesig { [String, ::Java::Int, ::Java::Int] }
    # A list of positions in the given category with an end position inside
    # the given region. The order of the positions is arbitrary.
    # 
    # @param category the position category
    # @param offset the offset of the region
    # @param length the length of the region
    # @return a list of the positions in the region
    # @throws BadPositionCategoryException if category is undefined in this document
    # @since 3.4
    def get_ending_positions(category, offset, length_)
      positions = @f_end_positions.get(category)
      if ((positions).nil?)
        raise BadPositionCategoryException.new
      end
      index_start = compute_index_in_position_list(positions, offset, false)
      index_end = compute_index_in_position_list(positions, offset + length_, false)
      return positions.sub_list(index_start, index_end)
    end
    
    private
    alias_method :initialize__abstract_document, :initialize
  end
  
end
