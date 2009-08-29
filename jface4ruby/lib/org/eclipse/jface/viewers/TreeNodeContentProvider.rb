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
  module TreeNodeContentProviderImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
    }
  end
  
  # <p>
  # A content provider that expects every element to be a <code>TreeNode</code>.
  # Most methods delegate to <code>TreeNode</code>. <code>dispose()</code>
  # and <code>inputChanged(Viewer, Object, Object)</code> do nothing by
  # default.
  # </p>
  # <p>
  # This class and all of its methods may be overridden or extended.
  # </p>
  # 
  # @since 3.2
  # @see org.eclipse.jface.viewers.TreeNode
  class TreeNodeContentProvider 
    include_class_members TreeNodeContentProviderImports
    include ITreeContentProvider
    
    typesig { [] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.viewers.IContentProvider#dispose()
    def dispose
      # Do nothing
    end
    
    typesig { [Object] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.viewers.ITreeContentProvider#getChildren(java.lang.Object)
    def get_children(parent_element)
      node = parent_element
      return node.get_children
    end
    
    typesig { [Object] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.viewers.IStructuredContentProvider#getElements(java.lang.Object)
    def get_elements(input_element)
      if (input_element.is_a?(Array.typed(TreeNode)))
        return input_element
      end
      return Array.typed(Object).new(0) { nil }
    end
    
    typesig { [Object] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.viewers.ITreeContentProvider#getParent(java.lang.Object)
    def get_parent(element)
      node = element
      return node.get_parent
    end
    
    typesig { [Object] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.viewers.ITreeContentProvider#hasChildren(java.lang.Object)
    def has_children(element)
      node = element
      return node.has_children
    end
    
    typesig { [Viewer, Object, Object] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.viewers.IContentProvider#inputChanged(org.eclipse.jface.viewers.Viewer,
    # java.lang.Object, java.lang.Object)
    def input_changed(viewer, old_input, new_input)
      # Do nothing
    end
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__tree_node_content_provider, :initialize
  end
  
end
