require "rjava"

# Copyright (c) 2005, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Viewers
  module ILazyTreePathContentProviderImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
    }
  end
  
  # The ILazyTreePathContentProvider is a tree path-based content provider for
  # tree viewers created using the SWT.VIRTUAL flag that only wish to return
  # their contents as they are queried.
  # 
  # @since 3.3
  module ILazyTreePathContentProvider
    include_class_members ILazyTreePathContentProviderImports
    include IContentProvider
    
    typesig { [TreePath, ::Java::Int] }
    # Called when a previously-blank item becomes visible in the TreeViewer. If
    # the content provider knows the child element for the given parent at this
    # index, it should respond by calling
    # {@link TreeViewer#replace(Object, int, Object)}. The content provider
    # should also update the child count for any replaced element by calling
    # {@link TreeViewer#setChildCount(Object, int)}. If the given current child
    # count is already correct, setChildCount does not have to be called since
    # a call to replace will not change the child count.
    # 
    # <strong>NOTE</strong> #updateElement(int index) can be used to determine
    # selection values. If TableViewer#replace(Object, int) is not called
    # before returning from this method, selections may have missing or stale
    # elements. In this situation it is suggested that the selection is asked
    # for again after replace() has been called.
    # 
    # @param parentPath
    # The tree path of parent of the element, or if the
    # element to update is a root element, an empty tree path
    # @param index
    # The index of the element to update in the tree
    def update_element(parent_path, index)
      raise NotImplementedError
    end
    
    typesig { [TreePath, ::Java::Int] }
    # Called when the TreeViewer needs an up-to-date child count for the given
    # tree path, for example from {@link TreeViewer#refresh()} and
    # {@link TreeViewer#setInput(Object)}. If the content provider knows the
    # element at the given tree path, it should respond by calling
    # {@link TreeViewer#setChildCount(Object, int)}. If the given current
    # child count is already correct, no action has to be taken by this content
    # provider.
    # 
    # @param treePath
    # The tree path for which an up-to-date child count is needed, or
    # if the number of root elements is requested, the empty tree path
    # @param currentChildCount
    # The current child count for the element that needs updating
    def update_child_count(tree_path, current_child_count)
      raise NotImplementedError
    end
    
    typesig { [TreePath] }
    # Called when the TreeViewer needs up-to-date information whether the node
    # at the given tree path can be expanded. If the content provider knows the
    # element at the given tree path, it should respond by calling
    # {@link TreeViewer#setHasChildren(Object, boolean)}. The content provider
    # may also choose to call {@link TreeViewer#setChildCount(Object, int)}
    # instead if it knows the number of children.
    # 
    # <p>
    # Intended as an optimization for when the viewer does not need the actual
    # children. Clients may be able to implement this more efficiently than
    # <code>updateChildCount</code>.
    # </p>
    # 
    # @param path
    # The tree path for which up-to-date information about children
    # is needed
    def update_has_children(path)
      raise NotImplementedError
    end
    
    typesig { [Object] }
    # Return the possible parent paths for the given element. An empty array
    # can be returned if the paths cannot be computed. In this case the
    # tree-structured viewer can't expand a given node correctly if requested.
    # If the element is a potential child of the input of the viewer, an empty
    # tree path should be an entry in the returned array.
    # 
    # @param element
    # the element
    # @return the possible parent paths for the given element
    def get_parents(element)
      raise NotImplementedError
    end
  end
  
end
