require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text
  module AbstractHoverInformationControlManagerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Events, :ControlEvent
      include_const ::Org::Eclipse::Swt::Events, :ControlListener
      include_const ::Org::Eclipse::Swt::Events, :KeyEvent
      include_const ::Org::Eclipse::Swt::Events, :KeyListener
      include_const ::Org::Eclipse::Swt::Events, :MouseEvent
      include_const ::Org::Eclipse::Swt::Events, :MouseListener
      include_const ::Org::Eclipse::Swt::Events, :MouseMoveListener
      include_const ::Org::Eclipse::Swt::Events, :MouseTrackListener
      include_const ::Org::Eclipse::Swt::Events, :SelectionEvent
      include_const ::Org::Eclipse::Swt::Events, :SelectionListener
      include_const ::Org::Eclipse::Swt::Events, :ShellAdapter
      include_const ::Org::Eclipse::Swt::Events, :ShellEvent
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Graphics, :Rectangle
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Display
      include_const ::Org::Eclipse::Swt::Widgets, :Event
      include_const ::Org::Eclipse::Swt::Widgets, :Listener
      include_const ::Org::Eclipse::Swt::Widgets, :ScrollBar
      include_const ::Org::Eclipse::Swt::Widgets, :Scrollable
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Core::Runtime, :IProgressMonitor
      include_const ::Org::Eclipse::Core::Runtime, :IStatus
      include_const ::Org::Eclipse::Core::Runtime, :Status
      include_const ::Org::Eclipse::Core::Runtime::Jobs, :Job
      include_const ::Org::Eclipse::Jface::Internal::Text, :DelayedInputChangeListener
      include_const ::Org::Eclipse::Jface::Internal::Text, :InformationControlReplacer
      include_const ::Org::Eclipse::Jface::Internal::Text, :InternalAccessor
      include_const ::Org::Eclipse::Jface::Util, :Geometry
      include_const ::Org::Eclipse::Jface::Text::ITextViewerExtension8, :EnrichMode
      include_const ::Org::Eclipse::Jface::Text::Source, :AnnotationBarHoverManager
    }
  end
  
  # An information control manager that shows information in response to mouse
  # hover events. The mouse hover events are caught by registering a
  # {@link org.eclipse.swt.events.MouseTrackListener} on the manager's subject
  # control. The manager has by default an information control closer that closes
  # the information control as soon as the mouse pointer leaves the subject area,
  # the user presses a key, or the subject control is resized, moved, or
  # deactivated.
  # <p>
  # When being activated by a mouse hover event, the manager disables itself,
  # until the mouse leaves the subject area. Thus, the manager is usually still
  # disabled, when the information control has already been closed by the closer.
  # 
  # @see org.eclipse.swt.events.MouseTrackListener
  # @since 2.0
  class AbstractHoverInformationControlManager < AbstractHoverInformationControlManagerImports.const_get :AbstractInformationControlManager
    include_class_members AbstractHoverInformationControlManagerImports
    
    class_module.module_eval {
      # The  information control closer for the hover information. Closes the information control as
      # soon as the mouse pointer leaves the subject area (unless "move into hover" is enabled),
      # a mouse button is pressed, the user presses a key, or the subject control is resized, moved, or loses focus.
      const_set_lazy(:Closer) { Class.new do
        local_class_in AbstractHoverInformationControlManager
        include_class_members AbstractHoverInformationControlManager
        include IInformationControlCloser
        include MouseListener
        include MouseMoveListener
        include ControlListener
        include KeyListener
        include SelectionListener
        include Listener
        
        # The closer's subject control
        attr_accessor :f_subject_control
        alias_method :attr_f_subject_control, :f_subject_control
        undef_method :f_subject_control
        alias_method :attr_f_subject_control=, :f_subject_control=
        undef_method :f_subject_control=
        
        # The subject area
        attr_accessor :f_subject_area
        alias_method :attr_f_subject_area, :f_subject_area
        undef_method :f_subject_area
        alias_method :attr_f_subject_area=, :f_subject_area=
        undef_method :f_subject_area=
        
        # Indicates whether this closer is active
        attr_accessor :f_is_active
        alias_method :attr_f_is_active, :f_is_active
        undef_method :f_is_active
        alias_method :attr_f_is_active=, :f_is_active=
        undef_method :f_is_active=
        
        # The cached display.
        # @since 3.1
        attr_accessor :f_display
        alias_method :attr_f_display, :f_display
        undef_method :f_display
        alias_method :attr_f_display=, :f_display=
        undef_method :f_display=
        
        typesig { [] }
        # Creates a new information control closer.
        def initialize
          @f_subject_control = nil
          @f_subject_area = nil
          @f_is_active = false
          @f_display = nil
        end
        
        typesig { [class_self::Control] }
        # @see IInformationControlCloser#setSubjectControl(Control)
        def set_subject_control(control)
          @f_subject_control = control
        end
        
        typesig { [class_self::IInformationControl] }
        # @see IInformationControlCloser#setHoverControl(IHoverControl)
        def set_information_control(control)
          # NOTE: we use getCurrentInformationControl() from the outer class
        end
        
        typesig { [class_self::Rectangle] }
        # @see IInformationControlCloser#start(Rectangle)
        def start(subject_area)
          if (@f_is_active)
            return
          end
          @f_is_active = true
          self.attr_f_wait_for_mouse_up = false
          @f_subject_area = subject_area
          if (!(@f_subject_control).nil? && !@f_subject_control.is_disposed)
            @f_subject_control.add_mouse_listener(self)
            @f_subject_control.add_mouse_move_listener(self)
            @f_subject_control.add_control_listener(self)
            @f_subject_control.add_key_listener(self)
            if (@f_subject_control.is_a?(self.class::Scrollable))
              scrollable = @f_subject_control
              v_bar = scrollable.get_vertical_bar
              if (!(v_bar).nil?)
                v_bar.add_selection_listener(self)
              end
              h_bar = scrollable.get_horizontal_bar
              if (!(h_bar).nil?)
                h_bar.add_selection_listener(self)
              end
            end
            @f_display = @f_subject_control.get_display
            if (!@f_display.is_disposed)
              @f_display.add_filter(SWT::Activate, self)
              @f_display.add_filter(SWT::MouseWheel, self)
              @f_display.add_filter(SWT::FocusOut, self)
              @f_display.add_filter(SWT::MouseDown, self)
              @f_display.add_filter(SWT::MouseUp, self)
              @f_display.add_filter(SWT::MouseMove, self)
              @f_display.add_filter(SWT::MouseEnter, self)
              @f_display.add_filter(SWT::MouseExit, self)
            end
          end
        end
        
        typesig { [] }
        # @see IInformationControlCloser#stop()
        def stop
          if (!@f_is_active)
            return
          end
          @f_is_active = false
          if (DEBUG)
            System.out.println("AbstractHoverInformationControlManager.Closer stopped")
          end # $NON-NLS-1$
          if (!(@f_subject_control).nil? && !@f_subject_control.is_disposed)
            @f_subject_control.remove_mouse_listener(self)
            @f_subject_control.remove_mouse_move_listener(self)
            @f_subject_control.remove_control_listener(self)
            @f_subject_control.remove_key_listener(self)
            if (@f_subject_control.is_a?(self.class::Scrollable))
              scrollable = @f_subject_control
              v_bar = scrollable.get_vertical_bar
              if (!(v_bar).nil?)
                v_bar.remove_selection_listener(self)
              end
              h_bar = scrollable.get_horizontal_bar
              if (!(h_bar).nil?)
                h_bar.remove_selection_listener(self)
              end
            end
          end
          if (!(@f_display).nil? && !@f_display.is_disposed)
            @f_display.remove_filter(SWT::Activate, self)
            @f_display.remove_filter(SWT::MouseWheel, self)
            @f_display.remove_filter(SWT::FocusOut, self)
            @f_display.remove_filter(SWT::MouseDown, self)
            @f_display.remove_filter(SWT::MouseUp, self)
            @f_display.remove_filter(SWT::MouseMove, self)
            @f_display.remove_filter(SWT::MouseEnter, self)
            @f_display.remove_filter(SWT::MouseExit, self)
          end
          @f_display = nil
        end
        
        typesig { [class_self::MouseEvent] }
        # @see org.eclipse.swt.events.MouseMoveListener#mouseMove(org.eclipse.swt.events.MouseEvent)
        def mouse_move(event)
          if (!has_information_control_replacer || !can_move_into_information_control(get_current_information_control))
            if (!@f_subject_area.contains(event.attr_x, event.attr_y))
              hide_information_control
            end
          else
            if (!(get_current_information_control).nil? && !get_current_information_control.is_focus_control)
              if (!in_keep_up_zone(event.attr_x, event.attr_y, @f_subject_control, @f_subject_area, true))
                hide_information_control
              end
            end
          end
        end
        
        typesig { [class_self::MouseEvent] }
        # @see org.eclipse.swt.events.MouseListener#mouseUp(org.eclipse.swt.events.MouseEvent)
        def mouse_up(event)
        end
        
        typesig { [class_self::MouseEvent] }
        # @see MouseListener#mouseDown(MouseEvent)
        def mouse_down(event)
          hide_information_control
        end
        
        typesig { [class_self::MouseEvent] }
        # @see MouseListener#mouseDoubleClick(MouseEvent)
        def mouse_double_click(event)
          hide_information_control
        end
        
        typesig { [class_self::ControlEvent] }
        # @see ControlListener#controlResized(ControlEvent)
        def control_resized(event)
          hide_information_control
        end
        
        typesig { [class_self::ControlEvent] }
        # @see ControlListener#controlMoved(ControlEvent)
        def control_moved(event)
          hide_information_control
        end
        
        typesig { [class_self::KeyEvent] }
        # @see KeyListener#keyReleased(KeyEvent)
        def key_released(event)
        end
        
        typesig { [class_self::KeyEvent] }
        # @see KeyListener#keyPressed(KeyEvent)
        def key_pressed(event)
          hide_information_control
        end
        
        typesig { [class_self::SelectionEvent] }
        # @see org.eclipse.swt.events.SelectionListener#widgetSelected(org.eclipse.swt.events.SelectionEvent)
        def widget_selected(e)
          hide_information_control
        end
        
        typesig { [class_self::SelectionEvent] }
        # @see org.eclipse.swt.events.SelectionListener#widgetDefaultSelected(org.eclipse.swt.events.SelectionEvent)
        def widget_default_selected(e)
        end
        
        typesig { [class_self::Event] }
        # @see org.eclipse.swt.widgets.Listener#handleEvent(org.eclipse.swt.widgets.Event)
        # @since 3.1
        def handle_event(event)
          case (event.attr_type)
          when SWT::Activate, SWT::MouseWheel
            if (!has_information_control_replacer)
              hide_information_control
            else
              if (!is_replace_in_progress)
                info_control = get_current_information_control
                # During isReplaceInProgress(), events can come from the replacing information control
                if (event.attr_widget.is_a?(self.class::Control) && info_control.is_a?(self.class::IInformationControlExtension5))
                  control = event.attr_widget
                  i_control5 = info_control
                  if (!(i_control5.contains_control(control)))
                    hide_information_control
                  else
                    if ((event.attr_type).equal?(SWT::MouseWheel) && cancel_replacing_delay)
                      replace_information_control(false)
                    end
                  end
                else
                  if (!(info_control).nil? && info_control.is_focus_control && cancel_replacing_delay)
                    replace_information_control(true)
                  end
                end
              end
            end
          when SWT::MouseUp, SWT::MouseDown
            if (!has_information_control_replacer)
              hide_information_control
            else
              if (!is_replace_in_progress)
                info_control = get_current_information_control
                if (event.attr_widget.is_a?(self.class::Control) && info_control.is_a?(self.class::IInformationControlExtension5))
                  control = event.attr_widget
                  i_control5 = info_control
                  if (!(i_control5.contains_control(control)))
                    hide_information_control
                  else
                    if (cancel_replacing_delay)
                      if ((event.attr_type).equal?(SWT::MouseUp))
                        stop # avoid that someone else replaces the info control before the async is exec'd
                        if (info_control.is_a?(self.class::IDelayedInputChangeProvider))
                          delayed_icp = info_control
                          input_change_listener = self.class::DelayedInputChangeListener.new(delayed_icp, get_information_control_replacer)
                          delayed_icp.set_delayed_input_change_listener(input_change_listener)
                          control.get_shell.get_display.timer_exec(1000, # cancel automatic input updating after a small timeout:
                          Class.new(self.class::Runnable.class == Class ? self.class::Runnable : Object) do
                            local_class_in Closer
                            include_class_members Closer
                            include class_self::Runnable if class_self::Runnable.class == Module
                            
                            typesig { [] }
                            define_method :run do
                              delayed_icp.set_delayed_input_change_listener(nil)
                            end
                            
                            typesig { [Vararg.new(Object)] }
                            define_method :initialize do |*args|
                              super(*args)
                            end
                            
                            private
                            alias_method :initialize_anonymous, :initialize
                          end.new_local(self))
                        end
                        control.get_shell.get_display.async_exec(# XXX: workaround for https://bugs.eclipse.org/bugs/show_bug.cgi?id=212392 :
                        Class.new(self.class::Runnable.class == Class ? self.class::Runnable : Object) do
                          local_class_in Closer
                          include_class_members Closer
                          include class_self::Runnable if class_self::Runnable.class == Module
                          
                          typesig { [] }
                          define_method :run do
                            replace_information_control(true)
                          end
                          
                          typesig { [Vararg.new(Object)] }
                          define_method :initialize do |*args|
                            super(*args)
                          end
                          
                          private
                          alias_method :initialize_anonymous, :initialize
                        end.new_local(self))
                      else
                        self.attr_f_wait_for_mouse_up = true
                      end
                    end
                  end
                else
                  handle_mouse_move(event)
                end
              end
            end
          when SWT::FocusOut
            i_control = get_current_information_control
            if (!(i_control).nil? && !i_control.is_focus_control)
              hide_information_control
            end
          when SWT::MouseMove, SWT::MouseEnter, SWT::MouseExit
            handle_mouse_move(event)
          end
        end
        
        typesig { [class_self::Event] }
        # Handle mouse movement events.
        # 
        # @param event the event
        # @since 3.4
        def handle_mouse_move(event)
          # if (DEBUG)
          # System.out.println("AbstractHoverInformationControl.Closer.handleMouseMove():" + event); //$NON-NLS-1$
          if (!(event.attr_widget.is_a?(self.class::Control)))
            return
          end
          event_control = event.attr_widget
          # transform coordinates to subject control:
          mouse_loc = event.attr_display.map(event_control, @f_subject_control, event.attr_x, event.attr_y)
          if (@f_subject_area.contains(mouse_loc))
            return
          end
          i_control = get_current_information_control
          if (!has_information_control_replacer || !can_move_into_information_control(i_control))
            if (@local_class_parent.is_a?(self.class::AnnotationBarHoverManager))
              if (get_internal_accessor.get_allow_mouse_exit)
                return
              end
            end
            hide_information_control
            return
          end
          i_control3 = i_control
          control_bounds = i_control3.get_bounds
          if (!(control_bounds).nil?)
            tooltip_bounds = event.attr_display.map(nil, event_control, control_bounds)
            if (tooltip_bounds.contains(event.attr_x, event.attr_y))
              if (!is_replace_in_progress && !(event.attr_type).equal?(SWT::MouseExit))
                start_replace_information_control(event.attr_display)
              end
              return
            end
            cancel_replacing_delay
          end
          if (!@f_subject_control.get_bounds.contains(mouse_loc))
            # Use inKeepUpZone() to make sure it also works when the hover is
            # completely outside of the subject control.
            if (!in_keep_up_zone(mouse_loc.attr_x, mouse_loc.attr_y, @f_subject_control, @f_subject_area, true))
              hide_information_control
              return
            end
          end
        end
        
        private
        alias_method :initialize__closer, :initialize
      end }
      
      # To be installed on the manager's subject control.  Serves two different purposes:
      # <ul>
      # <li> start function: initiates the computation of the information to be presented. This happens on
      # receipt of a mouse hover event and disables the information control manager,
      # <li> restart function: tracks mouse move and shell activation event to determine when the information
      # control manager needs to be reactivated.
      # </ul>
      const_set_lazy(:MouseTracker) { Class.new(ShellAdapter) do
        local_class_in AbstractHoverInformationControlManager
        include_class_members AbstractHoverInformationControlManager
        overload_protected {
          include MouseTrackListener
          include MouseMoveListener
        }
        
        class_module.module_eval {
          # Margin around the original hover event location for computing the hover area.
          const_set_lazy(:EPSILON) { 3 }
          const_attr_reader  :EPSILON
        }
        
        # The area in which the original hover event occurred.
        attr_accessor :f_hover_area
        alias_method :attr_f_hover_area, :f_hover_area
        undef_method :f_hover_area
        alias_method :attr_f_hover_area=, :f_hover_area=
        undef_method :f_hover_area=
        
        # The area for which is computed information is valid.
        attr_accessor :f_subject_area
        alias_method :attr_f_subject_area, :f_subject_area
        undef_method :f_subject_area
        alias_method :attr_f_subject_area=, :f_subject_area=
        undef_method :f_subject_area=
        
        # The tracker's subject control.
        attr_accessor :f_subject_control
        alias_method :attr_f_subject_control, :f_subject_control
        undef_method :f_subject_control
        alias_method :attr_f_subject_control=, :f_subject_control=
        undef_method :f_subject_control=
        
        # Indicates whether the tracker is in restart mode ignoring hover events.
        attr_accessor :f_is_in_restart_mode
        alias_method :attr_f_is_in_restart_mode, :f_is_in_restart_mode
        undef_method :f_is_in_restart_mode
        alias_method :attr_f_is_in_restart_mode=, :f_is_in_restart_mode=
        undef_method :f_is_in_restart_mode=
        
        # Indicates whether the tracker is computing the information to be presented.
        attr_accessor :f_is_computing
        alias_method :attr_f_is_computing, :f_is_computing
        undef_method :f_is_computing
        alias_method :attr_f_is_computing=, :f_is_computing=
        undef_method :f_is_computing=
        
        # Indicates whether the mouse has been lost.
        attr_accessor :f_mouse_lost_while_computing
        alias_method :attr_f_mouse_lost_while_computing, :f_mouse_lost_while_computing
        undef_method :f_mouse_lost_while_computing
        alias_method :attr_f_mouse_lost_while_computing=, :f_mouse_lost_while_computing=
        undef_method :f_mouse_lost_while_computing=
        
        # Indicates whether the subject control's shell has been deactivated.
        attr_accessor :f_shell_deactivated_while_computing
        alias_method :attr_f_shell_deactivated_while_computing, :f_shell_deactivated_while_computing
        undef_method :f_shell_deactivated_while_computing
        alias_method :attr_f_shell_deactivated_while_computing=, :f_shell_deactivated_while_computing=
        undef_method :f_shell_deactivated_while_computing=
        
        typesig { [] }
        # Creates a new mouse tracker.
        def initialize
          @f_hover_area = nil
          @f_subject_area = nil
          @f_subject_control = nil
          @f_is_in_restart_mode = false
          @f_is_computing = false
          @f_mouse_lost_while_computing = false
          @f_shell_deactivated_while_computing = false
          super()
          @f_is_in_restart_mode = false
          @f_is_computing = false
          @f_mouse_lost_while_computing = false
          @f_shell_deactivated_while_computing = false
        end
        
        typesig { [class_self::Rectangle] }
        # Sets this mouse tracker's subject area, the area to be tracked in order
        # to re-enable the information control manager.
        # 
        # @param subjectArea the subject area
        def set_subject_area(subject_area)
          Assert.is_not_null(subject_area)
          @f_subject_area = subject_area
        end
        
        typesig { [class_self::Control] }
        # Starts this mouse tracker. The given control becomes this tracker's subject control.
        # Installs itself as mouse track listener on the subject control.
        # 
        # @param subjectControl the subject control
        def start(subject_control)
          @f_subject_control = subject_control
          if (!(@f_subject_control).nil? && !@f_subject_control.is_disposed)
            @f_subject_control.add_mouse_track_listener(self)
          end
          @f_is_in_restart_mode = false
          @f_is_computing = false
          @f_mouse_lost_while_computing = false
          @f_shell_deactivated_while_computing = false
        end
        
        typesig { [] }
        # Stops this mouse tracker. Removes itself  as mouse track, mouse move, and
        # shell listener from the subject control.
        def stop
          if (!(@f_subject_control).nil? && !@f_subject_control.is_disposed)
            @f_subject_control.remove_mouse_track_listener(self)
            @f_subject_control.remove_mouse_move_listener(self)
            @f_subject_control.get_shell.remove_shell_listener(self)
          end
        end
        
        typesig { [class_self::MouseEvent] }
        # Initiates the computation of the information to be presented. Sets the initial hover area
        # to a small rectangle around the hover event location. Adds mouse move and shell activation listeners
        # to track whether the computed information is, after completion, useful for presentation and to
        # implement the restart function.
        # 
        # @param event the mouse hover event
        def mouse_hover(event)
          if (@f_is_computing || @f_is_in_restart_mode || (!(@f_subject_control).nil? && !@f_subject_control.is_disposed && !(@f_subject_control.get_shell).equal?(@f_subject_control.get_shell.get_display.get_active_shell)))
            if (DEBUG)
              System.out.println("AbstractHoverInformationControlManager...mouseHover: @ " + RJava.cast_to_string(event.attr_x) + "/" + RJava.cast_to_string(event.attr_y) + " : hover cancelled: fIsComputing= " + RJava.cast_to_string(@f_is_computing) + ", fIsInRestartMode= " + RJava.cast_to_string(@f_is_in_restart_mode))
            end # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$ //$NON-NLS-4$
            return
          end
          @f_is_in_restart_mode = true
          @f_is_computing = true
          @f_mouse_lost_while_computing = false
          @f_shell_deactivated_while_computing = false
          self.attr_f_hover_event_state_mask = event.attr_state_mask
          self.attr_f_hover_event = event
          @f_hover_area = self.class::Rectangle.new(event.attr_x - self.class::EPSILON, event.attr_y - self.class::EPSILON, 2 * self.class::EPSILON, 2 * self.class::EPSILON)
          if (@f_hover_area.attr_x < 0)
            @f_hover_area.attr_x = 0
          end
          if (@f_hover_area.attr_y < 0)
            @f_hover_area.attr_y = 0
          end
          set_subject_area(@f_hover_area)
          if (!(@f_subject_control).nil? && !@f_subject_control.is_disposed)
            @f_subject_control.add_mouse_move_listener(self)
            @f_subject_control.get_shell.add_shell_listener(self)
          end
          do_show_information
        end
        
        typesig { [] }
        # Deactivates this tracker's restart function and enables the information control
        # manager. Does not have any effect if the tracker is still executing the start function (i.e.
        # computing the information to be presented.
        def deactivate
          if (@f_is_computing)
            return
          end
          @f_is_in_restart_mode = false
          if (!(@f_subject_control).nil? && !@f_subject_control.is_disposed)
            @f_subject_control.remove_mouse_move_listener(self)
            @f_subject_control.get_shell.remove_shell_listener(self)
          end
        end
        
        typesig { [class_self::MouseEvent] }
        # @see MouseTrackListener#mouseEnter(MouseEvent)
        def mouse_enter(e)
        end
        
        typesig { [class_self::MouseEvent] }
        # @see MouseTrackListener#mouseExit(MouseEvent)
        def mouse_exit(e)
          if (!has_information_control_replacer || !can_move_into_information_control(get_current_information_control) || !in_keep_up_zone(e.attr_x, e.attr_y, @f_subject_control, @f_subject_area, false))
            @f_mouse_lost_while_computing = true
            deactivate
          end
        end
        
        typesig { [class_self::MouseEvent] }
        # @see MouseMoveListener#mouseMove(MouseEvent)
        def mouse_move(event)
          if (!has_information_control_replacer || !can_move_into_information_control(get_current_information_control))
            if (!@f_subject_area.contains(event.attr_x, event.attr_y))
              deactivate
            end
          else
            if (!in_keep_up_zone(event.attr_x, event.attr_y, @f_subject_control, @f_subject_area, false))
              deactivate
            end
          end
        end
        
        typesig { [class_self::ShellEvent] }
        # @see ShellListener#shellDeactivated(ShellEvent)
        def shell_deactivated(e)
          @f_shell_deactivated_while_computing = true
          deactivate
        end
        
        typesig { [class_self::ShellEvent] }
        # @see ShellListener#shellIconified(ShellEvent)
        def shell_iconified(e)
          @f_shell_deactivated_while_computing = true
          deactivate
        end
        
        typesig { [] }
        # Tells this tracker that the start function processing has been completed.
        def computation_completed
          @f_is_computing = false
          @f_mouse_lost_while_computing = false
          @f_shell_deactivated_while_computing = false
        end
        
        typesig { [] }
        # Determines whether the computed information is still useful for presentation.
        # This is not the case, if the shell of the subject control has been deactivated, the mouse
        # left the subject control, or the mouse moved on, so that it is no longer in the subject
        # area.
        # 
        # @return <code>true</code> if information is still useful for presentation, <code>false</code> otherwise
        def is_mouse_lost
          if (@f_mouse_lost_while_computing || @f_shell_deactivated_while_computing)
            return true
          end
          if (!(@f_subject_control).nil? && !@f_subject_control.is_disposed)
            display = @f_subject_control.get_display
            p = display.get_cursor_location
            p = @f_subject_control.to_control(p)
            if (!@f_subject_area.contains(p) && !@f_hover_area.contains(p))
              return true
            end
          end
          return false
        end
        
        private
        alias_method :initialize__mouse_tracker, :initialize
      end }
      
      # The delay in {@link ITextViewerExtension8.EnrichMode#AFTER_DELAY} mode after which
      # the hover is enriched when the mouse has stopped moving inside the hover.
      # @since 3.4
      const_set_lazy(:HOVER_AUTO_REPLACING_DELAY) { 200 }
      const_attr_reader  :HOVER_AUTO_REPLACING_DELAY
    }
    
    # The mouse tracker on the subject control
    attr_accessor :f_mouse_tracker
    alias_method :attr_f_mouse_tracker, :f_mouse_tracker
    undef_method :f_mouse_tracker
    alias_method :attr_f_mouse_tracker=, :f_mouse_tracker=
    undef_method :f_mouse_tracker=
    
    # The remembered hover event.
    # @since 3.0
    attr_accessor :f_hover_event
    alias_method :attr_f_hover_event, :f_hover_event
    undef_method :f_hover_event
    alias_method :attr_f_hover_event=, :f_hover_event=
    undef_method :f_hover_event=
    
    # The remembered hover event state mask of the keyboard modifiers
    attr_accessor :f_hover_event_state_mask
    alias_method :attr_f_hover_event_state_mask, :f_hover_event_state_mask
    undef_method :f_hover_event_state_mask
    alias_method :attr_f_hover_event_state_mask=, :f_hover_event_state_mask=
    undef_method :f_hover_event_state_mask=
    
    # The thread that delays replacing of the hover information control.
    # To be accessed in the UI thread only!
    # 
    # @since 3.4
    attr_accessor :f_replacing_delay_job
    alias_method :attr_f_replacing_delay_job, :f_replacing_delay_job
    undef_method :f_replacing_delay_job
    alias_method :attr_f_replacing_delay_job=, :f_replacing_delay_job=
    undef_method :f_replacing_delay_job=
    
    # The {@link ITextViewerExtension8.EnrichMode}, may be <code>null</code>.
    # @since 3.4
    attr_accessor :f_enrich_mode
    alias_method :attr_f_enrich_mode, :f_enrich_mode
    undef_method :f_enrich_mode
    alias_method :attr_f_enrich_mode=, :f_enrich_mode=
    undef_method :f_enrich_mode=
    
    # Indicates whether we have received a MouseDown event and are waiting for a MouseUp
    # (and don't replace the information control until that happened).
    # @since 3.4
    attr_accessor :f_wait_for_mouse_up
    alias_method :attr_f_wait_for_mouse_up, :f_wait_for_mouse_up
    undef_method :f_wait_for_mouse_up
    alias_method :attr_f_wait_for_mouse_up=, :f_wait_for_mouse_up=
    undef_method :f_wait_for_mouse_up=
    
    typesig { [IInformationControlCreator] }
    # Creates a new hover information control manager using the given information control creator.
    # By default a <code>Closer</code> instance is set as this manager's closer.
    # 
    # @param creator the information control creator
    def initialize(creator)
      @f_mouse_tracker = nil
      @f_hover_event = nil
      @f_hover_event_state_mask = 0
      @f_replacing_delay_job = nil
      @f_enrich_mode = nil
      @f_wait_for_mouse_up = false
      super(creator)
      @f_mouse_tracker = MouseTracker.new_local(self)
      @f_hover_event = nil
      @f_hover_event_state_mask = 0
      @f_wait_for_mouse_up = false
      set_closer(Closer.new_local(self))
      set_hover_enrich_mode(ITextViewerExtension8::EnrichMode::AFTER_DELAY)
    end
    
    typesig { [::Java::Int, ::Java::Int, Control, Rectangle, ::Java::Boolean] }
    # Tests whether a given mouse location is within the keep-up zone.
    # The hover should not be hidden as long as the mouse stays inside this zone.
    # 
    # @param x the x coordinate, relative to the <em>subject control</em>
    # @param y the y coordinate, relative to the <em>subject control</em>
    # @param subjectControl the subject control
    # @param subjectArea the area for which the presented information is valid
    # @param blowUp If <code>true</code>, then calculate for the closer, i.e. blow up the keepUp area.
    # If <code>false</code>, then use tight bounds for hover detection.
    # 
    # @return <code>true</code> iff the mouse event occurred in the keep-up zone
    # @since 3.4
    def in_keep_up_zone(x, y, subject_control, subject_area, blow_up)
      if (subject_area.contains(x, y))
        return true
      end
      i_control = get_current_information_control
      if ((i_control.is_a?(IInformationControlExtension5) && !(i_control).is_visible))
        i_control = nil
        if (!(get_information_control_replacer).nil?)
          i_control = get_information_control_replacer.get_current_information_control2
          if ((i_control.is_a?(IInformationControlExtension5) && !(i_control).is_visible))
            return false
          end
        end
      end
      if (i_control.is_a?(IInformationControlExtension3))
        i_control3 = i_control
        i_control_bounds = subject_control.get_display.map(nil, subject_control, i_control3.get_bounds)
        total_bounds = Geometry.copy(i_control_bounds)
        if (blow_up && is_replace_in_progress)
          # Problem: blown up iControl overlaps rest of subjectArea's line
          # solution for now: only blow up for keep up (closer), but not for further hover detection
          margin = get_information_control_replacer.get_keep_up_margin
          Geometry.expand(total_bounds, margin, margin, margin, margin)
        end
        if (!blow_up)
          if (i_control_bounds.contains(x, y))
            return true
          end
          if (subject_area.attr_y + subject_area.attr_height < i_control_bounds.attr_y)
            # special case for hover events: subjectArea totally above iControl:
            # +-----------+
            # |subjectArea|
            # +-----------+
            # |also keepUp|
            # ++-----------+-------+
            # | InformationControl |
            # +--------------------+
            if (subject_area.attr_y + subject_area.attr_height <= y && y <= total_bounds.attr_y)
              # is vertically between subject area and iControl
              if (subject_area.attr_x <= x && x <= subject_area.attr_x + subject_area.attr_width)
                # is below subject area (in a vertical projection)
                return true
              end
              # FIXME: cases when subjectArea extends to left or right of iControl?
            end
            return false
          else
            if (i_control_bounds.attr_x + i_control_bounds.attr_width < subject_area.attr_x)
              # special case for hover events (e.g. in overview ruler): iControl totally left of subjectArea
              # +--------------------+-----------+
              # |                    |           +-----------+
              # | InformationControl |also keepUp|subjectArea|
              # |                    |           +-----------+
              # +--------------------+-----------+
              if (i_control_bounds.attr_x + i_control_bounds.attr_width <= x && x <= subject_area.attr_x)
                # is horizontally between iControl and subject area
                if (i_control_bounds.attr_y <= y && y <= i_control_bounds.attr_y + i_control_bounds.attr_height)
                  # is to the right of iControl (in a horizontal projection)
                  return true
                end
              end
              return false
            else
              if (subject_area.attr_x + subject_area.attr_width < i_control_bounds.attr_x)
                # special case for hover events (e.g. in annotation ruler): subjectArea totally left of iControl
                # +-----------+--------------------+
                # +-----------+           |                    |
                # |subjectArea|also keepUp| InformationControl |
                # +-----------+           |                    |
                # +-----------+--------------------+
                if (subject_area.attr_x + subject_area.attr_width <= x && x <= i_control_bounds.attr_x)
                  # is horizontally between subject area and iControl
                  if (i_control_bounds.attr_y <= y && y <= i_control_bounds.attr_y + i_control_bounds.attr_height)
                    # is to the left of iControl (in a horizontal projection)
                    return true
                  end
                end
                return false
              end
            end
          end
        end
        # FIXME: should maybe use convex hull, not bounding box
        total_bounds.add(subject_area)
        if (total_bounds.contains(x, y))
          return true
        end
      end
      return false
    end
    
    typesig { [IInformationControl] }
    # Tests whether the given information control allows the mouse to be moved
    # into it.
    # 
    # @param iControl information control or <code>null</code> if none
    # @return <code>true</code> if information control allows mouse move into
    # control, <code>false</code> otherwise
    def can_move_into_information_control(i_control)
      return !(@f_enrich_mode).nil? && can_replace(i_control)
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.AbstractInformationControlManager#hideInformationControl()
    def hide_information_control
      cancel_replacing_delay
      super
    end
    
    typesig { [EnrichMode] }
    # Sets the hover enrich mode. Only applicable when an information
    # control replacer has been set with
    # {@link #setInformationControlReplacer(InformationControlReplacer)} .
    # 
    # @param mode the enrich mode
    # @since 3.4
    # @see ITextViewerExtension8#setHoverEnrichMode(org.eclipse.jface.text.ITextViewerExtension8.EnrichMode)
    def set_hover_enrich_mode(mode)
      @f_enrich_mode = mode
    end
    
    typesig { [::Java::Boolean] }
    # @see org.eclipse.jface.text.AbstractInformationControlManager#replaceInformationControl(boolean)
    def replace_information_control(take_focus)
      @f_wait_for_mouse_up = false
      super(take_focus)
    end
    
    typesig { [] }
    # Cancels the replacing delay job.
    # @return <code>true</code> iff canceling was successful, <code>false</code> if replacing has already started
    def cancel_replacing_delay
      @f_wait_for_mouse_up = false
      if (!(@f_replacing_delay_job).nil? && !(@f_replacing_delay_job.get_state).equal?(Job::RUNNING))
        cancelled = @f_replacing_delay_job.cancel
        @f_replacing_delay_job = nil
        # if (DEBUG)
        # System.out.println("AbstractHoverInformationControlManager.cancelReplacingDelay(): cancelled=" + cancelled); //$NON-NLS-1$
        return cancelled
      end
      # if (DEBUG)
      # System.out.println("AbstractHoverInformationControlManager.cancelReplacingDelay(): not delayed"); //$NON-NLS-1$
      return true
    end
    
    typesig { [Display] }
    # Starts replacing the information control, considering the current
    # {@link ITextViewerExtension8.EnrichMode}.
    # If set to {@link ITextViewerExtension8.EnrichMode#AFTER_DELAY}, this
    # method cancels previous requests and restarts the delay timer.
    # 
    # @param display the display to be used for the call to
    # {@link #replaceInformationControl(boolean)} in the UI thread
    def start_replace_information_control(display)
      if ((@f_enrich_mode).equal?(EnrichMode::ON_CLICK))
        return
      end
      if (!(@f_replacing_delay_job).nil?)
        if (!(@f_replacing_delay_job.get_state).equal?(Job::RUNNING))
          if (@f_replacing_delay_job.cancel)
            if ((@f_enrich_mode).equal?(EnrichMode::IMMEDIATELY))
              @f_replacing_delay_job = nil
              if (!@f_wait_for_mouse_up)
                replace_information_control(false)
              end
            else
              # if (DEBUG)
              # System.out.println("AbstractHoverInformationControlManager.startReplaceInformationControl(): rescheduled"); //$NON-NLS-1$
              @f_replacing_delay_job.schedule(HOVER_AUTO_REPLACING_DELAY)
            end
          end
        end
        return
      end
      @f_replacing_delay_job = Class.new(Job.class == Class ? Job : Object) do
        local_class_in AbstractHoverInformationControlManager
        include_class_members AbstractHoverInformationControlManager
        include Job if Job.class == Module
        
        typesig { [IProgressMonitor] }
        # $NON-NLS-1$
        define_method :run do |monitor|
          if (monitor.is_canceled || display.is_disposed)
            return Status::CANCEL_STATUS
          end
          job_class = self.class
          display.sync_exec(Class.new(self.class::Runnable.class == Class ? self.class::Runnable : Object) do
            local_class_in job_class
            include_class_members job_class
            include class_self::Runnable if class_self::Runnable.class == Module
            
            typesig { [] }
            define_method :run do
              self.attr_f_replacing_delay_job = nil
              if (monitor.is_canceled)
                return
              end
              if (!self.attr_f_wait_for_mouse_up)
                replace_information_control(false)
              end
            end
            
            typesig { [Vararg.new(Object)] }
            define_method :initialize do |*args|
              super(*args)
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
          return Status::OK_STATUS
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self, "AbstractHoverInformationControlManager Replace Delayer")
      @f_replacing_delay_job.set_system(true)
      @f_replacing_delay_job.set_priority(Job::INTERACTIVE)
      # if (DEBUG)
      # System.out.println("AbstractHoverInformationControlManager.startReplaceInformationControl(): scheduled"); //$NON-NLS-1$
      @f_replacing_delay_job.schedule(HOVER_AUTO_REPLACING_DELAY)
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.AbstractInformationControlManager#presentInformation()
    def present_information
      if ((@f_mouse_tracker).nil?)
        super
        return
      end
      area = get_subject_area
      if (!(area).nil?)
        @f_mouse_tracker.set_subject_area(area)
      end
      if (@f_mouse_tracker.is_mouse_lost)
        @f_mouse_tracker.computation_completed
        @f_mouse_tracker.deactivate
      else
        @f_mouse_tracker.computation_completed
        super
      end
    end
    
    typesig { [::Java::Boolean] }
    # {@inheritDoc}
    # @deprecated visibility will be changed to protected
    def set_enabled(enabled)
      was = is_enabled
      super(enabled)
      is = is_enabled
      if (!(was).equal?(is) && !(@f_mouse_tracker).nil?)
        if (is)
          @f_mouse_tracker.start(get_subject_control)
        else
          @f_mouse_tracker.stop
        end
      end
    end
    
    typesig { [] }
    # Disposes this manager's information control.
    def dispose
      if (!(@f_mouse_tracker).nil?)
        @f_mouse_tracker.stop
        @f_mouse_tracker.attr_f_subject_control = nil
        @f_mouse_tracker = nil
      end
      super
    end
    
    typesig { [] }
    # Returns the location at which the most recent mouse hover event
    # has been issued.
    # 
    # @return the location of the most recent mouse hover event
    def get_hover_event_location
      return !(@f_hover_event).nil? ? Point.new(@f_hover_event.attr_x, @f_hover_event.attr_y) : Point.new(-1, -1)
    end
    
    typesig { [] }
    # Returns the most recent mouse hover event.
    # 
    # @return the most recent mouse hover event or <code>null</code>
    # @since 3.0
    def get_hover_event
      return @f_hover_event
    end
    
    typesig { [] }
    # Returns the SWT event state of the most recent mouse hover event.
    # 
    # @return the SWT event state of the most recent mouse hover event
    def get_hover_event_state_mask
      return @f_hover_event_state_mask
    end
    
    typesig { [] }
    # Returns an adapter that gives access to internal methods.
    # <p>
    # <strong>Note:</strong> This method is not intended to be referenced or overridden by clients.</p>
    # 
    # @return the replaceable information control accessor
    # @since 3.4
    # @noreference This method is not intended to be referenced by clients.
    # @nooverride This method is not intended to be re-implemented or extended by clients.
    def get_internal_accessor
      return Class.new(MyInternalAccessor.class == Class ? MyInternalAccessor : Object) do
        local_class_in AbstractHoverInformationControlManager
        include_class_members AbstractHoverInformationControlManager
        include MyInternalAccessor if MyInternalAccessor.class == Module
        
        typesig { [EnrichMode] }
        define_method :set_hover_enrich_mode do |mode|
          @local_class_parent.set_hover_enrich_mode(mode)
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
    end
    
    private
    alias_method :initialize__abstract_hover_information_control_manager, :initialize
  end
  
end
