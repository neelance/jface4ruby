require "rjava"

# Copyright (c) 2004, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Viewers::Deferred
  module LazySortedCollectionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers::Deferred
      include_const ::Java::Util, :Collection
      include_const ::Java::Util, :Comparator
      include_const ::Java::Util, :Iterator
      include_const ::Org::Eclipse::Core::Runtime, :Assert
    }
  end
  
  # This object maintains a collection of elements, sorted by a comparator
  # given in the constructor. The collection is lazily sorted, allowing
  # more efficient runtimes for most methods. There are several methods on this
  # object that allow objects to be queried by their position in the sorted
  # collection.
  # 
  # <p>
  # This is a modified binary search tree. Each subtree has a value, a left and right subtree,
  # a count of the number of children, and a set of unsorted children.
  # Insertion happens lazily. When a new node N is inserted into a subtree T, it is initially
  # added to the set of unsorted children for T without actually comparing it with the value for T.
  # </p>
  # <p>
  # The unsorted children will remain in the unsorted set until some subsequent operation requires
  # us to know the exact set of elements in one of the subtrees. At that time, we partition
  # T by comparing all of its unsorted children with T's value and moving them into the left
  # or right subtrees.
  # </p>
  # 
  # @since 3.1
  class LazySortedCollection 
    include_class_members LazySortedCollectionImports
    
    attr_accessor :min_capacity
    alias_method :attr_min_capacity, :min_capacity
    undef_method :min_capacity
    alias_method :attr_min_capacity=, :min_capacity=
    undef_method :min_capacity=
    
    attr_accessor :contents
    alias_method :attr_contents, :contents
    undef_method :contents
    alias_method :attr_contents=, :contents=
    undef_method :contents=
    
    attr_accessor :left_sub_tree
    alias_method :attr_left_sub_tree, :left_sub_tree
    undef_method :left_sub_tree
    alias_method :attr_left_sub_tree=, :left_sub_tree=
    undef_method :left_sub_tree=
    
    attr_accessor :right_sub_tree
    alias_method :attr_right_sub_tree, :right_sub_tree
    undef_method :right_sub_tree
    alias_method :attr_right_sub_tree=, :right_sub_tree=
    undef_method :right_sub_tree=
    
    attr_accessor :next_unsorted
    alias_method :attr_next_unsorted, :next_unsorted
    undef_method :next_unsorted
    alias_method :attr_next_unsorted=, :next_unsorted=
    undef_method :next_unsorted=
    
    attr_accessor :tree_size
    alias_method :attr_tree_size, :tree_size
    undef_method :tree_size
    alias_method :attr_tree_size=, :tree_size=
    undef_method :tree_size=
    
    attr_accessor :parent_tree
    alias_method :attr_parent_tree, :parent_tree
    undef_method :parent_tree
    alias_method :attr_parent_tree=, :parent_tree=
    undef_method :parent_tree=
    
    attr_accessor :root
    alias_method :attr_root, :root
    undef_method :root
    alias_method :attr_root=, :root=
    undef_method :root=
    
    attr_accessor :last_node
    alias_method :attr_last_node, :last_node
    undef_method :last_node
    alias_method :attr_last_node=, :last_node=
    undef_method :last_node=
    
    attr_accessor :first_unused_node
    alias_method :attr_first_unused_node, :first_unused_node
    undef_method :first_unused_node
    alias_method :attr_first_unused_node=, :first_unused_node=
    undef_method :first_unused_node=
    
    class_module.module_eval {
      const_set_lazy(:LoadFactor) { 0.75 }
      const_attr_reader  :LoadFactor
    }
    
    attr_accessor :object_indices
    alias_method :attr_object_indices, :object_indices
    undef_method :object_indices
    alias_method :attr_object_indices=, :object_indices=
    undef_method :object_indices=
    
    attr_accessor :comparator
    alias_method :attr_comparator, :comparator
    undef_method :comparator
    alias_method :attr_comparator=, :comparator=
    undef_method :comparator=
    
    class_module.module_eval {
      
      def counter
        defined?(@@counter) ? @@counter : @@counter= 0
      end
      alias_method :attr_counter, :counter
      
      def counter=(value)
        @@counter = value
      end
      alias_method :attr_counter=, :counter=
    }
    
    # Disables randomization and enables additional runtime error checking.
    # Severely degrades performance if set to true. Intended for use in test
    # suites only.
    attr_accessor :enable_debug
    alias_method :attr_enable_debug, :enable_debug
    undef_method :enable_debug
    alias_method :attr_enable_debug=, :enable_debug=
    undef_method :enable_debug=
    
    # This object is inserted as the value into any node scheduled for lazy removal
    attr_accessor :lazy_removal_flag
    alias_method :attr_lazy_removal_flag, :lazy_removal_flag
    undef_method :lazy_removal_flag
    alias_method :attr_lazy_removal_flag=, :lazy_removal_flag=
    undef_method :lazy_removal_flag=
    
    class_module.module_eval {
      const_set_lazy(:DIR_LEFT) { 0 }
      const_attr_reader  :DIR_LEFT
      
      const_set_lazy(:DIR_RIGHT) { 1 }
      const_attr_reader  :DIR_RIGHT
      
      const_set_lazy(:DIR_UNSORTED) { 2 }
      const_attr_reader  :DIR_UNSORTED
      
      # Direction constants indicating root nodes
      const_set_lazy(:DIR_ROOT) { 3 }
      const_attr_reader  :DIR_ROOT
      
      const_set_lazy(:DIR_UNUSED) { 4 }
      const_attr_reader  :DIR_UNUSED
      
      const_set_lazy(:Edge) { Class.new do
        extend LocalClass
        include_class_members LazySortedCollection
        
        attr_accessor :start_node
        alias_method :attr_start_node, :start_node
        undef_method :start_node
        alias_method :attr_start_node=, :start_node=
        undef_method :start_node=
        
        attr_accessor :direction
        alias_method :attr_direction, :direction
        undef_method :direction
        alias_method :attr_direction=, :direction=
        undef_method :direction=
        
        typesig { [] }
        def initialize
          @start_node = 0
          @direction = 0
          @start_node = -1
          @direction = -1
        end
        
        typesig { [::Java::Int, ::Java::Int] }
        def initialize(node, dir)
          @start_node = 0
          @direction = 0
          @start_node = node
          @direction = dir
        end
        
        typesig { [] }
        def get_start
          return @start_node
        end
        
        typesig { [] }
        def get_target
          if ((@start_node).equal?(-1))
            if ((@direction).equal?(DIR_UNSORTED))
              return self.attr_first_unused_node
            else
              if ((@direction).equal?(DIR_ROOT))
                return self.attr_root
              end
            end
            return -1
          end
          if ((@direction).equal?(DIR_LEFT))
            return self.attr_left_sub_tree[@start_node]
          end
          if ((@direction).equal?(DIR_RIGHT))
            return self.attr_right_sub_tree[@start_node]
          end
          return self.attr_next_unsorted[@start_node]
        end
        
        typesig { [] }
        def is_null
          return (get_target).equal?(-1)
        end
        
        typesig { [::Java::Int] }
        # Redirects this edge to a new node
        # @param newNode
        # @since 3.1
        def set_target(new_node)
          if ((@direction).equal?(DIR_LEFT))
            self.attr_left_sub_tree[@start_node] = new_node
          else
            if ((@direction).equal?(DIR_RIGHT))
              self.attr_right_sub_tree[@start_node] = new_node
            else
              if ((@direction).equal?(DIR_UNSORTED))
                self.attr_next_unsorted[@start_node] = new_node
              else
                if ((@direction).equal?(DIR_ROOT))
                  self.attr_root = new_node
                else
                  if ((@direction).equal?(DIR_UNUSED))
                    self.attr_first_unused_node = new_node
                  end
                end
              end
            end
          end
          if (!(new_node).equal?(-1))
            self.attr_parent_tree[new_node] = @start_node
          end
        end
        
        typesig { [::Java::Int] }
        def advance(direction)
          @start_node = get_target
          @direction = direction
        end
        
        private
        alias_method :initialize__edge, :initialize
      end }
    }
    
    typesig { [::Java::Int] }
    def set_root_node(node)
      @root = node
      if (!(node).equal?(-1))
        @parent_tree[node] = -1
      end
    end
    
    typesig { [Comparator] }
    # Creates a new sorted collection using the given comparator to determine
    # sort order.
    # 
    # @param c comparator that determines the sort order
    def initialize(c)
      @min_capacity = 8
      @contents = Array.typed(Object).new(@min_capacity) { nil }
      @left_sub_tree = Array.typed(::Java::Int).new(@min_capacity) { 0 }
      @right_sub_tree = Array.typed(::Java::Int).new(@min_capacity) { 0 }
      @next_unsorted = Array.typed(::Java::Int).new(@min_capacity) { 0 }
      @tree_size = Array.typed(::Java::Int).new(@min_capacity) { 0 }
      @parent_tree = Array.typed(::Java::Int).new(@min_capacity) { 0 }
      @root = -1
      @last_node = 0
      @first_unused_node = -1
      @object_indices = nil
      @comparator = nil
      @enable_debug = false
      @lazy_removal_flag = Class.new(Object.class == Class ? Object : Object) do
        extend LocalClass
        include_class_members LazySortedCollection
        include Object if Object.class == Module
        
        typesig { [] }
        define_method :to_s do
          return "Lazy removal flag" # $NON-NLS-1$
        end
        
        typesig { [Object] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
      @comparator = c
    end
    
    typesig { [] }
    # Tests if this object's internal state is valid. Throws a runtime
    # exception if the state is invalid, indicating a programming error
    # in this class. This method is intended for use in test
    # suites and should not be called by clients.
    def test_invariants
      if (!@enable_debug)
        return
      end
      test_invariants(@root)
    end
    
    typesig { [::Java::Int] }
    def test_invariants(node)
      if ((node).equal?(-1))
        return
      end
      # Get the current tree size (we will later force the tree size
      # to be recomputed from scratch -- if everything works properly, then
      # there should be no change.
      tree_size = get_subtree_size(node)
      left = @left_sub_tree[node]
      right = @right_sub_tree[node]
      unsorted = @next_unsorted[node]
      if (is_unsorted(node))
        Assert.is_true((left).equal?(-1), "unsorted nodes shouldn't have a left subtree") # $NON-NLS-1$
        Assert.is_true((right).equal?(-1), "unsorted nodes shouldn't have a right subtree") # $NON-NLS-1$
      end
      if (!(left).equal?(-1))
        test_invariants(left)
        Assert.is_true((@parent_tree[left]).equal?(node), "left node has invalid parent pointer") # $NON-NLS-1$
      end
      if (!(right).equal?(-1))
        test_invariants(right)
        Assert.is_true((@parent_tree[right]).equal?(node), "right node has invalid parent pointer") # $NON-NLS-1$
      end
      previous = node
      while (!(unsorted).equal?(-1))
        old_tree_size = @tree_size[unsorted]
        recompute_tree_size(unsorted)
        Assert.is_true((@tree_size[unsorted]).equal?(old_tree_size), "Invalid node size for unsorted node") # $NON-NLS-1$
        Assert.is_true((@left_sub_tree[unsorted]).equal?(-1), "unsorted nodes shouldn't have left subtrees") # $NON-NLS-1$
        Assert.is_true((@right_sub_tree[unsorted]).equal?(-1), "unsorted nodes shouldn't have right subtrees") # $NON-NLS-1$
        Assert.is_true((@parent_tree[unsorted]).equal?(previous), "unsorted node has invalid parent pointer") # $NON-NLS-1$
        Assert.is_true(!(@contents[unsorted]).equal?(@lazy_removal_flag), "unsorted nodes should not be lazily removed") # $NON-NLS-1$
        previous = unsorted
        unsorted = @next_unsorted[unsorted]
      end
      # Note that we've already tested that the child sizes are correct... if our size is
      # correct, then recomputing it now should not cause any change.
      recompute_tree_size(node)
      Assert.is_true((tree_size).equal?(get_subtree_size(node)), "invalid tree size") # $NON-NLS-1$
    end
    
    typesig { [::Java::Int] }
    def is_unsorted(node)
      parent = @parent_tree[node]
      if (!(parent).equal?(-1))
        return (@next_unsorted[parent]).equal?(node)
      end
      return false
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    def is_less(element1, element2)
      return @comparator.compare(@contents[element1], @contents[element2]) < 0
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Adds the given element to the given subtree. Returns the new
    # root of the subtree.
    # 
    # @param subTree index of the subtree to insert elementToAdd into. If -1,
    # then a new subtree will be created for elementToAdd
    # @param elementToAdd index of the element to add to the subtree. If -1, this method
    # is a NOP.
    # @since 3.1
    def add_unsorted(sub_tree, element_to_add)
      if ((element_to_add).equal?(-1))
        return sub_tree
      end
      if ((sub_tree).equal?(-1))
        @next_unsorted[element_to_add] = -1
        @tree_size[element_to_add] = 1
        return element_to_add
      end
      # If the subTree is empty (ie: it only contains nodes flagged for lazy removal),
      # chop it off.
      if ((@tree_size[sub_tree]).equal?(0))
        remove_sub_tree(sub_tree)
        @next_unsorted[element_to_add] = -1
        @tree_size[element_to_add] = 1
        return element_to_add
      end
      # If neither subtree has any children, add a pseudorandom chance of the
      # newly added element becoming the new pivot for this node. Note: instead
      # of a real pseudorandom generator, we simply use a counter here.
      if (!@enable_debug && (@left_sub_tree[sub_tree]).equal?(-1) && (@right_sub_tree[sub_tree]).equal?(-1) && (@left_sub_tree[element_to_add]).equal?(-1) && (@right_sub_tree[element_to_add]).equal?(-1))
        self.attr_counter -= 1
        if ((self.attr_counter % @tree_size[sub_tree]).equal?(0))
          # Make the new node into the new pivot
          @next_unsorted[element_to_add] = sub_tree
          @parent_tree[element_to_add] = @parent_tree[sub_tree]
          @parent_tree[sub_tree] = element_to_add
          @tree_size[element_to_add] = @tree_size[sub_tree] + 1
          return element_to_add
        end
      end
      old_next_unsorted = @next_unsorted[sub_tree]
      @next_unsorted[element_to_add] = old_next_unsorted
      if ((old_next_unsorted).equal?(-1))
        @tree_size[element_to_add] = 1
      else
        @tree_size[element_to_add] = @tree_size[old_next_unsorted] + 1
        @parent_tree[old_next_unsorted] = element_to_add
      end
      @parent_tree[element_to_add] = sub_tree
      @next_unsorted[sub_tree] = element_to_add
      @tree_size[sub_tree] += 1
      return sub_tree
    end
    
    typesig { [] }
    # Returns the number of elements in the collection
    # 
    # @return the number of elements in the collection
    def size
      result = get_subtree_size(@root)
      test_invariants
      return result
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Given a tree and one of its unsorted children, this sorts the child by moving
    # it into the left or right subtrees. Returns the next unsorted child or -1 if none
    # 
    # @param subTree parent tree
    # @param toMove child (unsorted) subtree
    # @since 3.1
    def partition(sub_tree, to_move)
      result = @next_unsorted[to_move]
      if (is_less(to_move, sub_tree))
        next_left = add_unsorted(@left_sub_tree[sub_tree], to_move)
        @left_sub_tree[sub_tree] = next_left
        @parent_tree[next_left] = sub_tree
      else
        next_right = add_unsorted(@right_sub_tree[sub_tree], to_move)
        @right_sub_tree[sub_tree] = next_right
        @parent_tree[next_right] = sub_tree
      end
      return result
    end
    
    typesig { [::Java::Int, FastProgressReporter] }
    # Partitions the given subtree. Moves all unsorted elements at the given node
    # to either the left or right subtrees. If the node itself was scheduled for
    # lazy removal, this will force the node to be removed immediately. Returns
    # the new subTree.
    # 
    # @param subTree
    # @return the replacement node (this may be different from subTree if the subtree
    # was replaced during the removal)
    # @since 3.1
    def partition(sub_tree, mon)
      if ((sub_tree).equal?(-1))
        return -1
      end
      if ((@contents[sub_tree]).equal?(@lazy_removal_flag))
        sub_tree = remove_node(sub_tree)
        if ((sub_tree).equal?(-1))
          return -1
        end
      end
      idx = @next_unsorted[sub_tree]
      while !(idx).equal?(-1)
        idx = partition(sub_tree, idx)
        @next_unsorted[sub_tree] = idx
        if (!(idx).equal?(-1))
          @parent_tree[idx] = sub_tree
        end
        if (mon.is_canceled)
          raise InterruptedException.new
        end
      end
      # At this point, there are no remaining unsorted nodes in this subtree
      @next_unsorted[sub_tree] = -1
      return sub_tree
    end
    
    typesig { [::Java::Int] }
    def get_subtree_size(sub_tree)
      if ((sub_tree).equal?(-1))
        return 0
      end
      return @tree_size[sub_tree]
    end
    
    typesig { [::Java::Int] }
    # Increases the capacity of this collection, if necessary, so that it can hold the
    # given number of elements. This can be used prior to a sequence of additions to
    # avoid memory reallocation. This cannot be used to reduce the amount
    # of memory used by the collection.
    # 
    # @param newSize capacity for this collection
    def set_capacity(new_size)
      if (new_size > @contents.attr_length)
        set_array_size(new_size)
      end
    end
    
    typesig { [::Java::Int] }
    # Adjusts the capacity of the array.
    # 
    # @param newCapacity
    def set_array_size(new_capacity)
      new_contents = Array.typed(Object).new(new_capacity) { nil }
      System.arraycopy(@contents, 0, new_contents, 0, @last_node)
      @contents = new_contents
      new_left_sub_tree = Array.typed(::Java::Int).new(new_capacity) { 0 }
      System.arraycopy(@left_sub_tree, 0, new_left_sub_tree, 0, @last_node)
      @left_sub_tree = new_left_sub_tree
      new_right_sub_tree = Array.typed(::Java::Int).new(new_capacity) { 0 }
      System.arraycopy(@right_sub_tree, 0, new_right_sub_tree, 0, @last_node)
      @right_sub_tree = new_right_sub_tree
      new_next_unsorted = Array.typed(::Java::Int).new(new_capacity) { 0 }
      System.arraycopy(@next_unsorted, 0, new_next_unsorted, 0, @last_node)
      @next_unsorted = new_next_unsorted
      new_tree_size = Array.typed(::Java::Int).new(new_capacity) { 0 }
      System.arraycopy(@tree_size, 0, new_tree_size, 0, @last_node)
      @tree_size = new_tree_size
      new_parent_tree = Array.typed(::Java::Int).new(new_capacity) { 0 }
      System.arraycopy(@parent_tree, 0, new_parent_tree, 0, @last_node)
      @parent_tree = new_parent_tree
    end
    
    typesig { [Object] }
    # Creates a new node with the given value. Returns the index of the newly
    # created node.
    # 
    # @param value
    # @return the index of the newly created node
    # @since 3.1
    def create_node(value)
      result = -1
      if ((@first_unused_node).equal?(-1))
        # If there are no unused nodes from prior removals, then
        # we add a node at the end
        result = @last_node
        # If this would cause the array to overflow, reallocate the array
        if (@contents.attr_length <= @last_node)
          set_capacity(@last_node * 2)
        end
        @last_node += 1
      else
        # Reuse a node from a prior removal
        result = @first_unused_node
        @first_unused_node = @next_unsorted[result]
      end
      @contents[result] = value
      @tree_size[result] = 1
      # Clear pointers
      @left_sub_tree[result] = -1
      @right_sub_tree[result] = -1
      @next_unsorted[result] = -1
      # As long as we have a hash table of values onto tree indices, incrementally
      # update the hash table. Note: the table is only constructed as needed, and it
      # is destroyed whenever the arrays are reallocated instead of reallocating it.
      if (!(@object_indices).nil?)
        @object_indices.put(value, result)
      end
      return result
    end
    
    typesig { [Object] }
    # Returns the current tree index for the given object.
    # 
    # @param value
    # @return the current tree index
    # @since 3.1
    def get_object_index(value)
      # If we don't have a map of values onto tree indices, build the map now.
      if ((@object_indices).nil?)
        result = -1
        @object_indices = IntHashMap.new(RJava.cast_to_int((@contents.attr_length / LoadFactor)) + 1, LoadFactor)
        i = 0
        while i < @last_node
          element = @contents[i]
          if (!(element).nil? && !(element).equal?(@lazy_removal_flag))
            @object_indices.put(element, i)
            if ((value).equal?(element))
              result = i
            end
          end
          i += 1
        end
        return result
      end
      # If we have a map of values onto tree indices, return the result by looking it up in
      # the map
      return @object_indices.get(value, -1)
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Redirects any pointers from the original to the replacement. If the replacement
    # causes a change in the number of elements in the parent tree, the changes are
    # propogated toward the root.
    # 
    # @param nodeToReplace
    # @param replacementNode
    # @since 3.1
    def replace_node(node_to_replace, replacement_node)
      parent = @parent_tree[node_to_replace]
      if ((parent).equal?(-1))
        if ((@root).equal?(node_to_replace))
          set_root_node(replacement_node)
        end
      else
        if ((@left_sub_tree[parent]).equal?(node_to_replace))
          @left_sub_tree[parent] = replacement_node
        else
          if ((@right_sub_tree[parent]).equal?(node_to_replace))
            @right_sub_tree[parent] = replacement_node
          else
            if ((@next_unsorted[parent]).equal?(node_to_replace))
              @next_unsorted[parent] = replacement_node
            end
          end
        end
        if (!(replacement_node).equal?(-1))
          @parent_tree[replacement_node] = parent
        end
      end
    end
    
    typesig { [::Java::Int] }
    def recompute_ancestor_tree_sizes(node)
      while (!(node).equal?(-1))
        old_size = @tree_size[node]
        recompute_tree_size(node)
        if ((@tree_size[node]).equal?(old_size))
          break
        end
        node = @parent_tree[node]
      end
    end
    
    typesig { [::Java::Int] }
    # Recomputes the tree size for the given node.
    # 
    # @param node
    # @since 3.1
    def recompute_tree_size(node)
      if ((node).equal?(-1))
        return
      end
      @tree_size[node] = get_subtree_size(@left_sub_tree[node]) + get_subtree_size(@right_sub_tree[node]) + get_subtree_size(@next_unsorted[node]) + ((@contents[node]).equal?(@lazy_removal_flag) ? 0 : 1)
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # @param toRecompute
    # @param whereToStop
    # @since 3.1
    def force_recompute_tree_size(to_recompute, where_to_stop)
      while (!(to_recompute).equal?(-1) && !(to_recompute).equal?(where_to_stop))
        recompute_tree_size(to_recompute)
        to_recompute = @parent_tree[to_recompute]
      end
    end
    
    typesig { [::Java::Int] }
    # Destroy the node at the given index in the tree
    # @param nodeToDestroy
    # @since 3.1
    def destroy_node(node_to_destroy)
      # If we're maintaining a map of values onto tree indices, remove this entry from
      # the map
      if (!(@object_indices).nil?)
        old_contents = @contents[node_to_destroy]
        if (!(old_contents).equal?(@lazy_removal_flag))
          @object_indices.remove(old_contents)
        end
      end
      @contents[node_to_destroy] = nil
      @left_sub_tree[node_to_destroy] = -1
      @right_sub_tree[node_to_destroy] = -1
      if ((@first_unused_node).equal?(-1))
        @tree_size[node_to_destroy] = 1
      else
        @tree_size[node_to_destroy] = @tree_size[@first_unused_node] + 1
        @parent_tree[@first_unused_node] = node_to_destroy
      end
      @next_unsorted[node_to_destroy] = @first_unused_node
      @first_unused_node = node_to_destroy
    end
    
    typesig { [] }
    # Frees up memory by clearing the list of nodes that have been freed up through removals.
    # 
    # @since 3.1
    def pack
      # If there are no unused nodes, then there is nothing to do
      if ((@first_unused_node).equal?(-1))
        return
      end
      reusable_nodes = get_subtree_size(@first_unused_node)
      non_packable_nodes = @last_node - reusable_nodes
      # Only pack the array if we're utilizing less than 1/4 of the array (note:
      # this check is important, or it will change the time bounds for removals)
      if (@contents.attr_length < @min_capacity || non_packable_nodes > @contents.attr_length / 4)
        return
      end
      # Rather than update the entire map, just null it out. If it is needed,
      # it will be recreated lazily later. This will save some memory if the
      # map isn't needed, and it takes a similar amount of time to recreate the
      # map as to update all the indices.
      @object_indices = nil
      # Maps old index -> new index
      map_new_idx_onto_old = Array.typed(::Java::Int).new(@contents.attr_length) { 0 }
      map_old_idx_onto_new = Array.typed(::Java::Int).new(@contents.attr_length) { 0 }
      next_new_idx = 0
      # Compute the mapping. Determine the new index for each element
      old_idx = 0
      while old_idx < @last_node
        if (!(@contents[old_idx]).nil?)
          map_old_idx_onto_new[old_idx] = next_new_idx
          map_new_idx_onto_old[next_new_idx] = old_idx
          next_new_idx += 1
        else
          map_old_idx_onto_new[old_idx] = -1
        end
        old_idx += 1
      end
      # Make the actual array size double the number of nodes to allow
      # for expansion.
      new_nodes = next_new_idx
      new_capacity = Math.max(new_nodes * 2, @min_capacity)
      # Allocate new arrays
      new_contents = Array.typed(Object).new(new_capacity) { nil }
      new_tree_size = Array.typed(::Java::Int).new(new_capacity) { 0 }
      new_next_unsorted = Array.typed(::Java::Int).new(new_capacity) { 0 }
      new_left_sub_tree = Array.typed(::Java::Int).new(new_capacity) { 0 }
      new_right_sub_tree = Array.typed(::Java::Int).new(new_capacity) { 0 }
      new_parent_tree = Array.typed(::Java::Int).new(new_capacity) { 0 }
      new_idx = 0
      while new_idx < new_nodes
        old_idx_ = map_new_idx_onto_old[new_idx]
        new_contents[new_idx] = @contents[old_idx_]
        new_tree_size[new_idx] = @tree_size[old_idx_]
        left = @left_sub_tree[old_idx_]
        if ((left).equal?(-1))
          new_left_sub_tree[new_idx] = -1
        else
          new_left_sub_tree[new_idx] = map_old_idx_onto_new[left]
        end
        right = @right_sub_tree[old_idx_]
        if ((right).equal?(-1))
          new_right_sub_tree[new_idx] = -1
        else
          new_right_sub_tree[new_idx] = map_old_idx_onto_new[right]
        end
        unsorted = @next_unsorted[old_idx_]
        if ((unsorted).equal?(-1))
          new_next_unsorted[new_idx] = -1
        else
          new_next_unsorted[new_idx] = map_old_idx_onto_new[unsorted]
        end
        parent = @parent_tree[old_idx_]
        if ((parent).equal?(-1))
          new_parent_tree[new_idx] = -1
        else
          new_parent_tree[new_idx] = map_old_idx_onto_new[parent]
        end
        new_idx += 1
      end
      @contents = new_contents
      @next_unsorted = new_next_unsorted
      @tree_size = new_tree_size
      @left_sub_tree = new_left_sub_tree
      @right_sub_tree = new_right_sub_tree
      @parent_tree = new_parent_tree
      if (!(@root).equal?(-1))
        @root = map_old_idx_onto_new[@root]
      end
      # All unused nodes have been removed
      @first_unused_node = -1
      @last_node = new_nodes
    end
    
    typesig { [Object] }
    # Adds the given object to the collection. Runs in O(1) amortized time.
    # 
    # @param toAdd object to add
    def add(to_add)
      Assert.is_not_null(to_add)
      # Create the new node
      new_idx = create_node(to_add)
      # Insert the new node into the root tree
      set_root_node(add_unsorted(@root, new_idx))
      test_invariants
    end
    
    typesig { [Collection] }
    # Adds all items from the given collection to this collection
    # 
    # @param toAdd objects to add
    def add_all(to_add)
      Assert.is_not_null(to_add)
      iter = to_add.iterator
      while (iter.has_next)
        add(iter.next_)
      end
      test_invariants
    end
    
    typesig { [Array.typed(Object)] }
    # Adds all items from the given array to the collection
    # 
    # @param toAdd objects to add
    def add_all(to_add)
      Assert.is_not_null(to_add)
      i = 0
      while i < to_add.attr_length
        object = to_add[i]
        add(object)
        i += 1
      end
      test_invariants
    end
    
    typesig { [] }
    # Returns true iff the collection is empty
    # 
    # @return true iff the collection contains no elements
    def is_empty
      result = ((@root).equal?(-1))
      test_invariants
      return result
    end
    
    typesig { [Object] }
    # Removes the given object from the collection. Has no effect if
    # the element does not exist in this collection.
    # 
    # @param toRemove element to remove
    def remove(to_remove)
      internal_remove(to_remove)
      pack
      test_invariants
    end
    
    typesig { [Object] }
    # Internal implementation of remove. Removes the given element but does not
    # pack the container after the removal.
    # 
    # @param toRemove element to remove
    def internal_remove(to_remove)
      object_index = get_object_index(to_remove)
      if (!(object_index).equal?(-1))
        parent = @parent_tree[object_index]
        lazy_remove_node(object_index)
        # Edge parentEdge = getEdgeTo(objectIndex);
        # parentEdge.setTarget(lazyRemoveNode(objectIndex));
        recompute_ancestor_tree_sizes(parent)
      end
      # testInvariants();
    end
    
    typesig { [Array.typed(Object)] }
    # Removes all elements in the given array from this collection.
    # 
    # @param toRemove elements to remove
    def remove_all(to_remove)
      Assert.is_not_null(to_remove)
      i = 0
      while i < to_remove.attr_length
        object = to_remove[i]
        internal_remove(object)
        i += 1
      end
      pack
    end
    
    typesig { [::Java::Int, FastProgressReporter] }
    # Retains the n smallest items in the collection, removing the rest. When
    # this method returns, the size of the collection will be n. Note that
    # this is a no-op if n > the current size of the collection.
    # 
    # Temporarily package visibility until the implementation of FastProgressReporter
    # is finished.
    # 
    # @param n number of items to retain
    # @param mon progress monitor
    # @throws InterruptedException if the progress monitor is cancelled in another thread
    # 
    # package
    def retain_first(n, mon)
      sz = size
      if (n >= sz)
        return
      end
      remove_range(n, sz - n, mon)
      test_invariants
    end
    
    typesig { [::Java::Int] }
    # Retains the n smallest items in the collection, removing the rest. When
    # this method returns, the size of the collection will be n. Note that
    # this is a no-op if n > the current size of the collection.
    # 
    # @param n number of items to retain
    def retain_first(n)
      begin
        retain_first(n, FastProgressReporter.new)
      rescue InterruptedException => e
      end
      test_invariants
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Removes all elements in the given range from this collection.
    # For example, removeRange(10, 3) would remove the 11th through 13th
    # smallest items from the collection.
    # 
    # @param first 0-based index of the smallest item to remove
    # @param length number of items to remove
    def remove_range(first, length)
      begin
        remove_range(first, length, FastProgressReporter.new)
      rescue InterruptedException => e
      end
      test_invariants
    end
    
    typesig { [::Java::Int, ::Java::Int, FastProgressReporter] }
    # Removes all elements in the given range from this collection.
    # For example, removeRange(10, 3) would remove the 11th through 13th
    # smallest items from the collection.
    # 
    # Temporarily package visiblity until the implementation of FastProgressReporter is
    # finished.
    # 
    # @param first 0-based index of the smallest item to remove
    # @param length number of items to remove
    # @param mon progress monitor
    # @throws InterruptedException if the progress monitor is cancelled in another thread
    # 
    # package
    def remove_range(first, length, mon)
      remove_range(@root, first, length, mon)
      pack
      test_invariants
    end
    
    typesig { [::Java::Int, ::Java::Int, ::Java::Int, FastProgressReporter] }
    def remove_range(node, range_start, range_length, mon)
      if ((range_length).equal?(0))
        return
      end
      size_ = get_subtree_size(node)
      if (size_ <= range_start)
        return
      end
      # If we can chop off this entire subtree without any sorting, do so.
      if ((range_start).equal?(0) && range_length >= size_)
        remove_sub_tree(node)
        return
      end
      begin
        # Partition any unsorted nodes
        node = partition(node, mon)
        left = @left_sub_tree[node]
        left_size = get_subtree_size(left)
        to_remove_from_left = Math.min(left_size - range_start, range_length)
        # If we're removing anything from the left node
        if (to_remove_from_left >= 0)
          remove_range(@left_sub_tree[node], range_start, to_remove_from_left, mon)
          # Check if we're removing from both sides
          to_remove_from_right = range_start + range_length - left_size - 1
          if (to_remove_from_right >= 0)
            # Remove from right subtree
            remove_range(@right_sub_tree[node], 0, to_remove_from_right, mon)
            # ... removing from both sides means we need to remove the node itself too
            remove_node(node)
            return
          end
        else
          # If removing from the right side only
          remove_range(@right_sub_tree[node], range_start - left_size - 1, range_length, mon)
        end
      ensure
        recompute_tree_size(node)
      end
    end
    
    typesig { [::Java::Int] }
    # Prunes the given subtree (and all child nodes, sorted or unsorted).
    # 
    # @param subTree
    # @since 3.1
    def remove_sub_tree(sub_tree)
      if ((sub_tree).equal?(-1))
        return
      end
      # Destroy all unsorted nodes
      next__ = @next_unsorted[sub_tree]
      while !(next__).equal?(-1)
        current = next__
        next__ = @next_unsorted[next__]
        # Destroy this unsorted node
        destroy_node(current)
      end
      # Destroy left subtree
      remove_sub_tree(@left_sub_tree[sub_tree])
      # Destroy right subtree
      remove_sub_tree(@right_sub_tree[sub_tree])
      replace_node(sub_tree, -1)
      # Destroy pivot node
      destroy_node(sub_tree)
    end
    
    typesig { [::Java::Int] }
    # Schedules the node for removal. If the node can be removed in constant time,
    # it is removed immediately.
    # 
    # @param subTree
    # @return the replacement node
    # @since 3.1
    def lazy_remove_node(sub_tree)
      left = @left_sub_tree[sub_tree]
      right = @right_sub_tree[sub_tree]
      # If this is a leaf node, remove it immediately
      if ((left).equal?(-1) && (right).equal?(-1))
        result = @next_unsorted[sub_tree]
        replace_node(sub_tree, result)
        destroy_node(sub_tree)
        return result
      end
      # Otherwise, flag it for future removal
      value = @contents[sub_tree]
      @contents[sub_tree] = @lazy_removal_flag
      @tree_size[sub_tree] -= 1
      if (!(@object_indices).nil?)
        @object_indices.remove(value)
      end
      return sub_tree
    end
    
    typesig { [::Java::Int] }
    # Removes the given subtree, replacing it with one of its children.
    # Returns the new root of the subtree
    # 
    # @param subTree
    # @return the index of the new root
    # @since 3.1
    def remove_node(sub_tree)
      left = @left_sub_tree[sub_tree]
      right = @right_sub_tree[sub_tree]
      if ((left).equal?(-1) || (right).equal?(-1))
        result = -1
        if ((left).equal?(-1) && (right).equal?(-1))
          # If this is a leaf node, replace it with its first unsorted child
          result = @next_unsorted[sub_tree]
        else
          # Either the left or right child is missing -- replace with the remaining child
          if ((left).equal?(-1))
            result = right
          else
            result = left
          end
          begin
            result = partition(result, FastProgressReporter.new)
          rescue InterruptedException => e
          end
          if ((result).equal?(-1))
            result = @next_unsorted[sub_tree]
          else
            unsorted = @next_unsorted[sub_tree]
            @next_unsorted[result] = unsorted
            additional_nodes = 0
            if (!(unsorted).equal?(-1))
              @parent_tree[unsorted] = result
              additional_nodes = @tree_size[unsorted]
            end
            @tree_size[result] += additional_nodes
          end
        end
        replace_node(sub_tree, result)
        destroy_node(sub_tree)
        return result
      end
      # Find the edges that lead to the next-smallest and
      # next-largest nodes
      next_smallest = Edge.new_local(self, sub_tree, DIR_LEFT)
      while (!next_smallest.is_null)
        next_smallest.advance(DIR_RIGHT)
      end
      next_largest = Edge.new_local(self, sub_tree, DIR_RIGHT)
      while (!next_largest.is_null)
        next_largest.advance(DIR_LEFT)
      end
      # Index of the replacement node
      replacement_node = -1
      # Count of number of nodes moved to the right
      left_size = get_subtree_size(left)
      right_size = get_subtree_size(right)
      # Swap with a child from the larger subtree
      if (left_size > right_size)
        replacement_node = next_smallest.get_start
        # Move any unsorted nodes that are larger than the replacement node into
        # the left subtree of the next-largest node
        unsorted = Edge.new_local(self, replacement_node, DIR_UNSORTED)
        while (!unsorted.is_null)
          target = unsorted.get_target
          if (!is_less(target, replacement_node))
            unsorted.set_target(@next_unsorted[target])
            next_largest.set_target(add_unsorted(next_largest.get_target, target))
          else
            unsorted.advance(DIR_UNSORTED)
          end
        end
        force_recompute_tree_size(unsorted.get_start, replacement_node)
        force_recompute_tree_size(next_largest.get_start, sub_tree)
      else
        replacement_node = next_largest.get_start
        # Move any unsorted nodes that are smaller than the replacement node into
        # the right subtree of the next-smallest node
        unsorted = Edge.new_local(self, replacement_node, DIR_UNSORTED)
        while (!unsorted.is_null)
          target = unsorted.get_target
          if (is_less(target, replacement_node))
            unsorted.set_target(@next_unsorted[target])
            next_smallest.set_target(add_unsorted(next_smallest.get_target, target))
          else
            unsorted.advance(DIR_UNSORTED)
          end
        end
        force_recompute_tree_size(unsorted.get_start, replacement_node)
        force_recompute_tree_size(next_smallest.get_start, sub_tree)
      end
      # Now all the affected treeSize[...] elements should be updated to reflect the
      # unsorted nodes that moved. Swap nodes.
      replacement_content = @contents[replacement_node]
      @contents[replacement_node] = @contents[sub_tree]
      @contents[sub_tree] = replacement_content
      if (!(@object_indices).nil?)
        @object_indices.put(replacement_content, sub_tree)
        # Note: currently we don't bother updating the index of the replacement
        # node since we're going to remove it immediately afterwards and there's
        # no good reason to search for the index in a method that was given the
        # index as a parameter...
        # objectIndices.put(contents[replacementNode], replacementNode)
      end
      replacement_parent = @parent_tree[replacement_node]
      replace_node(replacement_node, remove_node(replacement_node))
      # Edge parentEdge = getEdgeTo(replacementNode);
      # parentEdge.setTarget(removeNode(replacementNode));
      force_recompute_tree_size(replacement_parent, sub_tree)
      recompute_tree_size(sub_tree)
      # testInvariants();
      return sub_tree
    end
    
    typesig { [] }
    # Removes all elements from the collection
    def clear
      @last_node = 0
      set_array_size(@min_capacity)
      @root = -1
      @first_unused_node = -1
      @object_indices = nil
      test_invariants
    end
    
    typesig { [] }
    # Returns the comparator that is determining the sort order for this collection
    # 
    # @return comparator for this collection
    def get_comparator
      return @comparator
    end
    
    typesig { [Array.typed(Object), ::Java::Boolean, FastProgressReporter] }
    # Fills in an array of size n with the n smallest elements from the collection.
    # Can compute the result in sorted or unsorted order.
    # 
    # Currently package visible until the implementation of FastProgressReporter is finished.
    # 
    # @param result array to be filled
    # @param sorted if true, the result array will be sorted. If false, the result array
    # may be unsorted. This does not affect which elements appear in the result, only their
    # order.
    # @param mon monitor used to report progress and check for cancellation
    # @return the number of items inserted into the result array. This will be equal to the minimum
    # of result.length and container.size()
    # @throws InterruptedException if the progress monitor is cancelled
    # 
    # package
    def get_first(result, sorted, mon)
      return_value = get_range(result, 0, sorted, mon)
      test_invariants
      return return_value
    end
    
    typesig { [Array.typed(Object), ::Java::Boolean] }
    # Fills in an array of size n with the n smallest elements from the collection.
    # Can compute the result in sorted or unsorted order.
    # 
    # @param result array to be filled
    # @param sorted if true, the result array will be sorted. If false, the result array
    # may be unsorted. This does not affect which elements appear in the result. It only
    # affects their order. Computing an unsorted result is asymptotically faster.
    # @return the number of items inserted into the result array. This will be equal to the minimum
    # of result.length and container.size()
    def get_first(result, sorted)
      return_value = 0
      begin
        return_value = get_first(result, sorted, FastProgressReporter.new)
      rescue InterruptedException => e
      end
      test_invariants
      return return_value
    end
    
    typesig { [Array.typed(Object), ::Java::Int, ::Java::Boolean, FastProgressReporter] }
    # Given a position defined by k and an array of size n, this fills in the array with
    # the kth smallest element through to the (k+n)th smallest element. For example,
    # getRange(myArray, 10, false) would fill in myArray starting with the 10th smallest item
    # in the collection. The result can be computed in sorted or unsorted order. Computing the
    # result in unsorted order is more efficient.
    # <p>
    # Temporarily set to package visibility until the implementation of FastProgressReporter
    # is finished.
    # </p>
    # 
    # @param result array to be filled in
    # @param rangeStart index of the smallest element to appear in the result
    # @param sorted true iff the result array should be sorted
    # @param mon progress monitor used to cancel the operation
    # @throws InterruptedException if the progress monitor was cancelled in another thread
    # 
    # package
    def get_range(result, range_start, sorted, mon)
      return get_range(result, 0, range_start, @root, sorted, mon)
    end
    
    typesig { [Array.typed(Object), ::Java::Int, ::Java::Boolean] }
    # Computes the n through n+k items in this collection.
    # Computing the result in unsorted order is more efficient. Sorting the result will
    # not change which elements actually show up in the result. That is, even if the result is
    # unsorted, it will still contain the same elements as would have been at that range in
    # a fully sorted collection.
    # 
    # @param result array containing the result
    # @param rangeStart index of the first element to be inserted into the result array
    # @param sorted true iff the result will be computed in sorted order
    # @return the number of items actually inserted into the result array (will be the minimum
    # of result.length and this.size())
    def get_range(result, range_start, sorted)
      return_value = 0
      begin
        return_value = get_range(result, range_start, sorted, FastProgressReporter.new)
      rescue InterruptedException => e
      end
      test_invariants
      return return_value
    end
    
    typesig { [::Java::Int] }
    # Returns the item at the given index. Indexes are based on sorted order.
    # 
    # @param index index to test
    # @return the item at the given index
    def get_item(index)
      result = Array.typed(Object).new(1) { nil }
      begin
        get_range(result, index, false, FastProgressReporter.new)
      rescue InterruptedException => e
        # shouldn't happen
      end
      return_value = result[0]
      test_invariants
      return return_value
    end
    
    typesig { [::Java::Boolean] }
    # Returns the contents of this collection as a sorted or unsorted
    # array. Computing an unsorted array is more efficient.
    # 
    # @param sorted if true, the result will be in sorted order. If false,
    # the result may be in unsorted order.
    # @return the contents of this collection as an array.
    def get_items(sorted)
      result = Array.typed(Object).new(size) { nil }
      get_range(result, 0, sorted)
      return result
    end
    
    typesig { [Array.typed(Object), ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Boolean, FastProgressReporter] }
    def get_range(result, result_idx, range_start, node, sorted, mon)
      if ((node).equal?(-1))
        return 0
      end
      available_space = result.attr_length - result_idx
      # If we're asking for all children of the current node, simply call getChildren
      if ((range_start).equal?(0))
        if (@tree_size[node] <= available_space)
          return get_children(result, result_idx, node, sorted, mon)
        end
      end
      node = partition(node, mon)
      if ((node).equal?(-1))
        return 0
      end
      inserted = 0
      number_less_than_node = get_subtree_size(@left_sub_tree[node])
      if (range_start < number_less_than_node)
        if (inserted < available_space)
          inserted += get_range(result, result_idx, range_start, @left_sub_tree[node], sorted, mon)
        end
      end
      if (range_start <= number_less_than_node)
        if (inserted < available_space)
          result[result_idx + inserted] = @contents[node]
          inserted += 1
        end
      end
      if (inserted < available_space)
        inserted += get_range(result, result_idx + inserted, Math.max(range_start - number_less_than_node - 1, 0), @right_sub_tree[node], sorted, mon)
      end
      return inserted
    end
    
    typesig { [Array.typed(Object), ::Java::Int, ::Java::Int, ::Java::Boolean, FastProgressReporter] }
    # Fills in the available space in the given array with all children of the given node.
    # 
    # @param result
    # @param resultIdx index in the result array where we will begin filling in children
    # @param node
    # @return the number of children added to the array
    # @since 3.1
    def get_children(result, result_idx, node, sorted, mon)
      if ((node).equal?(-1))
        return 0
      end
      temp_idx = result_idx
      if (sorted)
        node = partition(node, mon)
        if ((node).equal?(-1))
          return 0
        end
      end
      # Add child nodes smaller than this one
      if (temp_idx < result.attr_length)
        temp_idx += get_children(result, temp_idx, @left_sub_tree[node], sorted, mon)
      end
      # Add the pivot
      if (temp_idx < result.attr_length)
        value = @contents[node]
        if (!(value).equal?(@lazy_removal_flag))
          result[((temp_idx += 1) - 1)] = value
        end
      end
      # Add child nodes larger than this one
      if (temp_idx < result.attr_length)
        temp_idx += get_children(result, temp_idx, @right_sub_tree[node], sorted, mon)
      end
      # Add unsorted children (should be empty if the sorted flag was true)
      unsorted_node = @next_unsorted[node]
      while !(unsorted_node).equal?(-1) && temp_idx < result.attr_length
        result[((temp_idx += 1) - 1)] = @contents[unsorted_node]
        unsorted_node = @next_unsorted[unsorted_node]
      end
      return temp_idx - result_idx
    end
    
    typesig { [Object] }
    # Returns true iff this collection contains the given item
    # 
    # @param item item to test
    # @return true iff this collection contains the given item
    def contains(item)
      Assert.is_not_null(item)
      return_value = (!(get_object_index(item)).equal?(-1))
      test_invariants
      return return_value
    end
    
    private
    alias_method :initialize__lazy_sorted_collection, :initialize
  end
  
end
