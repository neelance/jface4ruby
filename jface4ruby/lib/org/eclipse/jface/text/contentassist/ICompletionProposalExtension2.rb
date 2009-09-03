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
  module ICompletionProposalExtension2Imports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Contentassist
      include_const ::Org::Eclipse::Jface::Text, :DocumentEvent
      include_const ::Org::Eclipse::Jface::Text, :IDocument
      include_const ::Org::Eclipse::Jface::Text, :ITextViewer
    }
  end
  
  # Extends {@link org.eclipse.jface.text.contentassist.ICompletionProposal}
  # with the following functions:
  # <ul>
  # <li>handling of trigger characters with modifiers</li>
  # <li>visual indication for selection of a proposal</li>
  # </ul>
  # 
  # @since 2.1
  module ICompletionProposalExtension2
    include_class_members ICompletionProposalExtension2Imports
    
    typesig { [ITextViewer, ::Java::Char, ::Java::Int, ::Java::Int] }
    # Applies the proposed completion to the given document. The insertion
    # has been triggered by entering the given character with a modifier at the given offset.
    # This method assumes that {@link #validate(IDocument, int, DocumentEvent)}
    # returns <code>true</code> if called for <code>offset</code>.
    # 
    # @param viewer the text viewer into which to insert the proposed completion
    # @param trigger the trigger to apply the completion
    # @param stateMask the state mask of the modifiers
    # @param offset the offset at which the trigger has been activated
    def apply(viewer, trigger, state_mask, offset)
      raise NotImplementedError
    end
    
    typesig { [ITextViewer, ::Java::Boolean] }
    # Called when the proposal is selected.
    # 
    # @param viewer the text viewer.
    # @param smartToggle the smart toggle key was pressed
    def selected(viewer, smart_toggle)
      raise NotImplementedError
    end
    
    typesig { [ITextViewer] }
    # Called when the proposal is unselected.
    # 
    # @param viewer the text viewer.
    def unselected(viewer)
      raise NotImplementedError
    end
    
    typesig { [IDocument, ::Java::Int, DocumentEvent] }
    # Requests the proposal to be validated with respect to the document event.
    # If the proposal cannot be validated, the methods returns <code>false</code>.
    # If the document event was <code>null</code>, only the caret offset was changed, but not the document.
    # 
    # This method replaces {@link ICompletionProposalExtension#isValidFor(IDocument, int)}
    # 
    # @param document the document
    # @param offset the caret offset
    # @param event the document event, may be <code>null</code>
    # @return boolean
    def validate(document, offset, event)
      raise NotImplementedError
    end
  end
  
end
