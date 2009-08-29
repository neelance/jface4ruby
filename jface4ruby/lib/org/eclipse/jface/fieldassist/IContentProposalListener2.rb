require "rjava"

# Copyright (c) 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Fieldassist
  module IContentProposalListener2Imports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Fieldassist
    }
  end
  
  # This interface is used to listen to additional notifications from a
  # {@link ContentProposalAdapter}.
  # 
  # @since 3.3
  module IContentProposalListener2
    include_class_members IContentProposalListener2Imports
    
    typesig { [ContentProposalAdapter] }
    # A content proposal popup has been opened for content proposal assistance.
    # 
    # @param adapter
    # the ContentProposalAdapter which is providing content proposal
    # behavior to a control
    def proposal_popup_opened(adapter)
      raise NotImplementedError
    end
    
    typesig { [ContentProposalAdapter] }
    # A content proposal popup has been closed.
    # 
    # @param adapter
    # the ContentProposalAdapter which is providing content proposal
    # behavior to a control
    def proposal_popup_closed(adapter)
      raise NotImplementedError
    end
  end
  
end
