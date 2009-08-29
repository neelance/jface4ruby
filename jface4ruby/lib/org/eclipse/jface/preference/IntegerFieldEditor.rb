require "rjava"

# Copyright (c) 2000, 2007 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
# <sgandon@nds.com> - Fix for bug 109389 - IntegerFieldEditor
# does not fire property change all the time
module Org::Eclipse::Jface::Preference
  module IntegerFieldEditorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Preference
      include_const ::Org::Eclipse::Jface::Resource, :JFaceResources
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Text
    }
  end
  
  # A field editor for an integer type preference.
  class IntegerFieldEditor < IntegerFieldEditorImports.const_get :StringFieldEditor
    include_class_members IntegerFieldEditorImports
    
    attr_accessor :min_valid_value
    alias_method :attr_min_valid_value, :min_valid_value
    undef_method :min_valid_value
    alias_method :attr_min_valid_value=, :min_valid_value=
    undef_method :min_valid_value=
    
    attr_accessor :max_valid_value
    alias_method :attr_max_valid_value, :max_valid_value
    undef_method :max_valid_value
    alias_method :attr_max_valid_value=, :max_valid_value=
    undef_method :max_valid_value=
    
    class_module.module_eval {
      const_set_lazy(:DEFAULT_TEXT_LIMIT) { 10 }
      const_attr_reader  :DEFAULT_TEXT_LIMIT
    }
    
    typesig { [] }
    # Creates a new integer field editor
    def initialize
      @min_valid_value = 0
      @max_valid_value = 0
      super()
      @min_valid_value = 0
      @max_valid_value = JavaInteger::MAX_VALUE
    end
    
    typesig { [String, String, Composite] }
    # Creates an integer field editor.
    # 
    # @param name the name of the preference this field editor works on
    # @param labelText the label text of the field editor
    # @param parent the parent of the field editor's control
    def initialize(name, label_text, parent)
      initialize__integer_field_editor(name, label_text, parent, DEFAULT_TEXT_LIMIT)
    end
    
    typesig { [String, String, Composite, ::Java::Int] }
    # Creates an integer field editor.
    # 
    # @param name the name of the preference this field editor works on
    # @param labelText the label text of the field editor
    # @param parent the parent of the field editor's control
    # @param textLimit the maximum number of characters in the text.
    def initialize(name, label_text, parent, text_limit)
      @min_valid_value = 0
      @max_valid_value = 0
      super()
      @min_valid_value = 0
      @max_valid_value = JavaInteger::MAX_VALUE
      init(name, label_text)
      set_text_limit(text_limit)
      set_empty_string_allowed(false)
      set_error_message(JFaceResources.get_string("IntegerFieldEditor.errorMessage")) # $NON-NLS-1$
      create_control(parent)
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Sets the range of valid values for this field.
    # 
    # @param min the minimum allowed value (inclusive)
    # @param max the maximum allowed value (inclusive)
    def set_valid_range(min, max)
      @min_valid_value = min
      @max_valid_value = max
      # $NON-NLS-1$
      set_error_message(JFaceResources.format("IntegerFieldEditor.errorMessageRange", Array.typed(Object).new([min, max])))
    end
    
    typesig { [] }
    # (non-Javadoc)
    # Method declared on StringFieldEditor.
    # Checks whether the entered String is a valid integer or not.
    def check_state
      text = get_text_control
      if ((text).nil?)
        return false
      end
      number_string = text.get_text
      begin
        number = JavaInteger.value_of(number_string).int_value
        if (number >= @min_valid_value && number <= @max_valid_value)
          clear_error_message
          return true
        end
        show_error_message
        return false
      rescue NumberFormatException => e1
        show_error_message
      end
      return false
    end
    
    typesig { [] }
    # (non-Javadoc)
    # Method declared on FieldEditor.
    def do_load
      text = get_text_control
      if (!(text).nil?)
        value = get_preference_store.get_int(get_preference_name)
        text.set_text("" + RJava.cast_to_string(value)) # $NON-NLS-1$
        self.attr_old_value = "" + RJava.cast_to_string(value) # $NON-NLS-1$
      end
    end
    
    typesig { [] }
    # (non-Javadoc)
    # Method declared on FieldEditor.
    def do_load_default
      text = get_text_control
      if (!(text).nil?)
        value = get_preference_store.get_default_int(get_preference_name)
        text.set_text("" + RJava.cast_to_string(value)) # $NON-NLS-1$
      end
      value_changed
    end
    
    typesig { [] }
    # (non-Javadoc)
    # Method declared on FieldEditor.
    def do_store
      text = get_text_control
      if (!(text).nil?)
        i = text.get_text
        get_preference_store.set_value(get_preference_name, i.int_value)
      end
    end
    
    typesig { [] }
    # Returns this field editor's current value as an integer.
    # 
    # @return the value
    # @exception NumberFormatException if the <code>String</code> does not
    # contain a parsable integer
    def get_int_value
      return get_string_value.int_value
    end
    
    private
    alias_method :initialize__integer_field_editor, :initialize
  end
  
end
