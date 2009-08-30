require "rjava"

# Copyright (c) 2000, 2007 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Core::Runtime
  module SubProgressMonitorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Runtime
    }
  end
  
  # For new implementations consider using {@link SubMonitor}.
  # 
  # A progress monitor that uses a given amount of work ticks
  # from a parent monitor. It can be used as follows:
  # <pre>
  # try {
  # pm.beginTask("Main Task", 100);
  # doSomeWork(pm, 30);
  # SubProgressMonitor subMonitor= new SubProgressMonitor(pm, 40);
  # try {
  # subMonitor.beginTask("", 300);
  # doSomeWork(subMonitor, 300);
  # } finally {
  # subMonitor.done();
  # }
  # doSomeWork(pm, 30);
  # } finally {
  # pm.done();
  # }
  # </pre>
  # <p>
  # This class can be used without OSGi running.
  # </p><p>
  # This class may be instantiated or subclassed by clients.
  # </p>
  # 
  # @see SubMonitor
  class SubProgressMonitor < SubProgressMonitorImports.const_get :ProgressMonitorWrapper
    include_class_members SubProgressMonitorImports
    
    class_module.module_eval {
      # Style constant indicating that calls to <code>subTask</code>
      # should not have any effect.
      # 
      # @see #SubProgressMonitor(IProgressMonitor,int,int)
      const_set_lazy(:SUPPRESS_SUBTASK_LABEL) { 1 << 1 }
      const_attr_reader  :SUPPRESS_SUBTASK_LABEL
      
      # Style constant indicating that the main task label
      # should be prepended to the subtask label.
      # 
      # @see #SubProgressMonitor(IProgressMonitor,int,int)
      const_set_lazy(:PREPEND_MAIN_LABEL_TO_SUBTASK) { 1 << 2 }
      const_attr_reader  :PREPEND_MAIN_LABEL_TO_SUBTASK
    }
    
    attr_accessor :parent_ticks
    alias_method :attr_parent_ticks, :parent_ticks
    undef_method :parent_ticks
    alias_method :attr_parent_ticks=, :parent_ticks=
    undef_method :parent_ticks=
    
    attr_accessor :sent_to_parent
    alias_method :attr_sent_to_parent, :sent_to_parent
    undef_method :sent_to_parent
    alias_method :attr_sent_to_parent=, :sent_to_parent=
    undef_method :sent_to_parent=
    
    attr_accessor :scale
    alias_method :attr_scale, :scale
    undef_method :scale
    alias_method :attr_scale=, :scale=
    undef_method :scale=
    
    attr_accessor :nested_begin_tasks
    alias_method :attr_nested_begin_tasks, :nested_begin_tasks
    undef_method :nested_begin_tasks
    alias_method :attr_nested_begin_tasks=, :nested_begin_tasks=
    undef_method :nested_begin_tasks=
    
    attr_accessor :used_up
    alias_method :attr_used_up, :used_up
    undef_method :used_up
    alias_method :attr_used_up=, :used_up=
    undef_method :used_up=
    
    attr_accessor :has_sub_task
    alias_method :attr_has_sub_task, :has_sub_task
    undef_method :has_sub_task
    alias_method :attr_has_sub_task=, :has_sub_task=
    undef_method :has_sub_task=
    
    attr_accessor :style
    alias_method :attr_style, :style
    undef_method :style
    alias_method :attr_style=, :style=
    undef_method :style=
    
    attr_accessor :main_task_label
    alias_method :attr_main_task_label, :main_task_label
    undef_method :main_task_label
    alias_method :attr_main_task_label=, :main_task_label=
    undef_method :main_task_label=
    
    typesig { [IProgressMonitor, ::Java::Int] }
    # Creates a new sub-progress monitor for the given monitor. The sub
    # progress monitor uses the given number of work ticks from its
    # parent monitor.
    # 
    # @param monitor the parent progress monitor
    # @param ticks the number of work ticks allocated from the
    # parent monitor
    def initialize(monitor, ticks)
      initialize__sub_progress_monitor(monitor, ticks, 0)
    end
    
    typesig { [IProgressMonitor, ::Java::Int, ::Java::Int] }
    # Creates a new sub-progress monitor for the given monitor. The sub
    # progress monitor uses the given number of work ticks from its
    # parent monitor.
    # 
    # @param monitor the parent progress monitor
    # @param ticks the number of work ticks allocated from the
    # parent monitor
    # @param style one of
    # <ul>
    # <li> <code>SUPPRESS_SUBTASK_LABEL</code> </li>
    # <li> <code>PREPEND_MAIN_LABEL_TO_SUBTASK</code> </li>
    # </ul>
    # @see #SUPPRESS_SUBTASK_LABEL
    # @see #PREPEND_MAIN_LABEL_TO_SUBTASK
    def initialize(monitor, ticks, style)
      @parent_ticks = 0
      @sent_to_parent = 0.0
      @scale = 0.0
      @nested_begin_tasks = 0
      @used_up = false
      @has_sub_task = false
      @style = 0
      @main_task_label = nil
      super(monitor)
      @parent_ticks = 0
      @sent_to_parent = 0.0
      @scale = 0.0
      @nested_begin_tasks = 0
      @used_up = false
      @has_sub_task = false
      @parent_ticks = (ticks > 0) ? ticks : 0
      @style = style
    end
    
    typesig { [String, ::Java::Int] }
    # (Intentionally not javadoc'd)
    # Implements the method <code>IProgressMonitor.beginTask</code>.
    # 
    # Starts a new main task. Since this progress monitor is a sub
    # progress monitor, the given name will NOT be used to update
    # the progress bar's main task label. That means the given
    # string will be ignored. If style <code>PREPEND_MAIN_LABEL_TO_SUBTASK
    # <code> is specified, then the given string will be prepended to
    # every string passed to <code>subTask(String)</code>.
    def begin_task(name, total_work)
      @nested_begin_tasks += 1
      # Ignore nested begin task calls.
      if (@nested_begin_tasks > 1)
        return
      end
      # be safe:  if the argument would cause math errors (zero or
      # negative), just use 0 as the scale.  This disables progress for
      # this submonitor.
      @scale = total_work <= 0 ? 0 : (@parent_ticks).to_f / (total_work).to_f
      if (!((@style & PREPEND_MAIN_LABEL_TO_SUBTASK)).equal?(0))
        @main_task_label = name
      end
    end
    
    typesig { [] }
    # (Intentionally not javadoc'd)
    # Implements the method <code>IProgressMonitor.done</code>.
    def done
      # Ignore if more done calls than beginTask calls or if we are still
      # in some nested beginTasks
      if ((@nested_begin_tasks).equal?(0) || (@nested_begin_tasks -= 1) > 0)
        return
      end
      # Send any remaining ticks and clear out the subtask text
      remaining = @parent_ticks - @sent_to_parent
      if (remaining > 0)
        ProgressMonitorWrapper.instance_method(:internal_worked).bind(self).call(remaining)
      end
      # clear the sub task if there was one
      if (@has_sub_task)
        sub_task("")
      end # $NON-NLS-1$
      @sent_to_parent = 0
    end
    
    typesig { [::Java::Double] }
    # (Intentionally not javadoc'd)
    # Implements the internal method <code>IProgressMonitor.internalWorked</code>.
    def internal_worked(work)
      if (@used_up || !(@nested_begin_tasks).equal?(1))
        return
      end
      real_work = (work > 0.0) ? @scale * work : 0.0
      super(real_work)
      @sent_to_parent += real_work
      if (@sent_to_parent >= @parent_ticks)
        @used_up = true
      end
    end
    
    typesig { [String] }
    # (Intentionally not javadoc'd)
    # Implements the method <code>IProgressMonitor.subTask</code>.
    def sub_task(name)
      if (!((@style & SUPPRESS_SUBTASK_LABEL)).equal?(0))
        return
      end
      @has_sub_task = true
      label = name
      if (!((@style & PREPEND_MAIN_LABEL_TO_SUBTASK)).equal?(0) && !(@main_task_label).nil? && @main_task_label.length > 0)
        label = @main_task_label + RJava.cast_to_string(Character.new(?\s.ord)) + label
      end
      super(label)
    end
    
    typesig { [::Java::Int] }
    # (Intentionally not javadoc'd)
    # Implements the method <code>IProgressMonitor.worked</code>.
    def worked(work)
      internal_worked(work)
    end
    
    private
    alias_method :initialize__sub_progress_monitor, :initialize
  end
  
end
