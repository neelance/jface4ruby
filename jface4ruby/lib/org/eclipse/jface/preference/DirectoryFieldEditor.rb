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
  module DirectoryFieldEditorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Preference
      include_const ::Java::Io, :JavaFile
      include_const ::Org::Eclipse::Jface::Resource, :JFaceResources
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :DirectoryDialog
    }
  end
  
  # A field editor for a directory path type preference. A standard directory
  # dialog appears when the user presses the change button.
  class DirectoryFieldEditor < DirectoryFieldEditorImports.const_get :StringButtonFieldEditor
    include_class_members DirectoryFieldEditorImports
    
    typesig { [] }
    # Creates a new directory field editor
    def initialize
      super()
    end
    
    typesig { [String, String, Composite] }
    # Creates a directory field editor.
    # 
    # @param name the name of the preference this field editor works on
    # @param labelText the label text of the field editor
    # @param parent the parent of the field editor's control
    def initialize(name, label_text, parent)
      super()
      init(name, label_text)
      set_error_message(JFaceResources.get_string("DirectoryFieldEditor.errorMessage")) # $NON-NLS-1$
      set_change_button_text(JFaceResources.get_string("openBrowse")) # $NON-NLS-1$
      set_validate_strategy(VALIDATE_ON_FOCUS_LOST)
      create_control(parent)
    end
    
    typesig { [] }
    # (non-Javadoc)
    # Method declared on StringButtonFieldEditor.
    # Opens the directory chooser dialog and returns the selected directory.
    def change_pressed
      f = JavaFile.new(get_text_control.get_text)
      if (!f.exists)
        f = nil
      end
      d = get_directory(f)
      if ((d).nil?)
        return nil
      end
      return d.get_absolute_path
    end
    
    typesig { [] }
    # (non-Javadoc)
    # Method declared on StringFieldEditor.
    # Checks whether the text input field contains a valid directory.
    def do_check_state
      file_name = get_text_control.get_text
      file_name = RJava.cast_to_string(file_name.trim)
      if ((file_name.length).equal?(0) && is_empty_string_allowed)
        return true
      end
      file = JavaFile.new(file_name)
      return file.is_directory
    end
    
    typesig { [JavaFile] }
    # Helper that opens the directory chooser dialog.
    # @param startingDirectory The directory the dialog will open in.
    # @return File File or <code>null</code>.
    def get_directory(starting_directory)
      file_dialog = DirectoryDialog.new(get_shell, SWT::OPEN | SWT::SHEET)
      if (!(starting_directory).nil?)
        file_dialog.set_filter_path(starting_directory.get_path)
      end
      dir = file_dialog.open
      if (!(dir).nil?)
        dir = RJava.cast_to_string(dir.trim)
        if (dir.length > 0)
          return JavaFile.new(dir)
        end
      end
      return nil
    end
    
    private
    alias_method :initialize__directory_field_editor, :initialize
  end
  
end
