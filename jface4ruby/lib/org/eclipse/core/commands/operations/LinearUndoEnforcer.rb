require "rjava"

# Copyright (c) 2005 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Core::Commands::Operations
  module LinearUndoEnforcerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Commands::Operations
      include_const ::Org::Eclipse::Core::Runtime, :IAdaptable
      include_const ::Org::Eclipse::Core::Runtime, :IStatus
      include_const ::Org::Eclipse::Core::Runtime, :Status
    }
  end
  
  # <p>
  # An operation approver that enforces a strict linear undo. It does not allow
  # the undo or redo of any operation that is not the latest available operation
  # in all of its undo contexts.  This class may be instantiated by clients.
  # </p>
  # 
  # @since 3.1
  class LinearUndoEnforcer < LinearUndoEnforcerImports.const_get :LinearUndoViolationDetector
    include_class_members LinearUndoEnforcerImports
    
    typesig { [] }
    # Create an instance of LinearUndoEnforcer.
    def initialize
      super()
    end
    
    typesig { [IUndoableOperation, IUndoContext, IOperationHistory, IAdaptable] }
    # Return whether a linear redo violation is allowable.  A linear redo violation
    # is defined as a request to redo a particular operation even if it is not the most
    # recently added operation to the redo history.
    def allow_linear_redo_violation(operation, context, history, ui_info)
      return Status::CANCEL_STATUS
    end
    
    typesig { [IUndoableOperation, IUndoContext, IOperationHistory, IAdaptable] }
    # Return whether a linear undo violation is allowable.  A linear undo violation
    # is defined as a request to undo a particular operation even if it is not the most
    # recently added operation to the undo history.
    def allow_linear_undo_violation(operation, context, history, ui_info)
      return Status::CANCEL_STATUS
    end
    
    private
    alias_method :initialize__linear_undo_enforcer, :initialize
  end
  
end
