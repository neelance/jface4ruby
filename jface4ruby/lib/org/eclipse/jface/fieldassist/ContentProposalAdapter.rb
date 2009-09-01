require "rjava"

# Copyright (c) 2005, 2009 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Fieldassist
  module ContentProposalAdapterImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Fieldassist
      include_const ::Java::Util, :ArrayList
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Core::Runtime, :ListenerList
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Events, :DisposeEvent
      include_const ::Org::Eclipse::Swt::Events, :DisposeListener
      include_const ::Org::Eclipse::Swt::Events, :FocusAdapter
      include_const ::Org::Eclipse::Swt::Events, :FocusEvent
      include_const ::Org::Eclipse::Swt::Events, :SelectionEvent
      include_const ::Org::Eclipse::Swt::Events, :SelectionListener
      include_const ::Org::Eclipse::Swt::Graphics, :Color
      include_const ::Org::Eclipse::Swt::Graphics, :Image
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Graphics, :Rectangle
      include_const ::Org::Eclipse::Swt::Layout, :GridData
      include_const ::Org::Eclipse::Swt::Widgets, :Combo
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Event
      include_const ::Org::Eclipse::Swt::Widgets, :Listener
      include_const ::Org::Eclipse::Swt::Widgets, :ScrollBar
      include_const ::Org::Eclipse::Swt::Widgets, :Shell
      include_const ::Org::Eclipse::Swt::Widgets, :Table
      include_const ::Org::Eclipse::Swt::Widgets, :TableItem
      include_const ::Org::Eclipse::Swt::Widgets, :Text
      include_const ::Org::Eclipse::Jface::Bindings::Keys, :KeyStroke
      include_const ::Org::Eclipse::Jface::Dialogs, :PopupDialog
      include_const ::Org::Eclipse::Jface::Preference, :JFacePreferences
      include_const ::Org::Eclipse::Jface::Resource, :JFaceResources
      include_const ::Org::Eclipse::Jface::Util, :Util
      include_const ::Org::Eclipse::Jface::Viewers, :ILabelProvider
    }
  end
  
  # ContentProposalAdapter can be used to attach content proposal behavior to a
  # control. This behavior includes obtaining proposals, opening a popup dialog,
  # managing the content of the control relative to the selections in the popup,
  # and optionally opening up a secondary popup to further describe proposals.
  # <p>
  # A number of configurable options are provided to determine how the control
  # content is altered when a proposal is chosen, how the content proposal popup
  # is activated, and whether any filtering should be done on the proposals as
  # the user types characters.
  # <p>
  # This class is not intended to be subclassed.
  # 
  # @since 3.2
  class ContentProposalAdapter 
    include_class_members ContentProposalAdapterImports
    
    class_module.module_eval {
      # The lightweight popup used to show content proposals for a text field. If
      # additional information exists for a proposal, then selecting that
      # proposal will result in the information being displayed in a secondary
      # popup.
      const_set_lazy(:ContentProposalPopup) { Class.new(PopupDialog) do
        extend LocalClass
        include_class_members ContentProposalAdapter
        
        class_module.module_eval {
          # The listener we install on the popup and related controls to
          # determine when to close the popup. Some events (move, resize, close,
          # deactivate) trigger closure as soon as they are received, simply
          # because one of the registered listeners received them. Other events
          # depend on additional circumstances.
          const_set_lazy(:PopupCloserListener) { Class.new do
            extend LocalClass
            include_class_members ContentProposalPopup
            include class_self::Listener
            
            attr_accessor :scrollbar_clicked
            alias_method :attr_scrollbar_clicked, :scrollbar_clicked
            undef_method :scrollbar_clicked
            alias_method :attr_scrollbar_clicked=, :scrollbar_clicked=
            undef_method :scrollbar_clicked=
            
            typesig { [class_self::Event] }
            def handle_event(e)
              # If focus is leaving an important widget or the field's
              # shell is deactivating
              if ((e.attr_type).equal?(SWT::FocusOut))
                @scrollbar_clicked = false
                e.attr_display.async_exec(# Ignore this event if it's only happening because focus is
                # moving between the popup shells, their controls, or a
                # scrollbar. Do this in an async since the focus is not
                # actually switched when this event is received.
                Class.new(self.class::Runnable.class == Class ? self.class::Runnable : Object) do
                  extend LocalClass
                  include_class_members PopupCloserListener
                  include class_self::Runnable if class_self::Runnable.class == Module
                  
                  typesig { [] }
                  define_method :run do
                    if (is_valid)
                      if (self.attr_scrollbar_clicked || has_focus)
                        return
                      end
                      # Workaround a problem on X and Mac, whereby at
                      # this point, the focus control is not known.
                      # This can happen, for example, when resizing
                      # the popup shell on the Mac.
                      # Check the active shell.
                      active_shell = e.attr_display.get_active_shell
                      if ((active_shell).equal?(get_shell) || (!(self.attr_info_popup).nil? && (self.attr_info_popup.get_shell).equal?(active_shell)))
                        return
                      end
                      # System.out.println(e);
                      # System.out.println(e.display.getFocusControl());
                      # System.out.println(e.display.getActiveShell());
                      close
                    end
                  end
                  
                  typesig { [Vararg.new(Object)] }
                  define_method :initialize do |*args|
                    super(*args)
                  end
                  
                  private
                  alias_method :initialize_anonymous, :initialize
                end.new_local(self))
                return
              end
              # Scroll bar has been clicked. Remember this for focus event
              # processing.
              if ((e.attr_type).equal?(SWT::Selection))
                @scrollbar_clicked = true
                return
              end
              # For all other events, merely getting them dictates closure.
              close
            end
            
            typesig { [] }
            # Install the listeners for events that need to be monitored for
            # popup closure.
            def install_listeners
              # Listeners on this popup's table and scroll bar
              self.attr_proposal_table.add_listener(SWT::FocusOut, self)
              scrollbar = self.attr_proposal_table.get_vertical_bar
              if (!(scrollbar).nil?)
                scrollbar.add_listener(SWT::Selection, self)
              end
              # Listeners on this popup's shell
              get_shell.add_listener(SWT::Deactivate, self)
              get_shell.add_listener(SWT::Close, self)
              # Listeners on the target control
              self.attr_control.add_listener(SWT::MouseDoubleClick, self)
              self.attr_control.add_listener(SWT::MouseDown, self)
              self.attr_control.add_listener(SWT::Dispose, self)
              self.attr_control.add_listener(SWT::FocusOut, self)
              # Listeners on the target control's shell
              control_shell = self.attr_control.get_shell
              control_shell.add_listener(SWT::Move, self)
              control_shell.add_listener(SWT::Resize, self)
            end
            
            typesig { [] }
            # Remove installed listeners
            def remove_listeners
              if (is_valid)
                self.attr_proposal_table.remove_listener(SWT::FocusOut, self)
                scrollbar = self.attr_proposal_table.get_vertical_bar
                if (!(scrollbar).nil?)
                  scrollbar.remove_listener(SWT::Selection, self)
                end
                get_shell.remove_listener(SWT::Deactivate, self)
                get_shell.remove_listener(SWT::Close, self)
              end
              if (!(self.attr_control).nil? && !self.attr_control.is_disposed)
                self.attr_control.remove_listener(SWT::MouseDoubleClick, self)
                self.attr_control.remove_listener(SWT::MouseDown, self)
                self.attr_control.remove_listener(SWT::Dispose, self)
                self.attr_control.remove_listener(SWT::FocusOut, self)
                control_shell = self.attr_control.get_shell
                control_shell.remove_listener(SWT::Move, self)
                control_shell.remove_listener(SWT::Resize, self)
              end
            end
            
            typesig { [] }
            def initialize
              @scrollbar_clicked = false
            end
            
            private
            alias_method :initialize__popup_closer_listener, :initialize
          end }
          
          # The listener we will install on the target control.
          const_set_lazy(:TargetControlListener) { Class.new do
            extend LocalClass
            include_class_members ContentProposalPopup
            include class_self::Listener
            
            typesig { [class_self::Event] }
            # Key events from the control
            def handle_event(e)
              if (!is_valid)
                return
              end
              key = e.attr_character
              # Traverse events are handled depending on whether the
              # event has a character.
              if ((e.attr_type).equal?(SWT::Traverse))
                # If the traverse event contains a legitimate character,
                # then we must set doit false so that the widget will
                # receive the key event. We return immediately so that
                # the character is handled only in the key event.
                # See https://bugs.eclipse.org/bugs/show_bug.cgi?id=132101
                if (!(key).equal?(0))
                  e.attr_doit = false
                  return
                end
                # Traversal does not contain a character. Set doit true
                # to indicate TRAVERSE_NONE will occur and that no key
                # event will be triggered. We will check for navigation
                # keys below.
                e.attr_detail = SWT::TRAVERSE_NONE
                e.attr_doit = true
              else
                # Default is to only propagate when configured that way.
                # Some keys will always set doit to false anyway.
                e.attr_doit = self.attr_propagate_keys
              end
              # No character. Check for navigation keys.
              if ((key).equal?(0))
                new_selection = self.attr_proposal_table.get_selection_index
                visible_rows = (self.attr_proposal_table.get_size.attr_y / self.attr_proposal_table.get_item_height) - 1
                case (e.attr_key_code)
                # If received as a Traverse, these should propagate
                # to the control as keydown. If received as a keydown,
                # proposals should be recomputed since the cursor
                # position has changed.
                # Any unknown keycodes will cause the popup to close.
                # Modifier keys are explicitly checked and ignored because
                # they are not complete yet (no character).
                when SWT::ARROW_UP
                  new_selection -= 1
                  if (new_selection < 0)
                    new_selection = self.attr_proposal_table.get_item_count - 1
                  end
                  # Not typical - usually we get this as a Traverse and
                  # therefore it never propagates. Added for consistency.
                  if ((e.attr_type).equal?(SWT::KeyDown))
                    # don't propagate to control
                    e.attr_doit = false
                  end
                when SWT::ARROW_DOWN
                  new_selection += 1
                  if (new_selection > self.attr_proposal_table.get_item_count - 1)
                    new_selection = 0
                  end
                  # Not typical - usually we get this as a Traverse and
                  # therefore it never propagates. Added for consistency.
                  if ((e.attr_type).equal?(SWT::KeyDown))
                    # don't propagate to control
                    e.attr_doit = false
                  end
                when SWT::PAGE_DOWN
                  new_selection += visible_rows
                  if (new_selection >= self.attr_proposal_table.get_item_count)
                    new_selection = self.attr_proposal_table.get_item_count - 1
                  end
                  if ((e.attr_type).equal?(SWT::KeyDown))
                    # don't propagate to control
                    e.attr_doit = false
                  end
                when SWT::PAGE_UP
                  new_selection -= visible_rows
                  if (new_selection < 0)
                    new_selection = 0
                  end
                  if ((e.attr_type).equal?(SWT::KeyDown))
                    # don't propagate to control
                    e.attr_doit = false
                  end
                when SWT::HOME
                  new_selection = 0
                  if ((e.attr_type).equal?(SWT::KeyDown))
                    # don't propagate to control
                    e.attr_doit = false
                  end
                when SWT::END_
                  new_selection = self.attr_proposal_table.get_item_count - 1
                  if ((e.attr_type).equal?(SWT::KeyDown))
                    # don't propagate to control
                    e.attr_doit = false
                  end
                when SWT::ARROW_LEFT, SWT::ARROW_RIGHT
                  if ((e.attr_type).equal?(SWT::Traverse))
                    e.attr_doit = false
                  else
                    e.attr_doit = true
                    contents = get_control_content_adapter.get_control_contents(get_control)
                    # If there are no contents, changes in cursor
                    # position have no effect. Note also that we do
                    # not affect the filter text on ARROW_LEFT as
                    # we would with BS.
                    if (contents.length > 0)
                      async_recompute_proposals(self.attr_filter_text)
                    end
                  end
                else
                  if (!(e.attr_key_code).equal?(SWT::CAPS_LOCK) && !(e.attr_key_code).equal?(SWT::MOD1) && !(e.attr_key_code).equal?(SWT::MOD2) && !(e.attr_key_code).equal?(SWT::MOD3) && !(e.attr_key_code).equal?(SWT::MOD4))
                    close
                  end
                  return
                end
                # If any of these navigation events caused a new selection,
                # then handle that now and return.
                if (new_selection >= 0)
                  select_proposal(new_selection)
                end
                return
              end
              # key != 0
              # Check for special keys involved in cancelling, accepting, or
              # filtering the proposals.
              case (key)
              when SWT::ESC
                e.attr_doit = false
                close
              when SWT::LF, SWT::CR
                e.attr_doit = false
                p = get_selected_proposal
                if (!(p).nil?)
                  accept_current_proposal
                else
                  close
                end
              when SWT::TAB
                e.attr_doit = false
                get_shell.set_focus
                return
              when SWT::BS
                # Backspace should back out of any stored filter text
                if (!(self.attr_filter_style).equal?(FILTER_NONE))
                  # We have no filter to back out of, so do nothing
                  if ((self.attr_filter_text.length).equal?(0))
                    return
                  end
                  # There is filter to back out of
                  self.attr_filter_text = self.attr_filter_text.substring(0, self.attr_filter_text.length - 1)
                  async_recompute_proposals(self.attr_filter_text)
                  return
                end
                # There is no filtering provided by us, but some
                # clients provide their own filtering based on content.
                # Recompute the proposals if the cursor position
                # will change (is not at 0).
                pos = get_control_content_adapter.get_cursor_position(get_control)
                # We rely on the fact that the contents and pos do not yet
                # reflect the result of the BS. If the contents were
                # already empty, then BS should not cause
                # a recompute.
                if (pos > 0)
                  async_recompute_proposals(self.attr_filter_text)
                end
              else
                # If the key is a defined unicode character, and not one of
                # the special cases processed above, update the filter text
                # and filter the proposals.
                if (Character.is_defined(key))
                  if ((self.attr_filter_style).equal?(FILTER_CUMULATIVE))
                    self.attr_filter_text = self.attr_filter_text + String.value_of(key)
                  else
                    if ((self.attr_filter_style).equal?(FILTER_CHARACTER))
                      self.attr_filter_text = String.value_of(key)
                    end
                  end
                  # Recompute proposals after processing this event.
                  async_recompute_proposals(self.attr_filter_text)
                end
              end
            end
            
            typesig { [] }
            def initialize
            end
            
            private
            alias_method :initialize__target_control_listener, :initialize
          end }
          
          # Internal class used to implement the secondary popup.
          const_set_lazy(:InfoPopupDialog) { Class.new(class_self::PopupDialog) do
            extend LocalClass
            include_class_members ContentProposalPopup
            
            # The text control that displays the text.
            attr_accessor :text
            alias_method :attr_text, :text
            undef_method :text
            alias_method :attr_text=, :text=
            undef_method :text=
            
            # The String shown in the popup.
            attr_accessor :contents
            alias_method :attr_contents, :contents
            undef_method :contents
            alias_method :attr_contents=, :contents=
            undef_method :contents=
            
            typesig { [class_self::Shell] }
            # Construct an info-popup with the specified parent.
            def initialize(parent)
              @text = nil
              @contents = nil
              super(parent, PopupDialog::HOVER_SHELLSTYLE, false, false, false, false, false, nil, nil)
              @contents = EMPTY
            end
            
            typesig { [class_self::Composite] }
            # Create a text control for showing the info about a proposal.
            def create_dialog_area(parent)
              @text = self.class::Text.new(parent, SWT::MULTI | SWT::READ_ONLY | SWT::WRAP | SWT::NO_FOCUS)
              # Use the compact margins employed by PopupDialog.
              gd = self.class::GridData.new(GridData::BEGINNING | GridData::FILL_BOTH)
              gd.attr_horizontal_indent = PopupDialog::POPUP_HORIZONTALSPACING
              gd.attr_vertical_indent = PopupDialog::POPUP_VERTICALSPACING
              @text.set_layout_data(gd)
              @text.set_text(@contents)
              @text.add_focus_listener(# since SWT.NO_FOCUS is only a hint...
              Class.new(self.class::FocusAdapter.class == Class ? self.class::FocusAdapter : Object) do
                extend LocalClass
                include_class_members InfoPopupDialog
                include class_self::FocusAdapter if class_self::FocusAdapter.class == Module
                
                typesig { [class_self::FocusEvent] }
                define_method :focus_gained do |event|
                  @local_class_parent.local_class_parent.close
                end
                
                typesig { [Vararg.new(Object)] }
                define_method :initialize do |*args|
                  super(*args)
                end
                
                private
                alias_method :initialize_anonymous, :initialize
              end.new_local(self))
              return @text
            end
            
            typesig { [] }
            # Adjust the bounds so that we appear adjacent to our parent shell
            def adjust_bounds
              parent_bounds = get_parent_shell.get_bounds
              proposed_bounds = nil
              # Try placing the info popup to the right
              right_proposed_bounds = self.class::Rectangle.new(parent_bounds.attr_x + parent_bounds.attr_width + PopupDialog::POPUP_HORIZONTALSPACING, parent_bounds.attr_y + PopupDialog::POPUP_VERTICALSPACING, parent_bounds.attr_width, parent_bounds.attr_height)
              right_proposed_bounds = get_constrained_shell_bounds(right_proposed_bounds)
              # If it won't fit on the right, try the left
              if (right_proposed_bounds.intersects(parent_bounds))
                left_proposed_bounds = self.class::Rectangle.new(parent_bounds.attr_x - parent_bounds.attr_width - POPUP_HORIZONTALSPACING - 1, parent_bounds.attr_y, parent_bounds.attr_width, parent_bounds.attr_height)
                left_proposed_bounds = get_constrained_shell_bounds(left_proposed_bounds)
                # If it won't fit on the left, choose the proposed bounds
                # that fits the best
                if (left_proposed_bounds.intersects(parent_bounds))
                  if (right_proposed_bounds.attr_x - parent_bounds.attr_x >= parent_bounds.attr_x - left_proposed_bounds.attr_x)
                    right_proposed_bounds.attr_x = parent_bounds.attr_x + parent_bounds.attr_width + PopupDialog::POPUP_HORIZONTALSPACING
                    proposed_bounds = right_proposed_bounds
                  else
                    left_proposed_bounds.attr_width = parent_bounds.attr_x - POPUP_HORIZONTALSPACING - left_proposed_bounds.attr_x
                    proposed_bounds = left_proposed_bounds
                  end
                else
                  # use the proposed bounds on the left
                  proposed_bounds = left_proposed_bounds
                end
              else
                # use the proposed bounds on the right
                proposed_bounds = right_proposed_bounds
              end
              get_shell.set_bounds(proposed_bounds)
            end
            
            typesig { [] }
            # (non-Javadoc)
            # @see org.eclipse.jface.dialogs.PopupDialog#getForeground()
            def get_foreground
              return self.attr_control.get_display.get_system_color(SWT::COLOR_INFO_FOREGROUND)
            end
            
            typesig { [] }
            # (non-Javadoc)
            # @see org.eclipse.jface.dialogs.PopupDialog#getBackground()
            def get_background
              return self.attr_control.get_display.get_system_color(SWT::COLOR_INFO_BACKGROUND)
            end
            
            typesig { [String] }
            # Set the text contents of the popup.
            def set_contents(new_contents)
              if ((new_contents).nil?)
                new_contents = EMPTY
              end
              @contents = new_contents
              if (!(@text).nil? && !@text.is_disposed)
                @text.set_text(@contents)
              end
            end
            
            typesig { [] }
            # Return whether the popup has focus.
            def has_focus
              if ((@text).nil? || @text.is_disposed)
                return false
              end
              return @text.get_shell.is_focus_control || @text.is_focus_control
            end
            
            private
            alias_method :initialize__info_popup_dialog, :initialize
          end }
        }
        
        # The listener installed on the target control.
        attr_accessor :target_control_listener
        alias_method :attr_target_control_listener, :target_control_listener
        undef_method :target_control_listener
        alias_method :attr_target_control_listener=, :target_control_listener=
        undef_method :target_control_listener=
        
        # The listener installed in order to close the popup.
        attr_accessor :popup_closer
        alias_method :attr_popup_closer, :popup_closer
        undef_method :popup_closer
        alias_method :attr_popup_closer=, :popup_closer=
        undef_method :popup_closer=
        
        # The table used to show the list of proposals.
        attr_accessor :proposal_table
        alias_method :attr_proposal_table, :proposal_table
        undef_method :proposal_table
        alias_method :attr_proposal_table=, :proposal_table=
        undef_method :proposal_table=
        
        # The proposals to be shown (cached to avoid repeated requests).
        attr_accessor :proposals
        alias_method :attr_proposals, :proposals
        undef_method :proposals
        alias_method :attr_proposals=, :proposals=
        undef_method :proposals=
        
        # Secondary popup used to show detailed information about the selected
        # proposal..
        attr_accessor :info_popup
        alias_method :attr_info_popup, :info_popup
        undef_method :info_popup
        alias_method :attr_info_popup=, :info_popup=
        undef_method :info_popup=
        
        # Flag indicating whether there is a pending secondary popup update.
        attr_accessor :pending_description_update
        alias_method :attr_pending_description_update, :pending_description_update
        undef_method :pending_description_update
        alias_method :attr_pending_description_update=, :pending_description_update=
        undef_method :pending_description_update=
        
        # Filter text - tracked while popup is open, only if we are told to
        # filter
        attr_accessor :filter_text
        alias_method :attr_filter_text, :filter_text
        undef_method :filter_text
        alias_method :attr_filter_text=, :filter_text=
        undef_method :filter_text=
        
        typesig { [String, Array.typed(class_self::IContentProposal)] }
        # Constructs a new instance of this popup, specifying the control for
        # which this popup is showing content, and how the proposals should be
        # obtained and displayed.
        # 
        # @param infoText
        # Text to be shown in a lower info area, or
        # <code>null</code> if there is no info area.
        def initialize(info_text, proposals)
          # IMPORTANT: Use of SWT.ON_TOP is critical here for ensuring
          # that the target control retains focus on Mac and Linux. Without
          # it, the focus will disappear, keystrokes will not go to the
          # popup, and the popup closer will wrongly close the popup.
          # On platforms where SWT.ON_TOP overrides SWT.RESIZE, we will live
          # with this.
          # See https://bugs.eclipse.org/bugs/show_bug.cgi?id=126138
          @target_control_listener = nil
          @popup_closer = nil
          @proposal_table = nil
          @proposals = nil
          @info_popup = nil
          @pending_description_update = false
          @filter_text = nil
          super(self.attr_control.get_shell, SWT::RESIZE | SWT::ON_TOP, false, false, false, false, false, nil, info_text)
          @pending_description_update = false
          @filter_text = EMPTY
          @proposals = proposals
        end
        
        typesig { [] }
        # (non-Javadoc)
        # @see org.eclipse.jface.dialogs.PopupDialog#getForeground()
        def get_foreground
          return JFaceResources.get_color_registry.get(JFacePreferences::CONTENT_ASSIST_FOREGROUND_COLOR)
        end
        
        typesig { [] }
        # (non-Javadoc)
        # @see org.eclipse.jface.dialogs.PopupDialog#getBackground()
        def get_background
          return JFaceResources.get_color_registry.get(JFacePreferences::CONTENT_ASSIST_BACKGROUND_COLOR)
        end
        
        typesig { [class_self::Composite] }
        # Creates the content area for the proposal popup. This creates a table
        # and places it inside the composite. The table will contain a list of
        # all the proposals.
        # 
        # @param parent The parent composite to contain the dialog area; must
        # not be <code>null</code>.
        def create_dialog_area(parent)
          # Use virtual where appropriate (see flag definition).
          if (USE_VIRTUAL)
            @proposal_table = self.class::Table.new(parent, SWT::H_SCROLL | SWT::V_SCROLL | SWT::VIRTUAL)
            listener = Class.new(self.class::Listener.class == Class ? self.class::Listener : Object) do
              extend LocalClass
              include_class_members ContentProposalPopup
              include class_self::Listener if class_self::Listener.class == Module
              
              typesig { [class_self::Event] }
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
            @proposal_table.add_listener(SWT::SetData, listener)
          else
            @proposal_table = self.class::Table.new(parent, SWT::H_SCROLL | SWT::V_SCROLL)
          end
          # set the proposals to force population of the table.
          set_proposals(filter_proposals(@proposals, @filter_text))
          @proposal_table.set_header_visible(false)
          @proposal_table.add_selection_listener(Class.new(self.class::SelectionListener.class == Class ? self.class::SelectionListener : Object) do
            extend LocalClass
            include_class_members ContentProposalPopup
            include class_self::SelectionListener if class_self::SelectionListener.class == Module
            
            typesig { [class_self::SelectionEvent] }
            define_method :widget_selected do |e|
              # If a proposal has been selected, show it in the secondary
              # popup. Otherwise close the popup.
              if ((e.attr_item).nil?)
                if (!(self.attr_info_popup).nil?)
                  self.attr_info_popup.close
                end
              else
                show_proposal_description
              end
            end
            
            typesig { [class_self::SelectionEvent] }
            # Default selection was made. Accept the current proposal.
            define_method :widget_default_selected do |e|
              accept_current_proposal
            end
            
            typesig { [Vararg.new(Object)] }
            define_method :initialize do |*args|
              super(*args)
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
          return @proposal_table
        end
        
        typesig { [] }
        # (non-Javadoc)
        # 
        # @see org.eclipse.jface.dialogs.PopupDialog.adjustBounds()
        def adjust_bounds
          # Get our control's location in display coordinates.
          location = self.attr_control.get_display.map(self.attr_control.get_parent, nil, self.attr_control.get_location)
          initial_x = location.attr_x + POPUP_OFFSET
          initial_y = location.attr_y + self.attr_control.get_size.attr_y + POPUP_OFFSET
          # If we are inserting content, use the cursor position to
          # position the control.
          if ((get_proposal_acceptance_style).equal?(PROPOSAL_INSERT))
            insertion_bounds = self.attr_control_content_adapter.get_insertion_bounds(self.attr_control)
            initial_x = initial_x + insertion_bounds.attr_x
            initial_y = location.attr_y + insertion_bounds.attr_y + insertion_bounds.attr_height
          end
          # If there is no specified size, force it by setting
          # up a layout on the table.
          if ((self.attr_popup_size).nil?)
            data = self.class::GridData.new(GridData::FILL_BOTH)
            data.attr_height_hint = @proposal_table.get_item_height * POPUP_CHAR_HEIGHT
            data.attr_width_hint = Math.max(self.attr_control.get_size.attr_x, POPUP_MINIMUM_WIDTH)
            @proposal_table.set_layout_data(data)
            get_shell.pack
            self.attr_popup_size = get_shell.get_size
          end
          get_shell.set_bounds(initial_x, initial_y, self.attr_popup_size.attr_x, self.attr_popup_size.attr_y)
          get_shell.add_listener(SWT::Resize, # Now set up a listener to monitor any changes in size.
          Class.new(self.class::Listener.class == Class ? self.class::Listener : Object) do
            extend LocalClass
            include_class_members ContentProposalPopup
            include class_self::Listener if class_self::Listener.class == Module
            
            typesig { [class_self::Event] }
            define_method :handle_event do |e|
              self.attr_popup_size = get_shell.get_size
              if (!(self.attr_info_popup).nil?)
                self.attr_info_popup.adjust_bounds
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
        
        typesig { [class_self::Event] }
        # Handle the set data event. Set the item data of the requested item to
        # the corresponding proposal in the proposal cache.
        def handle_set_data(event)
          item = event.attr_item
          index = @proposal_table.index_of(item)
          if (0 <= index && index < @proposals.attr_length)
            current = @proposals[index]
            item.set_text(get_string(current))
            item.set_image(get_image(current))
            item.set_data(current)
          else
            # this should not happen, but does on win32
          end
        end
        
        typesig { [Array.typed(class_self::IContentProposal)] }
        # Caches the specified proposals and repopulates the table if it has
        # been created.
        def set_proposals(new_proposals)
          if ((new_proposals).nil? || (new_proposals.attr_length).equal?(0))
            new_proposals = get_empty_proposal_array
          end
          @proposals = new_proposals
          # If there is a table
          if (is_valid)
            new_size = new_proposals.attr_length
            if (USE_VIRTUAL)
              # Set and clear the virtual table. Data will be
              # provided in the SWT.SetData event handler.
              @proposal_table.set_item_count(new_size)
              @proposal_table.clear_all
            else
              # Populate the table manually
              @proposal_table.set_redraw(false)
              @proposal_table.set_item_count(new_size)
              items = @proposal_table.get_items
              i = 0
              while i < items.attr_length
                item = items[i]
                proposal = new_proposals[i]
                item.set_text(get_string(proposal))
                item.set_image(get_image(proposal))
                item.set_data(proposal)
                i += 1
              end
              @proposal_table.set_redraw(true)
            end
            # Default to the first selection if there is content.
            if (new_proposals.attr_length > 0)
              select_proposal(0)
            else
              # No selection, close the secondary popup if it was open
              if (!(@info_popup).nil?)
                @info_popup.close
              end
            end
          end
        end
        
        typesig { [class_self::IContentProposal] }
        # Get the string for the specified proposal. Always return a String of
        # some kind.
        def get_string(proposal)
          if ((proposal).nil?)
            return EMPTY
          end
          if ((self.attr_label_provider).nil?)
            return (proposal.get_label).nil? ? proposal.get_content : proposal.get_label
          end
          return self.attr_label_provider.get_text(proposal)
        end
        
        typesig { [class_self::IContentProposal] }
        # Get the image for the specified proposal. If there is no image
        # available, return null.
        def get_image(proposal)
          if ((proposal).nil? || (self.attr_label_provider).nil?)
            return nil
          end
          return self.attr_label_provider.get_image(proposal)
        end
        
        typesig { [] }
        # Return an empty array. Used so that something always shows in the
        # proposal popup, even if no proposal provider was specified.
        def get_empty_proposal_array
          return Array.typed(self.class::IContentProposal).new(0) { nil }
        end
        
        typesig { [] }
        # Answer true if the popup is valid, which means the table has been
        # created and not disposed.
        def is_valid
          return !(@proposal_table).nil? && !@proposal_table.is_disposed
        end
        
        typesig { [] }
        # Return whether the receiver has focus. Since 3.4, this includes a
        # check for whether the info popup has focus.
        def has_focus
          if (!is_valid)
            return false
          end
          if (get_shell.is_focus_control || @proposal_table.is_focus_control)
            return true
          end
          if (!(@info_popup).nil? && @info_popup.has_focus)
            return true
          end
          return false
        end
        
        typesig { [] }
        # Return the current selected proposal.
        def get_selected_proposal
          if (is_valid)
            i = @proposal_table.get_selection_index
            if ((@proposals).nil? || i < 0 || i >= @proposals.attr_length)
              return nil
            end
            return @proposals[i]
          end
          return nil
        end
        
        typesig { [::Java::Int] }
        # Select the proposal at the given index.
        def select_proposal(index)
          Assert.is_true(index >= 0, "Proposal index should never be negative") # $NON-NLS-1$
          if (!is_valid || (@proposals).nil? || index >= @proposals.attr_length)
            return
          end
          @proposal_table.set_selection(index)
          @proposal_table.show_selection
          show_proposal_description
        end
        
        typesig { [] }
        # Opens this ContentProposalPopup. This method is extended in order to
        # add the control listener when the popup is opened and to invoke the
        # secondary popup if applicable.
        # 
        # @return the return code
        # 
        # @see org.eclipse.jface.window.Window#open()
        def open
          value = super
          if ((@popup_closer).nil?)
            @popup_closer = self.class::PopupCloserListener.new_local(self)
          end
          @popup_closer.install_listeners
          p = get_selected_proposal
          if (!(p).nil?)
            show_proposal_description
          end
          return value
        end
        
        typesig { [] }
        # Closes this popup. This method is extended to remove the control
        # listener.
        # 
        # @return <code>true</code> if the window is (or was already) closed,
        # and <code>false</code> if it is still open
        def close
          @popup_closer.remove_listeners
          if (!(@info_popup).nil?)
            @info_popup.close
          end
          ret = super
          notify_popup_closed
          return ret
        end
        
        typesig { [] }
        # Show the currently selected proposal's description in a secondary
        # popup.
        def show_proposal_description
          # If we do not already have a pending update, then
          # create a thread now that will show the proposal description
          if (!@pending_description_update)
            runnable = # Create a thread that will sleep for the specified delay
            # before creating the popup. We do not use Jobs since this
            # code must be able to run independently of the Eclipse
            # runtime.
            Class.new(self.class::Runnable.class == Class ? self.class::Runnable : Object) do
              extend LocalClass
              include_class_members ContentProposalPopup
              include class_self::Runnable if class_self::Runnable.class == Module
              
              typesig { [] }
              define_method :run do
                self.attr_pending_description_update = true
                begin
                  JavaThread.sleep(POPUP_DELAY)
                rescue self.class::InterruptedException => e
                end
                if (!is_valid)
                  return
                end
                runnable_class = self.class
                get_shell.get_display.sync_exec(Class.new(self.class::Runnable.class == Class ? self.class::Runnable : Object) do
                  extend LocalClass
                  include_class_members runnable_class
                  include class_self::Runnable if class_self::Runnable.class == Module
                  
                  typesig { [] }
                  define_method :run do
                    # Query the current selection since we have
                    # been delayed
                    p = get_selected_proposal
                    if (!(p).nil?)
                      description = p.get_description
                      if (!(description).nil?)
                        if ((self.attr_info_popup).nil?)
                          self.attr_info_popup = self.class::InfoPopupDialog.new(get_shell)
                          self.attr_info_popup.open
                          runnable_class = self.class
                          self.attr_info_popup.get_shell.add_dispose_listener(Class.new(self.class::DisposeListener.class == Class ? self.class::DisposeListener : Object) do
                            extend LocalClass
                            include_class_members runnable_class
                            include class_self::DisposeListener if class_self::DisposeListener.class == Module
                            
                            typesig { [class_self::DisposeEvent] }
                            define_method :widget_disposed do |event|
                              self.attr_info_popup = nil
                            end
                            
                            typesig { [Vararg.new(Object)] }
                            define_method :initialize do |*args|
                              super(*args)
                            end
                            
                            private
                            alias_method :initialize_anonymous, :initialize
                          end.new_local(self))
                        end
                        self.attr_info_popup.set_contents(p.get_description)
                      else
                        if (!(self.attr_info_popup).nil?)
                          self.attr_info_popup.close
                        end
                      end
                      self.attr_pending_description_update = false
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
              
              typesig { [Vararg.new(Object)] }
              define_method :initialize do |*args|
                super(*args)
              end
              
              private
              alias_method :initialize_anonymous, :initialize
            end.new_local(self)
            t = self.class::JavaThread.new(runnable)
            t.start
          end
        end
        
        typesig { [] }
        # Accept the current proposal.
        def accept_current_proposal
          # Close before accepting the proposal. This is important
          # so that the cursor position can be properly restored at
          # acceptance, which does not work without focus on some controls.
          # See https://bugs.eclipse.org/bugs/show_bug.cgi?id=127108
          proposal = get_selected_proposal
          close
          proposal_accepted(proposal)
        end
        
        typesig { [String] }
        # Request the proposals from the proposal provider, and recompute any
        # caches. Repopulate the popup if it is open.
        def recompute_proposals(filter_text)
          all_proposals = get_proposals
          # If the non-filtered proposal list is empty, we should
          # close the popup.
          # See https://bugs.eclipse.org/bugs/show_bug.cgi?id=147377
          if ((all_proposals.attr_length).equal?(0))
            @proposals = all_proposals
            close
          else
            # Keep the popup open, but filter by any provided filter text
            set_proposals(filter_proposals(all_proposals, filter_text))
          end
        end
        
        typesig { [String] }
        # In an async block, request the proposals. This is used when clients
        # are in the middle of processing an event that affects the widget
        # content. By using an async, we ensure that the widget content is up
        # to date with the event.
        def async_recompute_proposals(filter_text)
          if (is_valid)
            self.attr_control.get_display.async_exec(Class.new(self.class::Runnable.class == Class ? self.class::Runnable : Object) do
              extend LocalClass
              include_class_members ContentProposalPopup
              include class_self::Runnable if class_self::Runnable.class == Module
              
              typesig { [] }
              define_method :run do
                record_cursor_position
                recompute_proposals(filter_text)
              end
              
              typesig { [Vararg.new(Object)] }
              define_method :initialize do |*args|
                super(*args)
              end
              
              private
              alias_method :initialize_anonymous, :initialize
            end.new_local(self))
          else
            recompute_proposals(filter_text)
          end
        end
        
        typesig { [Array.typed(class_self::IContentProposal), String] }
        # Filter the provided list of content proposals according to the filter
        # text.
        def filter_proposals(proposals, filter_string)
          if ((filter_string.length).equal?(0))
            return proposals
          end
          # Check each string for a match. Use the string displayed to the
          # user, not the proposal content.
          list = self.class::ArrayList.new
          i = 0
          while i < proposals.attr_length
            string = get_string(proposals[i])
            if (string.length >= filter_string.length && string.substring(0, filter_string.length).equals_ignore_case(filter_string))
              list.add(proposals[i])
            end
            i += 1
          end
          return list.to_array(Array.typed(self.class::IContentProposal).new(list.size) { nil })
        end
        
        typesig { [] }
        def get_target_control_listener
          if ((@target_control_listener).nil?)
            @target_control_listener = self.class::TargetControlListener.new_local(self)
          end
          return @target_control_listener
        end
        
        private
        alias_method :initialize__content_proposal_popup, :initialize
      end }
      
      # Flag that controls the printing of debug info.
      const_set_lazy(:DEBUG) { false }
      const_attr_reader  :DEBUG
      
      # Indicates that a chosen proposal should be inserted into the field.
      const_set_lazy(:PROPOSAL_INSERT) { 1 }
      const_attr_reader  :PROPOSAL_INSERT
      
      # Indicates that a chosen proposal should replace the entire contents of
      # the field.
      const_set_lazy(:PROPOSAL_REPLACE) { 2 }
      const_attr_reader  :PROPOSAL_REPLACE
      
      # Indicates that the contents of the control should not be modified when a
      # proposal is chosen. This is typically used when a client needs more
      # specialized behavior when a proposal is chosen. In this case, clients
      # typically register an IContentProposalListener so that they are notified
      # when a proposal is chosen.
      const_set_lazy(:PROPOSAL_IGNORE) { 3 }
      const_attr_reader  :PROPOSAL_IGNORE
      
      # Indicates that there should be no filter applied as keys are typed in the
      # popup.
      const_set_lazy(:FILTER_NONE) { 1 }
      const_attr_reader  :FILTER_NONE
      
      # Indicates that a single character filter applies as keys are typed in the
      # popup.
      const_set_lazy(:FILTER_CHARACTER) { 2 }
      const_attr_reader  :FILTER_CHARACTER
      
      # Indicates that a cumulative filter applies as keys are typed in the
      # popup. That is, each character typed will be added to the filter.
      # 
      # @deprecated As of 3.4, filtering that is sensitive to changes in the
      # control content should be performed by the supplied
      # {@link IContentProposalProvider}, such as that performed by
      # {@link SimpleContentProposalProvider}
      const_set_lazy(:FILTER_CUMULATIVE) { 3 }
      const_attr_reader  :FILTER_CUMULATIVE
      
      # Set to <code>true</code> to use a Table with SWT.VIRTUAL. This is a
      # workaround for https://bugs.eclipse.org/bugs/show_bug.cgi?id=98585#c40
      # The corresponding SWT bug is
      # https://bugs.eclipse.org/bugs/show_bug.cgi?id=90321
      const_set_lazy(:USE_VIRTUAL) { !Util.is_motif }
      const_attr_reader  :USE_VIRTUAL
      
      # The delay before showing a secondary popup.
      const_set_lazy(:POPUP_DELAY) { 750 }
      const_attr_reader  :POPUP_DELAY
      
      # The character height hint for the popup. May be overridden by using
      # setInitialPopupSize.
      const_set_lazy(:POPUP_CHAR_HEIGHT) { 10 }
      const_attr_reader  :POPUP_CHAR_HEIGHT
      
      # The minimum pixel width for the popup. May be overridden by using
      # setInitialPopupSize.
      const_set_lazy(:POPUP_MINIMUM_WIDTH) { 300 }
      const_attr_reader  :POPUP_MINIMUM_WIDTH
      
      # The pixel offset of the popup from the bottom corner of the control.
      const_set_lazy(:POPUP_OFFSET) { 3 }
      const_attr_reader  :POPUP_OFFSET
      
      # Empty string.
      const_set_lazy(:EMPTY) { "" }
      const_attr_reader  :EMPTY
    }
    
    # $NON-NLS-1$
    # 
    # The object that provides content proposals.
    attr_accessor :proposal_provider
    alias_method :attr_proposal_provider, :proposal_provider
    undef_method :proposal_provider
    alias_method :attr_proposal_provider=, :proposal_provider=
    undef_method :proposal_provider=
    
    # A label provider used to display proposals in the popup, and to extract
    # Strings from non-String proposals.
    attr_accessor :label_provider
    alias_method :attr_label_provider, :label_provider
    undef_method :label_provider
    alias_method :attr_label_provider=, :label_provider=
    undef_method :label_provider=
    
    # The control for which content proposals are provided.
    attr_accessor :control
    alias_method :attr_control, :control
    undef_method :control
    alias_method :attr_control=, :control=
    undef_method :control=
    
    # The adapter used to extract the String contents from an arbitrary
    # control.
    attr_accessor :control_content_adapter
    alias_method :attr_control_content_adapter, :control_content_adapter
    undef_method :control_content_adapter
    alias_method :attr_control_content_adapter=, :control_content_adapter=
    undef_method :control_content_adapter=
    
    # The popup used to show proposals.
    attr_accessor :popup
    alias_method :attr_popup, :popup
    undef_method :popup
    alias_method :attr_popup=, :popup=
    undef_method :popup=
    
    # The keystroke that signifies content proposals should be shown.
    attr_accessor :trigger_key_stroke
    alias_method :attr_trigger_key_stroke, :trigger_key_stroke
    undef_method :trigger_key_stroke
    alias_method :attr_trigger_key_stroke=, :trigger_key_stroke=
    undef_method :trigger_key_stroke=
    
    # The String containing characters that auto-activate the popup.
    attr_accessor :auto_activate_string
    alias_method :attr_auto_activate_string, :auto_activate_string
    undef_method :auto_activate_string
    alias_method :attr_auto_activate_string=, :auto_activate_string=
    undef_method :auto_activate_string=
    
    # Integer that indicates how an accepted proposal should affect the
    # control. One of PROPOSAL_IGNORE, PROPOSAL_INSERT, or PROPOSAL_REPLACE.
    # Default value is PROPOSAL_INSERT.
    attr_accessor :proposal_acceptance_style
    alias_method :attr_proposal_acceptance_style, :proposal_acceptance_style
    undef_method :proposal_acceptance_style
    alias_method :attr_proposal_acceptance_style=, :proposal_acceptance_style=
    undef_method :proposal_acceptance_style=
    
    # A boolean that indicates whether key events received while the proposal
    # popup is open should also be propagated to the control. Default value is
    # true.
    attr_accessor :propagate_keys
    alias_method :attr_propagate_keys, :propagate_keys
    undef_method :propagate_keys
    alias_method :attr_propagate_keys=, :propagate_keys=
    undef_method :propagate_keys=
    
    # Integer that indicates the filtering style. One of FILTER_CHARACTER,
    # FILTER_CUMULATIVE, FILTER_NONE.
    attr_accessor :filter_style
    alias_method :attr_filter_style, :filter_style
    undef_method :filter_style
    alias_method :attr_filter_style=, :filter_style=
    undef_method :filter_style=
    
    # The listener we install on the control.
    attr_accessor :control_listener
    alias_method :attr_control_listener, :control_listener
    undef_method :control_listener
    alias_method :attr_control_listener=, :control_listener=
    undef_method :control_listener=
    
    # The list of IContentProposalListener listeners.
    attr_accessor :proposal_listeners
    alias_method :attr_proposal_listeners, :proposal_listeners
    undef_method :proposal_listeners
    alias_method :attr_proposal_listeners=, :proposal_listeners=
    undef_method :proposal_listeners=
    
    # The list of IContentProposalListener2 listeners.
    attr_accessor :proposal_listeners2
    alias_method :attr_proposal_listeners2, :proposal_listeners2
    undef_method :proposal_listeners2
    alias_method :attr_proposal_listeners2=, :proposal_listeners2=
    undef_method :proposal_listeners2=
    
    # Flag that indicates whether the adapter is enabled. In some cases,
    # adapters may be installed but depend upon outside state.
    attr_accessor :is_enabled
    alias_method :attr_is_enabled, :is_enabled
    undef_method :is_enabled
    alias_method :attr_is_enabled=, :is_enabled=
    undef_method :is_enabled=
    
    # The delay in milliseconds used when autoactivating the popup.
    attr_accessor :auto_activation_delay
    alias_method :attr_auto_activation_delay, :auto_activation_delay
    undef_method :auto_activation_delay
    alias_method :attr_auto_activation_delay=, :auto_activation_delay=
    undef_method :auto_activation_delay=
    
    # A boolean indicating whether a keystroke has been received. Used to see
    # if an autoactivation delay was interrupted by a keystroke.
    attr_accessor :received_key_down
    alias_method :attr_received_key_down, :received_key_down
    undef_method :received_key_down
    alias_method :attr_received_key_down=, :received_key_down=
    undef_method :received_key_down=
    
    # The desired size in pixels of the proposal popup.
    attr_accessor :popup_size
    alias_method :attr_popup_size, :popup_size
    undef_method :popup_size
    alias_method :attr_popup_size=, :popup_size=
    undef_method :popup_size=
    
    # The remembered position of the insertion position. Not all controls will
    # restore the insertion position if the proposal popup gets focus, so we
    # need to remember it.
    attr_accessor :insertion_pos
    alias_method :attr_insertion_pos, :insertion_pos
    undef_method :insertion_pos
    alias_method :attr_insertion_pos=, :insertion_pos=
    undef_method :insertion_pos=
    
    # The remembered selection range. Not all controls will restore the
    # selection position if the proposal popup gets focus, so we need to
    # remember it.
    attr_accessor :selection_range
    alias_method :attr_selection_range, :selection_range
    undef_method :selection_range
    alias_method :attr_selection_range=, :selection_range=
    undef_method :selection_range=
    
    # A flag that indicates that we are watching modify events
    attr_accessor :watch_modify
    alias_method :attr_watch_modify, :watch_modify
    undef_method :watch_modify
    alias_method :attr_watch_modify=, :watch_modify=
    undef_method :watch_modify=
    
    typesig { [Control, IControlContentAdapter, IContentProposalProvider, KeyStroke, Array.typed(::Java::Char)] }
    # Construct a content proposal adapter that can assist the user with
    # choosing content for the field.
    # 
    # @param control
    # the control for which the adapter is providing content assist.
    # May not be <code>null</code>.
    # @param controlContentAdapter
    # the <code>IControlContentAdapter</code> used to obtain and
    # update the control's contents as proposals are accepted. May
    # not be <code>null</code>.
    # @param proposalProvider
    # the <code>IContentProposalProvider</code> used to obtain
    # content proposals for this control, or <code>null</code> if
    # no content proposal is available.
    # @param keyStroke
    # the keystroke that will invoke the content proposal popup. If
    # this value is <code>null</code>, then proposals will be
    # activated automatically when any of the auto activation
    # characters are typed.
    # @param autoActivationCharacters
    # An array of characters that trigger auto-activation of content
    # proposal. If specified, these characters will trigger
    # auto-activation of the proposal popup, regardless of whether
    # an explicit invocation keyStroke was specified. If this
    # parameter is <code>null</code>, then only a specified
    # keyStroke will invoke content proposal. If this parameter is
    # <code>null</code> and the keyStroke parameter is
    # <code>null</code>, then all alphanumeric characters will
    # auto-activate content proposal.
    def initialize(control, control_content_adapter, proposal_provider, key_stroke, auto_activation_characters)
      @proposal_provider = nil
      @label_provider = nil
      @control = nil
      @control_content_adapter = nil
      @popup = nil
      @trigger_key_stroke = nil
      @auto_activate_string = nil
      @proposal_acceptance_style = PROPOSAL_INSERT
      @propagate_keys = true
      @filter_style = FILTER_NONE
      @control_listener = nil
      @proposal_listeners = ListenerList.new
      @proposal_listeners2 = ListenerList.new
      @is_enabled = true
      @auto_activation_delay = 0
      @received_key_down = false
      @popup_size = nil
      @insertion_pos = -1
      @selection_range = Point.new(-1, -1)
      @watch_modify = false
      # We always assume the control and content adapter are valid.
      Assert.is_not_null(control)
      Assert.is_not_null(control_content_adapter)
      @control = control
      @control_content_adapter = control_content_adapter
      # The rest of these may be null
      @proposal_provider = proposal_provider
      @trigger_key_stroke = key_stroke
      if (!(auto_activation_characters).nil?)
        @auto_activate_string = String.new(auto_activation_characters)
      end
      add_control_listener(control)
    end
    
    typesig { [] }
    # Get the control on which the content proposal adapter is installed.
    # 
    # @return the control on which the proposal adapter is installed.
    def get_control
      return @control
    end
    
    typesig { [] }
    # Get the label provider that is used to show proposals.
    # 
    # @return the {@link ILabelProvider} used to show proposals, or
    # <code>null</code> if one has not been installed.
    def get_label_provider
      return @label_provider
    end
    
    typesig { [] }
    # Return a boolean indicating whether the receiver is enabled.
    # 
    # @return <code>true</code> if the adapter is enabled, and
    # <code>false</code> if it is not.
    def is_enabled
      return @is_enabled
    end
    
    typesig { [ILabelProvider] }
    # Set the label provider that is used to show proposals. The lifecycle of
    # the specified label provider is not managed by this adapter. Clients must
    # dispose the label provider when it is no longer needed.
    # 
    # @param labelProvider
    # the (@link ILabelProvider} used to show proposals.
    def set_label_provider(label_provider)
      @label_provider = label_provider
    end
    
    typesig { [] }
    # Return the proposal provider that provides content proposals given the
    # current content of the field. A value of <code>null</code> indicates
    # that there are no content proposals available for the field.
    # 
    # @return the {@link IContentProposalProvider} used to show proposals. May
    # be <code>null</code>.
    def get_content_proposal_provider
      return @proposal_provider
    end
    
    typesig { [IContentProposalProvider] }
    # Set the content proposal provider that is used to show proposals.
    # 
    # @param proposalProvider
    # the {@link IContentProposalProvider} used to show proposals
    def set_content_proposal_provider(proposal_provider)
      @proposal_provider = proposal_provider
    end
    
    typesig { [] }
    # Return the array of characters on which the popup is autoactivated.
    # 
    # @return An array of characters that trigger auto-activation of content
    # proposal. If specified, these characters will trigger
    # auto-activation of the proposal popup, regardless of whether an
    # explicit invocation keyStroke was specified. If this parameter is
    # <code>null</code>, then only a specified keyStroke will invoke
    # content proposal. If this value is <code>null</code> and the
    # keyStroke value is <code>null</code>, then all alphanumeric
    # characters will auto-activate content proposal.
    def get_auto_activation_characters
      if ((@auto_activate_string).nil?)
        return nil
      end
      return @auto_activate_string.to_char_array
    end
    
    typesig { [Array.typed(::Java::Char)] }
    # Set the array of characters that will trigger autoactivation of the
    # popup.
    # 
    # @param autoActivationCharacters
    # An array of characters that trigger auto-activation of content
    # proposal. If specified, these characters will trigger
    # auto-activation of the proposal popup, regardless of whether
    # an explicit invocation keyStroke was specified. If this
    # parameter is <code>null</code>, then only a specified
    # keyStroke will invoke content proposal. If this parameter is
    # <code>null</code> and the keyStroke value is
    # <code>null</code>, then all alphanumeric characters will
    # auto-activate content proposal.
    def set_auto_activation_characters(auto_activation_characters)
      if ((auto_activation_characters).nil?)
        @auto_activate_string = nil
      else
        @auto_activate_string = String.new(auto_activation_characters)
      end
    end
    
    typesig { [] }
    # Set the delay, in milliseconds, used before any autoactivation is
    # triggered.
    # 
    # @return the time in milliseconds that will pass before a popup is
    # automatically opened
    def get_auto_activation_delay
      return @auto_activation_delay
    end
    
    typesig { [::Java::Int] }
    # Set the delay, in milliseconds, used before autoactivation is triggered.
    # 
    # @param delay
    # the time in milliseconds that will pass before a popup is
    # automatically opened
    def set_auto_activation_delay(delay)
      @auto_activation_delay = delay
    end
    
    typesig { [] }
    # Get the integer style that indicates how an accepted proposal affects the
    # control's content.
    # 
    # @return a constant indicating how an accepted proposal should affect the
    # control's content. Should be one of <code>PROPOSAL_INSERT</code>,
    # <code>PROPOSAL_REPLACE</code>, or <code>PROPOSAL_IGNORE</code>.
    # (Default is <code>PROPOSAL_INSERT</code>).
    def get_proposal_acceptance_style
      return @proposal_acceptance_style
    end
    
    typesig { [::Java::Int] }
    # Set the integer style that indicates how an accepted proposal affects the
    # control's content.
    # 
    # @param acceptance
    # a constant indicating how an accepted proposal should affect
    # the control's content. Should be one of
    # <code>PROPOSAL_INSERT</code>, <code>PROPOSAL_REPLACE</code>,
    # or <code>PROPOSAL_IGNORE</code>
    def set_proposal_acceptance_style(acceptance)
      @proposal_acceptance_style = acceptance
    end
    
    typesig { [] }
    # Return the integer style that indicates how keystrokes affect the content
    # of the proposal popup while it is open.
    # 
    # @return a constant indicating how keystrokes in the proposal popup affect
    # filtering of the proposals shown. <code>FILTER_NONE</code>
    # specifies that no filtering will occur in the content proposal
    # list as keys are typed. <code>FILTER_CHARACTER</code> specifies
    # the content of the popup will be filtered by the most recently
    # typed character. <code>FILTER_CUMULATIVE</code> is deprecated
    # and no longer recommended. It specifies that the content of the
    # popup will be filtered by a string containing all the characters
    # typed since the popup has been open. The default is
    # <code>FILTER_NONE</code>.
    def get_filter_style
      return @filter_style
    end
    
    typesig { [::Java::Int] }
    # Set the integer style that indicates how keystrokes affect the content of
    # the proposal popup while it is open. Popup-based filtering is useful for
    # narrowing and navigating the list of proposals provided once the popup is
    # open. Filtering of the proposals will occur even when the control content
    # is not affected by user typing. Note that automatic filtering is not used
    # to achieve content-sensitive filtering such as auto-completion. Filtering
    # that is sensitive to changes in the control content should be performed
    # by the supplied {@link IContentProposalProvider}.
    # 
    # @param filterStyle
    # a constant indicating how keystrokes received in the proposal
    # popup affect filtering of the proposals shown.
    # <code>FILTER_NONE</code> specifies that no automatic
    # filtering of the content proposal list will occur as keys are
    # typed in the popup. <code>FILTER_CHARACTER</code> specifies
    # that the content of the popup will be filtered by the most
    # recently typed character. <code>FILTER_CUMULATIVE</code> is
    # deprecated and no longer recommended. It specifies that the
    # content of the popup will be filtered by a string containing
    # all the characters typed since the popup has been open.
    def set_filter_style(filter_style)
      @filter_style = filter_style
    end
    
    typesig { [] }
    # Return the size, in pixels, of the content proposal popup.
    # 
    # @return a Point specifying the last width and height, in pixels, of the
    # content proposal popup.
    def get_popup_size
      return @popup_size
    end
    
    typesig { [Point] }
    # Set the size, in pixels, of the content proposal popup. This size will be
    # used the next time the content proposal popup is opened.
    # 
    # @param size
    # a Point specifying the desired width and height, in pixels, of
    # the content proposal popup.
    def set_popup_size(size)
      @popup_size = size
    end
    
    typesig { [] }
    # Get the boolean that indicates whether key events (including
    # auto-activation characters) received by the content proposal popup should
    # also be propagated to the adapted control when the proposal popup is
    # open.
    # 
    # @return a boolean that indicates whether key events (including
    # auto-activation characters) should be propagated to the adapted
    # control when the proposal popup is open. Default value is
    # <code>true</code>.
    def get_propagate_keys
      return @propagate_keys
    end
    
    typesig { [::Java::Boolean] }
    # Set the boolean that indicates whether key events (including
    # auto-activation characters) received by the content proposal popup should
    # also be propagated to the adapted control when the proposal popup is
    # open.
    # 
    # @param propagateKeys
    # a boolean that indicates whether key events (including
    # auto-activation characters) should be propagated to the
    # adapted control when the proposal popup is open.
    def set_propagate_keys(propagate_keys)
      @propagate_keys = propagate_keys
    end
    
    typesig { [] }
    # Return the content adapter that can get or retrieve the text contents
    # from the adapter's control. This method is used when a client, such as a
    # content proposal listener, needs to update the control's contents
    # manually.
    # 
    # @return the {@link IControlContentAdapter} which can update the control
    # text.
    def get_control_content_adapter
      return @control_content_adapter
    end
    
    typesig { [::Java::Boolean] }
    # Set the boolean flag that determines whether the adapter is enabled.
    # 
    # @param enabled
    # <code>true</code> if the adapter is enabled and responding
    # to user input, <code>false</code> if it is ignoring user
    # input.
    def set_enabled(enabled)
      # If we are disabling it while it's proposing content, close the
      # content proposal popup.
      if (@is_enabled && !enabled)
        if (!(@popup).nil?)
          @popup.close
        end
      end
      @is_enabled = enabled
    end
    
    typesig { [IContentProposalListener] }
    # Add the specified listener to the list of content proposal listeners that
    # are notified when content proposals are chosen.
    # </p>
    # 
    # @param listener
    # the IContentProposalListener to be added as a listener. Must
    # not be <code>null</code>. If an attempt is made to register
    # an instance which is already registered with this instance,
    # this method has no effect.
    # 
    # @see org.eclipse.jface.fieldassist.IContentProposalListener
    def add_content_proposal_listener(listener)
      @proposal_listeners.add(listener)
    end
    
    typesig { [IContentProposalListener] }
    # Removes the specified listener from the list of content proposal
    # listeners that are notified when content proposals are chosen.
    # </p>
    # 
    # @param listener
    # the IContentProposalListener to be removed as a listener. Must
    # not be <code>null</code>. If the listener has not already
    # been registered, this method has no effect.
    # 
    # @since 3.3
    # @see org.eclipse.jface.fieldassist.IContentProposalListener
    def remove_content_proposal_listener(listener)
      @proposal_listeners.remove(listener)
    end
    
    typesig { [IContentProposalListener2] }
    # Add the specified listener to the list of content proposal listeners that
    # are notified when a content proposal popup is opened or closed.
    # </p>
    # 
    # @param listener
    # the IContentProposalListener2 to be added as a listener. Must
    # not be <code>null</code>. If an attempt is made to register
    # an instance which is already registered with this instance,
    # this method has no effect.
    # 
    # @since 3.3
    # @see org.eclipse.jface.fieldassist.IContentProposalListener2
    def add_content_proposal_listener(listener)
      @proposal_listeners2.add(listener)
    end
    
    typesig { [IContentProposalListener2] }
    # Remove the specified listener from the list of content proposal listeners
    # that are notified when a content proposal popup is opened or closed.
    # </p>
    # 
    # @param listener
    # the IContentProposalListener2 to be removed as a listener.
    # Must not be <code>null</code>. If the listener has not
    # already been registered, this method has no effect.
    # 
    # @since 3.3
    # @see org.eclipse.jface.fieldassist.IContentProposalListener2
    def remove_content_proposal_listener(listener)
      @proposal_listeners2.remove(listener)
    end
    
    typesig { [Control] }
    # Add our listener to the control. Debug information to be left in until
    # this support is stable on all platforms.
    def add_control_listener(control)
      if (DEBUG)
        System.out.println("ContentProposalListener#installControlListener()") # $NON-NLS-1$
      end
      if (!(@control_listener).nil?)
        return
      end
      @control_listener = Class.new(Listener.class == Class ? Listener : Object) do
        extend LocalClass
        include_class_members ContentProposalAdapter
        include Listener if Listener.class == Module
        
        typesig { [Event] }
        define_method :handle_event do |e|
          if (!self.attr_is_enabled)
            return
          end
          case (e.attr_type)
          # There are times when we want to monitor content changes
          # rather than individual keystrokes to determine whether
          # the popup should be closed or opened based on the entire
          # content of the control.
          # The watchModify flag ensures that we don't autoactivate if
          # the content change was caused by something other than typing.
          # See https://bugs.eclipse.org/bugs/show_bug.cgi?id=183650
          when SWT::Traverse, SWT::KeyDown
            if (DEBUG)
              sb = nil
              if ((e.attr_type).equal?(SWT::Traverse))
                sb = self.class::StringBuffer.new("Traverse") # $NON-NLS-1$
              else
                sb = self.class::StringBuffer.new("KeyDown") # $NON-NLS-1$
              end
              sb.append(" received by adapter") # $NON-NLS-1$
              dump(sb.to_s, e)
            end
            # If the popup is open, it gets first shot at the
            # keystroke and should set the doit flags appropriately.
            if (!(self.attr_popup).nil?)
              self.attr_popup.get_target_control_listener.handle_event(e)
              if (DEBUG)
                sb = nil
                if ((e.attr_type).equal?(SWT::Traverse))
                  sb = self.class::StringBuffer.new("Traverse") # $NON-NLS-1$
                else
                  sb = self.class::StringBuffer.new("KeyDown") # $NON-NLS-1$
                end
                sb.append(" after being handled by popup") # $NON-NLS-1$
                dump(sb.to_s, e)
              end
              # See https://bugs.eclipse.org/bugs/show_bug.cgi?id=192633
              # If the popup is open and this is a valid character, we
              # want to watch for the modified text.
              if (self.attr_propagate_keys && !(e.attr_character).equal?(0))
                self.attr_watch_modify = true
              end
              return
            end
            # We were only listening to traverse events for the popup
            if ((e.attr_type).equal?(SWT::Traverse))
              return
            end
            # The popup is not open. We are looking at keydown events
            # for a trigger to open the popup.
            if (!(self.attr_trigger_key_stroke).nil?)
              # Either there are no modifiers for the trigger and we
              # check the character field...
              # ...or there are modifiers, in which case the
              # keycode and state must match
              if (((self.attr_trigger_key_stroke.get_modifier_keys).equal?(KeyStroke::NO_KEY) && (self.attr_trigger_key_stroke.get_natural_key).equal?(e.attr_character)) || ((self.attr_trigger_key_stroke.get_natural_key).equal?(e.attr_key_code) && (((self.attr_trigger_key_stroke.get_modifier_keys & e.attr_state_mask)).equal?(self.attr_trigger_key_stroke.get_modifier_keys))))
                # We never propagate the keystroke for an explicit
                # keystroke invocation of the popup
                e.attr_doit = false
                open_proposal_popup(false)
                return
              end
            end
            # The triggering keystroke was not invoked. If a character
            # was typed, compare it to the autoactivation characters.
            if (!(e.attr_character).equal?(0))
              if (!(self.attr_auto_activate_string).nil?)
                if (self.attr_auto_activate_string.index_of(e.attr_character) >= 0)
                  auto_activate
                else
                  # No autoactivation occurred, so record the key
                  # down as a means to interrupt any
                  # autoactivation that is pending due to
                  # autoactivation delay.
                  self.attr_received_key_down = true
                  # watch the modify so we can close the popup in
                  # cases where there is no longer a trigger
                  # character in the content
                  self.attr_watch_modify = true
                end
              else
                # The autoactivate string is null. If the trigger
                # is also null, we want to act on any modification
                # to the content. Set a flag so we'll catch this
                # in the modify event.
                if ((self.attr_trigger_key_stroke).nil?)
                  self.attr_watch_modify = true
                end
              end
            else
              # A non-character key has been pressed. Interrupt any
              # autoactivation that is pending due to autoactivation delay.
              self.attr_received_key_down = true
            end
          when SWT::Modify
            if (allows_auto_activate && self.attr_watch_modify)
              if (DEBUG)
                dump("Modify event triggers popup open or close", e) # $NON-NLS-1$
              end
              self.attr_watch_modify = false
              # We are in autoactivation mode, either for specific
              # characters or for all characters. In either case,
              # we should close the proposal popup when there is no
              # content in the control.
              if (is_control_content_empty)
                # see https://bugs.eclipse.org/bugs/show_bug.cgi?id=192633
                close_proposal_popup
              else
                # See https://bugs.eclipse.org/bugs/show_bug.cgi?id=147377
                # Given that we will close the popup when there are
                # no valid proposals, we must consider reopening it on any
                # content change when there are no particular autoActivation
                # characters
                if ((self.attr_auto_activate_string).nil?)
                  auto_activate
                else
                  # Autoactivation characters are defined, but this
                  # modify event does not involve one of them.  See
                  # if any of the autoactivation characters are left
                  # in the content and close the popup if none remain.
                  if (!should_popup_remain_open)
                    close_proposal_popup
                  end
                end
              end
            end
          else
          end
        end
        
        typesig { [String, Event] }
        # Dump the given events to "standard" output.
        # 
        # @param who
        # who is dumping the event
        # @param e
        # the event
        define_method :dump do |who, e|
          sb = self.class::StringBuffer.new("--- [ContentProposalAdapter]\n") # $NON-NLS-1$
          sb.append(who)
          sb.append(" - e: keyCode=" + RJava.cast_to_string(e.attr_key_code) + RJava.cast_to_string(hex(e.attr_key_code))) # $NON-NLS-1$
          sb.append("; character=" + RJava.cast_to_string(e.attr_character) + RJava.cast_to_string(hex(e.attr_character))) # $NON-NLS-1$
          sb.append("; stateMask=" + RJava.cast_to_string(e.attr_state_mask) + RJava.cast_to_string(hex(e.attr_state_mask))) # $NON-NLS-1$
          sb.append("; doit=" + RJava.cast_to_string(e.attr_doit)) # $NON-NLS-1$
          sb.append("; detail=" + RJava.cast_to_string(e.attr_detail) + RJava.cast_to_string(hex(e.attr_detail))) # $NON-NLS-1$
          sb.append("; widget=" + RJava.cast_to_string(e.attr_widget)) # $NON-NLS-1$
          System.out.println(sb)
        end
        
        typesig { [::Java::Int] }
        define_method :hex do |i|
          return "[0x" + RJava.cast_to_string(JavaInteger.to_hex_string(i)) + RJava.cast_to_string(Character.new(?].ord)) # $NON-NLS-1$
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
      control.add_listener(SWT::KeyDown, @control_listener)
      control.add_listener(SWT::Traverse, @control_listener)
      control.add_listener(SWT::Modify, @control_listener)
      if (DEBUG)
        System.out.println("ContentProposalAdapter#installControlListener() - installed") # $NON-NLS-1$
      end
    end
    
    typesig { [::Java::Boolean] }
    # Open the proposal popup and display the proposals provided by the
    # proposal provider. If there are no proposals to be shown, do not show the
    # popup. This method returns immediately. That is, it does not wait for the
    # popup to open or a proposal to be selected.
    # 
    # @param autoActivated
    # a boolean indicating whether the popup was autoactivated. If
    # false, a beep will sound when no proposals can be shown.
    def open_proposal_popup(auto_activated)
      if (is_valid)
        if ((@popup).nil?)
          # Check whether there are any proposals to be shown.
          record_cursor_position # must be done before getting proposals
          proposals = get_proposals
          if (proposals.attr_length > 0)
            if (DEBUG)
              System.out.println("POPUP OPENED BY PRECEDING EVENT") # $NON-NLS-1$
            end
            record_cursor_position
            @popup = ContentProposalPopup.new_local(self, nil, proposals)
            @popup.open
            @popup.get_shell.add_dispose_listener(Class.new(DisposeListener.class == Class ? DisposeListener : Object) do
              extend LocalClass
              include_class_members ContentProposalAdapter
              include DisposeListener if DisposeListener.class == Module
              
              typesig { [DisposeEvent] }
              define_method :widget_disposed do |event|
                self.attr_popup = nil
              end
              
              typesig { [Vararg.new(Object)] }
              define_method :initialize do |*args|
                super(*args)
              end
              
              private
              alias_method :initialize_anonymous, :initialize
            end.new_local(self))
            internal_popup_opened
            notify_popup_opened
          else
            if (!auto_activated)
              get_control.get_display.beep
            end
          end
        end
      end
    end
    
    typesig { [] }
    # Open the proposal popup and display the proposals provided by the
    # proposal provider. This method returns immediately. That is, it does not
    # wait for a proposal to be selected. This method is used by subclasses to
    # explicitly invoke the opening of the popup. If there are no proposals to
    # show, the popup will not open and a beep will be sounded.
    def open_proposal_popup
      open_proposal_popup(false)
    end
    
    typesig { [] }
    # Close the proposal popup without accepting a proposal. This method
    # returns immediately, and has no effect if the proposal popup was not
    # open. This method is used by subclasses to explicitly close the popup
    # based on additional logic.
    # 
    # @since 3.3
    def close_proposal_popup
      if (!(@popup).nil?)
        @popup.close
      end
    end
    
    typesig { [IContentProposal] }
    # A content proposal has been accepted. Update the control contents
    # accordingly and notify any listeners.
    # 
    # @param proposal the accepted proposal
    def proposal_accepted(proposal)
      case (@proposal_acceptance_style)
      when (PROPOSAL_REPLACE)
        set_control_content(proposal.get_content, proposal.get_cursor_position)
      when (PROPOSAL_INSERT)
        insert_control_content(proposal.get_content, proposal.get_cursor_position)
      else
        # do nothing. Typically a listener is installed to handle this in
        # a custom way.
      end
      # In all cases, notify listeners of an accepted proposal.
      notify_proposal_accepted(proposal)
    end
    
    typesig { [String, ::Java::Int] }
    # Set the text content of the control to the specified text, setting the
    # cursorPosition at the desired location within the new contents.
    def set_control_content(text, cursor_position)
      if (is_valid)
        # should already be false, but just in case.
        @watch_modify = false
        @control_content_adapter.set_control_contents(@control, text, cursor_position)
      end
    end
    
    typesig { [String, ::Java::Int] }
    # Insert the specified text into the control content, setting the
    # cursorPosition at the desired location within the new contents.
    def insert_control_content(text, cursor_position)
      if (is_valid)
        # should already be false, but just in case.
        @watch_modify = false
        # Not all controls preserve their selection index when they lose
        # focus, so we must set it explicitly here to what it was before
        # the popup opened.
        # See https://bugs.eclipse.org/bugs/show_bug.cgi?id=127108
        # See https://bugs.eclipse.org/bugs/show_bug.cgi?id=139063
        if (@control_content_adapter.is_a?(IControlContentAdapter2) && !(@selection_range.attr_x).equal?(-1))
          (@control_content_adapter).set_selection(@control, @selection_range)
        else
          if (!(@insertion_pos).equal?(-1))
            @control_content_adapter.set_cursor_position(@control, @insertion_pos)
          end
        end
        @control_content_adapter.insert_control_contents(@control, text, cursor_position)
      end
    end
    
    typesig { [] }
    # Check that the control and content adapter are valid.
    def is_valid
      return !(@control).nil? && !@control.is_disposed && !(@control_content_adapter).nil?
    end
    
    typesig { [] }
    # Record the control's cursor position.
    def record_cursor_position
      if (is_valid)
        adapter = get_control_content_adapter
        @insertion_pos = adapter.get_cursor_position(@control)
        # see https://bugs.eclipse.org/bugs/show_bug.cgi?id=139063
        if (adapter.is_a?(IControlContentAdapter2))
          @selection_range = (adapter).get_selection(@control)
        end
      end
    end
    
    typesig { [] }
    # Get the proposals from the proposal provider. Gets all of the proposals
    # without doing any filtering.
    def get_proposals
      if ((@proposal_provider).nil? || !is_valid)
        return nil
      end
      if (DEBUG)
        System.out.println(">>> obtaining proposals from provider") # $NON-NLS-1$
      end
      position = @insertion_pos
      if ((position).equal?(-1))
        position = get_control_content_adapter.get_cursor_position(get_control)
      end
      contents = get_control_content_adapter.get_control_contents(get_control)
      proposals = @proposal_provider.get_proposals(contents, position)
      return proposals
    end
    
    typesig { [] }
    # Autoactivation has been triggered. Open the popup using any specified
    # delay.
    def auto_activate
      if (@auto_activation_delay > 0)
        runnable = Class.new(Runnable.class == Class ? Runnable : Object) do
          extend LocalClass
          include_class_members ContentProposalAdapter
          include Runnable if Runnable.class == Module
          
          typesig { [] }
          define_method :run do
            self.attr_received_key_down = false
            begin
              JavaThread.sleep(self.attr_auto_activation_delay)
            rescue self.class::InterruptedException => e
            end
            if (!is_valid || self.attr_received_key_down)
              return
            end
            runnable_class = self.class
            get_control.get_display.sync_exec(Class.new(self.class::Runnable.class == Class ? self.class::Runnable : Object) do
              extend LocalClass
              include_class_members runnable_class
              include class_self::Runnable if class_self::Runnable.class == Module
              
              typesig { [] }
              define_method :run do
                open_proposal_popup(true)
              end
              
              typesig { [Vararg.new(Object)] }
              define_method :initialize do |*args|
                super(*args)
              end
              
              private
              alias_method :initialize_anonymous, :initialize
            end.new_local(self))
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self)
        t = JavaThread.new(runnable)
        t.start
      else
        get_control.get_display.async_exec(# Since we do not sleep, we must open the popup
        # in an async exec. This is necessary because
        # this method may be called in the middle of handling
        # some event that will cause the cursor position or
        # other important info to change as a result of this
        # event occurring.
        Class.new(Runnable.class == Class ? Runnable : Object) do
          extend LocalClass
          include_class_members ContentProposalAdapter
          include Runnable if Runnable.class == Module
          
          typesig { [] }
          define_method :run do
            if (is_valid)
              open_proposal_popup(true)
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
    end
    
    typesig { [IContentProposal] }
    # A proposal has been accepted. Notify interested listeners.
    def notify_proposal_accepted(proposal)
      if (DEBUG)
        System.out.println("Notify listeners - proposal accepted.") # $NON-NLS-1$
      end
      listener_array = @proposal_listeners.get_listeners
      i = 0
      while i < listener_array.attr_length
        (listener_array[i]).proposal_accepted(proposal)
        i += 1
      end
    end
    
    typesig { [] }
    # The proposal popup has opened. Notify interested listeners.
    def notify_popup_opened
      if (DEBUG)
        System.out.println("Notify listeners - popup opened.") # $NON-NLS-1$
      end
      listener_array = @proposal_listeners2.get_listeners
      i = 0
      while i < listener_array.attr_length
        (listener_array[i]).proposal_popup_opened(self)
        i += 1
      end
    end
    
    typesig { [] }
    # The proposal popup has closed. Notify interested listeners.
    def notify_popup_closed
      if (DEBUG)
        System.out.println("Notify listeners - popup closed.") # $NON-NLS-1$
      end
      listener_array = @proposal_listeners2.get_listeners
      i = 0
      while i < listener_array.attr_length
        (listener_array[i]).proposal_popup_closed(self)
        i += 1
      end
    end
    
    typesig { [] }
    # Returns whether the content proposal popup has the focus. This includes
    # both the primary popup and any secondary info popup that may have focus.
    # 
    # @return <code>true</code> if the proposal popup or its secondary info
    # popup has the focus
    # @since 3.4
    def has_proposal_popup_focus
      return !(@popup).nil? && @popup.has_focus
    end
    
    typesig { [] }
    # Return whether the control content is empty
    def is_control_content_empty
      return (get_control_content_adapter.get_control_contents(get_control).length).equal?(0)
    end
    
    typesig { [] }
    # The popup has just opened, but listeners have not yet
    # been notified.  Perform any cleanup that is needed.
    def internal_popup_opened
      # see https://bugs.eclipse.org/bugs/show_bug.cgi?id=243612
      if (@control.is_a?(Combo))
        (@control).set_list_visible(false)
      end
    end
    
    typesig { [] }
    # Return whether a proposal popup should remain open.
    # If it was autoactivated by specific characters, and
    # none of those characters remain, then it should not remain
    # open.  This method should not be used to determine
    # whether autoactivation has occurred or should occur, only whether
    # the circumstances would dictate that a popup remain open.
    def should_popup_remain_open
      # If we always autoactivate or never autoactivate, it should remain open
      if ((@auto_activate_string).nil? || (@auto_activate_string.length).equal?(0))
        return true
      end
      content = get_control_content_adapter.get_control_contents(get_control)
      i = 0
      while i < @auto_activate_string.length
        if (content.index_of(@auto_activate_string.char_at(i)) >= 0)
          return true
        end
        i += 1
      end
      return false
    end
    
    typesig { [] }
    # Return whether this adapter is configured for autoactivation, by
    # specific characters or by any characters.
    def allows_auto_activate
      # there are specific autoactivation chars supplied
      return (!(@auto_activate_string).nil? && @auto_activate_string.length > 0) || ((@auto_activate_string).nil? && (@trigger_key_stroke).nil?) # we autoactivate on everything
    end
    
    private
    alias_method :initialize__content_proposal_adapter, :initialize
  end
  
end
