require "rjava"

# Copyright (c) 2000, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Core::Internal::Commands::Util
  module UtilImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Internal::Commands::Util
      include_const ::Java::Util, :Collections
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :HashSet
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :Map
      include_const ::Java::Util, :JavaSet
      include_const ::Java::Util, :SortedMap
      include_const ::Java::Util, :SortedSet
      include_const ::Java::Util, :TreeMap
      include_const ::Java::Util, :TreeSet
    }
  end
  
  # A class providing utility functions for the commands plug-in.
  # 
  # @since 3.1
  class Util 
    include_class_members UtilImports
    
    class_module.module_eval {
      # A shared, unmodifiable, empty, sorted map. This value is guaranteed to
      # always be the same.
      const_set_lazy(:EMPTY_SORTED_MAP) { Collections.unmodifiable_sorted_map(TreeMap.new) }
      const_attr_reader  :EMPTY_SORTED_MAP
      
      # A shared, unmodifiable, empty, sorted set. This value is guaranteed to
      # always be the same.
      const_set_lazy(:EMPTY_SORTED_SET) { Collections.unmodifiable_sorted_set(TreeSet.new) }
      const_attr_reader  :EMPTY_SORTED_SET
      
      # A shared, zero-length string -- for avoiding non-externalized string
      # tags. This value is guaranteed to always be the same.
      const_set_lazy(:ZERO_LENGTH_STRING) { "" }
      const_attr_reader  :ZERO_LENGTH_STRING
      
      typesig { [Object, Class, ::Java::Boolean] }
      # $NON-NLS-1$
      # 
      # Asserts the the given object is an instance of the given class --
      # optionally allowing the object to be <code>null</code>.
      # 
      # @param object
      # The object for which the type should be checked.
      # @param c
      # The class that the object must be; fails if the class is
      # <code>null</code>.
      # @param allowNull
      # Whether the object being <code>null</code> will not cause a
      # failure.
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
      # less than <code>true</code>.
      # 
      # @param left
      # The left value to compare.
      # @param right
      # The right value to compare.
      # @return <code>-1</code> if <code>left</code> is <code>false</code>
      # and <code>right</code> is <code>true</code>;<code>0</code>
      # if they are equal; <code>1</code> if <code>left</code> is
      # <code>true</code> and <code>right</code> is
      # <code>false</code>
      def compare(left, right)
        return (left).equal?(false) ? ((right).equal?(true) ? -1 : 0) : ((right).equal?(true) ? 0 : 1)
      end
      
      typesig { [JavaComparable, JavaComparable] }
      # Compares two comparable objects, but with protection against
      # <code>null</code>.
      # 
      # @param left
      # The left value to compare; may be <code>null</code>.
      # @param right
      # The right value to compare; may be <code>null</code>.
      # @return <code>-1</code> if <code>left</code> is <code>null</code>
      # and <code>right</code> is not <code>null</code>;
      # <code>0</code> if they are both <code>null</code>;
      # <code>1</code> if <code>left</code> is not <code>null</code>
      # and <code>right</code> is <code>null</code>. Otherwise, the
      # result of <code>left.compareTo(right)</code>.
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
      
      typesig { [::Java::Int, ::Java::Int] }
      # Compares two integer values. This method fails if the distance between
      # <code>left</code> and <code>right</code> is greater than
      # <code>Integer.MAX_VALUE</code>.
      # 
      # @param left
      # The left value to compare.
      # @param right
      # The right value to compare.
      # @return <code>left - right</code>
      def compare(left, right)
        return left - right
      end
      
      typesig { [Object, Object] }
      # Compares two objects that are not otherwise comparable. If neither object
      # is <code>null</code>, then the string representation of each object is
      # used.
      # 
      # @param left
      # The left value to compare. The string representation of this
      # value must not be <code>null</code>.
      # @param right
      # The right value to compare. The string representation of this
      # value must not be <code>null</code>.
      # @return <code>-1</code> if <code>left</code> is <code>null</code>
      # and <code>right</code> is not <code>null</code>;
      # <code>0</code> if they are both <code>null</code>;
      # <code>1</code> if <code>left</code> is not <code>null</code>
      # and <code>right</code> is <code>null</code>. Otherwise, the
      # result of
      # <code>left.toString().compareTo(right.toString())</code>.
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
              return (left.to_s <=> right.to_s)
            end
          end
        end
      end
      
      typesig { [::Java::Boolean, ::Java::Boolean] }
      # Decides whether two booleans are equal.
      # 
      # @param left
      # The first boolean to compare; may be <code>null</code>.
      # @param right
      # The second boolean to compare; may be <code>null</code>.
      # @return <code>true</code> if the booleans are equal; <code>false</code>
      # otherwise.
      def ==(left, right)
        return (left).equal?(right)
      end
      
      typesig { [Object, Object] }
      # Decides whether two objects are equal -- defending against
      # <code>null</code>.
      # 
      # @param left
      # The first object to compare; may be <code>null</code>.
      # @param right
      # The second object to compare; may be <code>null</code>.
      # @return <code>true</code> if the objects are equals; <code>false</code>
      # otherwise.
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
      # Computes the hash code for an integer.
      # 
      # @param i
      # The integer for which a hash code should be computed.
      # @return <code>i</code>.
      def hash_code(i)
        return i
      end
      
      typesig { [Object] }
      # Computes the hash code for an object, but with defense against
      # <code>null</code>.
      # 
      # @param object
      # The object for which a hash code is needed; may be
      # <code>null</code>.
      # @return The hash code for <code>object</code>; or <code>0</code> if
      # <code>object</code> is <code>null</code>.
      def hash_code(object)
        return !(object).nil? ? object.hash_code : 0
      end
      
      typesig { [Map, Class, Class, ::Java::Boolean, ::Java::Boolean] }
      # Makes a type-safe copy of the given map. This method should be used when
      # a map is crossing an API boundary (i.e., from a hostile plug-in into
      # internal code, or vice versa).
      # 
      # @param map
      # The map which should be copied; must not be <code>null</code>.
      # @param keyClass
      # The class that all the keys must be; must not be
      # <code>null</code>.
      # @param valueClass
      # The class that all the values must be; must not be
      # <code>null</code>.
      # @param allowNullKeys
      # Whether <code>null</code> keys should be allowed.
      # @param allowNullValues
      # Whether <code>null</code> values should be allowed.
      # @return A copy of the map; may be empty, but never <code>null</code>.
      def safe_copy(map, key_class, value_class, allow_null_keys, allow_null_values)
        if ((map).nil? || (key_class).nil? || (value_class).nil?)
          raise NullPointerException.new
        end
        copy = Collections.unmodifiable_map(HashMap.new(map))
        iterator = copy.entry_set.iterator
        while (iterator.has_next)
          entry = iterator.next_
          assert_instance(entry.get_key, key_class, allow_null_keys)
          assert_instance(entry.get_value, value_class, allow_null_values)
        end
        return map
      end
      
      typesig { [JavaSet, Class] }
      # Makes a type-safe copy of the given set. This method should be used when
      # a set is crossing an API boundary (i.e., from a hostile plug-in into
      # internal code, or vice versa).
      # 
      # @param set
      # The set which should be copied; must not be <code>null</code>.
      # @param c
      # The class that all the values must be; must not be
      # <code>null</code>.
      # @return A copy of the set; may be empty, but never <code>null</code>.
      # None of its element will be <code>null</code>.
      def safe_copy(set, c)
        return safe_copy(set, c, false)
      end
      
      typesig { [JavaSet, Class, ::Java::Boolean] }
      # Makes a type-safe copy of the given set. This method should be used when
      # a set is crossing an API boundary (i.e., from a hostile plug-in into
      # internal code, or vice versa).
      # 
      # @param set
      # The set which should be copied; must not be <code>null</code>.
      # @param c
      # The class that all the values must be; must not be
      # <code>null</code>.
      # @param allowNullElements
      # Whether null values should be allowed.
      # @return A copy of the set; may be empty, but never <code>null</code>.
      def safe_copy(set, c, allow_null_elements)
        if ((set).nil? || (c).nil?)
          raise NullPointerException.new
        end
        copy = Collections.unmodifiable_set(HashSet.new(set))
        iterator_ = copy.iterator
        while (iterator_.has_next)
          assert_instance(iterator_.next_, c, allow_null_elements)
        end
        return set
      end
    }
    
    typesig { [] }
    # The utility class is meant to just provide static members.
    def initialize
      # Should not be called.
    end
    
    private
    alias_method :initialize__util, :initialize
  end
  
end
