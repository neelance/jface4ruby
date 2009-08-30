require "rjava"

# Copyright (c) 2000, 2009 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Core::Internal::Runtime
  module PlatformURLPluginConnectionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Internal::Runtime
      include_const ::Java::Io, :IOException
      include_const ::Java::Net, :URL
      include_const ::Org::Eclipse::Core::Internal::Boot, :PlatformURLConnection
      include_const ::Org::Eclipse::Core::Internal::Boot, :PlatformURLHandler
      include_const ::Org::Eclipse::Osgi::Util, :NLS
      include_const ::Org::Osgi::Framework, :Bundle
    }
  end
  
  # Platform URL support
  # platform:/plugin/pluginId/		maps to pluginDescriptor.getInstallURLInternal()
  class PlatformURLPluginConnection < PlatformURLPluginConnectionImports.const_get :PlatformURLConnection
    include_class_members PlatformURLPluginConnectionImports
    
    attr_accessor :target
    alias_method :attr_target, :target
    undef_method :target
    alias_method :attr_target=, :target=
    undef_method :target=
    
    class_module.module_eval {
      
      def is_registered
        defined?(@@is_registered) ? @@is_registered : @@is_registered= false
      end
      alias_method :attr_is_registered, :is_registered
      
      def is_registered=(value)
        @@is_registered = value
      end
      alias_method :attr_is_registered=, :is_registered=
      
      const_set_lazy(:PLUGIN) { "plugin" }
      const_attr_reader  :PLUGIN
    }
    
    typesig { [URL] }
    # $NON-NLS-1$
    # 
    # Constructor for the class.
    def initialize(url)
      @target = nil
      super(url)
      @target = nil
    end
    
    typesig { [] }
    # (non-Javadoc)
    # @see org.eclipse.equinox.internal.url.PlatformURLConnection#allowCaching()
    def allow_caching
      return true
    end
    
    class_module.module_eval {
      typesig { [String, URL] }
      # spec - /plugin/com.example/META-INF/MANIFEST.MF
      # originalURL - used only for exception messages
      # result[0] - Bundle (e.g. com.example)
      # result[1] - String (path) (e.g. META-INF/MANIFEST.MF)
      def parse(spec, original_url)
        result = Array.typed(Object).new(2) { nil }
        if (spec.starts_with("/"))
          # $NON-NLS-1$
          spec = RJava.cast_to_string(spec.substring(1))
        end
        if (!spec.starts_with(PLUGIN))
          raise IOException.new(NLS.bind(CommonMessages.attr_url_bad_variant, original_url))
        end
        ix = spec.index_of("/", PLUGIN.length + 1) # $NON-NLS-1$
        ref = (ix).equal?(-1) ? spec.substring(PLUGIN.length + 1) : spec.substring(PLUGIN.length + 1, ix)
        id = get_id(ref)
        activator = Activator.get_default
        if ((activator).nil?)
          raise IOException.new(CommonMessages.attr_activator_not_available)
        end
        bundle = activator.get_bundle(id)
        if ((bundle).nil?)
          raise IOException.new(NLS.bind(CommonMessages.attr_url_resolve_plugin, original_url))
        end
        result[0] = bundle
        result[1] = ((ix).equal?(-1) || (ix + 1) >= spec.length) ? "/" : spec.substring(ix + 1) # $NON-NLS-1$
        return result
      end
    }
    
    typesig { [] }
    # (non-Javadoc)
    # @see org.eclipse.equinox.internal.url.PlatformURLConnection#resolve()
    def resolve
      spec = self.attr_url.get_file.trim
      obj = parse(spec, self.attr_url)
      b = obj[0]
      path = obj[1]
      result = b.get_entry(path)
      if (!(result).nil? || ("/" == path))
        # $NON-NLS-1$
        return result
      end
      # if the result is null then force the creation of a URL that will throw FileNotFoundExceptions
      return URL.new(b.get_entry("/"), path) # $NON-NLS-1$
    end
    
    class_module.module_eval {
      typesig { [] }
      def startup
        # register connection type for platform:/plugin handling
        if (self.attr_is_registered)
          return
        end
        PlatformURLHandler.register(PLUGIN, PlatformURLPluginConnection)
        self.attr_is_registered = true
      end
    }
    
    typesig { [] }
    # (non-Javadoc)
    # @see org.eclipse.equinox.internal.url.PlatformURLConnection#getAuxillaryURLs()
    def get_auxillary_urls
      if ((@target).nil?)
        spec = self.attr_url.get_file.trim
        if (spec.starts_with("/"))
          # $NON-NLS-1$
          spec = RJava.cast_to_string(spec.substring(1))
        end
        if (!spec.starts_with(PLUGIN))
          raise IOException.new(NLS.bind(CommonMessages.attr_url_bad_variant, self.attr_url))
        end
        ix = spec.index_of("/", PLUGIN.length + 1) # $NON-NLS-1$
        ref = (ix).equal?(-1) ? spec.substring(PLUGIN.length + 1) : spec.substring(PLUGIN.length + 1, ix)
        id = get_id(ref)
        activator = Activator.get_default
        if ((activator).nil?)
          raise IOException.new(CommonMessages.attr_activator_not_available)
        end
        @target = activator.get_bundle(id)
        if ((@target).nil?)
          raise IOException.new(NLS.bind(CommonMessages.attr_url_resolve_plugin, self.attr_url))
        end
      end
      fragments = Activator.get_default.get_fragments(@target)
      fragment_length = ((fragments).nil?) ? 0 : fragments.attr_length
      if ((fragment_length).equal?(0))
        return nil
      end
      result = Array.typed(URL).new(fragment_length) { nil }
      i = 0
      while i < fragment_length
        result[i] = fragments[i].get_entry("/")
        i += 1
      end # $NON-NLS-1$
      return result
    end
    
    private
    alias_method :initialize__platform_urlplugin_connection, :initialize
  end
  
end
