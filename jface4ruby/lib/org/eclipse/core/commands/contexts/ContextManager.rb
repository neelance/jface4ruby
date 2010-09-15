require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Core::Commands::Contexts
  module ContextManagerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Commands::Contexts
      include_const ::Java::Util, :Collections
      include_const ::Java::Util, :HashSet
      include_const ::Java::Util, :JavaSet
      include_const ::Org::Eclipse::Core::Commands::Common, :HandleObjectManager
      include_const ::Org::Eclipse::Core::Commands::Util, :Tracing
      include_const ::Org::Eclipse::Core::Internal::Commands::Util, :Util
    }
  end
  
  # <p>
  # A context manager tracks the sets of defined and enabled contexts within the
  # application. The manager sends notification events to listeners when these
  # sets change. It is also possible to retrieve any given context with its
  # identifier.
  # </p>
  # <p>
  # This class is not intended to be extended by clients.
  # </p>
  # 
  # @since 3.1
  class ContextManager < ContextManagerImports.const_get :HandleObjectManager
    include_class_members ContextManagerImports
    overload_protected {
      include IContextListener
    }
    
    class_module.module_eval {
      # This flag can be set to <code>true</code> if the context manager should
      # print information to <code>System.out</code> when certain boundary
      # conditions occur.
      
      def debug
        defined?(@@debug) ? @@debug : @@debug= false
      end
      alias_method :attr_debug, :debug
      
      def debug=(value)
        @@debug = value
      end
      alias_method :attr_debug=, :debug=
    }
    
    # The set of active context identifiers. This value may be empty, but it is
    # never <code>null</code>.
    attr_accessor :active_context_ids
    alias_method :attr_active_context_ids, :active_context_ids
    undef_method :active_context_ids
    alias_method :attr_active_context_ids=, :active_context_ids=
    undef_method :active_context_ids=
    
    # allow the ContextManager to send one event for a larger delta
    attr_accessor :caching
    alias_method :attr_caching, :caching
    undef_method :caching
    alias_method :attr_caching=, :caching=
    undef_method :caching=
    
    attr_accessor :caching_ref
    alias_method :attr_caching_ref, :caching_ref
    undef_method :caching_ref
    alias_method :attr_caching_ref=, :caching_ref=
    undef_method :caching_ref=
    
    attr_accessor :active_contexts_change
    alias_method :attr_active_contexts_change, :active_contexts_change
    undef_method :active_contexts_change
    alias_method :attr_active_contexts_change=, :active_contexts_change=
    undef_method :active_contexts_change=
    
    attr_accessor :old_ids
    alias_method :attr_old_ids, :old_ids
    undef_method :old_ids
    alias_method :attr_old_ids=, :old_ids=
    undef_method :old_ids=
    
    typesig { [::Java::Boolean] }
    # Informs the manager that a batch operation has started.
    # <p>
    # <b>Note:</b> You must insure that if you call
    # <code>deferUpdates(true)</code> that nothing in your batched operation
    # will prevent the matching call to <code>deferUpdates(false)</code>.
    # </p>
    # 
    # @param defer
    # true when starting a batch operation false when ending the
    # operation
    # 
    # @since 3.5
    def defer_updates(defer)
      if (defer)
        @caching_ref += 1
        if ((@caching_ref).equal?(1))
          set_event_caching(true)
        end
      else
        @caching_ref -= 1
        if ((@caching_ref).equal?(0))
          set_event_caching(false)
        end
      end
    end
    
    typesig { [String] }
    # Activates a context in this context manager.
    # 
    # @param contextId
    # The identifier of the context to activate; must not be
    # <code>null</code>.
    def add_active_context(context_id)
      if (@active_context_ids.contains(context_id))
        return
      end
      @active_contexts_change = true
      if (@caching)
        @active_context_ids.add(context_id)
      else
        previously_active_context_ids = HashSet.new(@active_context_ids)
        @active_context_ids.add(context_id)
        fire_context_manager_changed(ContextManagerEvent.new(self, nil, false, true, previously_active_context_ids))
      end
      if (self.attr_debug)
        Tracing.print_trace("CONTEXTS", @active_context_ids.to_s) # $NON-NLS-1$
      end
    end
    
    typesig { [IContextManagerListener] }
    # Adds a listener to this context manager. The listener will be notified
    # when the set of defined contexts changes. This can be used to track the
    # global appearance and disappearance of contexts.
    # 
    # @param listener
    # The listener to attach; must not be <code>null</code>.
    def add_context_manager_listener(listener)
      add_listener_object(listener)
    end
    
    typesig { [ContextEvent] }
    def context_changed(context_event)
      if (context_event.is_defined_changed)
        context = context_event.get_context
        context_id = context.get_id
        context_id_added = context.is_defined
        if (context_id_added)
          self.attr_defined_handle_objects.add(context)
        else
          self.attr_defined_handle_objects.remove(context)
        end
        if (is_listener_attached)
          fire_context_manager_changed(ContextManagerEvent.new(self, context_id, context_id_added, false, nil))
        end
      end
    end
    
    typesig { [ContextManagerEvent] }
    # Notifies all of the listeners to this manager that the set of defined
    # context identifiers has changed.
    # 
    # @param event
    # The event to send to all of the listeners; must not be
    # <code>null</code>.
    def fire_context_manager_changed(event)
      if ((event).nil?)
        raise NullPointerException.new
      end
      listeners = get_listeners
      i = 0
      while i < listeners.attr_length
        listener = listeners[i]
        listener.context_manager_changed(event)
        i += 1
      end
    end
    
    typesig { [] }
    # Returns the set of active context identifiers.
    # 
    # @return The set of active context identifiers; this value may be
    # <code>null</code> if no active contexts have been set yet. If
    # the set is not <code>null</code>, then it contains only
    # instances of <code>String</code>.
    def get_active_context_ids
      return Collections.unmodifiable_set(@active_context_ids)
    end
    
    typesig { [String] }
    # Gets the context with the given identifier. If no such context currently
    # exists, then the context will be created (but be undefined).
    # 
    # @param contextId
    # The identifier to find; must not be <code>null</code>.
    # @return The context with the given identifier; this value will never be
    # <code>null</code>, but it might be undefined.
    # @see Context
    def get_context(context_id)
      check_id(context_id)
      context = self.attr_handle_objects_by_id.get(context_id)
      if ((context).nil?)
        context = Context.new(context_id)
        self.attr_handle_objects_by_id.put(context_id, context)
        context.add_context_listener(self)
      end
      return context
    end
    
    typesig { [] }
    # Returns the set of identifiers for those contexts that are defined.
    # 
    # @return The set of defined context identifiers; this value may be empty,
    # but it is never <code>null</code>.
    def get_defined_context_ids
      return get_defined_handle_object_ids
    end
    
    typesig { [] }
    # Returns the those contexts that are defined.
    # 
    # @return The defined contexts; this value may be empty, but it is never
    # <code>null</code>.
    # @since 3.2
    def get_defined_contexts
      return self.attr_defined_handle_objects.to_array(Array.typed(Context).new(self.attr_defined_handle_objects.size) { nil })
    end
    
    typesig { [String] }
    # Deactivates a context in this context manager.
    # 
    # @param contextId
    # The identifier of the context to deactivate; must not be
    # <code>null</code>.
    def remove_active_context(context_id)
      if (!@active_context_ids.contains(context_id))
        return
      end
      @active_contexts_change = true
      if (@caching)
        @active_context_ids.remove(context_id)
      else
        previously_active_context_ids = HashSet.new(@active_context_ids)
        @active_context_ids.remove(context_id)
        fire_context_manager_changed(ContextManagerEvent.new(self, nil, false, true, previously_active_context_ids))
      end
      if (self.attr_debug)
        Tracing.print_trace("CONTEXTS", @active_context_ids.to_s) # $NON-NLS-1$
      end
    end
    
    typesig { [IContextManagerListener] }
    # Removes a listener from this context manager.
    # 
    # @param listener
    # The listener to be removed; must not be <code>null</code>.
    def remove_context_manager_listener(listener)
      remove_listener_object(listener)
    end
    
    typesig { [JavaSet] }
    # Changes the set of active contexts for this context manager. The whole
    # set is required so that internal consistency can be maintained and so
    # that excessive recomputations do nothing occur.
    # 
    # @param activeContextIds
    # The new set of active context identifiers; may be
    # <code>null</code>.
    def set_active_context_ids(active_context_ids)
      if (Util.==(@active_context_ids, active_context_ids))
        return
      end
      @active_contexts_change = true
      previously_active_context_ids = @active_context_ids
      if (!(active_context_ids).nil?)
        @active_context_ids = HashSet.new
        @active_context_ids.add_all(active_context_ids)
      else
        @active_context_ids = nil
      end
      if (self.attr_debug)
        # $NON-NLS-1$ //$NON-NLS-2$
        Tracing.print_trace("CONTEXTS", ((active_context_ids).nil?) ? "none" : active_context_ids.to_s)
      end
      if (!@caching)
        fire_context_manager_changed(ContextManagerEvent.new(self, nil, false, true, previously_active_context_ids))
      end
    end
    
    typesig { [::Java::Boolean] }
    # Set the manager to cache context id changes.
    # 
    # @param cache
    # <code>true</code> to turn caching on, <code>false</code>
    # to turn caching off and send an event if necessary.
    # @since 3.3
    def set_event_caching(cache)
      if ((@caching).equal?(cache))
        return
      end
      @caching = cache
      fire_change = @active_contexts_change
      hold_old_ids = ((@old_ids).nil? ? Collections::EMPTY_SET : @old_ids)
      if (@caching)
        @old_ids = HashSet.new(@active_context_ids)
      else
        @old_ids = nil
      end
      @active_contexts_change = false
      if (!@caching && fire_change)
        fire_context_manager_changed(ContextManagerEvent.new(self, nil, false, true, hold_old_ids))
      end
    end
    
    typesig { [] }
    def initialize
      @active_context_ids = nil
      @caching = false
      @caching_ref = 0
      @active_contexts_change = false
      @old_ids = nil
      super()
      @active_context_ids = HashSet.new
      @caching = false
      @caching_ref = 0
      @active_contexts_change = false
      @old_ids = nil
    end
    
    private
    alias_method :initialize__context_manager, :initialize
  end
  
end
