require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
# Guy Gurfinkel, guy.g@zend.com - [content assist][api] provide better access to ContentAssistant - https://bugs.eclipse.org/bugs/show_bug.cgi?id=169954
# Anton Leherbauer (Wind River Systems) - [content assist][api] ContentAssistEvent should contain information about auto activation - https://bugs.eclipse.org/bugs/show_bug.cgi?id=193728
module Org::Eclipse::Jface::Text::Contentassist
  module ContentAssistantImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Contentassist
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :Map
      include_const ::Java::Util::Map, :Entry
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt, :SWTError
      include_const ::Org::Eclipse::Swt::Custom, :VerifyKeyListener
      include_const ::Org::Eclipse::Swt::Events, :ControlEvent
      include_const ::Org::Eclipse::Swt::Events, :ControlListener
      include_const ::Org::Eclipse::Swt::Events, :DisposeEvent
      include_const ::Org::Eclipse::Swt::Events, :DisposeListener
      include_const ::Org::Eclipse::Swt::Events, :FocusEvent
      include_const ::Org::Eclipse::Swt::Events, :FocusListener
      include_const ::Org::Eclipse::Swt::Events, :KeyAdapter
      include_const ::Org::Eclipse::Swt::Events, :KeyEvent
      include_const ::Org::Eclipse::Swt::Events, :MouseEvent
      include_const ::Org::Eclipse::Swt::Events, :MouseListener
      include_const ::Org::Eclipse::Swt::Events, :TraverseEvent
      include_const ::Org::Eclipse::Swt::Events, :TraverseListener
      include_const ::Org::Eclipse::Swt::Events, :VerifyEvent
      include_const ::Org::Eclipse::Swt::Graphics, :Color
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Graphics, :Rectangle
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Display
      include_const ::Org::Eclipse::Swt::Widgets, :Event
      include_const ::Org::Eclipse::Swt::Widgets, :Listener
      include_const ::Org::Eclipse::Swt::Widgets, :Monitor
      include_const ::Org::Eclipse::Swt::Widgets, :Shell
      include_const ::Org::Eclipse::Swt::Widgets, :Widget
      include_const ::Org::Eclipse::Core::Commands, :IHandler
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Core::Runtime, :ListenerList
      include_const ::Org::Eclipse::Jface::Bindings::Keys, :KeySequence
      include_const ::Org::Eclipse::Jface::Contentassist, :IContentAssistSubjectControl
      include_const ::Org::Eclipse::Jface::Contentassist, :ISubjectControlContentAssistProcessor
      include_const ::Org::Eclipse::Jface::Dialogs, :IDialogSettings
      include_const ::Org::Eclipse::Jface::Preference, :JFacePreferences
      include_const ::Org::Eclipse::Jface::Util, :Geometry
      include_const ::Org::Eclipse::Jface::Text, :BadLocationException
      include_const ::Org::Eclipse::Jface::Text, :IDocument
      include_const ::Org::Eclipse::Jface::Text, :IDocumentExtension3
      include_const ::Org::Eclipse::Jface::Text, :IEventConsumer
      include_const ::Org::Eclipse::Jface::Text, :IInformationControlCreator
      include_const ::Org::Eclipse::Jface::Text, :ITextViewer
      include_const ::Org::Eclipse::Jface::Text, :IViewportListener
      include_const ::Org::Eclipse::Jface::Text, :IWidgetTokenKeeper
      include_const ::Org::Eclipse::Jface::Text, :IWidgetTokenKeeperExtension
      include_const ::Org::Eclipse::Jface::Text, :IWidgetTokenOwner
      include_const ::Org::Eclipse::Jface::Text, :IWidgetTokenOwnerExtension
      include_const ::Org::Eclipse::Jface::Text, :TextUtilities
    }
  end
  
  # The standard implementation of the <code>IContentAssistant</code> interface. Usually, clients
  # instantiate this class and configure it before using it.
  class ContentAssistant 
    include_class_members ContentAssistantImports
    include IContentAssistant
    include IContentAssistantExtension
    include IContentAssistantExtension2
    include IContentAssistantExtension3
    include IContentAssistantExtension4
    include IWidgetTokenKeeper
    include IWidgetTokenKeeperExtension
    
    class_module.module_eval {
      # Content assist command identifier for 'select next proposal'.
      # 
      # @since 3.4
      const_set_lazy(:SELECT_NEXT_PROPOSAL_COMMAND_ID) { "org.eclipse.ui.edit.text.contentAssist.selectNextProposal" }
      const_attr_reader  :SELECT_NEXT_PROPOSAL_COMMAND_ID
      
      # $NON-NLS-1$
      # 
      # Content assist command identifier for 'select previous proposal'.
      # 
      # @since 3.4
      const_set_lazy(:SELECT_PREVIOUS_PROPOSAL_COMMAND_ID) { "org.eclipse.ui.edit.text.contentAssist.selectPreviousProposal" }
      const_attr_reader  :SELECT_PREVIOUS_PROPOSAL_COMMAND_ID
      
      # $NON-NLS-1$
      # 
      # A generic closer class used to monitor various interface events in order to determine whether
      # content-assist should be terminated and all associated windows closed.
      const_set_lazy(:Closer) { Class.new do
        local_class_in ContentAssistant
        include_class_members ContentAssistant
        include ControlListener
        include MouseListener
        include FocusListener
        include DisposeListener
        include IViewportListener
        
        # The shell that a <code>ControlListener</code> is registered with.
        attr_accessor :f_shell
        alias_method :attr_f_shell, :f_shell
        undef_method :f_shell
        alias_method :attr_f_shell=, :f_shell=
        undef_method :f_shell=
        
        # The control that a <code>MouseListener</code>, a<code>FocusListener</code> and a
        # <code>DisposeListener</code> are registered with.
        attr_accessor :f_control
        alias_method :attr_f_control, :f_control
        undef_method :f_control
        alias_method :attr_f_control=, :f_control=
        undef_method :f_control=
        
        typesig { [] }
        # Installs this closer on it's viewer's text widget.
        def install
          control = self.attr_f_content_assist_subject_control_adapter.get_control
          @f_control = control
          if (Helper.ok_to_use(control))
            shell = control.get_shell
            @f_shell = shell
            shell.add_control_listener(self)
            control.add_mouse_listener(self)
            control.add_focus_listener(self)
            # 1GGYYWK: ITPJUI:ALL - Dismissing editor with code assist up causes lots of
            # Internal Errors
            control.add_dispose_listener(self)
          end
          if (!(self.attr_f_viewer).nil?)
            self.attr_f_viewer.add_viewport_listener(self)
          end
        end
        
        typesig { [] }
        # Uninstalls this closer from the viewer's text widget.
        def uninstall
          shell = @f_shell
          @f_shell = nil
          if (Helper.ok_to_use(shell))
            shell.remove_control_listener(self)
          end
          control = @f_control
          @f_control = nil
          if (Helper.ok_to_use(control))
            control.remove_mouse_listener(self)
            control.remove_focus_listener(self)
            # 1GGYYWK: ITPJUI:ALL - Dismissing editor with code assist up causes lots of
            # Internal Errors
            control.remove_dispose_listener(self)
          end
          if (!(self.attr_f_viewer).nil?)
            self.attr_f_viewer.remove_viewport_listener(self)
          end
        end
        
        typesig { [class_self::ControlEvent] }
        # @see ControlListener#controlResized(ControlEvent)
        def control_resized(e)
          hide
        end
        
        typesig { [class_self::ControlEvent] }
        # @see ControlListener#controlMoved(ControlEvent)
        def control_moved(e)
          hide
        end
        
        typesig { [class_self::MouseEvent] }
        # @see MouseListener#mouseDown(MouseEvent)
        def mouse_down(e)
          hide
        end
        
        typesig { [class_self::MouseEvent] }
        # @see MouseListener#mouseUp(MouseEvent)
        def mouse_up(e)
        end
        
        typesig { [class_self::MouseEvent] }
        # @see MouseListener#mouseDoubleClick(MouseEvent)
        def mouse_double_click(e)
          hide
        end
        
        typesig { [class_self::FocusEvent] }
        # @see FocusListener#focusGained(FocusEvent)
        def focus_gained(e)
        end
        
        typesig { [class_self::FocusEvent] }
        # @see FocusListener#focusLost(FocusEvent)
        def focus_lost(e)
          control = @f_control
          if (Helper.ok_to_use(control))
            d = control.get_display
            if (!(d).nil?)
              d.async_exec(Class.new(self.class::Runnable.class == Class ? self.class::Runnable : Object) do
                local_class_in Closer
                include_class_members Closer
                include class_self::Runnable if class_self::Runnable.class == Module
                
                typesig { [] }
                define_method :run do
                  if (!self.attr_f_proposal_popup.has_focus && ((self.attr_f_context_info_popup).nil? || !self.attr_f_context_info_popup.has_focus))
                    hide
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
        end
        
        typesig { [class_self::DisposeEvent] }
        # @seeDisposeListener#widgetDisposed(DisposeEvent)
        def widget_disposed(e)
          # 1GGYYWK: ITPJUI:ALL - Dismissing editor with code assist up causes lots of Internal
          # Errors
          hide
        end
        
        typesig { [::Java::Int] }
        # @see IViewportListener#viewportChanged(int)
        def viewport_changed(top_index)
          hide
        end
        
        typesig { [] }
        def initialize
          @f_shell = nil
          @f_control = nil
        end
        
        private
        alias_method :initialize__closer, :initialize
      end }
      
      # An implementation of <code>IContentAssistListener</code>, this class is used to monitor
      # key events in support of automatic activation of the content assistant. If enabled, the
      # implementation utilizes a thread to watch for input characters matching the activation
      # characters specified by the content assist processor, and if detected, will wait the
      # indicated delay interval before activating the content assistant.
      # 
      # @since 3.4 protected, was added in 2.1 as private class
      const_set_lazy(:AutoAssistListener) { Class.new(KeyAdapter) do
        local_class_in ContentAssistant
        include_class_members ContentAssistant
        overload_protected {
          include Runnable
          include VerifyKeyListener
        }
        
        attr_accessor :f_thread
        alias_method :attr_f_thread, :f_thread
        undef_method :f_thread
        alias_method :attr_f_thread=, :f_thread=
        undef_method :f_thread=
        
        attr_accessor :f_is_reset
        alias_method :attr_f_is_reset, :f_is_reset
        undef_method :f_is_reset
        alias_method :attr_f_is_reset=, :f_is_reset=
        undef_method :f_is_reset=
        
        attr_accessor :f_mutex
        alias_method :attr_f_mutex, :f_mutex
        undef_method :f_mutex
        alias_method :attr_f_mutex=, :f_mutex=
        undef_method :f_mutex=
        
        attr_accessor :f_show_style
        alias_method :attr_f_show_style, :f_show_style
        undef_method :f_show_style
        alias_method :attr_f_show_style=, :f_show_style=
        undef_method :f_show_style=
        
        class_module.module_eval {
          const_set_lazy(:SHOW_PROPOSALS) { 1 }
          const_attr_reader  :SHOW_PROPOSALS
          
          const_set_lazy(:SHOW_CONTEXT_INFO) { 2 }
          const_attr_reader  :SHOW_CONTEXT_INFO
        }
        
        typesig { [] }
        def initialize
          @f_thread = nil
          @f_is_reset = false
          @f_mutex = nil
          @f_show_style = 0
          super()
          @f_is_reset = false
          @f_mutex = Object.new
        end
        
        typesig { [::Java::Int] }
        def start(show_style)
          @f_show_style = show_style
          @f_thread = self.class::JavaThread.new(self, JFaceTextMessages.get_string("ContentAssistant.assist_delay_timer_name")) # $NON-NLS-1$
          @f_thread.start
        end
        
        typesig { [] }
        def run
          begin
            while (true)
              synchronized((@f_mutex)) do
                if (!(self.attr_f_auto_activation_delay).equal?(0))
                  @f_mutex.wait(self.attr_f_auto_activation_delay)
                end
                if (@f_is_reset)
                  @f_is_reset = false
                  next
                end
              end
              show_assist(@f_show_style)
              break
            end
          rescue self.class::InterruptedException => e
          end
          @f_thread = nil
        end
        
        typesig { [::Java::Int] }
        def reset(show_style)
          synchronized((@f_mutex)) do
            @f_show_style = show_style
            @f_is_reset = true
            @f_mutex.notify_all
          end
        end
        
        typesig { [] }
        def stop
          thread_to_stop = @f_thread
          if (!(thread_to_stop).nil? && thread_to_stop.is_alive)
            thread_to_stop.interrupt
          end
        end
        
        typesig { [Array.typed(::Java::Char), ::Java::Char] }
        def contains(characters, character)
          if (!(characters).nil?)
            i = 0
            while i < characters.attr_length
              if ((character).equal?(characters[i]))
                return true
              end
              i += 1
            end
          end
          return false
        end
        
        typesig { [class_self::KeyEvent] }
        def key_pressed(e)
          # Only act on typed characters and ignore modifier-only events
          if ((e.attr_character).equal?(0) && ((e.attr_key_code & SWT::KEYCODE_BIT)).equal?(0))
            return
          end
          if (!(e.attr_character).equal?(0) && ((e.attr_state_mask).equal?(SWT::ALT)))
            return
          end
          # Only act on characters that are trigger candidates. This
          # avoids computing the model selection on every keystroke
          if (compute_all_auto_activation_triggers.index_of(e.attr_character) < 0)
            stop
            return
          end
          show_style = 0
          pos = self.attr_f_content_assist_subject_control_adapter.get_selected_range.attr_x
          activation = nil
          activation = self.attr_f_content_assist_subject_control_adapter.get_completion_proposal_auto_activation_characters(@local_class_parent, pos)
          if (contains(activation, e.attr_character) && !is_proposal_popup_active)
            show_style = self.class::SHOW_PROPOSALS
          else
            activation = self.attr_f_content_assist_subject_control_adapter.get_context_information_auto_activation_characters(@local_class_parent, pos)
            if (contains(activation, e.attr_character) && !is_context_info_popup_active)
              show_style = self.class::SHOW_CONTEXT_INFO
            else
              stop
              return
            end
          end
          if (!(@f_thread).nil? && @f_thread.is_alive)
            reset(show_style)
          else
            start(show_style)
          end
        end
        
        typesig { [class_self::VerifyEvent] }
        # @see org.eclipse.swt.custom.VerifyKeyListener#verifyKey(org.eclipse.swt.events.VerifyEvent)
        def verify_key(event)
          key_pressed(event)
        end
        
        typesig { [::Java::Int] }
        def show_assist(show_style)
          control = self.attr_f_content_assist_subject_control_adapter.get_control
          if ((control).nil?)
            return
          end
          d = control.get_display
          if ((d).nil?)
            return
          end
          begin
            d.sync_exec(Class.new(self.class::Runnable.class == Class ? self.class::Runnable : Object) do
              local_class_in AutoAssistListener
              include_class_members AutoAssistListener
              include class_self::Runnable if class_self::Runnable.class == Module
              
              typesig { [] }
              define_method :run do
                if (is_proposal_popup_active)
                  return
                end
                if (control.is_disposed || !control.is_focus_control)
                  return
                end
                if ((show_style).equal?(self.class::SHOW_PROPOSALS))
                  if (!prepare_to_show_completions(true))
                    return
                  end
                  self.attr_f_proposal_popup.show_proposals(true)
                  self.attr_f_last_auto_activation = System.current_time_millis
                else
                  if ((show_style).equal?(self.class::SHOW_CONTEXT_INFO) && !(self.attr_f_context_info_popup).nil?)
                    promote_key_listener
                    self.attr_f_context_info_popup.show_context_proposals(true)
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
          rescue self.class::SWTError => e
          end
        end
        
        private
        alias_method :initialize__auto_assist_listener, :initialize
      end }
      
      # The layout manager layouts the various windows associated with the content assistant based on
      # the settings of the content assistant.
      const_set_lazy(:LayoutManager) { Class.new do
        local_class_in ContentAssistant
        include_class_members ContentAssistant
        include Listener
        
        class_module.module_eval {
          # Presentation types.
          # The presentation type for the proposal selection popup.
          const_set_lazy(:LAYOUT_PROPOSAL_SELECTOR) { 0 }
          const_attr_reader  :LAYOUT_PROPOSAL_SELECTOR
          
          # The presentation type for the context selection popup.
          const_set_lazy(:LAYOUT_CONTEXT_SELECTOR) { 1 }
          const_attr_reader  :LAYOUT_CONTEXT_SELECTOR
          
          # The presentation type for the context information hover .
          const_set_lazy(:LAYOUT_CONTEXT_INFO_POPUP) { 2 }
          const_attr_reader  :LAYOUT_CONTEXT_INFO_POPUP
        }
        
        attr_accessor :f_context_type
        alias_method :attr_f_context_type, :f_context_type
        undef_method :f_context_type
        alias_method :attr_f_context_type=, :f_context_type=
        undef_method :f_context_type=
        
        attr_accessor :f_shells
        alias_method :attr_f_shells, :f_shells
        undef_method :f_shells
        alias_method :attr_f_shells=, :f_shells=
        undef_method :f_shells=
        
        attr_accessor :f_popups
        alias_method :attr_f_popups, :f_popups
        undef_method :f_popups
        alias_method :attr_f_popups=, :f_popups=
        undef_method :f_popups=
        
        typesig { [Object, class_self::Shell, ::Java::Int, ::Java::Int] }
        def add(popup, shell, type, offset)
          Assert.is_not_null(popup)
          Assert.is_true(!(shell).nil? && !shell.is_disposed)
          check_type(type)
          if (!(@f_shells[type]).equal?(shell))
            if (!(@f_shells[type]).nil?)
              @f_shells[type].remove_listener(SWT::Dispose, self)
            end
            shell.add_listener(SWT::Dispose, self)
            @f_shells[type] = shell
          end
          @f_popups[type] = popup
          if ((type).equal?(self.class::LAYOUT_CONTEXT_SELECTOR) || (type).equal?(self.class::LAYOUT_CONTEXT_INFO_POPUP))
            @f_context_type = type
          end
          layout(type, offset)
          adjust_listeners(type)
        end
        
        typesig { [::Java::Int] }
        def check_type(type)
          Assert.is_true((type).equal?(self.class::LAYOUT_PROPOSAL_SELECTOR) || (type).equal?(self.class::LAYOUT_CONTEXT_SELECTOR) || (type).equal?(self.class::LAYOUT_CONTEXT_INFO_POPUP))
        end
        
        typesig { [class_self::Event] }
        def handle_event(event)
          source = event.attr_widget
          source.remove_listener(SWT::Dispose, self)
          type = get_shell_type(source)
          check_type(type)
          @f_shells[type] = nil
          case (type)
          when self.class::LAYOUT_PROPOSAL_SELECTOR
            if ((@f_context_type).equal?(self.class::LAYOUT_CONTEXT_SELECTOR) && Helper.ok_to_use(@f_shells[self.class::LAYOUT_CONTEXT_SELECTOR]))
              # Restore event notification to the tip popup.
              add_content_assist_listener(@f_popups[self.class::LAYOUT_CONTEXT_SELECTOR], CONTEXT_SELECTOR)
            end
          when self.class::LAYOUT_CONTEXT_SELECTOR
            if (Helper.ok_to_use(@f_shells[self.class::LAYOUT_PROPOSAL_SELECTOR]))
              if ((self.attr_f_proposal_popup_orientation).equal?(PROPOSAL_STACKED))
                layout(self.class::LAYOUT_PROPOSAL_SELECTOR, get_selection_offset)
              end
              # Restore event notification to the proposal popup.
              add_content_assist_listener(@f_popups[self.class::LAYOUT_PROPOSAL_SELECTOR], PROPOSAL_SELECTOR)
            end
            @f_context_type = self.class::LAYOUT_CONTEXT_INFO_POPUP
          when self.class::LAYOUT_CONTEXT_INFO_POPUP
            if (Helper.ok_to_use(@f_shells[self.class::LAYOUT_PROPOSAL_SELECTOR]))
              if ((self.attr_f_context_info_popup_orientation).equal?(CONTEXT_INFO_BELOW))
                layout(self.class::LAYOUT_PROPOSAL_SELECTOR, get_selection_offset)
              end
            end
            @f_context_type = self.class::LAYOUT_CONTEXT_SELECTOR
          end
        end
        
        typesig { [class_self::Widget] }
        def get_shell_type(shell)
          i = 0
          while i < @f_shells.attr_length
            if ((@f_shells[i]).equal?(shell))
              return i
            end
            i += 1
          end
          return -1
        end
        
        typesig { [::Java::Int, ::Java::Int] }
        # Layouts the popup defined by <code>type</code> at the given widget offset.
        # 
        # @param type the kind of popup to layout
        # @param offset the widget offset
        def layout(type, offset)
          case (type)
          when self.class::LAYOUT_PROPOSAL_SELECTOR
            layout_proposal_selector(offset)
          when self.class::LAYOUT_CONTEXT_SELECTOR
            layout_context_selector(offset)
          when self.class::LAYOUT_CONTEXT_INFO_POPUP
            layout_context_info_popup(offset)
          end
        end
        
        typesig { [::Java::Int] }
        def layout_proposal_selector(offset)
          if ((@f_context_type).equal?(self.class::LAYOUT_CONTEXT_INFO_POPUP) && (self.attr_f_context_info_popup_orientation).equal?(CONTEXT_INFO_BELOW) && Helper.ok_to_use(@f_shells[self.class::LAYOUT_CONTEXT_INFO_POPUP]))
            # Stack proposal selector beneath the tip box.
            shell = @f_shells[self.class::LAYOUT_PROPOSAL_SELECTOR]
            parent = @f_shells[self.class::LAYOUT_CONTEXT_INFO_POPUP]
            shell.set_location(get_stacked_location(shell, parent))
          else
            if (!(@f_context_type).equal?(self.class::LAYOUT_CONTEXT_SELECTOR) || !Helper.ok_to_use(@f_shells[self.class::LAYOUT_CONTEXT_SELECTOR]))
              # There are no other presentations to be concerned with,
              # so place the proposal selector beneath the cursor line.
              shell = @f_shells[self.class::LAYOUT_PROPOSAL_SELECTOR]
              popup = @f_popups[self.class::LAYOUT_PROPOSAL_SELECTOR]
              shell.set_bounds(compute_bounds_below_above(shell, shell.get_size, offset, popup))
            else
              popup = (@f_popups[self.class::LAYOUT_PROPOSAL_SELECTOR])
              case (self.attr_f_proposal_popup_orientation)
              when PROPOSAL_REMOVE
                # Remove the tip selector and place the
                # proposal selector beneath the cursor line.
                @f_shells[self.class::LAYOUT_CONTEXT_SELECTOR].dispose
                shell = @f_shells[self.class::LAYOUT_PROPOSAL_SELECTOR]
                shell.set_bounds(compute_bounds_below_above(shell, shell.get_size, offset, popup))
              when PROPOSAL_OVERLAY
                # Overlay the tip selector with the proposal selector.
                shell = @f_shells[self.class::LAYOUT_PROPOSAL_SELECTOR]
                shell.set_bounds(compute_bounds_below_above(shell, shell.get_size, offset, popup))
              when PROPOSAL_STACKED
                # Stack the proposal selector beneath the tip selector.
                shell = @f_shells[self.class::LAYOUT_PROPOSAL_SELECTOR]
                parent = @f_shells[self.class::LAYOUT_CONTEXT_SELECTOR]
                shell.set_location(get_stacked_location(shell, parent))
              end
            end
          end
        end
        
        typesig { [::Java::Int] }
        def layout_context_selector(offset)
          # Always place the context selector beneath the cursor line.
          shell = @f_shells[self.class::LAYOUT_CONTEXT_SELECTOR]
          shell.set_bounds(compute_bounds_below_above(shell, shell.get_size, offset, nil))
          if (Helper.ok_to_use(@f_shells[self.class::LAYOUT_PROPOSAL_SELECTOR]))
            case (self.attr_f_proposal_popup_orientation)
            when PROPOSAL_REMOVE
              # Remove the proposal selector.
              @f_shells[self.class::LAYOUT_PROPOSAL_SELECTOR].dispose
            when PROPOSAL_OVERLAY
              # The proposal selector has been overlaid by the tip selector.
            when PROPOSAL_STACKED
              # Stack the proposal selector beneath the tip selector.
              shell = @f_shells[self.class::LAYOUT_PROPOSAL_SELECTOR]
              parent = @f_shells[self.class::LAYOUT_CONTEXT_SELECTOR]
              shell.set_location(get_stacked_location(shell, parent))
            end
          end
        end
        
        typesig { [::Java::Int] }
        def layout_context_info_popup(offset)
          case (self.attr_f_context_info_popup_orientation)
          when CONTEXT_INFO_ABOVE
            # Place the popup above the cursor line.
            shell = @f_shells[self.class::LAYOUT_CONTEXT_INFO_POPUP]
            shell.set_bounds(compute_bounds_above_below(shell, shell.get_size, offset))
          when CONTEXT_INFO_BELOW
            # Place the popup beneath the cursor line.
            parent = @f_shells[self.class::LAYOUT_CONTEXT_INFO_POPUP]
            parent.set_bounds(compute_bounds_below_above(parent, parent.get_size, offset, nil))
            if (Helper.ok_to_use(@f_shells[self.class::LAYOUT_PROPOSAL_SELECTOR]))
              # Stack the proposal selector beneath the context info popup.
              shell = @f_shells[self.class::LAYOUT_PROPOSAL_SELECTOR]
              shell.set_location(get_stacked_location(shell, parent))
            end
          end
        end
        
        typesig { [class_self::Point, class_self::Point, class_self::Rectangle] }
        # Moves <code>point</code> such that <code>rectangle</code> does not bleed outside of
        # <code>bounds</code>. All coordinates must have the same reference.
        # 
        # @param point the point to move if needed
        # @param shellSize the size of the shell that may be moved
        # @param bounds the bounds
        # @since 3.3
        def constrain_location(point, shell_size, bounds)
          if (point.attr_x + shell_size.attr_x > bounds.attr_x + bounds.attr_width)
            point.attr_x = bounds.attr_x + bounds.attr_width - shell_size.attr_x
          end
          if (point.attr_x < bounds.attr_x)
            point.attr_x = bounds.attr_x
          end
          if (point.attr_y + shell_size.attr_y > bounds.attr_y + bounds.attr_height)
            point.attr_y = bounds.attr_y + bounds.attr_height - shell_size.attr_y
          end
          if (point.attr_y < bounds.attr_y)
            point.attr_y = bounds.attr_y
          end
        end
        
        typesig { [class_self::Rectangle, class_self::Rectangle] }
        def constrain_horizontally(rect, bounds)
          # clip width
          if (rect.attr_width > bounds.attr_width)
            rect.attr_width = bounds.attr_width
          end
          if (rect.attr_x + rect.attr_width > bounds.attr_x + bounds.attr_width)
            rect.attr_x = bounds.attr_x + bounds.attr_width - rect.attr_width
          end
          if (rect.attr_x < bounds.attr_x)
            rect.attr_x = bounds.attr_x
          end
          return rect
        end
        
        typesig { [class_self::Shell, class_self::Point, ::Java::Int] }
        # Returns the display bounds for <code>shell</code> such that it appears right above
        # <code>offset</code>, or below it if above is not suitable. The returned bounds lie
        # within the monitor at the caret location and never overlap with the caret line.
        # 
        # @param shell the shell to compute the placement for
        # @param preferred the preferred size for <code>shell</code>
        # @param offset the caret offset in the subject control
        # @return the point right above <code>offset</code> in display coordinates
        # @since 3.3
        def compute_bounds_above_below(shell, preferred, offset)
          subject_control = self.attr_f_content_assist_subject_control_adapter.get_control
          display = subject_control.get_display
          caret = get_caret_rectangle(offset)
          monitor = get_closest_monitor(display, caret)
          bounds = monitor.get_client_area
          Geometry.move_inside(caret, bounds)
          space_above = caret.attr_y - bounds.attr_y
          caret_lower_y = caret.attr_y + caret.attr_height
          space_below = bounds.attr_y + bounds.attr_height - caret_lower_y
          rect = nil
          if (space_above >= preferred.attr_y)
            rect = self.class::Rectangle.new(caret.attr_x, caret.attr_y - preferred.attr_y, preferred.attr_x, preferred.attr_y)
          else
            if (space_below >= preferred.attr_y)
              rect = self.class::Rectangle.new(caret.attr_x, caret_lower_y, preferred.attr_x, preferred.attr_y)
            # we can't fit in the preferred size - squeeze into larger area
            else
              if (space_below <= space_above)
                rect = self.class::Rectangle.new(caret.attr_x, bounds.attr_y, preferred.attr_x, space_above)
              else
                rect = self.class::Rectangle.new(caret.attr_x, caret_lower_y, preferred.attr_x, space_below)
              end
            end
          end
          return constrain_horizontally(rect, bounds)
        end
        
        typesig { [class_self::Shell, class_self::Point, ::Java::Int, class_self::CompletionProposalPopup] }
        # Returns the display bounds for <code>shell</code> such that it appears right below
        # <code>offset</code>, or above it if below is not suitable. The returned bounds lie
        # within the monitor at the caret location and never overlap with the caret line.
        # 
        # @param shell the shell to compute the placement for
        # @param preferred the preferred size for <code>shell</code>
        # @param offset the caret offset in the subject control
        # @param popup a popup to inform if the location was switched to above, <code>null</code> to do nothing
        # @return the point right below <code>offset</code> in display coordinates
        # @since 3.3
        def compute_bounds_below_above(shell, preferred, offset, popup)
          subject_control = self.attr_f_content_assist_subject_control_adapter.get_control
          display = subject_control.get_display
          caret = get_caret_rectangle(offset)
          monitor = get_closest_monitor(display, caret)
          bounds = monitor.get_client_area
          Geometry.move_inside(caret, bounds)
          threshold = (popup).nil? ? JavaInteger::MAX_VALUE : popup.get_minimal_height
          space_above = caret.attr_y - bounds.attr_y
          space_below = bounds.attr_y + bounds.attr_height - (caret.attr_y + caret.attr_height)
          rect = nil
          switched = false
          if (space_below >= preferred.attr_y)
            rect = self.class::Rectangle.new(caret.attr_x, caret.attr_y + caret.attr_height, preferred.attr_x, preferred.attr_y)
          # squeeze in below if we have at least threshold space
          else
            if (space_below >= threshold)
              rect = self.class::Rectangle.new(caret.attr_x, caret.attr_y + caret.attr_height, preferred.attr_x, space_below)
            else
              if (space_above >= preferred.attr_y)
                rect = self.class::Rectangle.new(caret.attr_x, caret.attr_y - preferred.attr_y, preferred.attr_x, preferred.attr_y)
                switched = true
              else
                if (space_below >= space_above)
                  # we can't fit in the preferred size - squeeze into larger area
                  rect = self.class::Rectangle.new(caret.attr_x, caret.attr_y + caret.attr_height, preferred.attr_x, space_below)
                else
                  rect = self.class::Rectangle.new(caret.attr_x, bounds.attr_y, preferred.attr_x, space_above)
                  switched = true
                end
              end
            end
          end
          if (!(popup).nil?)
            popup.switched_position_to_above(switched)
          end
          return constrain_horizontally(rect, bounds)
        end
        
        typesig { [::Java::Int] }
        def get_caret_rectangle(offset)
          location = self.attr_f_content_assist_subject_control_adapter.get_location_at_offset(offset)
          subject_control = self.attr_f_content_assist_subject_control_adapter.get_control
          control_size = subject_control.get_size
          constrain_location(location, self.class::Point.new(0, 0), self.class::Rectangle.new(0, 0, control_size.attr_x, control_size.attr_y))
          location = subject_control.to_display(location)
          subject_rectangle = self.class::Rectangle.new(location.attr_x, location.attr_y, 1, self.attr_f_content_assist_subject_control_adapter.get_line_height)
          return subject_rectangle
        end
        
        typesig { [class_self::Shell, class_self::Shell] }
        def get_stacked_location(shell, parent)
          p = parent.get_location
          size = parent.get_size
          p.attr_x += size.attr_x / 4
          p.attr_y += size.attr_y
          p = parent.to_display(p)
          shell_size = shell.get_size
          monitor = get_closest_monitor(parent.get_display, self.class::Rectangle.new(p.attr_x, p.attr_y, 0, 0))
          display_bounds = monitor.get_client_area
          constrain_location(p, shell_size, display_bounds)
          return p
        end
        
        typesig { [::Java::Int] }
        def adjust_listeners(type)
          case (type)
          when self.class::LAYOUT_PROPOSAL_SELECTOR
            if ((@f_context_type).equal?(self.class::LAYOUT_CONTEXT_SELECTOR) && Helper.ok_to_use(@f_shells[self.class::LAYOUT_CONTEXT_SELECTOR]))
              # Disable event notification to the tip selector.
              remove_content_assist_listener(@f_popups[self.class::LAYOUT_CONTEXT_SELECTOR], CONTEXT_SELECTOR)
            end
          when self.class::LAYOUT_CONTEXT_SELECTOR
            if (Helper.ok_to_use(@f_shells[self.class::LAYOUT_PROPOSAL_SELECTOR]))
              # Disable event notification to the proposal selector.
              remove_content_assist_listener(@f_popups[self.class::LAYOUT_PROPOSAL_SELECTOR], PROPOSAL_SELECTOR)
            end
          when self.class::LAYOUT_CONTEXT_INFO_POPUP
          end
        end
        
        typesig { [class_self::Display, class_self::Rectangle] }
        # Copied from org.eclipse.jface.window.Window. Returns the monitor whose client area
        # contains the given point. If no monitor contains the point, returns the monitor that is
        # closest to the point. If this is ever made public, it should be moved into a separate
        # utility class.
        # 
        # @param toSearch point to find (display coordinates)
        # @param rectangle rectangle to find (display coordinates)
        # @return the monitor closest to the given point
        # @since 3.3
        def get_closest_monitor(to_search, rectangle)
          closest = JavaInteger::MAX_VALUE
          to_find = Geometry.center_point(rectangle)
          monitors = to_search.get_monitors
          result = monitors[0]
          idx = 0
          while idx < monitors.attr_length
            current = monitors[idx]
            client_area = current.get_client_area
            if (client_area.contains(to_find))
              return current
            end
            distance = Geometry.distance_squared(Geometry.center_point(client_area), to_find)
            if (distance < closest)
              closest = distance
              result = current
            end
            idx += 1
          end
          return result
        end
        
        typesig { [] }
        def initialize
          @f_context_type = self.class::LAYOUT_CONTEXT_SELECTOR
          @f_shells = Array.typed(self.class::Shell).new(3) { nil }
          @f_popups = Array.typed(Object).new(3) { nil }
        end
        
        private
        alias_method :initialize__layout_manager, :initialize
      end }
      
      # Internal key listener and event consumer.
      const_set_lazy(:InternalListener) { Class.new do
        local_class_in ContentAssistant
        include_class_members ContentAssistant
        include VerifyKeyListener
        include IEventConsumer
        
        typesig { [class_self::VerifyEvent] }
        # Verifies key events by notifying the registered listeners. Each listener is allowed to
        # indicate that the event has been handled and should not be further processed.
        # 
        # @param e the verify event
        # @see VerifyKeyListener#verifyKey(org.eclipse.swt.events.VerifyEvent)
        def verify_key(e)
          listeners = self.attr_f_listeners.clone
          i = 0
          while i < listeners.attr_length
            if (!(listeners[i]).nil?)
              if (!listeners[i].verify_key(e) || !e.attr_doit)
                break
              end
            end
            i += 1
          end
          if (!(self.attr_f_auto_assist_listener).nil?)
            self.attr_f_auto_assist_listener.key_pressed(e)
          end
        end
        
        typesig { [class_self::VerifyEvent] }
        # @see IEventConsumer#processEvent
        def process_event(event)
          install_key_listener
          listeners = self.attr_f_listeners.clone
          i = 0
          while i < listeners.attr_length
            if (!(listeners[i]).nil?)
              listeners[i].process_event(event)
              if (!event.attr_doit)
                return
              end
            end
            i += 1
          end
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__internal_listener, :initialize
      end }
      
      # Dialog store constants.
      # 
      # @since 3.0
      const_set_lazy(:STORE_SIZE_X) { "size.x" }
      const_attr_reader  :STORE_SIZE_X
      
      # $NON-NLS-1$
      const_set_lazy(:STORE_SIZE_Y) { "size.y" }
      const_attr_reader  :STORE_SIZE_Y
      
      # $NON-NLS-1$
      # Content-Assist Listener types
      const_set_lazy(:CONTEXT_SELECTOR) { 0 }
      const_attr_reader  :CONTEXT_SELECTOR
      
      const_set_lazy(:PROPOSAL_SELECTOR) { 1 }
      const_attr_reader  :PROPOSAL_SELECTOR
      
      const_set_lazy(:CONTEXT_INFO_POPUP) { 2 }
      const_attr_reader  :CONTEXT_INFO_POPUP
      
      # The popup priority: &gt; linked position proposals and hover pop-ups. Default value:
      # <code>20</code>;
      # 
      # @since 3.0
      const_set_lazy(:WIDGET_PRIORITY) { 20 }
      const_attr_reader  :WIDGET_PRIORITY
      
      const_set_lazy(:DEFAULT_AUTO_ACTIVATION_DELAY) { 500 }
      const_attr_reader  :DEFAULT_AUTO_ACTIVATION_DELAY
    }
    
    attr_accessor :f_information_control_creator
    alias_method :attr_f_information_control_creator, :f_information_control_creator
    undef_method :f_information_control_creator
    alias_method :attr_f_information_control_creator=, :f_information_control_creator=
    undef_method :f_information_control_creator=
    
    attr_accessor :f_auto_activation_delay
    alias_method :attr_f_auto_activation_delay, :f_auto_activation_delay
    undef_method :f_auto_activation_delay
    alias_method :attr_f_auto_activation_delay=, :f_auto_activation_delay=
    undef_method :f_auto_activation_delay=
    
    attr_accessor :f_is_auto_activated
    alias_method :attr_f_is_auto_activated, :f_is_auto_activated
    undef_method :f_is_auto_activated
    alias_method :attr_f_is_auto_activated=, :f_is_auto_activated=
    undef_method :f_is_auto_activated=
    
    attr_accessor :f_is_auto_inserting
    alias_method :attr_f_is_auto_inserting, :f_is_auto_inserting
    undef_method :f_is_auto_inserting
    alias_method :attr_f_is_auto_inserting=, :f_is_auto_inserting=
    undef_method :f_is_auto_inserting=
    
    attr_accessor :f_proposal_popup_orientation
    alias_method :attr_f_proposal_popup_orientation, :f_proposal_popup_orientation
    undef_method :f_proposal_popup_orientation
    alias_method :attr_f_proposal_popup_orientation=, :f_proposal_popup_orientation=
    undef_method :f_proposal_popup_orientation=
    
    attr_accessor :f_context_info_popup_orientation
    alias_method :attr_f_context_info_popup_orientation, :f_context_info_popup_orientation
    undef_method :f_context_info_popup_orientation
    alias_method :attr_f_context_info_popup_orientation=, :f_context_info_popup_orientation=
    undef_method :f_context_info_popup_orientation=
    
    attr_accessor :f_processors
    alias_method :attr_f_processors, :f_processors
    undef_method :f_processors
    alias_method :attr_f_processors=, :f_processors=
    undef_method :f_processors=
    
    # The partitioning.
    # 
    # @since 3.0
    attr_accessor :f_partitioning
    alias_method :attr_f_partitioning, :f_partitioning
    undef_method :f_partitioning
    alias_method :attr_f_partitioning=, :f_partitioning=
    undef_method :f_partitioning=
    
    attr_accessor :f_context_info_popup_background
    alias_method :attr_f_context_info_popup_background, :f_context_info_popup_background
    undef_method :f_context_info_popup_background
    alias_method :attr_f_context_info_popup_background=, :f_context_info_popup_background=
    undef_method :f_context_info_popup_background=
    
    attr_accessor :f_context_info_popup_foreground
    alias_method :attr_f_context_info_popup_foreground, :f_context_info_popup_foreground
    undef_method :f_context_info_popup_foreground
    alias_method :attr_f_context_info_popup_foreground=, :f_context_info_popup_foreground=
    undef_method :f_context_info_popup_foreground=
    
    attr_accessor :f_context_selector_background
    alias_method :attr_f_context_selector_background, :f_context_selector_background
    undef_method :f_context_selector_background
    alias_method :attr_f_context_selector_background=, :f_context_selector_background=
    undef_method :f_context_selector_background=
    
    attr_accessor :f_context_selector_foreground
    alias_method :attr_f_context_selector_foreground, :f_context_selector_foreground
    undef_method :f_context_selector_foreground
    alias_method :attr_f_context_selector_foreground=, :f_context_selector_foreground=
    undef_method :f_context_selector_foreground=
    
    attr_accessor :f_proposal_selector_background
    alias_method :attr_f_proposal_selector_background, :f_proposal_selector_background
    undef_method :f_proposal_selector_background
    alias_method :attr_f_proposal_selector_background=, :f_proposal_selector_background=
    undef_method :f_proposal_selector_background=
    
    attr_accessor :f_proposal_selector_foreground
    alias_method :attr_f_proposal_selector_foreground, :f_proposal_selector_foreground
    undef_method :f_proposal_selector_foreground
    alias_method :attr_f_proposal_selector_foreground=, :f_proposal_selector_foreground=
    undef_method :f_proposal_selector_foreground=
    
    attr_accessor :f_viewer
    alias_method :attr_f_viewer, :f_viewer
    undef_method :f_viewer
    alias_method :attr_f_viewer=, :f_viewer=
    undef_method :f_viewer=
    
    attr_accessor :f_last_error_message
    alias_method :attr_f_last_error_message, :f_last_error_message
    undef_method :f_last_error_message
    alias_method :attr_f_last_error_message=, :f_last_error_message=
    undef_method :f_last_error_message=
    
    attr_accessor :f_closer
    alias_method :attr_f_closer, :f_closer
    undef_method :f_closer
    alias_method :attr_f_closer=, :f_closer=
    undef_method :f_closer=
    
    attr_accessor :f_layout_manager
    alias_method :attr_f_layout_manager, :f_layout_manager
    undef_method :f_layout_manager
    alias_method :attr_f_layout_manager=, :f_layout_manager=
    undef_method :f_layout_manager=
    
    attr_accessor :f_auto_assist_listener
    alias_method :attr_f_auto_assist_listener, :f_auto_assist_listener
    undef_method :f_auto_assist_listener
    alias_method :attr_f_auto_assist_listener=, :f_auto_assist_listener=
    undef_method :f_auto_assist_listener=
    
    attr_accessor :f_internal_listener
    alias_method :attr_f_internal_listener, :f_internal_listener
    undef_method :f_internal_listener
    alias_method :attr_f_internal_listener=, :f_internal_listener=
    undef_method :f_internal_listener=
    
    attr_accessor :f_proposal_popup
    alias_method :attr_f_proposal_popup, :f_proposal_popup
    undef_method :f_proposal_popup
    alias_method :attr_f_proposal_popup=, :f_proposal_popup=
    undef_method :f_proposal_popup=
    
    attr_accessor :f_context_info_popup
    alias_method :attr_f_context_info_popup, :f_context_info_popup
    undef_method :f_context_info_popup
    alias_method :attr_f_context_info_popup=, :f_context_info_popup=
    undef_method :f_context_info_popup=
    
    # Flag which tells whether a verify key listener is hooked.
    # 
    # @since 3.0
    attr_accessor :f_verify_key_listener_hooked
    alias_method :attr_f_verify_key_listener_hooked, :f_verify_key_listener_hooked
    undef_method :f_verify_key_listener_hooked
    alias_method :attr_f_verify_key_listener_hooked=, :f_verify_key_listener_hooked=
    undef_method :f_verify_key_listener_hooked=
    
    attr_accessor :f_listeners
    alias_method :attr_f_listeners, :f_listeners
    undef_method :f_listeners
    alias_method :attr_f_listeners=, :f_listeners=
    undef_method :f_listeners=
    
    # The content assist subject control.
    # 
    # @since 3.0
    attr_accessor :f_content_assist_subject_control
    alias_method :attr_f_content_assist_subject_control, :f_content_assist_subject_control
    undef_method :f_content_assist_subject_control
    alias_method :attr_f_content_assist_subject_control=, :f_content_assist_subject_control=
    undef_method :f_content_assist_subject_control=
    
    # The content assist subject control's shell.
    # 
    # @since 3.2
    attr_accessor :f_content_assist_subject_control_shell
    alias_method :attr_f_content_assist_subject_control_shell, :f_content_assist_subject_control_shell
    undef_method :f_content_assist_subject_control_shell
    alias_method :attr_f_content_assist_subject_control_shell=, :f_content_assist_subject_control_shell=
    undef_method :f_content_assist_subject_control_shell=
    
    # The content assist subject control's shell traverse listener.
    # 
    # @since 3.2
    attr_accessor :f_cascstraverse_listener
    alias_method :attr_f_cascstraverse_listener, :f_cascstraverse_listener
    undef_method :f_cascstraverse_listener
    alias_method :attr_f_cascstraverse_listener=, :f_cascstraverse_listener=
    undef_method :f_cascstraverse_listener=
    
    # The content assist subject control adapter.
    # 
    # @since 3.0
    attr_accessor :f_content_assist_subject_control_adapter
    alias_method :attr_f_content_assist_subject_control_adapter, :f_content_assist_subject_control_adapter
    undef_method :f_content_assist_subject_control_adapter
    alias_method :attr_f_content_assist_subject_control_adapter=, :f_content_assist_subject_control_adapter=
    undef_method :f_content_assist_subject_control_adapter=
    
    # The dialog settings for the control's bounds.
    # 
    # @since 3.0
    attr_accessor :f_dialog_settings
    alias_method :attr_f_dialog_settings, :f_dialog_settings
    undef_method :f_dialog_settings
    alias_method :attr_f_dialog_settings=, :f_dialog_settings=
    undef_method :f_dialog_settings=
    
    # Prefix completion setting.
    # 
    # @since 3.0
    attr_accessor :f_is_prefix_completion_enabled
    alias_method :attr_f_is_prefix_completion_enabled, :f_is_prefix_completion_enabled
    undef_method :f_is_prefix_completion_enabled
    alias_method :attr_f_is_prefix_completion_enabled=, :f_is_prefix_completion_enabled=
    undef_method :f_is_prefix_completion_enabled=
    
    # The list of completion listeners.
    # 
    # @since 3.2
    attr_accessor :f_completion_listeners
    alias_method :attr_f_completion_listeners, :f_completion_listeners
    undef_method :f_completion_listeners
    alias_method :attr_f_completion_listeners=, :f_completion_listeners=
    undef_method :f_completion_listeners=
    
    # The message to display at the bottom of the proposal popup.
    # 
    # @since 3.2
    attr_accessor :f_message
    alias_method :attr_f_message, :f_message
    undef_method :f_message
    alias_method :attr_f_message=, :f_message=
    undef_method :f_message=
    
    # $NON-NLS-1$
    # 
    # The cycling mode property.
    # 
    # @since 3.2
    attr_accessor :f_is_repetition_mode
    alias_method :attr_f_is_repetition_mode, :f_is_repetition_mode
    undef_method :f_is_repetition_mode
    alias_method :attr_f_is_repetition_mode=, :f_is_repetition_mode=
    undef_method :f_is_repetition_mode=
    
    # The show empty property.
    # 
    # @since 3.2
    attr_accessor :f_show_empty_list
    alias_method :attr_f_show_empty_list, :f_show_empty_list
    undef_method :f_show_empty_list
    alias_method :attr_f_show_empty_list=, :f_show_empty_list=
    undef_method :f_show_empty_list=
    
    # The message line property.
    # 
    # @since 3.2
    attr_accessor :f_is_status_line_visible
    alias_method :attr_f_is_status_line_visible, :f_is_status_line_visible
    undef_method :f_is_status_line_visible
    alias_method :attr_f_is_status_line_visible=, :f_is_status_line_visible=
    undef_method :f_is_status_line_visible=
    
    # The last system time when auto activation performed.
    # 
    # @since 3.2
    attr_accessor :f_last_auto_activation
    alias_method :attr_f_last_auto_activation, :f_last_auto_activation
    undef_method :f_last_auto_activation
    alias_method :attr_f_last_auto_activation=, :f_last_auto_activation=
    undef_method :f_last_auto_activation=
    
    # The iteration key sequence to listen for, or <code>null</code>.
    # 
    # @since 3.2
    attr_accessor :f_repeated_invocation_key_sequence
    alias_method :attr_f_repeated_invocation_key_sequence, :f_repeated_invocation_key_sequence
    undef_method :f_repeated_invocation_key_sequence
    alias_method :attr_f_repeated_invocation_key_sequence=, :f_repeated_invocation_key_sequence=
    undef_method :f_repeated_invocation_key_sequence=
    
    # Maps handler to command identifiers.
    # 
    # @since 3.4
    attr_accessor :f_handlers
    alias_method :attr_f_handlers, :f_handlers
    undef_method :f_handlers
    alias_method :attr_f_handlers=, :f_handlers=
    undef_method :f_handlers=
    
    # Tells whether colored labels support is enabled.
    # 
    # @since 3.4
    attr_accessor :f_is_colored_labels_support_enabled
    alias_method :attr_f_is_colored_labels_support_enabled, :f_is_colored_labels_support_enabled
    undef_method :f_is_colored_labels_support_enabled
    alias_method :attr_f_is_colored_labels_support_enabled=, :f_is_colored_labels_support_enabled=
    undef_method :f_is_colored_labels_support_enabled=
    
    typesig { [] }
    # Creates a new content assistant. The content assistant is not automatically activated,
    # overlays the completion proposals with context information list if necessary, and shows the
    # context information above the location at which it was activated. If auto activation will be
    # enabled, without further configuration steps, this content assistant is activated after a 500
    # milliseconds delay. It uses the default partitioning.
    def initialize
      @f_information_control_creator = nil
      @f_auto_activation_delay = DEFAULT_AUTO_ACTIVATION_DELAY
      @f_is_auto_activated = false
      @f_is_auto_inserting = false
      @f_proposal_popup_orientation = PROPOSAL_OVERLAY
      @f_context_info_popup_orientation = CONTEXT_INFO_ABOVE
      @f_processors = nil
      @f_partitioning = nil
      @f_context_info_popup_background = nil
      @f_context_info_popup_foreground = nil
      @f_context_selector_background = nil
      @f_context_selector_foreground = nil
      @f_proposal_selector_background = nil
      @f_proposal_selector_foreground = nil
      @f_viewer = nil
      @f_last_error_message = nil
      @f_closer = nil
      @f_layout_manager = nil
      @f_auto_assist_listener = nil
      @f_internal_listener = nil
      @f_proposal_popup = nil
      @f_context_info_popup = nil
      @f_verify_key_listener_hooked = false
      @f_listeners = Array.typed(IContentAssistListener).new(4) { nil }
      @f_content_assist_subject_control = nil
      @f_content_assist_subject_control_shell = nil
      @f_cascstraverse_listener = nil
      @f_content_assist_subject_control_adapter = nil
      @f_dialog_settings = nil
      @f_is_prefix_completion_enabled = false
      @f_completion_listeners = ListenerList.new(ListenerList::IDENTITY)
      @f_message = ""
      @f_is_repetition_mode = false
      @f_show_empty_list = false
      @f_is_status_line_visible = false
      @f_last_auto_activation = Long::MIN_VALUE
      @f_repeated_invocation_key_sequence = nil
      @f_handlers = nil
      @f_is_colored_labels_support_enabled = false
      @f_partitioning = RJava.cast_to_string(IDocumentExtension3::DEFAULT_PARTITIONING)
    end
    
    typesig { [String] }
    # Sets the document partitioning this content assistant is using.
    # 
    # @param partitioning the document partitioning for this content assistant
    # @since 3.0
    def set_document_partitioning(partitioning)
      Assert.is_not_null(partitioning)
      @f_partitioning = partitioning
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.contentassist.IContentAssistantExtension#getDocumentPartitioning()
    # @since 3.0
    def get_document_partitioning
      return @f_partitioning
    end
    
    typesig { [IContentAssistProcessor, String] }
    # Registers a given content assist processor for a particular content type. If there is already
    # a processor registered for this type, the new processor is registered instead of the old one.
    # 
    # @param processor the content assist processor to register, or <code>null</code> to remove
    # an existing one
    # @param contentType the content type under which to register
    def set_content_assist_processor(processor, content_type)
      Assert.is_not_null(content_type)
      if ((@f_processors).nil?)
        @f_processors = HashMap.new
      end
      if ((processor).nil?)
        @f_processors.remove(content_type)
      else
        @f_processors.put(content_type, processor)
      end
    end
    
    typesig { [String] }
    # @see IContentAssistant#getContentAssistProcessor
    def get_content_assist_processor(content_type)
      if ((@f_processors).nil?)
        return nil
      end
      return @f_processors.get(content_type)
    end
    
    typesig { [] }
    # Computes the sorted set of all auto activation trigger characters.
    # 
    # @return the sorted set of all auto activation trigger characters
    # @since 3.1
    def compute_all_auto_activation_triggers
      if ((@f_processors).nil?)
        return ""
      end # $NON-NLS-1$
      buf = StringBuffer.new(5)
      iter = @f_processors.entry_set.iterator
      while (iter.has_next)
        entry = iter.next_
        processor = entry.get_value
        triggers = processor.get_completion_proposal_auto_activation_characters
        if (!(triggers).nil?)
          buf.append(triggers)
        end
        triggers = processor.get_context_information_auto_activation_characters
        if (!(triggers).nil?)
          buf.append(triggers)
        end
      end
      return buf.to_s
    end
    
    typesig { [::Java::Boolean] }
    # Enables the content assistant's auto activation mode.
    # 
    # @param enabled indicates whether auto activation is enabled or not
    def enable_auto_activation(enabled)
      @f_is_auto_activated = enabled
      manage_auto_activation(@f_is_auto_activated)
    end
    
    typesig { [::Java::Boolean] }
    # Enables the content assistant's auto insertion mode. If enabled, the content assistant
    # inserts a proposal automatically if it is the only proposal. In the case of ambiguities, the
    # user must make the choice.
    # 
    # @param enabled indicates whether auto insertion is enabled or not
    # @since 2.0
    def enable_auto_insert(enabled)
      @f_is_auto_inserting = enabled
    end
    
    typesig { [] }
    # Returns whether this content assistant is in the auto insertion mode or not.
    # 
    # @return <code>true</code> if in auto insertion mode
    # @since 2.0
    def is_auto_inserting
      return @f_is_auto_inserting
    end
    
    typesig { [::Java::Boolean] }
    # Installs and uninstall the listeners needed for auto activation.
    # 
    # @param start <code>true</code> if listeners must be installed, <code>false</code> if they
    # must be removed
    # @since 2.0
    def manage_auto_activation(start)
      if (start)
        if ((!(@f_content_assist_subject_control_adapter).nil?) && (@f_auto_assist_listener).nil?)
          @f_auto_assist_listener = create_auto_assist_listener
          # For details see https://bugs.eclipse.org/bugs/show_bug.cgi?id=49212
          if (@f_content_assist_subject_control_adapter.supports_verify_key_listener)
            @f_content_assist_subject_control_adapter.append_verify_key_listener(@f_auto_assist_listener)
          else
            @f_content_assist_subject_control_adapter.add_key_listener(@f_auto_assist_listener)
          end
        end
      else
        if (!(@f_auto_assist_listener).nil?)
          # For details see: https://bugs.eclipse.org/bugs/show_bug.cgi?id=49212
          if (@f_content_assist_subject_control_adapter.supports_verify_key_listener)
            @f_content_assist_subject_control_adapter.remove_verify_key_listener(@f_auto_assist_listener)
          else
            @f_content_assist_subject_control_adapter.remove_key_listener(@f_auto_assist_listener)
          end
          @f_auto_assist_listener = nil
        end
      end
    end
    
    typesig { [] }
    # This method allows subclasses to provide their own {@link AutoAssistListener}.
    # 
    # @return a new auto assist listener
    # @since 3.4
    def create_auto_assist_listener
      return AutoAssistListener.new_local(self)
    end
    
    typesig { [::Java::Int] }
    # Sets the delay after which the content assistant is automatically invoked if the cursor is
    # behind an auto activation character.
    # 
    # @param delay the auto activation delay
    def set_auto_activation_delay(delay)
      @f_auto_activation_delay = delay
    end
    
    typesig { [] }
    # Gets the delay after which the content assistant is automatically invoked if the cursor is
    # behind an auto activation character.
    # 
    # @return the auto activation delay
    # @since 3.4
    def get_auto_activation_delay
      return @f_auto_activation_delay
    end
    
    typesig { [::Java::Int] }
    # Sets the proposal pop-ups' orientation. The following values may be used:
    # <ul>
    # <li>PROPOSAL_OVERLAY<p>
    # proposal popup windows should overlay each other
    # </li>
    # <li>PROPOSAL_REMOVE<p>
    # any currently shown proposal popup should be closed
    # </li>
    # <li>PROPOSAL_STACKED<p>
    # proposal popup windows should be vertical stacked, with no overlap,
    # beneath the line containing the current cursor location
    # </li>
    # </ul>
    # 
    # @param orientation the popup's orientation
    def set_proposal_popup_orientation(orientation)
      @f_proposal_popup_orientation = orientation
    end
    
    typesig { [::Java::Int] }
    # Sets the context information popup's orientation.
    # The following values may be used:
    # <ul>
    # <li>CONTEXT_ABOVE<p>
    # context information popup should always appear above the line containing
    # the current cursor location
    # </li>
    # <li>CONTEXT_BELOW<p>
    # context information popup should always appear below the line containing
    # the current cursor location
    # </li>
    # </ul>
    # 
    # @param orientation the popup's orientation
    def set_context_information_popup_orientation(orientation)
      @f_context_info_popup_orientation = orientation
    end
    
    typesig { [Color] }
    # Sets the context information popup's background color.
    # 
    # @param background the background color
    def set_context_information_popup_background(background)
      @f_context_info_popup_background = background
    end
    
    typesig { [] }
    # Returns the background of the context information popup.
    # 
    # @return the background of the context information popup
    # @since 2.0
    def get_context_information_popup_background
      return @f_context_info_popup_background
    end
    
    typesig { [Color] }
    # Sets the context information popup's foreground color.
    # 
    # @param foreground the foreground color
    # @since 2.0
    def set_context_information_popup_foreground(foreground)
      @f_context_info_popup_foreground = foreground
    end
    
    typesig { [] }
    # Returns the foreground of the context information popup.
    # 
    # 
    # @return the foreground of the context information popup
    # @since 2.0
    def get_context_information_popup_foreground
      return @f_context_info_popup_foreground
    end
    
    typesig { [Color] }
    # Sets the proposal selector's background color.
    # <p>
    # <strong>Note:</strong> As of 3.4, you should only call this
    # method if you want to override the {@link JFacePreferences#CONTENT_ASSIST_BACKGROUND_COLOR}.
    # </p>
    # 
    # @param background the background color
    # @since 2.0
    def set_proposal_selector_background(background)
      @f_proposal_selector_background = background
    end
    
    typesig { [] }
    # Returns the custom background color of the proposal selector.
    # 
    # @return the background of the proposal selector or <code>null</code> if not set
    # @since 2.0
    def get_proposal_selector_background
      return @f_proposal_selector_background
    end
    
    typesig { [Color] }
    # Sets the proposal's foreground color.
    # <p>
    # <strong>Note:</strong> As of 3.4, you should only call this
    # method if you want to override the {@link JFacePreferences#CONTENT_ASSIST_FOREGROUND_COLOR}.
    # </p>
    # 
    # @param foreground the foreground color
    # @since 2.0
    def set_proposal_selector_foreground(foreground)
      @f_proposal_selector_foreground = foreground
    end
    
    typesig { [] }
    # Returns the custom foreground color of the proposal selector.
    # 
    # @return the foreground of the proposal selector or <code>null</code> if not set
    # @since 2.0
    def get_proposal_selector_foreground
      return @f_proposal_selector_foreground
    end
    
    typesig { [Color] }
    # Sets the context selector's background color.
    # 
    # @param background the background color
    # @since 2.0
    def set_context_selector_background(background)
      @f_context_selector_background = background
    end
    
    typesig { [] }
    # Returns the background of the context selector.
    # 
    # @return the background of the context selector
    # @since 2.0
    def get_context_selector_background
      return @f_context_selector_background
    end
    
    typesig { [Color] }
    # Sets the context selector's foreground color.
    # 
    # @param foreground the foreground color
    # @since 2.0
    def set_context_selector_foreground(foreground)
      @f_context_selector_foreground = foreground
    end
    
    typesig { [] }
    # Returns the foreground of the context selector.
    # 
    # @return the foreground of the context selector
    # @since 2.0
    def get_context_selector_foreground
      return @f_context_selector_foreground
    end
    
    typesig { [IInformationControlCreator] }
    # Sets the information control creator for the additional information control.
    # 
    # @param creator the information control creator for the additional information control
    # @since 2.0
    def set_information_control_creator(creator)
      @f_information_control_creator = creator
    end
    
    typesig { [IContentAssistSubjectControl] }
    # @see IControlContentAssistant#install(IContentAssistSubjectControl)
    # @since 3.0
    def install(content_assist_subject_control)
      @f_content_assist_subject_control = content_assist_subject_control
      @f_content_assist_subject_control_adapter = ContentAssistSubjectControlAdapter.new(@f_content_assist_subject_control)
      install
    end
    
    typesig { [ITextViewer] }
    # @see IContentAssist#install
    # @since 3.0
    def install(text_viewer)
      @f_viewer = text_viewer
      @f_content_assist_subject_control_adapter = ContentAssistSubjectControlAdapter.new(@f_viewer)
      install
    end
    
    typesig { [] }
    def install
      @f_layout_manager = LayoutManager.new_local(self)
      @f_internal_listener = InternalListener.new_local(self)
      controller = nil
      if (!(@f_information_control_creator).nil?)
        delay = @f_auto_activation_delay
        if ((delay).equal?(0))
          delay = DEFAULT_AUTO_ACTIVATION_DELAY
        end
        delay = Math.round(delay * 1.5)
        controller = AdditionalInfoController.new(@f_information_control_creator, delay)
      end
      @f_context_info_popup = @f_content_assist_subject_control_adapter.create_context_info_popup(self)
      @f_proposal_popup = @f_content_assist_subject_control_adapter.create_completion_proposal_popup(self, controller)
      register_handler(SELECT_NEXT_PROPOSAL_COMMAND_ID, @f_proposal_popup.create_proposal_selection_handler(CompletionProposalPopup::ProposalSelectionHandler::SELECT_NEXT))
      register_handler(SELECT_PREVIOUS_PROPOSAL_COMMAND_ID, @f_proposal_popup.create_proposal_selection_handler(CompletionProposalPopup::ProposalSelectionHandler::SELECT_PREVIOUS))
      if (Helper.ok_to_use(@f_content_assist_subject_control_adapter.get_control))
        @f_content_assist_subject_control_shell = @f_content_assist_subject_control_adapter.get_control.get_shell
        @f_cascstraverse_listener = Class.new(TraverseListener.class == Class ? TraverseListener : Object) do
          local_class_in ContentAssistant
          include_class_members ContentAssistant
          include TraverseListener if TraverseListener.class == Module
          
          typesig { [TraverseEvent] }
          define_method :key_traversed do |e|
            if ((e.attr_detail).equal?(SWT::TRAVERSE_ESCAPE) && is_proposal_popup_active)
              e.attr_doit = false
            end
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self)
        @f_content_assist_subject_control_shell.add_traverse_listener(@f_cascstraverse_listener)
      end
      manage_auto_activation(@f_is_auto_activated)
    end
    
    typesig { [] }
    # @see IContentAssist#uninstall
    def uninstall
      hide
      manage_auto_activation(false)
      if (!(@f_handlers).nil?)
        @f_handlers.clear
        @f_handlers = nil
      end
      if (!(@f_closer).nil?)
        @f_closer.uninstall
        @f_closer = nil
      end
      if (Helper.ok_to_use(@f_content_assist_subject_control_shell))
        @f_content_assist_subject_control_shell.remove_traverse_listener(@f_cascstraverse_listener)
      end
      @f_cascstraverse_listener = nil
      @f_content_assist_subject_control_shell = nil
      @f_viewer = nil
      @f_content_assist_subject_control = nil
      @f_content_assist_subject_control_adapter = nil
    end
    
    typesig { [Object, Shell, ::Java::Int, ::Java::Int] }
    # Adds the given shell of the specified type to the layout. Valid types are defined by
    # <code>LayoutManager</code>.
    # 
    # @param popup a content assist popup
    # @param shell the shell of the content-assist popup
    # @param type the type of popup
    # @param visibleOffset the offset at which to layout the popup relative to the offset of the
    # viewer's visible region
    # @since 2.0
    def add_to_layout(popup, shell, type, visible_offset)
      @f_layout_manager.add(popup, shell, type, visible_offset)
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Layouts the registered popup of the given type relative to the given offset. The offset is
    # relative to the offset of the viewer's visible region. Valid types are defined by
    # <code>LayoutManager</code>.
    # 
    # @param type the type of popup to layout
    # @param visibleOffset the offset at which to layout relative to the offset of the viewer's
    # visible region
    # @since 2.0
    def layout(type, visible_offset)
      @f_layout_manager.layout(type, visible_offset)
    end
    
    typesig { [] }
    # Returns the layout manager.
    # 
    # @return the layout manager
    # @since 3.3
    def get_layout_manager
      return @f_layout_manager
    end
    
    typesig { [FocusEvent] }
    # Notifies the controller that a popup has lost focus.
    # 
    # @param e the focus event
    def popup_focus_lost(e)
      @f_closer.focus_lost(e)
    end
    
    typesig { [] }
    # Returns the offset of the selection relative to the offset of the visible region.
    # 
    # @return the offset of the selection relative to the offset of the visible region
    # @since 2.0
    def get_selection_offset
      return @f_content_assist_subject_control_adapter.get_widget_selection_range.attr_x
    end
    
    typesig { [::Java::Int] }
    # Returns whether the widget token could be acquired. The following are valid listener types:
    # <ul>
    # <li>AUTO_ASSIST</li>
    # <li>CONTEXT_SELECTOR</li>
    # <li>PROPOSAL_SELECTOR</li>
    # <li>CONTEXT_INFO_POPUP</li>
    # </ul>
    # 
    # @param type the listener type for which to acquire
    # @return <code>true</code> if the widget token could be acquired
    # @since 2.0
    def acquire_widget_token(type)
      case (type)
      when CONTEXT_SELECTOR, PROPOSAL_SELECTOR
        if (@f_content_assist_subject_control.is_a?(IWidgetTokenOwnerExtension))
          extension = @f_content_assist_subject_control
          return extension.request_widget_token(self, WIDGET_PRIORITY)
        else
          if (@f_content_assist_subject_control.is_a?(IWidgetTokenOwner))
            owner = @f_content_assist_subject_control
            return owner.request_widget_token(self)
          else
            if (@f_viewer.is_a?(IWidgetTokenOwnerExtension))
              extension = @f_viewer
              return extension.request_widget_token(self, WIDGET_PRIORITY)
            else
              if (@f_viewer.is_a?(IWidgetTokenOwner))
                owner = @f_viewer
                return owner.request_widget_token(self)
              end
            end
          end
        end
      end
      return true
    end
    
    typesig { [IContentAssistListener, ::Java::Int] }
    # Registers a content assist listener. The following are valid listener types:
    # <ul>
    # <li>AUTO_ASSIST</li>
    # <li>CONTEXT_SELECTOR</li>
    # <li>PROPOSAL_SELECTOR</li>
    # <li>CONTEXT_INFO_POPUP</li>
    # </ul>
    # Returns whether the listener could be added successfully. A listener can not be added if the
    # widget token could not be acquired.
    # 
    # @param listener the listener to register
    # @param type the type of listener
    # @return <code>true</code> if the listener could be added
    def add_content_assist_listener(listener, type)
      if (acquire_widget_token(type))
        @f_listeners[type] = listener
        if ((@f_closer).nil? && (get_number_of_listeners).equal?(1))
          @f_closer = Closer.new_local(self)
          @f_closer.install
          @f_content_assist_subject_control_adapter.set_event_consumer(@f_internal_listener)
          install_key_listener
        else
          promote_key_listener
        end
        return true
      end
      return false
    end
    
    typesig { [] }
    # Re-promotes the key listener to the first position, using prependVerifyKeyListener. This
    # ensures no other instance is filtering away the keystrokes underneath, if we've been up for a
    # while (e.g. when the context info is showing.
    # 
    # @since 3.0
    def promote_key_listener
      uninstall_verify_key_listener
      install_key_listener
    end
    
    typesig { [] }
    # Installs a key listener on the text viewer's widget.
    def install_key_listener
      if (!@f_verify_key_listener_hooked)
        if (Helper.ok_to_use(@f_content_assist_subject_control_adapter.get_control))
          @f_verify_key_listener_hooked = @f_content_assist_subject_control_adapter.prepend_verify_key_listener(@f_internal_listener)
        end
      end
    end
    
    typesig { [::Java::Int] }
    # Releases the previously acquired widget token if the token is no longer necessary. The
    # following are valid listener types:
    # <ul>
    # <li>AUTO_ASSIST</li>
    # <li>CONTEXT_SELECTOR</li>
    # <li>PROPOSAL_SELECTOR</li>
    # <li>CONTEXT_INFO_POPUP</li>
    # </ul>
    # 
    # @param type the listener type
    # @since 2.0
    def release_widget_token(type)
      if ((@f_listeners[CONTEXT_SELECTOR]).nil? && (@f_listeners[PROPOSAL_SELECTOR]).nil?)
        owner = nil
        if (@f_content_assist_subject_control.is_a?(IWidgetTokenOwner))
          owner = @f_content_assist_subject_control
        else
          if (@f_viewer.is_a?(IWidgetTokenOwner))
            owner = @f_viewer
          end
        end
        if (!(owner).nil?)
          owner.release_widget_token(self)
        end
      end
    end
    
    typesig { [IContentAssistListener, ::Java::Int] }
    # Unregisters a content assist listener.
    # 
    # @param listener the listener to unregister
    # @param type the type of listener
    # @see #addContentAssistListener(IContentAssistListener, int)
    def remove_content_assist_listener(listener, type)
      @f_listeners[type] = nil
      if ((get_number_of_listeners).equal?(0))
        if (!(@f_closer).nil?)
          @f_closer.uninstall
          @f_closer = nil
        end
        uninstall_verify_key_listener
        @f_content_assist_subject_control_adapter.set_event_consumer(nil)
      end
      release_widget_token(type)
    end
    
    typesig { [] }
    # Uninstall the key listener from the text viewer's widget.
    # 
    # @since 3.0
    def uninstall_verify_key_listener
      if (@f_verify_key_listener_hooked)
        if (Helper.ok_to_use(@f_content_assist_subject_control_adapter.get_control))
          @f_content_assist_subject_control_adapter.remove_verify_key_listener(@f_internal_listener)
        end
        @f_verify_key_listener_hooked = false
      end
    end
    
    typesig { [] }
    # Returns the number of listeners.
    # 
    # @return the number of listeners
    # @since 2.0
    def get_number_of_listeners
      count = 0
      i = 0
      while i <= CONTEXT_INFO_POPUP
        if (!(@f_listeners[i]).nil?)
          (count += 1)
        end
        i += 1
      end
      return count
    end
    
    typesig { [] }
    # @see IContentAssist#showPossibleCompletions
    def show_possible_completions
      if (!prepare_to_show_completions(false))
        return nil
      end
      if (@f_is_prefix_completion_enabled)
        return @f_proposal_popup.incremental_complete
      end
      return @f_proposal_popup.show_proposals(false)
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.contentassist.IContentAssistantExtension#completePrefix()
    # @since 3.0
    def complete_prefix
      if (!prepare_to_show_completions(false))
        return nil
      end
      return @f_proposal_popup.incremental_complete
    end
    
    typesig { [::Java::Boolean] }
    # Prepares to show content assist proposals. It returns false if auto activation has kicked in
    # recently.
    # 
    # @param isAutoActivated  whether completion was triggered by auto activation
    # @return <code>true</code> if the caller should continue and show the proposals,
    # <code>false</code> otherwise.
    # @since 3.2
    def prepare_to_show_completions(is_auto_activated)
      current = System.current_time_millis
      grace_period = Math.max(@f_auto_activation_delay, 200)
      if (current < @f_last_auto_activation + grace_period)
        return false
      end
      promote_key_listener
      fire_session_begin_event(is_auto_activated)
      return true
    end
    
    typesig { [] }
    # Callback to signal this content assistant that the presentation of the possible completions
    # has been stopped.
    # 
    # @since 2.1
    def possible_completions_closed
      @f_last_auto_activation = Long::MIN_VALUE
      store_completion_proposal_popup_size
    end
    
    typesig { [] }
    # @see IContentAssist#showContextInformation
    def show_context_information
      promote_key_listener
      if (!(@f_context_info_popup).nil?)
        return @f_context_info_popup.show_context_proposals(false)
      end
      return nil
    end
    
    typesig { [] }
    # Callback to signal this content assistant that the presentation of the context information
    # has been stopped.
    # 
    # @since 2.1
    def context_information_closed
    end
    
    typesig { [IContextInformation, ::Java::Int] }
    # Requests that the specified context information to be shown.
    # 
    # @param contextInformation the context information to be shown
    # @param offset the offset to which the context information refers to
    # @since 2.0
    def show_context_information(context_information, offset)
      if (!(@f_context_info_popup).nil?)
        @f_context_info_popup.show_context_information(context_information, offset)
      end
    end
    
    typesig { [] }
    # Returns the current content assist error message.
    # 
    # @return an error message or <code>null</code> if no error has occurred
    def get_error_message
      return @f_last_error_message
    end
    
    typesig { [ITextViewer, ::Java::Int] }
    # Returns the content assist processor for the content type of the specified document position.
    # 
    # @param viewer the text viewer
    # @param offset a offset within the document
    # @return a content-assist processor or <code>null</code> if none exists
    # @since 3.0
    def get_processor(viewer, offset)
      begin
        document = viewer.get_document
        type = TextUtilities.get_content_type(document, get_document_partitioning, offset, true)
        return get_content_assist_processor(type)
      rescue BadLocationException => x
      end
      return nil
    end
    
    typesig { [IContentAssistSubjectControl, ::Java::Int] }
    # Returns the content assist processor for the content type of the specified document position.
    # 
    # @param contentAssistSubjectControl the content assist subject control
    # @param offset a offset within the document
    # @return a content-assist processor or <code>null</code> if none exists
    # @since 3.0
    def get_processor(content_assist_subject_control, offset)
      begin
        document = content_assist_subject_control.get_document
        type = nil
        if (!(document).nil?)
          type = RJava.cast_to_string(TextUtilities.get_content_type(document, get_document_partitioning, offset, true))
        else
          type = RJava.cast_to_string(IDocument::DEFAULT_CONTENT_TYPE)
        end
        return get_content_assist_processor(type)
      rescue BadLocationException => x
      end
      return nil
    end
    
    typesig { [IContentAssistSubjectControl, ::Java::Int] }
    # Returns an array of completion proposals computed based on the specified document position.
    # The position is used to determine the appropriate content assist processor to invoke.
    # 
    # @param contentAssistSubjectControl the content assist subject control
    # @param offset a document offset
    # @return an array of completion proposals
    # @see IContentAssistProcessor#computeCompletionProposals(ITextViewer, int)
    # @since 3.0
    def compute_completion_proposals(content_assist_subject_control, offset)
      @f_last_error_message = RJava.cast_to_string(nil)
      result = nil
      p = get_processor(content_assist_subject_control, offset)
      if (p.is_a?(ISubjectControlContentAssistProcessor))
        result = (p).compute_completion_proposals(content_assist_subject_control, offset)
        @f_last_error_message = RJava.cast_to_string(p.get_error_message)
      end
      return result
    end
    
    typesig { [ITextViewer, ::Java::Int] }
    # Returns an array of completion proposals computed based on the specified document position.
    # The position is used to determine the appropriate content assist processor to invoke.
    # 
    # @param viewer the viewer for which to compute the proposals
    # @param offset a document offset
    # @return an array of completion proposals or <code>null</code> if no proposals are possible
    # @see IContentAssistProcessor#computeCompletionProposals(ITextViewer, int)
    def compute_completion_proposals(viewer, offset)
      @f_last_error_message = RJava.cast_to_string(nil)
      result = nil
      p = get_processor(viewer, offset)
      if (!(p).nil?)
        result = p.compute_completion_proposals(viewer, offset)
        @f_last_error_message = RJava.cast_to_string(p.get_error_message)
      end
      return result
    end
    
    typesig { [ITextViewer, ::Java::Int] }
    # Returns an array of context information objects computed based on the specified document
    # position. The position is used to determine the appropriate content assist processor to
    # invoke.
    # 
    # @param viewer the viewer for which to compute the context information
    # @param offset a document offset
    # @return an array of context information objects
    # @see IContentAssistProcessor#computeContextInformation(ITextViewer, int)
    def compute_context_information(viewer, offset)
      @f_last_error_message = RJava.cast_to_string(nil)
      result = nil
      p = get_processor(viewer, offset)
      if (!(p).nil?)
        result = p.compute_context_information(viewer, offset)
        @f_last_error_message = RJava.cast_to_string(p.get_error_message)
      end
      return result
    end
    
    typesig { [IContentAssistSubjectControl, ::Java::Int] }
    # Returns an array of context information objects computed based on the specified document
    # position. The position is used to determine the appropriate content assist processor to
    # invoke.
    # 
    # @param contentAssistSubjectControl the content assist subject control
    # @param offset a document offset
    # @return an array of context information objects
    # @see IContentAssistProcessor#computeContextInformation(ITextViewer, int)
    # @since 3.0
    def compute_context_information(content_assist_subject_control, offset)
      @f_last_error_message = RJava.cast_to_string(nil)
      result = nil
      p = get_processor(content_assist_subject_control, offset)
      if (p.is_a?(ISubjectControlContentAssistProcessor))
        result = (p).compute_context_information(content_assist_subject_control, offset)
        @f_last_error_message = RJava.cast_to_string(p.get_error_message)
      end
      return result
    end
    
    typesig { [ITextViewer, ::Java::Int] }
    # Returns the context information validator that should be used to determine when the currently
    # displayed context information should be dismissed. The position is used to determine the
    # appropriate content assist processor to invoke.
    # 
    # @param viewer the text viewer
    # @param offset a document offset
    # @return an validator
    # @see IContentAssistProcessor#getContextInformationValidator()
    # @since 3.0
    def get_context_information_validator(viewer, offset)
      p = get_processor(viewer, offset)
      return !(p).nil? ? p.get_context_information_validator : nil
    end
    
    typesig { [IContentAssistSubjectControl, ::Java::Int] }
    # Returns the context information validator that should be used to determine when the currently
    # displayed context information should be dismissed. The position is used to determine the
    # appropriate content assist processor to invoke.
    # 
    # @param contentAssistSubjectControl the content assist subject control
    # @param offset a document offset
    # @return an validator
    # @see IContentAssistProcessor#getContextInformationValidator()
    # @since 3.0
    def get_context_information_validator(content_assist_subject_control, offset)
      p = get_processor(content_assist_subject_control, offset)
      return !(p).nil? ? p.get_context_information_validator : nil
    end
    
    typesig { [ITextViewer, ::Java::Int] }
    # Returns the context information presenter that should be used to display context information.
    # The position is used to determine the appropriate content assist processor to invoke.
    # 
    # @param viewer the text viewer
    # @param offset a document offset
    # @return a presenter
    # @since 2.0
    def get_context_information_presenter(viewer, offset)
      validator = get_context_information_validator(viewer, offset)
      if (validator.is_a?(IContextInformationPresenter))
        return validator
      end
      return nil
    end
    
    typesig { [IContentAssistSubjectControl, ::Java::Int] }
    # Returns the context information presenter that should be used to display context information.
    # The position is used to determine the appropriate content assist processor to invoke.
    # 
    # @param contentAssistSubjectControl the content assist subject control
    # @param offset a document offset
    # @return a presenter
    # @since 3.0
    def get_context_information_presenter(content_assist_subject_control, offset)
      validator = get_context_information_validator(content_assist_subject_control, offset)
      if (validator.is_a?(IContextInformationPresenter))
        return validator
      end
      return nil
    end
    
    typesig { [IContentAssistSubjectControl, ::Java::Int] }
    # Returns the characters which when typed by the user should automatically initiate proposing
    # completions. The position is used to determine the appropriate content assist processor to
    # invoke.
    # 
    # @param contentAssistSubjectControl the content assist subject control
    # @param offset a document offset
    # @return the auto activation characters
    # @see IContentAssistProcessor#getCompletionProposalAutoActivationCharacters()
    # @since 3.0
    def get_completion_proposal_auto_activation_characters(content_assist_subject_control, offset)
      p = get_processor(content_assist_subject_control, offset)
      return !(p).nil? ? p.get_completion_proposal_auto_activation_characters : nil
    end
    
    typesig { [ITextViewer, ::Java::Int] }
    # Returns the characters which when typed by the user should automatically initiate proposing
    # completions. The position is used to determine the appropriate content assist processor to
    # invoke.
    # 
    # @param viewer the text viewer
    # @param offset a document offset
    # @return the auto activation characters
    # @see IContentAssistProcessor#getCompletionProposalAutoActivationCharacters()
    def get_completion_proposal_auto_activation_characters(viewer, offset)
      p = get_processor(viewer, offset)
      return !(p).nil? ? p.get_completion_proposal_auto_activation_characters : nil
    end
    
    typesig { [ITextViewer, ::Java::Int] }
    # Returns the characters which when typed by the user should automatically initiate the
    # presentation of context information. The position is used to determine the appropriate
    # content assist processor to invoke.
    # 
    # @param viewer the text viewer
    # @param offset a document offset
    # @return the auto activation characters
    # @see IContentAssistProcessor#getContextInformationAutoActivationCharacters()
    # @since 3.0
    def get_context_information_auto_activation_characters(viewer, offset)
      p = get_processor(viewer, offset)
      return !(p).nil? ? p.get_context_information_auto_activation_characters : nil
    end
    
    typesig { [IContentAssistSubjectControl, ::Java::Int] }
    # Returns the characters which when typed by the user should automatically initiate the
    # presentation of context information. The position is used to determine the appropriate
    # content assist processor to invoke.
    # 
    # @param contentAssistSubjectControl the content assist subject control
    # @param offset a document offset
    # @return the auto activation characters
    # @see IContentAssistProcessor#getContextInformationAutoActivationCharacters()
    # @since 3.0
    def get_context_information_auto_activation_characters(content_assist_subject_control, offset)
      p = get_processor(content_assist_subject_control, offset)
      return !(p).nil? ? p.get_context_information_auto_activation_characters : nil
    end
    
    typesig { [IWidgetTokenOwner] }
    # @see org.eclipse.jface.text.IWidgetTokenKeeper#requestWidgetToken(IWidgetTokenOwner)
    # @since 2.0
    def request_widget_token(owner)
      return false
    end
    
    typesig { [IWidgetTokenOwner, ::Java::Int] }
    # @see org.eclipse.jface.text.IWidgetTokenKeeperExtension#requestWidgetToken(org.eclipse.jface.text.IWidgetTokenOwner,
    # int)
    # @since 3.0
    def request_widget_token(owner, priority)
      if (priority > WIDGET_PRIORITY)
        hide
        return true
      end
      return false
    end
    
    typesig { [IWidgetTokenOwner] }
    # @see org.eclipse.jface.text.IWidgetTokenKeeperExtension#setFocus(org.eclipse.jface.text.IWidgetTokenOwner)
    # @since 3.0
    def set_focus(owner)
      if (!(@f_proposal_popup).nil?)
        @f_proposal_popup.set_focus
        return @f_proposal_popup.has_focus
      end
      return false
    end
    
    typesig { [] }
    # Hides any open pop-ups.
    # 
    # @since 3.0
    def hide
      if (!(@f_proposal_popup).nil?)
        @f_proposal_popup.hide
      end
      if (!(@f_context_info_popup).nil?)
        @f_context_info_popup.hide
      end
    end
    
    typesig { [IDialogSettings] }
    # ------ control's size handling dialog settings ------
    # 
    # Tells this information control manager to open the information control with the values
    # contained in the given dialog settings and to store the control's last valid size in the
    # given dialog settings.
    # <p>
    # Note: This API is only valid if the information control implements
    # {@link org.eclipse.jface.text.IInformationControlExtension3}. Not following this restriction
    # will later result in an {@link UnsupportedOperationException}.
    # </p>
    # <p>
    # The constants used to store the values are:
    # <ul>
    # <li>{@link ContentAssistant#STORE_SIZE_X}</li>
    # <li>{@link ContentAssistant#STORE_SIZE_Y}</li>
    # </ul>
    # </p>
    # 
    # @param dialogSettings the dialog settings
    # @since 3.0
    def set_restore_completion_proposal_size(dialog_settings)
      Assert.is_true(!(dialog_settings).nil?)
      @f_dialog_settings = dialog_settings
    end
    
    typesig { [] }
    # Stores the content assist pop-up's size.
    def store_completion_proposal_popup_size
      if ((@f_dialog_settings).nil? || (@f_proposal_popup).nil?)
        return
      end
      size = @f_proposal_popup.get_size
      if ((size).nil?)
        return
      end
      @f_dialog_settings.put(STORE_SIZE_X, size.attr_x)
      @f_dialog_settings.put(STORE_SIZE_Y, size.attr_y)
    end
    
    typesig { [] }
    # Restores the content assist pop-up's size.
    # 
    # @return the stored size
    # @since 3.0
    def restore_completion_proposal_popup_size
      if ((@f_dialog_settings).nil?)
        return nil
      end
      size = Point.new(-1, -1)
      begin
        size.attr_x = @f_dialog_settings.get_int(STORE_SIZE_X)
        size.attr_y = @f_dialog_settings.get_int(STORE_SIZE_Y)
      rescue NumberFormatException => ex
        size.attr_x = -1
        size.attr_y = -1
      end
      # sanity check
      if ((size.attr_x).equal?(-1) && (size.attr_y).equal?(-1))
        return nil
      end
      max_bounds = nil
      if (!(@f_content_assist_subject_control).nil? && Helper.ok_to_use(@f_content_assist_subject_control.get_control))
        max_bounds = @f_content_assist_subject_control.get_control.get_display.get_bounds
      else
        # fallback
        display = Display.get_current
        if ((display).nil?)
          display = Display.get_default
        end
        if (!(display).nil? && !display.is_disposed)
          max_bounds = display.get_bounds
        end
      end
      if (size.attr_x > -1 && size.attr_y > -1)
        if (!(max_bounds).nil?)
          size.attr_x = Math.min(size.attr_x, max_bounds.attr_width)
          size.attr_y = Math.min(size.attr_y, max_bounds.attr_height)
        end
        # Enforce an absolute minimal size
        size.attr_x = Math.max(size.attr_x, 30)
        size.attr_y = Math.max(size.attr_y, 30)
      end
      return size
    end
    
    typesig { [::Java::Boolean] }
    # Sets the prefix completion property. If enabled, content assist delegates completion to
    # prefix completion.
    # 
    # @param enabled <code>true</code> to enable prefix completion, <code>false</code> to
    # disable
    def enable_prefix_completion(enabled)
      @f_is_prefix_completion_enabled = enabled
    end
    
    typesig { [] }
    # Returns the prefix completion state.
    # 
    # @return <code>true</code> if prefix completion is enabled, <code>false</code> otherwise
    # @since 3.2
    def is_prefix_completion_enabled
      return @f_is_prefix_completion_enabled
    end
    
    typesig { [] }
    # Returns whether the content assistant proposal popup has the focus.
    # 
    # @return <code>true</code> if the proposal popup has the focus
    # @since 3.0
    def has_proposal_popup_focus
      return @f_proposal_popup.has_focus
    end
    
    typesig { [ICompletionListener] }
    # @see org.eclipse.jface.text.contentassist.IContentAssistantExtension2#addCompletionListener(org.eclipse.jface.text.contentassist.ICompletionListener)
    # @since 3.2
    def add_completion_listener(listener)
      Assert.is_legal(!(listener).nil?)
      @f_completion_listeners.add(listener)
    end
    
    typesig { [ICompletionListener] }
    # @see org.eclipse.jface.text.contentassist.IContentAssistantExtension2#removeCompletionListener(org.eclipse.jface.text.contentassist.ICompletionListener)
    # @since 3.2
    def remove_completion_listener(listener)
      @f_completion_listeners.remove(listener)
    end
    
    typesig { [::Java::Boolean] }
    # Fires a session begin event to all registered {@link ICompletionListener}s.
    # 
    # @param isAutoActivated  <code>true</code> if this session was triggered by auto activation
    # @since 3.2
    def fire_session_begin_event(is_auto_activated)
      if (!(@f_content_assist_subject_control_adapter).nil? && !is_proposal_popup_active)
        processor = get_processor(@f_content_assist_subject_control_adapter, @f_content_assist_subject_control_adapter.get_selected_range.attr_x)
        event = ContentAssistEvent.new(self, processor, is_auto_activated)
        listeners = @f_completion_listeners.get_listeners
        i = 0
        while i < listeners.attr_length
          listener = listeners[i]
          listener.assist_session_started(event)
          i += 1
        end
      end
    end
    
    typesig { [] }
    # Fires a session restart event to all registered {@link ICompletionListener}s.
    # 
    # @since 3.4
    def fire_session_restart_event
      if (!(@f_content_assist_subject_control_adapter).nil?)
        processor = get_processor(@f_content_assist_subject_control_adapter, @f_content_assist_subject_control_adapter.get_selected_range.attr_x)
        event = ContentAssistEvent.new(self, processor)
        listeners = @f_completion_listeners.get_listeners
        i = 0
        while i < listeners.attr_length
          listener = listeners[i]
          if (listener.is_a?(ICompletionListenerExtension))
            (listener).assist_session_restarted(event)
          end
          i += 1
        end
      end
    end
    
    typesig { [] }
    # Fires a session end event to all registered {@link ICompletionListener}s.
    # 
    # @since 3.2
    def fire_session_end_event
      if (!(@f_content_assist_subject_control_adapter).nil?)
        processor = get_processor(@f_content_assist_subject_control_adapter, @f_content_assist_subject_control_adapter.get_selected_range.attr_x)
        event = ContentAssistEvent.new(self, processor)
        listeners = @f_completion_listeners.get_listeners
        i = 0
        while i < listeners.attr_length
          listener = listeners[i]
          listener.assist_session_ended(event)
          i += 1
        end
      end
    end
    
    typesig { [::Java::Boolean] }
    # @see org.eclipse.jface.text.contentassist.IContentAssistantExtension2#setRepeatedInvocationMode(boolean)
    # @since 3.2
    def set_repeated_invocation_mode(cycling)
      @f_is_repetition_mode = cycling
    end
    
    typesig { [] }
    # Returns <code>true</code> if repeated invocation mode is enabled, <code>false</code>
    # otherwise.
    # 
    # @return <code>true</code> if repeated invocation mode is enabled, <code>false</code>
    # otherwise
    # @since 3.2
    def is_repeated_invocation_mode
      return @f_is_repetition_mode
    end
    
    typesig { [::Java::Boolean] }
    # @see org.eclipse.jface.text.contentassist.IContentAssistantExtension2#setShowEmptyList(boolean)
    # @since 3.2
    def set_show_empty_list(show_empty)
      @f_show_empty_list = show_empty
    end
    
    typesig { [] }
    # Returns <code>true</code> if empty lists should be displayed, <code>false</code>
    # otherwise.
    # 
    # @return <code>true</code> if empty lists should be displayed, <code>false</code>
    # otherwise
    # @since 3.2
    def is_show_empty_list
      return @f_show_empty_list
    end
    
    typesig { [::Java::Boolean] }
    # @see org.eclipse.jface.text.contentassist.IContentAssistantExtension2#setStatusLineVisible(boolean)
    # @since 3.2
    def set_status_line_visible(show)
      @f_is_status_line_visible = show
      if (!(@f_proposal_popup).nil?)
        @f_proposal_popup.set_status_line_visible(show)
      end
    end
    
    typesig { [] }
    # Returns <code>true</code> if a message line should be displayed, <code>false</code>
    # otherwise.
    # 
    # @return <code>true</code> if a message line should be displayed, <code>false</code>
    # otherwise
    # @since 3.2
    def is_status_line_visible
      return @f_is_status_line_visible
    end
    
    typesig { [String] }
    # @see org.eclipse.jface.text.contentassist.IContentAssistantExtension2#setStatusMessage(java.lang.String)
    # @since 3.2
    def set_status_message(message)
      Assert.is_legal(!(message).nil?)
      @f_message = message
      if (!(@f_proposal_popup).nil?)
        @f_proposal_popup.set_message(message)
      end
    end
    
    typesig { [] }
    # Returns the affordance caption for the cycling affordance at the bottom of the pop-up.
    # 
    # @return the affordance caption for the cycling affordance at the bottom of the pop-up
    # @since 3.2
    def get_status_message
      return @f_message
    end
    
    typesig { [String] }
    # @see org.eclipse.jface.text.contentassist.IContentAssistantExtension2#setEmptyMessage(java.lang.String)
    # @since 3.2
    def set_empty_message(message)
      Assert.is_legal(!(message).nil?)
      if (!(@f_proposal_popup).nil?)
        @f_proposal_popup.set_empty_message(message)
      end
    end
    
    typesig { [ICompletionProposal, ::Java::Boolean] }
    # Fires a selection event, see {@link ICompletionListener}.
    # 
    # @param proposal the selected proposal, possibly <code>null</code>
    # @param smartToggle true if the smart toggle is on
    # @since 3.2
    def fire_selection_event(proposal, smart_toggle)
      listeners = @f_completion_listeners.get_listeners
      i = 0
      while i < listeners.attr_length
        listener = listeners[i]
        listener.selection_changed(proposal, smart_toggle)
        i += 1
      end
    end
    
    typesig { [KeySequence] }
    # @see org.eclipse.jface.text.contentassist.IContentAssistantExtension3#setInvocationTrigger(org.eclipse.jface.bindings.keys.KeySequence)
    # @since 3.2
    def set_repeated_invocation_trigger(sequence)
      @f_repeated_invocation_key_sequence = sequence
    end
    
    typesig { [] }
    # Returns the repeated invocation key sequence.
    # 
    # @return the repeated invocation key sequence or <code>null</code>, if none
    # @since 3.2
    def get_repeated_invocation_key_sequence
      return @f_repeated_invocation_key_sequence
    end
    
    typesig { [] }
    # Returns whether proposal popup is active.
    # 
    # @return <code>true</code> if the proposal popup is active, <code>false</code> otherwise
    # @since 3.4
    def is_proposal_popup_active
      return !(@f_proposal_popup).nil? && @f_proposal_popup.is_active
    end
    
    typesig { [] }
    # Returns whether the context information popup is active.
    # 
    # @return <code>true</code> if the context information popup is active, <code>false</code> otherwise
    # @since 3.4
    def is_context_info_popup_active
      return !(@f_context_info_popup).nil? && @f_context_info_popup.is_active
    end
    
    typesig { [String] }
    # {@inheritDoc}
    # 
    # @since 3.4
    def get_handler(command_id)
      if ((@f_handlers).nil?)
        raise IllegalStateException.new
      end
      handler = @f_handlers.get(command_id)
      if (!(handler).nil?)
        return handler
      end
      Assert.is_legal(false)
      return nil
    end
    
    typesig { [String, IHandler] }
    # Registers the given handler under the given command identifier.
    # 
    # @param commandId the command identifier
    # @param handler the handler
    # @since 3.4
    def register_handler(command_id, handler)
      if ((@f_handlers).nil?)
        @f_handlers = HashMap.new(2)
      end
      @f_handlers.put(command_id, handler)
    end
    
    typesig { [] }
    # Tells whether the support for colored labels is enabled.
    # 
    # @return <code>true</code> if the support for colored labels is enabled, <code>false</code> otherwise
    # @since 3.4
    def is_colored_labels_support_enabled
      return @f_is_colored_labels_support_enabled
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
    alias_method :initialize__content_assistant, :initialize
  end
  
end
