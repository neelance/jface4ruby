require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Dialogs
  module ProgressMonitorDialogImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Dialogs
      include_const ::Java::Lang::Reflect, :InvocationTargetException
      include_const ::Org::Eclipse::Core::Runtime, :IProgressMonitor
      include_const ::Org::Eclipse::Core::Runtime, :IProgressMonitorWithBlocking
      include_const ::Org::Eclipse::Core::Runtime, :IStatus
      include_const ::Org::Eclipse::Jface::Operation, :IRunnableContext
      include_const ::Org::Eclipse::Jface::Operation, :IRunnableWithProgress
      include_const ::Org::Eclipse::Jface::Operation, :ModalContext
      include_const ::Org::Eclipse::Jface::Resource, :JFaceResources
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Graphics, :Cursor
      include_const ::Org::Eclipse::Swt::Graphics, :Image
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Layout, :GridData
      include_const ::Org::Eclipse::Swt::Widgets, :Button
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Event
      include_const ::Org::Eclipse::Swt::Widgets, :Label
      include_const ::Org::Eclipse::Swt::Widgets, :Listener
      include_const ::Org::Eclipse::Swt::Widgets, :Shell
    }
  end
  
  # A modal dialog that displays progress during a long running operation.
  # <p>
  # This concrete dialog class can be instantiated as is, or further subclassed
  # as required.
  # </p>
  # <p>
  # Typical usage is:
  # 
  # <pre>
  # 
  # 
  # try {
  # IRunnableWithProgress op = ...;
  # new ProgressMonitorDialog(activeShell).run(true, true, op);
  # } catch (InvocationTargetException e) {
  # // handle exception
  # } catch (InterruptedException e) {
  # // handle cancelation
  # }
  # 
  # 
  # </pre>
  # 
  # </p>
  # <p>
  # Note that the ProgressMonitorDialog is not intended to be used with multiple
  # runnables - this dialog should be discarded after completion of one
  # IRunnableWithProgress and a new one instantiated for use by a second or
  # sebsequent IRunnableWithProgress to ensure proper initialization.
  # </p>
  # <p>
  # Note that not forking the process will result in it running in the UI which
  # may starve the UI. The most obvious symptom of this problem is non
  # responsiveness of the cancel button. If you are running within the UI Thread
  # you should do the bulk of your work in another Thread to prevent starvation.
  # It is recommended that fork is set to true in most cases.
  # </p>
  class ProgressMonitorDialog < ProgressMonitorDialogImports.const_get :IconAndMessageDialog
    include_class_members ProgressMonitorDialogImports
    overload_protected {
      include IRunnableContext
    }
    
    class_module.module_eval {
      # Name to use for task when normal task name is empty string.
      
      def default_taskname
        defined?(@@default_taskname) ? @@default_taskname : @@default_taskname= JFaceResources.get_string("ProgressMonitorDialog.message")
      end
      alias_method :attr_default_taskname, :default_taskname
      
      def default_taskname=(value)
        @@default_taskname = value
      end
      alias_method :attr_default_taskname=, :default_taskname=
      
      # $NON-NLS-1$
      # 
      # Constants for label and monitor size
      
      def label_dlus
        defined?(@@label_dlus) ? @@label_dlus : @@label_dlus= 21
      end
      alias_method :attr_label_dlus, :label_dlus
      
      def label_dlus=(value)
        @@label_dlus = value
      end
      alias_method :attr_label_dlus=, :label_dlus=
      
      
      def bar_dlus
        defined?(@@bar_dlus) ? @@bar_dlus : @@bar_dlus= 9
      end
      alias_method :attr_bar_dlus, :bar_dlus
      
      def bar_dlus=(value)
        @@bar_dlus = value
      end
      alias_method :attr_bar_dlus=, :bar_dlus=
    }
    
    # The progress indicator control.
    attr_accessor :progress_indicator
    alias_method :attr_progress_indicator, :progress_indicator
    undef_method :progress_indicator
    alias_method :attr_progress_indicator=, :progress_indicator=
    undef_method :progress_indicator=
    
    # The label control for the task. Kept for backwards compatibility.
    attr_accessor :task_label
    alias_method :attr_task_label, :task_label
    undef_method :task_label
    alias_method :attr_task_label=, :task_label=
    undef_method :task_label=
    
    # The label control for the subtask.
    attr_accessor :sub_task_label
    alias_method :attr_sub_task_label, :sub_task_label
    undef_method :sub_task_label
    alias_method :attr_sub_task_label=, :sub_task_label=
    undef_method :sub_task_label=
    
    # The Cancel button control.
    attr_accessor :cancel
    alias_method :attr_cancel, :cancel
    undef_method :cancel
    alias_method :attr_cancel=, :cancel=
    undef_method :cancel=
    
    # Indicates whether the Cancel button is to be shown.
    attr_accessor :operation_cancelable_state
    alias_method :attr_operation_cancelable_state, :operation_cancelable_state
    undef_method :operation_cancelable_state
    alias_method :attr_operation_cancelable_state=, :operation_cancelable_state=
    undef_method :operation_cancelable_state=
    
    # Indicates whether the Cancel button is to be enabled.
    attr_accessor :enable_cancel_button
    alias_method :attr_enable_cancel_button, :enable_cancel_button
    undef_method :enable_cancel_button
    alias_method :attr_enable_cancel_button=, :enable_cancel_button=
    undef_method :enable_cancel_button=
    
    # The progress monitor.
    attr_accessor :progress_monitor
    alias_method :attr_progress_monitor, :progress_monitor
    undef_method :progress_monitor
    alias_method :attr_progress_monitor=, :progress_monitor=
    undef_method :progress_monitor=
    
    # The name of the current task (used by ProgressMonitor).
    attr_accessor :task
    alias_method :attr_task, :task
    undef_method :task
    alias_method :attr_task=, :task=
    undef_method :task=
    
    # The nesting depth of currently running runnables.
    attr_accessor :nesting_depth
    alias_method :attr_nesting_depth, :nesting_depth
    undef_method :nesting_depth
    alias_method :attr_nesting_depth=, :nesting_depth=
    undef_method :nesting_depth=
    
    # The cursor used in the cancel button;
    attr_accessor :arrow_cursor
    alias_method :attr_arrow_cursor, :arrow_cursor
    undef_method :arrow_cursor
    alias_method :attr_arrow_cursor=, :arrow_cursor=
    undef_method :arrow_cursor=
    
    # The cursor used in the shell;
    attr_accessor :wait_cursor
    alias_method :attr_wait_cursor, :wait_cursor
    undef_method :wait_cursor
    alias_method :attr_wait_cursor=, :wait_cursor=
    undef_method :wait_cursor=
    
    # Flag indicating whether to open or merely create the dialog before run.
    attr_accessor :open_on_run
    alias_method :attr_open_on_run, :open_on_run
    undef_method :open_on_run
    alias_method :attr_open_on_run=, :open_on_run=
    undef_method :open_on_run=
    
    class_module.module_eval {
      # Internal progress monitor implementation.
      const_set_lazy(:ProgressMonitor) { Class.new do
        extend LocalClass
        include_class_members ProgressMonitorDialog
        include IProgressMonitorWithBlocking
        
        attr_accessor :f_sub_task
        alias_method :attr_f_sub_task, :f_sub_task
        undef_method :f_sub_task
        alias_method :attr_f_sub_task=, :f_sub_task=
        undef_method :f_sub_task=
        
        # $NON-NLS-1$
        attr_accessor :f_is_canceled
        alias_method :attr_f_is_canceled, :f_is_canceled
        undef_method :f_is_canceled
        alias_method :attr_f_is_canceled=, :f_is_canceled=
        undef_method :f_is_canceled=
        
        # is the process forked
        attr_accessor :forked
        alias_method :attr_forked, :forked
        undef_method :forked
        alias_method :attr_forked=, :forked=
        undef_method :forked=
        
        # is locked
        attr_accessor :locked
        alias_method :attr_locked, :locked
        undef_method :locked
        alias_method :attr_locked=, :locked=
        undef_method :locked=
        
        typesig { [String, ::Java::Int] }
        def begin_task(name, total_work)
          if (self.attr_progress_indicator.is_disposed)
            return
          end
          if ((name).nil?)
            self.attr_task = "" # $NON-NLS-1$
          else
            self.attr_task = name
          end
          s = self.attr_task
          if (s.length <= 0)
            s = self.attr_default_taskname
          end
          set_message(s, false)
          if (!@forked)
            update
          end
          if ((total_work).equal?(UNKNOWN))
            self.attr_progress_indicator.begin_animated_task
          else
            self.attr_progress_indicator.begin_task(total_work)
          end
        end
        
        typesig { [] }
        def done
          if (!self.attr_progress_indicator.is_disposed)
            self.attr_progress_indicator.send_remaining_work
            self.attr_progress_indicator.done
          end
        end
        
        typesig { [String] }
        def set_task_name(name)
          if ((name).nil?)
            self.attr_task = "" # $NON-NLS-1$
          else
            self.attr_task = name
          end
          s = self.attr_task
          if (s.length <= 0)
            s = self.attr_default_taskname
          end
          set_message(s, false)
          if (!@forked)
            update
          end
        end
        
        typesig { [] }
        def is_canceled
          return @f_is_canceled
        end
        
        typesig { [::Java::Boolean] }
        def set_canceled(b)
          @f_is_canceled = b
          if (@locked)
            clear_blocked
          end
        end
        
        typesig { [String] }
        def sub_task(name)
          if (self.attr_sub_task_label.is_disposed)
            return
          end
          if ((name).nil?)
            @f_sub_task = "" # $NON-NLS-1$
          else
            @f_sub_task = name
          end
          self.attr_sub_task_label.set_text(shorten_text(@f_sub_task, self.attr_sub_task_label))
          if (!@forked)
            self.attr_sub_task_label.update
          end
        end
        
        typesig { [::Java::Int] }
        def worked(work)
          internal_worked(work)
        end
        
        typesig { [::Java::Double] }
        def internal_worked(work)
          if (!self.attr_progress_indicator.is_disposed)
            self.attr_progress_indicator.worked(work)
          end
        end
        
        typesig { [] }
        # (non-Javadoc)
        # 
        # @see org.eclipse.core.runtime.IProgressMonitorWithBlocking#clearBlocked()
        def clear_blocked
          if ((get_shell).nil? || get_shell.is_disposed)
            return
          end
          @locked = false
          update_for_clear_blocked
        end
        
        typesig { [class_self::IStatus] }
        # (non-Javadoc)
        # 
        # @see org.eclipse.core.runtime.IProgressMonitorWithBlocking#setBlocked(org.eclipse.core.runtime.IStatus)
        def set_blocked(reason)
          if ((get_shell).nil? || get_shell.is_disposed)
            return
          end
          @locked = true
          update_for_set_blocked(reason)
        end
        
        typesig { [] }
        def initialize
          @f_sub_task = ""
          @f_is_canceled = false
          @forked = false
          @locked = false
        end
        
        private
        alias_method :initialize__progress_monitor, :initialize
      end }
    }
    
    typesig { [] }
    # Clear blocked state from the receiver.
    def update_for_clear_blocked
      @progress_indicator.show_normal
      set_message(@task, true)
      self.attr_image_label.set_image(get_image)
    end
    
    typesig { [IStatus] }
    # Set blocked state from the receiver.
    # 
    # @param reason
    # IStatus that gives the details
    def update_for_set_blocked(reason)
      @progress_indicator.show_paused
      set_message(reason.get_message, true)
      self.attr_image_label.set_image(get_image)
    end
    
    typesig { [Shell] }
    # Creates a progress monitor dialog under the given shell. The dialog has a
    # standard title and no image. <code>open</code> is non-blocking.
    # 
    # @param parent
    # the parent shell, or <code>null</code> to create a top-level
    # shell
    def initialize(parent)
      @progress_indicator = nil
      @task_label = nil
      @sub_task_label = nil
      @cancel = nil
      @operation_cancelable_state = false
      @enable_cancel_button = false
      @progress_monitor = nil
      @task = nil
      @nesting_depth = 0
      @arrow_cursor = nil
      @wait_cursor = nil
      @open_on_run = false
      super(parent)
      @operation_cancelable_state = false
      @progress_monitor = ProgressMonitor.new_local(self)
      @open_on_run = true
      # no close button on the shell style
      if (is_resizable)
        set_shell_style(get_default_orientation | SWT::BORDER | SWT::TITLE | SWT::APPLICATION_MODAL | SWT::RESIZE | SWT::MAX)
      else
        set_shell_style(get_default_orientation | SWT::BORDER | SWT::TITLE | SWT::APPLICATION_MODAL)
      end
      set_block_on_open(false)
    end
    
    typesig { [::Java::Boolean] }
    # Enables the cancel button (asynchronously).
    # 
    # @param b
    # The state to set the button to.
    def async_set_operation_cancel_button_enabled(b)
      if (!(get_shell).nil?)
        get_shell.get_display.async_exec(Class.new(Runnable.class == Class ? Runnable : Object) do
          extend LocalClass
          include_class_members ProgressMonitorDialog
          include Runnable if Runnable.class == Module
          
          typesig { [] }
          define_method :run do
            set_operation_cancel_button_enabled(b)
          end
          
          typesig { [] }
          define_method :initialize do
            super()
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      end
    end
    
    typesig { [] }
    # The cancel button has been pressed.
    # 
    # @since 3.0
    def cancel_pressed
      # NOTE: this was previously done from a listener installed on the
      # cancel button. On GTK, the listener installed by
      # Dialog.createButton is called first and this was throwing an
      # exception because the cancel button was already disposed
      @cancel.set_enabled(false)
      @progress_monitor.set_canceled(true)
      super
    end
    
    typesig { [] }
    # (non-Javadoc) Method declared on Window.
    # 
    # 
    # The <code>ProgressMonitorDialog</code> implementation of this method
    # only closes the dialog if there are no currently running runnables.
    def close
      if (get_nesting_depth <= 0)
        clear_cursors
        return super
      end
      return false
    end
    
    typesig { [] }
    # Clear the cursors in the dialog.
    # 
    # @since 3.0
    def clear_cursors
      if (!(@cancel).nil? && !@cancel.is_disposed)
        @cancel.set_cursor(nil)
      end
      shell = get_shell
      if (!(shell).nil? && !shell.is_disposed)
        shell.set_cursor(nil)
      end
      if (!(@arrow_cursor).nil?)
        @arrow_cursor.dispose
      end
      if (!(@wait_cursor).nil?)
        @wait_cursor.dispose
      end
      @arrow_cursor = nil
      @wait_cursor = nil
    end
    
    typesig { [Shell] }
    # (non-Javadoc) Method declared in Window.
    def configure_shell(shell)
      super(shell)
      shell.set_text(JFaceResources.get_string("ProgressMonitorDialog.title")) # $NON-NLS-1$
      if ((@wait_cursor).nil?)
        @wait_cursor = Cursor.new(shell.get_display, SWT::CURSOR_WAIT)
      end
      shell.set_cursor(@wait_cursor)
      shell.add_listener(SWT::Show, # Add a listener to set the message properly when the dialog becomes
      # visible
      Class.new(Listener.class == Class ? Listener : Object) do
        extend LocalClass
        include_class_members ProgressMonitorDialog
        include Listener if Listener.class == Module
        
        typesig { [Event] }
        define_method :handle_event do |event|
          # We need to async the message update since the Show precedes
          # visibility
          listener_class = self.class
          shell.get_display.async_exec(Class.new(self.class::Runnable.class == Class ? self.class::Runnable : Object) do
            extend LocalClass
            include_class_members listener_class
            include class_self::Runnable if class_self::Runnable.class == Module
            
            typesig { [] }
            define_method :run do
              set_message(self.attr_message, true)
            end
            
            typesig { [] }
            define_method :initialize do
              super()
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
        end
        
        typesig { [] }
        define_method :initialize do
          super()
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
    end
    
    typesig { [Composite] }
    # (non-Javadoc) Method declared on Dialog.
    def create_buttons_for_button_bar(parent)
      # cancel button
      create_cancel_button(parent)
    end
    
    typesig { [Composite] }
    # Creates the cancel button.
    # 
    # @param parent
    # the parent composite
    # @since 3.0
    def create_cancel_button(parent)
      @cancel = create_button(parent, IDialogConstants::CANCEL_ID, IDialogConstants::CANCEL_LABEL, true)
      if ((@arrow_cursor).nil?)
        @arrow_cursor = Cursor.new(@cancel.get_display, SWT::CURSOR_ARROW)
      end
      @cancel.set_cursor(@arrow_cursor)
      set_operation_cancel_button_enabled(@enable_cancel_button)
    end
    
    typesig { [Composite] }
    # (non-Javadoc) Method declared on Dialog.
    def create_dialog_area(parent)
      set_message(self.attr_default_taskname, false)
      create_message_area(parent)
      # Only set for backwards compatibility
      @task_label = self.attr_message_label
      # progress indicator
      @progress_indicator = ProgressIndicator.new(parent)
      gd = GridData.new
      gd.attr_height_hint = convert_vertical_dlus_to_pixels(self.attr_bar_dlus)
      gd.attr_horizontal_alignment = GridData::FILL
      gd.attr_grab_excess_horizontal_space = true
      gd.attr_horizontal_span = 2
      @progress_indicator.set_layout_data(gd)
      # label showing current task
      @sub_task_label = Label.new(parent, SWT::LEFT | SWT::WRAP)
      gd = GridData.new(GridData::FILL_HORIZONTAL)
      gd.attr_height_hint = convert_vertical_dlus_to_pixels(self.attr_label_dlus)
      gd.attr_horizontal_span = 2
      @sub_task_label.set_layout_data(gd)
      @sub_task_label.set_font(parent.get_font)
      return parent
    end
    
    typesig { [] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.window.Window#getInitialSize()
    def get_initial_size
      calculated_size = super
      if (calculated_size.attr_x < 450)
        calculated_size.attr_x = 450
      end
      return calculated_size
    end
    
    typesig { [] }
    # Returns the progress monitor to use for operations run in this progress
    # dialog.
    # 
    # @return the progress monitor
    def get_progress_monitor
      return @progress_monitor
    end
    
    typesig { [::Java::Boolean, ::Java::Boolean, IRunnableWithProgress] }
    # This implementation of IRunnableContext#run(boolean, boolean,
    # IRunnableWithProgress) runs the given <code>IRunnableWithProgress</code>
    # using the progress monitor for this progress dialog and blocks until the
    # runnable has been run, regardless of the value of <code>fork</code>.
    # The dialog is opened before the runnable is run, and closed after it
    # completes. It is recommended that <code>fork</code> is set to true in
    # most cases. If <code>fork</code> is set to <code>false</code>, the
    # runnable will run in the UI thread and it is the runnable's
    # responsibility to call <code>Display.readAndDispatch()</code> to ensure
    # UI responsiveness.
    def run(fork, cancelable, runnable)
      set_cancelable(cancelable)
      begin
        about_to_run
        # Let the progress monitor know if they need to update in UI Thread
        @progress_monitor.attr_forked = fork
        ModalContext.run(runnable, fork, get_progress_monitor, get_shell.get_display)
      ensure
        finished_run
      end
    end
    
    typesig { [] }
    # Returns whether the dialog should be opened before the operation is run.
    # Defaults to <code>true</code>
    # 
    # @return <code>true</code> to open the dialog before run,
    # <code>false</code> to only create the dialog, but not open it
    # @since 3.0
    def get_open_on_run
      return @open_on_run
    end
    
    typesig { [::Java::Boolean] }
    # Sets whether the dialog should be opened before the operation is run.
    # NOTE: Setting this to false and not forking a process may starve any
    # asyncExec that tries to open the dialog later.
    # 
    # @param openOnRun
    # <code>true</code> to open the dialog before run,
    # <code>false</code> to only create the dialog, but not open
    # it
    # @since 3.0
    def set_open_on_run(open_on_run)
      @open_on_run = open_on_run
    end
    
    typesig { [] }
    # Returns the nesting depth of running operations.
    # 
    # @return the nesting depth of running operations
    # @since 3.0
    def get_nesting_depth
      return @nesting_depth
    end
    
    typesig { [] }
    # Increments the nesting depth of running operations.
    # 
    # @since 3.0
    def increment_nesting_depth
      @nesting_depth += 1
    end
    
    typesig { [] }
    # Decrements the nesting depth of running operations.
    # 
    # @since 3.0
    def decrement_nesting_depth
      @nesting_depth -= 1
    end
    
    typesig { [] }
    # Called just before the operation is run. Default behaviour is to open or
    # create the dialog, based on the setting of <code>getOpenOnRun</code>,
    # and increment the nesting depth.
    # 
    # @since 3.0
    def about_to_run
      if (get_open_on_run)
        open
      else
        create
      end
      increment_nesting_depth
    end
    
    typesig { [] }
    # Called just after the operation is run. Default behaviour is to decrement
    # the nesting depth, and close the dialog.
    # 
    # @since 3.0
    def finished_run
      decrement_nesting_depth
      close
    end
    
    typesig { [::Java::Boolean] }
    # Sets whether the progress dialog is cancelable or not.
    # 
    # @param cancelable
    # <code>true</code> if the end user can cancel this progress
    # dialog, and <code>false</code> if it cannot be canceled
    def set_cancelable(cancelable)
      if ((@cancel).nil?)
        @enable_cancel_button = cancelable
      else
        async_set_operation_cancel_button_enabled(cancelable)
      end
    end
    
    typesig { [::Java::Boolean] }
    # Helper to enable/disable Cancel button for this dialog.
    # 
    # @param b
    # <code>true</code> to enable the cancel button, and
    # <code>false</code> to disable it
    # @since 3.0
    def set_operation_cancel_button_enabled(b)
      @operation_cancelable_state = b
      @cancel.set_enabled(b)
    end
    
    typesig { [] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.dialogs.IconAndMessageDialog#getImage()
    def get_image
      return get_info_image
    end
    
    typesig { [String, ::Java::Boolean] }
    # Set the message in the message label.
    # 
    # @param messageString
    # The string for the new message.
    # @param force
    # If force is true then always set the message text.
    def set_message(message_string, force)
      # must not set null text in a label
      self.attr_message = (message_string).nil? ? "" : message_string # $NON-NLS-1$
      if ((self.attr_message_label).nil? || self.attr_message_label.is_disposed)
        return
      end
      if (force || self.attr_message_label.is_visible)
        self.attr_message_label.set_tool_tip_text(self.attr_message)
        self.attr_message_label.set_text(shorten_text(self.attr_message, self.attr_message_label))
      end
    end
    
    typesig { [] }
    # Update the message label. Required if the monitor is forked.
    def update
      if ((self.attr_message_label).nil? || self.attr_message_label.is_disposed)
        return
      end
      self.attr_message_label.update
    end
    
    typesig { [] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.window.Window#open()
    def open
      # Check to be sure it is not already done. If it is just return OK.
      if (!get_open_on_run)
        if ((get_nesting_depth).equal?(0))
          return OK
        end
      end
      result = super
      # update message label just in case beginTask() has been invoked
      # already
      if ((@task).nil? || (@task.length).equal?(0))
        set_message(self.attr_default_taskname, true)
      else
        set_message(@task, true)
      end
      return result
    end
    
    private
    alias_method :initialize__progress_monitor_dialog, :initialize
  end
  
end
