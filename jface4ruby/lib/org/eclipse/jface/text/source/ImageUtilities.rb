require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Source
  module ImageUtilitiesImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Source
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Graphics, :FontMetrics
      include_const ::Org::Eclipse::Swt::Graphics, :GC
      include_const ::Org::Eclipse::Swt::Graphics, :Image
      include_const ::Org::Eclipse::Swt::Graphics, :Rectangle
      include_const ::Org::Eclipse::Swt::Widgets, :Canvas
    }
  end
  
  # Provides methods for drawing images onto a canvas.
  # <p>
  # This class is neither intended to be instantiated nor subclassed.
  # </p>
  # 
  # @since 3.0
  # @noinstantiate This class is not intended to be instantiated by clients.
  # @noextend This class is not intended to be subclassed by clients.
  class ImageUtilities 
    include_class_members ImageUtilitiesImports
    
    class_module.module_eval {
      typesig { [Image, GC, Canvas, Rectangle, ::Java::Int, ::Java::Int] }
      # Draws an image aligned inside the given rectangle on the given canvas.
      # 
      # @param image the image to be drawn
      # @param gc the drawing GC
      # @param canvas the canvas on which to draw
      # @param r the clipping rectangle
      # @param halign the horizontal alignment of the image to be drawn
      # @param valign the vertical alignment of the image to be drawn
      def draw_image(image, gc, canvas, r, halign, valign)
        if (!(image).nil?)
          bounds = image.get_bounds
          x = 0
          case (halign)
          when SWT::LEFT
          when SWT::CENTER
            x = (r.attr_width - bounds.attr_width) / 2
          when SWT::RIGHT
            x = r.attr_width - bounds.attr_width
          end
          y = 0
          case (valign)
          when SWT::TOP
            font_metrics = gc.get_font_metrics
            y = (font_metrics.get_height - bounds.attr_height) / 2
          when SWT::CENTER
            y = (r.attr_height - bounds.attr_height) / 2
          when SWT::BOTTOM
            font_metrics = gc.get_font_metrics
            y = r.attr_height - (font_metrics.get_height + bounds.attr_height) / 2
          end
          gc.draw_image(image, r.attr_x + x, r.attr_y + y)
        end
      end
      
      typesig { [Image, GC, Canvas, Rectangle, ::Java::Int] }
      # Draws an image aligned inside the given rectangle on the given canvas.
      # 
      # @param image the image to be drawn
      # @param gc the drawing GC
      # @param canvas the canvas on which to draw
      # @param r the clipping rectangle
      # @param align the alignment of the image to be drawn
      def draw_image(image, gc, canvas, r, align)
        draw_image(image, gc, canvas, r, align, SWT::CENTER)
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__image_utilities, :initialize
  end
  
end
