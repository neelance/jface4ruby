require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Quickassist
  module IQuickAssistInvocationContextImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Quickassist
      include_const ::Org::Eclipse::Jface::Text::Source, :ISourceViewer
    }
  end
  
  # Context information for quick fix and quick assist processors.
  # <p>
  # This interface can be implemented by clients.</p>
  # 
  # @since 3.2
  module IQuickAssistInvocationContext
    include_class_members IQuickAssistInvocationContextImports
    
    typesig { [] }
    # Returns the offset where quick assist was invoked.
    # 
    # @return the invocation offset or <code>-1</code> if unknown
    def get_offset
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the length of the selection at the invocation offset.
    # 
    # @return the length of the current selection or <code>-1</code> if none or unknown
    def get_length
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the viewer for this context.
    # 
    # @return the viewer or <code>null</code> if not available
    def get_source_viewer
      raise NotImplementedError
    end
  end
  
end
