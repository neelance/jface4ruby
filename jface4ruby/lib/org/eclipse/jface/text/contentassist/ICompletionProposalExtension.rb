require "rjava"

# Copyright (c) 2000, 2005 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Contentassist
  module ICompletionProposalExtensionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Contentassist
      include_const ::Org::Eclipse::Jface::Text, :IDocument
    }
  end
  
  # Extends {@link org.eclipse.jface.text.contentassist.ICompletionProposal}
  # with the following functions:
  # <ul>
  # <li>handling of trigger characters other than ENTER</li>
  # <li>completion proposal validation for a given offset</li>
  # <li>context information can be freely positioned</li>
  # </ul>
  # 
  # @since 2.0
  module ICompletionProposalExtension
    include_class_members ICompletionProposalExtensionImports
    
    typesig { [IDocument, ::Java::Char, ::Java::Int] }
    # Applies the proposed completion to the given document. The insertion
    # has been triggered by entering the given character at the given offset.
    # This method assumes that {@link #isValidFor(IDocument, int)} returns
    # <code>true</code> if called for <code>offset</code>.
    # 
    # @param document the document into which to insert the proposed completion
    # @param trigger the trigger to apply the completion
    # @param offset the offset at which the trigger has been activated
    def apply(document, trigger, offset)
      raise NotImplementedError
    end
    
    typesig { [IDocument, ::Java::Int] }
    # Returns whether this completion proposal is valid for the given
    # position in the given document.
    # 
    # @param document the document for which the proposal is tested
    # @param offset the offset for which the proposal is tested
    # @return <code>true</code> iff valid
    def is_valid_for(document, offset)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the characters which trigger the application of this completion proposal.
    # 
    # @return the completion characters for this completion proposal or <code>null</code>
    # if no completion other than the new line character is possible
    def get_trigger_characters
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the position to which the computed context information refers to or
    # <code>-1</code> if no context information can be provided by this completion proposal.
    # 
    # @return the position to which the context information refers to or <code>-1</code> for no information
    def get_context_information_position
      raise NotImplementedError
    end
  end
  
end
