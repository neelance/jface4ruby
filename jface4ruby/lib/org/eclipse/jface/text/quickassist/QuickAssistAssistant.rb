require "rjava"

# Copyright (c) 2006, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Quickassist
  module QuickAssistAssistantImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Quickassist
      include_const ::Org::Eclipse::Swt::Graphics, :Color
      include_const ::Org::Eclipse::Core::Commands, :IHandler
      include_const ::Org::Eclipse::Jface::Text, :IDocument
      include_const ::Org::Eclipse::Jface::Text, :IInformationControlCreator
      include_const ::Org::Eclipse::Jface::Text, :ITextViewer
      include_const ::Org::Eclipse::Jface::Text::Contentassist, :ContentAssistant
      include_const ::Org::Eclipse::Jface::Text::Contentassist, :ICompletionListener
      include_const ::Org::Eclipse::Jface::Text::Contentassist, :ICompletionProposal
      include_const ::Org::Eclipse::Jface::Text::Contentassist, :IContentAssistProcessor
      include_const ::Org::Eclipse::Jface::Text::Contentassist, :IContextInformation
      include_const ::Org::Eclipse::Jface::Text::Contentassist, :IContextInformationValidator
      include_const ::Org::Eclipse::Jface::Text::Source, :Annotation
      include_const ::Org::Eclipse::Jface::Text::Source, :ISourceViewer
      include_const ::Org::Eclipse::Jface::Text::Source, :TextInvocationContext
    }
  end
  
  # Default implementation of <code>IQuickAssistAssistant</code>.
  # 
  # @since 3.2
  class QuickAssistAssistant 
    include_class_members QuickAssistAssistantImports
    include IQuickAssistAssistant
    include IQuickAssistAssistantExtension
    
    class_module.module_eval {
      const_set_lazy(:QuickAssistAssistantImpl) { Class.new(ContentAssistant) do
        include_class_members QuickAssistAssistant
        
        typesig { [] }
        # @see org.eclipse.jface.text.contentassist.ContentAssistant#possibleCompletionsClosed()
        def possible_completions_closed
          super
        end
        
        typesig { [] }
        # @see org.eclipse.jface.text.contentassist.ContentAssistant#hide()
        # @since 3.4
        def hide
          super
        end
        
        typesig { [] }
        def initialize
          super()
        end
        
        private
        alias_method :initialize__quick_assist_assistant_impl, :initialize
      end }
      
      const_set_lazy(:ContentAssistProcessor) { Class.new do
        include_class_members QuickAssistAssistant
        include IContentAssistProcessor
        
        attr_accessor :f_quick_assist_processor
        alias_method :attr_f_quick_assist_processor, :f_quick_assist_processor
        undef_method :f_quick_assist_processor
        alias_method :attr_f_quick_assist_processor=, :f_quick_assist_processor=
        undef_method :f_quick_assist_processor=
        
        typesig { [class_self::IQuickAssistProcessor] }
        def initialize(processor)
          @f_quick_assist_processor = nil
          @f_quick_assist_processor = processor
        end
        
        typesig { [class_self::ITextViewer, ::Java::Int] }
        # @see org.eclipse.jface.text.contentassist.IContentAssistProcessor#computeCompletionProposals(org.eclipse.jface.text.ITextViewer, int)
        def compute_completion_proposals(viewer, offset)
          # panic code - should not happen
          if (!(viewer.is_a?(self.class::ISourceViewer)))
            return nil
          end
          return @f_quick_assist_processor.compute_quick_assist_proposals(self.class::TextInvocationContext.new(viewer, offset, -1))
        end
        
        typesig { [class_self::ITextViewer, ::Java::Int] }
        # @see org.eclipse.jface.text.contentassist.IContentAssistProcessor#computeContextInformation(org.eclipse.jface.text.ITextViewer, int)
        def compute_context_information(viewer, offset)
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
        
        private
        alias_method :initialize__content_assist_processor, :initialize
      end }
    }
    
    attr_accessor :f_quick_assist_assistant_impl
    alias_method :attr_f_quick_assist_assistant_impl, :f_quick_assist_assistant_impl
    undef_method :f_quick_assist_assistant_impl
    alias_method :attr_f_quick_assist_assistant_impl=, :f_quick_assist_assistant_impl=
    undef_method :f_quick_assist_assistant_impl=
    
    attr_accessor :f_quick_assist_processor
    alias_method :attr_f_quick_assist_processor, :f_quick_assist_processor
    undef_method :f_quick_assist_processor
    alias_method :attr_f_quick_assist_processor=, :f_quick_assist_processor=
    undef_method :f_quick_assist_processor=
    
    typesig { [] }
    def initialize
      @f_quick_assist_assistant_impl = nil
      @f_quick_assist_processor = nil
      @f_quick_assist_assistant_impl = QuickAssistAssistantImpl.new
      @f_quick_assist_assistant_impl.enable_auto_activation(false)
      @f_quick_assist_assistant_impl.enable_auto_insert(false)
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.quickassist.IQuickAssistAssistant#showPossibleQuickAssists()
    def show_possible_quick_assists
      return @f_quick_assist_assistant_impl.show_possible_completions
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.quickassist.IQuickAssistAssistant#getQuickAssistProcessor(java.lang.String)
    def get_quick_assist_processor
      return @f_quick_assist_processor
    end
    
    typesig { [IQuickAssistProcessor] }
    # @see org.eclipse.jface.text.quickassist.IQuickAssistAssistant#setQuickAssistProcessor(org.eclipse.jface.text.quickassist.IQuickAssistProcessor)
    def set_quick_assist_processor(processor)
      @f_quick_assist_processor = processor
      @f_quick_assist_assistant_impl.set_document_partitioning("__" + RJava.cast_to_string(get_class.get_name) + "_partitioning") # $NON-NLS-1$ //$NON-NLS-2$
      @f_quick_assist_assistant_impl.set_content_assist_processor(ContentAssistProcessor.new(processor), IDocument::DEFAULT_CONTENT_TYPE)
    end
    
    typesig { [Annotation] }
    # @see org.eclipse.jface.text.quickassist.IQuickAssistAssistant#canFix(org.eclipse.jface.text.source.Annotation)
    def can_fix(annotation)
      return !(@f_quick_assist_processor).nil? && @f_quick_assist_processor.can_fix(annotation)
    end
    
    typesig { [IQuickAssistInvocationContext] }
    # @see org.eclipse.jface.text.quickassist.IQuickAssistAssistant#canAssist(org.eclipse.jface.text.quickassist.IQuickAssistInvocationContext)
    def can_assist(invocation_context)
      return !(@f_quick_assist_processor).nil? && @f_quick_assist_processor.can_assist(invocation_context)
    end
    
    typesig { [ISourceViewer] }
    # @see org.eclipse.jface.text.quickassist.IQuickAssistAssistant#install(org.eclipse.jface.text.ITextViewer)
    def install(source_viewer)
      @f_quick_assist_assistant_impl.install(source_viewer)
    end
    
    typesig { [IInformationControlCreator] }
    # @see org.eclipse.jface.text.quickassist.IQuickAssistAssistant#setInformationControlCreator(org.eclipse.jface.text.IInformationControlCreator)
    def set_information_control_creator(creator)
      @f_quick_assist_assistant_impl.set_information_control_creator(creator)
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.quickassist.IQuickAssistAssistant#uninstall()
    def uninstall
      @f_quick_assist_assistant_impl.uninstall
    end
    
    typesig { [Color] }
    # @see org.eclipse.jface.text.quickassist.IQuickAssistAssistant#setProposalSelectorBackground(org.eclipse.swt.graphics.Color)
    def set_proposal_selector_background(background)
      @f_quick_assist_assistant_impl.set_proposal_selector_background(background)
    end
    
    typesig { [Color] }
    # @see org.eclipse.jface.text.quickassist.IQuickAssistAssistant#setProposalSelectorForeground(org.eclipse.swt.graphics.Color)
    def set_proposal_selector_foreground(foreground)
      @f_quick_assist_assistant_impl.set_proposal_selector_foreground(foreground)
    end
    
    typesig { [] }
    # Callback to signal this quick assist assistant that the presentation of the
    # possible completions has been stopped.
    def possible_completions_closed
      @f_quick_assist_assistant_impl.possible_completions_closed
    end
    
    typesig { [ICompletionListener] }
    # @see org.eclipse.jface.text.quickassist.IQuickAssistAssistant#addCompletionListener(org.eclipse.jface.text.contentassist.ICompletionListener)
    def add_completion_listener(listener)
      @f_quick_assist_assistant_impl.add_completion_listener(listener)
    end
    
    typesig { [ICompletionListener] }
    # @see org.eclipse.jface.text.quickassist.IQuickAssistAssistant#removeCompletionListener(org.eclipse.jface.text.contentassist.ICompletionListener)
    def remove_completion_listener(listener)
      @f_quick_assist_assistant_impl.remove_completion_listener(listener)
    end
    
    typesig { [::Java::Boolean] }
    # @see org.eclipse.jface.text.quickassist.IQuickAssistAssistant#setStatusLineVisible(boolean)
    def set_status_line_visible(show)
      @f_quick_assist_assistant_impl.set_status_line_visible(show)
    end
    
    typesig { [String] }
    # @see org.eclipse.jface.text.quickassist.IQuickAssistAssistant#setStatusMessage(java.lang.String)
    def set_status_message(message)
      @f_quick_assist_assistant_impl.set_status_message(message)
    end
    
    typesig { [String] }
    # {@inheritDoc}
    # 
    # @since 3.4
    def get_handler(command_id)
      return @f_quick_assist_assistant_impl.get_handler(command_id)
    end
    
    typesig { [] }
    # Hides any open pop-ups.
    # 
    # @since 3.4
    def hide
      @f_quick_assist_assistant_impl.hide
    end
    
    typesig { [::Java::Boolean] }
    # {@inheritDoc}
    # 
    # @since 3.4
    def enable_colored_labels(is_enabled)
      @f_quick_assist_assistant_impl.enable_colored_labels(is_enabled)
    end
    
    private
    alias_method :initialize__quick_assist_assistant, :initialize
  end
  
end
