require "rjava"

# Copyright (c) 2000, 2005 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Templates
  module TemplateCompletionProcessorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Templates
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :Collections
      include_const ::Java::Util, :Comparator
      include_const ::Java::Util, :JavaList
      include_const ::Org::Eclipse::Swt::Graphics, :Image
      include_const ::Org::Eclipse::Jface::Text, :BadLocationException
      include_const ::Org::Eclipse::Jface::Text, :IDocument
      include_const ::Org::Eclipse::Jface::Text, :IRegion
      include_const ::Org::Eclipse::Jface::Text, :ITextSelection
      include_const ::Org::Eclipse::Jface::Text, :ITextViewer
      include_const ::Org::Eclipse::Jface::Text, :Region
      include_const ::Org::Eclipse::Jface::Text::Contentassist, :ICompletionProposal
      include_const ::Org::Eclipse::Jface::Text::Contentassist, :IContentAssistProcessor
      include_const ::Org::Eclipse::Jface::Text::Contentassist, :IContextInformation
      include_const ::Org::Eclipse::Jface::Text::Contentassist, :IContextInformationValidator
    }
  end
  
  # A completion processor that computes template proposals. Subclasses need to
  # provide implementations for {@link #getTemplates(String)},
  # {@link #getContextType(ITextViewer, IRegion)} and {@link #getImage(Template)}.
  # 
  # @since 3.0
  class TemplateCompletionProcessor 
    include_class_members TemplateCompletionProcessorImports
    include IContentAssistProcessor
    
    class_module.module_eval {
      const_set_lazy(:ProposalComparator) { Class.new do
        include_class_members TemplateCompletionProcessor
        include Comparator
        
        typesig { [Object, Object] }
        def compare(o1, o2)
          return (o2).get_relevance - (o1).get_relevance
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__proposal_comparator, :initialize
      end }
      
      const_set_lazy(:FgProposalComparator) { ProposalComparator.new }
      const_attr_reader  :FgProposalComparator
    }
    
    typesig { [ITextViewer, ::Java::Int] }
    # @see org.eclipse.jface.text.contentassist.IContentAssistProcessor#computeCompletionProposals(org.eclipse.jface.text.ITextViewer,
    # int)
    def compute_completion_proposals(viewer, offset)
      selection = viewer.get_selection_provider.get_selection
      # adjust offset to end of normalized selection
      if ((selection.get_offset).equal?(offset))
        offset = selection.get_offset + selection.get_length
      end
      prefix = extract_prefix(viewer, offset)
      region = Region.new(offset - prefix.length, prefix.length)
      context = create_context(viewer, region)
      if ((context).nil?)
        return Array.typed(ICompletionProposal).new(0) { nil }
      end
      context.set_variable("selection", selection.get_text) # name of the selection variables {line, word}_selection //$NON-NLS-1$
      templates = get_templates(context.get_context_type.get_id)
      matches = ArrayList.new
      i = 0
      while i < templates.attr_length
        template = templates[i]
        begin
          context.get_context_type.validate(template.get_pattern)
        rescue TemplateException => e
          i += 1
          next
        end
        if (template.matches(prefix, context.get_context_type.get_id))
          matches.add(create_proposal(template, context, region, get_relevance(template, prefix)))
        end
        i += 1
      end
      Collections.sort(matches, FgProposalComparator)
      return matches.to_array(Array.typed(ICompletionProposal).new(matches.size) { nil })
    end
    
    typesig { [Template, TemplateContext, Region, ::Java::Int] }
    # Creates a new proposal.
    # <p>
    # Forwards to {@link #createProposal(Template, TemplateContext, IRegion, int)}.
    # Do neither call nor override.
    # </p>
    # 
    # @param template the template to be applied by the proposal
    # @param context the context for the proposal
    # @param region the region the proposal applies to
    # @param relevance the relevance of the proposal
    # @return a new <code>ICompletionProposal</code> for
    # <code>template</code>
    # @deprecated use the version specifying <code>IRegion</code> as third parameter
    # @since 3.1
    def create_proposal(template, context, region, relevance)
      return create_proposal(template, context, region, relevance)
    end
    
    typesig { [Template, TemplateContext, IRegion, ::Java::Int] }
    # Creates a new proposal.
    # <p>
    # The default implementation returns an instance of
    # {@link TemplateProposal}. Subclasses may replace this method to provide
    # their own implementations.
    # </p>
    # 
    # @param template the template to be applied by the proposal
    # @param context the context for the proposal
    # @param region the region the proposal applies to
    # @param relevance the relevance of the proposal
    # @return a new <code>ICompletionProposal</code> for
    # <code>template</code>
    def create_proposal(template, context, region, relevance)
      return TemplateProposal.new(template, context, region, get_image(template), relevance)
    end
    
    typesig { [String] }
    # Returns the templates valid for the context type specified by <code>contextTypeId</code>.
    # 
    # @param contextTypeId the context type id
    # @return the templates valid for this context type id
    def get_templates(context_type_id)
      raise NotImplementedError
    end
    
    typesig { [ITextViewer, IRegion] }
    # Creates a concrete template context for the given region in the document. This involves finding out which
    # context type is valid at the given location, and then creating a context of this type. The default implementation
    # returns a <code>DocumentTemplateContext</code> for the context type at the given location.
    # 
    # @param viewer the viewer for which the context is created
    # @param region the region into <code>document</code> for which the context is created
    # @return a template context that can handle template insertion at the given location, or <code>null</code>
    def create_context(viewer, region)
      context_type = get_context_type(viewer, region)
      if (!(context_type).nil?)
        document = viewer.get_document
        return DocumentTemplateContext.new(context_type, document, region.get_offset, region.get_length)
      end
      return nil
    end
    
    typesig { [ITextViewer, IRegion] }
    # Returns the context type that can handle template insertion at the given region
    # in the viewer's document.
    # 
    # @param viewer the text viewer
    # @param region the region into the document displayed by viewer
    # @return the context type that can handle template expansion for the given location, or <code>null</code> if none exists
    def get_context_type(viewer, region)
      raise NotImplementedError
    end
    
    typesig { [Template, String] }
    # Returns the relevance of a template given a prefix. The default
    # implementation returns a number greater than zero if the template name
    # starts with the prefix, and zero otherwise.
    # 
    # @param template the template to compute the relevance for
    # @param prefix the prefix after which content assist was requested
    # @return the relevance of <code>template</code>
    # @see #extractPrefix(ITextViewer, int)
    def get_relevance(template, prefix)
      if (template.get_name.starts_with(prefix))
        return 90
      end
      return 0
    end
    
    typesig { [ITextViewer, ::Java::Int] }
    # Heuristically extracts the prefix used for determining template relevance
    # from the viewer's document. The default implementation returns the String from
    # offset backwards that forms a java identifier.
    # 
    # @param viewer the viewer
    # @param offset offset into document
    # @return the prefix to consider
    # @see #getRelevance(Template, String)
    def extract_prefix(viewer, offset)
      i = offset
      document = viewer.get_document
      if (i > document.get_length)
        return ""
      end # $NON-NLS-1$
      begin
        while (i > 0)
          ch = document.get_char(i - 1)
          if (!Character.is_java_identifier_part(ch))
            break
          end
          i -= 1
        end
        return document.get(i, offset - i)
      rescue BadLocationException => e
        return "" # $NON-NLS-1$
      end
    end
    
    typesig { [Template] }
    # Returns the image to be used for the proposal for <code>template</code>.
    # 
    # @param template the template for which an image should be returned
    # @return the image for <code>template</code>
    def get_image(template)
      raise NotImplementedError
    end
    
    typesig { [ITextViewer, ::Java::Int] }
    # @see org.eclipse.jface.text.contentassist.IContentAssistProcessor#computeContextInformation(org.eclipse.jface.text.ITextViewer, int)
    def compute_context_information(viewer, document_offset)
      return nil
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.contentassist.IContentAssistProcessor#getCompletionProposalAutoActivationCharacters()
    def get_completion_proposal_auto_activation_characters
      return nil
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.contentassist.IContentAssistProcessor#getContextInformationAutoActivationCharacters()
    def get_context_information_auto_activation_characters
      return nil
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.contentassist.IContentAssistProcessor#getErrorMessage()
    def get_error_message
      return nil
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.contentassist.IContentAssistProcessor#getContextInformationValidator()
    def get_context_information_validator
      return nil
    end
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__template_completion_processor, :initialize
  end
  
end
