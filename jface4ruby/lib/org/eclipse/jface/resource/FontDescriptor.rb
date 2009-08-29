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
  module FontDescriptorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Resource
      include_const ::Org::Eclipse::Swt::Graphics, :Device
      include_const ::Org::Eclipse::Swt::Graphics, :Font
      include_const ::Org::Eclipse::Swt::Graphics, :FontData
      include_const ::Org::Eclipse::Swt::Widgets, :Display
    }
  end
  
  # Lightweight descriptor for a font. Creates the described font on demand.
  # Subclasses can implement different ways of describing a font. These objects
  # will be compared, so hashCode(...) and equals(...) must return something
  # meaningful.
  # 
  # @since 3.1
  class FontDescriptor < FontDescriptorImports.const_get :DeviceResourceDescriptor
    include_class_members FontDescriptorImports
    
    class_module.module_eval {
      typesig { [Font, Device] }
      # Creates a FontDescriptor that describes an existing font. The resulting
      # descriptor depends on the Font. Disposing the Font while the descriptor
      # is still in use may throw a graphic disposed exception.
      # 
      # @since 3.1
      # 
      # @deprecated use {@link FontDescriptor#createFrom(Font)}
      # 
      # @param font a font to describe
      # @param originalDevice must be the same Device that was passed into
      # the font's constructor when it was first created.
      # @return a newly created FontDescriptor.
      def create_from(font, original_device)
        return ArrayFontDescriptor.new(font)
      end
      
      typesig { [Font] }
      # Creates a FontDescriptor that describes an existing font. The resulting
      # descriptor depends on the original Font, and disposing the original Font
      # while the descriptor is still in use may cause SWT to throw a graphic
      # disposed exception.
      # 
      # @since 3.1
      # 
      # @param font font to create
      # @return a newly created FontDescriptor that describes the given font
      def create_from(font)
        return ArrayFontDescriptor.new(font)
      end
      
      typesig { [Array.typed(FontData)] }
      # Creates a new FontDescriptor given the an array of FontData that describes
      # the font.
      # 
      # @since 3.1
      # 
      # @param data an array of FontData that describes the font (will be passed into
      # the Font's constructor)
      # @return a FontDescriptor that describes the given font
      def create_from(data)
        return ArrayFontDescriptor.new(data)
      end
      
      typesig { [FontData] }
      # Creates a new FontDescriptor given the associated FontData
      # 
      # @param data FontData describing the font to create
      # @return a newly created FontDescriptor
      def create_from(data)
        return ArrayFontDescriptor.new(Array.typed(FontData).new([data]))
      end
      
      typesig { [String, ::Java::Int, ::Java::Int] }
      # Creates a new FontDescriptor given an OS-specific font name, height, and style.
      # 
      # @see Font#Font(org.eclipse.swt.graphics.Device, java.lang.String, int, int)
      # 
      # @param name os-specific font name
      # @param height height (pixels)
      # @param style a bitwise combination of NORMAL, BOLD, ITALIC
      # @return a new FontDescriptor
      def create_from(name, height, style)
        return create_from(FontData.new(name, height, style))
      end
    }
    
    typesig { [] }
    # Returns the set of FontData associated with this font. Modifying the elements
    # in the returned array has no effect on the original FontDescriptor.
    # 
    # @return the set of FontData associated with this font
    # @since 3.3
    def get_font_data
      temp_font = create_font(Display.get_current)
      result = temp_font.get_font_data
      destroy_font(temp_font)
      return result
    end
    
    class_module.module_eval {
      typesig { [Array.typed(FontData)] }
      # Returns an array of FontData containing copies of the FontData
      # from the original.
      # 
      # @param original array to copy
      # @return a deep copy of the original array
      # @since 3.3
      def copy(original)
        result = Array.typed(FontData).new(original.attr_length) { nil }
        i = 0
        while i < original.attr_length
          next_ = original[i]
          result[i] = copy(next_)
          i += 1
        end
        return result
      end
      
      typesig { [FontData] }
      # Returns a copy of the original FontData
      # 
      # @param next FontData to copy
      # @return a copy of the given FontData
      # @since 3.3
      def copy(next_)
        result = FontData.new(next_.get_name, next_.get_height, next_.get_style)
        result.set_locale(next_.get_locale)
        return result
      end
    }
    
    typesig { [::Java::Int] }
    # Returns a FontDescriptor that is equivalent to the reciever, but uses
    # the given style bits.
    # 
    # <p>Does not modify the reciever.</p>
    # 
    # @param style a bitwise combination of SWT.NORMAL, SWT.ITALIC and SWT.BOLD
    # @return a new FontDescriptor with the given style
    # 
    # @since 3.3
    def set_style(style)
      data = get_font_data
      i = 0
      while i < data.attr_length
        next_ = data[i]
        next_.set_style(style)
        i += 1
      end
      # Optimization: avoid holding onto extra instances by returning the reciever if
      # if it is exactly the same as the result
      result = ArrayFontDescriptor.new(data)
      if ((result == self))
        return self
      end
      return result
    end
    
    typesig { [::Java::Int] }
    # <p>Returns a FontDescriptor that is equivalent to the reciever, but
    # has the given style bits, in addition to any styles the reciever already has.</p>
    # 
    # <p>Does not modify the reciever.</p>
    # 
    # @param style a bitwise combination of SWT.NORMAL, SWT.ITALIC and SWT.BOLD
    # @return a new FontDescriptor with the given additional style bits
    # @since 3.3
    def with_style(style)
      data = get_font_data
      i = 0
      while i < data.attr_length
        next_ = data[i]
        next_.set_style(next_.get_style | style)
        i += 1
      end
      # Optimization: avoid allocating extra instances by returning the reciever if
      # if it is exactly the same as the result
      result = ArrayFontDescriptor.new(data)
      if ((result == self))
        return self
      end
      return result
    end
    
    typesig { [::Java::Int] }
    # <p>Returns a new FontDescriptor that is equivalent to the reciever, but
    # has the given height.</p>
    # 
    # <p>Does not modify the reciever.</p>
    # 
    # @param height a height, in points
    # @return a new FontDescriptor with the height, in points
    # @since 3.3
    def set_height(height)
      data = get_font_data
      i = 0
      while i < data.attr_length
        next_ = data[i]
        next_.set_height(height)
        i += 1
      end
      # Optimization: avoid holding onto extra instances by returning the reciever if
      # if it is exactly the same as the result
      result = ArrayFontDescriptor.new(data)
      if ((result == self))
        return self
      end
      return result
    end
    
    typesig { [::Java::Int] }
    # <p>Returns a FontDescriptor that is equivalent to the reciever, but whose height
    # is larger by the given number of points.</p>
    # 
    # <p>Does not modify the reciever.</p>
    # 
    # @param heightDelta a change in height, in points. Negative values will return smaller
    # fonts.
    # @return a FontDescriptor whose height differs from the reciever by the given number
    # of points.
    # @since 3.3
    def increase_height(height_delta)
      if ((height_delta).equal?(0))
        return self
      end
      data = get_font_data
      i = 0
      while i < data.attr_length
        next_ = data[i]
        next_.set_height(next_.get_height + height_delta)
        i += 1
      end
      return ArrayFontDescriptor.new(data)
    end
    
    typesig { [Device] }
    # Creates the Font described by this descriptor.
    # 
    # @since 3.1
    # 
    # @param device device on which to allocate the font
    # @return a newly allocated Font (never null)
    # @throws DeviceResourceException if unable to allocate the Font
    def create_font(device)
      raise NotImplementedError
    end
    
    typesig { [Font] }
    # Deallocates anything that was allocated by createFont, given a font
    # that was allocated by an equal FontDescriptor.
    # 
    # @since 3.1
    # 
    # @param previouslyCreatedFont previously allocated font
    def destroy_font(previously_created_font)
      raise NotImplementedError
    end
    
    typesig { [Device] }
    # (non-Javadoc)
    # @see org.eclipse.jface.resource.DeviceResourceDescriptor#create(org.eclipse.swt.graphics.Device)
    def create_resource(device)
      return create_font(device)
    end
    
    typesig { [Object] }
    # (non-Javadoc)
    # @see org.eclipse.jface.resource.DeviceResourceDescriptor#destroy(java.lang.Object)
    def destroy_resource(previously_created_object)
      destroy_font(previously_created_object)
    end
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__font_descriptor, :initialize
  end
  
end
