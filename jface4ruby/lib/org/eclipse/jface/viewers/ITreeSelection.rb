require "rjava"

# Copyright (c) 2005, 2007 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Viewers
  module ITreeSelectionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
    }
  end
  
  # A selection containing tree paths.
  # <p>
  # It is recommended that clients do not implement this interface but instead
  # use the standard implementation of this interface, {@link TreeSelection}.
  # <code>TreeSelection</code> adds API for getting the {@link IElementComparer}
  # of a selection (if available). This is important for clients who want to
  # create a slightly modified tree selection based on an existing tree selection.
  # The recommended coding pattern in this case is as follows:
  # <pre>
  # ITreeSelection selection = (ITreeSelection)treeViewer.getSelection();
  # TreePath[] paths = selection.getPaths();
  # IElementComparer comparer = null;
  # if (selection instanceof TreeSelection) {
  # comparer = ((TreeSelection)selection).getElementComparer();
  # }
  # TreePath[] modifiedPaths = ... // modify as required
  # TreeSelection modifiedSelection = new TreeSelection(modifiedPaths, comparer);
  # </pre>
  # See bugs 135818 and 133375 for details.
  # </p>
  # 
  # @since 3.2
  module ITreeSelection
    include_class_members ITreeSelectionImports
    include IStructuredSelection
    
    typesig { [] }
    # Returns the paths in this selection
    # 
    # @return the paths in this selection
    def get_paths
      raise NotImplementedError
    end
    
    typesig { [Object] }
    # Returns the paths in this selection whose last segment is equal
    # to the given element
    # 
    # @param element the element to get the tree paths for
    # 
    # @return the array of tree paths
    def get_paths_for(element)
      raise NotImplementedError
    end
  end
  
end
