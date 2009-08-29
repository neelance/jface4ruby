require "rjava"

# Copyright (c) 2004, 2007 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Resource
  module ImageDataImageDescriptorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Resource
      include_const ::Org::Eclipse::Swt::Graphics, :Device
      include_const ::Org::Eclipse::Swt::Graphics, :Image
      include_const ::Org::Eclipse::Swt::Graphics, :ImageData
    }
  end
  
  # @since 3.1
  class ImageDataImageDescriptor < ImageDataImageDescriptorImports.const_get :ImageDescriptor
    include_class_members ImageDataImageDescriptorImports
    
    attr_accessor :data
    alias_method :attr_data, :data
    undef_method :data
    alias_method :attr_data=, :data=
    undef_method :data=
    
    # Original image being described, or null if this image is described
    # completely using its ImageData
    attr_accessor :original_image
    alias_method :attr_original_image, :original_image
    undef_method :original_image
    alias_method :attr_original_image=, :original_image=
    undef_method :original_image=
    
    typesig { [Image] }
    # Creates an image descriptor, given an image and the device it was created on.
    # 
    # @param originalImage
    def initialize(original_image)
      initialize__image_data_image_descriptor(original_image.get_image_data)
      @original_image = original_image
    end
    
    typesig { [ImageData] }
    # Creates an image descriptor, given some image data.
    # 
    # @param data describing the image
    def initialize(data)
      @data = nil
      @original_image = nil
      super()
      @original_image = nil
      @data = data
    end
    
    typesig { [Device] }
    # (non-Javadoc)
    # @see org.eclipse.jface.resource.DeviceResourceDescriptor#create(org.eclipse.swt.graphics.Device)
    def create_resource(device)
      # If this descriptor is an existing font, then we can return the original font
      # if this is the same device.
      if (!(@original_image).nil?)
        # If we're allocating on the same device as the original font, return the original.
        if ((@original_image.get_device).equal?(device))
          return @original_image
        end
      end
      return super(device)
    end
    
    typesig { [Object] }
    # (non-Javadoc)
    # @see org.eclipse.jface.resource.DeviceResourceDescriptor#destroy(java.lang.Object)
    def destroy_resource(previously_created_object)
      if ((previously_created_object).equal?(@original_image))
        return
      end
      super(previously_created_object)
    end
    
    typesig { [] }
    # (non-Javadoc)
    # @see org.eclipse.jface.resource.ImageDescriptor#getImageData()
    def get_image_data
      return @data
    end
    
    typesig { [] }
    # (non-Javadoc)
    # @see Object#hashCode
    def hash_code
      if (!(@original_image).nil?)
        return System.identity_hash_code(@original_image)
      end
      return @data.hash_code
    end
    
    typesig { [Object] }
    # (non-Javadoc)
    # @see Object#equals
    def ==(obj)
      if (!(obj.is_a?(ImageDataImageDescriptor)))
        return false
      end
      img_wrap = obj
      # Intentionally using == instead of equals() as Image.hashCode() changes
      # when the image is disposed and so leaks may occur with equals()
      if (!(@original_image).nil?)
        return (img_wrap.attr_original_image).equal?(@original_image)
      end
      return ((img_wrap.attr_original_image).nil? && (@data == img_wrap.attr_data))
    end
    
    private
    alias_method :initialize__image_data_image_descriptor, :initialize
  end
  
end
