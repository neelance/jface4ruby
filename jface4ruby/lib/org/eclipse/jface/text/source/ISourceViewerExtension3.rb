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
  module ISourceViewerExtension3Imports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Source
      include_const ::Org::Eclipse::Jface::Text::Quickassist, :IQuickAssistAssistant
      include_const ::Org::Eclipse::Jface::Text::Quickassist, :IQuickAssistInvocationContext
    }
  end
  
  # Extension interface for {@link org.eclipse.jface.text.source.ISourceViewer}.<p>
  # It introduces the concept of a quick assist assistant and provides access
  # to the quick assist invocation context. It also gives access to any currently
  # showing annotation hover.</p>
  # 
  # @see IQuickAssistAssistant
  # @see IQuickAssistInvocationContext
  # @since 3.2
  module ISourceViewerExtension3
    include_class_members ISourceViewerExtension3Imports
    
    typesig { [] }
    # Returns this viewers quick assist assistant.
    # 
    # @return the quick assist assistant or <code>null</code> if none is configured
    # @since 3.2
    def get_quick_assist_assistant
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns this viewer's quick assist invocation context.
    # 
    # @return the quick assist invocation context or <code>null</code> if none is available
    def get_quick_assist_invocation_context
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the currently displayed annotation hover if any, <code>null</code> otherwise.
    # 
    # @return the currently displayed annotation hover or <code>null</code>
    def get_current_annotation_hover
      raise NotImplementedError
    end
  end
  
end
