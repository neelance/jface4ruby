require "rjava"

# Copyright (c) 2000, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Core::Internal::Boot
  module PlatformURLBaseConnectionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Internal::Boot
      include_const ::Java::Io, :IOException
      include_const ::Java::Net, :URL
      include_const ::Org::Eclipse::Core::Internal::Runtime, :CommonMessages
      include_const ::Org::Eclipse::Osgi::Util, :NLS
    }
  end
  
  # Platform URL support
  # platform:/base/	maps to platform installation location
  class PlatformURLBaseConnection < PlatformURLBaseConnectionImports.const_get :PlatformURLConnection
    include_class_members PlatformURLBaseConnectionImports
    
    class_module.module_eval {
      # platform/ protocol
      const_set_lazy(:PLATFORM) { "base" }
      const_attr_reader  :PLATFORM
      
      # $NON-NLS-1$
      const_set_lazy(:PLATFORM_URL_STRING) { RJava.cast_to_string(PlatformURLHandler::PROTOCOL + PlatformURLHandler::PROTOCOL_SEPARATOR) + "/" + PLATFORM + "/" }
      const_attr_reader  :PLATFORM_URL_STRING
      
      # $NON-NLS-1$ //$NON-NLS-2$
      
      def install_url
        defined?(@@install_url) ? @@install_url : @@install_url= nil
      end
      alias_method :attr_install_url, :install_url
      
      def install_url=(value)
        @@install_url = value
      end
      alias_method :attr_install_url=, :install_url=
    }
    
    typesig { [URL] }
    # Constructor for the class.
    def initialize(url)
      super(url)
    end
    
    typesig { [] }
    # (non-Javadoc)
    # @see org.eclipse.equinox.internal.url.PlatformURLConnection#allowCaching()
    def allow_caching
      return true
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
      if (!spec.starts_with(PLATFORM + "/"))
        # $NON-NLS-1$
        message = NLS.bind(CommonMessages.attr_url_bad_variant, self.attr_url)
        raise IOException.new(message)
      end
      return (spec.length).equal?(PLATFORM.length + 1) ? self.attr_install_url : URL.new(self.attr_install_url, spec.substring(PLATFORM.length + 1))
    end
    
    class_module.module_eval {
      typesig { [URL] }
      def startup(url)
        # register connection type for platform:/base/ handling
        if (!(self.attr_install_url).nil?)
          return
        end
        self.attr_install_url = url
        PlatformURLHandler.register(PLATFORM, PlatformURLBaseConnection)
      end
    }
    
    private
    alias_method :initialize__platform_urlbase_connection, :initialize
  end
  
end
