require "rjava"

# Copyright (c) 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Core::Internal::Runtime
  module PlatformURLConverterImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Internal::Runtime
      include_const ::Java::Io, :IOException
      include_const ::Java::Net, :URL
      include_const ::Java::Net, :URLConnection
      include_const ::Org::Eclipse::Core::Internal::Boot, :PlatformURLConnection
      include_const ::Org::Eclipse::Core::Internal::Boot, :PlatformURLHandler
      include_const ::Org::Eclipse::Core::Runtime, :FileLocator
      include_const ::Org::Eclipse::Osgi::Service::Urlconversion, :URLConverter
    }
  end
  
  # Class which implements the URLConverter service. Manages conversion of a
  # platform: URL to one with a more well known protocol.
  # 
  # @since 3.2
  class PlatformURLConverter 
    include_class_members PlatformURLConverterImports
    include URLConverter
    
    typesig { [URL] }
    # (non-Javadoc)
    # @see org.eclipse.osgi.service.urlconversion.URLConverter#toFileURL(java.net.URL)
    def to_file_url(url)
      connection = url.open_connection
      if (!(connection.is_a?(PlatformURLConnection)))
        return url
      end
      result = (connection).get_urlas_local
      # if we have a bundle*: URL we should try to convert it
      if (!result.get_protocol.starts_with(PlatformURLHandler::BUNDLE))
        return result
      end
      return FileLocator.to_file_url(result)
    end
    
    typesig { [URL] }
    # (non-Javadoc)
    # @see org.eclipse.osgi.service.urlconversion.URLConverter#resolve(java.net.URL)
    def resolve(url)
      connection = url.open_connection
      if (!(connection.is_a?(PlatformURLConnection)))
        return url
      end
      result = (connection).get_resolved_url
      # if we have a bundle*: URL we should try to convert it
      if (!result.get_protocol.starts_with(PlatformURLHandler::BUNDLE))
        return result
      end
      return FileLocator.resolve(result)
    end
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__platform_urlconverter, :initialize
  end
  
end
