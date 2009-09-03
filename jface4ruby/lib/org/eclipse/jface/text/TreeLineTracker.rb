require "rjava"

# Copyright (c) 2005, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text
  module TreeLineTrackerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
      include_const ::Java::Util, :Arrays
      include_const ::Java::Util, :LinkedList
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :ListIterator
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Jface::Text::AbstractLineTracker, :DelimiterInfo
    }
  end
  
  # Abstract implementation of <code>ILineTracker</code>. It lets the definition of line
  # delimiters to subclasses. Assuming that '\n' is the only line delimiter, this abstract
  # implementation defines the following line scheme:
  # <ul>
  # <li> "" -> [0,0]
  # <li> "a" -> [0,1]
  # <li> "\n" -> [0,1], [1,0]
  # <li> "a\n" -> [0,2], [2,0]
  # <li> "a\nb" -> [0,2], [2,1]
  # <li> "a\nbc\n" -> [0,2], [2,3], [5,0]
  # </ul>
  # <p>
  # This class must be subclassed.
  # </p>
  # <p>
  # <strong>Performance:</strong> The query operations perform in <i>O(log n)</i> where <var>n</var>
  # is the number of lines in the document. The modification operations roughly perform in <i>O(l *
  # log n)</i> where <var>n</var> is the number of lines in the document and <var>l</var> is the
  # sum of the number of removed, added or modified lines.
  # </p>
  # 
  # @since 3.2
  class TreeLineTracker 
    include_class_members TreeLineTrackerImports
    include ILineTracker
    
    class_module.module_eval {
      # Differential Balanced Binary Tree
      # 
      # Assumption: lines cannot overlap => there exists a total ordering of the lines by their offset,
      # which is the same as the ordering by line number
      # 
      # Base idea: store lines in a binary search tree
      # - the key is the line number / line offset
      # -> lookup_line is O(log n)
      # -> lookup_offset is O(log n)
      # - a change in a line somewhere will change any succeeding line numbers / line offsets
      # -> replace is O(n)
      # 
      # Differential tree: instead of storing the key (line number, line offset) directly, every node
      # stores the difference between its key and its parent's key
      # - the sort key is still the line number / line offset, but it remains "virtual"
      # - inserting a node (a line) really increases the virtual key of all succeeding nodes (lines), but this
      # fact will not be realized in the key information encoded in the nodes.
      # -> any change only affects the nodes in the node's parent chain, although more bookkeeping
      # has to be done when changing a node or balancing the tree
      # -> replace is O(log n)
      # -> line offsets and line numbers have to be computed when walking the tree from the root /
      # from a node
      # -> still O(log n)
      # 
      # The balancing algorithm chosen does not depend on the differential tree property. An AVL tree
      # implementation has been chosen for simplicity.
      # 
      # 
      # Turns assertions on/off. Don't make this a a debug option for performance reasons - this way
      # the compiler can optimize the asserts away.
      const_set_lazy(:ASSERT) { false }
      const_attr_reader  :ASSERT
      
      # The empty delimiter of the last line. The last line and only the last line must have this
      # zero-length delimiter.
      const_set_lazy(:NO_DELIM) { "" }
      const_attr_reader  :NO_DELIM
      
      # $NON-NLS-1$
      # 
      # A node represents one line. Its character and line offsets are 0-based and relative to the
      # subtree covered by the node. All nodes under the left subtree represent lines before, all
      # nodes under the right subtree lines after the current node.
      const_set_lazy(:Node) { Class.new do
        include_class_members TreeLineTracker
        
        typesig { [::Java::Int, String] }
        def initialize(length, delimiter)
          @line = 0
          @offset = 0
          @length = 0
          @delimiter = nil
          @parent = nil
          @left = nil
          @right = nil
          @balance = 0
          @length = length
          @delimiter = delimiter
        end
        
        # The line index in this node's line tree, or equivalently, the number of lines in the left
        # subtree.
        attr_accessor :line
        alias_method :attr_line, :line
        undef_method :line
        alias_method :attr_line=, :line=
        undef_method :line=
        
        # The line offset in this node's line tree, or equivalently, the number of characters in
        # the left subtree.
        attr_accessor :offset
        alias_method :attr_offset, :offset
        undef_method :offset
        alias_method :attr_offset=, :offset=
        undef_method :offset=
        
        # The number of characters in this line.
        attr_accessor :length
        alias_method :attr_length, :length
        undef_method :length
        alias_method :attr_length=, :length=
        undef_method :length=
        
        # The line delimiter of this line, needed to answer the delimiter query.
        attr_accessor :delimiter
        alias_method :attr_delimiter, :delimiter
        undef_method :delimiter
        alias_method :attr_delimiter=, :delimiter=
        undef_method :delimiter=
        
        # The parent node, <code>null</code> if this is the root node.
        attr_accessor :parent
        alias_method :attr_parent, :parent
        undef_method :parent
        alias_method :attr_parent=, :parent=
        undef_method :parent=
        
        # The left subtree, possibly <code>null</code>.
        attr_accessor :left
        alias_method :attr_left, :left
        undef_method :left
        alias_method :attr_left=, :left=
        undef_method :left=
        
        # The right subtree, possibly <code>null</code>.
        attr_accessor :right
        alias_method :attr_right, :right
        undef_method :right
        alias_method :attr_right=, :right=
        undef_method :right=
        
        # The balance factor.
        attr_accessor :balance
        alias_method :attr_balance, :balance
        undef_method :balance
        alias_method :attr_balance=, :balance=
        undef_method :balance=
        
        typesig { [] }
        # @see java.lang.Object#toString()
        def to_s
          bal = nil
          case (@balance)
          when 0
            bal = "=" # $NON-NLS-1$
          when 1
            bal = "+" # $NON-NLS-1$
          when 2
            bal = "++" # $NON-NLS-1$
          when -1
            bal = "-" # $NON-NLS-1$
          when -2
            bal = "--" # $NON-NLS-1$
          else
            bal = RJava.cast_to_string(Byte.to_s(@balance))
          end
          return "[" + RJava.cast_to_string(@offset) + "+" + RJava.cast_to_string(pure_length) + "+" + RJava.cast_to_string(@delimiter.length) + "|" + RJava.cast_to_string(@line) + "|" + bal + "]" # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$ //$NON-NLS-4$ //$NON-NLS-5$ //$NON-NLS-6$
        end
        
        typesig { [] }
        # Returns the pure (without the line delimiter) length of this line.
        # 
        # @return the pure line length
        def pure_length
          return @length - @delimiter.length
        end
        
        private
        alias_method :initialize__node, :initialize
      end }
    }
    
    # The root node of the tree, never <code>null</code>.
    attr_accessor :f_root
    alias_method :attr_f_root, :f_root
    undef_method :f_root
    alias_method :attr_f_root=, :f_root=
    undef_method :f_root=
    
    typesig { [] }
    # Creates a new line tracker.
    def initialize
      @f_root = Node.new(0, NO_DELIM)
    end
    
    typesig { [ListLineTracker] }
    # Package visible constructor for creating a tree tracker from a list tracker.
    # 
    # @param tracker the list line tracker
    def initialize(tracker)
      @f_root = Node.new(0, NO_DELIM)
      lines = tracker.get_lines
      n = lines.size
      if ((n).equal?(0))
        return
      end
      line = lines.get(0)
      delim = line.attr_delimiter
      if ((delim).nil?)
        delim = NO_DELIM
      end
      length = line.attr_length
      @f_root = Node.new(length, delim)
      node = @f_root
      i = 1
      while i < n
        line = lines.get(i)
        delim = RJava.cast_to_string(line.attr_delimiter)
        if ((delim).nil?)
          delim = NO_DELIM
        end
        length = line.attr_length
        node = insert_after(node, length, delim)
        i += 1
      end
      if (!(node.attr_delimiter).equal?(NO_DELIM))
        insert_after(node, 0, NO_DELIM)
      end
      if (ASSERT)
        check_tree
      end
    end
    
    typesig { [::Java::Int] }
    # Returns the node (line) including a certain offset. If the offset is between two
    # lines, the line starting at <code>offset</code> is returned.
    # <p>
    # This means that for offsets smaller than the length, the following holds:
    # </p>
    # <p>
    # <code>line.offset <= offset < line.offset + offset.length</code>.
    # </p>
    # <p>
    # If <code>offset</code> is the document length, then this is true:
    # </p>
    # <p>
    # <code>offset= line.offset + line.length</code>.
    # </p>
    # 
    # @param offset a document offset
    # @return the line starting at or containing <code>offset</code>
    # @throws BadLocationException if the offset is invalid
    def node_by_offset(offset)
      # Works for any binary search tree.
      remaining = offset
      node = @f_root
      line = 0
      while (true)
        if ((node).nil?)
          fail(offset)
        end
        if (remaining < node.attr_offset)
          node = node.attr_left
        else
          remaining -= node.attr_offset
          line += node.attr_line
          if (remaining < node.attr_length || (remaining).equal?(node.attr_length) && (node.attr_right).nil?)
            # last line
            break
          end
          remaining -= node.attr_length
          line += 1
          node = node.attr_right
        end
      end
      return node
    end
    
    typesig { [::Java::Int] }
    # Returns the line number for the given offset. If the offset is between two lines, the line
    # starting at <code>offset</code> is returned. The last line is returned if
    # <code>offset</code> is equal to the document length.
    # 
    # @param offset a document offset
    # @return the line number starting at or containing <code>offset</code>
    # @throws BadLocationException if the offset is invalid
    def line_by_offset(offset)
      # Works for any binary search tree.
      remaining = offset
      node = @f_root
      line = 0
      while (true)
        if ((node).nil?)
          fail(offset)
        end
        if (remaining < node.attr_offset)
          node = node.attr_left
        else
          remaining -= node.attr_offset
          line += node.attr_line
          if (remaining < node.attr_length || (remaining).equal?(node.attr_length) && (node.attr_right).nil?)
            # last line
            return line
          end
          remaining -= node.attr_length
          line += 1
          node = node.attr_right
        end
      end
    end
    
    typesig { [::Java::Int] }
    # Returns the node (line) with the given line number. Note that the last line is always
    # incomplete, i.e. has the {@link #NO_DELIM} delimiter.
    # 
    # @param line a line number
    # @return the line with the given line number
    # @throws BadLocationException if the line is invalid
    def node_by_line(line)
      # Works for any binary search tree.
      remaining = line
      offset = 0
      node = @f_root
      while (true)
        if ((node).nil?)
          fail(line)
        end
        if ((remaining).equal?(node.attr_line))
          break
        end
        if (remaining < node.attr_line)
          node = node.attr_left
        else
          remaining -= node.attr_line + 1
          offset += node.attr_offset + node.attr_length
          node = node.attr_right
        end
      end
      return node
    end
    
    typesig { [::Java::Int] }
    # Returns the offset for the given line number. Note that the
    # last line is always incomplete, i.e. has the {@link #NO_DELIM} delimiter.
    # 
    # @param line a line number
    # @return the line offset with the given line number
    # @throws BadLocationException if the line is invalid
    def offset_by_line(line)
      # Works for any binary search tree.
      remaining = line
      offset = 0
      node = @f_root
      while (true)
        if ((node).nil?)
          fail(line)
        end
        if ((remaining).equal?(node.attr_line))
          return offset + node.attr_offset
        end
        if (remaining < node.attr_line)
          node = node.attr_left
        else
          remaining -= node.attr_line + 1
          offset += node.attr_offset + node.attr_length
          node = node.attr_right
        end
      end
    end
    
    typesig { [Node] }
    # Left rotation - the given node is rotated down, its right child is rotated up, taking the
    # previous structural position of <code>node</code>.
    # 
    # @param node the node to rotate around
    def rotate_left(node)
      if (ASSERT)
        Assert.is_not_null(node)
      end
      child = node.attr_right
      if (ASSERT)
        Assert.is_not_null(child)
      end
      left_child = (node.attr_parent).nil? || (node).equal?(node.attr_parent.attr_left)
      # restructure
      set_child(node.attr_parent, child, left_child)
      set_child(node, child.attr_left, false)
      set_child(child, node, true)
      # update relative info
      # child becomes the new parent, its line and offset counts increase as the former parent
      # moves under child's left subtree
      child.attr_line += node.attr_line + 1
      child.attr_offset += node.attr_offset + node.attr_length
    end
    
    typesig { [Node] }
    # Right rotation - the given node is rotated down, its left child is rotated up, taking the
    # previous structural position of <code>node</code>.
    # 
    # @param node the node to rotate around
    def rotate_right(node)
      if (ASSERT)
        Assert.is_not_null(node)
      end
      child = node.attr_left
      if (ASSERT)
        Assert.is_not_null(child)
      end
      left_child = (node.attr_parent).nil? || (node).equal?(node.attr_parent.attr_left)
      set_child(node.attr_parent, child, left_child)
      set_child(node, child.attr_right, true)
      set_child(child, node, false)
      # update relative info
      # node loses its left subtree, except for what it keeps in its new subtree
      # this is exactly the amount in child
      node.attr_line -= child.attr_line + 1
      node.attr_offset -= child.attr_offset + child.attr_length
    end
    
    typesig { [Node, Node, ::Java::Boolean] }
    # Helper method for moving a child, ensuring that parent pointers are set correctly.
    # 
    # @param parent the new parent of <code>child</code>, <code>null</code> to replace the
    # root node
    # @param child the new child of <code>parent</code>, may be <code>null</code>
    # @param isLeftChild <code>true</code> if <code>child</code> shall become
    # <code>parent</code>'s left child, <code>false</code> if it shall become
    # <code>parent</code>'s right child
    def set_child(parent, child, is_left_child)
      if ((parent).nil?)
        if ((child).nil?)
          @f_root = Node.new(0, NO_DELIM)
        else
          @f_root = child
        end
      else
        if (is_left_child)
          parent.attr_left = child
        else
          parent.attr_right = child
        end
      end
      if (!(child).nil?)
        child.attr_parent = parent
      end
    end
    
    typesig { [Node, Node] }
    # A left rotation around <code>parent</code>, whose structural position is replaced by
    # <code>node</code>.
    # 
    # @param node the node moving up and left
    # @param parent the node moving left and down
    def single_left_rotation(node, parent)
      rotate_left(parent)
      node.attr_balance = 0
      parent.attr_balance = 0
    end
    
    typesig { [Node, Node] }
    # A right rotation around <code>parent</code>, whose structural position is replaced by
    # <code>node</code>.
    # 
    # @param node the node moving up and right
    # @param parent the node moving right and down
    def single_right_rotation(node, parent)
      rotate_right(parent)
      node.attr_balance = 0
      parent.attr_balance = 0
    end
    
    typesig { [Node, Node] }
    # A double left rotation, first rotating right around <code>node</code>, then left around
    # <code>parent</code>.
    # 
    # @param node the node that will be rotated right
    # @param parent the node moving left and down
    def right_left_rotation(node, parent)
      child = node.attr_left
      rotate_right(node)
      rotate_left(parent)
      if ((child.attr_balance).equal?(1))
        node.attr_balance = 0
        parent.attr_balance = -1
        child.attr_balance = 0
      else
        if ((child.attr_balance).equal?(0))
          node.attr_balance = 0
          parent.attr_balance = 0
        else
          if ((child.attr_balance).equal?(-1))
            node.attr_balance = 1
            parent.attr_balance = 0
            child.attr_balance = 0
          end
        end
      end
    end
    
    typesig { [Node, Node] }
    # A double right rotation, first rotating left around <code>node</code>, then right around
    # <code>parent</code>.
    # 
    # @param node the node that will be rotated left
    # @param parent the node moving right and down
    def left_right_rotation(node, parent)
      child = node.attr_right
      rotate_left(node)
      rotate_right(parent)
      if ((child.attr_balance).equal?(-1))
        node.attr_balance = 0
        parent.attr_balance = 1
        child.attr_balance = 0
      else
        if ((child.attr_balance).equal?(0))
          node.attr_balance = 0
          parent.attr_balance = 0
        else
          if ((child.attr_balance).equal?(1))
            node.attr_balance = -1
            parent.attr_balance = 0
            child.attr_balance = 0
          end
        end
      end
    end
    
    typesig { [Node, ::Java::Int, String] }
    # Inserts a line with the given length and delimiter after <code>node</code>.
    # 
    # @param node the predecessor of the inserted node
    # @param length the line length of the inserted node
    # @param delimiter the delimiter of the inserted node
    # @return the inserted node
    def insert_after(node, length, delimiter)
      # An insertion really shifts the key of all succeeding nodes. Hence we insert the added node
      # between node and the successor of node. The added node becomes either the right child
      # of the predecessor node, or the left child of the successor node.
      added = Node.new(length, delimiter)
      if ((node.attr_right).nil?)
        set_child(node, added, false)
      else
        set_child(successor_down(node.attr_right), added, true)
      end
      # parent chain update
      update_parent_chain(added, length, 1)
      update_parent_balance_after_insertion(added)
      return added
    end
    
    typesig { [Node] }
    # Updates the balance information in the parent chain of node until it reaches the root or
    # finds a node whose balance violates the AVL constraint, which is the re-balanced.
    # 
    # @param node the child of the first node that needs balance updating
    def update_parent_balance_after_insertion(node)
      parent = node.attr_parent
      while (!(parent).nil?)
        if ((node).equal?(parent.attr_left))
          parent.attr_balance -= 1
        else
          parent.attr_balance += 1
        end
        case (parent.attr_balance)
        when 1, -1
          node = parent
          parent = node.attr_parent
          next
          rebalance_after_insertion_left(node)
        when -2
          rebalance_after_insertion_left(node)
        when 2
          rebalance_after_insertion_right(node)
        when 0
        else
          if (ASSERT)
            Assert.is_true(false)
          end
        end
        return
      end
    end
    
    typesig { [Node] }
    # Re-balances a node whose parent has a double positive balance.
    # 
    # @param node the node to re-balance
    def rebalance_after_insertion_right(node)
      parent = node.attr_parent
      if ((node.attr_balance).equal?(1))
        single_left_rotation(node, parent)
      else
        if ((node.attr_balance).equal?(-1))
          right_left_rotation(node, parent)
        else
          if (ASSERT)
            Assert.is_true(false)
          end
        end
      end
    end
    
    typesig { [Node] }
    # Re-balances a node whose parent has a double negative balance.
    # 
    # @param node the node to re-balance
    def rebalance_after_insertion_left(node)
      parent = node.attr_parent
      if ((node.attr_balance).equal?(-1))
        single_right_rotation(node, parent)
      else
        if ((node.attr_balance).equal?(1))
          left_right_rotation(node, parent)
        else
          if (ASSERT)
            Assert.is_true(false)
          end
        end
      end
    end
    
    typesig { [::Java::Int, ::Java::Int, String] }
    # @see org.eclipse.jface.text.ILineTracker#replace(int, int, java.lang.String)
    def replace(offset, length, text)
      if (ASSERT)
        check_tree
      end
      # Inlined nodeByOffset as we need both node and offset
      remaining = offset
      first = @f_root
      first_node_offset = 0
      while (true)
        if ((first).nil?)
          fail(offset)
        end
        if (remaining < first.attr_offset)
          first = first.attr_left
        else
          remaining -= first.attr_offset
          if (remaining < first.attr_length || (remaining).equal?(first.attr_length) && (first.attr_right).nil?)
            # last line
            first_node_offset = offset - remaining
            break
          end
          remaining -= first.attr_length
          first = first.attr_right
        end
      end
      # Inline nodeByOffset end
      if (ASSERT)
        Assert.is_true(!(first).nil?)
      end
      last = nil
      if (offset + length < first_node_offset + first.attr_length)
        last = first
      else
        last = node_by_offset(offset + length)
      end
      if (ASSERT)
        Assert.is_true(!(last).nil?)
      end
      first_line_delta = first_node_offset + first.attr_length - offset
      if ((first).equal?(last))
        replace_internal(first, text, length, first_line_delta)
      else
        replace_from_to(first, last, text, length, first_line_delta)
      end
      if (ASSERT)
        check_tree
      end
    end
    
    typesig { [Node, String, ::Java::Int, ::Java::Int] }
    # Replace happening inside a single line.
    # 
    # @param node the affected node
    # @param text the added text
    # @param length the replace length, &lt; <code>firstLineDelta</code>
    # @param firstLineDelta the number of characters from the replacement offset to the end of
    # <code>node</code> &gt; <code>length</code>
    def replace_internal(node, text, length, first_line_delta)
      # 1) modification on a single line
      info = (text).nil? ? nil : next_delimiter_info(text, 0)
      if ((info).nil? || (info.attr_delimiter).nil?)
        # a) trivial case: insert into a single node, no line mangling
        added = (text).nil? ? 0 : text.length
        update_length(node, added - length)
      else
        # b) more lines to add between two chunks of the first node
        # remember what we split off the first line
        remainder = first_line_delta - length
        rem_delim = node.attr_delimiter
        # join the first line with the first added
        consumed = info.attr_delimiter_index + info.attr_delimiter_length
        delta = consumed - first_line_delta
        update_length(node, delta)
        node.attr_delimiter = info.attr_delimiter
        # Inline addlines start
        info = next_delimiter_info(text, consumed)
        while (!(info).nil?)
          line_len = info.attr_delimiter_index - consumed + info.attr_delimiter_length
          node = insert_after(node, line_len, info.attr_delimiter)
          consumed += line_len
          info = next_delimiter_info(text, consumed)
        end
        # Inline addlines end
        # add remaining chunk merged with last (incomplete) additional line
        insert_after(node, remainder + text.length - consumed, rem_delim)
      end
    end
    
    typesig { [Node, Node, String, ::Java::Int, ::Java::Int] }
    # Replace spanning from one node to another.
    # 
    # @param node the first affected node
    # @param last the last affected node
    # @param text the added text
    # @param length the replace length, &gt;= <code>firstLineDelta</code>
    # @param firstLineDelta the number of characters removed from the replacement offset to the end
    # of <code>node</code>, &lt;= <code>length</code>
    def replace_from_to(node, last, text, length_, first_line_delta)
      # 2) modification covers several lines
      # delete intermediate nodes
      # TODO could be further optimized: replace intermediate lines with intermediate added lines
      # to reduce re-balancing
      successor_ = successor(node)
      while (!(successor_).equal?(last))
        length_ -= successor_.attr_length
        to_delete = successor_
        successor_ = successor(successor_)
        update_length(to_delete, -to_delete.attr_length)
      end
      info = (text).nil? ? nil : next_delimiter_info(text, 0)
      if ((info).nil? || (info.attr_delimiter).nil?)
        added = (text).nil? ? 0 : text.length
        # join the two lines if there are no lines added
        join(node, last, added - length_)
      else
        # join the first line with the first added
        consumed = info.attr_delimiter_index + info.attr_delimiter_length
        update_length(node, consumed - first_line_delta)
        node.attr_delimiter = info.attr_delimiter
        length_ -= first_line_delta
        # Inline addLines start
        info = next_delimiter_info(text, consumed)
        while (!(info).nil?)
          line_len = info.attr_delimiter_index - consumed + info.attr_delimiter_length
          node = insert_after(node, line_len, info.attr_delimiter)
          consumed += line_len
          info = next_delimiter_info(text, consumed)
        end
        # Inline addLines end
        update_length(last, text.length - consumed - length_)
      end
    end
    
    typesig { [Node, Node, ::Java::Int] }
    # Joins two consecutive node lines, additionally adjusting the resulting length of the combined
    # line by <code>delta</code>. The first node gets deleted.
    # 
    # @param one the first node to join
    # @param two the second node to join
    # @param delta the delta to apply to the remaining single node
    def join(one, two, delta)
      one_length = one.attr_length
      update_length(one, -one_length)
      update_length(two, one_length + delta)
    end
    
    typesig { [Node, ::Java::Int] }
    # Adjusts the length of a node by <code>delta</code>, also adjusting the parent chain of
    # <code>node</code>. If the node's length becomes zero and is not the last (incomplete)
    # node, it is deleted after the update.
    # 
    # @param node the node to adjust
    # @param delta the character delta to add to the node's length
    def update_length(node, delta)
      if (ASSERT)
        Assert.is_true(node.attr_length + delta >= 0)
      end
      # update the node itself
      node.attr_length += delta
      # check deletion
      line_delta = 0
      delete = (node.attr_length).equal?(0) && !(node.attr_delimiter).equal?(NO_DELIM)
      if (delete)
        line_delta = -1
      else
        line_delta = 0
      end
      # update parent chain
      if (!(delta).equal?(0) || !(line_delta).equal?(0))
        update_parent_chain(node, delta, line_delta)
      end
      if (delete)
        delete(node)
      end
    end
    
    typesig { [Node, ::Java::Int, ::Java::Int] }
    # Updates the differential indices following the parent chain. All nodes from
    # <code>from.parent</code> to the root are updated.
    # 
    # @param node the child of the first node to update
    # @param deltaLength the character delta
    # @param deltaLines the line delta
    def update_parent_chain(node, delta_length, delta_lines)
      update_parent_chain(node, nil, delta_length, delta_lines)
    end
    
    typesig { [Node, Node, ::Java::Int, ::Java::Int] }
    # Updates the differential indices following the parent chain. All nodes from
    # <code>from.parent</code> to <code>to</code> (exclusive) are updated.
    # 
    # @param from the child of the first node to update
    # @param to the first node not to update
    # @param deltaLength the character delta
    # @param deltaLines the line delta
    def update_parent_chain(from, to, delta_length, delta_lines)
      parent = from.attr_parent
      while (!(parent).equal?(to))
        # only update node if update comes from left subtree
        if ((from).equal?(parent.attr_left))
          parent.attr_offset += delta_length
          parent.attr_line += delta_lines
        end
        from = parent
        parent = from.attr_parent
      end
    end
    
    typesig { [Node] }
    # Deletes a node from the tree, re-balancing it if necessary. The differential indices in the
    # node's parent chain have to be updated in advance to calling this method. Generally, don't
    # call <code>delete</code> directly, but call <code>update_length(node, -node.length)</code> to
    # properly remove a node.
    # 
    # @param node the node to delete.
    def delete(node)
      if (ASSERT)
        Assert.is_true(!(node).nil?)
      end
      if (ASSERT)
        Assert.is_true((node.attr_length).equal?(0))
      end
      parent = node.attr_parent
      to_update = nil # the parent of the node that lost a child
      lost_left_child = false
      is_left_child = (parent).nil? || (node).equal?(parent.attr_left)
      if ((node.attr_left).nil? || (node.attr_right).nil?)
        # 1) node has one child at max - replace parent's pointer with the only child
        # also handles the trivial case of no children
        replacement = (node.attr_left).nil? ? node.attr_right : node.attr_left
        set_child(parent, replacement, is_left_child)
        to_update = parent
        lost_left_child = is_left_child
        # no updates to do - subtrees stay as they are
      else
        if ((node.attr_right.attr_left).nil?)
          # 2a) node's right child has no left child - replace node with right child, giving node's
          # left subtree to the right child
          replacement = node.attr_right
          set_child(parent, replacement, is_left_child)
          set_child(replacement, node.attr_left, true)
          replacement.attr_line = node.attr_line
          replacement.attr_offset = node.attr_offset
          replacement.attr_balance = node.attr_balance
          to_update = replacement
          lost_left_child = false
          # } else if (node.left.right == null) {
          # // 2b) symmetric case
          # Node replacement= node.left;
          # set_child(parent, replacement, isLeftChild);
          # set_child(replacement, node.right, false);
          # replacement.balance= node.balance;
          # toUpdate= replacement;
          # lostLeftChild= true;
        else
          # 3) hard case - replace node with its successor
          successor_ = successor(node)
          # successor exists (otherwise node would not have right child, case 1)
          if (ASSERT)
            Assert.is_not_null(successor_)
          end
          # successor has no left child (a left child would be the real successor of node)
          if (ASSERT)
            Assert.is_true((successor_.attr_left).nil?)
          end
          if (ASSERT)
            Assert.is_true((successor_.attr_line).equal?(0))
          end
          # successor is the left child of its parent (otherwise parent would be smaller and
          # hence the real successor)
          if (ASSERT)
            Assert.is_true((successor_).equal?(successor_.attr_parent.attr_left))
          end
          # successor is not a child of node (would have been covered by 2a)
          if (ASSERT)
            Assert.is_true(!(successor_.attr_parent).equal?(node))
          end
          to_update = successor_.attr_parent
          lost_left_child = true
          # update relative indices
          update_parent_chain(successor_, node, -successor_.attr_length, -1)
          # delete successor from its current place - like 1)
          set_child(to_update, successor_.attr_right, true)
          # move node's subtrees to its successor
          set_child(successor_, node.attr_right, false)
          set_child(successor_, node.attr_left, true)
          # replace node by successor in its parent
          set_child(parent, successor_, is_left_child)
          # update the successor
          successor_.attr_line = node.attr_line
          successor_.attr_offset = node.attr_offset
          successor_.attr_balance = node.attr_balance
        end
      end
      update_parent_balance_after_deletion(to_update, lost_left_child)
    end
    
    typesig { [Node, ::Java::Boolean] }
    # Updates the balance information in the parent chain of node.
    # 
    # @param node the first node that needs balance updating
    # @param wasLeftChild <code>true</code> if the deletion happened on <code>node</code>'s
    # left subtree, <code>false</code> if it occurred on <code>node</code>'s right
    # subtree
    def update_parent_balance_after_deletion(node, was_left_child)
      while (!(node).nil?)
        if (was_left_child)
          node.attr_balance += 1
        else
          node.attr_balance -= 1
        end
        parent = node.attr_parent
        if (!(parent).nil?)
          was_left_child = (node).equal?(parent.attr_left)
        end
        case (node.attr_balance)
        # done, no tree change
        # propagate up
        # propagate up
        # propagate up
        when 1, -1
          return
        when -2
          if (rebalance_after_deletion_right(node.attr_left))
            return
          end
        when 2
          if (rebalance_after_deletion_left(node.attr_right))
            return
          end
        when 0
        else
          if (ASSERT)
            Assert.is_true(false)
          end
        end
        node = parent
      end
    end
    
    typesig { [Node] }
    # Re-balances a node whose parent has a double positive balance.
    # 
    # @param node the node to re-balance
    # @return <code>true</code> if the re-balancement leaves the height at
    # <code>node.parent</code> constant, <code>false</code> if the height changed
    def rebalance_after_deletion_left(node)
      parent = node.attr_parent
      if ((node.attr_balance).equal?(1))
        single_left_rotation(node, parent)
        return false
      else
        if ((node.attr_balance).equal?(-1))
          right_left_rotation(node, parent)
          return false
        else
          if ((node.attr_balance).equal?(0))
            rotate_left(parent)
            node.attr_balance = -1
            parent.attr_balance = 1
            return true
          else
            if (ASSERT)
              Assert.is_true(false)
            end
            return true
          end
        end
      end
    end
    
    typesig { [Node] }
    # Re-balances a node whose parent has a double negative balance.
    # 
    # @param node the node to re-balance
    # @return <code>true</code> if the re-balancement leaves the height at
    # <code>node.parent</code> constant, <code>false</code> if the height changed
    def rebalance_after_deletion_right(node)
      parent = node.attr_parent
      if ((node.attr_balance).equal?(-1))
        single_right_rotation(node, parent)
        return false
      else
        if ((node.attr_balance).equal?(1))
          left_right_rotation(node, parent)
          return false
        else
          if ((node.attr_balance).equal?(0))
            rotate_right(parent)
            node.attr_balance = 1
            parent.attr_balance = -1
            return true
          else
            if (ASSERT)
              Assert.is_true(false)
            end
            return true
          end
        end
      end
    end
    
    typesig { [Node] }
    # Returns the successor of a node, <code>null</code> if node is the last node.
    # 
    # @param node a node
    # @return the successor of <code>node</code>, <code>null</code> if there is none
    def successor(node)
      if (!(node.attr_right).nil?)
        return successor_down(node.attr_right)
      end
      return successor_up(node)
    end
    
    typesig { [Node] }
    # Searches the successor of <code>node</code> in its parent chain.
    # 
    # @param node a node
    # @return the first node in <code>node</code>'s parent chain that is reached from its left
    # subtree, <code>null</code> if there is none
    def successor_up(node)
      child = node
      parent = child.attr_parent
      while (!(parent).nil?)
        if ((child).equal?(parent.attr_left))
          return parent
        end
        child = parent
        parent = child.attr_parent
      end
      if (ASSERT)
        Assert.is_true((node.attr_delimiter).equal?(NO_DELIM))
      end
      return nil
    end
    
    typesig { [Node] }
    # Searches the left-most node in a given subtree.
    # 
    # @param node a node
    # @return the left-most node in the given subtree
    def successor_down(node)
      child = node.attr_left
      while (!(child).nil?)
        node = child
        child = node.attr_left
      end
      return node
    end
    
    typesig { [::Java::Int] }
    # miscellaneous
    # 
    # Throws an exception.
    # 
    # @param offset the illegal character or line offset that caused the exception
    # @throws BadLocationException always
    def fail(offset)
      raise BadLocationException.new
    end
    
    typesig { [String, ::Java::Int] }
    # Returns the information about the first delimiter found in the given
    # text starting at the given offset.
    # 
    # @param text the text to be searched
    # @param offset the offset in the given text
    # @return the information of the first found delimiter or <code>null</code>
    def next_delimiter_info(text, offset)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    # @see org.eclipse.jface.text.ILineTracker#getLineDelimiter(int)
    def get_line_delimiter(line)
      node = node_by_line(line)
      return (node.attr_delimiter).equal?(NO_DELIM) ? nil : node.attr_delimiter
    end
    
    typesig { [String] }
    # @see org.eclipse.jface.text.ILineTracker#computeNumberOfLines(java.lang.String)
    def compute_number_of_lines(text)
      count = 0
      start = 0
      delimiter_info = next_delimiter_info(text, start)
      while (!(delimiter_info).nil? && delimiter_info.attr_delimiter_index > -1)
        (count += 1)
        start = delimiter_info.attr_delimiter_index + delimiter_info.attr_delimiter_length
        delimiter_info = next_delimiter_info(text, start)
      end
      return count
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.ILineTracker#getNumberOfLines()
    def get_number_of_lines
      # TODO track separately?
      node = @f_root
      lines = 0
      while (!(node).nil?)
        lines += node.attr_line + 1
        node = node.attr_right
      end
      return lines
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # @see org.eclipse.jface.text.ILineTracker#getNumberOfLines(int, int)
    def get_number_of_lines(offset, length_)
      if ((length_).equal?(0))
        return 1
      end
      start_line = line_by_offset(offset)
      end_line = line_by_offset(offset + length_)
      return end_line - start_line + 1
    end
    
    typesig { [::Java::Int] }
    # @see org.eclipse.jface.text.ILineTracker#getLineOffset(int)
    def get_line_offset(line)
      return offset_by_line(line)
    end
    
    typesig { [::Java::Int] }
    # @see org.eclipse.jface.text.ILineTracker#getLineLength(int)
    def get_line_length(line)
      node = node_by_line(line)
      return node.attr_length
    end
    
    typesig { [::Java::Int] }
    # @see org.eclipse.jface.text.ILineTracker#getLineNumberOfOffset(int)
    def get_line_number_of_offset(offset)
      return line_by_offset(offset)
    end
    
    typesig { [::Java::Int] }
    # @see org.eclipse.jface.text.ILineTracker#getLineInformationOfOffset(int)
    def get_line_information_of_offset(offset)
      # Inline nodeByOffset start as we need both node and offset
      remaining = offset
      node = @f_root
      line_offset = 0
      while (true)
        if ((node).nil?)
          fail(offset)
        end
        if (remaining < node.attr_offset)
          node = node.attr_left
        else
          remaining -= node.attr_offset
          if (remaining < node.attr_length || (remaining).equal?(node.attr_length) && (node.attr_right).nil?)
            # last line
            line_offset = offset - remaining
            break
          end
          remaining -= node.attr_length
          node = node.attr_right
        end
      end
      # Inline nodeByOffset end
      return Region.new(line_offset, node.pure_length)
    end
    
    typesig { [::Java::Int] }
    # @see org.eclipse.jface.text.ILineTracker#getLineInformation(int)
    def get_line_information(line)
      begin
        # Inline nodeByLine start
        remaining = line
        offset = 0
        node = @f_root
        while (true)
          if ((node).nil?)
            fail(line)
          end
          if ((remaining).equal?(node.attr_line))
            offset += node.attr_offset
            break
          end
          if (remaining < node.attr_line)
            node = node.attr_left
          else
            remaining -= node.attr_line + 1
            offset += node.attr_offset + node.attr_length
            node = node.attr_right
          end
        end
        # Inline nodeByLine end
        return Region.new(offset, node.pure_length)
      rescue BadLocationException => x
        # FIXME: this really strange behavior is mandated by the previous line tracker
        # implementation and included here for compatibility. See
        # LineTrackerTest3#testFunnyLastLineCompatibility().
        if (line > 0 && (line).equal?(get_number_of_lines))
          line = line - 1
          # Inline nodeByLine start
          remaining_ = line
          offset_ = 0
          node_ = @f_root
          while (true)
            if ((node_).nil?)
              fail(line)
            end
            if ((remaining_).equal?(node_.attr_line))
              offset_ += node_.attr_offset
              break
            end
            if (remaining_ < node_.attr_line)
              node_ = node_.attr_left
            else
              remaining_ -= node_.attr_line + 1
              offset_ += node_.attr_offset + node_.attr_length
              node_ = node_.attr_right
            end
          end
          last = node_
          # Inline nodeByLine end
          if (last.attr_length > 0)
            return Region.new(offset_ + last.attr_length, 0)
          end
        end
        raise x
      end
    end
    
    typesig { [String] }
    # @see org.eclipse.jface.text.ILineTracker#set(java.lang.String)
    def set(text)
      @f_root = Node.new(0, NO_DELIM)
      begin
        replace(0, 0, text)
      rescue BadLocationException => x
        raise InternalError.new
      end
    end
    
    typesig { [] }
    # @see java.lang.Object#toString()
    def to_s
      depth = compute_depth(@f_root)
      width = 30
      leaves = RJava.cast_to_int(Math.pow(2, depth - 1))
      width_ = width * leaves
      empty = "." # $NON-NLS-1$
      roots = LinkedList.new
      roots.add(@f_root)
      buf = StringBuffer.new((width_ + 1) * depth)
      nodes = 1
      indents = leaves
      space = CharArray.new(leaves * width / 2)
      Arrays.fill(space, Character.new(?\s.ord))
      d = 0
      while d < depth
        # compute indent
        indents /= 2
        spaces = Math.max(0, indents * width - width / 2)
        # print nodes
        it = roots.list_iterator
        while it.has_next
          # pad before
          buf.append(space, 0, spaces)
          node = it.next_
          box = nil
          # replace the node with its children
          if ((node).nil?)
            it.add(nil)
            box = empty
          else
            it.set(node.attr_left)
            it.add(node.attr_right)
            box = RJava.cast_to_string(node.to_s)
          end
          # draw the node, pad to WIDTH
          pad_left = (width - box.length + 1) / 2
          pad_right = width - box.length - pad_left
          buf.append(space, 0, pad_left)
          buf.append(box)
          buf.append(space, 0, pad_right)
          # pad after
          buf.append(space, 0, spaces)
        end
        buf.append(Character.new(?\n.ord))
        nodes *= 2
        d += 1
      end
      return buf.to_s
    end
    
    typesig { [Node] }
    # Recursively computes the depth of the tree. Only used by {@link #toString()}.
    # 
    # @param root the subtree to compute the depth of, may be <code>null</code>
    # @return the depth of the given tree, 0 if it is <code>null</code>
    def compute_depth(root)
      if ((root).nil?)
        return 0
      end
      return (Math.max(compute_depth(root.attr_left), compute_depth(root.attr_right)) + 1)
    end
    
    typesig { [] }
    # Debug-only method that checks the tree structure and the differential offsets.
    def check_tree
      check_tree_structure(@f_root)
      begin
        check_tree_offsets(node_by_offset(0), Array.typed(::Java::Int).new([0, 0]), nil)
      rescue BadLocationException => x
        raise AssertionError.new
      end
    end
    
    typesig { [Node] }
    # Debug-only method that validates the tree structure below <code>node</code>. I.e. it
    # checks whether all parent/child pointers are consistent and whether the AVL balance
    # information is correct.
    # 
    # @param node the node to validate
    # @return the depth of the tree under <code>node</code>
    def check_tree_structure(node)
      if ((node).nil?)
        return 0
      end
      left_depth = check_tree_structure(node.attr_left)
      right_depth = check_tree_structure(node.attr_right)
      Assert.is_true((node.attr_balance).equal?(right_depth - left_depth))
      Assert.is_true((node.attr_left).nil? || (node.attr_left.attr_parent).equal?(node))
      Assert.is_true((node.attr_right).nil? || (node.attr_right.attr_parent).equal?(node))
      return (Math.max(right_depth, left_depth) + 1)
    end
    
    typesig { [Node, Array.typed(::Java::Int), Node] }
    # Debug-only method that checks the differential offsets of the tree, starting at
    # <code>node</code> and continuing until <code>last</code>.
    # 
    # @param node the first <code>Node</code> to check, may be <code>null</code>
    # @param offLen an array of length 2, with <code>offLen[0]</code> the expected offset of
    # <code>node</code> and <code>offLen[1]</code> the expected line of
    # <code>node</code>
    # @param last the last <code>Node</code> to check, may be <code>null</code>
    # @return an <code>int[]</code> of length 2, with the first element being the character
    # length of <code>node</code>'s subtree, and the second element the number of lines
    # in <code>node</code>'s subtree
    def check_tree_offsets(node, off_len, last)
      if ((node).equal?(last))
        return off_len
      end
      Assert.is_true((node.attr_offset).equal?(off_len[0]))
      Assert.is_true((node.attr_line).equal?(off_len[1]))
      if (!(node.attr_right).nil?)
        result = check_tree_offsets(successor_down(node.attr_right), Array.typed(::Java::Int).new(2) { 0 }, node)
        off_len[0] += result[0]
        off_len[1] += result[1]
      end
      off_len[0] += node.attr_length
      off_len[1] += 1
      return check_tree_offsets(node.attr_parent, off_len, last)
    end
    
    private
    alias_method :initialize__tree_line_tracker, :initialize
  end
  
end
