require "rjava"

# Copyright (c) 2007 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Viewers
  module CellNavigationStrategyImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Widgets, :Event
    }
  end
  
  # This class implementation the strategy how the table is navigated using the
  # keyboard.
  # 
  # <p>
  # <b>Subclasses can implement their custom navigation algorithms</b>
  # </p>
  # 
  # @since 3.3
  class CellNavigationStrategy 
    include_class_members CellNavigationStrategyImports
    
    typesig { [ColumnViewer, Event] }
    # is the given event an event which moves the selection to another cell
    # 
    # @param viewer
    # the viewer we are working for
    # @param event
    # the key event
    # @return <code>true</code> if a new cell is searched
    def is_navigation_event(viewer, event)
      case (event.attr_key_code)
      when SWT::ARROW_UP, SWT::ARROW_DOWN, SWT::ARROW_LEFT, SWT::ARROW_RIGHT, SWT::HOME, SWT::PAGE_DOWN, SWT::PAGE_UP, SWT::END_
        return true
      else
        return false
      end
    end
    
    typesig { [ColumnViewer, ViewerCell, Event] }
    # @param viewer
    # the viewer we are working for
    # @param cellToCollapse
    # the cell to collapse
    # @param event
    # the key event
    # @return <code>true</code> if this event triggers collapsing of a node
    def is_collapse_event(viewer, cell_to_collapse, event)
      return false
    end
    
    typesig { [ColumnViewer, ViewerCell, Event] }
    # @param viewer
    # the viewer we are working for
    # @param cellToExpand
    # the cell to expand
    # @param event
    # the key event
    # @return <code>true</code> if this event triggers expanding of a node
    def is_expand_event(viewer, cell_to_expand, event)
      return false
    end
    
    typesig { [ColumnViewer, ViewerCell, Event] }
    # @param viewer
    # the viewer working for
    # @param cellToExpand
    # the cell the user wants to expand
    # @param event
    # the event triggering the expansion
    def expand(viewer, cell_to_expand, event)
    end
    
    typesig { [ColumnViewer, ViewerCell, Event] }
    # @param viewer
    # the viewer working for
    # @param cellToCollapse
    # the cell the user wants to collapse
    # @param event
    # the event triggering the expansion
    def collapse(viewer, cell_to_collapse, event)
    end
    
    typesig { [ColumnViewer, ViewerCell, Event] }
    # @param viewer
    # the viewer we are working for
    # @param currentSelectedCell
    # the cell currently selected
    # @param event
    # the key event
    # @return the cell which is highlighted next or <code>null</code> if the
    # default implementation is taken. E.g. it's fairly impossible to
    # react on PAGE_DOWN requests
    def find_selected_cell(viewer, current_selected_cell, event)
      case (event.attr_key_code)
      when SWT::ARROW_UP
        if (!(current_selected_cell).nil?)
          return current_selected_cell.get_neighbor(ViewerCell::ABOVE, false)
        end
      when SWT::ARROW_DOWN
        if (!(current_selected_cell).nil?)
          return current_selected_cell.get_neighbor(ViewerCell::BELOW, false)
        end
      when SWT::ARROW_LEFT
        if (!(current_selected_cell).nil?)
          return current_selected_cell.get_neighbor(ViewerCell::LEFT, true)
        end
      when SWT::ARROW_RIGHT
        if (!(current_selected_cell).nil?)
          return current_selected_cell.get_neighbor(ViewerCell::RIGHT, true)
        end
      end
      return nil
    end
    
    typesig { [ColumnViewer, Event] }
    # This method is consulted to decide whether an event has to be canceled or
    # not. By default events who collapse/expand tree-nodes are canceled
    # 
    # @param viewer
    # the viewer working for
    # @param event
    # the event
    # @return <code>true</code> if the event has to be canceled
    def should_cancel_event(viewer, event)
      return (event.attr_key_code).equal?(SWT::ARROW_LEFT) || (event.attr_key_code).equal?(SWT::ARROW_RIGHT)
    end
    
    typesig { [] }
    # This method is called by the framework to initialize this navigation
    # strategy object. Subclasses may extend.
    def init
    end
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__cell_navigation_strategy, :initialize
  end
  
end
