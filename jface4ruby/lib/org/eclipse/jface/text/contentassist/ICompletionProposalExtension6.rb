require "rjava"

# Copyright (c) 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Contentassist
  module ICompletionProposalExtension6Imports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Contentassist
      include_const ::Org::Eclipse::Jface::Viewers, :StyledString
    }
  end
  
  # Extends {@link org.eclipse.jface.text.contentassist.ICompletionProposal} with the following
  # function:
  # <ul>
  # <li>Allow styled ranges in the display string.</li>
  # </ul>
  # 
  # @since 3.4
  module ICompletionProposalExtension6
    include_class_members ICompletionProposalExtension6Imports
    
    typesig { [] }
    # Returns the styled string used to display this proposal in the list of completion proposals.
    # This can for example be used to draw mixed colored labels.
    # <p>
    # <strong>Note:</strong> {@link ICompletionProposal#getDisplayString()} still needs to be
    # correctly implemented as this method might be ignored in case of uninstalled owner draw
    # support.
    # </p>
    # 
    # @return the string builder used to display this proposal
    def get_styled_display_string
      raise NotImplementedError
    end
  end
  
end
