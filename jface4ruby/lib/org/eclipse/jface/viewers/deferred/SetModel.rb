require "rjava"

# Copyright (c) 2004, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Viewers::Deferred
  module SetModelImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers::Deferred
      include_const ::Java::Util, :Collection
      include_const ::Java::Util, :HashSet
      include_const ::Org::Eclipse::Core::Runtime, :Assert
    }
  end
  
  # Trivial implementation of an <code>IConcurrentModel</code>. Implements
  # an unordered set of elements that fires off change notifications whenever
  # elements are added or removed from the set. All notifications are sent
  # synchronously.
  # 
  # @since 3.1
  class SetModel < SetModelImports.const_get :AbstractConcurrentModel
    include_class_members SetModelImports
    
    attr_accessor :data
    alias_method :attr_data, :data
    undef_method :data
    alias_method :attr_data=, :data=
    undef_method :data=
    
    typesig { [] }
    # Return the contents of the model.
    # @return the array of elements
    def get_elements
      return @data.to_array
    end
    
    typesig { [Array.typed(Object)] }
    # Sets the contents to the given array of elements
    # 
    # @param newContents new contents of this set
    def set(new_contents)
      Assert.is_not_null(new_contents)
      @data.clear
      i = 0
      while i < new_contents.attr_length
        object = new_contents[i]
        @data.add(object)
        i += 1
      end
      listeners = get_listeners
      i_ = 0
      while i_ < listeners.attr_length
        listener = listeners[i_]
        listener.set_contents(new_contents)
        i_ += 1
      end
    end
    
    typesig { [] }
    # Empties the set
    def clear
      removed = @data.to_array
      @data.clear
      fire_remove(removed)
    end
    
    typesig { [Array.typed(Object)] }
    # Adds the given elements to the set
    # 
    # @param toAdd elements to add
    def add_all(to_add)
      Assert.is_not_null(to_add)
      i = 0
      while i < to_add.attr_length
        object = to_add[i]
        @data.add(object)
        i += 1
      end
      fire_add(to_add)
    end
    
    typesig { [Collection] }
    # Adds the given elements to the set. Duplicate elements are ignored.
    # 
    # @param toAdd elements to add
    def add_all(to_add)
      Assert.is_not_null(to_add)
      add_all(to_add.to_array)
    end
    
    typesig { [Array.typed(Object)] }
    # Fires a change notification for all elements in the given array
    # 
    # @param changed array of elements that have changed
    def change_all(changed)
      Assert.is_not_null(changed)
      fire_update(changed)
    end
    
    typesig { [Array.typed(Object)] }
    # Removes all of the given elements from the set.
    # 
    # @param toRemove elements to remove
    def remove_all(to_remove)
      Assert.is_not_null(to_remove)
      i = 0
      while i < to_remove.attr_length
        object = to_remove[i]
        @data.remove(object)
        i += 1
      end
      fire_remove(to_remove)
    end
    
    typesig { [IConcurrentModelListener] }
    # (non-Javadoc)
    # @see org.eclipse.jface.viewers.deferred.IConcurrentModel#requestUpdate(org.eclipse.jface.viewers.deferred.IConcurrentModelListener)
    def request_update(listener)
      Assert.is_not_null(listener)
      listener.set_contents(get_elements)
    end
    
    typesig { [] }
    def initialize
      @data = nil
      super()
      @data = HashSet.new
    end
    
    private
    alias_method :initialize__set_model, :initialize
  end
  
end
