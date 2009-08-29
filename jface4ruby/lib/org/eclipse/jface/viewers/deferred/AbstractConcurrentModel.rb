require "rjava"

# Copyright (c) 2004, 2005 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Viewers::Deferred
  module AbstractConcurrentModelImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers::Deferred
      include_const ::Org::Eclipse::Core::Runtime, :ListenerList
    }
  end
  
  # Abstract base class for all IConcurrentModel implementations. Clients should
  # subclass this class instead of implementing IConcurrentModel directly.
  # 
  # @since 3.1
  class AbstractConcurrentModel 
    include_class_members AbstractConcurrentModelImports
    include IConcurrentModel
    
    attr_accessor :listeners
    alias_method :attr_listeners, :listeners
    undef_method :listeners
    alias_method :attr_listeners=, :listeners=
    undef_method :listeners=
    
    typesig { [IConcurrentModelListener] }
    # (non-Javadoc)
    # @see org.eclipse.jface.viewers.deferred.IConcurrentContentProvider#addListener(org.eclipse.jface.viewers.deferred.IConcurrentContentProviderListener)
    def add_listener(listener)
      @listeners.add(listener)
    end
    
    typesig { [Array.typed(Object)] }
    # Fires an add notification to all listeners
    # 
    # @param added objects added to the set
    def fire_add(added)
      listener_array = @listeners.get_listeners
      i = 0
      while i < listener_array.attr_length
        next_ = listener_array[i]
        next_.add(added)
        i += 1
      end
    end
    
    typesig { [Array.typed(Object)] }
    # Fires a remove notification to all listeners
    # 
    # @param removed objects removed from the set
    def fire_remove(removed)
      listener_array = @listeners.get_listeners
      i = 0
      while i < listener_array.attr_length
        next_ = listener_array[i]
        next_.remove(removed)
        i += 1
      end
    end
    
    typesig { [Array.typed(Object)] }
    # Fires an update notification to all listeners
    # 
    # @param updated objects that have changed
    def fire_update(updated)
      listener_array = @listeners.get_listeners
      i = 0
      while i < listener_array.attr_length
        next_ = listener_array[i]
        next_.update(updated)
        i += 1
      end
    end
    
    typesig { [] }
    # Returns the array of listeners for this model
    # 
    # @return the array of listeners for this model
    def get_listeners
      l = @listeners.get_listeners
      result = Array.typed(IConcurrentModelListener).new(l.attr_length) { nil }
      i = 0
      while i < l.attr_length
        result[i] = l[i]
        i += 1
      end
      return result
    end
    
    typesig { [IConcurrentModelListener] }
    # (non-Javadoc)
    # @see org.eclipse.jface.viewers.deferred.IConcurrentContentProvider#removeListener(org.eclipse.jface.viewers.deferred.IConcurrentContentProviderListener)
    def remove_listener(listener)
      @listeners.remove(listener)
    end
    
    typesig { [] }
    def initialize
      @listeners = ListenerList.new
    end
    
    private
    alias_method :initialize__abstract_concurrent_model, :initialize
  end
  
end
