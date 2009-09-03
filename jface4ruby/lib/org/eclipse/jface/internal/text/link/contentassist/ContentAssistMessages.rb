require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Internal::Text::Link::Contentassist
  module ContentAssistMessagesImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Internal::Text::Link::Contentassist
      include_const ::Java::Util, :MissingResourceException
      include_const ::Java::Util, :ResourceBundle
      include_const ::Com::Ibm::Icu::Text, :MessageFormat
    }
  end
  
  # Helper class to get NLSed messages.
  # 
  # @since 3.0
  class ContentAssistMessages 
    include_class_members ContentAssistMessagesImports
    
    class_module.module_eval {
      const_set_lazy(:RESOURCE_BUNDLE) { ContentAssistMessages.get_name }
      const_attr_reader  :RESOURCE_BUNDLE
      
      
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
    def initialize
    end
    
    class_module.module_eval {
      typesig { [String] }
      # Gets a string from the resource bundle.
      # 
      # @param key the string used to get the bundle value, must not be null
      # @return the string from the resource bundle
      def get_string(key)
        begin
          return self.attr_fg_resource_bundle.get_string(key)
        rescue MissingResourceException => e
          return "!" + key + "!" # $NON-NLS-2$ //$NON-NLS-1$
        end
      end
      
      typesig { [String, Array.typed(Object)] }
      # Gets a string from the resource bundle and formats it with the given arguments.
      # 
      # @param key the string used to get the bundle value, must not be null
      # @param args the arguments used to format the string
      # @return the formatted string
      def get_formatted_string(key, args)
        format = nil
        begin
          format = RJava.cast_to_string(self.attr_fg_resource_bundle.get_string(key))
        rescue MissingResourceException => e
          return "!" + key + "!" # $NON-NLS-2$ //$NON-NLS-1$
        end
        return MessageFormat.format(format, args)
      end
      
      typesig { [String, Object] }
      # Gets a string from the resource bundle and formats it with the given argument.
      # 
      # @param key the string used to get the bundle value, must not be null
      # @param arg the argument used to format the string
      # @return the formatted string
      def get_formatted_string(key, arg)
        format_ = nil
        begin
          format_ = RJava.cast_to_string(self.attr_fg_resource_bundle.get_string(key))
        rescue MissingResourceException => e
          return "!" + key + "!" # $NON-NLS-2$ //$NON-NLS-1$
        end
        if ((arg).nil?)
          arg = ""
        end # $NON-NLS-1$
        return MessageFormat.format(format_, Array.typed(Object).new([arg]))
      end
    }
    
    private
    alias_method :initialize__content_assist_messages, :initialize
  end
  
end
