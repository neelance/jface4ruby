require "rjava"

# Copyright (c) 2000, 2005 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Formatter
  module FormattingContextPropertiesImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Formatter
    }
  end
  
  # Keys used by <code>IFormattingContext</code> objects to register specific
  # properties needed during the formatting process of a content formatter
  # implementing <code>IContentFormatterExtension</code>.
  # 
  # @see IFormattingContext
  # @see IFormattingStrategyExtension
  # @see IContentFormatterExtension
  # @since 3.0
  class FormattingContextProperties 
    include_class_members FormattingContextPropertiesImports
    
    class_module.module_eval {
      # Property key of the document property. The property must implement
      # <code>java.lang#Boolean</code>. If set to <code>true</code> the whole
      # document is formatted.
      # <p>
      # Value: <code>"formatting.context.document"</code>
      const_set_lazy(:CONTEXT_DOCUMENT) { "formatting.context.document" }
      const_attr_reader  :CONTEXT_DOCUMENT
      
      # $NON-NLS-1$
      # 
      # Property key of the partition property. The property must implement
      # <code>org.eclipse.jface.text#TypedPosition</code>. The partition
      # a context based formatting strategy should format.
      # <p>
      # Value: <code>"formatting.context.partition"</code>
      const_set_lazy(:CONTEXT_PARTITION) { "formatting.context.partition" }
      const_attr_reader  :CONTEXT_PARTITION
      
      # $NON-NLS-1$
      # 
      # Property key of the preferences property. The property must implement
      # <code>java.util#Map</code>. The formatting preferences mapping preference
      # keys to values.
      # <p>
      # Value: <code>"formatting.context.preferences"</code>
      const_set_lazy(:CONTEXT_PREFERENCES) { "formatting.context.preferences" }
      const_attr_reader  :CONTEXT_PREFERENCES
      
      # $NON-NLS-1$
      # 
      # Property key of the region property. The property must implement <code>org.eclipse.jface.text#IRegion</code>.
      # The region to format. If set, {@link FormattingContextProperties#CONTEXT_DOCUMENT} should be <code>false</code>
      # for this to take effect.
      # <p>
      # Value: <code>"formatting.context.region"</code>
      const_set_lazy(:CONTEXT_REGION) { "formatting.context.region" }
      const_attr_reader  :CONTEXT_REGION
      
      # $NON-NLS-1$
      # 
      # Property key of the medium property. The property must implement <code>org.eclipse.jface.text#IDocument</code>.
      # The document to format.
      # <p>
      # Value: <code>"formatting.context.medium"</code>
      const_set_lazy(:CONTEXT_MEDIUM) { "formatting.context.medium" }
      const_attr_reader  :CONTEXT_MEDIUM
    }
    
    typesig { [] }
    # $NON-NLS-1$
    # 
    # Ensure that this class cannot be instantiated.
    def initialize
    end
    
    private
    alias_method :initialize__formatting_context_properties, :initialize
  end
  
end
