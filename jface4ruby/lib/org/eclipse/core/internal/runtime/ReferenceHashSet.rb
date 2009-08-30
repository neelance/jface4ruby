require "rjava"

# Copyright (c) 2004, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Core::Internal::Runtime
  module ReferenceHashSetImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Internal::Runtime
      include ::Java::Lang::Ref
    }
  end
  
  # A hashset whose values can be garbage collected.
  # This API is EXPERIMENTAL and provided as early access.
  # @since 3.1
  class ReferenceHashSet 
    include_class_members ReferenceHashSetImports
    
    class_module.module_eval {
      const_set_lazy(:HashedReference) { Module.new do
        include_class_members ReferenceHashSet
        
        typesig { [] }
        def hash_code
          raise NotImplementedError
        end
        
        typesig { [] }
        def get
          raise NotImplementedError
        end
      end }
      
      const_set_lazy(:HashableWeakReference) { Class.new(WeakReference) do
        extend LocalClass
        include_class_members ReferenceHashSet
        overload_protected {
          include HashedReference
        }
        
        attr_accessor :hash_code
        alias_method :attr_hash_code, :hash_code
        undef_method :hash_code
        alias_method :attr_hash_code=, :hash_code=
        undef_method :hash_code=
        
        typesig { [Object, class_self::ReferenceQueue] }
        def initialize(referent, queue)
          @hash_code = 0
          super(referent, queue)
          @hash_code = referent.hash_code
        end
        
        typesig { [Object] }
        def ==(obj)
          if (!(obj.is_a?(self.class::HashableWeakReference)))
            return false
          end
          referent = WeakReference.instance_method(:get).bind(self).call
          other = (obj).get
          if ((referent).nil?)
            return (other).nil?
          end
          return (referent == other)
        end
        
        typesig { [] }
        def hash_code
          return @hash_code
        end
        
        typesig { [] }
        def to_s
          referent = WeakReference.instance_method(:get).bind(self).call
          if ((referent).nil?)
            return "[hashCode=" + RJava.cast_to_string(@hash_code) + "] <referent was garbage collected>"
          end # $NON-NLS-1$  //$NON-NLS-2$
          return "[hashCode=" + RJava.cast_to_string(@hash_code) + "] " + RJava.cast_to_string(referent.to_s) # $NON-NLS-1$ //$NON-NLS-2$
        end
        
        private
        alias_method :initialize__hashable_weak_reference, :initialize
      end }
      
      const_set_lazy(:HashableSoftReference) { Class.new(SoftReference) do
        extend LocalClass
        include_class_members ReferenceHashSet
        overload_protected {
          include HashedReference
        }
        
        attr_accessor :hash_code
        alias_method :attr_hash_code, :hash_code
        undef_method :hash_code
        alias_method :attr_hash_code=, :hash_code=
        undef_method :hash_code=
        
        typesig { [Object, class_self::ReferenceQueue] }
        def initialize(referent, queue)
          @hash_code = 0
          super(referent, queue)
          @hash_code = referent.hash_code
        end
        
        typesig { [Object] }
        def ==(obj)
          if (!(obj.is_a?(self.class::HashableWeakReference)))
            return false
          end
          referent = SoftReference.instance_method(:get).bind(self).call
          other = (obj).get
          if ((referent).nil?)
            return (other).nil?
          end
          return (referent == other)
        end
        
        typesig { [] }
        def hash_code
          return @hash_code
        end
        
        typesig { [] }
        def to_s
          referent = SoftReference.instance_method(:get).bind(self).call
          if ((referent).nil?)
            return "[hashCode=" + RJava.cast_to_string(@hash_code) + "] <referent was garbage collected>"
          end # $NON-NLS-1$  //$NON-NLS-2$
          return "[hashCode=" + RJava.cast_to_string(@hash_code) + "] " + RJava.cast_to_string(referent.to_s) # $NON-NLS-1$ //$NON-NLS-2$
        end
        
        private
        alias_method :initialize__hashable_soft_reference, :initialize
      end }
      
      const_set_lazy(:StrongReference) { Class.new do
        extend LocalClass
        include_class_members ReferenceHashSet
        include HashedReference
        
        attr_accessor :referent
        alias_method :attr_referent, :referent
        undef_method :referent
        alias_method :attr_referent=, :referent=
        undef_method :referent=
        
        typesig { [Object, class_self::ReferenceQueue] }
        def initialize(referent, queue)
          @referent = nil
          @referent = referent
        end
        
        typesig { [] }
        def hash_code
          return @referent.hash_code
        end
        
        typesig { [] }
        def get
          return @referent
        end
        
        typesig { [Object] }
        def ==(obj)
          return (@referent == obj)
        end
        
        private
        alias_method :initialize__strong_reference, :initialize
      end }
    }
    
    attr_accessor :values
    alias_method :attr_values, :values
    undef_method :values
    alias_method :attr_values=, :values=
    undef_method :values=
    
    attr_accessor :element_size
    alias_method :attr_element_size, :element_size
    undef_method :element_size
    alias_method :attr_element_size=, :element_size=
    undef_method :element_size=
    
    # number of elements in the table
    attr_accessor :threshold
    alias_method :attr_threshold, :threshold
    undef_method :threshold
    alias_method :attr_threshold=, :threshold=
    undef_method :threshold=
    
    attr_accessor :reference_queue
    alias_method :attr_reference_queue, :reference_queue
    undef_method :reference_queue
    alias_method :attr_reference_queue=, :reference_queue=
    undef_method :reference_queue=
    
    typesig { [] }
    def initialize
      initialize__reference_hash_set(5)
    end
    
    typesig { [::Java::Int] }
    def initialize(size)
      @values = nil
      @element_size = 0
      @threshold = 0
      @reference_queue = ReferenceQueue.new
      @element_size = 0
      @threshold = size # size represents the expected
      # number of elements
      extra_room = RJava.cast_to_int((size * 1.75))
      if ((@threshold).equal?(extra_room))
        extra_room += 1
      end
      @values = Array.typed(HashedReference).new(extra_room) { nil }
    end
    
    class_module.module_eval {
      # Constant indicating that hard references should be used.
      const_set_lazy(:HARD) { 0 }
      const_attr_reader  :HARD
      
      # Constant indiciating that soft references should be used.
      const_set_lazy(:SOFT) { 1 }
      const_attr_reader  :SOFT
      
      # Constant indicating that weak references should be used.
      const_set_lazy(:WEAK) { 2 }
      const_attr_reader  :WEAK
    }
    
    typesig { [::Java::Int, Object] }
    def to_reference(type, referent)
      case (type)
      when HARD
        return StrongReference.new_local(self, referent, @reference_queue)
      when SOFT
        return HashableSoftReference.new_local(self, referent, @reference_queue)
      when WEAK
        return HashableWeakReference.new_local(self, referent, @reference_queue)
      else
        raise JavaError.new
      end
    end
    
    typesig { [Object, ::Java::Int] }
    # Adds the given object to this set. If an object that is equals to the
    # given object already exists, do nothing. Returns the existing object or
    # the new object if not found.
    def add(obj, reference_type)
      cleanup_garbage_collected_values
      index = (obj.hash_code & 0x7fffffff) % @values.attr_length
      current_value = nil
      while (!((current_value = @values[index])).nil?)
        referent = nil
        if ((obj == referent = current_value.get))
          return referent
        end
        index = (index + 1) % @values.attr_length
      end
      @values[index] = to_reference(reference_type, obj)
      # assumes the threshold is never equal to the size of the table
      if ((@element_size += 1) > @threshold)
        rehash
      end
      return obj
    end
    
    typesig { [HashedReference] }
    def add_value(value)
      obj = value.get
      if ((obj).nil?)
        return
      end
      values_length = @values.attr_length
      index = (value.hash_code & 0x7fffffff) % values_length
      current_value = nil
      while (!((current_value = @values[index])).nil?)
        if ((obj == current_value.get))
          return
        end
        index = (index + 1) % values_length
      end
      @values[index] = value
      # assumes the threshold is never equal to the size of the table
      if ((@element_size += 1) > @threshold)
        rehash
      end
    end
    
    typesig { [] }
    def cleanup_garbage_collected_values
      to_be_removed = nil
      while (!((to_be_removed = @reference_queue.poll)).nil?)
        hash_code_ = to_be_removed.hash_code
        values_length = @values.attr_length
        index = (hash_code_ & 0x7fffffff) % values_length
        current_value = nil
        while (!((current_value = @values[index])).nil?)
          if ((current_value).equal?(to_be_removed))
            # replace the value at index with the last value with the
            # same hash
            same_hash = index
            current = 0
            while (!((current_value = @values[current = (same_hash + 1) % values_length])).nil? && (current_value.hash_code).equal?(hash_code_))
              same_hash = current
            end
            @values[index] = @values[same_hash]
            @values[same_hash] = nil
            @element_size -= 1
            break
          end
          index = (index + 1) % values_length
        end
      end
    end
    
    typesig { [Object] }
    def contains(obj)
      return !(get(obj)).nil?
    end
    
    typesig { [Object] }
    # Return the object that is in this set and that is equals to the given
    # object. Return null if not found.
    def get(obj)
      cleanup_garbage_collected_values
      values_length = @values.attr_length
      index = (obj.hash_code & 0x7fffffff) % values_length
      current_value = nil
      while (!((current_value = @values[index])).nil?)
        referent = nil
        if ((obj == referent = current_value.get))
          return referent
        end
        index = (index + 1) % values_length
      end
      return nil
    end
    
    typesig { [] }
    def rehash
      new_hash_set = ReferenceHashSet.new(@element_size * 2) # double the number of expected elements
      new_hash_set.attr_reference_queue = @reference_queue
      current_value = nil
      i = 0
      length = @values.attr_length
      while i < length
        if (!((current_value = @values[i])).nil?)
          new_hash_set.add_value(current_value)
        end
        i += 1
      end
      @values = new_hash_set.attr_values
      @threshold = new_hash_set.attr_threshold
      @element_size = new_hash_set.attr_element_size
    end
    
    typesig { [Object] }
    # Removes the object that is in this set and that is equals to the given
    # object. Return the object that was in the set, or null if not found.
    def remove(obj)
      cleanup_garbage_collected_values
      values_length = @values.attr_length
      index = (obj.hash_code & 0x7fffffff) % values_length
      current_value = nil
      while (!((current_value = @values[index])).nil?)
        referent = nil
        if ((obj == referent = current_value.get))
          @element_size -= 1
          @values[index] = nil
          rehash
          return referent
        end
        index = (index + 1) % values_length
      end
      return nil
    end
    
    typesig { [] }
    def size
      return @element_size
    end
    
    typesig { [] }
    def to_s
      buffer = StringBuffer.new("{") # $NON-NLS-1$
      i = 0
      length = @values.attr_length
      while i < length
        value = @values[i]
        if (!(value).nil?)
          ref = value.get
          if (!(ref).nil?)
            buffer.append(ref.to_s)
            buffer.append(", ") # $NON-NLS-1$
          end
        end
        i += 1
      end
      buffer.append("}") # $NON-NLS-1$
      return buffer.to_s
    end
    
    typesig { [] }
    def to_array
      cleanup_garbage_collected_values
      result = Array.typed(Object).new(@element_size) { nil }
      result_size = 0
      i = 0
      while i < @values.attr_length
        if ((@values[i]).nil?)
          i += 1
          next
        end
        tmp = @values[i].get
        if (!(tmp).nil?)
          result[((result_size += 1) - 1)] = tmp
        end
        i += 1
      end
      if ((result.attr_length).equal?(result_size))
        return result
      end
      final_result = Array.typed(Object).new(result_size) { nil }
      System.arraycopy(result, 0, final_result, 0, result_size)
      return final_result
    end
    
    private
    alias_method :initialize__reference_hash_set, :initialize
  end
  
end
