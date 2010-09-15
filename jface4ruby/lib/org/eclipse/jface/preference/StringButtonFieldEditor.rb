require "rjava"

# Copyright (c) 2000, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
# Thierry Lach - thierry.lach@bbdodetroit.com - Fix for Bug 37155
module Org::Eclipse::Jface::Preference
  module StringButtonFieldEditorImports #:nodoc:
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
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Layout, :GridData
      include_const ::Org::Eclipse::Swt::Widgets, :Button
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Shell
    }
  end
  
  # An abstract field editor for a string type preference that presents
  # a string input field with a change button to its right to edit the
  # input field's content. When the user presses the change button, the
  # abstract framework method <code>changePressed()</code> gets called
  # to compute a new string.
  class StringButtonFieldEditor < StringButtonFieldEditorImports.const_get :StringFieldEditor
    include_class_members StringButtonFieldEditorImports
    
    # The change button, or <code>null</code> if none
    # (before creation and after disposal).
    attr_accessor :change_button
    alias_method :attr_change_button, :change_button
    undef_method :change_button
    alias_method :attr_change_button=, :change_button=
    undef_method :change_button=
    
    # The text for the change button, or <code>null</code> if missing.
    attr_accessor :change_button_text
    alias_method :attr_change_button_text, :change_button_text
    undef_method :change_button_text
    alias_method :attr_change_button_text=, :change_button_text=
    undef_method :change_button_text=
    
    typesig { [] }
    # Creates a new string button field editor
    def initialize
      @change_button = nil
      @change_button_text = nil
      super()
    end
    
    typesig { [String, String, Composite] }
    # Creates a string button field editor.
    # 
    # @param name the name of the preference this field editor works on
    # @param labelText the label text of the field editor
    # @param parent the parent of the field editor's control
    def initialize(name, label_text, parent)
      @change_button = nil
      @change_button_text = nil
      super()
      init(name, label_text)
      create_control(parent)
    end
    
    typesig { [::Java::Int] }
    # (non-Javadoc)
    # Method declared on FieldEditor.
    def adjust_for_num_columns(num_columns)
      (get_text_control.get_layout_data).attr_horizontal_span = num_columns - 2
    end
    
    typesig { [] }
    # Notifies that this field editor's change button has been pressed.
    # <p>
    # Subclasses must implement this method to provide a corresponding
    # new string for the text field. If the returned value is <code>null</code>,
    # the currently displayed value remains.
    # </p>
    # 
    # @return the new string to display, or <code>null</code> to leave the
    # old string showing
    def change_pressed
      raise NotImplementedError
    end
    
    typesig { [Composite, ::Java::Int] }
    # (non-Javadoc)
    # Method declared on StringFieldEditor (and FieldEditor).
    def do_fill_into_grid(parent, num_columns)
      super(parent, num_columns - 1)
      @change_button = get_change_control(parent)
      gd = GridData.new
      gd.attr_horizontal_alignment = GridData::FILL
      width_hint = convert_horizontal_dlus_to_pixels(@change_button, IDialogConstants::BUTTON_WIDTH)
      gd.attr_width_hint = Math.max(width_hint, @change_button.compute_size(SWT::DEFAULT, SWT::DEFAULT, true).attr_x)
      @change_button.set_layout_data(gd)
    end
    
    typesig { [Composite] }
    # Get the change control. Create it in parent if required.
    # @param parent
    # @return Button
    def get_change_control(parent)
      if ((@change_button).nil?)
        @change_button = Button.new(parent, SWT::PUSH)
        if ((@change_button_text).nil?)
          @change_button_text = RJava.cast_to_string(JFaceResources.get_string("openChange")) # $NON-NLS-1$
        end
        @change_button.set_text(@change_button_text)
        @change_button.set_font(parent.get_font)
        @change_button.add_selection_listener(Class.new(SelectionAdapter.class == Class ? SelectionAdapter : Object) do
          local_class_in StringButtonFieldEditor
          include_class_members StringButtonFieldEditor
          include SelectionAdapter if SelectionAdapter.class == Module
          
          typesig { [SelectionEvent] }
          define_method :widget_selected do |evt|
            new_value = change_pressed
            if (!(new_value).nil?)
              set_string_value(new_value)
            end
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
        @change_button.add_dispose_listener(Class.new(DisposeListener.class == Class ? DisposeListener : Object) do
          local_class_in StringButtonFieldEditor
          include_class_members StringButtonFieldEditor
          include DisposeListener if DisposeListener.class == Module
          
          typesig { [DisposeEvent] }
          define_method :widget_disposed do |event|
            self.attr_change_button = nil
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      else
        check_parent(@change_button, parent)
      end
      return @change_button
    end
    
    typesig { [] }
    # (non-Javadoc)
    # Method declared on FieldEditor.
    def get_number_of_controls
      return 3
    end
    
    typesig { [] }
    # Returns this field editor's shell.
    # 
    # @return the shell
    def get_shell
      if ((@change_button).nil?)
        return nil
      end
      return @change_button.get_shell
    end
    
    typesig { [String] }
    # Sets the text of the change button.
    # 
    # @param text the new text
    def set_change_button_text(text)
      Assert.is_not_null(text)
      @change_button_text = text
      if (!(@change_button).nil?)
        @change_button.set_text(text)
        pref_size = @change_button.compute_size(SWT::DEFAULT, SWT::DEFAULT)
        data = @change_button.get_layout_data
        data.attr_width_hint = Math.max(SWT::DEFAULT, pref_size.attr_x)
      end
    end
    
    typesig { [::Java::Boolean, Composite] }
    # (non-Javadoc)
    # @see org.eclipse.jface.preference.FieldEditor#setEnabled(boolean, org.eclipse.swt.widgets.Composite)
    def set_enabled(enabled, parent)
      super(enabled, parent)
      if (!(@change_button).nil?)
        @change_button.set_enabled(enabled)
      end
    end
    
    private
    alias_method :initialize__string_button_field_editor, :initialize
  end
  
end
