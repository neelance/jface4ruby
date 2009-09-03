require "rjava"

# Copyright (c) 2000, 2007 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Contentassist
  module CompletionProposalImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Contentassist
      include_const ::Org::Eclipse::Swt::Graphics, :Image
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Jface::Text, :BadLocationException
      include_const ::Org::Eclipse::Jface::Text, :IDocument
    }
  end
  
  # The standard implementation of the <code>ICompletionProposal</code> interface.
  class CompletionProposal 
    include_class_members CompletionProposalImports
    include ICompletionProposal
    
    # The string to be displayed in the completion proposal popup.
    attr_accessor :f_display_string
    alias_method :attr_f_display_string, :f_display_string
    undef_method :f_display_string
    alias_method :attr_f_display_string=, :f_display_string=
    undef_method :f_display_string=
    
    # The replacement string.
    attr_accessor :f_replacement_string
    alias_method :attr_f_replacement_string, :f_replacement_string
    undef_method :f_replacement_string
    alias_method :attr_f_replacement_string=, :f_replacement_string=
    undef_method :f_replacement_string=
    
    # The replacement offset.
    attr_accessor :f_replacement_offset
    alias_method :attr_f_replacement_offset, :f_replacement_offset
    undef_method :f_replacement_offset
    alias_method :attr_f_replacement_offset=, :f_replacement_offset=
    undef_method :f_replacement_offset=
    
    # The replacement length.
    attr_accessor :f_replacement_length
    alias_method :attr_f_replacement_length, :f_replacement_length
    undef_method :f_replacement_length
    alias_method :attr_f_replacement_length=, :f_replacement_length=
    undef_method :f_replacement_length=
    
    # The cursor position after this proposal has been applied.
    attr_accessor :f_cursor_position
    alias_method :attr_f_cursor_position, :f_cursor_position
    undef_method :f_cursor_position
    alias_method :attr_f_cursor_position=, :f_cursor_position=
    undef_method :f_cursor_position=
    
    # The image to be displayed in the completion proposal popup.
    attr_accessor :f_image
    alias_method :attr_f_image, :f_image
    undef_method :f_image
    alias_method :attr_f_image=, :f_image=
    undef_method :f_image=
    
    # The context information of this proposal.
    attr_accessor :f_context_information
    alias_method :attr_f_context_information, :f_context_information
    undef_method :f_context_information
    alias_method :attr_f_context_information=, :f_context_information=
    undef_method :f_context_information=
    
    # The additional info of this proposal.
    attr_accessor :f_additional_proposal_info
    alias_method :attr_f_additional_proposal_info, :f_additional_proposal_info
    undef_method :f_additional_proposal_info
    alias_method :attr_f_additional_proposal_info=, :f_additional_proposal_info=
    undef_method :f_additional_proposal_info=
    
    typesig { [String, ::Java::Int, ::Java::Int, ::Java::Int] }
    # Creates a new completion proposal based on the provided information. The replacement string is
    # considered being the display string too. All remaining fields are set to <code>null</code>.
    # 
    # @param replacementString the actual string to be inserted into the document
    # @param replacementOffset the offset of the text to be replaced
    # @param replacementLength the length of the text to be replaced
    # @param cursorPosition the position of the cursor following the insert relative to replacementOffset
    def initialize(replacement_string, replacement_offset, replacement_length, cursor_position)
      initialize__completion_proposal(replacement_string, replacement_offset, replacement_length, cursor_position, nil, nil, nil, nil)
    end
    
    typesig { [String, ::Java::Int, ::Java::Int, ::Java::Int, Image, String, IContextInformation, String] }
    # Creates a new completion proposal. All fields are initialized based on the provided information.
    # 
    # @param replacementString the actual string to be inserted into the document
    # @param replacementOffset the offset of the text to be replaced
    # @param replacementLength the length of the text to be replaced
    # @param cursorPosition the position of the cursor following the insert relative to replacementOffset
    # @param image the image to display for this proposal
    # @param displayString the string to be displayed for the proposal
    # @param contextInformation the context information associated with this proposal
    # @param additionalProposalInfo the additional information associated with this proposal
    def initialize(replacement_string, replacement_offset, replacement_length, cursor_position, image, display_string, context_information, additional_proposal_info)
      @f_display_string = nil
      @f_replacement_string = nil
      @f_replacement_offset = 0
      @f_replacement_length = 0
      @f_cursor_position = 0
      @f_image = nil
      @f_context_information = nil
      @f_additional_proposal_info = nil
      Assert.is_not_null(replacement_string)
      Assert.is_true(replacement_offset >= 0)
      Assert.is_true(replacement_length >= 0)
      Assert.is_true(cursor_position >= 0)
      @f_replacement_string = replacement_string
      @f_replacement_offset = replacement_offset
      @f_replacement_length = replacement_length
      @f_cursor_position = cursor_position
      @f_image = image
      @f_display_string = display_string
      @f_context_information = context_information
      @f_additional_proposal_info = additional_proposal_info
    end
    
    typesig { [IDocument] }
    # @see ICompletionProposal#apply(IDocument)
    def apply(document)
      begin
        document.replace(@f_replacement_offset, @f_replacement_length, @f_replacement_string)
      rescue BadLocationException => x
        # ignore
      end
    end
    
    typesig { [IDocument] }
    # @see ICompletionProposal#getSelection(IDocument)
    def get_selection(document)
      return Point.new(@f_replacement_offset + @f_cursor_position, 0)
    end
    
    typesig { [] }
    # @see ICompletionProposal#getContextInformation()
    def get_context_information
      return @f_context_information
    end
    
    typesig { [] }
    # @see ICompletionProposal#getImage()
    def get_image
      return @f_image
    end
    
    typesig { [] }
    # @see ICompletionProposal#getDisplayString()
    def get_display_string
      if (!(@f_display_string).nil?)
        return @f_display_string
      end
      return @f_replacement_string
    end
    
    typesig { [] }
    # @see ICompletionProposal#getAdditionalProposalInfo()
    def get_additional_proposal_info
      return @f_additional_proposal_info
    end
    
    private
    alias_method :initialize__completion_proposal, :initialize
  end
  
end
