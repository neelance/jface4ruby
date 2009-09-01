require "rjava"

# Copyright (c) 2003, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Preference
  module ScaleFieldEditorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Preference
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Events, :DisposeEvent
      include_const ::Org::Eclipse::Swt::Events, :DisposeListener
      include_const ::Org::Eclipse::Swt::Events, :SelectionAdapter
      include_const ::Org::Eclipse::Swt::Events, :SelectionEvent
      include_const ::Org::Eclipse::Swt::Layout, :GridData
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Scale
    }
  end
  
  # A field editor for an integer type preference. This class may be used as is,
  # or subclassed as required.
  # 
  # @since 3.0
  class ScaleFieldEditor < ScaleFieldEditorImports.const_get :FieldEditor
    include_class_members ScaleFieldEditorImports
    
    # Value that will feed Scale.setIncrement(int).
    attr_accessor :increment_value
    alias_method :attr_increment_value, :increment_value
    undef_method :increment_value
    alias_method :attr_increment_value=, :increment_value=
    undef_method :increment_value=
    
    # Value that will feed Scale.setMaximum(int).
    attr_accessor :max_value
    alias_method :attr_max_value, :max_value
    undef_method :max_value
    alias_method :attr_max_value=, :max_value=
    undef_method :max_value=
    
    # Value that will feed Scale.setMinimum(int).
    attr_accessor :min_value
    alias_method :attr_min_value, :min_value
    undef_method :min_value
    alias_method :attr_min_value=, :min_value=
    undef_method :min_value=
    
    # Old integer value.
    attr_accessor :old_value
    alias_method :attr_old_value, :old_value
    undef_method :old_value
    alias_method :attr_old_value=, :old_value=
    undef_method :old_value=
    
    # Value that will feed Scale.setPageIncrement(int).
    attr_accessor :page_increment_value
    alias_method :attr_page_increment_value, :page_increment_value
    undef_method :page_increment_value
    alias_method :attr_page_increment_value=, :page_increment_value=
    undef_method :page_increment_value=
    
    # The scale, or <code>null</code> if none.
    attr_accessor :scale
    alias_method :attr_scale, :scale
    undef_method :scale
    alias_method :attr_scale=, :scale=
    undef_method :scale=
    
    typesig { [String, String, Composite] }
    # Creates a scale field editor.
    # 
    # @param name
    # the name of the preference this field editor works on
    # @param labelText
    # the label text of the field editor
    # @param parent
    # the parent of the field editor's control
    def initialize(name, label_text, parent)
      @increment_value = 0
      @max_value = 0
      @min_value = 0
      @old_value = 0
      @page_increment_value = 0
      @scale = nil
      super(name, label_text, parent)
      set_default_values
    end
    
    typesig { [String, String, Composite, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int] }
    # Creates a scale field editor with particular scale values.
    # 
    # @param name
    # the name of the preference this field editor works on
    # @param labelText
    # the label text of the field editor
    # @param parent
    # the parent of the field editor's control
    # @param min
    # the value used for Scale.setMinimum(int).
    # @param max
    # the value used for Scale.setMaximum(int).
    # @param increment
    # the value used for Scale.setIncrement(int).
    # @param pageIncrement
    # the value used for Scale.setPageIncrement(int).
    def initialize(name, label_text, parent, min, max, increment, page_increment)
      @increment_value = 0
      @max_value = 0
      @min_value = 0
      @old_value = 0
      @page_increment_value = 0
      @scale = nil
      super(name, label_text, parent)
      set_values(min, max, increment, page_increment)
    end
    
    typesig { [::Java::Int] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.preference.FieldEditor#adjustForNumColumns(int)
    def adjust_for_num_columns(num_columns)
      (@scale.get_layout_data).attr_horizontal_span = num_columns - 1
    end
    
    typesig { [Composite, ::Java::Int] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.preference.FieldEditor#doFillIntoGrid(org.eclipse.swt.widgets.Composite,
    # int)
    def do_fill_into_grid(parent, num_columns)
      control = get_label_control(parent)
      gd = GridData.new
      control.set_layout_data(gd)
      @scale = get_scale_control(parent)
      gd = GridData.new(GridData::FILL_HORIZONTAL)
      gd.attr_vertical_alignment = GridData::FILL
      gd.attr_horizontal_span = num_columns - 1
      gd.attr_grab_excess_horizontal_space = true
      @scale.set_layout_data(gd)
      update_scale
    end
    
    typesig { [] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.preference.FieldEditor#doLoad()
    def do_load
      if (!(@scale).nil?)
        value = get_preference_store.get_int(get_preference_name)
        @scale.set_selection(value)
        @old_value = value
      end
    end
    
    typesig { [] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.preference.FieldEditor#doLoadDefault()
    def do_load_default
      if (!(@scale).nil?)
        value = get_preference_store.get_default_int(get_preference_name)
        @scale.set_selection(value)
      end
      value_changed
    end
    
    typesig { [] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.preference.FieldEditor#doStore()
    def do_store
      get_preference_store.set_value(get_preference_name, @scale.get_selection)
    end
    
    typesig { [] }
    # Returns the value that will be used for Scale.setIncrement(int).
    # 
    # @return the value.
    # @see org.eclipse.swt.widgets.Scale#setIncrement(int)
    def get_increment
      return @increment_value
    end
    
    typesig { [] }
    # Returns the value that will be used for Scale.setMaximum(int).
    # 
    # @return the value.
    # @see org.eclipse.swt.widgets.Scale#setMaximum(int)
    def get_maximum
      return @max_value
    end
    
    typesig { [] }
    # Returns the value that will be used for Scale.setMinimum(int).
    # 
    # @return the value.
    # @see org.eclipse.swt.widgets.Scale#setMinimum(int)
    def get_minimum
      return @min_value
    end
    
    typesig { [] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.preference.FieldEditor#getNumberOfControls()
    def get_number_of_controls
      return 2
    end
    
    typesig { [] }
    # Returns the value that will be used for Scale.setPageIncrement(int).
    # 
    # @return the value.
    # @see org.eclipse.swt.widgets.Scale#setPageIncrement(int)
    def get_page_increment
      return @page_increment_value
    end
    
    typesig { [] }
    # Returns this field editor's scale control.
    # 
    # @return the scale control, or <code>null</code> if no scale field is
    # created yet
    def get_scale_control
      return @scale
    end
    
    typesig { [Composite] }
    # Returns this field editor's scale control. The control is created if it
    # does not yet exist.
    # 
    # @param parent
    # the parent
    # @return the scale control
    def get_scale_control(parent)
      if ((@scale).nil?)
        @scale = Scale.new(parent, SWT::HORIZONTAL)
        @scale.set_font(parent.get_font)
        @scale.add_selection_listener(Class.new(SelectionAdapter.class == Class ? SelectionAdapter : Object) do
          extend LocalClass
          include_class_members ScaleFieldEditor
          include SelectionAdapter if SelectionAdapter.class == Module
          
          typesig { [SelectionEvent] }
          define_method :widget_selected do |event|
            value_changed
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
        @scale.add_dispose_listener(Class.new(DisposeListener.class == Class ? DisposeListener : Object) do
          extend LocalClass
          include_class_members ScaleFieldEditor
          include DisposeListener if DisposeListener.class == Module
          
          typesig { [DisposeEvent] }
          define_method :widget_disposed do |event|
            self.attr_scale = nil
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      else
        check_parent(@scale, parent)
      end
      return @scale
    end
    
    typesig { [] }
    # Set default values for the various scale fields.  These defaults are:<br>
    # <ul>
    # <li>Minimum  = 0
    # <li>Maximim = 10
    # <li>Increment = 1
    # <li>Page Increment = 1
    # </ul>
    def set_default_values
      set_values(0, 10, 1, 1)
    end
    
    typesig { [] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.preference.FieldEditor#setFocus()
    def set_focus
      if (!(@scale).nil? && !@scale.is_disposed)
        @scale.set_focus
      end
    end
    
    typesig { [::Java::Int] }
    # Set the value to be used for Scale.setIncrement(int) and update the
    # scale.
    # 
    # @param increment
    # a value greater than 0.
    # @see org.eclipse.swt.widgets.Scale#setIncrement(int)
    def set_increment(increment)
      @increment_value = increment
      update_scale
    end
    
    typesig { [::Java::Int] }
    # Set the value to be used for Scale.setMaximum(int) and update the
    # scale.
    # 
    # @param max
    # a value greater than 0.
    # @see org.eclipse.swt.widgets.Scale#setMaximum(int)
    def set_maximum(max)
      @max_value = max
      update_scale
    end
    
    typesig { [::Java::Int] }
    # Set the value to be used for Scale.setMinumum(int) and update the
    # scale.
    # 
    # @param min
    # a value greater than 0.
    # @see org.eclipse.swt.widgets.Scale#setMinimum(int)
    def set_minimum(min)
      @min_value = min
      update_scale
    end
    
    typesig { [::Java::Int] }
    # Set the value to be used for Scale.setPageIncrement(int) and update the
    # scale.
    # 
    # @param pageIncrement
    # a value greater than 0.
    # @see org.eclipse.swt.widgets.Scale#setPageIncrement(int)
    def set_page_increment(page_increment)
      @page_increment_value = page_increment
      update_scale
    end
    
    typesig { [::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int] }
    # Set all Scale values.
    # 
    # @param min
    # the value used for Scale.setMinimum(int).
    # @param max
    # the value used for Scale.setMaximum(int).
    # @param increment
    # the value used for Scale.setIncrement(int).
    # @param pageIncrement
    # the value used for Scale.setPageIncrement(int).
    def set_values(min, max, increment, page_increment)
      @increment_value = increment
      @max_value = max
      @min_value = min
      @page_increment_value = page_increment
      update_scale
    end
    
    typesig { [] }
    # Update the scale particulars with set values.
    def update_scale
      if (!(@scale).nil? && !@scale.is_disposed)
        @scale.set_minimum(get_minimum)
        @scale.set_maximum(get_maximum)
        @scale.set_increment(get_increment)
        @scale.set_page_increment(get_page_increment)
      end
    end
    
    typesig { [] }
    # Informs this field editor's listener, if it has one, about a change to
    # the value (<code>VALUE</code> property) provided that the old and new
    # values are different.
    # <p>
    # This hook is <em>not</em> called when the scale is initialized (or
    # reset to the default value) from the preference store.
    # </p>
    def value_changed
      set_presents_default_value(false)
      new_value = @scale.get_selection
      if (!(new_value).equal?(@old_value))
        fire_state_changed(IS_VALID, false, true)
        fire_value_changed(VALUE, @old_value, new_value)
        @old_value = new_value
      end
    end
    
    private
    alias_method :initialize__scale_field_editor, :initialize
  end
  
end
