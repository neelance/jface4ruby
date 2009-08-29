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
  module DeviceResourceManagerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Resource
      include_const ::Org::Eclipse::Swt::Graphics, :Device
      include_const ::Org::Eclipse::Swt::Graphics, :Image
    }
  end
  
  # Manages SWT resources for a particular device.
  # 
  # <p>
  # IMPORTANT: in most cases clients should use a <code>LocalResourceManager</code> instead of a
  # <code>DeviceResourceManager</code>. To create a resource manager on a particular display,
  # use <code>new LocalResourceManager(JFaceResources.getResources(myDisplay))</code>.
  # <code>DeviceResourceManager</code> should only be used directly when managing
  # resources for a device other than a Display (such as a printer).
  # </p>
  # 
  # @see LocalResourceManager
  # 
  # @since 3.1
  class DeviceResourceManager < DeviceResourceManagerImports.const_get :AbstractResourceManager
    include_class_members DeviceResourceManagerImports
    
    attr_accessor :device
    alias_method :attr_device, :device
    undef_method :device
    alias_method :attr_device=, :device=
    undef_method :device=
    
    attr_accessor :missing_image
    alias_method :attr_missing_image, :missing_image
    undef_method :missing_image
    alias_method :attr_missing_image=, :missing_image=
    undef_method :missing_image=
    
    typesig { [] }
    # (non-Javadoc)
    # @see org.eclipse.jface.resource.ResourceManager#getDevice()
    def get_device
      return @device
    end
    
    typesig { [Device] }
    # Creates a new registry for the given device.
    # 
    # @param device device to manage
    def initialize(device)
      @device = nil
      @missing_image = nil
      super()
      @device = device
    end
    
    typesig { [DeviceResourceDescriptor] }
    # (non-Javadoc)
    # @see org.eclipse.jface.resource.AbstractResourceManager#allocate(org.eclipse.jface.resource.DeviceResourceDescriptor)
    def allocate(descriptor)
      return descriptor.create_resource(@device)
    end
    
    typesig { [Object, DeviceResourceDescriptor] }
    # (non-Javadoc)
    # @see org.eclipse.jface.resource.AbstractResourceManager#deallocate(java.lang.Object, org.eclipse.jface.resource.DeviceResourceDescriptor)
    def deallocate(resource, descriptor)
      descriptor.destroy_resource(resource)
    end
    
    typesig { [] }
    # (non-Javadoc)
    # @see org.eclipse.jface.resource.ResourceManager#getDefaultImage()
    def get_default_image
      if ((@missing_image).nil?)
        @missing_image = ImageDescriptor.get_missing_image_descriptor.create_image
      end
      return @missing_image
    end
    
    typesig { [] }
    # (non-Javadoc)
    # @see org.eclipse.jface.resource.AbstractResourceManager#dispose()
    def dispose
      super
      if (!(@missing_image).nil?)
        @missing_image.dispose
        @missing_image = nil
      end
    end
    
    private
    alias_method :initialize__device_resource_manager, :initialize
  end
  
end
