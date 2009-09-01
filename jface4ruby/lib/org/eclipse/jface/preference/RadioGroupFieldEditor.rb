require "rjava"

# Copyright (c) 2000, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Preference
  module RadioGroupFieldEditorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Preference
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Events, :DisposeEvent
      include_const ::Org::Eclipse::Swt::Events, :DisposeListener
      include_const ::Org::Eclipse::Swt::Events, :SelectionAdapter
      include_const ::Org::Eclipse::Swt::Events, :SelectionEvent
      include_const ::Org::Eclipse::Swt::Graphics, :Font
      include_const ::Org::Eclipse::Swt::Layout, :GridData
      include_const ::Org::Eclipse::Swt::Layout, :GridLayout
      include_const ::Org::Eclipse::Swt::Widgets, :Button
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Group
    }
  end
  
  # A field editor for an enumeration type preference.
  # The choices are presented as a list of radio buttons.
  class RadioGroupFieldEditor < RadioGroupFieldEditorImports.const_get :FieldEditor
    include_class_members RadioGroupFieldEditorImports
    
    # List of radio button entries of the form [label,value].
    attr_accessor :labels_and_values
    alias_method :attr_labels_and_values, :labels_and_values
    undef_method :labels_and_values
    alias_method :attr_labels_and_values=, :labels_and_values=
    undef_method :labels_and_values=
    
    # Number of columns into which to arrange the radio buttons.
    attr_accessor :num_columns
    alias_method :attr_num_columns, :num_columns
    undef_method :num_columns
    alias_method :attr_num_columns=, :num_columns=
    undef_method :num_columns=
    
    # Indent used for the first column of the radion button matrix.
    attr_accessor :indent
    alias_method :attr_indent, :indent
    undef_method :indent
    alias_method :attr_indent=, :indent=
    undef_method :indent=
    
    # The current value, or <code>null</code> if none.
    attr_accessor :value
    alias_method :attr_value, :value
    undef_method :value
    alias_method :attr_value=, :value=
    undef_method :value=
    
    # The box of radio buttons, or <code>null</code> if none
    # (before creation and after disposal).
    attr_accessor :radio_box
    alias_method :attr_radio_box, :radio_box
    undef_method :radio_box
    alias_method :attr_radio_box=, :radio_box=
    undef_method :radio_box=
    
    # The radio buttons, or <code>null</code> if none
    # (before creation and after disposal).
    attr_accessor :radio_buttons
    alias_method :attr_radio_buttons, :radio_buttons
    undef_method :radio_buttons
    alias_method :attr_radio_buttons=, :radio_buttons=
    undef_method :radio_buttons=
    
    # Whether to use a Group control.
    attr_accessor :use_group
    alias_method :attr_use_group, :use_group
    undef_method :use_group
    alias_method :attr_use_group=, :use_group=
    undef_method :use_group=
    
    typesig { [] }
    # Creates a new radio group field editor
    def initialize
      @labels_and_values = nil
      @num_columns = 0
      @indent = 0
      @value = nil
      @radio_box = nil
      @radio_buttons = nil
      @use_group = false
      super()
      @indent = HORIZONTAL_GAP
    end
    
    typesig { [String, String, ::Java::Int, Array.typed(Array.typed(String)), Composite] }
    # Creates a radio group field editor.
    # This constructor does not use a <code>Group</code> to contain the radio buttons.
    # It is equivalent to using the following constructor with <code>false</code>
    # for the <code>useGroup</code> argument.
    # <p>
    # Example usage:
    # <pre>
    # RadioGroupFieldEditor editor= new RadioGroupFieldEditor(
    # "GeneralPage.DoubleClick", resName, 1,
    # new String[][] {
    # {"Open Browser", "open"},
    # {"Expand Tree", "expand"}
    # },
    # parent);
    # </pre>
    # </p>
    # 
    # @param name the name of the preference this field editor works on
    # @param labelText the label text of the field editor
    # @param numColumns the number of columns for the radio button presentation
    # @param labelAndValues list of radio button [label, value] entries;
    # the value is returned when the radio button is selected
    # @param parent the parent of the field editor's control
    def initialize(name, label_text, num_columns, label_and_values, parent)
      initialize__radio_group_field_editor(name, label_text, num_columns, label_and_values, parent, false)
    end
    
    typesig { [String, String, ::Java::Int, Array.typed(Array.typed(String)), Composite, ::Java::Boolean] }
    # Creates a radio group field editor.
    # <p>
    # Example usage:
    # <pre>
    # RadioGroupFieldEditor editor= new RadioGroupFieldEditor(
    # "GeneralPage.DoubleClick", resName, 1,
    # new String[][] {
    # {"Open Browser", "open"},
    # {"Expand Tree", "expand"}
    # },
    # parent,
    # true);
    # </pre>
    # </p>
    # 
    # @param name the name of the preference this field editor works on
    # @param labelText the label text of the field editor
    # @param numColumns the number of columns for the radio button presentation
    # @param labelAndValues list of radio button [label, value] entries;
    # the value is returned when the radio button is selected
    # @param parent the parent of the field editor's control
    # @param useGroup whether to use a Group control to contain the radio buttons
    def initialize(name, label_text, num_columns, label_and_values, parent, use_group)
      @labels_and_values = nil
      @num_columns = 0
      @indent = 0
      @value = nil
      @radio_box = nil
      @radio_buttons = nil
      @use_group = false
      super()
      @indent = HORIZONTAL_GAP
      init(name, label_text)
      Assert.is_true(check_array(label_and_values))
      @labels_and_values = label_and_values
      @num_columns = num_columns
      @use_group = use_group
      create_control(parent)
    end
    
    typesig { [::Java::Int] }
    # (non-Javadoc)
    # Method declared on FieldEditor.
    def adjust_for_num_columns(num_columns)
      control = get_label_control
      if (!(control).nil?)
        (control.get_layout_data).attr_horizontal_span = num_columns
      end
      (@radio_box.get_layout_data).attr_horizontal_span = num_columns
    end
    
    typesig { [Array.typed(Array.typed(String))] }
    # Checks whether given <code>String[][]</code> is of "type"
    # <code>String[][2]</code>.
    # @param table
    # 
    # @return <code>true</code> if it is ok, and <code>false</code> otherwise
    def check_array(table)
      if ((table).nil?)
        return false
      end
      i = 0
      while i < table.attr_length
        array = table[i]
        if ((array).nil? || !(array.attr_length).equal?(2))
          return false
        end
        i += 1
      end
      return true
    end
    
    typesig { [Composite, ::Java::Int] }
    # (non-Javadoc)
    # Method declared on FieldEditor.
    def do_fill_into_grid(parent, num_columns)
      if (@use_group)
        control = get_radio_box_control(parent)
        gd = GridData.new(GridData::FILL_HORIZONTAL)
        control.set_layout_data(gd)
      else
        control = get_label_control(parent)
        gd = GridData.new
        gd.attr_horizontal_span = num_columns
        control.set_layout_data(gd)
        control = get_radio_box_control(parent)
        gd = GridData.new
        gd.attr_horizontal_span = num_columns
        gd.attr_horizontal_indent = @indent
        control.set_layout_data(gd)
      end
    end
    
    typesig { [] }
    # (non-Javadoc)
    # Method declared on FieldEditor.
    def do_load
      update_value(get_preference_store.get_string(get_preference_name))
    end
    
    typesig { [] }
    # (non-Javadoc)
    # Method declared on FieldEditor.
    def do_load_default
      update_value(get_preference_store.get_default_string(get_preference_name))
    end
    
    typesig { [] }
    # (non-Javadoc)
    # Method declared on FieldEditor.
    def do_store
      if ((@value).nil?)
        get_preference_store.set_to_default(get_preference_name)
        return
      end
      get_preference_store.set_value(get_preference_name, @value)
    end
    
    typesig { [] }
    # (non-Javadoc)
    # Method declared on FieldEditor.
    def get_number_of_controls
      return 1
    end
    
    typesig { [Composite] }
    # Returns this field editor's radio group control.
    # @param parent The parent to create the radioBox in
    # @return the radio group control
    def get_radio_box_control(parent)
      if ((@radio_box).nil?)
        font = parent.get_font
        if (@use_group)
          group = Group.new(parent, SWT::NONE)
          group.set_font(font)
          text = get_label_text
          if (!(text).nil?)
            group.set_text(text)
          end
          @radio_box = group
          layout = GridLayout.new
          layout.attr_horizontal_spacing = HORIZONTAL_GAP
          layout.attr_num_columns = @num_columns
          @radio_box.set_layout(layout)
        else
          @radio_box = Composite.new(parent, SWT::NONE)
          layout = GridLayout.new
          layout.attr_margin_width = 0
          layout.attr_margin_height = 0
          layout.attr_horizontal_spacing = HORIZONTAL_GAP
          layout.attr_num_columns = @num_columns
          @radio_box.set_layout(layout)
          @radio_box.set_font(font)
        end
        @radio_buttons = Array.typed(Button).new(@labels_and_values.attr_length) { nil }
        i = 0
        while i < @labels_and_values.attr_length
          radio = Button.new(@radio_box, SWT::RADIO | SWT::LEFT)
          @radio_buttons[i] = radio
          label_and_value = @labels_and_values[i]
          radio.set_text(label_and_value[0])
          radio.set_data(label_and_value[1])
          radio.set_font(font)
          radio.add_selection_listener(Class.new(SelectionAdapter.class == Class ? SelectionAdapter : Object) do
            extend LocalClass
            include_class_members RadioGroupFieldEditor
            include SelectionAdapter if SelectionAdapter.class == Module
            
            typesig { [SelectionEvent] }
            define_method :widget_selected do |event|
              old_value = self.attr_value
              self.attr_value = event.attr_widget.get_data
              set_presents_default_value(false)
              fire_value_changed(VALUE, old_value, self.attr_value)
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
        @radio_box.add_dispose_listener(Class.new(DisposeListener.class == Class ? DisposeListener : Object) do
          extend LocalClass
          include_class_members RadioGroupFieldEditor
          include DisposeListener if DisposeListener.class == Module
          
          typesig { [DisposeEvent] }
          define_method :widget_disposed do |event|
            self.attr_radio_box = nil
            self.attr_radio_buttons = nil
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      else
        check_parent(@radio_box, parent)
      end
      return @radio_box
    end
    
    typesig { [::Java::Int] }
    # Sets the indent used for the first column of the radion button matrix.
    # 
    # @param indent the indent (in pixels)
    def set_indent(indent)
      if (indent < 0)
        @indent = 0
      else
        @indent = indent
      end
    end
    
    typesig { [String] }
    # Select the radio button that conforms to the given value.
    # 
    # @param selectedValue the selected value
    def update_value(selected_value)
      @value = selected_value
      if ((@radio_buttons).nil?)
        return
      end
      if (!(@value).nil?)
        found = false
        i = 0
        while i < @radio_buttons.attr_length
          radio = @radio_buttons[i]
          selection = false
          if (((radio.get_data) == @value))
            selection = true
            found = true
          end
          radio.set_selection(selection)
          i += 1
        end
        if (found)
          return
        end
      end
      # We weren't able to find the value. So we select the first
      # radio button as a default.
      if (@radio_buttons.attr_length > 0)
        @radio_buttons[0].set_selection(true)
        @value = @radio_buttons[0].get_data
      end
      return
    end
    
    typesig { [::Java::Boolean, Composite] }
    # @see FieldEditor.setEnabled(boolean,Composite).
    def set_enabled(enabled, parent)
      if (!@use_group)
        super(enabled, parent)
      end
      i = 0
      while i < @radio_buttons.attr_length
        @radio_buttons[i].set_enabled(enabled)
        i += 1
      end
    end
    
    private
    alias_method :initialize__radio_group_field_editor, :initialize
  end
  
end
