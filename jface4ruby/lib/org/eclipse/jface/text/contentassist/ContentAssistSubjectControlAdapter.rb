require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Contentassist
  module ContentAssistSubjectControlAdapterImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Contentassist
      include_const ::Org::Eclipse::Swt::Custom, :StyledText
      include_const ::Org::Eclipse::Swt::Custom, :VerifyKeyListener
      include_const ::Org::Eclipse::Swt::Events, :KeyListener
      include_const ::Org::Eclipse::Swt::Events, :SelectionListener
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Jface::Contentassist, :IContentAssistSubjectControl
      include_const ::Org::Eclipse::Jface::Contentassist, :ISubjectControlContextInformationPresenter
      include_const ::Org::Eclipse::Jface::Contentassist, :ISubjectControlContextInformationValidator
      include_const ::Org::Eclipse::Jface::Text, :IDocument
      include_const ::Org::Eclipse::Jface::Text, :IEventConsumer
      include_const ::Org::Eclipse::Jface::Text, :ITextViewer
      include_const ::Org::Eclipse::Jface::Text, :ITextViewerExtension
      include_const ::Org::Eclipse::Jface::Text::Contentassist::ContextInformationPopup, :ContextFrame
    }
  end
  
  # This content assist adapter delegates the calls either to
  # a text viewer or to a content assist subject control.
  # 
  # @since 3.0
  class ContentAssistSubjectControlAdapter 
    include_class_members ContentAssistSubjectControlAdapterImports
    include IContentAssistSubjectControl
    
    # The text viewer which is used as content assist subject control.
    attr_accessor :f_viewer
    alias_method :attr_f_viewer, :f_viewer
    undef_method :f_viewer
    alias_method :attr_f_viewer=, :f_viewer=
    undef_method :f_viewer=
    
    # The content assist subject control.
    attr_accessor :f_content_assist_subject_control
    alias_method :attr_f_content_assist_subject_control, :f_content_assist_subject_control
    undef_method :f_content_assist_subject_control
    alias_method :attr_f_content_assist_subject_control=, :f_content_assist_subject_control=
    undef_method :f_content_assist_subject_control=
    
    typesig { [IContentAssistSubjectControl] }
    # Creates an adapter for the given content assist subject control.
    # 
    # @param contentAssistSubjectControl the content assist subject control
    def initialize(content_assist_subject_control)
      @f_viewer = nil
      @f_content_assist_subject_control = nil
      Assert.is_not_null(content_assist_subject_control)
      @f_content_assist_subject_control = content_assist_subject_control
    end
    
    typesig { [ITextViewer] }
    # Creates an adapter for the given text viewer.
    # 
    # @param viewer the text viewer
    def initialize(viewer)
      @f_viewer = nil
      @f_content_assist_subject_control = nil
      Assert.is_not_null(viewer)
      @f_viewer = viewer
    end
    
    typesig { [] }
    # @see IContentAssistSubjectControl#getLineHeight()
    def get_line_height
      if (!(@f_content_assist_subject_control).nil?)
        return @f_content_assist_subject_control.get_line_height
      end
      return @f_viewer.get_text_widget.get_line_height(get_caret_offset)
    end
    
    typesig { [] }
    # @see IContentAssistSubjectControl#getControl()
    def get_control
      if (!(@f_content_assist_subject_control).nil?)
        return @f_content_assist_subject_control.get_control
      end
      return @f_viewer.get_text_widget
    end
    
    typesig { [::Java::Int] }
    # @see IContentAssistSubjectControl#getLocationAtOffset(int)
    def get_location_at_offset(offset)
      if (!(@f_content_assist_subject_control).nil?)
        return @f_content_assist_subject_control.get_location_at_offset(offset)
      end
      return @f_viewer.get_text_widget.get_location_at_offset(offset)
    end
    
    typesig { [] }
    # @see IContentAssistSubjectControl#getWidgetSelectionRange()
    def get_widget_selection_range
      if (!(@f_content_assist_subject_control).nil?)
        return @f_content_assist_subject_control.get_widget_selection_range
      end
      return @f_viewer.get_text_widget.get_selection_range
    end
    
    typesig { [] }
    # @see IContentAssistSubjectControl#getSelectedRange()
    def get_selected_range
      if (!(@f_content_assist_subject_control).nil?)
        return @f_content_assist_subject_control.get_selected_range
      end
      return @f_viewer.get_selected_range
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.contentassist.IContentAssistSubjectControl#getCaretOffset()
    def get_caret_offset
      if (!(@f_content_assist_subject_control).nil?)
        return @f_content_assist_subject_control.get_caret_offset
      end
      return @f_viewer.get_text_widget.get_caret_offset
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.contentassist.IContentAssistSubjectControl#getLineDelimiter()
    def get_line_delimiter
      if (!(@f_content_assist_subject_control).nil?)
        return @f_content_assist_subject_control.get_line_delimiter
      end
      return @f_viewer.get_text_widget.get_line_delimiter
    end
    
    typesig { [KeyListener] }
    # @see org.eclipse.jface.text.contentassist.IContentAssistSubjectControl#addKeyListener(org.eclipse.swt.events.KeyListener)
    def add_key_listener(key_listener)
      if (!(@f_content_assist_subject_control).nil?)
        @f_content_assist_subject_control.add_key_listener(key_listener)
      else
        @f_viewer.get_text_widget.add_key_listener(key_listener)
      end
    end
    
    typesig { [KeyListener] }
    # @see org.eclipse.jface.text.contentassist.IContentAssistSubjectControl#removeKeyListener(org.eclipse.swt.events.KeyListener)
    def remove_key_listener(key_listener)
      if (!(@f_content_assist_subject_control).nil?)
        @f_content_assist_subject_control.remove_key_listener(key_listener)
      else
        @f_viewer.get_text_widget.remove_key_listener(key_listener)
      end
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.contentassist.IContentAssistSubjectControl#getDocument()
    def get_document
      if (!(@f_content_assist_subject_control).nil?)
        return @f_content_assist_subject_control.get_document
      end
      return @f_viewer.get_document
    end
    
    typesig { [VerifyKeyListener] }
    # @see org.eclipse.jface.text.contentassist.IContentAssistSubjectControl#prependVerifyKeyListener(VerifyKeyListener)
    def prepend_verify_key_listener(verify_key_listener)
      if (!(@f_content_assist_subject_control).nil?)
        return @f_content_assist_subject_control.prepend_verify_key_listener(verify_key_listener)
      else
        if (@f_viewer.is_a?(ITextViewerExtension))
          e = @f_viewer
          e.prepend_verify_key_listener(verify_key_listener)
          return true
        else
          text_widget = @f_viewer.get_text_widget
          if (Helper.ok_to_use(text_widget))
            text_widget.add_verify_key_listener(verify_key_listener)
            return true
          end
        end
      end
      return false
    end
    
    typesig { [VerifyKeyListener] }
    # @see org.eclipse.jface.text.contentassist.IContentAssistSubjectControl#appendVerifyKeyListener(org.eclipse.swt.custom.VerifyKeyListener)
    def append_verify_key_listener(verify_key_listener)
      if (!(@f_content_assist_subject_control).nil?)
        return @f_content_assist_subject_control.append_verify_key_listener(verify_key_listener)
      else
        if (@f_viewer.is_a?(ITextViewerExtension))
          extension = @f_viewer
          extension.append_verify_key_listener(verify_key_listener)
          return true
        else
          text_widget = @f_viewer.get_text_widget
          if (Helper.ok_to_use(text_widget))
            text_widget.add_verify_key_listener(verify_key_listener)
            return true
          end
        end
      end
      return false
    end
    
    typesig { [VerifyKeyListener] }
    # @see org.eclipse.jface.text.contentassist.IContentAssistSubjectControl#removeVerifyKeyListener(org.eclipse.swt.custom.VerifyKeyListener)
    def remove_verify_key_listener(verify_key_listener)
      if (!(@f_content_assist_subject_control).nil?)
        @f_content_assist_subject_control.remove_verify_key_listener(verify_key_listener)
      else
        if (@f_viewer.is_a?(ITextViewerExtension))
          extension = @f_viewer
          extension.remove_verify_key_listener(verify_key_listener)
        else
          text_widget = @f_viewer.get_text_widget
          if (Helper.ok_to_use(text_widget))
            text_widget.remove_verify_key_listener(verify_key_listener)
          end
        end
      end
    end
    
    typesig { [IEventConsumer] }
    # @see org.eclipse.jface.text.contentassist.IContentAssistSubjectControl#setEventConsumer(org.eclipse.jface.text.contentassist.ContentAssistant.InternalListener)
    def set_event_consumer(event_consumer)
      if (!(@f_content_assist_subject_control).nil?)
        @f_content_assist_subject_control.set_event_consumer(event_consumer)
      else
        @f_viewer.set_event_consumer(event_consumer)
      end
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # @see org.eclipse.jface.text.contentassist.IContentAssistSubjectControl#setSelectedRange(int, int)
    def set_selected_range(i, j)
      if (!(@f_content_assist_subject_control).nil?)
        @f_content_assist_subject_control.set_selected_range(i, j)
      else
        @f_viewer.set_selected_range(i, j)
      end
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # @see org.eclipse.jface.text.contentassist.IContentAssistSubjectControl#revealRange(int, int)
    def reveal_range(i, j)
      if (!(@f_content_assist_subject_control).nil?)
        @f_content_assist_subject_control.reveal_range(i, j)
      else
        @f_viewer.reveal_range(i, j)
      end
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.contentassist.IContentAssistSubjectControl#canAddVerifyKeyListener()
    def supports_verify_key_listener
      if (!(@f_content_assist_subject_control).nil?)
        return @f_content_assist_subject_control.supports_verify_key_listener
      end
      return true
    end
    
    typesig { [ContentAssistant, ::Java::Int] }
    # Returns the characters which when typed by the user should automatically
    # initiate proposing completions. The position is used to determine the
    # appropriate content assist processor to invoke.
    # 
    # @param contentAssistant the content assistant
    # @param offset a document offset
    # @return the auto activation characters
    # @see IContentAssistProcessor#getCompletionProposalAutoActivationCharacters()
    def get_completion_proposal_auto_activation_characters(content_assistant, offset)
      if (!(@f_content_assist_subject_control).nil?)
        return content_assistant.get_completion_proposal_auto_activation_characters(@f_content_assist_subject_control, offset)
      end
      return content_assistant.get_completion_proposal_auto_activation_characters(@f_viewer, offset)
    end
    
    typesig { [ContentAssistant, ::Java::Int] }
    # Returns the characters which when typed by the user should automatically
    # initiate the presentation of context information. The position is used
    # to determine the appropriate content assist processor to invoke.
    # 
    # @param contentAssistant the content assistant
    # @param offset a document offset
    # @return the auto activation characters
    # 
    # @see IContentAssistProcessor#getContextInformationAutoActivationCharacters()
    def get_context_information_auto_activation_characters(content_assistant, offset)
      if (!(@f_content_assist_subject_control).nil?)
        return content_assistant.get_context_information_auto_activation_characters(@f_content_assist_subject_control, offset)
      end
      return content_assistant.get_context_information_auto_activation_characters(@f_viewer, offset)
    end
    
    typesig { [ContentAssistant, AdditionalInfoController] }
    # Creates and returns a completion proposal popup for the given content assistant.
    # 
    # @param contentAssistant the content assistant
    # @param controller the additional info controller
    # @return the completion proposal popup
    def create_completion_proposal_popup(content_assistant, controller)
      if (!(@f_content_assist_subject_control).nil?)
        return CompletionProposalPopup.new(content_assistant, @f_content_assist_subject_control, controller)
      end
      return CompletionProposalPopup.new(content_assistant, @f_viewer, controller)
    end
    
    typesig { [ContentAssistant] }
    # Creates and returns a context info popup for the given content assistant.
    # 
    # @param contentAssistant the content assistant
    # @return the context info popup or <code>null</code>
    def create_context_info_popup(content_assistant)
      if (!(@f_content_assist_subject_control).nil?)
        return ContextInformationPopup.new(content_assistant, @f_content_assist_subject_control)
      end
      return ContextInformationPopup.new(content_assistant, @f_viewer)
    end
    
    typesig { [ContentAssistant, ::Java::Int] }
    # Returns the context information validator that should be used to
    # determine when the currently displayed context information should
    # be dismissed. The position is used to determine the appropriate
    # content assist processor to invoke.
    # 
    # @param contentAssistant the content assistant
    # @param offset a document offset
    # @return an validator
    def get_context_information_validator(content_assistant, offset)
      if (!(@f_content_assist_subject_control).nil?)
        return content_assistant.get_context_information_validator(@f_content_assist_subject_control, offset)
      end
      return content_assistant.get_context_information_validator(@f_viewer, offset)
    end
    
    typesig { [ContentAssistant, ::Java::Int] }
    # Returns the context information presenter that should be used to
    # display context information. The position is used to determine the
    # appropriate content assist processor to invoke.
    # 
    # @param contentAssistant the content assistant
    # @param offset a document offset
    # @return a presenter
    def get_context_information_presenter(content_assistant, offset)
      if (!(@f_content_assist_subject_control).nil?)
        return content_assistant.get_context_information_presenter(@f_content_assist_subject_control, offset)
      end
      return content_assistant.get_context_information_presenter(@f_viewer, offset)
    end
    
    typesig { [ContextFrame] }
    # Installs this adapter's information validator on the given context frame.
    # 
    # @param frame the context frame
    def install_validator(frame)
      if (!(@f_content_assist_subject_control).nil?)
        if (frame.attr_f_validator.is_a?(ISubjectControlContextInformationValidator))
          (frame.attr_f_validator).install(frame.attr_f_information, @f_content_assist_subject_control, frame.attr_f_offset)
        end
      else
        frame.attr_f_validator.install(frame.attr_f_information, @f_viewer, frame.attr_f_offset)
      end
    end
    
    typesig { [ContextFrame] }
    # Installs this adapter's information presenter on the given context frame.
    # 
    # @param frame the context frame
    def install_context_information_presenter(frame)
      if (!(@f_content_assist_subject_control).nil?)
        if (frame.attr_f_presenter.is_a?(ISubjectControlContextInformationPresenter))
          (frame.attr_f_validator).install(frame.attr_f_information, @f_content_assist_subject_control, frame.attr_f_begin_offset)
        end
      else
        frame.attr_f_presenter.install(frame.attr_f_information, @f_viewer, frame.attr_f_begin_offset)
      end
    end
    
    typesig { [ContentAssistant, ::Java::Int] }
    # Returns an array of context information objects computed based
    # on the specified document position. The position is used to determine
    # the appropriate content assist processor to invoke.
    # 
    # @param contentAssistant the content assistant
    # @param offset a document offset
    # @return an array of context information objects
    # @see IContentAssistProcessor#computeContextInformation(ITextViewer, int)
    def compute_context_information(content_assistant, offset)
      if (!(@f_content_assist_subject_control).nil?)
        return content_assistant.compute_context_information(@f_content_assist_subject_control, offset)
      end
      return content_assistant.compute_context_information(@f_viewer, offset)
    end
    
    typesig { [SelectionListener] }
    # @see IContentAssistSubjectControl#addSelectionListener(SelectionListener)
    def add_selection_listener(selection_listener)
      if (!(@f_content_assist_subject_control).nil?)
        return @f_content_assist_subject_control.add_selection_listener(selection_listener)
      end
      @f_viewer.get_text_widget.add_selection_listener(selection_listener)
      return true
    end
    
    typesig { [SelectionListener] }
    # @see IContentAssistSubjectControl#removeSelectionListener(SelectionListener)
    def remove_selection_listener(selection_listener)
      if (!(@f_content_assist_subject_control).nil?)
        @f_content_assist_subject_control.remove_selection_listener(selection_listener)
      else
        @f_viewer.get_text_widget.remove_selection_listener(selection_listener)
      end
    end
    
    private
    alias_method :initialize__content_assist_subject_control_adapter, :initialize
  end
  
end
