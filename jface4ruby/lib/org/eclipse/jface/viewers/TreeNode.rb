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
  module TreeNodeImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
      include_const ::Org::Eclipse::Jface::Util, :Util
    }
  end
  
  # A simple data structure that is useful for implemented tree models. This can
  # be returned by
  # {@link org.eclipse.jface.viewers.IStructuredContentProvider#getElements(Object)}.
  # It allows simple delegation of methods from
  # {@link org.eclipse.jface.viewers.ITreeContentProvider} such as
  # {@link org.eclipse.jface.viewers.ITreeContentProvider#getChildren(Object)},
  # {@link org.eclipse.jface.viewers.ITreeContentProvider#getParent(Object)} and
  # {@link org.eclipse.jface.viewers.ITreeContentProvider#hasChildren(Object)}
  # 
  # @since 3.2
  class TreeNode 
    include_class_members TreeNodeImports
    
    # The array of child tree nodes for this tree node. If there are no
    # children, then this value may either by an empty array or
    # <code>null</code>. There should be no <code>null</code> children in
    # the array.
    attr_accessor :children
    alias_method :attr_children, :children
    undef_method :children
    alias_method :attr_children=, :children=
    undef_method :children=
    
    # The parent tree node for this tree node. This value may be
    # <code>null</code> if there is no parent.
    attr_accessor :parent
    alias_method :attr_parent, :parent
    undef_method :parent
    alias_method :attr_parent=, :parent=
    undef_method :parent=
    
    # The value contained in this node. This value may be anything.
    attr_accessor :value
    alias_method :attr_value, :value
    undef_method :value
    alias_method :attr_value=, :value=
    undef_method :value=
    
    typesig { [Object] }
    # Constructs a new instance of <code>TreeNode</code>.
    # 
    # @param value
    # The value held by this node; may be anything.
    def initialize(value)
      @children = nil
      @parent = nil
      @value = nil
      @value = value
    end
    
    typesig { [Object] }
    def ==(object)
      if (object.is_a?(TreeNode))
        return Util.==(@value, (object).attr_value)
      end
      return false
    end
    
    typesig { [] }
    # Returns the child nodes. Empty arrays are converted to <code>null</code>
    # before being returned.
    # 
    # @return The child nodes; may be <code>null</code>, but never empty.
    # There should be no <code>null</code> children in the array.
    def get_children
      if (!(@children).nil? && (@children.attr_length).equal?(0))
        return nil
      end
      return @children
    end
    
    typesig { [] }
    # Returns the parent node.
    # 
    # @return The parent node; may be <code>null</code> if there are no
    # parent nodes.
    def get_parent
      return @parent
    end
    
    typesig { [] }
    # Returns the value held by this node.
    # 
    # @return The value; may be anything.
    def get_value
      return @value
    end
    
    typesig { [] }
    # Returns whether the tree has any children.
    # 
    # @return <code>true</code> if its array of children is not
    # <code>null</code> and is non-empty; <code>false</code>
    # otherwise.
    def has_children
      return !(@children).nil? && @children.attr_length > 0
    end
    
    typesig { [] }
    def hash_code
      return Util.hash_code(@value)
    end
    
    typesig { [Array.typed(TreeNode)] }
    # Sets the children for this node.
    # 
    # @param children
    # The child nodes; may be <code>null</code> or empty. There
    # should be no <code>null</code> children in the array.
    def set_children(children)
      @children = children
    end
    
    typesig { [TreeNode] }
    # Sets the parent for this node.
    # 
    # @param parent
    # The parent node; may be <code>null</code>.
    def set_parent(parent)
      @parent = parent
    end
    
    private
    alias_method :initialize__tree_node, :initialize
  end
  
end
