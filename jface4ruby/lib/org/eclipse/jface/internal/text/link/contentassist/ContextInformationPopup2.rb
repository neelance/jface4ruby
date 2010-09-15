require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Internal::Text::Link::Contentassist
  module ContextInformationPopup2Imports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Internal::Text::Link::Contentassist
      include_const ::Java::Util, :Stack
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Custom, :BusyIndicator
      include_const ::Org::Eclipse::Swt::Custom, :StyledText
      include_const ::Org::Eclipse::Swt::Events, :KeyEvent
      include_const ::Org::Eclipse::Swt::Events, :SelectionEvent
      include_const ::Org::Eclipse::Swt::Events, :SelectionListener
      include_const ::Org::Eclipse::Swt::Events, :VerifyEvent
      include_const ::Org::Eclipse::Swt::Graphics, :Color
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Layout, :GridData
      include_const ::Org::Eclipse::Swt::Layout, :GridLayout
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Display
      include_const ::Org::Eclipse::Swt::Widgets, :Shell
      include_const ::Org::Eclipse::Swt::Widgets, :Table
      include_const ::Org::Eclipse::Swt::Widgets, :TableItem
      include_const ::Org::Eclipse::Jface::Text, :ITextViewer
      include_const ::Org::Eclipse::Jface::Text, :TextPresentation
      include_const ::Org::Eclipse::Jface::Text::Contentassist, :IContextInformation
      include_const ::Org::Eclipse::Jface::Text::Contentassist, :IContextInformationExtension
      include_const ::Org::Eclipse::Jface::Text::Contentassist, :IContextInformationPresenter
      include_const ::Org::Eclipse::Jface::Text::Contentassist, :IContextInformationValidator
    }
  end
  
  # This class is used to present context information to the user.
  # If multiple contexts are valid at the current cursor location,
  # a list is presented from which the user may choose one context.
  # Once the user makes their choice, or if there was only a single
  # possible context, the context information is shown in a tooltip like popup. <p>
  # If the tooltip is visible and the user wants to see context information of
  # a context embedded into the one for which context information is displayed,
  # context information for the embedded context is shown. As soon as the
  # cursor leaves the embedded context area, the context information for
  # the embedding context is shown again.
  # 
  # @see IContextInformation
  # @see IContextInformationValidator
  class ContextInformationPopup2 
    include_class_members ContextInformationPopup2Imports
    include IContentAssistListener2
    
    class_module.module_eval {
      # Represents the state necessary for embedding contexts.
      # @since 2.0
      const_set_lazy(:ContextFrame) { Class.new do
        include_class_members ContextInformationPopup2
        
        attr_accessor :f_begin_offset
        alias_method :attr_f_begin_offset, :f_begin_offset
        undef_method :f_begin_offset
        alias_method :attr_f_begin_offset=, :f_begin_offset=
        undef_method :f_begin_offset=
        
        attr_accessor :f_offset
        alias_method :attr_f_offset, :f_offset
        undef_method :f_offset
        alias_method :attr_f_offset=, :f_offset=
        undef_method :f_offset=
        
        attr_accessor :f_visible_offset
        alias_method :attr_f_visible_offset, :f_visible_offset
        undef_method :f_visible_offset
        alias_method :attr_f_visible_offset=, :f_visible_offset=
        undef_method :f_visible_offset=
        
        attr_accessor :f_information
        alias_method :attr_f_information, :f_information
        undef_method :f_information
        alias_method :attr_f_information=, :f_information=
        undef_method :f_information=
        
        attr_accessor :f_validator
        alias_method :attr_f_validator, :f_validator
        undef_method :f_validator
        alias_method :attr_f_validator=, :f_validator=
        undef_method :f_validator=
        
        attr_accessor :f_presenter
        alias_method :attr_f_presenter, :f_presenter
        undef_method :f_presenter
        alias_method :attr_f_presenter=, :f_presenter=
        undef_method :f_presenter=
        
        typesig { [] }
        def initialize
          @f_begin_offset = 0
          @f_offset = 0
          @f_visible_offset = 0
          @f_information = nil
          @f_validator = nil
          @f_presenter = nil
        end
        
        private
        alias_method :initialize__context_frame, :initialize
      end }
    }
    
    attr_accessor :f_viewer
    alias_method :attr_f_viewer, :f_viewer
    undef_method :f_viewer
    alias_method :attr_f_viewer=, :f_viewer=
    undef_method :f_viewer=
    
    attr_accessor :f_content_assistant
    alias_method :attr_f_content_assistant, :f_content_assistant
    undef_method :f_content_assistant
    alias_method :attr_f_content_assistant=, :f_content_assistant=
    undef_method :f_content_assistant=
    
    attr_accessor :f_popup_closer
    alias_method :attr_f_popup_closer, :f_popup_closer
    undef_method :f_popup_closer
    alias_method :attr_f_popup_closer=, :f_popup_closer=
    undef_method :f_popup_closer=
    
    attr_accessor :f_context_selector_shell
    alias_method :attr_f_context_selector_shell, :f_context_selector_shell
    undef_method :f_context_selector_shell
    alias_method :attr_f_context_selector_shell=, :f_context_selector_shell=
    undef_method :f_context_selector_shell=
    
    attr_accessor :f_context_selector_table
    alias_method :attr_f_context_selector_table, :f_context_selector_table
    undef_method :f_context_selector_table
    alias_method :attr_f_context_selector_table=, :f_context_selector_table=
    undef_method :f_context_selector_table=
    
    attr_accessor :f_context_selector_input
    alias_method :attr_f_context_selector_input, :f_context_selector_input
    undef_method :f_context_selector_input
    alias_method :attr_f_context_selector_input=, :f_context_selector_input=
    undef_method :f_context_selector_input=
    
    attr_accessor :f_line_delimiter
    alias_method :attr_f_line_delimiter, :f_line_delimiter
    undef_method :f_line_delimiter
    alias_method :attr_f_line_delimiter=, :f_line_delimiter=
    undef_method :f_line_delimiter=
    
    attr_accessor :f_context_info_popup
    alias_method :attr_f_context_info_popup, :f_context_info_popup
    undef_method :f_context_info_popup
    alias_method :attr_f_context_info_popup=, :f_context_info_popup=
    undef_method :f_context_info_popup=
    
    attr_accessor :f_context_info_text
    alias_method :attr_f_context_info_text, :f_context_info_text
    undef_method :f_context_info_text
    alias_method :attr_f_context_info_text=, :f_context_info_text=
    undef_method :f_context_info_text=
    
    attr_accessor :f_text_presentation
    alias_method :attr_f_text_presentation, :f_text_presentation
    undef_method :f_text_presentation
    alias_method :attr_f_text_presentation=, :f_text_presentation=
    undef_method :f_text_presentation=
    
    attr_accessor :f_context_frame_stack
    alias_method :attr_f_context_frame_stack, :f_context_frame_stack
    undef_method :f_context_frame_stack
    alias_method :attr_f_context_frame_stack=, :f_context_frame_stack=
    undef_method :f_context_frame_stack=
    
    typesig { [ContentAssistant2, ITextViewer] }
    # Creates a new context information popup.
    # 
    # @param contentAssistant the content assist for computing the context information
    # @param viewer the viewer on top of which the context information is shown
    def initialize(content_assistant, viewer)
      @f_viewer = nil
      @f_content_assistant = nil
      @f_popup_closer = PopupCloser2.new
      @f_context_selector_shell = nil
      @f_context_selector_table = nil
      @f_context_selector_input = nil
      @f_line_delimiter = nil
      @f_context_info_popup = nil
      @f_context_info_text = nil
      @f_text_presentation = nil
      @f_context_frame_stack = Stack.new
      @f_content_assistant = content_assistant
      @f_viewer = viewer
    end
    
    typesig { [::Java::Boolean] }
    # Shows all possible contexts for the given cursor position of the viewer.
    # 
    # @param autoActivated <code>true</code>  if auto activated
    # @return  a potential error message or <code>null</code> in case of no error
    def show_context_proposals(auto_activated)
      styled_text = @f_viewer.get_text_widget
      BusyIndicator.show_while(styled_text.get_display, Class.new(Runnable.class == Class ? Runnable : Object) do
        local_class_in ContextInformationPopup2
        include_class_members ContextInformationPopup2
        include Runnable if Runnable.class == Module
        
        typesig { [] }
        define_method :run do
          position = self.attr_f_viewer.get_selected_range.attr_x
          contexts = compute_context_information(position)
          count = ((contexts).nil? ? 0 : contexts.attr_length)
          if ((count).equal?(1))
            # Show context information directly
            internal_show_context_info(contexts[0], position)
          else
            if (count > 0)
              # Precise context must be selected
              if ((self.attr_f_line_delimiter).nil?)
                self.attr_f_line_delimiter = styled_text.get_line_delimiter
              end
              create_context_selector
              set_contexts(contexts)
              display_context_selector
              hide_context_info_popup
            else
              if (!auto_activated)
                styled_text.get_display.beep
              end
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
      return get_error_message
    end
    
    typesig { [IContextInformation, ::Java::Int] }
    # Displays the given context information for the given offset.
    # 
    # @param info the context information
    # @param position the offset
    # @since 2.0
    def show_context_information(info, position)
      control = @f_viewer.get_text_widget
      BusyIndicator.show_while(control.get_display, Class.new(Runnable.class == Class ? Runnable : Object) do
        local_class_in ContextInformationPopup2
        include_class_members ContextInformationPopup2
        include Runnable if Runnable.class == Module
        
        typesig { [] }
        define_method :run do
          internal_show_context_info(info, position)
          hide_context_selector
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
    end
    
    typesig { [IContextInformation, ::Java::Int] }
    # Displays the given context information for the given offset.
    # 
    # @param information the context information
    # @param offset the offset
    # @since 2.0
    def internal_show_context_info(information, offset)
      validator = @f_content_assistant.get_context_information_validator(@f_viewer, offset)
      if (!(validator).nil?)
        current = ContextFrame.new
        current.attr_f_information = information
        current.attr_f_begin_offset = (information.is_a?(IContextInformationExtension)) ? (information).get_context_information_position : offset
        if ((current.attr_f_begin_offset).equal?(-1))
          current.attr_f_begin_offset = offset
        end
        current.attr_f_offset = offset
        current.attr_f_visible_offset = @f_viewer.get_text_widget.get_selection_range.attr_x - (offset - current.attr_f_begin_offset)
        current.attr_f_validator = validator
        current.attr_f_presenter = @f_content_assistant.get_context_information_presenter(@f_viewer, offset)
        @f_context_frame_stack.push(current)
        internal_show_context_frame(current, (@f_context_frame_stack.size).equal?(1))
      end
    end
    
    typesig { [ContextFrame, ::Java::Boolean] }
    # Shows the given context frame.
    # 
    # @param frame the frane to display
    # @param initial <code>true</code> if this is the first frame to be displayed
    # @since 2.0
    def internal_show_context_frame(frame, initial)
      frame.attr_f_validator.install(frame.attr_f_information, @f_viewer, frame.attr_f_offset)
      if (!(frame.attr_f_presenter).nil?)
        if ((@f_text_presentation).nil?)
          @f_text_presentation = TextPresentation.new
        end
        frame.attr_f_presenter.install(frame.attr_f_information, @f_viewer, frame.attr_f_begin_offset)
        frame.attr_f_presenter.update_presentation(frame.attr_f_offset, @f_text_presentation)
      end
      create_context_info_popup
      @f_context_info_text.set_text(frame.attr_f_information.get_information_display_string)
      if (!(@f_text_presentation).nil?)
        TextPresentation.apply_text_presentation(@f_text_presentation, @f_context_info_text)
      end
      resize
      if (initial)
        if (@f_content_assistant.add_content_assist_listener(self, ContentAssistant2::CONTEXT_INFO_POPUP))
          @f_content_assistant.add_to_layout(self, @f_context_info_popup, ContentAssistant2::LayoutManager::LAYOUT_CONTEXT_INFO_POPUP, frame.attr_f_visible_offset)
          @f_context_info_popup.set_visible(true)
        end
      else
        @f_content_assistant.layout(ContentAssistant2::LayoutManager::LAYOUT_CONTEXT_INFO_POPUP, frame.attr_f_visible_offset)
      end
    end
    
    typesig { [::Java::Int] }
    # Computes all possible context information for the given offset.
    # 
    # @param position the offset
    # @return all possible context information for the given offset
    # @since 2.0
    def compute_context_information(position)
      return @f_content_assistant.compute_context_information(@f_viewer, position)
    end
    
    typesig { [] }
    # Returns the error message generated while computing context information.
    # 
    # @return the error message
    def get_error_message
      return @f_content_assistant.get_error_message
    end
    
    typesig { [] }
    # Creates the context information popup. This is the tooltip like overlay window.
    def create_context_info_popup
      if (Helper2.ok_to_use(@f_context_info_popup))
        return
      end
      control = @f_viewer.get_text_widget
      display = control.get_display
      @f_context_info_popup = Shell.new(control.get_shell, SWT::NO_TRIM | SWT::ON_TOP)
      @f_context_info_popup.set_background(display.get_system_color(SWT::COLOR_BLACK))
      @f_context_info_text = StyledText.new(@f_context_info_popup, SWT::MULTI | SWT::READ_ONLY)
      c = @f_content_assistant.get_context_information_popup_background
      if ((c).nil?)
        c = display.get_system_color(SWT::COLOR_INFO_BACKGROUND)
      end
      @f_context_info_text.set_background(c)
      c = @f_content_assistant.get_context_information_popup_foreground
      if ((c).nil?)
        c = display.get_system_color(SWT::COLOR_INFO_FOREGROUND)
      end
      @f_context_info_text.set_foreground(c)
    end
    
    typesig { [] }
    # Resizes the context information popup.
    # @since 2.0
    def resize
      size_ = @f_context_info_text.compute_size(SWT::DEFAULT, SWT::DEFAULT, true)
      size_.attr_x += 3
      @f_context_info_text.set_size(size_)
      @f_context_info_text.set_location(1, 1)
      size_.attr_x += 2
      size_.attr_y += 2
      @f_context_info_popup.set_size(size_)
    end
    
    typesig { [] }
    # Hides the context information popup.
    def hide_context_info_popup
      if (Helper2.ok_to_use(@f_context_info_popup))
        size_ = @f_context_frame_stack.size
        if (size_ > 0)
          @f_context_frame_stack.pop
          (size_ -= 1)
        end
        if (size_ > 0)
          current = @f_context_frame_stack.peek
          internal_show_context_frame(current, false)
        else
          @f_content_assistant.remove_content_assist_listener(self, ContentAssistant2::CONTEXT_INFO_POPUP)
          @f_context_info_popup.set_visible(false)
          @f_context_info_popup.dispose
          @f_context_info_popup = nil
          if (!(@f_text_presentation).nil?)
            @f_text_presentation.clear
            @f_text_presentation = nil
          end
        end
      end
      if ((@f_context_info_popup).nil?)
        @f_content_assistant.context_information_closed
      end
    end
    
    typesig { [] }
    # Creates the context selector in case the user has the choice between multiple valid contexts
    # at a given offset.
    def create_context_selector
      if (Helper2.ok_to_use(@f_context_selector_shell))
        return
      end
      control = @f_viewer.get_text_widget
      @f_context_selector_shell = Shell.new(control.get_shell, SWT::NO_TRIM | SWT::ON_TOP)
      layout_ = GridLayout.new
      layout_.attr_margin_width = 0
      layout_.attr_margin_height = 0
      @f_context_selector_shell.set_layout(layout_)
      @f_context_selector_shell.set_background(control.get_display.get_system_color(SWT::COLOR_BLACK))
      @f_context_selector_table = Table.new(@f_context_selector_shell, SWT::H_SCROLL | SWT::V_SCROLL)
      @f_context_selector_table.set_location(1, 1)
      gd = GridData.new(GridData::FILL_BOTH)
      gd.attr_height_hint = @f_context_selector_table.get_item_height * 10
      gd.attr_width_hint = 300
      @f_context_selector_table.set_layout_data(gd)
      @f_context_selector_shell.pack(true)
      c = @f_content_assistant.get_context_selector_background
      if ((c).nil?)
        c = control.get_display.get_system_color(SWT::COLOR_INFO_BACKGROUND)
      end
      @f_context_selector_table.set_background(c)
      c = @f_content_assistant.get_context_selector_foreground
      if ((c).nil?)
        c = control.get_display.get_system_color(SWT::COLOR_INFO_FOREGROUND)
      end
      @f_context_selector_table.set_foreground(c)
      @f_context_selector_table.add_selection_listener(Class.new(SelectionListener.class == Class ? SelectionListener : Object) do
        local_class_in ContextInformationPopup2
        include_class_members ContextInformationPopup2
        include SelectionListener if SelectionListener.class == Module
        
        typesig { [SelectionEvent] }
        define_method :widget_selected do |e|
        end
        
        typesig { [SelectionEvent] }
        define_method :widget_default_selected do |e|
          insert_selected_context
          hide_context_selector
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      @f_popup_closer.install(@f_content_assistant, @f_context_selector_table)
      @f_context_selector_table.set_header_visible(false)
      @f_content_assistant.add_to_layout(self, @f_context_selector_shell, ContentAssistant2::LayoutManager::LAYOUT_CONTEXT_SELECTOR, @f_content_assistant.get_selection_offset)
    end
    
    typesig { [] }
    # Causes the context information of the context selected in the context selector
    # to be displayed in the context information popup.
    def insert_selected_context
      i = @f_context_selector_table.get_selection_index
      if (i < 0 || i >= @f_context_selector_input.attr_length)
        return
      end
      position = @f_viewer.get_selected_range.attr_x
      internal_show_context_info(@f_context_selector_input[i], position)
    end
    
    typesig { [Array.typed(IContextInformation)] }
    # Sets the contexts in the context selector to the given set.
    # 
    # @param contexts the possible contexts
    def set_contexts(contexts)
      if (Helper2.ok_to_use(@f_context_selector_table))
        @f_context_selector_input = contexts
        @f_context_selector_table.set_redraw(false)
        @f_context_selector_table.remove_all
        item = nil
        t = nil
        i = 0
        while i < contexts.attr_length
          t = contexts[i]
          item = TableItem.new(@f_context_selector_table, SWT::NULL)
          if (!(t.get_image).nil?)
            item.set_image(t.get_image)
          end
          item.set_text(t.get_context_display_string)
          i += 1
        end
        @f_context_selector_table.select(0)
        @f_context_selector_table.set_redraw(true)
      end
    end
    
    typesig { [] }
    # Displays the context selector.
    def display_context_selector
      if (@f_content_assistant.add_content_assist_listener(self, ContentAssistant2::CONTEXT_SELECTOR))
        @f_context_selector_shell.set_visible(true)
      end
    end
    
    typesig { [] }
    # Hodes the context selector.
    def hide_context_selector
      if (Helper2.ok_to_use(@f_context_selector_shell))
        @f_content_assistant.remove_content_assist_listener(self, ContentAssistant2::CONTEXT_SELECTOR)
        @f_popup_closer.uninstall
        @f_context_selector_shell.set_visible(false)
        @f_context_selector_shell.dispose
        @f_context_selector_shell = nil
      end
      if (!Helper2.ok_to_use(@f_context_info_popup))
        @f_content_assistant.context_information_closed
      end
    end
    
    typesig { [] }
    # Returns whether the context selector has the focus.
    # 
    # @return <code>true</code> if teh context selector has the focus
    def has_focus
      if (Helper2.ok_to_use(@f_context_selector_shell))
        return (@f_context_selector_shell.is_focus_control || @f_context_selector_table.is_focus_control)
      end
      return false
    end
    
    typesig { [] }
    # Hides context selector and context information popup.
    def hide
      hide_context_selector
      hide_context_info_popup
    end
    
    typesig { [] }
    # Returns whether this context information popup is active. I.e., either
    # a context selector or context information is displayed.
    # 
    # @return <code>true</code> if the context selector is active
    def is_active
      return (Helper2.ok_to_use(@f_context_info_popup) || Helper2.ok_to_use(@f_context_selector_shell))
    end
    
    typesig { [VerifyEvent] }
    # @see IContentAssistListener#verifyKey(VerifyEvent)
    def verify_key(e)
      if (Helper2.ok_to_use(@f_context_selector_shell))
        return context_selector_key_pressed(e)
      end
      if (Helper2.ok_to_use(@f_context_info_popup))
        return context_info_popup_key_pressed(e)
      end
      return true
    end
    
    typesig { [VerifyEvent] }
    # Processes a key stroke in the context selector.
    # 
    # @param e the verify event describing the key stroke
    # @return <code>true</code> if processing can be stopped
    def context_selector_key_pressed(e)
      key = e.attr_character
      if ((key).equal?(0))
        change = 0
        visible_rows = (@f_context_selector_table.get_size.attr_y / @f_context_selector_table.get_item_height) - 1
        selection = @f_context_selector_table.get_selection_index
        case (e.attr_key_code)
        when SWT::ARROW_UP
          change = (@f_context_selector_table.get_selection_index > 0 ? -1 : 0)
        when SWT::ARROW_DOWN
          change = (@f_context_selector_table.get_selection_index < @f_context_selector_table.get_item_count - 1 ? 1 : 0)
        when SWT::PAGE_DOWN
          change = visible_rows
          if (selection + change >= @f_context_selector_table.get_item_count)
            change = @f_context_selector_table.get_item_count - selection
          end
        when SWT::PAGE_UP
          change = -visible_rows
          if (selection + change < 0)
            change = -selection
          end
        when SWT::HOME
          change = -selection
        when SWT::END_
          change = @f_context_selector_table.get_item_count - selection
        else
          if (!(e.attr_key_code).equal?(SWT::MOD1) && !(e.attr_key_code).equal?(SWT::MOD2) && !(e.attr_key_code).equal?(SWT::MOD3) && !(e.attr_key_code).equal?(SWT::MOD4))
            hide_context_selector
          end
          return true
        end
        @f_context_selector_table.set_selection(selection + change)
        @f_context_selector_table.show_selection
        e.attr_doit = false
        return false
      else
        if ((Character.new(?\t.ord)).equal?(key))
          # switch focus to selector shell
          e.attr_doit = false
          @f_context_selector_shell.set_focus
          return false
        else
          if ((key).equal?(SWT::ESC))
            e.attr_doit = false
            hide_context_selector
          end
        end
      end
      return true
    end
    
    typesig { [KeyEvent] }
    # Processes a key stroke while the info popup is up.
    # 
    # @param e the verify event describing the key stroke
    # @return <code>true</code> if processing can be stopped
    def context_info_popup_key_pressed(e)
      key = e.attr_character
      if ((key).equal?(0))
        case (e.attr_key_code)
        when SWT::ARROW_LEFT, SWT::ARROW_RIGHT, SWT::ARROW_UP, SWT::ARROW_DOWN
          validate_context_information
        else
          if (!(e.attr_key_code).equal?(SWT::MOD1) && !(e.attr_key_code).equal?(SWT::MOD2) && !(e.attr_key_code).equal?(SWT::MOD3) && !(e.attr_key_code).equal?(SWT::MOD4))
            hide_context_info_popup
          end
        end
      else
        if ((key).equal?(SWT::ESC))
          e.attr_doit = false
          hide_context_info_popup
        else
          validate_context_information
        end
      end
      return true
    end
    
    typesig { [VerifyEvent] }
    # @see IEventConsumer#processEvent(VerifyEvent)
    def process_event(event)
      if (Helper2.ok_to_use(@f_context_selector_shell))
        context_selector_process_event(event)
      end
      if (Helper2.ok_to_use(@f_context_info_popup))
        context_info_popup_process_event(event)
      end
    end
    
    typesig { [VerifyEvent] }
    # Processes a key stroke in the context selector.
    # 
    # @param e the verify event describing the key stroke
    def context_selector_process_event(e)
      if ((e.attr_start).equal?(e.attr_end) && !(e.attr_text).nil? && (e.attr_text == @f_line_delimiter))
        e.attr_doit = false
        insert_selected_context
      end
      hide_context_selector
    end
    
    typesig { [VerifyEvent] }
    # Processes a key stroke while the info popup is up.
    # 
    # @param e the verify event describing the key stroke
    def context_info_popup_process_event(e)
      if (!(e.attr_start).equal?(e.attr_end) && ((e.attr_text).nil? || (e.attr_text.length).equal?(0)))
        validate_context_information
      end
    end
    
    typesig { [] }
    # Validates the context information for the viewer's actual cursor position.
    def validate_context_information
      @f_context_info_popup.get_display.async_exec(# Post the code in the event queue in order to ensure that the
      # action described by this verify key event has already beed executed.
      # Otherwise, we'd validate the context information based on the
      # pre-key-stroke state.
      Class.new(Runnable.class == Class ? Runnable : Object) do
        local_class_in ContextInformationPopup2
        include_class_members ContextInformationPopup2
        include Runnable if Runnable.class == Module
        
        attr_accessor :f_frame
        alias_method :attr_f_frame, :f_frame
        undef_method :f_frame
        alias_method :attr_f_frame=, :f_frame=
        undef_method :f_frame=
        
        typesig { [] }
        define_method :run do
          if (Helper2.ok_to_use(self.attr_f_context_info_popup) && (@f_frame).equal?(self.attr_f_context_frame_stack.peek))
            offset = self.attr_f_viewer.get_selected_range.attr_x
            if ((@f_frame.attr_f_validator).nil? || !@f_frame.attr_f_validator.is_context_information_valid(offset))
              hide_context_info_popup
            else
              if (!(@f_frame.attr_f_presenter).nil? && @f_frame.attr_f_presenter.update_presentation(offset, self.attr_f_text_presentation))
                TextPresentation.apply_text_presentation(self.attr_f_text_presentation, self.attr_f_context_info_text)
                resize
              end
            end
          end
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          @f_frame = nil
          super(*args)
          @f_frame = self.attr_f_context_frame_stack.peek
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
    end
    
    private
    alias_method :initialize__context_information_popup2, :initialize
  end
  
end
