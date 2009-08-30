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
  module OperationHistoryEventImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Commands::Operations
      include_const ::Org::Eclipse::Core::Runtime, :IStatus
    }
  end
  
  # <p>
  # OperationHistoryEvent is used to communicate changes that occur in a
  # DefaultOperationHistory, including the addition or removal of operations, and
  # the execution, undo, and redo of operations.
  # </p>
  # <p>
  # Operation history listeners must be prepared to receive notifications from a
  # background thread. Any UI access occurring inside the implementation must be
  # properly synchronized using the techniques specified by the client's widget
  # library.
  # </p>
  # 
  # 
  # @since 3.1
  class OperationHistoryEvent 
    include_class_members OperationHistoryEventImports
    
    class_module.module_eval {
      # ABOUT_TO_EXECUTE indicates that an operation is about to execute.
      # Listeners should prepare for the execution as appropriate. Listeners will
      # receive a DONE notification if the operation is successful, or an
      # OPERATION_NOT_OK notification if the execution is cancelled or otherwise
      # fails. This notification is only received for those operations executed
      # by the operation history. Operations that are added to the history after
      # execution do not trigger these notifications.
      # 
      # If the operation successfully executes, clients will also receive a
      # notification that it has been added to the history.
      # 
      # (value is 1).
      const_set_lazy(:ABOUT_TO_EXECUTE) { 1 }
      const_attr_reader  :ABOUT_TO_EXECUTE
      
      # ABOUT_TO_REDO indicates that an operation is about to be redone.
      # Listeners should prepare for the redo as appropriate. Listeners will
      # receive a REDONE notification if the operation is successful, or an
      # OPERATION_NOT_OK notification if the redo is cancelled or otherwise
      # fails.
      # 
      # (value is 2).
      const_set_lazy(:ABOUT_TO_REDO) { 2 }
      const_attr_reader  :ABOUT_TO_REDO
      
      # ABOUT_TO_UNDO indicates that an operation is about to be undone.
      # Listeners should prepare for the undo as appropriate. Listeners will
      # receive an UNDONE notification if the operation is successful, or an
      # OPERATION_NOT_OK notification if the undo is cancelled or otherwise
      # fails.
      # 
      # (value is 3).
      const_set_lazy(:ABOUT_TO_UNDO) { 3 }
      const_attr_reader  :ABOUT_TO_UNDO
      
      # DONE indicates that an operation has been executed. Listeners can take
      # appropriate action, such as revealing any relevant state in the UI. This
      # notification is only received for those operations executed by the
      # operation history. Operations that are added to the history after
      # execution do not trigger this notification.
      # 
      # Clients will also receive a notification that the operation has been
      # added to the history.
      # 
      # (value is 4).
      const_set_lazy(:DONE) { 4 }
      const_attr_reader  :DONE
      
      # OPERATION_ADDED indicates that an operation was added to the history.
      # Listeners can use this notification to add their undo context to a new
      # operation as appropriate or otherwise record the operation.
      # 
      # (value is 5).
      const_set_lazy(:OPERATION_ADDED) { 5 }
      const_attr_reader  :OPERATION_ADDED
      
      # OPERATION_CHANGED indicates that an operation has changed in some way
      # since it was added to the operations history.
      # 
      # (value is 6).
      const_set_lazy(:OPERATION_CHANGED) { 6 }
      const_attr_reader  :OPERATION_CHANGED
      
      # OPERATION_NOT_OK indicates that an operation was attempted and not
      # successful. Listeners typically use this when they have prepared for an
      # execute, undo, or redo, and need to know that the operation did not
      # successfully complete. For example, listeners that turn redraw off before
      # an operation is undone would turn redraw on when the operation completes,
      # or when this notification is received, since there will be no
      # notification of the completion.
      # 
      # (value is 7).
      const_set_lazy(:OPERATION_NOT_OK) { 7 }
      const_attr_reader  :OPERATION_NOT_OK
      
      # OPERATION_REMOVED indicates an operation was removed from the history.
      # Listeners typically remove any record of the operation that they may have
      # kept in their own state. The operation has been disposed by the time
      # listeners receive this notification.
      # 
      # (value is 8).
      const_set_lazy(:OPERATION_REMOVED) { 8 }
      const_attr_reader  :OPERATION_REMOVED
      
      # REDONE indicates that an operation was redone. Listeners can take
      # appropriate action, such as revealing any relevant state in the UI.
      # 
      # (value is 9).
      const_set_lazy(:REDONE) { 9 }
      const_attr_reader  :REDONE
      
      # UNDONE indicates that an operation was undone. Listeners can take
      # appropriate action, such as revealing any relevant state in the UI.
      # 
      # (value is 10).
      const_set_lazy(:UNDONE) { 10 }
      const_attr_reader  :UNDONE
    }
    
    attr_accessor :code
    alias_method :attr_code, :code
    undef_method :code
    alias_method :attr_code=, :code=
    undef_method :code=
    
    attr_accessor :history
    alias_method :attr_history, :history
    undef_method :history
    alias_method :attr_history=, :history=
    undef_method :history=
    
    attr_accessor :operation
    alias_method :attr_operation, :operation
    undef_method :operation
    alias_method :attr_operation=, :operation=
    undef_method :operation=
    
    # @since 3.2
    attr_accessor :status
    alias_method :attr_status, :status
    undef_method :status
    alias_method :attr_status=, :status=
    undef_method :status=
    
    typesig { [::Java::Int, IOperationHistory, IUndoableOperation] }
    # Construct an event for the specified operation history.
    # 
    # @param code
    # the event code to be used.
    # @param history
    # the history triggering the event.
    # @param operation
    # the operation involved in the event.
    def initialize(code, history, operation)
      initialize__operation_history_event(code, history, operation, nil)
    end
    
    typesig { [::Java::Int, IOperationHistory, IUndoableOperation, IStatus] }
    # Construct an event for the specified operation history.
    # 
    # @param code
    # the event code to be used.
    # @param history
    # the history triggering the event.
    # @param operation
    # the operation involved in the event.
    # @param status
    # the status associated with the event, or null if no status is
    # available.
    # 
    # @since 3.2
    def initialize(code, history, operation, status)
      @code = 0
      @history = nil
      @operation = nil
      @status = nil
      if ((history).nil?)
        raise NullPointerException.new
      end
      if ((operation).nil?)
        raise NullPointerException.new
      end
      @code = code
      @history = history
      @operation = operation
      @status = status
    end
    
    typesig { [] }
    # Return the type of event that is occurring.
    # 
    # @return the type code indicating the type of event.
    def get_event_type
      return @code
    end
    
    typesig { [] }
    # Return the operation history that triggered this event.
    # 
    # @return the operation history
    def get_history
      return @history
    end
    
    typesig { [] }
    # Return the operation associated with this event.
    # 
    # @return the operation
    def get_operation
      return @operation
    end
    
    typesig { [] }
    # Return the status associated with this event.
    # 
    # @return the status associated with this event. The status may be null.
    # 
    # @since 3.2
    def get_status
      return @status
    end
    
    private
    alias_method :initialize__operation_history_event, :initialize
  end
  
end
