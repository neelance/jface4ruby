require "rjava"

# Copyright (c) 2006, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Contentassist
  module ICompletionProposalExtension5Imports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Contentassist
      include_const ::Org::Eclipse::Core::Runtime, :IProgressMonitor
    }
  end
  
  # Extends {@link org.eclipse.jface.text.contentassist.ICompletionProposal} with the following
  # function:
  # <ul>
  # <li>Allow background computation of the additional info.</li>
  # </ul>
  # 
  # @since 3.2
  module ICompletionProposalExtension5
    include_class_members ICompletionProposalExtension5Imports
    
    typesig { [IProgressMonitor] }
    # Returns additional information about the proposal. The additional information will be
    # presented to assist the user in deciding if the selected proposal is the desired choice.
    # <p>
    # This method may be called on a non-UI thread.
    # </p>
    # <p>
    # By default, the returned information is converted to a string and displayed as text; if
    # {@link ICompletionProposalExtension3#getInformationControlCreator()} is implemented, the
    # information will be passed to a custom information control for display.
    # </p>
    # 
    # @param monitor a monitor to report progress and to watch for
    # {@link IProgressMonitor#isCanceled() cancelation}.
    # @return the additional information, <code>null</code> for no information
    def get_additional_proposal_info(monitor)
      raise NotImplementedError
    end
  end
  
end
