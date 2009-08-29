require "rjava"

# Copyright (c) 2004, 2005 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Viewers::Deferred
  module FastProgressReporterImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers::Deferred
      include_const ::Org::Eclipse::Core::Runtime, :IProgressMonitor
    }
  end
  
  # A more efficient alternative to an IProgressMonitor. In particular, the implementation
  # is designed to make isCanceled() run as efficiently as possible. Currently package-visible
  # because the implementation is incomplete.
  # 
  # @since 3.1
  class FastProgressReporter 
    include_class_members FastProgressReporterImports
    
    attr_accessor :monitor
    alias_method :attr_monitor, :monitor
    undef_method :monitor
    alias_method :attr_monitor=, :monitor=
    undef_method :monitor=
    
    attr_accessor :canceled
    alias_method :attr_canceled, :canceled
    undef_method :canceled
    alias_method :attr_canceled=, :canceled=
    undef_method :canceled=
    
    attr_accessor :cancel_check
    alias_method :attr_cancel_check, :cancel_check
    undef_method :cancel_check
    alias_method :attr_cancel_check=, :cancel_check=
    undef_method :cancel_check=
    
    class_module.module_eval {
      # private String taskName;
      # 
      # private int taskDepth = 0;
      # private int subTaskSize = 1;
      # private int totalWork = 1;
      # private int parentWork = 1;
      # private int monitorUnitsRemaining;
      
      def cancel_check_period
        defined?(@@cancel_check_period) ? @@cancel_check_period : @@cancel_check_period= 40
      end
      alias_method :attr_cancel_check_period, :cancel_check_period
      
      def cancel_check_period=(value)
        @@cancel_check_period = value
      end
      alias_method :attr_cancel_check_period=, :cancel_check_period=
    }
    
    typesig { [] }
    # Constructs a null FastProgressReporter
    def initialize
      @monitor = nil
      @canceled = false
      @cancel_check = 0
    end
    
    typesig { [IProgressMonitor, ::Java::Int] }
    # Constructs a FastProgressReporter that wraps the given progress monitor
    # 
    # @param monitor the monitor to wrap
    # @param totalProgress the total progress to be reported
    def initialize(monitor, total_progress)
      @monitor = nil
      @canceled = false
      @cancel_check = 0
      @monitor = monitor
      # monitorUnitsRemaining = totalProgress;
      @canceled = monitor.is_canceled
    end
    
    typesig { [] }
    # /**
    # * Every call to beginTask must have a corresponding call to endTask, with the
    # * same argument.
    # *
    # * @param totalWork
    # * @since 3.1
    # */
    # public void beginTask(int totalWork) {
    # 
    # if (monitor == null) {
    # return;
    # }
    # 
    # taskDepth++;
    # 
    # if (totalWork == 0) {
    # return;
    # }
    # 
    # this.totalWork *= totalWork;
    # }
    # 
    # public void beginSubTask(int subTaskWork) {
    # subTaskSize *= subTaskWork;
    # }
    # 
    # public void endSubTask(int subTaskWork) {
    # subTaskSize /= subTaskWork;
    # }
    # 
    # public void worked(int amount) {
    # amount *= subTaskSize;
    # 
    # if (amount > totalWork) {
    # amount = totalWork;
    # }
    # 
    # int consumed = monitorUnitsRemaining * amount / totalWork;
    # 
    # if (consumed > 0) {
    # monitor.worked(consumed);
    # monitorUnitsRemaining -= consumed;
    # }
    # totalWork -= amount;
    # }
    # 
    # public void endTask(int totalWork) {
    # taskDepth--;
    # 
    # if (taskDepth == 0) {
    # if (monitor != null && monitorUnitsRemaining > 0) {
    # monitor.worked(monitorUnitsRemaining);
    # }
    # }
    # 
    # if (totalWork == 0) {
    # return;
    # }
    # 
    # this.totalWork /= totalWork;
    # 
    # }
    # 
    # Return whether the progress monitor has been canceled.
    # 
    # @return <code>true</code> if the monitor has been cancelled, <code>false</code> otherwise.
    def is_canceled
      if ((@monitor).nil?)
        return @canceled
      end
      @cancel_check += 1
      if (@cancel_check > self.attr_cancel_check_period)
        @canceled = @monitor.is_canceled
        @cancel_check = 0
      end
      return @canceled
    end
    
    typesig { [] }
    # Cancel the progress monitor.
    def cancel
      @canceled = true
      if ((@monitor).nil?)
        return
      end
      @monitor.set_canceled(true)
    end
    
    private
    alias_method :initialize__fast_progress_reporter, :initialize
  end
  
end
