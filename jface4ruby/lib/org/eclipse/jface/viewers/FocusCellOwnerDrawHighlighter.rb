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
# - fix for bug 183850, 182652, 182800, 215069
module Org::Eclipse::Jface::Viewers
  module FocusCellOwnerDrawHighlighterImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Graphics, :Color
      include_const ::Org::Eclipse::Swt::Graphics, :SwtGC
      include_const ::Org::Eclipse::Swt::Graphics, :Rectangle
      include_const ::Org::Eclipse::Swt::Widgets, :Event
      include_const ::Org::Eclipse::Swt::Widgets, :Listener
    }
  end
  
  # A concrete implementation of {@link FocusCellHighlighter} using by setting
  # the control into owner draw mode and highlighting the currently selected
  # cell. To make the use this class you should create the control with the
  # {@link SWT#FULL_SELECTION} bit set
  # 
  # This class can be subclassed to configure how the coloring of the selected
  # cell.
  # 
  # @since 3.3
  class FocusCellOwnerDrawHighlighter < FocusCellOwnerDrawHighlighterImports.const_get :FocusCellHighlighter
    include_class_members FocusCellOwnerDrawHighlighterImports
    
    typesig { [ColumnViewer] }
    # Create a new instance which can be passed to a
    # {@link TreeViewerFocusCellManager}
    # 
    # @param viewer
    # the viewer
    def initialize(viewer)
      super(viewer)
      hook_listener(viewer)
    end
    
    typesig { [Event, ViewerCell] }
    def mark_focused_cell(event, cell)
      background = (cell.get_control.is_focus_control) ? get_selected_cell_background_color(cell) : get_selected_cell_background_color_no_focus(cell)
      foreground = (cell.get_control.is_focus_control) ? get_selected_cell_foreground_color(cell) : get_selected_cell_foreground_color_no_focus(cell)
      if (!(foreground).nil? || !(background).nil? || only_text_highlighting(cell))
        gc = event.attr_gc
        if ((background).nil?)
          background = cell.get_item.get_display.get_system_color(SWT::COLOR_LIST_SELECTION)
        end
        if ((foreground).nil?)
          foreground = cell.get_item.get_display.get_system_color(SWT::COLOR_LIST_SELECTION_TEXT)
        end
        gc.set_background(background)
        gc.set_foreground(foreground)
        if (only_text_highlighting(cell))
          area = event.get_bounds
          rect = cell.get_text_bounds
          if (!(rect).nil?)
            area.attr_x = rect.attr_x
          end
          gc.fill_rectangle(area)
        else
          gc.fill_rectangle(event.get_bounds)
        end
        event.attr_detail &= ~SWT::SELECTED
      end
    end
    
    typesig { [Event, ViewerCell] }
    def remove_selection_information(event, cell)
      gc = event.attr_gc
      gc.set_background(cell.get_viewer_row.get_background(cell.get_column_index))
      gc.set_foreground(cell.get_viewer_row.get_foreground(cell.get_column_index))
      gc.fill_rectangle(cell.get_bounds)
      event.attr_detail &= ~SWT::SELECTED
    end
    
    typesig { [ColumnViewer] }
    def hook_listener(viewer)
      listener = Class.new(Listener.class == Class ? Listener : Object) do
        local_class_in FocusCellOwnerDrawHighlighter
        include_class_members FocusCellOwnerDrawHighlighter
        include Listener if Listener.class == Module
        
        typesig { [Event] }
        define_method :handle_event do |event|
          if ((event.attr_detail & SWT::SELECTED) > 0)
            focus_cell = get_focus_cell
            row = viewer.get_viewer_row_from_item(event.attr_item)
            Assert.is_not_null(row, "Internal structure invalid. Item without associated row is not possible.") # $NON-NLS-1$
            cell = row.get_cell(event.attr_index)
            if ((focus_cell).nil? || !(cell == focus_cell))
              remove_selection_information(event, cell)
            else
              mark_focused_cell(event, cell)
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
      viewer.get_control.add_listener(SWT::EraseItem, listener)
    end
    
    typesig { [ViewerCell] }
    # The color to use when rendering the background of the selected cell when
    # the control has the input focus
    # 
    # @param cell
    # the cell which is colored
    # @return the color or <code>null</code> to use the default
    def get_selected_cell_background_color(cell)
      return nil
    end
    
    typesig { [ViewerCell] }
    # The color to use when rendering the foreground (=text) of the selected
    # cell when the control has the input focus
    # 
    # @param cell
    # the cell which is colored
    # @return the color or <code>null</code> to use the default
    def get_selected_cell_foreground_color(cell)
      return nil
    end
    
    typesig { [ViewerCell] }
    # The color to use when rendering the foreground (=text) of the selected
    # cell when the control has <b>no</b> input focus
    # 
    # @param cell
    # the cell which is colored
    # @return the color or <code>null</code> to use the same used when
    # control has focus
    # @since 3.4
    def get_selected_cell_foreground_color_no_focus(cell)
      return nil
    end
    
    typesig { [ViewerCell] }
    # The color to use when rendering the background of the selected cell when
    # the control has <b>no</b> input focus
    # 
    # @param cell
    # the cell which is colored
    # @return the color or <code>null</code> to use the same used when
    # control has focus
    # @since 3.4
    def get_selected_cell_background_color_no_focus(cell)
      return nil
    end
    
    typesig { [ViewerCell] }
    # Controls whether the whole cell or only the text-area is highlighted
    # 
    # @param cell
    # the cell which is highlighted
    # @return <code>true</code> if only the text area should be highlighted
    # @since 3.4
    def only_text_highlighting(cell)
      return false
    end
    
    typesig { [ViewerCell, ViewerCell] }
    def focus_cell_changed(new_cell, old_cell)
      super(new_cell, old_cell)
      # Redraw new area
      if (!(new_cell).nil?)
        rect = new_cell.get_bounds
        x = (new_cell.get_column_index).equal?(0) ? 0 : rect.attr_x
        width = (new_cell.get_column_index).equal?(0) ? rect.attr_x + rect.attr_width : rect.attr_width
        # 1 is a fix for Linux-GTK
        new_cell.get_control.redraw(x, rect.attr_y - 1, width, rect.attr_height + 1, true)
      end
      if (!(old_cell).nil?)
        rect = old_cell.get_bounds
        x = (old_cell.get_column_index).equal?(0) ? 0 : rect.attr_x
        width = (old_cell.get_column_index).equal?(0) ? rect.attr_x + rect.attr_width : rect.attr_width
        # 1 is a fix for Linux-GTK
        old_cell.get_control.redraw(x, rect.attr_y - 1, width, rect.attr_height + 1, true)
      end
    end
    
    private
    alias_method :initialize__focus_cell_owner_draw_highlighter, :initialize
  end
  
end
