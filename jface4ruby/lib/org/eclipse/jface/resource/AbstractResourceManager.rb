require "rjava"

# Copyright (c) 2004, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Resource
  module AbstractResourceManagerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Resource
      include_const ::Java::Util, :Collection
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :Map
    }
  end
  
  # Abstract implementation of ResourceManager. Maintains reference counts for all previously
  # allocated SWT resources. Delegates to the abstract method allocate(...) the first time a resource
  # is referenced and delegates to the abstract method deallocate(...) the last time a reference is
  # removed.
  # 
  # @since 3.1
  class AbstractResourceManager < AbstractResourceManagerImports.const_get :ResourceManager
    include_class_members AbstractResourceManagerImports
    
    # Map of ResourceDescriptor onto RefCount. (null when empty)
    attr_accessor :map
    alias_method :attr_map, :map
    undef_method :map
    alias_method :attr_map=, :map=
    undef_method :map=
    
    class_module.module_eval {
      # Holds a reference count for a previously-allocated resource
      const_set_lazy(:RefCount) { Class.new do
        include_class_members AbstractResourceManager
        
        attr_accessor :resource
        alias_method :attr_resource, :resource
        undef_method :resource
        alias_method :attr_resource=, :resource=
        undef_method :resource=
        
        attr_accessor :count
        alias_method :attr_count, :count
        undef_method :count
        alias_method :attr_count=, :count=
        undef_method :count=
        
        typesig { [Object] }
        def initialize(resource)
          @resource = nil
          @count = 1
          @resource = resource
        end
        
        private
        alias_method :initialize__ref_count, :initialize
      end }
    }
    
    typesig { [DeviceResourceDescriptor] }
    # Called the first time a resource is requested. Should allocate and return a resource
    # of the correct type.
    # 
    # @since 3.1
    # 
    # @param descriptor identifier for the resource to allocate
    # @return the newly allocated resource
    # @throws DeviceResourceException Thrown when allocation of an SWT device resource fails
    def allocate(descriptor)
      raise NotImplementedError
    end
    
    typesig { [Object, DeviceResourceDescriptor] }
    # Called the last time a resource is dereferenced. Should release any resources reserved by
    # allocate(...).
    # 
    # @since 3.1
    # 
    # @param resource resource being deallocated
    # @param descriptor identifier for the resource
    def deallocate(resource, descriptor)
      raise NotImplementedError
    end
    
    typesig { [DeviceResourceDescriptor] }
    # (non-Javadoc)
    # @see ResourceManager#create(DeviceResourceDescriptor)
    def create(descriptor)
      # Lazily allocate the map
      if ((@map).nil?)
        @map = HashMap.new
      end
      # Get the current reference count
      count = @map.get(descriptor)
      if (!(count).nil?)
        # If this resource already exists, increment the reference count and return
        # the existing resource.
        count.attr_count += 1
        return count.attr_resource
      end
      # Allocate and return a new resource (with ref count = 1)
      resource = allocate(descriptor)
      count = RefCount.new(resource)
      @map.put(descriptor, count)
      return resource
    end
    
    typesig { [DeviceResourceDescriptor] }
    # (non-Javadoc)
    # @see ResourceManager#destroy(DeviceResourceDescriptor)
    def destroy(descriptor)
      # If the map is empty (null) then there are no resources to dispose
      if ((@map).nil?)
        return
      end
      # Find the existing resource
      count = @map.get(descriptor)
      if (!(count).nil?)
        # If the resource exists, decrement the reference count.
        count.attr_count -= 1
        if ((count.attr_count).equal?(0))
          # If this was the last reference, deallocate it.
          deallocate(count.attr_resource, descriptor)
          @map.remove(descriptor)
        end
      end
      # Null out the map when empty to save a small amount of memory
      if (@map.is_empty)
        @map = nil
      end
    end
    
    typesig { [] }
    # Deallocates any resources allocated by this registry that have not yet been
    # deallocated.
    # 
    # @since 3.1
    def dispose
      super
      if ((@map).nil?)
        return
      end
      entries = @map.entry_set
      iter = entries.iterator
      while iter.has_next
        next__ = iter.next_
        key = next__.get_key
        val = next__.get_value
        deallocate(val.attr_resource, key)
      end
      @map = nil
    end
    
    typesig { [DeviceResourceDescriptor] }
    # (non-Javadoc)
    # @see org.eclipse.jface.resource.ResourceManager#find(org.eclipse.jface.resource.DeviceResourceDescriptor)
    def find(descriptor)
      if ((@map).nil?)
        return nil
      end
      ref_count = @map.get(descriptor)
      if ((ref_count).nil?)
        return nil
      end
      return ref_count.attr_resource
    end
    
    typesig { [] }
    def initialize
      @map = nil
      super()
      @map = nil
    end
    
    private
    alias_method :initialize__abstract_resource_manager, :initialize
  end
  
end
