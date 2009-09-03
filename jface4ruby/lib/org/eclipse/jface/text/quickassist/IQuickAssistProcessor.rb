require "rjava"

# Copyright (c) 2006, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Quickassist
  module IQuickAssistProcessorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Quickassist
      include_const ::Org::Eclipse::Jface::Text::Contentassist, :ICompletionProposal
      include_const ::Org::Eclipse::Jface::Text::Source, :Annotation
    }
  end
  
  # Quick assist processor for quick fixes and quick assists.
  # <p>
  # A processor can provide just quick fixes, just quick assists
  # or both.
  # </p>
  # <p>
  # This interface can be implemented by clients.</p>
  # 
  # @since 3.2
  module IQuickAssistProcessor
    include_class_members IQuickAssistProcessorImports
    
    typesig { [] }
    # Returns the reason why this quick assist processor
    # was unable to produce any completion proposals.
    # 
    # @return an error message or <code>null</code> if no error occurred
    def get_error_message
      raise NotImplementedError
    end
    
    typesig { [Annotation] }
    # Tells whether this processor has a fix for the given annotation.
    # <p>
    # <strong>Note:</strong> This test must be fast and optimistic i.e. it is OK to return
    # <code>true</code> even though there might be no quick fix.
    # </p>
    # 
    # @param annotation the annotation
    # @return <code>true</code> if the assistant has a fix for the given annotation
    def can_fix(annotation)
      raise NotImplementedError
    end
    
    typesig { [IQuickAssistInvocationContext] }
    # Tells whether this assistant has assists for the given invocation context.
    # 
    # @param invocationContext the invocation context
    # @return <code>true</code> if the assistant has a fix for the given annotation
    def can_assist(invocation_context)
      raise NotImplementedError
    end
    
    typesig { [IQuickAssistInvocationContext] }
    # Returns a list of quick assist and quick fix proposals for the
    # given invocation context.
    # 
    # @param invocationContext the invocation context
    # @return an array of completion proposals or <code>null</code> if no proposals are available
    def compute_quick_assist_proposals(invocation_context)
      raise NotImplementedError
    end
  end
  
end
