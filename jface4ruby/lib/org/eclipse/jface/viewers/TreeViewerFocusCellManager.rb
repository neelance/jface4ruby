require "rjava"

# Copyright (c) 2007, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
# Tom Schindl<tom.schindl@bestsolution.at> - initial API and implementation
# - fix in bug: 195908, 210752
module Org::Eclipse::Jface::Viewers
  module TreeViewerFocusCellManagerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Widgets, :Event
      include_const ::Org::Eclipse::Swt::Widgets, :Item
      include_const ::Org::Eclipse::Swt::Widgets, :Tree
      include_const ::Org::Eclipse::Swt::Widgets, :TreeItem
    }
  end
  
  # This class is responsible to provide the concept of cells for {@link Tree}.
  # This concept is needed to provide features like editor activation with the
  # keyboard
  # 
  # @since 3.3
  class TreeViewerFocusCellManager < TreeViewerFocusCellManagerImports.const_get :SWTFocusCellManager
    include_class_members TreeViewerFocusCellManagerImports
    
    class_module.module_eval {
      const_set_lazy(:TREE_NAVIGATE) { Class.new(CellNavigationStrategy.class == Class ? CellNavigationStrategy : Object) do
        extend LocalClass
        include_class_members TreeViewerFocusCellManager
        include CellNavigationStrategy if CellNavigationStrategy.class == Module
        
        typesig { [ColumnViewer, ViewerCell, Event] }
        define_method :collapse do |viewer, cell_to_collapse, event|
          if (!(cell_to_collapse).nil?)
            (cell_to_collapse.get_item).set_expanded(false)
          end
        end
        
        typesig { [ColumnViewer, ViewerCell, Event] }
        define_method :expand do |viewer, cell_to_expand, event|
          if (!(cell_to_expand).nil?)
            v = viewer
            v.set_expanded_state(v.get_tree_path_from_item(cell_to_expand.get_item), true)
          end
        end
        
        typesig { [ColumnViewer, ViewerCell, Event] }
        define_method :is_collapse_event do |viewer, cell_to_collapse, event|
          if ((cell_to_collapse).nil?)
            return false
          end
          return !(cell_to_collapse).nil? && (cell_to_collapse.get_item).get_expanded && (event.attr_key_code).equal?(SWT::ARROW_LEFT) && is_first_column_cell(cell_to_collapse)
        end
        
        typesig { [ColumnViewer, ViewerCell, Event] }
        define_method :is_expand_event do |viewer, cell_to_expand, event|
          if ((cell_to_expand).nil?)
            return false
          end
          return !(cell_to_expand).nil? && (cell_to_expand.get_item).get_item_count > 0 && !(cell_to_expand.get_item).get_expanded && (event.attr_key_code).equal?(SWT::ARROW_RIGHT) && is_first_column_cell(cell_to_expand)
        end
        
        typesig { [ViewerCell] }
        define_method :is_first_column_cell do |cell|
          return (cell.get_viewer_row.get_visual_index(cell.get_column_index)).equal?(0)
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self) }
      const_attr_reader  :TREE_NAVIGATE
    }
    
    typesig { [TreeViewer, FocusCellHighlighter] }
    # Create a new manager using a default navigation strategy:
    # <ul>
    # <li><code>SWT.ARROW_UP</code>: navigate to cell above</li>
    # <li><code>SWT.ARROW_DOWN</code>: navigate to cell below</li>
    # <li><code>SWT.ARROW_RIGHT</code>: on first column (collapses if item
    # is expanded) else navigate to next visible cell on the right</li>
    # <li><code>SWT.ARROW_LEFT</code>: on first column (expands if item is
    # collapsed) else navigate to next visible cell on the left</li>
    # </ul>
    # 
    # @param viewer
    # the viewer the manager is bound to
    # @param focusDrawingDelegate
    # the delegate responsible to highlight selected cell
    def initialize(viewer, focus_drawing_delegate)
      initialize__tree_viewer_focus_cell_manager(viewer, focus_drawing_delegate, TREE_NAVIGATE)
    end
    
    typesig { [TreeViewer, FocusCellHighlighter, CellNavigationStrategy] }
    # Create a new manager with a custom navigation strategy
    # 
    # @param viewer
    # the viewer the manager is bound to
    # @param focusDrawingDelegate
    # the delegate responsible to highlight selected cell
    # @param navigationStrategy
    # the strategy used to navigate the cells
    # @since 3.4
    def initialize(viewer, focus_drawing_delegate, navigation_strategy)
      super(viewer, focus_drawing_delegate, navigation_strategy)
    end
    
    typesig { [] }
    def get_initial_focus_cell
      tree = get_viewer.get_control
      if (!tree.is_disposed && tree.get_item_count > 0 && !tree.get_item(0).is_disposed)
        return get_viewer.get_viewer_row_from_item(tree.get_item(0)).get_cell(0)
      end
      return nil
    end
    
    typesig { [] }
    def get_focus_cell
      cell = super
      t = get_viewer.get_control
      # It is possible that the selection has changed under the hood
      if (!(cell).nil?)
        if ((t.get_selection.attr_length).equal?(1) && !(t.get_selection[0]).equal?(cell.get_item))
          set_focus_cell(get_viewer.get_viewer_row_from_item(t.get_selection[0]).get_cell(cell.get_column_index))
        end
      end
      return super
    end
    
    private
    alias_method :initialize__tree_viewer_focus_cell_manager, :initialize
  end
  
end
