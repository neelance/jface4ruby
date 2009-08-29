require "rjava"

# Copyright (c) 2000, 2009 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Operation
  module ModalContextImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Operation
      include_const ::Java::Lang::Reflect, :InvocationTargetException
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Core::Runtime, :IProgressMonitor
      include_const ::Org::Eclipse::Core::Runtime, :IStatus
      include_const ::Org::Eclipse::Core::Runtime, :OperationCanceledException
      include_const ::Org::Eclipse::Core::Runtime, :ProgressMonitorWrapper
      include_const ::Org::Eclipse::Core::Runtime, :Status
      include_const ::Org::Eclipse::Jface::Util, :Policy
      include_const ::Org::Eclipse::Swt::Widgets, :Display
    }
  end
  
  # Utility class for supporting modal operations. The runnable passed to the
  # <code>run</code> method is executed in a separate thread, depending on the
  # value of the passed fork argument. If the runnable is executed in a separate
  # thread then the current thread either waits until the new thread ends or, if
  # the current thread is the UI thread, it polls the SWT event queue and
  # dispatches each event.
  # <p>
  # This class is not intended to be subclassed.
  # </p>
  # @noinstantiate This class is not intended to be instantiated by clients.
  # @noextend This class is not intended to be subclassed by clients.
  class ModalContext 
    include_class_members ModalContextImports
    
    class_module.module_eval {
      # Indicated whether ModalContext is in debug mode; <code>false</code> by
      # default.
      
      def debug
        defined?(@@debug) ? @@debug : @@debug= false
      end
      alias_method :attr_debug, :debug
      
      def debug=(value)
        @@debug = value
      end
      alias_method :attr_debug=, :debug=
      
      # The number of nested modal runs, or 0 if not inside a modal run. This is
      # global state.
      
      def modal_level
        defined?(@@modal_level) ? @@modal_level : @@modal_level= 0
      end
      alias_method :attr_modal_level, :modal_level
      
      def modal_level=(value)
        @@modal_level = value
      end
      alias_method :attr_modal_level=, :modal_level=
      
      # Indicates whether operations should be run in a separate thread. Defaults
      # to true. For internal debugging use, set to false to run operations in
      # the calling thread.
      
      def run_in_separate_thread
        defined?(@@run_in_separate_thread) ? @@run_in_separate_thread : @@run_in_separate_thread= true
      end
      alias_method :attr_run_in_separate_thread, :run_in_separate_thread
      
      def run_in_separate_thread=(value)
        @@run_in_separate_thread = value
      end
      alias_method :attr_run_in_separate_thread=, :run_in_separate_thread=
      
      # Thread which runs the modal context.
      const_set_lazy(:ModalContextThread) { Class.new(JavaThread) do
        include_class_members ModalContext
        
        # The operation to be run.
        attr_accessor :runnable
        alias_method :attr_runnable, :runnable
        undef_method :runnable
        alias_method :attr_runnable=, :runnable=
        undef_method :runnable=
        
        # The exception thrown by the operation starter.
        attr_accessor :throwable
        alias_method :attr_throwable, :throwable
        undef_method :throwable
        alias_method :attr_throwable=, :throwable=
        undef_method :throwable=
        
        # The progress monitor used for progress and cancelation.
        attr_accessor :progress_monitor
        alias_method :attr_progress_monitor, :progress_monitor
        undef_method :progress_monitor
        alias_method :attr_progress_monitor=, :progress_monitor=
        undef_method :progress_monitor=
        
        # The display used for event dispatching.
        attr_accessor :display
        alias_method :attr_display, :display
        undef_method :display
        alias_method :attr_display=, :display=
        undef_method :display=
        
        # Indicates whether to continue event queue dispatching.
        attr_accessor :continue_event_dispatching
        alias_method :attr_continue_event_dispatching, :continue_event_dispatching
        undef_method :continue_event_dispatching
        alias_method :attr_continue_event_dispatching=, :continue_event_dispatching=
        undef_method :continue_event_dispatching=
        
        # The thread that forked this modal context thread.
        # 
        # @since 3.1
        attr_accessor :calling_thread
        alias_method :attr_calling_thread, :calling_thread
        undef_method :calling_thread
        alias_method :attr_calling_thread=, :calling_thread=
        undef_method :calling_thread=
        
        typesig { [class_self::IRunnableWithProgress, class_self::IProgressMonitor, class_self::Display] }
        # Creates a new modal context.
        # 
        # @param operation
        # the runnable to run
        # @param monitor
        # the progress monitor to use to display progress and
        # receive requests for cancelation
        # @param display
        # the display to be used to read and dispatch events
        def initialize(operation, monitor, display)
          @runnable = nil
          @throwable = nil
          @progress_monitor = nil
          @display = nil
          @continue_event_dispatching = false
          @calling_thread = nil
          super("ModalContext")
          @continue_event_dispatching = true # $NON-NLS-1$
          Assert.is_true(!(monitor).nil? && !(display).nil?)
          @runnable = operation
          @progress_monitor = self.class::AccumulatingProgressMonitor.new(monitor, display)
          @display = display
          @calling_thread = JavaThread.current_thread
        end
        
        typesig { [] }
        # (non-Javadoc) Method declared on Thread.
        def run
          begin
            if (!(@runnable).nil?)
              @runnable.run(@progress_monitor)
            end
          rescue self.class::InvocationTargetException => e
            @throwable = e
          rescue self.class::InterruptedException => e
            @throwable = e
          rescue self.class::RuntimeException => e
            @throwable = e
          rescue self.class::ThreadDeath => e
            # Make sure to propagate ThreadDeath, or threads will never
            # fully terminate
            raise e
          rescue self.class::JavaError => e
            @throwable = e
          ensure
            # notify the operation of change of thread of control
            if (@runnable.is_a?(self.class::IThreadListener))
              exception = invoke_thread_listener((@runnable), @calling_thread)
              # Forward it if we don't already have one
              if (!(exception).nil? && (@throwable).nil?)
                @throwable = exception
              end
            end
            @display.sync_exec(# Make sure that all events in the asynchronous event queue
            # are dispatched.
            Class.new(self.class::Runnable.class == Class ? self.class::Runnable : Object) do
              extend LocalClass
              include_class_members ModalContextThread
              include class_self::Runnable if class_self::Runnable.class == Module
              
              typesig { [] }
              define_method :run do
                # do nothing
              end
              
              typesig { [] }
              define_method :initialize do
                super()
              end
              
              private
              alias_method :initialize_anonymous, :initialize
            end.new_local(self))
            # Stop event dispatching
            @continue_event_dispatching = false
            # Force the event loop to return from sleep () so that
            # it stops event dispatching.
            @display.async_exec(nil)
          end
        end
        
        typesig { [] }
        # Processes events or waits until this modal context thread terminates.
        def block
          if ((@display).equal?(Display.get_current))
            exception_count = 0
            while (@continue_event_dispatching)
              # Run the event loop. Handle any uncaught exceptions caused
              # by UI events.
              begin
                if (!@display.read_and_dispatch)
                  @display.sleep
                end
                exception_count = 0
              # ThreadDeath is a normal error when the thread is dying.
              # We must
              # propagate it in order for it to properly terminate.
              rescue self.class::ThreadDeath => e
                raise (e)
              # For all other exceptions, log the problem.
              rescue self.class::JavaThrowable => t
                if (t.is_a?(self.class::VirtualMachineError))
                  raise t
                end
                exception_count += 1
                # We're counting exceptions in client code, such as asyncExecs,
                # so be generous about how many may fail consecutively before we
                # give up.
                if (exception_count > 50 || @display.is_disposed)
                  if (t.is_a?(self.class::RuntimeException))
                    raise t
                  else
                    if (t.is_a?(self.class::JavaError))
                      raise t
                    else
                      raise self.class::RuntimeException.new(t)
                    end
                  end
                end
                # $NON-NLS-1$
                Policy.get_log.log(self.class::Status.new(IStatus::ERROR, Policy::JFACE, "Unhandled event loop exception during blocked modal context.", t))
              end
            end
          else
            begin
              join
            rescue self.class::InterruptedException => e
              @throwable = e
            end
          end
        end
        
        private
        alias_method :initialize__modal_context_thread, :initialize
      end }
      
      typesig { [IProgressMonitor, IProgressMonitor] }
      # Returns whether the first progress monitor is the same as, or a wrapper
      # around, the second progress monitor.
      # 
      # @param monitor1
      # the first progress monitor
      # @param monitor2
      # the second progress monitor
      # @return <code>true</code> if the first is the same as, or a wrapper
      # around, the second
      # @see ProgressMonitorWrapper
      def can_progress_monitor_be_used(monitor1, monitor2)
        if ((monitor1).equal?(monitor2))
          return true
        end
        while (monitor1.is_a?(ProgressMonitorWrapper))
          monitor1 = (monitor1).get_wrapped_progress_monitor
          if ((monitor1).equal?(monitor2))
            return true
          end
        end
        return false
      end
      
      typesig { [IProgressMonitor] }
      # Checks with the given progress monitor and throws
      # <code>InterruptedException</code> if it has been canceled.
      # <p>
      # Code in a long-running operation should call this method regularly so
      # that a request to cancel will be honored.
      # </p>
      # <p>
      # Convenience for:
      # 
      # <pre>
      # if (monitor.isCanceled())
      # throw new InterruptedException();
      # </pre>
      # 
      # </p>
      # 
      # @param monitor
      # the progress monitor
      # @exception InterruptedException
      # if cancelling the operation has been requested
      # @see IProgressMonitor#isCanceled()
      def check_canceled(monitor)
        if (monitor.is_canceled)
          raise InterruptedException.new
        end
      end
      
      typesig { [] }
      # Returns the currently active modal context thread, or null if no modal
      # context is active.
      def get_current_modal_context_thread
        t = JavaThread.current_thread
        if (t.is_a?(ModalContextThread))
          return t
        end
        return nil
      end
      
      typesig { [] }
      # Returns the modal nesting level.
      # <p>
      # The modal nesting level increases by one each time the
      # <code>ModalContext.run</code> method is called within the dynamic scope
      # of another call to <code>ModalContext.run</code>.
      # </p>
      # 
      # @return the modal nesting level, or <code>0</code> if this method is
      # called outside the dynamic scope of any invocation of
      # <code>ModalContext.run</code>
      def get_modal_level
        return self.attr_modal_level
      end
      
      typesig { [JavaThread] }
      # Returns whether the given thread is running a modal context.
      # 
      # @param thread
      # The thread to be checked
      # @return <code>true</code> if the given thread is running a modal
      # context, <code>false</code> if not
      def is_modal_context_thread(thread)
        return thread.is_a?(ModalContextThread)
      end
      
      typesig { [IRunnableWithProgress, ::Java::Boolean, IProgressMonitor, Display] }
      # Runs the given runnable in a modal context, passing it a progress
      # monitor.
      # <p>
      # The modal nesting level is increased by one from the perspective of the
      # given runnable.
      # </p>
      # <p>
      # If the supplied operation implements <code>IThreadListener</code>, it
      # will be notified of any thread changes required to execute the operation.
      # Specifically, the operation will be notified of the thread that will call
      # its <code>run</code> method before it is called, and will be notified
      # of the change of control back to the thread calling this method when the
      # operation completes. These thread change notifications give the operation
      # an opportunity to transfer any thread-local state to the execution thread
      # before control is transferred to the new thread.
      # </p>
      # 
      # @param operation
      # the runnable to run
      # @param fork
      # <code>true</code> if the runnable should run in a separate
      # thread, and <code>false</code> if in the same thread
      # @param monitor
      # the progress monitor to use to display progress and receive
      # requests for cancelation
      # @param display
      # the display to be used to read and dispatch events
      # @exception InvocationTargetException
      # if the run method must propagate a checked exception, it
      # should wrap it inside an
      # <code>InvocationTargetException</code>; runtime
      # exceptions and errors are automatically wrapped in an
      # <code>InvocationTargetException</code> by this method
      # @exception InterruptedException
      # if the operation detects a request to cancel, using
      # <code>IProgressMonitor.isCanceled()</code>, it should
      # exit by throwing <code>InterruptedException</code>;
      # this method propagates the exception
      def run(operation, fork, monitor, display)
        Assert.is_true(!(operation).nil? && !(monitor).nil?)
        self.attr_modal_level += 1
        begin
          if (!(monitor).nil?)
            monitor.set_canceled(false)
          end
          # Is the runnable supposed to be execute in the same thread.
          if (!fork || !self.attr_run_in_separate_thread)
            run_in_current_thread(operation, monitor)
          else
            t = get_current_modal_context_thread
            if (!(t).nil?)
              Assert.is_true(can_progress_monitor_be_used(monitor, t.attr_progress_monitor))
              run_in_current_thread(operation, monitor)
            else
              t = ModalContextThread.new(operation, monitor, display)
              listener_exception = nil
              if (operation.is_a?(IThreadListener))
                listener_exception = invoke_thread_listener(operation, t)
              end
              if ((listener_exception).nil?)
                t.start
                t.block
              else
                if ((t.attr_throwable).nil?)
                  t.attr_throwable = listener_exception
                end
              end
              throwable = t.attr_throwable
              if (!(throwable).nil?)
                if (self.attr_debug && !(throwable.is_a?(InterruptedException)) && !(throwable.is_a?(OperationCanceledException)))
                  System.err.println("Exception in modal context operation:") # $NON-NLS-1$
                  throwable.print_stack_trace
                  System.err.println("Called from:") # $NON-NLS-1$
                  # Don't create the InvocationTargetException on the
                  # throwable,
                  # otherwise it will print its stack trace (from the
                  # other thread).
                  InvocationTargetException.new(nil).print_stack_trace
                end
                if (throwable.is_a?(InvocationTargetException))
                  raise throwable
                else
                  if (throwable.is_a?(InterruptedException))
                    raise throwable
                  else
                    if (throwable.is_a?(OperationCanceledException))
                      # See 1GAN3L5: ITPUI:WIN2000 - ModalContext
                      # converts OperationCancelException into
                      # InvocationTargetException
                      raise InterruptedException.new(throwable.get_message)
                    else
                      raise InvocationTargetException.new(throwable)
                    end
                  end
                end
              end
            end
          end
        ensure
          self.attr_modal_level -= 1
        end
      end
      
      typesig { [IThreadListener, JavaThread] }
      # Invoke the ThreadListener if there are any errors or RuntimeExceptions
      # return them.
      # 
      # @param listener
      # @param switchingThread
      # the {@link Thread} being switched to
      def invoke_thread_listener(listener, switching_thread)
        begin
          listener.thread_change(switching_thread)
        rescue ThreadDeath => e
          # Make sure to propagate ThreadDeath, or threads will never
          # fully terminate
          raise e
        rescue JavaError => e
          return e
        rescue RuntimeException => e
          return e
        end
        return nil
      end
      
      typesig { [IRunnableWithProgress, IProgressMonitor] }
      # Run a runnable. Convert all thrown exceptions to either
      # InterruptedException or InvocationTargetException
      def run_in_current_thread(runnable, progress_monitor)
        begin
          if (!(runnable).nil?)
            runnable.run(progress_monitor)
          end
        rescue InvocationTargetException => e
          raise e
        rescue InterruptedException => e
          raise e
        rescue OperationCanceledException => e
          raise InterruptedException.new
        rescue ThreadDeath => e
          # Make sure to propagate ThreadDeath, or threads will never fully
          # terminate
          raise e
        rescue RuntimeException => e
          raise InvocationTargetException.new(e)
        rescue JavaError => e
          raise InvocationTargetException.new(e)
        end
      end
      
      typesig { [::Java::Boolean] }
      # Sets whether ModalContext is running in debug mode.
      # 
      # @param debugMode
      # <code>true</code> for debug mode, and <code>false</code>
      # for normal mode (the default)
      def set_debug_mode(debug_mode)
        self.attr_debug = debug_mode
      end
      
      typesig { [::Java::Boolean] }
      # Sets whether ModalContext may process events (by calling
      # <code>Display.readAndDispatch()</code>) while running operations. By
      # default, ModalContext will process events while running operations. Use
      # this method to disallow event processing temporarily.
      # 
      # @param allowReadAndDispatch
      # <code>true</code> (the default) if events may be processed
      # while running an operation, <code>false</code> if
      # Display.readAndDispatch() should not be called from
      # ModalContext.
      # @since 3.2
      def set_allow_read_and_dispatch(allow_read_and_dispatch)
        # use a separate thread if and only if it is OK to spin the event loop
        self.attr_run_in_separate_thread = allow_read_and_dispatch
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__modal_context, :initialize
  end
  
end
