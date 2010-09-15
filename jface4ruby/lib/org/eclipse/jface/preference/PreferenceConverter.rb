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
  module PreferenceConverterImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Preference
      include_const ::Java::Util, :Arrays
      include_const ::Java::Util, :StringTokenizer
      include_const ::Org::Eclipse::Jface::Resource, :JFaceResources
      include_const ::Org::Eclipse::Jface::Resource, :StringConverter
      include_const ::Org::Eclipse::Swt, :SWTException
      include_const ::Org::Eclipse::Swt::Graphics, :FontData
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Graphics, :RGB
      include_const ::Org::Eclipse::Swt::Graphics, :Rectangle
      include_const ::Org::Eclipse::Swt::Widgets, :Display
    }
  end
  
  # A utility class for dealing with preferences whose values are
  # common SWT objects (color, points, rectangles, and font data).
  # The static methods on this class handle the conversion between
  # the SWT objects and their string representations.
  # <p>
  # Usage:
  # <pre>
  # IPreferenceStore store = ...;
  # PreferenceConverter.setValue(store, "bg", new RGB(127,127,127));
  # ...
  # RBG bgColor = PreferenceConverter.getValue(store, "bg");
  # </pre>
  # </p>
  # <p>
  # This class contains static methods and fields only and cannot
  # be instantiated.
  # </p>
  # Note: touching this class has the side effect of creating a display (static initializer).
  # @noinstantiate This class is not intended to be instantiated by clients.
  class PreferenceConverter 
    include_class_members PreferenceConverterImports
    
    class_module.module_eval {
      # The default-default value for point preferences
      # (the origin, <code>(0,0)</code>).
      const_set_lazy(:POINT_DEFAULT_DEFAULT) { Point.new(0, 0) }
      const_attr_reader  :POINT_DEFAULT_DEFAULT
      
      # The default-default value for rectangle preferences
      # (the empty rectangle <code>(0,0,0,0)</code>).
      const_set_lazy(:RECTANGLE_DEFAULT_DEFAULT) { Rectangle.new(0, 0, 0, 0) }
      const_attr_reader  :RECTANGLE_DEFAULT_DEFAULT
      
      # The default-default value for color preferences
      # (black, <code>RGB(0,0,0)</code>).
      const_set_lazy(:COLOR_DEFAULT_DEFAULT) { RGB.new(0, 0, 0) }
      const_attr_reader  :COLOR_DEFAULT_DEFAULT
      
      const_set_lazy(:ENTRY_SEPARATOR) { ";" }
      const_attr_reader  :ENTRY_SEPARATOR
      
      when_class_loaded do
        display = Display.get_current
        if ((display).nil?)
          display = Display.get_default
        end
        const_set :FONTDATA_ARRAY_DEFAULT_DEFAULT, display.get_system_font.get_font_data
        # The default-default value for <code>FontData</code> preferences.
        # This is left in for compatibility purposes. It is recommended that
        # FONTDATA_ARRAY_DEFAULT_DEFAULT is actually used.
        const_set :FONTDATA_DEFAULT_DEFAULT, FONTDATA_ARRAY_DEFAULT_DEFAULT[0]
      end
    }
    
    typesig { [] }
    # (non-Javadoc)
    # private constructor to prevent instantiation.
    def initialize
      # no-op
    end
    
    class_module.module_eval {
      typesig { [String] }
      # Helper method to construct a color from the given string.
      # @param value the indentifier for the color
      # @return RGB
      def basic_get_color(value)
        if ((IPreferenceStore::STRING_DEFAULT_DEFAULT == value))
          return COLOR_DEFAULT_DEFAULT
        end
        color = StringConverter.as_rgb(value, nil)
        if ((color).nil?)
          return COLOR_DEFAULT_DEFAULT
        end
        return color
      end
      
      typesig { [String] }
      # Helper method to construct a <code>FontData</code> from the given string.
      # String is in the form FontData;FontData; in order that
      # multiple FontDatas can be defined.
      # @param value the identifier for the font
      # @return FontData[]
      # 
      # @since 3.0
      def basic_get_font_data(value)
        if ((IPreferenceStore::STRING_DEFAULT_DEFAULT == value))
          return FONTDATA_ARRAY_DEFAULT_DEFAULT
        end
        # Read in all of them to get the value
        tokenizer = StringTokenizer.new(value, ENTRY_SEPARATOR)
        num_tokens = tokenizer.count_tokens
        font_data = Array.typed(FontData).new(num_tokens) { nil }
        i = 0
        while i < num_tokens
          begin
            font_data[i] = FontData.new(tokenizer.next_token)
          rescue SWTException => error
            return FONTDATA_ARRAY_DEFAULT_DEFAULT
          rescue IllegalArgumentException => error
            return FONTDATA_ARRAY_DEFAULT_DEFAULT
          end
          i += 1
        end
        return font_data
      end
      
      typesig { [String] }
      # Reads the supplied string and returns its corresponding
      # FontData. If it cannot be read then the default FontData
      # will be returned.
      # 
      # @param fontDataValue the string value for the font data
      # @return the font data
      def read_font_data(font_data_value)
        return basic_get_font_data(font_data_value)
      end
      
      typesig { [String] }
      # Helper method to construct a point from the given string.
      # @param value
      # @return Point
      def basic_get_point(value)
        dp = Point.new(POINT_DEFAULT_DEFAULT.attr_x, POINT_DEFAULT_DEFAULT.attr_y)
        if ((IPreferenceStore::STRING_DEFAULT_DEFAULT == value))
          return dp
        end
        return StringConverter.as_point(value, dp)
      end
      
      typesig { [String] }
      # Helper method to construct a rectangle from the given string.
      # @param value
      # @return Rectangle
      def basic_get_rectangle(value)
        # We can't just return RECTANGLE_DEFAULT_DEFAULT because
        # a rectangle object doesn't have value semantik.
        dr = Rectangle.new(RECTANGLE_DEFAULT_DEFAULT.attr_x, RECTANGLE_DEFAULT_DEFAULT.attr_y, RECTANGLE_DEFAULT_DEFAULT.attr_width, RECTANGLE_DEFAULT_DEFAULT.attr_height)
        if ((IPreferenceStore::STRING_DEFAULT_DEFAULT == value))
          return dr
        end
        return StringConverter.as_rectangle(value, dr)
      end
      
      typesig { [IPreferenceStore, String] }
      # Returns the current value of the color-valued preference with the
      # given name in the given preference store.
      # Returns the default-default value (<code>COLOR_DEFAULT_DEFAULT</code>)
      # if there is no preference with the given name, or if the current value
      # cannot be treated as a color.
      # 
      # @param store the preference store
      # @param name the name of the preference
      # @return the color-valued preference
      def get_color(store, name)
        return basic_get_color(store.get_string(name))
      end
      
      typesig { [IPreferenceStore, String] }
      # Returns the default value for the color-valued preference
      # with the given name in the given preference store.
      # Returns the default-default value (<code>COLOR_DEFAULT_DEFAULT</code>)
      # is no default preference with the given name, or if the default
      # value cannot be treated as a color.
      # 
      # @param store the preference store
      # @param name the name of the preference
      # @return the default value of the preference
      def get_default_color(store, name)
        return basic_get_color(store.get_default_string(name))
      end
      
      typesig { [IPreferenceStore, String] }
      # Returns the default value array for the font-valued preference
      # with the given name in the given preference store.
      # Returns the default-default value (<code>FONTDATA_ARRAY_DEFAULT_DEFAULT</code>)
      # is no default preference with the given name, or if the default
      # value cannot be treated as font data.
      # 
      # @param store the preference store
      # @param name the name of the preference
      # @return the default value of the preference
      def get_default_font_data_array(store, name)
        return basic_get_font_data(store.get_default_string(name))
      end
      
      typesig { [IPreferenceStore, String] }
      # Returns a single default value for the font-valued preference
      # with the given name in the given preference store.
      # Returns the default-default value (<code>FONTDATA_DEFAULT_DEFAULT</code>)
      # is no default preference with the given name, or if the default
      # value cannot be treated as font data.
      # This method is provided for backwards compatibility. It is
      # recommended that <code>getDefaultFontDataArray</code> is
      # used instead.
      # 
      # @param store the preference store
      # @param name the name of the preference
      # @return the default value of the preference
      def get_default_font_data(store, name)
        return get_default_font_data_array(store, name)[0]
      end
      
      typesig { [IPreferenceStore, String] }
      # Returns the default value for the point-valued preference
      # with the given name in the given preference store.
      # Returns the default-default value (<code>POINT_DEFAULT_DEFAULT</code>)
      # is no default preference with the given name, or if the default
      # value cannot be treated as a point.
      # 
      # @param store the preference store
      # @param name the name of the preference
      # @return the default value of the preference
      def get_default_point(store, name)
        return basic_get_point(store.get_default_string(name))
      end
      
      typesig { [IPreferenceStore, String] }
      # Returns the default value for the rectangle-valued preference
      # with the given name in the given preference store.
      # Returns the default-default value (<code>RECTANGLE_DEFAULT_DEFAULT</code>)
      # is no default preference with the given name, or if the default
      # value cannot be treated as a rectangle.
      # 
      # @param store the preference store
      # @param name the name of the preference
      # @return the default value of the preference
      def get_default_rectangle(store, name)
        return basic_get_rectangle(store.get_default_string(name))
      end
      
      typesig { [IPreferenceStore, String] }
      # Returns the current value of the font-valued preference with the
      # given name in the given preference store.
      # Returns the default-default value (<code>FONTDATA_ARRAY_DEFAULT_DEFAULT</code>)
      # if there is no preference with the given name, or if the current value
      # cannot be treated as font data.
      # 
      # @param store the preference store
      # @param name the name of the preference
      # @return the font-valued preference
      def get_font_data_array(store, name)
        return basic_get_font_data(store.get_string(name))
      end
      
      typesig { [IPreferenceStore, String] }
      # Returns the current value of the first entry of the
      # font-valued preference with the
      # given name in the given preference store.
      # Returns the default-default value (<code>FONTDATA_ARRAY_DEFAULT_DEFAULT</code>)
      # if there is no preference with the given name, or if the current value
      # cannot be treated as font data.
      # This API is provided for backwards compatibility. It is
      # recommended that <code>getFontDataArray</code> is used instead.
      # 
      # @param store the preference store
      # @param name the name of the preference
      # @return the font-valued preference
      def get_font_data(store, name)
        return get_font_data_array(store, name)[0]
      end
      
      typesig { [IPreferenceStore, String] }
      # Returns the current value of the point-valued preference with the
      # given name in the given preference store.
      # Returns the default-default value (<code>POINT_DEFAULT_DEFAULT</code>)
      # if there is no preference with the given name, or if the current value
      # cannot be treated as a point.
      # 
      # @param store the preference store
      # @param name the name of the preference
      # @return the point-valued preference
      def get_point(store, name)
        return basic_get_point(store.get_string(name))
      end
      
      typesig { [IPreferenceStore, String] }
      # Returns the current value of the rectangle-valued preference with the
      # given name in the given preference store.
      # Returns the default-default value (<code>RECTANGLE_DEFAULT_DEFAULT</code>)
      # if there is no preference with the given name, or if the current value
      # cannot be treated as a rectangle.
      # 
      # @param store the preference store
      # @param name the name of the preference
      # @return the rectangle-valued preference
      def get_rectangle(store, name)
        return basic_get_rectangle(store.get_string(name))
      end
      
      typesig { [IPreferenceStore, String, FontData] }
      # Sets the default value of the preference with the given name
      # in the given preference store. As FontDatas are stored as
      # arrays this method is only provided for backwards compatibility.
      # Use <code>setDefault(IPreferenceStore, String, FontData[])</code>
      # instead.
      # 
      # @param store the preference store
      # @param name the name of the preference
      # @param value the new default value of the preference
      def set_default(store, name, value)
        font_datas = Array.typed(FontData).new(1) { nil }
        font_datas[0] = value
        set_default(store, name, font_datas)
      end
      
      typesig { [IPreferenceStore, String, Array.typed(FontData)] }
      # Sets the default value of the preference with the given name
      # in the given preference store.
      # 
      # @param store the preference store
      # @param name the name of the preference
      # @param value the new default value of the preference
      def set_default(store, name, value)
        store.set_default(name, get_stored_representation(value))
      end
      
      typesig { [IPreferenceStore, String, Point] }
      # Sets the default value of the preference with the given name
      # in the given preference store.
      # 
      # @param store the preference store
      # @param name the name of the preference
      # @param value the new default value of the preference
      def set_default(store, name, value)
        store.set_default(name, StringConverter.as_string(value))
      end
      
      typesig { [IPreferenceStore, String, Rectangle] }
      # Sets the default value of the preference with the given name
      # in the given preference store.
      # 
      # @param store the preference store
      # @param name the name of the preference
      # @param value the new default value of the preference
      def set_default(store, name, value)
        store.set_default(name, StringConverter.as_string(value))
      end
      
      typesig { [IPreferenceStore, String, RGB] }
      # Sets the default value of the preference with the given name
      # in the given preference store.
      # 
      # @param store the preference store
      # @param name the name of the preference
      # @param value the new default value of the preference
      def set_default(store, name, value)
        store.set_default(name, StringConverter.as_string(value))
      end
      
      typesig { [IPreferenceStore, String, FontData] }
      # Sets the current value of the preference with the given name
      # in the given preference store.
      # <p>
      # Included for backwards compatibility.  This method is equivalent to
      # </code>setValue(store, name, new FontData[]{value})</code>.
      # </p>
      # 
      # @param store the preference store
      # @param name the name of the preference
      # @param value the new current value of the preference
      def set_value(store, name, value)
        set_value(store, name, Array.typed(FontData).new([value]))
      end
      
      typesig { [IPreferenceStore, String, Array.typed(FontData)] }
      # Sets the current value of the preference with the given name
      # in the given preference store. This method also sets the corresponding
      # key in the JFace font registry to the value and fires a
      # property change event to listeners on the preference store.
      # 
      # <p>
      # Note that this API does not update any other settings that may
      # be dependant upon it. Only the value in the preference store
      # and in the font registry is updated.
      # </p>
      # @param store the preference store
      # @param name the name of the preference
      # @param value the new current value of the preference
      # 
      # @see #putValue(IPreferenceStore, String, FontData[])
      def set_value(store, name, value)
        old_value = get_font_data_array(store, name)
        # see if the font has changed
        if (!Arrays.==(old_value, value))
          store.put_value(name, get_stored_representation(value))
          JFaceResources.get_font_registry.put(name, value)
          store.fire_property_change_event(name, old_value, value)
        end
      end
      
      typesig { [IPreferenceStore, String, Array.typed(FontData)] }
      # Sets the current value of the preference with the given name
      # in the given preference store. This method does not update
      # the font registry or fire a property change event.
      # 
      # @param store the preference store
      # @param name the name of the preference
      # @param value the new current value of the preference
      # 
      # @see PreferenceConverter#setValue(IPreferenceStore, String, FontData[])
      def put_value(store, name, value)
        old_value = get_font_data_array(store, name)
        # see if the font has changed
        if (!Arrays.==(old_value, value))
          store.put_value(name, get_stored_representation(value))
        end
      end
      
      typesig { [Array.typed(FontData)] }
      # Returns the stored representation of the given array of FontData objects.
      # The stored representation has the form FontData;FontData;
      # Only includes the non-null entries.
      # 
      # @param fontData the array of FontData objects
      # @return the stored representation of the FontData objects
      # @since 3.0
      def get_stored_representation(font_data)
        buffer = StringBuffer.new
        i = 0
        while i < font_data.attr_length
          if (!(font_data[i]).nil?)
            buffer.append(font_data[i].to_s)
            buffer.append(ENTRY_SEPARATOR)
          end
          i += 1
        end
        return buffer.to_s
      end
      
      typesig { [IPreferenceStore, String, Point] }
      # Sets the current value of the preference with the given name
      # in the given preference store.
      # 
      # @param store the preference store
      # @param name the name of the preference
      # @param value the new current value of the preference
      def set_value(store, name, value)
        old_value = get_point(store, name)
        if ((old_value).nil? || !(old_value == value))
          store.put_value(name, StringConverter.as_string(value))
          store.fire_property_change_event(name, old_value, value)
        end
      end
      
      typesig { [IPreferenceStore, String, Rectangle] }
      # Sets the current value of the preference with the given name
      # in the given preference store.
      # 
      # @param store the preference store
      # @param name the name of the preference
      # @param value the new current value of the preference
      def set_value(store, name, value)
        old_value = get_rectangle(store, name)
        if ((old_value).nil? || !(old_value == value))
          store.put_value(name, StringConverter.as_string(value))
          store.fire_property_change_event(name, old_value, value)
        end
      end
      
      typesig { [IPreferenceStore, String, RGB] }
      # Sets the current value of the preference with the given name
      # in the given preference store.
      # 
      # @param store the preference store
      # @param name the name of the preference
      # @param value the new current value of the preference
      def set_value(store, name, value)
        old_value = get_color(store, name)
        if ((old_value).nil? || !(old_value == value))
          store.put_value(name, StringConverter.as_string(value))
          store.fire_property_change_event(name, old_value, value)
        end
      end
    }
    
    private
    alias_method :initialize__preference_converter, :initialize
  end
  
end
