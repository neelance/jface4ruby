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
  module AbstractHandlerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Commands
      include_const ::Org::Eclipse::Core::Commands::Common, :EventManager
    }
  end
  
  # <p>
  # This class is a partial implementation of <code>IHandler</code>. This
  # abstract implementation provides support for handler listeners. You should
  # subclass from this method unless you want to implement your own listener
  # support. Subclasses should call
  # {@link AbstractHandler#fireHandlerChanged(HandlerEvent)}when the handler
  # changes. Subclasses can also override {@link AbstractHandler#isEnabled()} and
  # {@link AbstractHandler#isHandled()}.
  # </p>
  # 
  # @since 3.1
  class AbstractHandler < AbstractHandlerImports.const_get :EventManager
    include_class_members AbstractHandlerImports
    overload_protected {
      include IHandler2
    }
    
    # Track this base class enabled state.
    # 
    # @since 3.4
    attr_accessor :base_enabled
    alias_method :attr_base_enabled, :base_enabled
    undef_method :base_enabled
    alias_method :attr_base_enabled=, :base_enabled=
    undef_method :base_enabled=
    
    typesig { [IHandlerListener] }
    # @see IHandler#addHandlerListener(IHandlerListener)
    def add_handler_listener(handler_listener)
      add_listener_object(handler_listener)
    end
    
    typesig { [] }
    # The default implementation does nothing. Subclasses who attach listeners
    # to other objects are encouraged to detach them in this method.
    # 
    # @see org.eclipse.core.commands.IHandler#dispose()
    def dispose
      # Do nothing.
    end
    
    typesig { [HandlerEvent] }
    # Fires an event to all registered listeners describing changes to this
    # instance.
    # <p>
    # Subclasses may extend the definition of this method (i.e., if a different
    # type of listener can be attached to a subclass). This is used primarily
    # for support of <code>AbstractHandler</code> in
    # <code>org.eclipse.ui.workbench</code>, and clients should be wary of
    # overriding this behaviour. If this method is overridden, then the first
    # line of the method should be "<code>super.fireHandlerChanged(handlerEvent);</code>".
    # </p>
    # 
    # @param handlerEvent
    # the event describing changes to this instance. Must not be
    # <code>null</code>.
    def fire_handler_changed(handler_event)
      if ((handler_event).nil?)
        raise NullPointerException.new
      end
      listeners = get_listeners
      i = 0
      while i < listeners.attr_length
        listener = listeners[i]
        listener.handler_changed(handler_event)
        i += 1
      end
    end
    
    typesig { [] }
    # Whether this handler is capable of executing at this time. Subclasses may
    # override this method. If clients override this method they should also
    # consider overriding {@link #setEnabled(Object)} so they can be notified
    # about framework execution contexts.
    # 
    # @return <code>true</code>
    # @see #setEnabled(Object)
    # @see #setBaseEnabled(boolean)
    def is_enabled
      return @base_enabled
    end
    
    typesig { [::Java::Boolean] }
    # Allow the default {@link #isEnabled()} to answer our enabled state. It
    # will fire a HandlerEvent if necessary. If clients use this method they
    # should also consider overriding {@link #setEnabled(Object)} so they can
    # be notified about framework execution contexts.
    # 
    # @param state
    # the enabled state
    # @since 3.4
    def set_base_enabled(state)
      if ((@base_enabled).equal?(state))
        return
      end
      @base_enabled = state
      fire_handler_changed(HandlerEvent.new(self, true, false))
    end
    
    typesig { [Object] }
    # Called by the framework to allow the handler to update its enabled state
    # by extracting the same information available at execution time. Clients
    # may override if they need to extract information from the application
    # context.
    # 
    # @param evaluationContext
    # the application context. May be <code>null</code>
    # @since 3.4
    # @see #setBaseEnabled(boolean)
    def set_enabled(evaluation_context)
    end
    
    typesig { [] }
    # Whether this handler is capable of handling delegated responsibilities at
    # this time. Subclasses may override this method.
    # 
    # @return <code>true</code>
    def is_handled
      return true
    end
    
    typesig { [] }
    # <p>
    # Returns true iff there is one or more IHandlerListeners attached to this
    # AbstractHandler.
    # </p>
    # <p>
    # Subclasses may extend the definition of this method (i.e., if a different
    # type of listener can be attached to a subclass). This is used primarily
    # for support of <code>AbstractHandler</code> in
    # <code>org.eclipse.ui.workbench</code>, and clients should be wary of
    # overriding this behaviour. If this method is overridden, then the return
    # value should include "<code>super.hasListeners() ||</code>".
    # </p>
    # 
    # @return true iff there is one or more IHandlerListeners attached to this
    # AbstractHandler
    def has_listeners
      return is_listener_attached
    end
    
    typesig { [IHandlerListener] }
    # @see IHandler#removeHandlerListener(IHandlerListener)
    def remove_handler_listener(handler_listener)
      remove_listener_object(handler_listener)
    end
    
    typesig { [] }
    def initialize
      @base_enabled = false
      super()
      @base_enabled = true
    end
    
    private
    alias_method :initialize__abstract_handler, :initialize
  end
  
end
