require "rjava"

# Copyright (c) 2007, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Internal::Text
  module StickyHoverManagerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Internal::Text
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Events, :ControlEvent
      include_const ::Org::Eclipse::Swt::Events, :ControlListener
      include_const ::Org::Eclipse::Swt::Events, :FocusEvent
      include_const ::Org::Eclipse::Swt::Events, :FocusListener
      include_const ::Org::Eclipse::Swt::Events, :KeyEvent
      include_const ::Org::Eclipse::Swt::Events, :KeyListener
      include_const ::Org::Eclipse::Swt::Events, :MouseEvent
      include_const ::Org::Eclipse::Swt::Events, :MouseListener
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Graphics, :Rectangle
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Display
      include_const ::Org::Eclipse::Swt::Widgets, :Event
      include_const ::Org::Eclipse::Swt::Widgets, :Listener
      include_const ::Org::Eclipse::Jface::Util, :Geometry
      include_const ::Org::Eclipse::Jface::Text, :IInformationControl
      include_const ::Org::Eclipse::Jface::Text, :IInformationControlExtension3
      include_const ::Org::Eclipse::Jface::Text, :IInformationControlExtension5
      include_const ::Org::Eclipse::Jface::Text, :IViewportListener
      include_const ::Org::Eclipse::Jface::Text, :IWidgetTokenKeeper
      include_const ::Org::Eclipse::Jface::Text, :IWidgetTokenKeeperExtension
      include_const ::Org::Eclipse::Jface::Text, :IWidgetTokenOwner
      include_const ::Org::Eclipse::Jface::Text, :TextViewer
    }
  end
  
  # Implements a sticky hover control, i.e. a control that replaces a hover
  # with an enriched and focusable control.
  # <p>
  # The information control is made visible on request by calling
  # {@link #showInformationControl(Rectangle)}.
  # </p>
  # <p>
  # Clients usually instantiate and configure this class before using it. The configuration
  # must be consistent: This means the used {@link org.eclipse.jface.text.IInformationControlCreator}
  # must create an information control expecting information in the same format the configured
  # {@link org.eclipse.jface.text.information.IInformationProvider}s use to encode the information they provide.
  # </p>
  # 
  # @since 3.4
  class StickyHoverManager < StickyHoverManagerImports.const_get :InformationControlReplacer
    include_class_members StickyHoverManagerImports
    overload_protected {
      include IWidgetTokenKeeper
      include IWidgetTokenKeeperExtension
    }
    
    class_module.module_eval {
      # Priority of the info controls managed by this sticky hover manager.
      # <p>
      # Note: Only applicable when info control does not have focus.
      # -5 as value has been chosen in order to be beaten by the hovers of TextViewerHoverManager.
      # </p>
      const_set_lazy(:WIDGET_PRIORITY) { -5 }
      const_attr_reader  :WIDGET_PRIORITY
      
      # Internal information control closer. Listens to several events issued by its subject control
      # and closes the information control when necessary.
      const_set_lazy(:Closer) { Class.new do
        local_class_in StickyHoverManager
        include_class_members StickyHoverManager
        include IInformationControlCloser
        include ControlListener
        include MouseListener
        include IViewportListener
        include KeyListener
        include FocusListener
        include Listener
        
        # TODO: Catch 'Esc' key in fInformationControlToClose: Don't dispose, just hideInformationControl().
        # This would allow to reuse the information control also when the user explicitly closes it.
        # TODO: if subject control is a Scrollable, should add selection listeners to both scroll bars
        # (and remove the ViewPortListener, which only listens to vertical scrolling)
        # The subject control.
        attr_accessor :f_subject_control
        alias_method :attr_f_subject_control, :f_subject_control
        undef_method :f_subject_control
        alias_method :attr_f_subject_control=, :f_subject_control=
        undef_method :f_subject_control=
        
        # Indicates whether this closer is active.
        attr_accessor :f_is_active
        alias_method :attr_f_is_active, :f_is_active
        undef_method :f_is_active
        alias_method :attr_f_is_active=, :f_is_active=
        undef_method :f_is_active=
        
        # The display.
        attr_accessor :f_display
        alias_method :attr_f_display, :f_display
        undef_method :f_display
        alias_method :attr_f_display=, :f_display=
        undef_method :f_display=
        
        typesig { [class_self::Control] }
        # @see IInformationControlCloser#setSubjectControl(Control)
        def set_subject_control(control)
          @f_subject_control = control
        end
        
        typesig { [class_self::IInformationControl] }
        # @see IInformationControlCloser#setInformationControl(IInformationControl)
        def set_information_control(control)
          # NOTE: we use getCurrentInformationControl2() from the outer class
        end
        
        typesig { [class_self::Rectangle] }
        # @see IInformationControlCloser#start(Rectangle)
        def start(information_area)
          if (@f_is_active)
            return
          end
          @f_is_active = true
          if (!(@f_subject_control).nil? && !@f_subject_control.is_disposed)
            @f_subject_control.add_control_listener(self)
            @f_subject_control.add_mouse_listener(self)
            @f_subject_control.add_key_listener(self)
          end
          self.attr_f_text_viewer.add_viewport_listener(self)
          f_information_control_to_close = get_current_information_control2
          if (!(f_information_control_to_close).nil?)
            f_information_control_to_close.add_focus_listener(self)
          end
          @f_display = @f_subject_control.get_display
          if (!@f_display.is_disposed)
            @f_display.add_filter(SWT::MouseMove, self)
            @f_display.add_filter(SWT::FocusOut, self)
          end
        end
        
        typesig { [] }
        # @see IInformationControlCloser#stop()
        def stop
          if (!@f_is_active)
            return
          end
          @f_is_active = false
          self.attr_f_text_viewer.remove_viewport_listener(self)
          if (!(@f_subject_control).nil? && !@f_subject_control.is_disposed)
            @f_subject_control.remove_control_listener(self)
            @f_subject_control.remove_mouse_listener(self)
            @f_subject_control.remove_key_listener(self)
          end
          f_information_control_to_close = get_current_information_control2
          if (!(f_information_control_to_close).nil?)
            f_information_control_to_close.remove_focus_listener(self)
          end
          if (!(@f_display).nil? && !@f_display.is_disposed)
            @f_display.remove_filter(SWT::MouseMove, self)
            @f_display.remove_filter(SWT::FocusOut, self)
          end
          @f_display = nil
        end
        
        typesig { [class_self::ControlEvent] }
        # @see ControlListener#controlResized(ControlEvent)
        def control_resized(e)
          hide_information_control
        end
        
        typesig { [class_self::ControlEvent] }
        # @see ControlListener#controlMoved(ControlEvent)
        def control_moved(e)
          hide_information_control
        end
        
        typesig { [class_self::MouseEvent] }
        # @see MouseListener#mouseDown(MouseEvent)
        def mouse_down(e)
          hide_information_control
        end
        
        typesig { [class_self::MouseEvent] }
        # @see MouseListener#mouseUp(MouseEvent)
        def mouse_up(e)
        end
        
        typesig { [class_self::MouseEvent] }
        # @see MouseListener#mouseDoubleClick(MouseEvent)
        def mouse_double_click(e)
          hide_information_control
        end
        
        typesig { [::Java::Int] }
        # @see IViewportListenerListener#viewportChanged(int)
        def viewport_changed(top_index)
          hide_information_control
        end
        
        typesig { [class_self::KeyEvent] }
        # @see KeyListener#keyPressed(KeyEvent)
        def key_pressed(e)
          hide_information_control
        end
        
        typesig { [class_self::KeyEvent] }
        # @see KeyListener#keyReleased(KeyEvent)
        def key_released(e)
        end
        
        typesig { [class_self::FocusEvent] }
        # @see org.eclipse.swt.events.FocusListener#focusGained(org.eclipse.swt.events.FocusEvent)
        def focus_gained(e)
        end
        
        typesig { [class_self::FocusEvent] }
        # @see org.eclipse.swt.events.FocusListener#focusLost(org.eclipse.swt.events.FocusEvent)
        def focus_lost(e)
          if (DEBUG)
            System.out.println("StickyHoverManager.Closer.focusLost(): " + RJava.cast_to_string(e))
          end # $NON-NLS-1$
          d = @f_subject_control.get_display
          d.async_exec(Class.new(self.class::Runnable.class == Class ? self.class::Runnable : Object) do
            local_class_in Closer
            include_class_members Closer
            include class_self::Runnable if class_self::Runnable.class == Module
            
            typesig { [] }
            # Without the asyncExec, mouse clicks to the workbench window are swallowed.
            define_method :run do
              hide_information_control
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
        # @see org.eclipse.swt.widgets.Listener#handleEvent(org.eclipse.swt.widgets.Event)
        def handle_event(event)
          if ((event.attr_type).equal?(SWT::MouseMove))
            if (!(event.attr_widget.is_a?(self.class::Control)) || event.attr_widget.is_disposed)
              return
            end
            info_control = get_current_information_control2
            if (!(info_control).nil? && !info_control.is_focus_control && info_control.is_a?(self.class::IInformationControlExtension3))
              # if (DEBUG) System.out.println("StickyHoverManager.Closer.handleEvent(): activeShell= " + fDisplay.getActiveShell()); //$NON-NLS-1$
              i_control3 = info_control
              control_bounds = i_control3.get_bounds
              if (!(control_bounds).nil?)
                mouse_loc = event.attr_display.map(event.attr_widget, nil, event.attr_x, event.attr_y)
                margin = get_keep_up_margin
                Geometry.expand(control_bounds, margin, margin, margin, margin)
                if (!control_bounds.contains(mouse_loc))
                  hide_information_control
                end
              end
            else
              # TODO: need better understanding of why/if this is needed.
              # Looks like the same panic code we have in org.eclipse.jface.text.AbstractHoverInformationControlManager.Closer.handleMouseMove(Event)
              if (!(@f_display).nil? && !@f_display.is_disposed)
                @f_display.remove_filter(SWT::MouseMove, self)
              end
            end
          else
            if ((event.attr_type).equal?(SWT::FocusOut))
              if (DEBUG)
                System.out.println("StickyHoverManager.Closer.handleEvent(): focusOut: " + RJava.cast_to_string(event))
              end # $NON-NLS-1$
              i_control = get_current_information_control2
              if (!(i_control).nil? && !i_control.is_focus_control)
                hide_information_control
              end
            end
          end
        end
        
        typesig { [] }
        def initialize
          @f_subject_control = nil
          @f_is_active = false
          @f_display = nil
        end
        
        private
        alias_method :initialize__closer, :initialize
      end }
    }
    
    attr_accessor :f_text_viewer
    alias_method :attr_f_text_viewer, :f_text_viewer
    undef_method :f_text_viewer
    alias_method :attr_f_text_viewer=, :f_text_viewer=
    undef_method :f_text_viewer=
    
    typesig { [TextViewer] }
    # Creates a new sticky hover manager.
    # 
    # @param textViewer the text viewer
    def initialize(text_viewer)
      @f_text_viewer = nil
      super(DefaultInformationControlCreator.new)
      @f_text_viewer = text_viewer
      set_closer(Closer.new_local(self))
      install(@f_text_viewer.get_text_widget)
    end
    
    typesig { [Rectangle] }
    # @see AbstractInformationControlManager#showInformationControl(Rectangle)
    def show_information_control(subject_area)
      if (!(@f_text_viewer).nil? && @f_text_viewer.request_widget_token(self, WIDGET_PRIORITY))
        super(subject_area)
      else
        if (DEBUG)
          System.out.println("cancelled StickyHoverManager.showInformationControl(..): did not get widget token (with prio)")
        end
      end # $NON-NLS-1$
    end
    
    typesig { [] }
    # @see AbstractInformationControlManager#hideInformationControl()
    def hide_information_control
      begin
        super
      ensure
        if (!(@f_text_viewer).nil?)
          @f_text_viewer.release_widget_token(self)
        end
      end
    end
    
    typesig { [] }
    # @see AbstractInformationControlManager#handleInformationControlDisposed()
    def handle_information_control_disposed
      begin
        super
      ensure
        if (!(@f_text_viewer).nil?)
          @f_text_viewer.release_widget_token(self)
        end
      end
    end
    
    typesig { [IWidgetTokenOwner] }
    # @see org.eclipse.jface.text.IWidgetTokenKeeper#requestWidgetToken(IWidgetTokenOwner)
    def request_widget_token(owner)
      hide_information_control
      if (DEBUG)
        System.out.println("StickyHoverManager gave up widget token (no prio)")
      end # $NON-NLS-1$
      return true
    end
    
    typesig { [IWidgetTokenOwner, ::Java::Int] }
    # @see org.eclipse.jface.text.IWidgetTokenKeeperExtension#requestWidgetToken(org.eclipse.jface.text.IWidgetTokenOwner, int)
    def request_widget_token(owner, priority)
      if (!(get_current_information_control2).nil?)
        if (get_current_information_control2.is_focus_control)
          if (DEBUG)
            System.out.println("StickyHoverManager kept widget token (focused)")
          end # $NON-NLS-1$
          return false
        else
          if (priority > WIDGET_PRIORITY)
            hide_information_control
            if (DEBUG)
              System.out.println("StickyHoverManager gave up widget token (prio)")
            end # $NON-NLS-1$
            return true
          else
            if (DEBUG)
              System.out.println("StickyHoverManager kept widget token (prio)")
            end # $NON-NLS-1$
            return false
          end
        end
      end
      if (DEBUG)
        System.out.println("StickyHoverManager gave up widget token (no iControl)")
      end # $NON-NLS-1$
      return true
    end
    
    typesig { [IWidgetTokenOwner] }
    # @see org.eclipse.jface.text.IWidgetTokenKeeperExtension#setFocus(org.eclipse.jface.text.IWidgetTokenOwner)
    def set_focus(owner)
      i_control = get_current_information_control2
      if (i_control.is_a?(IInformationControlExtension5))
        i_control5 = i_control
        if (i_control5.is_visible)
          i_control.set_focus
          return i_control.is_focus_control
        end
        return false
      end
      i_control.set_focus
      return i_control.is_focus_control
    end
    
    private
    alias_method :initialize__sticky_hover_manager, :initialize
  end
  
end
