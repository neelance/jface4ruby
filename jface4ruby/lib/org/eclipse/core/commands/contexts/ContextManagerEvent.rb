require "rjava"

# Copyright (c) 2003, 2005 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Core::Commands::Contexts
  module ContextManagerEventImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Commands::Contexts
      include_const ::Java::Util, :JavaSet
      include_const ::Org::Eclipse::Core::Commands::Common, :AbstractBitSetEvent
    }
  end
  
  # <p>
  # An event indicating that the set of defined context identifiers has changed.
  # </p>
  # 
  # @since 3.1
  # @see IContextManagerListener#contextManagerChanged(ContextManagerEvent)
  class ContextManagerEvent < ContextManagerEventImports.const_get :AbstractBitSetEvent
    include_class_members ContextManagerEventImports
    
    class_module.module_eval {
      # The bit used to represent whether the set of defined contexts has
      # changed.
      const_set_lazy(:CHANGED_CONTEXT_DEFINED) { 1 << 1 }
      const_attr_reader  :CHANGED_CONTEXT_DEFINED
      
      # The bit used to represent whether the set of active contexts has changed.
      const_set_lazy(:CHANGED_CONTEXTS_ACTIVE) { 1 }
      const_attr_reader  :CHANGED_CONTEXTS_ACTIVE
    }
    
    # The context identifier that was added or removed from the list of defined
    # context identifiers.
    attr_accessor :context_id
    alias_method :attr_context_id, :context_id
    undef_method :context_id
    alias_method :attr_context_id=, :context_id=
    undef_method :context_id=
    
    # The context manager that has changed.
    attr_accessor :context_manager
    alias_method :attr_context_manager, :context_manager
    undef_method :context_manager
    alias_method :attr_context_manager=, :context_manager=
    undef_method :context_manager=
    
    # The set of context identifiers (strings) that were active before the
    # change occurred. If the active contexts did not changed, then this value
    # is <code>null</code>.
    attr_accessor :previously_active_context_ids
    alias_method :attr_previously_active_context_ids, :previously_active_context_ids
    undef_method :previously_active_context_ids
    alias_method :attr_previously_active_context_ids=, :previously_active_context_ids=
    undef_method :previously_active_context_ids=
    
    typesig { [ContextManager, String, ::Java::Boolean, ::Java::Boolean, JavaSet] }
    # Creates a new instance of this class.
    # 
    # @param contextManager
    # the instance of the interface that changed; must not be
    # <code>null</code>.
    # @param contextId
    # The context identifier that was added or removed; may be
    # <code>null</code> if the active contexts are changing.
    # @param contextIdAdded
    # Whether the context identifier became defined (otherwise, it
    # became undefined).
    # @param activeContextsChanged
    # Whether the list of active contexts has changed.
    # @param previouslyActiveContextIds
    # the set of identifiers of previously active contexts. This set
    # may be empty. If this set is not empty, it must only contain
    # instances of <code>String</code>. This set must be
    # <code>null</code> if activeContextChanged is
    # <code>false</code> and must not be null if
    # activeContextChanged is <code>true</code>.
    def initialize(context_manager, context_id, context_id_added, active_contexts_changed, previously_active_context_ids)
      @context_id = nil
      @context_manager = nil
      @previously_active_context_ids = nil
      super()
      if ((context_manager).nil?)
        raise NullPointerException.new
      end
      @context_manager = context_manager
      @context_id = context_id
      @previously_active_context_ids = previously_active_context_ids
      if (context_id_added)
        self.attr_changed_values |= CHANGED_CONTEXT_DEFINED
      end
      if (active_contexts_changed)
        self.attr_changed_values |= CHANGED_CONTEXTS_ACTIVE
      end
    end
    
    typesig { [] }
    # Returns the context identifier that was added or removed.
    # 
    # @return The context identifier that was added or removed. This value may
    # be <code>null</code> if no context identifier was added or
    # removed.
    def get_context_id
      return @context_id
    end
    
    typesig { [] }
    # Returns the instance of the interface that changed.
    # 
    # @return the instance of the interface that changed. Guaranteed not to be
    # <code>null</code>.
    def get_context_manager
      return @context_manager
    end
    
    typesig { [] }
    # Returns the set of identifiers to previously active contexts.
    # 
    # @return the set of identifiers to previously active contexts. This set
    # may be empty. If this set is not empty, it is guaranteed to only
    # contain instances of <code>String</code>. This set is
    # guaranteed to be <code>null</code> if
    # haveActiveContextChanged() is <code>false</code> and is
    # guaranteed to not be <code>null</code> if
    # haveActiveContextsChanged() is <code>true</code>.
    def get_previously_active_context_ids
      return @previously_active_context_ids
    end
    
    typesig { [] }
    # Returns whether the active context identifiers have changed.
    # 
    # @return <code>true</code> if the collection of active contexts changed;
    # <code>false</code> otherwise.
    def is_active_contexts_changed
      return (!((self.attr_changed_values & CHANGED_CONTEXTS_ACTIVE)).equal?(0))
    end
    
    typesig { [] }
    # Returns whether the list of defined context identifiers has changed.
    # 
    # @return <code>true</code> if the list of context identifiers has
    # changed; <code>false</code> otherwise.
    def is_context_changed
      return (!(@context_id).nil?)
    end
    
    typesig { [] }
    # Returns whether the context identifier became defined. Otherwise, the
    # context identifier became undefined.
    # 
    # @return <code>true</code> if the context identifier became defined;
    # <code>false</code> if the context identifier became undefined.
    def is_context_defined
      return ((!((self.attr_changed_values & CHANGED_CONTEXT_DEFINED)).equal?(0)) && (!(@context_id).nil?))
    end
    
    private
    alias_method :initialize__context_manager_event, :initialize
  end
  
end
