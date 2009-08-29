require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Resource
  module StringConverterImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Resource
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :NoSuchElementException
      include_const ::Java::Util, :StringTokenizer
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Graphics, :FontData
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Graphics, :RGB
      include_const ::Org::Eclipse::Swt::Graphics, :Rectangle
    }
  end
  
  # Helper class for converting various data types to and from
  # strings. Supported types include:
  # <ul>
  # <li><code>boolean</code></li>
  # <li><code>int</code></li>
  # <li><code>long</code></li>
  # <li><code>float</code></li>
  # <li><code>double</code></li>
  # <li><code>org.eclipse.swt.graphics.Point</code></li>
  # <li><code>org.eclipse.swt.graphics.Rectangle</code></li>
  # <li><code>org.eclipse.swt.graphics.RGB</code></li>
  # <li><code>org.eclipse.swt.graphics.FontData</code></li>
  # </ul>
  # <p>
  # All methods declared on this class are static. This
  # class cannot be instantiated.
  # </p>
  # @noinstantiate This class is not intended to be instantiated by clients.
  # @noextend This class is not intended to be subclassed by clients.
  class StringConverter 
    include_class_members StringConverterImports
    
    class_module.module_eval {
      # Internal font style constant for regular fonts.
      const_set_lazy(:REGULAR) { "regular" }
      const_attr_reader  :REGULAR
      
      # $NON-NLS-1$
      # 
      # Internal font style constant for bold fonts.
      const_set_lazy(:BOLD) { "bold" }
      const_attr_reader  :BOLD
      
      # $NON-NLS-1$
      # 
      # Internal font style constant for italic fonts.
      const_set_lazy(:ITALIC) { "italic" }
      const_attr_reader  :ITALIC
      
      # $NON-NLS-1$
      # 
      # Internal font style constant for bold italic fonts.
      const_set_lazy(:BOLD_ITALIC) { "bold italic" }
      const_attr_reader  :BOLD_ITALIC
      
      # $NON-NLS-1$
      # 
      # Internal constant for the separator character used in
      # font specifications.
      const_set_lazy(:SEPARATOR) { Character.new(?-.ord) }
      const_attr_reader  :SEPARATOR
      
      # Internal constant for the seperator character used in font list
      # specifications.
      const_set_lazy(:FONT_SEPARATOR) { ";" }
      const_attr_reader  :FONT_SEPARATOR
    }
    
    typesig { [] }
    # $NON-NLS-1$
    # (non-Javadoc)
    # Declare a private constructor to block instantiation.
    def initialize
      # no-op
    end
    
    class_module.module_eval {
      typesig { [String] }
      # Breaks out space-separated words into an array of words.
      # For example: <code>"no comment"</code> into an array
      # <code>a[0]="no"</code> and <code>a[1]= "comment"</code>.
      # 
      # @param value the string to be converted
      # @return the list of words
      # @throws DataFormatException thrown if request string could not seperated
      def as_array(value)
        list = ArrayList.new
        stok = StringTokenizer.new(value)
        while (stok.has_more_tokens)
          list.add(stok.next_token)
        end
        result = Array.typed(String).new(list.size) { nil }
        list.to_array(result)
        return result
      end
      
      typesig { [String, Array.typed(String)] }
      # Breaks out space-separated words into an array of words.
      # For example: <code>"no comment"</code> into an array
      # <code>a[0]="no"</code> and <code>a[1]= "comment"</code>.
      # Returns the given default value if the value cannot be parsed.
      # 
      # @param value the string to be converted
      # @param dflt the default value
      # @return the list of words, or the default value
      def as_array(value, dflt)
        begin
          return as_array(value)
        rescue DataFormatException => e
          return dflt
        end
      end
      
      typesig { [String] }
      # Converts the given value into a boolean.
      # This method fails if the value does not represent a boolean.
      # <p>
      # Valid representations of <code>true</code> include the strings
      # "<code>t</code>", "<code>true</code>", or equivalent in mixed
      # or upper case.
      # Similarly, valid representations of <code>false</code> include the strings
      # "<code>f</code>", "<code>false</code>", or equivalent in mixed
      # or upper case.
      # </p>
      # 
      # @param value the value to be converted
      # @return the value as a boolean
      # @exception DataFormatException if the given value does not represent
      # a boolean
      def as_boolean(value)
        v = value.to_lower_case
        if ((v == "t") || (v == "true"))
          # $NON-NLS-1$ //$NON-NLS-2$
          return true
        end
        if ((value == "f") || (v == "false"))
          # $NON-NLS-1$ //$NON-NLS-2$
          return false
        end
        raise DataFormatException.new("Value " + value + "doesn't represent a boolean") # $NON-NLS-2$//$NON-NLS-1$
      end
      
      typesig { [String, ::Java::Boolean] }
      # Converts the given value into a boolean.
      # Returns the given default value if the
      # value does not represent a boolean.
      # 
      # @param value the value to be converted
      # @param dflt the default value
      # @return the value as a boolean, or the default value
      def as_boolean(value, dflt)
        begin
          return as_boolean(value)
        rescue DataFormatException => e
          return dflt
        end
      end
      
      typesig { [String] }
      # Converts the given value into a double.
      # This method fails if the value does not represent a double.
      # 
      # @param value the value to be converted
      # @return the value as a double
      # @exception DataFormatException if the given value does not represent
      # a double
      def as_double(value)
        begin
          return (Double.value_of(value)).double_value
        rescue NumberFormatException => e
          raise DataFormatException.new(e.get_message)
        end
      end
      
      typesig { [String, ::Java::Double] }
      # Converts the given value into a double.
      # Returns the given default value if the
      # value does not represent a double.
      # 
      # @param value the value to be converted
      # @param dflt the default value
      # @return the value as a double, or the default value
      def as_double(value, dflt)
        begin
          return as_double(value)
        rescue DataFormatException => e
          return dflt
        end
      end
      
      typesig { [String] }
      # Converts the given value into a float.
      # This method fails if the value does not represent a float.
      # 
      # @param value the value to be converted
      # @return the value as a float
      # @exception DataFormatException if the given value does not represent
      # a float
      def as_float(value)
        begin
          return (Float.value_of(value)).float_value
        rescue NumberFormatException => e
          raise DataFormatException.new(e.get_message)
        end
      end
      
      typesig { [String, ::Java::Float] }
      # Converts the given value into a float.
      # Returns the given default value if the
      # value does not represent a float.
      # 
      # @param value the value to be converted
      # @param dflt the default value
      # @return the value as a float, or the default value
      def as_float(value, dflt)
        begin
          return as_float(value)
        rescue DataFormatException => e
          return dflt
        end
      end
      
      typesig { [String] }
      # Converts the given value into an SWT font data object.
      # This method fails if the value does not represent font data.
      # <p>
      # A valid font data representation is a string of the form
      # <code><it>fontname</it>-<it>style</it>-<it>height</it></code> where
      # <code><it>fontname</it></code> is the name of a font,
      # <code><it>style</it></code> is a font style (one of
      # <code>"regular"</code>, <code>"bold"</code>,
      # <code>"italic"</code>, or <code>"bold italic"</code>)
      # and <code><it>height</it></code> is an integer representing the
      # font height. Example: <code>Times New Roman-bold-36</code>.
      # </p>
      # 
      # @param value the value to be converted
      # @return the value as font data
      # @exception DataFormatException if the given value does not represent
      # font data
      def as_font_data(value)
        if ((value).nil?)
          raise DataFormatException.new("Null doesn't represent a valid font data") # $NON-NLS-1$
        end
        name = nil
        height = 0
        style = 0
        begin
          length_ = value.length
          height_index = value.last_index_of(SEPARATOR)
          if ((height_index).equal?(-1))
            raise DataFormatException.new("No correct font data format \"" + value + "\"") # $NON-NLS-2$//$NON-NLS-1$
          end
          height = StringConverter.as_int(value.substring(height_index + 1, length_))
          face_index = value.last_index_of(SEPARATOR, height_index - 1)
          if ((face_index).equal?(-1))
            raise DataFormatException.new("No correct font data format \"" + value + "\"") # $NON-NLS-2$//$NON-NLS-1$
          end
          s = value.substring(face_index + 1, height_index)
          if ((BOLD_ITALIC == s))
            style = SWT::BOLD | SWT::ITALIC
          else
            if ((BOLD == s))
              style = SWT::BOLD
            else
              if ((ITALIC == s))
                style = SWT::ITALIC
              else
                if ((REGULAR == s))
                  style = SWT::NORMAL
                else
                  raise DataFormatException.new("Unknown face name \"" + s + "\"") # $NON-NLS-2$//$NON-NLS-1$
                end
              end
            end
          end
          name = RJava.cast_to_string(value.substring(0, face_index))
        rescue NoSuchElementException => e
          raise DataFormatException.new(e.get_message)
        end
        return FontData.new(name, height, style)
      end
      
      typesig { [String, String] }
      # Returns the result of converting a list of comma-separated tokens into an array
      # 
      # @return the array of string tokens
      # @param prop the initial comma-separated string
      def get_array_from_list(prop, separator)
        if ((prop).nil? || (prop.trim == ""))
          # $NON-NLS-1$
          return Array.typed(String).new(0) { nil }
        end
        list = ArrayList.new
        tokens = StringTokenizer.new(prop, separator)
        while (tokens.has_more_tokens)
          token = tokens.next_token.trim
          if (!(token == ""))
            # $NON-NLS-1$
            list.add(token)
          end
        end
        return list.is_empty ? Array.typed(String).new(0) { nil } : list.to_array(Array.typed(String).new(list.size) { nil })
      end
      
      typesig { [String] }
      # Convert the given value into an array of SWT font data objects.
      # 
      # @param value the font list string
      # @return the value as a font list
      # @since 3.0
      def as_font_data_array(value)
        strings = get_array_from_list(value, FONT_SEPARATOR)
        data = ArrayList.new(strings.attr_length)
        i = 0
        while i < strings.attr_length
          begin
            data.add(StringConverter.as_font_data(strings[i]))
          rescue DataFormatException => e
            # do-nothing
          end
          i += 1
        end
        return data.to_array(Array.typed(FontData).new(data.size) { nil })
      end
      
      typesig { [String, FontData] }
      # Converts the given value into an SWT font data object.
      # Returns the given default value if the
      # value does not represent a font data object.
      # 
      # @param value the value to be converted
      # @param dflt the default value
      # @return the value as a font data object, or the default value
      def as_font_data(value, dflt)
        begin
          return as_font_data(value)
        rescue DataFormatException => e
          return dflt
        end
      end
      
      typesig { [String] }
      # Converts the given value into an int.
      # This method fails if the value does not represent an int.
      # 
      # @param value the value to be converted
      # @return the value as an int
      # @exception DataFormatException if the given value does not represent
      # an int
      def as_int(value)
        begin
          return JavaInteger.parse_int(value)
        rescue NumberFormatException => e
          raise DataFormatException.new(e.get_message)
        end
      end
      
      typesig { [String, ::Java::Int] }
      # Converts the given value into an int.
      # Returns the given default value if the
      # value does not represent an int.
      # 
      # @param value the value to be converted
      # @param dflt the default value
      # @return the value as an int, or the default value
      def as_int(value, dflt)
        begin
          return as_int(value)
        rescue DataFormatException => e
          return dflt
        end
      end
      
      typesig { [String] }
      # Converts the given value into a long.
      # This method fails if the value does not represent a long.
      # 
      # @param value the value to be converted
      # @return the value as a long
      # @exception DataFormatException if the given value does not represent
      # a long
      def as_long(value)
        begin
          return Long.parse_long(value)
        rescue NumberFormatException => e
          raise DataFormatException.new(e.get_message)
        end
      end
      
      typesig { [String, ::Java::Long] }
      # Converts the given value into a long.
      # Returns the given default value if the
      # value does not represent a long.
      # 
      # @param value the value to be converted
      # @param dflt the default value
      # @return the value as a long, or the default value
      def as_long(value, dflt)
        begin
          return as_long(value)
        rescue DataFormatException => e
          return dflt
        end
      end
      
      typesig { [String] }
      # Converts the given value into an SWT point.
      # This method fails if the value does not represent a point.
      # <p>
      # A valid point representation is a string of the form
      # <code><it>x</it>,<it>y</it></code> where
      # <code><it>x</it></code> and <code><it>y</it></code>
      # are valid ints.
      # </p>
      # 
      # @param value the value to be converted
      # @return the value as a point
      # @exception DataFormatException if the given value does not represent
      # a point
      def as_point(value)
        if ((value).nil?)
          raise DataFormatException.new("Null doesn't represent a valid point") # $NON-NLS-1$
        end
        stok = StringTokenizer.new(value, ",") # $NON-NLS-1$
        x = stok.next_token
        y = stok.next_token
        xval = 0
        yval = 0
        begin
          xval = JavaInteger.parse_int(x)
          yval = JavaInteger.parse_int(y)
        rescue NumberFormatException => e
          raise DataFormatException.new(e.get_message)
        end
        return Point.new(xval, yval)
      end
      
      typesig { [String, Point] }
      # Converts the given value into an SWT point.
      # Returns the given default value if the
      # value does not represent a point.
      # 
      # @param value the value to be converted
      # @param dflt the default value
      # @return the value as a point, or the default value
      def as_point(value, dflt)
        begin
          return as_point(value)
        rescue DataFormatException => e
          return dflt
        end
      end
      
      typesig { [String] }
      # Converts the given value into an SWT rectangle.
      # This method fails if the value does not represent a rectangle.
      # <p>
      # A valid rectangle representation is a string of the form
      # <code><it>x</it>,<it>y</it>,<it>width</it>,<it>height</it></code>
      # where <code><it>x</it></code>, <code><it>y</it></code>,
      # <code><it>width</it></code>, and <code><it>height</it></code>
      # are valid ints.
      # </p>
      # 
      # @param value the value to be converted
      # @return the value as a rectangle
      # @exception DataFormatException if the given value does not represent
      # a rectangle
      def as_rectangle(value)
        if ((value).nil?)
          raise DataFormatException.new("Null doesn't represent a valid rectangle") # $NON-NLS-1$
        end
        stok = StringTokenizer.new(value, ",") # $NON-NLS-1$
        x = stok.next_token
        y = stok.next_token
        width = stok.next_token
        height = stok.next_token
        xval = 0
        yval = 0
        wval = 0
        hval = 0
        begin
          xval = JavaInteger.parse_int(x)
          yval = JavaInteger.parse_int(y)
          wval = JavaInteger.parse_int(width)
          hval = JavaInteger.parse_int(height)
        rescue NumberFormatException => e
          raise DataFormatException.new(e.get_message)
        end
        return Rectangle.new(xval, yval, wval, hval)
      end
      
      typesig { [String, Rectangle] }
      # Converts the given value into an SWT rectangle.
      # Returns the given default value if the
      # value does not represent a rectangle.
      # 
      # @param value the value to be converted
      # @param dflt the default value
      # @return the value as a rectangle, or the default value
      def as_rectangle(value, dflt)
        begin
          return as_rectangle(value)
        rescue DataFormatException => e
          return dflt
        end
      end
      
      typesig { [String] }
      # Converts the given value into an SWT RGB color value.
      # This method fails if the value does not represent an RGB
      # color value.
      # <p>
      # A valid RGB color value representation is a string of the form
      # <code><it>red</it>,<it>green</it></code>,<it>blue</it></code> where
      # <code><it>red</it></code>, <it>green</it></code>, and
      # <code><it>blue</it></code> are valid ints.
      # </p>
      # 
      # @param value the value to be converted
      # @return the value as an RGB color value
      # @exception DataFormatException if the given value does not represent
      # an RGB color value
      def as_rgb(value)
        if ((value).nil?)
          raise DataFormatException.new("Null doesn't represent a valid RGB") # $NON-NLS-1$
        end
        stok = StringTokenizer.new(value, ",") # $NON-NLS-1$
        begin
          red = stok.next_token.trim
          green = stok.next_token.trim
          blue = stok.next_token.trim
          rval = 0
          gval = 0
          bval = 0
          begin
            rval = JavaInteger.parse_int(red)
            gval = JavaInteger.parse_int(green)
            bval = JavaInteger.parse_int(blue)
          rescue NumberFormatException => e
            raise DataFormatException.new(e.get_message)
          end
          return RGB.new(rval, gval, bval)
        rescue NoSuchElementException => e
          raise DataFormatException.new(e.get_message)
        end
      end
      
      typesig { [String, RGB] }
      # Converts the given value into an SWT RGB color value.
      # Returns the given default value if the
      # value does not represent an RGB color value.
      # 
      # @param value the value to be converted
      # @param dflt the default value
      # @return the value as a RGB color value, or the default value
      def as_rgb(value, dflt)
        begin
          return as_rgb(value)
        rescue DataFormatException => e
          return dflt
        end
      end
      
      typesig { [::Java::Double] }
      # Converts the given double value to a string.
      # Equivalent to <code>String.valueOf(value)</code>.
      # 
      # @param value the double value
      # @return the string representing the given double
      def as_string(value)
        return String.value_of(value)
      end
      
      typesig { [::Java::Float] }
      # Converts the given float value to a string.
      # Equivalent to <code>String.valueOf(value)</code>.
      # 
      # @param value the float value
      # @return the string representing the given float
      def as_string(value)
        return String.value_of(value)
      end
      
      typesig { [::Java::Int] }
      # Converts the given int value to a string.
      # Equivalent to <code>String.valueOf(value)</code>.
      # 
      # @param value the int value
      # @return the string representing the given int
      def as_string(value)
        return String.value_of(value)
      end
      
      typesig { [::Java::Long] }
      # Converts the given long value to a string.
      # Equivalent to <code>String.valueOf(value)</code>.
      # 
      # @param value the long value
      # @return the string representing the given long
      def as_string(value)
        return String.value_of(value)
      end
      
      typesig { [Boolean] }
      # Converts the given boolean object to a string.
      # Equivalent to <code>String.valueOf(value.booleanValue())</code>.
      # 
      # @param value the boolean object
      # @return the string representing the given boolean value
      def as_string(value)
        Assert.is_not_null(value)
        return String.value_of(value.boolean_value)
      end
      
      typesig { [Double] }
      # Converts the given double object to a string.
      # Equivalent to <code>String.valueOf(value.doubleValue())</code>.
      # 
      # @param value the double object
      # @return the string representing the given double value
      def as_string(value)
        Assert.is_not_null(value)
        return String.value_of(value.double_value)
      end
      
      typesig { [Float] }
      # Converts the given float object to a string.
      # Equivalent to <code>String.valueOf(value.floatValue())</code>.
      # 
      # @param value the float object
      # @return the string representing the given float value
      def as_string(value)
        Assert.is_not_null(value)
        return String.value_of(value.float_value)
      end
      
      typesig { [JavaInteger] }
      # Converts the given integer object to a string.
      # Equivalent to <code>String.valueOf(value.intValue())</code>.
      # 
      # @param value the integer object
      # @return the string representing the given integer value
      def as_string(value)
        Assert.is_not_null(value)
        return String.value_of(value.int_value)
      end
      
      typesig { [Long] }
      # Converts the given long object to a string.
      # Equivalent to <code>String.valueOf(value.longValue())</code>.
      # 
      # @param value the long object
      # @return the string representing the given long value
      def as_string(value)
        Assert.is_not_null(value)
        return String.value_of(value.long_value)
      end
      
      typesig { [Array.typed(FontData)] }
      # Converts a font data array  to a string. The string representation is
      # that of asString(FontData) seperated by ';'
      # 
      # @param value The font data.
      # @return The string representation of the font data arra.
      # @since 3.0
      def as_string(value)
        buffer = StringBuffer.new
        i = 0
        while i < value.attr_length
          buffer.append(as_string(value[i]))
          if (!(i).equal?(value.attr_length - 1))
            buffer.append(FONT_SEPARATOR)
          end
          i += 1
        end
        return buffer.to_s
      end
      
      typesig { [FontData] }
      # Converts a font data object to a string. The string representation is
      # "font name-style-height" (for example "Times New Roman-bold-36").
      # @param value The font data.
      # @return The string representation of the font data object.
      def as_string(value)
        Assert.is_not_null(value)
        buffer = StringBuffer.new
        buffer.append(value.get_name)
        buffer.append(SEPARATOR)
        style = value.get_style
        bold = ((style & SWT::BOLD)).equal?(SWT::BOLD)
        italic = ((style & SWT::ITALIC)).equal?(SWT::ITALIC)
        if (bold && italic)
          buffer.append(BOLD_ITALIC)
        else
          if (bold)
            buffer.append(BOLD)
          else
            if (italic)
              buffer.append(ITALIC)
            else
              buffer.append(REGULAR)
            end
          end
        end
        buffer.append(SEPARATOR)
        buffer.append(value.get_height)
        return buffer.to_s
      end
      
      typesig { [Point] }
      # Converts the given SWT point object to a string.
      # <p>
      # The string representation of a point has the form
      # <code><it>x</it>,<it>y</it></code> where
      # <code><it>x</it></code> and <code><it>y</it></code>
      # are string representations of integers.
      # </p>
      # 
      # @param value the point object
      # @return the string representing the given point
      def as_string(value)
        Assert.is_not_null(value)
        buffer = StringBuffer.new
        buffer.append(value.attr_x)
        buffer.append(Character.new(?,.ord))
        buffer.append(value.attr_y)
        return buffer.to_s
      end
      
      typesig { [Rectangle] }
      # Converts the given SWT rectangle object to a string.
      # <p>
      # The string representation of a rectangle has the form
      # <code><it>x</it>,<it>y</it>,<it>width</it>,<it>height</it></code>
      # where <code><it>x</it></code>, <code><it>y</it></code>,
      # <code><it>width</it></code>, and <code><it>height</it></code>
      # are string representations of integers.
      # </p>
      # 
      # @param value the rectangle object
      # @return the string representing the given rectangle
      def as_string(value)
        Assert.is_not_null(value)
        buffer = StringBuffer.new
        buffer.append(value.attr_x)
        buffer.append(Character.new(?,.ord))
        buffer.append(value.attr_y)
        buffer.append(Character.new(?,.ord))
        buffer.append(value.attr_width)
        buffer.append(Character.new(?,.ord))
        buffer.append(value.attr_height)
        return buffer.to_s
      end
      
      typesig { [RGB] }
      # Converts the given SWT RGB color value object to a string.
      # <p>
      # The string representation of an RGB color value has the form
      # <code><it>red</it>,<it>green</it></code>,<it>blue</it></code> where
      # <code><it>red</it></code>, <it>green</it></code>, and
      # <code><it>blue</it></code> are string representations of integers.
      # </p>
      # 
      # @param value the RGB color value object
      # @return the string representing the given RGB color value
      def as_string(value)
        Assert.is_not_null(value)
        buffer = StringBuffer.new
        buffer.append(value.attr_red)
        buffer.append(Character.new(?,.ord))
        buffer.append(value.attr_green)
        buffer.append(Character.new(?,.ord))
        buffer.append(value.attr_blue)
        return buffer.to_s
      end
      
      typesig { [::Java::Boolean] }
      # Converts the given boolean value to a string.
      # Equivalent to <code>String.valueOf(value)</code>.
      # 
      # @param value the boolean value
      # @return the string representing the given boolean
      def as_string(value)
        return String.value_of(value)
      end
      
      typesig { [String] }
      # Returns the given string with all whitespace characters removed.
      # <p>
      # All characters that have codes less than or equal to <code>'&#92;u0020'</code>
      # (the space character) are considered to be a white space.
      # </p>
      # 
      # @param s the source string
      # @return the string with all whitespace characters removed
      def remove_white_spaces(s)
        # check for no whitespace (common case)
        found = false
        ws_index = -1
        size_ = s.length
        i = 0
        while i < size_
          found = Character.is_whitespace(s.char_at(i))
          if (found)
            ws_index = i
            break
          end
          i += 1
        end
        if (!found)
          return s
        end
        result = StringBuffer.new(s.substring(0, ws_index))
        i_ = ws_index + 1
        while i_ < size_
          ch = s.char_at(i_)
          if (!Character.is_whitespace(ch))
            result.append(ch)
          end
          i_ += 1
        end
        return result.to_s
      end
      
      typesig { [FontData] }
      # Converts a font data object to a string representation for display.
      # The string representation is
      # "font name-style-height" (for example "Times New Roman-bold-36").
      # @param value The font data.
      # @return The string representation of the font data object.
      # @deprecated use asString(FontData)
      def as_displayable_string(value)
        Assert.is_not_null(value)
        buffer = StringBuffer.new
        buffer.append(value.get_name)
        buffer.append(SEPARATOR)
        style = value.get_style
        bold = ((style & SWT::BOLD)).equal?(SWT::BOLD)
        italic = ((style & SWT::ITALIC)).equal?(SWT::ITALIC)
        if (bold && italic)
          buffer.append(JFaceResources.get_string("BoldItalicFont")) # $NON-NLS-1$
        else
          if (bold)
            buffer.append(JFaceResources.get_string("BoldFont")) # $NON-NLS-1$
          else
            if (italic)
              buffer.append(JFaceResources.get_string("ItalicFont")) # $NON-NLS-1$
            else
              buffer.append(JFaceResources.get_string("RegularFont")) # $NON-NLS-1$
            end
          end
        end
        buffer.append(SEPARATOR)
        buffer.append(value.get_height)
        return buffer.to_s
      end
    }
    
    private
    alias_method :initialize__string_converter, :initialize
  end
  
end
