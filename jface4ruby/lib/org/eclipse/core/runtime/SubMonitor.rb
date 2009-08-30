require "rjava"

# Copyright (c) 2006, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# Stefan Xenos - initial API and implementation
# Stefan Xenos - bug 174539 - add a 1-argument convert(...) method
# Stefan Xenos - bug 174040 - SubMonitor#convert doesn't always set task name
# Stefan Xenos - bug 206942 - updated javadoc to recommend better constants for infinite progress
# IBM Corporation - ongoing maintenance
module Org::Eclipse::Core::Runtime
  module SubMonitorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Runtime
    }
  end
  
  # <p>A progress monitor that uses a given amount of work ticks from a parent monitor. This is intended as a
  # safer, easier-to-use alternative to SubProgressMonitor. The main benefits of SubMonitor over
  # SubProgressMonitor are:</p>
  # <ul>
  # <li>It is not necessary to call beginTask() or done() on an instance of SubMonitor.</li>
  # <li>SubMonitor has a simpler syntax for creating nested monitors.</li>
  # <li>SubMonitor is more efficient for deep recursion chains.</li>
  # <li>SubMonitor has a setWorkRemining method that allows the remaining space on the monitor to be
  # redistributed without reporting any work.</li>
  # <li>SubMonitor protects the caller from common progress reporting bugs in a called method. For example,
  # if a called method fails to call done() on the given monitor or fails to consume all the ticks on
  # the given monitor, the parent will correct the problem after the method returns.</li>
  # </ul>
  # <p></p>
  # <p><b>USAGE:</b></p>
  # 
  # <p>When implementing a method that accepts an IProgressMonitor:</p>
  # <ul>
  # <li>At the start of your method, use <code>SubMonitor.convert(...).</code> to convert the IProgressMonitor
  # into a SubMonitor. </li>
  # <li>Use <code>SubMonitor.newChild(...)</code> whenever you need to call another method that
  # accepts an IProgressMonitor.</li>
  # </ul>
  # <p></p>
  # <p><b>DEFAULT BEHAVIOR:</b></p>
  # 
  # <p>When writing JavaDoc for a method that accepts an IProgressMonitor, you should assume the
  # following default behavior unless the method's JavaDoc says otherwise:</p>
  # <ul>
  # <li>It WILL call beginTask on the IProgressMonitor.</li>
  # <li>It WILL NOT accept a null argument.</li>
  # <li>It WILL call done on the IProgressMonitor.</li>
  # </ul>
  # <p></p>
  # <p><b>BEST PRACTISES:</b></p>
  # 
  # <p>We recommend that newly-written methods follow the given contract:</p>
  # <ul>
  # <li>It WILL call beginTask on the IProgressMonitor.</li>
  # <li>It WILL accept a null argument, indicating that no progress should be reported and the operation cannot be cancelled.</li>
  # <li>It WILL NOT call done on the IProgressMonitor, leaving this responsibility up to the caller.</li>
  # </ul>
  # <p>If you wish to follow these conventions, you may copy and paste the following text into your method's JavaDoc:</p>
  # 
  # <pre>@param monitor the progress monitor to use for reporting progress to the user. It is the caller's responsibility
  # to call done() on the given monitor. Accepts <code>null</code>, indicating that no progress should be
  # reported and that the operation cannot be cancelled.</pre>
  # 
  # <p></p>
  # <p><b>Example: Recommended usage</b></p>
  # 
  # <p>This example demonstrates how the recommended usage of <code>SubMonitor</code> makes it unnecessary to call
  # IProgressMonitor.done() in most situations.</p>
  # 
  # <p>It is never necessary to call done() on a monitor obtained from <code>convert</code> or <code>progress.newChild()</code>.
  # In this example, there is no guarantee that <code>monitor</code> is an instance of <code>SubMonitor</code>, making it
  # necessary to call <code>monitor.done()</code>. The JavaDoc contract makes this the responsibility of the caller.</p>
  # 
  # <pre>
  # // param monitor the progress monitor to use for reporting progress to the user. It is the caller's responsibility
  # //        to call done() on the given monitor. Accepts <code>null</code>, indicating that no progress should be
  # //        reported and that the operation cannot be cancelled.
  # //
  # void doSomething(IProgressMonitor monitor) {
  # // Convert the given monitor into a progress instance
  # SubMonitor progress = SubMonitor.convert(monitor, 100);
  # 
  # // Use 30% of the progress to do some work
  # doSomeWork(progress.newChild(30));
  # 
  # // Advance the monitor by another 30%
  # progress.worked(30);
  # 
  # // Use the remaining 40% of the progress to do some more work
  # doSomeWork(progress.newChild(40));
  # }
  # </pre>
  # 
  # 
  # <p></p>
  # <p><b>Example: Default usage</b></p>
  # 
  # <p>You will often need to implement a method that does not explicitly stipulate that calling done() is the responsibility
  # of the caller. In this case, you should use the following pattern:</p>
  # 
  # <pre>
  # // param monitor the progress monitor to use for reporting progress to the user, or <code>null</code> indicating
  # //        that no progress should be reported and the operation cannot be cancelled.
  # //
  # void doSomething(IProgressMonitor monitor) {
  # // Convert the given monitor into a progress instance
  # SubMonitor progress = SubMonitor.convert(monitor, 100);
  # try {
  # // Use 30% of the progress to do some work
  # doSomeWork(progress.newChild(30));
  # 
  # // Advance the monitor by another 30%
  # progress.worked(30);
  # 
  # // Use the remaining 40% of the progress to do some more work
  # doSomeWork(progress.newChild(40));
  # 
  # } finally {
  # if (monitor != null) {
  # monitor.done();
  # }
  # }
  # }
  # </pre>
  # 
  # <p></p>
  # <p><b>Example: Branches</b></p>
  # 
  # <p>This example demonstrates how to smoothly report progress in situations where some of the work is optional.</p>
  # 
  # <pre>
  # void doSomething(IProgressMonitor monitor) {
  # SubMonitor progress = SubMonitor.convert(monitor, 100);
  # 
  # if (condition) {
  # // Use 50% of the progress to do some work
  # doSomeWork(progress.newChild(50));
  # }
  # 
  # // Don't report any work, but ensure that we have 50 ticks remaining on the progress monitor.
  # // If we already consumed 50 ticks in the above branch, this is a no-op. Otherwise, the remaining
  # // space in the monitor is redistributed into 50 ticks.
  # 
  # progress.setWorkRemaining(50);
  # 
  # // Use the remainder of the progress monitor to do the rest of the work
  # doSomeWork(progress.newChild(50));
  # }
  # </pre>
  # 
  # <p>Please beware of the following anti-pattern:</p>
  # 
  # <pre>
  # if (condition) {
  # // Use 50% of the progress to do some work
  # doSomeWork(progress.newChild(50));
  # } else {
  # // Bad: Causes the progress monitor to appear to start at 50%, wasting half of the
  # // space in the monitor.
  # progress.worked(50);
  # }
  # </pre>
  # 
  # 
  # <p></p>
  # <p><b>Example: Loops</b></p>
  # 
  # <p>This example demonstrates how to report progress in a loop.</p>
  # 
  # <pre>
  # void doSomething(IProgressMonitor monitor, Collection someCollection) {
  # SubMonitor progress = SubMonitor.convert(monitor, 100);
  # 
  # // Create a new progress monitor that uses 70% of the total progress and will allocate one tick
  # // for each element of the given collection.
  # SubMonitor loopProgress = progress.newChild(70).setWorkRemaining(someCollection.size());
  # 
  # for (Iterator iter = someCollection.iterator(); iter.hasNext();) {
  # Object next = iter.next();
  # 
  # doWorkOnElement(next, loopProgress.newChild(1));
  # }
  # 
  # // Use the remaining 30% of the progress monitor to do some work outside the loop
  # doSomeWork(progress.newChild(30));
  # }
  # </pre>
  # 
  # 
  # <p></p>
  # <p><b>Example: Infinite progress</b></p>
  # 
  # <p>This example demonstrates how to report logarithmic progress in situations where the number of ticks
  # cannot be easily computed in advance.</p>
  # 
  # <pre>
  # void doSomething(IProgressMonitor monitor, LinkedListNode node) {
  # SubMonitor progress = SubMonitor.convert(monitor);
  # 
  # while (node != null) {
  # // Regardless of the amount of progress reported so far,
  # // use 0.01% of the space remaining in the monitor to process the next node.
  # progress.setWorkRemaining(10000);
  # 
  # doWorkOnElement(node, progress.newChild(1));
  # 
  # node = node.next;
  # }
  # }
  # </pre>
  # 
  # <p>
  # This class can be used without OSGi running.
  # </p>
  # 
  # @since org.eclipse.equinox.common 3.3
  class SubMonitor 
    include_class_members SubMonitorImports
    include IProgressMonitorWithBlocking
    
    class_module.module_eval {
      # Minimum number of ticks to allocate when calling beginTask on an unknown IProgressMonitor.
      # Pick a number that is big enough such that, no matter where progress is being displayed,
      # the user would be unlikely to notice if progress were to be reported with higher accuracy.
      const_set_lazy(:MINIMUM_RESOLUTION) { 1000 }
      const_attr_reader  :MINIMUM_RESOLUTION
      
      # The RootInfo holds information about the root progress monitor. A SubMonitor and
      # its active descendents share the same RootInfo.
      const_set_lazy(:RootInfo) { Class.new do
        include_class_members SubMonitor
        
        attr_accessor :root
        alias_method :attr_root, :root
        undef_method :root
        alias_method :attr_root=, :root=
        undef_method :root=
        
        # Remembers the last task name. Prevents us from setting the same task name multiple
        # times in a row.
        attr_accessor :task_name
        alias_method :attr_task_name, :task_name
        undef_method :task_name
        alias_method :attr_task_name=, :task_name=
        undef_method :task_name=
        
        # Remembers the last subtask name. Prevents the SubMonitor from setting the same
        # subtask string more than once in a row.
        attr_accessor :sub_task
        alias_method :attr_sub_task, :sub_task
        undef_method :sub_task
        alias_method :attr_sub_task=, :sub_task=
        undef_method :sub_task=
        
        typesig { [class_self::IProgressMonitor] }
        # Creates a RootInfo struct that delegates to the given progress
        # monitor.
        # 
        # @param root progress monitor to delegate to
        def initialize(root)
          @root = nil
          @task_name = nil
          @sub_task = nil
          @root = root
        end
        
        typesig { [] }
        def is_canceled
          return @root.is_canceled
        end
        
        typesig { [::Java::Boolean] }
        def set_canceled(value)
          @root.set_canceled(value)
        end
        
        typesig { [String] }
        def set_task_name(task_name)
          if (eq(task_name, @task_name))
            return
          end
          @task_name = task_name
          @root.set_task_name(task_name)
        end
        
        typesig { [String] }
        def sub_task(name)
          if (eq(@sub_task, name))
            return
          end
          @sub_task = name
          @root.sub_task(name)
        end
        
        typesig { [::Java::Int] }
        def worked(i)
          @root.worked(i)
        end
        
        typesig { [] }
        def clear_blocked
          if (@root.is_a?(self.class::IProgressMonitorWithBlocking))
            (@root).clear_blocked
          end
        end
        
        typesig { [class_self::IStatus] }
        def set_blocked(reason)
          if (@root.is_a?(self.class::IProgressMonitorWithBlocking))
            (@root).set_blocked(reason)
          end
        end
        
        private
        alias_method :initialize__root_info, :initialize
      end }
    }
    
    # Total number of ticks that this progress monitor is permitted to consume
    # from the root.
    attr_accessor :total_parent
    alias_method :attr_total_parent, :total_parent
    undef_method :total_parent
    alias_method :attr_total_parent=, :total_parent=
    undef_method :total_parent=
    
    # Number of ticks that this progress monitor has already reported in the root.
    attr_accessor :used_for_parent
    alias_method :attr_used_for_parent, :used_for_parent
    undef_method :used_for_parent
    alias_method :attr_used_for_parent=, :used_for_parent=
    undef_method :used_for_parent=
    
    # Number of ticks that have been consumed by this instance's children.
    attr_accessor :used_for_children
    alias_method :attr_used_for_children, :used_for_children
    undef_method :used_for_children
    alias_method :attr_used_for_children=, :used_for_children=
    undef_method :used_for_children=
    
    # Number of ticks allocated for this instance's children. This is the total number
    # of ticks that may be passed into worked(int) or newChild(int).
    attr_accessor :total_for_children
    alias_method :attr_total_for_children, :total_for_children
    undef_method :total_for_children
    alias_method :attr_total_for_children=, :total_for_children=
    undef_method :total_for_children=
    
    # Children created by newChild will be completed automatically the next time
    # the parent progress monitor is touched. This points to the last incomplete child
    # created with newChild.
    attr_accessor :last_sub_monitor
    alias_method :attr_last_sub_monitor, :last_sub_monitor
    undef_method :last_sub_monitor
    alias_method :attr_last_sub_monitor=, :last_sub_monitor=
    undef_method :last_sub_monitor=
    
    # Used to communicate with the root of this progress monitor tree
    attr_accessor :root
    alias_method :attr_root, :root
    undef_method :root
    alias_method :attr_root=, :root=
    undef_method :root=
    
    # A bitwise combination of the SUPPRESS_* flags.
    attr_accessor :flags
    alias_method :attr_flags, :flags
    undef_method :flags
    alias_method :attr_flags=, :flags=
    undef_method :flags=
    
    class_module.module_eval {
      # May be passed as a flag to newChild. Indicates that the calls
      # to subTask on the child should be ignored. Without this flag,
      # calling subTask on the child will result in a call to subTask
      # on its parent.
      const_set_lazy(:SUPPRESS_SUBTASK) { 0x1 }
      const_attr_reader  :SUPPRESS_SUBTASK
      
      # May be passed as a flag to newChild. Indicates that strings
      # passed into beginTask should be ignored. If this flag is
      # specified, then the progress monitor instance will accept null
      # as the first argument to beginTask. Without this flag, any
      # string passed to beginTask will result in a call to
      # setTaskName on the parent.
      const_set_lazy(:SUPPRESS_BEGINTASK) { 0x2 }
      const_attr_reader  :SUPPRESS_BEGINTASK
      
      # May be passed as a flag to newChild. Indicates that strings
      # passed into setTaskName should be ignored. If this string
      # is omitted, then a call to setTaskName on the child will
      # result in a call to setTaskName on the parent.
      const_set_lazy(:SUPPRESS_SETTASKNAME) { 0x4 }
      const_attr_reader  :SUPPRESS_SETTASKNAME
      
      # May be passed as a flag to newChild. Indicates that strings
      # passed to setTaskName, subTask, and beginTask should all be ignored.
      const_set_lazy(:SUPPRESS_ALL_LABELS) { SUPPRESS_SETTASKNAME | SUPPRESS_BEGINTASK | SUPPRESS_SUBTASK }
      const_attr_reader  :SUPPRESS_ALL_LABELS
      
      # May be passed as a flag to newChild. Indicates that strings
      # passed to setTaskName, subTask, and beginTask should all be propagated
      # to the parent.
      const_set_lazy(:SUPPRESS_NONE) { 0 }
      const_attr_reader  :SUPPRESS_NONE
    }
    
    typesig { [RootInfo, ::Java::Int, ::Java::Int, ::Java::Int] }
    # Creates a new SubMonitor that will report its progress via
    # the given RootInfo.
    # @param rootInfo the root of this progress monitor tree
    # @param totalWork total work to perform on the given progress monitor
    # @param availableToChildren number of ticks allocated for this instance's children
    # @param flags a bitwise combination of the SUPPRESS_* constants
    def initialize(root_info, total_work, available_to_children, flags)
      @total_parent = 0
      @used_for_parent = 0
      @used_for_children = 0.0
      @total_for_children = 0
      @last_sub_monitor = nil
      @root = nil
      @flags = 0
      @root = root_info
      @total_parent = (total_work > 0) ? total_work : 0
      @total_for_children = available_to_children
      @flags = flags
    end
    
    class_module.module_eval {
      typesig { [IProgressMonitor] }
      # <p>Converts an unknown (possibly null) IProgressMonitor into a SubMonitor. It is
      # not necessary to call done() on the result, but the caller is responsible for calling
      # done() on the argument. Calls beginTask on the argument.</p>
      # 
      # <p>This method should generally be called at the beginning of a method that accepts
      # an IProgressMonitor in order to convert the IProgressMonitor into a SubMonitor.</p>
      # 
      # @param monitor monitor to convert to a SubMonitor instance or null. Treats null
      # as a new instance of <code>NullProgressMonitor</code>.
      # @return a SubMonitor instance that adapts the argument
      def convert(monitor)
        return convert(monitor, "", 0) # $NON-NLS-1$
      end
      
      typesig { [IProgressMonitor, ::Java::Int] }
      # <p>Converts an unknown (possibly null) IProgressMonitor into a SubMonitor allocated
      # with the given number of ticks. It is not necessary to call done() on the result,
      # but the caller is responsible for calling done() on the argument. Calls beginTask
      # on the argument.</p>
      # 
      # <p>This method should generally be called at the beginning of a method that accepts
      # an IProgressMonitor in order to convert the IProgressMonitor into a SubMonitor.</p>
      # 
      # @param monitor monitor to convert to a SubMonitor instance or null. Treats null
      # as a new instance of <code>NullProgressMonitor</code>.
      # @param work number of ticks that will be available in the resulting monitor
      # @return a SubMonitor instance that adapts the argument
      def convert(monitor, work)
        return convert(monitor, "", work) # $NON-NLS-1$
      end
      
      typesig { [IProgressMonitor, String, ::Java::Int] }
      # <p>Converts an unknown (possibly null) IProgressMonitor into a SubMonitor allocated
      # with the given number of ticks. It is not necessary to call done() on the result,
      # but the caller is responsible for calling done() on the argument. Calls beginTask
      # on the argument.</p>
      # 
      # <p>This method should generally be called at the beginning of a method that accepts
      # an IProgressMonitor in order to convert the IProgressMonitor into a SubMonitor.</p>
      # 
      # @param monitor to convert into a SubMonitor instance or null. If given a null argument,
      # the resulting SubMonitor will not report its progress anywhere.
      # @param taskName user readable name to pass to monitor.beginTask. Never null.
      # @param work initial number of ticks to allocate for children of the SubMonitor
      # @return a new SubMonitor instance that is a child of the given monitor
      def convert(monitor, task_name, work)
        if ((monitor).nil?)
          monitor = NullProgressMonitor.new
        end
        # Optimization: if the given monitor already a SubMonitor, no conversion is necessary
        if (monitor.is_a?(SubMonitor))
          monitor.begin_task(task_name, work)
          return monitor
        end
        monitor.begin_task(task_name, MINIMUM_RESOLUTION)
        return SubMonitor.new(RootInfo.new(monitor), MINIMUM_RESOLUTION, work, SUPPRESS_NONE)
      end
    }
    
    typesig { [::Java::Int] }
    # <p>Sets the work remaining for this SubMonitor instance. This is the total number
    # of ticks that may be reported by all subsequent calls to worked(int), newChild(int), etc.
    # This may be called many times for the same SubMonitor instance. When this method
    # is called, the remaining space on the progress monitor is redistributed into the given
    # number of ticks.</p>
    # 
    # <p>It doesn't matter how much progress has already been reported with this SubMonitor
    # instance. If you call setWorkRemaining(100), you will be able to report 100 more ticks of
    # work before the progress meter reaches 100%.</p>
    # 
    # @param workRemaining total number of remaining ticks
    # @return the receiver
    def set_work_remaining(work_remaining)
      # Ensure we don't try to allocate negative ticks
      work_remaining = Math.max(0, work_remaining)
      # Ensure we don't cause division by zero
      if (@total_for_children > 0 && @total_parent > @used_for_parent)
        # Note: We want the following value to remain invariant after this method returns
        remain_for_parent = @total_parent * (1.0 - (@used_for_children / @total_for_children))
        @used_for_children = (work_remaining * (1.0 - remain_for_parent / (@total_parent - @used_for_parent)))
      else
        @used_for_children = 0.0
      end
      @total_parent = @total_parent - @used_for_parent
      @used_for_parent = 0
      @total_for_children = work_remaining
      return self
    end
    
    typesig { [::Java::Double] }
    # Consumes the given number of child ticks, given as a double. Must only
    # be called if the monitor is in floating-point mode.
    # 
    # @param ticks the number of ticks to consume
    # @return ticks the number of ticks to be consumed from parent
    def consume(ticks)
      if ((@total_parent).equal?(0) || (@total_for_children).equal?(0))
        # this monitor has no available work to report
        return 0
      end
      @used_for_children += ticks
      if (@used_for_children > @total_for_children)
        @used_for_children = @total_for_children
      else
        if (@used_for_children < 0.0)
          @used_for_children = 0.0
        end
      end
      parent_position = RJava.cast_to_int((@total_parent * @used_for_children / @total_for_children))
      delta = parent_position - @used_for_parent
      @used_for_parent = parent_position
      return delta
    end
    
    typesig { [] }
    # (non-Javadoc)
    # @see org.eclipse.core.runtime.IProgressMonitor#isCanceled()
    def is_canceled
      return @root.is_canceled
    end
    
    typesig { [String] }
    # (non-Javadoc)
    # @see org.eclipse.core.runtime.IProgressMonitor#setTaskName(java.lang.String)
    def set_task_name(name)
      if (((@flags & SUPPRESS_SETTASKNAME)).equal?(0))
        @root.set_task_name(name)
      end
    end
    
    typesig { [String, ::Java::Int] }
    # Starts a new main task. The string argument is ignored
    # if and only if the SUPPRESS_BEGINTASK flag has been set on this SubMonitor
    # instance.
    # 
    # <p>This method is equivalent calling setWorkRemaining(...) on the receiver. Unless
    # the SUPPRESS_BEGINTASK flag is set, this will also be equivalent to calling
    # setTaskName(...) on the parent.</p>
    # 
    # @param name new main task name
    # @param totalWork number of ticks to allocate
    # 
    # @see org.eclipse.core.runtime.IProgressMonitor#beginTask(java.lang.String, int)
    def begin_task(name, total_work)
      if (((@flags & SUPPRESS_BEGINTASK)).equal?(0) && !(name).nil?)
        @root.set_task_name(name)
      end
      set_work_remaining(total_work)
    end
    
    typesig { [] }
    # (non-Javadoc)
    # @see org.eclipse.core.runtime.IProgressMonitor#done()
    def done
      cleanup_active_child
      delta = @total_parent - @used_for_parent
      if (delta > 0)
        @root.worked(delta)
      end
      @total_parent = 0
      @used_for_parent = 0
      @total_for_children = 0
      @used_for_children = 0.0
    end
    
    typesig { [::Java::Double] }
    # (non-Javadoc)
    # @see org.eclipse.core.runtime.IProgressMonitor#internalWorked(double)
    def internal_worked(work)
      cleanup_active_child
      delta = consume((work > 0.0) ? work : 0.0)
      if (!(delta).equal?(0))
        @root.worked(delta)
      end
    end
    
    typesig { [String] }
    # (non-Javadoc)
    # @see org.eclipse.core.runtime.IProgressMonitor#subTask(java.lang.String)
    def sub_task(name)
      if (((@flags & SUPPRESS_SUBTASK)).equal?(0))
        @root.sub_task(name)
      end
    end
    
    typesig { [::Java::Int] }
    # (non-Javadoc)
    # @see org.eclipse.core.runtime.IProgressMonitor#worked(int)
    def worked(work)
      internal_worked(work)
    end
    
    typesig { [::Java::Boolean] }
    # (non-Javadoc)
    # @see org.eclipse.core.runtime.IProgressMonitor#setCanceled(boolean)
    def set_canceled(b)
      @root.set_canceled(b)
    end
    
    typesig { [::Java::Int] }
    # <p>Creates a sub progress monitor that will consume the given number of ticks from the
    # receiver. It is not necessary to call <code>beginTask</code> or <code>done</code> on the
    # result. However, the resulting progress monitor will not report any work after the first
    # call to done() or before ticks are allocated. Ticks may be allocated by calling beginTask
    # or setWorkRemaining.</p>
    # 
    # <p>Each SubMonitor only has one active child at a time. Each time newChild() is called, the
    # result becomes the new active child and any unused progress from the previously-active child is
    # consumed.</p>
    # 
    # <p>This is property makes it unnecessary to call done() on a SubMonitor instance, since child
    # monitors are automatically cleaned up the next time the parent is touched.</p>
    # 
    # <code><pre>
    # ////////////////////////////////////////////////////////////////////////////
    # // Example 1: Typical usage of newChild
    # void myMethod(IProgressMonitor parent) {
    # SubMonitor progress = SubMonitor.convert(parent, 100);
    # doSomething(progress.newChild(50));
    # doSomethingElse(progress.newChild(50));
    # }
    # 
    # ////////////////////////////////////////////////////////////////////////////
    # // Example 2: Demonstrates the function of active children. Creating children
    # // is sufficient to smoothly report progress, even if worked(...) and done()
    # // are never called.
    # void myMethod(IProgressMonitor parent) {
    # SubMonitor progress = SubMonitor.convert(parent, 100);
    # 
    # for (int i = 0; i < 100; i++) {
    # // Creating the next child monitor will clean up the previous one,
    # // causing progress to be reported smoothly even if we don't do anything
    # // with the monitors we create
    # progress.newChild(1);
    # }
    # }
    # 
    # ////////////////////////////////////////////////////////////////////////////
    # // Example 3: Demonstrates a common anti-pattern
    # void wrongMethod(IProgressMonitor parent) {
    # SubMonitor progress = SubMonitor.convert(parent, 100);
    # 
    # // WRONG WAY: Won't have the intended effect, as only one of these progress
    # // monitors may be active at a time and the other will report no progress.
    # callMethod(progress.newChild(50), computeValue(progress.newChild(50)));
    # }
    # 
    # void rightMethod(IProgressMonitor parent) {
    # SubMonitor progress = SubMonitor.convert(parent, 100);
    # 
    # // RIGHT WAY: Break up method calls so that only one SubMonitor is in use at a time.
    # Object someValue = computeValue(progress.newChild(50));
    # callMethod(progress.newChild(50), someValue);
    # }
    # </pre></code>
    # 
    # @param totalWork number of ticks to consume from the receiver
    # @return new sub progress monitor that may be used in place of a new SubMonitor
    def new_child(total_work)
      return new_child(total_work, SUPPRESS_BEGINTASK)
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # <p>Creates a sub progress monitor that will consume the given number of ticks from the
    # receiver. It is not necessary to call <code>beginTask</code> or <code>done</code> on the
    # result. However, the resulting progress monitor will not report any work after the first
    # call to done() or before ticks are allocated. Ticks may be allocated by calling beginTask
    # or setWorkRemaining.</p>
    # 
    # <p>Each SubMonitor only has one active child at a time. Each time newChild() is called, the
    # result becomes the new active child and any unused progress from the previously-active child is
    # consumed.</p>
    # 
    # <p>This is property makes it unnecessary to call done() on a SubMonitor instance, since child
    # monitors are automatically cleaned up the next time the parent is touched.</p>
    # 
    # <code><pre>
    # ////////////////////////////////////////////////////////////////////////////
    # // Example 1: Typical usage of newChild
    # void myMethod(IProgressMonitor parent) {
    # SubMonitor progress = SubMonitor.convert(parent, 100);
    # doSomething(progress.newChild(50));
    # doSomethingElse(progress.newChild(50));
    # }
    # 
    # ////////////////////////////////////////////////////////////////////////////
    # // Example 2: Demonstrates the function of active children. Creating children
    # // is sufficient to smoothly report progress, even if worked(...) and done()
    # // are never called.
    # void myMethod(IProgressMonitor parent) {
    # SubMonitor progress = SubMonitor.convert(parent, 100);
    # 
    # for (int i = 0; i < 100; i++) {
    # // Creating the next child monitor will clean up the previous one,
    # // causing progress to be reported smoothly even if we don't do anything
    # // with the monitors we create
    # progress.newChild(1);
    # }
    # }
    # 
    # ////////////////////////////////////////////////////////////////////////////
    # // Example 3: Demonstrates a common anti-pattern
    # void wrongMethod(IProgressMonitor parent) {
    # SubMonitor progress = SubMonitor.convert(parent, 100);
    # 
    # // WRONG WAY: Won't have the intended effect, as only one of these progress
    # // monitors may be active at a time and the other will report no progress.
    # callMethod(progress.newChild(50), computeValue(progress.newChild(50)));
    # }
    # 
    # void rightMethod(IProgressMonitor parent) {
    # SubMonitor progress = SubMonitor.convert(parent, 100);
    # 
    # // RIGHT WAY: Break up method calls so that only one SubMonitor is in use at a time.
    # Object someValue = computeValue(progress.newChild(50));
    # callMethod(progress.newChild(50), someValue);
    # }
    # </pre></code>
    # 
    # @param totalWork number of ticks to consume from the receiver
    # @return new sub progress monitor that may be used in place of a new SubMonitor
    def new_child(total_work, suppress_flags)
      total_work_double = (total_work > 0) ? total_work : 0.0
      total_work_double = Math.min(total_work_double, @total_for_children - @used_for_children)
      cleanup_active_child
      # Compute the flags for the child. We want the net effect to be as though the child is
      # delegating to its parent, even though it is actually talking directly to the root.
      # This means that we need to compute the flags such that - even if a label isn't
      # suppressed by the child - if that same label would have been suppressed when the
      # child delegated to its parent, the child must explicitly suppress the label.
      child_flags = SUPPRESS_NONE
      if (!((@flags & SUPPRESS_SETTASKNAME)).equal?(0))
        # If the parent was ignoring labels passed to setTaskName, then the child will ignore
        # labels passed to either beginTask or setTaskName - since both delegate to setTaskName
        # on the parent
        child_flags |= SUPPRESS_SETTASKNAME | SUPPRESS_BEGINTASK
      end
      if (!((@flags & SUPPRESS_SUBTASK)).equal?(0))
        # If the parent was suppressing labels passed to subTask, so will the child.
        child_flags |= SUPPRESS_SUBTASK
      end
      # Note: the SUPPRESS_BEGINTASK flag does not affect the child since there
      # is no method on the child that would delegate to beginTask on the parent.
      child_flags |= suppress_flags
      result = SubMonitor.new(@root, consume(total_work_double), RJava.cast_to_int(total_work_double), child_flags)
      @last_sub_monitor = result
      return result
    end
    
    typesig { [] }
    def cleanup_active_child
      if ((@last_sub_monitor).nil?)
        return
      end
      child = @last_sub_monitor
      @last_sub_monitor = nil
      child.done
    end
    
    typesig { [] }
    # (non-Javadoc)
    # @see org.eclipse.core.runtime.IProgressMonitorWithBlocking#clearBlocked()
    def clear_blocked
      @root.clear_blocked
    end
    
    typesig { [IStatus] }
    # (non-Javadoc)
    # @see org.eclipse.core.runtime.IProgressMonitorWithBlocking#setBlocked(org.eclipse.core.runtime.IStatus)
    def set_blocked(reason)
      @root.set_blocked(reason)
    end
    
    class_module.module_eval {
      typesig { [Object, Object] }
      def eq(o1, o2)
        if ((o1).nil?)
          return ((o2).nil?)
        end
        if ((o2).nil?)
          return false
        end
        return (o1 == o2)
      end
    }
    
    private
    alias_method :initialize__sub_monitor, :initialize
  end
  
end
