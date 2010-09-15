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
  module TextViewerHoverManagerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
      include_const ::Org::Eclipse::Swt::Custom, :StyledText
      include_const ::Org::Eclipse::Swt::Events, :MouseEvent
      include_const ::Org::Eclipse::Swt::Events, :MouseMoveListener
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Graphics, :Rectangle
      include_const ::Org::Eclipse::Swt::Widgets, :Display
      include_const ::Org::Eclipse::Core::Runtime, :ILog
      include_const ::Org::Eclipse::Core::Runtime, :IStatus
      include_const ::Org::Eclipse::Core::Runtime, :Platform
      include_const ::Org::Eclipse::Core::Runtime, :Status
    }
  end
  
  # This manager controls the layout, content, and visibility of an information
  # control in reaction to mouse hover events issued by the text widget of a
  # text viewer. It overrides <code>computeInformation</code>, so that the
  # computation is performed in a dedicated background thread. This implies
  # that the used <code>ITextHover</code> objects must be capable of
  # operating in a non-UI thread.
  # 
  # @since 2.0
  class TextViewerHoverManager < TextViewerHoverManagerImports.const_get :AbstractHoverInformationControlManager
    include_class_members TextViewerHoverManagerImports
    overload_protected {
      include IWidgetTokenKeeper
      include IWidgetTokenKeeperExtension
    }
    
    class_module.module_eval {
      # Priority of the hovers managed by this manager.
      # Default value: <code>0</code>;
      # @since 3.0
      const_set_lazy(:WIDGET_PRIORITY) { 0 }
      const_attr_reader  :WIDGET_PRIORITY
    }
    
    # The text viewer
    attr_accessor :f_text_viewer
    alias_method :attr_f_text_viewer, :f_text_viewer
    undef_method :f_text_viewer
    alias_method :attr_f_text_viewer=, :f_text_viewer=
    undef_method :f_text_viewer=
    
    # The hover information computation thread
    attr_accessor :f_thread
    alias_method :attr_f_thread, :f_thread
    undef_method :f_thread
    alias_method :attr_f_thread=, :f_thread=
    undef_method :f_thread=
    
    # The stopper of the computation thread
    attr_accessor :f_stopper
    alias_method :attr_f_stopper, :f_stopper
    undef_method :f_stopper
    alias_method :attr_f_stopper=, :f_stopper=
    undef_method :f_stopper=
    
    # Internal monitor
    attr_accessor :f_mutex
    alias_method :attr_f_mutex, :f_mutex
    undef_method :f_mutex
    alias_method :attr_f_mutex=, :f_mutex=
    undef_method :f_mutex=
    
    # The currently shown text hover.
    attr_accessor :f_text_hover
    alias_method :attr_f_text_hover, :f_text_hover
    undef_method :f_text_hover
    alias_method :attr_f_text_hover=, :f_text_hover=
    undef_method :f_text_hover=
    
    # Tells whether the next mouse hover event
    # should be processed.
    # @since 3.0
    attr_accessor :f_process_mouse_hover_event
    alias_method :attr_f_process_mouse_hover_event, :f_process_mouse_hover_event
    undef_method :f_process_mouse_hover_event
    alias_method :attr_f_process_mouse_hover_event=, :f_process_mouse_hover_event=
    undef_method :f_process_mouse_hover_event=
    
    # Internal mouse move listener.
    # @since 3.0
    attr_accessor :f_mouse_move_listener
    alias_method :attr_f_mouse_move_listener, :f_mouse_move_listener
    undef_method :f_mouse_move_listener
    alias_method :attr_f_mouse_move_listener=, :f_mouse_move_listener=
    undef_method :f_mouse_move_listener=
    
    # Internal view port listener.
    # @since 3.0
    attr_accessor :f_viewport_listener
    alias_method :attr_f_viewport_listener, :f_viewport_listener
    undef_method :f_viewport_listener
    alias_method :attr_f_viewport_listener=, :f_viewport_listener=
    undef_method :f_viewport_listener=
    
    typesig { [TextViewer, IInformationControlCreator] }
    # Creates a new text viewer hover manager specific for the given text viewer.
    # The manager uses the given information control creator.
    # 
    # @param textViewer the viewer for which the controller is created
    # @param creator the information control creator
    def initialize(text_viewer, creator)
      @f_text_viewer = nil
      @f_thread = nil
      @f_stopper = nil
      @f_mutex = nil
      @f_text_hover = nil
      @f_process_mouse_hover_event = false
      @f_mouse_move_listener = nil
      @f_viewport_listener = nil
      super(creator)
      @f_mutex = Object.new
      @f_process_mouse_hover_event = true
      @f_text_viewer = text_viewer
      @f_stopper = Class.new(ITextListener.class == Class ? ITextListener : Object) do
        local_class_in TextViewerHoverManager
        include_class_members TextViewerHoverManager
        include ITextListener if ITextListener.class == Module
        
        typesig { [TextEvent] }
        define_method :text_changed do |event|
          synchronized((self.attr_f_mutex)) do
            if (!(self.attr_f_thread).nil?)
              self.attr_f_thread.interrupt
              self.attr_f_thread = nil
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
      @f_viewport_listener = Class.new(IViewportListener.class == Class ? IViewportListener : Object) do
        local_class_in TextViewerHoverManager
        include_class_members TextViewerHoverManager
        include IViewportListener if IViewportListener.class == Module
        
        typesig { [::Java::Int] }
        # @see org.eclipse.jface.text.IViewportListener#viewportChanged(int)
        define_method :viewport_changed do |vertical_offset|
          self.attr_f_process_mouse_hover_event = false
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
      @f_text_viewer.add_viewport_listener(@f_viewport_listener)
      @f_mouse_move_listener = Class.new(MouseMoveListener.class == Class ? MouseMoveListener : Object) do
        local_class_in TextViewerHoverManager
        include_class_members TextViewerHoverManager
        include MouseMoveListener if MouseMoveListener.class == Module
        
        typesig { [MouseEvent] }
        # @see MouseMoveListener#mouseMove(MouseEvent)
        define_method :mouse_move do |event|
          self.attr_f_process_mouse_hover_event = true
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
      @f_text_viewer.get_text_widget.add_mouse_move_listener(@f_mouse_move_listener)
    end
    
    typesig { [] }
    # Determines all necessary details and delegates the computation into
    # a background thread.
    def compute_information
      if (!@f_process_mouse_hover_event)
        set_information(nil, nil)
        return
      end
      location = get_hover_event_location
      offset = compute_offset_at_location(location.attr_x, location.attr_y)
      if ((offset).equal?(-1))
        set_information(nil, nil)
        return
      end
      hover = @f_text_viewer.get_text_hover(offset, get_hover_event_state_mask)
      if ((hover).nil?)
        set_information(nil, nil)
        return
      end
      region = hover.get_hover_region(@f_text_viewer, offset)
      if ((region).nil?)
        set_information(nil, nil)
        return
      end
      area = JFaceTextUtil.compute_area(region, @f_text_viewer)
      if ((area).nil? || area.is_empty)
        set_information(nil, nil)
        return
      end
      if (!(@f_thread).nil?)
        set_information(nil, nil)
        return
      end
      @f_thread = Class.new(JavaThread.class == Class ? JavaThread : Object) do
        local_class_in TextViewerHoverManager
        include_class_members TextViewerHoverManager
        include JavaThread if JavaThread.class == Module
        
        typesig { [] }
        # $NON-NLS-1$
        define_method :run do
          # http://bugs.eclipse.org/bugs/show_bug.cgi?id=17693
          has_finished = false
          begin
            if (!(self.attr_f_thread).nil?)
              information = nil
              begin
                if (hover.is_a?(self.class::ITextHoverExtension2))
                  information = (hover).get_hover_info2(self.attr_f_text_viewer, region)
                else
                  information = hover.get_hover_info(self.attr_f_text_viewer, region)
                end
              rescue self.class::ArrayIndexOutOfBoundsException => x
                # This code runs in a separate thread which can
                # lead to text offsets being out of bounds when
                # computing the hover info (see bug 32848).
                information = nil
              end
              if (hover.is_a?(self.class::ITextHoverExtension))
                set_custom_information_control_creator((hover).get_hover_control_creator)
              else
                set_custom_information_control_creator(nil)
              end
              set_information(information, area)
              if (!(information).nil?)
                self.attr_f_text_hover = hover
              end
            else
              set_information(nil, nil)
            end
            has_finished = true
          rescue self.class::RuntimeException => ex
            plugin_id = "org.eclipse.jface.text" # $NON-NLS-1$
            log = Platform.get_log(Platform.get_bundle(plugin_id))
            log.log(self.class::Status.new(IStatus::ERROR, plugin_id, IStatus::OK, "Unexpected runtime error while computing a text hover", ex)) # $NON-NLS-1$
          ensure
            synchronized((self.attr_f_mutex)) do
              if (!(self.attr_f_text_viewer).nil?)
                self.attr_f_text_viewer.remove_text_listener(self.attr_f_stopper)
              end
              self.attr_f_thread = nil
              # https://bugs.eclipse.org/bugs/show_bug.cgi?id=44756
              if (!has_finished)
                set_information(nil, nil)
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
      end.new_local(self, "Text Viewer Hover Presenter")
      @f_thread.set_daemon(true)
      @f_thread.set_priority(JavaThread::MIN_PRIORITY)
      synchronized((@f_mutex)) do
        @f_text_viewer.add_text_listener(@f_stopper)
        @f_thread.start
      end
    end
    
    typesig { [] }
    # As computation is done in the background, this method is
    # also called in the background thread. Delegates the control
    # flow back into the UI thread, in order to allow displaying the
    # information in the information control.
    def present_information
      if ((@f_text_viewer).nil?)
        return
      end
      text_widget = @f_text_viewer.get_text_widget
      if (!(text_widget).nil? && !text_widget.is_disposed)
        display = text_widget.get_display
        if ((display).nil?)
          return
        end
        display.async_exec(Class.new(Runnable.class == Class ? Runnable : Object) do
          local_class_in TextViewerHoverManager
          include_class_members TextViewerHoverManager
          include Runnable if Runnable.class == Module
          
          typesig { [] }
          define_method :run do
            do_present_information
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
    
    typesig { [] }
    # @see AbstractInformationControlManager#presentInformation()
    def do_present_information
      AbstractHoverInformationControlManager.instance_method(:present_information).bind(self).call
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Computes the document offset underlying the given text widget coordinates.
    # This method uses a linear search as it cannot make any assumption about
    # how the document is actually presented in the widget. (Covers cases such
    # as bidirectional text.)
    # 
    # @param x the horizontal coordinate inside the text widget
    # @param y the vertical coordinate inside the text widget
    # @return the document offset corresponding to the given point
    def compute_offset_at_location(x, y)
      begin
        styled_text = @f_text_viewer.get_text_widget
        widget_offset = styled_text.get_offset_at_location(Point.new(x, y))
        p = styled_text.get_location_at_offset(widget_offset)
        if (p.attr_x > x)
          widget_offset -= 1
        end
        if (@f_text_viewer.is_a?(ITextViewerExtension5))
          extension = @f_text_viewer
          return extension.widget_offset2model_offset(widget_offset)
        end
        return widget_offset + @f_text_viewer.__get_visible_region_offset
      rescue IllegalArgumentException => e
        return -1
      end
    end
    
    typesig { [Rectangle] }
    # @see org.eclipse.jface.text.AbstractInformationControlManager#showInformationControl(org.eclipse.swt.graphics.Rectangle)
    def show_information_control(subject_area)
      if (!(@f_text_viewer).nil? && @f_text_viewer.request_widget_token(self, WIDGET_PRIORITY))
        super(subject_area)
      else
        if (DEBUG)
          System.out.println("TextViewerHoverManager#showInformationControl(..) did not get widget token")
        end
      end # $NON-NLS-1$
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.AbstractInformationControlManager#hideInformationControl()
    def hide_information_control
      begin
        @f_text_hover = nil
        super
      ensure
        if (!(@f_text_viewer).nil?)
          @f_text_viewer.release_widget_token(self)
        end
      end
    end
    
    typesig { [::Java::Boolean] }
    # @see org.eclipse.jface.text.AbstractInformationControlManager#replaceInformationControl(boolean)
    # @since 3.4
    def replace_information_control(take_focus)
      if (!(@f_text_viewer).nil?)
        @f_text_viewer.release_widget_token(self)
      end
      super(take_focus)
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.AbstractInformationControlManager#handleInformationControlDisposed()
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
    # @see org.eclipse.jface.text.IWidgetTokenKeeper#requestWidgetToken(org.eclipse.jface.text.IWidgetTokenOwner)
    def request_widget_token(owner)
      @f_text_hover = nil
      AbstractHoverInformationControlManager.instance_method(:hide_information_control).bind(self).call
      return true
    end
    
    typesig { [IWidgetTokenOwner, ::Java::Int] }
    # @see org.eclipse.jface.text.IWidgetTokenKeeperExtension#requestWidgetToken(org.eclipse.jface.text.IWidgetTokenOwner, int)
    # @since 3.0
    def request_widget_token(owner, priority)
      if (priority > WIDGET_PRIORITY)
        @f_text_hover = nil
        AbstractHoverInformationControlManager.instance_method(:hide_information_control).bind(self).call
        return true
      end
      return false
    end
    
    typesig { [IWidgetTokenOwner] }
    # @see org.eclipse.jface.text.IWidgetTokenKeeperExtension#setFocus(org.eclipse.jface.text.IWidgetTokenOwner)
    # @since 3.0
    def set_focus(owner)
      if (!has_information_control_replacer)
        return false
      end
      i_control = get_current_information_control
      if (can_replace(i_control))
        if (cancel_replacing_delay)
          replace_information_control(true)
        end
        return true
      end
      return false
    end
    
    typesig { [] }
    # Returns the currently shown text hover or <code>null</code> if no text
    # hover is shown.
    # 
    # @return the currently shown text hover or <code>null</code>
    def get_current_text_hover
      return @f_text_hover
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.AbstractHoverInformationControlManager#dispose()
    # @since 3.0
    def dispose
      if (!(@f_text_viewer).nil?)
        @f_text_viewer.remove_viewport_listener(@f_viewport_listener)
        @f_viewport_listener = nil
        st = @f_text_viewer.get_text_widget
        if (!(st).nil? && !st.is_disposed)
          st.remove_mouse_move_listener(@f_mouse_move_listener)
        end
        @f_mouse_move_listener = nil
      end
      super
    end
    
    private
    alias_method :initialize__text_viewer_hover_manager, :initialize
  end
  
end
