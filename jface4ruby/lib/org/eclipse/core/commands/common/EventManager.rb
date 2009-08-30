require "rjava"

# Copyright (c) 2005, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Core::Commands::Common
  module EventManagerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Commands::Common
      include_const ::Org::Eclipse::Core::Runtime, :ListenerList
    }
  end
  
  # <p>
  # A manager to which listeners can be attached. This handles the management of
  # a list of listeners -- optimizing memory and performance. All the methods on
  # this class are guaranteed to be thread-safe.
  # </p>
  # <p>
  # Clients may extend.
  # </p>
  # 
  # @since 3.2
  class EventManager 
    include_class_members EventManagerImports
    
    class_module.module_eval {
      # An empty array that can be returned from a call to
      # {@link #getListeners()} when {@link #listenerList} is <code>null</code>.
      const_set_lazy(:EMPTY_ARRAY) { Array.typed(Object).new(0) { nil } }
      const_attr_reader  :EMPTY_ARRAY
    }
    
    # A collection of objects listening to changes to this manager. This
    # collection is <code>null</code> if there are no listeners.
    attr_accessor :listener_list
    alias_method :attr_listener_list, :listener_list
    undef_method :listener_list
    alias_method :attr_listener_list=, :listener_list=
    undef_method :listener_list=
    
    typesig { [Object] }
    # Adds a listener to this manager that will be notified when this manager's
    # state changes.
    # 
    # @param listener
    # The listener to be added; must not be <code>null</code>.
    def add_listener_object(listener)
      synchronized(self) do
        if ((@listener_list).nil?)
          @listener_list = ListenerList.new(ListenerList::IDENTITY)
        end
        @listener_list.add(listener)
      end
    end
    
    typesig { [] }
    # Clears all of the listeners from the listener list.
    def clear_listeners
      synchronized(self) do
        if (!(@listener_list).nil?)
          @listener_list.clear
        end
      end
    end
    
    typesig { [] }
    # Returns the listeners attached to this event manager.
    # 
    # @return The listeners currently attached; may be empty, but never
    # <code>null</code>
    def get_listeners
      list = @listener_list
      if ((list).nil?)
        return EMPTY_ARRAY
      end
      return list.get_listeners
    end
    
    typesig { [] }
    # Whether one or more listeners are attached to the manager.
    # 
    # @return <code>true</code> if listeners are attached to the manager;
    # <code>false</code> otherwise.
    def is_listener_attached
      return !(@listener_list).nil?
    end
    
    typesig { [Object] }
    # Removes a listener from this manager.
    # 
    # @param listener
    # The listener to be removed; must not be <code>null</code>.
    def remove_listener_object(listener)
      synchronized(self) do
        if (!(@listener_list).nil?)
          @listener_list.remove(listener)
          if (@listener_list.is_empty)
            @listener_list = nil
          end
        end
      end
    end
    
    typesig { [] }
    def initialize
      @listener_list = nil
    end
    
    private
    alias_method :initialize__event_manager, :initialize
  end
  
end
