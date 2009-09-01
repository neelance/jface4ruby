require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
# Tom Schindl <tom.schindl@bestsolution.at> - bugfix in: 187963, 218336
module Org::Eclipse::Jface::Viewers
  module CellEditorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
      include_const ::Org::Eclipse::Core::Runtime, :ListenerList
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Jface::Util, :IPropertyChangeListener
      include_const ::Org::Eclipse::Jface::Util, :PropertyChangeEvent
      include_const ::Org::Eclipse::Jface::Util, :SafeRunnable
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Events, :KeyEvent
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Display
    }
  end
  
  # Abstract base class for cell editors. Implements property change listener
  # handling, and SWT window management.
  # <p>
  # Subclasses implement particular kinds of cell editors. This package contains
  # various specialized cell editors:
  # <ul>
  # <li><code>TextCellEditor</code> - for simple text strings</li>
  # <li><code>ColorCellEditor</code> - for colors</li>
  # <li><code>ComboBoxCellEditor</code> - value selected from drop-down combo
  # box</li>
  # <li><code>CheckboxCellEditor</code> - boolean valued checkbox</li>
  # <li><code>DialogCellEditor</code> - value from arbitrary dialog</li>
  # </ul>
  # </p>
  class CellEditor 
    include_class_members CellEditorImports
    
    # List of cell editor listeners (element type:
    # <code>ICellEditorListener</code>).
    attr_accessor :listeners
    alias_method :attr_listeners, :listeners
    undef_method :listeners
    alias_method :attr_listeners=, :listeners=
    undef_method :listeners=
    
    # List of cell editor property change listeners (element type:
    # <code>IPropertyChangeListener</code>).
    attr_accessor :property_change_listeners
    alias_method :attr_property_change_listeners, :property_change_listeners
    undef_method :property_change_listeners
    alias_method :attr_property_change_listeners=, :property_change_listeners=
    undef_method :property_change_listeners=
    
    # Indicates whether this cell editor's current value is valid.
    attr_accessor :valid
    alias_method :attr_valid, :valid
    undef_method :valid
    alias_method :attr_valid=, :valid=
    undef_method :valid=
    
    # Optional cell editor validator; <code>null</code> if none.
    attr_accessor :validator
    alias_method :attr_validator, :validator
    undef_method :validator
    alias_method :attr_validator=, :validator=
    undef_method :validator=
    
    # The error message string to display for invalid values; <code>null</code>
    # if none (that is, the value is valid).
    attr_accessor :error_message
    alias_method :attr_error_message, :error_message
    undef_method :error_message
    alias_method :attr_error_message=, :error_message=
    undef_method :error_message=
    
    # Indicates whether this cell editor has been changed recently.
    attr_accessor :dirty
    alias_method :attr_dirty, :dirty
    undef_method :dirty
    alias_method :attr_dirty=, :dirty=
    undef_method :dirty=
    
    # This cell editor's control, or <code>null</code> if not created yet.
    attr_accessor :control
    alias_method :attr_control, :control
    undef_method :control
    alias_method :attr_control=, :control=
    undef_method :control=
    
    class_module.module_eval {
      # Default cell editor style
      const_set_lazy(:DefaultStyle) { SWT::NONE }
      const_attr_reader  :DefaultStyle
    }
    
    # This cell editor's style
    attr_accessor :style
    alias_method :attr_style, :style
    undef_method :style
    alias_method :attr_style=, :style=
    undef_method :style=
    
    class_module.module_eval {
      # Struct-like layout data for cell editors, with reasonable defaults for
      # all fields.
      # 
      # @noextend This class is not intended to be subclassed by clients.
      const_set_lazy(:LayoutData) { Class.new do
        include_class_members CellEditor
        
        # Horizontal alignment; <code>SWT.LEFT</code> by default.
        attr_accessor :horizontal_alignment
        alias_method :attr_horizontal_alignment, :horizontal_alignment
        undef_method :horizontal_alignment
        alias_method :attr_horizontal_alignment=, :horizontal_alignment=
        undef_method :horizontal_alignment=
        
        # Indicates control grabs additional space; <code>true</code> by
        # default.
        attr_accessor :grab_horizontal
        alias_method :attr_grab_horizontal, :grab_horizontal
        undef_method :grab_horizontal
        alias_method :attr_grab_horizontal=, :grab_horizontal=
        undef_method :grab_horizontal=
        
        # Minimum width in pixels; <code>50</code> pixels by default.
        attr_accessor :minimum_width
        alias_method :attr_minimum_width, :minimum_width
        undef_method :minimum_width
        alias_method :attr_minimum_width=, :minimum_width=
        undef_method :minimum_width=
        
        # Minimum height in pixels; by default the height is aligned to the
        # row-height
        # @since 3.4
        attr_accessor :minimum_height
        alias_method :attr_minimum_height, :minimum_height
        undef_method :minimum_height
        alias_method :attr_minimum_height=, :minimum_height=
        undef_method :minimum_height=
        
        # The vertical alignment; <code>SWT.CENTER</code> by default.
        # @since 3.4
        attr_accessor :vertical_alignment
        alias_method :attr_vertical_alignment, :vertical_alignment
        undef_method :vertical_alignment
        alias_method :attr_vertical_alignment=, :vertical_alignment=
        undef_method :vertical_alignment=
        
        typesig { [] }
        def initialize
          @horizontal_alignment = SWT::LEFT
          @grab_horizontal = true
          @minimum_width = 50
          @minimum_height = SWT::DEFAULT
          @vertical_alignment = SWT::CENTER
        end
        
        private
        alias_method :initialize__layout_data, :initialize
      end }
      
      # Property name for the copy action
      const_set_lazy(:COPY) { "copy" }
      const_attr_reader  :COPY
      
      # $NON-NLS-1$
      # 
      # Property name for the cut action
      const_set_lazy(:CUT) { "cut" }
      const_attr_reader  :CUT
      
      # $NON-NLS-1$
      # 
      # Property name for the delete action
      const_set_lazy(:DELETE) { "delete" }
      const_attr_reader  :DELETE
      
      # $NON-NLS-1$
      # 
      # Property name for the find action
      const_set_lazy(:FIND) { "find" }
      const_attr_reader  :FIND
      
      # $NON-NLS-1$
      # 
      # Property name for the paste action
      const_set_lazy(:PASTE) { "paste" }
      const_attr_reader  :PASTE
      
      # $NON-NLS-1$
      # 
      # Property name for the redo action
      const_set_lazy(:REDO) { "redo" }
      const_attr_reader  :REDO
      
      # $NON-NLS-1$
      # 
      # Property name for the select all action
      const_set_lazy(:SELECT_ALL) { "selectall" }
      const_attr_reader  :SELECT_ALL
      
      # $NON-NLS-1$
      # 
      # Property name for the undo action
      const_set_lazy(:UNDO) { "undo" }
      const_attr_reader  :UNDO
    }
    
    typesig { [] }
    # $NON-NLS-1$
    # 
    # Creates a new cell editor with no control The cell editor has no cell
    # validator.
    # 
    # @since 2.1
    def initialize
      @listeners = ListenerList.new
      @property_change_listeners = ListenerList.new
      @valid = false
      @validator = nil
      @error_message = nil
      @dirty = false
      @control = nil
      @style = DefaultStyle
    end
    
    typesig { [Composite] }
    # Creates a new cell editor under the given parent control. The cell editor
    # has no cell validator.
    # 
    # @param parent
    # the parent control
    def initialize(parent)
      initialize__cell_editor(parent, DefaultStyle)
    end
    
    typesig { [Composite, ::Java::Int] }
    # Creates a new cell editor under the given parent control. The cell editor
    # has no cell validator.
    # 
    # @param parent
    # the parent control
    # @param style
    # the style bits
    # @since 2.1
    def initialize(parent, style)
      @listeners = ListenerList.new
      @property_change_listeners = ListenerList.new
      @valid = false
      @validator = nil
      @error_message = nil
      @dirty = false
      @control = nil
      @style = DefaultStyle
      @style = style
      create(parent)
    end
    
    typesig { [] }
    # Activates this cell editor.
    # <p>
    # The default implementation of this framework method does nothing.
    # Subclasses may reimplement.
    # </p>
    def activate
    end
    
    typesig { [ICellEditorListener] }
    # Adds a listener to this cell editor. Has no effect if an identical
    # listener is already registered.
    # 
    # @param listener
    # a cell editor listener
    def add_listener(listener)
      @listeners.add(listener)
    end
    
    typesig { [IPropertyChangeListener] }
    # Adds a property change listener to this cell editor. Has no effect if an
    # identical property change listener is already registered.
    # 
    # @param listener
    # a property change listener
    def add_property_change_listener(listener)
      @property_change_listeners.add(listener)
    end
    
    typesig { [Composite] }
    # Creates the control for this cell editor under the given parent control.
    # <p>
    # This framework method must be implemented by concrete subclasses.
    # </p>
    # 
    # @param parent
    # the parent control
    # @return the new control, or <code>null</code> if this cell editor has
    # no control
    def create_control(parent)
      raise NotImplementedError
    end
    
    typesig { [Composite] }
    # Creates the control for this cell editor under the given parent control.
    # 
    # @param parent
    # the parent control
    # @since 2.1
    def create(parent)
      Assert.is_true((@control).nil?)
      @control = create_control(parent)
      # See 1GD5CA6: ITPUI:ALL - TaskView.setSelection does not work
      # Control is created with getVisible()==true by default.
      # This causes composite.setFocus() to work incorrectly.
      # The cell editor's control grabs focus instead, even if it is not
      # active.
      # Make the control invisible here by default.
      deactivate
    end
    
    typesig { [] }
    # Hides this cell editor's control. Does nothing if this cell editor is not
    # visible.
    def deactivate
      if (!(@control).nil? && !@control.is_disposed)
        @control.set_visible(false)
      end
    end
    
    typesig { [] }
    # Disposes of this cell editor and frees any associated SWT resources.
    def dispose
      if (!(@control).nil? && !@control.is_disposed)
        @control.dispose
      end
      @control = nil
    end
    
    typesig { [] }
    # Returns this cell editor's value.
    # <p>
    # This framework method must be implemented by concrete subclasses.
    # </p>
    # 
    # @return the value of this cell editor
    # @see #getValue
    def do_get_value
      raise NotImplementedError
    end
    
    typesig { [] }
    # Sets the focus to the cell editor's control.
    # <p>
    # This framework method must be implemented by concrete subclasses.
    # </p>
    # 
    # @see #setFocus
    def do_set_focus
      raise NotImplementedError
    end
    
    typesig { [Object] }
    # Sets this cell editor's value.
    # <p>
    # This framework method must be implemented by concrete subclasses.
    # </p>
    # 
    # @param value
    # the value of this cell editor
    # @see #setValue
    def do_set_value(value)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Notifies all registered cell editor listeners of an apply event. Only
    # listeners registered at the time this method is called are notified.
    # 
    # @see ICellEditorListener#applyEditorValue
    def fire_apply_editor_value
      array = @listeners.get_listeners
      i = 0
      while i < array.attr_length
        l = array[i]
        SafeRunnable.run(Class.new(SafeRunnable.class == Class ? SafeRunnable : Object) do
          extend LocalClass
          include_class_members CellEditor
          include SafeRunnable if SafeRunnable.class == Module
          
          typesig { [] }
          define_method :run do
            l.apply_editor_value
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
        i += 1
      end
    end
    
    typesig { [] }
    # Notifies all registered cell editor listeners that editing has been
    # canceled.
    # 
    # @see ICellEditorListener#cancelEditor
    def fire_cancel_editor
      array = @listeners.get_listeners
      i = 0
      while i < array.attr_length
        l = array[i]
        SafeRunnable.run(Class.new(SafeRunnable.class == Class ? SafeRunnable : Object) do
          extend LocalClass
          include_class_members CellEditor
          include SafeRunnable if SafeRunnable.class == Module
          
          typesig { [] }
          define_method :run do
            l.cancel_editor
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
        i += 1
      end
    end
    
    typesig { [::Java::Boolean, ::Java::Boolean] }
    # Notifies all registered cell editor listeners of a value change.
    # 
    # @param oldValidState
    # the valid state before the end user changed the value
    # @param newValidState
    # the current valid state
    # @see ICellEditorListener#editorValueChanged
    def fire_editor_value_changed(old_valid_state, new_valid_state)
      array = @listeners.get_listeners
      i = 0
      while i < array.attr_length
        l = array[i]
        SafeRunnable.run(Class.new(SafeRunnable.class == Class ? SafeRunnable : Object) do
          extend LocalClass
          include_class_members CellEditor
          include SafeRunnable if SafeRunnable.class == Module
          
          typesig { [] }
          define_method :run do
            l.editor_value_changed(old_valid_state, new_valid_state)
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
        i += 1
      end
    end
    
    typesig { [String] }
    # Notifies all registered property listeners of an enablement change.
    # 
    # @param actionId
    # the id indicating what action's enablement has changed.
    def fire_enablement_changed(action_id)
      array = @property_change_listeners.get_listeners
      i = 0
      while i < array.attr_length
        l = array[i]
        SafeRunnable.run(Class.new(SafeRunnable.class == Class ? SafeRunnable : Object) do
          extend LocalClass
          include_class_members CellEditor
          include SafeRunnable if SafeRunnable.class == Module
          
          typesig { [] }
          define_method :run do
            l.property_change(self.class::PropertyChangeEvent.new(self, action_id, nil, nil))
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
        i += 1
      end
    end
    
    typesig { [::Java::Int] }
    # Sets the style bits for this cell editor.
    # 
    # @param style
    # the SWT style bits for this cell editor
    # @since 2.1
    def set_style(style)
      @style = style
    end
    
    typesig { [] }
    # Returns the style bits for this cell editor.
    # 
    # @return the style for this cell editor
    # @since 2.1
    def get_style
      return @style
    end
    
    typesig { [] }
    # Returns the control used to implement this cell editor.
    # 
    # @return the control, or <code>null</code> if this cell editor has no
    # control
    def get_control
      return @control
    end
    
    typesig { [] }
    # Returns the current error message for this cell editor.
    # 
    # @return the error message if the cell editor is in an invalid state, and
    # <code>null</code> if the cell editor is valid
    def get_error_message
      return @error_message
    end
    
    typesig { [] }
    # Returns a layout data object for this cell editor. This is called each
    # time the cell editor is activated and controls the layout of the SWT
    # table editor.
    # <p>
    # The default implementation of this method sets the minimum width to the
    # control's preferred width. Subclasses may extend or reimplement.
    # </p>
    # 
    # @return the layout data object
    def get_layout_data
      result = LayoutData.new
      control = get_control
      if (!(control).nil?)
        result.attr_minimum_width = control.compute_size(SWT::DEFAULT, SWT::DEFAULT, true).attr_x
      end
      return result
    end
    
    typesig { [] }
    # Returns the input validator for this cell editor.
    # 
    # @return the input validator, or <code>null</code> if none
    def get_validator
      return @validator
    end
    
    typesig { [] }
    # Returns this cell editor's value provided that it has a valid one.
    # 
    # @return the value of this cell editor, or <code>null</code> if the cell
    # editor does not contain a valid value
    def get_value
      if (!@valid)
        return nil
      end
      return do_get_value
    end
    
    typesig { [] }
    # Returns whether this cell editor is activated.
    # 
    # @return <code>true</code> if this cell editor's control is currently
    # activated, and <code>false</code> if not activated
    def is_activated
      # Use the state of the visible style bit (getVisible()) rather than the
      # window's actual visibility (isVisible()) to get correct handling when
      # an ancestor control goes invisible, see bug 85331.
      return !(@control).nil? && @control.get_visible
    end
    
    typesig { [] }
    # Returns <code>true</code> if this cell editor is able to perform the
    # copy action.
    # <p>
    # This default implementation always returns <code>false</code>.
    # </p>
    # <p>
    # Subclasses may override
    # </p>
    # 
    # @return <code>true</code> if copy is possible, <code>false</code>
    # otherwise
    def is_copy_enabled
      return false
    end
    
    typesig { [Object] }
    # Returns whether the given value is valid for this cell editor. This cell
    # editor's validator (if any) makes the actual determination.
    # 
    # @param value
    # the value to check for
    # 
    # @return <code>true</code> if the value is valid, and <code>false</code>
    # if invalid
    def is_correct(value)
      @error_message = RJava.cast_to_string(nil)
      if ((@validator).nil?)
        return true
      end
      @error_message = RJava.cast_to_string(@validator.is_valid(value))
      return ((@error_message).nil? || (@error_message == "")) # $NON-NLS-1$
    end
    
    typesig { [] }
    # Returns <code>true</code> if this cell editor is able to perform the
    # cut action.
    # <p>
    # This default implementation always returns <code>false</code>.
    # </p>
    # <p>
    # Subclasses may override
    # </p>
    # 
    # @return <code>true</code> if cut is possible, <code>false</code>
    # otherwise
    def is_cut_enabled
      return false
    end
    
    typesig { [] }
    # Returns <code>true</code> if this cell editor is able to perform the
    # delete action.
    # <p>
    # This default implementation always returns <code>false</code>.
    # </p>
    # <p>
    # Subclasses may override
    # </p>
    # 
    # @return <code>true</code> if delete is possible, <code>false</code>
    # otherwise
    def is_delete_enabled
      return false
    end
    
    typesig { [] }
    # Returns whether the value of this cell editor has changed since the last
    # call to <code>setValue</code>.
    # 
    # @return <code>true</code> if the value has changed, and
    # <code>false</code> if unchanged
    def is_dirty
      return @dirty
    end
    
    typesig { [] }
    # Marks this cell editor as dirty.
    # 
    # @since 2.1
    def mark_dirty
      @dirty = true
    end
    
    typesig { [] }
    # Returns <code>true</code> if this cell editor is able to perform the
    # find action.
    # <p>
    # This default implementation always returns <code>false</code>.
    # </p>
    # <p>
    # Subclasses may override
    # </p>
    # 
    # @return <code>true</code> if find is possible, <code>false</code>
    # otherwise
    def is_find_enabled
      return false
    end
    
    typesig { [] }
    # Returns <code>true</code> if this cell editor is able to perform the
    # paste action.
    # <p>
    # This default implementation always returns <code>false</code>.
    # </p>
    # <p>
    # Subclasses may override
    # </p>
    # 
    # @return <code>true</code> if paste is possible, <code>false</code>
    # otherwise
    def is_paste_enabled
      return false
    end
    
    typesig { [] }
    # Returns <code>true</code> if this cell editor is able to perform the
    # redo action.
    # <p>
    # This default implementation always returns <code>false</code>.
    # </p>
    # <p>
    # Subclasses may override
    # </p>
    # 
    # @return <code>true</code> if redo is possible, <code>false</code>
    # otherwise
    def is_redo_enabled
      return false
    end
    
    typesig { [] }
    # Returns <code>true</code> if this cell editor is able to perform the
    # select all action.
    # <p>
    # This default implementation always returns <code>false</code>.
    # </p>
    # <p>
    # Subclasses may override
    # </p>
    # 
    # @return <code>true</code> if select all is possible, <code>false</code>
    # otherwise
    def is_select_all_enabled
      return false
    end
    
    typesig { [] }
    # Returns <code>true</code> if this cell editor is able to perform the
    # undo action.
    # <p>
    # This default implementation always returns <code>false</code>.
    # </p>
    # <p>
    # Subclasses may override
    # </p>
    # 
    # @return <code>true</code> if undo is possible, <code>false</code>
    # otherwise
    def is_undo_enabled
      return false
    end
    
    typesig { [] }
    # Returns whether this cell editor has a valid value. The default value is
    # false.
    # 
    # @return <code>true</code> if the value is valid, and <code>false</code>
    # if invalid
    # 
    # @see #setValueValid(boolean)
    def is_value_valid
      return @valid
    end
    
    typesig { [KeyEvent] }
    # Processes a key release event that occurred in this cell editor.
    # <p>
    # The default implementation of this framework method cancels editing when
    # the ESC key is pressed. When the RETURN key is pressed the current value
    # is applied and the cell editor deactivates. Subclasses should call this
    # method at appropriate times. Subclasses may also extend or reimplement.
    # </p>
    # 
    # @param keyEvent
    # the key event
    def key_release_occured(key_event)
      if ((key_event.attr_character).equal?(Character.new(0x001b)))
        # Escape character
        fire_cancel_editor
      else
        if ((key_event.attr_character).equal?(Character.new(?\r.ord)))
          # Return key
          fire_apply_editor_value
          deactivate
        end
      end
    end
    
    typesig { [] }
    # Processes a focus lost event that occurred in this cell editor.
    # <p>
    # The default implementation of this framework method applies the current
    # value and deactivates the cell editor. Subclasses should call this method
    # at appropriate times. Subclasses may also extend or reimplement.
    # </p>
    def focus_lost
      if (is_activated)
        fire_apply_editor_value
        deactivate
      end
    end
    
    typesig { [] }
    # Performs the copy action. This default implementation does nothing.
    # <p>
    # Subclasses may override
    # </p>
    def perform_copy
    end
    
    typesig { [] }
    # Performs the cut action. This default implementation does nothing.
    # <p>
    # Subclasses may override
    # </p>
    def perform_cut
    end
    
    typesig { [] }
    # Performs the delete action. This default implementation does nothing.
    # <p>
    # Subclasses may override
    # </p>
    def perform_delete
    end
    
    typesig { [] }
    # Performs the find action. This default implementation does nothing.
    # <p>
    # Subclasses may override
    # </p>
    def perform_find
    end
    
    typesig { [] }
    # Performs the paste action. This default implementation does nothing.
    # <p>
    # Subclasses may override
    # </p>
    def perform_paste
    end
    
    typesig { [] }
    # Performs the redo action. This default implementation does nothing.
    # <p>
    # Subclasses may override
    # </p>
    def perform_redo
    end
    
    typesig { [] }
    # Performs the select all action. This default implementation does nothing.
    # <p>
    # Subclasses may override
    # </p>
    def perform_select_all
    end
    
    typesig { [] }
    # Performs the undo action. This default implementation does nothing.
    # <p>
    # Subclasses may override
    # </p>
    def perform_undo
    end
    
    typesig { [ICellEditorListener] }
    # Removes the given listener from this cell editor. Has no affect if an
    # identical listener is not registered.
    # 
    # @param listener
    # a cell editor listener
    def remove_listener(listener)
      @listeners.remove(listener)
    end
    
    typesig { [IPropertyChangeListener] }
    # Removes the given property change listener from this cell editor. Has no
    # affect if an identical property change listener is not registered.
    # 
    # @param listener
    # a property change listener
    def remove_property_change_listener(listener)
      @property_change_listeners.remove(listener)
    end
    
    typesig { [String] }
    # Sets or clears the current error message for this cell editor.
    # <p>
    # No formatting is done here, the message to be set is expected to be fully
    # formatted before being passed in.
    # </p>
    # 
    # @param message
    # the error message, or <code>null</code> to clear
    def set_error_message(message)
      @error_message = message
    end
    
    typesig { [] }
    # Sets the focus to the cell editor's control.
    def set_focus
      do_set_focus
    end
    
    typesig { [ICellEditorValidator] }
    # Sets the input validator for this cell editor.
    # 
    # @param validator
    # the input validator, or <code>null</code> if none
    def set_validator(validator)
      @validator = validator
    end
    
    typesig { [Object] }
    # Sets this cell editor's value.
    # 
    # @param value
    # the value of this cell editor
    def set_value(value)
      @valid = is_correct(value)
      @dirty = false
      do_set_value(value)
    end
    
    typesig { [::Java::Boolean] }
    # Sets the valid state of this cell editor. The default value is false.
    # Subclasses should call this method on construction.
    # 
    # @param valid
    # <code>true</code> if the current value is valid, and
    # <code>false</code> if invalid
    # 
    # @see #isValueValid
    def set_value_valid(valid)
      @valid = valid
    end
    
    typesig { [::Java::Boolean, ::Java::Boolean] }
    # The value has changed. Updates the valid state flag, marks this cell
    # editor as dirty, and notifies all registered cell editor listeners of a
    # value change.
    # 
    # @param oldValidState
    # the valid state before the end user changed the value
    # @param newValidState
    # the current valid state
    # @see ICellEditorListener#editorValueChanged
    def value_changed(old_valid_state, new_valid_state)
      @valid = new_valid_state
      @dirty = true
      fire_editor_value_changed(old_valid_state, new_valid_state)
    end
    
    typesig { [ColumnViewerEditorActivationEvent] }
    # Activate the editor but also inform the editor which event triggered its
    # activation. <b>The default implementation simply calls
    # {@link #activate()}</b>
    # 
    # @param activationEvent
    # the editor activation event
    # @since 3.3
    def activate(activation_event)
      activate
    end
    
    typesig { [] }
    # The default implementation of this method returns true. Subclasses that
    # hook their own focus listener should override this method and return
    # false. See also bug 58777.
    # 
    # @return <code>true</code> to indicate that a focus listener has to be
    # attached
    # @since 3.4
    def depends_on_external_focus_listener
      return true
    end
    
    typesig { [ColumnViewerEditorDeactivationEvent] }
    # @param event
    # deactivation event
    # @since 3.4
    def deactivate(event)
      deactivate
    end
    
    typesig { [] }
    # Returns the duration, in milliseconds, between the mouse button click
    # that activates the cell editor and a subsequent mouse button click that
    # will be considered a <em>double click</em> on the underlying control.
    # Clients may override, in particular, clients can return 0 to denote that
    # two subsequent mouse clicks in a cell should not be interpreted as a
    # double click.
    # 
    # @return the timeout or <code>0</code>
    # @since 3.4
    def get_double_click_timeout
      return Display.get_current.get_double_click_time
    end
    
    private
    alias_method :initialize__cell_editor, :initialize
  end
  
end
