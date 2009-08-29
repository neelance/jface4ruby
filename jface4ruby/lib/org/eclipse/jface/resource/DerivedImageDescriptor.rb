require "rjava"

# Copyright (c) 2005, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Resource
  module DerivedImageDescriptorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Resource
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt, :SWTException
      include_const ::Org::Eclipse::Swt::Graphics, :Device
      include_const ::Org::Eclipse::Swt::Graphics, :Image
      include_const ::Org::Eclipse::Swt::Graphics, :ImageData
      include_const ::Org::Eclipse::Swt::Widgets, :Display
    }
  end
  
  # An image descriptor which creates images based on another ImageDescriptor, but with
  # additional SWT flags. Note that this is only intended for compatibility.
  # 
  # @since 3.1
  class DerivedImageDescriptor < DerivedImageDescriptorImports.const_get :ImageDescriptor
    include_class_members DerivedImageDescriptorImports
    
    attr_accessor :original
    alias_method :attr_original, :original
    undef_method :original
    alias_method :attr_original=, :original=
    undef_method :original=
    
    attr_accessor :flags
    alias_method :attr_flags, :flags
    undef_method :flags
    alias_method :attr_flags=, :flags=
    undef_method :flags=
    
    typesig { [ImageDescriptor, ::Java::Int] }
    # Create a new image descriptor
    # @param original the original one
    # @param swtFlags flags to be used when image is created {@link Image#Image(Device, Image, int)}
    # @see SWT#IMAGE_COPY
    # @see SWT#IMAGE_DISABLE
    # @see SWT#IMAGE_GRAY
    def initialize(original, swt_flags)
      @original = nil
      @flags = 0
      super()
      @original = original
      @flags = swt_flags
    end
    
    typesig { [Device] }
    def create_resource(device)
      begin
        return internal_create_image(device)
      rescue SWTException => e
        raise DeviceResourceException.new(self, e)
      end
    end
    
    typesig { [Device] }
    def create_image(device)
      return internal_create_image(device)
    end
    
    typesig { [] }
    def hash_code
      return @original.hash_code + @flags
    end
    
    typesig { [Object] }
    def ==(arg0)
      if (arg0.is_a?(DerivedImageDescriptor))
        desc = arg0
        return (desc.attr_original).equal?(@original) && (@flags).equal?(desc.attr_flags)
      end
      return false
    end
    
    typesig { [Device] }
    # Creates a new Image on the given device. Note that we defined a new
    # method rather than overloading createImage since this needs to be
    # called by getImageData(), and we want to be absolutely certain not
    # to cause infinite recursion if the base class gets refactored.
    # 
    # @param device device to create the image on
    # @return a newly allocated Image. Must be disposed by calling image.dispose().
    def internal_create_image(device)
      original_image = @original.create_image(device)
      result = Image.new(device, original_image, @flags)
      @original.destroy_resource(original_image)
      return result
    end
    
    typesig { [] }
    def get_image_data
      image = internal_create_image(Display.get_current)
      result = image.get_image_data
      image.dispose
      return result
    end
    
    private
    alias_method :initialize__derived_image_descriptor, :initialize
  end
  
end
