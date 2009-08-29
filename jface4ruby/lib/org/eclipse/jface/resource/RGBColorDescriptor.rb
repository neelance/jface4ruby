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
  module RGBColorDescriptorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Resource
      include_const ::Org::Eclipse::Swt::Graphics, :Color
      include_const ::Org::Eclipse::Swt::Graphics, :Device
      include_const ::Org::Eclipse::Swt::Graphics, :RGB
    }
  end
  
  # Describes a color by its RGB values.
  # 
  # @since 3.1
  class RGBColorDescriptor < RGBColorDescriptorImports.const_get :ColorDescriptor
    include_class_members RGBColorDescriptorImports
    
    attr_accessor :color
    alias_method :attr_color, :color
    undef_method :color
    alias_method :attr_color=, :color=
    undef_method :color=
    
    # Color being copied, or null if none
    attr_accessor :original_color
    alias_method :attr_original_color, :original_color
    undef_method :original_color
    alias_method :attr_original_color=, :original_color=
    undef_method :original_color=
    
    typesig { [RGB] }
    # Creates a new RGBColorDescriptor given some RGB values
    # 
    # @param color RGB values (not null)
    def initialize(color)
      @color = nil
      @original_color = nil
      super()
      @original_color = nil
      @color = color
    end
    
    typesig { [Color] }
    # Creates a new RGBColorDescriptor that describes an existing color.
    # 
    # @since 3.1
    # 
    # @param originalColor a color to describe
    def initialize(original_color)
      initialize__rgbcolor_descriptor(original_color.get_rgb)
      @original_color = original_color
    end
    
    typesig { [Object] }
    # (non-Javadoc)
    # @see java.lang.Object#equals(java.lang.Object)
    def ==(obj)
      if (obj.is_a?(RGBColorDescriptor))
        other = obj
        return (other.attr_color == @color) && (other.attr_original_color).equal?(@original_color)
      end
      return false
    end
    
    typesig { [] }
    # (non-Javadoc)
    # @see java.lang.Object#hashCode()
    def hash_code
      return @color.hash_code
    end
    
    typesig { [Device] }
    # (non-Javadoc)
    # @see org.eclipse.jface.resources.ColorDescriptor#createColor()
    def create_color(device)
      # If this descriptor is wrapping an existing color, then we can return the original color
      # if this is the same device.
      if (!(@original_color).nil?)
        # If we're allocating on the same device as the original color, return the original.
        if ((@original_color.get_device).equal?(device))
          return @original_color
        end
      end
      return Color.new(device, @color)
    end
    
    typesig { [Color] }
    # (non-Javadoc)
    # @see org.eclipse.jface.resource.ColorDescriptor#destroyColor(org.eclipse.swt.graphics.Color)
    def destroy_color(to_destroy)
      if ((to_destroy).equal?(@original_color))
        return
      end
      to_destroy.dispose
    end
    
    private
    alias_method :initialize__rgbcolor_descriptor, :initialize
  end
  
end
