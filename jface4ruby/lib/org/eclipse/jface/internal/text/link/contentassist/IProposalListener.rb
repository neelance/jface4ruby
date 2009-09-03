require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Internal::Text::Link::Contentassist
  module IProposalListenerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Internal::Text::Link::Contentassist
      include_const ::Org::Eclipse::Jface::Text::Contentassist, :ICompletionProposal
    }
  end
  
  module IProposalListener
    include_class_members IProposalListenerImports
    
    typesig { [ICompletionProposal] }
    # @param proposal the completion proposal
    def proposal_chosen(proposal)
      raise NotImplementedError
    end
  end
  
end
