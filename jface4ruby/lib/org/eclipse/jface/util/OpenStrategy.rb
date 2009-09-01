require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Util
  module OpenStrategyImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Util
      include_const ::Org::Eclipse::Core::Runtime, :ListenerList
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Custom, :TableTree
      include_const ::Org::Eclipse::Swt::Custom, :TableTreeItem
      include_const ::Org::Eclipse::Swt::Events, :SelectionEvent
      include_const ::Org::Eclipse::Swt::Events, :SelectionListener
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Display
      include_const ::Org::Eclipse::Swt::Widgets, :Event
      include_const ::Org::Eclipse::Swt::Widgets, :Listener
      include_const ::Org::Eclipse::Swt::Widgets, :Table
      include_const ::Org::Eclipse::Swt::Widgets, :TableItem
      include_const ::Org::Eclipse::Swt::Widgets, :Tree
      include_const ::Org::Eclipse::Swt::Widgets, :TreeItem
      include_const ::Org::Eclipse::Swt::Widgets, :Widget
    }
  end
  
  # Implementation of single-click and double-click strategies.
  # <p>
  # Usage:
  # <pre>
  # OpenStrategy handler = new OpenStrategy(control);
  # handler.addOpenListener(new IOpenEventListener() {
  # public void handleOpen(SelectionEvent e) {
  # ... // code to handle the open event.
  # }
  # });
  # </pre>
  # </p>
  class OpenStrategy 
    include_class_members OpenStrategyImports
    
    class_module.module_eval {
      # Default behavior. Double click to open the item.
      const_set_lazy(:DOUBLE_CLICK) { 0 }
      const_attr_reader  :DOUBLE_CLICK
      
      # Single click will open the item.
      const_set_lazy(:SINGLE_CLICK) { 1 }
      const_attr_reader  :SINGLE_CLICK
      
      # Hover will select the item.
      const_set_lazy(:SELECT_ON_HOVER) { 1 << 1 }
      const_attr_reader  :SELECT_ON_HOVER
      
      # Open item when using arrow keys
      const_set_lazy(:ARROW_KEYS_OPEN) { 1 << 2 }
      const_attr_reader  :ARROW_KEYS_OPEN
      
      # A single click will generate
      # an open event but key arrows will not do anything.
      # 
      # @deprecated
      const_set_lazy(:NO_TIMER) { SINGLE_CLICK }
      const_attr_reader  :NO_TIMER
      
      # A single click will generate an open
      # event and key arrows will generate an open event after a
      # small time.
      # 
      # @deprecated
      const_set_lazy(:FILE_EXPLORER) { SINGLE_CLICK | ARROW_KEYS_OPEN }
      const_attr_reader  :FILE_EXPLORER
      
      # Pointing to an item will change the selection
      # and a single click will gererate an open event
      # 
      # @deprecated
      const_set_lazy(:ACTIVE_DESKTOP) { SINGLE_CLICK | SELECT_ON_HOVER }
      const_attr_reader  :ACTIVE_DESKTOP
      
      # Time used in FILE_EXPLORER and ACTIVE_DESKTOP
      # Not declared final, see bug 246209
      
      def time
        defined?(@@time) ? @@time : @@time= 500
      end
      alias_method :attr_time, :time
      
      def time=(value)
        @@time = value
      end
      alias_method :attr_time=, :time=
      
      # SINGLE_CLICK or DOUBLE_CLICK;
      # In case of SINGLE_CLICK, the bits SELECT_ON_HOVER and ARROW_KEYS_OPEN
      # my be set as well.
      
      def current_method
        defined?(@@current_method) ? @@current_method : @@current_method= DOUBLE_CLICK
      end
      alias_method :attr_current_method, :current_method
      
      def current_method=(value)
        @@current_method = value
      end
      alias_method :attr_current_method=, :current_method=
    }
    
    attr_accessor :event_handler
    alias_method :attr_event_handler, :event_handler
    undef_method :event_handler
    alias_method :attr_event_handler=, :event_handler=
    undef_method :event_handler=
    
    attr_accessor :open_event_listeners
    alias_method :attr_open_event_listeners, :open_event_listeners
    undef_method :open_event_listeners
    alias_method :attr_open_event_listeners=, :open_event_listeners=
    undef_method :open_event_listeners=
    
    attr_accessor :selection_event_listeners
    alias_method :attr_selection_event_listeners, :selection_event_listeners
    undef_method :selection_event_listeners
    alias_method :attr_selection_event_listeners=, :selection_event_listeners=
    undef_method :selection_event_listeners=
    
    attr_accessor :post_selection_event_listeners
    alias_method :attr_post_selection_event_listeners, :post_selection_event_listeners
    undef_method :post_selection_event_listeners
    alias_method :attr_post_selection_event_listeners=, :post_selection_event_listeners=
    undef_method :post_selection_event_listeners=
    
    typesig { [Control] }
    # @param control the control the strategy is applied to
    def initialize(control)
      @event_handler = nil
      @open_event_listeners = ListenerList.new
      @selection_event_listeners = ListenerList.new
      @post_selection_event_listeners = ListenerList.new
      initialize_handler(control.get_display)
      add_listener(control)
    end
    
    typesig { [IOpenEventListener] }
    # Adds an IOpenEventListener to the collection of openEventListeners
    # @param listener the listener to add
    def add_open_listener(listener)
      @open_event_listeners.add(listener)
    end
    
    typesig { [IOpenEventListener] }
    # Removes an IOpenEventListener to the collection of openEventListeners
    # @param listener the listener to remove
    def remove_open_listener(listener)
      @open_event_listeners.remove(listener)
    end
    
    typesig { [SelectionListener] }
    # Adds an SelectionListener to the collection of selectionEventListeners
    # @param listener the listener to add
    def add_selection_listener(listener)
      @selection_event_listeners.add(listener)
    end
    
    typesig { [SelectionListener] }
    # Removes an SelectionListener to the collection of selectionEventListeners
    # @param listener the listener to remove
    def remove_selection_listener(listener)
      @selection_event_listeners.remove(listener)
    end
    
    typesig { [SelectionListener] }
    # Adds an SelectionListener to the collection of selectionEventListeners
    # @param listener the listener to add
    def add_post_selection_listener(listener)
      @post_selection_event_listeners.add(listener)
    end
    
    typesig { [SelectionListener] }
    # Removes an SelectionListener to the collection of selectionEventListeners
    # @param listener the listener to remove
    def remove_post_selection_listener(listener)
      @post_selection_event_listeners.remove(listener)
    end
    
    class_module.module_eval {
      typesig { [] }
      # This method is internal to the framework; it should not be implemented outside
      # the framework.
      # @return the current used single/double-click method
      def get_open_method
        return self.attr_current_method
      end
      
      typesig { [::Java::Int] }
      # Set the current used single/double-click method.
      # 
      # This method is internal to the framework; it should not be implemented outside
      # the framework.
      # @param method the method to be used
      # @see OpenStrategy#DOUBLE_CLICK
      # @see OpenStrategy#SINGLE_CLICK
      # @see OpenStrategy#SELECT_ON_HOVER
      # @see OpenStrategy#ARROW_KEYS_OPEN
      def set_open_method(method)
        if ((method).equal?(DOUBLE_CLICK))
          self.attr_current_method = method
          return
        end
        if (((method & SINGLE_CLICK)).equal?(0))
          raise IllegalArgumentException.new("Invalid open mode") # $NON-NLS-1$
        end
        if (((method & (SINGLE_CLICK | SELECT_ON_HOVER | ARROW_KEYS_OPEN))).equal?(0))
          raise IllegalArgumentException.new("Invalid open mode") # $NON-NLS-1$
        end
        self.attr_current_method = method
      end
      
      typesig { [] }
      # @return true if editors should be activated when opened.
      def activate_on_open
        return (get_open_method).equal?(DOUBLE_CLICK)
      end
    }
    
    typesig { [Control] }
    # Adds all needed listener to the control in order to implement
    # single-click/double-click strategies.
    def add_listener(c)
      c.add_listener(SWT::MouseEnter, @event_handler)
      c.add_listener(SWT::MouseExit, @event_handler)
      c.add_listener(SWT::MouseMove, @event_handler)
      c.add_listener(SWT::MouseDown, @event_handler)
      c.add_listener(SWT::MouseUp, @event_handler)
      c.add_listener(SWT::KeyDown, @event_handler)
      c.add_listener(SWT::Selection, @event_handler)
      c.add_listener(SWT::DefaultSelection, @event_handler)
      c.add_listener(SWT::Collapse, @event_handler)
      c.add_listener(SWT::Expand, @event_handler)
    end
    
    typesig { [SelectionEvent] }
    # Fire the selection event to all selectionEventListeners
    def fire_selection_event(e)
      if (!(e.attr_item).nil? && e.attr_item.is_disposed)
        return
      end
      l = @selection_event_listeners.get_listeners
      i = 0
      while i < l.attr_length
        (l[i]).widget_selected(e)
        i += 1
      end
    end
    
    typesig { [SelectionEvent] }
    # Fire the default selection event to all selectionEventListeners
    def fire_default_selection_event(e)
      l = @selection_event_listeners.get_listeners
      i = 0
      while i < l.attr_length
        (l[i]).widget_default_selected(e)
        i += 1
      end
    end
    
    typesig { [SelectionEvent] }
    # Fire the post selection event to all postSelectionEventListeners
    def fire_post_selection_event(e)
      if (!(e.attr_item).nil? && e.attr_item.is_disposed)
        return
      end
      l = @post_selection_event_listeners.get_listeners
      i = 0
      while i < l.attr_length
        (l[i]).widget_selected(e)
        i += 1
      end
    end
    
    typesig { [SelectionEvent] }
    # Fire the open event to all openEventListeners
    def fire_open_event(e)
      if (!(e.attr_item).nil? && e.attr_item.is_disposed)
        return
      end
      l = @open_event_listeners.get_listeners
      i = 0
      while i < l.attr_length
        (l[i]).handle_open(e)
        i += 1
      end
    end
    
    typesig { [Display] }
    # Initialize event handler.
    def initialize_handler(display)
      @event_handler = Class.new(Listener.class == Class ? Listener : Object) do
        extend LocalClass
        include_class_members OpenStrategy
        include Listener if Listener.class == Module
        
        attr_accessor :timer_started
        alias_method :attr_timer_started, :timer_started
        undef_method :timer_started
        alias_method :attr_timer_started=, :timer_started=
        undef_method :timer_started=
        
        attr_accessor :mouse_up_event
        alias_method :attr_mouse_up_event, :mouse_up_event
        undef_method :mouse_up_event
        alias_method :attr_mouse_up_event=, :mouse_up_event=
        undef_method :mouse_up_event=
        
        attr_accessor :mouse_move_event
        alias_method :attr_mouse_move_event, :mouse_move_event
        undef_method :mouse_move_event
        alias_method :attr_mouse_move_event=, :mouse_move_event=
        undef_method :mouse_move_event=
        
        attr_accessor :selection_pendent
        alias_method :attr_selection_pendent, :selection_pendent
        undef_method :selection_pendent
        alias_method :attr_selection_pendent=, :selection_pendent=
        undef_method :selection_pendent=
        
        attr_accessor :enter_key_down
        alias_method :attr_enter_key_down, :enter_key_down
        undef_method :enter_key_down
        alias_method :attr_enter_key_down=, :enter_key_down=
        undef_method :enter_key_down=
        
        attr_accessor :default_selection_pendent
        alias_method :attr_default_selection_pendent, :default_selection_pendent
        undef_method :default_selection_pendent
        alias_method :attr_default_selection_pendent=, :default_selection_pendent=
        undef_method :default_selection_pendent=
        
        attr_accessor :arrow_key_down
        alias_method :attr_arrow_key_down, :arrow_key_down
        undef_method :arrow_key_down
        alias_method :attr_arrow_key_down=, :arrow_key_down=
        undef_method :arrow_key_down=
        
        attr_accessor :count
        alias_method :attr_count, :count
        undef_method :count
        alias_method :attr_count=, :count=
        undef_method :count=
        
        attr_accessor :start_time
        alias_method :attr_start_time, :start_time
        undef_method :start_time
        alias_method :attr_start_time=, :start_time=
        undef_method :start_time=
        
        attr_accessor :collapse_occurred
        alias_method :attr_collapse_occurred, :collapse_occurred
        undef_method :collapse_occurred
        alias_method :attr_collapse_occurred=, :collapse_occurred=
        undef_method :collapse_occurred=
        
        attr_accessor :expand_occurred
        alias_method :attr_expand_occurred, :expand_occurred
        undef_method :expand_occurred
        alias_method :attr_expand_occurred=, :expand_occurred=
        undef_method :expand_occurred=
        
        typesig { [Event] }
        define_method :handle_event do |e|
          if ((e.attr_type).equal?(SWT::DefaultSelection))
            event = self.class::SelectionEvent.new(e)
            fire_default_selection_event(event)
            if ((self.attr_current_method).equal?(DOUBLE_CLICK))
              fire_open_event(event)
            else
              if (@enter_key_down)
                fire_open_event(event)
                @enter_key_down = false
                @default_selection_pendent = nil
              else
                @default_selection_pendent = event
              end
            end
            return
          end
          case (e.attr_type)
          when SWT::MouseEnter, SWT::MouseExit
            @mouse_up_event = nil
            @mouse_move_event = nil
            @selection_pendent = nil
          when SWT::MouseMove
            if (((self.attr_current_method & SELECT_ON_HOVER)).equal?(0))
              return
            end
            if (!(e.attr_state_mask).equal?(0))
              return
            end
            if (!(e.attr_widget.get_display.get_focus_control).equal?(e.attr_widget))
              return
            end
            @mouse_move_event = e
            runnable = Array.typed(self.class::Runnable).new(1) { nil }
            listener_class = self.class
            runnable[0] = Class.new(self.class::Runnable.class == Class ? self.class::Runnable : Object) do
              extend LocalClass
              include_class_members listener_class
              include class_self::Runnable if class_self::Runnable.class == Module
              
              typesig { [] }
              define_method :run do
                time = System.current_time_millis
                diff = RJava.cast_to_int((time - self.attr_start_time))
                if (diff <= self.attr_time)
                  display.timer_exec(diff * 2 / 3, runnable[0])
                else
                  self.attr_timer_started = false
                  set_selection(self.attr_mouse_move_event)
                end
              end
              
              typesig { [Vararg.new(Object)] }
              define_method :initialize do |*args|
                super(*args)
              end
              
              private
              alias_method :initialize_anonymous, :initialize
            end.new_local(self)
            @start_time = System.current_time_millis
            if (!@timer_started)
              @timer_started = true
              display.timer_exec(self.attr_time * 2 / 3, runnable[0])
            end
          when SWT::MouseDown
            @mouse_up_event = nil
            @arrow_key_down = false
          when SWT::Expand
            @expand_occurred = true
          when SWT::Collapse
            @collapse_occurred = true
          when SWT::MouseUp
            @mouse_move_event = nil
            if ((!(e.attr_button).equal?(1)) || (!((e.attr_state_mask & ~SWT::BUTTON1)).equal?(0)))
              return
            end
            if (!(@selection_pendent).nil? && !(@collapse_occurred || @expand_occurred))
              mouse_select_item(@selection_pendent)
            else
              @mouse_up_event = e
              @collapse_occurred = false
              @expand_occurred = false
            end
          when SWT::KeyDown
            @mouse_move_event = nil
            @mouse_up_event = nil
            @arrow_key_down = (((e.attr_key_code).equal?(SWT::ARROW_UP)) || ((e.attr_key_code).equal?(SWT::ARROW_DOWN))) && (e.attr_state_mask).equal?(0)
            if ((e.attr_character).equal?(SWT::CR))
              if (!(@default_selection_pendent).nil?)
                fire_open_event(self.class::SelectionEvent.new(e))
                @enter_key_down = false
                @default_selection_pendent = nil
              else
                @enter_key_down = true
              end
            end
          when SWT::Selection
            event = self.class::SelectionEvent.new(e)
            fire_selection_event(event)
            @mouse_move_event = nil
            if (!(@mouse_up_event).nil?)
              mouse_select_item(event)
            else
              @selection_pendent = event
            end
            @count[0] += 1
            id = @count[0]
            # In the case of arrowUp/arrowDown when in the arrowKeysOpen mode, we
            # want to delay any selection until the last arrowDown/Up occurs.  This
            # handles the case where the user presses arrowDown/Up successively.
            # We only want to open an editor for the last selected item.
            listener_class = self.class
            display.async_exec(Class.new(self.class::Runnable.class == Class ? self.class::Runnable : Object) do
              extend LocalClass
              include_class_members listener_class
              include class_self::Runnable if class_self::Runnable.class == Module
              
              typesig { [] }
              define_method :run do
                if (self.attr_arrow_key_down)
                  runnable_class = self.class
                  display.timer_exec(self.attr_time, Class.new(self.class::Runnable.class == Class ? self.class::Runnable : Object) do
                    extend LocalClass
                    include_class_members runnable_class
                    include class_self::Runnable if class_self::Runnable.class == Module
                    
                    typesig { [] }
                    define_method :run do
                      if ((id).equal?(self.attr_count[0]))
                        fire_post_selection_event(self.class::SelectionEvent.new(e))
                        if (!((self.attr_current_method & ARROW_KEYS_OPEN)).equal?(0))
                          fire_open_event(self.class::SelectionEvent.new(e))
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
                else
                  fire_post_selection_event(self.class::SelectionEvent.new(e))
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
        
        typesig { [SelectionEvent] }
        define_method :mouse_select_item do |e|
          if (!((self.attr_current_method & SINGLE_CLICK)).equal?(0))
            fire_open_event(e)
          end
          @mouse_up_event = nil
          @selection_pendent = nil
        end
        
        typesig { [Event] }
        define_method :set_selection do |e|
          if ((e).nil?)
            return
          end
          w = e.attr_widget
          if (w.is_disposed)
            return
          end
          sel_event = self.class::SelectionEvent.new(e)
          # ISSUE: May have to create a interface with method:
          # setSelection(Point p) so that user's custom widgets
          # can use this class. If we keep this option.
          if (w.is_a?(self.class::Tree))
            tree = w
            item = tree.get_item(self.class::Point.new(e.attr_x, e.attr_y))
            if (!(item).nil?)
              tree.set_selection(Array.typed(self.class::TreeItem).new([item]))
            end
            sel_event.attr_item = item
          else
            if (w.is_a?(self.class::Table))
              table = w
              item = table.get_item(self.class::Point.new(e.attr_x, e.attr_y))
              if (!(item).nil?)
                table.set_selection(Array.typed(self.class::TableItem).new([item]))
              end
              sel_event.attr_item = item
            else
              if (w.is_a?(self.class::TableTree))
                table = w
                item = table.get_item(self.class::Point.new(e.attr_x, e.attr_y))
                if (!(item).nil?)
                  table.set_selection(Array.typed(self.class::TableTreeItem).new([item]))
                end
                sel_event.attr_item = item
              else
                return
              end
            end
          end
          if ((sel_event.attr_item).nil?)
            return
          end
          fire_selection_event(sel_event)
          fire_post_selection_event(sel_event)
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          @timer_started = false
          @mouse_up_event = nil
          @mouse_move_event = nil
          @selection_pendent = nil
          @enter_key_down = false
          @default_selection_pendent = nil
          @arrow_key_down = false
          @count = nil
          @start_time = 0
          @collapse_occurred = false
          @expand_occurred = false
          super(*args)
          @timer_started = false
          @mouse_up_event = nil
          @mouse_move_event = nil
          @selection_pendent = nil
          @enter_key_down = false
          @default_selection_pendent = nil
          @arrow_key_down = false
          @count = Array.typed(::Java::Int).new(1) { 0 }
          @start_time = System.current_time_millis
          @collapse_occurred = false
          @expand_occurred = false
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
    end
    
    private
    alias_method :initialize__open_strategy, :initialize
  end
  
end
