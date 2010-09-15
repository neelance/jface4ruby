require "rjava"

# Copyright (c) 2005, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Core::Commands::Operations
  module DefaultOperationHistoryImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Commands::Operations
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :Collections
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :Map
      include_const ::Org::Eclipse::Core::Commands, :ExecutionException
      include_const ::Org::Eclipse::Core::Commands::Util, :Tracing
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Core::Runtime, :IAdaptable
      include_const ::Org::Eclipse::Core::Runtime, :IProgressMonitor
      include_const ::Org::Eclipse::Core::Runtime, :ISafeRunnable
      include_const ::Org::Eclipse::Core::Runtime, :IStatus
      include_const ::Org::Eclipse::Core::Runtime, :ListenerList
      include_const ::Org::Eclipse::Core::Runtime, :OperationCanceledException
      include_const ::Org::Eclipse::Core::Runtime, :SafeRunner
      include_const ::Org::Eclipse::Core::Runtime, :Status
    }
  end
  
  # <p>
  # A base implementation of IOperationHistory that implements a linear undo and
  # redo model . The most recently added operation is available for undo, and the
  # most recently undone operation is available for redo.
  # </p>
  # <p>
  # If the operation eligible for undo is not in a state where it can be undone,
  # then no undo is available. No other operations are considered. Likewise, if
  # the operation available for redo cannot be redone, then no redo is available.
  # </p>
  # <p>
  # Implementations for the direct undo and redo of a specified operation are
  # available. If a strict linear undo is to be enforced, than an
  # IOperationApprover should be installed that prevents undo and redo of any
  # operation that is not the most recently undone or redone operation in all of
  # its undo contexts.
  # </p>
  # <p>
  # The data structures used by the DefaultOperationHistory are synchronized, and
  # entry points that modify the undo and redo history concurrently are also
  # synchronized. This means that the DefaultOperationHistory is relatively
  # "thread-friendly" in its implementation. Outbound notifications or operation
  # approval requests will occur on the thread that initiated the request.
  # Clients may use DefaultOperationHistory API from any thread; however,
  # listeners or operation approvers that receive notifications from the
  # DefaultOperationHistory must be prepared to receive these notifications from
  # a background thread. Any UI access occurring inside these notifications must
  # be properly synchronized using the techniques specified by the client's
  # widget library.
  # </p>
  # 
  # <p>
  # This implementation is not intended to be subclassed.
  # </p>
  # 
  # @see org.eclipse.core.commands.operations.IOperationHistory
  # @see org.eclipse.core.commands.operations.IOperationApprover
  # 
  # @since 3.1
  class DefaultOperationHistory 
    include_class_members DefaultOperationHistoryImports
    include IOperationHistory
    
    class_module.module_eval {
      # This flag can be set to <code>true</code> if the history should print
      # information to <code>System.out</code> whenever notifications about
      # changes to the history occur. This flag should be used for debug purposes
      # only.
      
      def debug_operation_history_notification
        defined?(@@debug_operation_history_notification) ? @@debug_operation_history_notification : @@debug_operation_history_notification= false
      end
      alias_method :attr_debug_operation_history_notification, :debug_operation_history_notification
      
      def debug_operation_history_notification=(value)
        @@debug_operation_history_notification = value
      end
      alias_method :attr_debug_operation_history_notification=, :debug_operation_history_notification=
      
      # This flag can be set to <code>true</code> if the history should print
      # information to <code>System.out</code> whenever an unexpected condition
      # arises. This flag should be used for debug purposes only.
      
      def debug_operation_history_unexpected
        defined?(@@debug_operation_history_unexpected) ? @@debug_operation_history_unexpected : @@debug_operation_history_unexpected= false
      end
      alias_method :attr_debug_operation_history_unexpected, :debug_operation_history_unexpected
      
      def debug_operation_history_unexpected=(value)
        @@debug_operation_history_unexpected = value
      end
      alias_method :attr_debug_operation_history_unexpected=, :debug_operation_history_unexpected=
      
      # This flag can be set to <code>true</code> if the history should print
      # information to <code>System.out</code> whenever an undo context is
      # disposed. This flag should be used for debug purposes only.
      
      def debug_operation_history_dispose
        defined?(@@debug_operation_history_dispose) ? @@debug_operation_history_dispose : @@debug_operation_history_dispose= false
      end
      alias_method :attr_debug_operation_history_dispose, :debug_operation_history_dispose
      
      def debug_operation_history_dispose=(value)
        @@debug_operation_history_dispose = value
      end
      alias_method :attr_debug_operation_history_dispose=, :debug_operation_history_dispose=
      
      # This flag can be set to <code>true</code> if the history should print
      # information to <code>System.out</code> during the open/close sequence.
      # This flag should be used for debug purposes only.
      
      def debug_operation_history_openoperation
        defined?(@@debug_operation_history_openoperation) ? @@debug_operation_history_openoperation : @@debug_operation_history_openoperation= false
      end
      alias_method :attr_debug_operation_history_openoperation, :debug_operation_history_openoperation
      
      def debug_operation_history_openoperation=(value)
        @@debug_operation_history_openoperation = value
      end
      alias_method :attr_debug_operation_history_openoperation=, :debug_operation_history_openoperation=
      
      # This flag can be set to <code>true</code> if the history should print
      # information to <code>System.out</code> whenever an operation is not
      # approved. This flag should be used for debug purposes only.
      
      def debug_operation_history_approval
        defined?(@@debug_operation_history_approval) ? @@debug_operation_history_approval : @@debug_operation_history_approval= false
      end
      alias_method :attr_debug_operation_history_approval, :debug_operation_history_approval
      
      def debug_operation_history_approval=(value)
        @@debug_operation_history_approval = value
      end
      alias_method :attr_debug_operation_history_approval=, :debug_operation_history_approval=
      
      const_set_lazy(:DEFAULT_LIMIT) { 20 }
      const_attr_reader  :DEFAULT_LIMIT
    }
    
    # the list of {@link IOperationApprover}s
    attr_accessor :approvers
    alias_method :attr_approvers, :approvers
    undef_method :approvers
    alias_method :attr_approvers=, :approvers=
    undef_method :approvers=
    
    # a map of undo limits per context
    attr_accessor :limits
    alias_method :attr_limits, :limits
    undef_method :limits
    alias_method :attr_limits=, :limits=
    undef_method :limits=
    
    # the list of {@link IOperationHistoryListener}s
    attr_accessor :listeners
    alias_method :attr_listeners, :listeners
    undef_method :listeners
    alias_method :attr_listeners=, :listeners=
    undef_method :listeners=
    
    # the list of operations available for redo, LIFO
    attr_accessor :redo_list
    alias_method :attr_redo_list, :redo_list
    undef_method :redo_list
    alias_method :attr_redo_list=, :redo_list=
    undef_method :redo_list=
    
    # the list of operations available for undo, LIFO
    attr_accessor :undo_list
    alias_method :attr_undo_list, :undo_list
    undef_method :undo_list
    alias_method :attr_undo_list=, :undo_list=
    undef_method :undo_list=
    
    # a lock that is used to synchronize access between the undo and redo
    # history
    attr_accessor :undo_redo_history_lock
    alias_method :attr_undo_redo_history_lock, :undo_redo_history_lock
    undef_method :undo_redo_history_lock
    alias_method :attr_undo_redo_history_lock=, :undo_redo_history_lock=
    undef_method :undo_redo_history_lock=
    
    # An operation that is "absorbing" all other operations while it is open.
    # When this is not null, other operations added or executed are added to
    # this composite.
    attr_accessor :open_composite
    alias_method :attr_open_composite, :open_composite
    undef_method :open_composite
    alias_method :attr_open_composite=, :open_composite=
    undef_method :open_composite=
    
    # a lock that is used to synchronize access to the open composite.
    attr_accessor :open_composite_lock
    alias_method :attr_open_composite_lock, :open_composite_lock
    undef_method :open_composite_lock
    alias_method :attr_open_composite_lock=, :open_composite_lock=
    undef_method :open_composite_lock=
    
    typesig { [] }
    # Create an instance of DefaultOperationHistory.
    def initialize
      @approvers = ListenerList.new(ListenerList::IDENTITY)
      @limits = Collections.synchronized_map(HashMap.new)
      @listeners = ListenerList.new(ListenerList::IDENTITY)
      @redo_list = Collections.synchronized_list(ArrayList.new)
      @undo_list = Collections.synchronized_list(ArrayList.new)
      @undo_redo_history_lock = Object.new
      @open_composite = nil
      @open_composite_lock = Object.new
    end
    
    typesig { [IUndoableOperation] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.core.commands.operations.IOperationHistory#add(org.eclipse.core.commands.operations.IUndoableOperation)
    def add(operation)
      Assert.is_not_null(operation)
      # If we are in the middle of executing an open batching operation, and
      # this is not that operation, then we need only add the context of the
      # new operation to the batch. The operation itself is disposed since we
      # will never undo or redo it. We consider it to be triggered by the
      # batching operation and assume that its undo will be triggered by the
      # batching operation undo.
      synchronized((@open_composite_lock)) do
        if (!(@open_composite).nil? && !(@open_composite).equal?(operation))
          @open_composite.add(operation)
          return
        end
      end
      if (check_undo_limit(operation))
        synchronized((@undo_redo_history_lock)) do
          @undo_list.add(operation)
        end
        notify_add(operation)
        # flush redo stack for related contexts
        contexts = operation.get_contexts
        i = 0
        while i < contexts.attr_length
          flush_redo(contexts[i])
          i += 1
        end
      else
        # Dispose the operation since we will not have a reference to it.
        operation.dispose
      end
    end
    
    typesig { [IOperationApprover] }
    # <p>
    # Add the specified approver to the list of operation approvers consulted
    # by the operation history before an undo or redo is allowed to proceed.
    # This method has no effect if the instance being added is already in the
    # list.
    # </p>
    # <p>
    # Operation approvers must be prepared to receive these the operation
    # approval messages from a background thread. Any UI access occurring
    # inside the implementation must be properly synchronized using the
    # techniques specified by the client's widget library.
    # </p>
    # 
    # @param approver
    # the IOperationApprover to be added as an approver.
    def add_operation_approver(approver)
      @approvers.add(approver)
    end
    
    typesig { [IOperationHistoryListener] }
    # <p>
    # Add the specified listener to the list of operation history listeners
    # that are notified about changes in the history or operations that are
    # executed, undone, or redone. This method has no effect if the instance
    # being added is already in the list.
    # </p>
    # <p>
    # Operation history listeners must be prepared to receive notifications
    # from a background thread. Any UI access occurring inside the
    # implementation must be properly synchronized using the techniques
    # specified by the client's widget library.
    # </p>
    # 
    # @param listener
    # the IOperationHistoryListener to be added as a listener.
    # 
    # @see org.eclipse.core.commands.operations.IOperationHistoryListener
    # @see org.eclipse.core.commands.operations.OperationHistoryEvent
    def add_operation_history_listener(listener)
      @listeners.add(listener)
    end
    
    typesig { [IUndoContext] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.core.commands.operations.IOperationHistory#canRedo(org.eclipse.core.commands.operations.IUndoContext)
    def can_redo(context)
      # null context is allowed and passed through
      operation = get_redo_operation(context)
      return (!(operation).nil? && operation.can_redo)
    end
    
    typesig { [IUndoContext] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.core.commands.operations.IOperationHistory#canUndo(org.eclipse.core.commands.operations.IUndoContext)
    def can_undo(context)
      # null context is allowed and passed through
      operation = get_undo_operation(context)
      return (!(operation).nil? && operation.can_undo)
    end
    
    typesig { [IUndoableOperation] }
    # Check the redo limit before adding an operation. In theory the redo limit
    # should never be reached, because the redo items are transferred from the
    # undo history, which has the same limit. The redo history is cleared
    # whenever a new operation is added. We check for completeness since
    # implementations may change over time.
    # 
    # Return a boolean indicating whether the redo should proceed.
    def check_redo_limit(operation)
      contexts = operation.get_contexts
      i = 0
      while i < contexts.attr_length
        limit = get_limit(contexts[i])
        if (limit > 0)
          force_redo_limit(contexts[i], limit - 1)
        else
          # this context has a 0 limit
          operation.remove_context(contexts[i])
        end
        i += 1
      end
      return operation.get_contexts.attr_length > 0
    end
    
    typesig { [IUndoableOperation] }
    # Check the undo limit before adding an operation. Return a boolean
    # indicating whether the undo should proceed.
    def check_undo_limit(operation)
      contexts = operation.get_contexts
      i = 0
      while i < contexts.attr_length
        limit = get_limit(contexts[i])
        if (limit > 0)
          force_undo_limit(contexts[i], limit - 1)
        else
          # this context has a 0 limit
          operation.remove_context(contexts[i])
        end
        i += 1
      end
      return operation.get_contexts.attr_length > 0
    end
    
    typesig { [IUndoContext, ::Java::Boolean, ::Java::Boolean, ::Java::Boolean] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.core.commands.operations.IOperationHistory#dispose(org.eclipse.core.commands.operations.IUndoContext,
    # boolean, boolean, boolean)
    def dispose(context, flush_undo, flush_redo_, flush_context)
      # dispose of any limit that was set for the context if it is not to be
      # used again.
      if (flush_context)
        if (self.attr_debug_operation_history_dispose)
          # $NON-NLS-1$//$NON-NLS-2$
          Tracing.print_trace("OPERATIONHISTORY", "Flushing context " + RJava.cast_to_string(context))
        end
        flush_undo(context)
        flush_redo(context)
        @limits.remove(context)
        return
      end
      if (flush_undo)
        flush_undo(context)
      end
      if (flush_redo_)
        flush_redo(context)
      end
    end
    
    typesig { [IProgressMonitor, IAdaptable, IUndoableOperation] }
    # Perform the redo. All validity checks have already occurred.
    # 
    # @param monitor
    # @param operation
    def do_redo(monitor, info, operation)
      status = get_redo_approval(operation, info)
      if (status.is_ok)
        notify_about_to_redo(operation)
        begin
          status = operation.redo_(monitor, info)
        rescue OperationCanceledException => e
          status = Status::CANCEL_STATUS
        rescue ExecutionException => e
          notify_not_ok(operation)
          if (self.attr_debug_operation_history_unexpected)
            # $NON-NLS-1$
            Tracing.print_trace("OPERATIONHISTORY", "ExecutionException while redoing " + RJava.cast_to_string(operation)) # $NON-NLS-1$
          end
          raise e
        rescue JavaException => e
          notify_not_ok(operation)
          if (self.attr_debug_operation_history_unexpected)
            # $NON-NLS-1$
            Tracing.print_trace("OPERATIONHISTORY", "Exception while redoing " + RJava.cast_to_string(operation)) # $NON-NLS-1$
          end
          raise ExecutionException.new("While redoing the operation, an exception occurred", e) # $NON-NLS-1$
        end
      end
      # if successful, the operation is removed from the redo history and
      # placed back in the undo history.
      if (status.is_ok)
        added_to_undo = true
        synchronized((@undo_redo_history_lock)) do
          @redo_list.remove(operation)
          if (check_undo_limit(operation))
            @undo_list.add(operation)
          else
            added_to_undo = false
          end
        end
        # dispose the operation since we could not add it to the
        # stack and will no longer have a reference to it.
        if (!added_to_undo)
          operation.dispose
        end
        # notify listeners must happen after history is updated
        notify_redone(operation)
      else
        notify_not_ok(operation, status)
      end
      return status
    end
    
    typesig { [IProgressMonitor, IAdaptable, IUndoableOperation] }
    # Perform the undo. All validity checks have already occurred.
    # 
    # @param monitor
    # @param operation
    def do_undo(monitor, info, operation)
      status = get_undo_approval(operation, info)
      if (status.is_ok)
        notify_about_to_undo(operation)
        begin
          status = operation.undo(monitor, info)
        rescue OperationCanceledException => e
          status = Status::CANCEL_STATUS
        rescue ExecutionException => e
          notify_not_ok(operation)
          if (self.attr_debug_operation_history_unexpected)
            # $NON-NLS-1$
            Tracing.print_trace("OPERATIONHISTORY", "ExecutionException while undoing " + RJava.cast_to_string(operation)) # $NON-NLS-1$
          end
          raise e
        rescue JavaException => e
          notify_not_ok(operation)
          if (self.attr_debug_operation_history_unexpected)
            # $NON-NLS-1$
            Tracing.print_trace("OPERATIONHISTORY", "Exception while undoing " + RJava.cast_to_string(operation)) # $NON-NLS-1$
          end
          raise ExecutionException.new("While undoing the operation, an exception occurred", e) # $NON-NLS-1$
        end
      end
      # if successful, the operation is removed from the undo history and
      # placed in the redo history.
      if (status.is_ok)
        added_to_redo = true
        synchronized((@undo_redo_history_lock)) do
          @undo_list.remove(operation)
          if (check_redo_limit(operation))
            @redo_list.add(operation)
          else
            added_to_redo = false
          end
        end
        # dispose the operation since we could not add it to the
        # stack and will no longer have a reference to it.
        if (!added_to_redo)
          operation.dispose
        end
        # notification occurs after the undo and redo histories are
        # adjusted
        notify_undone(operation)
      else
        notify_not_ok(operation, status)
      end
      return status
    end
    
    typesig { [IUndoableOperation, IProgressMonitor, IAdaptable] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.core.commands.operations.IOperationHistory#execute(org.eclipse.core.commands.operations.IUndoableOperation,
    # org.eclipse.core.runtime.IProgressMonitor,
    # org.eclipse.core.runtime.IAdaptable)
    def execute(operation, monitor, info)
      Assert.is_not_null(operation)
      # error if operation is invalid
      if (!operation.can_execute)
        return IOperationHistory::OPERATION_INVALID_STATUS
      end
      # check with the operation approvers
      status = get_execute_approval(operation, info)
      if (!status.is_ok)
        # not approved. No notifications are sent, just return the status.
        return status
      end
      # If we are in the middle of an open composite, then we will add this
      # operation to the open operation rather than add the operation to the
      # history. We will still execute it.
      merging = false
      synchronized((@open_composite_lock)) do
        if (!(@open_composite).nil?)
          # the composite shouldn't be executed explicitly while it is
          # still
          # open
          if ((@open_composite).equal?(operation))
            return IOperationHistory::OPERATION_INVALID_STATUS
          end
          @open_composite.add(operation)
          merging = true
        end
      end
      # Execute the operation
      if (!merging)
        notify_about_to_execute(operation)
      end
      begin
        status = operation.execute(monitor, info)
      rescue OperationCanceledException => e
        status = Status::CANCEL_STATUS
      rescue ExecutionException => e
        notify_not_ok(operation)
        raise e
      rescue JavaException => e
        notify_not_ok(operation)
        raise ExecutionException.new("While executing the operation, an exception occurred", e) # $NON-NLS-1$
      end
      # if successful, the notify listeners are notified and the operation is
      # added to the history
      if (!merging)
        if (status.is_ok)
          notify_done(operation)
          add(operation)
        else
          notify_not_ok(operation, status)
          # dispose the operation since we did not add it to the stack
          # and will no longer have a reference to it.
          operation.dispose
        end
      end
      # all other severities are not interpreted. Simply return the status.
      return status
    end
    
    typesig { [JavaList, IUndoContext] }
    # Filter the specified list to include only the specified undo context.
    def filter(list, context)
      # This method is used whenever there is a need to filter the undo or
      # redo history on a particular context. Currently there are no caches
      # kept to optimize repeated requests for the same filter. If benchmarks
      # show this to be a common pattern that causes performances problems,
      # we could implement a filtered cache here that is nullified whenever
      # the global history changes.
      filtered = ArrayList.new
      iterator_ = list.iterator
      synchronized((@undo_redo_history_lock)) do
        while (iterator_.has_next)
          operation = iterator_.next_
          if (operation.has_context(context))
            filtered.add(operation)
          end
        end
      end
      return filtered.to_array(Array.typed(IUndoableOperation).new(filtered.size) { nil })
    end
    
    typesig { [IUndoContext] }
    # Flush the redo stack of all operations that have the given context.
    def flush_redo(context)
      if (self.attr_debug_operation_history_dispose)
        # $NON-NLS-1$ //$NON-NLS-2$
        Tracing.print_trace("OPERATIONHISTORY", "Flushing redo history for " + RJava.cast_to_string(context))
      end
      synchronized((@undo_redo_history_lock)) do
        filtered = filter(@redo_list, context)
        i = 0
        while i < filtered.attr_length
          operation = filtered[i]
          if ((context).equal?(GLOBAL_UNDO_CONTEXT) || (operation.get_contexts.attr_length).equal?(1))
            # remove the operation if it only has the context or we are
            # flushing all
            @redo_list.remove(operation)
            internal_remove(operation)
          else
            # remove the reference to the context.
            # See https://bugs.eclipse.org/bugs/show_bug.cgi?id=161786
            # It is not enough to simply remove the context. There could
            # be one or more contexts that match the one we are trying to
            # dispose.
            contexts = operation.get_contexts
            j = 0
            while j < contexts.attr_length
              if (contexts[j].matches(context))
                operation.remove_context(contexts[j])
              end
              j += 1
            end
            if ((operation.get_contexts.attr_length).equal?(0))
              @redo_list.remove(operation)
              internal_remove(operation)
            end
          end
          i += 1
        end
      end
    end
    
    typesig { [IUndoContext] }
    # Flush the undo stack of all operations that have the given context.
    def flush_undo(context)
      if (self.attr_debug_operation_history_dispose)
        # $NON-NLS-1$ //$NON-NLS-2$
        Tracing.print_trace("OPERATIONHISTORY", "Flushing undo history for " + RJava.cast_to_string(context))
      end
      synchronized((@undo_redo_history_lock)) do
        # Get all operations that have the context (or one that matches)
        filtered = filter(@undo_list, context)
        i = 0
        while i < filtered.attr_length
          operation = filtered[i]
          if ((context).equal?(GLOBAL_UNDO_CONTEXT) || (operation.get_contexts.attr_length).equal?(1))
            # remove the operation if it only has the context or we are
            # flushing all
            @undo_list.remove(operation)
            internal_remove(operation)
          else
            # remove the reference to the context.
            # See https://bugs.eclipse.org/bugs/show_bug.cgi?id=161786
            # It is not enough to simply remove the context. There could
            # be one or more contexts that match the one we are trying to
            # dispose.
            contexts = operation.get_contexts
            j = 0
            while j < contexts.attr_length
              if (contexts[j].matches(context))
                operation.remove_context(contexts[j])
              end
              j += 1
            end
            if ((operation.get_contexts.attr_length).equal?(0))
              @undo_list.remove(operation)
              internal_remove(operation)
            end
          end
          i += 1
        end
      end
      # There may be an open composite. If it has this context, then the
      # context must be removed. If it has only this context or we are
      # flushing all operations, then null it out and notify that we are
      # ending it. We don't remove it since it was never added.
      ended_composite = nil
      synchronized((@open_composite_lock)) do
        if (!(@open_composite).nil?)
          if (@open_composite.has_context(context))
            if ((context).equal?(GLOBAL_UNDO_CONTEXT) || (@open_composite.get_contexts.attr_length).equal?(1))
              ended_composite = @open_composite
              @open_composite = nil
            else
              @open_composite.remove_context(context)
            end
          end
        end
      end
      # notify outside of the synchronized block.
      if (!(ended_composite).nil?)
        notify_not_ok(ended_composite)
      end
    end
    
    typesig { [IUndoContext, ::Java::Int] }
    # Force the redo history for the given context to contain max or less
    # items.
    def force_redo_limit(context, max)
      synchronized((@undo_redo_history_lock)) do
        filtered = filter(@redo_list, context)
        size_ = filtered.attr_length
        if (size_ > 0)
          index = 0
          while (size_ > max)
            removed = filtered[index]
            if ((context).equal?(GLOBAL_UNDO_CONTEXT) || (removed.get_contexts.attr_length).equal?(1))
              # remove the operation if we are enforcing a global limit
              # or if the operation only has the specified context
              @redo_list.remove(removed)
              internal_remove(removed)
            else
              # if the operation has multiple contexts and we've reached
              # the limit for only one of them, then just remove the
              # context, not the operation.
              removed.remove_context(context)
            end
            size_ -= 1
            index += 1
          end
        end
      end
    end
    
    typesig { [IUndoContext, ::Java::Int] }
    # Force the undo history for the given context to contain max or less
    # items.
    def force_undo_limit(context, max)
      synchronized((@undo_redo_history_lock)) do
        filtered = filter(@undo_list, context)
        size_ = filtered.attr_length
        if (size_ > 0)
          index = 0
          while (size_ > max)
            removed = filtered[index]
            if ((context).equal?(GLOBAL_UNDO_CONTEXT) || (removed.get_contexts.attr_length).equal?(1))
              # remove the operation if we are enforcing a global limit
              # or if the operation only has the specified context
              @undo_list.remove(removed)
              internal_remove(removed)
            else
              # if the operation has multiple contexts and we've reached
              # the limit for only one of them, then just remove the
              # context, not the operation.
              removed.remove_context(context)
            end
            size_ -= 1
            index += 1
          end
        end
      end
    end
    
    typesig { [IUndoContext] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.core.commands.operations.IOperationHistory#getLimit()
    def get_limit(context)
      if (!@limits.contains_key(context))
        return DEFAULT_LIMIT
      end
      return ((@limits.get(context))).int_value
    end
    
    typesig { [IUndoableOperation, IAdaptable] }
    # Consult the IOperationApprovers to see if the proposed redo should be
    # allowed.
    def get_redo_approval(operation, info)
      approver_array = @approvers.get_listeners
      i = 0
      while i < approver_array.attr_length
        approver = approver_array[i]
        approval = approver.proceed_redoing(operation, self, info)
        if (!approval.is_ok)
          if (self.attr_debug_operation_history_approval)
            # $NON-NLS-1$
            # $NON-NLS-1$
            # $NON-NLS-1$
            Tracing.print_trace("OPERATIONHISTORY", "Redo not approved by " + RJava.cast_to_string(approver) + "for operation " + RJava.cast_to_string(operation) + " approved by " + RJava.cast_to_string(approval)) # $NON-NLS-1$
          end
          return approval
        end
        i += 1
      end
      return Status::OK_STATUS
    end
    
    typesig { [IUndoContext] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.core.commands.operations.IOperationHistory#getRedoHistory(org.eclipse.core.commands.operations.IUndoContext)
    def get_redo_history(context)
      Assert.is_not_null(context)
      return filter(@redo_list, context)
    end
    
    typesig { [IUndoContext] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.core.commands.operations.IOperationHistory#getOperation(org.eclipse.core.commands.operations.IUndoContext)
    def get_redo_operation(context)
      Assert.is_not_null(context)
      synchronized((@undo_redo_history_lock)) do
        i = @redo_list.size - 1
        while i >= 0
          operation = @redo_list.get(i)
          if (operation.has_context(context))
            return operation
          end
          i -= 1
        end
      end
      return nil
    end
    
    typesig { [IUndoableOperation, IAdaptable] }
    # Consult the IOperationApprovers to see if the proposed undo should be
    # allowed.
    def get_undo_approval(operation, info)
      approver_array = @approvers.get_listeners
      i = 0
      while i < approver_array.attr_length
        approver = approver_array[i]
        approval = approver.proceed_undoing(operation, self, info)
        if (!approval.is_ok)
          if (self.attr_debug_operation_history_approval)
            # $NON-NLS-1$
            # $NON-NLS-1$
            # $NON-NLS-1$
            Tracing.print_trace("OPERATIONHISTORY", "Undo not approved by " + RJava.cast_to_string(approver) + "for operation " + RJava.cast_to_string(operation) + " with status " + RJava.cast_to_string(approval)) # $NON-NLS-1$
          end
          return approval
        end
        i += 1
      end
      return Status::OK_STATUS
    end
    
    typesig { [IUndoContext] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.core.commands.operations.IOperationHistory#getUndoHistory(org.eclipse.core.commands.operations.IUndoContext)
    def get_undo_history(context)
      Assert.is_not_null(context)
      return filter(@undo_list, context)
    end
    
    typesig { [IUndoContext] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.core.commands.operations.IOperationHistory#getUndoOperation(org.eclipse.core.commands.operations.IUndoContext)
    def get_undo_operation(context)
      Assert.is_not_null(context)
      synchronized((@undo_redo_history_lock)) do
        i = @undo_list.size - 1
        while i >= 0
          operation = @undo_list.get(i)
          if (operation.has_context(context))
            return operation
          end
          i -= 1
        end
      end
      return nil
    end
    
    typesig { [IUndoableOperation, IAdaptable] }
    # Consult the IOperationApprovers to see if the proposed execution should
    # be allowed.
    # 
    # @since 3.2
    def get_execute_approval(operation, info)
      approver_array = @approvers.get_listeners
      i = 0
      while i < approver_array.attr_length
        if (approver_array[i].is_a?(IOperationApprover2))
          approver = approver_array[i]
          approval = approver.proceed_executing(operation, self, info)
          if (!approval.is_ok)
            if (self.attr_debug_operation_history_approval)
              # $NON-NLS-1$
              # $NON-NLS-1$
              # $NON-NLS-1$
              Tracing.print_trace("OPERATIONHISTORY", "Execute not approved by " + RJava.cast_to_string(approver) + "for operation " + RJava.cast_to_string(operation) + " with status " + RJava.cast_to_string(approval)) # $NON-NLS-1$
            end
            return approval
          end
        end
        i += 1
      end
      return Status::OK_STATUS
    end
    
    typesig { [IUndoableOperation] }
    # Remove the operation by disposing it and notifying listeners.
    def internal_remove(operation)
      operation.dispose
      notify_removed(operation)
    end
    
    typesig { [OperationHistoryEvent] }
    # Notify listeners of an operation event.
    def notify_listeners(event)
      if (event.get_operation.is_a?(IAdvancedUndoableOperation))
        advanced_op = event.get_operation
        SafeRunner.run(Class.new(ISafeRunnable.class == Class ? ISafeRunnable : Object) do
          local_class_in DefaultOperationHistory
          include_class_members DefaultOperationHistory
          include ISafeRunnable if ISafeRunnable.class == Module
          
          typesig { [JavaThrowable] }
          define_method :handle_exception do |exception|
            if (self.attr_debug_operation_history_unexpected)
              # $NON-NLS-1$
              Tracing.print_trace("OPERATIONHISTORY", "Exception during notification callback " + RJava.cast_to_string(exception)) # $NON-NLS-1$
            end
          end
          
          typesig { [] }
          define_method :run do
            advanced_op.about_to_notify(event)
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      end
      listener_array = @listeners.get_listeners
      i = 0
      while i < listener_array.attr_length
        listener = listener_array[i]
        SafeRunner.run(Class.new(ISafeRunnable.class == Class ? ISafeRunnable : Object) do
          local_class_in DefaultOperationHistory
          include_class_members DefaultOperationHistory
          include ISafeRunnable if ISafeRunnable.class == Module
          
          typesig { [JavaThrowable] }
          define_method :handle_exception do |exception|
            if (self.attr_debug_operation_history_unexpected)
              # $NON-NLS-1$
              Tracing.print_trace("OPERATIONHISTORY", "Exception during notification callback " + RJava.cast_to_string(exception)) # $NON-NLS-1$
            end
          end
          
          typesig { [] }
          define_method :run do
            listener.history_notification(event)
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
        i += 1
      end
    end
    
    typesig { [IUndoableOperation] }
    def notify_about_to_execute(operation)
      if (self.attr_debug_operation_history_notification)
        # $NON-NLS-1$ //$NON-NLS-2$
        Tracing.print_trace("OPERATIONHISTORY", "ABOUT_TO_EXECUTE " + RJava.cast_to_string(operation))
      end
      notify_listeners(OperationHistoryEvent.new(OperationHistoryEvent::ABOUT_TO_EXECUTE, self, operation))
    end
    
    typesig { [IUndoableOperation] }
    # Notify listeners that an operation is about to redo.
    def notify_about_to_redo(operation)
      if (self.attr_debug_operation_history_notification)
        # $NON-NLS-1$ //$NON-NLS-2$
        Tracing.print_trace("OPERATIONHISTORY", "ABOUT_TO_REDO " + RJava.cast_to_string(operation))
      end
      notify_listeners(OperationHistoryEvent.new(OperationHistoryEvent::ABOUT_TO_REDO, self, operation))
    end
    
    typesig { [IUndoableOperation] }
    # Notify listeners that an operation is about to undo.
    def notify_about_to_undo(operation)
      if (self.attr_debug_operation_history_notification)
        # $NON-NLS-1$ //$NON-NLS-2$
        Tracing.print_trace("OPERATIONHISTORY", "ABOUT_TO_UNDO " + RJava.cast_to_string(operation))
      end
      notify_listeners(OperationHistoryEvent.new(OperationHistoryEvent::ABOUT_TO_UNDO, self, operation))
    end
    
    typesig { [IUndoableOperation] }
    # Notify listeners that an operation has been added.
    def notify_add(operation)
      if (self.attr_debug_operation_history_notification)
        # $NON-NLS-1$ //$NON-NLS-2$
        Tracing.print_trace("OPERATIONHISTORY", "OPERATION_ADDED " + RJava.cast_to_string(operation))
      end
      notify_listeners(OperationHistoryEvent.new(OperationHistoryEvent::OPERATION_ADDED, self, operation))
    end
    
    typesig { [IUndoableOperation] }
    # Notify listeners that an operation is done executing.
    def notify_done(operation)
      if (self.attr_debug_operation_history_notification)
        Tracing.print_trace("OPERATIONHISTORY", "DONE " + RJava.cast_to_string(operation)) # $NON-NLS-1$ //$NON-NLS-2$
      end
      notify_listeners(OperationHistoryEvent.new(OperationHistoryEvent::DONE, self, operation))
    end
    
    typesig { [IUndoableOperation] }
    # Notify listeners that an operation did not succeed after an attempt to
    # execute, undo, or redo was made.
    def notify_not_ok(operation)
      notify_not_ok(operation, nil)
    end
    
    typesig { [IUndoableOperation, IStatus] }
    # Notify listeners that an operation did not succeed after an attempt to
    # execute, undo, or redo was made. Include the status associated with the
    # attempt.
    # 
    # @since 3.2
    def notify_not_ok(operation, status)
      if (self.attr_debug_operation_history_notification)
        # $NON-NLS-1$ //$NON-NLS-2$
        Tracing.print_trace("OPERATIONHISTORY", "OPERATION_NOT_OK " + RJava.cast_to_string(operation))
      end
      notify_listeners(OperationHistoryEvent.new(OperationHistoryEvent::OPERATION_NOT_OK, self, operation, status))
    end
    
    typesig { [IUndoableOperation] }
    # Notify listeners that an operation was redone.
    def notify_redone(operation)
      if (self.attr_debug_operation_history_notification)
        Tracing.print_trace("OPERATIONHISTORY", "REDONE " + RJava.cast_to_string(operation)) # $NON-NLS-1$ //$NON-NLS-2$
      end
      notify_listeners(OperationHistoryEvent.new(OperationHistoryEvent::REDONE, self, operation))
    end
    
    typesig { [IUndoableOperation] }
    # Notify listeners that an operation has been removed from the history.
    def notify_removed(operation)
      if (self.attr_debug_operation_history_notification)
        # $NON-NLS-1$ //$NON-NLS-2$
        Tracing.print_trace("OPERATIONHISTORY", "OPERATION_REMOVED " + RJava.cast_to_string(operation))
      end
      notify_listeners(OperationHistoryEvent.new(OperationHistoryEvent::OPERATION_REMOVED, self, operation))
    end
    
    typesig { [IUndoableOperation] }
    # Notify listeners that an operation has been undone.
    def notify_undone(operation)
      if (self.attr_debug_operation_history_notification)
        Tracing.print_trace("OPERATIONHISTORY", "UNDONE " + RJava.cast_to_string(operation)) # $NON-NLS-1$ //$NON-NLS-2$
      end
      notify_listeners(OperationHistoryEvent.new(OperationHistoryEvent::UNDONE, self, operation))
    end
    
    typesig { [IUndoableOperation] }
    # Notify listeners that an operation has been undone.
    def notify_changed(operation)
      if (self.attr_debug_operation_history_notification)
        # $NON-NLS-1$//$NON-NLS-2$
        Tracing.print_trace("OPERATIONHISTORY", "OPERATION_CHANGED " + RJava.cast_to_string(operation))
      end
      notify_listeners(OperationHistoryEvent.new(OperationHistoryEvent::OPERATION_CHANGED, self, operation))
    end
    
    typesig { [IUndoContext, IProgressMonitor, IAdaptable] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.core.commands.operations.IOperationHistory#redo(org.eclipse.core.commands.operations.IUndoContext,
    # org.eclipse.core.runtime.IProgressMonitor,
    # org.eclipse.core.runtime.IAdaptable)
    def redo_(context, monitor, info)
      Assert.is_not_null(context)
      operation = get_redo_operation(context)
      # info if there is no operation
      if ((operation).nil?)
        return IOperationHistory::NOTHING_TO_REDO_STATUS
      end
      # error if operation is invalid
      if (!operation.can_redo)
        if (self.attr_debug_operation_history_unexpected)
          # $NON-NLS-1$
          Tracing.print_trace("OPERATIONHISTORY", "Redo operation not valid - " + RJava.cast_to_string(operation)) # $NON-NLS-1$
        end
        return IOperationHistory::OPERATION_INVALID_STATUS
      end
      return do_redo(monitor, info, operation)
    end
    
    typesig { [IUndoableOperation, IProgressMonitor, IAdaptable] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.core.commands.operations.IOperationHistory#redoOperation(org.eclipse.core.commands.operations.IUndoableOperation,
    # org.eclipse.core.runtime.IProgressMonitor,
    # org.eclipse.core.runtime.IAdaptable)
    def redo_operation(operation, monitor, info)
      Assert.is_not_null(operation)
      status = nil
      if (operation.can_redo)
        status = do_redo(monitor, info, operation)
      else
        if (self.attr_debug_operation_history_unexpected)
          # $NON-NLS-1$
          Tracing.print_trace("OPERATIONHISTORY", "Redo operation not valid - " + RJava.cast_to_string(operation)) # $NON-NLS-1$
        end
        status = IOperationHistory::OPERATION_INVALID_STATUS
      end
      return status
    end
    
    typesig { [IOperationApprover] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.core.commands.operations.IOperationHistory#removeOperationApprover(org.eclipse.core.commands.operations.IOperationApprover)
    def remove_operation_approver(approver)
      @approvers.remove(approver)
    end
    
    typesig { [IOperationHistoryListener] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.core.commands.operations.IOperationHistory#removeOperationHistoryListener(org.eclipse.core.commands.operations.IOperationHistoryListener)
    def remove_operation_history_listener(listener)
      @listeners.remove(listener)
    end
    
    typesig { [IUndoableOperation, Array.typed(IUndoableOperation)] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.core.commands.operations.IOperationHistory#replaceOperation(org.eclipse.core.commands.operations.IUndoableOperation,
    # org.eclipse.core.commands.operations.IUndoableOperation [])
    def replace_operation(operation, replacements)
      # check the undo history first.
      in_undo = false
      synchronized((@undo_redo_history_lock)) do
        index = @undo_list.index_of(operation)
        if (index > -1)
          in_undo = true
          @undo_list.remove(operation)
          # notify listeners after the lock on undoList is released
          all_contexts = ArrayList.new(replacements.attr_length)
          i = 0
          while i < replacements.attr_length
            op_contexts = replacements[i].get_contexts
            j = 0
            while j < op_contexts.attr_length
              all_contexts.add(op_contexts[j])
              j += 1
            end
            @undo_list.add(index, replacements[i])
            i += 1
          end
          # recheck all the limits. We do this at the end so the index
          # doesn't change during replacement
          i_ = 0
          while i_ < all_contexts.size
            context = all_contexts.get(i_)
            force_undo_limit(context, get_limit(context))
            i_ += 1
          end
        end
      end
      if (in_undo)
        # notify listeners of operations added and removed
        internal_remove(operation)
        i = 0
        while i < replacements.attr_length
          notify_add(replacements[i])
          i += 1
        end
        return
      end
      # operation was not in the undo history. Check the redo history.
      synchronized((@undo_redo_history_lock)) do
        index_ = @redo_list.index_of(operation)
        if ((index_).equal?(-1))
          return
        end
        all_contexts = ArrayList.new(replacements.attr_length)
        @redo_list.remove(operation)
        # notify listeners after we release the lock on redoList
        i = 0
        while i < replacements.attr_length
          op_contexts = replacements[i].get_contexts
          j = 0
          while j < op_contexts.attr_length
            all_contexts.add(op_contexts[j])
            j += 1
          end
          @redo_list.add(index_, replacements[i])
          i += 1
        end
        # recheck all the limits. We do this at the end so the index
        # doesn't change during replacement
        i_ = 0
        while i_ < all_contexts.size
          context = all_contexts.get(i_)
          force_redo_limit(context, get_limit(context))
          i_ += 1
        end
      end
      # send listener notifications after we release the lock on the history
      internal_remove(operation)
      i__ = 0
      while i__ < replacements.attr_length
        notify_add(replacements[i__])
        i__ += 1
      end
    end
    
    typesig { [IUndoContext, ::Java::Int] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.core.commands.operations.IOperationHistory#setLimit(org.eclipse.core.commands.operations.IUndoContext,
    # int)
    def set_limit(context, limit)
      Assert.is_true(limit >= 0)
      # The limit checking methods interpret a null context as a global limit
      # to be enforced. We do not wish to support a global limit in this
      # implementation, so we throw an exception for a null context. The rest
      # of the implementation can handle a null context, so subclasses can
      # override this if a global limit is desired.
      Assert.is_not_null(context)
      @limits.put(context, limit)
      synchronized((@undo_redo_history_lock)) do
        force_undo_limit(context, limit)
        force_redo_limit(context, limit)
      end
    end
    
    typesig { [IUndoContext, IProgressMonitor, IAdaptable] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.core.commands.operations.IOperationHistory#undo(org.eclipse.core.commands.operations.IUndoContext,
    # org.eclipse.core.runtime.IProgressMonitor,
    # org.eclipse.core.runtime.IAdaptable)
    def undo(context, monitor, info)
      Assert.is_not_null(context)
      operation = get_undo_operation(context)
      # info if there is no operation
      if ((operation).nil?)
        return IOperationHistory::NOTHING_TO_UNDO_STATUS
      end
      # error if operation is invalid
      if (!operation.can_undo)
        if (self.attr_debug_operation_history_unexpected)
          # $NON-NLS-1$
          Tracing.print_trace("OPERATIONHISTORY", "Undo operation not valid - " + RJava.cast_to_string(operation)) # $NON-NLS-1$
        end
        return IOperationHistory::OPERATION_INVALID_STATUS
      end
      return do_undo(monitor, info, operation)
    end
    
    typesig { [IUndoableOperation, IProgressMonitor, IAdaptable] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.core.commands.operations.IOperationHistory#undoOperation(org.eclipse.core.commands.operations.IUndoableOperation,
    # org.eclipse.core.runtime.IProgressMonitor,
    # org.eclipse.core.runtime.IAdaptable)
    def undo_operation(operation, monitor, info)
      Assert.is_not_null(operation)
      status = nil
      if (operation.can_undo)
        status = do_undo(monitor, info, operation)
      else
        if (self.attr_debug_operation_history_unexpected)
          # $NON-NLS-1$
          Tracing.print_trace("OPERATIONHISTORY", "Undo operation not valid - " + RJava.cast_to_string(operation)) # $NON-NLS-1$
        end
        status = IOperationHistory::OPERATION_INVALID_STATUS
      end
      return status
    end
    
    typesig { [ICompositeOperation, ::Java::Int] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.core.commands.operations.IOperationHistory#openOperation(org.eclipse.core.commands.operations.ICompositeOperation)
    def open_operation(operation, mode)
      synchronized((@open_composite_lock)) do
        if (!(@open_composite).nil? && !(@open_composite).equal?(operation))
          # unexpected nesting of operations.
          if (self.attr_debug_operation_history_unexpected)
            # $NON-NLS-1$
            # $NON-NLS-1$
            Tracing.print_trace("OPERATIONHISTORY", "Open operation called while another operation is open.  old: " + RJava.cast_to_string(@open_composite) + "; new:  " + RJava.cast_to_string(operation)) # $NON-NLS-1$
          end
          raise IllegalStateException.new("Cannot open an operation while one is already open") # $NON-NLS-1$
        end
        @open_composite = operation
      end
      if (self.attr_debug_operation_history_openoperation)
        # $NON-NLS-1$ //$NON-NLS-2$
        Tracing.print_trace("OPERATIONHISTORY", "Opening operation " + RJava.cast_to_string(@open_composite))
      end
      if ((mode).equal?(EXECUTE))
        notify_about_to_execute(@open_composite)
      end
    end
    
    typesig { [::Java::Boolean, ::Java::Boolean, ::Java::Int] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.core.commands.operations.IOperationHistory#closeOperation(boolean,
    # boolean)
    def close_operation(operation_ok, add_to_history, mode)
      ended_composite = nil
      synchronized((@open_composite_lock)) do
        if (self.attr_debug_operation_history_unexpected)
          if ((@open_composite).nil?)
            # $NON-NLS-1$
            Tracing.print_trace("OPERATIONHISTORY", "Attempted to close operation when none was open") # $NON-NLS-1$
            return
          end
        end
        # notifications will occur outside the synchonized block
        if (!(@open_composite).nil?)
          if (self.attr_debug_operation_history_openoperation)
            # $NON-NLS-1$ //$NON-NLS-2$
            Tracing.print_trace("OPERATIONHISTORY", "Closing operation " + RJava.cast_to_string(@open_composite))
          end
          ended_composite = @open_composite
          @open_composite = nil
        end
      end
      # any mode other than EXECUTE was triggered by a request to undo or
      # redo something already in the history, so undo and redo
      # notification will occur at the end of that sequence.
      if (!(ended_composite).nil?)
        if (operation_ok)
          if ((mode).equal?(EXECUTE))
            notify_done(ended_composite)
          end
          if (add_to_history)
            add(ended_composite)
          end
        else
          if ((mode).equal?(EXECUTE))
            notify_not_ok(ended_composite)
          end
        end
      end
    end
    
    typesig { [IUndoableOperation] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.core.commands.operations.IOperationHistory#operationChanged(org.eclipse.core.commands.operations.IUndoableOperation)
    def operation_changed(operation)
      if (@undo_list.contains(operation) || @redo_list.contains(operation))
        notify_changed(operation)
      end
    end
    
    private
    alias_method :initialize__default_operation_history, :initialize
  end
  
end
