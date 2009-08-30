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
  module NullProgressMonitorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Runtime
    }
  end
  
  # A default progress monitor implementation suitable for
  # subclassing.
  # <p>
  # This implementation supports cancelation. The default
  # implementations of the other methods do nothing.
  # </p><p>
  # This class can be used without OSGi running.
  # </p>
  class NullProgressMonitor 
    include_class_members NullProgressMonitorImports
    include IProgressMonitor
    
    # Indicates whether cancel has been requested.
    attr_accessor :cancelled
    alias_method :attr_cancelled, :cancelled
    undef_method :cancelled
    alias_method :attr_cancelled=, :cancelled=
    undef_method :cancelled=
    
    typesig { [] }
    # Constructs a new progress monitor.
    def initialize
      @cancelled = false
    end
    
    typesig { [String, ::Java::Int] }
    # This implementation does nothing.
    # Subclasses may override this method to do interesting
    # processing when a task begins.
    # 
    # @see IProgressMonitor#beginTask(String, int)
    def begin_task(name, total_work)
      # do nothing
    end
    
    typesig { [] }
    # This implementation does nothing.
    # Subclasses may override this method to do interesting
    # processing when a task is done.
    # 
    # @see IProgressMonitor#done()
    def done
      # do nothing
    end
    
    typesig { [::Java::Double] }
    # This implementation does nothing.
    # Subclasses may override this method.
    # 
    # @see IProgressMonitor#internalWorked(double)
    def internal_worked(work)
      # do nothing
    end
    
    typesig { [] }
    # This implementation returns the value of the internal
    # state variable set by <code>setCanceled</code>.
    # Subclasses which override this method should
    # override <code>setCanceled</code> as well.
    # 
    # @see IProgressMonitor#isCanceled()
    # @see IProgressMonitor#setCanceled(boolean)
    def is_canceled
      return @cancelled
    end
    
    typesig { [::Java::Boolean] }
    # This implementation sets the value of an internal state variable.
    # Subclasses which override this method should override
    # <code>isCanceled</code> as well.
    # 
    # @see IProgressMonitor#isCanceled()
    # @see IProgressMonitor#setCanceled(boolean)
    def set_canceled(cancelled)
      @cancelled = cancelled
    end
    
    typesig { [String] }
    # This implementation does nothing.
    # Subclasses may override this method to do something
    # with the name of the task.
    # 
    # @see IProgressMonitor#setTaskName(String)
    def set_task_name(name)
      # do nothing
    end
    
    typesig { [String] }
    # This implementation does nothing.
    # Subclasses may override this method to do interesting
    # processing when a subtask begins.
    # 
    # @see IProgressMonitor#subTask(String)
    def sub_task(name)
      # do nothing
    end
    
    typesig { [::Java::Int] }
    # This implementation does nothing.
    # Subclasses may override this method to do interesting
    # processing when some work has been completed.
    # 
    # @see IProgressMonitor#worked(int)
    def worked(work)
      # do nothing
    end
    
    private
    alias_method :initialize__null_progress_monitor, :initialize
  end
  
end
