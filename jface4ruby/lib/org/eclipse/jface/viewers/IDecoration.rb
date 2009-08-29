require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Viewers
  module IDecorationImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
      include_const ::Org::Eclipse::Jface::Resource, :ImageDescriptor
      include_const ::Org::Eclipse::Swt::Graphics, :Color
      include_const ::Org::Eclipse::Swt::Graphics, :Font
    }
  end
  
  # Defines the result of decorating an element.
  # 
  # This interface is not meant to be implemented and will be provided to
  # instances of <code>ILightweightLabelDecorator</code>.
  # @noimplement This interface is not intended to be implemented by clients.
  module IDecoration
    include_class_members IDecorationImports
    
    class_module.module_eval {
      # Constants for placement of image decorations.
      const_set_lazy(:TOP_LEFT) { 0 }
      const_attr_reader  :TOP_LEFT
      
      # Constant for the top right quadrant.
      const_set_lazy(:TOP_RIGHT) { 1 }
      const_attr_reader  :TOP_RIGHT
      
      # Constant for the bottom left quadrant.
      const_set_lazy(:BOTTOM_LEFT) { 2 }
      const_attr_reader  :BOTTOM_LEFT
      
      # Constant for the bottom right quadrant.
      const_set_lazy(:BOTTOM_RIGHT) { 3 }
      const_attr_reader  :BOTTOM_RIGHT
      
      # Constant for the underlay.
      const_set_lazy(:UNDERLAY) { 4 }
      const_attr_reader  :UNDERLAY
      
      # Constant for replacing the original image. Note that for this to have an
      # effect on the resulting decorated image, {@link #ENABLE_REPLACE} has to
      # be set to {@link Boolean#TRUE} in the {@link IDecorationContext} (opt-in
      # model). If replacement behavior is enabled, the resulting decorated image
      # will be constructed by first painting the underlay, then the replacement
      # image, and then the regular quadrant images.
      # 
      # @since 3.4
      const_set_lazy(:REPLACE) { 5 }
      const_attr_reader  :REPLACE
      
      # Constant that is used as the property key on an
      # {@link IDecorationContext}. To enable image replacement, set to
      # {@link Boolean#TRUE}.
      # 
      # @since 3.4
      # @see IDecorationContext
      const_set_lazy(:ENABLE_REPLACE) { "org.eclipse.jface.viewers.IDecoration.disableReplace" }
      const_attr_reader  :ENABLE_REPLACE
    }
    
    typesig { [String] }
    # $NON-NLS-1$
    # 
    # Adds a prefix to the element's label.
    # 
    # @param prefix
    # the prefix
    def add_prefix(prefix)
      raise NotImplementedError
    end
    
    typesig { [String] }
    # Adds a suffix to the element's label.
    # 
    # @param suffix
    # the suffix
    def add_suffix(suffix)
      raise NotImplementedError
    end
    
    typesig { [ImageDescriptor] }
    # Adds an overlay to the element's image.
    # 
    # @param overlay
    # the overlay image descriptor
    def add_overlay(overlay)
      raise NotImplementedError
    end
    
    typesig { [ImageDescriptor, ::Java::Int] }
    # Adds an overlay to the element's image.
    # 
    # @param overlay
    # the overlay image descriptor
    # @param quadrant
    # The constant for the quadrant to draw the image on.
    def add_overlay(overlay, quadrant)
      raise NotImplementedError
    end
    
    typesig { [Color] }
    # Set the foreground color for this decoration.
    # @param color the color to be set for the foreground
    # 
    # @since 3.1
    def set_foreground_color(color)
      raise NotImplementedError
    end
    
    typesig { [Color] }
    # Set the background color for this decoration.
    # @param color the color to be set for the background
    # 
    # @since 3.1
    def set_background_color(color)
      raise NotImplementedError
    end
    
    typesig { [Font] }
    # Set the font for this decoration.
    # @param font the font to use in this decoration
    # 
    # @since 3.1
    def set_font(font)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Return the decoration context in which this decoration
    # will be applied.
    # @return the decoration context
    # 
    # @since 3.2
    def get_decoration_context
      raise NotImplementedError
    end
  end
  
end
