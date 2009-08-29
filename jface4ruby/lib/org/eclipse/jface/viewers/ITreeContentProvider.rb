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
  module ITreeContentProviderImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
    }
  end
  
  # An interface to content providers for tree-structure-oriented
  # viewers.
  # 
  # @see AbstractTreeViewer
  module ITreeContentProvider
    include_class_members ITreeContentProviderImports
    include IStructuredContentProvider
    
    typesig { [Object] }
    # Returns the child elements of the given parent element.
    # <p>
    # The difference between this method and <code>IStructuredContentProvider.getElements</code>
    # is that <code>getElements</code> is called to obtain the
    # tree viewer's root elements, whereas <code>getChildren</code> is used
    # to obtain the children of a given parent element in the tree (including a root).
    # </p>
    # The result is not modified by the viewer.
    # 
    # @param parentElement the parent element
    # @return an array of child elements
    def get_children(parent_element)
      raise NotImplementedError
    end
    
    typesig { [Object] }
    # Returns the parent for the given element, or <code>null</code>
    # indicating that the parent can't be computed.
    # In this case the tree-structured viewer can't expand
    # a given node correctly if requested.
    # 
    # @param element the element
    # @return the parent element, or <code>null</code> if it
    # has none or if the parent cannot be computed
    def get_parent(element)
      raise NotImplementedError
    end
    
    typesig { [Object] }
    # Returns whether the given element has children.
    # <p>
    # Intended as an optimization for when the viewer does not
    # need the actual children.  Clients may be able to implement
    # this more efficiently than <code>getChildren</code>.
    # </p>
    # 
    # @param element the element
    # @return <code>true</code> if the given element has children,
    # and <code>false</code> if it has no children
    def has_children(element)
      raise NotImplementedError
    end
  end
  
end
