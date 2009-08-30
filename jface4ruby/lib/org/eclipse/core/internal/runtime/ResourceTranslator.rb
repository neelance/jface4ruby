require "rjava"

# Copyright (c) 2003, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Core::Internal::Runtime
  module ResourceTranslatorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Internal::Runtime
      include_const ::Java::Net, :URL
      include_const ::Java::Net, :URLClassLoader
      include ::Java::Util
      include_const ::Org::Eclipse::Osgi::Util, :ManifestElement
      include ::Org::Osgi::Framework
    }
  end
  
  # This class can only be used if OSGi plugin is available.
  class ResourceTranslator 
    include_class_members ResourceTranslatorImports
    
    class_module.module_eval {
      const_set_lazy(:KEY_PREFIX) { "%" }
      const_attr_reader  :KEY_PREFIX
      
      # $NON-NLS-1$
      const_set_lazy(:KEY_DOUBLE_PREFIX) { "%%" }
      const_attr_reader  :KEY_DOUBLE_PREFIX
      
      typesig { [Bundle, String] }
      # $NON-NLS-1$
      def get_resource_string(bundle, value)
        return get_resource_string(bundle, value, nil)
      end
      
      typesig { [Bundle, String, ResourceBundle] }
      def get_resource_string(bundle, value, resource_bundle)
        s = value.trim
        if (!s.starts_with(KEY_PREFIX, 0))
          return s
        end
        if (s.starts_with(KEY_DOUBLE_PREFIX, 0))
          return s.substring(1)
        end
        ix = s.index_of(Character.new(?\s.ord))
        key = (ix).equal?(-1) ? s : s.substring(0, ix)
        dflt = (ix).equal?(-1) ? s : s.substring(ix + 1)
        if ((resource_bundle).nil? && !(bundle).nil?)
          begin
            resource_bundle = get_resource_bundle(bundle)
          rescue MissingResourceException => e
            # just return the default (dflt)
          end
        end
        if ((resource_bundle).nil?)
          return dflt
        end
        begin
          return resource_bundle.get_string(key.substring(1))
        rescue MissingResourceException => e
          # this will avoid requiring a bundle access on the next lookup
          return dflt
        end
      end
      
      typesig { [Bundle] }
      def get_resource_bundle(bundle)
        if (has_runtime21(bundle))
          return ResourceBundle.get_bundle("plugin", Locale.get_default, create_temp_classloader(bundle))
        end # $NON-NLS-1$
        return Activator.get_default.get_localization(bundle, nil)
      end
      
      typesig { [Bundle] }
      def has_runtime21(b)
        begin
          prereqs = ManifestElement.parse_header(Constants::REQUIRE_BUNDLE, b.get_headers("").get(Constants::REQUIRE_BUNDLE)) # $NON-NLS-1$
          if ((prereqs).nil?)
            return false
          end
          i = 0
          while i < prereqs.attr_length
            if (("2.1" == prereqs[i].get_attribute(Constants::BUNDLE_VERSION_ATTRIBUTE)) && ("org.eclipse.core.runtime" == prereqs[i].get_value))
              # $NON-NLS-1$//$NON-NLS-2$
              return true
            end
            i += 1
          end
        rescue BundleException => e
          return false
        end
        return false
      end
      
      typesig { [Bundle] }
      def create_temp_classloader(b)
        classpath = ArrayList.new
        add_classpath_entries(b, classpath)
        add_bundle_root(b, classpath)
        add_dev_entries(b, classpath)
        add_fragments(b, classpath)
        urls = Array.typed(URL).new(classpath.size) { nil }
        return URLClassLoader.new(classpath.to_array(urls))
      end
      
      typesig { [Bundle, ArrayList] }
      def add_fragments(host, classpath)
        activator = Activator.get_default
        if ((activator).nil?)
          return
        end
        fragments = activator.get_fragments(host)
        if ((fragments).nil?)
          return
        end
        i = 0
        while i < fragments.attr_length
          add_classpath_entries(fragments[i], classpath)
          add_dev_entries(fragments[i], classpath)
          i += 1
        end
      end
      
      typesig { [Bundle, ArrayList] }
      def add_classpath_entries(b, classpath)
        classpath_elements = nil
        begin
          classpath_elements = ManifestElement.parse_header(Constants::BUNDLE_CLASSPATH, b.get_headers("").get(Constants::BUNDLE_CLASSPATH)) # $NON-NLS-1$
          if ((classpath_elements).nil?)
            return
          end
          i = 0
          while i < classpath_elements.attr_length
            classpath_entry = b.get_entry(classpath_elements[i].get_value)
            if (!(classpath_entry).nil?)
              classpath.add(classpath_entry)
            end
            i += 1
          end
        rescue BundleException => e
          # ignore
        end
      end
      
      typesig { [Bundle, ArrayList] }
      def add_bundle_root(b, classpath)
        classpath.add(b.get_entry("/")) # $NON-NLS-1$
      end
      
      typesig { [Bundle, ArrayList] }
      def add_dev_entries(b, classpath)
        if (!DevClassPathHelper.in_development_mode)
          return
        end
        binary_paths = DevClassPathHelper.get_dev_class_path(b.get_symbolic_name)
        i = 0
        while i < binary_paths.attr_length
          classpath_entry = b.get_entry(binary_paths[i])
          if (!(classpath_entry).nil?)
            classpath.add(classpath_entry)
          end
          i += 1
        end
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__resource_translator, :initialize
  end
  
end
