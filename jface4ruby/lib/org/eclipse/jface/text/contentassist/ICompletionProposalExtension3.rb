require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Contentassist
  module ICompletionProposalExtension3Imports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Contentassist
      include_const ::Org::Eclipse::Jface::Text, :IDocument
      include_const ::Org::Eclipse::Jface::Text, :IInformationControlCreator
    }
  end
  
  # Extends {@link org.eclipse.jface.text.contentassist.ICompletionProposal}
  # with the following functions:
  # <ul>
  # <li>provision of a custom information control creator</li>
  # <li>provide a custom completion text and offset for prefix completion</li>
  # </ul>
  # 
  # @since 3.0
  module ICompletionProposalExtension3
    include_class_members ICompletionProposalExtension3Imports
    
    typesig { [] }
    # Returns the information control creator of this completion proposal.
    # 
    # @return the information control creator, or <code>null</code> if no custom control creator is available
    def get_information_control_creator
      raise NotImplementedError
    end
    
    typesig { [IDocument, ::Java::Int] }
    # Returns the string that would be inserted at the position returned from
    # {@link #getPrefixCompletionStart(IDocument, int)} if this proposal was
    # applied. If the replacement string cannot be determined,
    # <code>null</code> may be returned.
    # 
    # @param document the document that the receiver applies to
    # @param completionOffset the offset into <code>document</code> where the
    # completion takes place
    # @return the replacement string or <code>null</code> if it cannot be
    # determined
    def get_prefix_completion_text(document, completion_offset)
      raise NotImplementedError
    end
    
    typesig { [IDocument, ::Java::Int] }
    # Returns the document offset at which the receiver would insert its
    # proposal.
    # 
    # @param document the document that the receiver applies to
    # @param completionOffset the offset into <code>document</code> where the
    # completion takes place
    # @return the offset at which the proposal would insert its proposal
    def get_prefix_completion_start(document, completion_offset)
      raise NotImplementedError
    end
  end
  
end
