require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
# Jan-Hendrik Diederich, Bredex GmbH - bug 201052
module Org::Eclipse::Jface::Preference
  module PreferenceManagerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Preference
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :StringTokenizer
      include_const ::Org::Eclipse::Core::Runtime, :Assert
    }
  end
  
  # A preference manager maintains a hierarchy of preference nodes and
  # associated preference pages.
  class PreferenceManager 
    include_class_members PreferenceManagerImports
    
    class_module.module_eval {
      # Pre-order traversal means visit the root first,
      # then the children.
      const_set_lazy(:PRE_ORDER) { 0 }
      const_attr_reader  :PRE_ORDER
      
      # Post-order means visit the children, and then the root.
      const_set_lazy(:POST_ORDER) { 1 }
      const_attr_reader  :POST_ORDER
      
      # The id of the root node.
      const_set_lazy(:ROOT_NODE_ID) { "" }
      const_attr_reader  :ROOT_NODE_ID
    }
    
    # $NON-NLS-1$
    # 
    # The root node.
    # Note that the root node is a special internal node
    # that is used to collect together all the nodes that
    # have no parent; it is not given out to clients.
    attr_accessor :root
    alias_method :attr_root, :root
    undef_method :root
    alias_method :attr_root=, :root=
    undef_method :root=
    
    # The path separator character.
    attr_accessor :separator
    alias_method :attr_separator, :separator
    undef_method :separator
    alias_method :attr_separator=, :separator=
    undef_method :separator=
    
    typesig { [] }
    # Creates a new preference manager.
    def initialize
      initialize__preference_manager(Character.new(?..ord), PreferenceNode.new(ROOT_NODE_ID))
    end
    
    typesig { [::Java::Char] }
    # Creates a new preference manager with the given
    # path separator.
    # 
    # @param separatorChar
    def initialize(separator_char)
      initialize__preference_manager(separator_char, PreferenceNode.new(ROOT_NODE_ID))
    end
    
    typesig { [::Java::Char, PreferenceNode] }
    # Creates a new preference manager with the given
    # path separator and root node.
    # 
    # @param separatorChar the separator character
    # @param rootNode the root node.
    # 
    # @since 3.4
    def initialize(separator_char, root_node)
      @root = nil
      @separator = nil
      @separator = RJava.cast_to_string(String.new(Array.typed(::Java::Char).new([separator_char])))
      @root = root_node
    end
    
    typesig { [String, IPreferenceNode] }
    # Adds the given preference node as a subnode of the
    # node at the given path.
    # 
    # @param path the path
    # @param node the node to add
    # @return <code>true</code> if the add was successful,
    # and <code>false</code> if there is no contribution at
    # the given path
    def add_to(path, node)
      target = find(path)
      if ((target).nil?)
        return false
      end
      target.add(node)
      return true
    end
    
    typesig { [IPreferenceNode] }
    # Adds the given preference node as a subnode of the
    # root.
    # 
    # @param node the node to add, which must implement
    # <code>IPreferenceNode</code>
    def add_to_root(node)
      Assert.is_not_null(node)
      @root.add(node)
    end
    
    typesig { [IPreferenceNode, JavaList, ::Java::Int] }
    # Recursively enumerates all nodes at or below the given node
    # and adds them to the given list in the given order.
    # 
    # @param node the starting node
    # @param sequence a read-write list of preference nodes
    # (element type: <code>IPreferenceNode</code>)
    # in the given order
    # @param order the traversal order, one of
    # <code>PRE_ORDER</code> and <code>POST_ORDER</code>
    def build_sequence(node, sequence, order)
      if ((order).equal?(PRE_ORDER))
        sequence.add(node)
      end
      subnodes = node.get_sub_nodes
      i = 0
      while i < subnodes.attr_length
        build_sequence(subnodes[i], sequence, order)
        i += 1
      end
      if ((order).equal?(POST_ORDER))
        sequence.add(node)
      end
    end
    
    typesig { [String] }
    # Finds and returns the contribution node at the given path.
    # 
    # @param path the path
    # @return the node, or <code>null</code> if none
    def find(path)
      return find(path, @root)
    end
    
    typesig { [String, IPreferenceNode] }
    # Finds and returns the preference node directly
    # below the top at the given path.
    # 
    # @param path the path
    # @param top top at the given path
    # @return the node, or <code>null</code> if none
    # 
    # @since 3.1
    def find(path, top)
      Assert.is_not_null(path)
      stok = StringTokenizer.new(path, @separator)
      node = top
      while (stok.has_more_tokens)
        id = stok.next_token
        node = node.find_sub_node(id)
        if ((node).nil?)
          return nil
        end
      end
      if ((node).equal?(top))
        return nil
      end
      return node
    end
    
    typesig { [::Java::Int] }
    # Returns all preference nodes managed by this
    # manager.
    # 
    # @param order the traversal order, one of
    # <code>PRE_ORDER</code> and <code>POST_ORDER</code>
    # @return a list of preference nodes
    # (element type: <code>IPreferenceNode</code>)
    # in the given order
    def get_elements(order)
      Assert.is_true((order).equal?(PRE_ORDER) || (order).equal?(POST_ORDER), "invalid traversal order") # $NON-NLS-1$
      sequence = ArrayList.new
      subnodes = get_root.get_sub_nodes
      i = 0
      while i < subnodes.attr_length
        build_sequence(subnodes[i], sequence, order)
        i += 1
      end
      return sequence
    end
    
    typesig { [] }
    # Returns the root node.
    # Note that the root node is a special internal node
    # that is used to collect together all the nodes that
    # have no parent; it is not given out to clients.
    # 
    # @return the root node
    def get_root
      return @root
    end
    
    typesig { [] }
    # Returns the root level nodes of this preference manager.
    # 
    # @return an array containing the root nodes
    # @since 3.2
    def get_root_sub_nodes
      return get_root.get_sub_nodes
    end
    
    typesig { [String] }
    # Removes the preference node at the given path.
    # 
    # @param path
    # the path
    # @return the node that was removed, or <code>null</code> if there was no
    # node at the given path
    def remove(path)
      Assert.is_not_null(path)
      index = path.last_index_of(@separator)
      if ((index).equal?(-1))
        return @root.remove(path)
      end
      # Make sure that the last character in the string isn't the "."
      Assert.is_true(index < path.length - 1, "Path can not end with a dot") # $NON-NLS-1$
      parent_path = path.substring(0, index)
      id = path.substring(index + 1)
      parent_node = find(parent_path)
      if ((parent_node).nil?)
        return nil
      end
      return parent_node.remove(id)
    end
    
    typesig { [IPreferenceNode] }
    # Removes the given prefreence node if it is managed by
    # this contribution manager.
    # 
    # @param node the node to remove
    # @return <code>true</code> if the node was removed,
    # and <code>false</code> otherwise
    def remove(node)
      Assert.is_not_null(node)
      return @root.remove(node)
    end
    
    typesig { [] }
    # Removes all contribution nodes known to this manager.
    def remove_all
      @root = PreferenceNode.new("") # $NON-NLS-1$
    end
    
    private
    alias_method :initialize__preference_manager, :initialize
  end
  
end
