require "rjava"

# Copyright (c) 2003, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Resource
  module ColorRegistryImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Resource
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :Collections
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :Map
      include_const ::Java::Util, :JavaSet
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Swt::Graphics, :Color
      include_const ::Org::Eclipse::Swt::Graphics, :RGB
      include_const ::Org::Eclipse::Swt::Widgets, :Display
    }
  end
  
  # A color registry maintains a mapping between symbolic color names and SWT
  # <code>Color</code>s.
  # <p>
  # A color registry owns all of the <code>Color</code> objects registered with
  # it, and automatically disposes of them when the SWT Display that creates the
  # <code>Color</code>s is disposed. Because of this, clients do not need to
  # (indeed, must not attempt to) dispose of <code>Color</code> objects
  # themselves.
  # </p>
  # <p>
  # Methods are provided for registering listeners that will be kept
  # apprised of changes to list of registed colors.
  # </p>
  # <p>
  # Clients may instantiate this class (it was not designed to be subclassed).
  # </p>
  # 
  # @since 3.0
  # @noextend This class is not intended to be subclassed by clients.
  class ColorRegistry < ColorRegistryImports.const_get :ResourceRegistry
    include_class_members ColorRegistryImports
    
    class_module.module_eval {
      # Default color value.  This is cyan (very unappetizing).
      # @since 3.4
      const_set_lazy(:DEFAULT_COLOR) { RGBColorDescriptor.new(RGB.new(0, 255, 255)) }
      const_attr_reader  :DEFAULT_COLOR
    }
    
    # This registries <code>Display</code>. All colors will be allocated using
    # it.
    attr_accessor :display
    alias_method :attr_display, :display
    undef_method :display
    alias_method :attr_display=, :display=
    undef_method :display=
    
    # Collection of <code>Color</code> that are now stale to be disposed when
    # it is safe to do so (i.e. on shutdown).
    attr_accessor :stale_colors
    alias_method :attr_stale_colors, :stale_colors
    undef_method :stale_colors
    alias_method :attr_stale_colors=, :stale_colors=
    undef_method :stale_colors=
    
    # Table of known colors, keyed by symbolic color name (key type: <code>String</code>,
    # value type: <code>org.eclipse.swt.graphics.Color</code>.
    attr_accessor :string_to_color
    alias_method :attr_string_to_color, :string_to_color
    undef_method :string_to_color
    alias_method :attr_string_to_color=, :string_to_color=
    undef_method :string_to_color=
    
    # Table of known color data, keyed by symbolic color name (key type:
    # <code>String</code>, value type: <code>org.eclipse.swt.graphics.RGB</code>).
    attr_accessor :string_to_rgb
    alias_method :attr_string_to_rgb, :string_to_rgb
    undef_method :string_to_rgb
    alias_method :attr_string_to_rgb=, :string_to_rgb=
    undef_method :string_to_rgb=
    
    # Runnable that cleans up the manager on disposal of the display.
    attr_accessor :display_runnable
    alias_method :attr_display_runnable, :display_runnable
    undef_method :display_runnable
    alias_method :attr_display_runnable=, :display_runnable=
    undef_method :display_runnable=
    
    attr_accessor :clean_on_display_disposal
    alias_method :attr_clean_on_display_disposal, :clean_on_display_disposal
    undef_method :clean_on_display_disposal
    alias_method :attr_clean_on_display_disposal=, :clean_on_display_disposal=
    undef_method :clean_on_display_disposal=
    
    typesig { [] }
    # Create a new instance of the receiver that is hooked to the current
    # display.
    # 
    # @see org.eclipse.swt.widgets.Display#getCurrent()
    def initialize
      initialize__color_registry(Display.get_current, true)
    end
    
    typesig { [Display] }
    # Create a new instance of the receiver.
    # 
    # @param display the <code>Display</code> to hook into.
    def initialize(display)
      initialize__color_registry(display, true)
    end
    
    typesig { [Display, ::Java::Boolean] }
    # Create a new instance of the receiver.
    # 
    # @param display the <code>Display</code> to hook into
    # @param cleanOnDisplayDisposal
    # whether all fonts allocated by this <code>ColorRegistry</code>
    # should be disposed when the display is disposed
    # @since 3.1
    def initialize(display, clean_on_display_disposal)
      @display = nil
      @stale_colors = nil
      @string_to_color = nil
      @string_to_rgb = nil
      @display_runnable = nil
      @clean_on_display_disposal = false
      super()
      @stale_colors = ArrayList.new
      @string_to_color = HashMap.new(7)
      @string_to_rgb = HashMap.new(7)
      @display_runnable = Class.new(Runnable.class == Class ? Runnable : Object) do
        extend LocalClass
        include_class_members ColorRegistry
        include Runnable if Runnable.class == Module
        
        typesig { [] }
        define_method :run do
          clear_caches
        end
        
        typesig { [] }
        define_method :initialize do
          super()
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
      Assert.is_not_null(display)
      @display = display
      @clean_on_display_disposal = clean_on_display_disposal
      if (clean_on_display_disposal)
        hook_display_dispose
      end
    end
    
    typesig { [RGB] }
    # Create a new <code>Color</code> on the receivers <code>Display</code>.
    # 
    # @param rgb the <code>RGB</code> data for the color.
    # @return the new <code>Color</code> object.
    # 
    # @since 3.1
    def create_color(rgb)
      if ((@display).nil?)
        display = Display.get_current
        if ((display).nil?)
          raise IllegalStateException.new
        end
        @display = display
        if (@clean_on_display_disposal)
          hook_display_dispose
        end
      end
      return Color.new(@display, rgb)
    end
    
    typesig { [Iterator] }
    # Dispose of all of the <code>Color</code>s in this iterator.
    # 
    # @param iterator over <code>Collection</code> of <code>Color</code>
    def dispose_colors(iterator)
      while (iterator.has_next)
        next__ = iterator.next_
        (next__).dispose
      end
    end
    
    typesig { [String] }
    # Returns the <code>color</code> associated with the given symbolic color
    # name, or <code>null</code> if no such definition exists.
    # 
    # @param symbolicName symbolic color name
    # @return the <code>Color</code> or <code>null</code>
    def get(symbolic_name)
      Assert.is_not_null(symbolic_name)
      result = @string_to_color.get(symbolic_name)
      if (!(result).nil?)
        return result
      end
      color = nil
      result = @string_to_rgb.get(symbolic_name)
      if ((result).nil?)
        return nil
      end
      color = create_color(result)
      @string_to_color.put(symbolic_name, color)
      return color
    end
    
    typesig { [] }
    # (non-Javadoc)
    # @see org.eclipse.jface.resource.ResourceRegistry#getKeySet()
    def get_key_set
      return Collections.unmodifiable_set(@string_to_rgb.key_set)
    end
    
    typesig { [String] }
    # Returns the color data associated with the given symbolic color name.
    # 
    # @param symbolicName symbolic color name.
    # @return the <code>RGB</code> data, or <code>null</code> if the symbolic name
    # is not valid.
    def get_rgb(symbolic_name)
      Assert.is_not_null(symbolic_name)
      return @string_to_rgb.get(symbolic_name)
    end
    
    typesig { [String] }
    # Returns the color descriptor associated with the given symbolic color
    # name. As of 3.4 if this color is not defined then an unspecified color
    # is returned. Users that wish to ensure a reasonable default value should
    # use {@link #getColorDescriptor(String, ColorDescriptor)} instead.
    # 
    # @since 3.1
    # 
    # @param symbolicName
    # @return the color descriptor associated with the given symbolic color
    # name or an unspecified sentinel.
    def get_color_descriptor(symbolic_name)
      return get_color_descriptor(symbolic_name, DEFAULT_COLOR)
    end
    
    typesig { [String, ColorDescriptor] }
    # Returns the color descriptor associated with the given symbolic color
    # name. If this name does not exist within the registry the supplied
    # default value will be used.
    # 
    # @param symbolicName
    # @param defaultValue
    # @return the color descriptor associated with the given symbolic color
    # name or the default
    # @since 3.4
    def get_color_descriptor(symbolic_name, default_value)
      rgb = get_rgb(symbolic_name)
      if ((rgb).nil?)
        return default_value
      end
      return ColorDescriptor.create_from(rgb)
    end
    
    typesig { [] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.resource.ResourceRegistry#clearCaches()
    def clear_caches
      dispose_colors(@string_to_color.values.iterator)
      dispose_colors(@stale_colors.iterator)
      @string_to_color.clear
      @stale_colors.clear
      @display = nil
    end
    
    typesig { [String] }
    # (non-Javadoc)
    # @see org.eclipse.jface.resource.ResourceRegistry#hasValueFor(java.lang.String)
    def has_value_for(color_key)
      return @string_to_rgb.contains_key(color_key)
    end
    
    typesig { [] }
    # Hook a dispose listener on the SWT display.
    def hook_display_dispose
      @display.dispose_exec(@display_runnable)
    end
    
    typesig { [String, RGB] }
    # Adds (or replaces) a color to this color registry under the given
    # symbolic name.
    # <p>
    # A property change event is reported whenever the mapping from a symbolic
    # name to a color changes. The source of the event is this registry; the
    # property name is the symbolic color name.
    # </p>
    # 
    # @param symbolicName the symbolic color name
    # @param colorData an <code>RGB</code> object
    def put(symbolic_name, color_data)
      put(symbolic_name, color_data, true)
    end
    
    typesig { [String, RGB, ::Java::Boolean] }
    # Adds (or replaces) a color to this color registry under the given
    # symbolic name.
    # <p>
    # A property change event is reported whenever the mapping from a symbolic
    # name to a color changes. The source of the event is this registry; the
    # property name is the symbolic color name.
    # </p>
    # 
    # @param symbolicName the symbolic color name
    # @param colorData an <code>RGB</code> object
    # @param update - fire a color mapping changed if true. False if this
    # method is called from the get method as no setting has
    # changed.
    def put(symbolic_name, color_data, update)
      Assert.is_not_null(symbolic_name)
      Assert.is_not_null(color_data)
      existing = @string_to_rgb.get(symbolic_name)
      if ((color_data == existing))
        return
      end
      old_color = @string_to_color.remove(symbolic_name)
      @string_to_rgb.put(symbolic_name, color_data)
      if (update)
        fire_mapping_changed(symbolic_name, existing, color_data)
      end
      if (!(old_color).nil?)
        @stale_colors.add(old_color)
      end
    end
    
    private
    alias_method :initialize__color_registry, :initialize
  end
  
end
