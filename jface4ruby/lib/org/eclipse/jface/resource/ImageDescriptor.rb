require "rjava"

# Copyright (c) 2000, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Resource
  module ImageDescriptorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Resource
      include_const ::Java::Net, :URL
      include_const ::Org::Eclipse::Swt, :SWTException
      include_const ::Org::Eclipse::Swt::Graphics, :Device
      include_const ::Org::Eclipse::Swt::Graphics, :Image
      include_const ::Org::Eclipse::Swt::Graphics, :ImageData
      include_const ::Org::Eclipse::Swt::Graphics, :PaletteData
      include_const ::Org::Eclipse::Swt::Graphics, :RGB
      include_const ::Org::Eclipse::Swt::Widgets, :Display
    }
  end
  
  # An image descriptor is an object that knows how to create
  # an SWT image.  It does not hold onto images or cache them,
  # but rather just creates them on demand.  An image descriptor
  # is intended to be a lightweight representation of an image
  # that can be manipulated even when no SWT display exists.
  # <p>
  # This package defines a concrete image descriptor implementation
  # which reads an image from a file (<code>FileImageDescriptor</code>).
  # It also provides abstract framework classes (this one and
  # <code>CompositeImageDescriptor</code>) which may be subclassed to define
  # news kinds of image descriptors.
  # </p>
  # <p>
  # Using this abstract class involves defining a concrete subclass
  # and providing an implementation for the <code>getImageData</code>
  # method.
  # </p>
  # <p>
  # There are two ways to get an Image from an ImageDescriptor. The method
  # createImage will always return a new Image which must be disposed by
  # the caller. Alternatively, createResource() returns a shared
  # Image. When the caller is done with an image obtained from createResource,
  # they must call destroyResource() rather than disposing the Image directly.
  # The result of createResource() can be safely cast to an Image.
  # </p>
  # 
  # @see org.eclipse.swt.graphics.Image
  class ImageDescriptor < ImageDescriptorImports.const_get :DeviceResourceDescriptor
    include_class_members ImageDescriptorImports
    
    class_module.module_eval {
      # A small red square used to warn that an image cannot be created.
      # <p>
      const_set_lazy(:DEFAULT_IMAGE_DATA) { ImageData.new(6, 6, 1, PaletteData.new(Array.typed(RGB).new([RGB.new(255, 0, 0)]))) }
      const_attr_reader  :DEFAULT_IMAGE_DATA
    }
    
    typesig { [] }
    # Constructs an image descriptor.
    def initialize
      super()
      # do nothing
    end
    
    class_module.module_eval {
      typesig { [Class, String] }
      # Creates and returns a new image descriptor from a file.
      # Convenience method for
      # <code>new FileImageDescriptor(location,filename)</code>.
      # 
      # @param location the class whose resource directory contain the file
      # @param filename the file name
      # @return a new image descriptor
      def create_from_file(location, filename)
        return FileImageDescriptor.new(location, filename)
      end
      
      typesig { [ImageData] }
      # Creates and returns a new image descriptor given ImageData
      # describing the image.
      # 
      # @since 3.1
      # 
      # @param data contents of the image
      # @return newly created image descriptor
      def create_from_image_data(data)
        return ImageDataImageDescriptor.new(data)
      end
      
      typesig { [Image] }
      # Creates and returns a new image descriptor for the given image. Note
      # that disposing the original Image will cause the descriptor to become invalid.
      # 
      # @since 3.1
      # 
      # @param img image to create
      # @return a newly created image descriptor
      def create_from_image(img)
        return ImageDataImageDescriptor.new(img)
      end
      
      typesig { [ImageDescriptor, ::Java::Int] }
      # Creates an ImageDescriptor based on the given original descriptor, but with additional
      # SWT flags.
      # 
      # <p>
      # Note that this sort of ImageDescriptor is slower and consumes more resources than
      # a regular image descriptor. It will also never generate results that look as nice as
      # a hand-drawn image. Clients are encouraged to supply their own disabled/grayed/etc. images
      # rather than using a default image and transforming it.
      # </p>
      # 
      # @param originalImage image to transform
      # @param swtFlags any flag that can be passed to the flags argument of Image#Image(Device, Image, int)
      # @return an ImageDescriptor that creates new images by transforming the given image descriptor
      # 
      # @see Image#Image(Device, Image, int)
      # @since 3.1
      def create_with_flags(original_image, swt_flags)
        return DerivedImageDescriptor.new(original_image, swt_flags)
      end
      
      typesig { [Image, Device] }
      # Creates and returns a new image descriptor for the given image. This
      # method takes the Device that created the Image as an argument, allowing
      # the original Image to be reused if the descriptor is asked for another
      # Image on the same device. Note that disposing the original Image will
      # cause the descriptor to become invalid.
      # 
      # @deprecated use {@link ImageDescriptor#createFromImage(Image)}
      # @since 3.1
      # 
      # @param img image to create
      # @param theDevice the device that was used to create the Image
      # @return a newly created image descriptor
      def create_from_image(img, the_device)
        return ImageDataImageDescriptor.new(img)
      end
      
      typesig { [URL] }
      # Creates and returns a new image descriptor from a URL.
      # 
      # @param url The URL of the image file.
      # @return a new image descriptor
      def create_from_url(url)
        if ((url).nil?)
          return get_missing_image_descriptor
        end
        return URLImageDescriptor.new(url)
      end
    }
    
    typesig { [Device] }
    # (non-Javadoc)
    # @see org.eclipse.jface.resource.DeviceResourceDescriptor#createResource(org.eclipse.swt.graphics.Device)
    def create_resource(device)
      result = create_image(false, device)
      if ((result).nil?)
        raise DeviceResourceException.new(self)
      end
      return result
    end
    
    typesig { [Object] }
    # (non-Javadoc)
    # @see org.eclipse.jface.resource.DeviceResourceDescriptor#destroyResource(Object)
    def destroy_resource(previously_created_object)
      (previously_created_object).dispose
    end
    
    typesig { [] }
    # Creates and returns a new SWT image for this image descriptor. Note that
    # each call returns a new SWT image object. The returned image must be
    # explicitly disposed using the image's dispose call. The image will not be
    # automatically garbage collected. A default image is returned in the event
    # of an error.
    # 
    # <p>
    # Note: this method differs from createResource(Device) in that the returned image
    # must be disposed directly, whereas an image obtained from createResource(...)
    # must be disposed by calling destroyResource(...). It is not possible to
    # mix-and-match. If you obtained the Image from this method, you must not dispose
    # it by calling destroyResource. Clients are encouraged to use
    # create/destroyResource and downcast the result to Image rather than using
    # createImage.
    # </p>
    # 
    # <p>
    # Note: it is still possible for this method to return <code>null</code>
    # in extreme cases, for example if SWT runs out of image handles.
    # </p>
    # 
    # @return a new image or <code>null</code> if the image could not be
    # created
    def create_image
      return create_image(true)
    end
    
    typesig { [::Java::Boolean] }
    # Creates and returns a new SWT image for this image descriptor. The
    # returned image must be explicitly disposed using the image's dispose
    # call. The image will not be automatically garbage collected. In the event
    # of an error, a default image is returned if
    # <code>returnMissingImageOnError</code> is true, otherwise
    # <code>null</code> is returned.
    # <p>
    # Note: Even if <code>returnMissingImageOnError</code> is true, it is
    # still possible for this method to return <code>null</code> in extreme
    # cases, for example if SWT runs out of image handles.
    # </p>
    # 
    # @param returnMissingImageOnError
    # flag that determines if a default image is returned on error
    # @return a new image or <code>null</code> if the image could not be
    # created
    def create_image(return_missing_image_on_error)
      return create_image(return_missing_image_on_error, Display.get_current)
    end
    
    typesig { [Device] }
    # Creates and returns a new SWT image for this image descriptor. The
    # returned image must be explicitly disposed using the image's dispose
    # call. The image will not be automatically garbage collected. A default
    # image is returned in the event of an error.
    # <p>
    # Note: it is still possible for this method to return <code>null</code>
    # in extreme cases, for example if SWT runs out of image handles.
    # </p>
    # 
    # @param device
    # the device on which to create the image
    # @return a new image or <code>null</code> if the image could not be
    # created
    # @since 2.0
    def create_image(device)
      return create_image(true, device)
    end
    
    typesig { [::Java::Boolean, Device] }
    # Creates and returns a new SWT image for this image descriptor. The
    # returned image must be explicitly disposed using the image's dispose
    # call. The image will not be automatically garbage collected. In the even
    # of an error, a default image is returned if
    # <code>returnMissingImageOnError</code> is true, otherwise
    # <code>null</code> is returned.
    # <p>
    # Note: Even if <code>returnMissingImageOnError</code> is true, it is
    # still possible for this method to return <code>null</code> in extreme
    # cases, for example if SWT runs out of image handles.
    # </p>
    # 
    # @param returnMissingImageOnError
    # flag that determines if a default image is returned on error
    # @param device
    # the device on which to create the image
    # @return a new image or <code>null</code> if the image could not be
    # created
    # @since 2.0
    def create_image(return_missing_image_on_error, device)
      data = get_image_data
      if ((data).nil?)
        if (!return_missing_image_on_error)
          return nil
        end
        data = DEFAULT_IMAGE_DATA
      end
      # Try to create the supplied image. If there is an SWT Exception try and create
      # the default image if that was requested. Return null if this fails.
      begin
        if (data.attr_transparent_pixel >= 0)
          mask_data = data.get_transparency_mask
          return Image.new(device, data, mask_data)
        end
        return Image.new(device, data)
      rescue SWTException => exception
        if (return_missing_image_on_error)
          begin
            return Image.new(device, DEFAULT_IMAGE_DATA)
          rescue SWTException => next_exception
            return nil
          end
        end
        return nil
      end
    end
    
    typesig { [] }
    # Creates and returns a new SWT <code>ImageData</code> object
    # for this image descriptor.
    # Note that each call returns a new SWT image data object.
    # <p>
    # This framework method is declared public so that it is
    # possible to request an image descriptor's image data without
    # creating an SWT image object.
    # </p>
    # <p>
    # Returns <code>null</code> if the image data could not be created.
    # </p>
    # 
    # @return a new image data or <code>null</code>
    def get_image_data
      raise NotImplementedError
    end
    
    class_module.module_eval {
      typesig { [] }
      # Returns the shared image descriptor for a missing image.
      # 
      # @return the missing image descriptor
      def get_missing_image_descriptor
        return MissingImageDescriptor.get_instance
      end
    }
    
    private
    alias_method :initialize__image_descriptor, :initialize
  end
  
end
