require "rjava"

# Copyright (c) 2006, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Internal::Text::Revisions
  module ColorsImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Internal::Text::Revisions
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Graphics, :RGB
      include_const ::Org::Eclipse::Core::Runtime, :Assert
    }
  end
  
  # Utility for color operations.
  # 
  # @since 3.3
  class Colors 
    include_class_members ColorsImports
    
    class_module.module_eval {
      typesig { [RGB] }
      # Implementation note: Color computation assumes sRGB, which is probably not true, and does not
      # always give good results. CIE based algorithms would be better, see
      # http://www.w3.org/TR/PNG-ColorAppendix.html and http://en.wikipedia.org/wiki/Lab_color_space
      # 
      # 
      # Returns the human-perceived brightness of a color as float in [0.0, 1.0]. The used RGB
      # weights come from http://www.poynton.com/notes/colour_and_gamma/ColorFAQ.html#RTFToC9.
      # 
      # @param rgb the color
      # @return the gray-scale value
      def brightness(rgb)
        return Math.min(1, (0.2126 * rgb.attr_red + 0.7152 * rgb.attr_green + 0.0722 * rgb.attr_blue + 0.5) / 255)
      end
      
      typesig { [RGB, ::Java::Float] }
      # Normalizes a color in its perceived brightness. Yellows are darkened, while blues and reds
      # are lightened. Depending on the hue, the brightness range within the RGB gamut may be
      # different, outside values are clipped. Note that this is an approximation; the returned RGB
      # is not guaranteed to have the requested {@link #brightness(RGB) brightness}.
      # 
      # @param color the color to normalize
      # @param brightness the requested brightness, in [0,&nbsp;1]
      # @return a normalized version of <code>color</code>
      # @see #brightness(RGB)
      def adjust_brightness(color, brightness)
        hsi = to_hsi(color)
        psycho_factor = brightness - brightness(color)
        weight = 0.5 # found by trial and error
        hsi[2] = Math.max(0, Math.min(1.0, hsi[2] + psycho_factor * weight))
        color = from_hsi(hsi)
        return color
      end
      
      typesig { [RGB] }
      # Converts an {@link RGB} to an <a href="http://en.wikipedia.org/wiki/HSL_color_space">HSI</a>
      # triplet.
      # 
      # @param color the color to convert
      # @return the HSI float array of length 3
      def to_hsi(color)
        r = color.attr_red / 255
        g = color.attr_green / 255
        b = color.attr_blue / 255
        max_ = Math.max(Math.max(r, g), b)
        min_ = Math.min(Math.min(r, g), b)
        delta = max_ - min_
        max_plus_min = max_ + min_
        intensity = max_plus_min / 2
        saturation = intensity < 0.5 ? delta / max_plus_min : delta / (2 - max_plus_min)
        hue = 0
        if (!(delta).equal?(0))
          if ((r).equal?(max_))
            hue = (g - b) / delta
          else
            if ((g).equal?(max_))
              hue = 2 + (b - r) / delta
            else
              hue = 4 + (r - g) / delta
            end
          end
          hue *= 60
          if (hue < 0)
            hue += 360
          end
        end
        return Array.typed(::Java::Float).new([hue, saturation, intensity])
      end
      
      typesig { [Array.typed(::Java::Float)] }
      # Converts a <a href="http://en.wikipedia.org/wiki/HSL_color_space">HSI</a> triplet to an RGB.
      # 
      # @param hsi the HSI values
      # @return the RGB corresponding to the HSI spec
      def from_hsi(hsi)
        r = 0.0
        g = 0.0
        b = 0.0
        hue = hsi[0]
        saturation = hsi[1]
        intensity = hsi[2]
        if ((saturation).equal?(0))
          r = g = b = intensity
        else
          temp2 = intensity < 0.5 ? intensity * (1.0 + saturation) : (intensity + saturation) - (intensity * saturation)
          temp1 = 2 * intensity - temp2
          if ((hue).equal?(360))
            hue = 0
          end
          hue /= 360
          r = hue2_rgb(temp1, temp2, hue + 1 / 3)
          g = hue2_rgb(temp1, temp2, hue)
          b = hue2_rgb(temp1, temp2, hue - 1 / 3)
        end
        red = RJava.cast_to_int((r * 255 + 0.5))
        green = RJava.cast_to_int((g * 255 + 0.5))
        blue = RJava.cast_to_int((b * 255 + 0.5))
        return RGB.new(red, green, blue)
      end
      
      typesig { [::Java::Float, ::Java::Float, ::Java::Float] }
      def hue2_rgb(t1, t2, hue)
        if (hue < 0)
          hue += 1
        else
          if (hue > 1)
            hue -= 1
          end
        end
        if (6 * hue < 1)
          return t1 + (t2 - t1) * 6 * hue
        end
        if (2 * hue < 1)
          return t2
        end
        if (3 * hue < 2)
          return t1 + (t2 - t1) * (2 / 3 - hue) * 6
        end
        return t1
      end
      
      typesig { [RGB, RGB, ::Java::Float] }
      # Returns an RGB that lies between the given foreground and background
      # colors using the given mixing factor. A <code>factor</code> of 1.0 will produce a
      # color equal to <code>fg</code>, while a <code>factor</code> of 0.0 will produce one
      # equal to <code>bg</code>.
      # @param bg the background color
      # @param fg the foreground color
      # @param factor the mixing factor, must be in [0,&nbsp;1]
      # 
      # @return the interpolated color
      def blend(bg, fg, factor)
        Assert.is_legal(!(bg).nil?)
        Assert.is_legal(!(fg).nil?)
        Assert.is_legal(factor >= 0 && factor <= 1)
        complement = 1 - factor
        return RGB.new(RJava.cast_to_int((complement * bg.attr_red + factor * fg.attr_red)), RJava.cast_to_int((complement * bg.attr_green + factor * fg.attr_green)), RJava.cast_to_int((complement * bg.attr_blue + factor * fg.attr_blue)))
      end
      
      typesig { [RGB, RGB, ::Java::Int] }
      # Returns an array of colors in a smooth palette from <code>start</code> to <code>end</code>.
      # <p>
      # The returned array has size <code>steps</code>, and the color at index 0 is <code>start</code>, the color
      # at index <code>steps&nbsp;-&nbsp;1</code> is <code>end</code>.
      # 
      # @param start the start color of the palette
      # @param end the end color of the palette
      # @param steps the requested size, must be &gt; 0
      # @return an array of <code>steps</code> colors in the palette from <code>start</code> to <code>end</code>
      def palette(start, end_, steps)
        Assert.is_legal(!(start).nil?)
        Assert.is_legal(!(end_).nil?)
        Assert.is_legal(steps > 0)
        if ((steps).equal?(1))
          return Array.typed(RGB).new([start])
        end
        step = 1.0 / (steps - 1)
        gradient = Array.typed(RGB).new(steps) { nil }
        i = 0
        while i < steps
          gradient[i] = blend(start, end_, step * i)
          i += 1
        end
        return gradient
      end
      
      typesig { [::Java::Int] }
      # Returns an array of colors with hues evenly distributed on the hue wheel defined by the <a
      # href="http://en.wikipedia.org/wiki/HSV_color_space">HSB color space</a>. The returned array
      # has size <code>steps</code>. The distance <var>d</var> between two successive colors is
      # in [120&#176;,&nbsp;180&#176;].
      # <p>
      # The color at a given <code>index</code> has the hue returned by
      # {@linkplain #computeHue(int) computeHue(index)}; i.e. the computed hues are not equidistant,
      # but adaptively distributed on the color wheel.
      # </p>
      # <p>
      # The first six colors returned correspond to the following {@link SWT} color constants:
      # {@link SWT#COLOR_RED red}, {@link SWT#COLOR_GREEN green}, {@link SWT#COLOR_BLUE blue},
      # {@link SWT#COLOR_YELLOW yellow}, {@link SWT#COLOR_CYAN cyan},
      # {@link SWT#COLOR_MAGENTA magenta}.
      # </p>
      # 
      # @param steps the requested size, must be &gt;= 2
      # @return an array of <code>steps</code> colors evenly distributed on the color wheel
      def rainbow(steps)
        Assert.is_legal(steps >= 2)
        rainbow = Array.typed(RGB).new(steps) { nil }
        i = 0
        while i < steps
          rainbow[i] = RGB.new(compute_hue(i), 1, 1)
          i += 1
        end
        return rainbow
      end
      
      typesig { [::Java::Int] }
      # Returns an indexed hue in [0&#176;,&nbsp;360&#176;), distributing the hues evenly on the hue wheel
      # defined by the <a href="http://en.wikipedia.org/wiki/HSV_color_space">HSB (or HSV) color
      # space</a>. The distance <var>d</var> between two successive colors is in [120&#176;,&nbsp;180&#176;].
      # <p>
      # The first six colors returned correspond to the following {@link SWT} color constants:
      # {@link SWT#COLOR_RED red}, {@link SWT#COLOR_GREEN green}, {@link SWT#COLOR_BLUE blue},
      # {@link SWT#COLOR_YELLOW yellow}, {@link SWT#COLOR_CYAN cyan},
      # {@link SWT#COLOR_MAGENTA magenta}.
      # </p>
      # 
      # @param index the index of the color, must be &gt;= 0
      # @return a color hue in [0&#176;,&nbsp;360&#176;)
      # @see RGB#RGB(float, float, float)
      def compute_hue(index)
        Assert.is_legal(index >= 0)
        # Base 3 gives a nice partitioning for RGB colors with red, green, blue being the colors
        # 0,1,2, and yellow, cyan, magenta colors 3,4,5.
        base = 3
        range = 360
        # partition the baseRange by using the least significant bit to select one half of the
        # partitioning
        base_index = index / base
        base_range = range / base
        base_offset = 0
        while (base_index > 0)
          base_range /= 2
          lsb = base_index % 2
          base_offset += lsb * base_range
          base_index >>= 1
        end
        base_mod = index % base
        hue = base_offset + base_mod * range / base
        Assert.is_true(hue >= 0 && hue < 360)
        return hue
      end
    }
    
    typesig { [] }
    def initialize
      # not instantiatable
    end
    
    private
    alias_method :initialize__colors, :initialize
  end
  
end
