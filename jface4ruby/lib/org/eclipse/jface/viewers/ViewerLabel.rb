require "rjava"

# Copyright (c) 2004, 2007 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
# Tom Schindl <tom.shindl@bestsolution.at> - tooltip support
module Org::Eclipse::Jface::Viewers
  module ViewerLabelImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
      include_const ::Org::Eclipse::Swt::Graphics, :Color
      include_const ::Org::Eclipse::Swt::Graphics, :Font
      include_const ::Org::Eclipse::Swt::Graphics, :Image
      include_const ::Org::Eclipse::Swt::Graphics, :Point
    }
  end
  
  # The ViewerLabel is the class that is passed to a viewer to handle updates of
  # labels. It keeps track of both original and updates text.
  # 
  # @see IViewerLabelProvider
  # @since 3.0
  class ViewerLabel 
    include_class_members ViewerLabelImports
    
    # New values for the receiver. Null if nothing has been set.
    attr_accessor :new_text
    alias_method :attr_new_text, :new_text
    undef_method :new_text
    alias_method :attr_new_text=, :new_text=
    undef_method :new_text=
    
    attr_accessor :new_image
    alias_method :attr_new_image, :new_image
    undef_method :new_image
    alias_method :attr_new_image=, :new_image=
    undef_method :new_image=
    
    attr_accessor :image_updated
    alias_method :attr_image_updated, :image_updated
    undef_method :image_updated
    alias_method :attr_image_updated=, :image_updated=
    undef_method :image_updated=
    
    attr_accessor :text_updated
    alias_method :attr_text_updated, :text_updated
    undef_method :text_updated
    alias_method :attr_text_updated=, :text_updated=
    undef_method :text_updated=
    
    attr_accessor :background
    alias_method :attr_background, :background
    undef_method :background
    alias_method :attr_background=, :background=
    undef_method :background=
    
    attr_accessor :foreground
    alias_method :attr_foreground, :foreground
    undef_method :foreground
    alias_method :attr_foreground=, :foreground=
    undef_method :foreground=
    
    attr_accessor :font
    alias_method :attr_font, :font
    undef_method :font
    alias_method :attr_font=, :font=
    undef_method :font=
    
    # The initial values for the receiver.
    attr_accessor :start_text
    alias_method :attr_start_text, :start_text
    undef_method :start_text
    alias_method :attr_start_text=, :start_text=
    undef_method :start_text=
    
    attr_accessor :start_image
    alias_method :attr_start_image, :start_image
    undef_method :start_image
    alias_method :attr_start_image=, :start_image=
    undef_method :start_image=
    
    attr_accessor :has_pending_decorations
    alias_method :attr_has_pending_decorations, :has_pending_decorations
    undef_method :has_pending_decorations
    alias_method :attr_has_pending_decorations=, :has_pending_decorations=
    undef_method :has_pending_decorations=
    
    attr_accessor :tooltip_text
    alias_method :attr_tooltip_text, :tooltip_text
    undef_method :tooltip_text
    alias_method :attr_tooltip_text=, :tooltip_text=
    undef_method :tooltip_text=
    
    attr_accessor :tooltip_foreground_color
    alias_method :attr_tooltip_foreground_color, :tooltip_foreground_color
    undef_method :tooltip_foreground_color
    alias_method :attr_tooltip_foreground_color=, :tooltip_foreground_color=
    undef_method :tooltip_foreground_color=
    
    attr_accessor :tooltip_background_color
    alias_method :attr_tooltip_background_color, :tooltip_background_color
    undef_method :tooltip_background_color
    alias_method :attr_tooltip_background_color=, :tooltip_background_color=
    undef_method :tooltip_background_color=
    
    attr_accessor :tooltip_shift
    alias_method :attr_tooltip_shift, :tooltip_shift
    undef_method :tooltip_shift
    alias_method :attr_tooltip_shift=, :tooltip_shift=
    undef_method :tooltip_shift=
    
    typesig { [String, Image] }
    # Create a new instance of the receiver with the supplied initial text and
    # image.
    # 
    # @param initialText
    # @param initialImage
    def initialize(initial_text, initial_image)
      @new_text = nil
      @new_image = nil
      @image_updated = false
      @text_updated = false
      @background = nil
      @foreground = nil
      @font = nil
      @start_text = nil
      @start_image = nil
      @has_pending_decorations = false
      @tooltip_text = nil
      @tooltip_foreground_color = nil
      @tooltip_background_color = nil
      @tooltip_shift = nil
      @start_text = initial_text
      @start_image = initial_image
    end
    
    typesig { [] }
    # Get the image for the receiver. If the new image has been set return it,
    # otherwise return the starting image.
    # 
    # @return Returns the image.
    def get_image
      if (@image_updated)
        return @new_image
      end
      return @start_image
    end
    
    typesig { [Image] }
    # Set the image for the receiver.
    # 
    # @param image
    # The image to set.
    def set_image(image)
      @image_updated = true
      @new_image = image
    end
    
    typesig { [] }
    # Get the text for the receiver. If the new text has been set return it,
    # otherwise return the starting text.
    # 
    # @return String or <code>null</code> if there was no initial text and
    # nothing was updated.
    def get_text
      if (@text_updated)
        return @new_text
      end
      return @start_text
    end
    
    typesig { [String] }
    # Set the text for the receiver.
    # 
    # @param text
    # String The label to set. This value should not be
    # <code>null</code>.
    # @see #hasNewText()
    def set_text(text)
      @new_text = text
      @text_updated = true
    end
    
    typesig { [] }
    # Return whether or not the image has been set.
    # 
    # @return boolean. <code>true</code> if the image has been set to
    # something new.
    # 
    # @since 3.1
    def has_new_image
      # If we started with null any change is an update
      if ((@start_image).nil?)
        return !(@new_image).nil?
      end
      if (@image_updated)
        return !((@start_image == @new_image))
      end
      return false
    end
    
    typesig { [] }
    # Return whether or not the text has been set.
    # 
    # @return boolean. <code>true</code> if the text has been set to
    # something new.
    def has_new_text
      # If we started with null any change is an update
      if ((@start_text).nil?)
        return !(@new_text).nil?
      end
      if (@text_updated)
        return !((@start_text == @new_text))
      end
      return false
    end
    
    typesig { [] }
    # Return whether or not the background color has been set.
    # 
    # @return boolean. <code>true</code> if the value has been set.
    def has_new_background
      return !(@background).nil?
    end
    
    typesig { [] }
    # Return whether or not the foreground color has been set.
    # 
    # @return boolean. <code>true</code> if the value has been set.
    # 
    # @since 3.1
    def has_new_foreground
      return !(@foreground).nil?
    end
    
    typesig { [] }
    # Return whether or not the font has been set.
    # 
    # @return boolean. <code>true</code> if the value has been set.
    # 
    # @since 3.1
    def has_new_font
      return !(@font).nil?
    end
    
    typesig { [] }
    # Get the background Color.
    # 
    # @return Color or <code>null</code> if no new value was set.
    # 
    # @since 3.1
    def get_background
      return @background
    end
    
    typesig { [Color] }
    # Set the background Color.
    # 
    # @param background
    # Color. This value should not be <code>null</code>.
    # 
    # @since 3.1
    def set_background(background)
      @background = background
    end
    
    typesig { [] }
    # Get the font.
    # 
    # @return Font or <code>null</code> if no new value was set.
    # 
    # @since 3.1
    def get_font
      return @font
    end
    
    typesig { [Font] }
    # Set the font.
    # 
    # @param font
    # Font This value should not be <code>null</code>.
    # 
    # @since 3.1
    def set_font(font)
      @font = font
    end
    
    typesig { [] }
    # Get the foreground Color.
    # 
    # @return Color or <code>null</code> if no new value was set.
    # 
    # @since 3.1
    def get_foreground
      return @foreground
    end
    
    typesig { [Color] }
    # Set the foreground Color.
    # 
    # @param foreground
    # Color This value should not be <code>null</code>.
    # 
    # @since 3.1
    def set_foreground(foreground)
      @foreground = foreground
    end
    
    typesig { [::Java::Boolean] }
    # Set whether or not there are any decorations pending.
    # 
    # @param hasPendingDecorations
    def set_has_pending_decorations(has_pending_decorations)
      @has_pending_decorations = has_pending_decorations
    end
    
    typesig { [] }
    # @return <code>boolean</code>. <code>true</code> if there are any
    # decorations pending.
    def has_pending_decorations
      return @has_pending_decorations
    end
    
    typesig { [] }
    # Returns the tooltipText.
    # 
    # @return {@link String} or <code>null</code> if the tool tip text was
    # never set.
    # 
    # @since 3.3
    def get_tooltip_text
      return @tooltip_text
    end
    
    typesig { [String] }
    # Set the tool tip text.
    # 
    # @param tooltipText
    # The tooltipText {@link String} to set. This value should not
    # be <code>null</code>.
    # 
    # @since 3.3
    def set_tooltip_text(tooltip_text)
      @tooltip_text = tooltip_text
    end
    
    typesig { [] }
    # Return whether or not the tool tip text has been set.
    # 
    # @return <code>boolean</code>. <code>true</code> if the tool tip text
    # has been set.
    # 
    # @since 3.3
    def has_new_tooltip_text
      return !(@tooltip_text).nil?
    end
    
    typesig { [] }
    # Return the tool tip background color.
    # 
    # @return {@link Color} or <code>null</code> if the tool tip background
    # color has not been set.
    # 
    # @since 3.3
    def get_tooltip_background_color
      return @tooltip_background_color
    end
    
    typesig { [Color] }
    # Set the background {@link Color} for tool tip.
    # 
    # @param tooltipBackgroundColor
    # The {@link Color} to set. This value should not be
    # <code>null</code>.
    # 
    # @since 3.3
    def set_tooltip_background_color(tooltip_background_color)
      @tooltip_background_color = tooltip_background_color
    end
    
    typesig { [] }
    # Return whether or not the tool tip background color has been set.
    # 
    # @return <code>boolean</code>. <code>true</code> if the tool tip text
    # has been set.
    # 
    # @since 3.3
    def has_new_tooltip_background_color
      return !(@tooltip_background_color).nil?
    end
    
    typesig { [] }
    # Return the foreground {@link Color}.
    # 
    # @return Returns {@link Color} or <code>null</code> if the tool tip
    # foreground color has not been set.
    # 
    # @since 3.3
    def get_tooltip_foreground_color
      return @tooltip_foreground_color
    end
    
    typesig { [Color] }
    # Set the foreground {@link Color} for tool tip.
    # 
    # @param tooltipForegroundColor
    # The tooltipForegroundColor to set.
    # 
    # @since 3.3
    def set_tooltip_foreground_color(tooltip_foreground_color)
      @tooltip_foreground_color = tooltip_foreground_color
    end
    
    typesig { [] }
    # Return whether or not the tool tip foreground color has been set.
    # 
    # @return <code>boolean</code>. <code>true</code> if the tool tip foreground
    # has been set.
    # 
    # @since 3.3
    def has_new_tooltip_foreground_color
      return !(@tooltip_foreground_color).nil?
    end
    
    typesig { [] }
    # @return Returns the tooltipShift.
    # @since 3.3
    def get_tooltip_shift
      return @tooltip_shift
    end
    
    typesig { [Point] }
    # @param tooltipShift
    # The tooltipShift to set.
    # @since 3.3
    def set_tooltip_shift(tooltip_shift)
      @tooltip_shift = tooltip_shift
    end
    
    typesig { [] }
    # @return Return whether or not the tool tip shift has been set.
    # @since 3.3
    def has_tooltip_shift
      return !(@tooltip_shift).nil?
    end
    
    private
    alias_method :initialize__viewer_label, :initialize
  end
  
end
