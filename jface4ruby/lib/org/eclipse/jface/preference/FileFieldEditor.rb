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
  module FileFieldEditorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Preference
      include_const ::Java::Io, :JavaFile
      include_const ::Org::Eclipse::Jface::Resource, :JFaceResources
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :FileDialog
    }
  end
  
  # A field editor for a file path type preference. A standard file
  # dialog appears when the user presses the change button.
  class FileFieldEditor < FileFieldEditorImports.const_get :StringButtonFieldEditor
    include_class_members FileFieldEditorImports
    
    # List of legal file extension suffixes, or <code>null</code>
    # for system defaults.
    attr_accessor :extensions
    alias_method :attr_extensions, :extensions
    undef_method :extensions
    alias_method :attr_extensions=, :extensions=
    undef_method :extensions=
    
    # Indicates whether the path must be absolute;
    # <code>false</code> by default.
    attr_accessor :enforce_absolute
    alias_method :attr_enforce_absolute, :enforce_absolute
    undef_method :enforce_absolute
    alias_method :attr_enforce_absolute=, :enforce_absolute=
    undef_method :enforce_absolute=
    
    typesig { [] }
    # Creates a new file field editor
    def initialize
      @extensions = nil
      @enforce_absolute = false
      super()
      @extensions = nil
      @enforce_absolute = false
    end
    
    typesig { [String, String, Composite] }
    # Creates a file field editor.
    # 
    # @param name the name of the preference this field editor works on
    # @param labelText the label text of the field editor
    # @param parent the parent of the field editor's control
    def initialize(name, label_text, parent)
      initialize__file_field_editor(name, label_text, false, parent)
    end
    
    typesig { [String, String, ::Java::Boolean, Composite] }
    # Creates a file field editor.
    # 
    # @param name the name of the preference this field editor works on
    # @param labelText the label text of the field editor
    # @param enforceAbsolute <code>true</code> if the file path
    # must be absolute, and <code>false</code> otherwise
    # @param parent the parent of the field editor's control
    def initialize(name, label_text, enforce_absolute, parent)
      initialize__file_field_editor(name, label_text, enforce_absolute, VALIDATE_ON_FOCUS_LOST, parent)
    end
    
    typesig { [String, String, ::Java::Boolean, ::Java::Int, Composite] }
    # Creates a file field editor.
    # 
    # @param name the name of the preference this field editor works on
    # @param labelText the label text of the field editor
    # @param enforceAbsolute <code>true</code> if the file path
    # must be absolute, and <code>false</code> otherwise
    # @param validationStrategy either {@link StringButtonFieldEditor#VALIDATE_ON_KEY_STROKE}
    # to perform on the fly checking, or {@link StringButtonFieldEditor#VALIDATE_ON_FOCUS_LOST}
    # (the default) to perform validation only after the text has been typed in
    # @param parent the parent of the field editor's control.
    # @since 3.4
    # @see StringButtonFieldEditor#VALIDATE_ON_KEY_STROKE
    # @see StringButtonFieldEditor#VALIDATE_ON_FOCUS_LOST
    def initialize(name, label_text, enforce_absolute, validation_strategy, parent)
      @extensions = nil
      @enforce_absolute = false
      super()
      @extensions = nil
      @enforce_absolute = false
      init(name, label_text)
      @enforce_absolute = enforce_absolute
      set_error_message(JFaceResources.get_string("FileFieldEditor.errorMessage")) # $NON-NLS-1$
      set_change_button_text(JFaceResources.get_string("openBrowse")) # $NON-NLS-1$
      set_validate_strategy(validation_strategy)
      create_control(parent)
    end
    
    typesig { [] }
    # (non-Javadoc)
    # Method declared on StringButtonFieldEditor.
    # Opens the file chooser dialog and returns the selected file.
    def change_pressed
      f = JavaFile.new(get_text_control.get_text)
      if (!f.exists)
        f = nil
      end
      d = get_file(f)
      if ((d).nil?)
        return nil
      end
      return d.get_absolute_path
    end
    
    typesig { [] }
    # (non-Javadoc)
    # Method declared on StringFieldEditor.
    # Checks whether the text input field specifies an existing file.
    def check_state
      msg = nil
      path = get_text_control.get_text
      if (!(path).nil?)
        path = RJava.cast_to_string(path.trim)
      else
        path = "" # $NON-NLS-1$
      end
      if ((path.length).equal?(0))
        if (!is_empty_string_allowed)
          msg = RJava.cast_to_string(get_error_message)
        end
      else
        file = JavaFile.new(path)
        if (file.is_file)
          if (@enforce_absolute && !file.is_absolute)
            msg = RJava.cast_to_string(JFaceResources.get_string("FileFieldEditor.errorMessage2")) # $NON-NLS-1$
          end
        else
          msg = RJava.cast_to_string(get_error_message)
        end
      end
      if (!(msg).nil?)
        # error
        show_error_message(msg)
        return false
      end
      # OK!
      clear_error_message
      return true
    end
    
    typesig { [JavaFile] }
    # Helper to open the file chooser dialog.
    # @param startingDirectory the directory to open the dialog on.
    # @return File The File the user selected or <code>null</code> if they
    # do not.
    def get_file(starting_directory)
      dialog = FileDialog.new(get_shell, SWT::OPEN | SWT::SHEET)
      if (!(starting_directory).nil?)
        dialog.set_file_name(starting_directory.get_path)
      end
      if (!(@extensions).nil?)
        dialog.set_filter_extensions(@extensions)
      end
      file = dialog.open
      if (!(file).nil?)
        file = RJava.cast_to_string(file.trim)
        if (file.length > 0)
          return JavaFile.new(file)
        end
      end
      return nil
    end
    
    typesig { [Array.typed(String)] }
    # Sets this file field editor's file extension filter.
    # 
    # @param extensions a list of file extension, or <code>null</code>
    # to set the filter to the system's default value
    def set_file_extensions(extensions)
      @extensions = extensions
    end
    
    private
    alias_method :initialize__file_field_editor, :initialize
  end
  
end
