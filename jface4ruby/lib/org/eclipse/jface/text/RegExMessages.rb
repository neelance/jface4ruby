require "rjava"

# Copyright (c) 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text
  module RegExMessagesImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
      include_const ::Java::Util, :MissingResourceException
      include_const ::Java::Util, :ResourceBundle
    }
  end
  
  # RegEx messages. Helper class to get NLSed messages.
  # 
  # @since 3.4
  class RegExMessages 
    include_class_members RegExMessagesImports
    
    class_module.module_eval {
      const_set_lazy(:RESOURCE_BUNDLE) { RegExMessages.get_name }
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
      # Do not instantiate
    end
    
    class_module.module_eval {
      typesig { [String] }
      def get_string(key)
        begin
          return self.attr_fg_resource_bundle.get_string(key)
        rescue MissingResourceException => e
          return "!" + key + "!" # $NON-NLS-2$ //$NON-NLS-1$
        end
      end
    }
    
    private
    alias_method :initialize__reg_ex_messages, :initialize
  end
  
end
