require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text
  module TextAttributeImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Graphics, :Color
      include_const ::Org::Eclipse::Swt::Graphics, :Font
    }
  end
  
  # Description of textual attributes such as color and style. Text attributes
  # are considered value objects.
  # <p>
  # Clients usually instantiate object of the class.</p>
  class TextAttribute 
    include_class_members TextAttributeImports
    
    class_module.module_eval {
      # Text attribute for strikethrough style.
      # (value <code>1 << 29</code>).
      # @since 3.1
      const_set_lazy(:STRIKETHROUGH) { 1 << 29 }
      const_attr_reader  :STRIKETHROUGH
      
      # Text attribute for underline style.
      # (value <code>1 << 30</code>)
      # @since 3.1
      const_set_lazy(:UNDERLINE) { 1 << 30 }
      const_attr_reader  :UNDERLINE
    }
    
    # Foreground color
    attr_accessor :foreground
    alias_method :attr_foreground, :foreground
    undef_method :foreground
    alias_method :attr_foreground=, :foreground=
    undef_method :foreground=
    
    # Background color
    attr_accessor :background
    alias_method :attr_background, :background
    undef_method :background
    alias_method :attr_background=, :background=
    undef_method :background=
    
    # The text style
    attr_accessor :style
    alias_method :attr_style, :style
    undef_method :style
    alias_method :attr_style=, :style=
    undef_method :style=
    
    # The text font.
    # @since 3.3
    attr_accessor :font
    alias_method :attr_font, :font
    undef_method :font
    alias_method :attr_font=, :font=
    undef_method :font=
    
    # Cached hash code.
    # @since 3.3
    attr_accessor :f_hash_code
    alias_method :attr_f_hash_code, :f_hash_code
    undef_method :f_hash_code
    alias_method :attr_f_hash_code=, :f_hash_code=
    undef_method :f_hash_code=
    
    typesig { [Color, Color, ::Java::Int] }
    # Creates a text attribute with the given colors and style.
    # 
    # @param foreground the foreground color, <code>null</code> if none
    # @param background the background color, <code>null</code> if none
    # @param style the style
    def initialize(foreground, background, style)
      @foreground = nil
      @background = nil
      @style = 0
      @font = nil
      @f_hash_code = 0
      @foreground = foreground
      @background = background
      @style = style
    end
    
    typesig { [Color, Color, ::Java::Int, Font] }
    # Creates a text attribute with the given colors and style.
    # 
    # @param foreground the foreground color, <code>null</code> if none
    # @param background the background color, <code>null</code> if none
    # @param style the style
    # @param font the font, <code>null</code> if none
    # @since 3.3
    def initialize(foreground, background, style, font)
      @foreground = nil
      @background = nil
      @style = 0
      @font = nil
      @f_hash_code = 0
      @foreground = foreground
      @background = background
      @style = style
      @font = font
    end
    
    typesig { [Color] }
    # Creates a text attribute for the given foreground color, no background color and
    # with the SWT normal style.
    # 
    # @param foreground the foreground color, <code>null</code> if none
    def initialize(foreground)
      initialize__text_attribute(foreground, nil, SWT::NORMAL)
    end
    
    typesig { [Object] }
    # @see Object#equals(Object)
    def ==(object)
      if ((object).equal?(self))
        return true
      end
      if (!(object.is_a?(TextAttribute)))
        return false
      end
      a = object
      return ((a.attr_style).equal?(@style) && self.==(a.attr_foreground, @foreground) && self.==(a.attr_background, @background) && self.==(a.attr_font, @font))
    end
    
    typesig { [Object, Object] }
    # Returns whether the two given objects are equal.
    # 
    # @param o1 the first object, can be <code>null</code>
    # @param o2 the second object, can be <code>null</code>
    # @return <code>true</code> if the given objects are equals
    # @since 2.0
    def ==(o1, o2)
      if (!(o1).nil?)
        return (o1 == o2)
      end
      return ((o2).nil?)
    end
    
    typesig { [] }
    # @see Object#hashCode()
    def hash_code
      if ((@f_hash_code).equal?(0))
        multiplier = 37 # some prime
        @f_hash_code = 13 # some random value
        @f_hash_code = multiplier * @f_hash_code + ((@font).nil? ? 0 : @font.hash_code)
        @f_hash_code = multiplier * @f_hash_code + ((@background).nil? ? 0 : @background.hash_code)
        @f_hash_code = multiplier * @f_hash_code + ((@foreground).nil? ? 0 : @foreground.hash_code)
        @f_hash_code = multiplier * @f_hash_code + @style
      end
      return @f_hash_code
    end
    
    typesig { [] }
    # Returns the attribute's foreground color.
    # 
    # @return the attribute's foreground color or <code>null</code> if not set
    def get_foreground
      return @foreground
    end
    
    typesig { [] }
    # Returns the attribute's background color.
    # 
    # @return the attribute's background color or <code>null</code> if not set
    def get_background
      return @background
    end
    
    typesig { [] }
    # Returns the attribute's style.
    # 
    # @return the attribute's style
    def get_style
      return @style
    end
    
    typesig { [] }
    # Returns the attribute's font.
    # 
    # @return the attribute's font or <code>null</code> if not set
    # @since 3.3
    def get_font
      return @font
    end
    
    private
    alias_method :initialize__text_attribute, :initialize
  end
  
end
