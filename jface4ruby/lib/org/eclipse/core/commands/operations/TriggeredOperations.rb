require "rjava"

# Copyright (c) 2005, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Core::Commands::Operations
  module TriggeredOperationsImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Commands::Operations
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :JavaList
      include_const ::Org::Eclipse::Core::Commands, :ExecutionException
      include_const ::Org::Eclipse::Core::Runtime, :IAdaptable
      include_const ::Org::Eclipse::Core::Runtime, :IProgressMonitor
      include_const ::Org::Eclipse::Core::Runtime, :IStatus
      include_const ::Org::Eclipse::Core::Runtime, :OperationCanceledException
      include_const ::Org::Eclipse::Core::Runtime, :Status
    }
  end
  
  # Triggered operations are a specialized implementation of a composite
  # operation that keeps track of operations triggered by the execution of some
  # primary operation. The composite knows which operation was the trigger for
  # subsequent operations, and adds all triggered operations as children. When
  # execution, undo, or redo is performed, only the triggered operation is
  # executed, undone, or redone if it is still present. If the trigger is removed
  # from the triggered operations, then the child operations will replace the
  # triggered operations in the history.
  # <p>
  # This class may be instantiated by clients.
  # </p>
  # 
  # @since 3.1
  class TriggeredOperations < TriggeredOperationsImports.const_get :AbstractOperation
    include_class_members TriggeredOperationsImports
    overload_protected {
      include ICompositeOperation
      include IAdvancedUndoableOperation
      include IContextReplacingOperation
    }
    
    attr_accessor :triggering_operation
    alias_method :attr_triggering_operation, :triggering_operation
    undef_method :triggering_operation
    alias_method :attr_triggering_operation=, :triggering_operation=
    undef_method :triggering_operation=
    
    attr_accessor :history
    alias_method :attr_history, :history
    undef_method :history
    alias_method :attr_history=, :history=
    undef_method :history=
    
    attr_accessor :children
    alias_method :attr_children, :children
    undef_method :children
    alias_method :attr_children=, :children=
    undef_method :children=
    
    typesig { [IUndoableOperation, IOperationHistory] }
    # Construct a composite triggered operations using the specified undoable
    # operation as the trigger. Use the label of this trigger as the label of
    # the operation.
    # 
    # @param operation
    # the operation that will trigger other operations.
    # @param history
    # the operation history containing the triggered operations.
    def initialize(operation, history)
      @triggering_operation = nil
      @history = nil
      @children = nil
      super(operation.get_label)
      @children = ArrayList.new
      @triggering_operation = operation
      recompute_contexts
      @history = history
    end
    
    typesig { [IUndoableOperation] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.core.commands.operations.IUndoableOperation#add(org.eclipse.core.commands.operations.IUndoableOperation)
    def add(operation)
      @children.add(operation)
      recompute_contexts
    end
    
    typesig { [IUndoableOperation] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.core.commands.operations.IUndoableOperation#remove(org.eclipse.core.commands.operations.IUndoableOperation)
    def remove(operation)
      if ((operation).equal?(@triggering_operation))
        # the triggering operation is being removed, so we must replace
        # this composite with its individual triggers.
        @triggering_operation = nil
        # save the children before replacing the operation, since this
        # operation will be disposed as part of replacing it. We don't want
        # the children to be disposed since they are to replace this
        # operation.
        children_to_restore = ArrayList.new(@children)
        @children = ArrayList.new(0)
        recompute_contexts
        operation.dispose
        # now replace the triggering operation
        @history.replace_operation(self, children_to_restore.to_array(Array.typed(IUndoableOperation).new(children_to_restore.size) { nil }))
      else
        @children.remove(operation)
        operation.dispose
        recompute_contexts
      end
    end
    
    typesig { [IUndoContext] }
    # Remove the specified context from the receiver. This method is typically
    # invoked when the history is being flushed for a certain context. In the
    # case of triggered operations, if the only context for the triggering
    # operation is being removed, then the triggering operation must be
    # replaced in the operation history with the atomic operations that it
    # triggered. If the context being removed is not the only context for the
    # triggering operation, the triggering operation will remain, and the
    # children will each be similarly checked.
    # 
    # @param context
    # the undo context being removed from the receiver.
    def remove_context(context)
      recompute = false
      # first check to see if we are removing the only context of the
      # triggering operation
      if (!(@triggering_operation).nil? && @triggering_operation.has_context(context))
        if ((@triggering_operation.get_contexts.attr_length).equal?(1))
          remove(@triggering_operation)
          return
        end
        @triggering_operation.remove_context(context)
        recompute = true
      end
      # the triggering operation remains, check all the children
      to_be_removed = ArrayList.new
      i = 0
      while i < @children.size
        child = @children.get(i)
        if (child.has_context(context))
          if ((child.get_contexts.attr_length).equal?(1))
            to_be_removed.add(child)
          else
            child.remove_context(context)
          end
          recompute = true
        end
        i += 1
      end
      i_ = 0
      while i_ < to_be_removed.size
        remove(to_be_removed.get(i_))
        i_ += 1
      end
      if (recompute)
        recompute_contexts
      end
    end
    
    typesig { [IProgressMonitor, IAdaptable] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.core.commands.operations.IUndoableOperation#execute(org.eclipse.core.runtime.IProgressMonitor,
    # org.eclipse.core.runtime.IAdaptable)
    def execute(monitor, info)
      if (!(@triggering_operation).nil?)
        @history.open_operation(self, IOperationHistory::EXECUTE)
        begin
          status = @triggering_operation.execute(monitor, info)
          @history.close_operation(status.is_ok, false, IOperationHistory::EXECUTE)
          return status
        rescue ExecutionException => e
          @history.close_operation(false, false, IOperationHistory::EXECUTE)
          raise e
        rescue RuntimeException => e
          @history.close_operation(false, false, IOperationHistory::EXECUTE)
          raise e
        end
      end
      return IOperationHistory::OPERATION_INVALID_STATUS
    end
    
    typesig { [IProgressMonitor, IAdaptable] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.core.commands.operations.IUndoableOperation#redo(org.eclipse.core.runtime.IProgressMonitor,
    # org.eclipse.core.runtime.IAdaptable)
    def redo_(monitor, info)
      if (!(@triggering_operation).nil?)
        @history.open_operation(self, IOperationHistory::REDO)
        children_to_restore = ArrayList.new(@children)
        begin
          remove_all_children
          status = @triggering_operation.redo_(monitor, info)
          if (!status.is_ok)
            @children = children_to_restore
          end
          @history.close_operation(status.is_ok, false, IOperationHistory::REDO)
          return status
        rescue ExecutionException => e
          @children = children_to_restore
          @history.close_operation(false, false, IOperationHistory::REDO)
          raise e
        rescue RuntimeException => e
          @children = children_to_restore
          @history.close_operation(false, false, IOperationHistory::REDO)
          raise e
        end
      end
      return IOperationHistory::OPERATION_INVALID_STATUS
    end
    
    typesig { [IProgressMonitor, IAdaptable] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.core.commands.operations.IUndoableOperation#undo(org.eclipse.core.runtime.IProgressMonitor,
    # org.eclipse.core.runtime.IAdaptable)
    def undo(monitor, info)
      if (!(@triggering_operation).nil?)
        @history.open_operation(self, IOperationHistory::UNDO)
        children_to_restore = ArrayList.new(@children)
        begin
          remove_all_children
          status = @triggering_operation.undo(monitor, info)
          if (!status.is_ok)
            @children = children_to_restore
          end
          @history.close_operation(status.is_ok, false, IOperationHistory::UNDO)
          return status
        rescue ExecutionException => e
          @children = children_to_restore
          @history.close_operation(false, false, IOperationHistory::UNDO)
          raise e
        rescue RuntimeException => e
          @children = children_to_restore
          @history.close_operation(false, false, IOperationHistory::UNDO)
          raise e
        end
      end
      return IOperationHistory::OPERATION_INVALID_STATUS
    end
    
    typesig { [] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.core.commands.operations.IUndoableOperation#canUndo()
    def can_undo
      if (!(@triggering_operation).nil?)
        return @triggering_operation.can_undo
      end
      return false
    end
    
    typesig { [] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.core.commands.operations.IUndoableOperation#canExecute()
    def can_execute
      if (!(@triggering_operation).nil?)
        return @triggering_operation.can_execute
      end
      return false
    end
    
    typesig { [] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.core.commands.operations.IUndoableOperation#canRedo()
    def can_redo
      if (!(@triggering_operation).nil?)
        return @triggering_operation.can_redo
      end
      return false
    end
    
    typesig { [] }
    # Dispose all operations in the receiver.
    def dispose
      i = 0
      while i < @children.size
        ((@children.get(i))).dispose
        i += 1
      end
      if (!(@triggering_operation).nil?)
        @triggering_operation.dispose
      end
    end
    
    typesig { [] }
    # Recompute contexts in light of some change in the children
    def recompute_contexts
      all_contexts = ArrayList.new
      if (!(@triggering_operation).nil?)
        contexts = @triggering_operation.get_contexts
        i = 0
        while i < contexts.attr_length
          all_contexts.add(contexts[i])
          i += 1
        end
      end
      i = 0
      while i < @children.size
        contexts = (@children.get(i)).get_contexts
        j = 0
        while j < contexts.attr_length
          if (!all_contexts.contains(contexts[j]))
            all_contexts.add(contexts[j])
          end
          j += 1
        end
        i += 1
      end
      self.attr_contexts = all_contexts
    end
    
    typesig { [] }
    # Remove all non-triggering children
    def remove_all_children
      non_triggers = @children.to_array(Array.typed(IUndoableOperation).new(@children.size) { nil })
      i = 0
      while i < non_triggers.attr_length
        @children.remove(non_triggers[i])
        non_triggers[i].dispose
        i += 1
      end
    end
    
    typesig { [] }
    # Return the operation that triggered the other operations in this
    # composite.
    # 
    # @return the IUndoableOperation that triggered the other children.
    def get_triggering_operation
      return @triggering_operation
    end
    
    typesig { [] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.core.commands.operations.IAdvancedModelOperation#getAffectedObjects()
    def get_affected_objects
      if (@triggering_operation.is_a?(IAdvancedUndoableOperation))
        return (@triggering_operation).get_affected_objects
      end
      return nil
    end
    
    typesig { [OperationHistoryEvent] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.core.commands.operations.IAdvancedModelOperation#aboutToNotify(org.eclipse.core.commands.operations.OperationHistoryEvent)
    def about_to_notify(event)
      if (@triggering_operation.is_a?(IAdvancedUndoableOperation))
        (@triggering_operation).about_to_notify(event)
      end
    end
    
    typesig { [IProgressMonitor] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.core.commands.operations.IAdvancedUndoableOperation#computeUndoableStatus(org.eclipse.core.runtime.IProgressMonitor)
    def compute_undoable_status(monitor)
      if (@triggering_operation.is_a?(IAdvancedUndoableOperation))
        begin
          return (@triggering_operation).compute_undoable_status(monitor)
        rescue OperationCanceledException => e
          return Status::CANCEL_STATUS
        end
      end
      return Status::OK_STATUS
    end
    
    typesig { [IProgressMonitor] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.core.commands.operations.IAdvancedUndoableOperation#computeRedoableStatus(org.eclipse.core.runtime.IProgressMonitor)
    def compute_redoable_status(monitor)
      if (@triggering_operation.is_a?(IAdvancedUndoableOperation))
        begin
          return (@triggering_operation).compute_redoable_status(monitor)
        rescue OperationCanceledException => e
          return Status::CANCEL_STATUS
        end
      end
      return Status::OK_STATUS
    end
    
    typesig { [IUndoContext, IUndoContext] }
    # Replace the undo context of the receiver with the provided replacement
    # undo context. In the case of triggered operations, all contained
    # operations are checked and any occurrence of the original context is
    # replaced with the new undo context.
    # <p>
    # This message has no effect if the original undo context is not present in
    # the receiver.
    # 
    # @param original
    # the undo context which is to be replaced
    # @param replacement
    # the undo context which is replacing the original
    # @since 3.2
    def replace_context(original, replacement)
      # first check the triggering operation
      if (!(@triggering_operation).nil? && @triggering_operation.has_context(original))
        if (@triggering_operation.is_a?(IContextReplacingOperation))
          (@triggering_operation).replace_context(original, replacement)
        else
          @triggering_operation.remove_context(original)
          @triggering_operation.add_context(replacement)
        end
      end
      # Now check all the children
      i = 0
      while i < @children.size
        child = @children.get(i)
        if (child.has_context(original))
          if (child.is_a?(IContextReplacingOperation))
            (child).replace_context(original, replacement)
          else
            child.remove_context(original)
            child.add_context(replacement)
          end
        end
        i += 1
      end
      recompute_contexts
    end
    
    typesig { [IUndoContext] }
    # Add the specified context to the operation. Overridden in
    # TriggeredOperations to add the specified undo context to the triggering
    # operation.
    # 
    # @param context
    # the context to be added
    # 
    # @since 3.2
    def add_context(context)
      if (!(@triggering_operation).nil?)
        @triggering_operation.add_context(context)
        recompute_contexts
      end
    end
    
    private
    alias_method :initialize__triggered_operations, :initialize
  end
  
end
