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
# - bug fix for bug 187189, 182800, 215069
module Org::Eclipse::Jface::Viewers
  module SWTFocusCellManagerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Accessibility, :ACC
      include_const ::Org::Eclipse::Swt::Accessibility, :AccessibleAdapter
      include_const ::Org::Eclipse::Swt::Accessibility, :AccessibleEvent
      include_const ::Org::Eclipse::Swt::Events, :DisposeEvent
      include_const ::Org::Eclipse::Swt::Events, :DisposeListener
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Widgets, :Event
      include_const ::Org::Eclipse::Swt::Widgets, :Listener
    }
  end
  
  # This class is responsible to provide cell management base features for the
  # SWT-Controls {@link org.eclipse.swt.widgets.Table} and
  # {@link org.eclipse.swt.widgets.Tree}.
  # 
  # @since 3.3
  class SWTFocusCellManager 
    include_class_members SWTFocusCellManagerImports
    
    attr_accessor :navigation_strategy
    alias_method :attr_navigation_strategy, :navigation_strategy
    undef_method :navigation_strategy
    alias_method :attr_navigation_strategy=, :navigation_strategy=
    undef_method :navigation_strategy=
    
    attr_accessor :viewer
    alias_method :attr_viewer, :viewer
    undef_method :viewer
    alias_method :attr_viewer=, :viewer=
    undef_method :viewer=
    
    attr_accessor :focus_cell
    alias_method :attr_focus_cell, :focus_cell
    undef_method :focus_cell
    alias_method :attr_focus_cell=, :focus_cell=
    undef_method :focus_cell=
    
    attr_accessor :cell_highlighter
    alias_method :attr_cell_highlighter, :cell_highlighter
    undef_method :cell_highlighter
    alias_method :attr_cell_highlighter=, :cell_highlighter=
    undef_method :cell_highlighter=
    
    attr_accessor :item_deletion_listener
    alias_method :attr_item_deletion_listener, :item_deletion_listener
    undef_method :item_deletion_listener
    alias_method :attr_item_deletion_listener=, :item_deletion_listener=
    undef_method :item_deletion_listener=
    
    typesig { [ColumnViewer, FocusCellHighlighter, CellNavigationStrategy] }
    # @param viewer
    # @param focusDrawingDelegate
    # @param navigationDelegate
    def initialize(viewer, focus_drawing_delegate, navigation_delegate)
      @navigation_strategy = nil
      @viewer = nil
      @focus_cell = nil
      @cell_highlighter = nil
      @item_deletion_listener = Class.new(DisposeListener.class == Class ? DisposeListener : Object) do
        extend LocalClass
        include_class_members SWTFocusCellManager
        include DisposeListener if DisposeListener.class == Module
        
        typesig { [DisposeEvent] }
        define_method :widget_disposed do |e|
          set_focus_cell(nil)
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
      @viewer = viewer
      @cell_highlighter = focus_drawing_delegate
      if (!(@cell_highlighter).nil?)
        @cell_highlighter.set_mgr(self)
      end
      @navigation_strategy = navigation_delegate
      hook_listener(viewer)
    end
    
    typesig { [] }
    # This method is called by the framework to initialize this cell manager.
    def init
      @cell_highlighter.init
      @navigation_strategy.init
    end
    
    typesig { [Event] }
    def handle_mouse_down(event)
      cell = @viewer.get_cell(Point.new(event.attr_x, event.attr_y))
      if (!(cell).nil?)
        if (!(cell == @focus_cell))
          set_focus_cell(cell)
        end
      end
    end
    
    typesig { [Event] }
    def handle_key_down(event)
      tmp = nil
      if (@navigation_strategy.is_collapse_event(@viewer, @focus_cell, event))
        @navigation_strategy.collapse(@viewer, @focus_cell, event)
      else
        if (@navigation_strategy.is_expand_event(@viewer, @focus_cell, event))
          @navigation_strategy.expand(@viewer, @focus_cell, event)
        else
          if (@navigation_strategy.is_navigation_event(@viewer, event))
            tmp = @navigation_strategy.find_selected_cell(@viewer, @focus_cell, event)
            if (!(tmp).nil?)
              if (!(tmp == @focus_cell))
                set_focus_cell(tmp)
              end
            end
          end
        end
      end
      if (@navigation_strategy.should_cancel_event(@viewer, event))
        event.attr_doit = false
      end
    end
    
    typesig { [Event] }
    def handle_selection(event)
      if (((event.attr_detail & SWT::CHECK)).equal?(0) && !(@focus_cell).nil? && !(@focus_cell.get_item).equal?(event.attr_item) && !(event.attr_item).nil? && !event.attr_item.is_disposed)
        row = @viewer.get_viewer_row_from_item(event.attr_item)
        Assert.is_not_null(row, "Internal Structure invalid. Row item has no row ViewerRow assigned") # $NON-NLS-1$
        tmp = row.get_cell(@focus_cell.get_column_index)
        if (!(@focus_cell == tmp))
          set_focus_cell(tmp)
        end
      end
    end
    
    typesig { [Event] }
    # Handles the {@link SWT#FocusIn} event.
    # 
    # @param event the event
    def handle_focus_in(event)
      if ((@focus_cell).nil?)
        set_focus_cell(get_initial_focus_cell)
      end
    end
    
    typesig { [] }
    def get_initial_focus_cell
      raise NotImplementedError
    end
    
    typesig { [ColumnViewer] }
    def hook_listener(viewer)
      listener = Class.new(Listener.class == Class ? Listener : Object) do
        extend LocalClass
        include_class_members SWTFocusCellManager
        include Listener if Listener.class == Module
        
        typesig { [Event] }
        define_method :handle_event do |event|
          case (event.attr_type)
          when SWT::MouseDown
            handle_mouse_down(event)
          when SWT::KeyDown
            handle_key_down(event)
          when SWT::Selection
            handle_selection(event)
          when SWT::FocusIn
            handle_focus_in(event)
          end
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
      viewer.get_control.add_listener(SWT::MouseDown, listener)
      viewer.get_control.add_listener(SWT::KeyDown, listener)
      viewer.get_control.add_listener(SWT::Selection, listener)
      viewer.add_selection_changed_listener(Class.new(ISelectionChangedListener.class == Class ? ISelectionChangedListener : Object) do
        extend LocalClass
        include_class_members SWTFocusCellManager
        include ISelectionChangedListener if ISelectionChangedListener.class == Module
        
        typesig { [SelectionChangedEvent] }
        define_method :selection_changed do |event|
          if (event.attr_selection.is_empty)
            set_focus_cell(nil)
          end
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      viewer.get_control.add_listener(SWT::FocusIn, listener)
      viewer.get_control.get_accessible.add_accessible_listener(Class.new(AccessibleAdapter.class == Class ? AccessibleAdapter : Object) do
        extend LocalClass
        include_class_members SWTFocusCellManager
        include AccessibleAdapter if AccessibleAdapter.class == Module
        
        typesig { [AccessibleEvent] }
        define_method :get_name do |event|
          cell = get_focus_cell
          if ((cell).nil?)
            return
          end
          row = cell.get_viewer_row
          if ((row).nil?)
            return
          end
          element = row.get_item.get_data
          view_part = viewer.get_viewer_column(cell.get_column_index)
          if ((view_part).nil?)
            return
          end
          label_provider = view_part.get_label_provider
          if ((label_provider).nil?)
            return
          end
          event.attr_result = label_provider.get_text(element)
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
    # @return the cell with the focus
    def get_focus_cell
      return @focus_cell
    end
    
    typesig { [] }
    def __get_focus_cell
      return @focus_cell
    end
    
    typesig { [ViewerCell] }
    def set_focus_cell(focus_cell)
      old_cell = @focus_cell
      if (!(@focus_cell).nil? && !@focus_cell.get_item.is_disposed)
        @focus_cell.get_item.remove_dispose_listener(@item_deletion_listener)
      end
      @focus_cell = focus_cell
      if (!(@focus_cell).nil? && !@focus_cell.get_item.is_disposed)
        @focus_cell.get_item.add_dispose_listener(@item_deletion_listener)
      end
      if (!(focus_cell).nil?)
        focus_cell.scroll_into_view
      end
      @cell_highlighter.focus_cell_changed(focus_cell, old_cell)
      get_viewer.get_control.get_accessible.set_focus(ACC::CHILDID_SELF)
    end
    
    typesig { [] }
    def get_viewer
      return @viewer
    end
    
    private
    alias_method :initialize__swtfocus_cell_manager, :initialize
  end
  
end
