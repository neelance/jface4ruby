require "rjava"

# Copyright (c) 2005, 2007 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Core::Internal::Runtime
  module ActivatorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Internal::Runtime
      include_const ::Java::Net, :URL
      include ::Java::Util
      include_const ::Org::Eclipse::Core::Internal::Boot, :PlatformURLBaseConnection
      include_const ::Org::Eclipse::Core::Internal::Boot, :PlatformURLHandler
      include_const ::Org::Eclipse::Core::Runtime, :IAdapterManager
      include_const ::Org::Eclipse::Osgi::Framework::Log, :FrameworkLog
      include_const ::Org::Eclipse::Osgi::Service::Datalocation, :Location
      include_const ::Org::Eclipse::Osgi::Service::Debug, :DebugOptions
      include_const ::Org::Eclipse::Osgi::Service::Localization, :BundleLocalization
      include_const ::Org::Eclipse::Osgi::Service::Urlconversion, :URLConverter
      include ::Org::Osgi::Framework
      include_const ::Org::Osgi::Service::Packageadmin, :PackageAdmin
      include_const ::Org::Osgi::Service::Url, :URLConstants
      include_const ::Org::Osgi::Service::Url, :URLStreamHandlerService
      include_const ::Org::Osgi::Util::Tracker, :ServiceTracker
    }
  end
  
  # The Common runtime plugin class.
  # 
  # This class can only be used if OSGi plugin is available.
  class Activator 
    include_class_members ActivatorImports
    include BundleActivator
    
    class_module.module_eval {
      # Table to keep track of all the URL converter services.
      
      def url_trackers
        defined?(@@url_trackers) ? @@url_trackers : @@url_trackers= HashMap.new
      end
      alias_method :attr_url_trackers, :url_trackers
      
      def url_trackers=(value)
        @@url_trackers = value
      end
      alias_method :attr_url_trackers=, :url_trackers=
      
      
      def bundle_context
        defined?(@@bundle_context) ? @@bundle_context : @@bundle_context= nil
      end
      alias_method :attr_bundle_context, :bundle_context
      
      def bundle_context=(value)
        @@bundle_context = value
      end
      alias_method :attr_bundle_context=, :bundle_context=
      
      
      def singleton
        defined?(@@singleton) ? @@singleton : @@singleton= nil
      end
      alias_method :attr_singleton, :singleton
      
      def singleton=(value)
        @@singleton = value
      end
      alias_method :attr_singleton=, :singleton=
    }
    
    attr_accessor :platform_urlconverter_service
    alias_method :attr_platform_urlconverter_service, :platform_urlconverter_service
    undef_method :platform_urlconverter_service
    alias_method :attr_platform_urlconverter_service=, :platform_urlconverter_service=
    undef_method :platform_urlconverter_service=
    
    attr_accessor :adapter_manager_service
    alias_method :attr_adapter_manager_service, :adapter_manager_service
    undef_method :adapter_manager_service
    alias_method :attr_adapter_manager_service=, :adapter_manager_service=
    undef_method :adapter_manager_service=
    
    attr_accessor :install_location_tracker
    alias_method :attr_install_location_tracker, :install_location_tracker
    undef_method :install_location_tracker
    alias_method :attr_install_location_tracker=, :install_location_tracker=
    undef_method :install_location_tracker=
    
    attr_accessor :instance_location_tracker
    alias_method :attr_instance_location_tracker, :instance_location_tracker
    undef_method :instance_location_tracker
    alias_method :attr_instance_location_tracker=, :instance_location_tracker=
    undef_method :instance_location_tracker=
    
    attr_accessor :config_location_tracker
    alias_method :attr_config_location_tracker, :config_location_tracker
    undef_method :config_location_tracker
    alias_method :attr_config_location_tracker=, :config_location_tracker=
    undef_method :config_location_tracker=
    
    attr_accessor :bundle_tracker
    alias_method :attr_bundle_tracker, :bundle_tracker
    undef_method :bundle_tracker
    alias_method :attr_bundle_tracker=, :bundle_tracker=
    undef_method :bundle_tracker=
    
    attr_accessor :debug_tracker
    alias_method :attr_debug_tracker, :debug_tracker
    undef_method :debug_tracker
    alias_method :attr_debug_tracker=, :debug_tracker=
    undef_method :debug_tracker=
    
    attr_accessor :log_tracker
    alias_method :attr_log_tracker, :log_tracker
    undef_method :log_tracker
    alias_method :attr_log_tracker=, :log_tracker=
    undef_method :log_tracker=
    
    attr_accessor :localization_tracker
    alias_method :attr_localization_tracker, :localization_tracker
    undef_method :localization_tracker
    alias_method :attr_localization_tracker=, :localization_tracker=
    undef_method :localization_tracker=
    
    class_module.module_eval {
      typesig { [] }
      # Returns the singleton for this Activator. Callers should be aware that
      # this will return null if the bundle is not active.
      def get_default
        return self.attr_singleton
      end
      
      typesig { [String] }
      # Print a debug message to the console.
      # Pre-pend the message with the current date and the name of the current thread.
      def message(message)
        buffer = StringBuffer.new
        buffer.append(JavaDate.new(System.current_time_millis))
        buffer.append(" - [") # $NON-NLS-1$
        buffer.append(JavaThread.current_thread.get_name)
        buffer.append("] ") # $NON-NLS-1$
        buffer.append(message)
        System.out.println(buffer.to_s)
      end
    }
    
    typesig { [BundleContext] }
    # (non-Javadoc)
    # @see org.osgi.framework.BundleActivator#start(org.osgi.framework.BundleContext)
    def start(context)
      self.attr_bundle_context = context
      self.attr_singleton = self
      url_properties = Hashtable.new
      url_properties.put("protocol", "platform") # $NON-NLS-1$ //$NON-NLS-2$
      @platform_urlconverter_service = context.register_service(URLConverter.get_name, PlatformURLConverter.new, url_properties)
      @adapter_manager_service = context.register_service(IAdapterManager.get_name, AdapterManager.get_default, nil)
      install_platform_urlsupport
    end
    
    typesig { [] }
    # Return the configuration location service, if available.
    def get_configuration_location
      if ((@config_location_tracker).nil?)
        filter = nil
        begin
          filter = self.attr_bundle_context.create_filter(Location::CONFIGURATION_FILTER)
        rescue InvalidSyntaxException => e
          # should not happen
        end
        @config_location_tracker = ServiceTracker.new(self.attr_bundle_context, filter, nil)
        @config_location_tracker.open
      end
      return @config_location_tracker.get_service
    end
    
    typesig { [] }
    # Return the debug options service, if available.
    def get_debug_options
      if ((@debug_tracker).nil?)
        @debug_tracker = ServiceTracker.new(self.attr_bundle_context, DebugOptions.get_name, nil)
        @debug_tracker.open
      end
      return @debug_tracker.get_service
    end
    
    typesig { [] }
    # Return the framework log service, if available.
    def get_framework_log
      if ((@log_tracker).nil?)
        @log_tracker = ServiceTracker.new(self.attr_bundle_context, FrameworkLog.get_name, nil)
        @log_tracker.open
      end
      return @log_tracker.get_service
    end
    
    typesig { [] }
    # Return the instance location service, if available.
    def get_instance_location
      if ((@instance_location_tracker).nil?)
        filter = nil
        begin
          filter = self.attr_bundle_context.create_filter(Location::INSTANCE_FILTER)
        rescue InvalidSyntaxException => e
          # ignore this.  It should never happen as we have tested the above format.
        end
        @instance_location_tracker = ServiceTracker.new(self.attr_bundle_context, filter, nil)
        @instance_location_tracker.open
      end
      return @instance_location_tracker.get_service
    end
    
    typesig { [String] }
    # Return the resolved bundle with the specified symbolic name.
    # 
    # @see PackageAdmin#getBundles(String, String)
    def get_bundle(symbolic_name)
      admin = get_bundle_admin
      if ((admin).nil?)
        return nil
      end
      bundles = admin.get_bundles(symbolic_name, nil)
      if ((bundles).nil?)
        return nil
      end
      # Return the first bundle that is not installed or uninstalled
      i = 0
      while i < bundles.attr_length
        if (((bundles[i].get_state & (Bundle::INSTALLED | Bundle::UNINSTALLED))).equal?(0))
          return bundles[i]
        end
        i += 1
      end
      return nil
    end
    
    typesig { [] }
    # Return the package admin service, if available.
    def get_bundle_admin
      if ((@bundle_tracker).nil?)
        @bundle_tracker = ServiceTracker.new(get_context, PackageAdmin.get_name, nil)
        @bundle_tracker.open
      end
      return @bundle_tracker.get_service
    end
    
    typesig { [Bundle] }
    # Return an array of fragments for the given bundle host.
    def get_fragments(host)
      admin = get_bundle_admin
      if ((admin).nil?)
        return Array.typed(Bundle).new(0) { nil }
      end
      return admin.get_fragments(host)
    end
    
    typesig { [] }
    # Return the install location service if available.
    def get_install_location
      if ((@install_location_tracker).nil?)
        filter = nil
        begin
          filter = self.attr_bundle_context.create_filter(Location::INSTALL_FILTER)
        rescue InvalidSyntaxException => e
          # should not happen
        end
        @install_location_tracker = ServiceTracker.new(self.attr_bundle_context, filter, nil)
        @install_location_tracker.open
      end
      return @install_location_tracker.get_service
    end
    
    typesig { [Object] }
    # Returns the bundle id of the bundle that contains the provided object, or
    # <code>null</code> if the bundle could not be determined.
    def get_bundle_id(object)
      if ((object).nil?)
        return nil
      end
      if ((@bundle_tracker).nil?)
        message("Bundle tracker is not set") # $NON-NLS-1$
        return nil
      end
      package_admin = @bundle_tracker.get_service
      if ((package_admin).nil?)
        return nil
      end
      source = package_admin.get_bundle(object.get_class)
      if (!(source).nil? && !(source.get_symbolic_name).nil?)
        return source.get_symbolic_name
      end
      return nil
    end
    
    typesig { [Bundle, String] }
    def get_localization(bundle, locale)
      if ((@localization_tracker).nil?)
        context = Activator.get_context
        if ((context).nil?)
          message("ResourceTranslator called before plugin is started") # $NON-NLS-1$
          return nil
        end
        @localization_tracker = ServiceTracker.new(context, BundleLocalization.get_name, nil)
        @localization_tracker.open
      end
      location = @localization_tracker.get_service
      if (!(location).nil?)
        return location.get_localization(bundle, locale)
      end
      return nil
    end
    
    typesig { [BundleContext] }
    # (non-Javadoc)
    # @see org.osgi.framework.BundleActivator#stop(org.osgi.framework.BundleContext)
    def stop(context)
      close_urltracker_services
      if (!(@platform_urlconverter_service).nil?)
        @platform_urlconverter_service.unregister
        @platform_urlconverter_service = nil
      end
      if (!(@adapter_manager_service).nil?)
        @adapter_manager_service.unregister
        @adapter_manager_service = nil
      end
      if (!(@install_location_tracker).nil?)
        @install_location_tracker.close
        @install_location_tracker = nil
      end
      if (!(@config_location_tracker).nil?)
        @config_location_tracker.close
        @config_location_tracker = nil
      end
      if (!(@bundle_tracker).nil?)
        @bundle_tracker.close
        @bundle_tracker = nil
      end
      if (!(@debug_tracker).nil?)
        @debug_tracker.close
        @debug_tracker = nil
      end
      if (!(@log_tracker).nil?)
        @log_tracker.close
        @log_tracker = nil
      end
      if (!(@instance_location_tracker).nil?)
        @instance_location_tracker.close
        @instance_location_tracker = nil
      end
      if (!(@localization_tracker).nil?)
        @localization_tracker.close
        @localization_tracker = nil
      end
      self.attr_bundle_context = nil
      self.attr_singleton = nil
    end
    
    class_module.module_eval {
      typesig { [] }
      # Return this bundle's context.
      def get_context
        return self.attr_bundle_context
      end
      
      typesig { [] }
      # Let go of all the services that we acquired and kept track of.
      def close_urltracker_services
        synchronized((self.attr_url_trackers)) do
          if (!self.attr_url_trackers.is_empty)
            iter = self.attr_url_trackers.key_set.iterator
            while iter.has_next
              key = iter.next_
              tracker = self.attr_url_trackers.get(key)
              tracker.close
            end
            self.attr_url_trackers = HashMap.new
          end
        end
      end
      
      typesig { [URL] }
      # Return the URL Converter for the given URL. Return null if we can't
      # find one.
      def get_urlconverter(url)
        protocol = url.get_protocol
        synchronized((self.attr_url_trackers)) do
          tracker = self.attr_url_trackers.get(protocol)
          if ((tracker).nil?)
            # get the right service based on the protocol
            filter_prefix = "(&(objectClass=" + RJava.cast_to_string(URLConverter.get_name) + ")(protocol=" # $NON-NLS-1$ //$NON-NLS-2$
            filter_postfix = "))" # $NON-NLS-1$
            filter = nil
            begin
              filter = get_context.create_filter(filter_prefix + protocol + filter_postfix)
            rescue InvalidSyntaxException => e
              return nil
            end
            tracker = ServiceTracker.new(get_context, filter, nil)
            tracker.open
            # cache it in the registry
            self.attr_url_trackers.put(protocol, tracker)
          end
          return tracker.get_service
        end
      end
    }
    
    typesig { [] }
    # Register the platform URL support as a service to the URLHandler service
    def install_platform_urlsupport
      PlatformURLPluginConnection.startup
      PlatformURLFragmentConnection.startup
      PlatformURLMetaConnection.startup
      PlatformURLConfigConnection.startup
      service = get_install_location
      if (!(service).nil?)
        PlatformURLBaseConnection.startup(service.get_url)
      end
      properties = Hashtable.new(1)
      properties.put(URLConstants::URL_HANDLER_PROTOCOL, Array.typed(String).new([PlatformURLHandler::PROTOCOL]))
      get_context.register_service(URLStreamHandlerService.get_name, PlatformURLHandler.new, properties)
    end
    
    typesig { [] }
    def initialize
      @platform_urlconverter_service = nil
      @adapter_manager_service = nil
      @install_location_tracker = nil
      @instance_location_tracker = nil
      @config_location_tracker = nil
      @bundle_tracker = nil
      @debug_tracker = nil
      @log_tracker = nil
      @localization_tracker = nil
    end
    
    private
    alias_method :initialize__activator, :initialize
  end
  
end
