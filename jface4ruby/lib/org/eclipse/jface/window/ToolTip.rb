require "rjava"

# Copyright (c) 2006, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# Tom Schindl <tom.schindl@bestsolution.at> - initial API and implementation
# bugfix in: 195137, 198089, 225190
module Org::Eclipse::Jface::Window
  module ToolTipImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Window
      include_const ::Java::Util, :HashMap
      include_const ::Org::Eclipse::Jface::Util, :Util
      include_const ::Org::Eclipse::Jface::Viewers, :ColumnViewer
      include_const ::Org::Eclipse::Jface::Viewers, :ViewerCell
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Events, :DisposeEvent
      include_const ::Org::Eclipse::Swt::Events, :DisposeListener
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Graphics, :Rectangle
      include_const ::Org::Eclipse::Swt::Layout, :FillLayout
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Display
      include_const ::Org::Eclipse::Swt::Widgets, :Event
      include_const ::Org::Eclipse::Swt::Widgets, :Listener
      include_const ::Org::Eclipse::Swt::Widgets, :Monitor
      include_const ::Org::Eclipse::Swt::Widgets, :Shell
    }
  end
  
  # This class gives implementors to provide customized tooltips for any control.
  # 
  # @since 3.3
  class ToolTip 
    include_class_members ToolTipImports
    
    attr_accessor :control
    alias_method :attr_control, :control
    undef_method :control
    alias_method :attr_control=, :control=
    undef_method :control=
    
    attr_accessor :x_shift
    alias_method :attr_x_shift, :x_shift
    undef_method :x_shift
    alias_method :attr_x_shift=, :x_shift=
    undef_method :x_shift=
    
    attr_accessor :y_shift
    alias_method :attr_y_shift, :y_shift
    undef_method :y_shift
    alias_method :attr_y_shift=, :y_shift=
    undef_method :y_shift=
    
    attr_accessor :popup_delay
    alias_method :attr_popup_delay, :popup_delay
    undef_method :popup_delay
    alias_method :attr_popup_delay=, :popup_delay=
    undef_method :popup_delay=
    
    attr_accessor :hide_delay
    alias_method :attr_hide_delay, :hide_delay
    undef_method :hide_delay
    alias_method :attr_hide_delay=, :hide_delay=
    undef_method :hide_delay=
    
    attr_accessor :listener
    alias_method :attr_listener, :listener
    undef_method :listener
    alias_method :attr_listener=, :listener=
    undef_method :listener=
    
    attr_accessor :data
    alias_method :attr_data, :data
    undef_method :data
    alias_method :attr_data=, :data=
    undef_method :data=
    
    class_module.module_eval {
      # Ensure that only one tooltip is active in time
      
      def current_tooltip
        defined?(@@current_tooltip) ? @@current_tooltip : @@current_tooltip= nil
      end
      alias_method :attr_current_tooltip, :current_tooltip
      
      def current_tooltip=(value)
        @@current_tooltip = value
      end
      alias_method :attr_current_tooltip=, :current_tooltip=
      
      # Recreate the tooltip on every mouse move
      const_set_lazy(:RECREATE) { 1 }
      const_attr_reader  :RECREATE
      
      # Don't recreate the tooltip as long the mouse doesn't leave the area
      # triggering the tooltip creation
      const_set_lazy(:NO_RECREATE) { 1 << 1 }
      const_attr_reader  :NO_RECREATE
    }
    
    attr_accessor :hide_listener
    alias_method :attr_hide_listener, :hide_listener
    undef_method :hide_listener
    alias_method :attr_hide_listener=, :hide_listener=
    undef_method :hide_listener=
    
    attr_accessor :shell_listener
    alias_method :attr_shell_listener, :shell_listener
    undef_method :shell_listener
    alias_method :attr_shell_listener=, :shell_listener=
    undef_method :shell_listener=
    
    attr_accessor :hide_on_mouse_down
    alias_method :attr_hide_on_mouse_down, :hide_on_mouse_down
    undef_method :hide_on_mouse_down
    alias_method :attr_hide_on_mouse_down=, :hide_on_mouse_down=
    undef_method :hide_on_mouse_down=
    
    attr_accessor :respect_display_bounds
    alias_method :attr_respect_display_bounds, :respect_display_bounds
    undef_method :respect_display_bounds
    alias_method :attr_respect_display_bounds=, :respect_display_bounds=
    undef_method :respect_display_bounds=
    
    attr_accessor :respect_monitor_bounds
    alias_method :attr_respect_monitor_bounds, :respect_monitor_bounds
    undef_method :respect_monitor_bounds
    alias_method :attr_respect_monitor_bounds=, :respect_monitor_bounds=
    undef_method :respect_monitor_bounds=
    
    attr_accessor :style
    alias_method :attr_style, :style
    undef_method :style
    alias_method :attr_style=, :style=
    undef_method :style=
    
    attr_accessor :current_area
    alias_method :attr_current_area, :current_area
    undef_method :current_area
    alias_method :attr_current_area=, :current_area=
    undef_method :current_area=
    
    class_module.module_eval {
      const_set_lazy(:IS_OSX) { Util.is_carbon }
      const_attr_reader  :IS_OSX
    }
    
    typesig { [Control] }
    # Create new instance which add TooltipSupport to the widget
    # 
    # @param control
    # the control on whose action the tooltip is shown
    def initialize(control)
      initialize__tool_tip(control, RECREATE, false)
    end
    
    typesig { [Control, ::Java::Int, ::Java::Boolean] }
    # @param control
    # the control to which the tooltip is bound
    # @param style
    # style passed to control tooltip behavior
    # 
    # @param manualActivation
    # <code>true</code> if the activation is done manually using
    # {@link #show(Point)}
    # @see #RECREATE
    # @see #NO_RECREATE
    def initialize(control, style, manual_activation)
      @control = nil
      @x_shift = 3
      @y_shift = 0
      @popup_delay = 0
      @hide_delay = 0
      @listener = nil
      @data = nil
      @hide_listener = TooltipHideListener.new_local(self)
      @shell_listener = nil
      @hide_on_mouse_down = true
      @respect_display_bounds = true
      @respect_monitor_bounds = true
      @style = 0
      @current_area = nil
      @control = control
      @style = style
      @control.add_dispose_listener(Class.new(DisposeListener.class == Class ? DisposeListener : Object) do
        extend LocalClass
        include_class_members ToolTip
        include DisposeListener if DisposeListener.class == Module
        
        typesig { [DisposeEvent] }
        define_method :widget_disposed do |e|
          self.attr_data = nil
          deactivate
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      @listener = ToolTipOwnerControlListener.new_local(self)
      @shell_listener = Class.new(Listener.class == Class ? Listener : Object) do
        extend LocalClass
        include_class_members ToolTip
        include Listener if Listener.class == Module
        
        typesig { [Event] }
        define_method :handle_event do |event|
          if (!(@local_class_parent.attr_control).nil? && !@local_class_parent.attr_control.is_disposed)
            listener_class = self.class
            @local_class_parent.attr_control.get_display.async_exec(Class.new(self.class::Runnable.class == Class ? self.class::Runnable : Object) do
              extend LocalClass
              include_class_members listener_class
              include class_self::Runnable if class_self::Runnable.class == Module
              
              typesig { [] }
              define_method :run do
                # Check if the new active shell is the tooltip
                # itself
                if (!(@local_class_parent.local_class_parent.attr_control.get_display.get_active_shell).equal?(self.attr_current_tooltip))
                  tool_tip_hide(self.attr_current_tooltip, event)
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
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
      if (!manual_activation)
        activate
      end
    end
    
    typesig { [String, Object] }
    # Restore arbitrary data under the given key
    # 
    # @param key
    # the key
    # @param value
    # the value
    def set_data(key, value)
      if ((@data).nil?)
        @data = HashMap.new
      end
      @data.put(key, value)
    end
    
    typesig { [String] }
    # Get the data restored under the key
    # 
    # @param key
    # the key
    # @return data or <code>null</code> if no entry is restored under the key
    def get_data(key)
      if (!(@data).nil?)
        return @data.get(key)
      end
      return nil
    end
    
    typesig { [Point] }
    # Set the shift (from the mouse position triggered the event) used to
    # display the tooltip.
    # <p>
    # By default the tooltip is shifted 3 pixels to the right.
    # </p>
    # 
    # @param p
    # the new shift
    def set_shift(p)
      @x_shift = p.attr_x
      @y_shift = p.attr_y
    end
    
    typesig { [] }
    # Activate tooltip support for this control
    def activate
      deactivate
      @control.add_listener(SWT::Dispose, @listener)
      @control.add_listener(SWT::MouseHover, @listener)
      @control.add_listener(SWT::MouseMove, @listener)
      @control.add_listener(SWT::MouseExit, @listener)
      @control.add_listener(SWT::MouseDown, @listener)
      @control.add_listener(SWT::MouseWheel, @listener)
    end
    
    typesig { [] }
    # Deactivate tooltip support for the underlying control
    def deactivate
      @control.remove_listener(SWT::Dispose, @listener)
      @control.remove_listener(SWT::MouseHover, @listener)
      @control.remove_listener(SWT::MouseMove, @listener)
      @control.remove_listener(SWT::MouseExit, @listener)
      @control.remove_listener(SWT::MouseDown, @listener)
      @control.remove_listener(SWT::MouseWheel, @listener)
    end
    
    typesig { [] }
    # Return whether the tooltip respects bounds of the display.
    # 
    # @return <code>true</code> if the tooltip respects bounds of the display
    def is_respect_display_bounds
      return @respect_display_bounds
    end
    
    typesig { [::Java::Boolean] }
    # Set to <code>false</code> if display bounds should not be respected or
    # to <code>true</code> if the tooltip is should repositioned to not
    # overlap the display bounds.
    # <p>
    # Default is <code>true</code>
    # </p>
    # 
    # @param respectDisplayBounds
    def set_respect_display_bounds(respect_display_bounds)
      @respect_display_bounds = respect_display_bounds
    end
    
    typesig { [] }
    # Return whether the tooltip respects bounds of the monitor.
    # 
    # @return <code>true</code> if tooltip respects the bounds of the monitor
    def is_respect_monitor_bounds
      return @respect_monitor_bounds
    end
    
    typesig { [::Java::Boolean] }
    # Set to <code>false</code> if monitor bounds should not be respected or
    # to <code>true</code> if the tooltip is should repositioned to not
    # overlap the monitors bounds. The monitor the tooltip belongs to is the
    # same is control's monitor the tooltip is shown for.
    # <p>
    # Default is <code>true</code>
    # </p>
    # 
    # @param respectMonitorBounds
    def set_respect_monitor_bounds(respect_monitor_bounds)
      @respect_monitor_bounds = respect_monitor_bounds
    end
    
    typesig { [Event] }
    # Should the tooltip displayed because of the given event.
    # <p>
    # <b>Subclasses may overwrite this to get custom behavior</b>
    # </p>
    # 
    # @param event
    # the event
    # @return <code>true</code> if tooltip should be displayed
    def should_create_tool_tip(event)
      if (!((@style & NO_RECREATE)).equal?(0))
        tmp = get_tool_tip_area(event)
        # No new area close the current tooltip
        if ((tmp).nil?)
          hide
          return false
        end
        rv = !(tmp == @current_area)
        return rv
      end
      return true
    end
    
    typesig { [Event] }
    # This method is called before the tooltip is hidden
    # 
    # @param event
    # the event trying to hide the tooltip
    # @return <code>true</code> if the tooltip should be hidden
    def should_hide_tool_tip(event)
      if (!(event).nil? && (event.attr_type).equal?(SWT::MouseMove) && !((@style & NO_RECREATE)).equal?(0))
        tmp = get_tool_tip_area(event)
        # No new area close the current tooltip
        if ((tmp).nil?)
          hide
          return false
        end
        rv = !(tmp == @current_area)
        return rv
      end
      return true
    end
    
    typesig { [Event] }
    # This method is called to check for which area the tooltip is
    # created/hidden for. In case of {@link #NO_RECREATE} this is used to
    # decide if the tooltip is hidden recreated.
    # 
    # <code>By the default it is the widget the tooltip is created for but could be any object. To decide if
    # the area changed the {@link Object#equals(Object)} method is used.</code>
    # 
    # @param event
    # the event
    # @return the area responsible for the tooltip creation or
    # <code>null</code> this could be any object describing the area
    # (e.g. the {@link Control} onto which the tooltip is bound to, a
    # part of this area e.g. for {@link ColumnViewer} this could be a
    # {@link ViewerCell})
    def get_tool_tip_area(event)
      return @control
    end
    
    typesig { [Point] }
    # Start up the tooltip programmatically
    # 
    # @param location
    # the location relative to the control the tooltip is shown
    def show(location)
      event = Event.new
      event.attr_x = location.attr_x
      event.attr_y = location.attr_y
      event.attr_widget = @control
      tool_tip_create(event)
    end
    
    typesig { [Event] }
    def tool_tip_create(event)
      if (should_create_tool_tip(event))
        shell = Shell.new(@control.get_shell, SWT::ON_TOP | SWT::TOOL | SWT::NO_FOCUS)
        shell.set_layout(FillLayout.new)
        tool_tip_open(shell, event)
        return shell
      end
      return nil
    end
    
    typesig { [Shell, Event] }
    def tool_tip_show(tip, event)
      if (!tip.is_disposed)
        @current_area = get_tool_tip_area(event)
        create_tool_tip_content_area(event, tip)
        if (is_hide_on_mouse_down)
          tool_tip_hook_both_recursively(tip)
        else
          tool_tip_hook_by_type_recursively(tip, true, SWT::MouseExit)
        end
        tip.pack
        size = tip.get_size
        location = fixup_display_bounds(size, get_location(size, event))
        # Need to adjust a bit more if the mouse cursor.y == tip.y and
        # the cursor.x is inside the tip
        cursor_location = tip.get_display.get_cursor_location
        if ((cursor_location.attr_y).equal?(location.attr_y) && location.attr_x < cursor_location.attr_x && location.attr_x + size.attr_x > cursor_location.attr_x)
          location.attr_y -= 2
        end
        tip.set_location(location)
        tip.set_visible(true)
      end
    end
    
    typesig { [Point, Point] }
    def fixup_display_bounds(tip_size, location)
      if (@respect_display_bounds || @respect_monitor_bounds)
        bounds = nil
        right_bounds = Point.new(tip_size.attr_x + location.attr_x, tip_size.attr_y + location.attr_y)
        ms = @control.get_display.get_monitors
        if (@respect_monitor_bounds && ms.attr_length > 1)
          # By default present in the monitor of the control
          bounds = @control.get_monitor.get_bounds
          p = Point.new(location.attr_x, location.attr_y)
          # Search on which monitor the event occurred
          tmp = nil
          i = 0
          while i < ms.attr_length
            tmp = ms[i].get_bounds
            if (tmp.contains(p))
              bounds = tmp
              break
            end
            i += 1
          end
        else
          bounds = @control.get_display.get_bounds
        end
        if (!(bounds.contains(location) && bounds.contains(right_bounds)))
          if (right_bounds.attr_x > bounds.attr_x + bounds.attr_width)
            location.attr_x -= right_bounds.attr_x - (bounds.attr_x + bounds.attr_width)
          end
          if (right_bounds.attr_y > bounds.attr_y + bounds.attr_height)
            location.attr_y -= right_bounds.attr_y - (bounds.attr_y + bounds.attr_height)
          end
          if (location.attr_x < bounds.attr_x)
            location.attr_x = bounds.attr_x
          end
          if (location.attr_y < bounds.attr_y)
            location.attr_y = bounds.attr_y
          end
        end
      end
      return location
    end
    
    typesig { [Point, Event] }
    # Get the display relative location where the tooltip is displayed.
    # Subclasses may overwrite to implement custom positioning.
    # 
    # @param tipSize
    # the size of the tooltip to be shown
    # @param event
    # the event triggered showing the tooltip
    # @return the absolute position on the display
    def get_location(tip_size, event)
      return @control.to_display(event.attr_x + @x_shift, event.attr_y + @y_shift)
    end
    
    typesig { [Shell, Event] }
    def tool_tip_hide(tip, event)
      if (!(tip).nil? && !tip.is_disposed && should_hide_tool_tip(event))
        @control.get_shell.remove_listener(SWT::Deactivate, @shell_listener)
        @current_area = nil
        pass_on_event(tip, event)
        tip.dispose
        self.attr_current_tooltip = nil
        after_hide_tool_tip(event)
      end
    end
    
    typesig { [Shell, Event] }
    def pass_on_event(tip, event)
      if (!(@control).nil? && !@control.is_disposed && !(event).nil? && !(event.attr_widget).equal?(@control) && (event.attr_type).equal?(SWT::MouseDown))
        display = @control.get_display
        new_pt = display.map(tip, nil, Point.new(event.attr_x, event.attr_y))
        new_event = Event.new
        new_event.attr_button = event.attr_button
        new_event.attr_character = event.attr_character
        new_event.attr_count = event.attr_count
        new_event.attr_data = event.attr_data
        new_event.attr_detail = event.attr_detail
        new_event.attr_display = event.attr_display
        new_event.attr_doit = event.attr_doit
        new_event.attr_end = event.attr_end
        new_event.attr_gc = event.attr_gc
        new_event.attr_height = event.attr_height
        new_event.attr_index = event.attr_index
        new_event.attr_item = event.attr_item
        new_event.attr_key_code = event.attr_key_code
        new_event.attr_start = event.attr_start
        new_event.attr_state_mask = event.attr_state_mask
        new_event.attr_text = event.attr_text
        new_event.attr_time = event.attr_time
        new_event.attr_type = event.attr_type
        new_event.attr_widget = event.attr_widget
        new_event.attr_width = event.attr_width
        new_event.attr_x = new_pt.attr_x
        new_event.attr_y = new_pt.attr_y
        tip.close
        display.async_exec(Class.new(Runnable.class == Class ? Runnable : Object) do
          extend LocalClass
          include_class_members ToolTip
          include Runnable if Runnable.class == Module
          
          typesig { [] }
          define_method :run do
            if (IS_OSX)
              begin
                JavaThread.sleep(300)
              rescue self.class::InterruptedException => e
              end
              display.post(new_event)
              new_event.attr_type = SWT::MouseUp
              display.post(new_event)
            else
              display.post(new_event)
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
    
    typesig { [Shell, Event] }
    def tool_tip_open(shell, event)
      # Ensure that only one Tooltip is shown in time
      if (!(self.attr_current_tooltip).nil?)
        tool_tip_hide(self.attr_current_tooltip, nil)
      end
      self.attr_current_tooltip = shell
      @control.get_shell.add_listener(SWT::Deactivate, @shell_listener)
      if (@popup_delay > 0)
        @control.get_display.timer_exec(@popup_delay, Class.new(Runnable.class == Class ? Runnable : Object) do
          extend LocalClass
          include_class_members ToolTip
          include Runnable if Runnable.class == Module
          
          typesig { [] }
          define_method :run do
            tool_tip_show(shell, event)
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      else
        tool_tip_show(self.attr_current_tooltip, event)
      end
      if (@hide_delay > 0)
        @control.get_display.timer_exec(@popup_delay + @hide_delay, Class.new(Runnable.class == Class ? Runnable : Object) do
          extend LocalClass
          include_class_members ToolTip
          include Runnable if Runnable.class == Module
          
          typesig { [] }
          define_method :run do
            tool_tip_hide(shell, nil)
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
    
    typesig { [Control, ::Java::Boolean, ::Java::Int] }
    def tool_tip_hook_by_type_recursively(c, add, type)
      if (add)
        c.add_listener(type, @hide_listener)
      else
        c.remove_listener(type, @hide_listener)
      end
      if (c.is_a?(Composite))
        children = (c).get_children
        i = 0
        while i < children.attr_length
          tool_tip_hook_by_type_recursively(children[i], add, type)
          i += 1
        end
      end
    end
    
    typesig { [Control] }
    def tool_tip_hook_both_recursively(c)
      c.add_listener(SWT::MouseDown, @hide_listener)
      c.add_listener(SWT::MouseExit, @hide_listener)
      if (c.is_a?(Composite))
        children = (c).get_children
        i = 0
        while i < children.attr_length
          tool_tip_hook_both_recursively(children[i])
          i += 1
        end
      end
    end
    
    typesig { [Event, Composite] }
    # Creates the content area of the the tooltip.
    # 
    # @param event
    # the event that triggered the activation of the tooltip
    # @param parent
    # the parent of the content area
    # @return the content area created
    def create_tool_tip_content_area(event, parent)
      raise NotImplementedError
    end
    
    typesig { [Event] }
    # This method is called after a tooltip is hidden.
    # <p>
    # <b>Subclasses may override to clean up requested system resources</b>
    # </p>
    # 
    # @param event
    # event triggered the hiding action (may be <code>null</code>
    # if event wasn't triggered by user actions directly)
    def after_hide_tool_tip(event)
    end
    
    typesig { [::Java::Int] }
    # Set the hide delay.
    # 
    # @param hideDelay
    # the delay before the tooltip is hidden. If <code>0</code>
    # the tooltip is shown until user moves to other item
    def set_hide_delay(hide_delay)
      @hide_delay = hide_delay
    end
    
    typesig { [::Java::Int] }
    # Set the popup delay.
    # 
    # @param popupDelay
    # the delay before the tooltip is shown to the user. If
    # <code>0</code> the tooltip is shown immediately
    def set_popup_delay(popup_delay)
      @popup_delay = popup_delay
    end
    
    typesig { [] }
    # Return if hiding on mouse down is set.
    # 
    # @return <code>true</code> if hiding on mouse down in the tool tip is on
    def is_hide_on_mouse_down
      return @hide_on_mouse_down
    end
    
    typesig { [::Java::Boolean] }
    # If you don't want the tool tip to be hidden when the user clicks inside
    # the tool tip set this to <code>false</code>. You maybe also need to
    # hide the tool tip yourself depending on what you do after clicking in the
    # tooltip (e.g. if you open a new {@link Shell})
    # 
    # @param hideOnMouseDown
    # flag to indicate of tooltip is hidden automatically on mouse
    # down inside the tool tip
    def set_hide_on_mouse_down(hide_on_mouse_down)
      # Only needed if there's currently a tooltip active
      if (!(self.attr_current_tooltip).nil? && !self.attr_current_tooltip.is_disposed)
        # Only change if value really changed
        if (!(hide_on_mouse_down).equal?(@hide_on_mouse_down))
          @control.get_display.sync_exec(Class.new(Runnable.class == Class ? Runnable : Object) do
            extend LocalClass
            include_class_members ToolTip
            include Runnable if Runnable.class == Module
            
            typesig { [] }
            define_method :run do
              if (!(self.attr_current_tooltip).nil? && self.attr_current_tooltip.is_disposed)
                tool_tip_hook_by_type_recursively(self.attr_current_tooltip, hide_on_mouse_down, SWT::MouseDown)
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
      @hide_on_mouse_down = hide_on_mouse_down
    end
    
    typesig { [] }
    # Hide the currently active tool tip
    def hide
      tool_tip_hide(self.attr_current_tooltip, nil)
    end
    
    class_module.module_eval {
      const_set_lazy(:ToolTipOwnerControlListener) { Class.new do
        extend LocalClass
        include_class_members ToolTip
        include Listener
        
        typesig { [class_self::Event] }
        def handle_event(event)
          catch(:break_case) do
            case (event.attr_type)
            when SWT::Dispose, SWT::KeyDown, SWT::MouseDown, SWT::MouseMove, SWT::MouseWheel
              tool_tip_hide(self.attr_current_tooltip, event)
            when SWT::MouseHover
              tool_tip_create(event)
            when SWT::MouseExit
              # Check if the mouse exit happened because we move over the
              # tooltip
              if (!(self.attr_current_tooltip).nil? && !self.attr_current_tooltip.is_disposed)
                if (self.attr_current_tooltip.get_bounds.contains(self.attr_control.to_display(event.attr_x, event.attr_y)))
                  throw :break_case, :thrown
                end
              end
              tool_tip_hide(self.attr_current_tooltip, event)
            end
          end
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__tool_tip_owner_control_listener, :initialize
      end }
      
      const_set_lazy(:TooltipHideListener) { Class.new do
        extend LocalClass
        include_class_members ToolTip
        include Listener
        
        typesig { [class_self::Event] }
        def handle_event(event)
          if (event.attr_widget.is_a?(self.class::Control))
            c = event.attr_widget
            shell = c.get_shell
            case (event.attr_type)
            when SWT::MouseDown
              if (is_hide_on_mouse_down)
                tool_tip_hide(shell, event)
              end
            when SWT::MouseExit
              # Give some insets to ensure we get exit informations from
              # a wider area ;-)
              rect = shell.get_bounds
              rect.attr_x += 5
              rect.attr_y += 5
              rect.attr_width -= 10
              rect.attr_height -= 10
              if (!rect.contains(c.get_display.get_cursor_location))
                tool_tip_hide(shell, event)
              end
            end
          end
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__tooltip_hide_listener, :initialize
      end }
    }
    
    private
    alias_method :initialize__tool_tip, :initialize
  end
  
end
