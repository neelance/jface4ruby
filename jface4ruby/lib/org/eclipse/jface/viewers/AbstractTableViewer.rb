require "rjava"

# Copyright (c) 2000, 2009 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
# Tom Schindl <tom.schindl@bestsolution.at> - initial API and implementation bug 154329
# - fixes in bug 170381, 198665, 200731
module Org::Eclipse::Jface::Viewers
  module AbstractTableViewerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :Arrays
      include_const ::Java::Util, :HashSet
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :JavaList
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Events, :DisposeEvent
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Event
      include_const ::Org::Eclipse::Swt::Widgets, :Item
      include_const ::Org::Eclipse::Swt::Widgets, :Listener
      include_const ::Org::Eclipse::Swt::Widgets, :Widget
    }
  end
  
  # This is a widget independent class implementors of
  # {@link org.eclipse.swt.widgets.Table} like widgets can use to provide a
  # viewer on top of their widget implementations.
  # 
  # @since 3.3
  class AbstractTableViewer < AbstractTableViewerImports.const_get :ColumnViewer
    include_class_members AbstractTableViewerImports
    
    class_module.module_eval {
      const_set_lazy(:VirtualManager) { Class.new do
        local_class_in AbstractTableViewer
        include_class_members AbstractTableViewer
        
        # The currently invisible elements as provided by the content provider
        # or by addition. This will not be populated by an
        # ILazyStructuredContentProvider as an ILazyStructuredContentProvider
        # is only queried on the virtual callback.
        attr_accessor :cached_elements
        alias_method :attr_cached_elements, :cached_elements
        undef_method :cached_elements
        alias_method :attr_cached_elements=, :cached_elements=
        undef_method :cached_elements=
        
        typesig { [] }
        # Create a new instance of the receiver.
        def initialize
          @cached_elements = Array.typed(Object).new(0) { nil }
          add_table_listener
        end
        
        typesig { [] }
        # Add the listener for SetData on the table
        def add_table_listener
          get_control.add_listener(SWT::SetData, Class.new(self.class::Listener.class == Class ? self.class::Listener : Object) do
            local_class_in VirtualManager
            include_class_members VirtualManager
            include class_self::Listener if class_self::Listener.class == Module
            
            typesig { [class_self::Event] }
            # (non-Javadoc)
            # 
            # @see org.eclipse.swt.widgets.Listener#handleEvent(org.eclipse.swt.widgets.Event)
            define_method :handle_event do |event|
              item = event.attr_item
              index = do_index_of(item)
              if ((index).equal?(-1))
                # Should not happen, but the spec for doIndexOf allows returning -1.
                # See bug 241117.
                return
              end
              element = resolve_element(index)
              if ((element).nil?)
                # Didn't find it so make a request
                # Keep looking if it is not in the cache.
                content_provider = get_content_provider
                # If we are building lazily then request lookup now
                if (content_provider.is_a?(self.class::ILazyContentProvider))
                  (content_provider).update_element(index)
                  return
                end
              end
              associate(element, item)
              update_item(item, element)
            end
            
            typesig { [Vararg.new(Object)] }
            define_method :initialize do |*args|
              super(*args)
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
        end
        
        typesig { [::Java::Int] }
        # Get the element at index.Resolve it lazily if this is available.
        # 
        # @param index
        # @return Object or <code>null</code> if it could not be found
        def resolve_element(index)
          element = nil
          if (index < @cached_elements.attr_length)
            element = @cached_elements[index]
          end
          return element
        end
        
        typesig { [Object, ::Java::Int] }
        # A non visible item has been added.
        # 
        # @param element
        # @param index
        def not_visible_added(element, index)
          required_count = do_get_item_count + 1
          new_cache = Array.typed(Object).new(required_count) { nil }
          System.arraycopy(@cached_elements, 0, new_cache, 0, index)
          if (index < @cached_elements.attr_length)
            System.arraycopy(@cached_elements, index, new_cache, index + 1, @cached_elements.attr_length - index)
          end
          new_cache[index] = element
          @cached_elements = new_cache
          do_set_item_count(required_count)
        end
        
        typesig { [Array.typed(::Java::Int)] }
        # The elements with the given indices need to be removed from the
        # cache.
        # 
        # @param indices
        def remove_indices(indices)
          if ((indices.attr_length).equal?(1))
            remove_indices_from_to(indices[0], indices[0])
          end
          required_count = do_get_item_count - indices.attr_length
          Arrays.sort(indices)
          new_cache = Array.typed(Object).new(required_count) { nil }
          index_in_new_cache = 0
          next_to_skip = 0
          i = 0
          while i < @cached_elements.attr_length
            if (next_to_skip < indices.attr_length && (i).equal?(indices[next_to_skip]))
              next_to_skip += 1
            else
              new_cache[((index_in_new_cache += 1) - 1)] = @cached_elements[i]
            end
            i += 1
          end
          @cached_elements = new_cache
        end
        
        typesig { [::Java::Int, ::Java::Int] }
        # The elements between the given indices (inclusive) need to be removed
        # from the cache.
        # 
        # @param from
        # @param to
        def remove_indices_from_to(from, to)
          index_after_to = to + 1
          new_cache = Array.typed(Object).new(@cached_elements.attr_length - (index_after_to - from)) { nil }
          System.arraycopy(@cached_elements, 0, new_cache, 0, from)
          if (index_after_to < @cached_elements.attr_length)
            System.arraycopy(@cached_elements, index_after_to, new_cache, from, @cached_elements.attr_length - index_after_to)
          end
        end
        
        typesig { [Object] }
        # @param element
        # @return the index of the element in the cache, or null
        def find(element)
          return Arrays.as_list(@cached_elements).index_of(element)
        end
        
        typesig { [::Java::Int] }
        # @param count
        def adjust_cache_size(count)
          if ((count).equal?(@cached_elements.attr_length))
            return
          else
            if (count < @cached_elements.attr_length)
              new_cache = Array.typed(Object).new(count) { nil }
              System.arraycopy(@cached_elements, 0, new_cache, 0, count)
              @cached_elements = new_cache
            else
              new_cache = Array.typed(Object).new(count) { nil }
              System.arraycopy(@cached_elements, 0, new_cache, 0, @cached_elements.attr_length)
              @cached_elements = new_cache
            end
          end
        end
        
        private
        alias_method :initialize__virtual_manager, :initialize
      end }
    }
    
    attr_accessor :virtual_manager
    alias_method :attr_virtual_manager, :virtual_manager
    undef_method :virtual_manager
    alias_method :attr_virtual_manager=, :virtual_manager=
    undef_method :virtual_manager=
    
    typesig { [] }
    # Create the new viewer for table like widgets
    def initialize
      @virtual_manager = nil
      super()
    end
    
    typesig { [Control] }
    def hook_control(control)
      super(control)
      initialize_virtual_manager(get_control.get_style)
    end
    
    typesig { [DisposeEvent] }
    def handle_dispose(event)
      super(event)
      @virtual_manager = nil
    end
    
    typesig { [::Java::Int] }
    # Initialize the virtual manager to manage the virtual state if the table
    # is VIRTUAL. If not use the default no-op version.
    # 
    # @param style
    def initialize_virtual_manager(style)
      if (((style & SWT::VIRTUAL)).equal?(0))
        return
      end
      @virtual_manager = VirtualManager.new_local(self)
    end
    
    typesig { [Array.typed(Object)] }
    # Adds the given elements to this table viewer. If this viewer does not
    # have a sorter, the elements are added at the end in the order given;
    # otherwise the elements are inserted at appropriate positions.
    # <p>
    # This method should be called (by the content provider) when elements have
    # been added to the model, in order to cause the viewer to accurately
    # reflect the model. This method only affects the viewer, not the model.
    # </p>
    # 
    # @param elements
    # the elements to add
    def add(elements)
      assert_elements_not_null(elements)
      if (check_busy)
        return
      end
      filtered = filter(elements)
      i = 0
      while i < filtered.attr_length
        element = filtered[i]
        index = index_for_element(element)
        create_item(element, index)
        i += 1
      end
    end
    
    typesig { [Object, ::Java::Int] }
    # Create a new TableItem at index if required.
    # 
    # @param element
    # @param index
    # 
    # @since 3.1
    def create_item(element, index)
      if ((@virtual_manager).nil?)
        update_item(internal_create_new_row_part(SWT::NONE, index).get_item, element)
      else
        @virtual_manager.not_visible_added(element, index)
      end
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Create a new row.  Callers can only use the returned object locally and before
    # making the next call on the viewer since it may be re-used for subsequent method
    # calls.
    # 
    # @param style
    # the style for the new row
    # @param rowIndex
    # the index of the row or -1 if the row is appended at the end
    # @return the newly created row
    def internal_create_new_row_part(style, row_index)
      raise NotImplementedError
    end
    
    typesig { [Object] }
    # Adds the given element to this table viewer. If this viewer does not have
    # a sorter, the element is added at the end; otherwise the element is
    # inserted at the appropriate position.
    # <p>
    # This method should be called (by the content provider) when a single
    # element has been added to the model, in order to cause the viewer to
    # accurately reflect the model. This method only affects the viewer, not
    # the model. Note that there is another method for efficiently processing
    # the simultaneous addition of multiple elements.
    # </p>
    # 
    # @param element
    # the element to add
    def add(element)
      add(Array.typed(Object).new([element]))
    end
    
    typesig { [Object] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.viewers.StructuredViewer#doFindInputItem(java.lang.Object)
    def do_find_input_item(element)
      if (self.==(element, get_root))
        return get_control
      end
      return nil
    end
    
    typesig { [Object] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.viewers.StructuredViewer#doFindItem(java.lang.Object)
    def do_find_item(element)
      children = do_get_items
      i = 0
      while i < children.attr_length
        item = children[i]
        data = item.get_data
        if (!(data).nil? && self.==(data, element))
          return item
        end
        i += 1
      end
      return nil
    end
    
    typesig { [Widget, Object, ::Java::Boolean] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.viewers.StructuredViewer#doUpdateItem(org.eclipse.swt.widgets.Widget,
    # java.lang.Object, boolean)
    def do_update_item(widget, element, full_map)
      old_busy = is_busy
      set_busy(true)
      begin
        if (widget.is_a?(Item))
          item = widget
          # remember element we are showing
          if (full_map)
            associate(element, item)
          else
            data = item.get_data
            if (!(data).nil?)
              unmap_element(data, item)
            end
            item.set_data(element)
            map_element(element, item)
          end
          column_count = do_get_column_count
          if ((column_count).equal?(0))
            column_count = 1
          end # If there are no columns do the first one
          viewer_row_from_item = get_viewer_row_from_item(item)
          is_virtual = !((get_control.get_style & SWT::VIRTUAL)).equal?(0)
          # If the control is virtual, we cannot use the cached viewer row object. See bug 188663.
          if (is_virtual)
            viewer_row_from_item = viewer_row_from_item.clone
          end
          # Also enter loop if no columns added. See 1G9WWGZ: JFUIF:WINNT -
          # TableViewer with 0 columns does not work
          column = 0
          while column < column_count || (column).equal?(0)
            column_viewer = get_viewer_column(column)
            cell_to_update = update_cell(viewer_row_from_item, column, element)
            # If the control is virtual, we cannot use the cached cell object. See bug 188663.
            if (is_virtual)
              cell_to_update = ViewerCell.new(cell_to_update.get_viewer_row, cell_to_update.get_column_index, element)
            end
            column_viewer.refresh(cell_to_update)
            # clear cell (see bug 201280)
            update_cell(nil, 0, nil)
            # As it is possible for user code to run the event
            # loop check here.
            if (item.is_disposed)
              unmap_element(element, item)
              return
            end
            column += 1
          end
        end
      ensure
        set_busy(old_busy)
      end
    end
    
    typesig { [::Java::Int] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.viewers.ColumnViewer#getColumnViewerOwner(int)
    def get_column_viewer_owner(column_index)
      column_count = do_get_column_count
      if (column_index < 0 || (column_index > 0 && column_index >= column_count))
        return nil
      end
      if ((column_count).equal?(0))
        # Hang it off the table if it
        return get_control
      end
      return do_get_column(column_index)
    end
    
    typesig { [::Java::Int] }
    # Returns the element with the given index from this table viewer. Returns
    # <code>null</code> if the index is out of range.
    # <p>
    # This method is internal to the framework.
    # </p>
    # 
    # @param index
    # the zero-based index
    # @return the element at the given index, or <code>null</code> if the
    # index is out of range
    def get_element_at(index)
      if (index >= 0 && index < do_get_item_count)
        i = do_get_item(index)
        if (!(i).nil?)
          return i.get_data
        end
      end
      return nil
    end
    
    typesig { [] }
    # The table viewer implementation of this <code>Viewer</code> framework
    # method returns the label provider, which in the case of table viewers
    # will be an instance of either <code>ITableLabelProvider</code> or
    # <code>ILabelProvider</code>. If it is an
    # <code>ITableLabelProvider</code>, then it provides a separate label
    # text and image for each column. If it is an <code>ILabelProvider</code>,
    # then it provides only the label text and image for the first column, and
    # any remaining columns are blank.
    def get_label_provider
      return super
    end
    
    typesig { [] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.viewers.StructuredViewer#getSelectionFromWidget()
    def get_selection_from_widget
      if (!(@virtual_manager).nil?)
        return get_virtual_selection
      end
      items = do_get_selection
      list = ArrayList.new(items.attr_length)
      i = 0
      while i < items.attr_length
        item = items[i]
        e = item.get_data
        if (!(e).nil?)
          list.add(e)
        end
        i += 1
      end
      return list
    end
    
    typesig { [] }
    # Get the virtual selection. Avoid calling SWT whenever possible to prevent
    # extra widget creation.
    # 
    # @return List of Object
    def get_virtual_selection
      result = ArrayList.new
      selection_indices = do_get_selection_indices
      if (get_content_provider.is_a?(ILazyContentProvider))
        lazy = get_content_provider
        i = 0
        while i < selection_indices.attr_length
          selection_index = selection_indices[i]
          lazy.update_element(selection_index) # Start the update
          # check for the case where the content provider changed the number of items
          if (selection_index < do_get_item_count)
            element = do_get_item(selection_index).get_data
            # Only add the element if it got updated.
            # If this is done deferred the selection will
            # be incomplete until selection is finished.
            if (!(element).nil?)
              result.add(element)
            end
          end
          i += 1
        end
      else
        i = 0
        while i < selection_indices.attr_length
          element = nil
          # See if it is cached
          selection_index = selection_indices[i]
          if (selection_index < @virtual_manager.attr_cached_elements.attr_length)
            element = @virtual_manager.attr_cached_elements[selection_index]
          end
          if ((element).nil?)
            # Not cached so try the item's data
            item = do_get_item(selection_index)
            element = item.get_data
          end
          if (!(element).nil?)
            result.add(element)
          end
          i += 1
        end
      end
      return result
    end
    
    typesig { [Object] }
    # @param element
    # the element to insert
    # @return the index where the item should be inserted.
    def index_for_element(element)
      comparator = get_comparator
      if ((comparator).nil?)
        return do_get_item_count
      end
      count = do_get_item_count
      min = 0
      max = count - 1
      while (min <= max)
        mid = (min + max) / 2
        data = do_get_item(mid).get_data
        compare_ = comparator.compare(self, data, element)
        if ((compare_).equal?(0))
          # find first item > element
          while ((compare_).equal?(0))
            (mid += 1)
            if (mid >= count)
              break
            end
            data = do_get_item(mid).get_data
            compare_ = comparator.compare(self, data, element)
          end
          return mid
        end
        if (compare_ < 0)
          min = mid + 1
        else
          max = mid - 1
        end
      end
      return min
    end
    
    typesig { [Object, Object] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.viewers.Viewer#inputChanged(java.lang.Object,
    # java.lang.Object)
    def input_changed(input, old_input)
      get_control.set_redraw(false)
      begin
        preserving_selection(Class.new(Runnable.class == Class ? Runnable : Object) do
          local_class_in AbstractTableViewer
          include_class_members AbstractTableViewer
          include Runnable if Runnable.class == Module
          
          typesig { [] }
          define_method :run do
            internal_refresh(get_root)
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      ensure
        get_control.set_redraw(true)
      end
    end
    
    typesig { [Object, ::Java::Int] }
    # Inserts the given element into this table viewer at the given position.
    # If this viewer has a sorter, the position is ignored and the element is
    # inserted at the correct position in the sort order.
    # <p>
    # This method should be called (by the content provider) when elements have
    # been added to the model, in order to cause the viewer to accurately
    # reflect the model. This method only affects the viewer, not the model.
    # </p>
    # 
    # @param element
    # the element
    # @param position
    # a 0-based position relative to the model, or -1 to indicate
    # the last position
    def insert(element, position)
      apply_editor_value
      if (!(get_comparator).nil? || has_filters)
        add(element)
        return
      end
      if ((position).equal?(-1))
        position = do_get_item_count
      end
      if (check_busy)
        return
      end
      create_item(element, position)
    end
    
    typesig { [Object] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.viewers.StructuredViewer#internalRefresh(java.lang.Object)
    def internal_refresh(element)
      internal_refresh(element, true)
    end
    
    typesig { [Object, ::Java::Boolean] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.viewers.StructuredViewer#internalRefresh(java.lang.Object,
    # boolean)
    def internal_refresh(element, update_labels)
      apply_editor_value
      if ((element).nil? || self.==(element, get_root))
        if ((@virtual_manager).nil?)
          internal_refresh_all(update_labels)
        else
          internal_virtual_refresh_all
        end
      else
        w = find_item(element)
        if (!(w).nil?)
          update_item(w, element)
        end
      end
    end
    
    typesig { [] }
    # Refresh all with virtual elements.
    # 
    # @since 3.1
    def internal_virtual_refresh_all
      root = get_root
      content_provider = get_content_provider
      # Invalidate for lazy
      if (!(content_provider.is_a?(ILazyContentProvider)) && (content_provider.is_a?(IStructuredContentProvider)))
        # Don't cache if the root is null but cache if it is not lazy.
        if (!(root).nil?)
          @virtual_manager.attr_cached_elements = get_sorted_children(root)
          do_set_item_count(@virtual_manager.attr_cached_elements.attr_length)
        end
      end
      do_clear_all
    end
    
    typesig { [::Java::Boolean] }
    # Refresh all of the elements of the table. update the labels if
    # updatLabels is true;
    # 
    # @param updateLabels
    # 
    # @since 3.1
    def internal_refresh_all(update_labels)
      # the parent
      # in the code below, it is important to do all disassociates
      # before any associates, since a later disassociate can undo an
      # earlier associate
      # e.g. if (a, b) is replaced by (b, a), the disassociate of b to
      # item 1 could undo
      # the associate of b to item 0.
      children = get_sorted_children(get_root)
      items = do_get_items
      min_ = Math.min(children.attr_length, items.attr_length)
      i = 0
      while i < min_
        item = items[i]
        # if the element is unchanged, update its label if appropriate
        if (self.==(children[i], item.get_data))
          if (update_labels)
            update_item(item, children[i])
          else
            # associate the new element, even if equal to the old
            # one,
            # to remove stale references (see bug 31314)
            associate(children[i], item)
          end
        else
          # updateItem does an associate(...), which can mess up
          # the associations if the order of elements has changed.
          # E.g. (a, b) -> (b, a) first replaces a->0 with b->0, then
          # replaces b->1 with a->1, but this actually removes b->0.
          # So, if the object associated with this item has changed,
          # just disassociate it for now, and update it below.
          # we also need to reset the item (set its text,images etc. to
          # default values) because the label decorators rely on this
          disassociate(item)
          do_clear(i)
        end
        (i += 1)
      end
      # dispose of all items beyond the end of the current elements
      if (min_ < items.attr_length)
        i_ = items.attr_length
        while (i_ -= 1) >= min_
          disassociate(items[i_])
        end
        if (!(@virtual_manager).nil?)
          @virtual_manager.remove_indices_from_to(min_, items.attr_length - 1)
        end
        do_remove(min_, items.attr_length - 1)
      end
      # Workaround for 1GDGN4Q: ITPUI:WIN2000 - TableViewer icons get
      # scrunched
      if ((do_get_item_count).equal?(0))
        do_remove_all
      end
      # Update items which were disassociated above
      i_ = 0
      while i_ < min_
        item = items[i_]
        if ((item.get_data).nil?)
          update_item(item, children[i_])
        end
        (i_ += 1)
      end
      # add any remaining elements
      i__ = min_
      while i__ < children.attr_length
        create_item(children[i__], i__)
        (i__ += 1)
      end
    end
    
    typesig { [Array.typed(Object)] }
    # Removes the given elements from this table viewer.
    # 
    # @param elements
    # the elements to remove
    def internal_remove(elements)
      input = get_input
      i = 0
      while i < elements.attr_length
        if (self.==(elements[i], input))
          old_busy = is_busy
          set_busy(false)
          begin
            set_input(nil)
          ensure
            set_busy(old_busy)
          end
          return
        end
        (i += 1)
      end
      # use remove(int[]) rather than repeated TableItem.dispose() calls
      # to allow SWT to optimize multiple removals
      indices = Array.typed(::Java::Int).new(elements.attr_length) { 0 }
      count = 0
      i_ = 0
      while i_ < elements.attr_length
        w = find_item(elements[i_])
        if ((w).nil? && !(@virtual_manager).nil?)
          index = @virtual_manager.find(elements[i_])
          if (!(index).equal?(-1))
            indices[((count += 1) - 1)] = index
          end
        else
          if (w.is_a?(Item))
            item = w
            disassociate(item)
            indices[((count += 1) - 1)] = do_index_of(item)
          end
        end
        (i_ += 1)
      end
      if (count < indices.attr_length)
        System.arraycopy(indices, 0, indices = Array.typed(::Java::Int).new(count) { 0 }, 0, count)
      end
      if (!(@virtual_manager).nil?)
        @virtual_manager.remove_indices(indices)
      end
      do_remove(indices)
      # Workaround for 1GDGN4Q: ITPUI:WIN2000 - TableViewer icons get
      # scrunched
      if ((do_get_item_count).equal?(0))
        do_remove_all
      end
    end
    
    typesig { [Array.typed(Object)] }
    # Removes the given elements from this table viewer. The selection is
    # updated if required.
    # <p>
    # This method should be called (by the content provider) when elements have
    # been removed from the model, in order to cause the viewer to accurately
    # reflect the model. This method only affects the viewer, not the model.
    # </p>
    # 
    # @param elements
    # the elements to remove
    def remove(elements)
      assert_elements_not_null(elements)
      if (check_busy)
        return
      end
      if ((elements.attr_length).equal?(0))
        return
      end
      preserving_selection(Class.new(Runnable.class == Class ? Runnable : Object) do
        local_class_in AbstractTableViewer
        include_class_members AbstractTableViewer
        include Runnable if Runnable.class == Module
        
        typesig { [] }
        define_method :run do
          internal_remove(elements)
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
    end
    
    typesig { [Object] }
    # Removes the given element from this table viewer. The selection is
    # updated if necessary.
    # <p>
    # This method should be called (by the content provider) when a single
    # element has been removed from the model, in order to cause the viewer to
    # accurately reflect the model. This method only affects the viewer, not
    # the model. Note that there is another method for efficiently processing
    # the simultaneous removal of multiple elements.
    # </p>
    # <strong>NOTE:</strong> removing an object from a virtual table will
    # decrement the itemCount.
    # 
    # @param element
    # the element
    def remove(element)
      remove(Array.typed(Object).new([element]))
    end
    
    typesig { [Object] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.viewers.StructuredViewer#reveal(java.lang.Object)
    def reveal(element)
      Assert.is_not_null(element)
      w = find_item(element)
      if (w.is_a?(Item))
        do_show_item(w)
      end
    end
    
    typesig { [JavaList, ::Java::Boolean] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.viewers.StructuredViewer#setSelectionToWidget(java.util.List,
    # boolean)
    def set_selection_to_widget(list, reveal)
      if ((list).nil?)
        do_deselect_all
        return
      end
      if (!(@virtual_manager).nil?)
        virtual_set_selection_to_widget(list, reveal)
        return
      end
      # This is vital to use doSetSelection because on SWT-Table on Win32 this will also
      # move the focus to this row (See bug https://bugs.eclipse.org/bugs/show_bug.cgi?id=198665)
      if (reveal)
        size_ = list.size
        items = Array.typed(Item).new(size_) { nil }
        count = 0
        i = 0
        while i < size_
          o = list.get(i)
          w = find_item(o)
          if (w.is_a?(Item))
            item = w
            items[((count += 1) - 1)] = item
          end
          (i += 1)
        end
        if (count < size_)
          System.arraycopy(items, 0, items = Array.typed(Item).new(count) { nil }, 0, count)
        end
        do_set_selection(items)
      else
        do_deselect_all # Clear the selection
        if (!list.is_empty)
          indices = Array.typed(::Java::Int).new(list.size) { 0 }
          it = list.iterator
          items = do_get_items
          model_element = nil
          count = 0
          while (it.has_next)
            model_element = it.next_
            found = false
            i = 0
            while i < items.attr_length && !found
              if (self.==(model_element, items[i].get_data))
                indices[((count += 1) - 1)] = i
                found = true
              end
              i += 1
            end
          end
          if (count < indices.attr_length)
            System.arraycopy(indices, 0, indices = Array.typed(::Java::Int).new(count) { 0 }, 0, count)
          end
          do_select(indices)
        end
      end
    end
    
    typesig { [JavaList, ::Java::Boolean] }
    # Set the selection on a virtual table
    # 
    # @param list
    # The elements to set
    # @param reveal
    # Whether or not reveal the first item.
    def virtual_set_selection_to_widget(list, reveal)
      size_ = list.size
      indices = Array.typed(::Java::Int).new(list.size) { 0 }
      first_item = nil
      count = 0
      virtual_elements = HashSet.new
      i = 0
      while i < size_
        o = list.get(i)
        w = find_item(o)
        if (w.is_a?(Item))
          item = w
          indices[((count += 1) - 1)] = do_index_of(item)
          if ((first_item).nil?)
            first_item = item
          end
        else
          virtual_elements.add(o)
        end
        (i += 1)
      end
      if (get_content_provider.is_a?(ILazyContentProvider))
        provider = get_content_provider
        # Now go through it again until all is done or we are no longer
        # virtual
        # This may create all items so it is not a good
        # idea in general.
        # Use #setSelection (int [] indices,boolean reveal) instead
        i_ = 0
        while virtual_elements.size > 0 && i_ < do_get_item_count
          provider.update_element(i_)
          item = do_get_item(i_)
          if (virtual_elements.contains(item.get_data))
            indices[((count += 1) - 1)] = i_
            virtual_elements.remove(item.get_data)
            if ((first_item).nil?)
              first_item = item
            end
          end
          i_ += 1
        end
      else
        if (!(count).equal?(list.size))
          # As this is expensive skip it if all
          # have been found
          # If it is not lazy we can use the cache
          i_ = 0
          while i_ < @virtual_manager.attr_cached_elements.attr_length
            element = @virtual_manager.attr_cached_elements[i_]
            if (virtual_elements.contains(element))
              item = do_get_item(i_)
              item.get_text # Be sure to fire the update
              indices[((count += 1) - 1)] = i_
              virtual_elements.remove(element)
              if ((first_item).nil?)
                first_item = item
              end
            end
            i_ += 1
          end
        end
      end
      if (count < size_)
        System.arraycopy(indices, 0, indices = Array.typed(::Java::Int).new(count) { 0 }, 0, count)
      end
      do_deselect_all
      do_select(indices)
      if (reveal && !(first_item).nil?)
        do_show_item(first_item)
      end
    end
    
    typesig { [::Java::Int] }
    # Set the item count of the receiver.
    # 
    # @param count
    # the new table size.
    # 
    # @since 3.1
    def set_item_count(count)
      if (check_busy)
        return
      end
      old_count = do_get_item_count
      if (count < old_count)
        # need to disassociate elements that are being disposed
        i = count
        while i < old_count
          item = do_get_item(i)
          if (!(item.get_data).nil?)
            disassociate(item)
          end
          i += 1
        end
      end
      do_set_item_count(count)
      if (!(@virtual_manager).nil?)
        @virtual_manager.adjust_cache_size(count)
      end
      get_control.redraw
    end
    
    typesig { [Object, ::Java::Int] }
    # Replace the element at the given index with the given element. This
    # method will not call the content provider to verify. <strong>Note that
    # this method will materialize a TableItem the given index.</strong>.
    # 
    # @param element
    # @param index
    # @see ILazyContentProvider
    # 
    # @since 3.1
    def replace(element, index)
      if (check_busy)
        return
      end
      item = do_get_item(index)
      refresh_item(item, element)
    end
    
    typesig { [::Java::Int] }
    # Clear the table item at the specified index
    # 
    # @param index
    # the index of the table item to be cleared
    # 
    # @since 3.1
    def clear(index)
      item = do_get_item(index)
      if (!(item.get_data).nil?)
        disassociate(item)
      end
      do_clear(index)
    end
    
    typesig { [Object] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.viewers.StructuredViewer#getRawChildren(java.lang.Object)
    def get_raw_children(parent)
      Assert.is_true(!(get_content_provider.is_a?(ILazyContentProvider)), "Cannot get raw children with an ILazyContentProvider") # $NON-NLS-1$
      return super(parent)
    end
    
    typesig { [IContentProvider] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.viewers.StructuredViewer#assertContentProviderType(org.eclipse.jface.viewers.IContentProvider)
    def assert_content_provider_type(provider)
      Assert.is_true(provider.is_a?(IStructuredContentProvider) || provider.is_a?(ILazyContentProvider))
    end
    
    typesig { [Item] }
    # Searches the receiver's list starting at the first item (index 0) until
    # an item is found that is equal to the argument, and returns the index of
    # that item. If no item is found, returns -1.
    # 
    # @param item
    # the search item
    # @return the index of the item
    # 
    # @since 3.3
    def do_index_of(item)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the number of items contained in the receiver.
    # 
    # @return the number of items
    # 
    # @since 3.3
    def do_get_item_count
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    # Sets the number of items contained in the receiver.
    # 
    # @param count
    # the number of items
    # 
    # @since 3.3
    def do_set_item_count(count)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns a (possibly empty) array of TableItems which are the items in the
    # receiver.
    # 
    # @return the items in the receiver
    # 
    # @since 3.3
    def do_get_items
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    # Returns the column at the given, zero-relative index in the receiver.
    # Throws an exception if the index is out of range. Columns are returned in
    # the order that they were created. If no TableColumns were created by the
    # programmer, this method will throw ERROR_INVALID_RANGE despite the fact
    # that a single column of data may be visible in the table. This occurs
    # when the programmer uses the table like a list, adding items but never
    # creating a column.
    # 
    # @param index
    # the index of the column to return
    # @return the column at the given index
    # @exception IllegalArgumentException -
    # if the index is not between 0 and the number of elements
    # in the list minus 1 (inclusive)
    # 
    # @since 3.3
    def do_get_column(index)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    # Returns the item at the given, zero-relative index in the receiver.
    # Throws an exception if the index is out of range.
    # 
    # @param index
    # the index of the item to return
    # @return the item at the given index
    # @exception IllegalArgumentException -
    # if the index is not between 0 and the number of elements
    # in the list minus 1 (inclusive)
    # 
    # @since 3.3
    def do_get_item(index)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns an array of {@link Item} that are currently selected in the
    # receiver. The order of the items is unspecified. An empty array indicates
    # that no items are selected.
    # 
    # @return an array representing the selection
    # 
    # @since 3.3
    def do_get_selection
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the zero-relative indices of the items which are currently
    # selected in the receiver. The order of the indices is unspecified. The
    # array is empty if no items are selected.
    # 
    # @return an array representing the selection
    # 
    # @since 3.3
    def do_get_selection_indices
      raise NotImplementedError
    end
    
    typesig { [] }
    # Clears all the items in the receiver. The text, icon and other attributes
    # of the items are set to their default values. If the table was created
    # with the <code>SWT.VIRTUAL</code> style, these attributes are requested
    # again as needed.
    # 
    # @since 3.3
    def do_clear_all
      raise NotImplementedError
    end
    
    typesig { [Item] }
    # Resets the given item in the receiver. The text, icon and other attributes
    # of the item are set to their default values.
    # 
    # @param item the item to reset
    # 
    # @since 3.3
    def do_reset_item(item)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Removes the items from the receiver which are between the given
    # zero-relative start and end indices (inclusive).
    # 
    # @param start
    # the start of the range
    # @param end
    # the end of the range
    # 
    # @exception IllegalArgumentException -
    # if either the start or end are not between 0 and the
    # number of elements in the list minus 1 (inclusive)
    # 
    # @since 3.3
    def do_remove(start, end_)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Removes all of the items from the receiver.
    # 
    # @since 3.3
    def do_remove_all
      raise NotImplementedError
    end
    
    typesig { [Array.typed(::Java::Int)] }
    # Removes the items from the receiver's list at the given zero-relative
    # indices.
    # 
    # @param indices
    # the array of indices of the items
    # 
    # @exception IllegalArgumentException -
    # if the array is null, or if any of the indices is not
    # between 0 and the number of elements in the list minus 1
    # (inclusive)
    # 
    # @since 3.3
    def do_remove(indices)
      raise NotImplementedError
    end
    
    typesig { [Item] }
    # Shows the item. If the item is already showing in the receiver, this
    # method simply returns. Otherwise, the items are scrolled until the item
    # is visible.
    # 
    # @param item
    # the item to be shown
    # 
    # @exception IllegalArgumentException -
    # if the item is null
    # 
    # @since 3.3
    def do_show_item(item)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Deselects all selected items in the receiver.
    # 
    # @since 3.3
    def do_deselect_all
      raise NotImplementedError
    end
    
    typesig { [Array.typed(Item)] }
    # Sets the receiver's selection to be the given array of items. The current
    # selection is cleared before the new items are selected.
    # <p>
    # Items that are not in the receiver are ignored. If the receiver is
    # single-select and multiple items are specified, then all items are
    # ignored.
    # </p>
    # 
    # @param items
    # the array of items
    # 
    # @exception IllegalArgumentException -
    # if the array of items is null
    # 
    # @since 3.3
    def do_set_selection(items)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Shows the selection. If the selection is already showing in the receiver,
    # this method simply returns. Otherwise, the items are scrolled until the
    # selection is visible.
    # 
    # @since 3.3
    def do_show_selection
      raise NotImplementedError
    end
    
    typesig { [Array.typed(::Java::Int)] }
    # Selects the items at the given zero-relative indices in the receiver. The
    # current selection is cleared before the new items are selected.
    # <p>
    # Indices that are out of range and duplicate indices are ignored. If the
    # receiver is single-select and multiple indices are specified, then all
    # indices are ignored.
    # </p>
    # 
    # @param indices
    # the indices of the items to select
    # 
    # @exception IllegalArgumentException -
    # if the array of indices is null
    # 
    # @since 3.3
    def do_set_selection(indices)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    # Clears the item at the given zero-relative index in the receiver. The
    # text, icon and other attributes of the item are set to the default value.
    # If the table was created with the <code>SWT.VIRTUAL</code> style, these
    # attributes are requested again as needed.
    # 
    # @param index
    # the index of the item to clear
    # 
    # @exception IllegalArgumentException -
    # if the index is not between 0 and the number of elements
    # in the list minus 1 (inclusive)
    # 
    # @see SWT#VIRTUAL
    # @see SWT#SetData
    # 
    # @since 3.3
    def do_clear(index)
      raise NotImplementedError
    end
    
    typesig { [Array.typed(::Java::Int)] }
    # Selects the items at the given zero-relative indices in the receiver.
    # The current selection is not cleared before the new items are selected.
    # <p>
    # If the item at a given index is not selected, it is selected.
    # If the item at a given index was already selected, it remains selected.
    # Indices that are out of range and duplicate indices are ignored.
    # If the receiver is single-select and multiple indices are specified,
    # then all indices are ignored.
    # </p>
    # 
    # @param indices the array of indices for the items to select
    # 
    # @exception IllegalArgumentException - if the array of indices is null
    def do_select(indices)
      raise NotImplementedError
    end
    
    private
    alias_method :initialize__abstract_table_viewer, :initialize
  end
  
end
