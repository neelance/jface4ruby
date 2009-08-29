require "rjava"

# Copyright (c) 2000, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Resource
  module JFaceColorsImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Resource
      include_const ::Org::Eclipse::Jface::Preference, :JFacePreferences
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Graphics, :Color
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Display
    }
  end
  
  # JFaceColors is the class that stores references
  # to all of the colors used by JFace.
  class JFaceColors 
    include_class_members JFaceColorsImports
    
    class_module.module_eval {
      typesig { [Display] }
      # @param display the display the color is from
      # @return the Color used for banner backgrounds
      # @see SWT#COLOR_LIST_BACKGROUND
      # @see Display#getSystemColor(int)
      def get_banner_background(display)
        return display.get_system_color(SWT::COLOR_LIST_BACKGROUND)
      end
      
      typesig { [Display] }
      # @param display the display the color is from
      # @return the Color used for banner foregrounds
      # @see SWT#COLOR_LIST_FOREGROUND
      # @see Display#getSystemColor(int)
      def get_banner_foreground(display)
        return display.get_system_color(SWT::COLOR_LIST_FOREGROUND)
      end
      
      typesig { [Display] }
      # @param display the display the color is from
      # @return the background Color for widgets that display errors.
      # @see SWT#COLOR_WIDGET_BACKGROUND
      # @see Display#getSystemColor(int)
      def get_error_background(display)
        return display.get_system_color(SWT::COLOR_WIDGET_BACKGROUND)
      end
      
      typesig { [Display] }
      # @param display the display the color is from
      # @return the border Color for widgets that display errors.
      # @see SWT#COLOR_WIDGET_DARK_SHADOW
      # @see Display#getSystemColor(int)
      def get_error_border(display)
        return display.get_system_color(SWT::COLOR_WIDGET_DARK_SHADOW)
      end
      
      typesig { [Display] }
      # @param display the display the color is from
      # @return the default color to use for displaying errors.
      # @see ColorRegistry#get(String)
      # @see JFacePreferences#ERROR_COLOR
      def get_error_text(display)
        return JFaceResources.get_color_registry.get(JFacePreferences::ERROR_COLOR)
      end
      
      typesig { [Display] }
      # @param display the display the color is from
      # @return the default color to use for displaying hyperlinks.
      # @see ColorRegistry#get(String)
      # @see JFacePreferences#HYPERLINK_COLOR
      def get_hyperlink_text(display)
        return JFaceResources.get_color_registry.get(JFacePreferences::HYPERLINK_COLOR)
      end
      
      typesig { [Display] }
      # @param display the display the color is from
      # @return the default color to use for displaying active hyperlinks.
      # @see ColorRegistry#get(String)
      # @see JFacePreferences#ACTIVE_HYPERLINK_COLOR
      def get_active_hyperlink_text(display)
        return JFaceResources.get_color_registry.get(JFacePreferences::ACTIVE_HYPERLINK_COLOR)
      end
      
      typesig { [String] }
      # Clear out the cached color for name. This is generally
      # done when the color preferences changed and any cached colors
      # may be disposed. Users of the colors in this class should add a IPropertyChangeListener
      # to detect when any of these colors change.
      # @param colorName name of the color
      # 
      # @deprecated JFaceColors no longer maintains a cache of colors.  This job
      # is now handled by the ColorRegistry.
      def clear_color(color_name)
        # no-op
      end
      
      typesig { [] }
      # Dispose of all allocated colors. Called on workbench
      # shutdown.
      # 
      # @deprecated JFaceColors no longer maintains a cache of colors.  This job
      # is now handled by the ColorRegistry.
      def dispose_colors
        # no-op
      end
      
      typesig { [Control, Color, Color] }
      # Set the foreground and background colors of the
      # control to the specified values. If the values are
      # null than ignore them.
      # @param control the control the foreground and/or background color should be set
      # 
      # @param foreground Color the foreground color (maybe <code>null</code>)
      # @param background Color the background color (maybe <code>null</code>)
      def set_colors(control, foreground, background)
        if (!(foreground).nil?)
          control.set_foreground(foreground)
        end
        if (!(background).nil?)
          control.set_background(background)
        end
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__jface_colors, :initialize
  end
  
end
