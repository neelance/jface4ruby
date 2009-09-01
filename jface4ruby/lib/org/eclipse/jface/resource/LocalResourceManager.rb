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
  module LocalResourceManagerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Resource
      include_const ::Org::Eclipse::Swt::Events, :DisposeEvent
      include_const ::Org::Eclipse::Swt::Events, :DisposeListener
      include_const ::Org::Eclipse::Swt::Graphics, :Device
      include_const ::Org::Eclipse::Swt::Graphics, :Image
      include_const ::Org::Eclipse::Swt::Widgets, :Control
    }
  end
  
  # A local registry that shares its resources with some global registry.
  # LocalResourceManager is typically used to safeguard against leaks. Clients
  # can use a nested registry to allocate and deallocate resources in the
  # global registry. Calling dispose() on the nested registry will deallocate
  # everything allocated for the nested registry without affecting the rest
  # of the global registry.
  # <p>
  # A nested registry can be used to manage the resources for, say, a dialog
  # box.
  # </p>
  # @since 3.1
  class LocalResourceManager < LocalResourceManagerImports.const_get :AbstractResourceManager
    include_class_members LocalResourceManagerImports
    
    attr_accessor :parent_registry
    alias_method :attr_parent_registry, :parent_registry
    undef_method :parent_registry
    alias_method :attr_parent_registry=, :parent_registry=
    undef_method :parent_registry=
    
    typesig { [ResourceManager] }
    # Creates a local registry that delegates to the given global registry
    # for all resource allocation and deallocation.
    # 
    # @param parentRegistry global registry
    def initialize(parent_registry)
      @parent_registry = nil
      super()
      @parent_registry = parent_registry
    end
    
    typesig { [ResourceManager, Control] }
    # Creates a local registry that wraps the given global registry. Anything
    # allocated by this registry will be automatically cleaned up with the given
    # control is disposed. Note that registries created in this way should not
    # be used to allocate any resource that must outlive the given control.
    # 
    # @param parentRegistry global registry that handles resource allocation
    # @param owner control whose disposal will trigger cleanup of everything
    # in the registry.
    def initialize(parent_registry, owner)
      initialize__local_resource_manager(parent_registry)
      owner.add_dispose_listener(Class.new(DisposeListener.class == Class ? DisposeListener : Object) do
        extend LocalClass
        include_class_members LocalResourceManager
        include DisposeListener if DisposeListener.class == Module
        
        typesig { [DisposeEvent] }
        # (non-Javadoc)
        # @see org.eclipse.swt.events.DisposeListener#widgetDisposed(org.eclipse.swt.events.DisposeEvent)
        define_method :widget_disposed do |e|
          @local_class_parent.dispose
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
    end
    
    typesig { [] }
    # (non-Javadoc)
    # @see org.eclipse.jface.resource.ResourceManager#getDevice()
    def get_device
      return @parent_registry.get_device
    end
    
    typesig { [DeviceResourceDescriptor] }
    # (non-Javadoc)
    # @see org.eclipse.jface.resource.AbstractResourceManager#allocate(org.eclipse.jface.resource.DeviceResourceDescriptor)
    def allocate(descriptor)
      return @parent_registry.create(descriptor)
    end
    
    typesig { [Object, DeviceResourceDescriptor] }
    # (non-Javadoc)
    # @see org.eclipse.jface.resource.AbstractResourceManager#deallocate(java.lang.Object, org.eclipse.jface.resource.DeviceResourceDescriptor)
    def deallocate(resource, descriptor)
      @parent_registry.destroy(descriptor)
    end
    
    typesig { [] }
    # (non-Javadoc)
    # @see org.eclipse.jface.resource.ResourceManager#getDefaultImage()
    def get_default_image
      return @parent_registry.get_default_image
    end
    
    private
    alias_method :initialize__local_resource_manager, :initialize
  end
  
end
