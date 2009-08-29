require "rjava"

# Copyright (c) 2005, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Fieldassist
  module IContentProposalImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Fieldassist
    }
  end
  
  # IContentProposal describes a content proposal to be shown. It consists of the
  # content that will be provided if the proposal is accepted, an optional label
  # used to describe the content to the user, and an optional description that
  # further elaborates the meaning of the proposal.
  # 
  # @since 3.2
  module IContentProposal
    include_class_members IContentProposalImports
    
    typesig { [] }
    # Return the content represented by this proposal.
    # 
    # @return the String content represented by this proposal.
    def get_content
      raise NotImplementedError
    end
    
    typesig { [] }
    # Return the integer position within the contents that the cursor should be
    # placed after the proposal is accepted.
    # 
    # @return the zero-based index position within the contents where the
    # cursor should be placed after the proposal is accepted.
    def get_cursor_position
      raise NotImplementedError
    end
    
    typesig { [] }
    # Return the label used to describe this proposal.
    # 
    # @return the String label used to display the proposal. If
    # <code>null</code>, then the content will be displayed as the
    # label.
    def get_label
      raise NotImplementedError
    end
    
    typesig { [] }
    # Return a description that describes this proposal.
    # 
    # @return the String label used to further the proposal. If
    # <code>null</code>, then no description will be displayed.
    def get_description
      raise NotImplementedError
    end
  end
  
end
