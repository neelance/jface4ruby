require "rjava"

# Copyright (c) 2000, 2005 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Link
  module ProposalPositionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Link
      include_const ::Java::Util, :Arrays
      include_const ::Org::Eclipse::Jface::Text, :IDocument
      include_const ::Org::Eclipse::Jface::Text::Contentassist, :ICompletionProposal
    }
  end
  
  # LinkedPosition with added completion proposals.
  # <p>
  # Clients may instantiate or extend this class.
  # </p>
  # 
  # @since 3.0
  class ProposalPosition < ProposalPositionImports.const_get :LinkedPosition
    include_class_members ProposalPositionImports
    
    # The proposals
    attr_accessor :f_proposals
    alias_method :attr_f_proposals, :f_proposals
    undef_method :f_proposals
    alias_method :attr_f_proposals=, :f_proposals=
    undef_method :f_proposals=
    
    typesig { [IDocument, ::Java::Int, ::Java::Int, ::Java::Int, Array.typed(ICompletionProposal)] }
    # Creates a new instance.
    # 
    # @param document the document
    # @param offset the offset of the position
    # @param length the length of the position
    # @param sequence the iteration sequence rank
    # @param proposals the proposals to be shown when entering this position
    def initialize(document, offset, length, sequence, proposals)
      @f_proposals = nil
      super(document, offset, length, sequence)
      @f_proposals = copy(proposals)
    end
    
    typesig { [IDocument, ::Java::Int, ::Java::Int, Array.typed(ICompletionProposal)] }
    # Creates a new instance, with no sequence number.
    # 
    # @param document the document
    # @param offset the offset of the position
    # @param length the length of the position
    # @param proposals the proposals to be shown when entering this position
    def initialize(document, offset, length, proposals)
      @f_proposals = nil
      super(document, offset, length, LinkedPositionGroup::NO_STOP)
      @f_proposals = copy(proposals)
    end
    
    typesig { [Array.typed(ICompletionProposal)] }
    # @since 3.1
    def copy(proposals)
      if (!(proposals).nil?)
        copy_ = Array.typed(ICompletionProposal).new(proposals.attr_length) { nil }
        System.arraycopy(proposals, 0, copy_, 0, proposals.attr_length)
        return copy_
      end
      return nil
    end
    
    typesig { [Object] }
    # @see java.lang.Object#equals(java.lang.Object)
    def ==(o)
      if (o.is_a?(ProposalPosition))
        if (super(o))
          return (Arrays == @f_proposals)
        end
      end
      return false
    end
    
    typesig { [] }
    # Returns the proposals attached to this position. The returned array is owned by
    # this <code>ProposalPosition</code> and may not be modified by clients.
    # 
    # @return an array of choices, including the initial one. Callers must not
    # modify it.
    def get_choices
      return @f_proposals
    end
    
    typesig { [] }
    # @see org.eclipse.jdt.internal.ui.text.link.LinkedPosition#hashCode()
    def hash_code
      return super | ((@f_proposals).nil? ? 0 : @f_proposals.hash_code)
    end
    
    private
    alias_method :initialize__proposal_position, :initialize
  end
  
end
