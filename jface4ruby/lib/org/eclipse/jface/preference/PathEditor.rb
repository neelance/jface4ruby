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
  module PathEditorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Preference
      include_const ::Java::Io, :JavaFile
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :StringTokenizer
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :DirectoryDialog
    }
  end
  
  # A field editor to edit directory paths.
  class PathEditor < PathEditorImports.const_get :ListEditor
    include_class_members PathEditorImports
    
    # The last path, or <code>null</code> if none.
    attr_accessor :last_path
    alias_method :attr_last_path, :last_path
    undef_method :last_path
    alias_method :attr_last_path=, :last_path=
    undef_method :last_path=
    
    # The special label text for directory chooser,
    # or <code>null</code> if none.
    attr_accessor :dir_chooser_label_text
    alias_method :attr_dir_chooser_label_text, :dir_chooser_label_text
    undef_method :dir_chooser_label_text
    alias_method :attr_dir_chooser_label_text=, :dir_chooser_label_text=
    undef_method :dir_chooser_label_text=
    
    typesig { [] }
    # Creates a new path field editor
    def initialize
      @last_path = nil
      @dir_chooser_label_text = nil
      super()
    end
    
    typesig { [String, String, String, Composite] }
    # Creates a path field editor.
    # 
    # @param name the name of the preference this field editor works on
    # @param labelText the label text of the field editor
    # @param dirChooserLabelText the label text displayed for the directory chooser
    # @param parent the parent of the field editor's control
    def initialize(name, label_text, dir_chooser_label_text, parent)
      @last_path = nil
      @dir_chooser_label_text = nil
      super()
      init(name, label_text)
      @dir_chooser_label_text = dir_chooser_label_text
      create_control(parent)
    end
    
    typesig { [Array.typed(String)] }
    # (non-Javadoc)
    # Method declared on ListEditor.
    # Creates a single string from the given array by separating each
    # string with the appropriate OS-specific path separator.
    def create_list(items)
      path = StringBuffer.new("") # $NON-NLS-1$
      i = 0
      while i < items.attr_length
        path.append(items[i])
        path.append(JavaFile.attr_path_separator)
        i += 1
      end
      return path.to_s
    end
    
    typesig { [] }
    # (non-Javadoc)
    # Method declared on ListEditor.
    # Creates a new path element by means of a directory dialog.
    def get_new_input_object
      dialog = DirectoryDialog.new(get_shell, SWT::SHEET)
      if (!(@dir_chooser_label_text).nil?)
        dialog.set_message(@dir_chooser_label_text)
      end
      if (!(@last_path).nil?)
        if (JavaFile.new(@last_path).exists)
          dialog.set_filter_path(@last_path)
        end
      end
      dir = dialog.open
      if (!(dir).nil?)
        dir = RJava.cast_to_string(dir.trim)
        if ((dir.length).equal?(0))
          return nil
        end
        @last_path = dir
      end
      return dir
    end
    
    typesig { [String] }
    # (non-Javadoc)
    # Method declared on ListEditor.
    def parse_string(string_list)
      st = StringTokenizer.new(string_list, RJava.cast_to_string(JavaFile.attr_path_separator) + "\n\r") # $NON-NLS-1$
      v = ArrayList.new
      while (st.has_more_elements)
        v.add(st.next_element)
      end
      return v.to_array(Array.typed(String).new(v.size) { nil })
    end
    
    private
    alias_method :initialize__path_editor, :initialize
  end
  
end
