require "rjava"

# Copyright (c) 2006, 2007 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Window
  module DefaultToolTipImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Window
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Custom, :CLabel
      include_const ::Org::Eclipse::Swt::Graphics, :Color
      include_const ::Org::Eclipse::Swt::Graphics, :Font
      include_const ::Org::Eclipse::Swt::Graphics, :Image
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Event
    }
  end
  
  # Default implementation of ToolTip that provides an iconofied label with font
  # and color controls by subclass.
  # 
  # @since 3.3
  class DefaultToolTip < DefaultToolTipImports.const_get :ToolTip
    include_class_members DefaultToolTipImports
    
    attr_accessor :text
    alias_method :attr_text, :text
    undef_method :text
    alias_method :attr_text=, :text=
    undef_method :text=
    
    attr_accessor :background_color
    alias_method :attr_background_color, :background_color
    undef_method :background_color
    alias_method :attr_background_color=, :background_color=
    undef_method :background_color=
    
    attr_accessor :font
    alias_method :attr_font, :font
    undef_method :font
    alias_method :attr_font=, :font=
    undef_method :font=
    
    attr_accessor :background_image
    alias_method :attr_background_image, :background_image
    undef_method :background_image
    alias_method :attr_background_image=, :background_image=
    undef_method :background_image=
    
    attr_accessor :foreground_color
    alias_method :attr_foreground_color, :foreground_color
    undef_method :foreground_color
    alias_method :attr_foreground_color=, :foreground_color=
    undef_method :foreground_color=
    
    attr_accessor :image
    alias_method :attr_image, :image
    undef_method :image
    alias_method :attr_image=, :image=
    undef_method :image=
    
    attr_accessor :style
    alias_method :attr_style, :style
    undef_method :style
    alias_method :attr_style=, :style=
    undef_method :style=
    
    typesig { [Control] }
    # Create new instance which add TooltipSupport to the widget
    # 
    # @param control the control on whose action the tooltip is shown
    def initialize(control)
      @text = nil
      @background_color = nil
      @font = nil
      @background_image = nil
      @foreground_color = nil
      @image = nil
      @style = 0
      super(control)
      @style = SWT::SHADOW_NONE
    end
    
    typesig { [Control, ::Java::Int, ::Java::Boolean] }
    # Create new instance which add TooltipSupport to the widget
    # 
    # @param control the control to which the tooltip is bound
    # @param style style passed to control tooltip behaviour
    # @param manualActivation <code>true</code> if the activation is done manually using
    # {@link #show(Point)}
    # @see #RECREATE
    # @see #NO_RECREATE
    def initialize(control, style, manual_activation)
      @text = nil
      @background_color = nil
      @font = nil
      @background_image = nil
      @foreground_color = nil
      @image = nil
      @style = 0
      super(control, style, manual_activation)
      @style = SWT::SHADOW_NONE
    end
    
    typesig { [Event, Composite] }
    # Creates the content are of the the tooltip. By default this creates a
    # CLabel to display text. To customize the text Subclasses may override the
    # following methods
    # <ul>
    # <li>{@link #getStyle(Event)}</li>
    # <li>{@link #getBackgroundColor(Event)}</li>
    # <li>{@link #getForegroundColor(Event)}</li>
    # <li>{@link #getFont(Event)}</li>
    # <li>{@link #getImage(Event)}</li>
    # <li>{@link #getText(Event)}</li>
    # <li>{@link #getBackgroundImage(Event)}</li>
    # </ul>
    # 
    # @param event
    # the event that triggered the activation of the tooltip
    # @param parent
    # the parent of the content area
    # @return the content area created
    def create_tool_tip_content_area(event, parent)
      image = get_image(event)
      bg_image = get_background_image(event)
      text = get_text(event)
      fg_color = get_foreground_color(event)
      bg_color = get_background_color(event)
      font = get_font(event)
      label = CLabel.new(parent, get_style(event))
      if (!(text).nil?)
        label.set_text(text)
      end
      if (!(image).nil?)
        label.set_image(image)
      end
      if (!(fg_color).nil?)
        label.set_foreground(fg_color)
      end
      if (!(bg_color).nil?)
        label.set_background(bg_color)
      end
      if (!(bg_image).nil?)
        label.set_background_image(image)
      end
      if (!(font).nil?)
        label.set_font(font)
      end
      return label
    end
    
    typesig { [Event] }
    # The style used to create the {@link CLabel} in the default implementation
    # 
    # @param event
    # the event triggered the popup of the tooltip
    # @return the style
    def get_style(event)
      return @style
    end
    
    typesig { [Event] }
    # The {@link Image} displayed in the {@link CLabel} in the default
    # implementation implementation
    # 
    # @param event
    # the event triggered the popup of the tooltip
    # @return the {@link Image} or <code>null</code> if no image should be
    # displayed
    def get_image(event)
      return @image
    end
    
    typesig { [Event] }
    # The foreground {@link Color} used by {@link CLabel} in the default
    # implementation
    # 
    # @param event
    # the event triggered the popup of the tooltip
    # @return the {@link Color} or <code>null</code> if default foreground
    # color should be used
    def get_foreground_color(event)
      return ((@foreground_color).nil?) ? event.attr_widget.get_display.get_system_color(SWT::COLOR_INFO_FOREGROUND) : @foreground_color
    end
    
    typesig { [Event] }
    # The background {@link Color} used by {@link CLabel} in the default
    # implementation
    # 
    # @param event
    # the event triggered the popup of the tooltip
    # @return the {@link Color} or <code>null</code> if default background
    # color should be used
    def get_background_color(event)
      return ((@background_color).nil?) ? event.attr_widget.get_display.get_system_color(SWT::COLOR_INFO_BACKGROUND) : @background_color
    end
    
    typesig { [Event] }
    # The background {@link Image} used by {@link CLabel} in the default
    # implementation
    # 
    # @param event
    # the event triggered the popup of the tooltip
    # @return the {@link Image} or <code>null</code> if no image should be
    # displayed in the background
    def get_background_image(event)
      return @background_image
    end
    
    typesig { [Event] }
    # The {@link Font} used by {@link CLabel} in the default implementation
    # 
    # @param event
    # the event triggered the popup of the tooltip
    # @return the {@link Font} or <code>null</code> if the default font
    # should be used
    def get_font(event)
      return @font
    end
    
    typesig { [Event] }
    # The text displayed in the {@link CLabel} in the default implementation
    # 
    # @param event
    # the event triggered the popup of the tooltip
    # @return the text or <code>null</code> if no text has to be displayed
    def get_text(event)
      return @text
    end
    
    typesig { [Color] }
    # The background {@link Image} used by {@link CLabel} in the default
    # implementation
    # 
    # @param backgroundColor
    # the {@link Color} or <code>null</code> if default background
    # color ({@link SWT#COLOR_INFO_BACKGROUND}) should be used
    def set_background_color(background_color)
      @background_color = background_color
    end
    
    typesig { [Image] }
    # The background {@link Image} used by {@link CLabel} in the default
    # implementation
    # 
    # @param backgroundImage
    # the {@link Image} or <code>null</code> if no image should be
    # displayed in the background
    def set_background_image(background_image)
      @background_image = background_image
    end
    
    typesig { [Font] }
    # The {@link Font} used by {@link CLabel} in the default implementation
    # 
    # @param font
    # the {@link Font} or <code>null</code> if the default font
    # should be used
    def set_font(font)
      @font = font
    end
    
    typesig { [Color] }
    # The foreground {@link Color} used by {@link CLabel} in the default
    # implementation
    # 
    # @param foregroundColor
    # the {@link Color} or <code>null</code> if default foreground
    # color should be used
    def set_foreground_color(foreground_color)
      @foreground_color = foreground_color
    end
    
    typesig { [Image] }
    # The {@link Image} displayed in the {@link CLabel} in the default
    # implementation implementation
    # 
    # @param image
    # the {@link Image} or <code>null</code> if no image should be
    # displayed
    def set_image(image)
      @image = image
    end
    
    typesig { [::Java::Int] }
    # The style used to create the {@link CLabel} in the default implementation
    # 
    # @param style
    # the event triggered the popup of the tooltip
    def set_style(style)
      @style = style
    end
    
    typesig { [String] }
    # The text displayed in the {@link CLabel} in the default implementation
    # 
    # @param text
    # the text or <code>null</code> if no text has to be displayed
    def set_text(text)
      @text = text
    end
    
    private
    alias_method :initialize__default_tool_tip, :initialize
  end
  
end
