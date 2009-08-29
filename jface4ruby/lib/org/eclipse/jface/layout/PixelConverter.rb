require "rjava"

# Copyright (c) 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Layout
  module PixelConverterImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Layout
      include_const ::Org::Eclipse::Swt::Graphics, :Font
      include_const ::Org::Eclipse::Swt::Graphics, :FontMetrics
      include_const ::Org::Eclipse::Swt::Graphics, :GC
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Jface::Dialogs, :Dialog
    }
  end
  
  # PixelConverter performs various conversions from device-independent units
  # (such as DLUs or characters) to pixels. It can be associated with a control or
  # a font. In the case of a control, the font used by the control at the time
  # the PixelConverter is created is used for the pixel calculations. In the case
  # of a specific font, the supplied font is used for the calculations.
  # 
  # The control and/or font must not be disposed at the time the PixelConverter
  # is created.
  # 
  # @since 3.5
  class PixelConverter 
    include_class_members PixelConverterImports
    
    attr_accessor :font_metrics
    alias_method :attr_font_metrics, :font_metrics
    undef_method :font_metrics
    alias_method :attr_font_metrics=, :font_metrics=
    undef_method :font_metrics=
    
    typesig { [Control] }
    # Create a PixelConverter which will convert device-independent units to
    # pixels using the font of the specified control.
    # 
    # @param control
    # the control whose font should be used for pixel conversions.
    # Note that the font used by the control at the time this
    # constructor is called is the font that will be used for all
    # calculations. If the font of the specified control is changed
    # after this PixelConverter is created, then the conversions
    # from this instance will not produce the desired effect.
    def initialize(control)
      initialize__pixel_converter(control.get_font)
    end
    
    typesig { [Font] }
    # Create a PixelConverter which will convert device-independent units to
    # pixels using the specified font.
    # 
    # @param font
    # the font that should be used for pixel conversions.
    def initialize(font)
      @font_metrics = nil
      gc = GC.new(font.get_device)
      gc.set_font(font)
      @font_metrics = gc.get_font_metrics
      gc.dispose
    end
    
    typesig { [::Java::Int] }
    # Returns the number of pixels corresponding to the height of the given
    # number of characters.
    # 
    # @param chars
    # the number of characters
    # @return the number of pixels
    def convert_height_in_chars_to_pixels(chars)
      return Dialog.convert_height_in_chars_to_pixels(@font_metrics, chars)
    end
    
    typesig { [::Java::Int] }
    # Returns the number of pixels corresponding to the given number of
    # horizontal dialog units.
    # 
    # @param dlus
    # the number of horizontal dialog units
    # @return the number of pixels
    def convert_horizontal_dlus_to_pixels(dlus)
      return Dialog.convert_horizontal_dlus_to_pixels(@font_metrics, dlus)
    end
    
    typesig { [::Java::Int] }
    # Returns the number of pixels corresponding to the given number of
    # vertical dialog units.
    # 
    # @param dlus
    # the number of vertical dialog units
    # @return the number of pixels
    def convert_vertical_dlus_to_pixels(dlus)
      return Dialog.convert_vertical_dlus_to_pixels(@font_metrics, dlus)
    end
    
    typesig { [::Java::Int] }
    # Returns the number of pixels corresponding to the width of the given
    # number of characters.
    # 
    # @param chars
    # the number of characters
    # @return the number of pixels
    def convert_width_in_chars_to_pixels(chars)
      return Dialog.convert_width_in_chars_to_pixels(@font_metrics, chars)
    end
    
    private
    alias_method :initialize__pixel_converter, :initialize
  end
  
end
