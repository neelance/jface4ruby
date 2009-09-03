require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Source
  module JFaceTextMessagesImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Source
      include_const ::Java::Util, :MissingResourceException
      include_const ::Java::Util, :ResourceBundle
      include_const ::Com::Ibm::Icu::Text, :MessageFormat
    }
  end
  
  # Accessor for the <code>JFaceTextMessages.properties</code> file in
  # package <code>org.eclipse.jface.text</code>.
  # @since 2.0
  class JFaceTextMessages 
    include_class_members JFaceTextMessagesImports
    
    class_module.module_eval {
      # The resource bundle name.
      const_set_lazy(:RESOURCE_BUNDLE) { "org.eclipse.jface.text.JFaceTextMessages" }
      const_attr_reader  :RESOURCE_BUNDLE
      
      # $NON-NLS-1$
      # The resource bundle.
      
      def fg_resource_bundle
        defined?(@@fg_resource_bundle) ? @@fg_resource_bundle : @@fg_resource_bundle= ResourceBundle.get_bundle(RESOURCE_BUNDLE)
      end
      alias_method :attr_fg_resource_bundle, :fg_resource_bundle
      
      def fg_resource_bundle=(value)
        @@fg_resource_bundle = value
      end
      alias_method :attr_fg_resource_bundle=, :fg_resource_bundle=
    }
    
    typesig { [] }
    # Prohibits the creation of accessor objects.
    def initialize
    end
    
    class_module.module_eval {
      typesig { [String] }
      # Returns the string found in the resource bundle under the given key or a place holder string.
      # 
      # @param key the look up key
      # @return the value found under the given key
      def get_string(key)
        begin
          return self.attr_fg_resource_bundle.get_string(key)
        rescue MissingResourceException => e
          return "!" + key + "!" # $NON-NLS-2$ //$NON-NLS-1$
        end
      end
      
      typesig { [String, Array.typed(Object)] }
      # Gets a string from the resource bundle and formats it with the argument
      # 
      # @param key	the string used to get the bundle value, must not be null
      # @param args arguments used when formatting the string
      # @return the formatted string
      # @since 3.0
      def get_formatted_string(key, args)
        format = nil
        begin
          format = RJava.cast_to_string(self.attr_fg_resource_bundle.get_string(key))
        rescue MissingResourceException => e
          return "!" + key + "!" # $NON-NLS-2$ //$NON-NLS-1$
        end
        return MessageFormat.format(format, args)
      end
    }
    
    private
    alias_method :initialize__jface_text_messages, :initialize
  end
  
end
