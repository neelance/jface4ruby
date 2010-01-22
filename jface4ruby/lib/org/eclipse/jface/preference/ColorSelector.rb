require "rjava"

# Copyright (c) 2000, 2007 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Preference
  module ColorSelectorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Preference
      include_const ::Org::Eclipse::Core::Commands::Common, :EventManager
      include_const ::Org::Eclipse::Jface::Resource, :JFaceResources
      include_const ::Org::Eclipse::Jface::Util, :IPropertyChangeListener
      include_const ::Org::Eclipse::Jface::Util, :PropertyChangeEvent
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Accessibility, :AccessibleAdapter
      include_const ::Org::Eclipse::Swt::Accessibility, :AccessibleEvent
      include_const ::Org::Eclipse::Swt::Events, :DisposeEvent
      include_const ::Org::Eclipse::Swt::Events, :DisposeListener
      include_const ::Org::Eclipse::Swt::Events, :SelectionAdapter
      include_const ::Org::Eclipse::Swt::Events, :SelectionEvent
      include_const ::Org::Eclipse::Swt::Graphics, :Color
      include_const ::Org::Eclipse::Swt::Graphics, :Font
      include_const ::Org::Eclipse::Swt::Graphics, :SwtGC
      include_const ::Org::Eclipse::Swt::Graphics, :Image
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Graphics, :RGB
      include_const ::Org::Eclipse::Swt::Widgets, :Button
      include_const ::Org::Eclipse::Swt::Widgets, :ColorDialog
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Display
    }
  end
  
  # The <code>ColorSelector</code> is a wrapper for a button that displays a
  # selected <code>Color</code> and allows the user to change the selection.
  class ColorSelector < ColorSelectorImports.const_get :EventManager
    include_class_members ColorSelectorImports
    
    class_module.module_eval {
      # Property name that signifies the selected color of this
      # <code>ColorSelector</code> has changed.
      # 
      # @since 3.0
      const_set_lazy(:PROP_COLORCHANGE) { "colorValue" }
      const_attr_reader  :PROP_COLORCHANGE
    }
    
    # $NON-NLS-1$
    attr_accessor :f_button
    alias_method :attr_f_button, :f_button
    undef_method :f_button
    alias_method :attr_f_button=, :f_button=
    undef_method :f_button=
    
    attr_accessor :f_color
    alias_method :attr_f_color, :f_color
    undef_method :f_color
    alias_method :attr_f_color=, :f_color=
    undef_method :f_color=
    
    attr_accessor :f_color_value
    alias_method :attr_f_color_value, :f_color_value
    undef_method :f_color_value
    alias_method :attr_f_color_value=, :f_color_value=
    undef_method :f_color_value=
    
    attr_accessor :f_extent
    alias_method :attr_f_extent, :f_extent
    undef_method :f_extent
    alias_method :attr_f_extent=, :f_extent=
    undef_method :f_extent=
    
    attr_accessor :f_image
    alias_method :attr_f_image, :f_image
    undef_method :f_image
    alias_method :attr_f_image=, :f_image=
    undef_method :f_image=
    
    typesig { [Composite] }
    # Create a new instance of the reciever and the button that it wrappers in
    # the supplied parent <code>Composite</code>.
    # 
    # @param parent
    # The parent of the button.
    def initialize(parent)
      @f_button = nil
      @f_color = nil
      @f_color_value = nil
      @f_extent = nil
      @f_image = nil
      super()
      @f_button = Button.new(parent, SWT::PUSH)
      @f_extent = compute_image_size(parent)
      @f_image = Image.new(parent.get_display, @f_extent.attr_x, @f_extent.attr_y)
      gc = SwtGC.new(@f_image)
      gc.set_background(@f_button.get_background)
      gc.fill_rectangle(0, 0, @f_extent.attr_x, @f_extent.attr_y)
      gc.dispose
      @f_button.set_image(@f_image)
      @f_button.add_selection_listener(Class.new(SelectionAdapter.class == Class ? SelectionAdapter : Object) do
        local_class_in ColorSelector
        include_class_members ColorSelector
        include SelectionAdapter if SelectionAdapter.class == Module
        
        typesig { [SelectionEvent] }
        define_method :widget_selected do |event|
          open
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      @f_button.add_dispose_listener(Class.new(DisposeListener.class == Class ? DisposeListener : Object) do
        extend LocalClass
        include_class_members ColorSelector
        include DisposeListener if DisposeListener.class == Module
        
        typesig { [DisposeEvent] }
        define_method :widget_disposed do |event|
          if (!(self.attr_f_image).nil?)
            self.attr_f_image.dispose
            self.attr_f_image = nil
          end
          if (!(self.attr_f_color).nil?)
            self.attr_f_color.dispose
            self.attr_f_color = nil
          end
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      @f_button.get_accessible.add_accessible_listener(Class.new(AccessibleAdapter.class == Class ? AccessibleAdapter : Object) do
        extend LocalClass
        include_class_members ColorSelector
        include AccessibleAdapter if AccessibleAdapter.class == Module
        
        typesig { [AccessibleEvent] }
        # (non-Javadoc)
        # 
        # @see org.eclipse.swt.accessibility.AccessibleAdapter#getName(org.eclipse.swt.accessibility.AccessibleEvent)
        define_method :get_name do |e|
          e.attr_result = JFaceResources.get_string("ColorSelector.Name") # $NON-NLS-1$
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
    end
    
    typesig { [IPropertyChangeListener] }
    # Adds a property change listener to this <code>ColorSelector</code>.
    # Events are fired when the color in the control changes via the user
    # clicking an selecting a new one in the color dialog. No event is fired in
    # the case where <code>setColorValue(RGB)</code> is invoked.
    # 
    # @param listener
    # a property change listener
    # @since 3.0
    def add_listener(listener)
      add_listener_object(listener)
    end
    
    typesig { [Control] }
    # Compute the size of the image to be displayed.
    # 
    # @param window -
    # the window used to calculate
    # @return <code>Point</code>
    def compute_image_size(window)
      gc = SwtGC.new(window)
      f = JFaceResources.get_font_registry.get(JFaceResources::DIALOG_FONT)
      gc.set_font(f)
      height = gc.get_font_metrics.get_height
      gc.dispose
      p = Point.new(height * 3 - 6, height)
      return p
    end
    
    typesig { [] }
    # Get the button control being wrappered by the selector.
    # 
    # @return <code>Button</code>
    def get_button
      return @f_button
    end
    
    typesig { [] }
    # Return the currently displayed color.
    # 
    # @return <code>RGB</code>
    def get_color_value
      return @f_color_value
    end
    
    typesig { [IPropertyChangeListener] }
    # Removes the given listener from this <code>ColorSelector</code>. Has
    # no affect if the listener is not registered.
    # 
    # @param listener
    # a property change listener
    # @since 3.0
    def remove_listener(listener)
      remove_listener_object(listener)
    end
    
    typesig { [RGB] }
    # Set the current color value and update the control.
    # 
    # @param rgb
    # The new color.
    def set_color_value(rgb)
      @f_color_value = rgb
      update_color_image
    end
    
    typesig { [::Java::Boolean] }
    # Set whether or not the button is enabled.
    # 
    # @param state
    # the enabled state.
    def set_enabled(state)
      get_button.set_enabled(state)
    end
    
    typesig { [] }
    # Update the image being displayed on the button using the current color
    # setting.
    def update_color_image
      display = @f_button.get_display
      gc = SwtGC.new(@f_image)
      gc.set_foreground(display.get_system_color(SWT::COLOR_BLACK))
      gc.draw_rectangle(0, 2, @f_extent.attr_x - 1, @f_extent.attr_y - 4)
      if (!(@f_color).nil?)
        @f_color.dispose
      end
      @f_color = Color.new(display, @f_color_value)
      gc.set_background(@f_color)
      gc.fill_rectangle(1, 3, @f_extent.attr_x - 2, @f_extent.attr_y - 5)
      gc.dispose
      @f_button.set_image(@f_image)
    end
    
    typesig { [] }
    # Activate the editor for this selector. This causes the color selection
    # dialog to appear and wait for user input.
    # 
    # @since 3.2
    def open
      color_dialog = ColorDialog.new(@f_button.get_shell)
      color_dialog.set_rgb(@f_color_value)
      new_color = color_dialog.open
      if (!(new_color).nil?)
        old_value = @f_color_value
        @f_color_value = new_color
        final_listeners = get_listeners
        if (final_listeners.attr_length > 0)
          p_event = PropertyChangeEvent.new(self, PROP_COLORCHANGE, old_value, new_color)
          i = 0
          while i < final_listeners.attr_length
            listener = final_listeners[i]
            listener.property_change(p_event)
            (i += 1)
          end
        end
        update_color_image
      end
    end
    
    private
    alias_method :initialize__color_selector, :initialize
  end
  
end
