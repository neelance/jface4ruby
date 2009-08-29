require "rjava"

# Copyright (c) 2005, 2007 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
# Amir Kouchekinia <amir@pyrus.us> - bug 200762
module Org::Eclipse::Jface::Fieldassist
  module SimpleContentProposalProviderImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Fieldassist
      include_const ::Java::Util, :ArrayList
    }
  end
  
  # SimpleContentProposalProvider is a class designed to map a static list of
  # Strings to content proposals.
  # 
  # @see IContentProposalProvider
  # @since 3.2
  class SimpleContentProposalProvider 
    include_class_members SimpleContentProposalProviderImports
    include IContentProposalProvider
    
    # The proposals provided.
    attr_accessor :proposals
    alias_method :attr_proposals, :proposals
    undef_method :proposals
    alias_method :attr_proposals=, :proposals=
    undef_method :proposals=
    
    # The proposals mapped to IContentProposal. Cached for speed in the case
    # where filtering is not used.
    attr_accessor :content_proposals
    alias_method :attr_content_proposals, :content_proposals
    undef_method :content_proposals
    alias_method :attr_content_proposals=, :content_proposals=
    undef_method :content_proposals=
    
    # Boolean that tracks whether filtering is used.
    attr_accessor :filter_proposals
    alias_method :attr_filter_proposals, :filter_proposals
    undef_method :filter_proposals
    alias_method :attr_filter_proposals=, :filter_proposals=
    undef_method :filter_proposals=
    
    typesig { [Array.typed(String)] }
    # Construct a SimpleContentProposalProvider whose content proposals are
    # always the specified array of Objects.
    # 
    # @param proposals
    # the array of Strings to be returned whenever proposals are
    # requested.
    def initialize(proposals)
      @proposals = nil
      @content_proposals = nil
      @filter_proposals = false
      @proposals = proposals
    end
    
    typesig { [String, ::Java::Int] }
    # Return an array of Objects representing the valid content proposals for a
    # field.
    # 
    # @param contents
    # the current contents of the field (only consulted if filtering
    # is set to <code>true</code>)
    # @param position
    # the current cursor position within the field (ignored)
    # @return the array of Objects that represent valid proposals for the field
    # given its current content.
    def get_proposals(contents, position)
      if (@filter_proposals)
        list = ArrayList.new
        i = 0
        while i < @proposals.attr_length
          if (@proposals[i].length >= contents.length && @proposals[i].substring(0, contents.length).equals_ignore_case(contents))
            list.add(make_content_proposal(@proposals[i]))
          end
          i += 1
        end
        return list.to_array(Array.typed(IContentProposal).new(list.size) { nil })
      end
      if ((@content_proposals).nil?)
        @content_proposals = Array.typed(IContentProposal).new(@proposals.attr_length) { nil }
        i = 0
        while i < @proposals.attr_length
          @content_proposals[i] = make_content_proposal(@proposals[i])
          i += 1
        end
      end
      return @content_proposals
    end
    
    typesig { [Array.typed(String)] }
    # Set the Strings to be used as content proposals.
    # 
    # @param items
    # the array of Strings to be used as proposals.
    def set_proposals(items)
      @proposals = items
      @content_proposals = nil
    end
    
    typesig { [::Java::Boolean] }
    # Set the boolean that controls whether proposals are filtered according to
    # the current field content.
    # 
    # @param filterProposals
    # <code>true</code> if the proposals should be filtered to
    # show only those that match the current contents of the field,
    # and <code>false</code> if the proposals should remain the
    # same, ignoring the field content.
    # @since 3.3
    def set_filtering(filter_proposals)
      @filter_proposals = filter_proposals
      # Clear any cached proposals.
      @content_proposals = nil
    end
    
    typesig { [String] }
    # Make an IContentProposal for showing the specified String.
    def make_content_proposal(proposal)
      return Class.new(IContentProposal.class == Class ? IContentProposal : Object) do
        extend LocalClass
        include_class_members SimpleContentProposalProvider
        include IContentProposal if IContentProposal.class == Module
        
        typesig { [] }
        define_method :get_content do
          return proposal
        end
        
        typesig { [] }
        define_method :get_description do
          return nil
        end
        
        typesig { [] }
        define_method :get_label do
          return nil
        end
        
        typesig { [] }
        define_method :get_cursor_position do
          return proposal.length
        end
        
        typesig { [] }
        define_method :initialize do
          super()
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
    end
    
    private
    alias_method :initialize__simple_content_proposal_provider, :initialize
  end
  
end
