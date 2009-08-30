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
  module StringFieldEditorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Preference
      include_const ::Org::Eclipse::Jface::Resource, :JFaceResources
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Events, :DisposeEvent
      include_const ::Org::Eclipse::Swt::Events, :DisposeListener
      include_const ::Org::Eclipse::Swt::Events, :FocusAdapter
      include_const ::Org::Eclipse::Swt::Events, :FocusEvent
      include_const ::Org::Eclipse::Swt::Events, :KeyAdapter
      include_const ::Org::Eclipse::Swt::Events, :KeyEvent
      include_const ::Org::Eclipse::Swt::Graphics, :GC
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Layout, :GridData
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Text
    }
  end
  
  # A field editor for a string type preference.
  # <p>
  # This class may be used as is, or subclassed as required.
  # </p>
  class StringFieldEditor < StringFieldEditorImports.const_get :FieldEditor
    include_class_members StringFieldEditorImports
    
    class_module.module_eval {
      # Validation strategy constant (value <code>0</code>) indicating that
      # the editor should perform validation after every key stroke.
      # 
      # @see #setValidateStrategy
      const_set_lazy(:VALIDATE_ON_KEY_STROKE) { 0 }
      const_attr_reader  :VALIDATE_ON_KEY_STROKE
      
      # Validation strategy constant (value <code>1</code>) indicating that
      # the editor should perform validation only when the text widget
      # loses focus.
      # 
      # @see #setValidateStrategy
      const_set_lazy(:VALIDATE_ON_FOCUS_LOST) { 1 }
      const_attr_reader  :VALIDATE_ON_FOCUS_LOST
      
      # Text limit constant (value <code>-1</code>) indicating unlimited
      # text limit and width.
      
      def unlimited
        defined?(@@unlimited) ? @@unlimited : @@unlimited= -1
      end
      alias_method :attr_unlimited, :unlimited
      
      def unlimited=(value)
        @@unlimited = value
      end
      alias_method :attr_unlimited=, :unlimited=
    }
    
    # Cached valid state.
    attr_accessor :is_valid
    alias_method :attr_is_valid, :is_valid
    undef_method :is_valid
    alias_method :attr_is_valid=, :is_valid=
    undef_method :is_valid=
    
    # Old text value.
    # @since 3.4 this field is protected.
    attr_accessor :old_value
    alias_method :attr_old_value, :old_value
    undef_method :old_value
    alias_method :attr_old_value=, :old_value=
    undef_method :old_value=
    
    # The text field, or <code>null</code> if none.
    attr_accessor :text_field
    alias_method :attr_text_field, :text_field
    undef_method :text_field
    alias_method :attr_text_field=, :text_field=
    undef_method :text_field=
    
    # Width of text field in characters; initially unlimited.
    attr_accessor :width_in_chars
    alias_method :attr_width_in_chars, :width_in_chars
    undef_method :width_in_chars
    alias_method :attr_width_in_chars=, :width_in_chars=
    undef_method :width_in_chars=
    
    # Text limit of text field in characters; initially unlimited.
    attr_accessor :text_limit
    alias_method :attr_text_limit, :text_limit
    undef_method :text_limit
    alias_method :attr_text_limit=, :text_limit=
    undef_method :text_limit=
    
    # The error message, or <code>null</code> if none.
    attr_accessor :error_message
    alias_method :attr_error_message, :error_message
    undef_method :error_message
    alias_method :attr_error_message=, :error_message=
    undef_method :error_message=
    
    # Indicates whether the empty string is legal;
    # <code>true</code> by default.
    attr_accessor :empty_string_allowed
    alias_method :attr_empty_string_allowed, :empty_string_allowed
    undef_method :empty_string_allowed
    alias_method :attr_empty_string_allowed=, :empty_string_allowed=
    undef_method :empty_string_allowed=
    
    # The validation strategy;
    # <code>VALIDATE_ON_KEY_STROKE</code> by default.
    attr_accessor :validate_strategy
    alias_method :attr_validate_strategy, :validate_strategy
    undef_method :validate_strategy
    alias_method :attr_validate_strategy=, :validate_strategy=
    undef_method :validate_strategy=
    
    typesig { [] }
    # Creates a new string field editor
    def initialize
      @is_valid = false
      @old_value = nil
      @text_field = nil
      @width_in_chars = 0
      @text_limit = 0
      @error_message = nil
      @empty_string_allowed = false
      @validate_strategy = 0
      super()
      @width_in_chars = self.attr_unlimited
      @text_limit = self.attr_unlimited
      @empty_string_allowed = true
      @validate_strategy = VALIDATE_ON_KEY_STROKE
    end
    
    typesig { [String, String, ::Java::Int, ::Java::Int, Composite] }
    # Creates a string field editor.
    # Use the method <code>setTextLimit</code> to limit the text.
    # 
    # @param name the name of the preference this field editor works on
    # @param labelText the label text of the field editor
    # @param width the width of the text input field in characters,
    # or <code>UNLIMITED</code> for no limit
    # @param strategy either <code>VALIDATE_ON_KEY_STROKE</code> to perform
    # on the fly checking (the default), or <code>VALIDATE_ON_FOCUS_LOST</code> to
    # perform validation only after the text has been typed in
    # @param parent the parent of the field editor's control
    # @since 2.0
    def initialize(name, label_text, width, strategy, parent)
      @is_valid = false
      @old_value = nil
      @text_field = nil
      @width_in_chars = 0
      @text_limit = 0
      @error_message = nil
      @empty_string_allowed = false
      @validate_strategy = 0
      super()
      @width_in_chars = self.attr_unlimited
      @text_limit = self.attr_unlimited
      @empty_string_allowed = true
      @validate_strategy = VALIDATE_ON_KEY_STROKE
      init(name, label_text)
      @width_in_chars = width
      set_validate_strategy(strategy)
      @is_valid = false
      @error_message = RJava.cast_to_string(JFaceResources.get_string("StringFieldEditor.errorMessage")) # $NON-NLS-1$
      create_control(parent)
    end
    
    typesig { [String, String, ::Java::Int, Composite] }
    # Creates a string field editor.
    # Use the method <code>setTextLimit</code> to limit the text.
    # 
    # @param name the name of the preference this field editor works on
    # @param labelText the label text of the field editor
    # @param width the width of the text input field in characters,
    # or <code>UNLIMITED</code> for no limit
    # @param parent the parent of the field editor's control
    def initialize(name, label_text, width, parent)
      initialize__string_field_editor(name, label_text, width, VALIDATE_ON_KEY_STROKE, parent)
    end
    
    typesig { [String, String, Composite] }
    # Creates a string field editor of unlimited width.
    # Use the method <code>setTextLimit</code> to limit the text.
    # 
    # @param name the name of the preference this field editor works on
    # @param labelText the label text of the field editor
    # @param parent the parent of the field editor's control
    def initialize(name, label_text, parent)
      initialize__string_field_editor(name, label_text, self.attr_unlimited, parent)
    end
    
    typesig { [::Java::Int] }
    # (non-Javadoc)
    # Method declared on FieldEditor.
    def adjust_for_num_columns(num_columns)
      gd = @text_field.get_layout_data
      gd.attr_horizontal_span = num_columns - 1
      # We only grab excess space if we have to
      # If another field editor has more columns then
      # we assume it is setting the width.
      gd.attr_grab_excess_horizontal_space = (gd.attr_horizontal_span).equal?(1)
    end
    
    typesig { [] }
    # Checks whether the text input field contains a valid value or not.
    # 
    # @return <code>true</code> if the field value is valid,
    # and <code>false</code> if invalid
    def check_state
      result = false
      if (@empty_string_allowed)
        result = true
      end
      if ((@text_field).nil?)
        result = false
      end
      txt = @text_field.get_text
      result = (txt.trim.length > 0) || @empty_string_allowed
      # call hook for subclasses
      result = result && do_check_state
      if (result)
        clear_error_message
      else
        show_error_message(@error_message)
      end
      return result
    end
    
    typesig { [] }
    # Hook for subclasses to do specific state checks.
    # <p>
    # The default implementation of this framework method does
    # nothing and returns <code>true</code>.  Subclasses should
    # override this method to specific state checks.
    # </p>
    # 
    # @return <code>true</code> if the field value is valid,
    # and <code>false</code> if invalid
    def do_check_state
      return true
    end
    
    typesig { [Composite, ::Java::Int] }
    # Fills this field editor's basic controls into the given parent.
    # <p>
    # The string field implementation of this <code>FieldEditor</code>
    # framework method contributes the text field. Subclasses may override
    # but must call <code>super.doFillIntoGrid</code>.
    # </p>
    def do_fill_into_grid(parent, num_columns)
      get_label_control(parent)
      @text_field = get_text_control(parent)
      gd = GridData.new
      gd.attr_horizontal_span = num_columns - 1
      if (!(@width_in_chars).equal?(self.attr_unlimited))
        gc = GC.new(@text_field)
        begin
          extent = gc.text_extent("X") # $NON-NLS-1$
          gd.attr_width_hint = @width_in_chars * extent.attr_x
        ensure
          gc.dispose
        end
      else
        gd.attr_horizontal_alignment = GridData::FILL
        gd.attr_grab_excess_horizontal_space = true
      end
      @text_field.set_layout_data(gd)
    end
    
    typesig { [] }
    # (non-Javadoc)
    # Method declared on FieldEditor.
    def do_load
      if (!(@text_field).nil?)
        value = get_preference_store.get_string(get_preference_name)
        @text_field.set_text(value)
        @old_value = value
      end
    end
    
    typesig { [] }
    # (non-Javadoc)
    # Method declared on FieldEditor.
    def do_load_default
      if (!(@text_field).nil?)
        value = get_preference_store.get_default_string(get_preference_name)
        @text_field.set_text(value)
      end
      value_changed
    end
    
    typesig { [] }
    # (non-Javadoc)
    # Method declared on FieldEditor.
    def do_store
      get_preference_store.set_value(get_preference_name, @text_field.get_text)
    end
    
    typesig { [] }
    # Returns the error message that will be displayed when and if
    # an error occurs.
    # 
    # @return the error message, or <code>null</code> if none
    def get_error_message
      return @error_message
    end
    
    typesig { [] }
    # (non-Javadoc)
    # Method declared on FieldEditor.
    def get_number_of_controls
      return 2
    end
    
    typesig { [] }
    # Returns the field editor's value.
    # 
    # @return the current value
    def get_string_value
      if (!(@text_field).nil?)
        return @text_field.get_text
      end
      return get_preference_store.get_string(get_preference_name)
    end
    
    typesig { [] }
    # Returns this field editor's text control.
    # 
    # @return the text control, or <code>null</code> if no
    # text field is created yet
    def get_text_control
      return @text_field
    end
    
    typesig { [Composite] }
    # Returns this field editor's text control.
    # <p>
    # The control is created if it does not yet exist
    # </p>
    # 
    # @param parent the parent
    # @return the text control
    def get_text_control(parent)
      if ((@text_field).nil?)
        @text_field = Text.new(parent, SWT::SINGLE | SWT::BORDER)
        @text_field.set_font(parent.get_font)
        case (@validate_strategy)
        when VALIDATE_ON_KEY_STROKE
          @text_field.add_key_listener(Class.new(KeyAdapter.class == Class ? KeyAdapter : Object) do
            extend LocalClass
            include_class_members StringFieldEditor
            include KeyAdapter if KeyAdapter.class == Module
            
            typesig { [KeyEvent] }
            # (non-Javadoc)
            # @see org.eclipse.swt.events.KeyAdapter#keyReleased(org.eclipse.swt.events.KeyEvent)
            define_method :key_released do |e|
              value_changed
            end
            
            typesig { [Object] }
            define_method :initialize do |*args|
              super(*args)
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
          @text_field.add_focus_listener(Class.new(FocusAdapter.class == Class ? FocusAdapter : Object) do
            extend LocalClass
            include_class_members StringFieldEditor
            include FocusAdapter if FocusAdapter.class == Module
            
            typesig { [FocusEvent] }
            # Ensure that the value is checked on focus loss in case we
            # missed a keyRelease or user hasn't released key.
            # See https://bugs.eclipse.org/bugs/show_bug.cgi?id=214716
            define_method :focus_lost do |e|
              value_changed
            end
            
            typesig { [Object] }
            define_method :initialize do |*args|
              super(*args)
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
        when VALIDATE_ON_FOCUS_LOST
          @text_field.add_key_listener(Class.new(KeyAdapter.class == Class ? KeyAdapter : Object) do
            extend LocalClass
            include_class_members StringFieldEditor
            include KeyAdapter if KeyAdapter.class == Module
            
            typesig { [KeyEvent] }
            define_method :key_pressed do |e|
              clear_error_message
            end
            
            typesig { [Object] }
            define_method :initialize do |*args|
              super(*args)
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
          @text_field.add_focus_listener(Class.new(FocusAdapter.class == Class ? FocusAdapter : Object) do
            extend LocalClass
            include_class_members StringFieldEditor
            include FocusAdapter if FocusAdapter.class == Module
            
            typesig { [FocusEvent] }
            define_method :focus_gained do |e|
              refresh_valid_state
            end
            
            typesig { [FocusEvent] }
            define_method :focus_lost do |e|
              value_changed
              clear_error_message
            end
            
            typesig { [Object] }
            define_method :initialize do |*args|
              super(*args)
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
        else
          Assert.is_true(false, "Unknown validate strategy")
        end # $NON-NLS-1$
        @text_field.add_dispose_listener(Class.new(DisposeListener.class == Class ? DisposeListener : Object) do
          extend LocalClass
          include_class_members StringFieldEditor
          include DisposeListener if DisposeListener.class == Module
          
          typesig { [DisposeEvent] }
          define_method :widget_disposed do |event|
            self.attr_text_field = nil
          end
          
          typesig { [Object] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
        if (@text_limit > 0)
          # Only set limits above 0 - see SWT spec
          @text_field.set_text_limit(@text_limit)
        end
      else
        check_parent(@text_field, parent)
      end
      return @text_field
    end
    
    typesig { [] }
    # Returns whether an empty string is a valid value.
    # 
    # @return <code>true</code> if an empty string is a valid value, and
    # <code>false</code> if an empty string is invalid
    # @see #setEmptyStringAllowed
    def is_empty_string_allowed
      return @empty_string_allowed
    end
    
    typesig { [] }
    # (non-Javadoc)
    # Method declared on FieldEditor.
    def is_valid
      return @is_valid
    end
    
    typesig { [] }
    # (non-Javadoc)
    # Method declared on FieldEditor.
    def refresh_valid_state
      @is_valid = check_state
    end
    
    typesig { [::Java::Boolean] }
    # Sets whether the empty string is a valid value or not.
    # 
    # @param b <code>true</code> if the empty string is allowed,
    # and <code>false</code> if it is considered invalid
    def set_empty_string_allowed(b)
      @empty_string_allowed = b
    end
    
    typesig { [String] }
    # Sets the error message that will be displayed when and if
    # an error occurs.
    # 
    # @param message the error message
    def set_error_message(message)
      @error_message = message
    end
    
    typesig { [] }
    # (non-Javadoc)
    # Method declared on FieldEditor.
    def set_focus
      if (!(@text_field).nil?)
        @text_field.set_focus
      end
    end
    
    typesig { [String] }
    # Sets this field editor's value.
    # 
    # @param value the new value, or <code>null</code> meaning the empty string
    def set_string_value(value)
      if (!(@text_field).nil?)
        if ((value).nil?)
          value = "" # $NON-NLS-1$
        end
        @old_value = RJava.cast_to_string(@text_field.get_text)
        if (!(@old_value == value))
          @text_field.set_text(value)
          value_changed
        end
      end
    end
    
    typesig { [::Java::Int] }
    # Sets this text field's text limit.
    # 
    # @param limit the limit on the number of character in the text
    # input field, or <code>UNLIMITED</code> for no limit
    def set_text_limit(limit)
      @text_limit = limit
      if (!(@text_field).nil?)
        @text_field.set_text_limit(limit)
      end
    end
    
    typesig { [::Java::Int] }
    # Sets the strategy for validating the text.
    # <p>
    # Calling this method has no effect after <code>createPartControl</code>
    # is called. Thus this method is really only useful for subclasses to call
    # in their constructor. However, it has public visibility for backward
    # compatibility.
    # </p>
    # 
    # @param value either <code>VALIDATE_ON_KEY_STROKE</code> to perform
    # on the fly checking (the default), or <code>VALIDATE_ON_FOCUS_LOST</code> to
    # perform validation only after the text has been typed in
    def set_validate_strategy(value)
      Assert.is_true((value).equal?(VALIDATE_ON_FOCUS_LOST) || (value).equal?(VALIDATE_ON_KEY_STROKE))
      @validate_strategy = value
    end
    
    typesig { [] }
    # Shows the error message set via <code>setErrorMessage</code>.
    def show_error_message
      show_error_message(@error_message)
    end
    
    typesig { [] }
    # Informs this field editor's listener, if it has one, about a change
    # to the value (<code>VALUE</code> property) provided that the old and
    # new values are different.
    # <p>
    # This hook is <em>not</em> called when the text is initialized
    # (or reset to the default value) from the preference store.
    # </p>
    def value_changed
      set_presents_default_value(false)
      old_state = @is_valid
      refresh_valid_state
      if (!(@is_valid).equal?(old_state))
        fire_state_changed(IS_VALID, old_state, @is_valid)
      end
      new_value = @text_field.get_text
      if (!(new_value == @old_value))
        fire_value_changed(VALUE, @old_value, new_value)
        @old_value = new_value
      end
    end
    
    typesig { [::Java::Boolean, Composite] }
    # @see FieldEditor.setEnabled(boolean,Composite).
    def set_enabled(enabled, parent)
      super(enabled, parent)
      get_text_control(parent).set_enabled(enabled)
    end
    
    private
    alias_method :initialize__string_field_editor, :initialize
  end
  
end
