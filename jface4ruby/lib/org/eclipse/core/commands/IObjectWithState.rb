require "rjava"

# Copyright (c) 2005, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Core::Commands
  module IObjectWithStateImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Commands
    }
  end
  
  # <p>
  # An object that holds zero or more state objects. This state information can
  # be shared between different instances of <code>IObjectWithState</code>.
  # </p>
  # <p>
  # Clients may implement, but must not extend this interface.
  # </p>
  # 
  # @see AbstractHandlerWithState
  # @since 3.2
  module IObjectWithState
    include_class_members IObjectWithStateImports
    
    typesig { [String, State] }
    # Adds state to this object.
    # 
    # @param id
    # The identifier indicating the type of state being added; must
    # not be <code>null</code>.
    # @param state
    # The new state to add to this object; must not be
    # <code>null</code>.
    def add_state(id, state)
      raise NotImplementedError
    end
    
    typesig { [String] }
    # Gets the state with the given id.
    # 
    # @param stateId
    # The identifier of the state to retrieve; must not be
    # <code>null</code>.
    # @return The state; may be <code>null</code> if there is no state with
    # the given id.
    def get_state(state_id)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Gets the identifiers for all of the state associated with this object.
    # 
    # @return All of the state identifiers; may be empty, but never
    # <code>null</code>.
    def get_state_ids
      raise NotImplementedError
    end
    
    typesig { [String] }
    # Removes state from this object.
    # 
    # @param stateId
    # The id of the state to remove from this object; must not be
    # <code>null</code>.
    def remove_state(state_id)
      raise NotImplementedError
    end
  end
  
end
