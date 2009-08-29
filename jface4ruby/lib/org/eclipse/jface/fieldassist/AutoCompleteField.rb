require "rjava"

# Copyright (c) 2006, 2007 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Fieldassist
  module AutoCompleteFieldImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Fieldassist
      include_const ::Org::Eclipse::Swt::Widgets, :Control
    }
  end
  
  # AutoCompleteField is a class which attempts to auto-complete a user's
  # keystrokes by activating a popup that filters a list of proposals according
  # to the content typed by the user.
  # 
  # @see ContentProposalAdapter
  # @see SimpleContentProposalProvider
  # 
  # @since 3.3
  class AutoCompleteField 
    include_class_members AutoCompleteFieldImports
    
    attr_accessor :proposal_provider
    alias_method :attr_proposal_provider, :proposal_provider
    undef_method :proposal_provider
    alias_method :attr_proposal_provider=, :proposal_provider=
    undef_method :proposal_provider=
    
    attr_accessor :adapter
    alias_method :attr_adapter, :adapter
    undef_method :adapter
    alias_method :attr_adapter=, :adapter=
    undef_method :adapter=
    
    typesig { [Control, IControlContentAdapter, Array.typed(String)] }
    # Construct an AutoComplete field on the specified control, whose
    # completions are characterized by the specified array of Strings.
    # 
    # @param control
    # the control for which autocomplete is desired. May not be
    # <code>null</code>.
    # @param controlContentAdapter
    # the <code>IControlContentAdapter</code> used to obtain and
    # update the control's contents. May not be <code>null</code>.
    # @param proposals
    # the array of Strings representing valid content proposals for
    # the field.
    def initialize(control, control_content_adapter, proposals)
      @proposal_provider = nil
      @adapter = nil
      @proposal_provider = SimpleContentProposalProvider.new(proposals)
      @proposal_provider.set_filtering(true)
      @adapter = ContentProposalAdapter.new(control, control_content_adapter, @proposal_provider, nil, nil)
      @adapter.set_propagate_keys(true)
      @adapter.set_proposal_acceptance_style(ContentProposalAdapter::PROPOSAL_REPLACE)
    end
    
    typesig { [Array.typed(String)] }
    # Set the Strings to be used as content proposals.
    # 
    # @param proposals
    # the array of Strings to be used as proposals.
    def set_proposals(proposals)
      @proposal_provider.set_proposals(proposals)
    end
    
    private
    alias_method :initialize__auto_complete_field, :initialize
  end
  
end
