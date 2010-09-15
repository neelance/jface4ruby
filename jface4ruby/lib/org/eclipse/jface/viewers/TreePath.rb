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
  module TreePathImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
      include_const ::Org::Eclipse::Core::Runtime, :Assert
    }
  end
  
  # A tree path denotes a model element in a tree viewer. Tree path objects have
  # value semantics. A model element is represented by a path of elements in the
  # tree from the root element to the leaf element.
  # <p>
  # Clients may instantiate this class. Not intended to be subclassed.
  # </p>
  # 
  # @since 3.2
  class TreePath 
    include_class_members TreePathImports
    
    class_module.module_eval {
      # Constant for representing an empty tree path.
      const_set_lazy(:EMPTY) { TreePath.new(Array.typed(Object).new(0) { nil }) }
      const_attr_reader  :EMPTY
    }
    
    attr_accessor :segments
    alias_method :attr_segments, :segments
    undef_method :segments
    alias_method :attr_segments=, :segments=
    undef_method :segments=
    
    attr_accessor :hash
    alias_method :attr_hash, :hash
    undef_method :hash
    alias_method :attr_hash=, :hash=
    undef_method :hash=
    
    typesig { [Array.typed(Object)] }
    # Constructs a path identifying a leaf node in a tree.
    # 
    # @param segments
    # path of elements to a leaf node in a tree, starting with the
    # root element
    def initialize(segments)
      @segments = nil
      @hash = 0
      Assert.is_not_null(segments)
      i = 0
      while i < segments.attr_length
        Assert.is_not_null(segments[i])
        i += 1
      end
      @segments = segments
    end
    
    typesig { [::Java::Int] }
    # Returns the element at the specified index in this path.
    # 
    # @param index
    # index of element to return
    # @return element at the specified index
    def get_segment(index)
      return @segments[index]
    end
    
    typesig { [] }
    # Returns the number of elements in this path.
    # 
    # @return the number of elements in this path
    def get_segment_count
      return @segments.attr_length
    end
    
    typesig { [] }
    # Returns the first element in this path, or <code>null</code> if this
    # path has no segments.
    # 
    # @return the first element in this path
    def get_first_segment
      if ((@segments.attr_length).equal?(0))
        return nil
      end
      return @segments[0]
    end
    
    typesig { [] }
    # Returns the last element in this path, or <code>null</code> if this
    # path has no segments.
    # 
    # @return the last element in this path
    def get_last_segment
      if ((@segments.attr_length).equal?(0))
        return nil
      end
      return @segments[@segments.attr_length - 1]
    end
    
    typesig { [Object] }
    # (non-Javadoc)
    # 
    # @see java.lang.Object#equals(java.lang.Object)
    def ==(other)
      if (!(other.is_a?(TreePath)))
        return false
      end
      return self.==(other, nil)
    end
    
    typesig { [] }
    # (non-Javadoc)
    # 
    # @see java.lang.Object#hashCode()
    def hash_code
      if ((@hash).equal?(0))
        @hash = hash_code(nil)
      end
      return @hash
    end
    
    typesig { [IElementComparer] }
    # Returns a hash code computed from the hash codes of the segments, using
    # the given comparer to compute the hash codes of the segments.
    # 
    # @param comparer
    # comparer to use or <code>null</code> if the segments' hash
    # codes should be computed by calling their hashCode() methods.
    # @return the computed hash code
    def hash_code(comparer)
      result = 0
      i = 0
      while i < @segments.attr_length
        if ((comparer).nil?)
          result += @segments[i].hash_code
        else
          result += comparer.hash_code(@segments[i])
        end
        i += 1
      end
      return result
    end
    
    typesig { [TreePath, IElementComparer] }
    # Returns whether this path is equivalent to the given path using the
    # specified comparer to compare individual elements.
    # 
    # @param otherPath
    # tree path to compare to
    # @param comparer
    # comparator to use or <code>null</code> if segments should be
    # compared using equals()
    # @return whether the paths are equal
    def ==(other_path, comparer)
      if ((other_path).nil?)
        return false
      end
      if (!(@segments.attr_length).equal?(other_path.attr_segments.attr_length))
        return false
      end
      i = 0
      while i < @segments.attr_length
        if ((comparer).nil?)
          if (!(@segments[i] == other_path.attr_segments[i]))
            return false
          end
        else
          if (!comparer.==(@segments[i], other_path.attr_segments[i]))
            return false
          end
        end
        i += 1
      end
      return true
    end
    
    typesig { [TreePath, IElementComparer] }
    # Returns whether this path starts with the same segments as the given
    # path, using the given comparer to compare segments.
    # 
    # @param treePath
    # path to compare to
    # @param comparer
    # the comparer to use, or <code>null</code> if equals() should
    # be used to compare segments
    # @return whether the given path is a prefix of this path, or the same as
    # this path
    def starts_with(tree_path, comparer)
      this_segment_count = get_segment_count
      other_segment_count = tree_path.get_segment_count
      if ((other_segment_count).equal?(this_segment_count))
        return self.==(tree_path, comparer)
      end
      if (other_segment_count > this_segment_count)
        return false
      end
      i = 0
      while i < other_segment_count
        other_segment = tree_path.get_segment(i)
        if ((comparer).nil?)
          if (!(other_segment == @segments[i]))
            return false
          end
        else
          if (!comparer.==(other_segment, @segments[i]))
            return false
          end
        end
        i += 1
      end
      return true
    end
    
    typesig { [] }
    # Returns a copy of this tree path with one segment removed from the end,
    # or <code>null</code> if this tree path has no segments.
    # @return a tree path
    def get_parent_path
      segment_count = get_segment_count
      if (segment_count < 1)
        return nil
      else
        if ((segment_count).equal?(1))
          return EMPTY
        end
      end
      parent_segments = Array.typed(Object).new(segment_count - 1) { nil }
      System.arraycopy(@segments, 0, parent_segments, 0, segment_count - 1)
      return TreePath.new(parent_segments)
    end
    
    typesig { [Object] }
    # Returns a copy of this tree path with the given segment added at the end.
    # @param newSegment
    # @return a tree path
    def create_child_path(new_segment)
      segment_count = get_segment_count
      child_segments = Array.typed(Object).new(segment_count + 1) { nil }
      if (segment_count > 0)
        System.arraycopy(@segments, 0, child_segments, 0, segment_count)
      end
      child_segments[segment_count] = new_segment
      return TreePath.new(child_segments)
    end
    
    private
    alias_method :initialize__tree_path, :initialize
  end
  
end
