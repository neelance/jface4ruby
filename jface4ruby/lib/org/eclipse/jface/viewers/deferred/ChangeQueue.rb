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
  module ChangeQueueImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers::Deferred
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :LinkedList
    }
  end
  
  # Holds a queue of additions, removals, updates, and SET calls for a
  # BackgroundContentProvider
  class ChangeQueue 
    include_class_members ChangeQueueImports
    
    class_module.module_eval {
      # Represents the addition of an item
      # @since 3.1
      const_set_lazy(:ADD) { 0 }
      const_attr_reader  :ADD
      
      # Represents the removal of an item
      # @since 3.1
      const_set_lazy(:REMOVE) { 1 }
      const_attr_reader  :REMOVE
      
      # Represents a reset of all the items
      # @since 3.1
      const_set_lazy(:SET) { 2 }
      const_attr_reader  :SET
      
      # Represents an update of an item
      # @since 3.1
      const_set_lazy(:UPDATE) { 3 }
      const_attr_reader  :UPDATE
      
      # @since 3.1
      const_set_lazy(:Change) { Class.new do
        include_class_members ChangeQueue
        
        attr_accessor :type
        alias_method :attr_type, :type
        undef_method :type
        alias_method :attr_type=, :type=
        undef_method :type=
        
        attr_accessor :elements
        alias_method :attr_elements, :elements
        undef_method :elements
        alias_method :attr_elements=, :elements=
        undef_method :elements=
        
        typesig { [::Java::Int, Array.typed(Object)] }
        # Create a change of the specified type that affects the given elements.
        # 
        # @param type one of <code>ADD</code>, <code>REMOVE</code>, <code>SET</code>, or <code>UPDATE</code>.
        # @param elements the elements affected by the change.
        # 
        # @since 3.1
        def initialize(type, elements)
          @type = 0
          @elements = nil
          @type = type
          @elements = elements
        end
        
        typesig { [] }
        # Get the type of change.
        # @return one of <code>ADD</code>, <code>REMOVE</code>, <code>SET</code>, or <code>UPDATE</code>.
        # 
        # @since 3.1
        def get_type
          return @type
        end
        
        typesig { [] }
        # Return the elements associated with the change.
        # @return the elements affected by the change.
        # 
        # @since 3.1
        def get_elements
          return @elements
        end
        
        private
        alias_method :initialize__change, :initialize
      end }
    }
    
    attr_accessor :queue
    alias_method :attr_queue, :queue
    undef_method :queue
    alias_method :attr_queue=, :queue=
    undef_method :queue=
    
    attr_accessor :workload
    alias_method :attr_workload, :workload
    undef_method :workload
    alias_method :attr_workload=, :workload=
    undef_method :workload=
    
    typesig { [::Java::Int, Array.typed(Object)] }
    # Create a change of the given type and elements and enqueue it.
    # 
    # @param type the type of change to be created
    # @param elements the elements affected by the change
    def enqueue(type, elements)
      synchronized(self) do
        enqueue(Change.new(type, elements))
      end
    end
    
    typesig { [Change] }
    # Add the specified change to the queue
    # @param toQueue the change to be added
    def enqueue(to_queue)
      synchronized(self) do
        # A SET event makes all previous adds, removes, and sets redundant... so remove
        # them from the queue
        if ((to_queue.attr_type).equal?(SET))
          @workload = 0
          new_queue = LinkedList.new
          iter = @queue.iterator
          while iter.has_next
            next__ = iter.next_
            if ((next__.get_type).equal?(ADD) || (next__.get_type).equal?(REMOVE) || (next__.get_type).equal?(SET))
              next
            end
            new_queue.add(next__)
            @workload += next__.attr_elements.attr_length
          end
          @queue = new_queue
        end
        @queue.add(to_queue)
        @workload += to_queue.attr_elements.attr_length
      end
    end
    
    typesig { [] }
    # Remove the first change from the queue.
    # @return the first change
    def dequeue
      synchronized(self) do
        result = @queue.remove_first
        @workload -= result.attr_elements.attr_length
        return result
      end
    end
    
    typesig { [] }
    # Return whether the queue is empty
    # @return <code>true</code> if empty, <code>false</code> otherwise
    def is_empty
      synchronized(self) do
        return @queue.is_empty
      end
    end
    
    typesig { [] }
    def initialize
      @queue = LinkedList.new
      @workload = 0
    end
    
    private
    alias_method :initialize__change_queue, :initialize
  end
  
end
