require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
# Steven Ketcham (sketcham@dsicdi.com) - Bug 42451
# [Dialogs] ImageRegistry throws null pointer exception in
# application with multiple Display's
module Org::Eclipse::Jface::Resource
  module ImageRegistryImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Resource
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :Map
      include_const ::Org::Eclipse::Jface::Dialogs, :Dialog
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Graphics, :Device
      include_const ::Org::Eclipse::Swt::Graphics, :Image
      include_const ::Org::Eclipse::Swt::Graphics, :ImageData
      include_const ::Org::Eclipse::Swt::Widgets, :Display
    }
  end
  
  # An image registry maintains a mapping between symbolic image names
  # and SWT image objects or special image descriptor objects which
  # defer the creation of SWT image objects until they are needed.
  # <p>
  # An image registry owns all of the image objects registered
  # with it, and automatically disposes of them when the SWT Display
  # that creates the images is disposed. Because of this, clients do not
  # need to (indeed, must not attempt to) dispose of these images themselves.
  # </p>
  # <p>
  # Clients may instantiate this class (it was not designed to be subclassed).
  # </p>
  # <p>
  # Unlike the FontRegistry, it is an error to replace images. As a result
  # there are no events that fire when values are changed in the registry
  # </p>
  # @noextend This class is not intended to be subclassed by clients.
  class ImageRegistry 
    include_class_members ImageRegistryImports
    
    # display used when getting images
    attr_accessor :display
    alias_method :attr_display, :display
    undef_method :display
    alias_method :attr_display=, :display=
    undef_method :display=
    
    attr_accessor :manager
    alias_method :attr_manager, :manager
    undef_method :manager
    alias_method :attr_manager=, :manager=
    undef_method :manager=
    
    attr_accessor :table
    alias_method :attr_table, :table
    undef_method :table
    alias_method :attr_table=, :table=
    undef_method :table=
    
    attr_accessor :dispose_runnable
    alias_method :attr_dispose_runnable, :dispose_runnable
    undef_method :dispose_runnable
    alias_method :attr_dispose_runnable=, :dispose_runnable=
    undef_method :dispose_runnable=
    
    class_module.module_eval {
      # Contains the data for an entry in the registry.
      const_set_lazy(:Entry) { Class.new do
        include_class_members ImageRegistry
        
        # the image
        attr_accessor :image
        alias_method :attr_image, :image
        undef_method :image
        alias_method :attr_image=, :image=
        undef_method :image=
        
        # the descriptor
        attr_accessor :descriptor
        alias_method :attr_descriptor, :descriptor
        undef_method :descriptor
        alias_method :attr_descriptor=, :descriptor=
        undef_method :descriptor=
        
        typesig { [] }
        def initialize
          @image = nil
          @descriptor = nil
        end
        
        private
        alias_method :initialize__entry, :initialize
      end }
      
      const_set_lazy(:OriginalImageDescriptor) { Class.new(ImageDescriptor) do
        include_class_members ImageRegistry
        
        attr_accessor :original
        alias_method :attr_original, :original
        undef_method :original
        alias_method :attr_original=, :original=
        undef_method :original=
        
        attr_accessor :ref_count
        alias_method :attr_ref_count, :ref_count
        undef_method :ref_count
        alias_method :attr_ref_count=, :ref_count=
        undef_method :ref_count=
        
        attr_accessor :original_display
        alias_method :attr_original_display, :original_display
        undef_method :original_display
        alias_method :attr_original_display=, :original_display=
        undef_method :original_display=
        
        typesig { [class_self::Image, class_self::Device] }
        # @param original the original image
        # @param originalDisplay the device the image is part of
        def initialize(original, original_display)
          @original = nil
          @ref_count = 0
          @original_display = nil
          super()
          @ref_count = 0
          @original = original
          @original_display = original_display
        end
        
        typesig { [class_self::Device] }
        def create_resource(device)
          if ((device).equal?(@original_display))
            @ref_count += 1
            return @original
          end
          return super(device)
        end
        
        typesig { [Object] }
        def destroy_resource(to_dispose)
          if ((@original).equal?(to_dispose))
            @ref_count -= 1
            if ((@ref_count).equal?(0))
              @original.dispose
              @original = nil
            end
          else
            super(to_dispose)
          end
        end
        
        typesig { [] }
        # (non-Javadoc)
        # @see org.eclipse.jface.resource.ImageDescriptor#getImageData()
        def get_image_data
          return @original.get_image_data
        end
        
        private
        alias_method :initialize__original_image_descriptor, :initialize
      end }
    }
    
    typesig { [] }
    # Creates an empty image registry.
    # <p>
    # There must be an SWT Display created in the current
    # thread before calling this method.
    # </p>
    def initialize
      initialize__image_registry(Display.get_current)
    end
    
    typesig { [ResourceManager] }
    # Creates an empty image registry using the given resource manager to allocate images.
    # 
    # @param manager the resource manager used to allocate images
    # 
    # @since 3.1
    def initialize(manager)
      @display = nil
      @manager = nil
      @table = nil
      @dispose_runnable = Class.new(Runnable.class == Class ? Runnable : Object) do
        extend LocalClass
        include_class_members ImageRegistry
        include Runnable if Runnable.class == Module
        
        typesig { [] }
        define_method :run do
          dispose
        end
        
        typesig { [Object] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
      Assert.is_not_null(manager)
      dev = manager.get_device
      if (dev.is_a?(Display))
        @display = dev
      end
      @manager = manager
      manager.dispose_exec(@dispose_runnable)
    end
    
    typesig { [Display] }
    # Creates an empty image registry.
    # 
    # @param display this <code>Display</code> must not be
    # <code>null</code> and must not be disposed in order
    # to use this registry
    def initialize(display)
      initialize__image_registry(JFaceResources.get_resources(display))
    end
    
    typesig { [String] }
    # Returns the image associated with the given key in this registry,
    # or <code>null</code> if none.
    # 
    # @param key the key
    # @return the image, or <code>null</code> if none
    def get(key)
      # can be null
      if ((key).nil?)
        return nil
      end
      if (!(@display).nil?)
        # NOTE, for backwards compatibility the following images are supported
        # here, they should never be disposed, hence we explicitly return them
        # rather then registering images that SWT will dispose.
        # 
        # Applications should go direclty to SWT for these icons.
        # 
        # @see Display.getSystemIcon(int ID)
        swt_key = -1
        if ((key == Dialog::DLG_IMG_INFO))
          swt_key = SWT::ICON_INFORMATION
        end
        if ((key == Dialog::DLG_IMG_QUESTION))
          swt_key = SWT::ICON_QUESTION
        end
        if ((key == Dialog::DLG_IMG_WARNING))
          swt_key = SWT::ICON_WARNING
        end
        if ((key == Dialog::DLG_IMG_ERROR))
          swt_key = SWT::ICON_ERROR
        end
        # if we actually just want to return an SWT image do so without
        # looking in the registry
        if (!(swt_key).equal?(-1))
          image = Array.typed(Image).new(1) { nil }
          id = swt_key
          @display.sync_exec(Class.new(Runnable.class == Class ? Runnable : Object) do
            extend LocalClass
            include_class_members ImageRegistry
            include Runnable if Runnable.class == Module
            
            typesig { [] }
            define_method :run do
              image[0] = self.attr_display.get_system_image(id)
            end
            
            typesig { [Object] }
            define_method :initialize do |*args|
              super(*args)
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
          return image[0]
        end
      end
      entry = get_entry(key)
      if ((entry).nil?)
        return nil
      end
      if ((entry.attr_image).nil?)
        entry.attr_image = @manager.create_image_with_default(entry.attr_descriptor)
      end
      return entry.attr_image
    end
    
    typesig { [String] }
    # Returns the descriptor associated with the given key in this registry,
    # or <code>null</code> if none.
    # 
    # @param key the key
    # @return the descriptor, or <code>null</code> if none
    # @since 2.1
    def get_descriptor(key)
      entry = get_entry(key)
      if ((entry).nil?)
        return nil
      end
      return entry.attr_descriptor
    end
    
    typesig { [String, ImageDescriptor] }
    # Adds (or replaces) an image descriptor to this registry. The first time
    # this new entry is retrieved, the image descriptor's image will be computed
    # (via </code>ImageDescriptor.createImage</code>) and remembered.
    # This method replaces an existing image descriptor associated with the
    # given key, but fails if there is a real image associated with it.
    # 
    # @param key the key
    # @param descriptor the ImageDescriptor
    # @exception IllegalArgumentException if the key already exists
    def put(key, descriptor)
      entry = get_entry(key)
      if ((entry).nil?)
        entry = Entry.new
        get_table.put(key, entry)
      end
      if (!(entry.attr_image).nil?)
        raise IllegalArgumentException.new("ImageRegistry key already in use: " + key) # $NON-NLS-1$
      end
      entry.attr_descriptor = descriptor
    end
    
    typesig { [String, Image] }
    # Adds an image to this registry.  This method fails if there
    # is already an image or descriptor for the given key.
    # <p>
    # Note that an image registry owns all of the image objects registered
    # with it, and automatically disposes of them when the SWT Display is disposed.
    # Because of this, clients must not register an image object
    # that is managed by another object.
    # </p>
    # 
    # @param key the key
    # @param image the image, should not be <code>null</code>
    # @exception IllegalArgumentException if the key already exists
    def put(key, image)
      entry = get_entry(key)
      if ((entry).nil?)
        entry = Entry.new
        put_entry(key, entry)
      end
      if (!(entry.attr_image).nil? || !(entry.attr_descriptor).nil?)
        raise IllegalArgumentException.new("ImageRegistry key already in use: " + key) # $NON-NLS-1$
      end
      # Check for a null image here, otherwise the problem won't appear
      # until dispose.
      # See https://bugs.eclipse.org/bugs/show_bug.cgi?id=130315
      Assert.is_not_null(image, "Cannot register a null image.") # $NON-NLS-1$
      entry.attr_image = image
      entry.attr_descriptor = OriginalImageDescriptor.new(image, @manager.get_device)
      begin
        @manager.create(entry.attr_descriptor)
      rescue DeviceResourceException => e
      end
    end
    
    typesig { [String] }
    # Removes an image from this registry.
    # If an SWT image was allocated, it is disposed.
    # This method has no effect if there is no image or descriptor for the given key.
    # @param key the key
    def remove(key)
      descriptor = get_descriptor(key)
      if (!(descriptor).nil?)
        @manager.destroy(descriptor)
        get_table.remove(key)
      end
    end
    
    typesig { [String] }
    def get_entry(key)
      return get_table.get(key)
    end
    
    typesig { [String, Entry] }
    def put_entry(key, entry)
      get_table.put(key, entry)
    end
    
    typesig { [] }
    def get_table
      if ((@table).nil?)
        @table = HashMap.new(10)
      end
      return @table
    end
    
    typesig { [] }
    # Disposes this image registry, disposing any images
    # that were allocated for it, and clearing its entries.
    # 
    # @since 3.1
    def dispose
      @manager.cancel_dispose_exec(@dispose_runnable)
      if (!(@table).nil?)
        i = @table.values.iterator
        while i.has_next
          entry = i.next_
          if (!(entry.attr_image).nil?)
            @manager.destroy_image(entry.attr_descriptor)
          end
        end
        @table = nil
      end
      @display = nil
    end
    
    private
    alias_method :initialize__image_registry, :initialize
  end
  
end
