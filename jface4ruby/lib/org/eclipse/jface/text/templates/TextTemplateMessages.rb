require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Templates
  module TextTemplateMessagesImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Templates
      include_const ::Java::Util, :MissingResourceException
      include_const ::Java::Util, :ResourceBundle
      include_const ::Com::Ibm::Icu::Text, :MessageFormat
    }
  end
  
  # @since 3.0
  class TextTemplateMessages 
    include_class_members TextTemplateMessagesImports
    
    class_module.module_eval {
      const_set_lazy(:RESOURCE_BUNDLE) { TextTemplateMessages.get_name }
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
      def get_string(key)
        begin
          return self.attr_fg_resource_bundle.get_string(key)
        rescue MissingResourceException => e
          return RJava.cast_to_string(Character.new(?!.ord)) + key + RJava.cast_to_string(Character.new(?!.ord))
        end
      end
      
      typesig { [String, Object] }
      def get_formatted_string(key, arg)
        return MessageFormat.format(get_string(key), Array.typed(Object).new([arg]))
      end
      
      typesig { [String, Array.typed(Object)] }
      def get_formatted_string(key, args)
        return MessageFormat.format(get_string(key), args)
      end
    }
    
    private
    alias_method :initialize__text_template_messages, :initialize
  end
  
end
