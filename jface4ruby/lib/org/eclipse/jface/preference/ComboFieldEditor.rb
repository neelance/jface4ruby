require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
# Remy Chi Jian Suen <remy.suen@gmail.com> - Bug 214392 missing implementation of ComboFieldEditor.setEnabled
module Org::Eclipse::Jface::Preference
  module ComboFieldEditorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Preference
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Events, :SelectionAdapter
      include_const ::Org::Eclipse::Swt::Events, :SelectionEvent
      include_const ::Org::Eclipse::Swt::Layout, :GridData
      include_const ::Org::Eclipse::Swt::Widgets, :Combo
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Control
    }
  end
  
  # A field editor for a combo box that allows the drop-down selection of one of
  # a list of items.
  # 
  # @since 3.3
  class ComboFieldEditor < ComboFieldEditorImports.const_get :FieldEditor
    include_class_members ComboFieldEditorImports
    
    # The <code>Combo</code> widget.
    attr_accessor :f_combo
    alias_method :attr_f_combo, :f_combo
    undef_method :f_combo
    alias_method :attr_f_combo=, :f_combo=
    undef_method :f_combo=
    
    # The value (not the name) of the currently selected item in the Combo widget.
    attr_accessor :f_value
    alias_method :attr_f_value, :f_value
    undef_method :f_value
    alias_method :attr_f_value=, :f_value=
    undef_method :f_value=
    
    # The names (labels) and underlying values to populate the combo widget.  These should be
    # arranged as: { {name1, value1}, {name2, value2}, ...}
    attr_accessor :f_entry_names_and_values
    alias_method :attr_f_entry_names_and_values, :f_entry_names_and_values
    undef_method :f_entry_names_and_values
    alias_method :attr_f_entry_names_and_values=, :f_entry_names_and_values=
    undef_method :f_entry_names_and_values=
    
    typesig { [String, String, Array.typed(Array.typed(String)), Composite] }
    # Create the combo box field editor.
    # 
    # @param name the name of the preference this field editor works on
    # @param labelText the label text of the field editor
    # @param entryNamesAndValues the names (labels) and underlying values to populate the combo widget.  These should be
    # arranged as: { {name1, value1}, {name2, value2}, ...}
    # @param parent the parent composite
    def initialize(name, label_text, entry_names_and_values, parent)
      @f_combo = nil
      @f_value = nil
      @f_entry_names_and_values = nil
      super()
      init(name, label_text)
      Assert.is_true(check_array(entry_names_and_values))
      @f_entry_names_and_values = entry_names_and_values
      create_control(parent)
    end
    
    typesig { [Array.typed(Array.typed(String))] }
    # Checks whether given <code>String[][]</code> is of "type"
    # <code>String[][2]</code>.
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
    
    typesig { [::Java::Int] }
    # (non-Javadoc)
    # @see org.eclipse.jface.preference.FieldEditor#adjustForNumColumns(int)
    def adjust_for_num_columns(num_columns)
      if (num_columns > 1)
        control = get_label_control
        left = num_columns
        if (!(control).nil?)
          (control.get_layout_data).attr_horizontal_span = 1
          left = left - 1
        end
        (@f_combo.get_layout_data).attr_horizontal_span = left
      else
        control = get_label_control
        if (!(control).nil?)
          (control.get_layout_data).attr_horizontal_span = 1
        end
        (@f_combo.get_layout_data).attr_horizontal_span = 1
      end
    end
    
    typesig { [Composite, ::Java::Int] }
    # (non-Javadoc)
    # @see org.eclipse.jface.preference.FieldEditor#doFillIntoGrid(org.eclipse.swt.widgets.Composite, int)
    def do_fill_into_grid(parent, num_columns)
      combo_c = 1
      if (num_columns > 1)
        combo_c = num_columns - 1
      end
      control = get_label_control(parent)
      gd = GridData.new
      gd.attr_horizontal_span = 1
      control.set_layout_data(gd)
      control = get_combo_box_control(parent)
      gd = GridData.new
      gd.attr_horizontal_span = combo_c
      gd.attr_horizontal_alignment = GridData::FILL
      control.set_layout_data(gd)
      control.set_font(parent.get_font)
    end
    
    typesig { [] }
    # (non-Javadoc)
    # @see org.eclipse.jface.preference.FieldEditor#doLoad()
    def do_load
      update_combo_for_value(get_preference_store.get_string(get_preference_name))
    end
    
    typesig { [] }
    # (non-Javadoc)
    # @see org.eclipse.jface.preference.FieldEditor#doLoadDefault()
    def do_load_default
      update_combo_for_value(get_preference_store.get_default_string(get_preference_name))
    end
    
    typesig { [] }
    # (non-Javadoc)
    # @see org.eclipse.jface.preference.FieldEditor#doStore()
    def do_store
      if ((@f_value).nil?)
        get_preference_store.set_to_default(get_preference_name)
        return
      end
      get_preference_store.set_value(get_preference_name, @f_value)
    end
    
    typesig { [] }
    # (non-Javadoc)
    # @see org.eclipse.jface.preference.FieldEditor#getNumberOfControls()
    def get_number_of_controls
      return 2
    end
    
    typesig { [Composite] }
    # Lazily create and return the Combo control.
    def get_combo_box_control(parent)
      if ((@f_combo).nil?)
        @f_combo = Combo.new(parent, SWT::READ_ONLY)
        @f_combo.set_font(parent.get_font)
        i = 0
        while i < @f_entry_names_and_values.attr_length
          @f_combo.add(@f_entry_names_and_values[i][0], i)
          i += 1
        end
        @f_combo.add_selection_listener(Class.new(SelectionAdapter.class == Class ? SelectionAdapter : Object) do
          extend LocalClass
          include_class_members ComboFieldEditor
          include SelectionAdapter if SelectionAdapter.class == Module
          
          typesig { [SelectionEvent] }
          define_method :widget_selected do |evt|
            old_value = self.attr_f_value
            name = self.attr_f_combo.get_text
            self.attr_f_value = get_value_for_name(name)
            set_presents_default_value(false)
            fire_value_changed(VALUE, old_value, self.attr_f_value)
          end
          
          typesig { [] }
          define_method :initialize do
            super()
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      end
      return @f_combo
    end
    
    typesig { [String] }
    # Given the name (label) of an entry, return the corresponding value.
    def get_value_for_name(name)
      i = 0
      while i < @f_entry_names_and_values.attr_length
        entry = @f_entry_names_and_values[i]
        if ((name == entry[0]))
          return entry[1]
        end
        i += 1
      end
      return @f_entry_names_and_values[0][0]
    end
    
    typesig { [String] }
    # Set the name in the combo widget to match the specified value.
    def update_combo_for_value(value)
      @f_value = value
      i = 0
      while i < @f_entry_names_and_values.attr_length
        if ((value == @f_entry_names_and_values[i][1]))
          @f_combo.set_text(@f_entry_names_and_values[i][0])
          return
        end
        i += 1
      end
      if (@f_entry_names_and_values.attr_length > 0)
        @f_value = RJava.cast_to_string(@f_entry_names_and_values[0][1])
        @f_combo.set_text(@f_entry_names_and_values[0][0])
      end
    end
    
    typesig { [::Java::Boolean, Composite] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.preference.FieldEditor#setEnabled(boolean,
    # org.eclipse.swt.widgets.Composite)
    def set_enabled(enabled, parent)
      super(enabled, parent)
      get_combo_box_control(parent).set_enabled(enabled)
    end
    
    private
    alias_method :initialize__combo_field_editor, :initialize
  end
  
end
