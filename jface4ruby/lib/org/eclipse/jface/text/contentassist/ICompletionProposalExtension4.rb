require "rjava"

# Copyright (c) 2005, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Contentassist
  module ICompletionProposalExtension4Imports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Contentassist
    }
  end
  
  # Extends
  # {@link org.eclipse.jface.text.contentassist.ICompletionProposal} with
  # the following functions:
  # <ul>
  # <li>specify whether a proposal is automatically insertable</li>
  # </ul>
  # 
  # @since 3.1
  module ICompletionProposalExtension4
    include_class_members ICompletionProposalExtension4Imports
    
    typesig { [] }
    # Returns <code>true</code> if the proposal may be automatically
    # inserted, <code>false</code> otherwise. Automatic insertion can
    # happen if the proposal is the only one being proposed, in which
    # case the content assistant may decide to not prompt the user with
    # a list of proposals, but simply insert the single proposal. A
    # proposal may veto this behavior by returning <code>false</code>
    # to a call to this method.
    # 
    # @return <code>true</code> if the proposal may be inserted
    # automatically, <code>false</code> if not
    def is_auto_insertable
      raise NotImplementedError
    end
  end
  
end
