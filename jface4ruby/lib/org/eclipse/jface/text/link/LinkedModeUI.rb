require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Link
  module LinkedModeUIImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Link
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :Arrays
      include_const ::Java::Util, :HashSet
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :JavaSet
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Custom, :StyledText
      include_const ::Org::Eclipse::Swt::Custom, :VerifyKeyListener
      include_const ::Org::Eclipse::Swt::Events, :ShellEvent
      include_const ::Org::Eclipse::Swt::Events, :ShellListener
      include_const ::Org::Eclipse::Swt::Events, :VerifyEvent
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Widgets, :Display
      include_const ::Org::Eclipse::Swt::Widgets, :Shell
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Jface::Internal::Text::Link::Contentassist, :ContentAssistant2
      include_const ::Org::Eclipse::Jface::Internal::Text::Link::Contentassist, :IProposalListener
      include_const ::Org::Eclipse::Jface::Viewers, :IPostSelectionProvider
      include_const ::Org::Eclipse::Jface::Viewers, :ISelection
      include_const ::Org::Eclipse::Jface::Viewers, :ISelectionChangedListener
      include_const ::Org::Eclipse::Jface::Viewers, :SelectionChangedEvent
      include_const ::Org::Eclipse::Jface::Text, :BadLocationException
      include_const ::Org::Eclipse::Jface::Text, :BadPartitioningException
      include_const ::Org::Eclipse::Jface::Text, :BadPositionCategoryException
      include_const ::Org::Eclipse::Jface::Text, :DefaultPositionUpdater
      include_const ::Org::Eclipse::Jface::Text, :DocumentCommand
      include_const ::Org::Eclipse::Jface::Text, :DocumentEvent
      include_const ::Org::Eclipse::Jface::Text, :IAutoEditStrategy
      include_const ::Org::Eclipse::Jface::Text, :IDocument
      include_const ::Org::Eclipse::Jface::Text, :IDocumentExtension3
      include_const ::Org::Eclipse::Jface::Text, :IDocumentListener
      include_const ::Org::Eclipse::Jface::Text, :IEditingSupport
      include_const ::Org::Eclipse::Jface::Text, :IEditingSupportRegistry
      include_const ::Org::Eclipse::Jface::Text, :IPositionUpdater
      include_const ::Org::Eclipse::Jface::Text, :IRegion
      include_const ::Org::Eclipse::Jface::Text, :IRewriteTarget
      include_const ::Org::Eclipse::Jface::Text, :ITextInputListener
      include_const ::Org::Eclipse::Jface::Text, :ITextOperationTarget
      include_const ::Org::Eclipse::Jface::Text, :ITextSelection
      include_const ::Org::Eclipse::Jface::Text, :ITextViewer
      include_const ::Org::Eclipse::Jface::Text, :ITextViewerExtension
      include_const ::Org::Eclipse::Jface::Text, :ITextViewerExtension2
      include_const ::Org::Eclipse::Jface::Text, :ITextViewerExtension5
      include_const ::Org::Eclipse::Jface::Text, :Position
      include_const ::Org::Eclipse::Jface::Text, :Region
      include_const ::Org::Eclipse::Jface::Text::Contentassist, :ICompletionProposal
      include_const ::Org::Eclipse::Jface::Text::Contentassist, :ICompletionProposalExtension6
      include_const ::Org::Eclipse::Jface::Text::Source, :IAnnotationModel
      include_const ::Org::Eclipse::Jface::Text::Source, :IAnnotationModelExtension
      include_const ::Org::Eclipse::Jface::Text::Source, :ISourceViewer
    }
  end
  
  # The UI for linked mode. Detects events that influence behavior of the linked mode
  # UI and acts upon them.
  # <p>
  # <code>LinkedModeUI</code> relies on all added
  # <code>LinkedModeUITarget</code>s to provide implementations of
  # <code>ITextViewer</code> that implement <code>ITextViewerExtension</code>,
  # and the documents being edited to implement <code>IDocumentExtension3</code>.
  # </p>
  # <p>
  # Clients may instantiate and extend this class.
  # </p>
  # 
  # @since 3.0
  class LinkedModeUI 
    include_class_members LinkedModeUIImports
    
    class_module.module_eval {
      # cycle constants
      # 
      # Constant indicating that this UI should never cycle from the last
      # position to the first and vice versa.
      const_set_lazy(:CYCLE_NEVER) { Object.new }
      const_attr_reader  :CYCLE_NEVER
      
      # Constant indicating that this UI should always cycle from the last
      # position to the first and vice versa.
      const_set_lazy(:CYCLE_ALWAYS) { Object.new }
      const_attr_reader  :CYCLE_ALWAYS
      
      # Constant indicating that this UI should cycle from the last position to
      # the first and vice versa if its model is not nested.
      const_set_lazy(:CYCLE_WHEN_NO_PARENT) { Object.new }
      const_attr_reader  :CYCLE_WHEN_NO_PARENT
      
      # Listener that gets notified when the linked mode UI switches its focus position.
      # <p>
      # Clients may implement this interface.
      # </p>
      const_set_lazy(:ILinkedModeUIFocusListener) { Module.new do
        include_class_members LinkedModeUI
        
        typesig { [LinkedPosition, LinkedModeUITarget] }
        # Called when the UI for the linked mode leaves a linked position.
        # 
        # @param position the position being left
        # @param target the target where <code>position</code> resides in
        def linking_focus_lost(position, target)
          raise NotImplementedError
        end
        
        typesig { [LinkedPosition, LinkedModeUITarget] }
        # Called when the UI for the linked mode gives focus to a linked position.
        # 
        # @param position the position being entered
        # @param target the target where <code>position</code> resides in
        def linking_focus_gained(position, target)
          raise NotImplementedError
        end
      end }
      
      # Null object implementation of focus listener.
      const_set_lazy(:EmtpyFocusListener) { Class.new do
        include_class_members LinkedModeUI
        include ILinkedModeUIFocusListener
        
        typesig { [class_self::LinkedPosition, class_self::LinkedModeUITarget] }
        def linking_focus_gained(position, target)
          # ignore
        end
        
        typesig { [class_self::LinkedPosition, class_self::LinkedModeUITarget] }
        def linking_focus_lost(position, target)
          # ignore
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__emtpy_focus_listener, :initialize
      end }
      
      # A link target consists of a viewer and gets notified if the linked mode UI on
      # it is being shown.
      # <p>
      # Clients may extend this class.
      # </p>
      # @since 3.0
      const_set_lazy(:LinkedModeUITarget) { Class.new do
        include_class_members LinkedModeUI
        include ILinkedModeUIFocusListener
        
        typesig { [] }
        # Returns the viewer represented by this target, never <code>null</code>.
        # 
        # @return the viewer associated with this target.
        def get_viewer
          raise NotImplementedError
        end
        
        # The viewer's text widget is initialized when the UI first connects
        # to the viewer and never changed thereafter. This is to keep the
        # reference of the widget that we have registered our listeners with,
        # as the viewer, when it gets disposed, does not remember it, resulting
        # in a situation where we cannot uninstall the listeners and a memory leak.
        attr_accessor :f_widget
        alias_method :attr_f_widget, :f_widget
        undef_method :f_widget
        alias_method :attr_f_widget=, :f_widget=
        undef_method :f_widget=
        
        # The cached shell - same reason as fWidget.
        attr_accessor :f_shell
        alias_method :attr_f_shell, :f_shell
        undef_method :f_shell
        alias_method :attr_f_shell=, :f_shell=
        undef_method :f_shell=
        
        # The registered listener, or <code>null</code>.
        attr_accessor :f_key_listener
        alias_method :attr_f_key_listener, :f_key_listener
        undef_method :f_key_listener
        alias_method :attr_f_key_listener=, :f_key_listener=
        undef_method :f_key_listener=
        
        # The cached custom annotation model.
        attr_accessor :f_annotation_model
        alias_method :attr_f_annotation_model, :f_annotation_model
        undef_method :f_annotation_model
        alias_method :attr_f_annotation_model=, :f_annotation_model=
        undef_method :f_annotation_model=
        
        typesig { [] }
        def initialize
          @f_widget = nil
          @f_shell = nil
          @f_key_listener = nil
          @f_annotation_model = nil
        end
        
        private
        alias_method :initialize__linked_mode_uitarget, :initialize
      end }
      
      const_set_lazy(:EmptyTarget) { Class.new(LinkedModeUITarget) do
        include_class_members LinkedModeUI
        
        attr_accessor :f_text_viewer
        alias_method :attr_f_text_viewer, :f_text_viewer
        undef_method :f_text_viewer
        alias_method :attr_f_text_viewer=, :f_text_viewer=
        undef_method :f_text_viewer=
        
        typesig { [class_self::ITextViewer] }
        # @param viewer the viewer
        def initialize(viewer)
          @f_text_viewer = nil
          super()
          Assert.is_not_null(viewer)
          @f_text_viewer = viewer
        end
        
        typesig { [] }
        # @see org.eclipse.jdt.internal.ui.text.link2.LinkedModeUI.ILinkedUITarget#getViewer()
        def get_viewer
          return @f_text_viewer
        end
        
        typesig { [class_self::LinkedPosition, class_self::LinkedModeUITarget] }
        # {@inheritDoc}
        def linking_focus_lost(position, target)
        end
        
        typesig { [class_self::LinkedPosition, class_self::LinkedModeUITarget] }
        # {@inheritDoc}
        def linking_focus_gained(position, target)
        end
        
        private
        alias_method :initialize__empty_target, :initialize
      end }
      
      # Listens for state changes in the model.
      const_set_lazy(:ExitListener) { Class.new do
        local_class_in LinkedModeUI
        include_class_members LinkedModeUI
        include ILinkedModeListener
        
        typesig { [class_self::LinkedModeModel, ::Java::Int] }
        def left(model, flags)
          leave(ILinkedModeListener::EXIT_ALL | flags)
        end
        
        typesig { [class_self::LinkedModeModel] }
        def suspend(model)
          disconnect
          redraw
        end
        
        typesig { [class_self::LinkedModeModel, ::Java::Int] }
        def resume(model, flags)
          if (!((flags & ILinkedModeListener::EXIT_ALL)).equal?(0))
            leave(flags)
          else
            connect
            if (!((flags & ILinkedModeListener::SELECT)).equal?(0))
              select
            end
            ensure_annotation_model_installed
            redraw
          end
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__exit_listener, :initialize
      end }
      
      # Exit flags returned if a custom exit policy wants to exit linked mode.
      # <p>
      # Clients may instantiate this class.
      # </p>
      const_set_lazy(:ExitFlags) { Class.new do
        include_class_members LinkedModeUI
        
        # The flags to return in the <code>leave</code> method.
        attr_accessor :flags
        alias_method :attr_flags, :flags
        undef_method :flags
        alias_method :attr_flags=, :flags=
        undef_method :flags=
        
        # The doit flag of the checked <code>VerifyKeyEvent</code>.
        attr_accessor :doit
        alias_method :attr_doit, :doit
        undef_method :doit
        alias_method :attr_doit=, :doit=
        undef_method :doit=
        
        typesig { [::Java::Int, ::Java::Boolean] }
        # Creates a new instance.
        # 
        # @param flags the exit flags
        # @param doit the doit flag for the verify event
        def initialize(flags, doit)
          @flags = 0
          @doit = false
          @flags = flags
          @doit = doit
        end
        
        private
        alias_method :initialize__exit_flags, :initialize
      end }
      
      # An exit policy can be registered by a caller to get custom exit
      # behavior.
      # <p>
      # Clients may implement this interface.
      # </p>
      const_set_lazy(:IExitPolicy) { Module.new do
        include_class_members LinkedModeUI
        
        typesig { [LinkedModeModel, VerifyEvent, ::Java::Int, ::Java::Int] }
        # Checks whether the linked mode should be left after receiving the
        # given <code>VerifyEvent</code> and selection. Note that the event
        # carries widget coordinates as opposed to <code>offset</code> and
        # <code>length</code> which are document coordinates.
        # 
        # @param model the linked mode model
        # @param event the verify event
        # @param offset the offset of the current selection
        # @param length the length of the current selection
        # @return valid exit flags or <code>null</code> if no special action
        # should be taken
        def do_exit(model, event, offset, length)
          raise NotImplementedError
        end
      end }
      
      # A NullObject implementation of <code>IExitPolicy</code>.
      const_set_lazy(:NullExitPolicy) { Class.new do
        include_class_members LinkedModeUI
        include IExitPolicy
        
        typesig { [class_self::LinkedModeModel, class_self::VerifyEvent, ::Java::Int, ::Java::Int] }
        # @see org.eclipse.jdt.internal.ui.text.link2.LinkedModeUI.IExitPolicy#doExit(org.eclipse.swt.events.VerifyEvent, int, int)
        def do_exit(model, event, offset, length)
          return nil
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__null_exit_policy, :initialize
      end }
      
      # Listens for shell events and acts upon them.
      const_set_lazy(:Closer) { Class.new do
        local_class_in LinkedModeUI
        include_class_members LinkedModeUI
        include ShellListener
        include ITextInputListener
        
        typesig { [class_self::ShellEvent] }
        def shell_activated(e)
        end
        
        typesig { [class_self::ShellEvent] }
        def shell_closed(e)
          leave(ILinkedModeListener::EXIT_ALL)
        end
        
        typesig { [class_self::ShellEvent] }
        def shell_deactivated(e)
          # TODO re-enable after debugging
          # if (true) return;
          # from LinkedPositionUI:
          # don't deactivate on focus lost, since the proposal popups may take focus
          # plus: it doesn't hurt if you can check with another window without losing linked mode
          # since there is no intrusive popup sticking out.
          # need to check first what happens on reentering based on an open action
          # Seems to be no problem
          # Better:
          # Check with content assistant and only leave if its not the proposal shell that took the
          # focus away.
          text = nil
          viewer = nil
          display = nil
          if ((self.attr_f_current_target).nil? || ((text = self.attr_f_current_target.attr_f_widget)).nil? || text.is_disposed || ((display = text.get_display)).nil? || display.is_disposed || ((viewer = self.attr_f_current_target.get_viewer)).nil?)
            leave(ILinkedModeListener::EXIT_ALL)
          else
            display.async_exec(# Post in UI thread since the assistant popup will only get the focus after we lose it.
            Class.new(self.class::Runnable.class == Class ? self.class::Runnable : Object) do
              local_class_in Closer
              include_class_members Closer
              include class_self::Runnable if class_self::Runnable.class == Module
              
              typesig { [] }
              define_method :run do
                if (self.attr_f_is_active && viewer.is_a?(self.class::IEditingSupportRegistry))
                  helpers = (viewer).get_registered_supports
                  i = 0
                  while i < helpers.attr_length
                    if (helpers[i].owns_focus_shell)
                      return
                    end
                    i += 1
                  end
                end
                # else
                leave(ILinkedModeListener::EXIT_ALL)
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
        
        typesig { [class_self::ShellEvent] }
        def shell_deiconified(e)
        end
        
        typesig { [class_self::ShellEvent] }
        def shell_iconified(e)
          leave(ILinkedModeListener::EXIT_ALL)
        end
        
        typesig { [class_self::IDocument, class_self::IDocument] }
        # @see org.eclipse.jface.text.ITextInputListener#inputDocumentAboutToBeChanged(org.eclipse.jface.text.IDocument, org.eclipse.jface.text.IDocument)
        def input_document_about_to_be_changed(old_input, new_input)
          leave(ILinkedModeListener::EXIT_ALL)
        end
        
        typesig { [class_self::IDocument, class_self::IDocument] }
        # @see org.eclipse.jface.text.ITextInputListener#inputDocumentChanged(org.eclipse.jface.text.IDocument, org.eclipse.jface.text.IDocument)
        def input_document_changed(old_input, new_input)
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__closer, :initialize
      end }
      
      # @since 3.1
      const_set_lazy(:DocumentListener) { Class.new do
        local_class_in LinkedModeUI
        include_class_members LinkedModeUI
        include IDocumentListener
        
        typesig { [class_self::DocumentEvent] }
        # @see org.eclipse.jface.text.IDocumentListener#documentAboutToBeChanged(org.eclipse.jface.text.DocumentEvent)
        def document_about_to_be_changed(event)
          # default behavior: any document change outside a linked position
          # causes us to exit
          end_ = event.get_offset + event.get_length
          offset = event.get_offset
          while offset <= end_
            if (!self.attr_f_model.any_position_contains(offset))
              viewer = self.attr_f_current_target.get_viewer
              if (!(self.attr_f_frame_position).nil? && viewer.is_a?(self.class::IEditingSupportRegistry))
                helpers = (viewer).get_registered_supports
                i = 0
                while i < helpers.attr_length
                  if (helpers[i].is_originator(nil, self.class::Region.new(self.attr_f_frame_position.get_offset, self.attr_f_frame_position.get_length)))
                    return
                  end
                  i += 1
                end
              end
              leave(ILinkedModeListener::EXTERNAL_MODIFICATION)
              return
            end
            offset += 1
          end
        end
        
        typesig { [class_self::DocumentEvent] }
        # @see org.eclipse.jface.text.IDocumentListener#documentChanged(org.eclipse.jface.text.DocumentEvent)
        def document_changed(event)
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__document_listener, :initialize
      end }
      
      # Listens for key events, checks the exit policy for custom exit
      # strategies but defaults to handling Tab, Enter, and Escape.
      const_set_lazy(:KeyListener) { Class.new do
        local_class_in LinkedModeUI
        include_class_members LinkedModeUI
        include VerifyKeyListener
        
        attr_accessor :f_is_enabled
        alias_method :attr_f_is_enabled, :f_is_enabled
        undef_method :f_is_enabled
        alias_method :attr_f_is_enabled=, :f_is_enabled=
        undef_method :f_is_enabled=
        
        typesig { [class_self::VerifyEvent] }
        def verify_key(event)
          if (!event.attr_doit || !@f_is_enabled)
            return
          end
          selection = self.attr_f_current_target.get_viewer.get_selected_range
          offset = selection.attr_x
          length = selection.attr_y
          # if the custom exit policy returns anything, use that
          exit_flags = self.attr_f_exit_policy.do_exit(self.attr_f_model, event, offset, length)
          if (!(exit_flags).nil?)
            leave(exit_flags.attr_flags)
            event.attr_doit = exit_flags.attr_doit
            return
          end
          catch(:break_case) do
            # standard behavior:
            # (Shift+)Tab:	jumps from position to position, depending on cycle mode
            # Enter:		accepts all entries and leaves all (possibly stacked) environments, the last sets the caret
            # Esc:			accepts all entries and leaves all (possibly stacked) environments, the caret stays
            # ? what do we do to leave one level of a cycling model that is stacked?
            # -> This is only the case if the level was set up with forced cycling (CYCLE_ALWAYS), in which case
            # the caller is sure that one does not need by-level exiting.
            case (event.attr_character)
            # [SHIFT-]TAB = hop between edit boxes
            # ENTER
            # Ctrl+Enter on WinXP
            # ESC
            when 0x9
              if (!(!(self.attr_f_exit_position).nil? && self.attr_f_exit_position.includes(offset)) && !self.attr_f_model.any_position_contains(offset))
                # outside any edit box -> leave (all? TODO should only leave the affected, level and forward to the next upper)
                leave(ILinkedModeListener::EXIT_ALL)
                throw :break_case, :thrown
              end
              if ((event.attr_state_mask).equal?(SWT::SHIFT))
                previous
              else
                next_
              end
              event.attr_doit = false
            when 0xa, 0xd
              # if ((fExitPosition != null && fExitPosition.includes(offset)) || !fModel.anyPositionContains(offset)) {
              if (!self.attr_f_model.any_position_contains(offset))
                # if ((fExitPosition == null || !fExitPosition.includes(offset)) && !fModel.anyPositionContains(offset)) {
                # outside any edit box or on exit position -> leave (all? TODO should only leave the affected, level and forward to the next upper)
                leave(ILinkedModeListener::EXIT_ALL)
                throw :break_case, :thrown
              end
              # normal case: exit entire stack and put caret to final position
              leave(ILinkedModeListener::EXIT_ALL | ILinkedModeListener::UPDATE_CARET)
              event.attr_doit = false
            when 0x1b
              # exit entire stack and leave caret
              leave(ILinkedModeListener::EXIT_ALL)
              event.attr_doit = false
            else
              if (!(event.attr_character).equal?(0))
                if (!control_undo_behavior(offset, length))
                  leave(ILinkedModeListener::EXIT_ALL)
                end
              end
            end
          end
        end
        
        typesig { [::Java::Int, ::Java::Int] }
        def control_undo_behavior(offset, length)
          position = self.attr_f_model.find_position(self.class::LinkedPosition.new(self.attr_f_current_target.get_viewer.get_document, offset, length, LinkedPositionGroup::NO_STOP))
          if (!(position).nil?)
            # if the last position is not the same and there is an open change: close it.
            if (!(position == self.attr_f_previous_position))
              end_compound_change
            end
            begin_compound_change
          end
          self.attr_f_previous_position = position
          return !(self.attr_f_previous_position).nil?
        end
        
        typesig { [::Java::Boolean] }
        # @param enabled the new enabled state
        def set_enabled(enabled)
          @f_is_enabled = enabled
        end
        
        typesig { [] }
        def initialize
          @f_is_enabled = true
        end
        
        private
        alias_method :initialize__key_listener, :initialize
      end }
      
      # Installed as post selection listener on the watched viewer. Updates the
      # linked position after cursor movement, even to positions not in the
      # iteration list.
      const_set_lazy(:MySelectionListener) { Class.new do
        local_class_in LinkedModeUI
        include_class_members LinkedModeUI
        include ISelectionChangedListener
        
        typesig { [class_self::SelectionChangedEvent] }
        # @see org.eclipse.jface.viewers.ISelectionChangedListener#selectionChanged(org.eclipse.jface.viewers.SelectionChangedEvent)
        def selection_changed(event)
          selection = event.get_selection
          if (selection.is_a?(self.class::ITextSelection))
            textsel = selection
            if (event.get_selection_provider.is_a?(self.class::ITextViewer))
              doc = (event.get_selection_provider).get_document
              if (!(doc).nil?)
                offset = textsel.get_offset
                length = textsel.get_length
                if (offset >= 0 && length >= 0)
                  find = self.class::LinkedPosition.new(doc, offset, length, LinkedPositionGroup::NO_STOP)
                  pos = self.attr_f_model.find_position(find)
                  if ((pos).nil? && !(self.attr_f_exit_position).nil? && self.attr_f_exit_position.includes(find))
                    pos = self.attr_f_exit_position
                  end
                  if (!(pos).nil?)
                    switch_position(pos, false, false)
                  end
                end
              end
            end
          end
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__my_selection_listener, :initialize
      end }
      
      const_set_lazy(:ProposalListener) { Class.new do
        local_class_in LinkedModeUI
        include_class_members LinkedModeUI
        include IProposalListener
        
        typesig { [class_self::ICompletionProposal] }
        # @see org.eclipse.jface.internal.text.link.contentassist.IProposalListener#proposalChosen(org.eclipse.jface.text.contentassist.ICompletionProposal)
        def proposal_chosen(proposal)
          next_
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__proposal_listener, :initialize
      end }
    }
    
    # The current viewer.
    attr_accessor :f_current_target
    alias_method :attr_f_current_target, :f_current_target
    undef_method :f_current_target
    alias_method :attr_f_current_target=, :f_current_target=
    undef_method :f_current_target=
    
    # The manager of the linked positions we provide a UI for.
    # @since 3.1
    attr_accessor :f_model
    alias_method :attr_f_model, :f_model
    undef_method :f_model
    alias_method :attr_f_model=, :f_model=
    undef_method :f_model=
    
    # The set of viewers we manage.
    attr_accessor :f_targets
    alias_method :attr_f_targets, :f_targets
    undef_method :f_targets
    alias_method :attr_f_targets=, :f_targets=
    undef_method :f_targets=
    
    # The iterator over the tab stop positions.
    attr_accessor :f_iterator
    alias_method :attr_f_iterator, :f_iterator
    undef_method :f_iterator
    alias_method :attr_f_iterator=, :f_iterator=
    undef_method :f_iterator=
    
    # Our team of event listeners
    # The shell listener.
    attr_accessor :f_closer
    alias_method :attr_f_closer, :f_closer
    undef_method :f_closer
    alias_method :attr_f_closer=, :f_closer=
    undef_method :f_closer=
    
    # The linked mode listener.
    attr_accessor :f_linked_listener
    alias_method :attr_f_linked_listener, :f_linked_listener
    undef_method :f_linked_listener
    alias_method :attr_f_linked_listener=, :f_linked_listener=
    undef_method :f_linked_listener=
    
    # The selection listener.
    attr_accessor :f_selection_listener
    alias_method :attr_f_selection_listener, :f_selection_listener
    undef_method :f_selection_listener
    alias_method :attr_f_selection_listener=, :f_selection_listener=
    undef_method :f_selection_listener=
    
    # The content assist listener.
    attr_accessor :f_proposal_listener
    alias_method :attr_f_proposal_listener, :f_proposal_listener
    undef_method :f_proposal_listener
    alias_method :attr_f_proposal_listener=, :f_proposal_listener=
    undef_method :f_proposal_listener=
    
    # The document listener.
    # @since 3.1
    attr_accessor :f_document_listener
    alias_method :attr_f_document_listener, :f_document_listener
    undef_method :f_document_listener
    alias_method :attr_f_document_listener=, :f_document_listener=
    undef_method :f_document_listener=
    
    # The last caret position, used by fCaretListener.
    attr_accessor :f_caret_position
    alias_method :attr_f_caret_position, :f_caret_position
    undef_method :f_caret_position
    alias_method :attr_f_caret_position=, :f_caret_position=
    undef_method :f_caret_position=
    
    # The exit policy to control custom exit behavior
    attr_accessor :f_exit_policy
    alias_method :attr_f_exit_policy, :f_exit_policy
    undef_method :f_exit_policy
    alias_method :attr_f_exit_policy=, :f_exit_policy=
    undef_method :f_exit_policy=
    
    # The current frame position shown in the UI, or <code>null</code>.
    attr_accessor :f_frame_position
    alias_method :attr_f_frame_position, :f_frame_position
    undef_method :f_frame_position
    alias_method :attr_f_frame_position=, :f_frame_position=
    undef_method :f_frame_position=
    
    # The last visited position, used for undo / redo.
    attr_accessor :f_previous_position
    alias_method :attr_f_previous_position, :f_previous_position
    undef_method :f_previous_position
    alias_method :attr_f_previous_position=, :f_previous_position=
    undef_method :f_previous_position=
    
    # The content assistant used to show proposals.
    attr_accessor :f_assistant
    alias_method :attr_f_assistant, :f_assistant
    undef_method :f_assistant
    alias_method :attr_f_assistant=, :f_assistant=
    undef_method :f_assistant=
    
    # The exit position.
    attr_accessor :f_exit_position
    alias_method :attr_f_exit_position, :f_exit_position
    undef_method :f_exit_position
    alias_method :attr_f_exit_position=, :f_exit_position=
    undef_method :f_exit_position=
    
    # State indicator to prevent multiple invocation of leave.
    attr_accessor :f_is_active
    alias_method :attr_f_is_active, :f_is_active
    undef_method :f_is_active
    alias_method :attr_f_is_active=, :f_is_active=
    undef_method :f_is_active=
    
    # The position updater for the exit position.
    attr_accessor :f_position_updater
    alias_method :attr_f_position_updater, :f_position_updater
    undef_method :f_position_updater
    alias_method :attr_f_position_updater=, :f_position_updater=
    undef_method :f_position_updater=
    
    # Whether to show context info.
    attr_accessor :f_do_context_info
    alias_method :attr_f_do_context_info, :f_do_context_info
    undef_method :f_do_context_info
    alias_method :attr_f_do_context_info=, :f_do_context_info=
    undef_method :f_do_context_info=
    
    # Whether we have begun a compound change, but not yet closed.
    attr_accessor :f_has_open_compound_change
    alias_method :attr_f_has_open_compound_change, :f_has_open_compound_change
    undef_method :f_has_open_compound_change
    alias_method :attr_f_has_open_compound_change=, :f_has_open_compound_change=
    undef_method :f_has_open_compound_change=
    
    # The position listener.
    attr_accessor :f_position_listener
    alias_method :attr_f_position_listener, :f_position_listener
    undef_method :f_position_listener
    alias_method :attr_f_position_listener=, :f_position_listener=
    undef_method :f_position_listener=
    
    attr_accessor :f_auto_edit_vetoer
    alias_method :attr_f_auto_edit_vetoer, :f_auto_edit_vetoer
    undef_method :f_auto_edit_vetoer
    alias_method :attr_f_auto_edit_vetoer=, :f_auto_edit_vetoer=
    undef_method :f_auto_edit_vetoer=
    
    # Whether this UI is in simple highlighting mode or not.
    attr_accessor :f_simple
    alias_method :attr_f_simple, :f_simple
    undef_method :f_simple
    alias_method :attr_f_simple=, :f_simple=
    undef_method :f_simple=
    
    # Tells whether colored labels support is enabled.
    # @since 3.4
    attr_accessor :f_is_colored_labels_support_enabled
    alias_method :attr_f_is_colored_labels_support_enabled, :f_is_colored_labels_support_enabled
    undef_method :f_is_colored_labels_support_enabled
    alias_method :attr_f_is_colored_labels_support_enabled=, :f_is_colored_labels_support_enabled=
    undef_method :f_is_colored_labels_support_enabled=
    
    typesig { [LinkedModeModel, Array.typed(LinkedModeUITarget)] }
    # Creates a new UI on the given model and the set of viewers. The model
    # must provide a tab stop sequence with a non-empty list of tab stops.
    # 
    # @param model the linked mode model
    # @param targets the non-empty list of targets upon which the linked mode
    # UI should act
    def initialize(model, targets)
      @f_current_target = nil
      @f_model = nil
      @f_targets = nil
      @f_iterator = nil
      @f_closer = Closer.new_local(self)
      @f_linked_listener = ExitListener.new_local(self)
      @f_selection_listener = MySelectionListener.new_local(self)
      @f_proposal_listener = ProposalListener.new_local(self)
      @f_document_listener = DocumentListener.new_local(self)
      @f_caret_position = Position.new(0, 0)
      @f_exit_policy = NullExitPolicy.new
      @f_frame_position = nil
      @f_previous_position = nil
      @f_assistant = nil
      @f_exit_position = nil
      @f_is_active = false
      @f_position_updater = DefaultPositionUpdater.new(get_category)
      @f_do_context_info = false
      @f_has_open_compound_change = false
      @f_position_listener = EmtpyFocusListener.new
      @f_auto_edit_vetoer = Class.new(IAutoEditStrategy.class == Class ? IAutoEditStrategy : Object) do
        local_class_in LinkedModeUI
        include_class_members LinkedModeUI
        include IAutoEditStrategy if IAutoEditStrategy.class == Module
        
        typesig { [IDocument, DocumentCommand] }
        # @see org.eclipse.jface.text.IAutoEditStrategy#customizeDocumentCommand(org.eclipse.jface.text.IDocument, org.eclipse.jface.text.DocumentCommand)
        define_method :customize_document_command do |document, command|
          # invalidate the change to ensure that the change is performed on the document only.
          if (self.attr_f_model.any_position_contains(command.attr_offset))
            command.attr_doit = false
            command.attr_caret_offset = command.attr_offset + command.attr_length
          end
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
      @f_simple = false
      @f_is_colored_labels_support_enabled = false
      constructor(model, targets)
    end
    
    typesig { [LinkedModeModel, ITextViewer] }
    # Convenience constructor for just one viewer.
    # 
    # @param model the linked mode model
    # @param viewer the viewer upon which the linked mode UI should act
    def initialize(model, viewer)
      @f_current_target = nil
      @f_model = nil
      @f_targets = nil
      @f_iterator = nil
      @f_closer = Closer.new_local(self)
      @f_linked_listener = ExitListener.new_local(self)
      @f_selection_listener = MySelectionListener.new_local(self)
      @f_proposal_listener = ProposalListener.new_local(self)
      @f_document_listener = DocumentListener.new_local(self)
      @f_caret_position = Position.new(0, 0)
      @f_exit_policy = NullExitPolicy.new
      @f_frame_position = nil
      @f_previous_position = nil
      @f_assistant = nil
      @f_exit_position = nil
      @f_is_active = false
      @f_position_updater = DefaultPositionUpdater.new(get_category)
      @f_do_context_info = false
      @f_has_open_compound_change = false
      @f_position_listener = EmtpyFocusListener.new
      @f_auto_edit_vetoer = Class.new(IAutoEditStrategy.class == Class ? IAutoEditStrategy : Object) do
        local_class_in LinkedModeUI
        include_class_members LinkedModeUI
        include IAutoEditStrategy if IAutoEditStrategy.class == Module
        
        typesig { [IDocument, DocumentCommand] }
        # @see org.eclipse.jface.text.IAutoEditStrategy#customizeDocumentCommand(org.eclipse.jface.text.IDocument, org.eclipse.jface.text.DocumentCommand)
        define_method :customize_document_command do |document, command|
          # invalidate the change to ensure that the change is performed on the document only.
          if (self.attr_f_model.any_position_contains(command.attr_offset))
            command.attr_doit = false
            command.attr_caret_offset = command.attr_offset + command.attr_length
          end
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
      @f_simple = false
      @f_is_colored_labels_support_enabled = false
      constructor(model, Array.typed(LinkedModeUITarget).new([EmptyTarget.new(viewer)]))
    end
    
    typesig { [LinkedModeModel, Array.typed(ITextViewer)] }
    # Convenience constructor for multiple viewers.
    # 
    # @param model the linked mode model
    # @param viewers the non-empty list of viewers upon which the linked mode
    # UI should act
    def initialize(model, viewers)
      @f_current_target = nil
      @f_model = nil
      @f_targets = nil
      @f_iterator = nil
      @f_closer = Closer.new_local(self)
      @f_linked_listener = ExitListener.new_local(self)
      @f_selection_listener = MySelectionListener.new_local(self)
      @f_proposal_listener = ProposalListener.new_local(self)
      @f_document_listener = DocumentListener.new_local(self)
      @f_caret_position = Position.new(0, 0)
      @f_exit_policy = NullExitPolicy.new
      @f_frame_position = nil
      @f_previous_position = nil
      @f_assistant = nil
      @f_exit_position = nil
      @f_is_active = false
      @f_position_updater = DefaultPositionUpdater.new(get_category)
      @f_do_context_info = false
      @f_has_open_compound_change = false
      @f_position_listener = EmtpyFocusListener.new
      @f_auto_edit_vetoer = Class.new(IAutoEditStrategy.class == Class ? IAutoEditStrategy : Object) do
        local_class_in LinkedModeUI
        include_class_members LinkedModeUI
        include IAutoEditStrategy if IAutoEditStrategy.class == Module
        
        typesig { [IDocument, DocumentCommand] }
        # @see org.eclipse.jface.text.IAutoEditStrategy#customizeDocumentCommand(org.eclipse.jface.text.IDocument, org.eclipse.jface.text.DocumentCommand)
        define_method :customize_document_command do |document, command|
          # invalidate the change to ensure that the change is performed on the document only.
          if (self.attr_f_model.any_position_contains(command.attr_offset))
            command.attr_doit = false
            command.attr_caret_offset = command.attr_offset + command.attr_length
          end
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
      @f_simple = false
      @f_is_colored_labels_support_enabled = false
      array = Array.typed(LinkedModeUITarget).new(viewers.attr_length) { nil }
      i = 0
      while i < array.attr_length
        array[i] = EmptyTarget.new(viewers[i])
        i += 1
      end
      constructor(model, array)
    end
    
    typesig { [LinkedModeModel, LinkedModeUITarget] }
    # Convenience constructor for one target.
    # 
    # @param model the linked mode model
    # @param target the target upon which the linked mode UI should act
    def initialize(model, target)
      @f_current_target = nil
      @f_model = nil
      @f_targets = nil
      @f_iterator = nil
      @f_closer = Closer.new_local(self)
      @f_linked_listener = ExitListener.new_local(self)
      @f_selection_listener = MySelectionListener.new_local(self)
      @f_proposal_listener = ProposalListener.new_local(self)
      @f_document_listener = DocumentListener.new_local(self)
      @f_caret_position = Position.new(0, 0)
      @f_exit_policy = NullExitPolicy.new
      @f_frame_position = nil
      @f_previous_position = nil
      @f_assistant = nil
      @f_exit_position = nil
      @f_is_active = false
      @f_position_updater = DefaultPositionUpdater.new(get_category)
      @f_do_context_info = false
      @f_has_open_compound_change = false
      @f_position_listener = EmtpyFocusListener.new
      @f_auto_edit_vetoer = Class.new(IAutoEditStrategy.class == Class ? IAutoEditStrategy : Object) do
        local_class_in LinkedModeUI
        include_class_members LinkedModeUI
        include IAutoEditStrategy if IAutoEditStrategy.class == Module
        
        typesig { [IDocument, DocumentCommand] }
        # @see org.eclipse.jface.text.IAutoEditStrategy#customizeDocumentCommand(org.eclipse.jface.text.IDocument, org.eclipse.jface.text.DocumentCommand)
        define_method :customize_document_command do |document, command|
          # invalidate the change to ensure that the change is performed on the document only.
          if (self.attr_f_model.any_position_contains(command.attr_offset))
            command.attr_doit = false
            command.attr_caret_offset = command.attr_offset + command.attr_length
          end
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
      @f_simple = false
      @f_is_colored_labels_support_enabled = false
      constructor(model, Array.typed(LinkedModeUITarget).new([target]))
    end
    
    typesig { [LinkedModeModel, Array.typed(LinkedModeUITarget)] }
    # This does the actual constructor work.
    # 
    # @param model the linked mode model
    # @param targets the non-empty array of targets upon which the linked mode UI
    # should act
    def constructor(model, targets)
      Assert.is_not_null(model)
      Assert.is_not_null(targets)
      Assert.is_true(targets.attr_length > 0)
      Assert.is_true(model.get_tab_stop_sequence.size > 0)
      @f_model = model
      @f_targets = targets
      @f_current_target = targets[0]
      @f_iterator = TabStopIterator.new(@f_model.get_tab_stop_sequence)
      @f_iterator.set_cycling(!@f_model.is_nested)
      @f_model.add_linking_listener(@f_linked_listener)
      @f_assistant = ContentAssistant2.new
      @f_assistant.add_proposal_listener(@f_proposal_listener)
      # TODO find a way to set up content assistant.
      # fAssistant.setDocumentPartitioning(IJavaPartitions.JAVA_PARTITIONING);
      @f_assistant.enable_colored_labels(@f_is_colored_labels_support_enabled)
      @f_caret_position.delete
    end
    
    typesig { [] }
    # Starts this UI on the first position.
    def enter
      @f_is_active = true
      connect
      next_
    end
    
    typesig { [IExitPolicy] }
    # Sets an <code>IExitPolicy</code> to customize the exit behavior of
    # this linked mode UI.
    # 
    # @param policy the exit policy to use.
    def set_exit_policy(policy)
      @f_exit_policy = policy
    end
    
    typesig { [LinkedModeUITarget, ::Java::Int, ::Java::Int, ::Java::Int] }
    # Sets the exit position to move the caret to when linked mode mode is
    # exited.
    # 
    # @param target the target where the exit position is located
    # @param offset the offset of the exit position
    # @param length the length of the exit position (in case there should be a
    # selection)
    # @param sequence set to the tab stop position of the exit position, or
    # <code>LinkedPositionGroup.NO_STOP</code> if there should be no
    # tab stop.
    # @throws BadLocationException if the position is not valid in the viewer's
    # document
    def set_exit_position(target, offset, length, sequence)
      # remove any existing exit position
      if (!(@f_exit_position).nil?)
        @f_exit_position.get_document.remove_position(@f_exit_position)
        @f_iterator.remove_position(@f_exit_position)
        @f_exit_position = nil
      end
      doc = target.get_viewer.get_document
      if ((doc).nil?)
        return
      end
      @f_exit_position = LinkedPosition.new(doc, offset, length, sequence)
      doc.add_position(@f_exit_position) # gets removed in leave()
      if (!(sequence).equal?(LinkedPositionGroup::NO_STOP))
        @f_iterator.add_position(@f_exit_position)
      end
    end
    
    typesig { [ITextViewer, ::Java::Int, ::Java::Int, ::Java::Int] }
    # Sets the exit position to move the caret to when linked mode is exited.
    # 
    # @param viewer the viewer where the exit position is located
    # @param offset the offset of the exit position
    # @param length the length of the exit position (in case there should be a
    # selection)
    # @param sequence set to the tab stop position of the exit position, or
    # <code>LinkedPositionGroup.NO_STOP</code> if there should be no tab stop.
    # @throws BadLocationException if the position is not valid in the
    # viewer's document
    def set_exit_position(viewer, offset, length, sequence)
      set_exit_position(EmptyTarget.new(viewer), offset, length, sequence)
    end
    
    typesig { [Object] }
    # Sets the cycling mode to either of <code>CYCLING_ALWAYS</code>,
    # <code>CYCLING_NEVER</code>, or <code>CYCLING_WHEN_NO_PARENT</code>,
    # which is the default.
    # 
    # @param mode the new cycling mode.
    def set_cycling_mode(mode)
      if (!(mode).equal?(CYCLE_ALWAYS) && !(mode).equal?(CYCLE_NEVER) && !(mode).equal?(CYCLE_WHEN_NO_PARENT))
        raise IllegalArgumentException.new
      end
      if ((mode).equal?(CYCLE_ALWAYS) || (mode).equal?(CYCLE_WHEN_NO_PARENT) && !@f_model.is_nested)
        @f_iterator.set_cycling(true)
      else
        @f_iterator.set_cycling(false)
      end
    end
    
    typesig { [] }
    def next_
      if (@f_iterator.has_next(@f_frame_position))
        switch_position(@f_iterator.next_(@f_frame_position), true, true)
        return
      end
      leave(ILinkedModeListener::UPDATE_CARET)
    end
    
    typesig { [] }
    def previous
      if (@f_iterator.has_previous(@f_frame_position))
        switch_position(@f_iterator.previous(@f_frame_position), true, true)
      else
        # dont't update caret, but rather select the current frame
        leave(ILinkedModeListener::SELECT)
      end
    end
    
    typesig { [] }
    def trigger_context_info
      target = @f_current_target.get_viewer.get_text_operation_target
      if (!(target).nil?)
        if (target.can_do_operation(ISourceViewer::CONTENTASSIST_CONTEXT_INFORMATION))
          target.do_operation(ISourceViewer::CONTENTASSIST_CONTEXT_INFORMATION)
        end
      end
    end
    
    typesig { [] }
    # Trigger content assist on choice positions
    def trigger_content_assist
      if (@f_frame_position.is_a?(ProposalPosition))
        pp = @f_frame_position
        choices = pp.get_choices
        if (!(choices).nil? && choices.attr_length > 0)
          @f_assistant.set_completions(choices)
          @f_assistant.show_possible_completions
          return
        end
      end
      @f_assistant.set_completions(Array.typed(ICompletionProposal).new(0) { nil })
      @f_assistant.hide_possible_completions
    end
    
    typesig { [LinkedPosition, ::Java::Boolean, ::Java::Boolean] }
    def switch_position(pos, select, show_proposals)
      Assert.is_not_null(pos)
      if ((pos == @f_frame_position))
        return
      end
      if (!(@f_frame_position).nil? && !(@f_current_target).nil?)
        @f_position_listener.linking_focus_lost(@f_frame_position, @f_current_target)
      end
      # undo
      end_compound_change
      redraw # redraw current position being left - usually not needed
      old_doc = (@f_frame_position).nil? ? nil : @f_frame_position.get_document
      new_doc = pos.get_document
      switch_viewer(old_doc, new_doc, pos)
      @f_frame_position = pos
      if (select)
        select
      end
      if ((@f_frame_position).equal?(@f_exit_position) && !@f_iterator.is_cycling)
        leave(ILinkedModeListener::NONE)
      else
        redraw # redraw new position
        ensure_annotation_model_installed
      end
      if (show_proposals)
        trigger_content_assist
      end
      if (!(@f_frame_position).equal?(@f_exit_position) && @f_do_context_info)
        trigger_context_info
      end
      if (!(@f_frame_position).nil? && !(@f_current_target).nil?)
        @f_position_listener.linking_focus_gained(@f_frame_position, @f_current_target)
      end
    end
    
    typesig { [] }
    def ensure_annotation_model_installed
      lpa = @f_current_target.attr_f_annotation_model
      if (!(lpa).nil?)
        viewer = @f_current_target.get_viewer
        if (viewer.is_a?(ISourceViewer))
          sv = viewer
          model = sv.get_annotation_model
          if (model.is_a?(IAnnotationModelExtension))
            ext = model
            our_model = ext.get_annotation_model(get_unique_key)
            if ((our_model).nil?)
              ext.add_annotation_model(get_unique_key, lpa)
            end
          end
        end
      end
    end
    
    typesig { [LinkedModeUITarget] }
    def uninstall_annotation_model(target)
      viewer = target.get_viewer
      if (viewer.is_a?(ISourceViewer))
        sv = viewer
        model = sv.get_annotation_model
        if (model.is_a?(IAnnotationModelExtension))
          ext = model
          ext.remove_annotation_model(get_unique_key)
        end
      end
    end
    
    typesig { [IDocument, IDocument, LinkedPosition] }
    def switch_viewer(old_doc, new_doc, pos)
      if (!(old_doc).equal?(new_doc))
        # redraw current document with new position before switching viewer
        if (!(@f_current_target.attr_f_annotation_model).nil?)
          @f_current_target.attr_f_annotation_model.switch_to_position(@f_model, pos)
        end
        target = nil
        i = 0
        while i < @f_targets.attr_length
          if ((@f_targets[i].get_viewer.get_document).equal?(new_doc))
            target = @f_targets[i]
            break
          end
          i += 1
        end
        if (!(target).equal?(@f_current_target))
          disconnect
          @f_current_target = target
          target.linking_focus_lost(@f_frame_position, target)
          connect
          ensure_annotation_model_installed
          if (!(@f_current_target).nil?)
            @f_current_target.linking_focus_gained(pos, @f_current_target)
          end
        end
      end
    end
    
    typesig { [] }
    def select
      viewer = @f_current_target.get_viewer
      if (viewer.is_a?(ITextViewerExtension5))
        extension5 = viewer
        extension5.expose_model_range(Region.new(@f_frame_position.attr_offset, @f_frame_position.attr_length))
      else
        if (!viewer.overlaps_with_visible_region(@f_frame_position.attr_offset, @f_frame_position.attr_length))
          viewer.reset_visible_region
        end
      end
      viewer.reveal_range(@f_frame_position.attr_offset, @f_frame_position.attr_length)
      viewer.set_selected_range(@f_frame_position.attr_offset, @f_frame_position.attr_length)
    end
    
    typesig { [] }
    def redraw
      if (!(@f_current_target.attr_f_annotation_model).nil?)
        @f_current_target.attr_f_annotation_model.switch_to_position(@f_model, @f_frame_position)
      end
    end
    
    typesig { [] }
    def connect
      Assert.is_not_null(@f_current_target)
      viewer = @f_current_target.get_viewer
      Assert.is_not_null(viewer)
      @f_current_target.attr_f_widget = viewer.get_text_widget
      if ((@f_current_target.attr_f_widget).nil?)
        leave(ILinkedModeListener::EXIT_ALL)
      end
      if ((@f_current_target.attr_f_key_listener).nil?)
        @f_current_target.attr_f_key_listener = KeyListener.new_local(self)
        (viewer).prepend_verify_key_listener(@f_current_target.attr_f_key_listener)
      else
        @f_current_target.attr_f_key_listener.set_enabled(true)
      end
      register_auto_edit_vetoer(viewer)
      (viewer).add_post_selection_changed_listener(@f_selection_listener)
      create_annotation_model
      show_selection
      @f_current_target.attr_f_shell = @f_current_target.attr_f_widget.get_shell
      if ((@f_current_target.attr_f_shell).nil?)
        leave(ILinkedModeListener::EXIT_ALL)
      end
      @f_current_target.attr_f_shell.add_shell_listener(@f_closer)
      @f_assistant.install(viewer)
      viewer.add_text_input_listener(@f_closer)
      viewer.get_document.add_document_listener(@f_document_listener)
    end
    
    typesig { [] }
    # Reveals the selection on the current target's widget, if it is valid.
    def show_selection
      widget = @f_current_target.attr_f_widget
      if ((widget).nil? || widget.is_disposed)
        return
      end
      widget.get_display.async_exec(# See https://bugs.eclipse.org/bugs/show_bug.cgi?id=132263
      Class.new(Runnable.class == Class ? Runnable : Object) do
        local_class_in LinkedModeUI
        include_class_members LinkedModeUI
        include Runnable if Runnable.class == Module
        
        typesig { [] }
        define_method :run do
          if (!widget.is_disposed)
            begin
              widget.show_selection
            rescue self.class::IllegalArgumentException => e
              # See https://bugs.eclipse.org/bugs/show_bug.cgi?id=66914
              # if the StyledText is in setRedraw(false) mode, its
              # selection may not be up2date and calling showSelection
              # will throw an IAE.
              # We don't have means to find out whether the selection is valid
              # or whether the widget is redrawing or not therefore we try
              # and ignore an IAE.
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
    
    typesig { [ITextViewer] }
    # Registers our auto edit vetoer with the viewer.
    # 
    # @param viewer the viewer we want to veto ui-triggered changes within
    # linked positions
    def register_auto_edit_vetoer(viewer)
      begin
        content_types = get_content_types(viewer.get_document)
        if (viewer.is_a?(ITextViewerExtension2))
          v_extension = (viewer)
          i = 0
          while i < content_types.attr_length
            v_extension.prepend_auto_edit_strategy(@f_auto_edit_vetoer, content_types[i])
            i += 1
          end
        else
          Assert.is_true(false)
        end
      rescue BadPartitioningException => e
        leave(ILinkedModeListener::EXIT_ALL)
      end
    end
    
    typesig { [ITextViewer] }
    def unregister_auto_edit_vetoer(viewer)
      begin
        content_types = get_content_types(viewer.get_document)
        if (viewer.is_a?(ITextViewerExtension2))
          v_extension = (viewer)
          i = 0
          while i < content_types.attr_length
            v_extension.remove_auto_edit_strategy(@f_auto_edit_vetoer, content_types[i])
            i += 1
          end
        else
          Assert.is_true(false)
        end
      rescue BadPartitioningException => e
        leave(ILinkedModeListener::EXIT_ALL)
      end
    end
    
    typesig { [IDocument] }
    # Returns all possible content types of <code>document</code>.
    # 
    # @param document the document
    # @return all possible content types of <code>document</code>
    # @throws BadPartitioningException if partitioning is invalid for this document
    # @since 3.1
    def get_content_types(document)
      if (document.is_a?(IDocumentExtension3))
        ext = document
        partitionings = ext.get_partitionings
        content_types = HashSet.new(20)
        i = 0
        while i < partitionings.attr_length
          content_types.add_all(Arrays.as_list(ext.get_legal_content_types(partitionings[i])))
          i += 1
        end
        content_types.add(IDocument::DEFAULT_CONTENT_TYPE)
        return content_types.to_array(Array.typed(String).new(content_types.size) { nil })
      end
      return document.get_legal_content_types
    end
    
    typesig { [] }
    def create_annotation_model
      if ((@f_current_target.attr_f_annotation_model).nil?)
        lpa = LinkedPositionAnnotations.new
        if (@f_simple)
          lpa.mark_exit_target(true)
          lpa.mark_focus(false)
          lpa.mark_slaves(false)
          lpa.mark_targets(false)
        end
        lpa.set_targets(@f_iterator.get_positions)
        lpa.set_exit_target(@f_exit_position)
        lpa.connect(@f_current_target.get_viewer.get_document)
        @f_current_target.attr_f_annotation_model = lpa
      end
    end
    
    typesig { [] }
    def get_unique_key
      return "linked.annotationmodelkey." + RJava.cast_to_string(to_s) # $NON-NLS-1$
    end
    
    typesig { [] }
    def disconnect
      Assert.is_not_null(@f_current_target)
      viewer = @f_current_target.get_viewer
      Assert.is_not_null(viewer)
      viewer.get_document.remove_document_listener(@f_document_listener)
      @f_assistant.uninstall
      @f_assistant.remove_proposal_listener(@f_proposal_listener)
      @f_current_target.attr_f_widget = nil
      shell = @f_current_target.attr_f_shell
      @f_current_target.attr_f_shell = nil
      if (!(shell).nil? && !shell.is_disposed)
        shell.remove_shell_listener(@f_closer)
      end
      # this one is asymmetric: we don't install the model in
      # connect, but leave it to its callers to ensure they
      # have the model installed if they need it
      uninstall_annotation_model(@f_current_target)
      unregister_auto_edit_vetoer(viewer)
      # don't remove the verify key listener to let it keep its position
      # in the listener queue
      if (!(@f_current_target.attr_f_key_listener).nil?)
        @f_current_target.attr_f_key_listener.set_enabled(false)
      end
      (viewer).remove_post_selection_changed_listener(@f_selection_listener)
      redraw
    end
    
    typesig { [::Java::Int] }
    def leave(flags)
      if (!@f_is_active)
        return
      end
      @f_is_active = false
      end_compound_change
      display = nil
      if (!(@f_current_target.attr_f_widget).nil? && !@f_current_target.attr_f_widget.is_disposed)
        display = @f_current_target.attr_f_widget.get_display
      end
      if (!(@f_current_target.attr_f_annotation_model).nil?)
        @f_current_target.attr_f_annotation_model.remove_all_annotations
      end
      disconnect
      i = 0
      while i < @f_targets.attr_length
        target = @f_targets[i]
        viewer = target.get_viewer
        if (!(target.attr_f_key_listener).nil?)
          (viewer).remove_verify_key_listener(target.attr_f_key_listener)
          target.attr_f_key_listener = nil
        end
        viewer.remove_text_input_listener(@f_closer)
        i += 1
      end
      i_ = 0
      while i_ < @f_targets.attr_length
        if (!(@f_targets[i_].attr_f_annotation_model).nil?)
          @f_targets[i_].attr_f_annotation_model.remove_all_annotations
          @f_targets[i_].attr_f_annotation_model.disconnect(@f_targets[i_].get_viewer.get_document)
          @f_targets[i_].attr_f_annotation_model = nil
        end
        uninstall_annotation_model(@f_targets[i_])
        i_ += 1
      end
      if (!((flags & ILinkedModeListener::UPDATE_CARET)).equal?(0) && !(@f_exit_position).nil? && !(@f_frame_position).equal?(@f_exit_position) && !@f_exit_position.is_deleted)
        switch_position(@f_exit_position, true, false)
      end
      docs = ArrayList.new
      i__ = 0
      while i__ < @f_targets.attr_length
        doc = @f_targets[i__].get_viewer.get_document
        if (!(doc).nil?)
          docs.add(doc)
        end
        i__ += 1
      end
      @f_model.stop_forwarding(flags)
      runnable = Class.new(Runnable.class == Class ? Runnable : Object) do
        local_class_in LinkedModeUI
        include_class_members LinkedModeUI
        include Runnable if Runnable.class == Module
        
        typesig { [] }
        define_method :run do
          if (!(self.attr_f_exit_position).nil?)
            self.attr_f_exit_position.get_document.remove_position(self.attr_f_exit_position)
          end
          iter = docs.iterator
          while iter.has_next
            doc = iter.next_
            doc.remove_position_updater(self.attr_f_position_updater)
            uninstall_cat = false
            cats = doc.get_position_categories
            j = 0
            while j < cats.attr_length
              if ((get_category == cats[j]))
                uninstall_cat = true
                break
              end
              j += 1
            end
            if (uninstall_cat)
              begin
                doc.remove_position_category(get_category)
              rescue self.class::BadPositionCategoryException => e
                # ignore
              end
            end
          end
          self.attr_f_model.exit(flags)
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
      # remove positions (both exit positions AND linked positions in the
      # model) asynchronously to make sure that the annotation painter
      # gets correct document offsets.
      if (!(display).nil?)
        display.async_exec(runnable)
      else
        runnable.run
      end
    end
    
    typesig { [] }
    def end_compound_change
      if (@f_has_open_compound_change)
        extension = @f_current_target.get_viewer
        target = extension.get_rewrite_target
        target.end_compound_change
        @f_has_open_compound_change = false
      end
    end
    
    typesig { [] }
    def begin_compound_change
      if (!@f_has_open_compound_change)
        extension = @f_current_target.get_viewer
        target = extension.get_rewrite_target
        target.begin_compound_change
        @f_has_open_compound_change = true
      end
    end
    
    typesig { [] }
    # Returns the currently selected region or <code>null</code>.
    # 
    # @return the currently selected region or <code>null</code>
    def get_selected_region
      if (!(@f_frame_position).nil?)
        return Region.new(@f_frame_position.get_offset, @f_frame_position.get_length)
      end
      if (!(@f_exit_position).nil?)
        return Region.new(@f_exit_position.get_offset, @f_exit_position.get_length)
      end
      return nil
    end
    
    typesig { [] }
    def get_category
      return to_s
    end
    
    typesig { [::Java::Boolean] }
    # Sets the context info property. If set to <code>true</code>, context
    # info will be invoked on the current target's viewer whenever a position
    # is switched.
    # 
    # @param doContextInfo <code>true</code> if context information should be
    # displayed
    def set_do_context_info(do_context_info)
      @f_do_context_info = do_context_info
    end
    
    typesig { [ILinkedModeUIFocusListener] }
    # Sets the focus callback which will get informed when the focus of the
    # linked mode UI changes.
    # <p>
    # If there is a listener installed already, it will be replaced.
    # </p>
    # 
    # @param listener the new listener, never <code>null</code>.
    def set_position_listener(listener)
      Assert.is_not_null(listener)
      @f_position_listener = listener
    end
    
    typesig { [::Java::Boolean] }
    # Sets the "simple" mode of the receiver. A linked mode UI in simple mode
    # merely draws the exit position, but not the target, focus, and slave
    # positions. Default is <code>false</code>. This method must be called
    # before it is entered.
    # 
    # @param simple <code>true</code> if the UI should be in simple mode.
    def set_simple_mode(simple)
      @f_simple = simple
    end
    
    typesig { [::Java::Boolean] }
    # Enables the support for colored labels in the proposal popup.
    # <p>Completion proposals can implement {@link ICompletionProposalExtension6}
    # to provide colored proposal labels.</p>
    # 
    # @param isEnabled if <code>true</code> the support for colored labels is enabled in the proposal popup
    # @since 3.4
    def enable_colored_labels(is_enabled)
      @f_is_colored_labels_support_enabled = is_enabled
    end
    
    private
    alias_method :initialize__linked_mode_ui, :initialize
  end
  
end
