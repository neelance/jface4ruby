require "rjava"

# Copyright (c) 2000, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# Peter Shipton - original hashtable implementation
# Nick Edgar - added element comparer support
module Org::Eclipse::Jface::Viewers
  module CustomHashtableImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
      include_const ::Java::Util, :Enumeration
      include_const ::Java::Util, :NoSuchElementException
    }
  end
  
  # CustomHashtable associates keys with values. Keys and values cannot be null.
  # The size of the Hashtable is the number of key/value pairs it contains.
  # The capacity is the number of key/value pairs the Hashtable can hold.
  # The load factor is a float value which determines how full the Hashtable
  # gets before expanding the capacity. If the load factor of the Hashtable
  # is exceeded, the capacity is doubled.
  # <p>
  # CustomHashtable allows a custom comparator and hash code provider.
  # 
  # package
  class CustomHashtable 
    include_class_members CustomHashtableImports
    
    class_module.module_eval {
      # HashMapEntry is an internal class which is used to hold the entries of a Hashtable.
      const_set_lazy(:HashMapEntry) { Class.new do
        include_class_members CustomHashtable
        
        attr_accessor :key
        alias_method :attr_key, :key
        undef_method :key
        alias_method :attr_key=, :key=
        undef_method :key=
        
        attr_accessor :value
        alias_method :attr_value, :value
        undef_method :value
        alias_method :attr_value=, :value=
        undef_method :value=
        
        attr_accessor :next
        alias_method :attr_next, :next
        undef_method :next
        alias_method :attr_next=, :next=
        undef_method :next=
        
        typesig { [Object, Object] }
        def initialize(the_key, the_value)
          @key = nil
          @value = nil
          @next = nil
          @key = the_key
          @value = the_value
        end
        
        private
        alias_method :initialize__hash_map_entry, :initialize
      end }
      
      const_set_lazy(:EmptyEnumerator) { Class.new do
        include_class_members CustomHashtable
        include Enumeration
        
        typesig { [] }
        def has_more_elements
          return false
        end
        
        typesig { [] }
        def next_element
          raise self.class::NoSuchElementException.new
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__empty_enumerator, :initialize
      end }
      
      const_set_lazy(:HashEnumerator) { Class.new do
        extend LocalClass
        include_class_members CustomHashtable
        include Enumeration
        
        attr_accessor :key
        alias_method :attr_key, :key
        undef_method :key
        alias_method :attr_key=, :key=
        undef_method :key=
        
        attr_accessor :start
        alias_method :attr_start, :start
        undef_method :start
        alias_method :attr_start=, :start=
        undef_method :start=
        
        attr_accessor :entry
        alias_method :attr_entry, :entry
        undef_method :entry
        alias_method :attr_entry=, :entry=
        undef_method :entry=
        
        typesig { [::Java::Boolean] }
        def initialize(is_key)
          @key = false
          @start = 0
          @entry = nil
          @key = is_key
          @start = self.attr_first_slot
        end
        
        typesig { [] }
        def has_more_elements
          if (!(@entry).nil?)
            return true
          end
          while (@start <= self.attr_last_slot)
            if (!(self.attr_element_data[((@start += 1) - 1)]).nil?)
              @entry = self.attr_element_data[@start - 1]
              return true
            end
          end
          return false
        end
        
        typesig { [] }
        def next_element
          if (has_more_elements)
            result = @key ? @entry.attr_key : @entry.attr_value
            @entry = @entry.attr_next
            return result
          else
            raise self.class::NoSuchElementException.new
          end
        end
        
        private
        alias_method :initialize__hash_enumerator, :initialize
      end }
    }
    
    attr_accessor :element_count
    alias_method :attr_element_count, :element_count
    undef_method :element_count
    alias_method :attr_element_count=, :element_count=
    undef_method :element_count=
    
    attr_accessor :element_data
    alias_method :attr_element_data, :element_data
    undef_method :element_data
    alias_method :attr_element_data=, :element_data=
    undef_method :element_data=
    
    attr_accessor :load_factor
    alias_method :attr_load_factor, :load_factor
    undef_method :load_factor
    alias_method :attr_load_factor=, :load_factor=
    undef_method :load_factor=
    
    attr_accessor :threshold
    alias_method :attr_threshold, :threshold
    undef_method :threshold
    alias_method :attr_threshold=, :threshold=
    undef_method :threshold=
    
    attr_accessor :first_slot
    alias_method :attr_first_slot, :first_slot
    undef_method :first_slot
    alias_method :attr_first_slot=, :first_slot=
    undef_method :first_slot=
    
    attr_accessor :last_slot
    alias_method :attr_last_slot, :last_slot
    undef_method :last_slot
    alias_method :attr_last_slot=, :last_slot=
    undef_method :last_slot=
    
    attr_accessor :comparer
    alias_method :attr_comparer, :comparer
    undef_method :comparer
    alias_method :attr_comparer=, :comparer=
    undef_method :comparer=
    
    class_module.module_eval {
      const_set_lazy(:EmptyEnumerator) { EmptyEnumerator.new }
      const_attr_reader  :EmptyEnumerator
      
      # The default capacity used when not specified in the constructor.
      const_set_lazy(:DEFAULT_CAPACITY) { 13 }
      const_attr_reader  :DEFAULT_CAPACITY
    }
    
    typesig { [] }
    # Constructs a new Hashtable using the default capacity
    # and load factor.
    def initialize
      initialize__custom_hashtable(13)
    end
    
    typesig { [::Java::Int] }
    # Constructs a new Hashtable using the specified capacity
    # and the default load factor.
    # 
    # @param capacity the initial capacity
    def initialize(capacity)
      initialize__custom_hashtable(capacity, nil)
    end
    
    typesig { [IElementComparer] }
    # Constructs a new hash table with the default capacity and the given
    # element comparer.
    # 
    # @param comparer the element comparer to use to compare keys and obtain
    # hash codes for keys, or <code>null</code>  to use the normal
    # <code>equals</code> and <code>hashCode</code> methods
    def initialize(comparer)
      initialize__custom_hashtable(DEFAULT_CAPACITY, comparer)
    end
    
    typesig { [::Java::Int, IElementComparer] }
    # Constructs a new hash table with the given capacity and the given
    # element comparer.
    # 
    # @param capacity the maximum number of elements that can be added without
    # rehashing
    # @param comparer the element comparer to use to compare keys and obtain
    # hash codes for keys, or <code>null</code>  to use the normal
    # <code>equals</code> and <code>hashCode</code> methods
    def initialize(capacity, comparer)
      @element_count = 0
      @element_data = nil
      @load_factor = 0.0
      @threshold = 0
      @first_slot = 0
      @last_slot = -1
      @comparer = nil
      if (capacity >= 0)
        @element_count = 0
        @element_data = Array.typed(HashMapEntry).new((capacity).equal?(0) ? 1 : capacity) { nil }
        @first_slot = @element_data.attr_length
        @load_factor = 0.75
        compute_max_size
      else
        raise IllegalArgumentException.new
      end
      @comparer = comparer
    end
    
    typesig { [CustomHashtable, IElementComparer] }
    # Constructs a new hash table with enough capacity to hold all keys in the
    # given hash table, then adds all key/value pairs in the given hash table
    # to the new one, using the given element comparer.
    # @param table the original hash table to copy from
    # 
    # @param comparer the element comparer to use to compare keys and obtain
    # hash codes for keys, or <code>null</code>  to use the normal
    # <code>equals</code> and <code>hashCode</code> methods
    def initialize(table, comparer)
      initialize__custom_hashtable(table.size * 2, comparer)
      i = table.attr_element_data.attr_length
      while (i -= 1) >= 0
        entry = table.attr_element_data[i]
        while (!(entry).nil?)
          put(entry.attr_key, entry.attr_value)
          entry = entry.attr_next
        end
      end
    end
    
    typesig { [] }
    # Returns the element comparer used  to compare keys and to obtain
    # hash codes for keys, or <code>null</code> if no comparer has been
    # provided.
    # 
    # @return the element comparer or <code>null</code>
    # 
    # @since 3.2
    def get_comparer
      return @comparer
    end
    
    typesig { [] }
    def compute_max_size
      @threshold = RJava.cast_to_int((@element_data.attr_length * @load_factor))
    end
    
    typesig { [Object] }
    # Answers if this Hashtable contains the specified object as a key
    # of one of the key/value pairs.
    # 
    # @param		key	the object to look for as a key in this Hashtable
    # @return		true if object is a key in this Hashtable, false otherwise
    def contains_key(key)
      return !(get_entry(key)).nil?
    end
    
    typesig { [] }
    # Answers an Enumeration on the values of this Hashtable. The
    # results of the Enumeration may be affected if the contents
    # of this Hashtable are modified.
    # 
    # @return		an Enumeration of the values of this Hashtable
    def elements
      if ((@element_count).equal?(0))
        return EmptyEnumerator
      end
      return HashEnumerator.new_local(self, false)
    end
    
    typesig { [Object] }
    # Answers the value associated with the specified key in
    # this Hashtable.
    # 
    # @param		key	the key of the value returned
    # @return		the value associated with the specified key, null if the specified key
    # does not exist
    def get(key)
      index = (hash_code(key) & 0x7fffffff) % @element_data.attr_length
      entry = @element_data[index]
      while (!(entry).nil?)
        if (key_equals(key, entry.attr_key))
          return entry.attr_value
        end
        entry = entry.attr_next
      end
      return nil
    end
    
    typesig { [Object] }
    def get_entry(key)
      index = (hash_code(key) & 0x7fffffff) % @element_data.attr_length
      entry = @element_data[index]
      while (!(entry).nil?)
        if (key_equals(key, entry.attr_key))
          return entry
        end
        entry = entry.attr_next
      end
      return nil
    end
    
    typesig { [Object] }
    # Answers the hash code for the given key.
    def hash_code(key)
      if ((@comparer).nil?)
        return key.hash_code
      else
        return @comparer.hash_code(key)
      end
    end
    
    typesig { [Object, Object] }
    # Compares two keys for equality.
    def key_equals(a, b)
      if ((@comparer).nil?)
        return (a == b)
      else
        return (@comparer == a)
      end
    end
    
    typesig { [] }
    # Answers an Enumeration on the keys of this Hashtable. The
    # results of the Enumeration may be affected if the contents
    # of this Hashtable are modified.
    # 
    # @return		an Enumeration of the keys of this Hashtable
    def keys
      if ((@element_count).equal?(0))
        return EmptyEnumerator
      end
      return HashEnumerator.new_local(self, true)
    end
    
    typesig { [Object, Object] }
    # Associate the specified value with the specified key in this Hashtable.
    # If the key already exists, the old value is replaced. The key and value
    # cannot be null.
    # 
    # @param		key	the key to add
    # @param		value	the value to add
    # @return		the old value associated with the specified key, null if the key did
    # not exist
    def put(key, value)
      if (!(key).nil? && !(value).nil?)
        index = (hash_code(key) & 0x7fffffff) % @element_data.attr_length
        entry = @element_data[index]
        while (!(entry).nil? && !key_equals(key, entry.attr_key))
          entry = entry.attr_next
        end
        if ((entry).nil?)
          if ((@element_count += 1) > @threshold)
            rehash
            index = (hash_code(key) & 0x7fffffff) % @element_data.attr_length
          end
          if (index < @first_slot)
            @first_slot = index
          end
          if (index > @last_slot)
            @last_slot = index
          end
          entry = HashMapEntry.new(key, value)
          entry.attr_next = @element_data[index]
          @element_data[index] = entry
          return nil
        end
        result = entry.attr_value
        entry.attr_key = key # important to avoid hanging onto keys that are equal but "old" -- see bug 30607
        entry.attr_value = value
        return result
      else
        raise NullPointerException.new
      end
    end
    
    typesig { [] }
    # Increases the capacity of this Hashtable. This method is sent when
    # the size of this Hashtable exceeds the load factor.
    def rehash
      length = @element_data.attr_length << 1
      if ((length).equal?(0))
        length = 1
      end
      @first_slot = length
      @last_slot = -1
      new_data = Array.typed(HashMapEntry).new(length) { nil }
      i = @element_data.attr_length
      while (i -= 1) >= 0
        entry = @element_data[i]
        while (!(entry).nil?)
          index = (hash_code(entry.attr_key) & 0x7fffffff) % length
          if (index < @first_slot)
            @first_slot = index
          end
          if (index > @last_slot)
            @last_slot = index
          end
          next_ = entry.attr_next
          entry.attr_next = new_data[index]
          new_data[index] = entry
          entry = next_
        end
      end
      @element_data = new_data
      compute_max_size
    end
    
    typesig { [Object] }
    # Remove the key/value pair with the specified key from this Hashtable.
    # 
    # @param		key	the key to remove
    # @return		the value associated with the specified key, null if the specified key
    # did not exist
    def remove(key)
      last = nil
      index = (hash_code(key) & 0x7fffffff) % @element_data.attr_length
      entry = @element_data[index]
      while (!(entry).nil? && !key_equals(key, entry.attr_key))
        last = entry
        entry = entry.attr_next
      end
      if (!(entry).nil?)
        if ((last).nil?)
          @element_data[index] = entry.attr_next
        else
          last.attr_next = entry.attr_next
        end
        @element_count -= 1
        return entry.attr_value
      end
      return nil
    end
    
    typesig { [] }
    # Answers the number of key/value pairs in this Hashtable.
    # 
    # @return		the number of key/value pairs in this Hashtable
    def size
      return @element_count
    end
    
    typesig { [] }
    # Answers the string representation of this Hashtable.
    # 
    # @return		the string representation of this Hashtable
    def to_s
      if ((size).equal?(0))
        return "{}" # $NON-NLS-1$
      end
      buffer = StringBuffer.new
      buffer.append(Character.new(?{.ord))
      i = @element_data.attr_length
      while (i -= 1) >= 0
        entry = @element_data[i]
        while (!(entry).nil?)
          buffer.append(entry.attr_key)
          buffer.append(Character.new(?=.ord))
          buffer.append(entry.attr_value)
          buffer.append(", ") # $NON-NLS-1$
          entry = entry.attr_next
        end
      end
      # Remove the last ", "
      if (@element_count > 0)
        buffer.set_length(buffer.length - 2)
      end
      buffer.append(Character.new(?}.ord))
      return buffer.to_s
    end
    
    private
    alias_method :initialize__custom_hashtable, :initialize
  end
  
end
