require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Preference
  module JFacePreferencesImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Preference
    }
  end
  
  # JFacePreferences is a class used to administer the preferences used by JFace
  # objects.
  class JFacePreferences 
    include_class_members JFacePreferencesImports
    
    class_module.module_eval {
      # Identifier for the Error Color
      const_set_lazy(:ERROR_COLOR) { "ERROR_COLOR" }
      const_attr_reader  :ERROR_COLOR
      
      # $NON-NLS-1$
      # 
      # Identifier for the Hyperlink Color
      const_set_lazy(:HYPERLINK_COLOR) { "HYPERLINK_COLOR" }
      const_attr_reader  :HYPERLINK_COLOR
      
      # $NON-NLS-1$
      # 
      # Identifier for the Active Hyperlink Colour
      const_set_lazy(:ACTIVE_HYPERLINK_COLOR) { "ACTIVE_HYPERLINK_COLOR" }
      const_attr_reader  :ACTIVE_HYPERLINK_COLOR
      
      # $NON-NLS-1$
      # 
      # Identifier for the color used to show extra informations in labels, as a
      # qualified name. For example in 'Foo.txt - myproject/bar', the qualifier
      # is '- myproject/bar'.
      # 
      # @since 3.4
      const_set_lazy(:QUALIFIER_COLOR) { "QUALIFIER_COLOR" }
      const_attr_reader  :QUALIFIER_COLOR
      
      # $NON-NLS-1$
      # 
      # Identifier for the color used to show label decorations For example in
      # 'Foo.txt [1.16]', the decoration is '[1.16]'.
      # 
      # @since 3.4
      const_set_lazy(:DECORATIONS_COLOR) { "DECORATIONS_COLOR" }
      const_attr_reader  :DECORATIONS_COLOR
      
      # $NON-NLS-1$
      # 
      # Identifier for the color used to counter informations For example in
      # 'Foo.txt (2 matches)', the counter information is '(2 matches)'.
      # 
      # @since 3.4
      const_set_lazy(:COUNTER_COLOR) { "COUNTER_COLOR" }
      const_attr_reader  :COUNTER_COLOR
      
      # $NON-NLS-1$
      # 
      # Identifier for the color used for the background of content assist
      # popup dialogs.
      # 
      # @since 3.4
      const_set_lazy(:CONTENT_ASSIST_BACKGROUND_COLOR) { "CONTENT_ASSIST_BACKGROUND_COLOR" }
      const_attr_reader  :CONTENT_ASSIST_BACKGROUND_COLOR
      
      # $NON-NLS-1$
      # 
      # Identifier for the color used for the foreground of content assist
      # popup dialogs.
      # 
      # @since 3.4
      const_set_lazy(:CONTENT_ASSIST_FOREGROUND_COLOR) { "CONTENT_ASSIST_FOREGROUND_COLOR" }
      const_attr_reader  :CONTENT_ASSIST_FOREGROUND_COLOR
      
      # $NON-NLS-1$
      
      def preference_store
        defined?(@@preference_store) ? @@preference_store : @@preference_store= nil
      end
      alias_method :attr_preference_store, :preference_store
      
      def preference_store=(value)
        @@preference_store = value
      end
      alias_method :attr_preference_store=, :preference_store=
    }
    
    typesig { [] }
    # Prevent construction.
    def initialize
    end
    
    class_module.module_eval {
      typesig { [] }
      # Return the preference store for the receiver.
      # 
      # @return IPreferenceStore or null
      def get_preference_store
        return self.attr_preference_store
      end
      
      typesig { [IPreferenceStore] }
      # Set the preference store for the receiver.
      # 
      # @param store
      # IPreferenceStore
      def set_preference_store(store)
        self.attr_preference_store = store
      end
    }
    
    private
    alias_method :initialize__jface_preferences, :initialize
  end
  
end
