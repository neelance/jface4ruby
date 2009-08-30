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
  module PlatformURLHandlerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Internal::Boot
      include_const ::Java::Io, :IOException
      include_const ::Java::Lang::Reflect, :Constructor
      include ::Java::Net
      include_const ::Java::Util, :Hashtable
      include_const ::Org::Eclipse::Core::Internal::Runtime, :CommonMessages
      include_const ::Org::Eclipse::Osgi::Util, :NLS
      include_const ::Org::Osgi::Service::Url, :AbstractURLStreamHandlerService
    }
  end
  
  # URL handler for the "platform" protocol
  class PlatformURLHandler < PlatformURLHandlerImports.const_get :AbstractURLStreamHandlerService
    include_class_members PlatformURLHandlerImports
    
    class_module.module_eval {
      
      def connection_type
        defined?(@@connection_type) ? @@connection_type : @@connection_type= Hashtable.new
      end
      alias_method :attr_connection_type, :connection_type
      
      def connection_type=(value)
        @@connection_type = value
      end
      alias_method :attr_connection_type=, :connection_type=
      
      # URL protocol designations
      const_set_lazy(:PROTOCOL) { "platform" }
      const_attr_reader  :PROTOCOL
      
      # $NON-NLS-1$
      const_set_lazy(:FILE) { "file" }
      const_attr_reader  :FILE
      
      # $NON-NLS-1$
      const_set_lazy(:JAR) { "jar" }
      const_attr_reader  :JAR
      
      # $NON-NLS-1$
      const_set_lazy(:BUNDLE) { "bundle" }
      const_attr_reader  :BUNDLE
      
      # $NON-NLS-1$
      const_set_lazy(:JAR_SEPARATOR) { "!/" }
      const_attr_reader  :JAR_SEPARATOR
      
      # $NON-NLS-1$
      const_set_lazy(:PROTOCOL_SEPARATOR) { ":" }
      const_attr_reader  :PROTOCOL_SEPARATOR
    }
    
    typesig { [] }
    # $NON-NLS-1$
    # 
    # Constructor for the class.
    def initialize
      super()
    end
    
    typesig { [URL] }
    # (non-Javadoc)
    # @see org.osgi.service.url.AbstractURLStreamHandlerService#openConnection(java.net.URL)
    def open_connection(url)
      # Note: openConnection() method is made public (rather than protected)
      # to enable request delegation from proxy handlers
      spec = url.get_file.trim
      if (spec.starts_with("/"))
        # $NON-NLS-1$
        spec = RJava.cast_to_string(spec.substring(1))
      end
      ix = spec.index_of("/") # $NON-NLS-1$
      if ((ix).equal?(-1))
        raise MalformedURLException.new(NLS.bind(CommonMessages.attr_url_invalid_url, url.to_external_form))
      end
      type = spec.substring(0, ix)
      construct = self.attr_connection_type.get(type)
      if ((construct).nil?)
        raise MalformedURLException.new(NLS.bind(CommonMessages.attr_url_bad_variant, type))
      end
      connection = nil
      begin
        connection = construct.new_instance(Array.typed(Object).new([url]))
      rescue JavaException => e
        raise IOException.new(NLS.bind(CommonMessages.attr_url_create_connection, e.get_message))
      end
      connection.set_resolved_url(connection.resolve)
      return connection
    end
    
    class_module.module_eval {
      typesig { [String, Class] }
      def register(type, connection_class)
        begin
          c = connection_class.get_constructor(Array.typed(Class).new([URL]))
          self.attr_connection_type.put(type, c)
        rescue NoSuchMethodException => e
          # don't register connection classes that don't conform to the spec
        end
      end
      
      typesig { [String] }
      def unregister(type)
        self.attr_connection_type.remove(type)
      end
    }
    
    private
    alias_method :initialize__platform_urlhandler, :initialize
  end
  
end
