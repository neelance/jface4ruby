require "rjava"

# Copyright (c) 2007, 2009 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
# Tom Schindl <tom.schindl@bestsolution.at> - initial API and implementation
# fixes in bug 198665, 200731
module Org::Eclipse::Jface::Viewers
  module TableViewerEditorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
      include_const ::Java::Util, :JavaList
      include_const ::Org::Eclipse::Jface::Viewers::CellEditor, :LayoutData
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Custom, :TableEditor
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Item
      include_const ::Org::Eclipse::Swt::Widgets, :Table
      include_const ::Org::Eclipse::Swt::Widgets, :TableItem
    }
  end
  
  # This is an editor-implementation for {@link Table}
  # 
  # @since 3.3
  class TableViewerEditor < TableViewerEditorImports.const_get :ColumnViewerEditor
    include_class_members TableViewerEditorImports
    
    # This viewer's table editor.
    attr_accessor :table_editor
    alias_method :attr_table_editor, :table_editor
    undef_method :table_editor
    alias_method :attr_table_editor=, :table_editor=
    undef_method :table_editor=
    
    attr_accessor :focus_cell_manager
    alias_method :attr_focus_cell_manager, :focus_cell_manager
    undef_method :focus_cell_manager
    alias_method :attr_focus_cell_manager=, :focus_cell_manager=
    undef_method :focus_cell_manager=
    
    typesig { [TableViewer, SWTFocusCellManager, ColumnViewerEditorActivationStrategy, ::Java::Int] }
    # @param viewer
    # the viewer the editor is attached to
    # @param focusCellManager
    # the cell focus manager if one used or <code>null</code>
    # @param editorActivationStrategy
    # the strategy used to decide about the editor activation
    # @param feature
    # the feature mask
    def initialize(viewer, focus_cell_manager, editor_activation_strategy, feature)
      @table_editor = nil
      @focus_cell_manager = nil
      super(viewer, editor_activation_strategy, feature)
      @table_editor = TableEditor.new(viewer.get_table)
      @focus_cell_manager = focus_cell_manager
    end
    
    class_module.module_eval {
      typesig { [TableViewer, SWTFocusCellManager, ColumnViewerEditorActivationStrategy, ::Java::Int] }
      # Create a customized editor with focusable cells
      # 
      # @param viewer
      # the viewer the editor is created for
      # @param focusCellManager
      # the cell focus manager if one needed else <code>null</code>
      # @param editorActivationStrategy
      # activation strategy to control if an editor activated
      # @param feature
      # bit mask controlling the editor
      # <ul>
      # <li>{@link ColumnViewerEditor#DEFAULT}</li>
      # <li>{@link ColumnViewerEditor#TABBING_CYCLE_IN_ROW}</li>
      # <li>{@link ColumnViewerEditor#TABBING_HORIZONTAL}</li>
      # <li>{@link ColumnViewerEditor#TABBING_MOVE_TO_ROW_NEIGHBOR}</li>
      # <li>{@link ColumnViewerEditor#TABBING_VERTICAL}</li>
      # </ul>
      # @see #create(TableViewer, ColumnViewerEditorActivationStrategy, int)
      def create(viewer, focus_cell_manager, editor_activation_strategy, feature)
        editor = TableViewerEditor.new(viewer, focus_cell_manager, editor_activation_strategy, feature)
        viewer.set_column_viewer_editor(editor)
        if (!(focus_cell_manager).nil?)
          focus_cell_manager.init
        end
      end
      
      typesig { [TableViewer, ColumnViewerEditorActivationStrategy, ::Java::Int] }
      # Create a customized editor whose activation process is customized
      # 
      # @param viewer
      # the viewer the editor is created for
      # @param editorActivationStrategy
      # activation strategy to control if an editor activated
      # @param feature
      # bit mask controlling the editor
      # <ul>
      # <li>{@link ColumnViewerEditor#DEFAULT}</li>
      # <li>{@link ColumnViewerEditor#TABBING_CYCLE_IN_ROW}</li>
      # <li>{@link ColumnViewerEditor#TABBING_HORIZONTAL}</li>
      # <li>{@link ColumnViewerEditor#TABBING_MOVE_TO_ROW_NEIGHBOR}</li>
      # <li>{@link ColumnViewerEditor#TABBING_VERTICAL}</li>
      # </ul>
      def create(viewer, editor_activation_strategy, feature)
        create(viewer, nil, editor_activation_strategy, feature)
      end
    }
    
    typesig { [Control, Item, ::Java::Int] }
    def set_editor(w, item, column_number)
      @table_editor.set_editor(w, item, column_number)
    end
    
    typesig { [LayoutData] }
    def set_layout_data(layout_data)
      @table_editor.attr_grab_horizontal = layout_data.attr_grab_horizontal
      @table_editor.attr_horizontal_alignment = layout_data.attr_horizontal_alignment
      @table_editor.attr_minimum_width = layout_data.attr_minimum_width
      @table_editor.attr_vertical_alignment = layout_data.attr_vertical_alignment
      if (!(layout_data.attr_minimum_height).equal?(SWT::DEFAULT))
        @table_editor.attr_minimum_height = layout_data.attr_minimum_height
      end
    end
    
    typesig { [] }
    def get_focus_cell
      if (!(@focus_cell_manager).nil?)
        return @focus_cell_manager.get_focus_cell
      end
      return super
    end
    
    typesig { [ViewerCell, ColumnViewerEditorActivationEvent] }
    def update_focus_cell(focus_cell, event)
      # Update the focus cell when we activated the editor with these 2
      # events
      if ((event.attr_event_type).equal?(ColumnViewerEditorActivationEvent::PROGRAMMATIC) || (event.attr_event_type).equal?(ColumnViewerEditorActivationEvent::TRAVERSAL))
        l = get_viewer.get_selection_from_widget
        if (!l.contains(focus_cell.get_element))
          get_viewer.set_selection(StructuredSelection.new(focus_cell.get_element), true)
        end
        # Set the focus cell after the selection is updated because else
        # the cell is not scrolled into view
        if (!(@focus_cell_manager).nil?)
          @focus_cell_manager.set_focus_cell(focus_cell)
        end
      end
    end
    
    private
    alias_method :initialize__table_viewer_editor, :initialize
  end
  
end
