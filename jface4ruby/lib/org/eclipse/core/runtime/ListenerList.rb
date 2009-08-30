require "rjava"

# Copyright (c) 2004, 2007 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Core::Runtime
  module ListenerListImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Runtime
    }
  end
  
  # This class is a thread safe list that is designed for storing lists of listeners.
  # The implementation is optimized for minimal memory footprint, frequent reads
  # and infrequent writes.  Modification of the list is synchronized and relatively
  # expensive, while accessing the listeners is very fast.  Readers are given access
  # to the underlying array data structure for reading, with the trust that they will
  # not modify the underlying array.
  # <p>
  # <a name="same">A listener list handles the <i>same</i> listener being added
  # multiple times, and tolerates removal of listeners that are the same as other
  # listeners in the list.  For this purpose, listeners can be compared with each other
  # using either equality or identity, as specified in the list constructor.
  # </p>
  # <p>
  # Use the <code>getListeners</code> method when notifying listeners. The recommended
  # code sequence for notifying all registered listeners of say,
  # <code>FooListener.eventHappened</code>, is:
  # 
  # <pre>
  # Object[] listeners = myListenerList.getListeners();
  # for (int i = 0; i &lt; listeners.length; ++i) {
  # ((FooListener) listeners[i]).eventHappened(event);
  # }
  # </pre>
  # 
  # </p><p>
  # This class can be used without OSGi running.
  # </p>
  # @since org.eclipse.equinox.common 3.2
  class ListenerList 
    include_class_members ListenerListImports
    
    class_module.module_eval {
      # The empty array singleton instance.
      const_set_lazy(:EmptyArray) { Array.typed(Object).new(0) { nil } }
      const_attr_reader  :EmptyArray
      
      # Mode constant (value 0) indicating that listeners should be considered
      # the <a href="#same">same</a> if they are equal.
      const_set_lazy(:EQUALITY) { 0 }
      const_attr_reader  :EQUALITY
      
      # Mode constant (value 1) indicating that listeners should be considered
      # the <a href="#same">same</a> if they are identical.
      const_set_lazy(:IDENTITY) { 1 }
      const_attr_reader  :IDENTITY
    }
    
    # Indicates the comparison mode used to determine if two
    # listeners are equivalent
    attr_accessor :identity
    alias_method :attr_identity, :identity
    undef_method :identity
    alias_method :attr_identity=, :identity=
    undef_method :identity=
    
    # The list of listeners.  Initially empty but initialized
    # to an array of size capacity the first time a listener is added.
    # Maintains invariant: listeners != null
    attr_accessor :listeners
    alias_method :attr_listeners, :listeners
    undef_method :listeners
    alias_method :attr_listeners=, :listeners=
    undef_method :listeners=
    
    typesig { [] }
    # Creates a listener list in which listeners are compared using equality.
    def initialize
      initialize__listener_list(EQUALITY)
    end
    
    typesig { [::Java::Int] }
    # Creates a listener list using the provided comparison mode.
    # 
    # @param mode The mode used to determine if listeners are the <a href="#same">same</a>.
    def initialize(mode)
      @identity = false
      @listeners = EmptyArray
      if (!(mode).equal?(EQUALITY) && !(mode).equal?(IDENTITY))
        raise IllegalArgumentException.new
      end
      @identity = (mode).equal?(IDENTITY)
    end
    
    typesig { [Object] }
    # Adds a listener to this list. This method has no effect if the <a href="#same">same</a>
    # listener is already registered.
    # 
    # @param listener the non-<code>null</code> listener to add
    def add(listener)
      synchronized(self) do
        # This method is synchronized to protect against multiple threads adding
        # or removing listeners concurrently. This does not block concurrent readers.
        if ((listener).nil?)
          raise IllegalArgumentException.new
        end
        # check for duplicates
        old_size = @listeners.attr_length
        i = 0
        while i < old_size
          listener2 = @listeners[i]
          if (@identity ? (listener).equal?(listener2) : (listener == listener2))
            return
          end
          (i += 1)
        end
        # Thread safety: create new array to avoid affecting concurrent readers
        new_listeners = Array.typed(Object).new(old_size + 1) { nil }
        System.arraycopy(@listeners, 0, new_listeners, 0, old_size)
        new_listeners[old_size] = listener
        # atomic assignment
        @listeners = new_listeners
      end
    end
    
    typesig { [] }
    # Returns an array containing all the registered listeners.
    # The resulting array is unaffected by subsequent adds or removes.
    # If there are no listeners registered, the result is an empty array.
    # Use this method when notifying listeners, so that any modifications
    # to the listener list during the notification will have no effect on
    # the notification itself.
    # <p>
    # Note: Callers of this method <b>must not</b> modify the returned array.
    # 
    # @return the list of registered listeners
    def get_listeners
      return @listeners
    end
    
    typesig { [] }
    # Returns whether this listener list is empty.
    # 
    # @return <code>true</code> if there are no registered listeners, and
    # <code>false</code> otherwise
    def is_empty
      return (@listeners.attr_length).equal?(0)
    end
    
    typesig { [Object] }
    # Removes a listener from this list. Has no effect if the <a href="#same">same</a>
    # listener was not already registered.
    # 
    # @param listener the non-<code>null</code> listener to remove
    def remove(listener)
      synchronized(self) do
        # This method is synchronized to protect against multiple threads adding
        # or removing listeners concurrently. This does not block concurrent readers.
        if ((listener).nil?)
          raise IllegalArgumentException.new
        end
        old_size = @listeners.attr_length
        i = 0
        while i < old_size
          listener2 = @listeners[i]
          if (@identity ? (listener).equal?(listener2) : (listener == listener2))
            if ((old_size).equal?(1))
              @listeners = EmptyArray
            else
              # Thread safety: create new array to avoid affecting concurrent readers
              new_listeners = Array.typed(Object).new(old_size - 1) { nil }
              System.arraycopy(@listeners, 0, new_listeners, 0, i)
              System.arraycopy(@listeners, i + 1, new_listeners, i, old_size - i - 1)
              # atomic assignment to field
              @listeners = new_listeners
            end
            return
          end
          (i += 1)
        end
      end
    end
    
    typesig { [] }
    # Returns the number of registered listeners.
    # 
    # @return the number of registered listeners
    def size
      return @listeners.attr_length
    end
    
    typesig { [] }
    # Removes all listeners from this list.
    def clear
      synchronized(self) do
        @listeners = EmptyArray
      end
    end
    
    private
    alias_method :initialize__listener_list, :initialize
  end
  
end
