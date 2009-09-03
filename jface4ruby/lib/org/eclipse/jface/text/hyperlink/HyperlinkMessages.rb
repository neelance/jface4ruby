require "rjava"

# Copyright (c) 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Hyperlink
  module HyperlinkMessagesImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Hyperlink
      include_const ::Java::Util, :MissingResourceException
      include_const ::Java::Util, :ResourceBundle
    }
  end
  
  # Helper class to get NLSed messages.
  # 
  # @since 3.4
  class HyperlinkMessages 
    include_class_members HyperlinkMessagesImports
    
    class_module.module_eval {
      const_set_lazy(:BUNDLE_NAME) { HyperlinkMessages.get_name }
      const_attr_reader  :BUNDLE_NAME
      
      const_set_lazy(:RESOURCE_BUNDLE) { ResourceBundle.get_bundle(BUNDLE_NAME) }
      const_attr_reader  :RESOURCE_BUNDLE
    }
    
    typesig { [] }
    def initialize
    end
    
    class_module.module_eval {
      typesig { [String] }
      # Gets a string from the resource bundle.
      # 
      # @param key the string used to get the bundle value, must not be
      # <code>null</code>
      # @return the string from the resource bundle
      def get_string(key)
        begin
          return RESOURCE_BUNDLE.get_string(key)
        rescue MissingResourceException => e
          return RJava.cast_to_string(Character.new(?!.ord)) + key + RJava.cast_to_string(Character.new(?!.ord))
        end
      end
    }
    
    private
    alias_method :initialize__hyperlink_messages, :initialize
  end
  
end
