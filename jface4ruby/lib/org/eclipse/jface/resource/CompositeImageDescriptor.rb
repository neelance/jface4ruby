require "rjava"

# Copyright (c) 2000, 2007 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Resource
  module CompositeImageDescriptorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Resource
      include_const ::Org::Eclipse::Swt::Graphics, :ImageData
      include_const ::Org::Eclipse::Swt::Graphics, :PaletteData
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Graphics, :RGB
    }
  end
  
  # Abstract base class for image descriptors that synthesize an image from other
  # images in order to simulate the effect of custom drawing. For example, this
  # could be used to superimpose a red bar dexter symbol across an image to
  # indicate that something was disallowed.
  # <p>
  # Subclasses must implement the <code>getSize</code> and <code>fill</code>
  # methods. Little or no work happens until the image descriptor's image is
  # actually requested by a call to <code>createImage</code> (or to
  # <code>getImageData</code> directly).
  # </p>
  class CompositeImageDescriptor < CompositeImageDescriptorImports.const_get :ImageDescriptor
    include_class_members CompositeImageDescriptorImports
    
    # The image data for this composite image.
    attr_accessor :image_data
    alias_method :attr_image_data, :image_data
    undef_method :image_data
    alias_method :attr_image_data=, :image_data=
    undef_method :image_data=
    
    typesig { [] }
    # Constructs an uninitialized composite image.
    def initialize
      @image_data = nil
      super()
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Draw the composite images.
    # <p>
    # Subclasses must implement this framework method to paint images within
    # the given bounds using one or more calls to the <code>drawImage</code>
    # framework method.
    # </p>
    # 
    # @param width
    # the width
    # @param height
    # the height
    def draw_composite_image(width, height)
      raise NotImplementedError
    end
    
    typesig { [ImageData, ::Java::Int, ::Java::Int] }
    # Draws the given source image data into this composite image at the given
    # position.
    # <p>
    # Call this internal framework method to superimpose another image atop
    # this composite image.
    # </p>
    # 
    # @param src
    # the source image data
    # @param ox
    # the x position
    # @param oy
    # the y position
    def draw_image(src, ox, oy)
      dst = @image_data
      src_palette = src.attr_palette
      src_mask = nil
      alpha_mask = 0
      alpha_shift = 0
      if (!(src.attr_mask_data).nil?)
        src_mask = src.get_transparency_mask
        if ((src.attr_depth).equal?(32))
          alpha_mask = ~(src_palette.attr_red_mask | src_palette.attr_green_mask | src_palette.attr_blue_mask)
          while (!(alpha_mask).equal?(0) && (((alpha_mask >> alpha_shift) & 1)).equal?(0))
            alpha_shift += 1
          end
        end
      end
      src_y = 0
      dst_y = src_y + oy
      while src_y < src.attr_height
        src_x = 0
        dst_x = src_x + ox
        while src_x < src.attr_width
          if (!(0 <= dst_x && dst_x < dst.attr_width && 0 <= dst_y && dst_y < dst.attr_height))
            src_x += 1
            dst_x += 1
            next
          end
          src_pixel = src.get_pixel(src_x, src_y)
          src_alpha = 255
          if (!(src.attr_mask_data).nil?)
            if ((src.attr_depth).equal?(32))
              src_alpha = (src_pixel & alpha_mask) >> alpha_shift
              if ((src_alpha).equal?(0))
                src_alpha = !(src_mask.get_pixel(src_x, src_y)).equal?(0) ? 255 : 0
              end
            else
              if ((src_mask.get_pixel(src_x, src_y)).equal?(0))
                src_alpha = 0
              end
            end
          else
            if (!(src.attr_transparent_pixel).equal?(-1))
              if ((src.attr_transparent_pixel).equal?(src_pixel))
                src_alpha = 0
              end
            else
              if (!(src.attr_alpha).equal?(-1))
                src_alpha = src.attr_alpha
              else
                if (!(src.attr_alpha_data).nil?)
                  src_alpha = src.get_alpha(src_x, src_y)
                end
              end
            end
          end
          if ((src_alpha).equal?(0))
            src_x += 1
            dst_x += 1
            next
          end
          src_red = 0
          src_green = 0
          src_blue = 0
          if (src_palette.attr_is_direct)
            src_red = src_pixel & src_palette.attr_red_mask
            src_red = (src_palette.attr_red_shift < 0) ? src_red >> -src_palette.attr_red_shift : src_red << src_palette.attr_red_shift
            src_green = src_pixel & src_palette.attr_green_mask
            src_green = (src_palette.attr_green_shift < 0) ? src_green >> -src_palette.attr_green_shift : src_green << src_palette.attr_green_shift
            src_blue = src_pixel & src_palette.attr_blue_mask
            src_blue = (src_palette.attr_blue_shift < 0) ? src_blue >> -src_palette.attr_blue_shift : src_blue << src_palette.attr_blue_shift
          else
            rgb = src_palette.get_rgb(src_pixel)
            src_red = rgb.attr_red
            src_green = rgb.attr_green
            src_blue = rgb.attr_blue
          end
          dst_red = 0
          dst_green = 0
          dst_blue = 0
          dst_alpha = 0
          if ((src_alpha).equal?(255))
            dst_red = src_red
            dst_green = src_green
            dst_blue = src_blue
            dst_alpha = src_alpha
          else
            dst_pixel = dst.get_pixel(dst_x, dst_y)
            dst_alpha = dst.get_alpha(dst_x, dst_y)
            dst_red = (dst_pixel & 0xff) >> 0
            dst_green = (dst_pixel & 0xff00) >> 8
            dst_blue = (dst_pixel & 0xff0000) >> 16
            dst_red += (src_red - dst_red) * src_alpha / 255
            dst_green += (src_green - dst_green) * src_alpha / 255
            dst_blue += (src_blue - dst_blue) * src_alpha / 255
            dst_alpha += (src_alpha - dst_alpha) * src_alpha / 255
          end
          dst.set_pixel(dst_x, dst_y, ((dst_red & 0xff) << 0) | ((dst_green & 0xff) << 8) | ((dst_blue & 0xff) << 16))
          dst.set_alpha(dst_x, dst_y, dst_alpha)
          src_x += 1
          dst_x += 1
        end
        src_y += 1
        dst_y += 1
      end
    end
    
    typesig { [] }
    # (non-Javadoc) Method declared on ImageDesciptor.
    def get_image_data
      size = get_size
      # Create a 24 bit image data with alpha channel
      @image_data = ImageData.new(size.attr_x, size.attr_y, 24, PaletteData.new(0xff, 0xff00, 0xff0000))
      @image_data.attr_alpha_data = Array.typed(::Java::Byte).new(@image_data.attr_width * @image_data.attr_height) { 0 }
      draw_composite_image(size.attr_x, size.attr_y)
      # Detect minimum transparency
      transparency = false
      alpha_data = @image_data.attr_alpha_data
      i = 0
      while i < alpha_data.attr_length
        alpha = alpha_data[i] & 0xff
        if (!((alpha).equal?(0) || (alpha).equal?(255)))
          # Full alpha channel transparency
          return @image_data
        end
        if (!transparency && (alpha).equal?(0))
          transparency = true
        end
        i += 1
      end
      if (transparency)
        # Reduce to 1-bit alpha channel transparency
        palette = PaletteData.new(Array.typed(RGB).new([RGB.new(0, 0, 0), RGB.new(255, 255, 255)]))
        mask = ImageData.new(@image_data.attr_width, @image_data.attr_height, 1, palette)
        y = 0
        while y < mask.attr_height
          x = 0
          while x < mask.attr_width
            mask.set_pixel(x, y, (@image_data.get_alpha(x, y)).equal?(255) ? 1 : 0)
            x += 1
          end
          y += 1
        end
      else
        # no transparency
        @image_data.attr_alpha_data = nil
      end
      return @image_data
    end
    
    typesig { [] }
    # Return the transparent pixel for the receiver.
    # <strong>NOTE</strong> This value is not currently in use in the
    # default implementation.
    # @return int
    # @since 3.3
    def get_transparent_pixel
      return 0
    end
    
    typesig { [] }
    # Return the size of this composite image.
    # <p>
    # Subclasses must implement this framework method.
    # </p>
    # 
    # @return the x and y size of the image expressed as a point object
    def get_size
      raise NotImplementedError
    end
    
    typesig { [ImageData] }
    # @param imageData The imageData to set.
    # @since 3.3
    def set_image_data(image_data)
      @image_data = image_data
    end
    
    private
    alias_method :initialize__composite_image_descriptor, :initialize
  end
  
end
