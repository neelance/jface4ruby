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
  module ISelectionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
    }
  end
  
  # Interface for a selection.
  # 
  # @see ISelectionProvider
  # @see ISelectionChangedListener
  # @see SelectionChangedEvent
  module ISelection
    include_class_members ISelectionImports
    
    typesig { [] }
    # Returns whether this selection is empty.
    # 
    # @return <code>true</code> if this selection is empty,
    # and <code>false</code> otherwise
    def is_empty
      raise NotImplementedError
    end
  end
  
end
