require "rjava"

# Copyright (c) 2000, 2007 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Viewers
  module ICheckableImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
    }
  end
  
  # Interface for objects that support elements with a checked state.
  # 
  # @see ICheckStateListener
  # @see CheckStateChangedEvent
  module ICheckable
    include_class_members ICheckableImports
    
    typesig { [ICheckStateListener] }
    # Adds a listener for changes to the checked state of elements
    # in this viewer.
    # Has no effect if an identical listener is already registered.
    # 
    # @param listener a check state listener
    def add_check_state_listener(listener)
      raise NotImplementedError
    end
    
    typesig { [Object] }
    # Returns the checked state of the given element.
    # 
    # @param element the element
    # @return <code>true</code> if the element is checked,
    # and <code>false</code> if not checked
    def get_checked(element)
      raise NotImplementedError
    end
    
    typesig { [ICheckStateListener] }
    # Removes the given check state listener from this viewer.
    # Has no effect if an identical listener is not registered.
    # 
    # @param listener a check state listener
    def remove_check_state_listener(listener)
      raise NotImplementedError
    end
    
    typesig { [Object, ::Java::Boolean] }
    # Sets the checked state for the given element in this viewer.
    # Does not fire events to check state listeners.
    # 
    # @param element the element
    # @param state <code>true</code> if the item should be checked,
    # and <code>false</code> if it should be unchecked
    # @return <code>true</code> if the checked state could be set,
    # and <code>false</code> otherwise
    def set_checked(element, state)
      raise NotImplementedError
    end
  end
  
end
