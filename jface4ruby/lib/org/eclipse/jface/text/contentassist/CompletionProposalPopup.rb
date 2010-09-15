require "rjava"

# Copyright (c) 2000, 2009 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
# Sean Montgomery, sean_montgomery@comcast.net - https://bugs.eclipse.org/bugs/show_bug.cgi?id=116454
module Org::Eclipse::Jface::Text::Contentassist
  module CompletionProposalPopupImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Contentassist
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :JavaList
      include_const ::Org::Eclipse::Osgi::Util, :TextProcessor
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Custom, :BusyIndicator
      include_const ::Org::Eclipse::Swt::Custom, :StyleRange
      include_const ::Org::Eclipse::Swt::Events, :ControlEvent
      include_const ::Org::Eclipse::Swt::Events, :ControlListener
      include_const ::Org::Eclipse::Swt::Events, :DisposeEvent
      include_const ::Org::Eclipse::Swt::Events, :DisposeListener
      include_const ::Org::Eclipse::Swt::Events, :FocusEvent
      include_const ::Org::Eclipse::Swt::Events, :FocusListener
      include_const ::Org::Eclipse::Swt::Events, :KeyAdapter
      include_const ::Org::Eclipse::Swt::Events, :KeyEvent
      include_const ::Org::Eclipse::Swt::Events, :KeyListener
      include_const ::Org::Eclipse::Swt::Events, :MouseAdapter
      include_const ::Org::Eclipse::Swt::Events, :MouseEvent
      include_const ::Org::Eclipse::Swt::Events, :SelectionEvent
      include_const ::Org::Eclipse::Swt::Events, :SelectionListener
      include_const ::Org::Eclipse::Swt::Events, :TraverseEvent
      include_const ::Org::Eclipse::Swt::Events, :TraverseListener
      include_const ::Org::Eclipse::Swt::Events, :VerifyEvent
      include_const ::Org::Eclipse::Swt::Graphics, :Color
      include_const ::Org::Eclipse::Swt::Graphics, :Font
      include_const ::Org::Eclipse::Swt::Graphics, :FontData
      include_const ::Org::Eclipse::Swt::Graphics, :Image
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Graphics, :Rectangle
      include_const ::Org::Eclipse::Swt::Layout, :GridData
      include_const ::Org::Eclipse::Swt::Layout, :GridLayout
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Display
      include_const ::Org::Eclipse::Swt::Widgets, :Event
      include_const ::Org::Eclipse::Swt::Widgets, :Label
      include_const ::Org::Eclipse::Swt::Widgets, :Listener
      include_const ::Org::Eclipse::Swt::Widgets, :Shell
      include_const ::Org::Eclipse::Swt::Widgets, :Table
      include_const ::Org::Eclipse::Swt::Widgets, :TableItem
      include_const ::Org::Eclipse::Core::Commands, :AbstractHandler
      include_const ::Org::Eclipse::Core::Commands, :ExecutionEvent
      include_const ::Org::Eclipse::Core::Commands, :ExecutionException
      include_const ::Org::Eclipse::Core::Commands, :IHandler
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Jface::Bindings::Keys, :KeySequence
      include_const ::Org::Eclipse::Jface::Bindings::Keys, :SWTKeySupport
      include_const ::Org::Eclipse::Jface::Contentassist, :IContentAssistSubjectControl
      include_const ::Org::Eclipse::Jface::Internal::Text, :InformationControlReplacer
      include_const ::Org::Eclipse::Jface::Internal::Text, :TableOwnerDrawSupport
      include_const ::Org::Eclipse::Jface::Preference, :JFacePreferences
      include_const ::Org::Eclipse::Jface::Resource, :JFaceResources
      include_const ::Org::Eclipse::Jface::Util, :Geometry
      include_const ::Org::Eclipse::Jface::Viewers, :StyledString
      include_const ::Org::Eclipse::Jface::Text, :AbstractInformationControlManager
      include_const ::Org::Eclipse::Jface::Text, :BadLocationException
      include_const ::Org::Eclipse::Jface::Text, :DocumentEvent
      include_const ::Org::Eclipse::Jface::Text, :IDocument
      include_const ::Org::Eclipse::Jface::Text, :IDocumentListener
      include_const ::Org::Eclipse::Jface::Text, :IEditingSupport
      include_const ::Org::Eclipse::Jface::Text, :IEditingSupportRegistry
      include_const ::Org::Eclipse::Jface::Text, :IInformationControl
      include_const ::Org::Eclipse::Jface::Text, :IRegion
      include_const ::Org::Eclipse::Jface::Text, :IRewriteTarget
      include_const ::Org::Eclipse::Jface::Text, :ITextViewer
      include_const ::Org::Eclipse::Jface::Text, :ITextViewerExtension
      include_const ::Org::Eclipse::Jface::Text, :TextUtilities
      include_const ::Org::Eclipse::Jface::Text::AbstractInformationControlManager, :Anchor
    }
  end
  
  # This class is used to present proposals to the user. If additional
  # information exists for a proposal, then selecting that proposal
  # will result in the information being displayed in a secondary
  # window.
  # 
  # @see org.eclipse.jface.text.contentassist.ICompletionProposal
  # @see org.eclipse.jface.text.contentassist.AdditionalInfoController
  class CompletionProposalPopup 
    include_class_members CompletionProposalPopupImports
    include IContentAssistListener
    
    class_module.module_eval {
      # Set to <code>true</code> to use a Table with SWT.VIRTUAL.
      # XXX: This is a workaround for: https://bugs.eclipse.org/bugs/show_bug.cgi?id=90321
      # More details see also: https://bugs.eclipse.org/bugs/show_bug.cgi?id=98585#c36
      # @since 3.1
      const_set_lazy(:USE_VIRTUAL) { !("motif" == SWT.get_platform) }
      const_attr_reader  :USE_VIRTUAL
      
      # $NON-NLS-1$
      # 
      # Completion proposal selection handler.
      # 
      # @since 3.4
      const_set_lazy(:ProposalSelectionHandler) { Class.new(AbstractHandler) do
        local_class_in CompletionProposalPopup
        include_class_members CompletionProposalPopup
        
        class_module.module_eval {
          # Selection operation codes.
          const_set_lazy(:SELECT_NEXT) { 1 }
          const_attr_reader  :SELECT_NEXT
          
          const_set_lazy(:SELECT_PREVIOUS) { 2 }
          const_attr_reader  :SELECT_PREVIOUS
        }
        
        attr_accessor :f_operation_code
        alias_method :attr_f_operation_code, :f_operation_code
        undef_method :f_operation_code
        alias_method :attr_f_operation_code=, :f_operation_code=
        undef_method :f_operation_code=
        
        typesig { [::Java::Int] }
        # Creates a new selection handler.
        # 
        # @param operationCode the operation code
        # @since 3.4
        def initialize(operation_code)
          @f_operation_code = 0
          super()
          Assert.is_legal((operation_code).equal?(self.class::SELECT_NEXT) || (operation_code).equal?(self.class::SELECT_PREVIOUS))
          @f_operation_code = operation_code
        end
        
        typesig { [class_self::ExecutionEvent] }
        # @see org.eclipse.core.commands.AbstractHandler#execute(org.eclipse.core.commands.ExecutionEvent)
        # @since 3.4
        def execute(event)
          item_count = self.attr_f_proposal_table.get_item_count
          selection_index = self.attr_f_proposal_table.get_selection_index
          case (@f_operation_code)
          when self.class::SELECT_NEXT
            selection_index += 1
            if (selection_index > item_count - 1)
              selection_index = 0
            end
          when self.class::SELECT_PREVIOUS
            selection_index -= 1
            if (selection_index < 0)
              selection_index = item_count - 1
            end
          end
          select_proposal(selection_index, false)
          return nil
        end
        
        private
        alias_method :initialize__proposal_selection_handler, :initialize
      end }
      
      # The empty proposal displayed if there is nothing else to show.
      # 
      # @since 3.2
      const_set_lazy(:EmptyProposal) { Class.new do
        include_class_members CompletionProposalPopup
        include ICompletionProposal
        include ICompletionProposalExtension
        
        attr_accessor :f_display_string
        alias_method :attr_f_display_string, :f_display_string
        undef_method :f_display_string
        alias_method :attr_f_display_string=, :f_display_string=
        undef_method :f_display_string=
        
        attr_accessor :f_offset
        alias_method :attr_f_offset, :f_offset
        undef_method :f_offset
        alias_method :attr_f_offset=, :f_offset=
        undef_method :f_offset=
        
        typesig { [class_self::IDocument] }
        # @see ICompletionProposal#apply(IDocument)
        def apply(document)
        end
        
        typesig { [class_self::IDocument] }
        # @see ICompletionProposal#getSelection(IDocument)
        def get_selection(document)
          return self.class::Point.new(@f_offset, 0)
        end
        
        typesig { [] }
        # @see ICompletionProposal#getContextInformation()
        def get_context_information
          return nil
        end
        
        typesig { [] }
        # @see ICompletionProposal#getImage()
        def get_image
          return nil
        end
        
        typesig { [] }
        # @see ICompletionProposal#getDisplayString()
        def get_display_string
          return @f_display_string
        end
        
        typesig { [] }
        # @see ICompletionProposal#getAdditionalProposalInfo()
        def get_additional_proposal_info
          return nil
        end
        
        typesig { [class_self::IDocument, ::Java::Char, ::Java::Int] }
        # @see org.eclipse.jface.text.contentassist.ICompletionProposalExtension#apply(org.eclipse.jface.text.IDocument, char, int)
        def apply(document, trigger, offset)
        end
        
        typesig { [class_self::IDocument, ::Java::Int] }
        # @see org.eclipse.jface.text.contentassist.ICompletionProposalExtension#isValidFor(org.eclipse.jface.text.IDocument, int)
        def is_valid_for(document, offset)
          return false
        end
        
        typesig { [] }
        # @see org.eclipse.jface.text.contentassist.ICompletionProposalExtension#getTriggerCharacters()
        def get_trigger_characters
          return nil
        end
        
        typesig { [] }
        # @see org.eclipse.jface.text.contentassist.ICompletionProposalExtension#getContextInformationPosition()
        def get_context_information_position
          return -1
        end
        
        typesig { [] }
        def initialize
          @f_display_string = nil
          @f_offset = 0
        end
        
        private
        alias_method :initialize__empty_proposal, :initialize
      end }
      
      const_set_lazy(:ProposalSelectionListener) { Class.new do
        local_class_in CompletionProposalPopup
        include_class_members CompletionProposalPopup
        include KeyListener
        
        typesig { [class_self::KeyEvent] }
        def key_pressed(e)
          if (!Helper.ok_to_use(self.attr_f_proposal_shell))
            return
          end
          if ((e.attr_character).equal?(0) && (e.attr_key_code).equal?(SWT::CTRL))
            # http://dev.eclipse.org/bugs/show_bug.cgi?id=34754
            index = self.attr_f_proposal_table.get_selection_index
            if (index >= 0)
              select_proposal(index, true)
            end
          end
        end
        
        typesig { [class_self::KeyEvent] }
        def key_released(e)
          if (!Helper.ok_to_use(self.attr_f_proposal_shell))
            return
          end
          if ((e.attr_character).equal?(0) && (e.attr_key_code).equal?(SWT::CTRL))
            # http://dev.eclipse.org/bugs/show_bug.cgi?id=34754
            index = self.attr_f_proposal_table.get_selection_index
            if (index >= 0)
              select_proposal(index, false)
            end
          end
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__proposal_selection_listener, :initialize
      end }
      
      const_set_lazy(:CommandKeyListener) { Class.new(KeyAdapter) do
        local_class_in CompletionProposalPopup
        include_class_members CompletionProposalPopup
        
        attr_accessor :f_command_sequence
        alias_method :attr_f_command_sequence, :f_command_sequence
        undef_method :f_command_sequence
        alias_method :attr_f_command_sequence=, :f_command_sequence=
        undef_method :f_command_sequence=
        
        typesig { [class_self::KeySequence] }
        def initialize(key_sequence)
          @f_command_sequence = nil
          super()
          @f_command_sequence = key_sequence
        end
        
        typesig { [class_self::KeyEvent] }
        def key_pressed(e)
          if (!Helper.ok_to_use(self.attr_f_proposal_shell))
            return
          end
          accelerator = SWTKeySupport.convert_event_to_unmodified_accelerator(e)
          sequence = KeySequence.get_instance(SWTKeySupport.convert_accelerator_to_key_stroke(accelerator))
          if ((sequence == @f_command_sequence))
            if (self.attr_f_content_assistant.is_prefix_completion_enabled)
              incremental_complete
            else
              show_proposals(false)
            end
          end
        end
        
        private
        alias_method :initialize__command_key_listener, :initialize
      end }
    }
    
    # The associated text viewer.
    attr_accessor :f_viewer
    alias_method :attr_f_viewer, :f_viewer
    undef_method :f_viewer
    alias_method :attr_f_viewer=, :f_viewer=
    undef_method :f_viewer=
    
    # The associated content assistant.
    attr_accessor :f_content_assistant
    alias_method :attr_f_content_assistant, :f_content_assistant
    undef_method :f_content_assistant
    alias_method :attr_f_content_assistant=, :f_content_assistant=
    undef_method :f_content_assistant=
    
    # The used additional info controller.
    attr_accessor :f_additional_info_controller
    alias_method :attr_f_additional_info_controller, :f_additional_info_controller
    undef_method :f_additional_info_controller
    alias_method :attr_f_additional_info_controller=, :f_additional_info_controller=
    undef_method :f_additional_info_controller=
    
    # The closing strategy for this completion proposal popup.
    attr_accessor :f_popup_closer
    alias_method :attr_f_popup_closer, :f_popup_closer
    undef_method :f_popup_closer
    alias_method :attr_f_popup_closer=, :f_popup_closer=
    undef_method :f_popup_closer=
    
    # The popup shell.
    attr_accessor :f_proposal_shell
    alias_method :attr_f_proposal_shell, :f_proposal_shell
    undef_method :f_proposal_shell
    alias_method :attr_f_proposal_shell=, :f_proposal_shell=
    undef_method :f_proposal_shell=
    
    # The proposal table.
    attr_accessor :f_proposal_table
    alias_method :attr_f_proposal_table, :f_proposal_table
    undef_method :f_proposal_table
    alias_method :attr_f_proposal_table=, :f_proposal_table=
    undef_method :f_proposal_table=
    
    # Indicates whether a completion proposal is being inserted.
    attr_accessor :f_inserting
    alias_method :attr_f_inserting, :f_inserting
    undef_method :f_inserting
    alias_method :attr_f_inserting=, :f_inserting=
    undef_method :f_inserting=
    
    # The key listener to control navigation.
    attr_accessor :f_key_listener
    alias_method :attr_f_key_listener, :f_key_listener
    undef_method :f_key_listener
    alias_method :attr_f_key_listener=, :f_key_listener=
    undef_method :f_key_listener=
    
    # List of document events used for filtering proposals.
    attr_accessor :f_document_events
    alias_method :attr_f_document_events, :f_document_events
    undef_method :f_document_events
    alias_method :attr_f_document_events=, :f_document_events=
    undef_method :f_document_events=
    
    # Listener filling the document event queue.
    attr_accessor :f_document_listener
    alias_method :attr_f_document_listener, :f_document_listener
    undef_method :f_document_listener
    alias_method :attr_f_document_listener=, :f_document_listener=
    undef_method :f_document_listener=
    
    # The filter list of proposals.
    attr_accessor :f_filtered_proposals
    alias_method :attr_f_filtered_proposals, :f_filtered_proposals
    undef_method :f_filtered_proposals
    alias_method :attr_f_filtered_proposals=, :f_filtered_proposals=
    undef_method :f_filtered_proposals=
    
    # The computed list of proposals.
    attr_accessor :f_computed_proposals
    alias_method :attr_f_computed_proposals, :f_computed_proposals
    undef_method :f_computed_proposals
    alias_method :attr_f_computed_proposals=, :f_computed_proposals=
    undef_method :f_computed_proposals=
    
    # The offset for which the proposals have been computed.
    attr_accessor :f_invocation_offset
    alias_method :attr_f_invocation_offset, :f_invocation_offset
    undef_method :f_invocation_offset
    alias_method :attr_f_invocation_offset=, :f_invocation_offset=
    undef_method :f_invocation_offset=
    
    # The offset for which the computed proposals have been filtered.
    attr_accessor :f_filter_offset
    alias_method :attr_f_filter_offset, :f_filter_offset
    undef_method :f_filter_offset
    alias_method :attr_f_filter_offset=, :f_filter_offset=
    undef_method :f_filter_offset=
    
    # The most recently selected proposal.
    # @since 3.0
    attr_accessor :f_last_proposal
    alias_method :attr_f_last_proposal, :f_last_proposal
    undef_method :f_last_proposal
    alias_method :attr_f_last_proposal=, :f_last_proposal=
    undef_method :f_last_proposal=
    
    # The content assist subject control.
    # This replaces <code>fViewer</code>
    # 
    # @since 3.0
    attr_accessor :f_content_assist_subject_control
    alias_method :attr_f_content_assist_subject_control, :f_content_assist_subject_control
    undef_method :f_content_assist_subject_control
    alias_method :attr_f_content_assist_subject_control=, :f_content_assist_subject_control=
    undef_method :f_content_assist_subject_control=
    
    # The content assist subject control adapter.
    # This replaces <code>fViewer</code>
    # 
    # @since 3.0
    attr_accessor :f_content_assist_subject_control_adapter
    alias_method :attr_f_content_assist_subject_control_adapter, :f_content_assist_subject_control_adapter
    undef_method :f_content_assist_subject_control_adapter
    alias_method :attr_f_content_assist_subject_control_adapter=, :f_content_assist_subject_control_adapter=
    undef_method :f_content_assist_subject_control_adapter=
    
    # Remembers the size for this completion proposal popup.
    # @since 3.0
    attr_accessor :f_size
    alias_method :attr_f_size, :f_size
    undef_method :f_size
    alias_method :attr_f_size=, :f_size=
    undef_method :f_size=
    
    # Editor helper that communicates that the completion proposal popup may
    # have focus while the 'logical focus' is still with the editor.
    # @since 3.1
    attr_accessor :f_focus_helper
    alias_method :attr_f_focus_helper, :f_focus_helper
    undef_method :f_focus_helper
    alias_method :attr_f_focus_helper=, :f_focus_helper=
    undef_method :f_focus_helper=
    
    # Set to true by {@link #computeFilteredProposals(int, DocumentEvent)} if
    # the returned proposals are a subset of {@link #fFilteredProposals},
    # <code>false</code> if not.
    # @since 3.1
    attr_accessor :f_is_filtered_subset
    alias_method :attr_f_is_filtered_subset, :f_is_filtered_subset
    undef_method :f_is_filtered_subset
    alias_method :attr_f_is_filtered_subset=, :f_is_filtered_subset=
    undef_method :f_is_filtered_subset=
    
    # The filter runnable.
    # 
    # @since 3.1.1
    attr_accessor :f_filter_runnable
    alias_method :attr_f_filter_runnable, :f_filter_runnable
    undef_method :f_filter_runnable
    alias_method :attr_f_filter_runnable=, :f_filter_runnable=
    undef_method :f_filter_runnable=
    
    # <code>true</code> if <code>fFilterRunnable</code> has been
    # posted, <code>false</code> if not.
    # 
    # @since 3.1.1
    attr_accessor :f_is_filter_pending
    alias_method :attr_f_is_filter_pending, :f_is_filter_pending
    undef_method :f_is_filter_pending
    alias_method :attr_f_is_filter_pending=, :f_is_filter_pending=
    undef_method :f_is_filter_pending=
    
    # The info message at the bottom of the popup, or <code>null</code> for no popup (if
    # ContentAssistant does not provide one).
    # 
    # @since 3.2
    attr_accessor :f_message_text
    alias_method :attr_f_message_text, :f_message_text
    undef_method :f_message_text
    alias_method :attr_f_message_text=, :f_message_text=
    undef_method :f_message_text=
    
    # The font used for <code>fMessageText</code> or null; dispose when done.
    # 
    # @since 3.2
    attr_accessor :f_message_text_font
    alias_method :attr_f_message_text_font, :f_message_text_font
    undef_method :f_message_text_font
    alias_method :attr_f_message_text_font=, :f_message_text_font=
    undef_method :f_message_text_font=
    
    # The most recent completion offset (used to determine repeated invocation)
    # 
    # @since 3.2
    attr_accessor :f_last_completion_offset
    alias_method :attr_f_last_completion_offset, :f_last_completion_offset
    undef_method :f_last_completion_offset
    alias_method :attr_f_last_completion_offset=, :f_last_completion_offset=
    undef_method :f_last_completion_offset=
    
    # The (reusable) empty proposal.
    # 
    # @since 3.2
    attr_accessor :f_empty_proposal
    alias_method :attr_f_empty_proposal, :f_empty_proposal
    undef_method :f_empty_proposal
    alias_method :attr_f_empty_proposal=, :f_empty_proposal=
    undef_method :f_empty_proposal=
    
    # The text for the empty proposal, or <code>null</code> to use the default text.
    # 
    # @since 3.2
    attr_accessor :f_empty_message
    alias_method :attr_f_empty_message, :f_empty_message
    undef_method :f_empty_message
    alias_method :attr_f_empty_message=, :f_empty_message=
    undef_method :f_empty_message=
    
    # Tells whether colored labels support is enabled.
    # Only valid while the popup is active.
    # 
    # @since 3.4
    attr_accessor :f_is_colored_labels_support_enabled
    alias_method :attr_f_is_colored_labels_support_enabled, :f_is_colored_labels_support_enabled
    undef_method :f_is_colored_labels_support_enabled
    alias_method :attr_f_is_colored_labels_support_enabled=, :f_is_colored_labels_support_enabled=
    undef_method :f_is_colored_labels_support_enabled=
    
    typesig { [ContentAssistant, ITextViewer, AdditionalInfoController] }
    # Creates a new completion proposal popup for the given elements.
    # 
    # @param contentAssistant the content assistant feeding this popup
    # @param viewer the viewer on top of which this popup appears
    # @param infoController the information control collaborating with this popup
    # @since 2.0
    def initialize(content_assistant, viewer, info_controller)
      @f_viewer = nil
      @f_content_assistant = nil
      @f_additional_info_controller = nil
      @f_popup_closer = PopupCloser.new
      @f_proposal_shell = nil
      @f_proposal_table = nil
      @f_inserting = false
      @f_key_listener = nil
      @f_document_events = ArrayList.new
      @f_document_listener = nil
      @f_filtered_proposals = nil
      @f_computed_proposals = nil
      @f_invocation_offset = 0
      @f_filter_offset = 0
      @f_last_proposal = nil
      @f_content_assist_subject_control = nil
      @f_content_assist_subject_control_adapter = nil
      @f_size = nil
      @f_focus_helper = nil
      @f_is_filtered_subset = false
      @f_filter_runnable = Class.new(Runnable.class == Class ? Runnable : Object) do
        local_class_in CompletionProposalPopup
        include_class_members CompletionProposalPopup
        include Runnable if Runnable.class == Module
        
        typesig { [] }
        define_method :run do
          if (!self.attr_f_is_filter_pending)
            return
          end
          self.attr_f_is_filter_pending = false
          if (!Helper.ok_to_use(self.attr_f_content_assist_subject_control_adapter.get_control))
            return
          end
          offset = self.attr_f_content_assist_subject_control_adapter.get_selected_range.attr_x
          proposals = nil
          begin
            if (offset > -1)
              event = TextUtilities.merge_processed_document_events(self.attr_f_document_events)
              proposals = compute_filtered_proposals(offset, event)
            end
          rescue self.class::BadLocationException => x
          ensure
            self.attr_f_document_events.clear
          end
          self.attr_f_filter_offset = offset
          if (!(proposals).nil? && proposals.attr_length > 0)
            set_proposals(proposals, self.attr_f_is_filtered_subset)
          else
            hide
          end
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
      @f_is_filter_pending = false
      @f_message_text = nil
      @f_message_text_font = nil
      @f_last_completion_offset = 0
      @f_empty_proposal = EmptyProposal.new
      @f_empty_message = nil
      @f_is_colored_labels_support_enabled = false
      @f_content_assistant = content_assistant
      @f_viewer = viewer
      @f_additional_info_controller = info_controller
      @f_content_assist_subject_control_adapter = ContentAssistSubjectControlAdapter.new(@f_viewer)
    end
    
    typesig { [ContentAssistant, IContentAssistSubjectControl, AdditionalInfoController] }
    # Creates a new completion proposal popup for the given elements.
    # 
    # @param contentAssistant the content assistant feeding this popup
    # @param contentAssistSubjectControl the content assist subject control on top of which this popup appears
    # @param infoController the information control collaborating with this popup
    # @since 3.0
    def initialize(content_assistant, content_assist_subject_control, info_controller)
      @f_viewer = nil
      @f_content_assistant = nil
      @f_additional_info_controller = nil
      @f_popup_closer = PopupCloser.new
      @f_proposal_shell = nil
      @f_proposal_table = nil
      @f_inserting = false
      @f_key_listener = nil
      @f_document_events = ArrayList.new
      @f_document_listener = nil
      @f_filtered_proposals = nil
      @f_computed_proposals = nil
      @f_invocation_offset = 0
      @f_filter_offset = 0
      @f_last_proposal = nil
      @f_content_assist_subject_control = nil
      @f_content_assist_subject_control_adapter = nil
      @f_size = nil
      @f_focus_helper = nil
      @f_is_filtered_subset = false
      @f_filter_runnable = Class.new(Runnable.class == Class ? Runnable : Object) do
        local_class_in CompletionProposalPopup
        include_class_members CompletionProposalPopup
        include Runnable if Runnable.class == Module
        
        typesig { [] }
        define_method :run do
          if (!self.attr_f_is_filter_pending)
            return
          end
          self.attr_f_is_filter_pending = false
          if (!Helper.ok_to_use(self.attr_f_content_assist_subject_control_adapter.get_control))
            return
          end
          offset = self.attr_f_content_assist_subject_control_adapter.get_selected_range.attr_x
          proposals = nil
          begin
            if (offset > -1)
              event = TextUtilities.merge_processed_document_events(self.attr_f_document_events)
              proposals = compute_filtered_proposals(offset, event)
            end
          rescue self.class::BadLocationException => x
          ensure
            self.attr_f_document_events.clear
          end
          self.attr_f_filter_offset = offset
          if (!(proposals).nil? && proposals.attr_length > 0)
            set_proposals(proposals, self.attr_f_is_filtered_subset)
          else
            hide
          end
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
      @f_is_filter_pending = false
      @f_message_text = nil
      @f_message_text_font = nil
      @f_last_completion_offset = 0
      @f_empty_proposal = EmptyProposal.new
      @f_empty_message = nil
      @f_is_colored_labels_support_enabled = false
      @f_content_assistant = content_assistant
      @f_content_assist_subject_control = content_assist_subject_control
      @f_additional_info_controller = info_controller
      @f_content_assist_subject_control_adapter = ContentAssistSubjectControlAdapter.new(@f_content_assist_subject_control)
    end
    
    typesig { [::Java::Boolean] }
    # Computes and presents completion proposals. The flag indicates whether this call has
    # be made out of an auto activation context.
    # 
    # @param autoActivated <code>true</code> if auto activation context
    # @return an error message or <code>null</code> in case of no error
    def show_proposals(auto_activated)
      if ((@f_key_listener).nil?)
        @f_key_listener = ProposalSelectionListener.new_local(self)
      end
      control = @f_content_assist_subject_control_adapter.get_control
      if (!Helper.ok_to_use(@f_proposal_shell) && !(control).nil? && !control.is_disposed)
        # add the listener before computing the proposals so we don't move the caret
        # when the user types fast.
        @f_content_assist_subject_control_adapter.add_key_listener(@f_key_listener)
        BusyIndicator.show_while(control.get_display, Class.new(Runnable.class == Class ? Runnable : Object) do
          local_class_in CompletionProposalPopup
          include_class_members CompletionProposalPopup
          include Runnable if Runnable.class == Module
          
          typesig { [] }
          define_method :run do
            self.attr_f_invocation_offset = self.attr_f_content_assist_subject_control_adapter.get_selected_range.attr_x
            self.attr_f_filter_offset = self.attr_f_invocation_offset
            self.attr_f_last_completion_offset = self.attr_f_filter_offset
            self.attr_f_computed_proposals = compute_proposals(self.attr_f_invocation_offset)
            count = ((self.attr_f_computed_proposals).nil? ? 0 : self.attr_f_computed_proposals.attr_length)
            if ((count).equal?(0) && hide_when_no_proposals(auto_activated))
              return
            end
            if ((count).equal?(1) && !auto_activated && can_auto_insert(self.attr_f_computed_proposals[0]))
              insert_proposal(self.attr_f_computed_proposals[0], RJava.cast_to_char(0), 0, self.attr_f_invocation_offset)
              hide
            else
              create_proposal_selector
              set_proposals(self.attr_f_computed_proposals, false)
              display_proposals
            end
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      else
        @f_last_completion_offset = @f_filter_offset
        handle_repeated_invocation
      end
      return get_error_message
    end
    
    typesig { [::Java::Boolean] }
    # Hides the popup and returns <code>true</code> if the popup is configured
    # to never display an empty list. Returns <code>false</code> otherwise.
    # 
    # @param autoActivated whether the invocation was auto-activated
    # @return <code>false</code> if an empty list should be displayed, <code>true</code> otherwise
    # @since 3.2
    def hide_when_no_proposals(auto_activated)
      if (auto_activated || !@f_content_assistant.is_show_empty_list)
        if (!auto_activated)
          control = @f_content_assist_subject_control_adapter.get_control
          if (!(control).nil? && !control.is_disposed)
            control.get_display.beep
          end
        end
        hide
        return true
      end
      return false
    end
    
    typesig { [] }
    # If content assist is set up to handle cycling, then the proposals are recomputed. Otherwise,
    # nothing happens.
    # 
    # @since 3.2
    def handle_repeated_invocation
      if (@f_content_assistant.is_repeated_invocation_mode)
        @f_computed_proposals = compute_proposals(@f_filter_offset)
        set_proposals(@f_computed_proposals, false)
      end
    end
    
    typesig { [::Java::Int] }
    # Returns the completion proposal available at the given offset of the
    # viewer's document. Delegates the work to the content assistant.
    # 
    # @param offset the offset
    # @return the completion proposals available at this offset
    def compute_proposals(offset)
      if (!(@f_content_assist_subject_control).nil?)
        return @f_content_assistant.compute_completion_proposals(@f_content_assist_subject_control, offset)
      end
      return @f_content_assistant.compute_completion_proposals(@f_viewer, offset)
    end
    
    typesig { [] }
    # Returns the error message.
    # 
    # @return the error message
    def get_error_message
      return @f_content_assistant.get_error_message
    end
    
    typesig { [] }
    # Creates the proposal selector.
    def create_proposal_selector
      if (Helper.ok_to_use(@f_proposal_shell))
        return
      end
      control = @f_content_assist_subject_control_adapter.get_control
      @f_proposal_shell = Shell.new(control.get_shell, SWT::ON_TOP | SWT::RESIZE)
      @f_proposal_shell.set_font(JFaceResources.get_default_font)
      if (USE_VIRTUAL)
        @f_proposal_table = Table.new(@f_proposal_shell, SWT::H_SCROLL | SWT::V_SCROLL | SWT::VIRTUAL)
        listener = Class.new(Listener.class == Class ? Listener : Object) do
          local_class_in CompletionProposalPopup
          include_class_members CompletionProposalPopup
          include Listener if Listener.class == Module
          
          typesig { [Event] }
          define_method :handle_event do |event|
            handle_set_data(event)
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self)
        @f_proposal_table.add_listener(SWT::SetData, listener)
      else
        @f_proposal_table = Table.new(@f_proposal_shell, SWT::H_SCROLL | SWT::V_SCROLL)
      end
      @f_is_colored_labels_support_enabled = @f_content_assistant.is_colored_labels_support_enabled
      if (@f_is_colored_labels_support_enabled)
        TableOwnerDrawSupport.install(@f_proposal_table)
      end
      @f_proposal_table.set_location(0, 0)
      if (!(@f_additional_info_controller).nil?)
        @f_additional_info_controller.set_size_constraints(50, 10, true, true)
      end
      layout = GridLayout.new
      layout.attr_margin_width = 0
      layout.attr_margin_height = 0
      layout.attr_vertical_spacing = 1
      @f_proposal_shell.set_layout(layout)
      if (@f_content_assistant.is_status_line_visible)
        create_message_text
      end
      data = GridData.new(GridData::FILL_BOTH)
      size = @f_content_assistant.restore_completion_proposal_popup_size
      if (!(size).nil?)
        @f_proposal_table.set_layout_data(data)
        @f_proposal_shell.set_size(size)
      else
        height = @f_proposal_table.get_item_height * 10
        # use golden ratio as default aspect ratio
        aspect_ratio = (1 + Math.sqrt(5)) / 2
        width = RJava.cast_to_int((height * aspect_ratio))
        trim = @f_proposal_table.compute_trim(0, 0, width, height)
        data.attr_height_hint = trim.attr_height
        data.attr_width_hint = trim.attr_width
        @f_proposal_table.set_layout_data(data)
        @f_proposal_shell.pack
      end
      @f_content_assistant.add_to_layout(self, @f_proposal_shell, ContentAssistant::LayoutManager::LAYOUT_PROPOSAL_SELECTOR, @f_content_assistant.get_selection_offset)
      @f_proposal_shell.add_control_listener(Class.new(ControlListener.class == Class ? ControlListener : Object) do
        local_class_in CompletionProposalPopup
        include_class_members CompletionProposalPopup
        include ControlListener if ControlListener.class == Module
        
        typesig { [ControlEvent] }
        define_method :control_moved do |e|
        end
        
        typesig { [ControlEvent] }
        define_method :control_resized do |e|
          if (!(self.attr_f_additional_info_controller).nil?)
            # reset the cached resize constraints
            self.attr_f_additional_info_controller.set_size_constraints(50, 10, true, false)
          end
          self.attr_f_size = self.attr_f_proposal_shell.get_size
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      @f_proposal_shell.set_background(control.get_display.get_system_color(SWT::COLOR_GRAY))
      c = get_background_color(control)
      @f_proposal_table.set_background(c)
      c = get_foreground_color(control)
      @f_proposal_table.set_foreground(c)
      @f_proposal_table.add_selection_listener(Class.new(SelectionListener.class == Class ? SelectionListener : Object) do
        local_class_in CompletionProposalPopup
        include_class_members CompletionProposalPopup
        include SelectionListener if SelectionListener.class == Module
        
        typesig { [SelectionEvent] }
        define_method :widget_selected do |e|
        end
        
        typesig { [SelectionEvent] }
        define_method :widget_default_selected do |e|
          insert_selected_proposal_with_mask(e.attr_state_mask)
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      @f_popup_closer.install(@f_content_assistant, @f_proposal_table, @f_additional_info_controller)
      @f_proposal_shell.add_dispose_listener(Class.new(DisposeListener.class == Class ? DisposeListener : Object) do
        local_class_in CompletionProposalPopup
        include_class_members CompletionProposalPopup
        include DisposeListener if DisposeListener.class == Module
        
        typesig { [DisposeEvent] }
        define_method :widget_disposed do |e|
          unregister # but don't dispose the shell, since we're being called from its disposal event!
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      @f_proposal_table.set_header_visible(false)
      add_command_support(@f_proposal_table)
    end
    
    typesig { [] }
    # Returns the minimal required height for the proposal, may return 0 if the popup has not been
    # created yet.
    # 
    # @return the minimal height
    # @since 3.3
    def get_minimal_height
      height = 0
      if (Helper.ok_to_use(@f_proposal_table))
        items = @f_proposal_table.get_item_height * 10
        trim = @f_proposal_table.compute_trim(0, 0, SWT::DEFAULT, items)
        height = trim.attr_height
      end
      if (Helper.ok_to_use(@f_message_text))
        height += @f_message_text.get_size.attr_y + 1
      end
      return height
    end
    
    typesig { [Control] }
    # Adds command support to the given control.
    # 
    # @param control the control to watch for focus
    # @since 3.2
    def add_command_support(control)
      command_sequence = @f_content_assistant.get_repeated_invocation_key_sequence
      if (!(command_sequence).nil? && !command_sequence.is_empty && @f_content_assistant.is_repeated_invocation_mode)
        control.add_focus_listener(Class.new(FocusListener.class == Class ? FocusListener : Object) do
          local_class_in CompletionProposalPopup
          include_class_members CompletionProposalPopup
          include FocusListener if FocusListener.class == Module
          
          attr_accessor :f_command_key_listener
          alias_method :attr_f_command_key_listener, :f_command_key_listener
          undef_method :f_command_key_listener
          alias_method :attr_f_command_key_listener=, :f_command_key_listener=
          undef_method :f_command_key_listener=
          
          typesig { [FocusEvent] }
          define_method :focus_gained do |e|
            if (Helper.ok_to_use(control))
              if ((@f_command_key_listener).nil?)
                @f_command_key_listener = self.class::CommandKeyListener.new(command_sequence)
                self.attr_f_proposal_table.add_key_listener(@f_command_key_listener)
              end
            end
          end
          
          typesig { [FocusEvent] }
          define_method :focus_lost do |e|
            if (!(@f_command_key_listener).nil?)
              control.remove_key_listener(@f_command_key_listener)
              @f_command_key_listener = nil
            end
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            @f_command_key_listener = nil
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      end
      control.add_focus_listener(Class.new(FocusListener.class == Class ? FocusListener : Object) do
        local_class_in CompletionProposalPopup
        include_class_members CompletionProposalPopup
        include FocusListener if FocusListener.class == Module
        
        attr_accessor :f_traverse_listener
        alias_method :attr_f_traverse_listener, :f_traverse_listener
        undef_method :f_traverse_listener
        alias_method :attr_f_traverse_listener=, :f_traverse_listener=
        undef_method :f_traverse_listener=
        
        typesig { [FocusEvent] }
        define_method :focus_gained do |e|
          if (Helper.ok_to_use(control))
            if ((@f_traverse_listener).nil?)
              focus_listener_class = self.class
              @f_traverse_listener = Class.new(self.class::TraverseListener.class == Class ? self.class::TraverseListener : Object) do
                local_class_in focus_listener_class
                include_class_members focus_listener_class
                include class_self::TraverseListener if class_self::TraverseListener.class == Module
                
                typesig { [class_self::TraverseEvent] }
                define_method :key_traversed do |event|
                  if ((event.attr_detail).equal?(SWT::TRAVERSE_TAB_NEXT))
                    i_control = self.attr_f_additional_info_controller.get_current_information_control2
                    if (self.attr_f_additional_info_controller.get_internal_accessor.can_replace(i_control))
                      self.attr_f_additional_info_controller.get_internal_accessor.replace_information_control(true)
                      event.attr_doit = false
                    end
                  end
                end
                
                typesig { [Vararg.new(Object)] }
                define_method :initialize do |*args|
                  super(*args)
                end
                
                private
                alias_method :initialize_anonymous, :initialize
              end.new_local(self)
              self.attr_f_proposal_table.add_traverse_listener(@f_traverse_listener)
            end
          end
        end
        
        typesig { [FocusEvent] }
        define_method :focus_lost do |e|
          if (!(@f_traverse_listener).nil?)
            control.remove_traverse_listener(@f_traverse_listener)
            @f_traverse_listener = nil
          end
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          @f_traverse_listener = nil
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
    end
    
    typesig { [Control] }
    # Returns the background color to use.
    # 
    # @param control the control to get the display from
    # @return the background color
    # @since 3.2
    def get_background_color(control)
      c = @f_content_assistant.get_proposal_selector_background
      if ((c).nil?)
        c = JFaceResources.get_color_registry.get(JFacePreferences::CONTENT_ASSIST_BACKGROUND_COLOR)
      end
      return c
    end
    
    typesig { [Control] }
    # Returns the foreground color to use.
    # 
    # @param control the control to get the display from
    # @return the foreground color
    # @since 3.2
    def get_foreground_color(control)
      c = @f_content_assistant.get_proposal_selector_foreground
      if ((c).nil?)
        c = JFaceResources.get_color_registry.get(JFacePreferences::CONTENT_ASSIST_FOREGROUND_COLOR)
      end
      return c
    end
    
    typesig { [] }
    # Creates the caption line under the proposal table.
    # 
    # @since 3.2
    def create_message_text
      if ((@f_message_text).nil?)
        @f_message_text = Label.new(@f_proposal_shell, SWT::RIGHT)
        text_data = GridData.new(SWT::FILL, SWT::BOTTOM, true, false)
        @f_message_text.set_layout_data(text_data)
        @f_message_text.set_text(RJava.cast_to_string(@f_content_assistant.get_status_message) + " ") # $NON-NLS-1$
        if ((@f_message_text_font).nil?)
          font = @f_message_text.get_font
          display = @f_proposal_shell.get_display
          font_datas = font.get_font_data
          i = 0
          while i < font_datas.attr_length
            font_datas[i].set_height(font_datas[i].get_height * 9 / 10)
            i += 1
          end
          @f_message_text_font = Font.new(display, font_datas)
        end
        @f_message_text.set_font(@f_message_text_font)
        @f_message_text.set_background(get_background_color(@f_proposal_shell))
        @f_message_text.set_foreground(get_foreground_color(@f_proposal_shell))
        if (@f_content_assistant.is_repeated_invocation_mode)
          @f_message_text.set_cursor(@f_proposal_shell.get_display.get_system_cursor(SWT::CURSOR_HAND))
          @f_message_text.add_mouse_listener(Class.new(MouseAdapter.class == Class ? MouseAdapter : Object) do
            local_class_in CompletionProposalPopup
            include_class_members CompletionProposalPopup
            include MouseAdapter if MouseAdapter.class == Module
            
            typesig { [MouseEvent] }
            define_method :mouse_up do |e|
              self.attr_f_last_completion_offset = self.attr_f_filter_offset
              self.attr_f_proposal_table.set_focus
              handle_repeated_invocation
            end
            
            typesig { [MouseEvent] }
            define_method :mouse_down do |e|
            end
            
            typesig { [Vararg.new(Object)] }
            define_method :initialize do |*args|
              super(*args)
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
        end
      end
    end
    
    typesig { [Event] }
    # @since 3.1
    def handle_set_data(event)
      item = event.attr_item
      index = @f_proposal_table.index_of(item)
      if (0 <= index && index < @f_filtered_proposals.attr_length)
        current = @f_filtered_proposals[index]
        display_string = nil
        style_ranges = nil
        if (@f_is_colored_labels_support_enabled && current.is_a?(ICompletionProposalExtension6))
          styled_string = (current).get_styled_display_string
          display_string = RJava.cast_to_string(styled_string.get_string)
          style_ranges = styled_string.get_style_ranges
        else
          display_string = RJava.cast_to_string(current.get_display_string)
        end
        item.set_text(display_string)
        if (@f_is_colored_labels_support_enabled)
          TableOwnerDrawSupport.store_style_ranges(item, 0, style_ranges)
        end
        item.set_image(current.get_image)
        item.set_data(current)
      else
        # this should not happen, but does on win32
      end
    end
    
    typesig { [] }
    # Returns the proposal selected in the proposal selector.
    # 
    # @return the selected proposal
    # @since 2.0
    def get_selected_proposal
      # Make sure that there is no filter runnable pending.
      # See https://bugs.eclipse.org/bugs/show_bug.cgi?id=31427
      if (@f_is_filter_pending)
        @f_filter_runnable.run
      end
      # filter runnable may have hidden the proposals
      if (!Helper.ok_to_use(@f_proposal_table))
        return nil
      end
      i = @f_proposal_table.get_selection_index
      if ((@f_filtered_proposals).nil? || i < 0 || i >= @f_filtered_proposals.attr_length)
        return nil
      end
      return @f_filtered_proposals[i]
    end
    
    typesig { [::Java::Int] }
    # Takes the selected proposal and applies it.
    # 
    # @param stateMask the state mask
    # @since 3.2
    def insert_selected_proposal_with_mask(state_mask)
      p = get_selected_proposal
      hide
      if (!(p).nil?)
        insert_proposal(p, RJava.cast_to_char(0), state_mask, @f_content_assist_subject_control_adapter.get_selected_range.attr_x)
      end
    end
    
    typesig { [ICompletionProposal, ::Java::Char, ::Java::Int, ::Java::Int] }
    # Applies the given proposal at the given offset. The given character is the
    # one that triggered the insertion of this proposal.
    # 
    # @param p the completion proposal
    # @param trigger the trigger character
    # @param stateMask the state mask
    # @param offset the offset
    # @since 2.1
    def insert_proposal(p, trigger, state_mask, offset)
      @f_inserting = true
      target = nil
      helper = Class.new(IEditingSupport.class == Class ? IEditingSupport : Object) do
        local_class_in CompletionProposalPopup
        include_class_members CompletionProposalPopup
        include IEditingSupport if IEditingSupport.class == Module
        
        typesig { [DocumentEvent, IRegion] }
        define_method :is_originator do |event, focus|
          return focus.get_offset <= offset && focus.get_offset + focus.get_length >= offset
        end
        
        typesig { [] }
        define_method :owns_focus_shell do
          return false
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
      begin
        document = @f_content_assist_subject_control_adapter.get_document
        if (@f_viewer.is_a?(ITextViewerExtension))
          extension = @f_viewer
          target = extension.get_rewrite_target
        end
        if (!(target).nil?)
          target.begin_compound_change
        end
        if (@f_viewer.is_a?(IEditingSupportRegistry))
          registry = @f_viewer
          registry.register(helper)
        end
        if (p.is_a?(ICompletionProposalExtension2) && !(@f_viewer).nil?)
          e = p
          e.apply(@f_viewer, trigger, state_mask, offset)
        else
          if (p.is_a?(ICompletionProposalExtension))
            e = p
            e.apply(document, trigger, offset)
          else
            p.apply(document)
          end
        end
        selection = p.get_selection(document)
        if (!(selection).nil?)
          @f_content_assist_subject_control_adapter.set_selected_range(selection.attr_x, selection.attr_y)
          @f_content_assist_subject_control_adapter.reveal_range(selection.attr_x, selection.attr_y)
        end
        info = p.get_context_information
        if (!(info).nil?)
          context_information_offset = 0
          if (p.is_a?(ICompletionProposalExtension))
            e = p
            context_information_offset = e.get_context_information_position
          else
            if ((selection).nil?)
              selection = @f_content_assist_subject_control_adapter.get_selected_range
            end
            context_information_offset = selection.attr_x + selection.attr_y
          end
          @f_content_assistant.show_context_information(info, context_information_offset)
        else
          @f_content_assistant.show_context_information(nil, -1)
        end
      ensure
        if (!(target).nil?)
          target.end_compound_change
        end
        if (@f_viewer.is_a?(IEditingSupportRegistry))
          registry = @f_viewer
          registry.unregister(helper)
        end
        @f_inserting = false
      end
    end
    
    typesig { [] }
    # Returns whether this popup has the focus.
    # 
    # @return <code>true</code> if the popup has the focus
    def has_focus
      if (Helper.ok_to_use(@f_proposal_shell))
        if ((@f_proposal_shell.is_focus_control || @f_proposal_table.is_focus_control))
          return true
        end
        # We have to delegate this query to the additional info controller
        # as well, since the content assistant is the widget token owner
        # and its closer does not know that the additional info control can
        # now also take focus.
        if (!(@f_additional_info_controller).nil?)
          information_control = @f_additional_info_controller.get_current_information_control2
          if (!(information_control).nil? && information_control.is_focus_control)
            return true
          end
          replacer = @f_additional_info_controller.get_internal_accessor.get_information_control_replacer
          if (!(replacer).nil?)
            information_control = replacer.get_current_information_control2
            if (!(information_control).nil? && information_control.is_focus_control)
              return true
            end
          end
        end
      end
      return false
    end
    
    typesig { [] }
    # Hides this popup.
    def hide
      unregister
      if (@f_viewer.is_a?(IEditingSupportRegistry))
        registry = @f_viewer
        registry.unregister(@f_focus_helper)
      end
      if (Helper.ok_to_use(@f_proposal_shell))
        @f_content_assistant.remove_content_assist_listener(self, ContentAssistant::PROPOSAL_SELECTOR)
        @f_popup_closer.uninstall
        @f_proposal_shell.set_visible(false)
        @f_proposal_shell.dispose
        @f_proposal_shell = nil
      end
      if (!(@f_message_text_font).nil?)
        @f_message_text_font.dispose
        @f_message_text_font = nil
      end
      if (!(@f_message_text).nil?)
        @f_message_text = nil
      end
      @f_empty_message = RJava.cast_to_string(nil)
      @f_last_completion_offset = -1
      @f_content_assistant.fire_session_end_event
    end
    
    typesig { [] }
    # Unregister this completion proposal popup.
    # 
    # @since 3.0
    def unregister
      if (!(@f_document_listener).nil?)
        document = @f_content_assist_subject_control_adapter.get_document
        if (!(document).nil?)
          document.remove_document_listener(@f_document_listener)
        end
        @f_document_listener = nil
      end
      @f_document_events.clear
      if (!(@f_key_listener).nil? && !(@f_content_assist_subject_control_adapter.get_control).nil? && !@f_content_assist_subject_control_adapter.get_control.is_disposed)
        @f_content_assist_subject_control_adapter.remove_key_listener(@f_key_listener)
        @f_key_listener = nil
      end
      if (!(@f_last_proposal).nil?)
        if (@f_last_proposal.is_a?(ICompletionProposalExtension2) && !(@f_viewer).nil?)
          extension = @f_last_proposal
          extension.unselected(@f_viewer)
        end
        @f_last_proposal = nil
      end
      @f_filtered_proposals = nil
      @f_computed_proposals = nil
      @f_content_assistant.possible_completions_closed
    end
    
    typesig { [] }
    # Returns whether this popup is active. It is active if the proposal selector is visible.
    # 
    # @return <code>true</code> if this popup is active
    def is_active
      return !(@f_proposal_shell).nil? && !@f_proposal_shell.is_disposed
    end
    
    typesig { [Array.typed(ICompletionProposal), ::Java::Boolean] }
    # Initializes the proposal selector with these given proposals.
    # @param proposals the proposals
    # @param isFilteredSubset if <code>true</code>, the proposal table is
    # not cleared, but the proposals that are not in the passed array
    # are removed from the displayed set
    def set_proposals(proposals, is_filtered_subset)
      old_proposals = @f_filtered_proposals
      old_proposal = get_selected_proposal # may trigger filtering and a reentrant call to setProposals()
      if (!(old_proposals).equal?(@f_filtered_proposals))
        # reentrant call was first - abort
        return
      end
      if (Helper.ok_to_use(@f_proposal_table))
        if (old_proposal.is_a?(ICompletionProposalExtension2) && !(@f_viewer).nil?)
          (old_proposal).unselected(@f_viewer)
        end
        if ((proposals).nil? || (proposals.attr_length).equal?(0))
          @f_empty_proposal.attr_f_offset = @f_filter_offset
          @f_empty_proposal.attr_f_display_string = !(@f_empty_message).nil? ? @f_empty_message : JFaceTextMessages.get_string("CompletionProposalPopup.no_proposals") # $NON-NLS-1$
          proposals = Array.typed(ICompletionProposal).new([@f_empty_proposal])
        end
        @f_filtered_proposals = proposals
        new_len = proposals.attr_length
        if (USE_VIRTUAL)
          @f_proposal_table.set_item_count(new_len)
          @f_proposal_table.clear_all
        else
          @f_proposal_table.set_redraw(false)
          @f_proposal_table.set_item_count(new_len)
          items = @f_proposal_table.get_items
          i = 0
          while i < items.attr_length
            item = items[i]
            proposal = proposals[i]
            item.set_text(proposal.get_display_string)
            item.set_image(proposal.get_image)
            item.set_data(proposal)
            i += 1
          end
          @f_proposal_table.set_redraw(true)
        end
        current_location = @f_proposal_shell.get_location
        new_location = get_location
        if ((new_location.attr_x < current_location.attr_x && (new_location.attr_y).equal?(current_location.attr_y)) || new_location.attr_y < current_location.attr_y)
          @f_proposal_shell.set_location(new_location)
        end
        select_proposal(0, false)
      end
    end
    
    typesig { [] }
    # Returns the graphical location at which this popup should be made visible.
    # 
    # @return the location of this popup
    def get_location
      caret = @f_content_assist_subject_control_adapter.get_caret_offset
      location = @f_content_assistant.get_layout_manager.compute_bounds_below_above(@f_proposal_shell, (@f_size).nil? ? @f_proposal_shell.get_size : @f_size, caret, self)
      return Geometry.get_location(location)
    end
    
    typesig { [] }
    # Returns the size of this completion proposal popup.
    # 
    # @return a Point containing the size
    # @since 3.0
    def get_size
      return @f_size
    end
    
    typesig { [] }
    # Displays this popup and install the additional info controller, so that additional info
    # is displayed when a proposal is selected and additional info is available.
    def display_proposals
      if (!Helper.ok_to_use(@f_proposal_shell) || !Helper.ok_to_use(@f_proposal_table))
        return
      end
      if (@f_content_assistant.add_content_assist_listener(self, ContentAssistant::PROPOSAL_SELECTOR))
        ensure_document_listener_installed
        if ((@f_focus_helper).nil?)
          @f_focus_helper = Class.new(IEditingSupport.class == Class ? IEditingSupport : Object) do
            local_class_in CompletionProposalPopup
            include_class_members CompletionProposalPopup
            include IEditingSupport if IEditingSupport.class == Module
            
            typesig { [DocumentEvent, IRegion] }
            define_method :is_originator do |event, focus|
              return false # this helper just covers the focus change to the proposal shell, no remote editions
            end
            
            typesig { [] }
            define_method :owns_focus_shell do
              return true
            end
            
            typesig { [Vararg.new(Object)] }
            define_method :initialize do |*args|
              super(*args)
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self)
        end
        if (@f_viewer.is_a?(IEditingSupportRegistry))
          registry = @f_viewer
          registry.register(@f_focus_helper)
        end
        # https://bugs.eclipse.org/bugs/show_bug.cgi?id=52646
        # on GTK, setVisible and such may run the event loop
        # (see also https://bugs.eclipse.org/bugs/show_bug.cgi?id=47511)
        # Since the user may have already canceled the popup or selected
        # an entry (ESC or RETURN), we have to double check whether
        # the table is still okToUse. See comments below
        @f_proposal_shell.set_visible(true) # may run event loop on GTK
        # transfer focus since no verify key listener can be attached
        if (!@f_content_assist_subject_control_adapter.supports_verify_key_listener && Helper.ok_to_use(@f_proposal_shell))
          @f_proposal_shell.set_focus
        end # may run event loop on GTK ??
        if (!(@f_additional_info_controller).nil? && Helper.ok_to_use(@f_proposal_table))
          @f_additional_info_controller.install(@f_proposal_table)
          @f_additional_info_controller.handle_table_selection_changed
        end
      else
        hide
      end
    end
    
    typesig { [] }
    # Installs the document listener if not already done.
    # 
    # @since 3.2
    def ensure_document_listener_installed
      if ((@f_document_listener).nil?)
        @f_document_listener = Class.new(IDocumentListener.class == Class ? IDocumentListener : Object) do
          local_class_in CompletionProposalPopup
          include_class_members CompletionProposalPopup
          include IDocumentListener if IDocumentListener.class == Module
          
          typesig { [DocumentEvent] }
          define_method :document_about_to_be_changed do |event|
            if (!self.attr_f_inserting)
              self.attr_f_document_events.add(event)
            end
          end
          
          typesig { [DocumentEvent] }
          define_method :document_changed do |event|
            if (!self.attr_f_inserting)
              filter_proposals
            end
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self)
        document = @f_content_assist_subject_control_adapter.get_document
        if (!(document).nil?)
          document.add_document_listener(@f_document_listener)
        end
      end
    end
    
    typesig { [VerifyEvent] }
    # @see IContentAssistListener#verifyKey(VerifyEvent)
    def verify_key(e)
      if (!Helper.ok_to_use(@f_proposal_shell))
        return true
      end
      key = e.attr_character
      if ((key).equal?(0))
        new_selection = @f_proposal_table.get_selection_index
        visible_rows = (@f_proposal_table.get_size.attr_y / @f_proposal_table.get_item_height) - 1
        item_count = @f_proposal_table.get_item_count
        smart_toggle = false
        case (e.attr_key_code)
        when SWT::ARROW_LEFT, SWT::ARROW_RIGHT
          filter_proposals
          return true
        when SWT::ARROW_UP
          new_selection -= 1
          if (new_selection < 0)
            new_selection = item_count - 1
          end
        when SWT::ARROW_DOWN
          new_selection += 1
          if (new_selection > item_count - 1)
            new_selection = 0
          end
        when SWT::PAGE_DOWN
          new_selection += visible_rows
          if (new_selection >= item_count)
            new_selection = item_count - 1
          end
        when SWT::PAGE_UP
          new_selection -= visible_rows
          if (new_selection < 0)
            new_selection = 0
          end
        when SWT::HOME
          new_selection = 0
        when SWT::END_
          new_selection = item_count - 1
        else
          if (!(e.attr_key_code).equal?(SWT::CAPS_LOCK) && !(e.attr_key_code).equal?(SWT::MOD1) && !(e.attr_key_code).equal?(SWT::MOD2) && !(e.attr_key_code).equal?(SWT::MOD3) && !(e.attr_key_code).equal?(SWT::MOD4))
            hide
          end
          return true
        end
        select_proposal(new_selection, smart_toggle)
        e.attr_doit = false
        return false
      end
      # key != 0
      case (key)
      # Ctrl-Enter on w2k
      when 0x1b
        # Esc
        e.attr_doit = false
        hide
      when Character.new(?\n.ord), Character.new(?\r.ord)
        # Enter
        e.attr_doit = false
        insert_selected_proposal_with_mask(e.attr_state_mask)
      when Character.new(?\t.ord)
        e.attr_doit = false
        @f_proposal_shell.set_focus
        return false
      else
        p = get_selected_proposal
        if (p.is_a?(ICompletionProposalExtension))
          t = p
          triggers = t.get_trigger_characters
          if (contains(triggers, key))
            e.attr_doit = false
            hide
            insert_proposal(p, key, e.attr_state_mask, @f_content_assist_subject_control_adapter.get_selected_range.attr_x)
          end
        end
      end
      return true
    end
    
    typesig { [::Java::Int, ::Java::Boolean] }
    # Selects the entry with the given index in the proposal selector and feeds
    # the selection to the additional info controller.
    # 
    # @param index the index in the list
    # @param smartToggle <code>true</code> if the smart toggle key has been pressed
    # @since 2.1
    def select_proposal(index, smart_toggle)
      old_proposal = get_selected_proposal
      if (old_proposal.is_a?(ICompletionProposalExtension2) && !(@f_viewer).nil?)
        (old_proposal).unselected(@f_viewer)
      end
      if ((@f_filtered_proposals).nil?)
        fire_selection_event(nil, smart_toggle)
        return
      end
      proposal = @f_filtered_proposals[index]
      if (proposal.is_a?(ICompletionProposalExtension2) && !(@f_viewer).nil?)
        (proposal).selected(@f_viewer, smart_toggle)
      end
      fire_selection_event(proposal, smart_toggle)
      @f_last_proposal = proposal
      @f_proposal_table.set_selection(index)
      @f_proposal_table.show_selection
      if (!(@f_additional_info_controller).nil?)
        @f_additional_info_controller.handle_table_selection_changed
      end
    end
    
    typesig { [ICompletionProposal, ::Java::Boolean] }
    # Fires a selection event, see {@link ICompletionListener}.
    # 
    # @param proposal the selected proposal, possibly <code>null</code>
    # @param smartToggle true if the smart toggle is on
    # @since 3.2
    def fire_selection_event(proposal, smart_toggle)
      @f_content_assistant.fire_selection_event(proposal, smart_toggle)
    end
    
    typesig { [Array.typed(::Java::Char), ::Java::Char] }
    # Returns whether the given character is contained in the given array of
    # characters.
    # 
    # @param characters the list of characters
    # @param c the character to look for in the list
    # @return <code>true</code> if character belongs to the list
    # @since 2.0
    def contains(characters, c)
      if ((characters).nil?)
        return false
      end
      i = 0
      while i < characters.attr_length
        if ((c).equal?(characters[i]))
          return true
        end
        i += 1
      end
      return false
    end
    
    typesig { [VerifyEvent] }
    # @see IEventConsumer#processEvent(VerifyEvent)
    def process_event(e)
    end
    
    typesig { [] }
    # Filters the displayed proposal based on the given cursor position and the
    # offset of the original invocation of the content assistant.
    def filter_proposals
      if (!@f_is_filter_pending)
        @f_is_filter_pending = true
        control = @f_content_assist_subject_control_adapter.get_control
        control.get_display.async_exec(@f_filter_runnable)
      end
    end
    
    typesig { [::Java::Int, DocumentEvent] }
    # Computes the subset of already computed proposals that are still valid for
    # the given offset.
    # 
    # @param offset the offset
    # @param event the merged document event
    # @return the set of filtered proposals
    # @since 3.0
    def compute_filtered_proposals(offset, event)
      if ((offset).equal?(@f_invocation_offset) && (event).nil?)
        @f_is_filtered_subset = false
        return @f_computed_proposals
      end
      if (offset < @f_invocation_offset)
        @f_is_filtered_subset = false
        @f_invocation_offset = offset
        @f_content_assistant.fire_session_restart_event
        @f_computed_proposals = compute_proposals(@f_invocation_offset)
        return @f_computed_proposals
      end
      proposals = nil
      if (offset < @f_filter_offset)
        proposals = @f_computed_proposals
        @f_is_filtered_subset = false
      else
        proposals = @f_filtered_proposals
        @f_is_filtered_subset = true
      end
      if ((proposals).nil?)
        @f_is_filtered_subset = false
        return nil
      end
      document = @f_content_assist_subject_control_adapter.get_document
      length = proposals.attr_length
      filtered = ArrayList.new(length)
      i = 0
      while i < length
        if (proposals[i].is_a?(ICompletionProposalExtension2))
          p = proposals[i]
          if (p.validate(document, offset, event))
            filtered.add(p)
          end
        else
          if (proposals[i].is_a?(ICompletionProposalExtension))
            p = proposals[i]
            if (p.is_valid_for(document, offset))
              filtered.add(p)
            end
          else
            # restore original behavior
            @f_is_filtered_subset = false
            @f_invocation_offset = offset
            @f_content_assistant.fire_session_restart_event
            @f_computed_proposals = compute_proposals(@f_invocation_offset)
            return @f_computed_proposals
          end
        end
        i += 1
      end
      return filtered.to_array(Array.typed(ICompletionProposal).new(filtered.size) { nil })
    end
    
    typesig { [] }
    # Requests the proposal shell to take focus.
    # 
    # @since 3.0
    def set_focus
      if (Helper.ok_to_use(@f_proposal_shell))
        @f_proposal_shell.set_focus
      end
    end
    
    typesig { [ICompletionProposal] }
    # Returns <code>true</code> if <code>proposal</code> should be auto-inserted,
    # <code>false</code> otherwise.
    # 
    # @param proposal the single proposal that might be automatically inserted
    # @return <code>true</code> if <code>proposal</code> can be inserted automatically,
    # <code>false</code> otherwise
    # @since 3.1
    def can_auto_insert(proposal)
      if (@f_content_assistant.is_auto_inserting)
        if (proposal.is_a?(ICompletionProposalExtension4))
          ext = proposal
          return ext.is_auto_insertable
        end
        return true # default behavior before ICompletionProposalExtension4 was introduced
      end
      return false
    end
    
    typesig { [] }
    # Completes the common prefix of all proposals directly in the code. If no
    # common prefix can be found, the proposal popup is shown.
    # 
    # @return an error message if completion failed.
    # @since 3.0
    def incremental_complete
      if (Helper.ok_to_use(@f_proposal_shell) && !(@f_filtered_proposals).nil?)
        if ((@f_last_completion_offset).equal?(@f_filter_offset))
          handle_repeated_invocation
        else
          @f_last_completion_offset = @f_filter_offset
          complete_common_prefix
        end
      else
        control = @f_content_assist_subject_control_adapter.get_control
        if ((@f_key_listener).nil?)
          @f_key_listener = ProposalSelectionListener.new_local(self)
        end
        if (!Helper.ok_to_use(@f_proposal_shell) && !control.is_disposed)
          @f_content_assist_subject_control_adapter.add_key_listener(@f_key_listener)
        end
        BusyIndicator.show_while(control.get_display, Class.new(Runnable.class == Class ? Runnable : Object) do
          local_class_in CompletionProposalPopup
          include_class_members CompletionProposalPopup
          include Runnable if Runnable.class == Module
          
          typesig { [] }
          define_method :run do
            self.attr_f_invocation_offset = self.attr_f_content_assist_subject_control_adapter.get_selected_range.attr_x
            self.attr_f_filter_offset = self.attr_f_invocation_offset
            self.attr_f_last_completion_offset = self.attr_f_filter_offset
            self.attr_f_filtered_proposals = compute_proposals(self.attr_f_invocation_offset)
            count = ((self.attr_f_filtered_proposals).nil? ? 0 : self.attr_f_filtered_proposals.attr_length)
            if ((count).equal?(0) && hide_when_no_proposals(false))
              return
            end
            if ((count).equal?(1) && can_auto_insert(self.attr_f_filtered_proposals[0]))
              insert_proposal(self.attr_f_filtered_proposals[0], RJava.cast_to_char(0), 0, self.attr_f_invocation_offset)
              hide
            else
              ensure_document_listener_installed
              if (count > 0 && complete_common_prefix)
                hide
              else
                self.attr_f_computed_proposals = self.attr_f_filtered_proposals
                create_proposal_selector
                set_proposals(self.attr_f_computed_proposals, false)
                display_proposals
              end
            end
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      end
      return get_error_message
    end
    
    typesig { [] }
    # Acts upon <code>fFilteredProposals</code>: if there is just one valid
    # proposal, it is inserted, otherwise, the common prefix of all proposals
    # is inserted into the document. If there is no common prefix, nothing
    # happens and <code>false</code> is returned.
    # 
    # @return <code>true</code> if a single proposal was inserted and the
    # selector can be closed, <code>false</code> otherwise
    # @since 3.0
    def complete_common_prefix
      # 0: insert single proposals
      if ((@f_filtered_proposals.attr_length).equal?(1))
        if (can_auto_insert(@f_filtered_proposals[0]))
          insert_proposal(@f_filtered_proposals[0], RJava.cast_to_char(0), 0, @f_filter_offset)
          hide
          return true
        end
        return false
      end
      # 1: extract pre- and postfix from all remaining proposals
      document = @f_content_assist_subject_control_adapter.get_document
      # contains the common postfix in the case that there are any proposals matching our LHS
      right_case_postfix = nil
      right_case = ArrayList.new
      is_wrong_case_match = false
      # the prefix of all case insensitive matches. This differs from the document
      # contents and will be replaced.
      wrong_case_prefix = nil
      wrong_case_prefix_start = 0
      # contains the common postfix of all case-insensitive matches
      wrong_case_postfix = nil
      wrong_case = ArrayList.new
      i = 0
      while i < @f_filtered_proposals.attr_length
        proposal = @f_filtered_proposals[i]
        if (!(proposal.is_a?(ICompletionProposalExtension3)))
          return false
        end
        start = (proposal).get_prefix_completion_start(@f_content_assist_subject_control_adapter.get_document, @f_filter_offset)
        insertion = (proposal).get_prefix_completion_text(@f_content_assist_subject_control_adapter.get_document, @f_filter_offset)
        if ((insertion).nil?)
          insertion = TextProcessor.deprocess(proposal.get_display_string)
        end
        begin
          prefix_length = @f_filter_offset - start
          relative_completion_offset = Math.min(insertion.length, prefix_length)
          prefix = document.get(start, prefix_length)
          if (!is_wrong_case_match && insertion.to_s.starts_with(prefix))
            is_wrong_case_match = false
            right_case.add(proposal)
            new_postfix = insertion.sub_sequence(relative_completion_offset, insertion.length)
            if ((right_case_postfix).nil?)
              right_case_postfix = StringBuffer.new(new_postfix.to_s)
            else
              truncate_postfix(right_case_postfix, new_postfix)
            end
          else
            if ((i).equal?(0) || is_wrong_case_match)
              new_prefix = insertion.sub_sequence(0, relative_completion_offset)
              if (is_prefix_compatible(wrong_case_prefix, wrong_case_prefix_start, new_prefix, start, document))
                is_wrong_case_match = true
                wrong_case_prefix = new_prefix
                wrong_case_prefix_start = start
                new_postfix = insertion.sub_sequence(relative_completion_offset, insertion.length)
                if ((wrong_case_postfix).nil?)
                  wrong_case_postfix = StringBuffer.new(new_postfix.to_s)
                else
                  truncate_postfix(wrong_case_postfix, new_postfix)
                end
                wrong_case.add(proposal)
              else
                return false
              end
            else
              return false
            end
          end
        rescue BadLocationException => e2
          # bail out silently
          return false
        end
        if (!(right_case_postfix).nil? && (right_case_postfix.length).equal?(0) && right_case.size > 1)
          return false
        end
        i += 1
      end
      # 2: replace single proposals
      if ((right_case.size).equal?(1))
        proposal = right_case.get(0)
        if (can_auto_insert(proposal) && right_case_postfix.length > 0)
          insert_proposal(proposal, RJava.cast_to_char(0), 0, @f_invocation_offset)
          hide
          return true
        end
        return false
      else
        if (is_wrong_case_match && (wrong_case.size).equal?(1))
          proposal = wrong_case.get(0)
          if (can_auto_insert(proposal))
            insert_proposal(proposal, RJava.cast_to_char(0), 0, @f_invocation_offset)
            hide
            return true
          end
          return false
        end
      end
      # 3: replace post- / prefixes
      prefix = nil
      if (is_wrong_case_match)
        prefix = wrong_case_prefix
      else
        prefix = ""
      end # $NON-NLS-1$
      postfix = nil
      if (is_wrong_case_match)
        postfix = wrong_case_postfix
      else
        postfix = right_case_postfix
      end
      if ((prefix).nil? || (postfix).nil?)
        return false
      end
      begin
        # 4: check if parts of the postfix are already in the document
        to = Math.min(document.get_length, @f_filter_offset + postfix.length)
        in_document = StringBuffer.new(document.get(@f_filter_offset, to - @f_filter_offset))
        truncate_postfix(in_document, postfix)
        # 5: replace and reveal
        document.replace(@f_filter_offset - prefix.length, prefix.length + in_document.length, prefix.to_s + postfix.to_s)
        @f_content_assist_subject_control_adapter.set_selected_range(@f_filter_offset + postfix.length, 0)
        @f_content_assist_subject_control_adapter.reveal_range(@f_filter_offset + postfix.length, 0)
        @f_filter_offset += postfix.length
        @f_last_completion_offset = @f_filter_offset
        return false
      rescue BadLocationException => e
        # ignore and return false
        return false
      end
    end
    
    typesig { [CharSequence, ::Java::Int, CharSequence, ::Java::Int, IDocument] }
    # @since 3.1
    def is_prefix_compatible(one_sequence, one_offset, two_sequence, two_offset, document)
      if ((one_sequence).nil? || (two_sequence).nil?)
        return true
      end
      min_ = Math.min(one_offset, two_offset)
      one_end = one_offset + one_sequence.length
      two_end = two_offset + two_sequence.length
      one = document.get(one_offset, min_ - one_offset) + one_sequence + document.get(one_end, Math.min(@f_filter_offset, @f_filter_offset - one_end))
      two = document.get(two_offset, min_ - two_offset) + two_sequence + document.get(two_end, Math.min(@f_filter_offset, @f_filter_offset - two_end))
      return (one == two)
    end
    
    typesig { [StringBuffer, CharSequence] }
    # Truncates <code>buffer</code> to the common prefix of <code>buffer</code>
    # and <code>sequence</code>.
    # 
    # @param buffer the common postfix to truncate
    # @param sequence the characters to truncate with
    def truncate_postfix(buffer, sequence)
      # find common prefix
      min_ = Math.min(buffer.length, sequence.length)
      c = 0
      while c < min_
        if (!(sequence.char_at(c)).equal?(buffer.char_at(c)))
          buffer.delete(c, buffer.length)
          return
        end
        c += 1
      end
      # all equal up to minimum
      buffer.delete(min_, buffer.length)
    end
    
    typesig { [String] }
    # Sets the message for the repetition affordance text at the bottom of the proposal. Only has
    # an effect if {@link ContentAssistant#isRepeatedInvocationMode()} returns <code>true</code>.
    # 
    # @param message the new caption
    # @since 3.2
    def set_message(message)
      Assert.is_not_null(message)
      if (is_active && !(@f_message_text).nil?)
        @f_message_text.set_text(message + " ")
      end # $NON-NLS-1$
    end
    
    typesig { [String] }
    # Sets the text to be displayed if no proposals are available. Only has an effect if
    # {@link ContentAssistant#isShowEmptyList()} returns <code>true</code>.
    # 
    # @param message the empty message
    # @since 3.2
    def set_empty_message(message)
      Assert.is_not_null(message)
      @f_empty_message = message
    end
    
    typesig { [::Java::Boolean] }
    # Enables or disables showing of the caption line. See also {@link #setMessage(String)}.
    # 
    # @param show <code>true</code> if the status line is visible
    # @since 3.2
    def set_status_line_visible(show)
      if (!is_active || (show).equal?((!(@f_message_text).nil?)))
        return
      end # nothing to do
      if (show)
        create_message_text
      else
        @f_message_text.dispose
        @f_message_text = nil
      end
      @f_proposal_shell.layout
    end
    
    typesig { [::Java::Boolean] }
    # Informs the popup that it is being placed above the caret line instead of below.
    # 
    # @param above <code>true</code> if the location of the popup is above the caret line, <code>false</code> if it is below
    # @since 3.3
    def switched_position_to_above(above)
      if (!(@f_additional_info_controller).nil?)
        @f_additional_info_controller.set_fallback_anchors(Array.typed(Anchor).new([AbstractInformationControlManager::ANCHOR_RIGHT, AbstractInformationControlManager::ANCHOR_LEFT, above ? AbstractInformationControlManager::ANCHOR_TOP : AbstractInformationControlManager::ANCHOR_BOTTOM]))
      end
    end
    
    typesig { [::Java::Int] }
    # Returns a new proposal selection handler.
    # 
    # @param operationCode the operation code
    # @return the handler
    # @since 3.4
    def create_proposal_selection_handler(operation_code)
      return ProposalSelectionHandler.new_local(self, operation_code)
    end
    
    private
    alias_method :initialize__completion_proposal_popup, :initialize
  end
  
end
