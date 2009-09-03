require "rjava"

# Copyright (c) 2006, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Source
  module IAnnotationAccessExtension2Imports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Source
      include_const ::Org::Eclipse::Jface::Text::Quickassist, :IQuickAssistAssistant
    }
  end
  
  # Extension interface for {@link org.eclipse.jface.text.source.IAnnotationAccess}.<p>
  # This interface allows clients to set a quick assist assistant.
  # 
  # @see org.eclipse.jface.text.source.IAnnotationAccess
  # @since 3.2
  module IAnnotationAccessExtension2
    include_class_members IAnnotationAccessExtension2Imports
    
    typesig { [IQuickAssistAssistant] }
    # Provides this annotation access with a quick assist assistant that
    # is used to decide whether the quick fix image should be shown.
    # 
    # @param assistant the quick assist assistant
    def set_quick_assist_assistant(assistant)
      raise NotImplementedError
    end
  end
  
end
