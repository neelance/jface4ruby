require "rjava"

# Copyright (c) 2000, 2007 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Operation
  module AccumulatingProgressMonitorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Operation
      include_const ::Org::Eclipse::Core::Runtime, :IProgressMonitor
      include_const ::Org::Eclipse::Core::Runtime, :IProgressMonitorWithBlocking
      include_const ::Org::Eclipse::Core::Runtime, :IStatus
      include_const ::Org::Eclipse::Core::Runtime, :ProgressMonitorWrapper
      include_const ::Org::Eclipse::Jface::Dialogs, :Dialog
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Swt::Widgets, :Display
    }
  end
  
  # A progress monitor that accumulates <code>worked</code> and <code>subtask</code>
  # calls in the following way by wrapping a standard progress monitor:
  # <ul>
  # <li> When a <code>worked</code> or <code>subtask</code> call occurs the first time,
  # the progress monitor posts a runnable into the asynchronous SWT event queue.
  # </li>
  # <li> Subsequent calls to <code>worked</code> or <code>subtask</code> do not post
  # a new runnable as long as a previous runnable still exists in the SWT event
  # queue. In this case, the progress monitor just updates the internal state of
  # the runnable that waits in the SWT event queue for its execution. If no runnable
  # exists, a new one is created and posted into the event queue.
  # </ul>
  # <p>
  # This class is internal to the framework; clients outside JFace should not
  # use this class.
  # </p>
  # 
  # package
  class AccumulatingProgressMonitor < AccumulatingProgressMonitorImports.const_get :ProgressMonitorWrapper
    include_class_members AccumulatingProgressMonitorImports
    
    # The display.
    attr_accessor :display
    alias_method :attr_display, :display
    undef_method :display
    alias_method :attr_display=, :display=
    undef_method :display=
    
    # The collector, or <code>null</code> if none.
    attr_accessor :collector
    alias_method :attr_collector, :collector
    undef_method :collector
    alias_method :attr_collector=, :collector=
    undef_method :collector=
    
    attr_accessor :current_task
    alias_method :attr_current_task, :current_task
    undef_method :current_task
    alias_method :attr_current_task=, :current_task=
    undef_method :current_task=
    
    class_module.module_eval {
      # $NON-NLS-1$
      const_set_lazy(:Collector) { Class.new do
        extend LocalClass
        include_class_members AccumulatingProgressMonitor
        include Runnable
        
        attr_accessor :sub_task
        alias_method :attr_sub_task, :sub_task
        undef_method :sub_task
        alias_method :attr_sub_task=, :sub_task=
        undef_method :sub_task=
        
        attr_accessor :worked
        alias_method :attr_worked, :worked
        undef_method :worked
        alias_method :attr_worked=, :worked=
        undef_method :worked=
        
        attr_accessor :monitor
        alias_method :attr_monitor, :monitor
        undef_method :monitor
        alias_method :attr_monitor=, :monitor=
        undef_method :monitor=
        
        typesig { [String, ::Java::Double, class_self::IProgressMonitor] }
        # Create a new collector.
        # @param subTask
        # @param work
        # @param monitor
        def initialize(sub_task, work, monitor)
          @sub_task = nil
          @worked = 0.0
          @monitor = nil
          @sub_task = sub_task
          @worked = work
          @monitor = monitor
        end
        
        typesig { [::Java::Double] }
        # Add worked to the work.
        # @param workedIncrement
        def worked(worked_increment)
          @worked = @worked + worked_increment
        end
        
        typesig { [String] }
        # Set the subTask name.
        # @param subTaskName
        def sub_task(sub_task_name)
          @sub_task = sub_task_name
        end
        
        typesig { [] }
        # Run the collector.
        def run
          clear_collector(self)
          if (!(@sub_task).nil?)
            @monitor.sub_task(@sub_task)
          end
          if (@worked > 0)
            @monitor.internal_worked(@worked)
          end
        end
        
        private
        alias_method :initialize__collector, :initialize
      end }
    }
    
    typesig { [IProgressMonitor, Display] }
    # Creates an accumulating progress monitor wrapping the given one
    # that uses the given display.
    # 
    # @param monitor the actual progress monitor to be wrapped
    # @param display the SWT display used to forward the calls
    # to the wrapped progress monitor
    def initialize(monitor, display)
      @display = nil
      @collector = nil
      @current_task = nil
      super(monitor)
      @current_task = ""
      Assert.is_not_null(display)
      @display = display
    end
    
    typesig { [String, ::Java::Int] }
    # (non-Javadoc)
    # Method declared on IProgressMonitor.
    def begin_task(name, total_work)
      synchronized((self)) do
        @collector = nil
      end
      @display.async_exec(Class.new(Runnable.class == Class ? Runnable : Object) do
        extend LocalClass
        include_class_members AccumulatingProgressMonitor
        include Runnable if Runnable.class == Module
        
        typesig { [] }
        define_method :run do
          self.attr_current_task = name
          get_wrapped_progress_monitor.begin_task(name, total_work)
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
    end
    
    typesig { [Collector] }
    # Clears the collector object used to accumulate work and subtask calls
    # if it matches the given one.
    # @param collectorToClear
    def clear_collector(collector_to_clear)
      synchronized(self) do
        # Check if the accumulator is still using the given collector.
        # If not, don't clear it.
        if ((@collector).equal?(collector_to_clear))
          @collector = nil
        end
      end
    end
    
    typesig { [String, ::Java::Double] }
    # Creates a collector object to accumulate work and subtask calls.
    # @param subTask
    # @param work
    def create_collector(sub_task, work)
      @collector = Collector.new_local(self, sub_task, work, get_wrapped_progress_monitor)
      @display.async_exec(@collector)
    end
    
    typesig { [] }
    # (non-Javadoc)
    # Method declared on IProgressMonitor.
    def done
      synchronized((self)) do
        @collector = nil
      end
      @display.async_exec(Class.new(Runnable.class == Class ? Runnable : Object) do
        extend LocalClass
        include_class_members AccumulatingProgressMonitor
        include Runnable if Runnable.class == Module
        
        typesig { [] }
        define_method :run do
          get_wrapped_progress_monitor.done
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
    end
    
    typesig { [::Java::Double] }
    # (non-Javadoc)
    # Method declared on IProgressMonitor.
    def internal_worked(work)
      synchronized(self) do
        if ((@collector).nil?)
          create_collector(nil, work)
        else
          @collector.worked(work)
        end
      end
    end
    
    typesig { [String] }
    # (non-Javadoc)
    # Method declared on IProgressMonitor.
    def set_task_name(name)
      synchronized((self)) do
        @collector = nil
      end
      @display.async_exec(Class.new(Runnable.class == Class ? Runnable : Object) do
        extend LocalClass
        include_class_members AccumulatingProgressMonitor
        include Runnable if Runnable.class == Module
        
        typesig { [] }
        define_method :run do
          self.attr_current_task = name
          get_wrapped_progress_monitor.set_task_name(name)
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
    end
    
    typesig { [String] }
    # (non-Javadoc)
    # Method declared on IProgressMonitor.
    def sub_task(name)
      synchronized(self) do
        if ((@collector).nil?)
          create_collector(name, 0)
        else
          @collector.sub_task(name)
        end
      end
    end
    
    typesig { [::Java::Int] }
    # (non-Javadoc)
    # Method declared on IProgressMonitor.
    def worked(work)
      synchronized(self) do
        internal_worked(work)
      end
    end
    
    typesig { [] }
    # (non-Javadoc)
    # @see org.eclipse.core.runtime.ProgressMonitorWrapper#clearBlocked()
    def clear_blocked
      # If this is a monitor that can report blocking do so.
      # Don't bother with a collector as this should only ever
      # happen once and prevent any more progress.
      pm = get_wrapped_progress_monitor
      if (!(pm.is_a?(IProgressMonitorWithBlocking)))
        return
      end
      @display.async_exec(Class.new(Runnable.class == Class ? Runnable : Object) do
        extend LocalClass
        include_class_members AccumulatingProgressMonitor
        include Runnable if Runnable.class == Module
        
        typesig { [] }
        # (non-Javadoc)
        # @see java.lang.Runnable#run()
        define_method :run do
          (pm).clear_blocked
          Dialog.get_blocked_handler.clear_blocked
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
    end
    
    typesig { [IStatus] }
    # (non-Javadoc)
    # @see org.eclipse.core.runtime.ProgressMonitorWrapper#setBlocked(org.eclipse.core.runtime.IStatus)
    def set_blocked(reason)
      # If this is a monitor that can report blocking do so.
      # Don't bother with a collector as this should only ever
      # happen once and prevent any more progress.
      pm = get_wrapped_progress_monitor
      if (!(pm.is_a?(IProgressMonitorWithBlocking)))
        return
      end
      @display.async_exec(Class.new(Runnable.class == Class ? Runnable : Object) do
        extend LocalClass
        include_class_members AccumulatingProgressMonitor
        include Runnable if Runnable.class == Module
        
        typesig { [] }
        # (non-Javadoc)
        # @see java.lang.Runnable#run()
        define_method :run do
          (pm).set_blocked(reason)
          # Do not give a shell as we want it to block until it opens.
          Dialog.get_blocked_handler.show_blocked(pm, reason, self.attr_current_task)
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
    end
    
    private
    alias_method :initialize__accumulating_progress_monitor, :initialize
  end
  
end
