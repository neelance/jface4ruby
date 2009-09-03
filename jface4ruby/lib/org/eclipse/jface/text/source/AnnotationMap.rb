require "rjava"

# Copyright (c) 2000, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Source
  module AnnotationMapImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Source
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :Collection
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :Map
      include_const ::Java::Util, :JavaSet
    }
  end
  
  # Internal implementation of {@link org.eclipse.jface.text.source.IAnnotationMap}.
  # 
  # @since 3.0
  class AnnotationMap 
    include_class_members AnnotationMapImports
    include IAnnotationMap
    
    # The lock object used to synchronize the operations explicitly defined by
    # <code>IAnnotationMap</code>
    attr_accessor :f_lock_object
    alias_method :attr_f_lock_object, :f_lock_object
    undef_method :f_lock_object
    alias_method :attr_f_lock_object=, :f_lock_object=
    undef_method :f_lock_object=
    
    # The internal lock object used if <code>fLockObject</code> is <code>null</code>.
    # @since 3.2
    attr_accessor :f_internal_lock_object
    alias_method :attr_f_internal_lock_object, :f_internal_lock_object
    undef_method :f_internal_lock_object
    alias_method :attr_f_internal_lock_object=, :f_internal_lock_object=
    undef_method :f_internal_lock_object=
    
    # The map holding the annotations
    attr_accessor :f_internal_map
    alias_method :attr_f_internal_map, :f_internal_map
    undef_method :f_internal_map
    alias_method :attr_f_internal_map=, :f_internal_map=
    undef_method :f_internal_map=
    
    typesig { [::Java::Int] }
    # Creates a new annotation map with the given capacity.
    # 
    # @param capacity the capacity
    def initialize(capacity)
      @f_lock_object = nil
      @f_internal_lock_object = Object.new
      @f_internal_map = nil
      @f_internal_map = HashMap.new(capacity)
    end
    
    typesig { [Object] }
    # @see org.eclipse.jface.text.source.ISynchronizable#setLockObject(java.lang.Object)
    def set_lock_object(lock_object)
      synchronized(self) do
        @f_lock_object = lock_object
      end
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.source.ISynchronizable#getLockObject()
    def get_lock_object
      synchronized(self) do
        if ((@f_lock_object).nil?)
          return @f_internal_lock_object
        end
        return @f_lock_object
      end
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.source.IAnnotationMap#valuesIterator()
    def values_iterator
      synchronized((get_lock_object)) do
        return ArrayList.new(@f_internal_map.values).iterator
      end
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.source.IAnnotationMap#keySetIterator()
    def key_set_iterator
      synchronized((get_lock_object)) do
        return ArrayList.new(@f_internal_map.key_set).iterator
      end
    end
    
    typesig { [Object] }
    # @see java.util.Map#containsKey(java.lang.Object)
    def contains_key(annotation)
      synchronized((get_lock_object)) do
        return @f_internal_map.contains_key(annotation)
      end
    end
    
    typesig { [Object, Object] }
    # @see java.util.Map#put(java.lang.Object, java.lang.Object)
    def put(annotation, position)
      synchronized((get_lock_object)) do
        return @f_internal_map.put(annotation, position)
      end
    end
    
    typesig { [Object] }
    # @see java.util.Map#get(java.lang.Object)
    def get(annotation)
      synchronized((get_lock_object)) do
        return @f_internal_map.get(annotation)
      end
    end
    
    typesig { [] }
    # @see java.util.Map#clear()
    def clear
      synchronized((get_lock_object)) do
        @f_internal_map.clear
      end
    end
    
    typesig { [Object] }
    # @see java.util.Map#remove(java.lang.Object)
    def remove(annotation)
      synchronized((get_lock_object)) do
        return @f_internal_map.remove(annotation)
      end
    end
    
    typesig { [] }
    # @see java.util.Map#size()
    def size
      synchronized((get_lock_object)) do
        return @f_internal_map.size
      end
    end
    
    typesig { [] }
    # @see java.util.Map#isEmpty()
    def is_empty
      synchronized((get_lock_object)) do
        return @f_internal_map.is_empty
      end
    end
    
    typesig { [Object] }
    # @see java.util.Map#containsValue(java.lang.Object)
    def contains_value(value)
      synchronized((get_lock_object)) do
        return @f_internal_map.contains_value(value)
      end
    end
    
    typesig { [Map] }
    # @see java.util.Map#putAll(java.util.Map)
    def put_all(map)
      synchronized((get_lock_object)) do
        @f_internal_map.put_all(map)
      end
    end
    
    typesig { [] }
    # @see IAnnotationMap#entrySet()
    def entry_set
      synchronized((get_lock_object)) do
        return @f_internal_map.entry_set
      end
    end
    
    typesig { [] }
    # @see IAnnotationMap#keySet()
    def key_set
      synchronized((get_lock_object)) do
        return @f_internal_map.key_set
      end
    end
    
    typesig { [] }
    # @see IAnnotationMap#values()
    def values
      synchronized((get_lock_object)) do
        return @f_internal_map.values
      end
    end
    
    private
    alias_method :initialize__annotation_map, :initialize
  end
  
end
