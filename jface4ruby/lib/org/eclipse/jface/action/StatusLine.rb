require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Action
  module StatusLineImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Action
      include_const ::Org::Eclipse::Core::Runtime, :IProgressMonitor
      include_const ::Org::Eclipse::Jface::Dialogs, :ProgressIndicator
      include_const ::Org::Eclipse::Jface::Resource, :ImageDescriptor
      include_const ::Org::Eclipse::Jface::Resource, :JFaceColors
      include_const ::Org::Eclipse::Jface::Resource, :JFaceResources
      include_const ::Org::Eclipse::Jface::Util, :Util
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Custom, :CLabel
      include_const ::Org::Eclipse::Swt::Events, :DisposeEvent
      include_const ::Org::Eclipse::Swt::Events, :DisposeListener
      include_const ::Org::Eclipse::Swt::Events, :SelectionAdapter
      include_const ::Org::Eclipse::Swt::Events, :SelectionEvent
      include_const ::Org::Eclipse::Swt::Graphics, :Cursor
      include_const ::Org::Eclipse::Swt::Graphics, :Font
      include_const ::Org::Eclipse::Swt::Graphics, :Image
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Graphics, :Rectangle
      include_const ::Org::Eclipse::Swt::Layout, :GridData
      include_const ::Org::Eclipse::Swt::Layout, :GridLayout
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Display
      include_const ::Org::Eclipse::Swt::Widgets, :Layout
      include_const ::Org::Eclipse::Swt::Widgets, :ToolBar
      include_const ::Org::Eclipse::Swt::Widgets, :ToolItem
    }
  end
  
  # A StatusLine control is a SWT Composite with a horizontal layout which hosts
  # a number of status indication controls. Typically it is situated below the
  # content area of the window.
  # <p>
  # By default a StatusLine has two predefined status controls: a MessageLine and
  # a ProgressIndicator and it provides API for easy access.
  # </p>
  # <p>
  # This is an internal class, not intended to be used outside the JFace
  # framework.
  # </p>
  # 
  # package
  class StatusLine < StatusLineImports.const_get :Composite
    include_class_members StatusLineImports
    overload_protected {
      include IProgressMonitor
    }
    
    class_module.module_eval {
      # Horizontal gaps between items.
      const_set_lazy(:GAP) { 3 }
      const_attr_reader  :GAP
      
      # Progress bar creation is delayed by this ms
      const_set_lazy(:DELAY_PROGRESS) { 500 }
      const_attr_reader  :DELAY_PROGRESS
    }
    
    # visibility state of the progressbar
    attr_accessor :f_progress_is_visible
    alias_method :attr_f_progress_is_visible, :f_progress_is_visible
    undef_method :f_progress_is_visible
    alias_method :attr_f_progress_is_visible=, :f_progress_is_visible=
    undef_method :f_progress_is_visible=
    
    # visibility state of the cancle button
    attr_accessor :f_cancel_button_is_visible
    alias_method :attr_f_cancel_button_is_visible, :f_cancel_button_is_visible
    undef_method :f_cancel_button_is_visible
    alias_method :attr_f_cancel_button_is_visible=, :f_cancel_button_is_visible=
    undef_method :f_cancel_button_is_visible=
    
    # enablement state of the cancle button
    attr_accessor :f_cancel_enabled
    alias_method :attr_f_cancel_enabled, :f_cancel_enabled
    undef_method :f_cancel_enabled
    alias_method :attr_f_cancel_enabled=, :f_cancel_enabled=
    undef_method :f_cancel_enabled=
    
    # name of the task
    attr_accessor :f_task_name
    alias_method :attr_f_task_name, :f_task_name
    undef_method :f_task_name
    alias_method :attr_f_task_name=, :f_task_name=
    undef_method :f_task_name=
    
    # is the task is cancled
    attr_accessor :f_is_canceled
    alias_method :attr_f_is_canceled, :f_is_canceled
    undef_method :f_is_canceled
    alias_method :attr_f_is_canceled=, :f_is_canceled=
    undef_method :f_is_canceled=
    
    # the start time of the task
    attr_accessor :f_start_time
    alias_method :attr_f_start_time, :f_start_time
    undef_method :f_start_time
    alias_method :attr_f_start_time=, :f_start_time=
    undef_method :f_start_time=
    
    attr_accessor :f_stop_button_cursor
    alias_method :attr_f_stop_button_cursor, :f_stop_button_cursor
    undef_method :f_stop_button_cursor
    alias_method :attr_f_stop_button_cursor=, :f_stop_button_cursor=
    undef_method :f_stop_button_cursor=
    
    # the message text
    attr_accessor :f_message_text
    alias_method :attr_f_message_text, :f_message_text
    undef_method :f_message_text
    alias_method :attr_f_message_text=, :f_message_text=
    undef_method :f_message_text=
    
    # the message image
    attr_accessor :f_message_image
    alias_method :attr_f_message_image, :f_message_image
    undef_method :f_message_image
    alias_method :attr_f_message_image=, :f_message_image=
    undef_method :f_message_image=
    
    # the error text
    attr_accessor :f_error_text
    alias_method :attr_f_error_text, :f_error_text
    undef_method :f_error_text
    alias_method :attr_f_error_text=, :f_error_text=
    undef_method :f_error_text=
    
    # the error image
    attr_accessor :f_error_image
    alias_method :attr_f_error_image, :f_error_image
    undef_method :f_error_image
    alias_method :attr_f_error_image=, :f_error_image=
    undef_method :f_error_image=
    
    # the message label
    attr_accessor :f_message_label
    alias_method :attr_f_message_label, :f_message_label
    undef_method :f_message_label
    alias_method :attr_f_message_label=, :f_message_label=
    undef_method :f_message_label=
    
    # the composite parent of the progress bar
    attr_accessor :f_progress_bar_composite
    alias_method :attr_f_progress_bar_composite, :f_progress_bar_composite
    undef_method :f_progress_bar_composite
    alias_method :attr_f_progress_bar_composite=, :f_progress_bar_composite=
    undef_method :f_progress_bar_composite=
    
    # the progress bar
    attr_accessor :f_progress_bar
    alias_method :attr_f_progress_bar, :f_progress_bar
    undef_method :f_progress_bar
    alias_method :attr_f_progress_bar=, :f_progress_bar=
    undef_method :f_progress_bar=
    
    # the toolbar
    attr_accessor :f_tool_bar
    alias_method :attr_f_tool_bar, :f_tool_bar
    undef_method :f_tool_bar
    alias_method :attr_f_tool_bar=, :f_tool_bar=
    undef_method :f_tool_bar=
    
    # the cancle button
    attr_accessor :f_cancel_button
    alias_method :attr_f_cancel_button, :f_cancel_button
    undef_method :f_cancel_button
    alias_method :attr_f_cancel_button=, :f_cancel_button=
    undef_method :f_cancel_button=
    
    class_module.module_eval {
      # stop image descriptor
      
      def fg_stop_image
        defined?(@@fg_stop_image) ? @@fg_stop_image : @@fg_stop_image= ImageDescriptor.create_from_file(StatusLine, "images/stop.gif")
      end
      alias_method :attr_fg_stop_image, :fg_stop_image
      
      def fg_stop_image=(value)
        @@fg_stop_image = value
      end
      alias_method :attr_fg_stop_image=, :fg_stop_image=
      
      # $NON-NLS-1$
      when_class_loaded do
        JFaceResources.get_image_registry.put("org.eclipse.jface.parts.StatusLine.stopImage", self.attr_fg_stop_image) # $NON-NLS-1$
      end
      
      # Layout the contribution item controls on the status line.
      const_set_lazy(:StatusLineLayout) { Class.new(Layout) do
        extend LocalClass
        include_class_members StatusLine
        
        attr_accessor :default_data
        alias_method :attr_default_data, :default_data
        undef_method :default_data
        alias_method :attr_default_data=, :default_data=
        undef_method :default_data=
        
        typesig { [class_self::Composite, ::Java::Int, ::Java::Int, ::Java::Boolean] }
        def compute_size(composite, w_hint, h_hint, changed)
          if (!(w_hint).equal?(SWT::DEFAULT) && !(h_hint).equal?(SWT::DEFAULT))
            return self.class::Point.new(w_hint, h_hint)
          end
          children = composite.get_children
          total_width = 0
          max_height = 0
          total_cnt = 0
          i = 0
          while i < children.attr_length
            use_width = true
            w = children[i]
            if ((w).equal?(self.attr_f_progress_bar_composite) && !self.attr_f_progress_is_visible)
              use_width = false
            else
              if ((w).equal?(self.attr_f_tool_bar) && !self.attr_f_cancel_button_is_visible)
                use_width = false
              end
            end
            data = w.get_layout_data
            if ((data).nil?)
              data = @default_data
            end
            e = w.compute_size(data.attr_width_hint, data.attr_height_hint, changed)
            if (use_width)
              total_width += e.attr_x
              total_cnt += 1
            end
            max_height = Math.max(max_height, e.attr_y)
            i += 1
          end
          if (total_cnt > 0)
            total_width += (total_cnt - 1) * GAP
          end
          if (total_width <= 0)
            total_width = max_height * 4
          end
          return self.class::Point.new(total_width, max_height)
        end
        
        typesig { [class_self::Composite, ::Java::Boolean] }
        def layout(composite, flush_cache)
          if ((composite).nil?)
            return
          end
          # StatusLineManager skips over the standard status line widgets
          # in its update method. There is thus a dependency
          # between the layout of the standard widgets and the update method.
          # Make sure cancel button and progress bar are before
          # contributions.
          self.attr_f_message_label.move_above(nil)
          self.attr_f_tool_bar.move_below(self.attr_f_message_label)
          self.attr_f_progress_bar_composite.move_below(self.attr_f_tool_bar)
          rect = composite.get_client_area
          children = composite.get_children
          count = children.attr_length
          ws = Array.typed(::Java::Int).new(count) { 0 }
          h = rect.attr_height
          total_width = -GAP
          i = 0
          while i < count
            w = children[i]
            if ((w).equal?(self.attr_f_progress_bar_composite) && !self.attr_f_progress_is_visible)
              i += 1
              next
            end
            if ((w).equal?(self.attr_f_tool_bar) && !self.attr_f_cancel_button_is_visible)
              i += 1
              next
            end
            data = w.get_layout_data
            if ((data).nil?)
              data = @default_data
            end
            width = w.compute_size(data.attr_width_hint, h, flush_cache).attr_x
            ws[i] = width
            total_width += width + GAP
            i += 1
          end
          diff = rect.attr_width - total_width
          ws[0] += diff # make the first StatusLabel wider
          # Check against minimum recommended width
          msg_min_width = rect.attr_width / 3
          if (ws[0] < msg_min_width)
            diff = ws[0] - msg_min_width
            ws[0] = msg_min_width
          else
            diff = 0
          end
          # Take space away from the contributions first.
          i_ = count - 1
          while i_ >= 0 && diff < 0
            min_ = Math.min(ws[i_], -diff)
            ws[i_] -= min_
            diff += min_ + GAP
            (i_ -= 1)
          end
          x = rect.attr_x
          y = rect.attr_y
          i__ = 0
          while i__ < count
            w = children[i__]
            # Workaround for Linux Motif: Even if the progress bar and
            # cancel button are not set to be visible ad of width 0, they
            # still draw over the first pixel of the editor contributions.
            # 
            # The fix here is to draw the progress bar and cancel button
            # off screen if they are not visible.
            if ((w).equal?(self.attr_f_progress_bar_composite) && !self.attr_f_progress_is_visible || (w).equal?(self.attr_f_tool_bar) && !self.attr_f_cancel_button_is_visible)
              w.set_bounds(x + rect.attr_width, y, ws[i__], h)
              i__ += 1
              next
            end
            w.set_bounds(x, y, ws[i__], h)
            if (ws[i__] > 0)
              x += ws[i__] + GAP
            end
            i__ += 1
          end
        end
        
        typesig { [] }
        def initialize
          @default_data = nil
          super()
          @default_data = self.class::StatusLineLayoutData.new
        end
        
        private
        alias_method :initialize__status_line_layout, :initialize
      end }
    }
    
    typesig { [Composite, ::Java::Int] }
    # Create a new StatusLine as a child of the given parent.
    # 
    # @param parent
    # the parent for this Composite
    # @param style
    # the style used to create this widget
    def initialize(parent, style)
      @f_progress_is_visible = false
      @f_cancel_button_is_visible = false
      @f_cancel_enabled = false
      @f_task_name = nil
      @f_is_canceled = false
      @f_start_time = 0
      @f_stop_button_cursor = nil
      @f_message_text = nil
      @f_message_image = nil
      @f_error_text = nil
      @f_error_image = nil
      @f_message_label = nil
      @f_progress_bar_composite = nil
      @f_progress_bar = nil
      @f_tool_bar = nil
      @f_cancel_button = nil
      super(parent, style)
      @f_progress_is_visible = false
      @f_cancel_button_is_visible = false
      @f_cancel_enabled = false
      add_dispose_listener(Class.new(DisposeListener.class == Class ? DisposeListener : Object) do
        extend LocalClass
        include_class_members StatusLine
        include DisposeListener if DisposeListener.class == Module
        
        typesig { [DisposeEvent] }
        define_method :widget_disposed do |e|
          handle_dispose
        end
        
        typesig { [Object] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      # StatusLineManager skips over the standard status line widgets
      # in its update method. There is thus a dependency
      # between this code defining the creation and layout of the standard
      # widgets and the update method.
      set_layout(StatusLineLayout.new_local(self))
      @f_message_label = CLabel.new(self, SWT::NONE) # SWT.SHADOW_IN);
      # Color[] colors = new Color[2];
      # colors[0] =
      # parent.getDisplay().getSystemColor(SWT.COLOR_WIDGET_LIGHT_SHADOW);
      # colors[1] = fMessageLabel.getBackground();
      # int[] gradient = new int[] {JFaceColors.STATUS_PERCENT};
      # fMessageLabel.setBackground(colors, gradient);
      @f_progress_is_visible = false
      @f_cancel_enabled = false
      @f_tool_bar = ToolBar.new(self, SWT::FLAT)
      @f_cancel_button = ToolItem.new(@f_tool_bar, SWT::PUSH)
      @f_cancel_button.set_image(self.attr_fg_stop_image.create_image)
      @f_cancel_button.set_tool_tip_text(JFaceResources.get_string("Cancel_Current_Operation")) # $NON-NLS-1$
      @f_cancel_button.add_selection_listener(Class.new(SelectionAdapter.class == Class ? SelectionAdapter : Object) do
        extend LocalClass
        include_class_members StatusLine
        include SelectionAdapter if SelectionAdapter.class == Module
        
        typesig { [SelectionEvent] }
        define_method :widget_selected do |e|
          set_canceled(true)
        end
        
        typesig { [Object] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      @f_cancel_button.add_dispose_listener(Class.new(DisposeListener.class == Class ? DisposeListener : Object) do
        extend LocalClass
        include_class_members StatusLine
        include DisposeListener if DisposeListener.class == Module
        
        typesig { [DisposeEvent] }
        define_method :widget_disposed do |e|
          i = self.attr_f_cancel_button.get_image
          if ((!(i).nil?) && (!i.is_disposed))
            i.dispose
          end
        end
        
        typesig { [Object] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      # We create a composite to create the progress bar in
      # so that it can be centered. See bug #32331
      @f_progress_bar_composite = Composite.new(self, SWT::NONE)
      layout = GridLayout.new
      layout.attr_horizontal_spacing = 0
      layout.attr_vertical_spacing = 0
      layout.attr_margin_height = 0
      layout.attr_margin_width = 0
      @f_progress_bar_composite.set_layout(layout)
      @f_progress_bar = ProgressIndicator.new(@f_progress_bar_composite)
      @f_progress_bar.set_layout_data(GridData.new(GridData::GRAB_HORIZONTAL | GridData::GRAB_VERTICAL))
      @f_stop_button_cursor = Cursor.new(get_display, SWT::CURSOR_ARROW)
    end
    
    typesig { [String, ::Java::Int] }
    # Notifies that the main task is beginning.
    # 
    # @param name
    # the name (or description) of the main task
    # @param totalWork
    # the total number of work units into which the main task is
    # been subdivided. If the value is 0 or UNKNOWN the
    # implemenation is free to indicate progress in a way which
    # doesn't require the total number of work units in advance. In
    # general users should use the UNKNOWN value if they don't know
    # the total amount of work units.
    def begin_task(name, total_work)
      timestamp = System.current_time_millis
      @f_start_time = timestamp
      animated = ((total_work).equal?(UNKNOWN) || (total_work).equal?(0))
      timer = # make sure the progress bar is made visible while
      # the task is running. Fixes bug 32198 for the non-animated case.
      Class.new(Runnable.class == Class ? Runnable : Object) do
        extend LocalClass
        include_class_members StatusLine
        include Runnable if Runnable.class == Module
        
        typesig { [] }
        define_method :run do
          @local_class_parent.start_task(timestamp, animated)
        end
        
        typesig { [Object] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
      if ((@f_progress_bar).nil?)
        return
      end
      @f_progress_bar.get_display.timer_exec(DELAY_PROGRESS, timer)
      if (!animated)
        @f_progress_bar.begin_task(total_work)
      end
      if ((name).nil?)
        @f_task_name = RJava.cast_to_string(Util::ZERO_LENGTH_STRING)
      else
        @f_task_name = name
      end
      set_message(@f_task_name)
    end
    
    typesig { [] }
    # Notifies that the work is done; that is, either the main task is
    # completed or the user cancelled it. Done() can be called more than once;
    # an implementation should be prepared to handle this case.
    def done
      @f_start_time = 0
      if (!(@f_progress_bar).nil?)
        @f_progress_bar.send_remaining_work
        @f_progress_bar.done
      end
      set_message(nil)
      hide_progress
    end
    
    typesig { [] }
    # Returns the status line's progress monitor
    # 
    # @return {@link IProgressMonitor} the progress monitor
    def get_progress_monitor
      return self
    end
    
    typesig { [] }
    # @private
    def handle_dispose
      if (!(@f_stop_button_cursor).nil?)
        @f_stop_button_cursor.dispose
        @f_stop_button_cursor = nil
      end
      if (!(@f_progress_bar).nil?)
        @f_progress_bar.dispose
        @f_progress_bar = nil
      end
    end
    
    typesig { [] }
    # Hides the Cancel button and ProgressIndicator.
    def hide_progress
      if (@f_progress_is_visible && !is_disposed)
        @f_progress_is_visible = false
        @f_cancel_enabled = false
        @f_cancel_button_is_visible = false
        if (!(@f_tool_bar).nil? && !@f_tool_bar.is_disposed)
          @f_tool_bar.set_visible(false)
        end
        if (!(@f_progress_bar_composite).nil? && !@f_progress_bar_composite.is_disposed)
          @f_progress_bar_composite.set_visible(false)
        end
        layout
      end
    end
    
    typesig { [::Java::Double] }
    # @see IProgressMonitor#internalWorked(double)
    def internal_worked(work)
      if (!@f_progress_is_visible)
        if (System.current_time_millis - @f_start_time > DELAY_PROGRESS)
          show_progress
        end
      end
      if (!(@f_progress_bar).nil?)
        @f_progress_bar.worked(work)
      end
    end
    
    typesig { [] }
    # Returns true if the user does some UI action to cancel this operation.
    # (like hitting the Cancel button on the progress dialog). The long running
    # operation typically polls isCanceled().
    def is_canceled
      return @f_is_canceled
    end
    
    typesig { [] }
    # Returns
    # <code>true</true> if the ProgressIndication provides UI for canceling
    # a long running operation.
    # @return <code>true</true> if the ProgressIndication provides UI for canceling
    def is_cancel_enabled
      return @f_cancel_enabled
    end
    
    typesig { [::Java::Boolean] }
    # Sets the cancel status. This method is usually called with the argument
    # false if a client wants to abort a cancel action.
    def set_canceled(b)
      @f_is_canceled = b
      if (!(@f_cancel_button).nil?)
        @f_cancel_button.set_enabled(!b)
      end
    end
    
    typesig { [::Java::Boolean] }
    # Controls whether the ProgressIndication provides UI for canceling a long
    # running operation. If the ProgressIndication is currently visible calling
    # this method may have a direct effect on the layout because it will make a
    # cancel button visible.
    # 
    # @param enabled
    # <code>true</true> if cancel should be enabled
    def set_cancel_enabled(enabled)
      @f_cancel_enabled = enabled
      if (@f_progress_is_visible && !@f_cancel_button_is_visible && enabled)
        show_button
        layout
      end
      if (!(@f_cancel_button).nil? && !@f_cancel_button.is_disposed)
        @f_cancel_button.set_enabled(enabled)
      end
    end
    
    typesig { [String] }
    # Sets the error message text to be displayed on the status line. The image
    # on the status line is cleared.
    # 
    # @param message
    # the error message, or <code>null</code> for no error message
    def set_error_message(message)
      set_error_message(nil, message)
    end
    
    typesig { [Image, String] }
    # Sets an image and error message text to be displayed on the status line.
    # 
    # @param image
    # the image to use, or <code>null</code> for no image
    # @param message
    # the error message, or <code>null</code> for no error message
    def set_error_message(image, message)
      @f_error_text = RJava.cast_to_string(trim(message))
      @f_error_image = image
      update_message_label
    end
    
    typesig { [Font] }
    # Applies the given font to this status line.
    def set_font(font)
      super(font)
      children = get_children
      i = 0
      while i < children.attr_length
        children[i].set_font(font)
        i += 1
      end
    end
    
    typesig { [String] }
    # Sets the message text to be displayed on the status line. The image on
    # the status line is cleared.
    # 
    # @param message
    # the error message, or <code>null</code> for no error message
    def set_message(message)
      set_message(nil, message)
    end
    
    typesig { [Image, String] }
    # Sets an image and a message text to be displayed on the status line.
    # 
    # @param image
    # the image to use, or <code>null</code> for no image
    # @param message
    # the message, or <code>null</code> for no message
    def set_message(image, message)
      @f_message_text = RJava.cast_to_string(trim(message))
      @f_message_image = image
      update_message_label
    end
    
    typesig { [String] }
    # @see IProgressMonitor#setTaskName(java.lang.String)
    def set_task_name(name)
      if ((name).nil?)
        @f_task_name = RJava.cast_to_string(Util::ZERO_LENGTH_STRING)
      else
        @f_task_name = name
      end
    end
    
    typesig { [] }
    # Makes the Cancel button visible.
    def show_button
      if (!(@f_tool_bar).nil? && !@f_tool_bar.is_disposed)
        @f_tool_bar.set_visible(true)
        @f_tool_bar.set_enabled(true)
        @f_tool_bar.set_cursor(@f_stop_button_cursor)
        @f_cancel_button_is_visible = true
      end
    end
    
    typesig { [] }
    # Shows the Cancel button and ProgressIndicator.
    def show_progress
      if (!@f_progress_is_visible && !is_disposed)
        @f_progress_is_visible = true
        if (@f_cancel_enabled)
          show_button
        end
        if (!(@f_progress_bar_composite).nil? && !@f_progress_bar_composite.is_disposed)
          @f_progress_bar_composite.set_visible(true)
        end
        layout
      end
    end
    
    typesig { [::Java::Long, ::Java::Boolean] }
    # @private
    def start_task(timestamp, animated)
      if (!@f_progress_is_visible && (@f_start_time).equal?(timestamp))
        show_progress
        if (animated)
          if (!(@f_progress_bar).nil? && !@f_progress_bar.is_disposed)
            @f_progress_bar.begin_animated_task
          end
        end
      end
    end
    
    typesig { [String] }
    # Notifies that a subtask of the main task is beginning. Subtasks are
    # optional; the main task might not have subtasks.
    # 
    # @param name
    # the name (or description) of the subtask
    # @see IProgressMonitor#subTask(String)
    def sub_task(name)
      new_name = nil
      if ((name).nil?)
        new_name = RJava.cast_to_string(Util::ZERO_LENGTH_STRING)
      else
        new_name = name
      end
      text = nil
      if ((@f_task_name).nil? || (@f_task_name.length).equal?(0))
        text = new_name
      else
        text = RJava.cast_to_string(JFaceResources.format("Set_SubTask", Array.typed(Object).new([@f_task_name, new_name]))) # $NON-NLS-1$
      end
      set_message(text)
    end
    
    typesig { [String] }
    # Trims the message to be displayable in the status line. This just pulls
    # out the first line of the message. Allows null.
    def trim(message)
      if ((message).nil?)
        return nil
      end
      message = RJava.cast_to_string(Util.replace_all(message, "&", "&&")) # $NON-NLS-1$//$NON-NLS-2$
      cr = message.index_of(Character.new(?\r.ord))
      lf = message.index_of(Character.new(?\n.ord))
      if ((cr).equal?(-1) && (lf).equal?(-1))
        return message
      end
      len = 0
      if ((cr).equal?(-1))
        len = lf
      else
        if ((lf).equal?(-1))
          len = cr
        else
          len = Math.min(cr, lf)
        end
      end
      return message.substring(0, len)
    end
    
    typesig { [] }
    # Updates the message label widget.
    def update_message_label
      if (!(@f_message_label).nil? && !@f_message_label.is_disposed)
        display = @f_message_label.get_display
        if ((!(@f_error_text).nil? && @f_error_text.length > 0) || !(@f_error_image).nil?)
          @f_message_label.set_foreground(JFaceColors.get_error_text(display))
          @f_message_label.set_text(@f_error_text)
          @f_message_label.set_image(@f_error_image)
        else
          @f_message_label.set_foreground(display.get_system_color(SWT::COLOR_WIDGET_FOREGROUND))
          @f_message_label.set_text((@f_message_text).nil? ? "" : @f_message_text) # $NON-NLS-1$
          @f_message_label.set_image(@f_message_image)
        end
      end
    end
    
    typesig { [::Java::Int] }
    # @see IProgressMonitor#worked(int)
    def worked(work)
      internal_worked(work)
    end
    
    private
    alias_method :initialize__status_line, :initialize
  end
  
end
