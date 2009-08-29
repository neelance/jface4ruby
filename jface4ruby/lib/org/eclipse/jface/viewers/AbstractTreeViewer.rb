require "rjava"

# Copyright (c) 2000, 2009 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
# Tom Schindl <tom.schindl@bestsolution.at> - bug 153993, bug 167323, bug 175192
# Lasse Knudsen, bug 205700
# Micah Hainline, bug 210448
# Michael Schneider, bug 210747
# Bruce Sutton, bug 221768
# Matthew Hall, bug 221988
module Org::Eclipse::Jface::Viewers
  module AbstractTreeViewerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :Arrays
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :LinkedList
      include_const ::Java::Util, :JavaList
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Core::Runtime, :ListenerList
      include_const ::Org::Eclipse::Jface::Util, :SafeRunnable
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Custom, :BusyIndicator
      include_const ::Org::Eclipse::Swt::Events, :SelectionEvent
      include_const ::Org::Eclipse::Swt::Events, :SelectionListener
      include_const ::Org::Eclipse::Swt::Events, :TreeEvent
      include_const ::Org::Eclipse::Swt::Events, :TreeListener
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Item
      include_const ::Org::Eclipse::Swt::Widgets, :Widget
    }
  end
  
  # Abstract base implementation for tree-structure-oriented viewers (trees and
  # table trees).
  # <p>
  # Nodes in the tree can be in either an expanded or a collapsed state,
  # depending on whether the children on a node are visible. This class
  # introduces public methods for controlling the expanding and collapsing of
  # nodes.
  # </p>
  # <p>
  # As of 3.2, AbstractTreeViewer supports multiple equal elements (each with a
  # different parent chain) in the tree. This support requires that clients
  # enable the element map by calling <code>setUseHashLookup(true)</code>.
  # </p>
  # <p>
  # Content providers for abstract tree viewers must implement one of the
  # interfaces <code>ITreeContentProvider</code> or (as of 3.2, to support
  # multiple equal elements) <code>ITreePathContentProvider</code>.
  # </p>
  # 
  # @see TreeViewer
  class AbstractTreeViewer < AbstractTreeViewerImports.const_get :ColumnViewer
    include_class_members AbstractTreeViewerImports
    
    class_module.module_eval {
      # Constant indicating that all levels of the tree should be expanded or
      # collapsed.
      # 
      # @see #expandToLevel(int)
      # @see #collapseToLevel(Object, int)
      const_set_lazy(:ALL_LEVELS) { -1 }
      const_attr_reader  :ALL_LEVELS
    }
    
    # List of registered tree listeners (element type:
    # <code>TreeListener</code>).
    attr_accessor :tree_listeners
    alias_method :attr_tree_listeners, :tree_listeners
    undef_method :tree_listeners
    alias_method :attr_tree_listeners=, :tree_listeners=
    undef_method :tree_listeners=
    
    # The level to which the tree is automatically expanded each time the
    # viewer's input is changed (that is, by <code>setInput</code>). A value
    # of 0 means that auto-expand is off.
    # 
    # @see #setAutoExpandLevel
    attr_accessor :expand_to_level
    alias_method :attr_expand_to_level, :expand_to_level
    undef_method :expand_to_level
    alias_method :attr_expand_to_level=, :expand_to_level=
    undef_method :expand_to_level=
    
    class_module.module_eval {
      # Safe runnable used to update an item.
      const_set_lazy(:UpdateItemSafeRunnable) { Class.new(SafeRunnable) do
        extend LocalClass
        include_class_members AbstractTreeViewer
        
        attr_accessor :element
        alias_method :attr_element, :element
        undef_method :element
        alias_method :attr_element=, :element=
        undef_method :element=
        
        attr_accessor :item
        alias_method :attr_item, :item
        undef_method :item
        alias_method :attr_item=, :item=
        undef_method :item=
        
        typesig { [class_self::Item, Object] }
        def initialize(item, element)
          @element = nil
          @item = nil
          super()
          @item = item
          @element = element
        end
        
        typesig { [] }
        def run
          do_update_item(@item, @element)
        end
        
        private
        alias_method :initialize__update_item_safe_runnable, :initialize
      end }
    }
    
    typesig { [] }
    # Creates an abstract tree viewer. The viewer has no input, no content
    # provider, a default label provider, no sorter, no filters, and has
    # auto-expand turned off.
    def initialize
      @tree_listeners = nil
      @expand_to_level = 0
      super()
      @tree_listeners = ListenerList.new
      @expand_to_level = 0
      # do nothing
    end
    
    typesig { [Object, Array.typed(Object)] }
    # Adds the given child elements to this viewer as children of the given
    # parent element. If this viewer does not have a sorter, the elements are
    # added at the end of the parent's list of children in the order given;
    # otherwise, the elements are inserted at the appropriate positions.
    # <p>
    # This method should be called (by the content provider) when elements have
    # been added to the model, in order to cause the viewer to accurately
    # reflect the model. This method only affects the viewer, not the model.
    # </p>
    # 
    # @param parentElementOrTreePath
    # the parent element
    # @param childElements
    # the child elements to add
    def add(parent_element_or_tree_path, child_elements)
      Assert.is_not_null(parent_element_or_tree_path)
      assert_elements_not_null(child_elements)
      if (check_busy)
        return
      end
      widgets = internal_find_items(parent_element_or_tree_path)
      # If parent hasn't been realized yet, just ignore the add.
      if ((widgets.attr_length).equal?(0))
        return
      end
      i = 0
      while i < widgets.attr_length
        internal_add(widgets[i], parent_element_or_tree_path, child_elements)
        i += 1
      end
    end
    
    typesig { [Object] }
    # Find the items for the given element of tree path
    # 
    # @param parentElementOrTreePath
    # the element or tree path
    # @return the items for that element
    # 
    # @since 3.3
    def internal_find_items(parent_element_or_tree_path)
      widgets = nil
      if (parent_element_or_tree_path.is_a?(TreePath))
        path = parent_element_or_tree_path
        w = internal_find_item(path)
        if ((w).nil?)
          widgets = Array.typed(Widget).new([])
        else
          widgets = Array.typed(Widget).new([w])
        end
      else
        widgets = find_items(parent_element_or_tree_path)
      end
      return widgets
    end
    
    typesig { [TreePath] }
    # Return the item at the given path or <code>null</code>
    # 
    # @param path
    # the path
    # @return {@link Widget} the item at that path
    def internal_find_item(path)
      widgets = find_items(path.get_last_segment)
      i = 0
      while i < widgets.attr_length
        widget = widgets[i]
        if (widget.is_a?(Item))
          item = widget
          p = get_tree_path_from_item(item)
          if ((p == path))
            return widget
          end
        end
        i += 1
      end
      return nil
    end
    
    typesig { [Widget, Object, Array.typed(Object)] }
    # Adds the given child elements to this viewer as children of the given
    # parent element.
    # <p>
    # EXPERIMENTAL. Not to be used except by JDT. This method was added to
    # support JDT's explorations into grouping by working sets, which requires
    # viewers to support multiple equal elements. See bug 76482 for more
    # details. This support will likely be removed in Eclipse 3.2 in favor of
    # proper support for multiple equal elements.
    # </p>
    # 
    # @param widget
    # the widget for the parent element
    # @param parentElementOrTreePath
    # the parent element
    # @param childElements
    # the child elements to add
    # @since 3.1
    def internal_add(widget, parent_element_or_tree_path, child_elements)
      parent = nil
      path = nil
      if (parent_element_or_tree_path.is_a?(TreePath))
        path = parent_element_or_tree_path
        parent = path.get_last_segment
      else
        parent = parent_element_or_tree_path
        path = nil
      end
      # optimization!
      # if the widget is not expanded we just invalidate the subtree
      if (widget.is_a?(Item))
        ti = widget
        if (!get_expanded(ti))
          need_dummy = is_expandable(ti, path, parent)
          have_dummy = false
          # remove all children
          items = get_items(ti)
          i = 0
          while i < items.attr_length
            if (!(items[i].get_data).nil?)
              disassociate(items[i])
              items[i].dispose
            else
              if (need_dummy && !have_dummy)
                have_dummy = true
              else
                items[i].dispose
              end
            end
            i += 1
          end
          # append a dummy if necessary
          if (need_dummy && !have_dummy)
            new_item(ti, SWT::NULL, -1)
          end
          return
        end
      end
      if (child_elements.attr_length > 0)
        # TODO: Add filtering back?
        filtered = filter(parent_element_or_tree_path, child_elements)
        comparator = get_comparator
        if (!(comparator).nil?)
          if (comparator.is_a?(TreePathViewerSorter))
            tpvs = comparator
            if ((path).nil?)
              path = internal_get_sorter_parent_path(widget, comparator)
            end
            tpvs.sort(self, path, filtered)
          else
            comparator.sort(self, filtered)
          end
        end
        create_added_elements(widget, filtered)
      end
    end
    
    typesig { [Object, Array.typed(Object)] }
    # Filter the children elements.
    # 
    # @param parentElementOrTreePath
    # the parent element or path
    # @param elements
    # the child elements
    # @return the filter list of children
    def filter(parent_element_or_tree_path, elements)
      filters = get_filters
      if (!(filters).nil?)
        filtered = ArrayList.new(elements.attr_length)
        i = 0
        while i < elements.attr_length
          add = true
          j = 0
          while j < filters.attr_length
            add = filters[j].select(self, parent_element_or_tree_path, elements[i])
            if (!add)
              break
            end
            j += 1
          end
          if (add)
            filtered.add(elements[i])
          end
          i += 1
        end
        return filtered.to_array
      end
      return elements
    end
    
    typesig { [Widget, Array.typed(Object)] }
    # Create the new elements in the parent widget. If the child already exists
    # do nothing.
    # 
    # @param widget
    # @param elements
    # Sorted list of elements to add.
    def create_added_elements(widget, elements)
      if ((elements.attr_length).equal?(1))
        if (self.==(elements[0], widget.get_data))
          return
        end
      end
      comparator = get_comparator
      parent_path = internal_get_sorter_parent_path(widget, comparator)
      items = get_children(widget)
      # Optimize for the empty case
      if ((items.attr_length).equal?(0))
        i = 0
        while i < elements.attr_length
          create_tree_item(widget, elements[i], -1)
          i += 1
        end
        return
      end
      # Optimize for no comparator
      if ((comparator).nil?)
        i = 0
        while i < elements.attr_length
          element = elements[i]
          if (item_exists(items, element))
            internal_refresh(element)
          else
            create_tree_item(widget, element, -1)
          end
          i += 1
        end
        return
      end
      # As the items are sorted already we optimize for a
      # start position. This is the insertion position relative to the
      # original item array.
      index_in_items = 0
      # Count of elements we have added. See bug 205700 for why this is needed.
      new_items = 0
      i = 0
      while i < elements.attr_length
        catch(:next_elementloop) do
          element = elements[i]
          # update the index relative to the original item array
          index_in_items = insertion_position(items, comparator, index_in_items, element, parent_path)
          if ((index_in_items).equal?(items.attr_length))
            create_tree_item(widget, element, -1)
            new_items += 1
          else
            # Search for an item for the element. The comparator might
            # regard elements as equal when they are not.
            # Use a separate index variable to search within the existing
            # elements that compare equally, see
            # TreeViewerTestBug205700.testAddEquallySortedElements.
            insertion_index_in_items = index_in_items
            while (insertion_index_in_items < items.attr_length && (internal_compare(comparator, parent_path, element, items[insertion_index_in_items].get_data)).equal?(0))
              # As we cannot assume the sorter is consistent with
              # equals() - therefore we can
              # just check against the item prior to this index (if
              # any)
              if ((items[insertion_index_in_items].get_data == element))
                # Found the item for the element.
                # Refresh the element in case it has new children.
                internal_refresh(element)
                # Do not create a new item - continue with the next element.
                throw :next_elementloop, :thrown
              end
              insertion_index_in_items += 1
            end
            # Did we get to the end?
            if ((insertion_index_in_items).equal?(items.attr_length))
              create_tree_item(widget, element, -1)
              new_items += 1
            else
              # InsertionIndexInItems is the index in the original array. We
              # need to correct by the number of new items we have
              # created. See bug 205700.
              create_tree_item(widget, element, insertion_index_in_items + new_items)
              new_items += 1
            end
          end
        end
        i += 1
      end
    end
    
    typesig { [Array.typed(Item), Object] }
    # See if element is the data of one of the elements in items.
    # 
    # @param items
    # @param element
    # @return <code>true</code> if the element matches.
    def item_exists(items, element)
      if (using_element_map)
        existing_items = find_items(element)
        # optimization for two common cases
        if ((existing_items.attr_length).equal?(0))
          return false
        else
          if ((existing_items.attr_length).equal?(1))
            if (items.attr_length > 0 && existing_items[0].is_a?(Item))
              existing_item = existing_items[0]
              return (get_parent_item(existing_item)).equal?(get_parent_item(items[0]))
            end
          end
        end
      end
      i = 0
      while i < items.attr_length
        if ((items[i].get_data == element))
          return true
        end
        i += 1
      end
      return false
    end
    
    typesig { [Array.typed(Item), ViewerComparator, ::Java::Int, Object, TreePath] }
    # Returns the index where the item should be inserted. It uses sorter to
    # determine the correct position, if sorter is not assigned, returns the
    # index of the element after the last.
    # 
    # @param items
    # the items to search
    # @param comparator
    # The comparator to use.
    # @param lastInsertion
    # the start index to start search for position from this allows
    # optimizing search for multiple elements that are sorted
    # themselves.
    # @param element
    # element to find position for.
    # @param parentPath
    # the tree path for the element's parent or <code>null</code>
    # if the element is a root element or the sorter is not a
    # {@link TreePathViewerSorter}
    # @return the index to use when inserting the element.
    def insertion_position(items, comparator, last_insertion, element, parent_path)
      size = items.attr_length
      if ((comparator).nil?)
        return size
      end
      min = last_insertion
      max = size - 1
      while (min <= max)
        mid = (min + max) / 2
        data = items[mid].get_data
        compare = internal_compare(comparator, parent_path, data, element)
        if ((compare).equal?(0))
          return mid # Return if we already match
        end
        if (compare < 0)
          min = mid + 1
        else
          max = mid - 1
        end
      end
      return min
    end
    
    typesig { [Widget, Object] }
    # Returns the index where the item should be inserted. It uses sorter to
    # determine the correct position, if sorter is not assigned, returns the
    # index of the element after the last.
    # 
    # @param parent
    # The parent widget
    # @param sorter
    # The sorter to use.
    # @param startIndex
    # the start index to start search for position from this allows
    # optimizing search for multiple elements that are sorted
    # themselves.
    # @param element
    # element to find position for.
    # @param currentSize
    # the current size of the collection
    # @return the index to use when inserting the element.
    # 
    # 
    # 
    # Returns the index where the item should be inserted.
    # 
    # @param parent
    # The parent widget the element will be inserted into.
    # @param element
    # The element to insert.
    # @return the index of the element
    def index_for_element(parent, element)
      comparator = get_comparator
      parent_path = internal_get_sorter_parent_path(parent, comparator)
      items = get_children(parent)
      count = items.attr_length
      if ((comparator).nil?)
        return count
      end
      min = 0
      max = count - 1
      while (min <= max)
        mid = (min + max) / 2
        data = items[mid].get_data
        compare = internal_compare(comparator, parent_path, data, element)
        if ((compare).equal?(0))
          # find first item > element
          while ((compare).equal?(0))
            (mid += 1)
            if (mid >= count)
              break
            end
            data = items[mid].get_data
            compare = internal_compare(comparator, parent_path, data, element)
          end
          return mid
        end
        if (compare < 0)
          min = mid + 1
        else
          max = mid - 1
        end
      end
      return min
    end
    
    typesig { [Widget, ViewerComparator] }
    # Return the tree path that should be used as the parent path for the given
    # widget and sorter. A <code>null</code> is returned if either the sorter
    # is not a {@link TreePathViewerSorter} or if the parent widget is not an
    # {@link Item} (i.e. is the root of the tree).
    # 
    # @param parent
    # the parent widget
    # @param comparator
    # the sorter
    # @return the tree path that should be used as the parent path for the
    # given widget and sorter
    def internal_get_sorter_parent_path(parent, comparator)
      path = nil
      if (comparator.is_a?(TreePathViewerSorter) && parent.is_a?(Item))
        item = parent
        path = get_tree_path_from_item(item)
      else
        path = nil
      end
      return path
    end
    
    typesig { [ViewerComparator, TreePath, Object, Object] }
    # Compare the two elements using the given sorter. If the sorter is a
    # {@link TreePathViewerSorter}, the provided tree path will be used. If
    # the tree path is null and the sorter is a tree path sorter, then the
    # elements are root elements
    # 
    # @param comparator
    # the sorter
    # @param parentPath
    # the path of the elements' parent
    # @param e1
    # the first element
    # @param e2
    # the second element
    # @return the result of comparing the two elements
    def internal_compare(comparator, parent_path, e1, e2)
      if (comparator.is_a?(TreePathViewerSorter))
        tpvs = comparator
        return tpvs.compare(self, parent_path, e1, e2)
      end
      return comparator.compare(self, e1, e2)
    end
    
    typesig { [Object] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.viewers.StructuredViewer#getSortedChildren(java.lang.Object)
    def get_sorted_children(parent_element_or_tree_path)
      result = get_filtered_children(parent_element_or_tree_path)
      comparator = get_comparator
      if (!(parent_element_or_tree_path).nil? && comparator.is_a?(TreePathViewerSorter))
        tpvs = comparator
        # be sure we're not modifying the original array from the model
        result = result.clone
        path = nil
        if (parent_element_or_tree_path.is_a?(TreePath))
          path = parent_element_or_tree_path
        else
          parent = parent_element_or_tree_path
          w = internal_get_widget_to_select(parent)
          if (!(w).nil?)
            path = internal_get_sorter_parent_path(w, comparator)
          end
        end
        tpvs.sort(self, path, result)
      else
        if (!(comparator).nil?)
          # be sure we're not modifying the original array from the model
          result = result.clone
          comparator.sort(self, result)
        end
      end
      return result
    end
    
    typesig { [Object] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.viewers.StructuredViewer#getFilteredChildren(java.lang.Object)
    def get_filtered_children(parent_element_or_tree_path)
      result = get_raw_children(parent_element_or_tree_path)
      filters = get_filters
      i = 0
      while i < filters.attr_length
        filter_ = filters[i]
        result = filter_.filter(self, parent_element_or_tree_path, result)
        i += 1
      end
      return result
    end
    
    typesig { [Object, Object] }
    # Adds the given child element to this viewer as a child of the given
    # parent element. If this viewer does not have a sorter, the element is
    # added at the end of the parent's list of children; otherwise, the element
    # is inserted at the appropriate position.
    # <p>
    # This method should be called (by the content provider) when a single
    # element has been added to the model, in order to cause the viewer to
    # accurately reflect the model. This method only affects the viewer, not
    # the model. Note that there is another method for efficiently processing
    # the simultaneous addition of multiple elements.
    # </p>
    # 
    # @param parentElementOrTreePath
    # the parent element or path
    # @param childElement
    # the child element
    def add(parent_element_or_tree_path, child_element)
      add(parent_element_or_tree_path, Array.typed(Object).new([child_element]))
    end
    
    typesig { [Control, SelectionListener] }
    # Adds the given SWT selection listener to the given SWT control.
    # 
    # @param control
    # the SWT control
    # @param listener
    # the SWT selection listener
    # @deprecated
    def add_selection_listener(control, listener)
      # do nothing
    end
    
    typesig { [ITreeViewerListener] }
    # Adds a listener for expand and collapse events in this viewer. Has no
    # effect if an identical listener is already registered.
    # 
    # @param listener
    # a tree viewer listener
    def add_tree_listener(listener)
      @tree_listeners.add(listener)
    end
    
    typesig { [Control, TreeListener] }
    # Adds the given SWT tree listener to the given SWT control.
    # 
    # @param control
    # the SWT control
    # @param listener
    # the SWT tree listener
    def add_tree_listener(control, listener)
      raise NotImplementedError
    end
    
    typesig { [Object, Item] }
    # (non-Javadoc)
    # 
    # @see StructuredViewer#associate(Object, Item)
    def associate(element, item)
      data = item.get_data
      if (!(data).nil? && !(data).equal?(element) && self.==(data, element))
        # workaround for PR 1FV62BT
        # assumption: elements are equal but not identical
        # -> remove from map but don't touch children
        unmap_element(data, item)
        item.set_data(element)
        map_element(element, item)
      else
        # recursively disassociate all
        super(element, item)
      end
    end
    
    typesig { [] }
    # Collapses all nodes of the viewer's tree, starting with the root. This
    # method is equivalent to <code>collapseToLevel(ALL_LEVELS)</code>.
    def collapse_all
      root = get_root
      if (!(root).nil?)
        collapse_to_level(root, ALL_LEVELS)
      end
    end
    
    typesig { [Object, ::Java::Int] }
    # Collapses the subtree rooted at the given element or tree path to the
    # given level.
    # 
    # @param elementOrTreePath
    # the element or tree path
    # @param level
    # non-negative level, or <code>ALL_LEVELS</code> to collapse
    # all levels of the tree
    def collapse_to_level(element_or_tree_path, level)
      Assert.is_not_null(element_or_tree_path)
      w = internal_get_widget_to_select(element_or_tree_path)
      if (!(w).nil?)
        internal_collapse_to_level(w, level)
      end
    end
    
    typesig { [Widget] }
    # Creates all children for the given widget.
    # <p>
    # The default implementation of this framework method assumes that
    # <code>widget.getData()</code> returns the element corresponding to the
    # node. Note: the node is not visually expanded! You may have to call
    # <code>parent.setExpanded(true)</code>.
    # </p>
    # 
    # @param widget
    # the widget
    def create_children(widget)
      old_busy = is_busy
      set_busy(true)
      begin
        tis = get_children(widget)
        if (!(tis).nil? && tis.attr_length > 0)
          data = tis[0].get_data
          if (!(data).nil?)
            return # children already there!
          end
        end
        BusyIndicator.show_while(widget.get_display, Class.new(Runnable.class == Class ? Runnable : Object) do
          extend LocalClass
          include_class_members AbstractTreeViewer
          include Runnable if Runnable.class == Module
          
          typesig { [] }
          define_method :run do
            # fix for PR 1FW89L7:
            # don't complain and remove all "dummies" ...
            if (!(tis).nil?)
              i = 0
              while i < tis.attr_length
                if (!(tis[i].get_data).nil?)
                  disassociate(tis[i])
                  Assert.is_true((tis[i].get_data).nil?, "Second or later child is non -null") # $NON-NLS-1$
                end
                tis[i].dispose
                i += 1
              end
            end
            d = widget.get_data
            if (!(d).nil?)
              parent_element = d
              children = nil
              if (is_tree_path_content_provider && widget.is_a?(self.class::Item))
                path = get_tree_path_from_item(widget)
                children = get_sorted_children(path)
              else
                children = get_sorted_children(parent_element)
              end
              i = 0
              while i < children.attr_length
                create_tree_item(widget, children[i], -1)
                i += 1
              end
            end
          end
          
          typesig { [] }
          define_method :initialize do
            super()
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      ensure
        set_busy(old_busy)
      end
    end
    
    typesig { [Widget, Object, ::Java::Int] }
    # Creates a single item for the given parent and synchronizes it with the
    # given element.
    # 
    # @param parent
    # the parent widget
    # @param element
    # the element
    # @param index
    # if non-negative, indicates the position to insert the item
    # into its parent
    def create_tree_item(parent, element, index)
      item = new_item(parent, SWT::NULL, index)
      update_item(item, element)
      update_plus(item, element)
    end
    
    typesig { [Item] }
    # The <code>AbstractTreeViewer</code> implementation of this method also
    # recurses over children of the corresponding element.
    def disassociate(item)
      super(item)
      # recursively unmapping the items is only required when
      # the hash map is used. In the other case disposing
      # an item will recursively dispose its children.
      if (using_element_map)
        disassociate_children(item)
      end
    end
    
    typesig { [Item] }
    # Disassociates the children of the given SWT item from their corresponding
    # elements.
    # 
    # @param item
    # the widget
    def disassociate_children(item)
      items = get_children(item)
      i = 0
      while i < items.attr_length
        if (!(items[i].get_data).nil?)
          disassociate(items[i])
        end
        i += 1
      end
    end
    
    typesig { [Object] }
    # (non-Javadoc) Method declared on StructuredViewer.
    def do_find_input_item(element)
      # compare with root
      root = get_root
      if ((root).nil?)
        return nil
      end
      if (self.==(root, element))
        return get_control
      end
      return nil
    end
    
    typesig { [Object] }
    # (non-Javadoc) Method declared on StructuredViewer.
    def do_find_item(element)
      # compare with root
      root = get_root
      if ((root).nil?)
        return nil
      end
      items = get_children(get_control)
      if (!(items).nil?)
        i = 0
        while i < items.attr_length
          o = internal_find_item(items[i], element)
          if (!(o).nil?)
            return o
          end
          i += 1
        end
      end
      return nil
    end
    
    typesig { [Item, Object] }
    # Copies the attributes of the given element into the given SWT item.
    # 
    # @param item
    # the SWT item
    # @param element
    # the element
    def do_update_item(item, element)
      if (item.is_disposed)
        unmap_element(element, item)
        return
      end
      column_count = do_get_column_count
      if ((column_count).equal?(0))
        # If no columns are created then fake one
        column_count = 1
      end
      viewer_row_from_item = get_viewer_row_from_item(item)
      is_virtual = !((get_control.get_style & SWT::VIRTUAL)).equal?(0)
      # If the control is virtual, we cannot use the cached viewer row object. See bug 188663.
      if (is_virtual)
        viewer_row_from_item = viewer_row_from_item.clone
      end
      column = 0
      while column < column_count
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
    
    typesig { [JavaList, Array.typed(Item)] }
    # Returns <code>true</code> if the given list and array of items refer to
    # the same model elements. Order is unimportant.
    # <p>
    # This method is not intended to be overridden by subclasses.
    # </p>
    # 
    # @param items
    # the list of items
    # @param current
    # the array of items
    # @return <code>true</code> if the refer to the same elements,
    # <code>false</code> otherwise
    # 
    # @since 3.1 in TreeViewer, moved to AbstractTreeViewer in 3.3
    def is_same_selection(items, current)
      # If they are not the same size then they are not equivalent
      n = items.size
      if (!(n).equal?(current.attr_length))
        return false
      end
      item_set = new_hashtable(n * 2 + 1)
      i = items.iterator
      while i.has_next
        item = i.next_
        element = item.get_data
        item_set.put(element, element)
      end
      # Go through the items of the current collection
      # If there is a mismatch return false
      i_ = 0
      while i_ < current.attr_length
        if ((current[i_].get_data).nil? || !item_set.contains_key(current[i_].get_data))
          return false
        end
        i_ += 1
      end
      return true
    end
    
    typesig { [Widget, Object, ::Java::Boolean] }
    # (non-Javadoc) Method declared on StructuredViewer.
    def do_update_item(widget, element, full_map)
      old_busy = is_busy
      set_busy(true)
      begin
        if (widget.is_a?(Item))
          item = widget
          # ensure that back pointer is correct
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
          # update icon and label
          SafeRunnable.run(UpdateItemSafeRunnable.new_local(self, item, element))
        end
      ensure
        set_busy(old_busy)
      end
    end
    
    typesig { [] }
    # Expands all nodes of the viewer's tree, starting with the root. This
    # method is equivalent to <code>expandToLevel(ALL_LEVELS)</code>.
    def expand_all
      expand_to_level(ALL_LEVELS)
    end
    
    typesig { [::Java::Int] }
    # Expands the root of the viewer's tree to the given level.
    # 
    # @param level
    # non-negative level, or <code>ALL_LEVELS</code> to expand all
    # levels of the tree
    def expand_to_level(level)
      expand_to_level(get_root, level)
    end
    
    typesig { [Object, ::Java::Int] }
    # Expands all ancestors of the given element or tree path so that the given
    # element becomes visible in this viewer's tree control, and then expands
    # the subtree rooted at the given element to the given level.
    # 
    # @param elementOrTreePath
    # the element
    # @param level
    # non-negative level, or <code>ALL_LEVELS</code> to expand all
    # levels of the tree
    def expand_to_level(element_or_tree_path, level)
      if (check_busy)
        return
      end
      w = internal_expand(element_or_tree_path, true)
      if (!(w).nil?)
        internal_expand_to_level(w, level)
      end
    end
    
    typesig { [TreeExpansionEvent] }
    # Fires a tree collapsed event. Only listeners registered at the time this
    # method is called are notified.
    # 
    # @param event
    # the tree expansion event
    # @see ITreeViewerListener#treeCollapsed
    def fire_tree_collapsed(event)
      listeners = @tree_listeners.get_listeners
      old_busy = is_busy
      set_busy(true)
      begin
        i = 0
        while i < listeners.attr_length
          l = listeners[i]
          SafeRunnable.run(Class.new(SafeRunnable.class == Class ? SafeRunnable : Object) do
            extend LocalClass
            include_class_members AbstractTreeViewer
            include SafeRunnable if SafeRunnable.class == Module
            
            typesig { [] }
            define_method :run do
              l.tree_collapsed(event)
            end
            
            typesig { [] }
            define_method :initialize do
              super()
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
          (i += 1)
        end
      ensure
        set_busy(old_busy)
      end
    end
    
    typesig { [TreeExpansionEvent] }
    # Fires a tree expanded event. Only listeners registered at the time this
    # method is called are notified.
    # 
    # @param event
    # the tree expansion event
    # @see ITreeViewerListener#treeExpanded
    def fire_tree_expanded(event)
      listeners = @tree_listeners.get_listeners
      old_busy = is_busy
      set_busy(true)
      begin
        i = 0
        while i < listeners.attr_length
          l = listeners[i]
          SafeRunnable.run(Class.new(SafeRunnable.class == Class ? SafeRunnable : Object) do
            extend LocalClass
            include_class_members AbstractTreeViewer
            include SafeRunnable if SafeRunnable.class == Module
            
            typesig { [] }
            define_method :run do
              l.tree_expanded(event)
            end
            
            typesig { [] }
            define_method :initialize do
              super()
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
          (i += 1)
        end
      ensure
        set_busy(old_busy)
      end
    end
    
    typesig { [] }
    # Returns the auto-expand level.
    # 
    # @return non-negative level, or <code>ALL_LEVELS</code> if all levels of
    # the tree are expanded automatically
    # @see #setAutoExpandLevel
    def get_auto_expand_level
      return @expand_to_level
    end
    
    typesig { [Widget] }
    # Returns the SWT child items for the given SWT widget.
    # 
    # @param widget
    # the widget
    # @return the child items
    def get_children(widget)
      raise NotImplementedError
    end
    
    typesig { [Widget, ::Java::Int] }
    # Get the child for the widget at index. Note that the default
    # implementation is not very efficient and should be overridden if this
    # class is implemented.
    # 
    # @param widget
    # the widget to check
    # @param index
    # the index of the widget
    # @return Item or <code>null</code> if widget is not a type that can
    # contain items.
    # 
    # @throws ArrayIndexOutOfBoundsException
    # if the index is not valid.
    # @since 3.1
    def get_child(widget, index)
      return get_children(widget)[index]
    end
    
    typesig { [Item] }
    # Returns whether the given SWT item is expanded or collapsed.
    # 
    # @param item
    # the item
    # @return <code>true</code> if the item is considered expanded and
    # <code>false</code> if collapsed
    def get_expanded(item)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns a list of elements corresponding to expanded nodes in this
    # viewer's tree, including currently hidden ones that are marked as
    # expanded but are under a collapsed ancestor.
    # <p>
    # This method is typically used when preserving the interesting state of a
    # viewer; <code>setExpandedElements</code> is used during the restore.
    # </p>
    # 
    # @return the array of expanded elements
    # @see #setExpandedElements
    def get_expanded_elements
      items = ArrayList.new
      internal_collect_expanded_items(items, get_control)
      result = ArrayList.new(items.size)
      it = items.iterator
      while it.has_next
        item = it.next_
        data = item.get_data
        if (!(data).nil?)
          result.add(data)
        end
      end
      return result.to_array
    end
    
    typesig { [Object] }
    # Returns whether the node corresponding to the given element or tree path
    # is expanded or collapsed.
    # 
    # @param elementOrTreePath
    # the element
    # @return <code>true</code> if the node is expanded, and
    # <code>false</code> if collapsed
    def get_expanded_state(element_or_tree_path)
      Assert.is_not_null(element_or_tree_path)
      item = internal_get_widget_to_select(element_or_tree_path)
      if (item.is_a?(Item))
        return get_expanded(item)
      end
      return false
    end
    
    typesig { [Control] }
    # Returns the number of child items of the given SWT control.
    # 
    # @param control
    # the control
    # @return the number of children
    def get_item_count(control)
      raise NotImplementedError
    end
    
    typesig { [Item] }
    # Returns the number of child items of the given SWT item.
    # 
    # @param item
    # the item
    # @return the number of children
    def get_item_count(item)
      raise NotImplementedError
    end
    
    typesig { [Item] }
    # Returns the child items of the given SWT item.
    # 
    # @param item
    # the item
    # @return the child items
    def get_items(item)
      raise NotImplementedError
    end
    
    typesig { [Item, ::Java::Boolean] }
    # Returns the item after the given item in the tree, or <code>null</code>
    # if there is no next item.
    # 
    # @param item
    # the item
    # @param includeChildren
    # <code>true</code> if the children are considered in
    # determining which item is next, and <code>false</code> if
    # subtrees are ignored
    # @return the next item, or <code>null</code> if none
    def get_next_item(item, include_children)
      if ((item).nil?)
        return nil
      end
      if (include_children && get_expanded(item))
        children = get_items(item)
        if (!(children).nil? && children.attr_length > 0)
          return children[0]
        end
      end
      # next item is either next sibling or next sibling of first
      # parent that has a next sibling.
      parent = get_parent_item(item)
      if ((parent).nil?)
        return nil
      end
      siblings = get_items(parent)
      if (!(siblings).nil?)
        if (siblings.attr_length <= 1)
          return get_next_item(parent, false)
        end
        i = 0
        while i < siblings.attr_length
          if ((siblings[i]).equal?(item) && i < (siblings.attr_length - 1))
            return siblings[i + 1]
          end
          i += 1
        end
      end
      return get_next_item(parent, false)
    end
    
    typesig { [Item] }
    # Returns the parent item of the given item in the tree, or
    # <code>null</code> if there is no parent item.
    # 
    # @param item
    # the item
    # @return the parent item, or <code>null</code> if none
    def get_parent_item(item)
      raise NotImplementedError
    end
    
    typesig { [Item] }
    # Returns the item before the given item in the tree, or <code>null</code>
    # if there is no previous item.
    # 
    # @param item
    # the item
    # @return the previous item, or <code>null</code> if none
    def get_previous_item(item)
      # previous item is either right-most visible descendent of previous
      # sibling or parent
      parent = get_parent_item(item)
      if ((parent).nil?)
        return nil
      end
      siblings = get_items(parent)
      if ((siblings.attr_length).equal?(0) || (siblings[0]).equal?(item))
        return parent
      end
      previous = siblings[0]
      i = 1
      while i < siblings.attr_length
        if ((siblings[i]).equal?(item))
          return right_most_visible_descendent(previous)
        end
        previous = siblings[i]
        i += 1
      end
      return nil
    end
    
    typesig { [Object] }
    # (non-Javadoc) Method declared on StructuredViewer.
    def get_raw_children(parent_element_or_tree_path)
      old_busy = is_busy
      set_busy(true)
      begin
        parent = nil
        path = nil
        if (parent_element_or_tree_path.is_a?(TreePath))
          path = parent_element_or_tree_path
          parent = path.get_last_segment
        else
          parent = parent_element_or_tree_path
          path = nil
        end
        if (!(parent).nil?)
          if (self.==(parent, get_root))
            return super(parent)
          end
          cp = get_content_provider
          if (cp.is_a?(ITreePathContentProvider))
            tpcp = cp
            if ((path).nil?)
              # A path was not provided so try and find one
              w = find_item(parent)
              if (w.is_a?(Item))
                item = w
                path = get_tree_path_from_item(item)
              end
              if ((path).nil?)
                path = TreePath.new(Array.typed(Object).new([parent]))
              end
            end
            result = tpcp.get_children(path)
            if (!(result).nil?)
              return result
            end
          else
            if (cp.is_a?(ITreeContentProvider))
              tcp = cp
              result = tcp.get_children(parent)
              if (!(result).nil?)
                return result
              end
            end
          end
        end
        return Array.typed(Object).new(0) { nil }
      ensure
        set_busy(old_busy)
      end
    end
    
    typesig { [Control] }
    # Returns all selected items for the given SWT control.
    # 
    # @param control
    # the control
    # @return the list of selected items
    def get_selection(control)
      raise NotImplementedError
    end
    
    typesig { [] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.viewers.StructuredViewer#getSelectionFromWidget()
    def get_selection_from_widget
      items = get_selection(get_control)
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
    
    typesig { [SelectionEvent] }
    # Overridden in AbstractTreeViewer to fix bug 108102 (code copied from
    # StructuredViewer to avoid introducing new API) (non-Javadoc)
    # 
    # @see org.eclipse.jface.viewers.StructuredViewer#handleDoubleSelect(org.eclipse.swt.events.SelectionEvent)
    def handle_double_select(event)
      # handle case where an earlier selection listener disposed the control.
      control = get_control
      if (!(control).nil? && !control.is_disposed)
        # If the double-clicked element can be obtained from the event, use
        # it
        # otherwise get it from the control. Some controls like List do
        # not have the notion of item.
        # For details, see bug 90161 [Navigator] DefaultSelecting folders
        # shouldn't always expand first one
        selection = nil
        if (!(event.attr_item).nil? && !(event.attr_item.get_data).nil?)
          # changes to fix bug 108102 follow
          tree_path = get_tree_path_from_item(event.attr_item)
          selection = TreeSelection.new(tree_path)
          # end of changes
        else
          selection = get_selection
          update_selection(selection)
        end
        fire_double_click(DoubleClickEvent.new(self, selection))
      end
    end
    
    typesig { [TreeEvent] }
    # Handles a tree collapse event from the SWT widget.
    # 
    # @param event
    # the SWT tree event
    def handle_tree_collapse(event)
      if (!(event.attr_item.get_data).nil?)
        fire_tree_collapsed(TreeExpansionEvent.new(self, event.attr_item.get_data))
      end
    end
    
    typesig { [TreeEvent] }
    # Handles a tree expand event from the SWT widget.
    # 
    # @param event
    # the SWT tree event
    def handle_tree_expand(event)
      create_children(event.attr_item)
      if (!(event.attr_item.get_data).nil?)
        fire_tree_expanded(TreeExpansionEvent.new(self, event.attr_item.get_data))
      end
    end
    
    typesig { [Control] }
    # (non-Javadoc) Method declared on Viewer.
    def hook_control(control)
      super(control)
      add_tree_listener(control, Class.new(TreeListener.class == Class ? TreeListener : Object) do
        extend LocalClass
        include_class_members AbstractTreeViewer
        include TreeListener if TreeListener.class == Module
        
        typesig { [TreeEvent] }
        define_method :tree_expanded do |event|
          handle_tree_expand(event)
        end
        
        typesig { [TreeEvent] }
        define_method :tree_collapsed do |event|
          handle_tree_collapse(event)
        end
        
        typesig { [] }
        define_method :initialize do
          super()
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
    end
    
    typesig { [Object, Object] }
    # (non-Javadoc) Method declared on StructuredViewer. Builds the initial
    # tree and handles the automatic expand feature.
    def input_changed(input, old_input)
      preserving_selection(Class.new(Runnable.class == Class ? Runnable : Object) do
        extend LocalClass
        include_class_members AbstractTreeViewer
        include Runnable if Runnable.class == Module
        
        typesig { [] }
        define_method :run do
          tree = get_control
          tree.set_redraw(false)
          begin
            remove_all(tree)
            tree.set_data(get_root)
            internal_initialize_tree(tree)
          ensure
            tree.set_redraw(true)
          end
        end
        
        typesig { [] }
        define_method :initialize do
          super()
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
    end
    
    typesig { [Control] }
    # Initializes the tree with root items, expanding to the appropriate
    # level if necessary.
    # 
    # @param tree the tree control
    # @since 3.3
    def internal_initialize_tree(tree)
      create_children(tree)
      internal_expand_to_level(tree, @expand_to_level)
    end
    
    typesig { [Widget, ::Java::Int] }
    # Recursively collapses the subtree rooted at the given widget to the given
    # level.
    # <p>
    # </p>
    # Note that the default implementation of this method does not call
    # <code>setRedraw</code>.
    # 
    # @param widget
    # the widget
    # @param level
    # non-negative level, or <code>ALL_LEVELS</code> to collapse
    # all levels of the tree
    def internal_collapse_to_level(widget, level)
      if ((level).equal?(ALL_LEVELS) || level > 0)
        if (widget.is_a?(Item))
          item = widget
          set_expanded(item, false)
          element = item.get_data
          if (!(element).nil? && (level).equal?(ALL_LEVELS))
            if (optionally_prune_children(item, element))
              return
            end
          end
        end
        if ((level).equal?(ALL_LEVELS) || level > 1)
          children = get_children(widget)
          if (!(children).nil?)
            next_level = ((level).equal?(ALL_LEVELS) ? ALL_LEVELS : level - 1)
            i = 0
            while i < children.attr_length
              internal_collapse_to_level(children[i], next_level)
              i += 1
            end
          end
        end
      end
    end
    
    typesig { [JavaList, Widget] }
    # Recursively collects all expanded items from the given widget.
    # 
    # @param result
    # a list (element type: <code>Item</code>) into which to
    # collect the elements
    # @param widget
    # the widget
    def internal_collect_expanded_items(result, widget)
      items = get_children(widget)
      i = 0
      while i < items.attr_length
        item = items[i]
        if (get_expanded(item))
          result.add(item)
        end
        internal_collect_expanded_items(result, item)
        i += 1
      end
    end
    
    typesig { [Object, ::Java::Boolean] }
    # Tries to create a path of tree items for the given element or tree path.
    # This method recursively walks up towards the root of the tree and in the
    # case of an element (rather than a tree path) assumes that
    # <code>getParent</code> returns the correct parent of an element.
    # 
    # @param elementOrPath
    # the element
    # @param expand
    # <code>true</code> if all nodes on the path should be
    # expanded, and <code>false</code> otherwise
    # @return Widget
    def internal_expand(element_or_path, expand)
      if ((element_or_path).nil?)
        return nil
      end
      w = internal_get_widget_to_select(element_or_path)
      if ((w).nil?)
        if (self.==(element_or_path, get_root))
          # stop at root
          return nil
        end
        # my parent has to create me
        parent = get_parent_element(element_or_path)
        if (!(parent).nil?)
          pw = internal_expand(parent, false)
          if (!(pw).nil?)
            # let my parent create me
            create_children(pw)
            element = internal_to_element(element_or_path)
            w = internal_find_child(pw, element)
            if (expand && pw.is_a?(Item))
              # expand parent items top-down
              item = pw
              to_expand_list = LinkedList.new
              while (!(item).nil? && !get_expanded(item))
                to_expand_list.add_first(item)
                item = get_parent_item(item)
              end
              it = to_expand_list.iterator
              while it.has_next
                to_expand = it.next_
                set_expanded(to_expand, true)
              end
            end
          end
        end
      end
      return w
    end
    
    typesig { [Object] }
    # If the argument is a tree path, returns its last segment, otherwise
    # return the argument
    # 
    # @param elementOrPath
    # an element or a tree path
    # @return the element, or the last segment of the tree path
    def internal_to_element(element_or_path)
      if (element_or_path.is_a?(TreePath))
        return (element_or_path).get_last_segment
      end
      return element_or_path
    end
    
    typesig { [Object] }
    # This method takes a tree path or an element. If the argument is not a
    # tree path, returns the parent of the given element or <code>null</code>
    # if the parent is not known. If the argument is a tree path with more than
    # one segment, returns its parent tree path, otherwise returns
    # <code>null</code>.
    # 
    # @param elementOrTreePath
    # @return the parent element, or parent path, or <code>null</code>
    # 
    # @since 3.2
    def get_parent_element(element_or_tree_path)
      if (element_or_tree_path.is_a?(TreePath))
        tree_path = element_or_tree_path
        return (tree_path).get_parent_path
      end
      cp = get_content_provider
      if (cp.is_a?(ITreePathContentProvider))
        tpcp = cp
        paths = tpcp.get_parents(element_or_tree_path)
        if (paths.attr_length > 0)
          if ((paths[0].get_segment_count).equal?(0))
            return get_root
          end
          return paths[0].get_last_segment
        end
      end
      if (cp.is_a?(ITreeContentProvider))
        tcp = cp
        return tcp.get_parent(element_or_tree_path)
      end
      return nil
    end
    
    typesig { [Object] }
    # Returns the widget to be selected for the given element or tree path.
    # 
    # @param elementOrTreePath
    # the element or tree path to select
    # @return the widget to be selected, or <code>null</code> if not found
    # 
    # @since 3.1
    def internal_get_widget_to_select(element_or_tree_path)
      if (element_or_tree_path.is_a?(TreePath))
        tree_path = element_or_tree_path
        if ((tree_path.get_segment_count).equal?(0))
          return get_control
        end
        candidates = find_items(tree_path.get_last_segment)
        i = 0
        while i < candidates.attr_length
          candidate = candidates[i]
          if (!(candidate.is_a?(Item)))
            i += 1
            next
          end
          if ((tree_path == get_tree_path_from_item(candidate)))
            return candidate
          end
          i += 1
        end
        return nil
      end
      return find_item(element_or_tree_path)
    end
    
    typesig { [Widget, ::Java::Int] }
    # Recursively expands the subtree rooted at the given widget to the given
    # level.
    # <p>
    # </p>
    # Note that the default implementation of this method does not call
    # <code>setRedraw</code>.
    # 
    # @param widget
    # the widget
    # @param level
    # non-negative level, or <code>ALL_LEVELS</code> to collapse
    # all levels of the tree
    def internal_expand_to_level(widget, level)
      if ((level).equal?(ALL_LEVELS) || level > 0)
        if (widget.is_a?(Item) && !(widget.get_data).nil? && !is_expandable(widget, nil, widget.get_data))
          return
        end
        create_children(widget)
        if (widget.is_a?(Item))
          set_expanded(widget, true)
        end
        if ((level).equal?(ALL_LEVELS) || level > 1)
          children = get_children(widget)
          if (!(children).nil?)
            new_level = ((level).equal?(ALL_LEVELS) ? ALL_LEVELS : level - 1)
            i = 0
            while i < children.attr_length
              internal_expand_to_level(children[i], new_level)
              i += 1
            end
          end
        end
      end
    end
    
    typesig { [Widget, Object] }
    # Non-recursively tries to find the given element as a child of the given
    # parent (item or tree).
    # 
    # @param parent
    # the parent item
    # @param element
    # the element
    # @return Widget
    def internal_find_child(parent, element)
      items = get_children(parent)
      i = 0
      while i < items.attr_length
        item = items[i]
        data = item.get_data
        if (!(data).nil? && self.==(data, element))
          return item
        end
        i += 1
      end
      return nil
    end
    
    typesig { [Item, Object] }
    # Recursively tries to find the given element.
    # 
    # @param parent
    # the parent item
    # @param element
    # the element
    # @return Widget
    def internal_find_item(parent, element)
      # compare with node
      data = parent.get_data
      if (!(data).nil?)
        if (self.==(data, element))
          return parent
        end
      end
      # recurse over children
      items = get_children(parent)
      i = 0
      while i < items.attr_length
        item = items[i]
        o = internal_find_item(item, element)
        if (!(o).nil?)
          return o
        end
        i += 1
      end
      return nil
    end
    
    typesig { [Object] }
    # (non-Javadoc) Method declared on StructuredViewer.
    def internal_refresh(element)
      internal_refresh(element, true)
    end
    
    typesig { [Object, ::Java::Boolean] }
    # (non-Javadoc) Method declared on StructuredViewer.
    def internal_refresh(element, update_labels)
      # If element is null, do a full refresh.
      if ((element).nil?)
        internal_refresh(get_control, get_root, true, update_labels)
        return
      end
      items = find_items(element)
      if (!(items.attr_length).equal?(0))
        i = 0
        while i < items.attr_length
          # pick up structure changes too
          internal_refresh(items[i], element, true, update_labels)
          i += 1
        end
      end
    end
    
    typesig { [Widget, Object, ::Java::Boolean, ::Java::Boolean] }
    # Refreshes the tree starting at the given widget.
    # <p>
    # EXPERIMENTAL. Not to be used except by JDT. This method was added to
    # support JDT's explorations into grouping by working sets, which requires
    # viewers to support multiple equal elements. See bug 76482 for more
    # details. This support will likely be removed in Eclipse 3.2 in favor of
    # proper support for multiple equal elements.
    # </p>
    # 
    # @param widget
    # the widget
    # @param element
    # the element
    # @param doStruct
    # <code>true</code> if structural changes are to be picked up,
    # and <code>false</code> if only label provider changes are of
    # interest
    # @param updateLabels
    # <code>true</code> to update labels for existing elements,
    # <code>false</code> to only update labels as needed, assuming
    # that labels for existing elements are unchanged.
    # @since 3.1
    def internal_refresh(widget, element, do_struct, update_labels)
      if (widget.is_a?(Item))
        if (do_struct)
          update_plus(widget, element)
        end
        if (update_labels || !self.==(element, widget.get_data))
          do_update_item(widget, element, true)
        else
          associate(element, widget)
        end
      end
      if (do_struct)
        internal_refresh_struct(widget, element, update_labels)
      else
        children = get_children(widget)
        if (!(children).nil?)
          i = 0
          while i < children.attr_length
            item = children[i]
            data = item.get_data
            if (!(data).nil?)
              internal_refresh(item, data, do_struct, update_labels)
            end
            i += 1
          end
        end
      end
    end
    
    typesig { [Widget, Object, ::Java::Boolean] }
    # Update the structure and recurse. Items are updated in updateChildren, as
    # needed.
    # 
    # @param widget
    # @param element
    # @param updateLabels
    # 
    # package
    def internal_refresh_struct(widget, element, update_labels)
      update_children(widget, element, nil, update_labels)
      children = get_children(widget)
      if (!(children).nil?)
        i = 0
        while i < children.attr_length
          item = children[i]
          data = item.get_data
          if (!(data).nil?)
            internal_refresh_struct(item, data, update_labels)
          end
          i += 1
        end
      end
    end
    
    typesig { [Array.typed(Object)] }
    # Removes the given elements from this viewer.
    # <p>
    # EXPERIMENTAL. Not to be used except by JDT. This method was added to
    # support JDT's explorations into grouping by working sets, which requires
    # viewers to support multiple equal elements. See bug 76482 for more
    # details. This support will likely be removed in Eclipse 3.2 in favor of
    # proper support for multiple equal elements.
    # </p>
    # 
    # @param elementsOrPaths
    # the elements or element paths to remove
    # @since 3.1
    def internal_remove(elements_or_paths)
      input = get_input
      i = 0
      while i < elements_or_paths.attr_length
        element = elements_or_paths[i]
        if (self.==(element, input))
          set_input(nil)
          return
        end
        child_items = internal_find_items(element)
        if (child_items.attr_length > 0)
          j = 0
          while j < child_items.attr_length
            child_item = child_items[j]
            if (child_item.is_a?(Item))
              disassociate(child_item)
              child_item.dispose
            end
            j += 1
          end
        else
          # see https://bugs.eclipse.org/bugs/show_bug.cgi?id=210747
          parent = get_parent_element(element)
          if (!(parent).nil? && !self.==(parent, get_root) && !(parent.is_a?(TreePath) && ((parent).get_segment_count).equal?(0)))
            parent_items = internal_find_items(parent)
            j = 0
            while j < parent_items.attr_length
              parent_item = parent_items[j]
              if (parent_item.is_a?(Item))
                update_plus(parent_item, parent)
              end
              j += 1
            end
          end
        end
        (i += 1)
      end
    end
    
    typesig { [Object, Array.typed(Object)] }
    # Removes the given elements from this viewer, whenever those elements
    # appear as children of the given parent.
    # 
    # @param parent the parent element
    # @param elements
    # the elements to remove
    # @since 3.1
    def internal_remove(parent, elements)
      to_remove = CustomHashtable.new(get_comparer)
      i = 0
      while i < elements.attr_length
        to_remove.put(elements[i], elements[i])
        i += 1
      end
      # Find each place the parent appears in the tree
      parent_item_array = find_items(parent)
      i_ = 0
      while i_ < parent_item_array.attr_length
        parent_item = parent_item_array[i_]
        # May happen if parent element is a descendent of of a previously
        # removed element
        if (parent_item.is_disposed)
          i_ += 1
          next
        end
        # Iterate over the child items and remove each one
        children = get_children(parent_item)
        if ((children.attr_length).equal?(1) && (children[0].get_data).nil? && parent_item.is_a?(Item))
          # dummy node
          # Remove plus if parent element has no children
          update_plus(parent_item, parent)
        else
          j = 0
          while j < children.attr_length
            child = children[j]
            data = child.get_data
            if (!(data).nil? && to_remove.contains_key(data))
              disassociate(child)
              child.dispose
            end
            j += 1
          end
        end
        i_ += 1
      end
    end
    
    typesig { [CustomHashtable, Widget] }
    # Sets the expanded state of all items to correspond to the given set of
    # expanded elements.
    # 
    # @param expandedElements
    # the set (element type: <code>Object</code>) of elements
    # which are expanded
    # @param widget
    # the widget
    def internal_set_expanded(expanded_elements, widget)
      items = get_children(widget)
      i = 0
      while i < items.attr_length
        item = items[i]
        data = item.get_data
        if (!(data).nil?)
          # remove the element to avoid an infinite loop
          # if the same element appears on a child item
          expanded = !(expanded_elements.remove(data)).nil?
          if (!(expanded).equal?(get_expanded(item)))
            if (expanded)
              create_children(item)
            end
            set_expanded(item, expanded)
          end
        end
        if (expanded_elements.size > 0)
          internal_set_expanded(expanded_elements, item)
        end
        i += 1
      end
    end
    
    typesig { [CustomHashtable, Widget, TreePath] }
    # Sets the expanded state of all items to correspond to the given set of
    # expanded tree paths.
    # 
    # @param expandedTreePaths
    # the set (element type: <code>TreePath</code>) of elements
    # which are expanded
    # @param widget
    # the widget
    def internal_set_expanded_tree_paths(expanded_tree_paths, widget, current_path)
      items = get_children(widget)
      i = 0
      while i < items.attr_length
        item = items[i]
        data = item.get_data
        child_path = (data).nil? ? nil : current_path.create_child_path(data)
        if (!(data).nil? && !(child_path).nil?)
          # remove the element to avoid an infinite loop
          # if the same element appears on a child item
          expanded = !(expanded_tree_paths.remove(child_path)).nil?
          if (!(expanded).equal?(get_expanded(item)))
            if (expanded)
              create_children(item)
            end
            set_expanded(item, expanded)
          end
        end
        internal_set_expanded_tree_paths(expanded_tree_paths, item, child_path)
        i += 1
      end
    end
    
    typesig { [Object] }
    # Return whether the tree node representing the given element or path can
    # be expanded. Clients should query expandability by path if the viewer's
    # content provider is an {@link ITreePathContentProvider}.
    # <p>
    # The default implementation of this framework method calls
    # <code>hasChildren</code> on this viewer's content provider. It may be
    # overridden if necessary.
    # </p>
    # 
    # @param elementOrTreePath
    # the element or path
    # @return <code>true</code> if the tree node representing the given
    # element can be expanded, or <code>false</code> if not
    def is_expandable(element_or_tree_path)
      element = nil
      path = nil
      if (element_or_tree_path.is_a?(TreePath))
        path = element_or_tree_path
        element = path.get_last_segment
      else
        element = element_or_tree_path
        path = nil
      end
      cp = get_content_provider
      if (cp.is_a?(ITreePathContentProvider))
        tpcp = cp
        if ((path).nil?)
          # A path was not provided so try and find one
          w = find_item(element)
          if (w.is_a?(Item))
            item = w
            path = get_tree_path_from_item(item)
          end
          if ((path).nil?)
            path = TreePath.new(Array.typed(Object).new([element]))
          end
        end
        return tpcp.has_children(path)
      end
      if (cp.is_a?(ITreeContentProvider))
        tcp = cp
        return tcp.has_children(element)
      end
      return false
    end
    
    typesig { [Item, TreePath, Object] }
    # Return whether the given element is expandable.
    # 
    # @param item
    # the tree item for the element
    # @param parentPath
    # the parent path if it is known or <code>null</code> if it
    # needs to be determines
    # @param element
    # the element
    # @return whether the given element is expandable
    def is_expandable(item, parent_path, element)
      element_or_tree_path = element
      if (is_tree_path_content_provider)
        if (!(parent_path).nil?)
          element_or_tree_path = parent_path.create_child_path(element)
        else
          element_or_tree_path = get_tree_path_from_item(item)
        end
      end
      return is_expandable(element_or_tree_path)
    end
    
    typesig { [] }
    # (non-Javadoc) Method declared on Viewer.
    def label_provider_changed
      # we have to walk the (visible) tree and update every item
      tree = get_control
      tree.set_redraw(false)
      # don't pick up structure changes, but do force label updates
      internal_refresh(tree, get_root, false, true)
      tree.set_redraw(true)
    end
    
    typesig { [Widget, ::Java::Int, ::Java::Int] }
    # Creates a new item.
    # 
    # @param parent
    # the parent widget
    # @param style
    # SWT style bits
    # @param index
    # if non-negative, indicates the position to insert the item
    # into its parent
    # @return the newly-created item
    def new_item(parent, style, index)
      raise NotImplementedError
    end
    
    typesig { [Array.typed(Object)] }
    # Removes the given elements from this viewer. The selection is updated if
    # required.
    # <p>
    # This method should be called (by the content provider) when elements have
    # been removed from the model, in order to cause the viewer to accurately
    # reflect the model. This method only affects the viewer, not the model.
    # </p>
    # 
    # @param elementsOrTreePaths
    # the elements to remove
    def remove(elements_or_tree_paths)
      assert_elements_not_null(elements_or_tree_paths)
      if ((elements_or_tree_paths.attr_length).equal?(0))
        return
      end
      if (check_busy)
        return
      end
      preserving_selection(Class.new(Runnable.class == Class ? Runnable : Object) do
        extend LocalClass
        include_class_members AbstractTreeViewer
        include Runnable if Runnable.class == Module
        
        typesig { [] }
        define_method :run do
          internal_remove(elements_or_tree_paths)
        end
        
        typesig { [] }
        define_method :initialize do
          super()
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
    end
    
    typesig { [Object, Array.typed(Object)] }
    # Removes the given elements from this viewer whenever they appear as
    # children of the given parent element. If the given elements also appear
    # as children of some other parent, the other parent will remain unchanged.
    # The selection is updated if required.
    # <p>
    # This method should be called (by the content provider) when elements have
    # been removed from the model, in order to cause the viewer to accurately
    # reflect the model. This method only affects the viewer, not the model.
    # </p>
    # 
    # @param parent
    # the parent of the elements to remove
    # @param elements
    # the elements to remove
    # 
    # @since 3.2
    def remove(parent, elements)
      assert_elements_not_null(elements)
      if ((elements.attr_length).equal?(0))
        return
      end
      if (check_busy)
        return
      end
      preserving_selection(Class.new(Runnable.class == Class ? Runnable : Object) do
        extend LocalClass
        include_class_members AbstractTreeViewer
        include Runnable if Runnable.class == Module
        
        typesig { [] }
        define_method :run do
          internal_remove(parent, elements)
        end
        
        typesig { [] }
        define_method :initialize do
          super()
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
    end
    
    typesig { [Object] }
    # Removes the given element from the viewer. The selection is updated if
    # necessary.
    # <p>
    # This method should be called (by the content provider) when a single
    # element has been removed from the model, in order to cause the viewer to
    # accurately reflect the model. This method only affects the viewer, not
    # the model. Note that there is another method for efficiently processing
    # the simultaneous removal of multiple elements.
    # </p>
    # 
    # @param elementsOrTreePaths
    # the element
    def remove(elements_or_tree_paths)
      remove(Array.typed(Object).new([elements_or_tree_paths]))
    end
    
    typesig { [Control] }
    # Removes all items from the given control.
    # 
    # @param control
    # the control
    def remove_all(control)
      raise NotImplementedError
    end
    
    typesig { [ITreeViewerListener] }
    # Removes a listener for expand and collapse events in this viewer. Has no
    # affect if an identical listener is not registered.
    # 
    # @param listener
    # a tree viewer listener
    def remove_tree_listener(listener)
      @tree_listeners.remove(listener)
    end
    
    typesig { [Object] }
    # This implementation of reveal() reveals the given element or tree path.
    def reveal(element_or_tree_path)
      Assert.is_not_null(element_or_tree_path)
      w = internal_expand(element_or_tree_path, true)
      if (w.is_a?(Item))
        show_item(w)
      end
    end
    
    typesig { [Item] }
    # Returns the rightmost visible descendent of the given item. Returns the
    # item itself if it has no children.
    # 
    # @param item
    # the item to compute the descendent of
    # @return the rightmost visible descendent or the item itself if it has no
    # children
    def right_most_visible_descendent(item)
      children = get_items(item)
      if (get_expanded(item) && !(children).nil? && children.attr_length > 0)
        return right_most_visible_descendent(children[children.attr_length - 1])
      end
      return item
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # (non-Javadoc) Method declared on Viewer.
    def scroll_down(x, y)
      current = get_item(x, y)
      if (!(current).nil?)
        next__ = get_next_item(current, true)
        show_item((next__).nil? ? current : next__)
        return next__
      end
      return nil
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # (non-Javadoc) Method declared on Viewer.
    def scroll_up(x, y)
      current = get_item(x, y)
      if (!(current).nil?)
        previous = get_previous_item(current)
        show_item((previous).nil? ? current : previous)
        return previous
      end
      return nil
    end
    
    typesig { [::Java::Int] }
    # Sets the auto-expand level to be used when the input of the viewer is set
    # using {@link #setInput(Object)}. The value 0 means that there is no
    # auto-expand; 1 means that the invisible root element is expanded (since
    # most concrete subclasses do not show the root element, there is usually
    # no practical difference between using the values 0 and 1); 2 means that
    # top-level elements are expanded, but not their children; 3 means that
    # top-level elements are expanded, and their children, but not
    # grandchildren; and so on.
    # <p>
    # The value <code>ALL_LEVELS</code> means that all subtrees should be
    # expanded.
    # </p>
    # <p>
    # Note that in previous releases, the Javadoc for this method had an off-by
    # one error. See bug 177669 for details.
    # </p>
    # 
    # @param level
    # non-negative level, or <code>ALL_LEVELS</code> to expand all
    # levels of the tree
    def set_auto_expand_level(level)
      @expand_to_level = level
    end
    
    typesig { [IContentProvider] }
    # The <code>AbstractTreeViewer</code> implementation of this method
    # checks to ensure that the content provider is an
    # <code>ITreeContentProvider</code>.
    def set_content_provider(provider)
      # the actual check is in assertContentProviderType
      super(provider)
    end
    
    typesig { [IContentProvider] }
    def assert_content_provider_type(provider)
      Assert.is_true(provider.is_a?(ITreeContentProvider) || provider.is_a?(ITreePathContentProvider))
    end
    
    typesig { [Item, ::Java::Boolean] }
    # Sets the expand state of the given item.
    # 
    # @param item
    # the item
    # @param expand
    # the expand state of the item
    def set_expanded(item, expand)
      raise NotImplementedError
    end
    
    typesig { [Array.typed(Object)] }
    # Sets which nodes are expanded in this viewer's tree. The given list
    # contains the elements that are to be expanded; all other nodes are to be
    # collapsed.
    # <p>
    # This method is typically used when restoring the interesting state of a
    # viewer captured by an earlier call to <code>getExpandedElements</code>.
    # </p>
    # 
    # @param elements
    # the array of expanded elements
    # @see #getExpandedElements
    def set_expanded_elements(elements)
      assert_elements_not_null(elements)
      if (check_busy)
        return
      end
      expanded_elements = new_hashtable(elements.attr_length * 2 + 1)
      i = 0
      while i < elements.attr_length
        element = elements[i]
        # Ensure item exists for element. This will materialize items for
        # each element and their parents, if possible. This is important
        # to support expanding of inner tree nodes without necessarily
        # expanding their parents.
        internal_expand(element, false)
        expanded_elements.put(element, element)
        (i += 1)
      end
      # this will traverse all existing items, and create children for
      # elements that need to be expanded. If the tree contains multiple
      # equal elements, and those are in the set of elements to be expanded,
      # only the first item found for each element will be expanded.
      internal_set_expanded(expanded_elements, get_control)
    end
    
    typesig { [Array.typed(TreePath)] }
    # Sets which nodes are expanded in this viewer's tree. The given list
    # contains the tree paths that are to be expanded; all other nodes are to
    # be collapsed.
    # <p>
    # This method is typically used when restoring the interesting state of a
    # viewer captured by an earlier call to <code>getExpandedTreePaths</code>.
    # </p>
    # 
    # @param treePaths
    # the array of expanded tree paths
    # @see #getExpandedTreePaths()
    # 
    # @since 3.2
    def set_expanded_tree_paths(tree_paths)
      assert_elements_not_null(tree_paths)
      if (check_busy)
        return
      end
      comparer = get_comparer
      tree_path_comparer = Class.new(IElementComparer.class == Class ? IElementComparer : Object) do
        extend LocalClass
        include_class_members AbstractTreeViewer
        include IElementComparer if IElementComparer.class == Module
        
        typesig { [Object, Object] }
        define_method :== do |a, b|
          return ((a) == (b))
        end
        
        typesig { [Object] }
        define_method :hash_code do |element|
          return (element).hash_code(comparer)
        end
        
        typesig { [] }
        define_method :initialize do
          super()
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
      expanded_tree_paths = CustomHashtable.new(tree_paths.attr_length * 2 + 1, tree_path_comparer)
      i = 0
      while i < tree_paths.attr_length
        tree_path = tree_paths[i]
        # Ensure item exists for element. This will materialize items for
        # each element and their parents, if possible. This is important
        # to support expanding of inner tree nodes without necessarily
        # expanding their parents.
        internal_expand(tree_path, false)
        expanded_tree_paths.put(tree_path, tree_path)
        (i += 1)
      end
      # this will traverse all existing items, and create children for
      # elements that need to be expanded. If the tree contains multiple
      # equal elements, and those are in the set of elements to be expanded,
      # only the first item found for each element will be expanded.
      internal_set_expanded_tree_paths(expanded_tree_paths, get_control, TreePath.new(Array.typed(Object).new(0) { nil }))
    end
    
    typesig { [Object, ::Java::Boolean] }
    # Sets whether the node corresponding to the given element or tree path is
    # expanded or collapsed.
    # 
    # @param elementOrTreePath
    # the element
    # @param expanded
    # <code>true</code> if the node is expanded, and
    # <code>false</code> if collapsed
    def set_expanded_state(element_or_tree_path, expanded)
      Assert.is_not_null(element_or_tree_path)
      if (check_busy)
        return
      end
      item = internal_expand(element_or_tree_path, false)
      if (item.is_a?(Item))
        if (expanded)
          create_children(item)
        end
        set_expanded(item, expanded)
      end
    end
    
    typesig { [JavaList] }
    # Sets the selection to the given list of items.
    # 
    # @param items
    # list of items (element type:
    # <code>org.eclipse.swt.widgets.Item</code>)
    def set_selection(items)
      raise NotImplementedError
    end
    
    typesig { [JavaList, ::Java::Boolean] }
    # This implementation of setSelectionToWidget accepts a list of elements or
    # a list of tree paths.
    def set_selection_to_widget(v, reveal)
      if ((v).nil?)
        set_selection(ArrayList.new(0))
        return
      end
      size_ = v.size
      new_selection = ArrayList.new(size_)
      i = 0
      while i < size_
        element_or_tree_path = v.get(i)
        # Use internalExpand since item may not yet be created. See
        # 1G6B1AR.
        w = internal_expand(element_or_tree_path, false)
        if (w.is_a?(Item))
          new_selection.add(w)
        else
          if ((w).nil? && element_or_tree_path.is_a?(TreePath))
            tree_path = element_or_tree_path
            element = tree_path.get_last_segment
            if (!(element).nil?)
              w = internal_expand(element, false)
              if (w.is_a?(Item))
                new_selection.add(w)
              end
            end
          end
        end
        (i += 1)
      end
      set_selection(new_selection)
      # Although setting the selection in the control should reveal it,
      # setSelection may be a no-op if the selection is unchanged,
      # so explicitly reveal items in the selection here.
      # See bug 100565 for more details.
      if (reveal && new_selection.size > 0)
        # Iterate backwards so the first item in the list
        # is the one guaranteed to be visible
        i_ = (new_selection.size - 1)
        while i_ >= 0
          show_item(new_selection.get(i_))
          i_ -= 1
        end
      end
    end
    
    typesig { [Item] }
    # Shows the given item.
    # 
    # @param item
    # the item
    def show_item(item)
      raise NotImplementedError
    end
    
    typesig { [Widget, Object, Array.typed(Object)] }
    # Updates the tree items to correspond to the child elements of the given
    # parent element. If null is passed for the children, this method obtains
    # them (only if needed).
    # 
    # @param widget
    # the widget
    # @param parent
    # the parent element
    # @param elementChildren
    # the child elements, or null
    # @deprecated this is no longer called by the framework
    def update_children(widget, parent, element_children)
      update_children(widget, parent, element_children, true)
    end
    
    typesig { [Widget, Object, Array.typed(Object), ::Java::Boolean] }
    # Updates the tree items to correspond to the child elements of the given
    # parent element. If null is passed for the children, this method obtains
    # them (only if needed).
    # 
    # @param widget
    # the widget
    # @param parent
    # the parent element
    # @param elementChildren
    # the child elements, or null
    # @param updateLabels
    # <code>true</code> to update labels for existing elements,
    # <code>false</code> to only update labels as needed, assuming
    # that labels for existing elements are unchanged.
    # @since 2.1
    def update_children(widget, parent, element_children, update_labels)
      # optimization! prune collapsed subtrees
      if (widget.is_a?(Item))
        ti = widget
        if (!get_expanded(ti))
          if (optionally_prune_children(ti, parent))
            # children were pruned, nothing left to do
            return
          end
          # The following code is being executed if children were not pruned.
          # This is (as of 3.5) only the case for CheckboxTreeViewer.
          its = get_items(ti)
          if (is_expandable(ti, nil, parent))
            if ((its.attr_length).equal?(0))
              # need dummy node
              new_item(ti, SWT::NULL, -1)
              return
            else
              if ((its.attr_length).equal?(1) && (its[0].get_data).nil?)
                # dummy node exists, nothing left to do
                return
              end
            end
            # else fall through to normal update code below
          else
            i = 0
            while i < its.attr_length
              if (!(its[i].get_data).nil?)
                disassociate(its[i])
              end
              its[i].dispose
              i += 1
            end
            # nothing left to do
            return
          end
        end
      end
      # If the children weren't passed in, get them now since they're needed
      # below.
      if ((element_children).nil?)
        if (is_tree_path_content_provider && widget.is_a?(Item))
          path = get_tree_path_from_item(widget)
          element_children = get_sorted_children(path)
        else
          element_children = get_sorted_children(parent)
        end
      end
      tree = get_control
      # WORKAROUND
      old_cnt = -1
      if ((widget).equal?(tree))
        old_cnt = get_item_count(tree)
      end
      items = get_children(widget)
      # save the expanded elements
      expanded = new_hashtable(CustomHashtable::DEFAULT_CAPACITY) # assume
      # num
      # expanded
      # is
      # small
      i = 0
      while i < items.attr_length
        if (get_expanded(items[i]))
          element = items[i].get_data
          if (!(element).nil?)
            expanded.put(element, element)
          end
        end
        (i += 1)
      end
      min_ = Math.min(element_children.attr_length, items.attr_length)
      # dispose of surplus items, optimizing for the case where elements have
      # been deleted but not reordered, or all elements have been removed.
      num_items_to_dispose = items.attr_length - min_
      if (num_items_to_dispose > 0)
        children = new_hashtable(element_children.attr_length * 2)
        i_ = 0
        while i_ < element_children.attr_length
          element_child = element_children[i_]
          children.put(element_child, element_child)
          i_ += 1
        end
        i__ = 0
        while (num_items_to_dispose > 0 && i__ < items.attr_length)
          data = items[i__].get_data
          if ((data).nil? || items.attr_length - i__ <= num_items_to_dispose || !children.contains_key(data))
            if (!(data).nil?)
              disassociate(items[i__])
            end
            items[i__].dispose
            if (i__ + 1 < items.attr_length)
              # The components at positions i+1 through
              # items.length-1 in the source array are copied into
              # positions i through items.length-2
              System.arraycopy(items, i__ + 1, items, i__, items.attr_length - (i__ + 1))
            end
            num_items_to_dispose -= 1
          else
            i__ += 1
          end
        end
      end
      # compare first min items, and update item if necessary
      # need to do it in two passes:
      # 1: disassociate old items
      # 2: associate new items
      # because otherwise a later disassociate can remove a mapping made for
      # a previous associate,
      # making the map inconsistent
      i_ = 0
      while i_ < min_
        item = items[i_]
        old_element = item.get_data
        if (!(old_element).nil?)
          new_element = element_children[i_]
          if (!(new_element).equal?(old_element))
            if (self.==(new_element, old_element))
              # update the data to be the new element, since
              # although the elements
              # may be equal, they may still have different labels
              # or children
              data = item.get_data
              if (!(data).nil?)
                unmap_element(data, item)
              end
              item.set_data(new_element)
              map_element(new_element, item)
            else
              disassociate(item)
              # Clear the text and image to force a label update
              item.set_image(nil)
              item.set_text("") # $NON-NLS-1$
            end
          end
        end
        (i_ += 1)
      end
      i__ = 0
      while i__ < min_
        item = items[i__]
        new_element = element_children[i__]
        if ((item.get_data).nil?)
          # old and new elements are not equal
          associate(new_element, item)
          update_plus(item, new_element)
          update_item(item, new_element)
        else
          # old and new elements are equal
          update_plus(item, new_element)
          if (update_labels)
            update_item(item, new_element)
          end
        end
        (i__ += 1)
      end
      # Restore expanded state for items that changed position.
      # Make sure setExpanded is called after updatePlus, since
      # setExpanded(false) fails if item has no children.
      # Need to call setExpanded for both expanded and unexpanded
      # cases since the expanded state can change either way.
      # This needs to be done in a second loop, see bug 148025.
      i___ = 0
      while i___ < min_
        item = items[i___]
        new_element = element_children[i___]
        set_expanded(item, expanded.contains_key(new_element))
        (i___ += 1)
      end
      # add any remaining elements
      if (min_ < element_children.attr_length)
        i____ = min_
        while i____ < element_children.attr_length
          create_tree_item(widget, element_children[i____], i____)
          (i____ += 1)
        end
        # Need to restore expanded state in a separate pass
        # because createTreeItem does not return the new item.
        # Avoid doing this unless needed.
        if (expanded.size > 0)
          # get the items again, to include the new items
          items = get_children(widget)
          i_____ = min_
          while i_____ < element_children.attr_length
            # Restore expanded state for items that changed position.
            # Make sure setExpanded is called after updatePlus (called
            # in createTreeItem), since
            # setExpanded(false) fails if item has no children.
            # Only need to call setExpanded if element was expanded
            # since new items are initially unexpanded.
            if (expanded.contains_key(element_children[i_____]))
              set_expanded(items[i_____], true)
            end
            (i_____ += 1)
          end
        end
      end
      # WORKAROUND
      if ((widget).equal?(tree) && (old_cnt).equal?(0) && !(get_item_count(tree)).equal?(0))
        # System.out.println("WORKAROUND setRedraw");
        tree.set_redraw(false)
        tree.set_redraw(true)
      end
    end
    
    typesig { [Item, Object] }
    # Returns true if children were pruned
    # package
    def optionally_prune_children(item, element)
      # need a dummy node if element is expandable;
      # but try to avoid recreating the dummy node
      need_dummy = is_expandable(item, nil, element)
      have_dummy = false
      # remove all children
      items = get_items(item)
      i = 0
      while i < items.attr_length
        if (!(items[i].get_data).nil?)
          disassociate(items[i])
          items[i].dispose
        else
          if (need_dummy && !have_dummy)
            have_dummy = true
          else
            items[i].dispose
          end
        end
        i += 1
      end
      if (need_dummy && !have_dummy)
        new_item(item, SWT::NULL, -1)
      end
      return true
    end
    
    typesig { [Widget, Array.typed(Object)] }
    # Not to be called by clients. Return the items to be refreshed as part of
    # an update. elementChildren are the new elements.
    # 
    # @param widget
    # @param elementChildren
    # @since 3.4
    # @return Item[]
    # 
    # @deprecated This method was inadvertently released as API but is not
    # intended to be called by clients.
    def get_children(widget, element_children)
      return get_children(widget)
    end
    
    typesig { [Item, Object] }
    # Updates the "+"/"-" icon of the tree node from the given element. It
    # calls <code>isExpandable</code> to determine whether an element is
    # expandable.
    # 
    # @param item
    # the item
    # @param element
    # the element
    def update_plus(item, element)
      has_plus = get_item_count(item) > 0
      needs_plus = is_expandable(item, nil, element)
      remove_all = false
      add_dummy = false
      data = item.get_data
      if (!(data).nil? && self.==(element, data))
        # item shows same element
        if (!(has_plus).equal?(needs_plus))
          if (needs_plus)
            add_dummy = true
          else
            remove_all = true
          end
        end
      else
        # item shows different element
        remove_all = true
        add_dummy = needs_plus
        # we cannot maintain expand state so collapse it
        set_expanded(item, false)
      end
      if (remove_all)
        # remove all children
        items = get_items(item)
        i = 0
        while i < items.attr_length
          if (!(items[i].get_data).nil?)
            disassociate(items[i])
          end
          items[i].dispose
          i += 1
        end
      end
      if (add_dummy)
        new_item(item, SWT::NULL, -1) # append a dummy
      end
    end
    
    typesig { [] }
    # Gets the expanded elements that are visible to the user. An expanded
    # element is only visible if the parent is expanded.
    # 
    # @return the visible expanded elements
    # @since 2.0
    def get_visible_expanded_elements
      v = ArrayList.new
      internal_collect_visible_expanded(v, get_control)
      return v.to_array
    end
    
    typesig { [ArrayList, Widget] }
    def internal_collect_visible_expanded(result, widget)
      items = get_children(widget)
      i = 0
      while i < items.attr_length
        item = items[i]
        if (get_expanded(item))
          data = item.get_data
          if (!(data).nil?)
            result.add(data)
          end
          # Only recurse if it is expanded - if
          # not then the children aren't visible
          internal_collect_visible_expanded(result, item)
        end
        i += 1
      end
    end
    
    typesig { [Item] }
    # Returns the tree path for the given item.
    # @param item
    # @return {@link TreePath}
    # 
    # @since 3.2
    def get_tree_path_from_item(item)
      segments = LinkedList.new
      while (!(item).nil?)
        segment = item.get_data
        Assert.is_not_null(segment)
        segments.add_first(segment)
        item = get_parent_item(item)
      end
      return TreePath.new(segments.to_array)
    end
    
    typesig { [] }
    # This implementation of getSelection() returns an instance of
    # ITreeSelection.
    # 
    # @since 3.2
    def get_selection
      control = get_control
      if ((control).nil? || control.is_disposed)
        return TreeSelection::EMPTY
      end
      items = get_selection(get_control)
      list = ArrayList.new(items.attr_length)
      i = 0
      while i < items.attr_length
        item = items[i]
        if (!(item.get_data).nil?)
          list.add(get_tree_path_from_item(item))
        end
        i += 1
      end
      return TreeSelection.new(list.to_array(Array.typed(TreePath).new(list.size) { nil }), get_comparer)
    end
    
    typesig { [ISelection, ::Java::Boolean] }
    def set_selection_to_widget(selection, reveal)
      if (selection.is_a?(ITreeSelection))
        tree_selection = selection
        set_selection_to_widget(Arrays.as_list(tree_selection.get_paths), reveal)
      else
        super(selection, reveal)
      end
    end
    
    typesig { [] }
    # Returns a list of tree paths corresponding to expanded nodes in this
    # viewer's tree, including currently hidden ones that are marked as
    # expanded but are under a collapsed ancestor.
    # <p>
    # This method is typically used when preserving the interesting state of a
    # viewer; <code>setExpandedElements</code> is used during the restore.
    # </p>
    # 
    # @return the array of expanded tree paths
    # @see #setExpandedElements
    # 
    # @since 3.2
    def get_expanded_tree_paths
      items = ArrayList.new
      internal_collect_expanded_items(items, get_control)
      result = ArrayList.new(items.size)
      it = items.iterator
      while it.has_next
        item = it.next_
        tree_path = get_tree_path_from_item(item)
        if (!(tree_path).nil?)
          result.add(tree_path)
        end
      end
      return result.to_array(Array.typed(TreePath).new(items.size) { nil })
    end
    
    typesig { [] }
    def is_tree_path_content_provider
      return get_content_provider.is_a?(ITreePathContentProvider)
    end
    
    typesig { [Object, Object, ::Java::Int] }
    # Inserts the given element as a new child element of the given parent
    # element at the given position. If this viewer has a sorter, the position
    # is ignored and the element is inserted at the correct position in the
    # sort order.
    # <p>
    # This method should be called (by the content provider) when elements have
    # been added to the model, in order to cause the viewer to accurately
    # reflect the model. This method only affects the viewer, not the model.
    # </p>
    # 
    # @param parentElementOrTreePath
    # the parent element, or the tree path to the parent
    # @param element
    # the element
    # @param position
    # a 0-based position relative to the model, or -1 to indicate
    # the last position
    # 
    # @since 3.2
    def insert(parent_element_or_tree_path, element, position)
      Assert.is_not_null(parent_element_or_tree_path)
      Assert.is_not_null(element)
      if (check_busy)
        return
      end
      if (!(get_comparator).nil? || has_filters)
        add(parent_element_or_tree_path, Array.typed(Object).new([element]))
        return
      end
      items = nil
      if (internal_is_input_or_empty_path(parent_element_or_tree_path))
        items = Array.typed(Widget).new([get_control])
      else
        items = internal_find_items(parent_element_or_tree_path)
      end
      i = 0
      while i < items.attr_length
        widget = items[i]
        if (widget.is_a?(Item))
          item = widget
          child_items = get_children(item)
          if (get_expanded(item) || (child_items.attr_length > 0 && !(child_items[0].get_data).nil?))
            # item has real children, go ahead and add
            insertion_position_ = position
            if ((insertion_position_).equal?(-1))
              insertion_position_ = get_item_count(item)
            end
            create_tree_item(item, element, insertion_position_)
          else
            parent_element = parent_element_or_tree_path
            if (element.is_a?(TreePath))
              parent_element = (parent_element).get_last_segment
            end
            update_plus(item, parent_element)
          end
        else
          insertion_position_ = position
          if ((insertion_position_).equal?(-1))
            insertion_position_ = get_item_count(widget)
          end
          create_tree_item(widget, element, insertion_position_)
        end
        i += 1
      end
    end
    
    typesig { [::Java::Int] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.viewers.ColumnViewer#getColumnViewerOwner(int)
    def get_column_viewer_owner(column_index)
      # Return null by default
      return nil
    end
    
    typesig { [Point] }
    # This implementation of {@link #getItemAt(Point)} returns null to ensure
    # API backwards compatibility. Subclasses should override.
    # 
    # @since 3.3
    def get_item_at(point)
      return nil
    end
    
    typesig { [] }
    # This implementation of {@link #createViewerEditor()} returns null to ensure
    # API backwards compatibility. Subclasses should override.
    # 
    # @since 3.3
    def create_viewer_editor
      return nil
    end
    
    typesig { [] }
    # Returns the number of columns of this viewer.
    # <p><b>Subclasses should overwrite this method, which has a default
    # implementation (returning 0) for API backwards compatility reasons</b></p>
    # 
    # @return the number of columns
    # 
    # @since 3.3
    def do_get_column_count
      return 0
    end
    
    typesig { [ViewerLabel, Object] }
    # This implementation of buildLabel handles tree paths as well as elements.
    # 
    # @param updateLabel
    # the ViewerLabel to collect the result in
    # @param elementOrPath
    # the element or tree path for which a label should be built
    # 
    # @see org.eclipse.jface.viewers.StructuredViewer#buildLabel(org.eclipse.jface.viewers.ViewerLabel,
    # java.lang.Object)
    def build_label(update_label, element_or_path)
      element = nil
      if (element_or_path.is_a?(TreePath))
        path = element_or_path
        provider = get_label_provider
        if (provider.is_a?(ITreePathLabelProvider))
          pprov = provider
          build_label(update_label, path, pprov)
          return
        end
        element = path.get_last_segment
      else
        element = element_or_path
      end
      super(update_label, element)
    end
    
    typesig { [Object] }
    # Returns true if the given object is either the input or an empty tree path.
    # 
    # @param elementOrTreePath an element which could either be the viewer's input, or a tree path
    # 
    # @return <code>true</code> if the given object is either the input or an empty tree path,
    # <code>false</code> otherwise.
    # @since 3.3
    def internal_is_input_or_empty_path(element_or_tree_path)
      if ((element_or_tree_path == get_root))
        return true
      end
      if (!(element_or_tree_path.is_a?(TreePath)))
        return false
      end
      return ((element_or_tree_path).get_segment_count).equal?(0)
    end
    
    typesig { [Widget] }
    # Subclasses should implement
    def get_viewer_row_from_item(item)
      return nil
    end
    
    private
    alias_method :initialize__abstract_tree_viewer, :initialize
  end
  
end
