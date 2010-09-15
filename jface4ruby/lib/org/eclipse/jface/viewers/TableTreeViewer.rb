require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
# Tom Schindl <tom.schindl@bestsolution.at> - bug 153993
module Org::Eclipse::Jface::Viewers
  module TableTreeViewerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
      include_const ::Java::Util, :JavaList
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Custom, :TableTree
      include_const ::Org::Eclipse::Swt::Custom, :TableTreeEditor
      include_const ::Org::Eclipse::Swt::Custom, :TableTreeItem
      include_const ::Org::Eclipse::Swt::Events, :FocusAdapter
      include_const ::Org::Eclipse::Swt::Events, :FocusEvent
      include_const ::Org::Eclipse::Swt::Events, :FocusListener
      include_const ::Org::Eclipse::Swt::Events, :MouseAdapter
      include_const ::Org::Eclipse::Swt::Events, :MouseEvent
      include_const ::Org::Eclipse::Swt::Events, :MouseListener
      include_const ::Org::Eclipse::Swt::Events, :TreeListener
      include_const ::Org::Eclipse::Swt::Graphics, :Image
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Graphics, :Rectangle
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Display
      include_const ::Org::Eclipse::Swt::Widgets, :Item
      include_const ::Org::Eclipse::Swt::Widgets, :Widget
    }
  end
  
  # A concrete viewer based on a SWT <code>TableTree</code> control.
  # <p>
  # This class is not intended to be subclassed outside the viewer framework. It
  # is designed to be instantiated with a pre-existing SWT table tree control and
  # configured with a domain-specific content provider, label provider, element
  # filter (optional), and element sorter (optional).
  # </p>
  # <p>
  # Content providers for table tree viewers must implement the
  # <code>ITreeContentProvider</code> interface.
  # </p>
  # <p>
  # Label providers for table tree viewers must implement either the
  # <code>ITableLabelProvider</code> or the <code>ILabelProvider</code>
  # interface (see <code>TableTreeViewer.setLabelProvider</code> for more
  # details).
  # </p>
  # 
  # @deprecated As of 3.1 use {@link TreeViewer} instead
  # @noextend This class is not intended to be subclassed by clients.
  class TableTreeViewer < TableTreeViewerImports.const_get :AbstractTreeViewer
    include_class_members TableTreeViewerImports
    
    # Internal table viewer implementation.
    attr_accessor :table_editor_impl
    alias_method :attr_table_editor_impl, :table_editor_impl
    undef_method :table_editor_impl
    alias_method :attr_table_editor_impl=, :table_editor_impl=
    undef_method :table_editor_impl=
    
    # This viewer's table tree control.
    attr_accessor :table_tree
    alias_method :attr_table_tree, :table_tree
    undef_method :table_tree
    alias_method :attr_table_tree=, :table_tree=
    undef_method :table_tree=
    
    # This viewer's table tree editor.
    attr_accessor :table_tree_editor
    alias_method :attr_table_tree_editor, :table_tree_editor
    undef_method :table_tree_editor
    alias_method :attr_table_tree_editor=, :table_tree_editor=
    undef_method :table_tree_editor=
    
    class_module.module_eval {
      # Copied from original TableEditorImpl and moved here since refactoring
      # completely wiped out the original implementation in 3.3
      # 
      # @since 3.1
      const_set_lazy(:TableTreeEditorImpl) { Class.new do
        local_class_in TableTreeViewer
        include_class_members TableTreeViewer
        
        attr_accessor :cell_editor
        alias_method :attr_cell_editor, :cell_editor
        undef_method :cell_editor
        alias_method :attr_cell_editor=, :cell_editor=
        undef_method :cell_editor=
        
        attr_accessor :cell_editors
        alias_method :attr_cell_editors, :cell_editors
        undef_method :cell_editors
        alias_method :attr_cell_editors=, :cell_editors=
        undef_method :cell_editors=
        
        attr_accessor :cell_modifier
        alias_method :attr_cell_modifier, :cell_modifier
        undef_method :cell_modifier
        alias_method :attr_cell_modifier=, :cell_modifier=
        undef_method :cell_modifier=
        
        attr_accessor :column_properties
        alias_method :attr_column_properties, :column_properties
        undef_method :column_properties
        alias_method :attr_column_properties=, :column_properties=
        undef_method :column_properties=
        
        attr_accessor :table_item
        alias_method :attr_table_item, :table_item
        undef_method :table_item
        alias_method :attr_table_item=, :table_item=
        undef_method :table_item=
        
        attr_accessor :column_number
        alias_method :attr_column_number, :column_number
        undef_method :column_number
        alias_method :attr_column_number=, :column_number=
        undef_method :column_number=
        
        attr_accessor :cell_editor_listener
        alias_method :attr_cell_editor_listener, :cell_editor_listener
        undef_method :cell_editor_listener
        alias_method :attr_cell_editor_listener=, :cell_editor_listener=
        undef_method :cell_editor_listener=
        
        attr_accessor :focus_listener
        alias_method :attr_focus_listener, :focus_listener
        undef_method :focus_listener
        alias_method :attr_focus_listener=, :focus_listener=
        undef_method :focus_listener=
        
        attr_accessor :mouse_listener
        alias_method :attr_mouse_listener, :mouse_listener
        undef_method :mouse_listener
        alias_method :attr_mouse_listener=, :mouse_listener=
        undef_method :mouse_listener=
        
        attr_accessor :double_click_expiration_time
        alias_method :attr_double_click_expiration_time, :double_click_expiration_time
        undef_method :double_click_expiration_time
        alias_method :attr_double_click_expiration_time=, :double_click_expiration_time=
        undef_method :double_click_expiration_time=
        
        attr_accessor :viewer
        alias_method :attr_viewer, :viewer
        undef_method :viewer
        alias_method :attr_viewer=, :viewer=
        undef_method :viewer=
        
        typesig { [class_self::ColumnViewer] }
        def initialize(viewer)
          @cell_editor = nil
          @cell_editors = nil
          @cell_modifier = nil
          @column_properties = nil
          @table_item = nil
          @column_number = 0
          @cell_editor_listener = nil
          @focus_listener = nil
          @mouse_listener = nil
          @double_click_expiration_time = 0
          @viewer = nil
          @viewer = viewer
          init_cell_editor_listener
        end
        
        typesig { [] }
        # Returns this <code>TableViewerImpl</code> viewer
        # 
        # @return the viewer
        def get_viewer
          return @viewer
        end
        
        typesig { [] }
        def activate_cell_editor
          if (!(@cell_editors).nil?)
            if (!(@cell_editors[@column_number]).nil? && !(@cell_modifier).nil?)
              element = @table_item.get_data
              property = @column_properties[@column_number]
              if (@cell_modifier.can_modify(element, property))
                @cell_editor = @cell_editors[@column_number]
                @cell_editor.add_listener(@cell_editor_listener)
                value = @cell_modifier.get_value(element, property)
                @cell_editor.set_value(value)
                # Tricky flow of control here:
                # activate() can trigger callback to cellEditorListener
                # which will clear cellEditor
                # so must get control first, but must still call activate()
                # even if there is no control.
                control = @cell_editor.get_control
                @cell_editor.activate
                if ((control).nil?)
                  return
                end
                set_layout_data(@cell_editor.get_layout_data)
                set_editor(control, @table_item, @column_number)
                @cell_editor.set_focus
                if ((@focus_listener).nil?)
                  @focus_listener = Class.new(self.class::FocusAdapter.class == Class ? self.class::FocusAdapter : Object) do
                    local_class_in TableTreeEditorImpl
                    include_class_members TableTreeEditorImpl
                    include class_self::FocusAdapter if class_self::FocusAdapter.class == Module
                    
                    typesig { [class_self::FocusEvent] }
                    define_method :focus_lost do |e|
                      apply_editor_value
                    end
                    
                    typesig { [Vararg.new(Object)] }
                    define_method :initialize do |*args|
                      super(*args)
                    end
                    
                    private
                    alias_method :initialize_anonymous, :initialize
                  end.new_local(self)
                end
                control.add_focus_listener(@focus_listener)
                @mouse_listener = Class.new(self.class::MouseAdapter.class == Class ? self.class::MouseAdapter : Object) do
                  local_class_in TableTreeEditorImpl
                  include_class_members TableTreeEditorImpl
                  include class_self::MouseAdapter if class_self::MouseAdapter.class == Module
                  
                  typesig { [class_self::MouseEvent] }
                  define_method :mouse_down do |e|
                    # time wrap?
                    # check for expiration of doubleClickTime
                    if (e.attr_time <= self.attr_double_click_expiration_time)
                      control.remove_mouse_listener(self.attr_mouse_listener)
                      cancel_editing
                      handle_double_click_event
                    else
                      if (!(self.attr_mouse_listener).nil?)
                        control.remove_mouse_listener(self.attr_mouse_listener)
                      end
                    end
                  end
                  
                  typesig { [Vararg.new(Object)] }
                  define_method :initialize do |*args|
                    super(*args)
                  end
                  
                  private
                  alias_method :initialize_anonymous, :initialize
                end.new_local(self)
                control.add_mouse_listener(@mouse_listener)
              end
            end
          end
        end
        
        typesig { [class_self::MouseEvent] }
        # Activate a cell editor for the given mouse position.
        def activate_cell_editor(event)
          if ((@table_item).nil? || @table_item.is_disposed)
            # item no longer exists
            return
          end
          column_to_edit = 0
          columns = get_column_count
          if ((columns).equal?(0))
            # If no TableColumn, Table acts as if it has a single column
            # which takes the whole width.
            column_to_edit = 0
          else
            column_to_edit = -1
            i = 0
            while i < columns
              bounds = get_bounds(@table_item, i)
              if (bounds.contains(event.attr_x, event.attr_y))
                column_to_edit = i
                break
              end
              i += 1
            end
            if ((column_to_edit).equal?(-1))
              return
            end
          end
          @column_number = column_to_edit
          activate_cell_editor
        end
        
        typesig { [] }
        # Deactivates the currently active cell editor.
        def apply_editor_value
          c = @cell_editor
          if (!(c).nil?)
            # null out cell editor before calling save
            # in case save results in applyEditorValue being re-entered
            # see 1GAHI8Z: ITPUI:ALL - How to code event notification when
            # using cell editor ?
            @cell_editor = nil
            t = @table_item
            # don't null out table item -- same item is still selected
            if (!(t).nil? && !t.is_disposed)
              save_editor_value(c, t)
            end
            set_editor(nil, nil, 0)
            c.remove_listener(@cell_editor_listener)
            control = c.get_control
            if (!(control).nil?)
              if (!(@mouse_listener).nil?)
                control.remove_mouse_listener(@mouse_listener)
              end
              if (!(@focus_listener).nil?)
                control.remove_focus_listener(@focus_listener)
              end
            end
            c.deactivate
          end
        end
        
        typesig { [] }
        # Cancels the active cell editor, without saving the value back to the
        # domain model.
        def cancel_editing
          if (!(@cell_editor).nil?)
            set_editor(nil, nil, 0)
            @cell_editor.remove_listener(@cell_editor_listener)
            old_editor = @cell_editor
            @cell_editor = nil
            old_editor.deactivate
          end
        end
        
        typesig { [Object, ::Java::Int] }
        # Start editing the given element.
        # 
        # @param element
        # @param column
        def edit_element(element, column)
          if (!(@cell_editor).nil?)
            apply_editor_value
          end
          set_selection(self.class::StructuredSelection.new(element), true)
          selection = get_selection
          if (!(selection.attr_length).equal?(1))
            return
          end
          @table_item = selection[0]
          # Make sure selection is visible
          show_selection
          @column_number = column
          activate_cell_editor
        end
        
        typesig { [] }
        # Return the array of CellEditors used in the viewer
        # 
        # @return the cell editors
        def get_cell_editors
          return @cell_editors
        end
        
        typesig { [] }
        # Get the cell modifier
        # 
        # @return the cell modifier
        def get_cell_modifier
          return @cell_modifier
        end
        
        typesig { [] }
        # Return the properties for the column
        # 
        # @return the array of column properties
        def get_column_properties
          return @column_properties
        end
        
        typesig { [class_self::MouseEvent] }
        # Handles the mouse down event; activates the cell editor.
        # 
        # @param event
        # the mouse event that should be handled
        def handle_mouse_down(event)
          if (!(event.attr_button).equal?(1))
            return
          end
          if (!(@cell_editor).nil?)
            apply_editor_value
          end
          # activate the cell editor immediately. If a second mouseDown
          # is received prior to the expiration of the doubleClick time then
          # the cell editor will be deactivated and a doubleClick event will
          # be processed.
          @double_click_expiration_time = event.attr_time + Display.get_current.get_double_click_time
          items = get_selection
          # Do not edit if more than one row is selected.
          if (!(items.attr_length).equal?(1))
            @table_item = nil
            return
          end
          @table_item = items[0]
          activate_cell_editor(event)
        end
        
        typesig { [] }
        def init_cell_editor_listener
          @cell_editor_listener = Class.new(self.class::ICellEditorListener.class == Class ? self.class::ICellEditorListener : Object) do
            local_class_in TableTreeEditorImpl
            include_class_members TableTreeEditorImpl
            include class_self::ICellEditorListener if class_self::ICellEditorListener.class == Module
            
            typesig { [::Java::Boolean, ::Java::Boolean] }
            define_method :editor_value_changed do |old_valid_state, new_valid_state|
              # Ignore.
            end
            
            typesig { [] }
            define_method :cancel_editor do
              @local_class_parent.cancel_editing
            end
            
            typesig { [] }
            define_method :apply_editor_value do
              @local_class_parent.apply_editor_value
            end
            
            typesig { [Vararg.new(Object)] }
            define_method :initialize do |*args|
              super(*args)
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self)
        end
        
        typesig { [] }
        # Return whether there is an active cell editor.
        # 
        # @return <code>true</code> if there is an active cell editor;
        # otherwise <code>false</code> is returned.
        def is_cell_editor_active
          return !(@cell_editor).nil?
        end
        
        typesig { [class_self::CellEditor, class_self::Item] }
        # Saves the value of the currently active cell editor, by delegating to
        # the cell modifier.
        def save_editor_value(cell_editor, table_item)
          if (!(@cell_modifier).nil?)
            if (!cell_editor.is_value_valid)
              # Do what????
            end
          end
          property = nil
          if (!(@column_properties).nil? && @column_number < @column_properties.attr_length)
            property = RJava.cast_to_string(@column_properties[@column_number])
          end
          @cell_modifier.modify(table_item, property, cell_editor.get_value)
        end
        
        typesig { [Array.typed(class_self::CellEditor)] }
        # Set the cell editors
        # 
        # @param editors
        def set_cell_editors(editors)
          @cell_editors = editors
        end
        
        typesig { [class_self::ICellModifier] }
        # Set the cell modifier
        # 
        # @param modifier
        def set_cell_modifier(modifier)
          @cell_modifier = modifier
        end
        
        typesig { [Array.typed(String)] }
        # Set the column properties
        # 
        # @param columnProperties
        def set_column_properties(column_properties)
          @column_properties = column_properties
        end
        
        typesig { [class_self::Item, ::Java::Int] }
        def get_bounds(item, column_number)
          return (item).get_bounds(column_number)
        end
        
        typesig { [] }
        def get_column_count
          # getColumnCount() should be a API in TableTree.
          return get_table_tree.get_table.get_column_count
        end
        
        typesig { [] }
        def get_selection
          return get_table_tree.get_selection
        end
        
        typesig { [class_self::Control, class_self::Item, ::Java::Int] }
        def set_editor(w, item, column_number)
          self.attr_table_tree_editor.set_editor(w, item, column_number)
        end
        
        typesig { [class_self::StructuredSelection, ::Java::Boolean] }
        def set_selection(selection, b)
          @local_class_parent.set_selection(selection, b)
        end
        
        typesig { [] }
        def show_selection
          get_table_tree.show_selection
        end
        
        typesig { [class_self::CellEditor::LayoutData] }
        def set_layout_data(layout_data)
          self.attr_table_tree_editor.attr_horizontal_alignment = layout_data.attr_horizontal_alignment
          self.attr_table_tree_editor.attr_grab_horizontal = layout_data.attr_grab_horizontal
          self.attr_table_tree_editor.attr_minimum_width = layout_data.attr_minimum_width
        end
        
        typesig { [] }
        def handle_double_click_event
          viewer = get_viewer
          fire_double_click(self.class::DoubleClickEvent.new(viewer, viewer.get_selection))
          fire_open(self.class::OpenEvent.new(viewer, viewer.get_selection))
        end
        
        private
        alias_method :initialize__table_tree_editor_impl, :initialize
      end }
    }
    
    typesig { [TableTree] }
    # Creates a table tree viewer on the given table tree control. The viewer
    # has no input, no content provider, a default label provider, no sorter,
    # and no filters.
    # 
    # @param tree
    # the table tree control
    def initialize(tree)
      @table_editor_impl = nil
      @table_tree = nil
      @table_tree_editor = nil
      super()
      @table_tree = tree
      hook_control(tree)
      @table_tree_editor = TableTreeEditor.new(@table_tree)
      @table_editor_impl = TableTreeEditorImpl.new_local(self, self)
    end
    
    typesig { [Composite] }
    # Creates a table tree viewer on a newly-created table tree control under
    # the given parent. The table tree control is created using the SWT style
    # bits <code>MULTI, H_SCROLL, V_SCROLL, and BORDER</code>. The viewer
    # has no input, no content provider, a default label provider, no sorter,
    # and no filters.
    # 
    # @param parent
    # the parent control
    def initialize(parent)
      initialize__table_tree_viewer(parent, SWT::MULTI | SWT::H_SCROLL | SWT::V_SCROLL | SWT::BORDER)
    end
    
    typesig { [Composite, ::Java::Int] }
    # Creates a table tree viewer on a newly-created table tree control under
    # the given parent. The table tree control is created using the given SWT
    # style bits. The viewer has no input, no content provider, a default label
    # provider, no sorter, and no filters.
    # 
    # @param parent
    # the parent control
    # @param style
    # the SWT style bits
    def initialize(parent, style)
      initialize__table_tree_viewer(TableTree.new(parent, style))
    end
    
    typesig { [Control, TreeListener] }
    # (non-Javadoc) Method declared on AbstractTreeViewer.
    def add_tree_listener(c, listener)
      (c).add_tree_listener(listener)
    end
    
    typesig { [] }
    # Cancels a currently active cell editor. All changes already done in the
    # cell editor are lost.
    def cancel_editing
      @table_editor_impl.cancel_editing
    end
    
    typesig { [Item, Object] }
    # (non-Javadoc) Method declared on AbstractTreeViewer.
    def do_update_item(item, element)
      # update icon and label
      # Similar code in TableTreeViewer.doUpdateItem()
      prov = get_label_provider
      tprov = nil
      if (prov.is_a?(ITableLabelProvider))
        tprov = prov
      end
      column_count = @table_tree.get_table.get_column_count
      ti = item
      # Also enter loop if no columns added. See 1G9WWGZ: JFUIF:WINNT -
      # TableViewer with 0 columns does not work
      column = 0
      while column < column_count || (column).equal?(0)
        text = "" # $NON-NLS-1$
        image = nil
        if (!(tprov).nil?)
          text = RJava.cast_to_string(tprov.get_column_text(element, column))
          image = tprov.get_column_image(element, column)
        else
          if ((column).equal?(0))
            update_label = ViewerLabel.new(item.get_text, item.get_image)
            build_label(update_label, element)
            # As it is possible for user code to run the event
            # loop check here.
            if (item.is_disposed)
              unmap_element(element, item)
              return
            end
            text = RJava.cast_to_string(update_label.get_text)
            image = update_label.get_image
          end
        end
        # Avoid setting text to null
        if ((text).nil?)
          text = "" # $NON-NLS-1$
        end
        ti.set_text(column, text)
        # Apparently a problem to setImage to null if already null
        if (!(ti.get_image(column)).equal?(image))
          ti.set_image(column, image)
        end
        get_color_and_font_collector.set_fonts_and_colors(element)
        get_color_and_font_collector.apply_fonts_and_colors(ti)
        column += 1
      end
    end
    
    typesig { [Object, ::Java::Int] }
    # Starts editing the given element.
    # 
    # @param element
    # the element
    # @param column
    # the column number
    def edit_element(element, column)
      @table_editor_impl.edit_element(element, column)
    end
    
    typesig { [] }
    # Returns the cell editors of this viewer.
    # 
    # @return the list of cell editors
    def get_cell_editors
      return @table_editor_impl.get_cell_editors
    end
    
    typesig { [] }
    # Returns the cell modifier of this viewer.
    # 
    # @return the cell modifier
    def get_cell_modifier
      return @table_editor_impl.get_cell_modifier
    end
    
    typesig { [Widget] }
    # (non-Javadoc) Method declared on AbstractTreeViewer.
    def get_children(o)
      if (o.is_a?(TableTreeItem))
        return (o).get_items
      end
      if (o.is_a?(TableTree))
        return (o).get_items
      end
      return nil
    end
    
    typesig { [Widget, ::Java::Int] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.viewers.AbstractTreeViewer#getChild(org.eclipse.swt.widgets.Widget,
    # int)
    def get_child(widget, index)
      if (widget.is_a?(TableTreeItem))
        return (widget).get_item(index)
      end
      if (widget.is_a?(TableTree))
        return (widget).get_item(index)
      end
      return nil
    end
    
    typesig { [] }
    # Returns the column properties of this viewer. The properties must
    # correspond with the columns of the table control. They are used to
    # identify the column in a cell modifier.
    # 
    # @return the list of column properties
    def get_column_properties
      return @table_editor_impl.get_column_properties
    end
    
    typesig { [] }
    # (non-Javadoc) Method declared on Viewer.
    def get_control
      return @table_tree
    end
    
    typesig { [::Java::Int] }
    # Returns the element with the given index from this viewer. Returns
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
      # XXX: Workaround for 1GBCSB1: SWT:WIN2000 - TableTree should have
      # getItem(int index)
      i = @table_tree.get_items[index]
      if (!(i).nil?)
        return i.get_data
      end
      return nil
    end
    
    typesig { [Item] }
    # (non-Javadoc) Method declared on AbstractTreeViewer.
    def get_expanded(item)
      return (item).get_expanded
    end
    
    typesig { [Point] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.viewers.ColumnViewer#getItemAt(org.eclipse.swt.graphics.Point)
    def get_item_at(p)
      return get_table_tree.get_table.get_item(p)
    end
    
    typesig { [Control] }
    # (non-Javadoc) Method declared on AbstractTreeViewer.
    def get_item_count(widget)
      return (widget).get_item_count
    end
    
    typesig { [Item] }
    # (non-Javadoc) Method declared on AbstractTreeViewer.
    def get_item_count(item)
      return (item).get_item_count
    end
    
    typesig { [Org::Eclipse::Swt::Widgets::Item] }
    # (non-Javadoc) Method declared on AbstractTreeViewer.
    def get_items(item)
      return (item).get_items
    end
    
    typesig { [] }
    # The table tree viewer implementation of this <code>Viewer</code>
    # framework method returns the label provider, which in the case of table
    # tree viewers will be an instance of either
    # <code>ITableLabelProvider</code> or <code>ILabelProvider</code>. If
    # it is an <code>ITableLabelProvider</code>, then it provides a separate
    # label text and image for each column. If it is an
    # <code>ILabelProvider</code>, then it provides only the label text and
    # image for the first column, and any remaining columns are blank.
    def get_label_provider
      return super
    end
    
    typesig { [Item] }
    # (non-Javadoc) Method declared on AbstractTreeViewer.
    def get_parent_item(item)
      return (item).get_parent_item
    end
    
    typesig { [Control] }
    # (non-Javadoc) Method declared on AbstractTreeViewer.
    def get_selection(widget)
      return (widget).get_selection
    end
    
    typesig { [] }
    # Returns this table tree viewer's table tree control.
    # 
    # @return the table tree control
    def get_table_tree
      return @table_tree
    end
    
    typesig { [Control] }
    # (non-Javadoc) Method declared on AbstractTreeViewer.
    def hook_control(control)
      super(control)
      @table_tree.get_table.add_mouse_listener(Class.new(MouseAdapter.class == Class ? MouseAdapter : Object) do
        local_class_in TableTreeViewer
        include_class_members TableTreeViewer
        include MouseAdapter if MouseAdapter.class == Module
        
        typesig { [MouseEvent] }
        define_method :mouse_down do |e|
          # If user clicked on the [+] or [-], do not activate
          # CellEditor.
          # 
          # XXX: This code should not be here. SWT should either have
          # support to see
          # if the user clicked on the [+]/[-] or manage the table editor
          # activation
          items = self.attr_table_tree.get_table.get_items
          i = 0
          while i < items.attr_length
            rect = items[i].get_image_bounds(0)
            if (rect.contains(e.attr_x, e.attr_y))
              return
            end
            i += 1
          end
          self.attr_table_editor_impl.handle_mouse_down(e)
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
    end
    
    typesig { [] }
    # Returns whether there is an active cell editor.
    # 
    # @return <code>true</code> if there is an active cell editor, and
    # <code>false</code> otherwise
    def is_cell_editor_active
      return @table_editor_impl.is_cell_editor_active
    end
    
    typesig { [Widget, ::Java::Int, ::Java::Int] }
    # (non-Javadoc) Method declared in AbstractTreeViewer.
    def new_item(parent, flags, ix)
      item = nil
      if (ix >= 0)
        if (parent.is_a?(TableTreeItem))
          item = TableTreeItem.new(parent, flags, ix)
        else
          item = TableTreeItem.new(parent, flags, ix)
        end
      else
        if (parent.is_a?(TableTreeItem))
          item = TableTreeItem.new(parent, flags)
        else
          item = TableTreeItem.new(parent, flags)
        end
      end
      return item
    end
    
    typesig { [Control] }
    # (non-Javadoc) Method declared in AbstractTreeViewer.
    def remove_all(widget)
      (widget).remove_all
    end
    
    typesig { [Array.typed(CellEditor)] }
    # Sets the cell editors of this table viewer.
    # 
    # @param editors
    # the list of cell editors
    def set_cell_editors(editors)
      @table_editor_impl.set_cell_editors(editors)
    end
    
    typesig { [ICellModifier] }
    # Sets the cell modifier of this table viewer.
    # 
    # @param modifier
    # the cell modifier
    def set_cell_modifier(modifier)
      @table_editor_impl.set_cell_modifier(modifier)
    end
    
    typesig { [Array.typed(String)] }
    # Sets the column properties of this table viewer. The properties must
    # correspond with the columns of the table control. They are used to
    # identify the column in a cell modifier.
    # 
    # @param columnProperties
    # the list of column properties
    def set_column_properties(column_properties)
      @table_editor_impl.set_column_properties(column_properties)
    end
    
    typesig { [Item, ::Java::Boolean] }
    # (non-Javadoc) Method declared in AbstractTreeViewer.
    def set_expanded(node, expand)
      (node).set_expanded(expand)
    end
    
    typesig { [JavaList] }
    # (non-Javadoc) Method declared in AbstractTreeViewer.
    def set_selection(items)
      new_items = Array.typed(TableTreeItem).new(items.size) { nil }
      items.to_array(new_items)
      get_table_tree.set_selection(new_items)
    end
    
    typesig { [Item] }
    # (non-Javadoc) Method declared in AbstractTreeViewer.
    def show_item(item)
      get_table_tree.show_item(item)
    end
    
    private
    alias_method :initialize__table_tree_viewer, :initialize
  end
  
end
