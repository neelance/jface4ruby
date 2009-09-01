require "rjava"

# Copyright (c) 2000, 2009 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
# Tom Schindl <tom.schindl@bestsolution.at> - concept of ViewerRow,
# fix for 159597, refactoring (bug 153993),
# widget-independency (bug 154329), fix for 187826, 191468
# Peter Centgraf - bug 251575
module Org::Eclipse::Jface::Viewers
  module TableViewerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Item
      include_const ::Org::Eclipse::Swt::Widgets, :Table
      include_const ::Org::Eclipse::Swt::Widgets, :TableItem
      include_const ::Org::Eclipse::Swt::Widgets, :Widget
    }
  end
  
  # A concrete viewer based on a SWT <code>Table</code> control.
  # <p>
  # This class is not intended to be subclassed outside the viewer framework. It
  # is designed to be instantiated with a pre-existing SWT table control and
  # configured with a domain-specific content provider, table label provider,
  # element filter (optional), and element sorter (optional).
  # </p>
  # <p>
  # Label providers for table viewers must implement either the
  # <code>ITableLabelProvider</code> or the <code>ILabelProvider</code> interface
  # (see <code>TableViewer.setLabelProvider</code> for more details).
  # </p>
  # <p>
  # As of 3.1 the TableViewer now supports the SWT.VIRTUAL flag. If the
  # underlying table is SWT.VIRTUAL, the content provider may implement {@link
  # ILazyContentProvider} instead of {@link IStructuredContentProvider} . Note
  # that in this case, the viewer does not support sorting or filtering. Also
  # note that in this case, the Widget based APIs may return null if the element
  # is not specified or not created yet.
  # </p>
  # <p>
  # Users of SWT.VIRTUAL should also avoid using getItems() from the Table within
  # the TreeViewer as this does not necessarily generate a callback for the
  # TreeViewer to populate the items. It also has the side effect of creating all
  # of the items thereby eliminating the performance improvements of SWT.VIRTUAL.
  # </p>
  # <p>
  # Users setting up an editable table with more than 1 column <b>have</b> to pass the
  # SWT.FULL_SELECTION style bit
  # </p>
  # 
  # @see SWT#VIRTUAL
  # @see #doFindItem(Object)
  # @see #internalRefresh(Object, boolean)
  # @noextend This class is not intended to be subclassed by clients.
  class TableViewer < TableViewerImports.const_get :AbstractTableViewer
    include_class_members TableViewerImports
    
    # This viewer's table control.
    attr_accessor :table
    alias_method :attr_table, :table
    undef_method :table
    alias_method :attr_table=, :table=
    undef_method :table=
    
    # The cached row which is reused all over
    attr_accessor :cached_row
    alias_method :attr_cached_row, :cached_row
    undef_method :cached_row
    alias_method :attr_cached_row=, :cached_row=
    undef_method :cached_row=
    
    typesig { [Composite] }
    # Creates a table viewer on a newly-created table control under the given
    # parent. The table control is created using the SWT style bits
    # <code>MULTI, H_SCROLL, V_SCROLL,</code> and <code>BORDER</code>. The
    # viewer has no input, no content provider, a default label provider, no
    # sorter, and no filters. The table has no columns.
    # 
    # @param parent
    # the parent control
    def initialize(parent)
      initialize__table_viewer(parent, SWT::MULTI | SWT::H_SCROLL | SWT::V_SCROLL | SWT::BORDER)
    end
    
    typesig { [Composite, ::Java::Int] }
    # Creates a table viewer on a newly-created table control under the given
    # parent. The table control is created using the given style bits. The
    # viewer has no input, no content provider, a default label provider, no
    # sorter, and no filters. The table has no columns.
    # 
    # @param parent
    # the parent control
    # @param style
    # SWT style bits
    def initialize(parent, style)
      initialize__table_viewer(Table.new(parent, style))
    end
    
    typesig { [Table] }
    # Creates a table viewer on the given table control. The viewer has no
    # input, no content provider, a default label provider, no sorter, and no
    # filters.
    # 
    # @param table
    # the table control
    def initialize(table)
      @table = nil
      @cached_row = nil
      super()
      @table = table
      hook_control(table)
    end
    
    typesig { [] }
    def get_control
      return @table
    end
    
    typesig { [] }
    # Returns this table viewer's table control.
    # 
    # @return the table control
    def get_table
      return @table
    end
    
    typesig { [] }
    def create_viewer_editor
      return TableViewerEditor.new(self, nil, ColumnViewerEditorActivationStrategy.new(self), ColumnViewerEditor::DEFAULT)
    end
    
    typesig { [ISelection, ::Java::Boolean] }
    # <p>
    # Sets a new selection for this viewer and optionally makes it visible. The
    # TableViewer implementation of this method is inefficient for the
    # ILazyContentProvider as lookup is done by indices rather than elements
    # and may require population of the entire table in worse case.
    # </p>
    # <p>
    # Use Table#setSelection(int[] indices) and Table#showSelection() if you
    # wish to set selection more efficiently when using a ILazyContentProvider.
    # </p>
    # 
    # @param selection
    # the new selection
    # @param reveal
    # <code>true</code> if the selection is to be made visible, and
    # <code>false</code> otherwise
    # @see Table#setSelection(int[])
    # @see Table#showSelection()
    def set_selection(selection, reveal)
      super(selection, reveal)
    end
    
    typesig { [Widget] }
    def get_viewer_row_from_item(item)
      if ((@cached_row).nil?)
        @cached_row = TableViewerRow.new(item)
      else
        @cached_row.set_item(item)
      end
      return @cached_row
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Create a new row with style at index
    # 
    # @param style
    # @param rowIndex
    # @return ViewerRow
    # @since 3.3
    def internal_create_new_row_part(style, row_index)
      item = nil
      if (row_index >= 0)
        item = TableItem.new(@table, style, row_index)
      else
        item = TableItem.new(@table, style)
      end
      return get_viewer_row_from_item(item)
    end
    
    typesig { [Point] }
    def get_item_at(p)
      selection = @table.get_selection
      if ((selection.attr_length).equal?(1))
        column_count = @table.get_column_count
        i = 0
        while i < column_count
          if (selection[0].get_bounds(i).contains(p))
            return selection[0]
          end
          i += 1
        end
      end
      return @table.get_item(p)
    end
    
    typesig { [] }
    # Methods to provide widget independency
    def do_get_item_count
      return @table.get_item_count
    end
    
    typesig { [Item] }
    def do_index_of(item)
      return @table.index_of(item)
    end
    
    typesig { [::Java::Int] }
    def do_set_item_count(count)
      @table.set_item_count(count)
    end
    
    typesig { [] }
    def do_get_items
      return @table.get_items
    end
    
    typesig { [] }
    def do_get_column_count
      return @table.get_column_count
    end
    
    typesig { [::Java::Int] }
    def do_get_column(index)
      return @table.get_column(index)
    end
    
    typesig { [::Java::Int] }
    def do_get_item(index)
      return @table.get_item(index)
    end
    
    typesig { [] }
    def do_get_selection
      return @table.get_selection
    end
    
    typesig { [] }
    def do_get_selection_indices
      return @table.get_selection_indices
    end
    
    typesig { [] }
    def do_clear_all
      @table.clear_all
    end
    
    typesig { [Item] }
    def do_reset_item(item)
      table_item = item
      column_count = Math.max(1, @table.get_column_count)
      i = 0
      while i < column_count
        table_item.set_text(i, "") # $NON-NLS-1$
        if (!(table_item.get_image(i)).nil?)
          table_item.set_image(i, nil)
        end
        i += 1
      end
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    def do_remove(start, end_)
      @table.remove(start, end_)
    end
    
    typesig { [] }
    def do_remove_all
      @table.remove_all
    end
    
    typesig { [Array.typed(::Java::Int)] }
    def do_remove(indices)
      @table.remove(indices)
    end
    
    typesig { [Item] }
    def do_show_item(item)
      @table.show_item(item)
    end
    
    typesig { [] }
    def do_deselect_all
      @table.deselect_all
    end
    
    typesig { [Array.typed(Item)] }
    def do_set_selection(items)
      Assert.is_not_null(items, "Items-Array can not be null") # $NON-NLS-1$
      t = Array.typed(TableItem).new(items.attr_length) { nil }
      System.arraycopy(items, 0, t, 0, t.attr_length)
      @table.set_selection(t)
    end
    
    typesig { [] }
    def do_show_selection
      @table.show_selection
    end
    
    typesig { [Array.typed(::Java::Int)] }
    def do_set_selection(indices)
      @table.set_selection(indices)
    end
    
    typesig { [::Java::Int] }
    def do_clear(index)
      @table.clear(index)
    end
    
    typesig { [Array.typed(::Java::Int)] }
    def do_select(indices)
      @table.select(indices)
    end
    
    typesig { [Object, ::Java::Boolean, ::Java::Boolean] }
    # Refreshes this viewer starting with the given element. Labels are updated
    # as described in <code>refresh(boolean updateLabels)</code>. The methods
    # attempts to preserve the selection.
    # <p>
    # Unlike the <code>update</code> methods, this handles structural changes
    # to the given element (e.g. addition or removal of children). If only the
    # given element needs updating, it is more efficient to use the
    # <code>update</code> methods.
    # </p>
    # 
    # <p>
    # Subclasses who can provide this feature can open this method for the
    # public
    # </p>
    # 
    # @param element
    # the element
    # @param updateLabels
    # <code>true</code> to update labels for existing elements,
    # <code>false</code> to only update labels as needed, assuming that labels
    # for existing elements are unchanged.
    # @param reveal
    # <code>true</code> to make the preserved selection visible afterwards
    # 
    # @since 3.3
    def refresh(element, update_labels, reveal)
      if (check_busy)
        return
      end
      if (is_cell_editor_active)
        cancel_editing
      end
      preserving_selection(Class.new(Runnable.class == Class ? Runnable : Object) do
        extend LocalClass
        include_class_members TableViewer
        include Runnable if Runnable.class == Module
        
        typesig { [] }
        define_method :run do
          internal_refresh(element, update_labels)
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self), reveal)
    end
    
    typesig { [::Java::Boolean, ::Java::Boolean] }
    # Refreshes this viewer with information freshly obtained from this
    # viewer's model. If <code>updateLabels</code> is <code>true</code> then
    # labels for otherwise unaffected elements are updated as well. Otherwise,
    # it assumes labels for existing elements are unchanged, and labels are
    # only obtained as needed (for example, for new elements).
    # <p>
    # Calling <code>refresh(true)</code> has the same effect as
    # <code>refresh()</code>.
    # <p>
    # Note that the implementation may still obtain labels for existing
    # elements even if <code>updateLabels</code> is false. The intent is simply
    # to allow optimization where possible.
    # 
    # @param updateLabels
    # <code>true</code> to update labels for existing elements,
    # <code>false</code> to only update labels as needed, assuming that labels
    # for existing elements are unchanged.
    # @param reveal
    # <code>true</code> to make the preserved selection visible afterwards
    # 
    # @since 3.3
    def refresh(update_labels, reveal)
      refresh(get_root, update_labels, reveal)
    end
    
    typesig { [Array.typed(Object)] }
    # (non-Javadoc)
    # @see org.eclipse.jface.viewers.AbstractTableViewer#remove(java.lang.Object[])
    def remove(elements)
      assert_elements_not_null(elements)
      if (check_busy)
        return
      end
      if ((elements.attr_length).equal?(0))
        return
      end
      # deselect any items that are being removed, see bug 97786
      deselected_items = false
      element_to_be_removed = nil
      elements_to_be_removed = nil
      if ((elements.attr_length).equal?(1))
        element_to_be_removed = elements[0]
      else
        elements_to_be_removed = CustomHashtable.new(get_comparer)
        i = 0
        while i < elements.attr_length
          element = elements[i]
          elements_to_be_removed.put(element, element)
          i += 1
        end
      end
      selection_indices = do_get_selection_indices
      i = 0
      while i < selection_indices.attr_length
        index = selection_indices[i]
        item = do_get_item(index)
        data = item.get_data
        if (!(data).nil?)
          if ((!(elements_to_be_removed).nil? && elements_to_be_removed.contains_key(data)) || self.==(element_to_be_removed, data))
            @table.deselect(index)
            deselected_items = true
          end
        end
        i += 1
      end
      super(elements)
      if (deselected_items)
        sel = get_selection
        update_selection(sel)
        fire_post_selection_changed(SelectionChangedEvent.new(self, sel))
      end
    end
    
    typesig { [Object] }
    def do_find_item(element)
      content_provider = get_content_provider
      if (content_provider.is_a?(IIndexableLazyContentProvider))
        indexable = content_provider
        idx = indexable.find_element(element)
        if (!(idx).equal?(-1))
          return do_get_item(idx)
        end
        return nil
      end
      return super(element)
    end
    
    private
    alias_method :initialize__table_viewer, :initialize
  end
  
end
