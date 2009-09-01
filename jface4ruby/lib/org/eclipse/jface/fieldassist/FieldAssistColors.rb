require "rjava"

# Copyright (c) 2006, 2007 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Fieldassist
  module FieldAssistColorsImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Fieldassist
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :Map
      include_const ::Org::Eclipse::Jface::Resource, :JFaceColors
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Graphics, :Color
      include_const ::Org::Eclipse::Swt::Graphics, :RGB
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Display
    }
  end
  
  # FieldAssistColors defines protocol for retrieving colors that can be used to
  # provide visual cues with fields. For consistency with JFace dialogs and
  # wizards, it is recommended that FieldAssistColors is used when colors are
  # used to annotate fields.
  # <p>
  # Color resources that are returned using methods in this class are maintained
  # in the JFace color registries, or by SWT. Users of any color resources
  # provided by this class are not responsible for the lifecycle of the color.
  # Colors provided by this class should never be disposed by clients. In some
  # cases, clients are provided information, such as RGB values, in order to
  # create their own color resources. In these cases, the client should manage
  # the lifecycle of any created resource.
  # 
  # @since 3.2
  # @deprecated As of 3.3, this class is no longer necessary.
  class FieldAssistColors 
    include_class_members FieldAssistColorsImports
    
    class_module.module_eval {
      
      def debug
        defined?(@@debug) ? @@debug : @@debug= false
      end
      alias_method :attr_debug, :debug
      
      def debug=(value)
        @@debug = value
      end
      alias_method :attr_debug=, :debug=
      
      # Keys are background colors, values are the color with the alpha value
      # applied
      
      def required_field_color_map
        defined?(@@required_field_color_map) ? @@required_field_color_map : @@required_field_color_map= HashMap.new
      end
      alias_method :attr_required_field_color_map, :required_field_color_map
      
      def required_field_color_map=(value)
        @@required_field_color_map = value
      end
      alias_method :attr_required_field_color_map=, :required_field_color_map=
      
      # Keys are colors we have created, values are the displays on which they
      # were created.
      
      def displays
        defined?(@@displays) ? @@displays : @@displays= HashMap.new
      end
      alias_method :attr_displays, :displays
      
      def displays=(value)
        @@displays = value
      end
      alias_method :attr_displays=, :displays=
      
      typesig { [Control] }
      # Compute the RGB of the color that should be used for the background of a
      # control to indicate that the control has an error. Because the color
      # suitable for indicating an error depends on the colors set into the
      # control, this color is always computed dynamically and provided as an RGB
      # value. Clients who use this RGB to create a Color resource are
      # responsible for managing the life cycle of the color.
      # <p>
      # This color is computed dynamically each time that it is queried. Clients
      # should typically call this method once, create a color from the RGB
      # provided, and dispose of the color when finished using it.
      # 
      # @param control
      # the control for which the background color should be computed.
      # @return the RGB value indicating a background color appropriate for
      # indicating an error in the control.
      def compute_error_field_background_rgb(control)
        # Use a 10% alpha of the error color applied on top of the widget
        # background color.
        dest = control.get_background
        src = JFaceColors.get_error_text(control.get_display)
        dest_red = dest.get_red
        dest_green = dest.get_green
        dest_blue = dest.get_blue
        # 10% alpha
        alpha = RJava.cast_to_int((0xff * 0.10))
        # Alpha blending math
        dest_red += (src.get_red - dest_red) * alpha / 0xff
        dest_green += (src.get_green - dest_green) * alpha / 0xff
        dest_blue += (src.get_blue - dest_blue) * alpha / 0xff
        return RGB.new(dest_red, dest_green, dest_blue)
      end
      
      typesig { [Control] }
      # Return the color that should be used for the background of a control to
      # indicate that the control is a required field and does not have content.
      # <p>
      # This color is managed by FieldAssistResources and should never be
      # disposed by clients.
      # 
      # @param control
      # the control on which the background color will be used.
      # @return the color used to indicate that a field is required.
      def get_required_field_background_color(control)
        display = control.get_display
        # If we are in high contrast mode, then don't apply an alpha
        if (display.get_high_contrast)
          return control.get_background
        end
        # See if a color has already been computed
        stored_color = self.attr_required_field_color_map.get(control.get_background)
        if (!(stored_color).nil?)
          return stored_color
        end
        # There is no color already created, so we must create one.
        # Use a 15% alpha of yellow on top of the widget background.
        dest = control.get_background
        src = display.get_system_color(SWT::COLOR_YELLOW)
        dest_red = dest.get_red
        dest_green = dest.get_green
        dest_blue = dest.get_blue
        # 15% alpha
        alpha = RJava.cast_to_int((0xff * 0.15))
        # Alpha blending math
        dest_red += (src.get_red - dest_red) * alpha / 0xff
        dest_green += (src.get_green - dest_green) * alpha / 0xff
        dest_blue += (src.get_blue - dest_blue) * alpha / 0xff
        # create the color
        color = Color.new(display, dest_red, dest_green, dest_blue)
        # record the color in a map using the original color as the key
        self.attr_required_field_color_map.put(dest, color)
        # If we have never created a color on this display before, install
        # a dispose exec on the display.
        if (!self.attr_displays.contains_value(display))
          display.dispose_exec(Class.new(Runnable.class == Class ? Runnable : Object) do
            extend LocalClass
            include_class_members FieldAssistColors
            include Runnable if Runnable.class == Module
            
            typesig { [] }
            define_method :run do
              dispose_colors(display)
            end
            
            typesig { [Vararg.new(Object)] }
            define_method :initialize do |*args|
              super(*args)
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
        end
        # Record the color and its display in a map for later disposal.
        self.attr_displays.put(color, display)
        return color
      end
      
      typesig { [Display] }
      # Dispose any colors that were allocated for the given display.
      def dispose_colors(display)
        to_be_removed = ArrayList.new(1)
        if (self.attr_debug)
          System.out.println("Display map is " + RJava.cast_to_string(self.attr_displays.to_s)) # $NON-NLS-1$
          System.out.println("Color map is " + RJava.cast_to_string(self.attr_required_field_color_map.to_s)) # $NON-NLS-1$
        end
        # Look for any stored colors that were created on this display
        i = self.attr_displays.key_set.iterator
        while i.has_next
          color = i.next_
          if (((self.attr_displays.get(color)) == display))
            # The color is on this display. Mark it for removal.
            to_be_removed.add(color)
            # Now look for any references to it in the required field color
            # map
            to_be_removed_from_required_map = ArrayList.new(1)
            iter = self.attr_required_field_color_map.key_set.iterator
            while iter.has_next
              bg_color = iter.next_
              if (((self.attr_required_field_color_map.get(bg_color)) == color))
                # mark it for removal from the required field color map
                to_be_removed_from_required_map.add(bg_color)
              end
            end
            # Remove references in the required field map now that
            # we are done iterating.
            j = 0
            while j < to_be_removed_from_required_map.size
              self.attr_required_field_color_map.remove(to_be_removed_from_required_map.get(j))
              j += 1
            end
          end
        end
        # Remove references in the display map now that we are
        # done iterating
        i_ = 0
        while i_ < to_be_removed.size
          color = to_be_removed.get(i_)
          # Removing from the display map must be done before disposing the
          # color or else the comparison between this color and the one
          # in the map will fail.
          self.attr_displays.remove(color)
          # Dispose it
          if (self.attr_debug)
            System.out.println("Disposing color " + RJava.cast_to_string(color.to_s)) # $NON-NLS-1$
          end
          color.dispose
          i_ += 1
        end
        if (self.attr_debug)
          System.out.println("Display map is " + RJava.cast_to_string(self.attr_displays.to_s)) # $NON-NLS-1$
          System.out.println("Color map is " + RJava.cast_to_string(self.attr_required_field_color_map.to_s)) # $NON-NLS-1$
        end
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__field_assist_colors, :initialize
  end
  
end
