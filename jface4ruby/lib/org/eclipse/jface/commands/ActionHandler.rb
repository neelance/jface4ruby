require "rjava"

# Copyright (c) 2004, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Commands
  module ActionHandlerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Commands
      include_const ::Org::Eclipse::Core::Commands, :AbstractHandler
      include_const ::Org::Eclipse::Core::Commands, :ExecutionEvent
      include_const ::Org::Eclipse::Core::Commands, :ExecutionException
      include_const ::Org::Eclipse::Core::Commands, :HandlerEvent
      include_const ::Org::Eclipse::Core::Commands, :IHandlerListener
      include_const ::Org::Eclipse::Jface::Action, :IAction
      include_const ::Org::Eclipse::Jface::Util, :IPropertyChangeListener
      include_const ::Org::Eclipse::Jface::Util, :PropertyChangeEvent
      include_const ::Org::Eclipse::Swt::Widgets, :Event
    }
  end
  
  # <p>
  # This class adapts instances of <code>IAction</code> to
  # <code>IHandler</code>.
  # </p>
  # 
  # @since 3.1
  class ActionHandler < ActionHandlerImports.const_get :AbstractHandler
    include_class_members ActionHandlerImports
    
    # The wrapped action. This value is never <code>null</code>.
    attr_accessor :action
    alias_method :attr_action, :action
    undef_method :action
    alias_method :attr_action=, :action=
    undef_method :action=
    
    # The property change listener hooked on to the action. This is initialized
    # when the first listener is attached to this handler, and is removed when
    # the handler is disposed or the last listener is removed.
    attr_accessor :property_change_listener
    alias_method :attr_property_change_listener, :property_change_listener
    undef_method :property_change_listener
    alias_method :attr_property_change_listener=, :property_change_listener=
    undef_method :property_change_listener=
    
    typesig { [IAction] }
    # Creates a new instance of this class given an instance of
    # <code>IAction</code>.
    # 
    # @param action
    # the action. Must not be <code>null</code>.
    def initialize(action)
      @action = nil
      @property_change_listener = nil
      super()
      if ((action).nil?)
        raise NullPointerException.new
      end
      @action = action
    end
    
    typesig { [IHandlerListener] }
    def add_handler_listener(handler_listener)
      if (!has_listeners)
        attach_listener
      end
      super(handler_listener)
    end
    
    typesig { [] }
    # When a listener is attached to this handler, then this registers a
    # listener with the underlying action.
    # 
    # @since 3.1
    def attach_listener
      if ((@property_change_listener).nil?)
        @property_change_listener = Class.new(IPropertyChangeListener.class == Class ? IPropertyChangeListener : Object) do
          extend LocalClass
          include_class_members ActionHandler
          include IPropertyChangeListener if IPropertyChangeListener.class == Module
          
          typesig { [PropertyChangeEvent] }
          define_method :property_change do |property_change_event|
            property = property_change_event.get_property
            fire_handler_changed(self.class::HandlerEvent.new(@local_class_parent, (IAction::ENABLED == property), (IAction::HANDLED == property)))
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self)
      end
      @action.add_property_change_listener(@property_change_listener)
    end
    
    typesig { [] }
    # When no more listeners are registered, then this is used to removed the
    # property change listener from the underlying action.
    def detach_listener
      @action.remove_property_change_listener(@property_change_listener)
      @property_change_listener = nil
    end
    
    typesig { [] }
    # Removes the property change listener from the action.
    # 
    # @see org.eclipse.core.commands.IHandler#dispose()
    def dispose
      if (has_listeners)
        @action.remove_property_change_listener(@property_change_listener)
      end
    end
    
    typesig { [ExecutionEvent] }
    def execute(event)
      if (((@action.get_style).equal?(IAction::AS_CHECK_BOX)) || ((@action.get_style).equal?(IAction::AS_RADIO_BUTTON)))
        @action.set_checked(!@action.is_checked)
      end
      trigger = event.get_trigger
      begin
        if (trigger.is_a?(Event))
          @action.run_with_event(trigger)
        else
          @action.run_with_event(Event.new)
        end
      rescue JavaException => e
        raise ExecutionException.new("While executing the action, an exception occurred", e) # $NON-NLS-1$
      end
      return nil
    end
    
    typesig { [] }
    # Returns the action associated with this handler
    # 
    # @return the action associated with this handler (not null)
    # @since 3.1
    def get_action
      return @action
    end
    
    typesig { [] }
    def is_enabled
      return @action.is_enabled
    end
    
    typesig { [] }
    def is_handled
      return @action.is_handled
    end
    
    typesig { [IHandlerListener] }
    def remove_handler_listener(handler_listener)
      super(handler_listener)
      if (!has_listeners)
        detach_listener
      end
    end
    
    typesig { [] }
    def to_s
      buffer = StringBuffer.new
      buffer.append("ActionHandler(") # $NON-NLS-1$
      buffer.append(@action)
      buffer.append(Character.new(?).ord))
      return buffer.to_s
    end
    
    private
    alias_method :initialize__action_handler, :initialize
  end
  
end
