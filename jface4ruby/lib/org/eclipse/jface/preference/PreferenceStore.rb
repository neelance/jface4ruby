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
  module PreferenceStoreImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Preference
      include_const ::Java::Io, :FileInputStream
      include_const ::Java::Io, :FileOutputStream
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :InputStream
      include_const ::Java::Io, :OutputStream
      include_const ::Java::Io, :PrintStream
      include_const ::Java::Io, :PrintWriter
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :Enumeration
      include_const ::Java::Util, :Properties
      include_const ::Org::Eclipse::Core::Commands::Common, :EventManager
      include_const ::Org::Eclipse::Jface::Resource, :JFaceResources
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Jface::Util, :IPropertyChangeListener
      include_const ::Org::Eclipse::Jface::Util, :PropertyChangeEvent
      include_const ::Org::Eclipse::Jface::Util, :SafeRunnable
    }
  end
  
  # A concrete preference store implementation based on an internal
  # <code>java.util.Properties</code> object, with support for persisting the
  # non-default preference values to files or streams.
  # <p>
  # This class was not designed to be subclassed.
  # </p>
  # 
  # @see IPreferenceStore
  # @noextend This class is not intended to be subclassed by clients.
  class PreferenceStore < PreferenceStoreImports.const_get :EventManager
    include_class_members PreferenceStoreImports
    overload_protected {
      include IPersistentPreferenceStore
    }
    
    # The mapping from preference name to preference value (represented as
    # strings).
    attr_accessor :properties
    alias_method :attr_properties, :properties
    undef_method :properties
    alias_method :attr_properties=, :properties=
    undef_method :properties=
    
    # The mapping from preference name to default preference value (represented
    # as strings); <code>null</code> if none.
    attr_accessor :default_properties
    alias_method :attr_default_properties, :default_properties
    undef_method :default_properties
    alias_method :attr_default_properties=, :default_properties=
    undef_method :default_properties=
    
    # Indicates whether a value as been changed by <code>setToDefault</code>
    # or <code>setValue</code>; initially <code>false</code>.
    attr_accessor :dirty
    alias_method :attr_dirty, :dirty
    undef_method :dirty
    alias_method :attr_dirty=, :dirty=
    undef_method :dirty=
    
    # The file name used by the <code>load</code> method to load a property
    # file. This filename is used to save the properties file when
    # <code>save</code> is called.
    attr_accessor :filename
    alias_method :attr_filename, :filename
    undef_method :filename
    alias_method :attr_filename=, :filename=
    undef_method :filename=
    
    typesig { [] }
    # Creates an empty preference store.
    # <p>
    # Use the methods <code>load(InputStream)</code> and
    # <code>save(InputStream)</code> to load and store this preference store.
    # </p>
    # 
    # @see #load(InputStream)
    # @see #save(OutputStream, String)
    def initialize
      @properties = nil
      @default_properties = nil
      @dirty = false
      @filename = nil
      super()
      @dirty = false
      @default_properties = Properties.new
      @properties = Properties.new(@default_properties)
    end
    
    typesig { [String] }
    # Creates an empty preference store that loads from and saves to the a
    # file.
    # <p>
    # Use the methods <code>load()</code> and <code>save()</code> to load
    # and store this preference store.
    # </p>
    # 
    # @param filename
    # the file name
    # @see #load()
    # @see #save()
    def initialize(filename)
      initialize__preference_store()
      Assert.is_not_null(filename)
      @filename = filename
    end
    
    typesig { [IPropertyChangeListener] }
    # (non-Javadoc) Method declared on IPreferenceStore.
    def add_property_change_listener(listener)
      add_listener_object(listener)
    end
    
    typesig { [String] }
    # (non-Javadoc) Method declared on IPreferenceStore.
    def contains(name)
      return (@properties.contains_key(name) || @default_properties.contains_key(name))
    end
    
    typesig { [String, Object, Object] }
    # (non-Javadoc) Method declared on IPreferenceStore.
    def fire_property_change_event(name, old_value, new_value)
      final_listeners = get_listeners
      # Do we need to fire an event.
      if (final_listeners.attr_length > 0 && ((old_value).nil? || !(old_value == new_value)))
        pe = PropertyChangeEvent.new(self, name, old_value, new_value)
        i = 0
        while i < final_listeners.attr_length
          l = final_listeners[i]
          SafeRunnable.run(Class.new(SafeRunnable.class == Class ? SafeRunnable : Object) do
            local_class_in PreferenceStore
            include_class_members PreferenceStore
            include SafeRunnable if SafeRunnable.class == Module
            
            typesig { [] }
            # $NON-NLS-1$
            define_method :run do
              l.property_change(pe)
            end
            
            typesig { [Vararg.new(Object)] }
            define_method :initialize do |*args|
              super(*args)
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self, JFaceResources.get_string("PreferenceStore.changeError")))
          (i += 1)
        end
      end
    end
    
    typesig { [String] }
    # (non-Javadoc) Method declared on IPreferenceStore.
    def get_boolean(name)
      return get_boolean(@properties, name)
    end
    
    typesig { [Properties, String] }
    # Helper function: gets boolean for a given name.
    # 
    # @param p
    # @param name
    # @return boolean
    def get_boolean(p, name)
      value = !(p).nil? ? p.get_property(name) : nil
      if ((value).nil?)
        return BOOLEAN_DEFAULT_DEFAULT
      end
      if ((value == IPreferenceStore::TRUE))
        return true
      end
      return false
    end
    
    typesig { [String] }
    # (non-Javadoc) Method declared on IPreferenceStore.
    def get_default_boolean(name)
      return get_boolean(@default_properties, name)
    end
    
    typesig { [String] }
    # (non-Javadoc) Method declared on IPreferenceStore.
    def get_default_double(name)
      return get_double(@default_properties, name)
    end
    
    typesig { [String] }
    # (non-Javadoc) Method declared on IPreferenceStore.
    def get_default_float(name)
      return get_float(@default_properties, name)
    end
    
    typesig { [String] }
    # (non-Javadoc) Method declared on IPreferenceStore.
    def get_default_int(name)
      return get_int(@default_properties, name)
    end
    
    typesig { [String] }
    # (non-Javadoc) Method declared on IPreferenceStore.
    def get_default_long(name)
      return get_long(@default_properties, name)
    end
    
    typesig { [String] }
    # (non-Javadoc) Method declared on IPreferenceStore.
    def get_default_string(name)
      return get_string(@default_properties, name)
    end
    
    typesig { [String] }
    # (non-Javadoc) Method declared on IPreferenceStore.
    def get_double(name)
      return get_double(@properties, name)
    end
    
    typesig { [Properties, String] }
    # Helper function: gets double for a given name.
    # 
    # @param p
    # @param name
    # @return double
    def get_double(p, name)
      value = !(p).nil? ? p.get_property(name) : nil
      if ((value).nil?)
        return DOUBLE_DEFAULT_DEFAULT
      end
      ival = DOUBLE_DEFAULT_DEFAULT
      begin
        ival = Double.new(value).double_value
      rescue NumberFormatException => e
      end
      return ival
    end
    
    typesig { [String] }
    # (non-Javadoc) Method declared on IPreferenceStore.
    def get_float(name)
      return get_float(@properties, name)
    end
    
    typesig { [Properties, String] }
    # Helper function: gets float for a given name.
    # 
    # @param p
    # @param name
    # @return float
    def get_float(p, name)
      value = !(p).nil? ? p.get_property(name) : nil
      if ((value).nil?)
        return FLOAT_DEFAULT_DEFAULT
      end
      ival = FLOAT_DEFAULT_DEFAULT
      begin
        ival = Float.new(value).float_value
      rescue NumberFormatException => e
      end
      return ival
    end
    
    typesig { [String] }
    # (non-Javadoc) Method declared on IPreferenceStore.
    def get_int(name)
      return get_int(@properties, name)
    end
    
    typesig { [Properties, String] }
    # Helper function: gets int for a given name.
    # 
    # @param p
    # @param name
    # @return int
    def get_int(p, name)
      value = !(p).nil? ? p.get_property(name) : nil
      if ((value).nil?)
        return INT_DEFAULT_DEFAULT
      end
      ival = 0
      begin
        ival = JavaInteger.parse_int(value)
      rescue NumberFormatException => e
      end
      return ival
    end
    
    typesig { [String] }
    # (non-Javadoc) Method declared on IPreferenceStore.
    def get_long(name)
      return get_long(@properties, name)
    end
    
    typesig { [Properties, String] }
    # Helper function: gets long for a given name.
    # 
    # @param p
    # the properties storage (may be <code>null</code>)
    # @param name
    # the name of the property
    # @return the long or a default value of if:
    # <ul>
    # <li>properties storage is <code>null</code></li>
    # <li>property is not found</li>
    # <li>property value is not a number</li>
    # </ul>
    # @see IPreferenceStore#LONG_DEFAULT_DEFAULT
    def get_long(p, name)
      value = !(p).nil? ? p.get_property(name) : nil
      if ((value).nil?)
        return LONG_DEFAULT_DEFAULT
      end
      ival = LONG_DEFAULT_DEFAULT
      begin
        ival = Long.parse_long(value)
      rescue NumberFormatException => e
      end
      return ival
    end
    
    typesig { [String] }
    # (non-Javadoc) Method declared on IPreferenceStore.
    def get_string(name)
      return get_string(@properties, name)
    end
    
    typesig { [Properties, String] }
    # Helper function: gets string for a given name.
    # 
    # @param p
    # the properties storage (may be <code>null</code>)
    # @param name
    # the name of the property
    # @return the value or a default value of if:
    # <ul>
    # <li>properties storage is <code>null</code></li>
    # <li>property is not found</li>
    # <li>property value is not a number</li>
    # </ul>
    # @see IPreferenceStore#STRING_DEFAULT_DEFAULT
    def get_string(p, name)
      value = !(p).nil? ? p.get_property(name) : nil
      if ((value).nil?)
        return STRING_DEFAULT_DEFAULT
      end
      return value
    end
    
    typesig { [String] }
    # (non-Javadoc) Method declared on IPreferenceStore.
    def is_default(name)
      return (!@properties.contains_key(name) && @default_properties.contains_key(name))
    end
    
    typesig { [PrintStream] }
    # Prints the contents of this preference store to the given print stream.
    # 
    # @param out
    # the print stream
    def list(out)
      @properties.list(out)
    end
    
    typesig { [PrintWriter] }
    # Prints the contents of this preference store to the given print writer.
    # 
    # @param out
    # the print writer
    def list(out)
      @properties.list(out)
    end
    
    typesig { [] }
    # Loads this preference store from the file established in the constructor
    # <code>PreferenceStore(java.lang.String)</code> (or by
    # <code>setFileName</code>). Default preference values are not affected.
    # 
    # @exception java.io.IOException
    # if there is a problem loading this store
    def load
      if ((@filename).nil?)
        raise IOException.new("File name not specified") # $NON-NLS-1$
      end
      in_ = FileInputStream.new(@filename)
      load(in_)
      in_.close
    end
    
    typesig { [InputStream] }
    # Loads this preference store from the given input stream. Default
    # preference values are not affected.
    # 
    # @param in
    # the input stream
    # @exception java.io.IOException
    # if there is a problem loading this store
    def load(in_)
      @properties.load(in_)
      @dirty = false
    end
    
    typesig { [] }
    # (non-Javadoc) Method declared on IPreferenceStore.
    def needs_saving
      return @dirty
    end
    
    typesig { [] }
    # Returns an enumeration of all preferences known to this store which have
    # current values other than their default value.
    # 
    # @return an array of preference names
    def preference_names
      list_ = ArrayList.new
      it = @properties.property_names
      while (it.has_more_elements)
        list_.add(it.next_element)
      end
      return list_.to_array(Array.typed(String).new(list_.size) { nil })
    end
    
    typesig { [String, String] }
    # (non-Javadoc) Method declared on IPreferenceStore.
    def put_value(name, value)
      old_value = get_string(name)
      if ((old_value).nil? || !(old_value == value))
        set_value(@properties, name, value)
        @dirty = true
      end
    end
    
    typesig { [IPropertyChangeListener] }
    # (non-Javadoc) Method declared on IPreferenceStore.
    def remove_property_change_listener(listener)
      remove_listener_object(listener)
    end
    
    typesig { [] }
    # Saves the non-default-valued preferences known to this preference store
    # to the file from which they were originally loaded.
    # 
    # @exception java.io.IOException
    # if there is a problem saving this store
    def save
      if ((@filename).nil?)
        raise IOException.new("File name not specified") # $NON-NLS-1$
      end
      out = nil
      begin
        out = FileOutputStream.new(@filename)
        save(out, nil)
      ensure
        if (!(out).nil?)
          out.close
        end
      end
    end
    
    typesig { [OutputStream, String] }
    # Saves this preference store to the given output stream. The given string
    # is inserted as header information.
    # 
    # @param out
    # the output stream
    # @param header
    # the header
    # @exception java.io.IOException
    # if there is a problem saving this store
    def save(out, header)
      @properties.store(out, header)
      @dirty = false
    end
    
    typesig { [String, ::Java::Double] }
    # (non-Javadoc) Method declared on IPreferenceStore.
    def set_default(name, value)
      set_value(@default_properties, name, value)
    end
    
    typesig { [String, ::Java::Float] }
    # (non-Javadoc) Method declared on IPreferenceStore.
    def set_default(name, value)
      set_value(@default_properties, name, value)
    end
    
    typesig { [String, ::Java::Int] }
    # (non-Javadoc) Method declared on IPreferenceStore.
    def set_default(name, value)
      set_value(@default_properties, name, value)
    end
    
    typesig { [String, ::Java::Long] }
    # (non-Javadoc) Method declared on IPreferenceStore.
    def set_default(name, value)
      set_value(@default_properties, name, value)
    end
    
    typesig { [String, String] }
    # (non-Javadoc) Method declared on IPreferenceStore.
    def set_default(name, value)
      set_value(@default_properties, name, value)
    end
    
    typesig { [String, ::Java::Boolean] }
    # (non-Javadoc) Method declared on IPreferenceStore.
    def set_default(name, value)
      set_value(@default_properties, name, value)
    end
    
    typesig { [String] }
    # Sets the name of the file used when loading and storing this preference
    # store.
    # <p>
    # Afterward, the methods <code>load()</code> and <code>save()</code>
    # can be used to load and store this preference store.
    # </p>
    # 
    # @param name
    # the file name
    # @see #load()
    # @see #save()
    def set_filename(name)
      @filename = name
    end
    
    typesig { [String] }
    # (non-Javadoc) Method declared on IPreferenceStore.
    def set_to_default(name)
      old_value = @properties.get(name)
      @properties.remove(name)
      @dirty = true
      new_value = nil
      if (!(@default_properties).nil?)
        new_value = @default_properties.get(name)
      end
      fire_property_change_event(name, old_value, new_value)
    end
    
    typesig { [String, ::Java::Double] }
    # (non-Javadoc) Method declared on IPreferenceStore.
    def set_value(name, value)
      old_value = get_double(name)
      if (!(old_value).equal?(value))
        set_value(@properties, name, value)
        @dirty = true
        fire_property_change_event(name, Double.new(old_value), Double.new(value))
      end
    end
    
    typesig { [String, ::Java::Float] }
    # (non-Javadoc) Method declared on IPreferenceStore.
    def set_value(name, value)
      old_value = get_float(name)
      if (!(old_value).equal?(value))
        set_value(@properties, name, value)
        @dirty = true
        fire_property_change_event(name, Float.new(old_value), Float.new(value))
      end
    end
    
    typesig { [String, ::Java::Int] }
    # (non-Javadoc) Method declared on IPreferenceStore.
    def set_value(name, value)
      old_value = get_int(name)
      if (!(old_value).equal?(value))
        set_value(@properties, name, value)
        @dirty = true
        fire_property_change_event(name, old_value, value)
      end
    end
    
    typesig { [String, ::Java::Long] }
    # (non-Javadoc) Method declared on IPreferenceStore.
    def set_value(name, value)
      old_value = get_long(name)
      if (!(old_value).equal?(value))
        set_value(@properties, name, value)
        @dirty = true
        fire_property_change_event(name, Long.new(old_value), Long.new(value))
      end
    end
    
    typesig { [String, String] }
    # (non-Javadoc) Method declared on IPreferenceStore.
    def set_value(name, value)
      old_value = get_string(name)
      if ((old_value).nil? || !(old_value == value))
        set_value(@properties, name, value)
        @dirty = true
        fire_property_change_event(name, old_value, value)
      end
    end
    
    typesig { [String, ::Java::Boolean] }
    # (non-Javadoc) Method declared on IPreferenceStore.
    def set_value(name, value)
      old_value = get_boolean(name)
      if (!(old_value).equal?(value))
        set_value(@properties, name, value)
        @dirty = true
        fire_property_change_event(name, old_value ? Boolean::TRUE : Boolean::FALSE, value ? Boolean::TRUE : Boolean::FALSE)
      end
    end
    
    typesig { [Properties, String, ::Java::Double] }
    # Helper method: sets value for a given name.
    # 
    # @param p
    # @param name
    # @param value
    def set_value(p, name, value)
      Assert.is_true(!(p).nil?)
      p.put(name, Double.to_s(value))
    end
    
    typesig { [Properties, String, ::Java::Float] }
    # Helper method: sets value for a given name.
    # 
    # @param p
    # @param name
    # @param value
    def set_value(p, name, value)
      Assert.is_true(!(p).nil?)
      p.put(name, Float.to_s(value))
    end
    
    typesig { [Properties, String, ::Java::Int] }
    # Helper method: sets value for a given name.
    # 
    # @param p
    # @param name
    # @param value
    def set_value(p, name, value)
      Assert.is_true(!(p).nil?)
      p.put(name, JavaInteger.to_s(value))
    end
    
    typesig { [Properties, String, ::Java::Long] }
    # Helper method: sets the value for a given name.
    # 
    # @param p
    # @param name
    # @param value
    def set_value(p, name, value)
      Assert.is_true(!(p).nil?)
      p.put(name, Long.to_s(value))
    end
    
    typesig { [Properties, String, String] }
    # Helper method: sets the value for a given name.
    # 
    # @param p
    # @param name
    # @param value
    def set_value(p, name, value)
      Assert.is_true(!(p).nil? && !(value).nil?)
      p.put(name, value)
    end
    
    typesig { [Properties, String, ::Java::Boolean] }
    # Helper method: sets the value for a given name.
    # 
    # @param p
    # @param name
    # @param value
    def set_value(p, name, value)
      Assert.is_true(!(p).nil?)
      p.put(name, (value).equal?(true) ? IPreferenceStore::TRUE : IPreferenceStore::FALSE)
    end
    
    private
    alias_method :initialize__preference_store, :initialize
  end
  
end
