require "rjava"

# Copyright (c) 2000, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Viewers
  module ISelectionProviderImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
    }
  end
  
  # Interface common to all objects that provide a selection.
  # 
  # @see ISelection
  # @see ISelectionChangedListener
  # @see SelectionChangedEvent
  module ISelectionProvider
    include_class_members ISelectionProviderImports
    
    typesig { [ISelectionChangedListener] }
    # Adds a listener for selection changes in this selection provider.
    # Has no effect if an identical listener is already registered.
    # 
    # @param listener a selection changed listener
    def add_selection_changed_listener(listener)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the current selection for this provider.
    # 
    # @return the current selection
    def get_selection
      raise NotImplementedError
    end
    
    typesig { [ISelectionChangedListener] }
    # Removes the given selection change listener from this selection provider.
    # Has no affect if an identical listener is not registered.
    # 
    # @param listener a selection changed listener
    def remove_selection_changed_listener(listener)
      raise NotImplementedError
    end
    
    typesig { [ISelection] }
    # Sets the current selection for this selection provider.
    # 
    # @param selection the new selection
    def set_selection(selection)
      raise NotImplementedError
    end
  end
  
end
