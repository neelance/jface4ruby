require "rjava"

# Copyright (c) 2000, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Core::Runtime
  module ProgressMonitorWrapperImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Runtime
    }
  end
  
  # An abstract wrapper around a progress monitor which,
  # unless overridden, forwards <code>IProgressMonitor</code>
  # and <code>IProgressMonitorWithBlocking</code> methods to the wrapped progress monitor.
  # <p>
  # This class can be used without OSGi running.
  # </p><p>
  # Clients may subclass.
  # </p>
  class ProgressMonitorWrapper 
    include_class_members ProgressMonitorWrapperImports
    include IProgressMonitor
    include IProgressMonitorWithBlocking
    
    # The wrapped progress monitor.
    attr_accessor :progress_monitor
    alias_method :attr_progress_monitor, :progress_monitor
    undef_method :progress_monitor
    alias_method :attr_progress_monitor=, :progress_monitor=
    undef_method :progress_monitor=
    
    typesig { [IProgressMonitor] }
    # Creates a new wrapper around the given monitor.
    # 
    # @param monitor the progress monitor to forward to
    def initialize(monitor)
      @progress_monitor = nil
      Assert.is_not_null(monitor)
      @progress_monitor = monitor
    end
    
    typesig { [String, ::Java::Int] }
    # This implementation of a <code>IProgressMonitor</code>
    # method forwards to the wrapped progress monitor.
    # Clients may override this method to do additional
    # processing.
    # 
    # @see IProgressMonitor#beginTask(String, int)
    def begin_task(name, total_work)
      @progress_monitor.begin_task(name, total_work)
    end
    
    typesig { [] }
    # This implementation of a <code>IProgressMonitorWithBlocking</code>
    # method forwards to the wrapped progress monitor.
    # Clients may override this method to do additional
    # processing.
    # 
    # @see IProgressMonitorWithBlocking#clearBlocked()
    # @since 3.0
    def clear_blocked
      if (@progress_monitor.is_a?(IProgressMonitorWithBlocking))
        (@progress_monitor).clear_blocked
      end
    end
    
    typesig { [] }
    # This implementation of a <code>IProgressMonitor</code>
    # method forwards to the wrapped progress monitor.
    # Clients may override this method to do additional
    # processing.
    # 
    # @see IProgressMonitor#done()
    def done
      @progress_monitor.done
    end
    
    typesig { [] }
    # Returns the wrapped progress monitor.
    # 
    # @return the wrapped progress monitor
    def get_wrapped_progress_monitor
      return @progress_monitor
    end
    
    typesig { [::Java::Double] }
    # This implementation of a <code>IProgressMonitor</code>
    # method forwards to the wrapped progress monitor.
    # Clients may override this method to do additional
    # processing.
    # 
    # @see IProgressMonitor#internalWorked(double)
    def internal_worked(work)
      @progress_monitor.internal_worked(work)
    end
    
    typesig { [] }
    # This implementation of a <code>IProgressMonitor</code>
    # method forwards to the wrapped progress monitor.
    # Clients may override this method to do additional
    # processing.
    # 
    # @see IProgressMonitor#isCanceled()
    def is_canceled
      return @progress_monitor.is_canceled
    end
    
    typesig { [IStatus] }
    # This implementation of a <code>IProgressMonitorWithBlocking</code>
    # method forwards to the wrapped progress monitor.
    # Clients may override this method to do additional
    # processing.
    # 
    # @see IProgressMonitorWithBlocking#setBlocked(IStatus)
    # @since 3.0
    def set_blocked(reason)
      if (@progress_monitor.is_a?(IProgressMonitorWithBlocking))
        (@progress_monitor).set_blocked(reason)
      end
    end
    
    typesig { [::Java::Boolean] }
    # This implementation of a <code>IProgressMonitor</code>
    # method forwards to the wrapped progress monitor.
    # Clients may override this method to do additional
    # processing.
    # 
    # @see IProgressMonitor#setCanceled(boolean)
    def set_canceled(b)
      @progress_monitor.set_canceled(b)
    end
    
    typesig { [String] }
    # This implementation of a <code>IProgressMonitor</code>
    # method forwards to the wrapped progress monitor.
    # Clients may override this method to do additional
    # processing.
    # 
    # @see IProgressMonitor#setTaskName(String)
    def set_task_name(name)
      @progress_monitor.set_task_name(name)
    end
    
    typesig { [String] }
    # This implementation of a <code>IProgressMonitor</code>
    # method forwards to the wrapped progress monitor.
    # Clients may override this method to do additional
    # processing.
    # 
    # @see IProgressMonitor#subTask(String)
    def sub_task(name)
      @progress_monitor.sub_task(name)
    end
    
    typesig { [::Java::Int] }
    # This implementation of a <code>IProgressMonitor</code>
    # method forwards to the wrapped progress monitor.
    # Clients may override this method to do additional
    # processing.
    # 
    # @see IProgressMonitor#worked(int)
    def worked(work)
      @progress_monitor.worked(work)
    end
    
    private
    alias_method :initialize__progress_monitor_wrapper, :initialize
  end
  
end
