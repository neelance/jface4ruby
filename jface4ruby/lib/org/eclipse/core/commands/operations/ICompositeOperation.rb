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
  module ICompositeOperationImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Commands::Operations
    }
  end
  
  # <p>
  # ICompositeOperation defines an undoable operation that is composed of child
  # operations. Requests to execute, undo, or redo a composite result in the the
  # execution, undo, or redo of the composite as a whole. Similarly, a request to
  # dispose the composite should result in all child operations being disposed.
  # </p>
  # 
  # @since 3.1
  module ICompositeOperation
    include_class_members ICompositeOperationImports
    include IUndoableOperation
    
    typesig { [IUndoableOperation] }
    # <p>
    # Add the specified operation as a child of this operation.
    # </p>
    # 
    # @param operation
    # the operation to be added. If the operation instance has
    # already been added, this method will have no effect.
    def add(operation)
      raise NotImplementedError
    end
    
    typesig { [IUndoableOperation] }
    # <p>
    # Remove the specified operation from this operation.
    # </p>
    # <p>
    # The composite operation should dispose the operation as part of removing
    # it.
    # </p>
    # 
    # @param operation
    # the operation to be removed. The operation should be disposed
    # by the receiver. This method will have no effect if the
    # operation instance is not already a child.
    def remove(operation)
      raise NotImplementedError
    end
  end
  
end
