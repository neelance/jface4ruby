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
module Org::Eclipse::Jface::Internal::Text::Link::Contentassist
  module CompletionProposalPopup2Imports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Internal::Text::Link::Contentassist
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :JavaList
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Custom, :StyleRange
      include_const ::Org::Eclipse::Swt::Custom, :StyledText
      include_const ::Org::Eclipse::Swt::Events, :ControlEvent
      include_const ::Org::Eclipse::Swt::Events, :ControlListener
      include_const ::Org::Eclipse::Swt::Events, :DisposeEvent
      include_const ::Org::Eclipse::Swt::Events, :DisposeListener
      include_const ::Org::Eclipse::Swt::Events, :KeyEvent
      include_const ::Org::Eclipse::Swt::Events, :KeyListener
      include_const ::Org::Eclipse::Swt::Events, :SelectionEvent
      include_const ::Org::Eclipse::Swt::Events, :SelectionListener
      include_const ::Org::Eclipse::Swt::Events, :VerifyEvent
      include_const ::Org::Eclipse::Swt::Graphics, :Color
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Layout, :GridData
      include_const ::Org::Eclipse::Swt::Layout, :GridLayout
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Shell
      include_const ::Org::Eclipse::Swt::Widgets, :Table
      include_const ::Org::Eclipse::Swt::Widgets, :TableItem
      include_const ::Org::Eclipse::Jface::Internal::Text, :TableOwnerDrawSupport
      include_const ::Org::Eclipse::Jface::Resource, :JFaceResources
      include_const ::Org::Eclipse::Jface::Viewers, :StyledString
      include_const ::Org::Eclipse::Jface::Text, :BadLocationException
      include_const ::Org::Eclipse::Jface::Text, :DocumentEvent
      include_const ::Org::Eclipse::Jface::Text, :IDocument
      include_const ::Org::Eclipse::Jface::Text, :IDocumentListener
      include_const ::Org::Eclipse::Jface::Text, :IEditingSupport
      include_const ::Org::Eclipse::Jface::Text, :IEditingSupportRegistry
      include_const ::Org::Eclipse::Jface::Text, :IRegion
      include_const ::Org::Eclipse::Jface::Text, :IRewriteTarget
      include_const ::Org::Eclipse::Jface::Text, :ITextViewer
      include_const ::Org::Eclipse::Jface::Text, :ITextViewerExtension
      include_const ::Org::Eclipse::Jface::Text, :TextUtilities
      include_const ::Org::Eclipse::Jface::Text::Contentassist, :ICompletionProposal
      include_const ::Org::Eclipse::Jface::Text::Contentassist, :ICompletionProposalExtension
      include_const ::Org::Eclipse::Jface::Text::Contentassist, :ICompletionProposalExtension2
      include_const ::Org::Eclipse::Jface::Text::Contentassist, :ICompletionProposalExtension6
      include_const ::Org::Eclipse::Jface::Text::Contentassist, :IContextInformation
    }
  end
  
  # This class is used to present proposals to the user. If additional
  # information exists for a proposal, then selecting that proposal
  # will result in the information being displayed in a secondary
  # window.
  # 
  # @see org.eclipse.jface.text.contentassist.ICompletionProposal
  # @see org.eclipse.jface.internal.text.link.contentassist.AdditionalInfoController2
  class CompletionProposalPopup2 
    include_class_members CompletionProposalPopup2Imports
    include IContentAssistListener2
    
    # The associated text viewer
    attr_accessor :f_viewer
    alias_method :attr_f_viewer, :f_viewer
    undef_method :f_viewer
    alias_method :attr_f_viewer=, :f_viewer=
    undef_method :f_viewer=
    
    # The associated content assistant
    attr_accessor :f_content_assistant
    alias_method :attr_f_content_assistant, :f_content_assistant
    undef_method :f_content_assistant
    alias_method :attr_f_content_assistant=, :f_content_assistant=
    undef_method :f_content_assistant=
    
    # The used additional info controller
    attr_accessor :f_additional_info_controller
    alias_method :attr_f_additional_info_controller, :f_additional_info_controller
    undef_method :f_additional_info_controller
    alias_method :attr_f_additional_info_controller=, :f_additional_info_controller=
    undef_method :f_additional_info_controller=
    
    # The closing strategy for this completion proposal popup
    attr_accessor :f_popup_closer
    alias_method :attr_f_popup_closer, :f_popup_closer
    undef_method :f_popup_closer
    alias_method :attr_f_popup_closer=, :f_popup_closer=
    undef_method :f_popup_closer=
    
    # The popup shell
    attr_accessor :f_proposal_shell
    alias_method :attr_f_proposal_shell, :f_proposal_shell
    undef_method :f_proposal_shell
    alias_method :attr_f_proposal_shell=, :f_proposal_shell=
    undef_method :f_proposal_shell=
    
    # The proposal table
    attr_accessor :f_proposal_table
    alias_method :attr_f_proposal_table, :f_proposal_table
    undef_method :f_proposal_table
    alias_method :attr_f_proposal_table=, :f_proposal_table=
    undef_method :f_proposal_table=
    
    # Indicates whether a completion proposal is being inserted
    attr_accessor :f_inserting
    alias_method :attr_f_inserting, :f_inserting
    undef_method :f_inserting
    alias_method :attr_f_inserting=, :f_inserting=
    undef_method :f_inserting=
    
    # The key listener to control navigation
    attr_accessor :f_key_listener
    alias_method :attr_f_key_listener, :f_key_listener
    undef_method :f_key_listener
    alias_method :attr_f_key_listener=, :f_key_listener=
    undef_method :f_key_listener=
    
    # List of document events used for filtering proposals
    attr_accessor :f_document_events
    alias_method :attr_f_document_events, :f_document_events
    undef_method :f_document_events
    alias_method :attr_f_document_events=, :f_document_events=
    undef_method :f_document_events=
    
    # Listener filling the document event queue
    attr_accessor :f_document_listener
    alias_method :attr_f_document_listener, :f_document_listener
    undef_method :f_document_listener
    alias_method :attr_f_document_listener=, :f_document_listener=
    undef_method :f_document_listener=
    
    # Reentrance count for <code>filterProposals</code>
    attr_accessor :f_invocation_counter
    alias_method :attr_f_invocation_counter, :f_invocation_counter
    undef_method :f_invocation_counter
    alias_method :attr_f_invocation_counter=, :f_invocation_counter=
    undef_method :f_invocation_counter=
    
    # The filter list of proposals
    attr_accessor :f_filtered_proposals
    alias_method :attr_f_filtered_proposals, :f_filtered_proposals
    undef_method :f_filtered_proposals
    alias_method :attr_f_filtered_proposals=, :f_filtered_proposals=
    undef_method :f_filtered_proposals=
    
    # The computed list of proposals
    attr_accessor :f_computed_proposals
    alias_method :attr_f_computed_proposals, :f_computed_proposals
    undef_method :f_computed_proposals
    alias_method :attr_f_computed_proposals=, :f_computed_proposals=
    undef_method :f_computed_proposals=
    
    # The offset for which the proposals have been computed
    attr_accessor :f_invocation_offset
    alias_method :attr_f_invocation_offset, :f_invocation_offset
    undef_method :f_invocation_offset
    alias_method :attr_f_invocation_offset=, :f_invocation_offset=
    undef_method :f_invocation_offset=
    
    # The offset for which the computed proposals have been filtered
    attr_accessor :f_filter_offset
    alias_method :attr_f_filter_offset, :f_filter_offset
    undef_method :f_filter_offset
    alias_method :attr_f_filter_offset=, :f_filter_offset=
    undef_method :f_filter_offset=
    
    # The default line delimiter of the viewer's widget
    attr_accessor :f_line_delimiter
    alias_method :attr_f_line_delimiter, :f_line_delimiter
    undef_method :f_line_delimiter
    alias_method :attr_f_line_delimiter=, :f_line_delimiter=
    undef_method :f_line_delimiter=
    
    # The most recently selected proposal.
    attr_accessor :f_last_proposal
    alias_method :attr_f_last_proposal, :f_last_proposal
    undef_method :f_last_proposal
    alias_method :attr_f_last_proposal=, :f_last_proposal=
    undef_method :f_last_proposal=
    
    # Tells whether colored labels support is enabled.
    # Only valid while the popup is active.
    # 
    # @since 3.4
    attr_accessor :f_is_colored_labels_support_enabled
    alias_method :attr_f_is_colored_labels_support_enabled, :f_is_colored_labels_support_enabled
    undef_method :f_is_colored_labels_support_enabled
    alias_method :attr_f_is_colored_labels_support_enabled=, :f_is_colored_labels_support_enabled=
    undef_method :f_is_colored_labels_support_enabled=
    
    attr_accessor :f_focus_editing_support
    alias_method :attr_f_focus_editing_support, :f_focus_editing_support
    undef_method :f_focus_editing_support
    alias_method :attr_f_focus_editing_support=, :f_focus_editing_support=
    undef_method :f_focus_editing_support=
    
    attr_accessor :f_modification_editing_support
    alias_method :attr_f_modification_editing_support, :f_modification_editing_support
    undef_method :f_modification_editing_support
    alias_method :attr_f_modification_editing_support=, :f_modification_editing_support=
    undef_method :f_modification_editing_support=
    
    typesig { [ContentAssistant2, ITextViewer, AdditionalInfoController2] }
    # Creates a new completion proposal popup for the given elements.
    # 
    # @param contentAssistant the content assistant feeding this popup
    # @param viewer the viewer on top of which this popup appears
    # @param infoController the info control collaborating with this popup
    # @since 2.0
    def initialize(content_assistant, viewer, info_controller)
      @f_viewer = nil
      @f_content_assistant = nil
      @f_additional_info_controller = nil
      @f_popup_closer = PopupCloser2.new
      @f_proposal_shell = nil
      @f_proposal_table = nil
      @f_inserting = false
      @f_key_listener = nil
      @f_document_events = ArrayList.new
      @f_document_listener = nil
      @f_invocation_counter = 0
      @f_filtered_proposals = nil
      @f_computed_proposals = nil
      @f_invocation_offset = 0
      @f_filter_offset = 0
      @f_line_delimiter = nil
      @f_last_proposal = nil
      @f_is_colored_labels_support_enabled = false
      @f_focus_editing_support = Class.new(IEditingSupport.class == Class ? IEditingSupport : Object) do
        local_class_in CompletionProposalPopup2
        include_class_members CompletionProposalPopup2
        include IEditingSupport if IEditingSupport.class == Module
        
        typesig { [DocumentEvent, IRegion] }
        define_method :is_originator do |event, focus|
          return false
        end
        
        typesig { [] }
        define_method :owns_focus_shell do
          return Helper2.ok_to_use(self.attr_f_proposal_shell) && self.attr_f_proposal_shell.is_focus_control || Helper2.ok_to_use(self.attr_f_proposal_table) && self.attr_f_proposal_table.is_focus_control
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
      @f_modification_editing_support = Class.new(IEditingSupport.class == Class ? IEditingSupport : Object) do
        local_class_in CompletionProposalPopup2
        include_class_members CompletionProposalPopup2
        include IEditingSupport if IEditingSupport.class == Module
        
        typesig { [DocumentEvent, IRegion] }
        define_method :is_originator do |event, focus|
          if (!(self.attr_f_viewer).nil?)
            selection = self.attr_f_viewer.get_selected_range
            return selection.attr_x <= focus.get_offset + focus.get_length && selection.attr_x + selection.attr_y >= focus.get_offset
          end
          return false
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
      @f_content_assistant = content_assistant
      @f_viewer = viewer
      @f_additional_info_controller = info_controller
    end
    
    typesig { [::Java::Boolean] }
    # Computes and presents completion proposals. The flag indicates whether this call has
    # be made out of an auto activation context.
    # 
    # @param autoActivated <code>true</code> if auto activation context
    # @return an error message or <code>null</code> in case of no error
    def show_proposals(auto_activated)
      if ((@f_key_listener).nil?)
        @f_key_listener = Class.new(KeyListener.class == Class ? KeyListener : Object) do
          local_class_in CompletionProposalPopup2
          include_class_members CompletionProposalPopup2
          include KeyListener if KeyListener.class == Module
          
          typesig { [KeyEvent] }
          define_method :key_pressed do |e|
            if (!Helper2.ok_to_use(self.attr_f_proposal_shell))
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
          
          typesig { [KeyEvent] }
          define_method :key_released do |e|
            if (!Helper2.ok_to_use(self.attr_f_proposal_shell))
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
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self)
      end
      styled_text = @f_viewer.get_text_widget
      if (!(styled_text).nil? && !styled_text.is_disposed)
        styled_text.add_key_listener(@f_key_listener)
      end
      # BusyIndicator.showWhile(styledText.getDisplay(), new Runnable() {
      # public void run() {
      @f_invocation_offset = @f_viewer.get_selected_range.attr_x
      # lazily compute proposals
      # if (fComputedProposals == null)	fComputedProposals= computeProposals(fContentAssistant.getCompletionPosition());
      @f_computed_proposals = compute_proposals(@f_invocation_offset)
      count = ((@f_computed_proposals).nil? ? 0 : @f_computed_proposals.attr_length)
      if ((count).equal?(0))
        if (!auto_activated)
          styled_text.get_display.beep
        end
      else
        if ((count).equal?(1) && !auto_activated && @f_content_assistant.is_auto_inserting)
          insert_proposal(@f_computed_proposals[0], RJava.cast_to_char(0), 0, @f_invocation_offset)
        else
          if ((@f_line_delimiter).nil?)
            @f_line_delimiter = RJava.cast_to_string(styled_text.get_line_delimiter)
          end
          create_proposal_selector
          set_proposals(@f_computed_proposals)
          resize_proposal_selector(true)
          display_proposals
        end
      end
      # }
      # });
      return get_error_message
    end
    
    typesig { [::Java::Int] }
    # Returns the completion proposal available at the given offset of the
    # viewer's document. Delegates the work to the content assistant.
    # 
    # @param offset the offset
    # @return the completion proposals available at this offset
    def compute_proposals(offset)
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
      if (Helper2.ok_to_use(@f_proposal_shell))
        return
      end
      control = @f_viewer.get_text_widget
      @f_proposal_shell = Shell.new(control.get_shell, SWT::ON_TOP)
      # fProposalShell= new Shell(control.getShell(), SWT.ON_TOP | SWT.RESIZE );
      @f_proposal_table = Table.new(@f_proposal_shell, SWT::H_SCROLL | SWT::V_SCROLL)
      # fProposalTable= new Table(fProposalShell, SWT.H_SCROLL | SWT.V_SCROLL);
      @f_is_colored_labels_support_enabled = @f_content_assistant.is_colored_labels_support_enabled
      if (@f_is_colored_labels_support_enabled)
        TableOwnerDrawSupport.install(@f_proposal_table)
      end
      @f_proposal_table.set_location(0, 0)
      if (!(@f_additional_info_controller).nil?)
        @f_additional_info_controller.set_size_constraints(50, 10, true, false)
      end
      layout = GridLayout.new
      layout.attr_margin_width = 0
      layout.attr_margin_height = 0
      @f_proposal_shell.set_layout(layout)
      data = GridData.new(GridData::FILL_BOTH)
      @f_proposal_table.set_layout_data(data)
      @f_proposal_shell.pack
      # set location
      current_location = @f_proposal_shell.get_location
      new_location = get_location
      if ((new_location.attr_x < current_location.attr_x && (new_location.attr_y).equal?(current_location.attr_y)) || new_location.attr_y < current_location.attr_y)
        @f_proposal_shell.set_location(new_location)
      end
      if (!(@f_additional_info_controller).nil?)
        @f_proposal_shell.add_control_listener(Class.new(ControlListener.class == Class ? ControlListener : Object) do
          local_class_in CompletionProposalPopup2
          include_class_members CompletionProposalPopup2
          include ControlListener if ControlListener.class == Module
          
          typesig { [ControlEvent] }
          define_method :control_moved do |e|
          end
          
          typesig { [ControlEvent] }
          define_method :control_resized do |e|
            # resets the cached resize constraints
            self.attr_f_additional_info_controller.set_size_constraints(50, 10, true, false)
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      end
      @f_proposal_shell.set_background(control.get_display.get_system_color(SWT::COLOR_BLACK))
      c = control.get_display.get_system_color(SWT::COLOR_INFO_BACKGROUND)
      @f_proposal_table.set_background(c)
      c = control.get_display.get_system_color(SWT::COLOR_INFO_FOREGROUND)
      @f_proposal_table.set_foreground(c)
      @f_proposal_table.add_selection_listener(Class.new(SelectionListener.class == Class ? SelectionListener : Object) do
        local_class_in CompletionProposalPopup2
        include_class_members CompletionProposalPopup2
        include SelectionListener if SelectionListener.class == Module
        
        typesig { [SelectionEvent] }
        define_method :widget_selected do |e|
        end
        
        typesig { [SelectionEvent] }
        define_method :widget_default_selected do |e|
          select_proposal_with_mask(e.attr_state_mask)
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      @f_popup_closer.install(@f_content_assistant, @f_proposal_table)
      @f_proposal_shell.add_dispose_listener(Class.new(DisposeListener.class == Class ? DisposeListener : Object) do
        local_class_in CompletionProposalPopup2
        include_class_members CompletionProposalPopup2
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
      @f_content_assistant.add_to_layout(self, @f_proposal_shell, ContentAssistant2::LayoutManager::LAYOUT_PROPOSAL_SELECTOR, @f_content_assistant.get_selection_offset)
    end
    
    typesig { [] }
    # Returns the proposal selected in the proposal selector.
    # 
    # @return the selected proposal
    # @since 2.0
    def get_selected_proposal
      i = @f_proposal_table.get_selection_index
      if (i < 0 || i >= @f_filtered_proposals.attr_length)
        return nil
      end
      return @f_filtered_proposals[i]
    end
    
    typesig { [::Java::Int] }
    # Takes the selected proposal and applies it.
    # 
    # @param stateMask the state mask
    # @since 2.1
    def select_proposal_with_mask(state_mask)
      p = get_selected_proposal
      hide
      if (!(p).nil?)
        insert_proposal(p, RJava.cast_to_char(0), state_mask, @f_viewer.get_selected_range.attr_x)
      end
    end
    
    typesig { [ICompletionProposal, ::Java::Char, ::Java::Int, ::Java::Int] }
    # Applies the given proposal at the given offset. The given character is the
    # one that triggered the insertion of this proposal.
    # 
    # @param p the completion proposal
    # @param trigger the trigger character
    # @param stateMask the state mask of the keyboard event triggering the insertion
    # @param offset the offset
    # @since 2.1
    def insert_proposal(p, trigger, state_mask, offset)
      @f_inserting = true
      target = nil
      registry = nil
      begin
        document = @f_viewer.get_document
        if (@f_viewer.is_a?(ITextViewerExtension))
          extension = @f_viewer
          target = extension.get_rewrite_target
        end
        if (!(target).nil?)
          target.begin_compound_change
        end
        if (@f_viewer.is_a?(IEditingSupportRegistry))
          registry = @f_viewer
          registry.register(@f_modification_editing_support)
        end
        if (p.is_a?(ICompletionProposalExtension2))
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
          @f_viewer.set_selected_range(selection.attr_x, selection.attr_y)
          @f_viewer.reveal_range(selection.attr_x, selection.attr_y)
        end
        info = p.get_context_information
        if (!(info).nil?)
          position = 0
          if (p.is_a?(ICompletionProposalExtension))
            e = p
            position = e.get_context_information_position
          else
            if ((selection).nil?)
              selection = @f_viewer.get_selected_range
            end
            position = selection.attr_x + selection.attr_y
          end
          @f_content_assistant.show_context_information(info, position)
        end
        @f_content_assistant.fire_proposal_chosen(p)
      ensure
        if (!(target).nil?)
          target.end_compound_change
        end
        if (!(registry).nil?)
          registry.unregister(@f_modification_editing_support)
        end
        @f_inserting = false
      end
    end
    
    typesig { [] }
    # Returns whether this popup has the focus.
    # 
    # @return <code>true</code> if the popup has the focus
    def has_focus
      if (Helper2.ok_to_use(@f_proposal_shell))
        return (@f_proposal_shell.is_focus_control || @f_proposal_table.is_focus_control)
      end
      return false
    end
    
    typesig { [] }
    # Hides this popup.
    def hide
      unregister
      if (@f_viewer.is_a?(IEditingSupportRegistry))
        registry = @f_viewer
        registry.unregister(@f_focus_editing_support)
      end
      if (Helper2.ok_to_use(@f_proposal_shell))
        @f_content_assistant.remove_content_assist_listener(self, ContentAssistant2::PROPOSAL_SELECTOR)
        @f_popup_closer.uninstall
        # see bug 47511: setVisible may run the event loop on GTK
        # and trigger a rentrant call - have to make sure we don't
        # dispose another shell that was already brought up in a
        # reentrant call when calling setVisible()
        temp_shell = @f_proposal_shell
        @f_proposal_shell = nil
        temp_shell.set_visible(false)
        temp_shell.dispose
      end
    end
    
    typesig { [] }
    def unregister
      if (!(@f_document_listener).nil?)
        document = @f_viewer.get_document
        if (!(document).nil?)
          document.remove_document_listener(@f_document_listener)
        end
        @f_document_listener = nil
      end
      @f_document_events.clear
      styled_text = @f_viewer.get_text_widget
      if (!(@f_key_listener).nil? && !(styled_text).nil? && !styled_text.is_disposed)
        styled_text.remove_key_listener(@f_key_listener)
      end
      if (!(@f_last_proposal).nil?)
        if (@f_last_proposal.is_a?(ICompletionProposalExtension2))
          extension = @f_last_proposal
          extension.unselected(@f_viewer)
        end
        @f_last_proposal = nil
      end
      @f_filtered_proposals = nil
      @f_content_assistant.possible_completions_closed
    end
    
    typesig { [] }
    # Returns whether this popup is active. It is active if the propsal selector is visible.
    # 
    # @return <code>true</code> if this popup is active
    def is_active
      return !(@f_proposal_shell).nil? && !@f_proposal_shell.is_disposed
    end
    
    typesig { [Array.typed(ICompletionProposal)] }
    # Initializes the proposal selector with these given proposals.
    # 
    # @param proposals the proposals
    def set_proposals(proposals)
      if (Helper2.ok_to_use(@f_proposal_table))
        old_proposal = get_selected_proposal
        if (old_proposal.is_a?(ICompletionProposalExtension2))
          (old_proposal).unselected(@f_viewer)
        end
        @f_filtered_proposals = proposals
        selection_index = 0
        @f_proposal_table.set_redraw(false)
        begin
          @f_proposal_table.remove_all
          selection = @f_viewer.get_selected_range
          end_offset = 0
          end_offset = selection.attr_x + selection.attr_y
          document = @f_viewer.get_document
          validate = false
          if (!(selection.attr_y).equal?(0) && !(document).nil?)
            validate = true
          end
          item = nil
          p = nil
          i = 0
          while i < proposals.attr_length
            p = proposals[i]
            item = TableItem.new(@f_proposal_table, SWT::NULL)
            if (!(p.get_image).nil?)
              item.set_image(p.get_image)
            end
            display_string = nil
            style_ranges = nil
            if (@f_is_colored_labels_support_enabled && p.is_a?(ICompletionProposalExtension6))
              styled_string = (p).get_styled_display_string
              display_string = RJava.cast_to_string(styled_string.get_string)
              style_ranges = styled_string.get_style_ranges
            else
              display_string = RJava.cast_to_string(p.get_display_string)
            end
            item.set_text(display_string)
            if (@f_is_colored_labels_support_enabled)
              TableOwnerDrawSupport.store_style_ranges(item, 0, style_ranges)
            end
            item.set_data(p)
            if (validate && validate_proposal(document, p, end_offset, nil))
              selection_index = i
              validate = false
            end
            i += 1
          end
        ensure
          @f_proposal_table.set_redraw(true)
        end
        resize_proposal_selector(false)
        select_proposal(selection_index, false)
      end
    end
    
    typesig { [::Java::Boolean] }
    def resize_proposal_selector(adjust_width)
      width = adjust_width ? SWT::DEFAULT : (@f_proposal_table.get_layout_data).attr_width_hint
      size = @f_proposal_table.compute_size(width, SWT::DEFAULT, true)
      data = GridData.new(GridData::FILL_BOTH)
      data.attr_width_hint = adjust_width ? Math.min(size.attr_x, 300) : width
      data.attr_height_hint = Math.min(get_table_height_hint(@f_proposal_table, @f_proposal_table.get_item_count), get_table_height_hint(@f_proposal_table, 10))
      @f_proposal_table.set_layout_data(data)
      @f_proposal_shell.layout(true)
      @f_proposal_shell.pack
      if (adjust_width)
        @f_proposal_shell.set_location(get_location)
      end
    end
    
    typesig { [Table, ::Java::Int] }
    # Computes the table hight hint for <code>table</code>.
    # 
    # @param table the table to compute the height for
    # @param rows the number of rows to compute the height for
    # @return the height hint for <code>table</code>
    def get_table_height_hint(table, rows)
      if ((table.get_font == JFaceResources.get_default_font))
        table.set_font(JFaceResources.get_dialog_font)
      end
      result = table.get_item_height * rows
      if (table.get_lines_visible)
        result += table.get_grid_line_width * (rows - 1)
      end
      # TODO adjust to correct size. +4 works on windows, but not others
      # return result + 4;
      return result
    end
    
    typesig { [IDocument, ICompletionProposal, ::Java::Int, DocumentEvent] }
    def validate_proposal(document, p, offset, event)
      # detect selected
      if (p.is_a?(ICompletionProposalExtension2))
        e = p
        if (e.validate(document, offset, event))
          return true
        end
      else
        if (p.is_a?(ICompletionProposalExtension))
          e = p
          if (e.is_valid_for(document, offset))
            return true
          end
        end
      end
      return false
    end
    
    typesig { [] }
    # Returns the graphical location at which this popup should be made visible.
    # 
    # @return the location of this popup
    def get_location
      text = @f_viewer.get_text_widget
      selection = text.get_selection
      p = text.get_location_at_offset(selection.attr_x)
      p.attr_x -= @f_proposal_shell.get_border_width
      if (p.attr_x < 0)
        p.attr_x = 0
      end
      if (p.attr_y < 0)
        p.attr_y = 0
      end
      p = Point.new(p.attr_x, p.attr_y + text.get_line_height(selection.attr_x))
      p = text.to_display(p)
      return p
    end
    
    typesig { [] }
    # Displays this popup and install the additional info controller, so that additional info
    # is displayed when a proposal is selected and additional info is available.
    def display_proposals
      if (@f_content_assistant.add_content_assist_listener(self, ContentAssistant2::PROPOSAL_SELECTOR))
        if ((@f_document_listener).nil?)
          @f_document_listener = Class.new(IDocumentListener.class == Class ? IDocumentListener : Object) do
            local_class_in CompletionProposalPopup2
            include_class_members CompletionProposalPopup2
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
        end
        document = @f_viewer.get_document
        if (!(document).nil?)
          document.add_document_listener(@f_document_listener)
        end
        if (@f_viewer.is_a?(IEditingSupportRegistry))
          registry = @f_viewer
          registry.register(@f_focus_editing_support)
        end
        @f_proposal_shell.set_visible(true)
        # see bug 47511: setVisible may run the event loop on GTK
        # and trigger a rentrant call - have to check whether we are still
        # visible
        if (!Helper2.ok_to_use(@f_proposal_shell))
          return
        end
        if (!(@f_additional_info_controller).nil?)
          @f_additional_info_controller.install(@f_proposal_table)
          @f_additional_info_controller.handle_table_selection_changed
        end
      end
    end
    
    typesig { [VerifyEvent] }
    # @see IContentAssistListener#verifyKey(VerifyEvent)
    def verify_key(e)
      if (!Helper2.ok_to_use(@f_proposal_shell))
        return true
      end
      key = e.attr_character
      if ((key).equal?(0))
        new_selection = @f_proposal_table.get_selection_index
        visible_rows = (@f_proposal_table.get_size.attr_y / @f_proposal_table.get_item_height) - 1
        smart_toggle = false
        case (e.attr_key_code)
        when SWT::ARROW_LEFT, SWT::ARROW_RIGHT
          filter_proposals
          return true
        when SWT::ARROW_UP
          new_selection -= 1
          if (new_selection < 0)
            new_selection = @f_proposal_table.get_item_count - 1
          end
        when SWT::ARROW_DOWN
          new_selection += 1
          if (new_selection > @f_proposal_table.get_item_count - 1)
            new_selection = 0
          end
        when SWT::PAGE_DOWN
          new_selection += visible_rows
          if (new_selection >= @f_proposal_table.get_item_count)
            new_selection = @f_proposal_table.get_item_count - 1
          end
        when SWT::PAGE_UP
          new_selection -= visible_rows
          if (new_selection < 0)
            new_selection = 0
          end
        when SWT::HOME
          new_selection = 0
        when SWT::END_
          new_selection = @f_proposal_table.get_item_count - 1
        else
          if (!(e.attr_key_code).equal?(SWT::MOD1) && !(e.attr_key_code).equal?(SWT::MOD2) && !(e.attr_key_code).equal?(SWT::MOD3) && !(e.attr_key_code).equal?(SWT::MOD4))
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
      # in linked mode: hide popup
      # plus: don't invalidate the event in order to give LinkedUI a chance to handle it
      when 0x1b
        # Esc
        e.attr_doit = false
        hide
      when Character.new(?\n.ord), Character.new(?\r.ord)
        # Enter
        if (((e.attr_state_mask & SWT::CTRL)).equal?(0))
          e.attr_doit = false
          select_proposal_with_mask(e.attr_state_mask)
        end
      when Character.new(?\t.ord)
        # hide();
      else
        p = get_selected_proposal
        if (p.is_a?(ICompletionProposalExtension))
          t = p
          triggers = t.get_trigger_characters
          if (contains(triggers, key))
            hide
            if ((key).equal?(Character.new(?;.ord)))
              e.attr_doit = true
              insert_proposal(p, RJava.cast_to_char(0), e.attr_state_mask, @f_viewer.get_selected_range.attr_x)
            else
              e.attr_doit = false
              insert_proposal(p, key, e.attr_state_mask, @f_viewer.get_selected_range.attr_x)
            end
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
    # @param smartToggle <code>true</code> if the smart toogle key has been pressed
    # @since 2.1
    def select_proposal(index, smart_toggle)
      old_proposal = get_selected_proposal
      if (old_proposal.is_a?(ICompletionProposalExtension2))
        (old_proposal).unselected(@f_viewer)
      end
      proposal = @f_filtered_proposals[index]
      if (proposal.is_a?(ICompletionProposalExtension2))
        (proposal).selected(@f_viewer, smart_toggle)
      end
      @f_last_proposal = proposal
      @f_proposal_table.set_selection(index)
      @f_proposal_table.show_selection
      if (!(@f_additional_info_controller).nil?)
        @f_additional_info_controller.handle_table_selection_changed
      end
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
      (@f_invocation_counter += 1)
      control = @f_viewer.get_text_widget
      control.get_display.async_exec(Class.new(Runnable.class == Class ? Runnable : Object) do
        local_class_in CompletionProposalPopup2
        include_class_members CompletionProposalPopup2
        include Runnable if Runnable.class == Module
        
        attr_accessor :f_counter
        alias_method :attr_f_counter, :f_counter
        undef_method :f_counter
        alias_method :attr_f_counter=, :f_counter=
        undef_method :f_counter=
        
        typesig { [] }
        define_method :run do
          if (!(@f_counter).equal?(self.attr_f_invocation_counter))
            return
          end
          offset = self.attr_f_viewer.get_selected_range.attr_x
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
            set_proposals(proposals)
          else
            hide
          end
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          @f_counter = 0
          super(*args)
          @f_counter = self.attr_f_invocation_counter
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
    end
    
    typesig { [::Java::Int, DocumentEvent] }
    # Computes the subset of already computed propsals that are still valid for
    # the given offset.
    # 
    # @param offset the offset
    # @param event the merged document event
    # @return the set of filtered proposals
    # @since 2.0
    def compute_filtered_proposals(offset, event)
      if ((offset).equal?(@f_invocation_offset) && (event).nil?)
        return @f_computed_proposals
      end
      if (offset < @f_invocation_offset)
        return nil
      end
      proposals = @f_computed_proposals
      if (offset > @f_filter_offset)
        proposals = @f_filtered_proposals
      end
      if ((proposals).nil?)
        return nil
      end
      document = @f_viewer.get_document
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
            @f_invocation_offset = offset
            @f_computed_proposals = compute_proposals(@f_invocation_offset)
            return @f_computed_proposals
          end
        end
        i += 1
      end
      p = Array.typed(ICompletionProposal).new(filtered.size) { nil }
      filtered.to_array(p)
      return p
    end
    
    typesig { [] }
    # Requests the proposal shell to take focus.
    # 
    # @since 3.0
    def set_focus
      if (Helper2.ok_to_use(@f_proposal_shell))
        @f_proposal_shell.set_focus
      end
    end
    
    private
    alias_method :initialize__completion_proposal_popup2, :initialize
  end
  
end
