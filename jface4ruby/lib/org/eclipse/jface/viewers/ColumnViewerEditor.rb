require "rjava"

# Copyright (c) 2006, 2009 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
# Tom Schindl <tom.schindl@bestsolution.at> - refactoring (bug 153993)
# fix in bug: 151295,178946,166500,195908,201906,207676,180504,216706,218336
module Org::Eclipse::Jface::Viewers
  module ColumnViewerEditorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
      include_const ::Org::Eclipse::Core::Runtime, :ListenerList
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Events, :DisposeEvent
      include_const ::Org::Eclipse::Swt::Events, :DisposeListener
      include_const ::Org::Eclipse::Swt::Events, :FocusAdapter
      include_const ::Org::Eclipse::Swt::Events, :FocusEvent
      include_const ::Org::Eclipse::Swt::Events, :FocusListener
      include_const ::Org::Eclipse::Swt::Events, :MouseAdapter
      include_const ::Org::Eclipse::Swt::Events, :MouseEvent
      include_const ::Org::Eclipse::Swt::Events, :MouseListener
      include_const ::Org::Eclipse::Swt::Events, :TraverseEvent
      include_const ::Org::Eclipse::Swt::Events, :TraverseListener
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Item
    }
  end
  
  # This is the base for all editor implementations of Viewers. ColumnViewer
  # implementors have to subclass this class and implement the missing methods
  # 
  # @since 3.3
  # @see TableViewerEditor
  # @see TreeViewerEditor
  class ColumnViewerEditor 
    include_class_members ColumnViewerEditorImports
    
    attr_accessor :cell_editor
    alias_method :attr_cell_editor, :cell_editor
    undef_method :cell_editor
    alias_method :attr_cell_editor=, :cell_editor=
    undef_method :cell_editor=
    
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
    
    attr_accessor :viewer
    alias_method :attr_viewer, :viewer
    undef_method :viewer
    alias_method :attr_viewer=, :viewer=
    undef_method :viewer=
    
    attr_accessor :tabediting_listener
    alias_method :attr_tabediting_listener, :tabediting_listener
    undef_method :tabediting_listener
    alias_method :attr_tabediting_listener=, :tabediting_listener=
    undef_method :tabediting_listener=
    
    attr_accessor :cell
    alias_method :attr_cell, :cell
    undef_method :cell
    alias_method :attr_cell=, :cell=
    undef_method :cell=
    
    attr_accessor :editor_activation_listener
    alias_method :attr_editor_activation_listener, :editor_activation_listener
    undef_method :editor_activation_listener
    alias_method :attr_editor_activation_listener=, :editor_activation_listener=
    undef_method :editor_activation_listener=
    
    attr_accessor :editor_activation_strategy
    alias_method :attr_editor_activation_strategy, :editor_activation_strategy
    undef_method :editor_activation_strategy
    alias_method :attr_editor_activation_strategy=, :editor_activation_strategy=
    undef_method :editor_activation_strategy=
    
    attr_accessor :in_editor_deactivation
    alias_method :attr_in_editor_deactivation, :in_editor_deactivation
    undef_method :in_editor_deactivation
    alias_method :attr_in_editor_deactivation=, :in_editor_deactivation=
    undef_method :in_editor_deactivation=
    
    attr_accessor :dispose_listener
    alias_method :attr_dispose_listener, :dispose_listener
    undef_method :dispose_listener
    alias_method :attr_dispose_listener=, :dispose_listener=
    undef_method :dispose_listener=
    
    class_module.module_eval {
      # Tabbing from cell to cell is turned off
      const_set_lazy(:DEFAULT) { 1 }
      const_attr_reader  :DEFAULT
      
      # Should if the end of the row is reach started from the start/end of the
      # row below/above
      const_set_lazy(:TABBING_MOVE_TO_ROW_NEIGHBOR) { 1 << 1 }
      const_attr_reader  :TABBING_MOVE_TO_ROW_NEIGHBOR
      
      # Should if the end of the row is reach started from the beginning in the
      # same row
      const_set_lazy(:TABBING_CYCLE_IN_ROW) { 1 << 2 }
      const_attr_reader  :TABBING_CYCLE_IN_ROW
      
      # Support tabbing to Cell above/below the current cell
      const_set_lazy(:TABBING_VERTICAL) { 1 << 3 }
      const_attr_reader  :TABBING_VERTICAL
      
      # Should tabbing from column to column with in one row be supported
      const_set_lazy(:TABBING_HORIZONTAL) { 1 << 4 }
      const_attr_reader  :TABBING_HORIZONTAL
      
      # Style mask used to enable keyboard activation
      const_set_lazy(:KEYBOARD_ACTIVATION) { 1 << 5 }
      const_attr_reader  :KEYBOARD_ACTIVATION
      
      # Style mask used to turn <b>off</b> the feature that an editor activation
      # is canceled on double click. It is also possible to turn off this feature
      # per cell-editor using {@link CellEditor#getDoubleClickTimeout()}
      # @since 3.4
      const_set_lazy(:KEEP_EDITOR_ON_DOUBLE_CLICK) { 1 << 6 }
      const_attr_reader  :KEEP_EDITOR_ON_DOUBLE_CLICK
    }
    
    attr_accessor :feature
    alias_method :attr_feature, :feature
    undef_method :feature
    alias_method :attr_feature=, :feature=
    undef_method :feature=
    
    typesig { [ColumnViewer, ColumnViewerEditorActivationStrategy, ::Java::Int] }
    # @param viewer
    # the viewer this editor is attached to
    # @param editorActivationStrategy
    # the strategy used to decide about editor activation
    # @param feature
    # bit mask controlling the editor
    # <ul>
    # <li>{@link ColumnViewerEditor#DEFAULT}</li>
    # <li>{@link ColumnViewerEditor#TABBING_CYCLE_IN_ROW}</li>
    # <li>{@link ColumnViewerEditor#TABBING_HORIZONTAL}</li>
    # <li>{@link ColumnViewerEditor#TABBING_MOVE_TO_ROW_NEIGHBOR}</li>
    # <li>{@link ColumnViewerEditor#TABBING_VERTICAL}</li>
    # </ul>
    def initialize(viewer, editor_activation_strategy, feature)
      @cell_editor = nil
      @cell_editor_listener = nil
      @focus_listener = nil
      @mouse_listener = nil
      @viewer = nil
      @tabediting_listener = nil
      @cell = nil
      @editor_activation_listener = nil
      @editor_activation_strategy = nil
      @in_editor_deactivation = false
      @dispose_listener = nil
      @feature = 0
      @viewer = viewer
      @editor_activation_strategy = editor_activation_strategy
      if (((feature & KEYBOARD_ACTIVATION)).equal?(KEYBOARD_ACTIVATION))
        @editor_activation_strategy.set_enable_editor_activation_with_keyboard(true)
      end
      @feature = feature
      @dispose_listener = Class.new(DisposeListener.class == Class ? DisposeListener : Object) do
        local_class_in ColumnViewerEditor
        include_class_members ColumnViewerEditor
        include DisposeListener if DisposeListener.class == Module
        
        typesig { [DisposeEvent] }
        define_method :widget_disposed do |e|
          if (viewer.is_cell_editor_active)
            cancel_editing
          end
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
      init_cell_editor_listener
    end
    
    typesig { [] }
    def init_cell_editor_listener
      @cell_editor_listener = Class.new(ICellEditorListener.class == Class ? ICellEditorListener : Object) do
        local_class_in ColumnViewerEditor
        include_class_members ColumnViewerEditor
        include ICellEditorListener if ICellEditorListener.class == Module
        
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
    
    typesig { [ColumnViewerEditorActivationEvent] }
    def activate_cell_editor(activation_event)
      part = @viewer.get_viewer_column(@cell.get_column_index)
      element = @cell.get_element
      if (!(part).nil? && !(part.get_editing_support).nil? && part.get_editing_support.can_edit(element))
        @cell_editor = part.get_editing_support.get_cell_editor(element)
        if (!(@cell_editor).nil?)
          timeout = @cell_editor.get_double_click_timeout
          activation_time = 0
          if (!(timeout).equal?(0))
            activation_time = activation_event.attr_time + timeout
          else
            activation_time = 0
          end
          if (!(@editor_activation_listener).nil? && !@editor_activation_listener.is_empty)
            ls = @editor_activation_listener.get_listeners
            i = 0
            while i < ls.attr_length
              (ls[i]).before_editor_activated(activation_event)
              # Was the activation canceled ?
              if (activation_event.attr_cancel)
                return false
              end
              i += 1
            end
          end
          update_focus_cell(@cell, activation_event)
          @cell_editor.add_listener(@cell_editor_listener)
          part.get_editing_support.initialize_cell_editor_value(@cell_editor, @cell)
          # Tricky flow of control here:
          # activate() can trigger callback to cellEditorListener which
          # will clear cellEditor
          # so must get control first, but must still call activate()
          # even if there is no control.
          control = @cell_editor.get_control
          @cell_editor.activate(activation_event)
          if ((control).nil?)
            return false
          end
          set_layout_data(@cell_editor.get_layout_data)
          set_editor(control, @cell.get_item, @cell.get_column_index)
          @cell_editor.set_focus
          if (@cell_editor.depends_on_external_focus_listener)
            if ((@focus_listener).nil?)
              @focus_listener = Class.new(FocusAdapter.class == Class ? FocusAdapter : Object) do
                local_class_in ColumnViewerEditor
                include_class_members ColumnViewerEditor
                include FocusAdapter if FocusAdapter.class == Module
                
                typesig { [FocusEvent] }
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
          end
          @mouse_listener = Class.new(MouseAdapter.class == Class ? MouseAdapter : Object) do
            local_class_in ColumnViewerEditor
            include_class_members ColumnViewerEditor
            include MouseAdapter if MouseAdapter.class == Module
            
            typesig { [MouseEvent] }
            define_method :mouse_down do |e|
              # time wrap?
              # check for expiration of doubleClickTime
              if (should_fire_double_click(activation_time, e.attr_time, activation_event) && (e.attr_button).equal?(1))
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
          if (!(activation_time).equal?(0) && ((@feature & KEEP_EDITOR_ON_DOUBLE_CLICK)).equal?(0))
            control.add_mouse_listener(@mouse_listener)
          end
          if ((@tabediting_listener).nil?)
            @tabediting_listener = Class.new(TraverseListener.class == Class ? TraverseListener : Object) do
              local_class_in ColumnViewerEditor
              include_class_members ColumnViewerEditor
              include TraverseListener if TraverseListener.class == Module
              
              typesig { [TraverseEvent] }
              define_method :key_traversed do |e|
                if (!((self.attr_feature & DEFAULT)).equal?(DEFAULT))
                  process_traverse_event(self.attr_cell.get_column_index, self.attr_viewer.get_viewer_row_from_item(self.attr_cell.get_item), e)
                end
              end
              
              typesig { [Vararg.new(Object)] }
              define_method :initialize do |*args|
                super(*args)
              end
              
              private
              alias_method :initialize_anonymous, :initialize
            end.new_local(self)
          end
          control.add_traverse_listener(@tabediting_listener)
          if (!(@editor_activation_listener).nil? && !@editor_activation_listener.is_empty)
            ls = @editor_activation_listener.get_listeners
            i = 0
            while i < ls.attr_length
              (ls[i]).after_editor_activated(activation_event)
              i += 1
            end
          end
          @cell.get_item.add_dispose_listener(@dispose_listener)
          return true
        end
      end
      return false
    end
    
    typesig { [::Java::Int, ::Java::Int, ColumnViewerEditorActivationEvent] }
    def should_fire_double_click(activation_time, mouse_time, activation_event)
      return mouse_time <= activation_time && !(activation_event.attr_event_type).equal?(ColumnViewerEditorActivationEvent::KEY_PRESSED) && !(activation_event.attr_event_type).equal?(ColumnViewerEditorActivationEvent::PROGRAMMATIC) && !(activation_event.attr_event_type).equal?(ColumnViewerEditorActivationEvent::TRAVERSAL)
    end
    
    typesig { [] }
    # Applies the current value and deactivates the currently active cell
    # editor.
    def apply_editor_value
      # avoid re-entering
      if (!@in_editor_deactivation)
        begin
          @in_editor_deactivation = true
          c = @cell_editor
          if (!(c).nil? && !(@cell).nil?)
            tmp = ColumnViewerEditorDeactivationEvent.new(@cell)
            tmp.attr_event_type = ColumnViewerEditorDeactivationEvent::EDITOR_SAVED
            if (!(@editor_activation_listener).nil? && !@editor_activation_listener.is_empty)
              ls = @editor_activation_listener.get_listeners
              i = 0
              while i < ls.attr_length
                (ls[i]).before_editor_deactivated(tmp)
                i += 1
              end
            end
            t = @cell.get_item
            # don't null out table item -- same item is still selected
            if (!(t).nil? && !t.is_disposed)
              save_editor_value(c)
            end
            if (!@viewer.get_control.is_disposed)
              set_editor(nil, nil, 0)
            end
            c.remove_listener(@cell_editor_listener)
            control = c.get_control
            if (!(control).nil? && !control.is_disposed)
              if (!(@mouse_listener).nil?)
                control.remove_mouse_listener(@mouse_listener)
                # Clear the instance not needed any more
                @mouse_listener = nil
              end
              if (!(@focus_listener).nil?)
                control.remove_focus_listener(@focus_listener)
              end
              if (!(@tabediting_listener).nil?)
                control.remove_traverse_listener(@tabediting_listener)
              end
            end
            c.deactivate(tmp)
            if (!(@editor_activation_listener).nil? && !@editor_activation_listener.is_empty)
              ls = @editor_activation_listener.get_listeners
              i = 0
              while i < ls.attr_length
                (ls[i]).after_editor_deactivated(tmp)
                i += 1
              end
            end
            if (!@cell.get_item.is_disposed)
              @cell.get_item.remove_dispose_listener(@dispose_listener)
            end
          end
          @cell_editor = nil
          @cell = nil
        ensure
          @in_editor_deactivation = false
        end
      end
    end
    
    typesig { [] }
    # Cancel editing
    def cancel_editing
      # avoid re-entering
      if (!@in_editor_deactivation)
        begin
          @in_editor_deactivation = true
          if (!(@cell_editor).nil?)
            tmp = ColumnViewerEditorDeactivationEvent.new(@cell)
            tmp.attr_event_type = ColumnViewerEditorDeactivationEvent::EDITOR_CANCELED
            if (!(@editor_activation_listener).nil? && !@editor_activation_listener.is_empty)
              ls = @editor_activation_listener.get_listeners
              i = 0
              while i < ls.attr_length
                (ls[i]).before_editor_deactivated(tmp)
                i += 1
              end
            end
            if (!@viewer.get_control.is_disposed)
              set_editor(nil, nil, 0)
            end
            @cell_editor.remove_listener(@cell_editor_listener)
            control = @cell_editor.get_control
            if (!(control).nil? && !@viewer.get_control.is_disposed)
              if (!(@mouse_listener).nil?)
                control.remove_mouse_listener(@mouse_listener)
                # Clear the instance not needed any more
                @mouse_listener = nil
              end
              if (!(@focus_listener).nil?)
                control.remove_focus_listener(@focus_listener)
              end
              if (!(@tabediting_listener).nil?)
                control.remove_traverse_listener(@tabediting_listener)
              end
            end
            old_editor = @cell_editor
            old_editor.deactivate(tmp)
            if (!(@editor_activation_listener).nil? && !@editor_activation_listener.is_empty)
              ls = @editor_activation_listener.get_listeners
              i = 0
              while i < ls.attr_length
                (ls[i]).after_editor_deactivated(tmp)
                i += 1
              end
            end
            if (!@cell.get_item.is_disposed)
              @cell.get_item.add_dispose_listener(@dispose_listener)
            end
            @cell_editor = nil
            @cell = nil
          end
        ensure
          @in_editor_deactivation = false
        end
      end
    end
    
    typesig { [ColumnViewerEditorActivationEvent] }
    # Enable the editor by mouse down
    # 
    # @param event
    def handle_editor_activation_event(event)
      # Only activate if the event isn't tagged as canceled
      if (!event.attr_cancel && @editor_activation_strategy.is_editor_activation_event(event))
        if (!(@cell_editor).nil?)
          apply_editor_value
        end
        @cell = event.get_source
        # Only null if we are not in a deactivation process see bug 260892
        if (!activate_cell_editor(event) && !@in_editor_deactivation)
          @cell = nil
          @cell_editor = nil
        end
      end
    end
    
    typesig { [CellEditor] }
    def save_editor_value(cell_editor)
      part = @viewer.get_viewer_column(@cell.get_column_index)
      if (!(part).nil? && !(part.get_editing_support).nil?)
        part.get_editing_support.save_cell_editor_value(cell_editor, @cell)
      end
    end
    
    typesig { [] }
    # Return whether there is an active cell editor.
    # 
    # @return <code>true</code> if there is an active cell editor; otherwise
    # <code>false</code> is returned.
    def is_cell_editor_active
      return !(@cell_editor).nil?
    end
    
    typesig { [] }
    def handle_double_click_event
      @viewer.fire_double_click(DoubleClickEvent.new(@viewer, @viewer.get_selection))
      @viewer.fire_open(OpenEvent.new(@viewer, @viewer.get_selection))
    end
    
    typesig { [ColumnViewerEditorActivationListener] }
    # Adds the given listener, it is to be notified when the cell editor is
    # activated or deactivated.
    # 
    # @param listener
    # the listener to add
    def add_editor_activation_listener(listener)
      if ((@editor_activation_listener).nil?)
        @editor_activation_listener = ListenerList.new
      end
      @editor_activation_listener.add(listener)
    end
    
    typesig { [ColumnViewerEditorActivationListener] }
    # Removes the given listener.
    # 
    # @param listener
    # the listener to remove
    def remove_editor_activation_listener(listener)
      if (!(@editor_activation_listener).nil?)
        @editor_activation_listener.remove(listener)
      end
    end
    
    typesig { [::Java::Int, ViewerRow, TraverseEvent] }
    # Process the traverse event and opens the next available editor depending
    # of the implemented strategy. The default implementation uses the style
    # constants
    # <ul>
    # <li>{@link ColumnViewerEditor#TABBING_MOVE_TO_ROW_NEIGHBOR}</li>
    # <li>{@link ColumnViewerEditor#TABBING_CYCLE_IN_ROW}</li>
    # <li>{@link ColumnViewerEditor#TABBING_VERTICAL}</li>
    # <li>{@link ColumnViewerEditor#TABBING_HORIZONTAL}</li>
    # </ul>
    # 
    # <p>
    # Subclasses may overwrite to implement their custom logic to edit the next
    # cell
    # </p>
    # 
    # @param columnIndex
    # the index of the current column
    # @param row
    # the current row - may only be used for the duration of this
    # method call
    # @param event
    # the traverse event
    def process_traverse_event(column_index, row, event)
      cell2edit = nil
      if ((event.attr_detail).equal?(SWT::TRAVERSE_TAB_PREVIOUS))
        event.attr_doit = false
        if (((event.attr_state_mask & SWT::CTRL)).equal?(SWT::CTRL) && ((@feature & TABBING_VERTICAL)).equal?(TABBING_VERTICAL))
          cell2edit = search_cell_above_below(row, @viewer, column_index, true)
        else
          if (((@feature & TABBING_HORIZONTAL)).equal?(TABBING_HORIZONTAL))
            cell2edit = search_previous_cell(row, row.get_cell(column_index), row.get_cell(column_index), @viewer)
          end
        end
      else
        if ((event.attr_detail).equal?(SWT::TRAVERSE_TAB_NEXT))
          event.attr_doit = false
          if (((event.attr_state_mask & SWT::CTRL)).equal?(SWT::CTRL) && ((@feature & TABBING_VERTICAL)).equal?(TABBING_VERTICAL))
            cell2edit = search_cell_above_below(row, @viewer, column_index, false)
          else
            if (((@feature & TABBING_HORIZONTAL)).equal?(TABBING_HORIZONTAL))
              cell2edit = search_next_cell(row, row.get_cell(column_index), row.get_cell(column_index), @viewer)
            end
          end
        end
      end
      if (!(cell2edit).nil?)
        @viewer.get_control.set_redraw(false)
        ac_event = ColumnViewerEditorActivationEvent.new(cell2edit, event)
        @viewer.trigger_editor_activation_event(ac_event)
        @viewer.get_control.set_redraw(true)
      end
    end
    
    typesig { [ViewerRow, ColumnViewer, ::Java::Int, ::Java::Boolean] }
    def search_cell_above_below(row, viewer, column_index, above)
      rv = nil
      new_row = nil
      if (above)
        new_row = row.get_neighbor(ViewerRow::ABOVE, false)
      else
        new_row = row.get_neighbor(ViewerRow::BELOW, false)
      end
      if (!(new_row).nil?)
        column = viewer.get_viewer_column(column_index)
        if (!(column).nil? && !(column.get_editing_support).nil? && column.get_editing_support.can_edit(new_row.get_item.get_data))
          rv = new_row.get_cell(column_index)
        else
          rv = search_cell_above_below(new_row, viewer, column_index, above)
        end
      end
      return rv
    end
    
    typesig { [ColumnViewer, ViewerCell] }
    def is_cell_editable(viewer, cell)
      column = viewer.get_viewer_column(cell.get_column_index)
      return !(column).nil? && !(column.get_editing_support).nil? && column.get_editing_support.can_edit(cell.get_element)
    end
    
    typesig { [ViewerRow, ViewerCell, ViewerCell, ColumnViewer] }
    def search_previous_cell(row, current_cell, original_cell, viewer)
      rv = nil
      previous_cell = nil
      if (!(current_cell).nil?)
        previous_cell = current_cell.get_neighbor(ViewerCell::LEFT, true)
      else
        if (!(row.get_column_count).equal?(0))
          previous_cell = row.get_cell(row.get_creation_index(row.get_column_count - 1))
        else
          previous_cell = row.get_cell(0)
        end
      end
      # No endless loop
      if ((original_cell == previous_cell))
        return nil
      end
      if (!(previous_cell).nil?)
        if (is_cell_editable(viewer, previous_cell))
          rv = previous_cell
        else
          rv = search_previous_cell(row, previous_cell, original_cell, viewer)
        end
      else
        if (((@feature & TABBING_CYCLE_IN_ROW)).equal?(TABBING_CYCLE_IN_ROW))
          rv = search_previous_cell(row, nil, original_cell, viewer)
        else
          if (((@feature & TABBING_MOVE_TO_ROW_NEIGHBOR)).equal?(TABBING_MOVE_TO_ROW_NEIGHBOR))
            row_above = row.get_neighbor(ViewerRow::ABOVE, false)
            if (!(row_above).nil?)
              rv = search_previous_cell(row_above, nil, original_cell, viewer)
            end
          end
        end
      end
      return rv
    end
    
    typesig { [ViewerRow, ViewerCell, ViewerCell, ColumnViewer] }
    def search_next_cell(row, current_cell, original_cell, viewer)
      rv = nil
      next_cell = nil
      if (!(current_cell).nil?)
        next_cell = current_cell.get_neighbor(ViewerCell::RIGHT, true)
      else
        next_cell = row.get_cell(row.get_creation_index(0))
      end
      # No endless loop
      if ((original_cell == next_cell))
        return nil
      end
      if (!(next_cell).nil?)
        if (is_cell_editable(viewer, next_cell))
          rv = next_cell
        else
          rv = search_next_cell(row, next_cell, original_cell, viewer)
        end
      else
        if (((@feature & TABBING_CYCLE_IN_ROW)).equal?(TABBING_CYCLE_IN_ROW))
          rv = search_next_cell(row, nil, original_cell, viewer)
        else
          if (((@feature & TABBING_MOVE_TO_ROW_NEIGHBOR)).equal?(TABBING_MOVE_TO_ROW_NEIGHBOR))
            row_below = row.get_neighbor(ViewerRow::BELOW, false)
            if (!(row_below).nil?)
              rv = search_next_cell(row_below, nil, original_cell, viewer)
            end
          end
        end
      end
      return rv
    end
    
    typesig { [Control, Item, ::Java::Int] }
    # Position the editor inside the control
    # 
    # @param w
    # the editor control
    # @param item
    # the item (row) in which the editor is drawn in
    # @param fColumnNumber
    # the column number in which the editor is shown
    def set_editor(w, item, f_column_number)
      raise NotImplementedError
    end
    
    typesig { [CellEditor::LayoutData] }
    # set the layout data for the editor
    # 
    # @param layoutData
    # the layout data used when editor is displayed
    def set_layout_data(layout_data)
      raise NotImplementedError
    end
    
    typesig { [ViewerCell, ColumnViewerEditorActivationEvent] }
    # @param focusCell
    # updates the cell with the current input focus
    # @param event
    # the event requesting to update the focusCell
    def update_focus_cell(focus_cell, event)
      raise NotImplementedError
    end
    
    typesig { [] }
    # @return the cell currently holding the focus if no cell has the focus or
    # the viewer implementation doesn't support <code>null</code> is
    # returned
    def get_focus_cell
      return nil
    end
    
    typesig { [] }
    # @return the viewer working for
    def get_viewer
      return @viewer
    end
    
    private
    alias_method :initialize__column_viewer_editor, :initialize
  end
  
end
