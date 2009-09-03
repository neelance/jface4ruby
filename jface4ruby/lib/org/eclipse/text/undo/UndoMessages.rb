require "rjava"

# Copyright (c) 2006, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Text::Undo
  module UndoMessagesImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Text::Undo
      include_const ::Java::Util, :MissingResourceException
      include_const ::Java::Util, :ResourceBundle
      include_const ::Com::Ibm::Icu::Text, :MessageFormat
    }
  end
  
  # Helper class to get NLSed messages.
  # 
  # @since 3.2
  class UndoMessages 
    include_class_members UndoMessagesImports
    
    class_module.module_eval {
      const_set_lazy(:BUNDLE_NAME) { "org.eclipse.text.undo.UndoMessages" }
      const_attr_reader  :BUNDLE_NAME
      
      # $NON-NLS-1$
      const_set_lazy(:RESOURCE_BUNDLE) { ResourceBundle.get_bundle(BUNDLE_NAME) }
      const_attr_reader  :RESOURCE_BUNDLE
    }
    
    typesig { [] }
    def initialize
    end
    
    class_module.module_eval {
      typesig { [String] }
      def get_string(key)
        begin
          return RESOURCE_BUNDLE.get_string(key)
        rescue MissingResourceException => e
          return RJava.cast_to_string(Character.new(?!.ord)) + key + RJava.cast_to_string(Character.new(?!.ord))
        end
      end
      
      typesig { [String, Object] }
      def get_formatted_string(key, arg)
        return get_formatted_string(key, Array.typed(Object).new([arg]))
      end
      
      typesig { [String, Array.typed(Object)] }
      def get_formatted_string(key, args)
        return MessageFormat.format(get_string(key), args)
      end
    }
    
    private
    alias_method :initialize__undo_messages, :initialize
  end
  
end
