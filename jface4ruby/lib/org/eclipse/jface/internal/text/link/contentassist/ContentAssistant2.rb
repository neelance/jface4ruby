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
  module ContentAssistant2Imports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Internal::Text::Link::Contentassist
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :Map
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt, :SWTError
      include_const ::Org::Eclipse::Swt::Custom, :StyledText
      include_const ::Org::Eclipse::Swt::Custom, :VerifyKeyListener
      include_const ::Org::Eclipse::Swt::Events, :ControlEvent
      include_const ::Org::Eclipse::Swt::Events, :ControlListener
      include_const ::Org::Eclipse::Swt::Events, :DisposeEvent
      include_const ::Org::Eclipse::Swt::Events, :DisposeListener
      include_const ::Org::Eclipse::Swt::Events, :FocusEvent
      include_const ::Org::Eclipse::Swt::Events, :FocusListener
      include_const ::Org::Eclipse::Swt::Events, :MouseEvent
      include_const ::Org::Eclipse::Swt::Events, :MouseListener
      include_const ::Org::Eclipse::Swt::Events, :VerifyEvent
      include_const ::Org::Eclipse::Swt::Graphics, :Color
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Graphics, :Rectangle
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Display
      include_const ::Org::Eclipse::Swt::Widgets, :Event
      include_const ::Org::Eclipse::Swt::Widgets, :Listener
      include_const ::Org::Eclipse::Swt::Widgets, :Shell
      include_const ::Org::Eclipse::Swt::Widgets, :Widget
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Jface::Text, :BadLocationException
      include_const ::Org::Eclipse::Jface::Text, :DefaultInformationControl
      include_const ::Org::Eclipse::Jface::Text, :IEventConsumer
      include_const ::Org::Eclipse::Jface::Text, :IInformationControl
      include_const ::Org::Eclipse::Jface::Text, :IInformationControlCreator
      include_const ::Org::Eclipse::Jface::Text, :ITextViewer
      include_const ::Org::Eclipse::Jface::Text, :ITextViewerExtension
      include_const ::Org::Eclipse::Jface::Text, :IViewportListener
      include_const ::Org::Eclipse::Jface::Text, :IWidgetTokenKeeper
      include_const ::Org::Eclipse::Jface::Text, :IWidgetTokenKeeperExtension
      include_const ::Org::Eclipse::Jface::Text, :IWidgetTokenOwner
      include_const ::Org::Eclipse::Jface::Text, :IWidgetTokenOwnerExtension
      include_const ::Org::Eclipse::Jface::Text, :TextUtilities
      include_const ::Org::Eclipse::Jface::Text::Contentassist, :CompletionProposal
      include_const ::Org::Eclipse::Jface::Text::Contentassist, :ICompletionProposal
      include_const ::Org::Eclipse::Jface::Text::Contentassist, :ICompletionProposalExtension6
      include_const ::Org::Eclipse::Jface::Text::Contentassist, :IContentAssistProcessor
      include_const ::Org::Eclipse::Jface::Text::Contentassist, :IContentAssistant
      include_const ::Org::Eclipse::Jface::Text::Contentassist, :IContentAssistantExtension
      include_const ::Org::Eclipse::Jface::Text::Contentassist, :IContextInformation
      include_const ::Org::Eclipse::Jface::Text::Contentassist, :IContextInformationPresenter
      include_const ::Org::Eclipse::Jface::Text::Contentassist, :IContextInformationValidator
    }
  end
  
  # A custom implementation of the <code>IContentAssistant</code> interface.
  # This implementation is used by the linked mode UI. This is internal and subject
  # to change without notice.
  class ContentAssistant2 
    include_class_members ContentAssistant2Imports
    include IContentAssistant
    include IContentAssistantExtension
    include IWidgetTokenKeeper
    include IWidgetTokenKeeperExtension
    
    class_module.module_eval {
      # A generic closer class used to monitor various
      # interface events in order to determine whether
      # content-assist should be terminated and all
      # associated windows closed.
      const_set_lazy(:Closer) { Class.new do
        extend LocalClass
        include_class_members ContentAssistant2
        include ControlListener
        include MouseListener
        include FocusListener
        include DisposeListener
        include IViewportListener
        
        # The shell on which we add listeners.
        attr_accessor :f_shell
        alias_method :attr_f_shell, :f_shell
        undef_method :f_shell
        alias_method :attr_f_shell=, :f_shell=
        undef_method :f_shell=
        
        attr_accessor :f_viewport_listener_start_time
        alias_method :attr_f_viewport_listener_start_time, :f_viewport_listener_start_time
        undef_method :f_viewport_listener_start_time
        alias_method :attr_f_viewport_listener_start_time=, :f_viewport_listener_start_time=
        undef_method :f_viewport_listener_start_time=
        
        typesig { [] }
        # Installs this closer on it's viewer's text widget.
        def install
          w = self.attr_f_viewer.get_text_widget
          if (Helper2.ok_to_use(w))
            shell = w.get_shell
            @f_shell = shell
            shell.add_control_listener(self)
            w.add_mouse_listener(self)
            w.add_focus_listener(self)
            # 1GGYYWK: ITPJUI:ALL - Dismissing editor with code assist up causes lots of Internal Errors
            w.add_dispose_listener(self)
          end
          self.attr_f_viewer.add_viewport_listener(self)
          @f_viewport_listener_start_time = System.current_time_millis + 500
        end
        
        typesig { [] }
        # Uninstalls this closer from the viewer's text widget.
        def uninstall
          shell = @f_shell
          @f_shell = nil
          if (Helper2.ok_to_use(shell))
            shell.remove_control_listener(self)
          end
          w = self.attr_f_viewer.get_text_widget
          if (Helper2.ok_to_use(w))
            w.remove_mouse_listener(self)
            w.remove_focus_listener(self)
            # 1GGYYWK: ITPJUI:ALL - Dismissing editor with code assist up causes lots of Internal Errors
            w.remove_dispose_listener(self)
          end
          self.attr_f_viewer.remove_viewport_listener(self)
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
          if (!(self.attr_f_viewer).nil?)
            control = self.attr_f_viewer.get_text_widget
            if (!(control).nil?)
              d = control.get_display
              if (!(d).nil?)
                d.async_exec(Class.new(self.class::Runnable.class == Class ? self.class::Runnable : Object) do
                  extend LocalClass
                  include_class_members Closer
                  include class_self::Runnable if class_self::Runnable.class == Module
                  
                  typesig { [] }
                  define_method :run do
                    if (!has_focus)
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
        end
        
        typesig { [class_self::DisposeEvent] }
        # @seeDisposeListener#widgetDisposed(DisposeEvent)
        def widget_disposed(e)
          # 1GGYYWK: ITPJUI:ALL - Dismissing editor with code assist up causes lots of Internal Errors
          hide
        end
        
        typesig { [::Java::Int] }
        # @see IViewportListener#viewportChanged(int)
        def viewport_changed(top_index)
          if (System.current_time_millis > @f_viewport_listener_start_time)
            hide
          end
        end
        
        typesig { [] }
        def initialize
          @f_shell = nil
          @f_viewport_listener_start_time = 0
        end
        
        private
        alias_method :initialize__closer, :initialize
      end }
      
      # An implementation of <code>IContentAssistListener</code>, this class is
      # used to monitor key events in support of automatic activation
      # of the content assistant. If enabled, the implementation utilizes a
      # thread to watch for input characters matching the activation
      # characters specified by the content assist processor, and if
      # detected, will wait the indicated delay interval before
      # activating the content assistant.
      const_set_lazy(:AutoAssistListener) { Class.new do
        extend LocalClass
        include_class_members ContentAssistant2
        include VerifyKeyListener
        include Runnable
        
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
          @f_mutex = Object.new
          @f_show_style = 0
        end
        
        typesig { [::Java::Int] }
        def start(show_style)
          @f_show_style = show_style
          @f_thread = self.class::JavaThread.new(self, ContentAssistMessages.get_string("ContentAssistant.assist_delay_timer_name")) # $NON-NLS-1$
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
          if (!(thread_to_stop).nil?)
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
        
        typesig { [class_self::VerifyEvent] }
        def verify_key(e)
          # Only act on typed characters and ignore modifier-only events
          if ((e.attr_character).equal?(0) && ((e.attr_key_code & SWT::KEYCODE_BIT)).equal?(0))
            return
          end
          if (!(e.attr_character).equal?(0) && ((e.attr_state_mask).equal?(SWT::ALT)))
            return
          end
          show_style = 0
          pos = self.attr_f_viewer.get_selected_range.attr_x
          activation = get_completion_proposal_auto_activation_characters(self.attr_f_viewer, pos)
          if (contains(activation, e.attr_character) && !self.attr_f_proposal_popup.is_active)
            show_style = self.class::SHOW_PROPOSALS
          else
            activation = get_context_information_auto_activation_characters(self.attr_f_viewer, pos)
            if (contains(activation, e.attr_character) && !self.attr_f_context_info_popup.is_active)
              show_style = self.class::SHOW_CONTEXT_INFO
            else
              if (!(@f_thread).nil? && @f_thread.is_alive)
                stop
              end
              return
            end
          end
          if (!(@f_thread).nil? && @f_thread.is_alive)
            reset(show_style)
          else
            start(show_style)
          end
        end
        
        typesig { [::Java::Int] }
        def show_assist(show_style)
          control = self.attr_f_viewer.get_text_widget
          d = control.get_display
          if (!(d).nil?)
            begin
              d.sync_exec(Class.new(self.class::Runnable.class == Class ? self.class::Runnable : Object) do
                extend LocalClass
                include_class_members AutoAssistListener
                include class_self::Runnable if class_self::Runnable.class == Module
                
                typesig { [] }
                define_method :run do
                  if ((show_style).equal?(self.class::SHOW_PROPOSALS))
                    self.attr_f_proposal_popup.show_proposals(true)
                  else
                    if ((show_style).equal?(self.class::SHOW_CONTEXT_INFO))
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
        end
        
        private
        alias_method :initialize__auto_assist_listener, :initialize
      end }
      
      # The layout manager layouts the various
      # windows associated with the content assistant based on the
      # settings of the content assistant.
      const_set_lazy(:LayoutManager) { Class.new do
        extend LocalClass
        include_class_members ContentAssistant2
        include Listener
        
        class_module.module_eval {
          # Presentation types.
          # proposal selector
          const_set_lazy(:LAYOUT_PROPOSAL_SELECTOR) { 0 }
          const_attr_reader  :LAYOUT_PROPOSAL_SELECTOR
          
          # context selector
          const_set_lazy(:LAYOUT_CONTEXT_SELECTOR) { 1 }
          const_attr_reader  :LAYOUT_CONTEXT_SELECTOR
          
          # context info
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
            if ((@f_context_type).equal?(self.class::LAYOUT_CONTEXT_SELECTOR) && Helper2.ok_to_use(@f_shells[self.class::LAYOUT_CONTEXT_SELECTOR]))
              # Restore event notification to the tip popup.
              add_content_assist_listener(@f_popups[self.class::LAYOUT_CONTEXT_SELECTOR], CONTEXT_SELECTOR)
            end
          when self.class::LAYOUT_CONTEXT_SELECTOR
            if (Helper2.ok_to_use(@f_shells[self.class::LAYOUT_PROPOSAL_SELECTOR]))
              if ((self.attr_f_proposal_popup_orientation).equal?(PROPOSAL_STACKED))
                layout(self.class::LAYOUT_PROPOSAL_SELECTOR, get_selection_offset)
              end
              # Restore event notification to the proposal popup.
              add_content_assist_listener(@f_popups[self.class::LAYOUT_PROPOSAL_SELECTOR], PROPOSAL_SELECTOR)
            end
            @f_context_type = self.class::LAYOUT_CONTEXT_INFO_POPUP
          when self.class::LAYOUT_CONTEXT_INFO_POPUP
            if (Helper2.ok_to_use(@f_shells[self.class::LAYOUT_PROPOSAL_SELECTOR]))
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
          if ((@f_context_type).equal?(self.class::LAYOUT_CONTEXT_INFO_POPUP) && (self.attr_f_context_info_popup_orientation).equal?(CONTEXT_INFO_BELOW) && Helper2.ok_to_use(@f_shells[self.class::LAYOUT_CONTEXT_INFO_POPUP]))
            # Stack proposal selector beneath the tip box.
            shell = @f_shells[self.class::LAYOUT_PROPOSAL_SELECTOR]
            parent = @f_shells[self.class::LAYOUT_CONTEXT_INFO_POPUP]
            shell.set_location(get_stacked_location(shell, parent))
          else
            if (!(@f_context_type).equal?(self.class::LAYOUT_CONTEXT_SELECTOR) || !Helper2.ok_to_use(@f_shells[self.class::LAYOUT_CONTEXT_SELECTOR]))
              # There are no other presentations to be concerned with,
              # so place the proposal selector beneath the cursor line.
              shell = @f_shells[self.class::LAYOUT_PROPOSAL_SELECTOR]
              shell.set_location(get_below_location(shell, offset))
            else
              case (self.attr_f_proposal_popup_orientation)
              when PROPOSAL_REMOVE
                # Remove the tip selector and place the
                # proposal selector beneath the cursor line.
                @f_shells[self.class::LAYOUT_CONTEXT_SELECTOR].dispose
                shell = @f_shells[self.class::LAYOUT_PROPOSAL_SELECTOR]
                shell.set_location(get_below_location(shell, offset))
              when PROPOSAL_OVERLAY
                # Overlay the tip selector with the proposal selector.
                shell = @f_shells[self.class::LAYOUT_PROPOSAL_SELECTOR]
                shell.set_location(get_below_location(shell, offset))
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
          shell.set_location(get_below_location(shell, offset))
          if (Helper2.ok_to_use(@f_shells[self.class::LAYOUT_PROPOSAL_SELECTOR]))
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
            shell.set_location(get_above_location(shell, offset))
          when CONTEXT_INFO_BELOW
            # Place the popup beneath the cursor line.
            parent = @f_shells[self.class::LAYOUT_CONTEXT_INFO_POPUP]
            parent.set_location(get_below_location(parent, offset))
            if (Helper2.ok_to_use(@f_shells[self.class::LAYOUT_PROPOSAL_SELECTOR]))
              # Stack the proposal selector beneath the context info popup.
              shell = @f_shells[self.class::LAYOUT_PROPOSAL_SELECTOR]
              shell.set_location(get_stacked_location(shell, parent))
            end
          end
        end
        
        typesig { [class_self::Point, class_self::Rectangle, class_self::Rectangle] }
        def shift_horizontal_location(location, shell_bounds, display_bounds)
          if (location.attr_x + shell_bounds.attr_width > display_bounds.attr_width)
            location.attr_x = display_bounds.attr_width - shell_bounds.attr_width
          end
          if (location.attr_x < display_bounds.attr_x)
            location.attr_x = display_bounds.attr_x
          end
        end
        
        typesig { [class_self::Point, class_self::Rectangle, class_self::Rectangle] }
        def shift_vertical_location(location, shell_bounds, display_bounds)
          if (location.attr_y + shell_bounds.attr_height > display_bounds.attr_height)
            location.attr_y = display_bounds.attr_height - shell_bounds.attr_height
          end
          if (location.attr_y < display_bounds.attr_y)
            location.attr_y = display_bounds.attr_y
          end
        end
        
        typesig { [class_self::Shell, ::Java::Int] }
        def get_above_location(shell, offset)
          text = self.attr_f_viewer.get_text_widget
          location = text.get_location_at_offset(offset)
          location = text.to_display(location)
          shell_bounds = shell.get_bounds
          display_bounds = shell.get_display.get_client_area
          location.attr_y = location.attr_y - shell_bounds.attr_height
          shift_horizontal_location(location, shell_bounds, display_bounds)
          shift_vertical_location(location, shell_bounds, display_bounds)
          return location
        end
        
        typesig { [class_self::Shell, ::Java::Int] }
        def get_below_location(shell, offset)
          text = self.attr_f_viewer.get_text_widget
          location = text.get_location_at_offset(offset)
          if (location.attr_x < 0)
            location.attr_x = 0
          end
          if (location.attr_y < 0)
            location.attr_y = 0
          end
          location = text.to_display(location)
          shell_bounds = shell.get_bounds
          display_bounds = shell.get_display.get_client_area
          location.attr_y = location.attr_y + text.get_line_height(offset)
          shift_horizontal_location(location, shell_bounds, display_bounds)
          shift_vertical_location(location, shell_bounds, display_bounds)
          return location
        end
        
        typesig { [class_self::Shell, class_self::Shell] }
        def get_stacked_location(shell, parent)
          p = parent.get_location
          size = parent.get_size
          p.attr_x += size.attr_x / 4
          p.attr_y += size.attr_y
          p = parent.to_display(p)
          shell_bounds = shell.get_bounds
          display_bounds = shell.get_display.get_client_area
          shift_horizontal_location(p, shell_bounds, display_bounds)
          shift_vertical_location(p, shell_bounds, display_bounds)
          return p
        end
        
        typesig { [::Java::Int] }
        def adjust_listeners(type)
          case (type)
          when self.class::LAYOUT_PROPOSAL_SELECTOR
            if ((@f_context_type).equal?(self.class::LAYOUT_CONTEXT_SELECTOR) && Helper2.ok_to_use(@f_shells[self.class::LAYOUT_CONTEXT_SELECTOR]))
              # Disable event notification to the tip selector.
              remove_content_assist_listener(@f_popups[self.class::LAYOUT_CONTEXT_SELECTOR], CONTEXT_SELECTOR)
            end
          when self.class::LAYOUT_CONTEXT_SELECTOR
            if (Helper2.ok_to_use(@f_shells[self.class::LAYOUT_PROPOSAL_SELECTOR]))
              # Disable event notification to the proposal selector.
              remove_content_assist_listener(@f_popups[self.class::LAYOUT_PROPOSAL_SELECTOR], PROPOSAL_SELECTOR)
            end
          when self.class::LAYOUT_CONTEXT_INFO_POPUP
          end
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
        extend LocalClass
        include_class_members ContentAssistant2
        include VerifyKeyListener
        include IEventConsumer
        
        typesig { [class_self::VerifyEvent] }
        # Verifies key events by notifying the registered listeners.
        # Each listener is allowed to indicate that the event has been
        # handled and should not be further processed.
        # 
        # @param e the verify event
        # @see VerifyKeyListener#verifyKey(org.eclipse.swt.events.VerifyEvent)
        def verify_key(e)
          listeners = self.attr_f_listeners.clone
          i = 0
          while i < listeners.attr_length
            if (!(listeners[i]).nil?)
              if (!listeners[i].verify_key(e) || !e.attr_doit)
                return
              end
            end
            i += 1
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
      
      # Content-Assist Listener types
      const_set_lazy(:CONTEXT_SELECTOR) { 0 }
      const_attr_reader  :CONTEXT_SELECTOR
      
      const_set_lazy(:PROPOSAL_SELECTOR) { 1 }
      const_attr_reader  :PROPOSAL_SELECTOR
      
      const_set_lazy(:CONTEXT_INFO_POPUP) { 2 }
      const_attr_reader  :CONTEXT_INFO_POPUP
      
      # The popup priority: &gt; info pop-ups, &lt; standard content assist.
      # Default value: <code>10</code>.
      # 
      # @since 3.0
      const_set_lazy(:WIDGET_PRIORITY) { 10 }
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
    
    attr_accessor :f_key_listener_hooked
    alias_method :attr_f_key_listener_hooked, :f_key_listener_hooked
    undef_method :f_key_listener_hooked
    alias_method :attr_f_key_listener_hooked=, :f_key_listener_hooked=
    undef_method :f_key_listener_hooked=
    
    attr_accessor :f_listeners
    alias_method :attr_f_listeners, :f_listeners
    undef_method :f_listeners
    alias_method :attr_f_listeners=, :f_listeners=
    undef_method :f_listeners=
    
    attr_accessor :f_completion_position
    alias_method :attr_f_completion_position, :f_completion_position
    undef_method :f_completion_position
    alias_method :attr_f_completion_position=, :f_completion_position=
    undef_method :f_completion_position=
    
    attr_accessor :f_proposal_strings
    alias_method :attr_f_proposal_strings, :f_proposal_strings
    undef_method :f_proposal_strings
    alias_method :attr_f_proposal_strings=, :f_proposal_strings=
    undef_method :f_proposal_strings=
    
    attr_accessor :f_proposals
    alias_method :attr_f_proposals, :f_proposals
    undef_method :f_proposals
    alias_method :attr_f_proposals=, :f_proposals=
    undef_method :f_proposals=
    
    attr_accessor :f_proposal_listeners
    alias_method :attr_f_proposal_listeners, :f_proposal_listeners
    undef_method :f_proposal_listeners
    alias_method :attr_f_proposal_listeners=, :f_proposal_listeners=
    undef_method :f_proposal_listeners=
    
    # Tells whether colored label support is enabled.
    # @since 3.4
    attr_accessor :f_is_colored_labels_support_enabled
    alias_method :attr_f_is_colored_labels_support_enabled, :f_is_colored_labels_support_enabled
    undef_method :f_is_colored_labels_support_enabled
    alias_method :attr_f_is_colored_labels_support_enabled=, :f_is_colored_labels_support_enabled=
    undef_method :f_is_colored_labels_support_enabled=
    
    typesig { [] }
    # Creates a new content assistant. The content assistant is not automatically activated,
    # overlays the completion proposals with context information list if necessary, and
    # shows the context information above the location at which it was activated. If auto
    # activation will be enabled, without further configuration steps, this content assistant
    # is activated after a 500 ms delay. It uses the default partitioning.
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
      @f_viewer = nil
      @f_last_error_message = nil
      @f_closer = nil
      @f_layout_manager = nil
      @f_auto_assist_listener = nil
      @f_internal_listener = nil
      @f_proposal_popup = nil
      @f_context_info_popup = nil
      @f_key_listener_hooked = false
      @f_listeners = Array.typed(IContentAssistListener2).new(4) { nil }
      @f_completion_position = 0
      @f_proposal_strings = nil
      @f_proposals = nil
      @f_proposal_listeners = ArrayList.new
      @f_is_colored_labels_support_enabled = false
      set_context_information_popup_orientation(CONTEXT_INFO_ABOVE)
      set_information_control_creator(get_information_control_creator)
      # JavaTextTools textTools= JavaPlugin.getDefault().getJavaTextTools();
      # IColorManager manager= textTools.getColorManager();
      # 
      # IPreferenceStore store=  JavaPlugin.getDefault().getPreferenceStore();
      # 
      # Color c= getColor(store, PreferenceConstants.CODEASSIST_PROPOSALS_FOREGROUND, manager);
      # setProposalSelectorForeground(c);
      # 
      # c= getColor(store, PreferenceConstants.CODEASSIST_PROPOSALS_BACKGROUND, manager);
      # setProposalSelectorBackground(c);
    end
    
    typesig { [] }
    # Creates an <code>IInformationControlCreator</code> to be used to display context information.
    # 
    # @return an <code>IInformationControlCreator</code> to be used to display context information
    def get_information_control_creator
      return Class.new(IInformationControlCreator.class == Class ? IInformationControlCreator : Object) do
        extend LocalClass
        include_class_members ContentAssistant2
        include IInformationControlCreator if IInformationControlCreator.class == Module
        
        typesig { [Shell] }
        define_method :create_information_control do |parent|
          return self.class::DefaultInformationControl.new(parent, false)
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
    end
    
    typesig { [String] }
    # Sets the document partitioning this content assistant is using.
    # 
    # @param partitioning the document partitioning for this content assistant
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
    # Registers a given content assist processor for a particular content type.
    # If there is already a processor registered for this type, the new processor
    # is registered instead of the old one.
    # 
    # @param processor the content assist processor to register, or <code>null</code> to remove an existing one
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
    
    typesig { [::Java::Boolean] }
    # Enables the content assistant's auto activation mode.
    # 
    # @param enabled indicates whether auto activation is enabled or not
    def enable_auto_activation(enabled)
      @f_is_auto_activated = enabled
      manage_auto_activation(@f_is_auto_activated)
    end
    
    typesig { [::Java::Boolean] }
    # Enables the content assistant's auto insertion mode. If enabled,
    # the content assistant inserts a proposal automatically if it is
    # the only proposal. In the case of ambiguities, the user must
    # make the choice.
    # 
    # @param enabled indicates whether auto insertion is enabled or not
    # @since 2.0
    def enable_auto_insert(enabled)
      @f_is_auto_inserting = enabled
    end
    
    typesig { [] }
    # Returns whether this content assistant is in the auto insertion
    # mode or not.
    # 
    # @return <code>true</code> if in auto insertion mode
    # @since 2.0
    def is_auto_inserting
      return @f_is_auto_inserting
    end
    
    typesig { [::Java::Boolean] }
    # Installs and uninstall the listeners needed for auto-activation.
    # @param start <code>true</code> if listeners must be installed,
    # <code>false</code> if they must be removed
    # @since 2.0
    def manage_auto_activation(start)
      if (start)
        if (!(@f_viewer).nil? && (@f_auto_assist_listener).nil?)
          @f_auto_assist_listener = AutoAssistListener.new_local(self)
          if (@f_viewer.is_a?(ITextViewerExtension))
            extension = @f_viewer
            extension.append_verify_key_listener(@f_auto_assist_listener)
          else
            text_widget = @f_viewer.get_text_widget
            if (Helper2.ok_to_use(text_widget))
              text_widget.add_verify_key_listener(@f_auto_assist_listener)
            end
          end
        end
      else
        if (!(@f_auto_assist_listener).nil?)
          if (@f_viewer.is_a?(ITextViewerExtension))
            extension = @f_viewer
            extension.remove_verify_key_listener(@f_auto_assist_listener)
          else
            text_widget = @f_viewer.get_text_widget
            if (Helper2.ok_to_use(text_widget))
              text_widget.remove_verify_key_listener(@f_auto_assist_listener)
            end
          end
          @f_auto_assist_listener = nil
        end
      end
    end
    
    typesig { [::Java::Int] }
    # Sets the delay after which the content assistant is automatically invoked
    # if the cursor is behind an auto activation character.
    # 
    # @param delay the auto activation delay
    def set_auto_activation_delay(delay)
      @f_auto_activation_delay = delay
    end
    
    typesig { [::Java::Int] }
    # Sets the proposal pop-ups' orientation.
    # The following values may be used:
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
    # @return the foreground of the context information popup
    # @since 2.0
    def get_context_information_popup_foreground
      return @f_context_info_popup_foreground
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
    
    typesig { [ITextViewer] }
    # @see IContentAssist#install
    def install(text_viewer)
      Assert.is_not_null(text_viewer)
      @f_viewer = text_viewer
      @f_layout_manager = LayoutManager.new_local(self)
      @f_internal_listener = InternalListener.new_local(self)
      controller = nil
      if (!(@f_information_control_creator).nil?)
        delay = @f_auto_activation_delay
        if ((delay).equal?(0))
          delay = DEFAULT_AUTO_ACTIVATION_DELAY
        end
        delay = Math.round(delay * 1.5)
        controller = AdditionalInfoController2.new(@f_information_control_creator, delay)
      end
      @f_context_info_popup = ContextInformationPopup2.new(self, @f_viewer)
      @f_proposal_popup = CompletionProposalPopup2.new(self, @f_viewer, controller)
      manage_auto_activation(@f_is_auto_activated)
    end
    
    typesig { [] }
    # @see IContentAssist#uninstall
    def uninstall
      if (!(@f_proposal_popup).nil?)
        @f_proposal_popup.hide
      end
      if (!(@f_context_info_popup).nil?)
        @f_context_info_popup.hide
      end
      manage_auto_activation(false)
      if (!(@f_closer).nil?)
        @f_closer.uninstall
        @f_closer = nil
      end
      @f_viewer = nil
    end
    
    typesig { [Object, Shell, ::Java::Int, ::Java::Int] }
    # Adds the given shell of the specified type to the layout.
    # Valid types are defined by <code>LayoutManager</code>.
    # 
    # @param popup a content assist popup
    # @param shell the shell of the content-assist popup
    # @param type the type of popup
    # @param visibleOffset the offset at which to layout the popup relative to the offset of the viewer's visible region
    # @since 2.0
    def add_to_layout(popup, shell, type, visible_offset)
      @f_layout_manager.add(popup, shell, type, visible_offset)
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Layouts the registered popup of the given type relative to the
    # given offset. The offset is relative to the offset of the viewer's visible region.
    # Valid types are defined by <code>LayoutManager</code>.
    # 
    # @param type the type of popup to layout
    # @param visibleOffset the offset at which to layout relative to the offset of the viewer's visible region
    # @since 2.0
    def layout(type, visible_offset)
      @f_layout_manager.layout(type, visible_offset)
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
      text = @f_viewer.get_text_widget
      return text.get_selection_range.attr_x
    end
    
    typesig { [::Java::Int] }
    # Returns whether the widget token could be acquired.
    # The following are valid listener types:
    # <ul>
    # <li>AUTO_ASSIST
    # <li>CONTEXT_SELECTOR
    # <li>PROPOSAL_SELECTOR
    # <li>CONTEXT_INFO_POPUP
    # <ul>
    # @param type the listener type for which to acquire
    # @return <code>true</code> if the widget token could be acquired
    # @since 2.0
    def acquire_widget_token(type)
      case (type)
      when CONTEXT_SELECTOR, PROPOSAL_SELECTOR
        if (@f_viewer.is_a?(IWidgetTokenOwner))
          owner = @f_viewer
          return owner.request_widget_token(self)
        else
          if (@f_viewer.is_a?(IWidgetTokenOwnerExtension))
            extension = @f_viewer
            return extension.request_widget_token(self, WIDGET_PRIORITY)
          end
        end
      end
      return true
    end
    
    typesig { [IContentAssistListener2, ::Java::Int] }
    # Registers a content assist listener.
    # The following are valid listener types:
    # <ul>
    # <li>AUTO_ASSIST
    # <li>CONTEXT_SELECTOR
    # <li>PROPOSAL_SELECTOR
    # <li>CONTEXT_INFO_POPUP
    # <ul>
    # Returns whether the listener could be added successfully. A listener
    # can not be added if the widget token could not be acquired.
    # 
    # @param listener the listener to register
    # @param type the type of listener
    # @return <code>true</code> if the listener could be added
    def add_content_assist_listener(listener, type)
      if (acquire_widget_token(type))
        @f_listeners[type] = listener
        if ((get_number_of_listeners).equal?(1))
          @f_closer = Closer.new_local(self)
          @f_closer.install
          @f_viewer.set_event_consumer(@f_internal_listener)
          install_key_listener
        end
        return true
      end
      return false
    end
    
    typesig { [] }
    # Installs a key listener on the text viewer's widget.
    def install_key_listener
      if (!@f_key_listener_hooked)
        text = @f_viewer.get_text_widget
        if (Helper2.ok_to_use(text))
          if (@f_viewer.is_a?(ITextViewerExtension))
            e = @f_viewer
            e.prepend_verify_key_listener(@f_internal_listener)
          else
            text.add_verify_key_listener(@f_internal_listener)
          end
          @f_key_listener_hooked = true
        end
      end
    end
    
    typesig { [::Java::Int] }
    # Releases the previously acquired widget token if the token
    # is no longer necessary.
    # The following are valid listener types:
    # <ul>
    # <li>AUTO_ASSIST
    # <li>CONTEXT_SELECTOR
    # <li>PROPOSAL_SELECTOR
    # <li>CONTEXT_INFO_POPUP
    # <ul>
    # 
    # @param type the listener type
    # @since 2.0
    def release_widget_token(type)
      if ((@f_listeners[CONTEXT_SELECTOR]).nil? && (@f_listeners[PROPOSAL_SELECTOR]).nil?)
        if (@f_viewer.is_a?(IWidgetTokenOwner))
          owner = @f_viewer
          owner.release_widget_token(self)
        end
      end
    end
    
    typesig { [IContentAssistListener2, ::Java::Int] }
    # Unregisters a content assist listener.
    # 
    # @param listener the listener to unregister
    # @param type the type of listener
    # 
    # @see #addContentAssistListener
    def remove_content_assist_listener(listener, type)
      @f_listeners[type] = nil
      if ((get_number_of_listeners).equal?(0))
        if (!(@f_closer).nil?)
          @f_closer.uninstall
          @f_closer = nil
        end
        uninstall_key_listener
        @f_viewer.set_event_consumer(nil)
      end
      release_widget_token(type)
    end
    
    typesig { [] }
    # Uninstall the key listener from the text viewer's widget.
    def uninstall_key_listener
      if (@f_key_listener_hooked)
        text = @f_viewer.get_text_widget
        if (Helper2.ok_to_use(text))
          if (@f_viewer.is_a?(ITextViewerExtension))
            e = @f_viewer
            e.remove_verify_key_listener(@f_internal_listener)
          else
            text.remove_verify_key_listener(@f_internal_listener)
          end
          @f_key_listener_hooked = false
        end
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
      return @f_proposal_popup.show_proposals(false)
    end
    
    typesig { [] }
    # Hides the proposal popup.
    def hide_possible_completions
      if (!(@f_proposal_popup).nil?)
        @f_proposal_popup.hide
      end
    end
    
    typesig { [] }
    # Hides any open pop-ups.
    def hide
      if (!(@f_proposal_popup).nil?)
        @f_proposal_popup.hide
      end
      if (!(@f_context_info_popup).nil?)
        @f_context_info_popup.hide
      end
    end
    
    typesig { [] }
    # Callback to signal this content assistant that the presentation of the possible completions has been stopped.
    # @since 2.1
    def possible_completions_closed
    end
    
    typesig { [] }
    # @see IContentAssist#showContextInformation
    def show_context_information
      return @f_context_info_popup.show_context_proposals(false)
    end
    
    typesig { [] }
    # Callback to signal this content assistant that the presentation of the context information has been stopped.
    # @since 2.1
    def context_information_closed
    end
    
    typesig { [IContextInformation, ::Java::Int] }
    # Requests that the specified context information to be shown.
    # 
    # @param contextInformation the context information to be shown
    # @param position the position to which the context information refers to
    # @since 2.0
    def show_context_information(context_information, position)
      @f_context_info_popup.show_context_information(context_information, position)
    end
    
    typesig { [] }
    # Returns the current content assist error message.
    # 
    # @return an error message or <code>null</code> if no error has occurred
    def get_error_message
      return @f_last_error_message
    end
    
    typesig { [ITextViewer, ::Java::Int] }
    # Returns the content assist processor for the content
    # type of the specified document position.
    # 
    # @param viewer the text viewer
    # @param offset a offset within the document
    # @return a content-assist processor or <code>null</code> if none exists
    def get_processor(viewer, offset)
      begin
        type = TextUtilities.get_content_type(viewer.get_document, get_document_partitioning, offset, true)
        return get_content_assist_processor(type)
      rescue BadLocationException => x
      end
      return nil
    end
    
    typesig { [ITextViewer, ::Java::Int] }
    # Returns an array of completion proposals computed based on
    # the specified document position. The position is used to
    # determine the appropriate content assist processor to invoke.
    # 
    # @param viewer the viewer for which to compute the proposals
    # @param position a document position
    # @return an array of completion proposals
    # 
    # @see IContentAssistProcessor#computeCompletionProposals
    def compute_completion_proposals(viewer, position)
      if (!(@f_proposals).nil?)
        return @f_proposals
      else
        if (!(@f_proposal_strings).nil?)
          result = Array.typed(ICompletionProposal).new(@f_proposal_strings.attr_length) { nil }
          i = 0
          while i < @f_proposal_strings.attr_length
            result[i] = CompletionProposal.new(@f_proposal_strings[i], position, @f_proposal_strings[i].length, @f_proposal_strings[i].length)
            i += 1
          end
          return result
        else
          return nil
        end
      end
    end
    
    typesig { [ITextViewer, ::Java::Int] }
    # Returns an array of context information objects computed based
    # on the specified document position. The position is used to determine
    # the appropriate content assist processor to invoke.
    # 
    # @param viewer the viewer for which to compute the context information
    # @param position a document position
    # @return an array of context information objects
    # 
    # @see IContentAssistProcessor#computeContextInformation
    def compute_context_information(viewer, position)
      @f_last_error_message = RJava.cast_to_string(nil)
      result = nil
      p = get_processor(viewer, position)
      if (!(p).nil?)
        result = p.compute_context_information(viewer, position)
        @f_last_error_message = RJava.cast_to_string(p.get_error_message)
      end
      return result
    end
    
    typesig { [ITextViewer, ::Java::Int] }
    # Returns the context information validator that should be used to
    # determine when the currently displayed context information should
    # be dismissed. The position is used to determine the appropriate
    # content assist processor to invoke.
    # 
    # @param textViewer the text viewer
    # @param offset a document offset
    # @return an validator
    # 
    # @see IContentAssistProcessor#getContextInformationValidator
    def get_context_information_validator(text_viewer, offset)
      p = get_processor(text_viewer, offset)
      return !(p).nil? ? p.get_context_information_validator : nil
    end
    
    typesig { [ITextViewer, ::Java::Int] }
    # Returns the context information presenter that should be used to
    # display context information. The position is used to determine the appropriate
    # content assist processor to invoke.
    # 
    # @param textViewer the text viewer
    # @param offset a document offset
    # @return a presenter
    # @since 2.0
    def get_context_information_presenter(text_viewer, offset)
      validator = get_context_information_validator(text_viewer, offset)
      if (validator.is_a?(IContextInformationPresenter))
        return validator
      end
      return nil
    end
    
    typesig { [ITextViewer, ::Java::Int] }
    # Returns the characters which when typed by the user should automatically
    # initiate proposing completions. The position is used to determine the
    # appropriate content assist processor to invoke.
    # 
    # @param textViewer the text viewer
    # @param offset a document offset
    # @return the auto activation characters
    # 
    # @see IContentAssistProcessor#getCompletionProposalAutoActivationCharacters
    def get_completion_proposal_auto_activation_characters(text_viewer, offset)
      p = get_processor(text_viewer, offset)
      return !(p).nil? ? p.get_completion_proposal_auto_activation_characters : nil
    end
    
    typesig { [ITextViewer, ::Java::Int] }
    # Returns the characters which when typed by the user should automatically
    # initiate the presentation of context information. The position is used
    # to determine the appropriate content assist processor to invoke.
    # 
    # @param textViewer the text viewer
    # @param offset a document offset
    # @return the auto activation characters
    # 
    # @see IContentAssistProcessor#getContextInformationAutoActivationCharacters
    def get_context_information_auto_activation_characters(text_viewer, offset)
      p = get_processor(text_viewer, offset)
      return !(p).nil? ? p.get_context_information_auto_activation_characters : nil
    end
    
    typesig { [IWidgetTokenOwner] }
    # @see org.eclipse.jface.text.IWidgetTokenKeeper#requestWidgetToken(IWidgetTokenOwner)
    # @since 2.0
    def request_widget_token(owner)
      hide_possible_completions
      return true
    end
    
    typesig { [::Java::Int] }
    # @param completionPosition the completion position
    def set_completion_position(completion_position)
      @f_completion_position = completion_position
    end
    
    typesig { [] }
    # @return the completion position
    def get_completion_position
      return @f_completion_position
    end
    
    typesig { [Array.typed(String)] }
    # @param proposals the proposals
    def set_completions(proposals)
      @f_proposal_strings = proposals
    end
    
    typesig { [Array.typed(ICompletionProposal)] }
    # @param proposals the proposals
    def set_completions(proposals)
      @f_proposals = proposals
    end
    
    typesig { [IWidgetTokenOwner, ::Java::Int] }
    # @see org.eclipse.jface.text.IWidgetTokenKeeperExtension#requestWidgetToken(org.eclipse.jface.text.IWidgetTokenOwner, int)
    # @since 3.0
    def request_widget_token(owner, priority)
      if (priority > WIDGET_PRIORITY)
        hide_possible_completions
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
    # Returns whether any popups controlled by the receiver have the input focus.
    # 
    # @return <code>true</code> if any of the managed popups have the focus, <code>false</code> otherwise
    def has_focus
      return (!(@f_proposal_popup).nil? && @f_proposal_popup.has_focus) || (!(@f_context_info_popup).nil? && @f_context_info_popup.has_focus)
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.contentassist.IContentAssistantExtension#completePrefix()
    def complete_prefix
      return nil
    end
    
    typesig { [ICompletionProposal] }
    # @param proposal the proposal
    def fire_proposal_chosen(proposal)
      list = ArrayList.new(@f_proposal_listeners)
      it = list.iterator
      while it.has_next
        listener = it.next_
        listener.proposal_chosen(proposal)
      end
    end
    
    typesig { [IProposalListener] }
    # @param listener the proposal listener
    def remove_proposal_listener(listener)
      @f_proposal_listeners.remove(listener)
    end
    
    typesig { [IProposalListener] }
    # @param listener the proposal listener
    def add_proposal_listener(listener)
      @f_proposal_listeners.add(listener)
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
    alias_method :initialize__content_assistant2, :initialize
  end
  
end
