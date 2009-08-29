require "rjava"

# Copyright (c) 2000, 2009 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Util
  module UtilImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Util
      include_const ::Java::Util, :Collections
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :MissingResourceException
      include_const ::Java::Util, :ResourceBundle
      include_const ::Java::Util, :SortedSet
      include_const ::Java::Util, :TreeSet
      include_const ::Org::Eclipse::Swt, :SWT
    }
  end
  
  # <p>
  # A static class providing utility methods to all of JFace.
  # </p>
  # 
  # @since 3.1
  class Util 
    include_class_members UtilImports
    
    class_module.module_eval {
      # An unmodifiable, empty, sorted set. This value is guaranteed to never
      # change and never be <code>null</code>.
      const_set_lazy(:EMPTY_SORTED_SET) { Collections.unmodifiable_sorted_set(TreeSet.new) }
      const_attr_reader  :EMPTY_SORTED_SET
      
      # A common zero-length string. It avoids needing write <code>NON-NLS</code>
      # next to code fragments. It's also a bit clearer to read.
      const_set_lazy(:ZERO_LENGTH_STRING) { "" }
      const_attr_reader  :ZERO_LENGTH_STRING
      
      typesig { [Object, Class] }
      # $NON-NLS-1$
      # 
      # Verifies that the given object is an instance of the given class.
      # 
      # @param object
      # The object to check; may be <code>null</code>.
      # @param c
      # The class which the object should be; must not be
      # <code>null</code>.
      def assert_instance(object, c)
        assert_instance(object, c, false)
      end
      
      typesig { [Object, Class, ::Java::Boolean] }
      # Verifies the given object is an instance of the given class. It is
      # possible to specify whether the object is permitted to be
      # <code>null</code>.
      # 
      # @param object
      # The object to check; may be <code>null</code>.
      # @param c
      # The class which the object should be; must not be
      # <code>null</code>.
      # @param allowNull
      # Whether the object is allowed to be <code>null</code>.
      def assert_instance(object, c, allow_null)
        if ((object).nil? && allow_null)
          return
        end
        if ((object).nil? || (c).nil?)
          raise NullPointerException.new
        else
          if (!c.is_instance(object))
            raise IllegalArgumentException.new
          end
        end
      end
      
      typesig { [::Java::Boolean, ::Java::Boolean] }
      # Compares two boolean values. <code>false</code> is considered to be
      # "less than" <code>true</code>.
      # 
      # @param left
      # The left value to compare
      # @param right
      # The right value to compare
      # @return <code>-1</code> if the left is <code>false</code> and the
      # right is <code>true</code>. <code>1</code> if the opposite
      # is true. If they are equal, then it returns <code>0</code>.
      def compare(left, right)
        return (left).equal?(false) ? ((right).equal?(true) ? -1 : 0) : 1
      end
      
      typesig { [::Java::Int, ::Java::Int] }
      # Compares two integer values.
      # 
      # @param left
      # The left value to compare
      # @param right
      # The right value to compare
      # @return <code>left - right</code>
      def compare(left, right)
        return left - right
      end
      
      typesig { [JavaComparable, JavaComparable] }
      # Compares to comparable objects -- defending against <code>null</code>.
      # 
      # @param left
      # The left object to compare; may be <code>null</code>.
      # @param right
      # The right object to compare; may be <code>null</code>.
      # @return The result of the comparison. <code>null</code> is considered
      # to be the least possible value.
      def compare(left, right)
        if ((left).nil? && (right).nil?)
          return 0
        else
          if ((left).nil?)
            return -1
          else
            if ((right).nil?)
              return 1
            else
              return (left <=> right)
            end
          end
        end
      end
      
      typesig { [Array.typed(JavaComparable), Array.typed(JavaComparable)] }
      # Compares two arrays of comparable objects -- accounting for
      # <code>null</code>.
      # 
      # @param left
      # The left array to be compared; may be <code>null</code>.
      # @param right
      # The right array to be compared; may be <code>null</code>.
      # @return The result of the comparison. <code>null</code> is considered
      # to be the least possible value. A shorter array is considered
      # less than a longer array.
      def compare(left, right)
        if ((left).nil? && (right).nil?)
          return 0
        else
          if ((left).nil?)
            return -1
          else
            if ((right).nil?)
              return 1
            else
              l = left.attr_length
              r = right.attr_length
              if (!(l).equal?(r))
                return l - r
              end
              i = 0
              while i < l
                compare_to_ = compare(left[i], right[i])
                if (!(compare_to_).equal?(0))
                  return compare_to_
                end
                i += 1
              end
              return 0
            end
          end
        end
      end
      
      typesig { [JavaList, JavaList] }
      # Compares two lists -- account for <code>null</code>. The lists must
      # contain comparable objects.
      # 
      # @param left
      # The left list to compare; may be <code>null</code>. This
      # list must only contain instances of <code>Comparable</code>.
      # @param right
      # The right list to compare; may be <code>null</code>. This
      # list must only contain instances of <code>Comparable</code>.
      # @return The result of the comparison. <code>null</code> is considered
      # to be the least possible value. A shorter list is considered less
      # than a longer list.
      def compare(left, right)
        if ((left).nil? && (right).nil?)
          return 0
        else
          if ((left).nil?)
            return -1
          else
            if ((right).nil?)
              return 1
            else
              l = left.size
              r = right.size
              if (!(l).equal?(r))
                return l - r
              end
              i = 0
              while i < l
                compare_to_ = compare(left.get(i), right.get(i))
                if (!(compare_to_).equal?(0))
                  return compare_to_
                end
                i += 1
              end
              return 0
            end
          end
        end
      end
      
      typesig { [Array.typed(Object), Array.typed(Object), ::Java::Boolean] }
      # Tests whether the first array ends with the second array.
      # 
      # @param left
      # The array to check (larger); may be <code>null</code>.
      # @param right
      # The array that should be a subsequence (smaller); may be
      # <code>null</code>.
      # @param equals
      # Whether the two array are allowed to be equal.
      # @return <code>true</code> if the second array is a subsequence of the
      # array list, and they share end elements.
      def ends_with(left, right, equals)
        if ((left).nil? || (right).nil?)
          return false
        end
        l = left.attr_length
        r = right.attr_length
        if (r > l || !equals && (r).equal?(l))
          return false
        end
        i = 0
        while i < r
          if (!self.==(left[l - i - 1], right[r - i - 1]))
            return false
          end
          i += 1
        end
        return true
      end
      
      typesig { [Object, Object] }
      # Checks whether the two objects are <code>null</code> -- allowing for
      # <code>null</code>.
      # 
      # @param left
      # The left object to compare; may be <code>null</code>.
      # @param right
      # The right object to compare; may be <code>null</code>.
      # @return <code>true</code> if the two objects are equivalent;
      # <code>false</code> otherwise.
      def ==(left, right)
        return (left).nil? ? (right).nil? : ((!(right).nil?) && (left == right))
      end
      
      typesig { [Array.typed(Object), Array.typed(Object)] }
      # Tests whether two arrays of objects are equal to each other. The arrays
      # must not be <code>null</code>, but their elements may be
      # <code>null</code>.
      # 
      # @param leftArray
      # The left array to compare; may be <code>null</code>, and
      # may be empty and may contain <code>null</code> elements.
      # @param rightArray
      # The right array to compare; may be <code>null</code>, and
      # may be empty and may contain <code>null</code> elements.
      # @return <code>true</code> if the arrays are equal length and the
      # elements at the same position are equal; <code>false</code>
      # otherwise.
      def ==(left_array, right_array)
        if ((left_array).equal?(right_array))
          return true
        end
        if ((left_array).nil?)
          return ((right_array).nil?)
        else
          if ((right_array).nil?)
            return false
          end
        end
        if (!(left_array.attr_length).equal?(right_array.attr_length))
          return false
        end
        i = 0
        while i < left_array.attr_length
          left = left_array[i]
          right = right_array[i]
          equal = ((left).nil?) ? ((right).nil?) : ((left == right))
          if (!equal)
            return false
          end
          i += 1
        end
        return true
      end
      
      typesig { [::Java::Int] }
      # Provides a hash code based on the given integer value.
      # 
      # @param i
      # The integer value
      # @return <code>i</code>
      def hash_code(i)
        return i
      end
      
      typesig { [Object] }
      # Provides a hash code for the object -- defending against
      # <code>null</code>.
      # 
      # @param object
      # The object for which a hash code is required.
      # @return <code>object.hashCode</code> or <code>0</code> if
      # <code>object</code> if <code>null</code>.
      def hash_code(object)
        return !(object).nil? ? object.hash_code : 0
      end
      
      typesig { [Array.typed(Object)] }
      # Computes the hash code for an array of objects, but with defense against
      # <code>null</code>.
      # 
      # @param objects
      # The array of objects for which a hash code is needed; may be
      # <code>null</code>.
      # @return The hash code for <code>objects</code>; or <code>0</code> if
      # <code>objects</code> is <code>null</code>.
      def hash_code(objects)
        if ((objects).nil?)
          return 0
        end
        hash_code_ = 89
        i = 0
        while i < objects.attr_length
          object = objects[i]
          if (!(object).nil?)
            hash_code_ = hash_code_ * 31 + object.hash_code
          end
          i += 1
        end
        return hash_code_
      end
      
      typesig { [Array.typed(Object), Array.typed(Object), ::Java::Boolean] }
      # Checks whether the second array is a subsequence of the first array, and
      # that they share common starting elements.
      # 
      # @param left
      # The first array to compare (large); may be <code>null</code>.
      # @param right
      # The second array to compare (small); may be <code>null</code>.
      # @param equals
      # Whether it is allowed for the two arrays to be equivalent.
      # @return <code>true</code> if the first arrays starts with the second
      # list; <code>false</code> otherwise.
      def starts_with(left, right, equals)
        if ((left).nil? || (right).nil?)
          return false
        end
        l = left.attr_length
        r = right.attr_length
        if (r > l || !equals && (r).equal?(l))
          return false
        end
        i = 0
        while i < r
          if (!self.==(left[i], right[i]))
            return false
          end
          i += 1
        end
        return true
      end
      
      typesig { [Array.typed(Object)] }
      # Converts an array into a string representation that is suitable for
      # debugging.
      # 
      # @param array
      # The array to convert; may be <code>null</code>.
      # @return The string representation of the array; never <code>null</code>.
      def to_s(array)
        if ((array).nil?)
          return "null" # $NON-NLS-1$
        end
        buffer = StringBuffer.new
        buffer.append(Character.new(?[.ord))
        length = array.attr_length
        i = 0
        while i < length
          if (!(i).equal?(0))
            buffer.append(Character.new(?,.ord))
          end
          object = array[i]
          element = String.value_of(object)
          buffer.append(element)
          i += 1
        end
        buffer.append(Character.new(?].ord))
        return buffer.to_s
      end
      
      typesig { [ResourceBundle, String, String] }
      # Provides a translation of a particular key from the resource bundle.
      # 
      # @param resourceBundle
      # The key to look up in the resource bundle; should not be
      # <code>null</code>.
      # @param key
      # The key to look up in the resource bundle; should not be
      # <code>null</code>.
      # @param defaultString
      # The value to return if the resource cannot be found; may be
      # <code>null</code>.
      # @return The value of the translated resource at <code>key</code>. If
      # the key cannot be found, then it is simply the
      # <code>defaultString</code>.
      def translate_string(resource_bundle, key, default_string)
        if (!(resource_bundle).nil? && !(key).nil?)
          begin
            translated_string = resource_bundle.get_string(key)
            if (!(translated_string).nil?)
              return translated_string
            end
          rescue MissingResourceException => e_missing_resource
            # Such is life. We'll return the key
          end
        end
        return default_string
      end
      
      typesig { [String, String, String] }
      # Foundation replacement for String.replaceAll(*).
      # 
      # @param src the starting string.
      # @param find the string to find.
      # @param replacement the string to replace.
      # @return The new string.
      # @since 3.4
      def replace_all(src, find, replacement)
        len = src.length
        find_len = find.length
        idx = src.index_of(find)
        if (idx < 0)
          return src
        end
        buf = StringBuffer.new
        begin_index = 0
        while (!(idx).equal?(-1) && idx < len)
          buf.append(src.substring(begin_index, idx))
          buf.append(replacement)
          begin_index = idx + find_len
          if (begin_index < len)
            idx = src.index_of(find, begin_index)
          else
            idx = -1
          end
        end
        if (begin_index < len)
          buf.append(src.substring(begin_index, ((idx).equal?(-1) ? len : idx)))
        end
        return buf.to_s
      end
      
      # Methods for working with the windowing system
      # 
      # 
      # Windowing system constant.
      # @since 3.5
      const_set_lazy(:WS_WIN32) { "win32" }
      const_attr_reader  :WS_WIN32
      
      # $NON-NLS-1$
      # 
      # Windowing system constant.
      # @since 3.5
      const_set_lazy(:WS_MOTIF) { "motif" }
      const_attr_reader  :WS_MOTIF
      
      # $NON-NLS-1$
      # 
      # Windowing system constant.
      # @since 3.5
      const_set_lazy(:WS_GTK) { "gtk" }
      const_attr_reader  :WS_GTK
      
      # $NON-NLS-1$
      # 
      # Windowing system constant.
      # @since 3.5
      const_set_lazy(:WS_PHOTON) { "photon" }
      const_attr_reader  :WS_PHOTON
      
      # $NON-NLS-1$
      # 
      # Windowing system constant.
      # @since 3.5
      const_set_lazy(:WS_CARBON) { "carbon" }
      const_attr_reader  :WS_CARBON
      
      # $NON-NLS-1$
      # 
      # Windowing system constant.
      # @since 3.5
      const_set_lazy(:WS_COCOA) { "cocoa" }
      const_attr_reader  :WS_COCOA
      
      # $NON-NLS-1$
      # 
      # Windowing system constant.
      # @since 3.5
      const_set_lazy(:WS_WPF) { "wpf" }
      const_attr_reader  :WS_WPF
      
      # $NON-NLS-1$
      # 
      # Windowing system constant.
      # @since 3.5
      const_set_lazy(:WS_UNKNOWN) { "unknown" }
      const_attr_reader  :WS_UNKNOWN
      
      typesig { [] }
      # $NON-NLS-1$
      # 
      # Common WS query helper method.
      # @return <code>true</code> for windows platforms
      # @since 3.5
      def is_windows
        ws = SWT.get_platform
        return (WS_WIN32 == ws) || (WS_WPF == ws)
      end
      
      typesig { [] }
      # Common WS query helper method.
      # @return <code>true</code> for mac platforms
      # @since 3.5
      def is_mac
        ws = SWT.get_platform
        return (WS_CARBON == ws) || (WS_COCOA == ws)
      end
      
      typesig { [] }
      # Common WS query helper method.
      # @return <code>true</code> for linux platform
      # @since 3.5
      def is_linux
        ws = SWT.get_platform
        return (WS_GTK == ws) || (WS_MOTIF == ws)
      end
      
      typesig { [] }
      # Common WS query helper method.
      # @return <code>true</code> for gtk platforms
      # @since 3.5
      def is_gtk
        ws = SWT.get_platform
        return (WS_GTK == ws)
      end
      
      typesig { [] }
      # Common WS query helper method.
      # @return <code>true</code> for motif platforms
      # @since 3.5
      def is_motif
        ws = SWT.get_platform
        return (WS_MOTIF == ws)
      end
      
      typesig { [] }
      # Common WS query helper method.
      # @return <code>true</code> for photon platforms
      # @since 3.5
      def is_photon
        ws = SWT.get_platform
        return (WS_PHOTON == ws)
      end
      
      typesig { [] }
      # Common WS query helper method.
      # @return <code>true</code> for carbon platforms
      # @since 3.5
      def is_carbon
        ws = SWT.get_platform
        return (WS_CARBON == ws)
      end
      
      typesig { [] }
      # Common WS query helper method.
      # @return <code>true</code> for the cocoa platform.
      # @since 3.5
      def is_cocoa
        ws = SWT.get_platform
        return (WS_COCOA == ws)
      end
      
      typesig { [] }
      # Common WS query helper method.
      # @return <code>true</code> for WPF
      # @since 3.5
      def is_wpf
        ws = SWT.get_platform
        return (WS_WPF == ws)
      end
      
      typesig { [] }
      # Common WS query helper method.
      # @return <code>true</code> for win32
      # @since 3.5
      def is_win32
        ws = SWT.get_platform
        return (WS_WIN32 == ws)
      end
      
      typesig { [] }
      # Common WS query helper method.
      # @return the SWT windowing platform string.
      # @see SWT#getPlatform()
      # @since 3.5
      def get_ws
        return SWT.get_platform
      end
    }
    
    typesig { [] }
    # This class should never be constructed.
    def initialize
      # Not allowed.
    end
    
    private
    alias_method :initialize__util, :initialize
  end
  
end
