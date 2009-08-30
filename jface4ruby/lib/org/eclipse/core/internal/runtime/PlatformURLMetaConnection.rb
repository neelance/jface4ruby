require "rjava"

# Copyright (c) 2004, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Core::Internal::Runtime
  module PlatformURLMetaConnectionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Internal::Runtime
      include ::Java::Io
      include_const ::Java::Net, :URL
      include_const ::Org::Eclipse::Core::Internal::Boot, :PlatformURLConnection
      include_const ::Org::Eclipse::Core::Internal::Boot, :PlatformURLHandler
      include_const ::Org::Eclipse::Core::Runtime, :IPath
      include_const ::Org::Eclipse::Osgi::Util, :NLS
      include_const ::Org::Osgi::Framework, :Bundle
    }
  end
  
  class PlatformURLMetaConnection < PlatformURLMetaConnectionImports.const_get :PlatformURLConnection
    include_class_members PlatformURLMetaConnectionImports
    
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
      
      const_set_lazy(:META) { "meta" }
      const_attr_reader  :META
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
    # @see org.eclipse.equinox.internal.url.PlatformURLConnection#resolve()
    def resolve
      spec = self.attr_url.get_file.trim
      if (spec.starts_with("/"))
        # $NON-NLS-1$
        spec = RJava.cast_to_string(spec.substring(1))
      end
      if (!spec.starts_with(META))
        raise IOException.new(NLS.bind(CommonMessages.attr_url_bad_variant, self.attr_url.to_s))
      end
      ix = spec.index_of("/", META.length + 1) # $NON-NLS-1$
      ref = (ix).equal?(-1) ? spec.substring(META.length + 1) : spec.substring(META.length + 1, ix)
      id = get_id(ref)
      activator = Activator.get_default
      if ((activator).nil?)
        raise IOException.new(CommonMessages.attr_activator_not_available)
      end
      @target = activator.get_bundle(id)
      if ((@target).nil?)
        raise IOException.new(NLS.bind(CommonMessages.attr_url_resolve_plugin, self.attr_url.to_s))
      end
      path = MetaDataKeeper.get_meta_area.get_state_location(@target)
      if (!(ix).equal?(-1) || (ix + 1) <= spec.length)
        path = path.append(spec.substring(ix + 1))
      end
      return path.to_file.to_url
    end
    
    class_module.module_eval {
      typesig { [] }
      def startup
        # register connection type for platform:/meta handling
        if (self.attr_is_registered)
          return
        end
        PlatformURLHandler.register(META, PlatformURLMetaConnection)
        self.attr_is_registered = true
      end
    }
    
    typesig { [] }
    # (non-Javadoc)
    # @see java.net.URLConnection#getOutputStream()
    def get_output_stream
      # This is not optimal but connection is a private instance variable in super.
      resolved = get_resolved_url
      if (!(resolved).nil?)
        file_string = resolved.get_file
        if (!(file_string).nil?)
          file = JavaFile.new(file_string)
          parent = file.get_parent
          if (!(parent).nil?)
            JavaFile.new(parent).mkdirs
          end
          return FileOutputStream.new(file)
        end
      end
      return nil
    end
    
    private
    alias_method :initialize__platform_urlmeta_connection, :initialize
  end
  
end
