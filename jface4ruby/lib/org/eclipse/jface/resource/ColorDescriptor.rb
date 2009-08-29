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
  module ColorDescriptorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Resource
      include_const ::Org::Eclipse::Swt::Graphics, :Color
      include_const ::Org::Eclipse::Swt::Graphics, :Device
      include_const ::Org::Eclipse::Swt::Graphics, :RGB
    }
  end
  
  # Lightweight descriptor for an SWT color. Each ColorDescriptor will create a particular SWT
  # Color on demand. This object will be compared so hashCode(...) and equals(...) must
  # return meaningful values.
  # 
  # @since 3.1
  class ColorDescriptor < ColorDescriptorImports.const_get :DeviceResourceDescriptor
    include_class_members ColorDescriptorImports
    
    class_module.module_eval {
      typesig { [Color, Device] }
      # Creates a ColorDescriptor from an existing Color, given the Device associated
      # with the original Color. This is the usual way to convert a Color into
      # a ColorDescriptor. Note that the returned ColorDescriptor depends on the
      # original Color, and disposing the Color will invalidate the ColorDescriptor.
      # 
      # @deprecated use {@link ColorDescriptor#createFrom(Color)}
      # 
      # @since 3.1
      # 
      # @param toCreate Color to convert into a ColorDescriptor.
      # @param originalDevice this must be the same Device that was passed into the
      # original Color's constructor.
      # @return a newly created ColorDescriptor that describes the given Color.
      def create_from(to_create, original_device)
        return RGBColorDescriptor.new(to_create)
      end
      
      typesig { [Color] }
      # Creates a ColorDescriptor from an existing color.
      # 
      # The returned ColorDescriptor depends on the original Color. Disposing
      # the original colour while the color descriptor is still in use may cause
      # SWT to throw a graphic disposed exception.
      # 
      # @since 3.1
      # 
      # @param toCreate Color to generate a ColorDescriptor from
      # @return a newly created ColorDescriptor
      def create_from(to_create)
        return RGBColorDescriptor.new(to_create)
      end
      
      typesig { [RGB] }
      # Returns a color descriptor for the given RGB values
      # @since 3.1
      # 
      # @param toCreate RGB values to create
      # @return a new ColorDescriptor
      def create_from(to_create)
        return RGBColorDescriptor.new(to_create)
      end
    }
    
    typesig { [Device] }
    # Returns the Color described by this descriptor.
    # 
    # @param device SWT device on which to allocate the Color
    # @return a newly allocated SWT Color object (never null)
    # @throws DeviceResourceException if unable to allocate the Color
    def create_color(device)
      raise NotImplementedError
    end
    
    typesig { [Color] }
    # Undoes whatever was done by createColor.
    # 
    # @since 3.1
    # 
    # @param toDestroy a Color that was previously allocated by an equal ColorDescriptor
    def destroy_color(to_destroy)
      raise NotImplementedError
    end
    
    typesig { [Device] }
    # (non-Javadoc)
    # @see org.eclipse.jface.resource.DeviceResourceDescriptor#createResource(org.eclipse.swt.graphics.Device)
    def create_resource(device)
      return create_color(device)
    end
    
    typesig { [Object] }
    # (non-Javadoc)
    # @see org.eclipse.jface.resource.DeviceResourceDescriptor#destroyResource(java.lang.Object)
    def destroy_resource(previously_created_object)
      destroy_color(previously_created_object)
    end
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__color_descriptor, :initialize
  end
  
end
