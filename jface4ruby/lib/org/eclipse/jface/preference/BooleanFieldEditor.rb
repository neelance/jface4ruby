require "rjava"

# Copyright (c) 2000, 2009 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Preference
  module BooleanFieldEditorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Preference
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Events, :DisposeEvent
      include_const ::Org::Eclipse::Swt::Events, :DisposeListener
      include_const ::Org::Eclipse::Swt::Events, :SelectionAdapter
      include_const ::Org::Eclipse::Swt::Events, :SelectionEvent
      include_const ::Org::Eclipse::Swt::Layout, :GridData
      include_const ::Org::Eclipse::Swt::Widgets, :Button
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Label
    }
  end
  
  # A field editor for a boolean type preference.
  class BooleanFieldEditor < BooleanFieldEditorImports.const_get :FieldEditor
    include_class_members BooleanFieldEditorImports
    
    class_module.module_eval {
      # Style constant (value <code>0</code>) indicating the default layout where
      # the field editor's check box appears to the left of the label.
      const_set_lazy(:DEFAULT) { 0 }
      const_attr_reader  :DEFAULT
      
      # Style constant (value <code>1</code>) indicating a layout where the field
      # editor's label appears on the left with a check box on the right.
      const_set_lazy(:SEPARATE_LABEL) { 1 }
      const_attr_reader  :SEPARATE_LABEL
    }
    
    # Style bits. Either <code>DEFAULT</code> or <code>SEPARATE_LABEL</code>.
    attr_accessor :style
    alias_method :attr_style, :style
    undef_method :style
    alias_method :attr_style=, :style=
    undef_method :style=
    
    # The previously selected, or "before", value.
    attr_accessor :was_selected
    alias_method :attr_was_selected, :was_selected
    undef_method :was_selected
    alias_method :attr_was_selected=, :was_selected=
    undef_method :was_selected=
    
    # The checkbox control, or <code>null</code> if none.
    attr_accessor :check_box
    alias_method :attr_check_box, :check_box
    undef_method :check_box
    alias_method :attr_check_box=, :check_box=
    undef_method :check_box=
    
    typesig { [] }
    # Creates a new boolean field editor
    def initialize
      @style = 0
      @was_selected = false
      @check_box = nil
      super()
      @check_box = nil
    end
    
    typesig { [String, String, ::Java::Int, Composite] }
    # Creates a boolean field editor in the given style.
    # 
    # @param name
    # the name of the preference this field editor works on
    # @param labelText
    # the label text of the field editor
    # @param style
    # the style, either <code>DEFAULT</code> or
    # <code>SEPARATE_LABEL</code>
    # @param parent
    # the parent of the field editor's control
    # @see #DEFAULT
    # @see #SEPARATE_LABEL
    def initialize(name, label_text, style, parent)
      @style = 0
      @was_selected = false
      @check_box = nil
      super()
      @check_box = nil
      init(name, label_text)
      @style = style
      create_control(parent)
    end
    
    typesig { [String, String, Composite] }
    # Creates a boolean field editor in the default style.
    # 
    # @param name
    # the name of the preference this field editor works on
    # @param label
    # the label text of the field editor
    # @param parent
    # the parent of the field editor's control
    def initialize(name, label, parent)
      initialize__boolean_field_editor(name, label, DEFAULT, parent)
    end
    
    typesig { [::Java::Int] }
    # (non-Javadoc) Method declared on FieldEditor.
    def adjust_for_num_columns(num_columns)
      if ((@style).equal?(SEPARATE_LABEL))
        num_columns -= 1
      end
      (@check_box.get_layout_data).attr_horizontal_span = num_columns
    end
    
    typesig { [Composite, ::Java::Int] }
    # (non-Javadoc) Method declared on FieldEditor.
    def do_fill_into_grid(parent, num_columns)
      text = get_label_text
      case (@style)
      # $FALL-THROUGH$
      when SEPARATE_LABEL
        get_label_control(parent)
        num_columns -= 1
        text = RJava.cast_to_string(nil)
        @check_box = get_change_control(parent)
        gd = GridData.new
        gd.attr_horizontal_span = num_columns
        @check_box.set_layout_data(gd)
        if (!(text).nil?)
          @check_box.set_text(text)
        end
      else
        @check_box = get_change_control(parent)
        gd = GridData.new
        gd.attr_horizontal_span = num_columns
        @check_box.set_layout_data(gd)
        if (!(text).nil?)
          @check_box.set_text(text)
        end
      end
    end
    
    typesig { [Composite] }
    # Returns the control responsible for displaying this field editor's label.
    # This method can be used to set a tooltip for a
    # <code>BooleanFieldEditor</code>. Note that the normal pattern of
    # <code>getLabelControl(parent).setToolTipText(tooltipText)</code> does not
    # work for boolean field editors, as it can lead to duplicate text (see bug
    # 259952).
    # 
    # @param parent
    # the parent composite
    # @return the control responsible for displaying the label
    # 
    # @since 3.5
    def get_description_control(parent)
      if ((@style).equal?(SEPARATE_LABEL))
        return get_label_control(parent)
      end
      return get_change_control(parent)
    end
    
    typesig { [] }
    # (non-Javadoc) Method declared on FieldEditor. Loads the value from the
    # preference store and sets it to the check box.
    def do_load
      if (!(@check_box).nil?)
        value = get_preference_store.get_boolean(get_preference_name)
        @check_box.set_selection(value)
        @was_selected = value
      end
    end
    
    typesig { [] }
    # (non-Javadoc) Method declared on FieldEditor. Loads the default value
    # from the preference store and sets it to the check box.
    def do_load_default
      if (!(@check_box).nil?)
        value = get_preference_store.get_default_boolean(get_preference_name)
        @check_box.set_selection(value)
        @was_selected = value
      end
    end
    
    typesig { [] }
    # (non-Javadoc) Method declared on FieldEditor.
    def do_store
      get_preference_store.set_value(get_preference_name, @check_box.get_selection)
    end
    
    typesig { [] }
    # Returns this field editor's current value.
    # 
    # @return the value
    def get_boolean_value
      return @check_box.get_selection
    end
    
    typesig { [Composite] }
    # Returns the change button for this field editor.
    # 
    # @param parent
    # The Composite to create the receiver in.
    # 
    # @return the change button
    def get_change_control(parent)
      if ((@check_box).nil?)
        @check_box = Button.new(parent, SWT::CHECK | SWT::LEFT)
        @check_box.set_font(parent.get_font)
        @check_box.add_selection_listener(Class.new(SelectionAdapter.class == Class ? SelectionAdapter : Object) do
          extend LocalClass
          include_class_members BooleanFieldEditor
          include SelectionAdapter if SelectionAdapter.class == Module
          
          typesig { [SelectionEvent] }
          define_method :widget_selected do |e|
            is_selected = self.attr_check_box.get_selection
            value_changed(self.attr_was_selected, is_selected)
            self.attr_was_selected = is_selected
          end
          
          typesig { [] }
          define_method :initialize do
            super()
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
        @check_box.add_dispose_listener(Class.new(DisposeListener.class == Class ? DisposeListener : Object) do
          extend LocalClass
          include_class_members BooleanFieldEditor
          include DisposeListener if DisposeListener.class == Module
          
          typesig { [DisposeEvent] }
          define_method :widget_disposed do |event|
            self.attr_check_box = nil
          end
          
          typesig { [] }
          define_method :initialize do
            super()
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      else
        check_parent(@check_box, parent)
      end
      return @check_box
    end
    
    typesig { [] }
    # (non-Javadoc) Method declared on FieldEditor.
    def get_number_of_controls
      case (@style)
      when SEPARATE_LABEL
        return 2
      else
        return 1
      end
    end
    
    typesig { [] }
    # (non-Javadoc) Method declared on FieldEditor.
    def set_focus
      if (!(@check_box).nil?)
        @check_box.set_focus
      end
    end
    
    typesig { [String] }
    # (non-Javadoc) Method declared on FieldEditor.
    def set_label_text(text)
      super(text)
      label = get_label_control
      if ((label).nil? && !(@check_box).nil?)
        @check_box.set_text(text)
      end
    end
    
    typesig { [::Java::Boolean, ::Java::Boolean] }
    # Informs this field editor's listener, if it has one, about a change to
    # the value (<code>VALUE</code> property) provided that the old and new
    # values are different.
    # 
    # @param oldValue
    # the old value
    # @param newValue
    # the new value
    def value_changed(old_value, new_value)
      set_presents_default_value(false)
      if (!(old_value).equal?(new_value))
        fire_state_changed(VALUE, old_value, new_value)
      end
    end
    
    typesig { [::Java::Boolean, Composite] }
    # @see FieldEditor.setEnabled
    def set_enabled(enabled, parent)
      # Only call super if there is a label already
      if ((@style).equal?(SEPARATE_LABEL))
        super(enabled, parent)
      end
      get_change_control(parent).set_enabled(enabled)
    end
    
    private
    alias_method :initialize__boolean_field_editor, :initialize
  end
  
end
