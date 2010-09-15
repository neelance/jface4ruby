require "rjava"

# Copyright (c) 2004, 2009 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
# Tom Schindl <tom.schindl@bestsolution.at> - concept of ViewerRow,
# refactoring (bug 153993), bug 167323, 191468, 205419
# Matthew Hall - bug 221988
module Org::Eclipse::Jface::Viewers
  module TreeViewerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
      include_const ::Java::Util, :Arrays
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :LinkedList
      include_const ::Java::Util, :JavaList
      include_const ::Org::Eclipse::Jface::Util, :Policy
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Events, :DisposeEvent
      include_const ::Org::Eclipse::Swt::Events, :DisposeListener
      include_const ::Org::Eclipse::Swt::Events, :TreeEvent
      include_const ::Org::Eclipse::Swt::Events, :TreeListener
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Event
      include_const ::Org::Eclipse::Swt::Widgets, :Item
      include_const ::Org::Eclipse::Swt::Widgets, :Listener
      include_const ::Org::Eclipse::Swt::Widgets, :Tree
      include_const ::Org::Eclipse::Swt::Widgets, :TreeItem
      include_const ::Org::Eclipse::Swt::Widgets, :Widget
    }
  end
  
  # A concrete viewer based on an SWT <code>Tree</code> control.
  # <p>
  # This class is not intended to be subclassed outside the viewer framework. It
  # is designed to be instantiated with a pre-existing SWT tree control and
  # configured with a domain-specific content provider, label provider, element
  # filter (optional), and element sorter (optional).
  # </p>
  # <p>
  # As of 3.2, TreeViewer supports multiple equal elements (each with a
  # different parent chain) in the tree. This support requires that clients
  # enable the element map by calling <code>setUseHashLookup(true)</code>.
  # </p>
  # <p>
  # Content providers for tree viewers must implement either the
  # {@link ITreeContentProvider} interface, (as of 3.2) the
  # {@link ILazyTreeContentProvider} interface, or (as of 3.3) the
  # {@link ILazyTreePathContentProvider}. If the content provider is an
  # <code>ILazyTreeContentProvider</code> or an
  # <code>ILazyTreePathContentProvider</code>, the underlying Tree must be
  # created using the {@link SWT#VIRTUAL} style bit, the tree viewer will not
  # support sorting or filtering, and hash lookup must be enabled by calling
  # {@link #setUseHashlookup(boolean)}.
  # </p>
  # <p>
  # Users setting up an editable tree with more than 1 column <b>have</b> to pass the
  # SWT.FULL_SELECTION style bit
  # </p>
  # @noextend This class is not intended to be subclassed by clients.
  class TreeViewer < TreeViewerImports.const_get :AbstractTreeViewer
    include_class_members TreeViewerImports
    
    class_module.module_eval {
      const_set_lazy(:VIRTUAL_DISPOSE_KEY) { RJava.cast_to_string(Policy::JFACE) + ".DISPOSE_LISTENER" }
      const_attr_reader  :VIRTUAL_DISPOSE_KEY
    }
    
    # $NON-NLS-1$
    # 
    # This viewer's control.
    attr_accessor :tree
    alias_method :attr_tree, :tree
    undef_method :tree
    alias_method :attr_tree=, :tree=
    undef_method :tree=
    
    # Flag for whether the tree has been disposed of.
    attr_accessor :tree_is_disposed
    alias_method :attr_tree_is_disposed, :tree_is_disposed
    undef_method :tree_is_disposed
    alias_method :attr_tree_is_disposed=, :tree_is_disposed=
    undef_method :tree_is_disposed=
    
    attr_accessor :content_provider_is_lazy
    alias_method :attr_content_provider_is_lazy, :content_provider_is_lazy
    undef_method :content_provider_is_lazy
    alias_method :attr_content_provider_is_lazy=, :content_provider_is_lazy=
    undef_method :content_provider_is_lazy=
    
    attr_accessor :content_provider_is_tree_based
    alias_method :attr_content_provider_is_tree_based, :content_provider_is_tree_based
    undef_method :content_provider_is_tree_based
    alias_method :attr_content_provider_is_tree_based=, :content_provider_is_tree_based=
    undef_method :content_provider_is_tree_based=
    
    # The row object reused
    attr_accessor :cached_row
    alias_method :attr_cached_row, :cached_row
    undef_method :cached_row
    alias_method :attr_cached_row=, :cached_row=
    undef_method :cached_row=
    
    # true if we are inside a preservingSelection() call
    attr_accessor :inside_preserving_selection
    alias_method :attr_inside_preserving_selection, :inside_preserving_selection
    undef_method :inside_preserving_selection
    alias_method :attr_inside_preserving_selection=, :inside_preserving_selection=
    undef_method :inside_preserving_selection=
    
    typesig { [Composite] }
    # Creates a tree viewer on a newly-created tree control under the given
    # parent. The tree control is created using the SWT style bits
    # <code>MULTI, H_SCROLL, V_SCROLL,</code> and <code>BORDER</code>. The
    # viewer has no input, no content provider, a default label provider, no
    # sorter, and no filters.
    # 
    # @param parent
    # the parent control
    def initialize(parent)
      initialize__tree_viewer(parent, SWT::MULTI | SWT::H_SCROLL | SWT::V_SCROLL | SWT::BORDER)
    end
    
    typesig { [Composite, ::Java::Int] }
    # Creates a tree viewer on a newly-created tree control under the given
    # parent. The tree control is created using the given SWT style bits. The
    # viewer has no input, no content provider, a default label provider, no
    # sorter, and no filters.
    # 
    # @param parent
    # the parent control
    # @param style
    # the SWT style bits used to create the tree.
    def initialize(parent, style)
      initialize__tree_viewer(Tree.new(parent, style))
    end
    
    typesig { [Tree] }
    # Creates a tree viewer on the given tree control. The viewer has no input,
    # no content provider, a default label provider, no sorter, and no filters.
    # 
    # @param tree
    # the tree control
    def initialize(tree)
      @tree = nil
      @tree_is_disposed = false
      @content_provider_is_lazy = false
      @content_provider_is_tree_based = false
      @cached_row = nil
      @inside_preserving_selection = false
      super()
      @tree_is_disposed = false
      @tree = tree
      hook_control(tree)
    end
    
    typesig { [Control, TreeListener] }
    # (non-Javadoc) Method declared in AbstractTreeViewer.
    def add_tree_listener(c, listener)
      (c).add_tree_listener(listener)
    end
    
    typesig { [::Java::Int] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.viewers.ColumnViewer#getColumnViewerOwner(int)
    def get_column_viewer_owner(column_index)
      if (column_index < 0 || (column_index > 0 && column_index >= get_tree.get_column_count))
        return nil
      end
      if ((get_tree.get_column_count).equal?(0))
        # Hang it off the table if it
        return get_tree
      end
      return get_tree.get_column(column_index)
    end
    
    typesig { [Widget] }
    # (non-Javadoc) Method declared in AbstractTreeViewer.
    def get_children(o)
      if (o.is_a?(TreeItem))
        return (o).get_items
      end
      if (o.is_a?(Tree))
        return (o).get_items
      end
      return nil
    end
    
    typesig { [] }
    # (non-Javadoc) Method declared in Viewer.
    def get_control
      return @tree
    end
    
    typesig { [Item] }
    # (non-Javadoc) Method declared in AbstractTreeViewer.
    def get_expanded(item)
      return (item).get_expanded
    end
    
    typesig { [Point] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.viewers.ColumnViewer#getItemAt(org.eclipse.swt.graphics.Point)
    def get_item_at(p)
      selection = @tree.get_selection
      if ((selection.attr_length).equal?(1))
        column_count = @tree.get_column_count
        i = 0
        while i < column_count
          if (selection[0].get_bounds(i).contains(p))
            return selection[0]
          end
          i += 1
        end
      end
      return get_tree.get_item(p)
    end
    
    typesig { [Control] }
    # (non-Javadoc) Method declared in AbstractTreeViewer.
    def get_item_count(widget)
      return (widget).get_item_count
    end
    
    typesig { [Item] }
    # (non-Javadoc) Method declared in AbstractTreeViewer.
    def get_item_count(item)
      return (item).get_item_count
    end
    
    typesig { [Item] }
    # (non-Javadoc) Method declared in AbstractTreeViewer.
    def get_items(item)
      return (item).get_items
    end
    
    typesig { [] }
    # The tree viewer implementation of this <code>Viewer</code> framework
    # method ensures that the given label provider is an instance of either
    # <code>ITableLabelProvider</code> or <code>ILabelProvider</code>. If
    # it is an <code>ITableLabelProvider</code>, then it provides a separate
    # label text and image for each column. If it is an
    # <code>ILabelProvider</code>, then it provides only the label text and
    # image for the first column, and any remaining columns are blank.
    def get_label_provider
      return super
    end
    
    typesig { [Item] }
    # (non-Javadoc) Method declared in AbstractTreeViewer.
    def get_parent_item(item)
      return (item).get_parent_item
    end
    
    typesig { [Control] }
    # (non-Javadoc) Method declared in AbstractTreeViewer.
    def get_selection(widget)
      return (widget).get_selection
    end
    
    typesig { [] }
    # Returns this tree viewer's tree control.
    # 
    # @return the tree control
    def get_tree
      return @tree
    end
    
    typesig { [Control] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.viewers.AbstractTreeViewer#hookControl(org.eclipse.swt.widgets.Control)
    def hook_control(control)
      super(control)
      tree_control = control
      if (!((tree_control.get_style & SWT::VIRTUAL)).equal?(0))
        tree_control.add_dispose_listener(Class.new(DisposeListener.class == Class ? DisposeListener : Object) do
          local_class_in TreeViewer
          include_class_members TreeViewer
          include DisposeListener if DisposeListener.class == Module
          
          typesig { [DisposeEvent] }
          define_method :widget_disposed do |e|
            self.attr_tree_is_disposed = true
            unmap_all_elements
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
        tree_control.add_listener(SWT::SetData, Class.new(Listener.class == Class ? Listener : Object) do
          local_class_in TreeViewer
          include_class_members TreeViewer
          include Listener if Listener.class == Module
          
          typesig { [Event] }
          define_method :handle_event do |event|
            if (self.attr_content_provider_is_lazy)
              item = event.attr_item
              parent_item = item.get_parent_item
              index = event.attr_index
              virtual_lazy_update_widget((parent_item).nil? ? get_tree : parent_item, index)
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
    
    typesig { [] }
    def create_viewer_editor
      return TreeViewerEditor.new(self, nil, ColumnViewerEditorActivationStrategy.new(self), ColumnViewerEditor::DEFAULT)
    end
    
    typesig { [Widget, ::Java::Int, ::Java::Int] }
    # (non-Javadoc) Method declared in AbstractTreeViewer.
    def new_item(parent, flags, ix)
      item = nil
      if (parent.is_a?(TreeItem))
        item = create_new_row_part(get_viewer_row_from_item(parent), flags, ix).get_item
      else
        item = create_new_row_part(nil, flags, ix).get_item
      end
      return item
    end
    
    typesig { [Control] }
    # (non-Javadoc) Method declared in AbstractTreeViewer.
    def remove_all(widget)
      (widget).remove_all
    end
    
    typesig { [Item, ::Java::Boolean] }
    # (non-Javadoc) Method declared in AbstractTreeViewer.
    def set_expanded(node, expand)
      (node).set_expanded(expand)
      if (@content_provider_is_lazy)
        # force repaints to happen
        get_control.update
      end
    end
    
    typesig { [JavaList] }
    # (non-Javadoc) Method declared in AbstractTreeViewer.
    def set_selection(items)
      current = get_selection(get_tree)
      # Don't bother resetting the same selection
      if (is_same_selection(items, current))
        return
      end
      new_items = Array.typed(TreeItem).new(items.size) { nil }
      items.to_array(new_items)
      get_tree.set_selection(new_items)
    end
    
    typesig { [Item] }
    # (non-Javadoc) Method declared in AbstractTreeViewer.
    def show_item(item)
      get_tree.show_item(item)
    end
    
    typesig { [Widget, ::Java::Int] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.viewers.AbstractTreeViewer#getChild(org.eclipse.swt.widgets.Widget,
    # int)
    def get_child(widget, index)
      if (widget.is_a?(TreeItem))
        return (widget).get_item(index)
      end
      if (widget.is_a?(Tree))
        return (widget).get_item(index)
      end
      return nil
    end
    
    typesig { [IContentProvider] }
    def assert_content_provider_type(provider)
      if (provider.is_a?(ILazyTreeContentProvider) || provider.is_a?(ILazyTreePathContentProvider))
        return
      end
      super(provider)
    end
    
    typesig { [Object] }
    def get_raw_children(parent)
      if (@content_provider_is_lazy)
        return Array.typed(Object).new(0) { nil }
      end
      return super(parent)
    end
    
    typesig { [Runnable, ::Java::Boolean] }
    def preserving_selection(update_code, reveal)
      if (@inside_preserving_selection || !get_preserve_selection)
        # avoid preserving the selection if called reentrantly,
        # see bug 172640
        update_code.run
        return
      end
      @inside_preserving_selection = true
      begin
        super(update_code, reveal)
      ensure
        @inside_preserving_selection = false
      end
    end
    
    typesig { [Object, ::Java::Int] }
    # For a TreeViewer with a tree with the VIRTUAL style bit set, set the
    # number of children of the given element or tree path. To set the number
    # of children of the invisible root of the tree, you can pass the input
    # object or an empty tree path.
    # 
    # @param elementOrTreePath
    # the element, or tree path
    # @param count
    # 
    # @since 3.2
    def set_child_count(element_or_tree_path, count)
      if (check_busy)
        return
      end
      preserving_selection(Class.new(Runnable.class == Class ? Runnable : Object) do
        local_class_in TreeViewer
        include_class_members TreeViewer
        include Runnable if Runnable.class == Module
        
        typesig { [] }
        define_method :run do
          if (internal_is_input_or_empty_path(element_or_tree_path))
            get_tree.set_item_count(count)
            return
          end
          items = internal_find_items(element_or_tree_path)
          i = 0
          while i < items.attr_length
            tree_item = items[i]
            tree_item.set_item_count(count)
            i += 1
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
    
    typesig { [Object, ::Java::Int, Object] }
    # For a TreeViewer with a tree with the VIRTUAL style bit set, replace the
    # given parent's child at index with the given element. If the given parent
    # is this viewer's input or an empty tree path, this will replace the root
    # element at the given index.
    # <p>
    # This method should be called by implementers of ILazyTreeContentProvider
    # to populate this viewer.
    # </p>
    # 
    # @param parentElementOrTreePath
    # the parent of the element that should be updated, or the tree
    # path to that parent
    # @param index
    # the index in the parent's children
    # @param element
    # the new element
    # 
    # @see #setChildCount(Object, int)
    # @see ILazyTreeContentProvider
    # @see ILazyTreePathContentProvider
    # 
    # @since 3.2
    def replace(parent_element_or_tree_path, index, element)
      if (check_busy)
        return
      end
      selected_items = get_selection(get_control)
      selection = get_selection
      items_to_disassociate = nil
      if (parent_element_or_tree_path.is_a?(TreePath))
        element_path = (parent_element_or_tree_path).create_child_path(element)
        items_to_disassociate = internal_find_items(element_path)
      else
        items_to_disassociate = internal_find_items(element)
      end
      if (internal_is_input_or_empty_path(parent_element_or_tree_path))
        if (index < @tree.get_item_count)
          item = @tree.get_item(index)
          selection = adjust_selection_for_replace(selected_items, selection, item, element, get_root)
          # disassociate any different item that represents the
          # same element under the same parent (the tree)
          i = 0
          while i < items_to_disassociate.attr_length
            if (items_to_disassociate[i].is_a?(TreeItem))
              item_to_disassociate = items_to_disassociate[i]
              if (!(item_to_disassociate).equal?(item) && (item_to_disassociate.get_parent_item).nil?)
                index_to_disassociate = get_tree.index_of(item_to_disassociate)
                disassociate(item_to_disassociate)
                get_tree.clear(index_to_disassociate, true)
              end
            end
            i += 1
          end
          old_data = item.get_data
          update_item(item, element)
          if (!self.==(old_data, element))
            item.clear_all(true)
          end
        end
      else
        parent_items = internal_find_items(parent_element_or_tree_path)
        i = 0
        while i < parent_items.attr_length
          parent_item = parent_items[i]
          if (index < parent_item.get_item_count)
            item = parent_item.get_item(index)
            selection = adjust_selection_for_replace(selected_items, selection, item, element, parent_item.get_data)
            # disassociate any different item that represents the
            # same element under the same parent (the tree)
            j = 0
            while j < items_to_disassociate.attr_length
              if (items_to_disassociate[j].is_a?(TreeItem))
                item_to_disassociate = items_to_disassociate[j]
                if (!(item_to_disassociate).equal?(item) && (item_to_disassociate.get_parent_item).equal?(parent_item))
                  index_to_disaccociate = parent_item.index_of(item_to_disassociate)
                  disassociate(item_to_disassociate)
                  parent_item.clear(index_to_disaccociate, true)
                end
              end
              j += 1
            end
            old_data = item.get_data
            update_item(item, element)
            if (!self.==(old_data, element))
              item.clear_all(true)
            end
          end
          i += 1
        end
      end
      # Restore the selection if we are not already in a nested preservingSelection:
      if (!@inside_preserving_selection)
        set_selection_to_widget(selection, false)
        # send out notification if old and new differ
        new_selection = get_selection
        if (!(new_selection == selection))
          handle_invalid_selection(selection, new_selection)
        end
      end
    end
    
    typesig { [Array.typed(Item), TreeSelection, TreeItem, Object, Object] }
    # Fix for bug 185673: If the currently replaced item was selected, add it
    # to the selection that is being restored. Only do this if its getData() is
    # currently null
    # 
    # @param selectedItems
    # @param selection
    # @param item
    # @param element
    # @return
    def adjust_selection_for_replace(selected_items, selection, item, element, parent_element)
      if (!(item.get_data).nil? || (selected_items.attr_length).equal?(selection.size) || (parent_element).nil?)
        # Don't do anything - we are not seeing an instance of bug 185673
        return selection
      end
      i = 0
      while i < selected_items.attr_length
        if ((item).equal?(selected_items[i]))
          # The current item was selected, but its data is null.
          # The data will be replaced by the given element, so to keep
          # it selected, we have to add it to the selection.
          original_paths = selection.get_paths
          length = original_paths.attr_length
          paths = Array.typed(TreePath).new(length + 1) { nil }
          System.arraycopy(original_paths, 0, paths, 0, length)
          # set the element temporarily so that we can call getTreePathFromItem
          item.set_data(element)
          paths[length] = get_tree_path_from_item(item)
          item.set_data(nil)
          return TreeSelection.new(paths, selection.get_element_comparer)
        end
        i += 1
      end
      # The item was not selected, return the given selection
      return selection
    end
    
    typesig { [Object] }
    def is_expandable(element)
      if (@content_provider_is_lazy)
        tree_item = internal_expand(element, false)
        if ((tree_item).nil?)
          return false
        end
        virtual_materialize_item(tree_item)
        return tree_item.get_item_count > 0
      end
      return super(element)
    end
    
    typesig { [Object] }
    def get_parent_element(element)
      old_busy = is_busy
      set_busy(true)
      begin
        if (@content_provider_is_lazy && !@content_provider_is_tree_based && !(element.is_a?(TreePath)))
          lazy_tree_content_provider = get_content_provider
          return lazy_tree_content_provider.get_parent(element)
        end
        if (@content_provider_is_lazy && @content_provider_is_tree_based && !(element.is_a?(TreePath)))
          lazy_tree_path_content_provider = get_content_provider
          parents = lazy_tree_path_content_provider.get_parents(element)
          if (!(parents).nil? && parents.attr_length > 0)
            return parents[0]
          end
        end
        return super(element)
      ensure
        set_busy(old_busy)
      end
    end
    
    typesig { [Widget] }
    def create_children(widget)
      if (@content_provider_is_lazy)
        element = widget.get_data
        if ((element).nil? && widget.is_a?(TreeItem))
          # parent has not been materialized
          virtual_materialize_item(widget)
          # try getting the element now that updateElement was called
          element = widget.get_data
        end
        if ((element).nil?)
          # give up because the parent is still not materialized
          return
        end
        children = get_children(widget)
        if ((children.attr_length).equal?(1) && (children[0].get_data).nil?)
          # found a dummy node
          virtual_lazy_update_child_count(widget, children.attr_length)
          children = get_children(widget)
        end
        # touch all children to make sure they are materialized
        i = 0
        while i < children.attr_length
          if ((children[i].get_data).nil?)
            virtual_lazy_update_widget(widget, i)
          end
          i += 1
        end
        return
      end
      super(widget)
    end
    
    typesig { [Widget, Object, Array.typed(Object)] }
    def internal_add(widget, parent_element, child_elements)
      if (@content_provider_is_lazy)
        if (widget.is_a?(TreeItem))
          ti = widget
          count = ti.get_item_count + child_elements.attr_length
          ti.set_item_count(count)
          ti.clear_all(false)
        else
          t = widget
          t.set_item_count(t.get_item_count + child_elements.attr_length)
          t.clear_all(false)
        end
        return
      end
      super(widget, parent_element, child_elements)
    end
    
    typesig { [TreeItem] }
    def virtual_materialize_item(tree_item)
      if (!(tree_item.get_data).nil?)
        # already materialized
        return
      end
      if (!@content_provider_is_lazy)
        return
      end
      index = 0
      parent = tree_item.get_parent_item
      if ((parent).nil?)
        parent = tree_item.get_parent
      end
      parent_element = parent.get_data
      if (!(parent_element).nil?)
        if (parent.is_a?(Tree))
          index = (parent).index_of(tree_item)
        else
          index = (parent).index_of(tree_item)
        end
        virtual_lazy_update_widget(parent, index)
      end
    end
    
    typesig { [Widget, Object, ::Java::Boolean] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.viewers.AbstractTreeViewer#internalRefreshStruct(org.eclipse.swt.widgets.Widget,
    # java.lang.Object, boolean)
    def internal_refresh_struct(widget, element, update_labels)
      if (@content_provider_is_lazy)
        # clear all starting with the given widget
        if (widget.is_a?(Tree))
          (widget).clear_all(true)
        else
          if (widget.is_a?(TreeItem))
            (widget).clear_all(true)
          end
        end
        index = 0
        parent = nil
        if (widget.is_a?(TreeItem))
          tree_item = widget
          parent = tree_item.get_parent_item
          if ((parent).nil?)
            parent = tree_item.get_parent
          end
          if (parent.is_a?(Tree))
            index = (parent).index_of(tree_item)
          else
            index = (parent).index_of(tree_item)
          end
        end
        virtual_refresh_expanded_items(parent, widget, element, index)
        return
      end
      super(widget, element, update_labels)
    end
    
    typesig { [Widget, Widget, Object, ::Java::Int] }
    # Traverses the visible (expanded) part of the tree and updates child
    # counts.
    # 
    # @param parent the parent of the widget, or <code>null</code> if the widget is the tree
    # @param widget
    # @param element
    # @param index the index of the widget in the children array of its parent, or 0 if the widget is the tree
    def virtual_refresh_expanded_items(parent, widget, element, index)
      if (widget.is_a?(Tree))
        if ((element).nil?)
          (widget).set_item_count(0)
          return
        end
        virtual_lazy_update_child_count(widget, get_children(widget).attr_length)
      else
        if ((widget).get_expanded)
          # prevent SetData callback
          (widget).set_text(" ") # $NON-NLS-1$
          virtual_lazy_update_widget(parent, index)
        else
          return
        end
      end
      items = get_children(widget)
      i = 0
      while i < items.attr_length
        item = items[i]
        data = item.get_data
        virtual_refresh_expanded_items(widget, item, data, i)
        i += 1
      end
    end
    
    typesig { [Object, Widget] }
    # To unmap elements correctly, we need to register a dispose listener with
    # the item if the tree is virtual.
    def map_element(element, item)
      super(element, item)
      # make sure to unmap elements if the tree is virtual
      if (!((get_tree.get_style & SWT::VIRTUAL)).equal?(0))
        # only add a dispose listener if item hasn't already on assigned
        # because it is reused
        if ((item.get_data(VIRTUAL_DISPOSE_KEY)).nil?)
          item.set_data(VIRTUAL_DISPOSE_KEY, Boolean::TRUE)
          item.add_dispose_listener(Class.new(DisposeListener.class == Class ? DisposeListener : Object) do
            local_class_in TreeViewer
            include_class_members TreeViewer
            include DisposeListener if DisposeListener.class == Module
            
            typesig { [DisposeEvent] }
            define_method :widget_disposed do |e|
              if (!self.attr_tree_is_disposed)
                data = item.get_data
                if (using_element_map && !(data).nil?)
                  unmap_element(data, item)
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
    
    typesig { [Widget] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.viewers.ColumnViewer#getRowPartFromItem(org.eclipse.swt.widgets.Widget)
    def get_viewer_row_from_item(item)
      if ((@cached_row).nil?)
        @cached_row = TreeViewerRow.new(item)
      else
        @cached_row.set_item(item)
      end
      return @cached_row
    end
    
    typesig { [ViewerRow, ::Java::Int, ::Java::Int] }
    # Create a new ViewerRow at rowIndex
    # 
    # @param parent
    # @param style
    # @param rowIndex
    # @return ViewerRow
    def create_new_row_part(parent, style, row_index)
      if ((parent).nil?)
        if (row_index >= 0)
          return get_viewer_row_from_item(TreeItem.new(@tree, style, row_index))
        end
        return get_viewer_row_from_item(TreeItem.new(@tree, style))
      end
      if (row_index >= 0)
        return get_viewer_row_from_item(TreeItem.new(parent.get_item, SWT::NONE, row_index))
      end
      return get_viewer_row_from_item(TreeItem.new(parent.get_item, SWT::NONE))
    end
    
    typesig { [Control] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.viewers.AbstractTreeViewer#internalInitializeTree(org.eclipse.swt.widgets.Control)
    def internal_initialize_tree(widget)
      if (@content_provider_is_lazy)
        if (widget.is_a?(Tree) && !(widget.get_data).nil?)
          virtual_lazy_update_child_count(widget, 0)
          return
        end
      end
      super(@tree)
    end
    
    typesig { [Item, Object] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.viewers.AbstractTreeViewer#updatePlus(org.eclipse.swt.widgets.Item,
    # java.lang.Object)
    def update_plus(item, element)
      if (@content_provider_is_lazy)
        data = item.get_data
        item_count = 0
        if (!(data).nil?)
          # item is already materialized
          item_count = (item).get_item_count
        end
        virtual_lazy_update_has_children(item, item_count)
      else
        super(item, element)
      end
    end
    
    typesig { [Object, ::Java::Int] }
    # Removes the element at the specified index of the parent.  The selection is updated if required.
    # 
    # @param parentOrTreePath the parent element, the input element, or a tree path to the parent element
    # @param index child index
    # @since 3.3
    def remove(parent_or_tree_path, index)
      if (check_busy)
        return
      end
      old_selection = LinkedList.new(Arrays.as_list((get_selection).get_paths))
      preserving_selection(Class.new(Runnable.class == Class ? Runnable : Object) do
        local_class_in TreeViewer
        include_class_members TreeViewer
        include Runnable if Runnable.class == Module
        
        typesig { [] }
        define_method :run do
          removed_path = nil
          if (internal_is_input_or_empty_path(parent_or_tree_path))
            tree = get_control
            if (index < tree.get_item_count)
              item = tree.get_item(index)
              if (!(item.get_data).nil?)
                removed_path = get_tree_path_from_item(item)
                disassociate(item)
              end
              item.dispose
            end
          else
            parent_items = internal_find_items(parent_or_tree_path)
            i = 0
            while i < parent_items.attr_length
              parent_item = parent_items[i]
              if (parent_item.is_disposed)
                i += 1
                next
              end
              if (index < parent_item.get_item_count)
                item = parent_item.get_item(index)
                if (!(item.get_data).nil?)
                  removed_path = get_tree_path_from_item(item)
                  disassociate(item)
                end
                item.dispose
              end
              i += 1
            end
          end
          if (!(removed_path).nil?)
            removed = false
            it = old_selection.iterator
            while it.has_next
              path = it.next_
              if (path.starts_with(removed_path, get_comparer))
                it.remove
                removed = true
              end
            end
            if (removed)
              set_selection(self.class::TreeSelection.new(old_selection.to_array(Array.typed(self.class::TreePath).new(old_selection.size) { nil }), get_comparer), false)
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
    
    typesig { [TreeEvent] }
    # (non-Javadoc)
    # @see org.eclipse.jface.viewers.AbstractTreeViewer#handleTreeExpand(org.eclipse.swt.events.TreeEvent)
    def handle_tree_expand(event)
      # Fix for Bug 271744 because windows expanding doesn't fire a focus lost
      if (is_cell_editor_active)
        apply_editor_value
      end
      if (@content_provider_is_lazy)
        if (!(event.attr_item.get_data).nil?)
          children = get_children(event.attr_item)
          if ((children.attr_length).equal?(1) && (children[0].get_data).nil?)
            # we have a dummy child node, ask for an updated child
            # count
            virtual_lazy_update_child_count(event.attr_item, children.attr_length)
          end
          fire_tree_expanded(TreeExpansionEvent.new(self, event.attr_item.get_data))
        end
        return
      end
      super(event)
    end
    
    typesig { [TreeEvent] }
    def handle_tree_collapse(event)
      # Fix for Bug 271744 because windows is firing collapse before
      # focus lost event
      if (is_cell_editor_active)
        apply_editor_value
      end
      super(event)
    end
    
    typesig { [IContentProvider] }
    # (non-Javadoc)
    # @see org.eclipse.jface.viewers.AbstractTreeViewer#setContentProvider(org.eclipse.jface.viewers.IContentProvider)
    def set_content_provider(provider)
      @content_provider_is_lazy = (provider.is_a?(ILazyTreeContentProvider)) || (provider.is_a?(ILazyTreePathContentProvider))
      @content_provider_is_tree_based = provider.is_a?(ILazyTreePathContentProvider)
      super(provider)
    end
    
    typesig { [Object, ::Java::Boolean] }
    # For a TreeViewer with a tree with the VIRTUAL style bit set, inform the
    # viewer about whether the given element or tree path has children. Avoid
    # calling this method if the number of children has already been set.
    # 
    # @param elementOrTreePath
    # the element, or tree path
    # @param hasChildren
    # 
    # @since 3.3
    def set_has_children(element_or_tree_path, has_children)
      if (check_busy)
        return
      end
      preserving_selection(Class.new(Runnable.class == Class ? Runnable : Object) do
        local_class_in TreeViewer
        include_class_members TreeViewer
        include Runnable if Runnable.class == Module
        
        typesig { [] }
        define_method :run do
          if (internal_is_input_or_empty_path(element_or_tree_path))
            if (has_children)
              virtual_lazy_update_child_count(get_tree, get_children(get_tree).attr_length)
            else
              set_child_count(element_or_tree_path, 0)
            end
            return
          end
          items = internal_find_items(element_or_tree_path)
          i = 0
          while i < items.attr_length
            item = items[i]
            if (!has_children)
              item.set_item_count(0)
            else
              if (!item.get_expanded)
                item.set_item_count(1)
                child = item.get_item(0)
                if (!(child.get_data).nil?)
                  disassociate(child)
                end
                item.clear(0, true)
              else
                virtual_lazy_update_child_count(item, item.get_item_count)
              end
            end
            i += 1
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
    
    typesig { [Widget, ::Java::Int] }
    # Update the widget at index.
    # @param widget
    # @param index
    def virtual_lazy_update_widget(widget, index)
      old_busy = is_busy
      set_busy(false)
      begin
        if (@content_provider_is_tree_based)
          tree_path = nil
          if (widget.is_a?(Item))
            if ((widget.get_data).nil?)
              # we need to materialize the parent first
              # see bug 167668
              # however, that would be too risky
              # see bug 182782 and bug 182598
              # so we just ignore this call altogether
              # and don't do this: virtualMaterializeItem((TreeItem) widget);
              return
            end
            tree_path = get_tree_path_from_item(widget)
          else
            tree_path = TreePath::EMPTY
          end
          (get_content_provider).update_element(tree_path, index)
        else
          (get_content_provider).update_element(widget.get_data, index)
        end
      ensure
        set_busy(old_busy)
      end
    end
    
    typesig { [Widget, ::Java::Int] }
    # Update the child count
    # @param widget
    # @param currentChildCount
    def virtual_lazy_update_child_count(widget, current_child_count)
      old_busy = is_busy
      set_busy(false)
      begin
        if (@content_provider_is_tree_based)
          tree_path = nil
          if (widget.is_a?(Item))
            tree_path = get_tree_path_from_item(widget)
          else
            tree_path = TreePath::EMPTY
          end
          (get_content_provider).update_child_count(tree_path, current_child_count)
        else
          (get_content_provider).update_child_count(widget.get_data, current_child_count)
        end
      ensure
        set_busy(old_busy)
      end
    end
    
    typesig { [Item, ::Java::Int] }
    # Update the item with the current child count.
    # @param item
    # @param currentChildCount
    def virtual_lazy_update_has_children(item, current_child_count)
      old_busy = is_busy
      set_busy(false)
      begin
        if (@content_provider_is_tree_based)
          tree_path = nil
          tree_path = get_tree_path_from_item(item)
          if ((current_child_count).equal?(0) || !(item).get_expanded)
            # item is not expanded (but may have a plus currently)
            (get_content_provider).update_has_children(tree_path)
          else
            (get_content_provider).update_child_count(tree_path, current_child_count)
          end
        else
          (get_content_provider).update_child_count(item.get_data, current_child_count)
        end
      ensure
        set_busy(old_busy)
      end
    end
    
    typesig { [Item] }
    def disassociate(item)
      if (@content_provider_is_lazy)
        # avoid causing a callback:
        item.set_text(" ") # $NON-NLS-1$
      end
      super(item)
    end
    
    typesig { [] }
    def do_get_column_count
      return @tree.get_column_count
    end
    
    typesig { [ISelection, ::Java::Boolean] }
    # Sets a new selection for this viewer and optionally makes it visible.
    # <p>
    # <b>Currently the <code>reveal</code> parameter is not honored because
    # {@link Tree} does not provide an API to only select an item without
    # scrolling it into view</b>
    # </p>
    # 
    # @param selection
    # the new selection
    # @param reveal
    # <code>true</code> if the selection is to be made visible,
    # and <code>false</code> otherwise
    def set_selection(selection, reveal)
      super(selection, reveal)
    end
    
    typesig { [Object, ::Java::Int] }
    def edit_element(element, column)
      if (element.is_a?(TreePath))
        begin
          get_control.set_redraw(false)
          set_selection(TreeSelection.new(element))
          items = @tree.get_selection
          if ((items.attr_length).equal?(1))
            row = get_viewer_row_from_item(items[0])
            if (!(row).nil?)
              cell = row.get_cell(column)
              if (!(cell).nil?)
                trigger_editor_activation_event(ColumnViewerEditorActivationEvent.new(cell))
              end
            end
          end
        ensure
          get_control.set_redraw(true)
        end
      else
        super(element, column)
      end
    end
    
    private
    alias_method :initialize__tree_viewer, :initialize
  end
  
end
