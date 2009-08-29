require "rjava"

# Copyright (c) 2000, 2009 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Resource
  module FontRegistryImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Resource
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :Arrays
      include_const ::Java::Util, :Collections
      include_const ::Java::Util, :Enumeration
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :Map
      include_const ::Java::Util, :MissingResourceException
      include_const ::Java::Util, :ResourceBundle
      include_const ::Java::Util, :JavaSet
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Jface::Util, :Policy
      include_const ::Org::Eclipse::Jface::Util, :Util
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt, :SWTException
      include_const ::Org::Eclipse::Swt::Graphics, :Font
      include_const ::Org::Eclipse::Swt::Graphics, :FontData
      include_const ::Org::Eclipse::Swt::Widgets, :Display
    }
  end
  
  # A font registry maintains a mapping between symbolic font names
  # and SWT fonts.
  # <p>
  # A font registry owns all of the font objects registered
  # with it, and automatically disposes of them when the SWT Display
  # that creates the fonts is disposed. Because of this, clients do
  # not need to (indeed, must not attempt to) dispose of font
  # objects themselves.
  # </p>
  # <p>
  # A special constructor is provided for populating a font registry
  # from a property files using the standard Java resource bundle mechanism.
  # </p>
  # <p>
  # Methods are provided for registering listeners that will be kept
  # apprised of changes to list of registered fonts.
  # </p>
  # <p>
  # Clients may instantiate this class (it was not designed to be subclassed).
  # </p>
  # 
  # Since 3.0 this class extends ResourceRegistry.
  # @noextend This class is not intended to be subclassed by clients.
  class FontRegistry < FontRegistryImports.const_get :ResourceRegistry
    include_class_members FontRegistryImports
    
    class_module.module_eval {
      # FontRecord is a private helper class that holds onto a font
      # and can be used to generate its bold and italic version.
      const_set_lazy(:FontRecord) { Class.new do
        extend LocalClass
        include_class_members FontRegistry
        
        attr_accessor :base_font
        alias_method :attr_base_font, :base_font
        undef_method :base_font
        alias_method :attr_base_font=, :base_font=
        undef_method :base_font=
        
        attr_accessor :bold_font
        alias_method :attr_bold_font, :bold_font
        undef_method :bold_font
        alias_method :attr_bold_font=, :bold_font=
        undef_method :bold_font=
        
        attr_accessor :italic_font
        alias_method :attr_italic_font, :italic_font
        undef_method :italic_font
        alias_method :attr_italic_font=, :italic_font=
        undef_method :italic_font=
        
        attr_accessor :base_data
        alias_method :attr_base_data, :base_data
        undef_method :base_data
        alias_method :attr_base_data=, :base_data=
        undef_method :base_data=
        
        typesig { [class_self::Font, Array.typed(class_self::FontData)] }
        # Create a new instance of the receiver based on the
        # plain font and the data for it.
        # @param plainFont The base looked up font.
        # @param data The data used to look it up.
        def initialize(plain_font, data)
          @base_font = nil
          @bold_font = nil
          @italic_font = nil
          @base_data = nil
          @base_font = plain_font
          @base_data = data
        end
        
        typesig { [] }
        # Dispose any of the fonts created for this record.
        def dispose
          @base_font.dispose
          if (!(@bold_font).nil?)
            @bold_font.dispose
          end
          if (!(@italic_font).nil?)
            @italic_font.dispose
          end
        end
        
        typesig { [] }
        # Return the base Font.
        # @return Font
        def get_base_font
          return @base_font
        end
        
        typesig { [] }
        # Return the bold Font. Create a bold version
        # of the base font to get it.
        # @return Font
        def get_bold_font
          if (!(@bold_font).nil?)
            return @bold_font
          end
          bold_data = get_modified_font_data(SWT::BOLD)
          @bold_font = self.class::Font.new(Display.get_current, bold_data)
          return @bold_font
        end
        
        typesig { [::Java::Int] }
        # Get a version of the base font data with the specified
        # style.
        # @param style the new style
        # @return the font data with the style {@link FontData#FontData(String, int, int)}
        # @see SWT#ITALIC
        # @see SWT#NORMAL
        # @see SWT#BOLD
        # @todo Generated comment
        def get_modified_font_data(style)
          style_data = Array.typed(self.class::FontData).new(@base_data.attr_length) { nil }
          i = 0
          while i < style_data.attr_length
            base = @base_data[i]
            style_data[i] = self.class::FontData.new(base.get_name, base.get_height, base.get_style | style)
            i += 1
          end
          return style_data
        end
        
        typesig { [] }
        # Return the italic Font. Create an italic version of the
        # base font to get it.
        # @return Font
        def get_italic_font
          if (!(@italic_font).nil?)
            return @italic_font
          end
          italic_data = get_modified_font_data(SWT::ITALIC)
          @italic_font = self.class::Font.new(Display.get_current, italic_data)
          return @italic_font
        end
        
        typesig { [class_self::Font] }
        # Add any fonts that were allocated for this record to the
        # stale fonts. Anything that matches the default font will
        # be skipped.
        # @param defaultFont The system default.
        def add_allocated_fonts_to_stale(default_font)
          # Return all of the fonts allocated by the receiver.
          # if any of them are the defaultFont then don't bother.
          if (!(default_font).equal?(@base_font) && !(@base_font).nil?)
            self.attr_stale_fonts.add(@base_font)
          end
          if (!(default_font).equal?(@bold_font) && !(@bold_font).nil?)
            self.attr_stale_fonts.add(@bold_font)
          end
          if (!(default_font).equal?(@italic_font) && !(@italic_font).nil?)
            self.attr_stale_fonts.add(@italic_font)
          end
        end
        
        private
        alias_method :initialize__font_record, :initialize
      end }
    }
    
    # Table of known fonts, keyed by symbolic font name
    # (key type: <code>String</code>,
    # value type: <code>FontRecord</code>.
    attr_accessor :string_to_font_record
    alias_method :attr_string_to_font_record, :string_to_font_record
    undef_method :string_to_font_record
    alias_method :attr_string_to_font_record=, :string_to_font_record=
    undef_method :string_to_font_record=
    
    # Table of known font data, keyed by symbolic font name
    # (key type: <code>String</code>,
    # value type: <code>org.eclipse.swt.graphics.FontData[]</code>).
    attr_accessor :string_to_font_data
    alias_method :attr_string_to_font_data, :string_to_font_data
    undef_method :string_to_font_data
    alias_method :attr_string_to_font_data=, :string_to_font_data=
    undef_method :string_to_font_data=
    
    # Collection of Fonts that are now stale to be disposed
    # when it is safe to do so (i.e. on shutdown).
    # @see List
    attr_accessor :stale_fonts
    alias_method :attr_stale_fonts, :stale_fonts
    undef_method :stale_fonts
    alias_method :attr_stale_fonts=, :stale_fonts=
    undef_method :stale_fonts=
    
    # Runnable that cleans up the manager on disposal of the display.
    attr_accessor :display_runnable
    alias_method :attr_display_runnable, :display_runnable
    undef_method :display_runnable
    alias_method :attr_display_runnable=, :display_runnable=
    undef_method :display_runnable=
    
    attr_accessor :display_dispose_hooked
    alias_method :attr_display_dispose_hooked, :display_dispose_hooked
    undef_method :display_dispose_hooked
    alias_method :attr_display_dispose_hooked=, :display_dispose_hooked=
    undef_method :display_dispose_hooked=
    
    attr_accessor :clean_on_display_disposal
    alias_method :attr_clean_on_display_disposal, :clean_on_display_disposal
    undef_method :clean_on_display_disposal
    alias_method :attr_clean_on_display_disposal=, :clean_on_display_disposal=
    undef_method :clean_on_display_disposal=
    
    typesig { [] }
    # Creates an empty font registry.
    # <p>
    # There must be an SWT Display created in the current
    # thread before calling this method.
    # </p>
    def initialize
      initialize__font_registry(Display.get_current, true)
    end
    
    typesig { [String, ClassLoader] }
    # Creates a font registry and initializes its content from
    # a property file.
    # <p>
    # There must be an SWT Display created in the current
    # thread before calling this method.
    # </p>
    # <p>
    # The OS name (retrieved using <code>System.getProperty("os.name")</code>)
    # is converted to lowercase, purged of whitespace, and appended
    # as suffix (separated by an underscore <code>'_'</code>) to the given
    # location string to yield the base name of a resource bundle
    # acceptable to <code>ResourceBundle.getBundle</code>.
    # The standard Java resource bundle mechanism is then used to locate
    # and open the appropriate properties file, taking into account
    # locale specific variations.
    # </p>
    # <p>
    # For example, on the Windows 2000 operating system the location string
    # <code>"com.example.myapp.Fonts"</code> yields the base name
    # <code>"com.example.myapp.Fonts_windows2000"</code>. For the US English locale,
    # this further elaborates to the resource bundle name
    # <code>"com.example.myapp.Fonts_windows2000_en_us"</code>.
    # </p>
    # <p>
    # If no appropriate OS-specific resource bundle is found, the
    # process is repeated using the location as the base bundle name.
    # </p>
    # <p>
    # The property file contains entries that look like this:
    # <pre>
    # textfont.0=MS Sans Serif-regular-10
    # textfont.1=Times New Roman-regular-10
    # 
    # titlefont.0=MS Sans Serif-regular-12
    # titlefont.1=Times New Roman-regular-12
    # </pre>
    # Each entry maps a symbolic font names (the font registry keys) with
    # a "<code>.<it>n</it></code> suffix to standard font names
    # on the right. The suffix indicated order of preference:
    # "<code>.0</code>" indicates the first choice,
    # "<code>.1</code>" indicates the second choice, and so on.
    # </p>
    # The following example shows how to use the font registry:
    # <pre>
    # FontRegistry registry = new FontRegistry("com.example.myapp.fonts");
    # Font font = registry.get("textfont");
    # control.setFont(font);
    # ...
    # </pre>
    # 
    # @param location the name of the resource bundle
    # @param loader the ClassLoader to use to find the resource bundle
    # @exception MissingResourceException if the resource bundle cannot be found
    # @since 2.1
    def initialize(location, loader)
      @string_to_font_record = nil
      @string_to_font_data = nil
      @stale_fonts = nil
      @display_runnable = nil
      @display_dispose_hooked = false
      @clean_on_display_disposal = false
      super()
      @string_to_font_record = HashMap.new(7)
      @string_to_font_data = HashMap.new(7)
      @stale_fonts = ArrayList.new
      @display_runnable = Class.new(Runnable.class == Class ? Runnable : Object) do
        extend LocalClass
        include_class_members FontRegistry
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
      display = Display.get_current
      Assert.is_not_null(display)
      # FIXE: need to respect loader
      # readResourceBundle(location, loader);
      read_resource_bundle(location)
      @clean_on_display_disposal = true
      hook_display_dispose(display)
    end
    
    typesig { [String] }
    # Load the FontRegistry using the ClassLoader from the PlatformUI
    # plug-in
    # <p>
    # This method should only be called from the UI thread. If you are not on the UI
    # thread then wrap the call with a
    # <code>PlatformUI.getWorkbench().getDisplay().synchExec()</code> in order to
    # guarantee the correct result. Failure to do this may result in an {@link
    # SWTException} being thrown.
    # </p>
    # @param location the location to read the resource bundle from
    # @throws MissingResourceException Thrown if a resource is missing
    def initialize(location)
      # FIXE:
      # this(location, WorkbenchPlugin.getDefault().getDescriptor().getPluginClassLoader());
      initialize__font_registry(location, nil)
    end
    
    typesig { [String] }
    # Read the resource bundle at location. Look for a file with the
    # extension _os_ws first, then _os then just the name.
    # @param location - String - the location of the file.
    def read_resource_bundle(location)
      osname = System.get_property("os.name").trim # $NON-NLS-1$
      wsname = Util.get_ws
      osname = RJava.cast_to_string(StringConverter.remove_white_spaces(osname).to_lower_case)
      wsname = RJava.cast_to_string(StringConverter.remove_white_spaces(wsname).to_lower_case)
      oslocation = location
      wslocation = location
      bundle = nil
      if (!(osname).nil?)
        oslocation = location + "_" + osname # $NON-NLS-1$
        if (!(wsname).nil?)
          wslocation = oslocation + "_" + wsname # $NON-NLS-1$
        end
      end
      begin
        bundle = ResourceBundle.get_bundle(wslocation)
        read_resource_bundle(bundle, wslocation)
      rescue MissingResourceException => ws_exception
        begin
          bundle = ResourceBundle.get_bundle(oslocation)
          read_resource_bundle(bundle, wslocation)
        rescue MissingResourceException => os_exception
          if (!(location).equal?(oslocation))
            bundle = ResourceBundle.get_bundle(location)
            read_resource_bundle(bundle, wslocation)
          else
            raise os_exception
          end
        end
      end
    end
    
    typesig { [Display] }
    # Creates an empty font registry.
    # 
    # @param display the Display
    def initialize(display)
      initialize__font_registry(display, true)
    end
    
    typesig { [Display, ::Java::Boolean] }
    # Creates an empty font registry.
    # 
    # @param display
    # the <code>Display</code>
    # @param cleanOnDisplayDisposal
    # whether all fonts allocated by this <code>FontRegistry</code>
    # should be disposed when the display is disposed
    # @since 3.1
    def initialize(display, clean_on_display_disposal)
      @string_to_font_record = nil
      @string_to_font_data = nil
      @stale_fonts = nil
      @display_runnable = nil
      @display_dispose_hooked = false
      @clean_on_display_disposal = false
      super()
      @string_to_font_record = HashMap.new(7)
      @string_to_font_data = HashMap.new(7)
      @stale_fonts = ArrayList.new
      @display_runnable = Class.new(Runnable.class == Class ? Runnable : Object) do
        extend LocalClass
        include_class_members FontRegistry
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
      @clean_on_display_disposal = clean_on_display_disposal
      if (clean_on_display_disposal)
        hook_display_dispose(display)
      end
    end
    
    typesig { [Array.typed(FontData), Display] }
    # Find the first valid fontData in the provided list. If none are valid
    # return the first one regardless. If the list is empty return null. Return
    # <code>null</code> if one cannot be found.
    # 
    # @param fonts the font list
    # @param display the display used
    # @return the font data of the like describe above
    # 
    # @deprecated use bestDataArray in order to support Motif multiple entry
    # fonts.
    def best_data(fonts, display)
      i = 0
      while i < fonts.attr_length
        fd = fonts[i]
        if ((fd).nil?)
          break
        end
        fixed_fonts = display.get_font_list(fd.get_name, false)
        if (is_fixed_font(fixed_fonts, fd))
          return fd
        end
        scalable_fonts = display.get_font_list(fd.get_name, true)
        if (scalable_fonts.attr_length > 0)
          return fd
        end
        i += 1
      end
      # None of the provided datas are valid. Return the
      # first one as it is at least the first choice.
      if (fonts.attr_length > 0)
        return fonts[0]
      end
      # Nothing specified
      return nil
    end
    
    typesig { [Array.typed(FontData), Display] }
    # Find the first valid fontData in the provided list.
    # If none are valid return the first one regardless.
    # If the list is empty return <code>null</code>.
    # 
    # @param fonts list of fonts
    # @param display the display
    # @return font data like described above
    # @deprecated use filterData in order to preserve
    # multiple entry fonts on Motif
    def best_data_array(fonts, display)
      best_data_ = best_data(fonts, display)
      if ((best_data_).nil?)
        return nil
      end
      datas = Array.typed(FontData).new(1) { nil }
      datas[0] = best_data_
      return datas
    end
    
    typesig { [Array.typed(FontData), Display] }
    # Removes from the list all fonts that do not exist in this system.
    # If none are valid, return the first irregardless.  If the list is
    # empty return <code>null</code>.
    # 
    # @param fonts the fonts to check
    # @param display the display to check against
    # @return the list of fonts that have been found on this system
    # @since 3.1
    def filter_data(fonts, display)
      good = ArrayList.new(fonts.attr_length)
      i = 0
      while i < fonts.attr_length
        fd = fonts[i]
        if ((fd).nil?)
          i += 1
          next
        end
        fixed_fonts = display.get_font_list(fd.get_name, false)
        if (is_fixed_font(fixed_fonts, fd))
          good.add(fd)
        end
        scalable_fonts = display.get_font_list(fd.get_name, true)
        if (scalable_fonts.attr_length > 0)
          good.add(fd)
        end
        i += 1
      end
      # None of the provided datas are valid. Return the
      # first one as it is at least the first choice.
      if (good.is_empty && fonts.attr_length > 0)
        good.add(fonts[0])
      else
        if ((fonts.attr_length).equal?(0))
          return nil
        end
      end
      return good.to_array(Array.typed(FontData).new(good.size) { nil })
    end
    
    typesig { [String, Array.typed(FontData)] }
    # Creates a new font with the given font datas or <code>null</code>
    # if there is no data.
    # @return FontRecord for the new Font or <code>null</code>.
    def create_font(symbolic_name, fonts)
      display = Display.get_current
      if ((display).nil?)
        return nil
      end
      if (@clean_on_display_disposal && !@display_dispose_hooked)
        hook_display_dispose(display)
      end
      valid_data = filter_data(fonts, display)
      if ((valid_data.attr_length).equal?(0))
        # Nothing specified
        return nil
      end
      # Do not fire the update from creation as it is not a property change
      put(symbolic_name, valid_data, false)
      new_font = Font.new(display, valid_data)
      return FontRecord.new_local(self, new_font, valid_data)
    end
    
    typesig { [] }
    # Calculates the default font and returns the result.
    # This method creates a font that must be disposed.
    def calculate_default_font
      current = Display.get_current
      if ((current).nil?)
        # can't do much without Display
        SWT.error(SWT::ERROR_THREAD_INVALID_ACCESS)
      end
      return Font.new(current, current.get_system_font.get_font_data)
    end
    
    typesig { [] }
    # Returns the default font data.  Creates it if necessary.
    # <p>
    # This method should only be called from the UI thread. If you are not on the UI
    # thread then wrap the call with a
    # <code>PlatformUI.getWorkbench().getDisplay().synchExec()</code> in order to
    # guarantee the correct result. Failure to do this may result in an {@link
    # SWTException} being thrown.
    # </p>
    # @return Font
    def default_font
      return default_font_record.get_base_font
    end
    
    typesig { [String] }
    # Returns the font descriptor for the font with the given symbolic
    # font name. Returns the default font if there is no special value
    # associated with that name
    # 
    # @param symbolicName symbolic font name
    # @return the font descriptor (never null)
    # 
    # @since 3.3
    def get_descriptor(symbolic_name)
      Assert.is_not_null(symbolic_name)
      return FontDescriptor.create_from(get_font_data(symbolic_name))
    end
    
    typesig { [] }
    # Returns the default font record.
    def default_font_record
      record = @string_to_font_record.get(JFaceResources::DEFAULT_FONT)
      if ((record).nil?)
        default_font = calculate_default_font
        record = create_font(JFaceResources::DEFAULT_FONT, default_font.get_font_data)
        default_font.dispose
        @string_to_font_record.put(JFaceResources::DEFAULT_FONT, record)
      end
      return record
    end
    
    typesig { [] }
    # Returns the default font data.  Creates it if necessary.
    def default_font_data
      return default_font_record.attr_base_data
    end
    
    typesig { [String] }
    # Returns the font data associated with the given symbolic font name.
    # Returns the default font data if there is no special value associated
    # with that name.
    # 
    # @param symbolicName symbolic font name
    # @return the font
    def get_font_data(symbolic_name)
      Assert.is_not_null(symbolic_name)
      result = @string_to_font_data.get(symbolic_name)
      if ((result).nil?)
        return default_font_data
      end
      return result
    end
    
    typesig { [String] }
    # Returns the font associated with the given symbolic font name.
    # Returns the default font if there is no special value associated
    # with that name.
    # <p>
    # This method should only be called from the UI thread. If you are not on the UI
    # thread then wrap the call with a
    # <code>PlatformUI.getWorkbench().getDisplay().synchExec()</code> in order to
    # guarantee the correct result. Failure to do this may result in an {@link
    # SWTException} being thrown.
    # </p>
    # @param symbolicName symbolic font name
    # @return the font
    def get(symbolic_name)
      return get_font_record(symbolic_name).get_base_font
    end
    
    typesig { [String] }
    # Returns the bold font associated with the given symbolic font name.
    # Returns the bolded default font if there is no special value associated
    # with that name.
    # <p>
    # This method should only be called from the UI thread. If you are not on the UI
    # thread then wrap the call with a
    # <code>PlatformUI.getWorkbench().getDisplay().synchExec()</code> in order to
    # guarantee the correct result. Failure to do this may result in an {@link
    # SWTException} being thrown.
    # </p>
    # @param symbolicName symbolic font name
    # @return the font
    # @since 3.0
    def get_bold(symbolic_name)
      return get_font_record(symbolic_name).get_bold_font
    end
    
    typesig { [String] }
    # Returns the italic font associated with the given symbolic font name.
    # Returns the italic default font if there is no special value associated
    # with that name.
    # <p>
    # This method should only be called from the UI thread. If you are not on the UI
    # thread then wrap the call with a
    # <code>PlatformUI.getWorkbench().getDisplay().synchExec()</code> in order to
    # guarantee the correct result. Failure to do this may result in an {@link
    # SWTException} being thrown.
    # </p>
    # @param symbolicName symbolic font name
    # @return the font
    # @since 3.0
    def get_italic(symbolic_name)
      return get_font_record(symbolic_name).get_italic_font
    end
    
    typesig { [String] }
    # Return the font record for the key.
    # @param symbolicName The key for the record.
    # @return FontRecord
    def get_font_record(symbolic_name)
      Assert.is_not_null(symbolic_name)
      result = @string_to_font_record.get(symbolic_name)
      if (!(result).nil?)
        return result
      end
      result = @string_to_font_data.get(symbolic_name)
      font_record = nil
      if ((result).nil?)
        font_record = default_font_record
      else
        font_record = create_font(symbolic_name, result)
      end
      if ((font_record).nil?)
        font_record = default_font_record
        if ((Display.get_current).nil?)
          # log error but don't throw an exception to preserve existing functionality
          msg = "Unable to create font \"" + symbolic_name + "\" in a non-UI thread. Using default font instead." # $NON-NLS-1$ //$NON-NLS-2$
          Policy.log_exception(SWTException.new(msg))
          return font_record # don't add it to the cache; if later asked from UI thread, a proper font will be created
        end
      end
      @string_to_font_record.put(symbolic_name, font_record)
      return font_record
    end
    
    typesig { [] }
    # (non-Javadoc)
    # @see org.eclipse.jface.resource.ResourceRegistry#getKeySet()
    def get_key_set
      return Collections.unmodifiable_set(@string_to_font_data.key_set)
    end
    
    typesig { [String] }
    # (non-Javadoc)
    # @see org.eclipse.jface.resource.ResourceRegistry#hasValueFor(java.lang.String)
    def has_value_for(font_key)
      return @string_to_font_data.contains_key(font_key)
    end
    
    typesig { [] }
    # (non-Javadoc)
    # @see org.eclipse.jface.resource.ResourceRegistry#clearCaches()
    def clear_caches
      iterator = @string_to_font_record.values.iterator
      while (iterator.has_next)
        next__ = iterator.next_
        (next__).dispose
      end
      dispose_fonts(@stale_fonts.iterator)
      @string_to_font_record.clear
      @stale_fonts.clear
      @display_dispose_hooked = false
    end
    
    typesig { [Iterator] }
    # Dispose of all of the fonts in this iterator.
    # @param iterator over Collection of Font
    def dispose_fonts(iterator_)
      while (iterator_.has_next)
        next__ = iterator_.next_
        (next__).dispose
      end
    end
    
    typesig { [Display] }
    # Hook a dispose listener on the SWT display.
    def hook_display_dispose(display)
      @display_dispose_hooked = true
      display.dispose_exec(@display_runnable)
    end
    
    typesig { [Array.typed(FontData), FontData] }
    # Checks whether the given font is in the list of fixed fonts.
    def is_fixed_font(fixed_fonts, fd)
      # Can't use FontData.equals() since some values aren't
      # set if a fontdata isn't used.
      height = fd.get_height
      name = fd.get_name
      i = 0
      while i < fixed_fonts.attr_length
        fixed = fixed_fonts[i]
        if ((fixed.get_height).equal?(height) && (fixed.get_name == name))
          return true
        end
        i += 1
      end
      return false
    end
    
    typesig { [String] }
    # Converts a String into a FontData object.
    def make_font_data(value)
      begin
        return StringConverter.as_font_data(value.trim)
      rescue DataFormatException => e
        raise MissingResourceException.new("Wrong font data format. Value is: \"" + value + "\"", get_class.get_name, value) # $NON-NLS-2$//$NON-NLS-1$
      end
    end
    
    typesig { [String, Array.typed(FontData)] }
    # Adds (or replaces) a font to this font registry under the given
    # symbolic name.
    # <p>
    # A property change event is reported whenever the mapping from
    # a symbolic name to a font changes. The source of the event is
    # this registry; the property name is the symbolic font name.
    # </p>
    # 
    # @param symbolicName the symbolic font name
    # @param fontData an Array of FontData
    def put(symbolic_name, font_data)
      put(symbolic_name, font_data, true)
    end
    
    typesig { [String, Array.typed(FontData), ::Java::Boolean] }
    # Adds (or replaces) a font to this font registry under the given
    # symbolic name.
    # <p>
    # A property change event is reported whenever the mapping from
    # a symbolic name to a font changes. The source of the event is
    # this registry; the property name is the symbolic font name.
    # </p>
    # 
    # @param symbolicName the symbolic font name
    # @param fontData an Array of FontData
    # @param update - fire a font mapping changed if true. False
    # if this method is called from the get method as no setting
    # has changed.
    def put(symbolic_name, font_data, update)
      Assert.is_not_null(symbolic_name)
      Assert.is_not_null(font_data)
      existing = @string_to_font_data.get(symbolic_name)
      if ((Arrays == existing))
        return
      end
      old_font = @string_to_font_record.remove(symbolic_name)
      @string_to_font_data.put(symbolic_name, font_data)
      if (update)
        fire_mapping_changed(symbolic_name, existing, font_data)
      end
      if (!(old_font).nil?)
        old_font.add_allocated_fonts_to_stale(default_font_record.get_base_font)
      end
    end
    
    typesig { [ResourceBundle, String] }
    # Reads the resource bundle.  This puts FontData[] objects
    # in the mapping table.  These will lazily be turned into
    # real Font objects when requested.
    def read_resource_bundle(bundle, bundle_name)
      keys = bundle.get_keys
      while (keys.has_more_elements)
        key = keys.next_element
        pos = key.last_index_of(Character.new(?..ord))
        if ((pos).equal?(-1))
          @string_to_font_data.put(key, Array.typed(FontData).new([make_font_data(bundle.get_string(key))]))
        else
          name = key.substring(0, pos)
          i = 0
          begin
            i = JavaInteger.parse_int(key.substring(pos + 1))
          rescue NumberFormatException => e
            # Panic the file can not be parsed.
            raise MissingResourceException.new("Wrong key format ", bundle_name, key) # $NON-NLS-1$
          end
          elements = @string_to_font_data.get(name)
          if ((elements).nil?)
            elements = Array.typed(FontData).new(8) { nil }
            @string_to_font_data.put(name, elements)
          end
          if (i > elements.attr_length)
            na = Array.typed(FontData).new(i + 8) { nil }
            System.arraycopy(elements, 0, na, 0, elements.attr_length)
            elements = na
            @string_to_font_data.put(name, elements)
          end
          elements[i] = make_font_data(bundle.get_string(key))
        end
      end
    end
    
    typesig { [] }
    # Returns the font descriptor for the JFace default font.
    # 
    # @return the font descriptor for the JFace default font
    # @since 3.3
    def default_font_descriptor
      return FontDescriptor.create_from(default_font_data)
    end
    
    private
    alias_method :initialize__font_registry, :initialize
  end
  
end
