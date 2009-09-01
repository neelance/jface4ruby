require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Preference
  module ListEditorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Preference
      include_const ::Org::Eclipse::Jface::Dialogs, :IDialogConstants
      include_const ::Org::Eclipse::Jface::Resource, :JFaceResources
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Events, :DisposeEvent
      include_const ::Org::Eclipse::Swt::Events, :DisposeListener
      include_const ::Org::Eclipse::Swt::Events, :SelectionAdapter
      include_const ::Org::Eclipse::Swt::Events, :SelectionEvent
      include_const ::Org::Eclipse::Swt::Events, :SelectionListener
      include_const ::Org::Eclipse::Swt::Layout, :GridData
      include_const ::Org::Eclipse::Swt::Layout, :GridLayout
      include_const ::Org::Eclipse::Swt::Widgets, :Button
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :JavaList
      include_const ::Org::Eclipse::Swt::Widgets, :Shell
      include_const ::Org::Eclipse::Swt::Widgets, :Widget
    }
  end
  
  # An abstract field editor that manages a list of input values.
  # The editor displays a list containing the values, buttons for
  # adding and removing values, and Up and Down buttons to adjust
  # the order of elements in the list.
  # <p>
  # Subclasses must implement the <code>parseString</code>,
  # <code>createList</code>, and <code>getNewInputObject</code>
  # framework methods.
  # </p>
  class ListEditor < ListEditorImports.const_get :FieldEditor
    include_class_members ListEditorImports
    
    # The list widget; <code>null</code> if none
    # (before creation or after disposal).
    attr_accessor :list
    alias_method :attr_list, :list
    undef_method :list
    alias_method :attr_list=, :list=
    undef_method :list=
    
    # The button box containing the Add, Remove, Up, and Down buttons;
    # <code>null</code> if none (before creation or after disposal).
    attr_accessor :button_box
    alias_method :attr_button_box, :button_box
    undef_method :button_box
    alias_method :attr_button_box=, :button_box=
    undef_method :button_box=
    
    # The Add button.
    attr_accessor :add_button
    alias_method :attr_add_button, :add_button
    undef_method :add_button
    alias_method :attr_add_button=, :add_button=
    undef_method :add_button=
    
    # The Remove button.
    attr_accessor :remove_button
    alias_method :attr_remove_button, :remove_button
    undef_method :remove_button
    alias_method :attr_remove_button=, :remove_button=
    undef_method :remove_button=
    
    # The Up button.
    attr_accessor :up_button
    alias_method :attr_up_button, :up_button
    undef_method :up_button
    alias_method :attr_up_button=, :up_button=
    undef_method :up_button=
    
    # The Down button.
    attr_accessor :down_button
    alias_method :attr_down_button, :down_button
    undef_method :down_button
    alias_method :attr_down_button=, :down_button=
    undef_method :down_button=
    
    # The selection listener.
    attr_accessor :selection_listener
    alias_method :attr_selection_listener, :selection_listener
    undef_method :selection_listener
    alias_method :attr_selection_listener=, :selection_listener=
    undef_method :selection_listener=
    
    typesig { [] }
    # Creates a new list field editor
    def initialize
      @list = nil
      @button_box = nil
      @add_button = nil
      @remove_button = nil
      @up_button = nil
      @down_button = nil
      @selection_listener = nil
      super()
    end
    
    typesig { [String, String, Composite] }
    # Creates a list field editor.
    # 
    # @param name the name of the preference this field editor works on
    # @param labelText the label text of the field editor
    # @param parent the parent of the field editor's control
    def initialize(name, label_text, parent)
      @list = nil
      @button_box = nil
      @add_button = nil
      @remove_button = nil
      @up_button = nil
      @down_button = nil
      @selection_listener = nil
      super()
      init(name, label_text)
      create_control(parent)
    end
    
    typesig { [] }
    # Notifies that the Add button has been pressed.
    def add_pressed
      set_presents_default_value(false)
      input = get_new_input_object
      if (!(input).nil?)
        index = @list.get_selection_index
        if (index >= 0)
          @list.add(input, index + 1)
        else
          @list.add(input, 0)
        end
        selection_changed
      end
    end
    
    typesig { [::Java::Int] }
    # (non-Javadoc)
    # Method declared on FieldEditor.
    def adjust_for_num_columns(num_columns)
      control = get_label_control
      (control.get_layout_data).attr_horizontal_span = num_columns
      (@list.get_layout_data).attr_horizontal_span = num_columns - 1
    end
    
    typesig { [Composite] }
    # Creates the Add, Remove, Up, and Down button in the given button box.
    # 
    # @param box the box for the buttons
    def create_buttons(box)
      @add_button = create_push_button(box, "ListEditor.add") # $NON-NLS-1$
      @remove_button = create_push_button(box, "ListEditor.remove") # $NON-NLS-1$
      @up_button = create_push_button(box, "ListEditor.up") # $NON-NLS-1$
      @down_button = create_push_button(box, "ListEditor.down") # $NON-NLS-1$
    end
    
    typesig { [Array.typed(String)] }
    # Combines the given list of items into a single string.
    # This method is the converse of <code>parseString</code>.
    # <p>
    # Subclasses must implement this method.
    # </p>
    # 
    # @param items the list of items
    # @return the combined string
    # @see #parseString
    def create_list(items)
      raise NotImplementedError
    end
    
    typesig { [Composite, String] }
    # Helper method to create a push button.
    # 
    # @param parent the parent control
    # @param key the resource name used to supply the button's label text
    # @return Button
    def create_push_button(parent, key)
      button = Button.new(parent, SWT::PUSH)
      button.set_text(JFaceResources.get_string(key))
      button.set_font(parent.get_font)
      data = GridData.new(GridData::FILL_HORIZONTAL)
      width_hint = convert_horizontal_dlus_to_pixels(button, IDialogConstants::BUTTON_WIDTH)
      data.attr_width_hint = Math.max(width_hint, button.compute_size(SWT::DEFAULT, SWT::DEFAULT, true).attr_x)
      button.set_layout_data(data)
      button.add_selection_listener(get_selection_listener)
      return button
    end
    
    typesig { [] }
    # Creates a selection listener.
    def create_selection_listener
      @selection_listener = Class.new(SelectionAdapter.class == Class ? SelectionAdapter : Object) do
        extend LocalClass
        include_class_members ListEditor
        include SelectionAdapter if SelectionAdapter.class == Module
        
        typesig { [SelectionEvent] }
        define_method :widget_selected do |event|
          widget = event.attr_widget
          if ((widget).equal?(self.attr_add_button))
            add_pressed
          else
            if ((widget).equal?(self.attr_remove_button))
              remove_pressed
            else
              if ((widget).equal?(self.attr_up_button))
                up_pressed
              else
                if ((widget).equal?(self.attr_down_button))
                  down_pressed
                else
                  if ((widget).equal?(self.attr_list))
                    selection_changed
                  end
                end
              end
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
    end
    
    typesig { [Composite, ::Java::Int] }
    # (non-Javadoc)
    # Method declared on FieldEditor.
    def do_fill_into_grid(parent, num_columns)
      control = get_label_control(parent)
      gd = GridData.new
      gd.attr_horizontal_span = num_columns
      control.set_layout_data(gd)
      @list = get_list_control(parent)
      gd = GridData.new(GridData::FILL_HORIZONTAL)
      gd.attr_vertical_alignment = GridData::FILL
      gd.attr_horizontal_span = num_columns - 1
      gd.attr_grab_excess_horizontal_space = true
      @list.set_layout_data(gd)
      @button_box = get_button_box_control(parent)
      gd = GridData.new
      gd.attr_vertical_alignment = GridData::BEGINNING
      @button_box.set_layout_data(gd)
    end
    
    typesig { [] }
    # (non-Javadoc)
    # Method declared on FieldEditor.
    def do_load
      if (!(@list).nil?)
        s = get_preference_store.get_string(get_preference_name)
        array = parse_string(s)
        i = 0
        while i < array.attr_length
          @list.add(array[i])
          i += 1
        end
      end
    end
    
    typesig { [] }
    # (non-Javadoc)
    # Method declared on FieldEditor.
    def do_load_default
      if (!(@list).nil?)
        @list.remove_all
        s = get_preference_store.get_default_string(get_preference_name)
        array = parse_string(s)
        i = 0
        while i < array.attr_length
          @list.add(array[i])
          i += 1
        end
      end
    end
    
    typesig { [] }
    # (non-Javadoc)
    # Method declared on FieldEditor.
    def do_store
      s = create_list(@list.get_items)
      if (!(s).nil?)
        get_preference_store.set_value(get_preference_name, s)
      end
    end
    
    typesig { [] }
    # Notifies that the Down button has been pressed.
    def down_pressed
      swap(false)
    end
    
    typesig { [Composite] }
    # Returns this field editor's button box containing the Add, Remove,
    # Up, and Down button.
    # 
    # @param parent the parent control
    # @return the button box
    def get_button_box_control(parent)
      if ((@button_box).nil?)
        @button_box = Composite.new(parent, SWT::NULL)
        layout = GridLayout.new
        layout.attr_margin_width = 0
        @button_box.set_layout(layout)
        create_buttons(@button_box)
        @button_box.add_dispose_listener(Class.new(DisposeListener.class == Class ? DisposeListener : Object) do
          extend LocalClass
          include_class_members ListEditor
          include DisposeListener if DisposeListener.class == Module
          
          typesig { [DisposeEvent] }
          define_method :widget_disposed do |event|
            self.attr_add_button = nil
            self.attr_remove_button = nil
            self.attr_up_button = nil
            self.attr_down_button = nil
            self.attr_button_box = nil
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      else
        check_parent(@button_box, parent)
      end
      selection_changed
      return @button_box
    end
    
    typesig { [Composite] }
    # Returns this field editor's list control.
    # 
    # @param parent the parent control
    # @return the list control
    def get_list_control(parent)
      if ((@list).nil?)
        @list = JavaList.new(parent, SWT::BORDER | SWT::SINGLE | SWT::V_SCROLL | SWT::H_SCROLL)
        @list.set_font(parent.get_font)
        @list.add_selection_listener(get_selection_listener)
        @list.add_dispose_listener(Class.new(DisposeListener.class == Class ? DisposeListener : Object) do
          extend LocalClass
          include_class_members ListEditor
          include DisposeListener if DisposeListener.class == Module
          
          typesig { [DisposeEvent] }
          define_method :widget_disposed do |event|
            self.attr_list = nil
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      else
        check_parent(@list, parent)
      end
      return @list
    end
    
    typesig { [] }
    # Creates and returns a new item for the list.
    # <p>
    # Subclasses must implement this method.
    # </p>
    # 
    # @return a new item
    def get_new_input_object
      raise NotImplementedError
    end
    
    typesig { [] }
    # (non-Javadoc)
    # Method declared on FieldEditor.
    def get_number_of_controls
      return 2
    end
    
    typesig { [] }
    # Returns this field editor's selection listener.
    # The listener is created if nessessary.
    # 
    # @return the selection listener
    def get_selection_listener
      if ((@selection_listener).nil?)
        create_selection_listener
      end
      return @selection_listener
    end
    
    typesig { [] }
    # Returns this field editor's shell.
    # <p>
    # This method is internal to the framework; subclassers should not call
    # this method.
    # </p>
    # 
    # @return the shell
    def get_shell
      if ((@add_button).nil?)
        return nil
      end
      return @add_button.get_shell
    end
    
    typesig { [String] }
    # Splits the given string into a list of strings.
    # This method is the converse of <code>createList</code>.
    # <p>
    # Subclasses must implement this method.
    # </p>
    # 
    # @param stringList the string
    # @return an array of <code>String</code>
    # @see #createList
    def parse_string(string_list)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Notifies that the Remove button has been pressed.
    def remove_pressed
      set_presents_default_value(false)
      index = @list.get_selection_index
      if (index >= 0)
        @list.remove(index)
        selection_changed
      end
    end
    
    typesig { [] }
    # Invoked when the selection in the list has changed.
    # 
    # <p>
    # The default implementation of this method utilizes the selection index
    # and the size of the list to toggle the enablement of the up, down and
    # remove buttons.
    # </p>
    # 
    # <p>
    # Sublcasses may override.
    # </p>
    # 
    # @since 3.5
    def selection_changed
      index = @list.get_selection_index
      size = @list.get_item_count
      @remove_button.set_enabled(index >= 0)
      @up_button.set_enabled(size > 1 && index > 0)
      @down_button.set_enabled(size > 1 && index >= 0 && index < size - 1)
    end
    
    typesig { [] }
    # (non-Javadoc)
    # Method declared on FieldEditor.
    def set_focus
      if (!(@list).nil?)
        @list.set_focus
      end
    end
    
    typesig { [::Java::Boolean] }
    # Moves the currently selected item up or down.
    # 
    # @param up <code>true</code> if the item should move up,
    # and <code>false</code> if it should move down
    def swap(up)
      set_presents_default_value(false)
      index = @list.get_selection_index
      target = up ? index - 1 : index + 1
      if (index >= 0)
        selection = @list.get_selection
        Assert.is_true((selection.attr_length).equal?(1))
        @list.remove(index)
        @list.add(selection[0], target)
        @list.set_selection(target)
      end
      selection_changed
    end
    
    typesig { [] }
    # Notifies that the Up button has been pressed.
    def up_pressed
      swap(true)
    end
    
    typesig { [::Java::Boolean, Composite] }
    # @see FieldEditor.setEnabled(boolean,Composite).
    def set_enabled(enabled, parent)
      super(enabled, parent)
      get_list_control(parent).set_enabled(enabled)
      @add_button.set_enabled(enabled)
      @remove_button.set_enabled(enabled)
      @up_button.set_enabled(enabled)
      @down_button.set_enabled(enabled)
    end
    
    typesig { [] }
    # Return the Add button.
    # 
    # @return the button
    # @since 3.5
    def get_add_button
      return @add_button
    end
    
    typesig { [] }
    # Return the Remove button.
    # 
    # @return the button
    # @since 3.5
    def get_remove_button
      return @remove_button
    end
    
    typesig { [] }
    # Return the Up button.
    # 
    # @return the button
    # @since 3.5
    def get_up_button
      return @up_button
    end
    
    typesig { [] }
    # Return the Down button.
    # 
    # @return the button
    # @since 3.5
    def get_down_button
      return @down_button
    end
    
    typesig { [] }
    # Return the List.
    # 
    # @return the list
    # @since 3.5
    def get_list
      return @list
    end
    
    private
    alias_method :initialize__list_editor, :initialize
  end
  
end
