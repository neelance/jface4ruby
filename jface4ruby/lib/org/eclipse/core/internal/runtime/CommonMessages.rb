require "rjava"

# Copyright (c) 2005, 2006 IBM Corporation and others. All rights reserved.   This
# program and the accompanying materials are made available under the terms of
# the Eclipse Public License v1.0 which accompanies this distribution, and is
# available at http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM - Initial API and implementation
module Org::Eclipse::Core::Internal::Runtime
  module CommonMessagesImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Internal::Runtime
      include_const ::Org::Eclipse::Osgi::Util, :NLS
    }
  end
  
  # Common runtime plugin message catalog
  class CommonMessages < CommonMessagesImports.const_get :NLS
    include_class_members CommonMessagesImports
    
    class_module.module_eval {
      const_set_lazy(:BUNDLE_NAME) { "org.eclipse.core.internal.runtime.commonMessages" }
      const_attr_reader  :BUNDLE_NAME
      
      # $NON-NLS-1$
      
      def ok
        defined?(@@ok) ? @@ok : @@ok= nil
      end
      alias_method :attr_ok, :ok
      
      def ok=(value)
        @@ok = value
      end
      alias_method :attr_ok=, :ok=
      
      # metadata
      
      def meta_could_not_create
        defined?(@@meta_could_not_create) ? @@meta_could_not_create : @@meta_could_not_create= nil
      end
      alias_method :attr_meta_could_not_create, :meta_could_not_create
      
      def meta_could_not_create=(value)
        @@meta_could_not_create = value
      end
      alias_method :attr_meta_could_not_create=, :meta_could_not_create=
      
      
      def meta_instance_data_unspecified
        defined?(@@meta_instance_data_unspecified) ? @@meta_instance_data_unspecified : @@meta_instance_data_unspecified= nil
      end
      alias_method :attr_meta_instance_data_unspecified, :meta_instance_data_unspecified
      
      def meta_instance_data_unspecified=(value)
        @@meta_instance_data_unspecified = value
      end
      alias_method :attr_meta_instance_data_unspecified=, :meta_instance_data_unspecified=
      
      
      def meta_no_data_mode_specified
        defined?(@@meta_no_data_mode_specified) ? @@meta_no_data_mode_specified : @@meta_no_data_mode_specified= nil
      end
      alias_method :attr_meta_no_data_mode_specified, :meta_no_data_mode_specified
      
      def meta_no_data_mode_specified=(value)
        @@meta_no_data_mode_specified = value
      end
      alias_method :attr_meta_no_data_mode_specified=, :meta_no_data_mode_specified=
      
      
      def meta_not_dir
        defined?(@@meta_not_dir) ? @@meta_not_dir : @@meta_not_dir= nil
      end
      alias_method :attr_meta_not_dir, :meta_not_dir
      
      def meta_not_dir=(value)
        @@meta_not_dir = value
      end
      alias_method :attr_meta_not_dir=, :meta_not_dir=
      
      
      def meta_readonly
        defined?(@@meta_readonly) ? @@meta_readonly : @@meta_readonly= nil
      end
      alias_method :attr_meta_readonly, :meta_readonly
      
      def meta_readonly=(value)
        @@meta_readonly = value
      end
      alias_method :attr_meta_readonly=, :meta_readonly=
      
      
      def meta_plugin_problems
        defined?(@@meta_plugin_problems) ? @@meta_plugin_problems : @@meta_plugin_problems= nil
      end
      alias_method :attr_meta_plugin_problems, :meta_plugin_problems
      
      def meta_plugin_problems=(value)
        @@meta_plugin_problems = value
      end
      alias_method :attr_meta_plugin_problems=, :meta_plugin_problems=
      
      # URL
      
      def url_bad_variant
        defined?(@@url_bad_variant) ? @@url_bad_variant : @@url_bad_variant= nil
      end
      alias_method :attr_url_bad_variant, :url_bad_variant
      
      def url_bad_variant=(value)
        @@url_bad_variant = value
      end
      alias_method :attr_url_bad_variant=, :url_bad_variant=
      
      
      def url_create_connection
        defined?(@@url_create_connection) ? @@url_create_connection : @@url_create_connection= nil
      end
      alias_method :attr_url_create_connection, :url_create_connection
      
      def url_create_connection=(value)
        @@url_create_connection = value
      end
      alias_method :attr_url_create_connection=, :url_create_connection=
      
      
      def url_invalid_url
        defined?(@@url_invalid_url) ? @@url_invalid_url : @@url_invalid_url= nil
      end
      alias_method :attr_url_invalid_url, :url_invalid_url
      
      def url_invalid_url=(value)
        @@url_invalid_url = value
      end
      alias_method :attr_url_invalid_url=, :url_invalid_url=
      
      
      def url_noaccess
        defined?(@@url_noaccess) ? @@url_noaccess : @@url_noaccess= nil
      end
      alias_method :attr_url_noaccess, :url_noaccess
      
      def url_noaccess=(value)
        @@url_noaccess = value
      end
      alias_method :attr_url_noaccess=, :url_noaccess=
      
      
      def url_no_output
        defined?(@@url_no_output) ? @@url_no_output : @@url_no_output= nil
      end
      alias_method :attr_url_no_output, :url_no_output
      
      def url_no_output=(value)
        @@url_no_output = value
      end
      alias_method :attr_url_no_output=, :url_no_output=
      
      
      def url_resolve_fragment
        defined?(@@url_resolve_fragment) ? @@url_resolve_fragment : @@url_resolve_fragment= nil
      end
      alias_method :attr_url_resolve_fragment, :url_resolve_fragment
      
      def url_resolve_fragment=(value)
        @@url_resolve_fragment = value
      end
      alias_method :attr_url_resolve_fragment=, :url_resolve_fragment=
      
      
      def url_resolve_plugin
        defined?(@@url_resolve_plugin) ? @@url_resolve_plugin : @@url_resolve_plugin= nil
      end
      alias_method :attr_url_resolve_plugin, :url_resolve_plugin
      
      def url_resolve_plugin=(value)
        @@url_resolve_plugin = value
      end
      alias_method :attr_url_resolve_plugin=, :url_resolve_plugin=
      
      # parsing/resolve
      
      def parse_double_separator_version
        defined?(@@parse_double_separator_version) ? @@parse_double_separator_version : @@parse_double_separator_version= nil
      end
      alias_method :attr_parse_double_separator_version, :parse_double_separator_version
      
      def parse_double_separator_version=(value)
        @@parse_double_separator_version = value
      end
      alias_method :attr_parse_double_separator_version=, :parse_double_separator_version=
      
      
      def parse_empty_plugin_version
        defined?(@@parse_empty_plugin_version) ? @@parse_empty_plugin_version : @@parse_empty_plugin_version= nil
      end
      alias_method :attr_parse_empty_plugin_version, :parse_empty_plugin_version
      
      def parse_empty_plugin_version=(value)
        @@parse_empty_plugin_version = value
      end
      alias_method :attr_parse_empty_plugin_version=, :parse_empty_plugin_version=
      
      
      def parse_four_element_plugin_version
        defined?(@@parse_four_element_plugin_version) ? @@parse_four_element_plugin_version : @@parse_four_element_plugin_version= nil
      end
      alias_method :attr_parse_four_element_plugin_version, :parse_four_element_plugin_version
      
      def parse_four_element_plugin_version=(value)
        @@parse_four_element_plugin_version = value
      end
      alias_method :attr_parse_four_element_plugin_version=, :parse_four_element_plugin_version=
      
      
      def parse_numeric_major_component
        defined?(@@parse_numeric_major_component) ? @@parse_numeric_major_component : @@parse_numeric_major_component= nil
      end
      alias_method :attr_parse_numeric_major_component, :parse_numeric_major_component
      
      def parse_numeric_major_component=(value)
        @@parse_numeric_major_component = value
      end
      alias_method :attr_parse_numeric_major_component=, :parse_numeric_major_component=
      
      
      def parse_numeric_minor_component
        defined?(@@parse_numeric_minor_component) ? @@parse_numeric_minor_component : @@parse_numeric_minor_component= nil
      end
      alias_method :attr_parse_numeric_minor_component, :parse_numeric_minor_component
      
      def parse_numeric_minor_component=(value)
        @@parse_numeric_minor_component = value
      end
      alias_method :attr_parse_numeric_minor_component=, :parse_numeric_minor_component=
      
      
      def parse_numeric_service_component
        defined?(@@parse_numeric_service_component) ? @@parse_numeric_service_component : @@parse_numeric_service_component= nil
      end
      alias_method :attr_parse_numeric_service_component, :parse_numeric_service_component
      
      def parse_numeric_service_component=(value)
        @@parse_numeric_service_component = value
      end
      alias_method :attr_parse_numeric_service_component=, :parse_numeric_service_component=
      
      
      def parse_one_element_plugin_version
        defined?(@@parse_one_element_plugin_version) ? @@parse_one_element_plugin_version : @@parse_one_element_plugin_version= nil
      end
      alias_method :attr_parse_one_element_plugin_version, :parse_one_element_plugin_version
      
      def parse_one_element_plugin_version=(value)
        @@parse_one_element_plugin_version = value
      end
      alias_method :attr_parse_one_element_plugin_version=, :parse_one_element_plugin_version=
      
      
      def parse_postive_major
        defined?(@@parse_postive_major) ? @@parse_postive_major : @@parse_postive_major= nil
      end
      alias_method :attr_parse_postive_major, :parse_postive_major
      
      def parse_postive_major=(value)
        @@parse_postive_major = value
      end
      alias_method :attr_parse_postive_major=, :parse_postive_major=
      
      
      def parse_postive_minor
        defined?(@@parse_postive_minor) ? @@parse_postive_minor : @@parse_postive_minor= nil
      end
      alias_method :attr_parse_postive_minor, :parse_postive_minor
      
      def parse_postive_minor=(value)
        @@parse_postive_minor = value
      end
      alias_method :attr_parse_postive_minor=, :parse_postive_minor=
      
      
      def parse_postive_service
        defined?(@@parse_postive_service) ? @@parse_postive_service : @@parse_postive_service= nil
      end
      alias_method :attr_parse_postive_service, :parse_postive_service
      
      def parse_postive_service=(value)
        @@parse_postive_service = value
      end
      alias_method :attr_parse_postive_service=, :parse_postive_service=
      
      
      def parse_separator_end_version
        defined?(@@parse_separator_end_version) ? @@parse_separator_end_version : @@parse_separator_end_version= nil
      end
      alias_method :attr_parse_separator_end_version, :parse_separator_end_version
      
      def parse_separator_end_version=(value)
        @@parse_separator_end_version = value
      end
      alias_method :attr_parse_separator_end_version=, :parse_separator_end_version=
      
      
      def parse_separator_start_version
        defined?(@@parse_separator_start_version) ? @@parse_separator_start_version : @@parse_separator_start_version= nil
      end
      alias_method :attr_parse_separator_start_version, :parse_separator_start_version
      
      def parse_separator_start_version=(value)
        @@parse_separator_start_version = value
      end
      alias_method :attr_parse_separator_start_version=, :parse_separator_start_version=
      
      
      def activator_not_available
        defined?(@@activator_not_available) ? @@activator_not_available : @@activator_not_available= nil
      end
      alias_method :attr_activator_not_available, :activator_not_available
      
      def activator_not_available=(value)
        @@activator_not_available = value
      end
      alias_method :attr_activator_not_available=, :activator_not_available=
      
      when_class_loaded do
        # load message values from bundle file
        reload_messages
      end
      
      typesig { [] }
      def reload_messages
        NLS.initialize_messages(BUNDLE_NAME, CommonMessages)
      end
    }
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__common_messages, :initialize
  end
  
end
