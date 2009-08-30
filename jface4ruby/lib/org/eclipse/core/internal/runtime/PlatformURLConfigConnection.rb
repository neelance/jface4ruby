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
  module PlatformURLConfigConnectionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Internal::Runtime
      include ::Java::Io
      include_const ::Java::Net, :URL
      include_const ::Java::Net, :UnknownServiceException
      include_const ::Org::Eclipse::Core::Internal::Boot, :PlatformURLConnection
      include_const ::Org::Eclipse::Core::Internal::Boot, :PlatformURLHandler
      include_const ::Org::Eclipse::Osgi::Service::Datalocation, :Location
      include_const ::Org::Eclipse::Osgi::Util, :NLS
    }
  end
  
  class PlatformURLConfigConnection < PlatformURLConfigConnectionImports.const_get :PlatformURLConnection
    include_class_members PlatformURLConfigConnectionImports
    
    class_module.module_eval {
      const_set_lazy(:FILE_PROTOCOL) { "file" }
      const_attr_reader  :FILE_PROTOCOL
      
      # $NON-NLS-1$
      
      def is_registered
        defined?(@@is_registered) ? @@is_registered : @@is_registered= false
      end
      alias_method :attr_is_registered, :is_registered
      
      def is_registered=(value)
        @@is_registered = value
      end
      alias_method :attr_is_registered=, :is_registered=
      
      const_set_lazy(:CONFIG) { "config" }
      const_attr_reader  :CONFIG
    }
    
    # $NON-NLS-1$
    attr_accessor :parent_configuration
    alias_method :attr_parent_configuration, :parent_configuration
    undef_method :parent_configuration
    alias_method :attr_parent_configuration=, :parent_configuration=
    undef_method :parent_configuration=
    
    typesig { [URL] }
    # Constructor for the class.
    def initialize(url)
      @parent_configuration = false
      super(url)
      @parent_configuration = false
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
      if (!spec.starts_with(CONFIG))
        raise IOException.new(NLS.bind(CommonMessages.attr_url_bad_variant, self.attr_url.to_s))
      end
      path = spec.substring(CONFIG.length + 1)
      # resolution takes parent configuration into account (if it exists)
      activator = Activator.get_default
      if ((activator).nil?)
        raise IOException.new(CommonMessages.attr_activator_not_available)
      end
      local_config = activator.get_configuration_location
      parent_config = local_config.get_parent_location
      # assume we will find the file locally
      local_url = URL.new(local_config.get_url, path)
      if (!(FILE_PROTOCOL == local_url.get_protocol) || (parent_config).nil?)
        # we only support cascaded file: URLs
        return local_url
      end
      local_file = JavaFile.new(local_url.get_path)
      if (local_file.exists)
        # file exists in local configuration
        return local_url
      end
      # try to find in the parent configuration
      parent_url = URL.new(parent_config.get_url, path)
      if ((FILE_PROTOCOL == parent_url.get_protocol))
        # we only support cascaded file: URLs
        parent_file = JavaFile.new(parent_url.get_path)
        if (parent_file.exists)
          # parent has the location
          @parent_configuration = true
          return parent_url
        end
      end
      return local_url
    end
    
    class_module.module_eval {
      typesig { [] }
      def startup
        # register connection type for platform:/config handling
        if (self.attr_is_registered)
          return
        end
        PlatformURLHandler.register(CONFIG, PlatformURLConfigConnection)
        self.attr_is_registered = true
      end
    }
    
    typesig { [] }
    # (non-Javadoc)
    # @see java.net.URLConnection#getOutputStream()
    def get_output_stream
      if (@parent_configuration || (Activator.get_default).nil? || Activator.get_default.get_configuration_location.is_read_only)
        raise UnknownServiceException.new(NLS.bind(CommonMessages.attr_url_no_output, self.attr_url))
      end
      # This is not optimal but connection is a private instance variable in the super-class.
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
    alias_method :initialize__platform_urlconfig_connection, :initialize
  end
  
end
