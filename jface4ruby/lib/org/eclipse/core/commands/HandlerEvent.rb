require "rjava"

# Copyright (c) 2004, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Core::Commands
  module HandlerEventImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Commands
      include_const ::Org::Eclipse::Core::Commands::Common, :AbstractBitSetEvent
    }
  end
  
  # An instance of this class describes changes to an instance of
  # <code>IHandler</code>.
  # <p>
  # This class is not intended to be extended by clients.
  # </p>
  # 
  # @since 3.1
  # @see IHandlerListener#handlerChanged(HandlerEvent)
  class HandlerEvent < HandlerEventImports.const_get :AbstractBitSetEvent
    include_class_members HandlerEventImports
    
    class_module.module_eval {
      # The bit used to represent whether the handler has changed its enabled
      # state.
      const_set_lazy(:CHANGED_ENABLED) { 1 }
      const_attr_reader  :CHANGED_ENABLED
      
      # The bit used to represent whether the handler has changed its handled
      # state.
      const_set_lazy(:CHANGED_HANDLED) { 1 << 1 }
      const_attr_reader  :CHANGED_HANDLED
    }
    
    # The handler that changed; this value is never <code>null</code>.
    attr_accessor :handler
    alias_method :attr_handler, :handler
    undef_method :handler
    alias_method :attr_handler=, :handler=
    undef_method :handler=
    
    typesig { [IHandler, ::Java::Boolean, ::Java::Boolean] }
    # Creates a new instance of this class.
    # 
    # @param handler
    # the instance of the interface that changed; must not be
    # <code>null</code>.
    # @param enabledChanged
    # Whether the enabled state of the handler has changed.
    # @param handledChanged
    # Whether the handled state of the handler has changed.
    def initialize(handler, enabled_changed, handled_changed)
      @handler = nil
      super()
      if ((handler).nil?)
        raise NullPointerException.new
      end
      @handler = handler
      if (enabled_changed)
        self.attr_changed_values |= CHANGED_ENABLED
      end
      if (handled_changed)
        self.attr_changed_values |= CHANGED_HANDLED
      end
    end
    
    typesig { [] }
    # Returns the instance of the interface that changed.
    # 
    # @return the instance of the interface that changed. Guaranteed not to be
    # <code>null</code>.
    def get_handler
      return @handler
    end
    
    typesig { [] }
    # Returns whether or not the enabled property changed.
    # 
    # @return <code>true</code>, iff the enabled property changed.
    def is_enabled_changed
      return (!((self.attr_changed_values & CHANGED_ENABLED)).equal?(0))
    end
    
    typesig { [] }
    # Returns whether or not the handled property changed.
    # 
    # @return <code>true</code>, iff the handled property changed.
    def is_handled_changed
      return (!((self.attr_changed_values & CHANGED_HANDLED)).equal?(0))
    end
    
    private
    alias_method :initialize__handler_event, :initialize
  end
  
end
