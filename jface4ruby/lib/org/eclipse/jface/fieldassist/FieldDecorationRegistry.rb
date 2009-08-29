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
  module FieldDecorationRegistryImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Fieldassist
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :Iterator
      include_const ::Org::Eclipse::Jface::Resource, :ImageDescriptor
      include_const ::Org::Eclipse::Jface::Resource, :ImageRegistry
      include_const ::Org::Eclipse::Jface::Resource, :JFaceResources
      include_const ::Org::Eclipse::Swt::Graphics, :Image
    }
  end
  
  # FieldDecorationRegistry is a common registry used to define shared field
  # decorations within an application. Unlike resource registries, the
  # FieldDecorationRegistry does not perform any lifecycle management of the
  # decorations.
  # </p>
  # <p>
  # Clients may specify images for the decorations in several different ways.
  # Images may be described by their image id in a specified
  # {@link ImageRegistry}. In this case, the life cycle of the image is managed
  # by the image registry, and the decoration registry will not attempt to obtain
  # an image from the image registry until the decoration is actually requested.
  # In cases where the client has access to an already-created image, the image
  # itself can be specified when registering the decoration. In this case, the
  # life cycle should be managed by the specifying client.
  # </p>
  # 
  # @see FieldDecoration
  # @see ImageRegistry
  # 
  # @since 3.2
  class FieldDecorationRegistry 
    include_class_members FieldDecorationRegistryImports
    
    class_module.module_eval {
      # Decoration id for the decoration that should be used to cue the user that
      # content proposals are available.
      const_set_lazy(:DEC_CONTENT_PROPOSAL) { "DEC_CONTENT_PROPOSAL" }
      const_attr_reader  :DEC_CONTENT_PROPOSAL
      
      # $NON-NLS-1$
      # 
      # Decoration id for the decoration that should be used to cue the user that
      # a field is required.
      const_set_lazy(:DEC_REQUIRED) { "DEC_REQUIRED" }
      const_attr_reader  :DEC_REQUIRED
      
      # $NON-NLS-1$
      # 
      # Decoration id for the decoration that should be used to cue the user that
      # a field has an error.
      const_set_lazy(:DEC_ERROR) { "DEC_ERROR" }
      const_attr_reader  :DEC_ERROR
      
      # $NON-NLS-1$
      # 
      # Decoration id for the decoration that should be used to cue the user that
      # a field has a warning.
      const_set_lazy(:DEC_WARNING) { "DEC_WARNING" }
      const_attr_reader  :DEC_WARNING
      
      # $NON-NLS-1$
      # 
      # Decoration id for the decoration that should be used to cue the user that
      # a field has additional information.
      # 
      # @since 3.3
      const_set_lazy(:DEC_INFORMATION) { "DEC_INFORMATION" }
      const_attr_reader  :DEC_INFORMATION
      
      # $NON-NLS-1$
      # 
      # Decoration id for the decoration that should be used to cue the user that
      # a field has an error with quick fix available.
      # 
      # @since 3.3
      const_set_lazy(:DEC_ERROR_QUICKFIX) { "DEC_ERRORQUICKFIX" }
      const_attr_reader  :DEC_ERROR_QUICKFIX
      
      # $NON-NLS-1$
      # 
      # Image id's
      const_set_lazy(:IMG_DEC_FIELD_CONTENT_PROPOSAL) { "org.eclipse.jface.fieldassist.IMG_DEC_FIELD_CONTENT_PROPOSAL" }
      const_attr_reader  :IMG_DEC_FIELD_CONTENT_PROPOSAL
      
      # $NON-NLS-1$
      const_set_lazy(:IMG_DEC_FIELD_REQUIRED) { "org.eclipse.jface.fieldassist.IMG_DEC_FIELD_REQUIRED" }
      const_attr_reader  :IMG_DEC_FIELD_REQUIRED
      
      # $NON-NLS-1$
      const_set_lazy(:IMG_DEC_FIELD_ERROR) { "org.eclipse.jface.fieldassist.IMG_DEC_FIELD_ERROR" }
      const_attr_reader  :IMG_DEC_FIELD_ERROR
      
      # $NON-NLS-1$
      const_set_lazy(:IMG_DEC_FIELD_ERROR_QUICKFIX) { "org.eclipse.jface.fieldassist.IMG_DEC_FIELD_ERROR_QUICKFIX" }
      const_attr_reader  :IMG_DEC_FIELD_ERROR_QUICKFIX
      
      # $NON-NLS-1$
      const_set_lazy(:IMG_DEC_FIELD_WARNING) { "org.eclipse.jface.fieldassist.IMG_DEC_FIELD_WARNING" }
      const_attr_reader  :IMG_DEC_FIELD_WARNING
      
      # $NON-NLS-1$
      const_set_lazy(:IMG_DEC_FIELD_INFO) { "org.eclipse.jface.fieldassist.IMG_DEC_FIELD_INFO" }
      const_attr_reader  :IMG_DEC_FIELD_INFO
      
      # $NON-NLS-1$
      # 
      # Declare images and decorations immediately.
      when_class_loaded do
        image_registry = JFaceResources.get_image_registry
        # Define the images used in the standard decorations.
        image_registry.put(IMG_DEC_FIELD_CONTENT_PROPOSAL, ImageDescriptor.create_from_file(FieldDecorationRegistry, "images/contassist_ovr.gif")) # $NON-NLS-1$
        image_registry.put(IMG_DEC_FIELD_ERROR, ImageDescriptor.create_from_file(FieldDecorationRegistry, "images/error_ovr.gif")) # $NON-NLS-1$
        image_registry.put(IMG_DEC_FIELD_WARNING, ImageDescriptor.create_from_file(FieldDecorationRegistry, "images/warn_ovr.gif")) # $NON-NLS-1$
        image_registry.put(IMG_DEC_FIELD_REQUIRED, ImageDescriptor.create_from_file(FieldDecorationRegistry, "images/required_field_cue.gif")) # $NON-NLS-1$
        image_registry.put(IMG_DEC_FIELD_ERROR_QUICKFIX, ImageDescriptor.create_from_file(FieldDecorationRegistry, "images/errorqf_ovr.gif")) # $NON-NLS-1$
        image_registry.put(IMG_DEC_FIELD_INFO, ImageDescriptor.create_from_file(FieldDecorationRegistry, "images/info_ovr.gif")) # $NON-NLS-1$
        # Define the standard decorations. Some do not have standard
        # descriptions. Use null in these cases.
        # $NON-NLS-1$
        get_default.register_field_decoration(DEC_CONTENT_PROPOSAL, JFaceResources.get_string("FieldDecorationRegistry.contentAssistMessage"), IMG_DEC_FIELD_CONTENT_PROPOSAL, image_registry)
        # $NON-NLS-1$
        get_default.register_field_decoration(DEC_ERROR, JFaceResources.get_string("FieldDecorationRegistry.errorMessage"), IMG_DEC_FIELD_ERROR, image_registry)
        # $NON-NLS-1$
        get_default.register_field_decoration(DEC_ERROR_QUICKFIX, JFaceResources.get_string("FieldDecorationRegistry.errorQuickFixMessage"), IMG_DEC_FIELD_ERROR_QUICKFIX, image_registry)
        get_default.register_field_decoration(DEC_WARNING, nil, IMG_DEC_FIELD_WARNING, image_registry)
        get_default.register_field_decoration(DEC_INFORMATION, nil, IMG_DEC_FIELD_INFO, image_registry)
        # $NON-NLS-1$
        get_default.register_field_decoration(DEC_REQUIRED, JFaceResources.get_string("FieldDecorationRegistry.requiredFieldMessage"), IMG_DEC_FIELD_REQUIRED, image_registry)
      end
      
      # Data structure that holds onto the decoration image info and description,
      # and can produce a decorator on request.
      const_set_lazy(:Entry) { Class.new do
        extend LocalClass
        include_class_members FieldDecorationRegistry
        
        attr_accessor :description
        alias_method :attr_description, :description
        undef_method :description
        alias_method :attr_description=, :description=
        undef_method :description=
        
        attr_accessor :image_id
        alias_method :attr_image_id, :image_id
        undef_method :image_id
        alias_method :attr_image_id=, :image_id=
        undef_method :image_id=
        
        attr_accessor :image_registry
        alias_method :attr_image_registry, :image_registry
        undef_method :image_registry
        alias_method :attr_image_registry=, :image_registry=
        undef_method :image_registry=
        
        attr_accessor :image
        alias_method :attr_image, :image
        undef_method :image
        alias_method :attr_image=, :image=
        undef_method :image=
        
        attr_accessor :decoration
        alias_method :attr_decoration, :decoration
        undef_method :decoration
        alias_method :attr_decoration=, :decoration=
        undef_method :decoration=
        
        typesig { [String, String, class_self::ImageRegistry] }
        def initialize(description, image_id, registry)
          @description = nil
          @image_id = nil
          @image_registry = nil
          @image = nil
          @decoration = nil
          @description = description
          @image_id = image_id
          @image_registry = registry
        end
        
        typesig { [String, class_self::Image] }
        def initialize(description, image)
          @description = nil
          @image_id = nil
          @image_registry = nil
          @image = nil
          @decoration = nil
          @description = description
          @image = image
        end
        
        typesig { [] }
        def get_decoration
          if ((@decoration).nil?)
            if ((@image).nil?)
              if ((@image_registry).nil?)
                @image_registry = JFaceResources.get_image_registry
              end
              @image = @image_registry.get(@image_id)
            end
            @decoration = self.class::FieldDecoration.new(@image, @description)
          end
          # Null out all other fields now that the decoration has an image
          @description = RJava.cast_to_string(nil)
          @image_id = RJava.cast_to_string(nil)
          @image_registry = nil
          @image = nil
          return @decoration
        end
        
        private
        alias_method :initialize__entry, :initialize
      end }
      
      # Default instance of the registry. Applications may install their own
      # registry.
      
      def default_instance
        defined?(@@default_instance) ? @@default_instance : @@default_instance= nil
      end
      alias_method :attr_default_instance, :default_instance
      
      def default_instance=(value)
        @@default_instance = value
      end
      alias_method :attr_default_instance=, :default_instance=
    }
    
    # Maximum width and height used by decorations in this registry. Clients
    # may use these values to reserve space in dialogs for decorations or to
    # adjust layouts so that decorated and non-decorated fields line up.
    attr_accessor :max_decoration_width
    alias_method :attr_max_decoration_width, :max_decoration_width
    undef_method :max_decoration_width
    alias_method :attr_max_decoration_width=, :max_decoration_width=
    undef_method :max_decoration_width=
    
    attr_accessor :max_decoration_height
    alias_method :attr_max_decoration_height, :max_decoration_height
    undef_method :max_decoration_height
    alias_method :attr_max_decoration_height=, :max_decoration_height=
    undef_method :max_decoration_height=
    
    # <String id, FieldDecoration>
    attr_accessor :decorations
    alias_method :attr_decorations, :decorations
    undef_method :decorations
    alias_method :attr_decorations=, :decorations=
    undef_method :decorations=
    
    class_module.module_eval {
      typesig { [] }
      # Get the default FieldDecorationRegistry.
      # 
      # @return the singleton FieldDecorationRegistry that is used to manage
      # shared field decorations.
      def get_default
        if ((self.attr_default_instance).nil?)
          self.attr_default_instance = FieldDecorationRegistry.new
        end
        return self.attr_default_instance
      end
      
      typesig { [FieldDecorationRegistry] }
      # Set the default FieldDecorationRegistry.
      # 
      # @param defaultRegistry
      # the singleton FieldDecorationRegistry that is used to manage
      # shared field decorations.
      def set_default(default_registry)
        self.attr_default_instance = default_registry
      end
    }
    
    typesig { [] }
    # Construct a FieldDecorationRegistry.
    def initialize
      @max_decoration_width = 0
      @max_decoration_height = 0
      @decorations = HashMap.new
      @max_decoration_width = 0
      @max_decoration_height = 0
    end
    
    typesig { [] }
    # Get the maximum width (in pixels) of any decoration retrieved so far in
    # the registry. This value changes as decorations are added and retrieved.
    # This value can be used by clients to reserve space or otherwise compute
    # margins when aligning non-decorated fields with decorated fields.
    # 
    # @return the maximum width in pixels of any accessed decoration
    def get_maximum_decoration_width
      return @max_decoration_width
    end
    
    typesig { [] }
    # Get the maximum height (in pixels) of any decoration retrieved so far in
    # the registry. This value changes as decorations are added and retrieved.
    # This value can be used by clients to reserve space or otherwise compute
    # margins when aligning non-decorated fields with decorated fields.
    # 
    # 
    # @return the maximum height in pixels of any accessed decoration
    def get_maximum_decoration_height
      return @max_decoration_height
    end
    
    typesig { [String, String, Image] }
    # Registers a field decoration using the specified id. The lifecyle of the
    # supplied image should be managed by the client. That is, it will never be
    # disposed by this registry and the decoration should be removed from the
    # registry if the image is ever disposed elsewhere.
    # 
    # @param id
    # the String id used to identify and access the decoration.
    # @param description
    # the String description to be used in the decoration, or
    # <code>null</code> if the decoration has no description.
    # @param image
    # the image to be used in the decoration
    def register_field_decoration(id, description, image)
      @decorations.put(id, Entry.new_local(self, description, image))
      # Recompute the maximums since this might be a replacement
      recompute_maximums
    end
    
    typesig { [String, String, String] }
    # Registers a field decoration using the specified id. An image id of an
    # image located in the default JFaceResources image registry is supplied.
    # The image will not be created until the decoration is requested.
    # 
    # @param id
    # the String id used to identify and access the decoration.
    # @param description
    # the String description to be used in the decoration, or
    # <code>null</code> if the decoration has no description. *
    # @param imageId
    # the id of the image in the JFaceResources image registry that
    # is used for this decorator
    def register_field_decoration(id, description, image_id)
      @decorations.put(id, Entry.new_local(self, description, image_id, JFaceResources.get_image_registry))
      # Recompute the maximums as this could be a replacement of a previous
      # image.
      recompute_maximums
    end
    
    typesig { [String, String, String, ImageRegistry] }
    # Registers a field decoration using the specified id. An image id and an
    # image registry are supplied. The image will not be created until the
    # decoration is requested.
    # 
    # @param id
    # the String id used to identify and access the decoration.
    # @param description
    # the String description to be used in the decoration, or
    # <code>null</code> if the decoration has no description. *
    # @param imageId
    # the id of the image in the supplied image registry that is
    # used for this decorator
    # @param imageRegistry
    # the registry used to obtain the image
    def register_field_decoration(id, description, image_id, image_registry)
      @decorations.put(id, Entry.new_local(self, description, image_id, image_registry))
      # Recompute the maximums since this could be a replacement
      recompute_maximums
    end
    
    typesig { [String] }
    # Unregisters the field decoration with the specified id. No lifecycle
    # management is performed on the decoration's image. This message has no
    # effect if no field decoration with the specified id was previously
    # registered.
    # </p>
    # <p>
    # This method need not be called if the registered decoration's image is
    # managed in an image registry. In that case, leaving the decoration in the
    # registry will do no harm since the image will remain valid and will be
    # properly disposed when the application is shut down. This method should
    # be used in cases where the caller intends to dispose of the image
    # referred to by the decoration, or otherwise determines that the
    # decoration should no longer be used.
    # 
    # @param id
    # the String id of the decoration to be unregistered.
    def unregister_field_decoration(id)
      @decorations.remove(id)
      recompute_maximums
    end
    
    typesig { [String] }
    # Returns the field decoration registered by the specified id .
    # 
    # @param id
    # the String id used to access the decoration.
    # @return the FieldDecoration with the specified id, or <code>null</code>
    # if there is no decoration with the specified id.
    def get_field_decoration(id)
      entry = @decorations.get(id)
      if ((entry).nil?)
        return nil
      end
      return (entry).get_decoration
    end
    
    typesig { [] }
    # The maximum decoration width and height must be recomputed. Typically
    # called in response to adding, removing, or replacing a decoration.
    def recompute_maximums
      entries = @decorations.values.iterator
      @max_decoration_height = 0
      @max_decoration_width = 0
      while (entries.has_next)
        image = (entries.next_).get_decoration.get_image
        if (!(image).nil?)
          @max_decoration_height = Math.max(@max_decoration_height, image.get_bounds.attr_height)
          @max_decoration_width = Math.max(@max_decoration_width, image.get_bounds.attr_width)
        end
      end
    end
    
    private
    alias_method :initialize__field_decoration_registry, :initialize
  end
  
end
