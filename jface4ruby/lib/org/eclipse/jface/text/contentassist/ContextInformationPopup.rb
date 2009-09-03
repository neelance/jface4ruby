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
  module ContextInformationPopupImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Contentassist
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :Stack
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Custom, :BusyIndicator
      include_const ::Org::Eclipse::Swt::Custom, :StyledText
      include_const ::Org::Eclipse::Swt::Events, :KeyEvent
      include_const ::Org::Eclipse::Swt::Events, :SelectionAdapter
      include_const ::Org::Eclipse::Swt::Events, :SelectionEvent
      include_const ::Org::Eclipse::Swt::Events, :SelectionListener
      include_const ::Org::Eclipse::Swt::Events, :VerifyEvent
      include_const ::Org::Eclipse::Swt::Graphics, :Color
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Graphics, :Rectangle
      include_const ::Org::Eclipse::Swt::Layout, :GridData
      include_const ::Org::Eclipse::Swt::Layout, :GridLayout
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Display
      include_const ::Org::Eclipse::Swt::Widgets, :Shell
      include_const ::Org::Eclipse::Swt::Widgets, :Table
      include_const ::Org::Eclipse::Swt::Widgets, :TableItem
      include_const ::Org::Eclipse::Jface::Contentassist, :IContentAssistSubjectControl
      include_const ::Org::Eclipse::Jface::Text, :ITextViewer
      include_const ::Org::Eclipse::Jface::Text, :TextPresentation
    }
  end
  
  # This class is used to present context information to the user.
  # If multiple contexts are valid at the current cursor location,
  # a list is presented from which the user may choose one context.
  # Once the user makes their choice, or if there was only a single
  # possible context, the context information is shown in a tool tip like popup. <p>
  # If the tool tip is visible and the user wants to see context information of
  # a context embedded into the one for which context information is displayed,
  # context information for the embedded context is shown. As soon as the
  # cursor leaves the embedded context area, the context information for
  # the embedding context is shown again.
  # 
  # @see IContextInformation
  # @see IContextInformationValidator
  class ContextInformationPopup 
    include_class_members ContextInformationPopupImports
    include IContentAssistListener
    
    class_module.module_eval {
      # Represents the state necessary for embedding contexts.
      # 
      # @since 2.0
      const_set_lazy(:ContextFrame) { Class.new do
        include_class_members ContextInformationPopup
        
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
        
        typesig { [class_self::IContextInformation, ::Java::Int, ::Java::Int, ::Java::Int, class_self::IContextInformationValidator, class_self::IContextInformationPresenter] }
        # @since 3.1
        def initialize(information, begin_offset, offset, visible_offset, validator, presenter)
          @f_begin_offset = 0
          @f_offset = 0
          @f_visible_offset = 0
          @f_information = nil
          @f_validator = nil
          @f_presenter = nil
          @f_information = information
          @f_begin_offset = begin_offset
          @f_offset = offset
          @f_visible_offset = visible_offset
          @f_validator = validator
          @f_presenter = presenter
        end
        
        typesig { [Object] }
        # @see java.lang.Object#equals(java.lang.Object)
        # @since 3.0
        def ==(obj)
          if (obj.is_a?(self.class::ContextFrame))
            frame = obj
            return (@f_information == frame.attr_f_information) && (@f_begin_offset).equal?(frame.attr_f_begin_offset)
          end
          return super(obj)
        end
        
        typesig { [] }
        # @see java.lang.Object#hashCode()
        # @since 3.1
        def hash_code
          return (@f_information.hash_code << 16) | @f_begin_offset
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
    
    # The content assist subject control.
    # 
    # @since 3.0
    attr_accessor :f_content_assist_subject_control
    alias_method :attr_f_content_assist_subject_control, :f_content_assist_subject_control
    undef_method :f_content_assist_subject_control
    alias_method :attr_f_content_assist_subject_control=, :f_content_assist_subject_control=
    undef_method :f_content_assist_subject_control=
    
    # The content assist subject control adapter.
    # 
    # @since 3.0
    attr_accessor :f_content_assist_subject_control_adapter
    alias_method :attr_f_content_assist_subject_control_adapter, :f_content_assist_subject_control_adapter
    undef_method :f_content_assist_subject_control_adapter
    alias_method :attr_f_content_assist_subject_control_adapter=, :f_content_assist_subject_control_adapter=
    undef_method :f_content_assist_subject_control_adapter=
    
    # Selection listener on the text widget which is active
    # while a context information pop up is shown.
    # 
    # @since 3.0
    attr_accessor :f_text_widget_selection_listener
    alias_method :attr_f_text_widget_selection_listener, :f_text_widget_selection_listener
    undef_method :f_text_widget_selection_listener
    alias_method :attr_f_text_widget_selection_listener=, :f_text_widget_selection_listener=
    undef_method :f_text_widget_selection_listener=
    
    # The last removed context frame is remembered in order to not re-query the
    # user about which context should be used.
    # 
    # @since 3.0
    attr_accessor :f_last_context
    alias_method :attr_f_last_context, :f_last_context
    undef_method :f_last_context
    alias_method :attr_f_last_context=, :f_last_context=
    undef_method :f_last_context=
    
    typesig { [ContentAssistant, ITextViewer] }
    # Creates a new context information popup.
    # 
    # @param contentAssistant the content assist for computing the context information
    # @param viewer the viewer on top of which the context information is shown
    def initialize(content_assistant, viewer)
      @f_viewer = nil
      @f_content_assistant = nil
      @f_popup_closer = PopupCloser.new
      @f_context_selector_shell = nil
      @f_context_selector_table = nil
      @f_context_selector_input = nil
      @f_line_delimiter = nil
      @f_context_info_popup = nil
      @f_context_info_text = nil
      @f_text_presentation = nil
      @f_context_frame_stack = Stack.new
      @f_content_assist_subject_control = nil
      @f_content_assist_subject_control_adapter = nil
      @f_text_widget_selection_listener = nil
      @f_last_context = nil
      @f_content_assistant = content_assistant
      @f_viewer = viewer
      @f_content_assist_subject_control_adapter = ContentAssistSubjectControlAdapter.new(@f_viewer)
    end
    
    typesig { [ContentAssistant, IContentAssistSubjectControl] }
    # Creates a new context information popup.
    # 
    # @param contentAssistant the content assist for computing the context information
    # @param contentAssistSubjectControl the content assist subject control on top of which the context information is shown
    # @since 3.0
    def initialize(content_assistant, content_assist_subject_control)
      @f_viewer = nil
      @f_content_assistant = nil
      @f_popup_closer = PopupCloser.new
      @f_context_selector_shell = nil
      @f_context_selector_table = nil
      @f_context_selector_input = nil
      @f_line_delimiter = nil
      @f_context_info_popup = nil
      @f_context_info_text = nil
      @f_text_presentation = nil
      @f_context_frame_stack = Stack.new
      @f_content_assist_subject_control = nil
      @f_content_assist_subject_control_adapter = nil
      @f_text_widget_selection_listener = nil
      @f_last_context = nil
      @f_content_assistant = content_assistant
      @f_content_assist_subject_control = content_assist_subject_control
      @f_content_assist_subject_control_adapter = ContentAssistSubjectControlAdapter.new(@f_content_assist_subject_control)
    end
    
    typesig { [::Java::Boolean] }
    # Shows all possible contexts for the given cursor position of the viewer.
    # 
    # @param autoActivated <code>true</code>  if auto activated
    # @return  a potential error message or <code>null</code> in case of no error
    def show_context_proposals(auto_activated)
      control = @f_content_assist_subject_control_adapter.get_control
      BusyIndicator.show_while(control.get_display, Class.new(Runnable.class == Class ? Runnable : Object) do
        extend LocalClass
        include_class_members ContextInformationPopup
        include Runnable if Runnable.class == Module
        
        typesig { [] }
        define_method :run do
          offset = self.attr_f_content_assist_subject_control_adapter.get_selected_range.attr_x
          contexts = compute_context_information(offset)
          count = ((contexts).nil? ? 0 : contexts.attr_length)
          if ((count).equal?(1))
            frame = create_context_frame(contexts[0], offset)
            if (is_duplicate(frame))
              validate_context_information
            else
              # Show context information directly
              internal_show_context_info(frame)
            end
          else
            if (count > 0)
              # if any of the proposed context matches any of the contexts on the stack,
              # assume that one (so, if context info is invoked repeatedly, the current
              # info is kept)
              i = 0
              while i < contexts.attr_length
                info = contexts[i]
                frame = create_context_frame(info, offset)
                # check top of stack and stored context
                if (is_duplicate(frame))
                  validate_context_information
                  return
                end
                if (is_last_frame(frame))
                  internal_show_context_info(frame)
                  return
                end
                # also check all other contexts
                it = self.attr_f_context_frame_stack.iterator
                while it.has_next
                  stack_frame = it.next_
                  if ((stack_frame == frame))
                    validate_context_information
                    return
                  end
                end
                i += 1
              end
              # otherwise:
              # Precise context must be selected
              if ((self.attr_f_line_delimiter).nil?)
                self.attr_f_line_delimiter = self.attr_f_content_assist_subject_control_adapter.get_line_delimiter
              end
              create_context_selector
              set_contexts(contexts)
              display_context_selector
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
    # @param offset the offset
    # @since 2.0
    def show_context_information(info, offset)
      control = @f_content_assist_subject_control_adapter.get_control
      BusyIndicator.show_while(control.get_display, Class.new(Runnable.class == Class ? Runnable : Object) do
        extend LocalClass
        include_class_members ContextInformationPopup
        include Runnable if Runnable.class == Module
        
        typesig { [] }
        define_method :run do
          if ((info).nil?)
            validate_context_information
          else
            frame = create_context_frame(info, offset)
            if (is_duplicate(frame))
              validate_context_information
            else
              internal_show_context_info(frame)
            end
            hide_context_selector
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
    
    typesig { [ContextFrame] }
    # Displays the given context information for the given offset.
    # 
    # @param frame the context frame to display, or <code>null</code>
    # @since 3.0
    def internal_show_context_info(frame)
      if (!(frame).nil?)
        @f_context_frame_stack.push(frame)
        if ((@f_context_frame_stack.size).equal?(1))
          @f_last_context = nil
        end
        internal_show_context_frame(frame, (@f_context_frame_stack.size).equal?(1))
        validate_context_information
      end
    end
    
    typesig { [IContextInformation, ::Java::Int] }
    # Creates a context frame for the given offset.
    # 
    # @param information the context information
    # @param offset the offset
    # @return the created context frame
    # @since 3.0
    def create_context_frame(information, offset)
      validator = @f_content_assist_subject_control_adapter.get_context_information_validator(@f_content_assistant, offset)
      if (!(validator).nil?)
        begin_offset = (information.is_a?(IContextInformationExtension)) ? (information).get_context_information_position : offset
        if ((begin_offset).equal?(-1))
          begin_offset = offset
        end
        visible_offset = @f_content_assist_subject_control_adapter.get_widget_selection_range.attr_x - (offset - begin_offset)
        presenter = @f_content_assist_subject_control_adapter.get_context_information_presenter(@f_content_assistant, offset)
        return ContextFrame.new(information, begin_offset, offset, visible_offset, validator, presenter)
      end
      return nil
    end
    
    typesig { [ContextFrame] }
    # Compares <code>frame</code> with the top of the stack, returns <code>true</code>
    # if the frames are the same.
    # 
    # @param frame the frame to check
    # @return <code>true</code> if <code>frame</code> matches the top of the stack
    # @since 3.0
    def is_duplicate(frame)
      if ((frame).nil?)
        return false
      end
      if (@f_context_frame_stack.is_empty)
        return false
      end
      # stack not empty
      top = @f_context_frame_stack.peek
      return (frame == top)
    end
    
    typesig { [ContextFrame] }
    # Compares <code>frame</code> with most recently removed context frame, returns <code>true</code>
    # if the frames are the same.
    # 
    # @param frame the frame to check
    # @return <code>true</code> if <code>frame</code> matches the most recently removed
    # @since 3.0
    def is_last_frame(frame)
      return !(frame).nil? && (frame == @f_last_context)
    end
    
    typesig { [ContextFrame, ::Java::Boolean] }
    # Shows the given context frame.
    # 
    # @param frame the frame to display
    # @param initial <code>true</code> if this is the first frame to be displayed
    # @since 2.0
    def internal_show_context_frame(frame, initial)
      @f_content_assist_subject_control_adapter.install_validator(frame)
      if (!(frame.attr_f_presenter).nil?)
        if ((@f_text_presentation).nil?)
          @f_text_presentation = TextPresentation.new
        end
        @f_content_assist_subject_control_adapter.install_context_information_presenter(frame)
        frame.attr_f_presenter.update_presentation(frame.attr_f_offset, @f_text_presentation)
      end
      create_context_info_popup
      @f_context_info_text.set_text(frame.attr_f_information.get_information_display_string)
      if (!(@f_text_presentation).nil?)
        TextPresentation.apply_text_presentation(@f_text_presentation, @f_context_info_text)
      end
      resize(frame.attr_f_visible_offset)
      if (initial)
        if (@f_content_assistant.add_content_assist_listener(self, ContentAssistant::CONTEXT_INFO_POPUP))
          if (!(@f_content_assist_subject_control_adapter.get_control).nil?)
            @f_text_widget_selection_listener = Class.new(SelectionAdapter.class == Class ? SelectionAdapter : Object) do
              extend LocalClass
              include_class_members ContextInformationPopup
              include SelectionAdapter if SelectionAdapter.class == Module
              
              typesig { [SelectionEvent] }
              # @see org.eclipse.swt.events.SelectionAdapter#widgetSelected(org.eclipse.swt.events.SelectionEvent)
              define_method :widget_selected do |e|
                validate_context_information
              end
              
              typesig { [Vararg.new(Object)] }
              define_method :initialize do |*args|
                super(*args)
              end
              
              private
              alias_method :initialize_anonymous, :initialize
            end.new_local(self)
            @f_content_assist_subject_control_adapter.add_selection_listener(@f_text_widget_selection_listener)
          end
          @f_content_assistant.add_to_layout(self, @f_context_info_popup, ContentAssistant::LayoutManager::LAYOUT_CONTEXT_INFO_POPUP, frame.attr_f_visible_offset)
          @f_context_info_popup.set_visible(true)
        end
      else
        @f_content_assistant.layout(ContentAssistant::LayoutManager::LAYOUT_CONTEXT_INFO_POPUP, frame.attr_f_visible_offset)
      end
    end
    
    typesig { [::Java::Int] }
    # Computes all possible context information for the given offset.
    # 
    # @param offset the offset
    # @return all possible context information for the given offset
    # @since 2.0
    def compute_context_information(offset)
      return @f_content_assist_subject_control_adapter.compute_context_information(@f_content_assistant, offset)
    end
    
    typesig { [] }
    # Returns the error message generated while computing context information.
    # 
    # @return the error message
    def get_error_message
      return @f_content_assistant.get_error_message
    end
    
    typesig { [] }
    # Creates the context information popup. This is the tool tip like overlay window.
    def create_context_info_popup
      if (Helper.ok_to_use(@f_context_info_popup))
        return
      end
      control = @f_content_assist_subject_control_adapter.get_control
      display = control.get_display
      @f_context_info_popup = Shell.new(control.get_shell, SWT::NO_TRIM | SWT::ON_TOP)
      @f_context_info_popup.set_background(display.get_system_color(SWT::COLOR_BLACK))
      @f_context_info_text = StyledText.new(@f_context_info_popup, SWT::MULTI | SWT::READ_ONLY | SWT::WRAP)
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
    
    typesig { [::Java::Int] }
    # Resizes the context information popup.
    # 
    # @param offset the caret offset in widget coordinates
    # @since 2.0
    def resize(offset)
      size_ = @f_context_info_text.compute_size(SWT::DEFAULT, SWT::DEFAULT, true)
      text_pad = 0
      border_pad = 2
      pad = text_pad + border_pad
      size_.attr_x += pad
      bounds = @f_content_assistant.get_layout_manager.compute_bounds_above_below(@f_context_info_popup, size_, offset)
      if (bounds.attr_width < size_.attr_x)
        # we don't fit on the screen - try again and wrap
        size_ = @f_context_info_text.compute_size(bounds.attr_width - pad, SWT::DEFAULT, true)
      end
      size_.attr_x += text_pad
      @f_context_info_text.set_size(size_)
      @f_context_info_text.set_location(1, 1)
      size_.attr_x += border_pad
      size_.attr_y += border_pad
      @f_context_info_popup.set_size(size_)
    end
    
    typesig { [] }
    # Hides the context information popup.
    def hide_context_info_popup
      if (Helper.ok_to_use(@f_context_info_popup))
        size_ = @f_context_frame_stack.size
        if (size_ > 0)
          @f_last_context = @f_context_frame_stack.pop
          (size_ -= 1)
        end
        if (size_ > 0)
          current = @f_context_frame_stack.peek
          internal_show_context_frame(current, false)
        else
          @f_content_assistant.remove_content_assist_listener(self, ContentAssistant::CONTEXT_INFO_POPUP)
          if (!(@f_content_assist_subject_control_adapter.get_control).nil?)
            @f_content_assist_subject_control_adapter.remove_selection_listener(@f_text_widget_selection_listener)
          end
          @f_text_widget_selection_listener = nil
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
      if (Helper.ok_to_use(@f_context_selector_shell))
        return
      end
      control = @f_content_assist_subject_control_adapter.get_control
      @f_context_selector_shell = Shell.new(control.get_shell, SWT::ON_TOP | SWT::RESIZE)
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
        extend LocalClass
        include_class_members ContextInformationPopup
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
      @f_content_assistant.add_to_layout(self, @f_context_selector_shell, ContentAssistant::LayoutManager::LAYOUT_CONTEXT_SELECTOR, @f_content_assistant.get_selection_offset)
    end
    
    typesig { [] }
    # Returns the minimal required height for the popup, may return 0 if the popup has not been
    # created yet.
    # 
    # @return the minimal height
    # @since 3.3
    def get_minimal_height
      height = 0
      if (Helper.ok_to_use(@f_context_selector_table))
        items = @f_context_selector_table.get_item_height * 10
        trim = @f_context_selector_table.compute_trim(0, 0, SWT::DEFAULT, items)
        height = trim.attr_height
      end
      return height
    end
    
    typesig { [] }
    # Causes the context information of the context selected in the context selector
    # to be displayed in the context information popup.
    def insert_selected_context
      i = @f_context_selector_table.get_selection_index
      if (i < 0 || i >= @f_context_selector_input.attr_length)
        return
      end
      offset = @f_content_assist_subject_control_adapter.get_selected_range.attr_x
      internal_show_context_info(create_context_frame(@f_context_selector_input[i], offset))
    end
    
    typesig { [Array.typed(IContextInformation)] }
    # Sets the contexts in the context selector to the given set.
    # 
    # @param contexts the possible contexts
    def set_contexts(contexts)
      if (Helper.ok_to_use(@f_context_selector_table))
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
      if (@f_content_assistant.add_content_assist_listener(self, ContentAssistant::CONTEXT_SELECTOR))
        @f_context_selector_shell.set_visible(true)
      end
    end
    
    typesig { [] }
    # Hides the context selector.
    def hide_context_selector
      if (Helper.ok_to_use(@f_context_selector_shell))
        @f_content_assistant.remove_content_assist_listener(self, ContentAssistant::CONTEXT_SELECTOR)
        @f_popup_closer.uninstall
        @f_context_selector_shell.set_visible(false)
        @f_context_selector_shell.dispose
        @f_context_selector_shell = nil
      end
      if (!Helper.ok_to_use(@f_context_info_popup))
        @f_content_assistant.context_information_closed
      end
    end
    
    typesig { [] }
    # Returns whether the context selector has the focus.
    # 
    # @return <code>true</code> if the context selector has the focus
    def has_focus
      if (Helper.ok_to_use(@f_context_selector_shell))
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
      return (Helper.ok_to_use(@f_context_info_popup) || Helper.ok_to_use(@f_context_selector_shell))
    end
    
    typesig { [VerifyEvent] }
    # @see IContentAssistListener#verifyKey(VerifyEvent)
    def verify_key(e)
      if (Helper.ok_to_use(@f_context_selector_shell))
        return context_selector_key_pressed(e)
      end
      if (Helper.ok_to_use(@f_context_info_popup))
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
        new_selection = @f_context_selector_table.get_selection_index
        visible_rows = (@f_context_selector_table.get_size.attr_y / @f_context_selector_table.get_item_height) - 1
        item_count = @f_context_selector_table.get_item_count
        case (e.attr_key_code)
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
            hide_context_selector
          end
          return true
        end
        @f_context_selector_table.set_selection(new_selection)
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
          if (!(e.attr_key_code).equal?(SWT::CAPS_LOCK) && !(e.attr_key_code).equal?(SWT::MOD1) && !(e.attr_key_code).equal?(SWT::MOD2) && !(e.attr_key_code).equal?(SWT::MOD3) && !(e.attr_key_code).equal?(SWT::MOD4))
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
      if (Helper.ok_to_use(@f_context_selector_shell))
        context_selector_process_event(event)
      end
      if (Helper.ok_to_use(@f_context_info_popup))
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
      # Post the code in the event queue in order to ensure that the
      # action described by this verify key event has already been executed.
      # Otherwise, we'd validate the context information based on the
      # pre-key-stroke state.
      if (!Helper.ok_to_use(@f_context_info_popup))
        return
      end
      @f_context_info_popup.get_display.async_exec(Class.new(Runnable.class == Class ? Runnable : Object) do
        extend LocalClass
        include_class_members ContextInformationPopup
        include Runnable if Runnable.class == Module
        
        attr_accessor :f_frame
        alias_method :attr_f_frame, :f_frame
        undef_method :f_frame
        alias_method :attr_f_frame=, :f_frame=
        undef_method :f_frame=
        
        typesig { [] }
        define_method :run do
          # only do this if no other frames have been added in between
          if (!self.attr_f_context_frame_stack.is_empty && (@f_frame).equal?(self.attr_f_context_frame_stack.peek))
            offset = self.attr_f_content_assist_subject_control_adapter.get_selected_range.attr_x
            # iterate all contexts on the stack
            while (Helper.ok_to_use(self.attr_f_context_info_popup) && !self.attr_f_context_frame_stack.is_empty)
              top = self.attr_f_context_frame_stack.peek
              if ((top.attr_f_validator).nil? || !top.attr_f_validator.is_context_information_valid(offset))
                hide_context_info_popup # loop variant: reduces the number of contexts on the stack
              else
                if (!(top.attr_f_presenter).nil? && top.attr_f_presenter.update_presentation(offset, self.attr_f_text_presentation))
                  widget_offset = self.attr_f_content_assist_subject_control_adapter.get_widget_selection_range.attr_x
                  TextPresentation.apply_text_presentation(self.attr_f_text_presentation, self.attr_f_context_info_text)
                  resize(widget_offset)
                  break
                else
                  break
                end
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
    alias_method :initialize__context_information_popup, :initialize
  end
  
end
