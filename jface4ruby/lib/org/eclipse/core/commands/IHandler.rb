require "rjava"

# Copyright (c) 2004, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Core::Commands
  module IHandlerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Commands
    }
  end
  
  # A handler is the pluggable piece of a command that handles execution. Each
  # command can have zero or more handlers associated with it (in general), of
  # which only one will be active at any given moment in time. When the command
  # is asked to execute, it will simply pass that request on to its active
  # handler, if any.
  # 
  # @see AbstractHandler
  # @since 3.1
  module IHandler
    include_class_members IHandlerImports
    
    typesig { [IHandlerListener] }
    # Registers an instance of <code>IHandlerListener</code> to listen for
    # changes to properties of this instance.
    # 
    # @param handlerListener
    # the instance to register. Must not be <code>null</code>. If
    # an attempt is made to register an instance which is already
    # registered with this instance, no operation is performed.
    def add_handler_listener(handler_listener)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Disposes of this handler. This method is run once when the object is no
    # longer referenced. This can be used as an opportunity to unhook listeners
    # from other objects.
    def dispose
      raise NotImplementedError
    end
    
    typesig { [ExecutionEvent] }
    # Executes with the map of parameter values by name.
    # 
    # @param event
    # An event containing all the information about the current
    # state of the application; must not be <code>null</code>.
    # @return the result of the execution. Reserved for future use, must be
    # <code>null</code>.
    # @throws ExecutionException
    # if an exception occurred during execution.
    def execute(event)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns whether this handler is capable of executing at this moment in
    # time. If the enabled state is other than true clients should also
    # consider implementing IHandler2 so they can be notified about framework
    # execution contexts.
    # 
    # @return <code>true</code> if the command is enabled; <code>false</code>
    # otherwise.
    # @see IHandler2#setEnabled(Object)
    def is_enabled
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns whether this handler is really capable of handling delegation. In
    # the case of a handler that is a composition of other handlers, this reply
    # is intended to indicate whether the handler is truly capable of receiving
    # delegated responsibilities at this time.
    # 
    # @return <code>true</code> if the handler is handled; <code>false</code>
    # otherwise.
    def is_handled
      raise NotImplementedError
    end
    
    typesig { [IHandlerListener] }
    # Unregisters an instance of <code>IHandlerListener</code> listening for
    # changes to properties of this instance.
    # 
    # @param handlerListener
    # the instance to unregister. Must not be <code>null</code>.
    # If an attempt is made to unregister an instance which is not
    # already registered with this instance, no operation is
    # performed.
    def remove_handler_listener(handler_listener)
      raise NotImplementedError
    end
  end
  
end
