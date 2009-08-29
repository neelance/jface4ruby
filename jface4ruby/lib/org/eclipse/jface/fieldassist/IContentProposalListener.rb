require "rjava"

# Copyright (c) 2005 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Fieldassist
  module IContentProposalListenerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Fieldassist
    }
  end
  
  # This interface is used to listen to notifications from a
  # {@link ContentProposalAdapter}.
  # 
  # @since 3.2
  module IContentProposalListener
    include_class_members IContentProposalListenerImports
    
    typesig { [IContentProposal] }
    # A content proposal has been accepted.
    # 
    # @param proposal
    # the accepted content proposal
    def proposal_accepted(proposal)
      raise NotImplementedError
    end
  end
  
end
