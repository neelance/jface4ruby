require "rjava"

# Copyright (c) 2004, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Viewers::Deferred
  module IntHashMapImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers::Deferred
      include_const ::Java::Util, :HashMap
    }
  end
  
  # Represents a map of objects onto ints. This is intended for future optimization:
  # using int primitives would allow for an implementation that doesn't require
  # additional object allocations for Integers. However, the current implementation
  # simply delegates to the Java HashMap class.
  # 
  # @since 3.1
  # 
  # package
  class IntHashMap 
    include_class_members IntHashMapImports
    
    attr_accessor :map
    alias_method :attr_map, :map
    undef_method :map
    alias_method :attr_map=, :map=
    undef_method :map=
    
    typesig { [::Java::Int, ::Java::Float] }
    # @param size
    # @param loadFactor
    def initialize(size, load_factor)
      @map = nil
      @map = HashMap.new(size, load_factor)
    end
    
    typesig { [] }
    def initialize
      @map = nil
      @map = HashMap.new
    end
    
    typesig { [Object] }
    # @param key
    def remove(key)
      @map.remove(key)
    end
    
    typesig { [Object, ::Java::Int] }
    # @param key
    # @param value
    def put(key, value)
      @map.put(key, value)
    end
    
    typesig { [Object] }
    # @param key
    # @return the int value at the given key
    def get(key)
      return get(key, 0)
    end
    
    typesig { [Object, ::Java::Int] }
    # @param key
    # @param defaultValue
    # @return the int value at the given key, or the default value if this map does not contain the given key
    def get(key, default_value)
      result = @map.get(key)
      if (!(result).nil?)
        return result.int_value
      end
      return default_value
    end
    
    typesig { [Object] }
    # @param key
    # @return <code>true</code> if this map contains the given key, <code>false</code> otherwise
    def contains_key(key)
      return @map.contains_key(key)
    end
    
    typesig { [] }
    # @return the number of key/value pairs
    def size
      return @map.size
    end
    
    private
    alias_method :initialize__int_hash_map, :initialize
  end
  
end
