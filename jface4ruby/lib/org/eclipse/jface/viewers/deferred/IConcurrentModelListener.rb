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
  module IConcurrentModelListenerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers::Deferred
    }
  end
  
  # Interface for objects that can listen to changes in an IConcurrentModel.
  # Elements in an IConcurrentModel are unordered.
  # 
  # @since 3.1
  module IConcurrentModelListener
    include_class_members IConcurrentModelListenerImports
    
    typesig { [Array.typed(Object)] }
    # Called when elements are added to the model
    # 
    # @param added elements added to the model
    def add(added)
      raise NotImplementedError
    end
    
    typesig { [Array.typed(Object)] }
    # Called when elements are removed from the model
    # 
    # @param removed elements removed from the model
    def remove(removed)
      raise NotImplementedError
    end
    
    typesig { [Array.typed(Object)] }
    # Called when elements in the model have changed
    # 
    # @param changed elements that have changed
    def update(changed)
      raise NotImplementedError
    end
    
    typesig { [Array.typed(Object)] }
    # Notifies the receiver about the complete set
    # of elements in the model. Most models will
    # not call this method unless the listener explicitly
    # requests it by calling
    # <code>IConcurrentModel.requestUpdate</code>
    # 
    # @param newContents contents of the model
    def set_contents(new_contents)
      raise NotImplementedError
    end
  end
  
end
