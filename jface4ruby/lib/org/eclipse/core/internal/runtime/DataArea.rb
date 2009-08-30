require "rjava"

# Copyright (c) 2004, 2009 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Core::Internal::Runtime
  module DataAreaImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Internal::Runtime
      include_const ::Java::Io, :JavaFile
      include_const ::Java::Io, :IOException
      include_const ::Java::Net, :URL
      include ::Org::Eclipse::Core::Runtime
      include_const ::Org::Eclipse::Osgi::Framework::Log, :FrameworkLog
      include_const ::Org::Eclipse::Osgi::Service::Datalocation, :Location
      include_const ::Org::Eclipse::Osgi::Service::Debug, :DebugOptions
      include_const ::Org::Eclipse::Osgi::Util, :NLS
      include_const ::Org::Osgi::Framework, :Bundle
    }
  end
  
  # This class can only be used if OSGi plugin is available
  class DataArea 
    include_class_members DataAreaImports
    
    class_module.module_eval {
      const_set_lazy(:OPTION_DEBUG) { "org.eclipse.equinox.common/debug" }
      const_attr_reader  :OPTION_DEBUG
      
      # $NON-NLS-1$;
      # package
      const_set_lazy(:F_META_AREA) { ".metadata" }
      const_attr_reader  :F_META_AREA
      
      # $NON-NLS-1$
      # package
      const_set_lazy(:F_PLUGIN_DATA) { ".plugins" }
      const_attr_reader  :F_PLUGIN_DATA
      
      # $NON-NLS-1$
      # package
      const_set_lazy(:F_LOG) { ".log" }
      const_attr_reader  :F_LOG
      
      # $NON-NLS-1$
      # package
      const_set_lazy(:F_TRACE) { "trace.log" }
      const_attr_reader  :F_TRACE
      
      # $NON-NLS-1$
      # 
      # Internal name of the preference storage file (value <code>"pref_store.ini"</code>) in this plug-in's (read-write) state area.
      # 
      # package
      const_set_lazy(:PREFERENCES_FILE_NAME) { "pref_store.ini" }
      const_attr_reader  :PREFERENCES_FILE_NAME
    }
    
    # $NON-NLS-1$
    attr_accessor :location
    alias_method :attr_location, :location
    undef_method :location
    alias_method :attr_location=, :location=
    undef_method :location=
    
    # The location of the instance data
    attr_accessor :initialized
    alias_method :attr_initialized, :initialized
    undef_method :initialized
    alias_method :attr_initialized=, :initialized=
    undef_method :initialized=
    
    typesig { [] }
    def assert_location_initialized
      if (!(@location).nil? && @initialized)
        return
      end
      activator = Activator.get_default
      if ((activator).nil?)
        raise IllegalStateException.new(CommonMessages.attr_activator_not_available)
      end
      service = activator.get_instance_location
      if ((service).nil?)
        raise IllegalStateException.new(CommonMessages.attr_meta_no_data_mode_specified)
      end
      begin
        url = service.get_url
        if ((url).nil?)
          raise IllegalStateException.new(CommonMessages.attr_meta_instance_data_unspecified)
        end
        # TODO assume the URL is a file:
        # Use the new File technique to ensure that the resultant string is
        # in the right format (e.g., leading / removed from /c:/foo etc)
        @location = Path.new(JavaFile.new(url.get_file).to_s)
        initialize_location
      rescue CoreException => e
        raise IllegalStateException.new(e.get_message)
      end
    end
    
    typesig { [] }
    def get_metadata_location
      assert_location_initialized
      return @location.append(F_META_AREA)
    end
    
    typesig { [] }
    def get_instance_data_location
      assert_location_initialized
      return @location
    end
    
    typesig { [] }
    # Returns the local file system path of the log file, or the default log location
    # if the log is not in the local file system.
    def get_log_location
      # make sure the log location is initialized if the instance location is known
      if (is_instance_location_set)
        assert_location_initialized
      end
      log = Activator.get_default.get_framework_log
      if (!(log).nil?)
        file = log.get_file
        if (!(file).nil?)
          return Path.new(file.get_absolute_path)
        end
      end
      if ((@location).nil?)
        raise IllegalStateException.new(CommonMessages.attr_meta_instance_data_unspecified)
      end
      return @location.append(F_META_AREA).append(F_LOG)
    end
    
    typesig { [] }
    def get_trace_location
      debug_options = Activator.get_default.get_debug_options
      if ((debug_options).nil?)
        return nil
      end
      return Path.new(debug_options.get_file.get_absolute_path)
    end
    
    typesig { [] }
    # Returns true if the instance location has been set, and <code>false</code> otherwise.
    def is_instance_location_set
      activator = Activator.get_default
      if ((activator).nil?)
        return false
      end
      service = activator.get_instance_location
      if ((service).nil?)
        return false
      end
      return service.is_set
    end
    
    typesig { [Bundle] }
    # Returns the read/write location in which the given bundle can manage private state.
    def get_state_location(bundle)
      assert_location_initialized
      return get_state_location(bundle.get_symbolic_name)
    end
    
    typesig { [String] }
    def get_state_location(bundle_name)
      assert_location_initialized
      return get_metadata_location.append(F_PLUGIN_DATA).append(bundle_name)
    end
    
    typesig { [String, ::Java::Boolean] }
    def get_preference_location(bundle_name, create)
      result = get_state_location(bundle_name)
      if (create)
        result.to_file.mkdirs
      end
      return result.append(PREFERENCES_FILE_NAME)
    end
    
    typesig { [] }
    def initialize_location
      # check if the location can be created
      if (@location.to_file.exists)
        if (!@location.to_file.is_directory)
          message = NLS.bind(CommonMessages.attr_meta_not_dir, @location)
          raise CoreException.new(Status.new(IStatus::ERROR, IRuntimeConstants::PI_RUNTIME, IRuntimeConstants::FAILED_WRITE_METADATA, message, nil))
        end
      end
      # try infer the device if there isn't one (windows)
      if ((@location.get_device).nil?)
        @location = Path.new(@location.to_file.get_absolute_path)
      end
      create_location
      @initialized = true
    end
    
    typesig { [] }
    def create_location
      # append on the metadata location so that the whole structure is created.
      file = @location.append(F_META_AREA).to_file
      begin
        file.mkdirs
      rescue JavaException => e
        message = NLS.bind(CommonMessages.attr_meta_could_not_create, file.get_absolute_path)
        raise CoreException.new(Status.new(IStatus::ERROR, IRuntimeConstants::PI_RUNTIME, IRuntimeConstants::FAILED_WRITE_METADATA, message, e))
      end
      if (!file.can_write)
        message = NLS.bind(CommonMessages.attr_meta_readonly, file.get_absolute_path)
        raise CoreException.new(Status.new(IStatus::ERROR, IRuntimeConstants::PI_RUNTIME, IRuntimeConstants::FAILED_WRITE_METADATA, message, nil))
      end
      # set the log file location now that we created the data area
      log_path = @location.append(F_META_AREA).append(F_LOG)
      begin
        activator = Activator.get_default
        if (!(activator).nil?)
          log = activator.get_framework_log
          if (!(log).nil?)
            log.set_file(log_path.to_file, true)
          else
            if (debug)
              System.out.println("ERROR: Unable to acquire log service. Application will proceed, but logging will be disabled.")
            end
          end # $NON-NLS-1$
        end
      rescue IOException => e
        e.print_stack_trace
      end
      # set the trace file location now that we created the data area
      trace_path = @location.append(F_META_AREA).append(F_TRACE)
      activator_ = Activator.get_default
      if (!(activator_).nil?)
        debug_options = activator_.get_debug_options
        if (!(debug_options).nil?)
          debug_options.set_file(trace_path.to_file)
        else
          System.out.println("ERROR: Unable to acquire debug service. Application will proceed, but debugging will be disabled.") # $NON-NLS-1$
        end
      end
    end
    
    typesig { [] }
    def debug
      activator = Activator.get_default
      if ((activator).nil?)
        return false
      end
      debug_options = activator.get_debug_options
      if ((debug_options).nil?)
        return false
      end
      return debug_options.get_boolean_option(OPTION_DEBUG, false)
    end
    
    typesig { [] }
    def initialize
      @location = nil
      @initialized = false
    end
    
    private
    alias_method :initialize__data_area, :initialize
  end
  
end
