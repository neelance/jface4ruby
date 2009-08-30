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
  module CheckboxTableViewerImports #:nodoc:
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
      include_const ::Org::Eclipse::Swt::Widgets, :Table
      include_const ::Org::Eclipse::Swt::Widgets, :TableColumn
      include_const ::Org::Eclipse::Swt::Widgets, :TableItem
      include_const ::Org::Eclipse::Swt::Widgets, :Widget
    }
  end
  
  # A concrete viewer based on an SWT <code>Table</code>
  # control with checkboxes on each node.
  # <p>This class supports setting an {@link ICheckStateProvider} to
  # set the checkbox states. To see standard SWT behavior, view
  # SWT Snippet274.</p>
  # <p>
  # This class is not intended to be subclassed outside the viewer framework.
  # It is designed to be instantiated with a pre-existing SWT table control and configured
  # with a domain-specific content provider, label provider, element filter (optional),
  # and element sorter (optional).
  # </p>
  # @noextend This class is not intended to be subclassed by clients.
  class CheckboxTableViewer < CheckboxTableViewerImports.const_get :TableViewer
    include_class_members CheckboxTableViewerImports
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
    
    typesig { [Composite] }
    # Creates a table viewer on a newly-created table control under the given parent.
    # The table control is created using the SWT style bits:
    # <code>SWT.CHECK</code> and <code>SWT.BORDER</code>.
    # The table has one column.
    # The viewer has no input, no content provider, a default label provider,
    # no sorter, and no filters.
    # <p>
    # This is equivalent to calling <code>new CheckboxTableViewer(parent, SWT.BORDER)</code>.
    # See that constructor for more details.
    # </p>
    # 
    # @param parent the parent control
    # 
    # @deprecated use newCheckList(Composite, int) or new CheckboxTableViewer(Table)
    # instead (see below for details)
    def initialize(parent)
      initialize__checkbox_table_viewer(parent, SWT::BORDER)
    end
    
    typesig { [Composite, ::Java::Int] }
    # Creates a table viewer on a newly-created table control under the given parent.
    # The table control is created using the given SWT style bits, plus the
    # <code>SWT.CHECK</code> style bit.
    # The table has one column.
    # The viewer has no input, no content provider, a default label provider,
    # no sorter, and no filters.
    # <p>
    # This also adds a <code>TableColumn</code> for the single column,
    # and sets a <code>TableLayout</code> on the table which sizes the column to fill
    # the table for its initial sizing, but does nothing on subsequent resizes.
    # </p>
    # <p>
    # If the caller just needs to show a single column with no header,
    # it is preferable to use the <code>newCheckList</code> factory method instead,
    # since SWT properly handles the initial sizing and subsequent resizes in this case.
    # </p>
    # <p>
    # If the caller adds its own columns, uses <code>Table.setHeadersVisible(true)</code>,
    # or needs to handle dynamic resizing of the table, it is recommended to
    # create the <code>Table</code> itself, specifying the <code>SWT.CHECK</code> style bit
    # (along with any other style bits needed), and use <code>new CheckboxTableViewer(Table)</code>
    # rather than this constructor.
    # </p>
    # 
    # @param parent the parent control
    # @param style SWT style bits
    # 
    # @deprecated use newCheckList(Composite, int) or new CheckboxTableViewer(Table)
    # instead (see above for details)
    def initialize(parent, style)
      initialize__checkbox_table_viewer(create_table(parent, style))
    end
    
    class_module.module_eval {
      typesig { [Composite, ::Java::Int] }
      # Creates a table viewer on a newly-created table control under the given parent.
      # The table control is created using the given SWT style bits, plus the
      # <code>SWT.CHECK</code> style bit.
      # The table shows its contents in a single column, with no header.
      # The viewer has no input, no content provider, a default label provider,
      # no sorter, and no filters.
      # <p>
      # No <code>TableColumn</code> is added. SWT does not require a
      # <code>TableColumn</code> if showing only a single column with no header.
      # SWT correctly handles the initial sizing and subsequent resizes in this case.
      # 
      # @param parent the parent control
      # @param style SWT style bits
      # 
      # @since 2.0
      # @return CheckboxTableViewer
      def new_check_list(parent, style)
        table = Table.new(parent, SWT::CHECK | style)
        return CheckboxTableViewer.new(table)
      end
    }
    
    typesig { [Table] }
    # Creates a table viewer on the given table control.
    # The <code>SWT.CHECK</code> style bit must be set on the given table control.
    # The viewer has no input, no content provider, a default label provider,
    # no sorter, and no filters.
    # 
    # @param table the table control
    def initialize(table)
      @check_state_listeners = nil
      @check_state_provider = nil
      super(table)
      @check_state_listeners = ListenerList.new
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
    
    typesig { [Widget, Object, ::Java::Boolean] }
    # Extends this method to update check box states.
    def do_update_item(widget, element, full_map)
      super(widget, element, full_map)
      if (!widget.is_disposed)
        if (!(@check_state_provider).nil?)
          set_checked(element, @check_state_provider.is_checked(element))
          set_grayed(element, @check_state_provider.is_grayed(element))
        end
      end
    end
    
    class_module.module_eval {
      typesig { [Composite, ::Java::Int] }
      # Creates a new table control with one column.
      # 
      # @param parent the parent control
      # @param style style bits
      # @return a new table control
      def create_table(parent, style)
        table = Table.new(parent, SWT::CHECK | style)
        # Although this table column is not needed, and can cause resize problems,
        # it can't be removed since this would be a breaking change against R1.0.
        # See bug 6643 for more details.
        TableColumn.new(table, SWT::NONE)
        layout = TableLayout.new
        layout.add_column_data(ColumnWeightData.new(100))
        table.set_layout(layout)
        return table
      end
    }
    
    typesig { [CheckStateChangedEvent] }
    # Notifies any check state listeners that a check state changed  has been received.
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
          include_class_members CheckboxTableViewer
          include SafeRunnable if SafeRunnable.class == Module
          
          typesig { [] }
          define_method :run do
            l.check_state_changed(event)
          end
          
          typesig { [Object] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
        i += 1
      end
    end
    
    typesig { [Object] }
    # (non-Javadoc)
    # Method declared on ICheckable.
    def get_checked(element)
      widget = find_item(element)
      if (widget.is_a?(TableItem))
        return (widget).get_checked
      end
      return false
    end
    
    typesig { [] }
    # Returns a list of elements corresponding to checked table items in this
    # viewer.
    # <p>
    # This method is typically used when preserving the interesting
    # state of a viewer; <code>setCheckedElements</code> is used during the restore.
    # </p>
    # 
    # @return the array of checked elements
    # @see #setCheckedElements
    def get_checked_elements
      children = get_table.get_items
      v = ArrayList.new(children.attr_length)
      i = 0
      while i < children.attr_length
        item = children[i]
        if (item.get_checked)
          v.add(item.get_data)
        end
        i += 1
      end
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
      if (widget.is_a?(TableItem))
        return (widget).get_grayed
      end
      return false
    end
    
    typesig { [] }
    # Returns a list of elements corresponding to grayed nodes in this
    # viewer.
    # <p>
    # This method is typically used when preserving the interesting
    # state of a viewer; <code>setGrayedElements</code> is used during the restore.
    # </p>
    # 
    # @return the array of grayed elements
    # @see #setGrayedElements
    def get_grayed_elements
      children = get_table.get_items
      v = ArrayList.new(children.attr_length)
      i = 0
      while i < children.attr_length
        item = children[i]
        if (item.get_grayed)
          v.add(item.get_data)
        end
        i += 1
      end
      return v.to_array
    end
    
    typesig { [SelectionEvent] }
    # (non-Javadoc)
    # Method declared on StructuredViewer.
    def handle_select(event)
      if ((event.attr_detail).equal?(SWT::CHECK))
        super(event) # this will change the current selection
        item = event.attr_item
        data = item.get_data
        if (!(data).nil?)
          fire_check_state_changed(CheckStateChangedEvent.new(self, data, item.get_checked))
        end
      else
        super(event)
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
      children = get_table.get_items
      checked = new_hashtable(children.attr_length * 2 + 1)
      grayed = new_hashtable(children.attr_length * 2 + 1)
      i = 0
      while i < children.attr_length
        item = children[i]
        data = item.get_data
        if (!(data).nil?)
          if (item.get_checked)
            checked.put(data, data)
          end
          if (item.get_grayed)
            grayed.put(data, data)
          end
        end
        i += 1
      end
      super(update_code)
      children = get_table.get_items
      i_ = 0
      while i_ < children.attr_length
        item = children[i_]
        data = item.get_data
        if (!(data).nil?)
          item.set_checked(checked.contains_key(data))
          item.set_grayed(grayed.contains_key(data))
        end
        i_ += 1
      end
    end
    
    typesig { [ICheckStateListener] }
    # (non-Javadoc)
    # Method declared on ICheckable.
    def remove_check_state_listener(listener)
      @check_state_listeners.remove(listener)
    end
    
    typesig { [::Java::Boolean] }
    # Sets to the given value the checked state for all elements in this viewer.
    # Does not fire events to check state listeners.
    # 
    # @param state <code>true</code> if the element should be checked,
    # and <code>false</code> if it should be unchecked
    def set_all_checked(state)
      children = get_table.get_items
      i = 0
      while i < children.attr_length
        item = children[i]
        item.set_checked(state)
        i += 1
      end
    end
    
    typesig { [::Java::Boolean] }
    # Sets to the given value the grayed state for all elements in this viewer.
    # 
    # @param state <code>true</code> if the element should be grayed,
    # and <code>false</code> if it should be ungrayed
    def set_all_grayed(state)
      children = get_table.get_items
      i = 0
      while i < children.attr_length
        item = children[i]
        item.set_grayed(state)
        i += 1
      end
    end
    
    typesig { [Object, ::Java::Boolean] }
    # (non-Javadoc)
    # Method declared on ICheckable.
    def set_checked(element, state)
      Assert.is_not_null(element)
      widget = find_item(element)
      if (widget.is_a?(TableItem))
        (widget).set_checked(state)
        return true
      end
      return false
    end
    
    typesig { [Array.typed(Object)] }
    # Sets which nodes are checked in this viewer.
    # The given list contains the elements that are to be checked;
    # all other nodes are to be unchecked.
    # Does not fire events to check state listeners.
    # <p>
    # This method is typically used when restoring the interesting
    # state of a viewer captured by an earlier call to <code>getCheckedElements</code>.
    # </p>
    # 
    # @param elements the list of checked elements (element type: <code>Object</code>)
    # @see #getCheckedElements
    def set_checked_elements(elements)
      assert_elements_not_null(elements)
      set = new_hashtable(elements.attr_length * 2 + 1)
      i = 0
      while i < elements.attr_length
        set.put(elements[i], elements[i])
        (i += 1)
      end
      items = get_table.get_items
      i_ = 0
      while i_ < items.attr_length
        item = items[i_]
        element = item.get_data
        if (!(element).nil?)
          check = set.contains_key(element)
          # only set if different, to avoid flicker
          if (!(item.get_checked).equal?(check))
            item.set_checked(check)
          end
        end
        (i_ += 1)
      end
    end
    
    typesig { [Object, ::Java::Boolean] }
    # Sets the grayed state for the given element in this viewer.
    # 
    # @param element the element
    # @param state <code>true</code> if the item should be grayed,
    # and <code>false</code> if it should be ungrayed
    # @return <code>true</code> if the element is visible and the gray
    # state could be set, and <code>false</code> otherwise
    def set_grayed(element, state)
      Assert.is_not_null(element)
      widget = find_item(element)
      if (widget.is_a?(TableItem))
        (widget).set_grayed(state)
        return true
      end
      return false
    end
    
    typesig { [Array.typed(Object)] }
    # Sets which nodes are grayed in this viewer.
    # The given list contains the elements that are to be grayed;
    # all other nodes are to be ungrayed.
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
      set = new_hashtable(elements.attr_length * 2 + 1)
      i = 0
      while i < elements.attr_length
        set.put(elements[i], elements[i])
        (i += 1)
      end
      items = get_table.get_items
      i_ = 0
      while i_ < items.attr_length
        item = items[i_]
        element = item.get_data
        if (!(element).nil?)
          gray = set.contains_key(element)
          # only set if different, to avoid flicker
          if (!(item.get_grayed).equal?(gray))
            item.set_grayed(gray)
          end
        end
        (i_ += 1)
      end
    end
    
    private
    alias_method :initialize__checkbox_table_viewer, :initialize
  end
  
end
