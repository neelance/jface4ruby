require "rjava"

# Copyright (c) 2000, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Dialogs
  module IDialogSettingsImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Dialogs
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :Reader
      include_const ::Java::Io, :Writer
    }
  end
  
  # An interface to a storage mechanism for making dialog settings persistent.
  # The store manages a collection of key/value pairs. The keys must be strings
  # and the values can be either, strings or array of strings. Convenience API to
  # convert primitive types to strings is provided.
  module IDialogSettings
    include_class_members IDialogSettingsImports
    
    typesig { [String] }
    # Create a new section in the receiver and return it.
    # 
    # @param name
    # the name of the new section
    # @return the new section
    def add_new_section(name)
      raise NotImplementedError
    end
    
    typesig { [IDialogSettings] }
    # Add a section in the receiver.
    # 
    # @param section
    # the section to be added
    def add_section(section)
      raise NotImplementedError
    end
    
    typesig { [String] }
    # Returns the value of the given key in this dialog settings.
    # 
    # @param key
    # the key
    # @return the value, or <code>null</code> if none
    def get(key)
      raise NotImplementedError
    end
    
    typesig { [String] }
    # Returns the value, an array of strings, of the given key in this dialog
    # settings.
    # 
    # @param key
    # the key
    # @return the array of string, or <code>null</code> if none
    def get_array(key)
      raise NotImplementedError
    end
    
    typesig { [String] }
    # Convenience API. Convert the value of the given key in this dialog
    # settings to a boolean and return it.
    # 
    # @param key
    # the key
    # @return the boolean value, or <code>false</code> if none
    def get_boolean(key)
      raise NotImplementedError
    end
    
    typesig { [String] }
    # Convenience API. Convert the value of the given key in this dialog
    # settings to a double and return it.
    # 
    # @param key
    # the key
    # @return the value coverted to double, or throws
    # <code>NumberFormatException</code> if none
    # 
    # @exception NumberFormatException
    # if the string value does not contain a parsable number.
    # @see java.lang.Double#valueOf(java.lang.String)
    def get_double(key)
      raise NotImplementedError
    end
    
    typesig { [String] }
    # Convenience API. Convert the value of the given key in this dialog
    # settings to a float and return it.
    # 
    # @param key
    # the key
    # @return the value coverted to float, or throws
    # <code>NumberFormatException</code> if none
    # 
    # @exception NumberFormatException
    # if the string value does not contain a parsable number.
    # @see java.lang.Float#valueOf(java.lang.String)
    def get_float(key)
      raise NotImplementedError
    end
    
    typesig { [String] }
    # Convenience API. Convert the value of the given key in this dialog
    # settings to a int and return it.
    # 
    # @param key
    # the key
    # @return the value coverted to int, or throws
    # <code>NumberFormatException</code> if none
    # 
    # @exception NumberFormatException
    # if the string value does not contain a parsable number.
    # @see java.lang.Integer#valueOf(java.lang.String)
    def get_int(key)
      raise NotImplementedError
    end
    
    typesig { [String] }
    # Convenience API. Convert the value of the given key in this dialog
    # settings to a long and return it.
    # 
    # @param key
    # the key
    # @return the value coverted to long, or throws
    # <code>NumberFormatException</code> if none
    # 
    # @exception NumberFormatException
    # if the string value does not contain a parsable number.
    # @see java.lang.Long#valueOf(java.lang.String)
    def get_long(key)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the IDialogSettings name.
    # 
    # @return the name
    def get_name
      raise NotImplementedError
    end
    
    typesig { [String] }
    # Returns the section with the given name in this dialog settings.
    # 
    # @param sectionName
    # the key
    # @return IDialogSettings (the section), or <code>null</code> if none
    def get_section(section_name)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns all the sections in this dialog settings.
    # 
    # @return the section, or <code>null</code> if none
    def get_sections
      raise NotImplementedError
    end
    
    typesig { [Reader] }
    # Load a dialog settings from a stream and fill the receiver with its
    # content.
    # 
    # @param reader
    # a Reader specifying the stream where the settings are read
    # from.
    # @throws IOException
    def load(reader)
      raise NotImplementedError
    end
    
    typesig { [String] }
    # Load a dialog settings from a file and fill the receiver with its
    # content.
    # 
    # @param fileName
    # the name of the file the settings are read from.
    # @throws IOException
    def load(file_name)
      raise NotImplementedError
    end
    
    typesig { [String, Array.typed(String)] }
    # Adds the pair <code>key/value</code> to this dialog settings.
    # 
    # @param key
    # the key.
    # @param value
    # the value to be associated with the <code>key</code>
    def put(key, value)
      raise NotImplementedError
    end
    
    typesig { [String, ::Java::Double] }
    # Convenience API. Converts the double <code>value</code> to a string and
    # adds the pair <code>key/value</code> to this dialog settings.
    # 
    # @param key
    # the key.
    # @param value
    # the value to be associated with the <code>key</code>
    def put(key, value)
      raise NotImplementedError
    end
    
    typesig { [String, ::Java::Float] }
    # Convenience API. Converts the float <code>value</code> to a string and
    # adds the pair <code>key/value</code> to this dialog settings.
    # 
    # @param key
    # the key.
    # @param value
    # the value to be associated with the <code>key</code>
    def put(key, value)
      raise NotImplementedError
    end
    
    typesig { [String, ::Java::Int] }
    # Convenience API. Converts the int <code>value</code> to a string and
    # adds the pair <code>key/value</code> to this dialog settings.
    # 
    # @param key
    # the key.
    # @param value
    # the value to be associated with the <code>key</code>
    def put(key, value)
      raise NotImplementedError
    end
    
    typesig { [String, ::Java::Long] }
    # Convenience API. Converts the long <code>value</code> to a string and
    # adds the pair <code>key/value</code> to this dialog settings.
    # 
    # @param key
    # the key.
    # @param value
    # the value to be associated with the <code>key</code>
    def put(key, value)
      raise NotImplementedError
    end
    
    typesig { [String, String] }
    # Adds the pair <code>key/value</code> to this dialog settings.
    # 
    # @param key
    # the key.
    # @param value
    # the value to be associated with the <code>key</code>
    def put(key, value)
      raise NotImplementedError
    end
    
    typesig { [String, ::Java::Boolean] }
    # Convenience API. Converts the boolean <code>value</code> to a string
    # and adds the pair <code>key/value</code> to this dialog settings.
    # 
    # @param key
    # the key.
    # @param value
    # the value to be associated with the <code>key</code>
    def put(key, value)
      raise NotImplementedError
    end
    
    typesig { [Writer] }
    # Save a dialog settings to a stream
    # 
    # @param writer
    # a Writer specifying the stream the settings are written in.
    # @throws IOException
    def save(writer)
      raise NotImplementedError
    end
    
    typesig { [String] }
    # Save a dialog settings to a file.
    # 
    # @param fileName
    # the name of the file the settings are written in.
    # @throws IOException
    def save(file_name)
      raise NotImplementedError
    end
  end
  
end
