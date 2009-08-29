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
  module ITreeViewerListenerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
    }
  end
  
  # A listener which is notified when a tree viewer expands or collapses
  # a node.
  module ITreeViewerListener
    include_class_members ITreeViewerListenerImports
    
    typesig { [TreeExpansionEvent] }
    # Notifies that a node in the tree has been collapsed.
    # 
    # @param event event object describing details
    def tree_collapsed(event)
      raise NotImplementedError
    end
    
    typesig { [TreeExpansionEvent] }
    # Notifies that a node in the tree has been expanded.
    # 
    # @param event event object describing details
    def tree_expanded(event)
      raise NotImplementedError
    end
  end
  
end
