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
  module LinearUndoViolationDetectorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Commands::Operations
      include_const ::Org::Eclipse::Core::Runtime, :IAdaptable
      include_const ::Org::Eclipse::Core::Runtime, :IStatus
      include_const ::Org::Eclipse::Core::Runtime, :Status
    }
  end
  
  # <p>
  # An abstract class for detecting violations in a strict linear undo/redo
  # model. Once a violation is detected, subclasses implement the specific
  # behavior for indicating whether or not the undo/redo should proceed.
  # </p>
  # 
  # @since 3.1
  class LinearUndoViolationDetector 
    include_class_members LinearUndoViolationDetectorImports
    include IOperationApprover
    
    typesig { [] }
    # Create an instance of LinearUndoViolationDetector.
    def initialize
    end
    
    typesig { [IUndoableOperation, IUndoContext, IOperationHistory, IAdaptable] }
    # Return a status indicating whether a linear redo violation is allowable.
    # A linear redo violation is defined as a request to redo a particular
    # operation even if it is not the most recently added operation to the redo
    # history.
    # 
    # @param operation
    # the operation for which a linear redo violation has been
    # detected.
    # @param context
    # the undo context in which the linear redo violation exists
    # @param history
    # the operation history containing the operation
    # @param info
    # the IAdaptable (or <code>null</code>) provided by the
    # caller in order to supply UI information for prompting the
    # user if necessary. When this parameter is not
    # <code>null</code>, it should minimally contain an adapter
    # for the org.eclipse.swt.widgets.Shell.class.
    # 
    # @return the IStatus describing whether the redo violation is allowed. The
    # redo will not proceed if the status severity is not
    # <code>OK</code>, and the caller requesting the redo will be
    # returned the status that caused the rejection. Specific status
    # severities will not be interpreted by the history.
    def allow_linear_redo_violation(operation, context, history, info)
      raise NotImplementedError
    end
    
    typesig { [IUndoableOperation, IUndoContext, IOperationHistory, IAdaptable] }
    # Return a status indicating whether a linear undo violation is allowable.
    # A linear undo violation is defined as a request to undo a particular
    # operation even if it is not the most recently added operation to the undo
    # history.
    # 
    # @param operation
    # the operation for which a linear undo violation has been
    # detected.
    # @param context
    # the undo context in which the linear undo violation exists
    # @param history
    # the operation history containing the operation
    # @param info
    # the IAdaptable (or <code>null</code>) provided by the
    # caller in order to supply UI information for prompting the
    # user if necessary. When this parameter is not
    # <code>null</code>, it should minimally contain an adapter
    # for the org.eclipse.swt.widgets.Shell.class.
    # 
    # @return the IStatus describing whether the undo violation is allowed. The
    # undo will not proceed if the status severity is not
    # <code>OK</code>, and the caller requesting the undo will be
    # returned the status that caused the rejection. Specific status
    # severities will not be interpreted by the history.
    def allow_linear_undo_violation(operation, context, history, info)
      raise NotImplementedError
    end
    
    typesig { [IUndoableOperation, IOperationHistory, IAdaptable] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.core.commands.operations.IOperationApprover#proceedRedoing(org.eclipse.core.commands.operations.IUndoableOperation,
    # org.eclipse.core.commands.operations.IOperationHistory,
    # org.eclipse.core.runtime.IAdaptable)
    def proceed_redoing(operation, history, info)
      contexts = operation.get_contexts
      i = 0
      while i < contexts.attr_length
        context = contexts[i]
        if (!(history.get_redo_operation(context)).equal?(operation))
          status = allow_linear_redo_violation(operation, context, history, info)
          if (!status.is_ok)
            return status
          end
        end
        i += 1
      end
      return Status::OK_STATUS
    end
    
    typesig { [IUndoableOperation, IOperationHistory, IAdaptable] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.core.commands.operations.IOperationApprover#proceedUndoing(org.eclipse.core.commands.operations.IUndoableOperation,
    # org.eclipse.core.commands.operations.IOperationHistory,
    # org.eclipse.core.runtime.IAdaptable)
    def proceed_undoing(operation, history, info)
      contexts = operation.get_contexts
      i = 0
      while i < contexts.attr_length
        context = contexts[i]
        if (!(history.get_undo_operation(context)).equal?(operation))
          status = allow_linear_undo_violation(operation, context, history, info)
          if (!status.is_ok)
            return status
          end
        end
        i += 1
      end
      return Status::OK_STATUS
    end
    
    private
    alias_method :initialize__linear_undo_violation_detector, :initialize
  end
  
end
