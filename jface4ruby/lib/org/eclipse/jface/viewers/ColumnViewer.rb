require "rjava"

# Copyright (c) 2006, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
# Tom Schindl <tom.schindl@bestsolution.at> - initial API and implementation; bug 153993
# fix in bug 163317, 151295, 167323, 167858, 184346, 187826, 201905
module Org::Eclipse::Jface::Viewers
  module ColumnViewerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Core::Runtime, :IStatus
      include_const ::Org::Eclipse::Core::Runtime, :Status
      include_const ::Org::Eclipse::Jface::Internal, :InternalPolicy
      include_const ::Org::Eclipse::Jface::Util, :Policy
      include_const ::Org::Eclipse::Swt::Events, :MouseAdapter
      include_const ::Org::Eclipse::Swt::Events, :MouseEvent
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Item
      include_const ::Org::Eclipse::Swt::Widgets, :Widget
    }
  end
  
  # The ColumnViewer is the abstract superclass of viewers that have columns
  # (e.g., AbstractTreeViewer and AbstractTableViewer). Concrete subclasses of
  # {@link ColumnViewer} should implement a matching concrete subclass of {@link
  # ViewerColumn}.
  # 
  # <strong> This class is not intended to be subclassed outside of the JFace
  # viewers framework.</strong>
  # 
  # @since 3.3
  class ColumnViewer < ColumnViewerImports.const_get :StructuredViewer
    include_class_members ColumnViewerImports
    
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
    
    # The cell is a cached viewer cell used for refreshing.
    attr_accessor :cell
    alias_method :attr_cell, :cell
    undef_method :cell
    alias_method :attr_cell=, :cell=
    undef_method :cell=
    
    attr_accessor :viewer_editor
    alias_method :attr_viewer_editor, :viewer_editor
    undef_method :viewer_editor
    alias_method :attr_viewer_editor=, :viewer_editor=
    undef_method :viewer_editor=
    
    attr_accessor :busy
    alias_method :attr_busy, :busy
    undef_method :busy
    alias_method :attr_busy=, :busy=
    undef_method :busy=
    
    attr_accessor :log_when_busy
    alias_method :attr_log_when_busy, :log_when_busy
    undef_method :log_when_busy
    alias_method :attr_log_when_busy=, :log_when_busy=
    undef_method :log_when_busy=
    
    typesig { [] }
    # initially true, set to false
    # after logging for the first
    # time
    # 
    # Create a new instance of the receiver.
    def initialize
      @cell_editors = nil
      @cell_modifier = nil
      @column_properties = nil
      @cell = nil
      @viewer_editor = nil
      @busy = false
      @log_when_busy = false
      super()
      @cell = ViewerCell.new(nil, 0, nil)
      @log_when_busy = true
    end
    
    typesig { [Control] }
    def hook_control(control)
      super(control)
      @viewer_editor = create_viewer_editor
      hook_editing_support(control)
    end
    
    typesig { [Control] }
    # Hook up the editing support. Subclasses may override.
    # 
    # @param control
    # the control you want to hook on
    def hook_editing_support(control)
      # Needed for backwards comp with AbstractTreeViewer and TableTreeViewer
      # who are not hooked this way others may already overwrite and provide
      # their
      # own impl
      if (!(@viewer_editor).nil?)
        control.add_mouse_listener(Class.new(MouseAdapter.class == Class ? MouseAdapter : Object) do
          extend LocalClass
          include_class_members ColumnViewer
          include MouseAdapter if MouseAdapter.class == Module
          
          typesig { [MouseEvent] }
          define_method :mouse_down do |e|
            # Workaround for bug 185817
            if (!(e.attr_count).equal?(2))
              handle_mouse_down(e)
            end
          end
          
          typesig { [MouseEvent] }
          define_method :mouse_double_click do |e|
            handle_mouse_down(e)
          end
          
          typesig { [Object] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      end
    end
    
    typesig { [] }
    # Creates the viewer editor used for editing cell contents. To be
    # implemented by subclasses.
    # 
    # @return the editor, or <code>null</code> if this viewer does not support
    # editing cell contents.
    def create_viewer_editor
      raise NotImplementedError
    end
    
    typesig { [Point] }
    # Returns the viewer cell at the given widget-relative coordinates, or
    # <code>null</code> if there is no cell at that location
    # 
    # @param point
    # the widget-relative coordinates
    # @return the cell or <code>null</code> if no cell is found at the given
    # point
    # 
    # @since 3.4
    def get_cell(point)
      row = get_viewer_row(point)
      if (!(row).nil?)
        return row.get_cell(point)
      end
      return nil
    end
    
    typesig { [Point] }
    # Returns the viewer row at the given widget-relative coordinates.
    # 
    # @param point
    # the widget-relative coordinates of the viewer row
    # @return ViewerRow the row or <code>null</code> if no row is found at the
    # given coordinates
    def get_viewer_row(point)
      item = get_item_at(point)
      if (!(item).nil?)
        return get_viewer_row_from_item(item)
      end
      return nil
    end
    
    typesig { [Widget] }
    # Returns a {@link ViewerRow} associated with the given row widget.
    # Implementations may re-use the same instance for different row widgets;
    # callers can only use the viewer row locally and until the next call to
    # this method.
    # 
    # @param item
    # the row widget
    # @return ViewerRow a viewer row object
    def get_viewer_row_from_item(item)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    # Returns the column widget at the given column index.
    # 
    # @param columnIndex
    # the column index
    # @return Widget the column widget
    def get_column_viewer_owner(column_index)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    # Returns the viewer column for the given column index.
    # 
    # @param columnIndex
    # the column index
    # @return the viewer column at the given index, or <code>null</code> if
    # there is none for the given index
    # 
    # package
    def get_viewer_column(column_index)
      viewer = nil
      column_owner = get_column_viewer_owner(column_index)
      if ((column_owner).nil? || column_owner.is_disposed)
        return nil
      end
      viewer = column_owner.get_data(ViewerColumn.attr_column_viewer_key)
      if ((viewer).nil?)
        viewer = create_viewer_column(column_owner, CellLabelProvider.create_viewer_label_provider(self, get_label_provider))
        setup_editing_support(column_index, viewer)
      end
      if ((viewer.get_editing_support).nil? && !(get_cell_modifier).nil?)
        setup_editing_support(column_index, viewer)
      end
      return viewer
    end
    
    typesig { [::Java::Int, ViewerColumn] }
    # Sets up editing support for the given column based on the "old" cell
    # editor API.
    # 
    # @param columnIndex
    # @param viewer
    def setup_editing_support(column_index, viewer)
      if (!(get_cell_modifier).nil?)
        viewer.set_editing_support(Class.new(EditingSupport.class == Class ? EditingSupport : Object) do
          extend LocalClass
          include_class_members ColumnViewer
          include EditingSupport if EditingSupport.class == Module
          
          typesig { [Object] }
          # (non-Javadoc)
          # 
          # @see
          # org.eclipse.jface.viewers.EditingSupport#canEdit(java.lang
          # .Object)
          define_method :can_edit do |element|
            properties = get_column_properties
            if (column_index < properties.attr_length)
              return get_cell_modifier.can_modify(element, get_column_properties[column_index])
            end
            return false
          end
          
          typesig { [Object] }
          # (non-Javadoc)
          # 
          # @see
          # org.eclipse.jface.viewers.EditingSupport#getCellEditor(java
          # .lang.Object)
          define_method :get_cell_editor do |element|
            editors = get_cell_editors
            if (column_index < editors.attr_length)
              return get_cell_editors[column_index]
            end
            return nil
          end
          
          typesig { [Object] }
          # (non-Javadoc)
          # 
          # @see
          # org.eclipse.jface.viewers.EditingSupport#getValue(java.lang
          # .Object)
          define_method :get_value do |element|
            properties = get_column_properties
            if (column_index < properties.attr_length)
              return get_cell_modifier.get_value(element, get_column_properties[column_index])
            end
            return nil
          end
          
          typesig { [Object, Object] }
          # (non-Javadoc)
          # 
          # @see
          # org.eclipse.jface.viewers.EditingSupport#setValue(java.lang
          # .Object, java.lang.Object)
          define_method :set_value do |element, value|
            properties = get_column_properties
            if (column_index < properties.attr_length)
              get_cell_modifier.modify(find_item(element), get_column_properties[column_index], value)
            end
          end
          
          typesig { [] }
          define_method :is_legacy_support do
            return true
          end
          
          typesig { [Object] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self, self))
      end
    end
    
    typesig { [Widget, CellLabelProvider] }
    # Creates a generic viewer column for the given column widget, based on the
    # given label provider.
    # 
    # @param columnOwner
    # the column widget
    # @param labelProvider
    # the label provider to use for the column
    # @return ViewerColumn the viewer column
    def create_viewer_column(column_owner, label_provider)
      column = Class.new(ViewerColumn.class == Class ? ViewerColumn : Object) do
        extend LocalClass
        include_class_members ColumnViewer
        include ViewerColumn if ViewerColumn.class == Module
        
        typesig { [Object] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self, self, column_owner)
      column.set_label_provider(label_provider, false)
      return column
    end
    
    typesig { [ViewerRow, ::Java::Int, Object] }
    # Update the cached cell object with the given row and column.
    # 
    # @param rowItem
    # @param column
    # @return ViewerCell
    # 
    # package
    def update_cell(row_item, column, element)
      @cell.update(row_item, column, element)
      return @cell
    end
    
    typesig { [Point] }
    # Returns the {@link Item} at the given widget-relative coordinates, or
    # <code>null</code> if there is no item at the given coordinates.
    # 
    # @param point
    # the widget-relative coordinates
    # @return the {@link Item} at the coordinates or <code>null</code> if there
    # is no item at the given coordinates
    def get_item_at(point)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.viewers.StructuredViewer#getItem(int, int)
    def get_item(x, y)
      return get_item_at(get_control.to_control(x, y))
    end
    
    typesig { [IBaseLabelProvider] }
    # The column viewer implementation of this <code>Viewer</code> framework
    # method ensures that the given label provider is an instance of
    # <code>ITableLabelProvider</code>, <code>ILabelProvider</code>, or
    # <code>CellLabelProvider</code>.
    # <p>
    # If the label provider is an {@link ITableLabelProvider} , then it
    # provides a separate label text and image for each column. Implementers of
    # <code>ITableLabelProvider</code> may also implement {@link
    # ITableColorProvider} and/or {@link ITableFontProvider} to provide colors
    # and/or fonts.
    # </p>
    # <p>
    # If the label provider is an <code>ILabelProvider</code> , then it
    # provides only the label text and image for the first column, and any
    # remaining columns are blank. Implementers of <code>ILabelProvider</code>
    # may also implement {@link IColorProvider} and/or {@link IFontProvider} to
    # provide colors and/or fonts.
    # </p>
    def set_label_provider(label_provider)
      Assert.is_true(label_provider.is_a?(ITableLabelProvider) || label_provider.is_a?(ILabelProvider) || label_provider.is_a?(CellLabelProvider))
      update_column_parts(label_provider) # Reset the label providers in the
      # columns
      super(label_provider)
      if (label_provider.is_a?(CellLabelProvider))
        (label_provider).initialize_(self, nil)
      end
    end
    
    typesig { [IBaseLabelProvider] }
    def internal_dispose_label_provider(old_provider)
      if (old_provider.is_a?(CellLabelProvider))
        (old_provider).dispose(self, nil)
      else
        super(old_provider)
      end
    end
    
    typesig { [IBaseLabelProvider] }
    # Clear the viewer parts for the columns
    def update_column_parts(label_provider)
      column = nil
      i = 0
      while (!((column = get_viewer_column(((i += 1) - 1)))).nil?)
        column.set_label_provider(CellLabelProvider.create_viewer_label_provider(self, label_provider), false)
      end
    end
    
    typesig { [] }
    # Cancels a currently active cell editor if one is active. All changes
    # already done in the cell editor are lost.
    # 
    # @since 3.1 (in subclasses, added in 3.3 to abstract class)
    def cancel_editing
      if (!(@viewer_editor).nil?)
        @viewer_editor.cancel_editing
      end
    end
    
    typesig { [] }
    # Apply the value of the active cell editor if one is active.
    # 
    # @since 3.3
    def apply_editor_value
      if (!(@viewer_editor).nil?)
        @viewer_editor.apply_editor_value
      end
    end
    
    typesig { [Object, ::Java::Int] }
    # Starts editing the given element at the given column index.
    # 
    # @param element
    # the model element
    # @param column
    # the column index
    # @since 3.1 (in subclasses, added in 3.3 to abstract class)
    def edit_element(element, column)
      if (!(@viewer_editor).nil?)
        begin
          get_control.set_redraw(false)
          # Set the selection at first because in Tree's
          # the element might not be materialized
          set_selection(StructuredSelection.new(element), true)
          item = find_item(element)
          if (!(item).nil?)
            row = get_viewer_row_from_item(item)
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
      end
    end
    
    typesig { [] }
    # Return the CellEditors for the receiver, or <code>null</code> if no cell
    # editors are set.
    # <p>
    # Since 3.3, an alternative API is available, see {@link
    # ViewerColumn#setEditingSupport(EditingSupport)} for a more flexible way
    # of editing values in a column viewer.
    # </p>
    # 
    # 
    # @return CellEditor[]
    # @since 3.1 (in subclasses, added in 3.3 to abstract class)
    # @see ViewerColumn#setEditingSupport(EditingSupport)
    # @see EditingSupport
    def get_cell_editors
      return @cell_editors
    end
    
    typesig { [] }
    # Returns the cell modifier of this viewer, or <code>null</code> if none
    # has been set.
    # 
    # <p>
    # Since 3.3, an alternative API is available, see {@link
    # ViewerColumn#setEditingSupport(EditingSupport)} for a more flexible way
    # of editing values in a column viewer.
    # </p>
    # 
    # @return the cell modifier, or <code>null</code>
    # @since 3.1 (in subclasses, added in 3.3 to abstract class)
    # @see ViewerColumn#setEditingSupport(EditingSupport)
    # @see EditingSupport
    def get_cell_modifier
      return @cell_modifier
    end
    
    typesig { [] }
    # Returns the column properties of this table viewer. The properties must
    # correspond with the columns of the table control. They are used to
    # identify the column in a cell modifier.
    # 
    # <p>
    # Since 3.3, an alternative API is available, see {@link
    # ViewerColumn#setEditingSupport(EditingSupport)} for a more flexible way
    # of editing values in a column viewer.
    # </p>
    # 
    # @return the list of column properties
    # @since 3.1 (in subclasses, added in 3.3 to abstract class)
    # @see ViewerColumn#setEditingSupport(EditingSupport)
    # @see EditingSupport
    def get_column_properties
      return @column_properties
    end
    
    typesig { [] }
    # Returns whether there is an active cell editor.
    # 
    # <p>
    # Since 3.3, an alternative API is available, see {@link
    # ViewerColumn#setEditingSupport(EditingSupport)} for a more flexible way
    # of editing values in a column viewer.
    # </p>
    # 
    # @return <code>true</code> if there is an active cell editor, and
    # <code>false</code> otherwise
    # @since 3.1 (in subclasses, added in 3.3 to abstract class)
    # @see ViewerColumn#setEditingSupport(EditingSupport)
    # @see EditingSupport
    def is_cell_editor_active
      if (!(@viewer_editor).nil?)
        return @viewer_editor.is_cell_editor_active
      end
      return false
    end
    
    typesig { [Object] }
    def refresh(element)
      if (check_busy)
        return
      end
      if (is_cell_editor_active)
        cancel_editing
      end
      super(element)
    end
    
    typesig { [Object, ::Java::Boolean] }
    def refresh(element, update_labels)
      if (check_busy)
        return
      end
      if (is_cell_editor_active)
        cancel_editing
      end
      super(element, update_labels)
    end
    
    typesig { [Object, Array.typed(String)] }
    def update(element, properties)
      if (check_busy)
        return
      end
      super(element, properties)
    end
    
    typesig { [Array.typed(CellEditor)] }
    # Sets the cell editors of this column viewer. If editing is not supported
    # by this viewer the call simply has no effect.
    # 
    # <p>
    # Since 3.3, an alternative API is available, see {@link
    # ViewerColumn#setEditingSupport(EditingSupport)} for a more flexible way
    # of editing values in a column viewer.
    # </p>
    # <p>
    # Users setting up an editable {@link TreeViewer} or {@link TableViewer} with more than 1 column <b>have</b>
    # to pass the SWT.FULL_SELECTION style bit
    # </p>
    # @param editors
    # the list of cell editors
    # @since 3.1 (in subclasses, added in 3.3 to abstract class)
    # @see ViewerColumn#setEditingSupport(EditingSupport)
    # @see EditingSupport
    def set_cell_editors(editors)
      @cell_editors = editors
    end
    
    typesig { [ICellModifier] }
    # Sets the cell modifier for this column viewer. This method does nothing
    # if editing is not supported by this viewer.
    # 
    # <p>
    # Since 3.3, an alternative API is available, see {@link
    # ViewerColumn#setEditingSupport(EditingSupport)} for a more flexible way
    # of editing values in a column viewer.
    # </p>
    # <p>
    # Users setting up an editable {@link TreeViewer} or {@link TableViewer} with more than 1 column <b>have</b>
    # to pass the SWT.FULL_SELECTION style bit
    # </p>
    # @param modifier
    # the cell modifier
    # @since 3.1 (in subclasses, added in 3.3 to abstract class)
    # @see ViewerColumn#setEditingSupport(EditingSupport)
    # @see EditingSupport
    def set_cell_modifier(modifier)
      @cell_modifier = modifier
    end
    
    typesig { [Array.typed(String)] }
    # Sets the column properties of this column viewer. The properties must
    # correspond with the columns of the control. They are used to identify the
    # column in a cell modifier. If editing is not supported by this viewer the
    # call simply has no effect.
    # 
    # <p>
    # Since 3.3, an alternative API is available, see {@link
    # ViewerColumn#setEditingSupport(EditingSupport)} for a more flexible way
    # of editing values in a column viewer.
    # </p>
    # <p>
    # Users setting up an editable {@link TreeViewer} or {@link TableViewer} with more than 1 column <b>have</b>
    # to pass the SWT.FULL_SELECTION style bit
    # </p>
    # @param columnProperties
    # the list of column properties
    # @since 3.1 (in subclasses, added in 3.3 to abstract class)
    # @see ViewerColumn#setEditingSupport(EditingSupport)
    # @see EditingSupport
    def set_column_properties(column_properties)
      @column_properties = column_properties
    end
    
    typesig { [] }
    # Returns the number of columns contained in the receiver. If no columns
    # were created by the programmer, this value is zero, despite the fact that
    # visually, one column of items may be visible. This occurs when the
    # programmer uses the column viewer like a list, adding elements but never
    # creating a column.
    # 
    # @return the number of columns
    # 
    # @since 3.3
    def do_get_column_count
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    # Returns the label provider associated with the column at the given index
    # or <code>null</code> if no column with this index is known.
    # 
    # @param columnIndex
    # the column index
    # @return the label provider associated with the column or
    # <code>null</code> if no column with this index is known
    # 
    # @since 3.3
    def get_label_provider(column_index)
      column = get_viewer_column(column_index)
      if (!(column).nil?)
        return column.get_label_provider
      end
      return nil
    end
    
    typesig { [MouseEvent] }
    def handle_mouse_down(e)
      cell = get_cell(Point.new(e.attr_x, e.attr_y))
      if (!(cell).nil?)
        trigger_editor_activation_event(ColumnViewerEditorActivationEvent.new(cell, e))
      end
    end
    
    typesig { [ColumnViewerEditorActivationEvent] }
    # Invoking this method fires an editor activation event which tries to
    # enable the editor but before this event is passed to {@link
    # ColumnViewerEditorActivationStrategy} to see if this event should really
    # trigger editor activation
    # 
    # @param event
    # the activation event
    def trigger_editor_activation_event(event)
      @viewer_editor.handle_editor_activation_event(event)
    end
    
    typesig { [ColumnViewerEditor] }
    # @param columnViewerEditor
    # the new column viewer editor
    def set_column_viewer_editor(column_viewer_editor)
      Assert.is_not_null(column_viewer_editor)
      @viewer_editor = column_viewer_editor
    end
    
    typesig { [] }
    # @return the currently attached viewer editor
    def get_column_viewer_editor
      return @viewer_editor
    end
    
    typesig { [Object] }
    def get_raw_children(parent)
      old_busy = is_busy
      set_busy(true)
      begin
        return super(parent)
      ensure
        set_busy(old_busy)
      end
    end
    
    typesig { [] }
    def clear_legacy_editing_setup
      if (!get_control.is_disposed && !(get_cell_editors).nil?)
        count = do_get_column_count
        i = 0
        while i < count || (i).equal?(0)
          owner = get_column_viewer_owner(i)
          if (!(owner).nil? && !owner.is_disposed)
            column = owner.get_data(ViewerColumn.attr_column_viewer_key)
            if (!(column).nil?)
              e = column.get_editing_support
              # Ensure that only EditingSupports are wiped that are
              # setup
              # for Legacy reasons
              if (!(e).nil? && e.is_legacy_support)
                column.set_editing_support(nil)
              end
            end
          end
          i += 1
        end
      end
    end
    
    typesig { [] }
    # Checks if this viewer is currently busy, logging a warning and returning
    # <code>true</code> if it is busy. A column viewer is busy when it is
    # processing a refresh, add, remove, insert, replace, setItemCount,
    # expandToLevel, update, setExpandedElements, or similar method that may
    # make calls to client code. Column viewers are not designed to handle
    # reentrant calls while they are busy. The method returns <code>true</code>
    # if the viewer is busy. It is recommended that this method be used by
    # subclasses to determine whether the viewer is busy to return early from
    # state-changing methods.
    # 
    # <p>
    # This method is not intended to be overridden by subclasses.
    # </p>
    # 
    # @return <code>true</code> if the viewer is busy.
    # 
    # @since 3.4
    def check_busy
      if (is_busy)
        if (@log_when_busy)
          message = "Ignored reentrant call while viewer is busy." # $NON-NLS-1$
          if (!InternalPolicy::DEBUG_LOG_REENTRANT_VIEWER_CALLS)
            # stop logging after the first
            @log_when_busy = false
            # $NON-NLS-1$
            message += " This is only logged once per viewer instance," + " but similar calls will still be ignored." # $NON-NLS-1$
          end
          Policy.get_log.log(Status.new(IStatus::WARNING, Policy::JFACE, message, RuntimeException.new))
        end
        return true
      end
      return false
    end
    
    typesig { [::Java::Boolean] }
    # Sets the busy state of this viewer. Subclasses MUST use <code>try</code>
    # ...<code>finally</code> as follows to ensure that the busy flag is reset
    # to its original value:
    # 
    # <pre>
    # boolean oldBusy = isBusy();
    # setBusy(true);
    # try {
    # // do work
    # } finally {
    # setBusy(oldBusy);
    # }
    # </pre>
    # 
    # <p>
    # This method is not intended to be overridden by subclasses.
    # </p>
    # 
    # @param busy
    # the new value of the busy flag
    # 
    # @since 3.4
    def set_busy(busy)
      @busy = busy
    end
    
    typesig { [] }
    # Returns <code>true</code> if this viewer is currently busy processing a
    # refresh, add, remove, insert, replace, setItemCount, expandToLevel,
    # update, setExpandedElements, or similar method that may make calls to
    # client code. Column viewers are not designed to handle reentrant calls
    # while they are busy. It is recommended that clients avoid using this
    # method if they can ensure by other means that they will not make
    # reentrant calls to methods like the ones listed above. See bug 184991 for
    # background discussion.
    # 
    # <p>
    # This method is not intended to be overridden by subclasses.
    # </p>
    # 
    # @return Returns whether this viewer is busy.
    # 
    # @since 3.4
    def is_busy
      return @busy
    end
    
    private
    alias_method :initialize__column_viewer, :initialize
  end
  
end
