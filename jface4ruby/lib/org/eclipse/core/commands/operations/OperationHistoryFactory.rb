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
  module OperationHistoryFactoryImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Commands::Operations
    }
  end
  
  # <p>
  # This class is used to maintain the instance of the operation history that
  # should be used by classes that access the undo or redo history and add
  # undoable operations to the history.
  # 
  # <p>
  # It is intended that an application can create an operation history appropriate
  # for its needs and set it into this class.  Otherwise, a default operation history
  # will be created.  The operation history may only be set one time.  All classes that
  # access an operations history use this class to obtain the correct instance.
  # 
  # @since 3.1
  class OperationHistoryFactory 
    include_class_members OperationHistoryFactoryImports
    
    class_module.module_eval {
      
      def operation_history
        defined?(@@operation_history) ? @@operation_history : @@operation_history= nil
      end
      alias_method :attr_operation_history, :operation_history
      
      def operation_history=(value)
        @@operation_history = value
      end
      alias_method :attr_operation_history=, :operation_history=
      
      typesig { [] }
      # Return the operation history to be used for managing undoable operations.
      # 
      # @return the operation history to be used for executing, undoing, and
      # redoing operations.
      def get_operation_history
        if ((self.attr_operation_history).nil?)
          self.attr_operation_history = DefaultOperationHistory.new
        end
        return self.attr_operation_history
      end
      
      typesig { [IOperationHistory] }
      # Set the operation history to be used for managing undoable operations.
      # This method may only be called one time, and must be called before any
      # request to get the history.  Attempts to set the operation history will
      # be ignored after it has been already set, or after a default one has
      # been created.
      # 
      # @param history
      # the operation history to be used for executing, undoing, and
      # redoing operations.
      def set_operation_history(history)
        # If one has already been set or created, ignore this request.
        if ((self.attr_operation_history).nil?)
          self.attr_operation_history = history
        end
      end
    }
    
    typesig { [] }
    def initialize
      # may not be instantiated
    end
    
    private
    alias_method :initialize__operation_history_factory, :initialize
  end
  
end
