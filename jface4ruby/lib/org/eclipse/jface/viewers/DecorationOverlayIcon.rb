require "rjava"

# Copyright (c) 2006, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Viewers
  module DecorationOverlayIconImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
      include_const ::Java::Util, :Arrays
      include_const ::Org::Eclipse::Jface::Resource, :CompositeImageDescriptor
      include_const ::Org::Eclipse::Jface::Resource, :ImageDescriptor
      include ::Org::Eclipse::Swt::Graphics
    }
  end
  
  # A <code>DecorationOverlayIcon</code> is an image descriptor that can be used
  # to overlay decoration images on to the 4 corner quadrants of a base image.
  # The four quadrants are {@link IDecoration#TOP_LEFT}, {@link IDecoration#TOP_RIGHT},
  # {@link IDecoration#BOTTOM_LEFT} and {@link IDecoration#BOTTOM_RIGHT}. Additionally,
  # the overlay can be used to provide an underlay corresponding to {@link IDecoration#UNDERLAY}.
  # 
  # @since 3.3
  # @see IDecoration
  class DecorationOverlayIcon < DecorationOverlayIconImports.const_get :CompositeImageDescriptor
    include_class_members DecorationOverlayIconImports
    
    # the base image
    attr_accessor :base
    alias_method :attr_base, :base
    undef_method :base
    alias_method :attr_base=, :base=
    undef_method :base=
    
    # the overlay images
    attr_accessor :overlays
    alias_method :attr_overlays, :overlays
    undef_method :overlays
    alias_method :attr_overlays=, :overlays=
    undef_method :overlays=
    
    # the size
    attr_accessor :size
    alias_method :attr_size, :size
    undef_method :size
    alias_method :attr_size=, :size=
    undef_method :size=
    
    typesig { [Image, Array.typed(ImageDescriptor), Point] }
    # Create the decoration overlay for the base image using the array of
    # provided overlays. The indices of the array correspond to the values
    # of the 5 overlay constants defined on {@link IDecoration}
    # ({@link IDecoration#TOP_LEFT}, {@link IDecoration#TOP_RIGHT},
    # {@link IDecoration#BOTTOM_LEFT}, {@link IDecoration#BOTTOM_RIGHT}
    # and{@link IDecoration#UNDERLAY}).
    # 
    # @param baseImage the base image
    # @param overlaysArray the overlay images
    # @param sizeValue the size of the resulting image
    def initialize(base_image, overlays_array, size_value)
      @base = nil
      @overlays = nil
      @size = nil
      super()
      @base = base_image
      @overlays = overlays_array
      @size = size_value
    end
    
    typesig { [Image, Array.typed(ImageDescriptor)] }
    # Create the decoration overlay for the base image using the array of
    # provided overlays. The indices of the array correspond to the values
    # of the 5 overlay constants defined on {@link IDecoration}
    # ({@link IDecoration#TOP_LEFT}, {@link IDecoration#TOP_RIGHT},
    # {@link IDecoration#BOTTOM_LEFT}, {@link IDecoration#BOTTOM_RIGHT}
    # and {@link IDecoration#UNDERLAY}).
    # 
    # @param baseImage the base image
    # @param overlaysArray the overlay images
    def initialize(base_image, overlays_array)
      initialize__decoration_overlay_icon(base_image, overlays_array, Point.new(base_image.get_bounds.attr_width, base_image.get_bounds.attr_height))
    end
    
    typesig { [Image, ImageDescriptor, ::Java::Int] }
    # Create a decoration overlay icon that will place the given overlay icon in
    # the given quadrant of the base image.
    # @param baseImage the base image
    # @param overlayImage the overlay image
    # @param quadrant the quadrant (one of {@link IDecoration}
    # ({@link IDecoration#TOP_LEFT}, {@link IDecoration#TOP_RIGHT},
    # {@link IDecoration#BOTTOM_LEFT}, {@link IDecoration#BOTTOM_RIGHT}
    # or {@link IDecoration#UNDERLAY})
    def initialize(base_image, overlay_image, quadrant)
      initialize__decoration_overlay_icon(base_image, create_array_from(overlay_image, quadrant))
    end
    
    class_module.module_eval {
      typesig { [ImageDescriptor, ::Java::Int] }
      # Convert the given image and quadrant into the proper input array.
      # @param overlayImage the overlay image
      # @param quadrant the quadrant
      # @return an array with the given image in the proper quadrant
      def create_array_from(overlay_image, quadrant)
        descs = Array.typed(ImageDescriptor).new([nil, nil, nil, nil, nil])
        descs[quadrant] = overlay_image
        return descs
      end
    }
    
    typesig { [Array.typed(ImageDescriptor)] }
    # Draw the overlays for the receiver.
    # @param overlaysArray
    def draw_overlays(overlays_array)
      i = 0
      while i < @overlays.attr_length
        overlay = overlays_array[i]
        if ((overlay).nil?)
          i += 1
          next
        end
        overlay_data = overlay.get_image_data
        # Use the missing descriptor if it is not there.
        if ((overlay_data).nil?)
          overlay_data = ImageDescriptor.get_missing_image_descriptor.get_image_data
        end
        case (i)
        when IDecoration::TOP_LEFT
          draw_image(overlay_data, 0, 0)
        when IDecoration::TOP_RIGHT
          draw_image(overlay_data, @size.attr_x - overlay_data.attr_width, 0)
        when IDecoration::BOTTOM_LEFT
          draw_image(overlay_data, 0, @size.attr_y - overlay_data.attr_height)
        when IDecoration::BOTTOM_RIGHT
          draw_image(overlay_data, @size.attr_x - overlay_data.attr_width, @size.attr_y - overlay_data.attr_height)
        end
        i += 1
      end
    end
    
    typesig { [Object] }
    # (non-Javadoc)
    # @see java.lang.Object#equals(java.lang.Object)
    def ==(o)
      if (!(o.is_a?(DecorationOverlayIcon)))
        return false
      end
      other = o
      return (@base == other.attr_base) && (Arrays == @overlays)
    end
    
    typesig { [] }
    # (non-Javadoc)
    # @see java.lang.Object#hashCode()
    def hash_code
      code = System.identity_hash_code(@base)
      i = 0
      while i < @overlays.attr_length
        if (!(@overlays[i]).nil?)
          code ^= @overlays[i].hash_code
        end
        i += 1
      end
      return code
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # (non-Javadoc)
    # @see org.eclipse.jface.resource.CompositeImageDescriptor#drawCompositeImage(int, int)
    def draw_composite_image(width, height)
      if (@overlays.attr_length > IDecoration::UNDERLAY)
        underlay = @overlays[IDecoration::UNDERLAY]
        if (!(underlay).nil?)
          draw_image(underlay.get_image_data, 0, 0)
        end
      end
      if (@overlays.attr_length > IDecoration::REPLACE && !(@overlays[IDecoration::REPLACE]).nil?)
        draw_image(@overlays[IDecoration::REPLACE].get_image_data, 0, 0)
      else
        draw_image(@base.get_image_data, 0, 0)
      end
      draw_overlays(@overlays)
    end
    
    typesig { [] }
    # (non-Javadoc)
    # @see org.eclipse.jface.resource.CompositeImageDescriptor#getSize()
    def get_size
      return @size
    end
    
    typesig { [] }
    # (non-Javadoc)
    # @see org.eclipse.jface.resource.CompositeImageDescriptor#getTransparentPixel()
    def get_transparent_pixel
      return @base.get_image_data.attr_transparent_pixel
    end
    
    private
    alias_method :initialize__decoration_overlay_icon, :initialize
  end
  
end
