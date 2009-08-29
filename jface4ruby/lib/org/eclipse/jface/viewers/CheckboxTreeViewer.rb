require "rjava"

# Copyright (c) 2000, 2009 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Viewers
  module CheckboxTreeViewerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :JavaList
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Core::Runtime, :ListenerList
      include_const ::Org::Eclipse::Jface::Util, :SafeRunnable
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Events, :SelectionEvent
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Item
      include_const ::Org::Eclipse::Swt::Widgets, :Tree
      include_const ::Org::Eclipse::Swt::Widgets, :TreeItem
      include_const ::Org::Eclipse::Swt::Widgets, :Widget
    }
  end
  
  # A concrete tree-structured viewer based on an SWT <code>Tree</code>
  # control with checkboxes on each node.
  # <p>This class supports setting an {@link ICheckStateProvider} to
  # set the checkbox states. To see standard SWT behavior, view
  # SWT Snippet274.</p>
  # <p>
  # This class is not intended to be subclassed outside the viewer framework.
  # It is designed to be instantiated with a pre-existing SWT tree control and configured
  # with a domain-specific content provider, label provider, element filter (optional),
  # and element sorter (optional).
  # </p>
  # @noextend This class is not intended to be subclassed by clients.
  class CheckboxTreeViewer < CheckboxTreeViewerImports.const_get :TreeViewer
    include_class_members CheckboxTreeViewerImports
    overload_protected {
      include ICheckable
    }
    
    # List of check state listeners (element type: <code>ICheckStateListener</code>).
    attr_accessor :check_state_listeners
    alias_method :attr_check_state_listeners, :check_state_listeners
    undef_method :check_state_listeners
    alias_method :attr_check_state_listeners=, :check_state_listeners=
    undef_method :check_state_listeners=
    
    # Provides the desired state of the check boxes.
    attr_accessor :check_state_provider
    alias_method :attr_check_state_provider, :check_state_provider
    undef_method :check_state_provider
    alias_method :attr_check_state_provider=, :check_state_provider=
    undef_method :check_state_provider=
    
    # Last item clicked on, or <code>null</code> if none.
    attr_accessor :last_clicked_item
    alias_method :attr_last_clicked_item, :last_clicked_item
    undef_method :last_clicked_item
    alias_method :attr_last_clicked_item=, :last_clicked_item=
    undef_method :last_clicked_item=
    
    typesig { [Composite] }
    # Creates a tree viewer on a newly-created tree control under the given parent.
    # The tree control is created using the SWT style bits: <code>CHECK</code> and <code>BORDER</code>.
    # The viewer has no input, no content provider, a default label provider,
    # no sorter, and no filters.
    # 
    # @param parent the parent control
    def initialize(parent)
      initialize__checkbox_tree_viewer(parent, SWT::BORDER)
    end
    
    typesig { [Composite, ::Java::Int] }
    # Creates a tree viewer on a newly-created tree control under the given parent.
    # The tree control is created using the given SWT style bits, plus the <code>CHECK</code> style bit.
    # The viewer has no input, no content provider, a default label provider,
    # no sorter, and no filters.
    # 
    # @param parent the parent control
    # @param style the SWT style bits
    def initialize(parent, style)
      initialize__checkbox_tree_viewer(Tree.new(parent, SWT::CHECK | style))
    end
    
    typesig { [Tree] }
    # Creates a tree viewer on the given tree control.
    # The <code>SWT.CHECK</code> style bit must be set on the given tree control.
    # The viewer has no input, no content provider, a default label provider,
    # no sorter, and no filters.
    # 
    # @param tree the tree control
    def initialize(tree)
      @check_state_listeners = nil
      @check_state_provider = nil
      @last_clicked_item = nil
      super(tree)
      @check_state_listeners = ListenerList.new
      @last_clicked_item = nil
    end
    
    typesig { [ICheckStateListener] }
    # (non-Javadoc)
    # Method declared on ICheckable.
    def add_check_state_listener(listener)
      @check_state_listeners.add(listener)
    end
    
    typesig { [ICheckStateProvider] }
    # Sets the {@link ICheckStateProvider} for this {@link CheckboxTreeViewer}.
    # The check state provider will supply the logic for deciding whether the
    # check box associated with each item should be checked, grayed or
    # unchecked.
    # @param checkStateProvider	The provider.
    # @since 3.5
    def set_check_state_provider(check_state_provider)
      @check_state_provider = check_state_provider
      refresh
    end
    
    typesig { [Item, Object] }
    # Extends this method to update check box states.
    def do_update_item(item, element)
      super(item, element)
      if (!item.is_disposed && !(@check_state_provider).nil?)
        set_checked(element, @check_state_provider.is_checked(element))
        set_grayed(element, @check_state_provider.is_grayed(element))
      end
    end
    
    typesig { [CustomHashtable, CustomHashtable, Widget] }
    # Applies the checked and grayed states of the given widget and its
    # descendents.
    # 
    # @param checked a set of elements (element type: <code>Object</code>)
    # @param grayed a set of elements (element type: <code>Object</code>)
    # @param widget the widget
    def apply_state(checked, grayed, widget)
      items = get_children(widget)
      i = 0
      while i < items.attr_length
        item = items[i]
        if (item.is_a?(TreeItem))
          data = item.get_data
          if (!(data).nil?)
            ti = item
            ti.set_checked(checked.contains_key(data))
            ti.set_grayed(grayed.contains_key(data))
          end
        end
        apply_state(checked, grayed, item)
        i += 1
      end
    end
    
    typesig { [CheckStateChangedEvent] }
    # Notifies any check state listeners that the check state of an element has changed.
    # Only listeners registered at the time this method is called are notified.
    # 
    # @param event a check state changed event
    # 
    # @see ICheckStateListener#checkStateChanged
    def fire_check_state_changed(event)
      array = @check_state_listeners.get_listeners
      i = 0
      while i < array.attr_length
        l = array[i]
        SafeRunnable.run(Class.new(SafeRunnable.class == Class ? SafeRunnable : Object) do
          extend LocalClass
          include_class_members CheckboxTreeViewer
          include SafeRunnable if SafeRunnable.class == Module
          
          typesig { [] }
          define_method :run do
            l.check_state_changed(event)
          end
          
          typesig { [] }
          define_method :initialize do
            super()
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
        i += 1
      end
    end
    
    typesig { [CustomHashtable, CustomHashtable, Widget] }
    # Gathers the checked and grayed states of the given widget and its
    # descendents.
    # 
    # @param checked a writable set of elements (element type: <code>Object</code>)
    # @param grayed a writable set of elements (element type: <code>Object</code>)
    # @param widget the widget
    def gather_state(checked, grayed, widget)
      items = get_children(widget)
      i = 0
      while i < items.attr_length
        item = items[i]
        if (item.is_a?(TreeItem))
          data = item.get_data
          if (!(data).nil?)
            ti = item
            if (ti.get_checked)
              checked.put(data, data)
            end
            if (ti.get_grayed)
              grayed.put(data, data)
            end
          end
        end
        gather_state(checked, grayed, item)
        i += 1
      end
    end
    
    typesig { [Object] }
    # (non-Javadoc)
    # Method declared on ICheckable.
    def get_checked(element)
      widget = find_item(element)
      if (widget.is_a?(TreeItem))
        return (widget).get_checked
      end
      return false
    end
    
    typesig { [] }
    # Returns a list of checked elements in this viewer's tree,
    # including currently hidden ones that are marked as
    # checked but are under a collapsed ancestor.
    # <p>
    # This method is typically used when preserving the interesting
    # state of a viewer; <code>setCheckedElements</code> is used during the restore.
    # </p>
    # 
    # @return the array of checked elements
    # 
    # @see #setCheckedElements
    def get_checked_elements
      v = ArrayList.new
      tree = get_control
      internal_collect_checked(v, tree)
      return v.to_array
    end
    
    typesig { [Object] }
    # Returns the grayed state of the given element.
    # 
    # @param element the element
    # @return <code>true</code> if the element is grayed,
    # and <code>false</code> if not grayed
    def get_grayed(element)
      widget = find_item(element)
      if (widget.is_a?(TreeItem))
        return (widget).get_grayed
      end
      return false
    end
    
    typesig { [] }
    # Returns a list of grayed elements in this viewer's tree,
    # including currently hidden ones that are marked as
    # grayed but are under a collapsed ancestor.
    # <p>
    # This method is typically used when preserving the interesting
    # state of a viewer; <code>setGrayedElements</code> is used during the restore.
    # </p>
    # 
    # @return the array of grayed elements
    # 
    # @see #setGrayedElements
    def get_grayed_elements
      result = ArrayList.new
      internal_collect_grayed(result, get_control)
      return result.to_array
    end
    
    typesig { [SelectionEvent] }
    # (non-Javadoc)
    # Method declared on StructuredViewer.
    def handle_double_select(event)
      if (!(@last_clicked_item).nil?)
        item = @last_clicked_item
        data = item.get_data
        if (!(data).nil?)
          state = item.get_checked
          set_checked(data, !state)
          fire_check_state_changed(CheckStateChangedEvent.new(self, data, !state))
        end
        @last_clicked_item = nil
      else
        super(event)
      end
    end
    
    typesig { [SelectionEvent] }
    # (non-Javadoc)
    # Method declared on StructuredViewer.
    def handle_select(event)
      @last_clicked_item = nil
      if ((event.attr_detail).equal?(SWT::CHECK))
        item = event.attr_item
        @last_clicked_item = item
        super(event)
        data = item.get_data
        if (!(data).nil?)
          fire_check_state_changed(CheckStateChangedEvent.new(self, data, item.get_checked))
        end
      else
        super(event)
      end
    end
    
    typesig { [JavaList, Widget] }
    # Gathers the checked states of the given widget and its
    # descendents, following a pre-order traversal of the tree.
    # 
    # @param result a writable list of elements (element type: <code>Object</code>)
    # @param widget the widget
    def internal_collect_checked(result, widget)
      items = get_children(widget)
      i = 0
      while i < items.attr_length
        item = items[i]
        if (item.is_a?(TreeItem) && (item).get_checked)
          data = item.get_data
          if (!(data).nil?)
            result.add(data)
          end
        end
        internal_collect_checked(result, item)
        i += 1
      end
    end
    
    typesig { [JavaList, Widget] }
    # Gathers the grayed states of the given widget and its
    # descendents, following a pre-order traversal of the tree.
    # 
    # @param result a writable list of elements (element type: <code>Object</code>)
    # @param widget the widget
    def internal_collect_grayed(result, widget)
      items = get_children(widget)
      i = 0
      while i < items.attr_length
        item = items[i]
        if (item.is_a?(TreeItem) && (item).get_grayed)
          data = item.get_data
          if (!(data).nil?)
            result.add(data)
          end
        end
        internal_collect_grayed(result, item)
        i += 1
      end
    end
    
    typesig { [CustomHashtable, Widget] }
    # Sets the checked state of all items to correspond to the given set of checked elements.
    # 
    # @param checkedElements the set (element type: <code>Object</code>) of elements which are checked
    # @param widget the widget
    def internal_set_checked(checked_elements, widget)
      items = get_children(widget)
      i = 0
      while i < items.attr_length
        item = items[i]
        data = item.get_data
        if (!(data).nil?)
          checked = checked_elements.contains_key(data)
          if (!(checked).equal?(item.get_checked))
            item.set_checked(checked)
          end
        end
        internal_set_checked(checked_elements, item)
        i += 1
      end
    end
    
    typesig { [CustomHashtable, Widget] }
    # Sets the grayed state of all items to correspond to the given set of grayed elements.
    # 
    # @param grayedElements the set (element type: <code>Object</code>) of elements which are grayed
    # @param widget the widget
    def internal_set_grayed(grayed_elements, widget)
      items = get_children(widget)
      i = 0
      while i < items.attr_length
        item = items[i]
        data = item.get_data
        if (!(data).nil?)
          grayed = grayed_elements.contains_key(data)
          if (!(grayed).equal?(item.get_grayed))
            item.set_grayed(grayed)
          end
        end
        internal_set_grayed(grayed_elements, item)
        i += 1
      end
    end
    
    typesig { [Runnable] }
    # (non-Javadoc)
    # Method declared on Viewer.
    def preserving_selection(update_code)
      if (!get_preserve_selection)
        return
      end
      # If a check provider is present, it determines the state across input
      # changes.
      if (!(@check_state_provider).nil?)
        # Try to preserve the selection, let the ICheckProvider manage
        # the check states
        super(update_code)
        return
      end
      # Preserve checked items
      n = get_item_count(get_control)
      checked_nodes = new_hashtable(n * 2 + 1)
      grayed_nodes = new_hashtable(n * 2 + 1)
      gather_state(checked_nodes, grayed_nodes, get_control)
      super(update_code)
      apply_state(checked_nodes, grayed_nodes, get_control)
    end
    
    typesig { [ICheckStateListener] }
    # (non-Javadoc)
    # Method declared on ICheckable.
    def remove_check_state_listener(listener)
      @check_state_listeners.remove(listener)
    end
    
    typesig { [Object, ::Java::Boolean] }
    # (non-Javadoc)
    # Method declared on ICheckable.
    def set_checked(element, state)
      Assert.is_not_null(element)
      widget = internal_expand(element, false)
      if (widget.is_a?(TreeItem))
        (widget).set_checked(state)
        return true
      end
      return false
    end
    
    typesig { [Item, ::Java::Boolean] }
    # Sets the checked state for the children of the given item.
    # 
    # @param item the item
    # @param state <code>true</code> if the item should be checked,
    # and <code>false</code> if it should be unchecked
    def set_checked_children(item, state)
      create_children(item)
      items = get_children(item)
      if (!(items).nil?)
        i = 0
        while i < items.attr_length
          it = items[i]
          if (!(it.get_data).nil? && (it.is_a?(TreeItem)))
            tree_item = it
            tree_item.set_checked(state)
            set_checked_children(tree_item, state)
          end
          i += 1
        end
      end
    end
    
    typesig { [Array.typed(Object)] }
    # Sets which elements are checked in this viewer's tree.
    # The given list contains the elements that are to be checked;
    # all other elements are to be unchecked.
    # Does not fire events to check state listeners.
    # <p>
    # This method is typically used when restoring the interesting
    # state of a viewer captured by an earlier call to <code>getCheckedElements</code>.
    # </p>
    # 
    # @param elements the array of checked elements
    # @see #getCheckedElements
    def set_checked_elements(elements)
      assert_elements_not_null(elements)
      checked_elements = new_hashtable(elements.attr_length * 2 + 1)
      i = 0
      while i < elements.attr_length
        element = elements[i]
        # Ensure item exists for element
        internal_expand(element, false)
        checked_elements.put(element, element)
        (i += 1)
      end
      tree = get_control
      tree.set_redraw(false)
      internal_set_checked(checked_elements, tree)
      tree.set_redraw(true)
    end
    
    typesig { [Object, ::Java::Boolean] }
    # Sets the grayed state for the given element in this viewer.
    # 
    # @param element the element
    # @param state <code>true</code> if the item should be grayed,
    # and <code>false</code> if it should be ungrayed
    # @return <code>true</code> if the gray state could be set,
    # and <code>false</code> otherwise
    def set_grayed(element, state)
      Assert.is_not_null(element)
      widget = internal_expand(element, false)
      if (widget.is_a?(TreeItem))
        (widget).set_grayed(state)
        return true
      end
      return false
    end
    
    typesig { [Object, ::Java::Boolean] }
    # Check and gray the selection rather than calling both
    # setGrayed and setChecked as an optimization.
    # Does not fire events to check state listeners.
    # @param element the item being checked
    # @param state a boolean indicating selection or deselection
    # @return boolean indicating success or failure.
    def set_gray_checked(element, state)
      Assert.is_not_null(element)
      widget = internal_expand(element, false)
      if (widget.is_a?(TreeItem))
        item = widget
        item.set_checked(state)
        item.set_grayed(state)
        return true
      end
      return false
    end
    
    typesig { [Array.typed(Object)] }
    # Sets which elements are grayed in this viewer's tree.
    # The given list contains the elements that are to be grayed;
    # all other elements are to be ungrayed.
    # <p>
    # This method is typically used when restoring the interesting
    # state of a viewer captured by an earlier call to <code>getGrayedElements</code>.
    # </p>
    # 
    # @param elements the array of grayed elements
    # 
    # @see #getGrayedElements
    def set_grayed_elements(elements)
      assert_elements_not_null(elements)
      grayed_elements = new_hashtable(elements.attr_length * 2 + 1)
      i = 0
      while i < elements.attr_length
        element = elements[i]
        # Ensure item exists for element
        internal_expand(element, false)
        grayed_elements.put(element, element)
        (i += 1)
      end
      tree = get_control
      tree.set_redraw(false)
      internal_set_grayed(grayed_elements, tree)
      tree.set_redraw(true)
    end
    
    typesig { [Object, ::Java::Boolean] }
    # Sets the grayed state for the given element and its parents
    # in this viewer.
    # 
    # @param element the element
    # @param state <code>true</code> if the item should be grayed,
    # and <code>false</code> if it should be ungrayed
    # @return <code>true</code> if the element is visible and the gray
    # state could be set, and <code>false</code> otherwise
    # @see #setGrayed
    def set_parents_grayed(element, state)
      Assert.is_not_null(element)
      widget = internal_expand(element, false)
      if (widget.is_a?(TreeItem))
        item = widget
        item.set_grayed(state)
        item = item.get_parent_item
        while (!(item).nil?)
          item.set_grayed(state)
          item = item.get_parent_item
        end
        return true
      end
      return false
    end
    
    typesig { [Object, ::Java::Boolean] }
    # Sets the checked state for the given element and its visible
    # children in this viewer.
    # Assumes that the element has been expanded before. To enforce
    # that the item is expanded, call <code>expandToLevel</code>
    # for the element.
    # Does not fire events to check state listeners.
    # 
    # @param element the element
    # @param state <code>true</code> if the item should be checked,
    # and <code>false</code> if it should be unchecked
    # @return <code>true</code> if the checked state could be set,
    # and <code>false</code> otherwise
    def set_subtree_checked(element, state)
      widget = internal_expand(element, false)
      if (widget.is_a?(TreeItem))
        item = widget
        item.set_checked(state)
        set_checked_children(item, state)
        return true
      end
      return false
    end
    
    typesig { [::Java::Boolean] }
    # Sets to the given value the checked state for all elements in this viewer.
    # Does not fire events to check state listeners.
    # Assumes that the element has been expanded before. To enforce
    # that the item is expanded, call <code>expandToLevel</code>
    # for the element.
    # 
    # @param state <code>true</code> if the element should be checked,
    # and <code>false</code> if it should be unchecked
    # @deprecated as this method only checks or unchecks visible items
    # is is recommended that {@link #setSubtreeChecked(Object, boolean)}
    # is used instead.
    # @see #setSubtreeChecked(Object, boolean)
    # 
    # @since 3.2
    def set_all_checked(state)
      set_all_checked(state, get_tree.get_items)
    end
    
    typesig { [::Java::Boolean, Array.typed(TreeItem)] }
    # Set the checked state of the visible items and their children to state.
    # @param state
    # @param items
    # @deprecated
    # @see #setAllChecked(boolean)
    def set_all_checked(state, items)
      i = 0
      while i < items.attr_length
        items[i].set_checked(state)
        children = items[i].get_items
        set_all_checked(state, children)
        i += 1
      end
    end
    
    typesig { [Item, Object] }
    def optionally_prune_children(item, element)
      return false
    end
    
    private
    alias_method :initialize__checkbox_tree_viewer, :initialize
  end
  
end
