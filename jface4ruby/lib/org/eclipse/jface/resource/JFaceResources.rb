require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Resource
  module JFaceResourcesImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Resource
      include_const ::Java::Net, :URL
      include_const ::Java::Text, :MessageFormat
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :Map
      include_const ::Java::Util, :MissingResourceException
      include_const ::Java::Util, :ResourceBundle
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Core::Runtime, :FileLocator
      include_const ::Org::Eclipse::Core::Runtime, :Path
      include_const ::Org::Eclipse::Jface::Dialogs, :Dialog
      include_const ::Org::Eclipse::Jface::Dialogs, :PopupDialog
      include_const ::Org::Eclipse::Jface::Dialogs, :TitleAreaDialog
      include_const ::Org::Eclipse::Jface::Internal, :JFaceActivator
      include_const ::Org::Eclipse::Jface::Preference, :PreferenceDialog
      include_const ::Org::Eclipse::Jface::Wizard, :Wizard
      include_const ::Org::Eclipse::Swt::Graphics, :Font
      include_const ::Org::Eclipse::Swt::Graphics, :Image
      include_const ::Org::Eclipse::Swt::Widgets, :Display
      include_const ::Org::Osgi::Framework, :Bundle
    }
  end
  
  # Utility methods to access JFace-specific resources.
  # <p>
  # All methods declared on this class are static. This class cannot be
  # instantiated.
  # </p>
  # <p>
  # The following global state is also maintained by this class:
  # <ul>
  # <li>a font registry</li>
  # <li>a color registry</li>
  # <li>an image registry</li>
  # <li>a resource bundle</li>
  # </ul>
  # </p>
  # @noinstantiate This class is not intended to be instantiated by clients.
  # @noextend This class is not intended to be subclassed by clients.
  class JFaceResources 
    include_class_members JFaceResourcesImports
    
    class_module.module_eval {
      # The path to the icons in the resources.
      const_set_lazy(:ICONS_PATH) { "$nl$/icons/full/" }
      const_attr_reader  :ICONS_PATH
      
      # $NON-NLS-1$
      # 
      # Map of Display onto DeviceResourceManager. Holds all the resources for
      # the associated display.
      const_set_lazy(:Registries) { HashMap.new }
      const_attr_reader  :Registries
      
      # The symbolic font name for the banner font (value
      # <code>"org.eclipse.jface.bannerfont"</code>).
      const_set_lazy(:BANNER_FONT) { "org.eclipse.jface.bannerfont" }
      const_attr_reader  :BANNER_FONT
      
      # $NON-NLS-1$
      # 
      # The JFace resource bundle; eagerly initialized.
      const_set_lazy(:Bundle) { ResourceBundle.get_bundle("org.eclipse.jface.messages") }
      const_attr_reader  :Bundle
      
      # $NON-NLS-1$
      # 
      # The JFace color registry; <code>null</code> until lazily initialized or
      # explicitly set.
      
      def color_registry
        defined?(@@color_registry) ? @@color_registry : @@color_registry= nil
      end
      alias_method :attr_color_registry, :color_registry
      
      def color_registry=(value)
        @@color_registry = value
      end
      alias_method :attr_color_registry=, :color_registry=
      
      # The symbolic font name for the standard font (value
      # <code>"org.eclipse.jface.defaultfont"</code>).
      const_set_lazy(:DEFAULT_FONT) { "org.eclipse.jface.defaultfont" }
      const_attr_reader  :DEFAULT_FONT
      
      # $NON-NLS-1$
      # 
      # The symbolic font name for the dialog font (value
      # <code>"org.eclipse.jface.dialogfont"</code>).
      const_set_lazy(:DIALOG_FONT) { "org.eclipse.jface.dialogfont" }
      const_attr_reader  :DIALOG_FONT
      
      # $NON-NLS-1$
      # 
      # The JFace font registry; <code>null</code> until lazily initialized or
      # explicitly set.
      
      def font_registry
        defined?(@@font_registry) ? @@font_registry : @@font_registry= nil
      end
      alias_method :attr_font_registry, :font_registry
      
      def font_registry=(value)
        @@font_registry = value
      end
      alias_method :attr_font_registry=, :font_registry=
      
      # The symbolic font name for the header font (value
      # <code>"org.eclipse.jface.headerfont"</code>).
      const_set_lazy(:HEADER_FONT) { "org.eclipse.jface.headerfont" }
      const_attr_reader  :HEADER_FONT
      
      # $NON-NLS-1$
      # 
      # The JFace image registry; <code>null</code> until lazily initialized.
      
      def image_registry
        defined?(@@image_registry) ? @@image_registry : @@image_registry= nil
      end
      alias_method :attr_image_registry, :image_registry
      
      def image_registry=(value)
        @@image_registry = value
      end
      alias_method :attr_image_registry=, :image_registry=
      
      # The symbolic font name for the text font (value
      # <code>"org.eclipse.jface.textfont"</code>).
      const_set_lazy(:TEXT_FONT) { "org.eclipse.jface.textfont" }
      const_attr_reader  :TEXT_FONT
      
      # $NON-NLS-1$
      # 
      # The symbolic font name for the viewer font (value
      # <code>"org.eclipse.jface.viewerfont"</code>).
      # 
      # @deprecated This font is not in use
      const_set_lazy(:VIEWER_FONT) { "org.eclipse.jface.viewerfont" }
      const_attr_reader  :VIEWER_FONT
      
      # $NON-NLS-1$
      # 
      # The symbolic font name for the window font (value
      # <code>"org.eclipse.jface.windowfont"</code>).
      # 
      # @deprecated This font is not in use
      const_set_lazy(:WINDOW_FONT) { "org.eclipse.jface.windowfont" }
      const_attr_reader  :WINDOW_FONT
      
      typesig { [String, Array.typed(Object)] }
      # $NON-NLS-1$
      # 
      # Returns the formatted message for the given key in JFace's resource
      # bundle.
      # 
      # @param key
      # the resource name
      # @param args
      # the message arguments
      # @return the string
      def format(key, args)
        return MessageFormat.format(get_string(key), args)
      end
      
      typesig { [] }
      # Returns the JFace's banner font. Convenience method equivalent to
      # 
      # <pre>
      # JFaceResources.getFontRegistry().get(JFaceResources.BANNER_FONT)
      # </pre>
      # 
      # @return the font
      def get_banner_font
        return get_font_registry.get(BANNER_FONT)
      end
      
      typesig { [] }
      # Returns the resource bundle for JFace itself. The resouble bundle is
      # obtained from
      # <code>ResourceBundle.getBundle("org.eclipse.jface.jface_nls")</code>.
      # <p>
      # Note that several static convenience methods are also provided on this
      # class for directly accessing resources in this bundle.
      # </p>
      # 
      # @return the resource bundle
      def get_bundle
        return Bundle
      end
      
      typesig { [] }
      # Returns the color registry for JFace itself.
      # <p>
      # 
      # @return the <code>ColorRegistry</code>.
      # @since 3.0
      def get_color_registry
        if ((self.attr_color_registry).nil?)
          self.attr_color_registry = ColorRegistry.new
          initialize_default_colors
        end
        return self.attr_color_registry
      end
      
      typesig { [Display] }
      # Returns the global resource manager for the given display
      # 
      # @since 3.1
      # 
      # @param toQuery
      # display to query
      # @return the global resource manager for the given display
      def get_resources(to_query)
        reg = Registries.get(to_query)
        if ((reg).nil?)
          mgr = DeviceResourceManager.new(to_query)
          reg = mgr
          Registries.put(to_query, reg)
          to_query.dispose_exec(Class.new(Runnable.class == Class ? Runnable : Object) do
            extend LocalClass
            include_class_members JFaceResources
            include Runnable if Runnable.class == Module
            
            typesig { [] }
            # (non-Javadoc)
            # 
            # @see java.lang.Runnable#run()
            define_method :run do
              mgr.dispose
              Registries.remove(to_query)
            end
            
            typesig { [Vararg.new(Object)] }
            define_method :initialize do |*args|
              super(*args)
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
        end
        return reg
      end
      
      typesig { [] }
      # Returns the ResourceManager for the current display. May only be called
      # from a UI thread.
      # 
      # @since 3.1
      # 
      # @return the global ResourceManager for the current display
      def get_resources
        return get_resources(Display.get_current)
      end
      
      typesig { [] }
      # Returns JFace's standard font. Convenience method equivalent to
      # 
      # <pre>
      # JFaceResources.getFontRegistry().get(JFaceResources.DEFAULT_FONT)
      # </pre>
      # 
      # @return the font
      def get_default_font
        return get_font_registry.default_font
      end
      
      typesig { [] }
      # Returns the descriptor for JFace's standard font. Convenience method
      # equivalent to
      # 
      # <pre>
      # JFaceResources.getFontRegistry().getDescriptor(JFaceResources.DEFAULT_FONT)
      # </pre>
      # 
      # @return the font
      # @since 3.3
      def get_default_font_descriptor
        return get_font_registry.default_font_descriptor
      end
      
      typesig { [] }
      # Returns the JFace's dialog font. Convenience method equivalent to
      # 
      # <pre>
      # JFaceResources.getFontRegistry().get(JFaceResources.DIALOG_FONT)
      # </pre>
      # 
      # @return the font
      def get_dialog_font
        return get_font_registry.get(DIALOG_FONT)
      end
      
      typesig { [] }
      # Returns the descriptor for JFace's dialog font. Convenience method
      # equivalent to
      # 
      # <pre>
      # JFaceResources.getFontRegistry().getDescriptor(JFaceResources.DIALOG_FONT)
      # </pre>
      # 
      # @return the font
      # @since 3.3
      def get_dialog_font_descriptor
        return get_font_registry.get_descriptor(DIALOG_FONT)
      end
      
      typesig { [String] }
      # Returns the font in JFace's font registry with the given symbolic font
      # name. Convenience method equivalent to
      # 
      # <pre>
      # JFaceResources.getFontRegistry().get(symbolicName)
      # </pre>
      # 
      # If an error occurs, return the default font.
      # 
      # @param symbolicName
      # the symbolic font name
      # @return the font
      def get_font(symbolic_name)
        return get_font_registry.get(symbolic_name)
      end
      
      typesig { [String] }
      # Returns the font descriptor for in JFace's font registry with the given
      # symbolic name. Convenience method equivalent to
      # 
      # <pre>
      # JFaceResources.getFontRegistry().getDescriptor(symbolicName)
      # </pre>
      # 
      # If an error occurs, return the default font.
      # 
      # @param symbolicName
      # the symbolic font name
      # @return the font descriptor (never null)
      # @since 3.3
      def get_font_descriptor(symbolic_name)
        return get_font_registry.get_descriptor(symbolic_name)
      end
      
      typesig { [] }
      # Returns the font registry for JFace itself. If the value has not been
      # established by an earlier call to <code>setFontRegistry</code>, is it
      # initialized to
      # <code>new FontRegistry("org.eclipse.jface.resource.jfacefonts")</code>.
      # <p>
      # Note that several static convenience methods are also provided on this
      # class for directly accessing JFace's standard fonts.
      # </p>
      # 
      # @return the JFace font registry
      def get_font_registry
        if ((self.attr_font_registry).nil?)
          self.attr_font_registry = FontRegistry.new("org.eclipse.jface.resource.jfacefonts") # $NON-NLS-1$
        end
        return self.attr_font_registry
      end
      
      typesig { [] }
      # Returns the JFace's header font. Convenience method equivalent to
      # 
      # <pre>
      # JFaceResources.getFontRegistry().get(JFaceResources.HEADER_FONT)
      # </pre>
      # 
      # @return the font
      def get_header_font
        return get_font_registry.get(HEADER_FONT)
      end
      
      typesig { [] }
      # Returns the descriptor for JFace's header font. Convenience method
      # equivalent to
      # 
      # <pre>
      # JFaceResources.getFontRegistry().get(JFaceResources.HEADER_FONT)
      # </pre>
      # 
      # @return the font descriptor (never null)
      # @since 3.3
      def get_header_font_descriptor
        return get_font_registry.get_descriptor(HEADER_FONT)
      end
      
      typesig { [String] }
      # Returns the image in JFace's image registry with the given key, or
      # <code>null</code> if none. Convenience method equivalent to
      # 
      # <pre>
      # JFaceResources.getImageRegistry().get(key)
      # </pre>
      # 
      # @param key
      # the key
      # @return the image, or <code>null</code> if none
      def get_image(key)
        return get_image_registry.get(key)
      end
      
      typesig { [] }
      # Returns the image registry for JFace itself.
      # <p>
      # Note that the static convenience method <code>getImage</code> is also
      # provided on this class.
      # </p>
      # 
      # @return the JFace image registry
      def get_image_registry
        if ((self.attr_image_registry).nil?)
          self.attr_image_registry = ImageRegistry.new(get_resources(Display.get_current))
          initialize_default_images
        end
        return self.attr_image_registry
      end
      
      typesig { [] }
      # Initialize default images in JFace's image registry.
      def initialize_default_images
        bundle = nil
        begin
          bundle = JFaceActivator.get_bundle
        rescue NoClassDefFoundError => exception
          # Test to see if OSGI is present
        end
        # $NON-NLS-1$
        declare_image(bundle, Wizard::DEFAULT_IMAGE, ICONS_PATH + "page.gif", Wizard, "images/page.gif") # $NON-NLS-1$
        # register default images for dialogs
        declare_image(bundle, Dialog::DLG_IMG_MESSAGE_INFO, ICONS_PATH + "message_info.gif", Dialog, "images/message_info.gif") # $NON-NLS-1$ //$NON-NLS-2$
        # $NON-NLS-1$
        declare_image(bundle, Dialog::DLG_IMG_MESSAGE_WARNING, ICONS_PATH + "message_warning.gif", Dialog, "images/message_warning.gif") # $NON-NLS-1$
        declare_image(bundle, Dialog::DLG_IMG_MESSAGE_ERROR, ICONS_PATH + "message_error.gif", Dialog, "images/message_error.gif") # $NON-NLS-1$ //$NON-NLS-2$
        declare_image(bundle, Dialog::DLG_IMG_HELP, ICONS_PATH + "help.gif", Dialog, "images/help.gif") # $NON-NLS-1$ //$NON-NLS-2$
        declare_image(bundle, TitleAreaDialog::DLG_IMG_TITLE_BANNER, ICONS_PATH + "title_banner.png", TitleAreaDialog, "images/title_banner.gif") # $NON-NLS-1$ //$NON-NLS-2$
        declare_image(bundle, PreferenceDialog::PREF_DLG_TITLE_IMG, ICONS_PATH + "pref_dialog_title.gif", PreferenceDialog, "images/pref_dialog_title.gif") # $NON-NLS-1$ //$NON-NLS-2$
        declare_image(bundle, PopupDialog::POPUP_IMG_MENU, ICONS_PATH + "popup_menu.gif", PopupDialog, "images/popup_menu.gif") # $NON-NLS-1$ //$NON-NLS-2$
        declare_image(bundle, PopupDialog::POPUP_IMG_MENU_DISABLED, ICONS_PATH + "popup_menu_disabled.gif", PopupDialog, "images/popup_menu_disabled.gif") # $NON-NLS-1$ //$NON-NLS-2$
      end
      
      typesig { [Object, String, String, Class, String] }
      # Declares a JFace image given the path of the image file (relative to the
      # JFace plug-in). This is a helper method that creates the image descriptor
      # and passes it to the main <code>declareImage</code> method.
      # 
      # @param bundle
      # the {@link Bundle} or <code>null</code> of the Bundle cannot
      # be found
      # @param key
      # the symbolic name of the image
      # @param path
      # the path of the image file relative to the base of the
      # workbench plug-ins install directory
      # @param fallback
      # the {@link Class} where the fallback implementation of the
      # image is relative to
      # @param fallbackPath
      # the path relative to the fallback {@link Class}
      def declare_image(bundle, key, path, fallback, fallback_path)
        descriptor = nil
        if (!(bundle).nil?)
          url = FileLocator.find(bundle, Path.new(path), nil)
          if (!(url).nil?)
            descriptor = ImageDescriptor.create_from_url(url)
          end
        end
        # If we failed then load from the backup file
        if ((descriptor).nil?)
          descriptor = ImageDescriptor.create_from_file(fallback, fallback_path)
        end
        self.attr_image_registry.put(key, descriptor)
      end
      
      typesig { [String] }
      # Returns the resource object with the given key in JFace's resource
      # bundle. If there isn't any value under the given key, the key is
      # returned.
      # 
      # @param key
      # the resource name
      # @return the string
      def get_string(key)
        begin
          return Bundle.get_string(key)
        rescue MissingResourceException => e
          return key
        end
      end
      
      typesig { [Array.typed(String)] }
      # Returns a list of string values corresponding to the given list of keys.
      # The lookup is done with <code>getString</code>. The values are in the
      # same order as the keys.
      # 
      # @param keys
      # a list of keys
      # @return a list of corresponding string values
      def get_strings(keys)
        Assert.is_not_null(keys)
        length = keys.attr_length
        result = Array.typed(String).new(length) { nil }
        i = 0
        while i < length
          result[i] = get_string(keys[i])
          i += 1
        end
        return result
      end
      
      typesig { [] }
      # Returns JFace's text font. Convenience method equivalent to
      # 
      # <pre>
      # JFaceResources.getFontRegistry().get(JFaceResources.TEXT_FONT)
      # </pre>
      # 
      # @return the font
      def get_text_font
        return get_font_registry.get(TEXT_FONT)
      end
      
      typesig { [] }
      # Returns the descriptor for JFace's text font. Convenience method
      # equivalent to
      # 
      # <pre>
      # JFaceResources.getFontRegistry().getDescriptor(JFaceResources.TEXT_FONT)
      # </pre>
      # 
      # @return the font descriptor (never null)
      # @since 3.3
      def get_text_font_descriptor
        return get_font_registry.get_descriptor(TEXT_FONT)
      end
      
      typesig { [] }
      # Returns JFace's viewer font. Convenience method equivalent to
      # 
      # <pre>
      # JFaceResources.getFontRegistry().get(JFaceResources.VIEWER_FONT)
      # </pre>
      # 
      # @return the font
      # @deprecated This font is not in use
      def get_viewer_font
        return get_font_registry.get(VIEWER_FONT)
      end
      
      typesig { [FontRegistry] }
      # Sets JFace's font registry to the given value. This method may only be
      # called once; the call must occur before
      # <code>JFaceResources.getFontRegistry</code> is invoked (either directly
      # or indirectly).
      # 
      # @param registry
      # a font registry
      def set_font_registry(registry)
        Assert.is_true((self.attr_font_registry).nil?, "Font registry can only be set once.") # $NON-NLS-1$
        self.attr_font_registry = registry
      end
    }
    
    typesig { [] }
    # (non-Javadoc) Declare a private constructor to block instantiation.
    def initialize
      # no-op
    end
    
    class_module.module_eval {
      typesig { [] }
      # Initialize any JFace colors that may not be initialized via a client.
      def initialize_default_colors
        # JFace Colors that may not be defined in a workbench theme should be
        # defined here.
      end
    }
    
    private
    alias_method :initialize__jface_resources, :initialize
  end
  
end
