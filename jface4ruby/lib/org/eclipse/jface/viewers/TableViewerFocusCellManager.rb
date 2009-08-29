require "rjava"

# Copyright (c) 2007, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
# Tom Schindl <tom.schindl@bestsolution.at> - initial API and implementation
# fix in bug: 210752
module Org::Eclipse::Jface::Viewers
  module TableViewerFocusCellManagerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
      include_const ::Org::Eclipse::Swt::Widgets, :Table
    }
  end
  
  # This class is responsible to provide the concept of cells for {@link Table}.
  # This concept is needed to provide features like editor activation with the
  # keyboard
  # 
  # @since 3.3
  class TableViewerFocusCellManager < TableViewerFocusCellManagerImports.const_get :SWTFocusCellManager
    include_class_members TableViewerFocusCellManagerImports
    
    class_module.module_eval {
      const_set_lazy(:TABLE_NAVIGATE) { CellNavigationStrategy.new }
      const_attr_reader  :TABLE_NAVIGATE
    }
    
    typesig { [TableViewer, FocusCellHighlighter] }
    # Create a new manager with a default navigation strategy:
    # <ul>
    # <li><code>SWT.ARROW_UP</code>: navigate to cell above</li>
    # <li><code>SWT.ARROW_DOWN</code>: navigate to cell below</li>
    # <li><code>SWT.ARROW_RIGHT</code>: navigate to next visible cell on
    # the right</li>
    # <li><code>SWT.ARROW_LEFT</code>: navigate to next visible cell on the
    # left</li>
    # </ul>
    # 
    # @param viewer
    # the viewer the manager is bound to
    # @param focusDrawingDelegate
    # the delegate responsible to highlight selected cell
    def initialize(viewer, focus_drawing_delegate)
      initialize__table_viewer_focus_cell_manager(viewer, focus_drawing_delegate, TABLE_NAVIGATE)
    end
    
    typesig { [TableViewer, FocusCellHighlighter, CellNavigationStrategy] }
    # Create a new manager
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
      table = get_viewer.get_control
      if (!table.is_disposed && table.get_item_count > 0 && !table.get_item(0).is_disposed)
        a_viewer_row = get_viewer.get_viewer_row_from_item(table.get_item(0))
        i = 0
        while i < table.get_column_count
          if (a_viewer_row.get_width(i) > 0)
            return a_viewer_row.get_cell(i)
          end
          i += 1
        end
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
    alias_method :initialize__table_viewer_focus_cell_manager, :initialize
  end
  
end
