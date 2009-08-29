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
  module ArrayFontDescriptorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Resource
      include_const ::Org::Eclipse::Swt::Graphics, :Device
      include_const ::Org::Eclipse::Swt::Graphics, :Font
      include_const ::Org::Eclipse::Swt::Graphics, :FontData
    }
  end
  
  # Describes a Font using an array of FontData
  # 
  # @since 3.1
  class ArrayFontDescriptor < ArrayFontDescriptorImports.const_get :FontDescriptor
    include_class_members ArrayFontDescriptorImports
    
    attr_accessor :data
    alias_method :attr_data, :data
    undef_method :data
    alias_method :attr_data=, :data=
    undef_method :data=
    
    attr_accessor :original_font
    alias_method :attr_original_font, :original_font
    undef_method :original_font
    alias_method :attr_original_font=, :original_font=
    undef_method :original_font=
    
    typesig { [Array.typed(FontData)] }
    # Creates a font descriptor for a font with the given name, height,
    # and style. These arguments are passed directly to the constructor
    # of Font.
    # 
    # @param data FontData describing the font to create
    # 
    # @see org.eclipse.swt.graphics.Font#Font(org.eclipse.swt.graphics.Device, org.eclipse.swt.graphics.FontData)
    # @since 3.1
    def initialize(data)
      @data = nil
      @original_font = nil
      super()
      @original_font = nil
      @data = data
    end
    
    typesig { [Font] }
    # Creates a font descriptor that describes the given font.
    # 
    # @param originalFont font to be described
    # 
    # @see FontDescriptor#createFrom(org.eclipse.swt.graphics.Font)
    # @since 3.1
    def initialize(original_font)
      initialize__array_font_descriptor(original_font.get_font_data)
      @original_font = original_font
    end
    
    typesig { [] }
    # (non-Javadoc)
    # @see org.eclipse.jface.resource.FontDescriptor#getFontData()
    def get_font_data
      # Copy the original array to ensure that callers will not modify it
      return copy(@data)
    end
    
    typesig { [Device] }
    # (non-Javadoc)
    # @see org.eclipse.jface.resource.FontDescriptor#createFont(org.eclipse.swt.graphics.Device)
    def create_font(device)
      # If this descriptor is an existing font, then we can return the original font
      # if this is the same device.
      if (!(@original_font).nil?)
        # If we're allocating on the same device as the original font, return the original.
        if ((@original_font.get_device).equal?(device))
          return @original_font
        end
      end
      return Font.new(device, @data)
    end
    
    typesig { [Object] }
    # (non-Javadoc)
    # @see java.lang.Object#equals(java.lang.Object)
    def ==(obj)
      if (((obj.get_class).equal?(ArrayFontDescriptor)))
        descr = obj
        if (!(descr.attr_original_font).equal?(@original_font))
          return false
        end
        if (!(@original_font).nil?)
          return true
        end
        if (!(@data.attr_length).equal?(descr.attr_data.attr_length))
          return false
        end
        i = 0
        while i < @data.attr_length
          fd = @data[i]
          fd2 = descr.attr_data[i]
          if (!(fd == fd2))
            return false
          end
          i += 1
        end
        return true
      end
      return false
    end
    
    typesig { [] }
    # (non-Javadoc)
    # @see java.lang.Object#hashCode()
    def hash_code
      if (!(@original_font).nil?)
        return @original_font.hash_code
      end
      code = 0
      i = 0
      while i < @data.attr_length
        fd = @data[i]
        code += fd.hash_code
        i += 1
      end
      return code
    end
    
    typesig { [Font] }
    # (non-Javadoc)
    # @see org.eclipse.jface.resource.FontDescriptor#destroyFont(org.eclipse.swt.graphics.Font)
    def destroy_font(previously_created_font)
      if ((previously_created_font).equal?(@original_font))
        return
      end
      previously_created_font.dispose
    end
    
    private
    alias_method :initialize__array_font_descriptor, :initialize
  end
  
end
