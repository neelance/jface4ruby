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
  module DevClassPathHelperImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Internal::Runtime
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :InputStream
      include_const ::Java::Net, :MalformedURLException
      include_const ::Java::Net, :URL
      include ::Java::Util
    }
  end
  
  class DevClassPathHelper 
    include_class_members DevClassPathHelperImports
    
    class_module.module_eval {
      # command line options
      const_set_lazy(:PROP_DEV) { "osgi.dev" }
      const_attr_reader  :PROP_DEV
      
      # $NON-NLS-1$
      
      def in_development_mode
        defined?(@@in_development_mode) ? @@in_development_mode : @@in_development_mode= false
      end
      alias_method :attr_in_development_mode, :in_development_mode
      
      def in_development_mode=(value)
        @@in_development_mode = value
      end
      alias_method :attr_in_development_mode=, :in_development_mode=
      
      
      def dev_default_classpath
        defined?(@@dev_default_classpath) ? @@dev_default_classpath : @@dev_default_classpath= nil
      end
      alias_method :attr_dev_default_classpath, :dev_default_classpath
      
      def dev_default_classpath=(value)
        @@dev_default_classpath = value
      end
      alias_method :attr_dev_default_classpath=, :dev_default_classpath=
      
      
      def dev_properties
        defined?(@@dev_properties) ? @@dev_properties : @@dev_properties= nil
      end
      alias_method :attr_dev_properties, :dev_properties
      
      def dev_properties=(value)
        @@dev_properties = value
      end
      alias_method :attr_dev_properties=, :dev_properties=
      
      when_class_loaded do
        # Check the osgi.dev property to see if dev classpath entries have been defined.
        osgi_dev = (Activator.get_context).nil? ? System.get_property(PROP_DEV) : Activator.get_context.get_property(PROP_DEV)
        if (!(osgi_dev).nil?)
          begin
            self.attr_in_development_mode = true
            location = URL.new(osgi_dev)
            self.attr_dev_properties = load(location)
            if (!(self.attr_dev_properties).nil?)
              self.attr_dev_default_classpath = get_array_from_list(self.attr_dev_properties.get_property("*"))
            end # $NON-NLS-1$
          rescue MalformedURLException => e
            self.attr_dev_default_classpath = get_array_from_list(osgi_dev)
          end
        end
      end
      
      typesig { [String] }
      def get_dev_class_path(id)
        result = nil
        if (!(id).nil? && !(self.attr_dev_properties).nil?)
          entry = self.attr_dev_properties.get_property(id)
          if (!(entry).nil?)
            result = get_array_from_list(entry)
          end
        end
        if ((result).nil?)
          result = self.attr_dev_default_classpath
        end
        return result
      end
      
      typesig { [String] }
      # Returns the result of converting a list of comma-separated tokens into an array
      # 
      # @return the array of string tokens
      # @param prop the initial comma-separated string
      def get_array_from_list(prop)
        if ((prop).nil? || (prop.trim == ""))
          # $NON-NLS-1$
          return Array.typed(String).new(0) { nil }
        end
        list = Vector.new
        tokens = StringTokenizer.new(prop, ",") # $NON-NLS-1$
        while (tokens.has_more_tokens)
          token = tokens.next_token.trim
          if (!(token == ""))
            # $NON-NLS-1$
            list.add_element(token)
          end
        end
        return list.is_empty ? Array.typed(String).new(0) { nil } : list.to_array(Array.typed(String).new(list.size) { nil })
      end
      
      typesig { [] }
      def in_development_mode
        return self.attr_in_development_mode
      end
      
      typesig { [URL] }
      # Load the given properties file
      def load(url)
        props = Properties.new
        begin
          is = nil
          begin
            is = url.open_stream
            props.load(is)
          ensure
            if (!(is).nil?)
              is.close
            end
          end
        rescue IOException => e
          # TODO consider logging here
        end
        return props
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__dev_class_path_helper, :initialize
  end
  
end
