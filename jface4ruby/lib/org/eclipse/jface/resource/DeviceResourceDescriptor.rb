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
  module DeviceResourceDescriptorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Resource
      include_const ::Org::Eclipse::Swt::Graphics, :Device
    }
  end
  
  # Instances of this class can allocate and dispose SWT resources. Each
  # instance describes a particular resource (such as a Color, Font, or Image)
  # and can create and destroy that resource on demand. DeviceResourceDescriptors
  # are managed by a ResourceRegistry.
  # 
  # @see org.eclipse.jface.resource.ResourceManager
  # 
  # @since 3.1
  class DeviceResourceDescriptor 
    include_class_members DeviceResourceDescriptorImports
    
    typesig { [Device] }
    # Creates the resource described by this descriptor
    # 
    # @since 3.1
    # 
    # @param device the Device on which to allocate the resource
    # @return the newly allocated resource (not null)
    # @throws DeviceResourceException if unable to allocate the resource
    def create_resource(device)
      raise NotImplementedError
    end
    
    typesig { [Object] }
    # Undoes everything that was done by a previous call to create(...), given
    # the object that was returned by create(...).
    # 
    # @since 3.1
    # 
    # @param previouslyCreatedObject an object that was returned by an equal
    # descriptor in a previous call to createResource(...).
    def destroy_resource(previously_created_object)
      raise NotImplementedError
    end
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__device_resource_descriptor, :initialize
  end
  
end
