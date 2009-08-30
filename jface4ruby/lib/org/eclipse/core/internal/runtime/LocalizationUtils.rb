require "rjava"

# Copyright (c) 2006, 2007 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Core::Internal::Runtime
  module LocalizationUtilsImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Internal::Runtime
      include_const ::Java::Lang::Reflect, :Field
    }
  end
  
  # Helper methods related to string localization.
  # 
  # @since org.eclipse.equinox.common 3.3
  class LocalizationUtils 
    include_class_members LocalizationUtilsImports
    
    class_module.module_eval {
      typesig { [String] }
      # This method can be used in the absence of NLS class. The method tries to
      # use the NLS-based translation routine. If it falls, the method returns the original
      # non-translated key.
      # 
      # @param key case-sensitive name of the filed in the translation file representing
      # the string to be translated
      # @return The localized message or the non-translated key
      def safe_localize(key)
        begin
          message_class = Class.for_name("org.eclipse.core.internal.runtime.CommonMessages") # $NON-NLS-1$
          if ((message_class).nil?)
            return key
          end
          field = message_class.get_declared_field(key)
          if ((field).nil?)
            return key
          end
          value = field.get(nil)
          if (value.is_a?(String))
            return value
          end
        rescue ClassNotFoundException => e
          # eat exception and fall through
        rescue NoClassDefFoundError => e
          # eat exception and fall through
        rescue SecurityException => e
          # eat exception and fall through
        rescue NoSuchFieldException => e
          # eat exception and fall through
        rescue IllegalArgumentException => e
          # eat exception and fall through
        rescue IllegalAccessException => e
          # eat exception and fall through
        end
        return key
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__localization_utils, :initialize
  end
  
end
