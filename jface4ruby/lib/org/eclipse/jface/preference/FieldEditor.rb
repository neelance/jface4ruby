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
  module FieldEditorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Preference
      include_const ::Org::Eclipse::Jface::Dialogs, :DialogPage
      include_const ::Org::Eclipse::Jface::Dialogs, :IDialogConstants
      include_const ::Org::Eclipse::Jface::Resource, :JFaceResources
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Jface::Util, :IPropertyChangeListener
      include_const ::Org::Eclipse::Jface::Util, :PropertyChangeEvent
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Events, :DisposeEvent
      include_const ::Org::Eclipse::Swt::Events, :DisposeListener
      include_const ::Org::Eclipse::Swt::Graphics, :FontMetrics
      include_const ::Org::Eclipse::Swt::Graphics, :SwtGC
      include_const ::Org::Eclipse::Swt::Layout, :GridData
      include_const ::Org::Eclipse::Swt::Layout, :GridLayout
      include_const ::Org::Eclipse::Swt::Widgets, :Button
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Label
    }
  end
  
  # Abstract base class for all field editors.
  # <p>
  # A field editor presents the value of a preference to the end
  # user. The value is loaded from a preference store; if
  # modified by the end user, the value is validated and eventually
  # stored back to the preference store. A field editor reports
  # an event when the value, or the validity of the value, changes.
  # </p>
  # <p>
  # Field editors should be used in conjunction with a field
  # editor preference page (<code>FieldEditorPreferencePage</code>)
  # which coordinates everything and provides the message line
  # which display messages emanating from the editor.
  # </p>
  # <p>
  # This package contains ready-to-use field editors for various
  # types of preferences:
  # <ul>
  # <li><code>BooleanFieldEditor</code> - booleans</li>
  # <li><code>IntegerFieldEditor</code> - integers</li>
  # <li><code>StringFieldEditor</code> - text strings</li>
  # <li><code>RadioGroupFieldEditor</code> - enumerations</li>
  # <li><code>ColorFieldEditor</code> - RGB colors</li>
  # <li><code>FontFieldEditor</code> - fonts</li>
  # <li><code>DirectoryFieldEditor</code> - directories</li>
  # <li><code>FileFieldEditor</code> - files</li>
  # <li><code>PathEditor</code> - paths</li>
  # </ul>
  # </p>
  class FieldEditor 
    include_class_members FieldEditorImports
    
    class_module.module_eval {
      # Property name constant (value <code>"field_editor_is_valid"</code>)
      # to signal a change in the validity of the value of this field editor.
      const_set_lazy(:IS_VALID) { "field_editor_is_valid" }
      const_attr_reader  :IS_VALID
      
      # $NON-NLS-1$
      # 
      # Property name constant (value <code>"field_editor_value"</code>)
      # to signal a change in the value of this field editor.
      const_set_lazy(:VALUE) { "field_editor_value" }
      const_attr_reader  :VALUE
      
      # $NON-NLS-1$
      # 
      # Gap between label and control.
      const_set_lazy(:HORIZONTAL_GAP) { 8 }
      const_attr_reader  :HORIZONTAL_GAP
    }
    
    # The preference store, or <code>null</code> if none.
    attr_accessor :preference_store
    alias_method :attr_preference_store, :preference_store
    undef_method :preference_store
    alias_method :attr_preference_store=, :preference_store=
    undef_method :preference_store=
    
    # The name of the preference displayed in this field editor.
    attr_accessor :preference_name
    alias_method :attr_preference_name, :preference_name
    undef_method :preference_name
    alias_method :attr_preference_name=, :preference_name=
    undef_method :preference_name=
    
    # Indicates whether the default value is currently displayed,
    # initially <code>false</code>.
    attr_accessor :is_default_presented
    alias_method :attr_is_default_presented, :is_default_presented
    undef_method :is_default_presented
    alias_method :attr_is_default_presented=, :is_default_presented=
    undef_method :is_default_presented=
    
    # The label's text.
    attr_accessor :label_text
    alias_method :attr_label_text, :label_text
    undef_method :label_text
    alias_method :attr_label_text=, :label_text=
    undef_method :label_text=
    
    # The label control.
    attr_accessor :label
    alias_method :attr_label, :label
    undef_method :label
    alias_method :attr_label=, :label=
    undef_method :label=
    
    # Listener, or <code>null</code> if none
    attr_accessor :property_change_listener
    alias_method :attr_property_change_listener, :property_change_listener
    undef_method :property_change_listener
    alias_method :attr_property_change_listener=, :property_change_listener=
    undef_method :property_change_listener=
    
    # The page containing this field editor
    attr_accessor :page
    alias_method :attr_page, :page
    undef_method :page
    alias_method :attr_page=, :page=
    undef_method :page=
    
    typesig { [] }
    # Creates a new field editor.
    def initialize
      @preference_store = nil
      @preference_name = nil
      @is_default_presented = false
      @label_text = nil
      @label = nil
      @property_change_listener = nil
      @page = nil
    end
    
    typesig { [String, String, Composite] }
    # Creates a new field editor.
    # 
    # @param name the name of the preference this field editor works on
    # @param labelText the label text of the field editor
    # @param parent the parent of the field editor's control
    def initialize(name, label_text, parent)
      @preference_store = nil
      @preference_name = nil
      @is_default_presented = false
      @label_text = nil
      @label = nil
      @property_change_listener = nil
      @page = nil
      init(name, label_text)
      create_control(parent)
    end
    
    typesig { [::Java::Int] }
    # Adjusts the horizontal span of this field editor's basic controls.
    # <p>
    # Subclasses must implement this method to adjust the horizontal span
    # of controls so they appear correct in the given number of columns.
    # </p>
    # <p>
    # The number of columns will always be equal to or greater than the
    # value returned by this editor's <code>getNumberOfControls</code> method.
    # 
    # @param numColumns the number of columns
    def adjust_for_num_columns(num_columns)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Applies a font.
    # <p>
    # The default implementation of this framework method
    # does nothing. Subclasses should override this method
    # if they want to change the font of the SWT control to
    # a value different than the standard dialog font.
    # </p>
    def apply_font
    end
    
    typesig { [Control, Composite] }
    # Checks if the given parent is the current parent of the
    # supplied control; throws an (unchecked) exception if they
    # are not correctly related.
    # 
    # @param control the control
    # @param parent the parent control
    def check_parent(control, parent)
      Assert.is_true((control.get_parent).equal?(parent), "Different parents") # $NON-NLS-1$
    end
    
    typesig { [] }
    # Clears the error message from the message line.
    def clear_error_message
      if (!(@page).nil?)
        @page.set_error_message(nil)
      end
    end
    
    typesig { [] }
    # Clears the normal message from the message line.
    def clear_message
      if (!(@page).nil?)
        @page.set_message(nil)
      end
    end
    
    typesig { [Control, ::Java::Int] }
    # Returns the number of pixels corresponding to the
    # given number of horizontal dialog units.
    # <p>
    # Clients may call this framework method, but should not override it.
    # </p>
    # 
    # @param control the control being sized
    # @param dlus the number of horizontal dialog units
    # @return the number of pixels
    def convert_horizontal_dlus_to_pixels(control, dlus)
      gc = SwtGC.new(control)
      gc.set_font(control.get_font)
      average_width = gc.get_font_metrics.get_average_char_width
      gc.dispose
      horizontal_dialog_unit_size = average_width * 0.25
      return RJava.cast_to_int(Math.round(dlus * horizontal_dialog_unit_size))
    end
    
    typesig { [Control, ::Java::Int] }
    # Returns the number of pixels corresponding to the
    # given number of vertical dialog units.
    # <p>
    # Clients may call this framework method, but should not override it.
    # </p>
    # 
    # @param control the control being sized
    # @param dlus the number of vertical dialog units
    # @return the number of pixels
    def convert_vertical_dlus_to_pixels(control, dlus)
      gc = SwtGC.new(control)
      gc.set_font(control.get_font)
      height = gc.get_font_metrics.get_height
      gc.dispose
      vertical_dialog_unit_size = height * 0.125
      return RJava.cast_to_int(Math.round(dlus * vertical_dialog_unit_size))
    end
    
    typesig { [Composite] }
    # Creates this field editor's main control containing all of its
    # basic controls.
    # 
    # @param parent the parent control
    def create_control(parent)
      layout = GridLayout.new
      layout.attr_num_columns = get_number_of_controls
      layout.attr_margin_width = 0
      layout.attr_margin_height = 0
      layout.attr_horizontal_spacing = HORIZONTAL_GAP
      parent.set_layout(layout)
      do_fill_into_grid(parent, layout.attr_num_columns)
    end
    
    typesig { [] }
    # Disposes the SWT resources used by this field editor.
    def dispose
      # nothing to dispose
    end
    
    typesig { [Composite, ::Java::Int] }
    # Fills this field editor's basic controls into the given parent.
    # <p>
    # Subclasses must implement this method to create the controls
    # for this field editor.
    # </p>
    # <p>
    # Note this method may be called by the constructor, so it must not access
    # fields on the receiver object because they will not be fully initialized.
    # </p>
    # 
    # @param parent the composite used as a parent for the basic controls;
    # the parent's layout must be a <code>GridLayout</code>
    # @param numColumns the number of columns
    def do_fill_into_grid(parent, num_columns)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Initializes this field editor with the preference value from
    # the preference store.
    # <p>
    # Subclasses must implement this method to properly initialize
    # the field editor.
    # </p>
    def do_load
      raise NotImplementedError
    end
    
    typesig { [] }
    # Initializes this field editor with the default preference value from
    # the preference store.
    # <p>
    # Subclasses must implement this method to properly initialize
    # the field editor.
    # </p>
    def do_load_default
      raise NotImplementedError
    end
    
    typesig { [] }
    # Stores the preference value from this field editor into
    # the preference store.
    # <p>
    # Subclasses must implement this method to save the entered value
    # into the preference store.
    # </p>
    def do_store
      raise NotImplementedError
    end
    
    typesig { [Composite, ::Java::Int] }
    # Fills this field editor's basic controls into the given parent.
    # 
    # @param parent the composite used as a parent for the basic controls;
    # the parent's layout must be a <code>GridLayout</code>
    # @param numColumns the number of columns
    def fill_into_grid(parent, num_columns)
      Assert.is_true(num_columns >= get_number_of_controls)
      Assert.is_true(parent.get_layout.is_a?(GridLayout))
      do_fill_into_grid(parent, num_columns)
    end
    
    typesig { [String, ::Java::Boolean, ::Java::Boolean] }
    # Informs this field editor's listener, if it has one, about a change to
    # one of this field editor's boolean-valued properties. Does nothing
    # if the old and new values are the same.
    # 
    # @param property the field editor property name,
    # such as <code>VALUE</code> or <code>IS_VALID</code>
    # @param oldValue the old value
    # @param newValue the new value
    def fire_state_changed(property, old_value, new_value)
      if ((old_value).equal?(new_value))
        return
      end
      fire_value_changed(property, old_value ? Boolean::TRUE : Boolean::FALSE, new_value ? Boolean::TRUE : Boolean::FALSE)
    end
    
    typesig { [String, Object, Object] }
    # Informs this field editor's listener, if it has one, about a change to
    # one of this field editor's properties.
    # 
    # @param property the field editor property name,
    # such as <code>VALUE</code> or <code>IS_VALID</code>
    # @param oldValue the old value object, or <code>null</code>
    # @param newValue the new value, or <code>null</code>
    def fire_value_changed(property, old_value, new_value)
      if ((@property_change_listener).nil?)
        return
      end
      @property_change_listener.property_change(PropertyChangeEvent.new(self, property, old_value, new_value))
    end
    
    typesig { [] }
    # Returns the symbolic font name used by this field editor.
    # 
    # @return the symbolic font name
    def get_field_editor_font_name
      return JFaceResources::DIALOG_FONT
    end
    
    typesig { [] }
    # Returns the label control.
    # 
    # @return the label control, or <code>null</code>
    # if no label control has been created
    def get_label_control
      return @label
    end
    
    typesig { [Composite] }
    # Returns this field editor's label component.
    # <p>
    # The label is created if it does not already exist
    # </p>
    # 
    # @param parent the parent
    # @return the label control
    def get_label_control(parent)
      if ((@label).nil?)
        @label = Label.new(parent, SWT::LEFT)
        @label.set_font(parent.get_font)
        text = get_label_text
        if (!(text).nil?)
          @label.set_text(text)
        end
        @label.add_dispose_listener(Class.new(DisposeListener.class == Class ? DisposeListener : Object) do
          local_class_in FieldEditor
          include_class_members FieldEditor
          include DisposeListener if DisposeListener.class == Module
          
          typesig { [DisposeEvent] }
          define_method :widget_disposed do |event|
            self.attr_label = nil
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      else
        check_parent(@label, parent)
      end
      return @label
    end
    
    typesig { [] }
    # Returns this field editor's label text.
    # 
    # @return the label text
    def get_label_text
      return @label_text
    end
    
    typesig { [] }
    # Returns the number of basic controls this field editor consists of.
    # 
    # @return the number of controls
    def get_number_of_controls
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the name of the preference this field editor operates on.
    # 
    # @return the name of the preference
    def get_preference_name
      return @preference_name
    end
    
    typesig { [] }
    # Returns the preference page in which this field editor
    # appears.
    # 
    # @return the preference page, or <code>null</code> if none
    # @deprecated use #getPage()
    def get_preference_page
      if (!(@page).nil? && @page.is_a?(PreferencePage))
        return @page
      end
      return nil
    end
    
    typesig { [] }
    # Return the DialogPage that the receiver is sending
    # updates to.
    # 
    # @return DialogPage or <code>null</code> if it
    # has not been set.
    # 
    # @since 3.1
    def get_page
      return @page
    end
    
    typesig { [] }
    # Returns the preference store used by this field editor.
    # 
    # @return the preference store, or <code>null</code> if none
    # @see #setPreferenceStore
    def get_preference_store
      return @preference_store
    end
    
    typesig { [String, String] }
    # Initialize the field editor with the given preference name and label.
    # 
    # @param name the name of the preference this field editor works on
    # @param text the label text of the field editor
    def init(name, text)
      Assert.is_not_null(name)
      Assert.is_not_null(text)
      @preference_name = name
      @label_text = text
    end
    
    typesig { [] }
    # Returns whether this field editor contains a valid value.
    # <p>
    # The default implementation of this framework method
    # returns <code>true</code>. Subclasses wishing to perform
    # validation should override both this method and
    # <code>refreshValidState</code>.
    # </p>
    # 
    # @return <code>true</code> if the field value is valid,
    # and <code>false</code> if invalid
    # @see #refreshValidState()
    def is_valid
      return true
    end
    
    typesig { [] }
    # Initializes this field editor with the preference value from
    # the preference store.
    def load
      if (!(@preference_store).nil?)
        @is_default_presented = false
        do_load
        refresh_valid_state
      end
    end
    
    typesig { [] }
    # Initializes this field editor with the default preference value
    # from the preference store.
    def load_default
      if (!(@preference_store).nil?)
        @is_default_presented = true
        do_load_default
        refresh_valid_state
      end
    end
    
    typesig { [] }
    # Returns whether this field editor currently presents the
    # default value for its preference.
    # 
    # @return <code>true</code> if the default value is presented,
    # and <code>false</code> otherwise
    def presents_default_value
      return @is_default_presented
    end
    
    typesig { [] }
    # Refreshes this field editor's valid state after a value change
    # and fires an <code>IS_VALID</code> property change event if
    # warranted.
    # <p>
    # The default implementation of this framework method does
    # nothing. Subclasses wishing to perform validation should override
    # both this method and <code>isValid</code>.
    # </p>
    # 
    # @see #isValid
    def refresh_valid_state
    end
    
    typesig { [] }
    # Sets the focus to this field editor.
    # <p>
    # The default implementation of this framework method
    # does nothing. Subclasses may reimplement.
    # </p>
    def set_focus
      # do nothing;
    end
    
    typesig { [String] }
    # Sets this field editor's label text.
    # The label is typically presented to the left of the entry field.
    # 
    # @param text the label text
    def set_label_text(text)
      Assert.is_not_null(text)
      @label_text = text
      if (!(@label).nil?)
        @label.set_text(text)
      end
    end
    
    typesig { [String] }
    # Sets the name of the preference this field editor operates on.
    # <p>
    # The ability to change this allows the same field editor object
    # to be reused for different preferences.
    # </p>
    # <p>
    # For example: <p>
    # <pre>
    # ...
    # editor.setPreferenceName("font");
    # editor.load();
    # </pre>
    # </p>
    # 
    # @param name the name of the preference
    def set_preference_name(name)
      @preference_name = name
    end
    
    typesig { [PreferencePage] }
    # Sets the preference page in which this field editor
    # appears.
    # 
    # @param preferencePage the preference page, or <code>null</code> if none
    # @deprecated use #setPage(DialogPage)
    def set_preference_page(preference_page)
      set_page(preference_page)
    end
    
    typesig { [DialogPage] }
    # Set the page to be the receiver.
    # @param dialogPage
    # 
    # @since 3.1
    def set_page(dialog_page)
      @page = dialog_page
    end
    
    typesig { [IPreferenceStore] }
    # Sets the preference store used by this field editor.
    # 
    # @param store the preference store, or <code>null</code> if none
    # @see #getPreferenceStore
    def set_preference_store(store)
      @preference_store = store
    end
    
    typesig { [::Java::Boolean] }
    # Sets whether this field editor is presenting the default value.
    # 
    # @param booleanValue <code>true</code> if the default value is being presented,
    # and <code>false</code> otherwise
    def set_presents_default_value(boolean_value)
      @is_default_presented = boolean_value
    end
    
    typesig { [IPropertyChangeListener] }
    # Sets or removes the property change listener for this field editor.
    # <p>
    # Note that field editors can support only a single listener.
    # </p>
    # 
    # @param listener a property change listener, or <code>null</code>
    # to remove
    def set_property_change_listener(listener)
      @property_change_listener = listener
    end
    
    typesig { [String] }
    # Shows the given error message in the page for this
    # field editor if it has one.
    # 
    # @param msg the error message
    def show_error_message(msg)
      if (!(@page).nil?)
        @page.set_error_message(msg)
      end
    end
    
    typesig { [String] }
    # Shows the given message in the page for this
    # field editor if it has one.
    # 
    # @param msg the message
    def show_message(msg)
      if (!(@page).nil?)
        @page.set_error_message(msg)
      end
    end
    
    typesig { [] }
    # Stores this field editor's value back into the preference store.
    def store
      if ((@preference_store).nil?)
        return
      end
      if (@is_default_presented)
        @preference_store.set_to_default(@preference_name)
      else
        do_store
      end
    end
    
    typesig { [Button] }
    # Set the GridData on button to be one that is spaced for the
    # current font.
    # @param button the button the data is being set on.
    def set_button_layout_data(button)
      data = GridData.new(GridData::HORIZONTAL_ALIGN_FILL)
      # Compute and store a font metric
      gc = SwtGC.new(button)
      gc.set_font(button.get_font)
      font_metrics = gc.get_font_metrics
      gc.dispose
      width_hint = Org::Eclipse::Jface::Dialogs::Dialog.convert_vertical_dlus_to_pixels(font_metrics, IDialogConstants::BUTTON_WIDTH)
      data.attr_width_hint = Math.max(width_hint, button.compute_size(SWT::DEFAULT, SWT::DEFAULT, true).attr_x)
      button.set_layout_data(data)
    end
    
    typesig { [::Java::Boolean, Composite] }
    # Set whether or not the controls in the field editor
    # are enabled.
    # @param enabled The enabled state.
    # @param parent The parent of the controls in the group.
    # Used to create the controls if required.
    def set_enabled(enabled, parent)
      get_label_control(parent).set_enabled(enabled)
    end
    
    private
    alias_method :initialize__field_editor, :initialize
  end
  
end
