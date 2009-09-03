require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Text::Edits
  module TextEditImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Text::Edits
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :Collections
      include_const ::Java::Util, :Comparator
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :JavaList
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Jface::Text, :BadLocationException
      include_const ::Org::Eclipse::Jface::Text, :IDocument
      include_const ::Org::Eclipse::Jface::Text, :IRegion
      include_const ::Org::Eclipse::Jface::Text, :Region
    }
  end
  
  # A text edit describes an elementary text manipulation operation. Edits are
  # executed by applying them to a document (e.g. an instance of <code>IDocument
  # </code>).
  # <p>
  # Text edits form a tree. Clients can navigate the tree upwards, from child to
  # parent, as well as downwards. Newly created edits are un-parented. New edits
  # are added to the tree by calling one of the <code>add</code> methods on a parent
  # edit.
  # </p>
  # <p>
  # An edit tree is well formed in the following sense:
  # <ul>
  # <li>a parent edit covers all its children</li>
  # <li>children don't overlap</li>
  # <li>an edit with length 0 can't have any children</li>
  # </ul>
  # Any manipulation of the tree that violates one of the above requirements results
  # in a <code>MalformedTreeException</code>.
  # </p>
  # <p>
  # Insert edits are represented by an edit of length 0. If more than one insert
  # edit exists at the same offset then the edits are executed in the order in which
  # they have been added to a parent. The following code example:
  # <pre>
  # IDocument document= new Document("org");
  # MultiTextEdit edit= new MultiTextEdit();
  # edit.addChild(new InsertEdit(0, "www."));
  # edit.addChild(new InsertEdit(0, "eclipse."));
  # edit.apply(document);
  # </pre>
  # therefore results in string: "www.eclipse.org".
  # </p>
  # <p>
  # Text edits can be executed in a mode where the edit's region is updated to
  # reflect the edit's position in the changed document. Region updating is enabled
  # by default or can be requested by passing <code>UPDATE_REGIONS</code> to the
  # {@link #apply(IDocument, int) apply(IDocument, int)} method. In the above example
  # the region of the <code>InsertEdit(0, "eclipse.")</code> edit after executing
  # the root edit is <code>[3, 8]</code>. If the region of an edit got deleted during
  # change execution the region is set to <code>[-1, -1]</code> and the method {@link
  # #isDeleted() isDeleted} returns <code>true</code>.
  # </p>
  # This class isn't intended to be subclassed outside of the edit framework. Clients
  # are only allowed to subclass <code>MultiTextEdit</code>.
  # 
  # @since 3.0
  # @noextend This class is not intended to be subclassed by clients.
  class TextEdit 
    include_class_members TextEditImports
    
    class_module.module_eval {
      # Flags indicating that neither <code>CREATE_UNDO</code> nor
      # <code>UPDATE_REGIONS</code> is set.
      const_set_lazy(:NONE) { 0 }
      const_attr_reader  :NONE
      
      # Flags indicating that applying an edit tree to a document
      # is supposed to create a corresponding undo edit. If not
      # specified <code>null</code> is returned from method <code>
      # apply</code>.
      const_set_lazy(:CREATE_UNDO) { 1 << 0 }
      const_attr_reader  :CREATE_UNDO
      
      # Flag indicating that the edit's region will be updated to
      # reflect its position in the changed document. If not specified
      # when applying an edit tree to a document the edit's region will
      # be arbitrary. It is even not guaranteed that the tree is still
      # well formed.
      const_set_lazy(:UPDATE_REGIONS) { 1 << 1 }
      const_attr_reader  :UPDATE_REGIONS
      
      const_set_lazy(:InsertionComparator) { Class.new do
        include_class_members TextEdit
        include Comparator
        
        typesig { [Object, Object] }
        def compare(o1, o2)
          edit1 = o1
          edit2 = o2
          offset1 = edit1.get_offset
          length1 = edit1.get_length
          offset2 = edit2.get_offset
          length2 = edit2.get_length
          if ((offset1).equal?(offset2) && (length1).equal?(0) && (length2).equal?(0))
            return 0
          end
          if (offset1 + length1 <= offset2)
            return -1
          end
          if (offset2 + length2 <= offset1)
            return 1
          end
          raise self.class::MalformedTreeException.new(nil, edit1, TextEditMessages.get_string("TextEdit.overlapping")) # $NON-NLS-1$
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__insertion_comparator, :initialize
      end }
      
      const_set_lazy(:EMPTY_ARRAY) { Array.typed(TextEdit).new(0) { nil } }
      const_attr_reader  :EMPTY_ARRAY
      
      const_set_lazy(:INSERTION_COMPARATOR) { InsertionComparator.new }
      const_attr_reader  :INSERTION_COMPARATOR
      
      const_set_lazy(:DELETED_VALUE) { -1 }
      const_attr_reader  :DELETED_VALUE
    }
    
    attr_accessor :f_offset
    alias_method :attr_f_offset, :f_offset
    undef_method :f_offset
    alias_method :attr_f_offset=, :f_offset=
    undef_method :f_offset=
    
    attr_accessor :f_length
    alias_method :attr_f_length, :f_length
    undef_method :f_length
    alias_method :attr_f_length=, :f_length=
    undef_method :f_length=
    
    attr_accessor :f_parent
    alias_method :attr_f_parent, :f_parent
    undef_method :f_parent
    alias_method :attr_f_parent=, :f_parent=
    undef_method :f_parent=
    
    attr_accessor :f_children
    alias_method :attr_f_children, :f_children
    undef_method :f_children
    alias_method :attr_f_children=, :f_children=
    undef_method :f_children=
    
    attr_accessor :f_delta
    alias_method :attr_f_delta, :f_delta
    undef_method :f_delta
    alias_method :attr_f_delta=, :f_delta=
    undef_method :f_delta=
    
    typesig { [::Java::Int, ::Java::Int] }
    # Create a new text edit. Parent is initialized to <code>
    # null<code> and the edit doesn't have any children.
    # 
    # @param offset the edit's offset
    # @param length the edit's length
    def initialize(offset, length)
      @f_offset = 0
      @f_length = 0
      @f_parent = nil
      @f_children = nil
      @f_delta = 0
      Assert.is_true(offset >= 0 && length >= 0)
      @f_offset = offset
      @f_length = length
      @f_delta = 0
    end
    
    typesig { [TextEdit] }
    # Copy constructor
    # 
    # @param source the source to copy form
    def initialize(source)
      @f_offset = 0
      @f_length = 0
      @f_parent = nil
      @f_children = nil
      @f_delta = 0
      @f_offset = source.attr_f_offset
      @f_length = source.attr_f_length
      @f_delta = 0
    end
    
    typesig { [] }
    # ---- Region management -----------------------------------------------
    # 
    # Returns the range that this edit is manipulating. The returned
    # <code>IRegion</code> contains the edit's offset and length at
    # the point in time when this call is made. Any subsequent changes
    # to the edit's offset and length aren't reflected in the returned
    # region object.
    # <p>
    # Creating a region for a deleted edit will result in an assertion
    # failure.
    # 
    # @return the manipulated region
    def get_region
      return Region.new(get_offset, get_length)
    end
    
    typesig { [] }
    # Returns the offset of the edit. An offset is a 0-based
    # character index. Returns <code>-1</code> if the edit
    # is marked as deleted.
    # 
    # @return the offset of the edit
    def get_offset
      return @f_offset
    end
    
    typesig { [] }
    # Returns the length of the edit. Returns <code>-1</code>
    # if the edit is marked as deleted.
    # 
    # @return the length of the edit
    def get_length
      return @f_length
    end
    
    typesig { [] }
    # Returns the inclusive end position of this edit. The inclusive end
    # position denotes the last character of the region manipulated by
    # this edit. The returned value is the result of the following
    # calculation:
    # <pre>
    # getOffset() + getLength() - 1;
    # <pre>
    # 
    # @return the inclusive end position
    def get_inclusive_end
      return get_offset + get_length - 1
    end
    
    typesig { [] }
    # Returns the exclusive end position of this edit. The exclusive end
    # position denotes the next character of the region manipulated by
    # this edit. The returned value is the result of the following
    # calculation:
    # <pre>
    # getOffset() + getLength();
    # </pre>
    # 
    # @return the exclusive end position
    def get_exclusive_end
      return get_offset + get_length
    end
    
    typesig { [] }
    # Returns whether this edit has been deleted or not.
    # 
    # @return <code>true</code> if the edit has been
    # deleted; otherwise <code>false</code> is returned.
    def is_deleted
      return (@f_offset).equal?(DELETED_VALUE) && (@f_length).equal?(DELETED_VALUE)
    end
    
    typesig { [::Java::Int] }
    # Move all offsets in the tree by the given delta. This node must be a
    # root node. The resulting offsets must be greater or equal to zero.
    # 
    # @param delta the delta
    # @since 3.1
    def move_tree(delta)
      Assert.is_true((@f_parent).nil?)
      Assert.is_true(get_offset + delta >= 0)
      internal_move_tree(delta)
    end
    
    typesig { [TextEdit] }
    # Returns <code>true</code> if the edit covers the given edit
    # <code>other</code>. It is up to the concrete text edit to
    # decide if a edit of length zero can cover another edit.
    # 
    # @param other the other edit
    # @return <code>true<code> if the edit covers the other edit;
    # otherwise <code>false</code> is returned.
    def covers(other)
      if ((get_length).equal?(0) && !can_zero_length_cover)
        return false
      end
      if (!other.is_defined)
        return true
      end
      this_offset = get_offset
      other_offset = other.get_offset
      return this_offset <= other_offset && other_offset + other.get_length <= this_offset + get_length
    end
    
    typesig { [] }
    # Returns <code>true</code> if an edit with length zero can cover
    # another edit. Returns <code>false</code> otherwise.
    # 
    # @return whether an edit of length zero can cover another edit
    def can_zero_length_cover
      return false
    end
    
    typesig { [] }
    # Returns whether the region of this edit is defined or not.
    # 
    # @return whether the region of this edit is defined or not
    # 
    # @since 3.1
    def is_defined
      return true
    end
    
    typesig { [] }
    # ---- parent and children management -----------------------------
    # 
    # Returns the edit's parent. The method returns <code>null</code>
    # if this edit hasn't been add to another edit.
    # 
    # @return the edit's parent
    def get_parent
      return @f_parent
    end
    
    typesig { [] }
    # Returns the root edit of the edit tree.
    # 
    # @return the root edit of the edit tree
    # @since 3.1
    def get_root
      result = self
      while (!(result.attr_f_parent).nil?)
        result = result.attr_f_parent
      end
      return result
    end
    
    typesig { [TextEdit] }
    # Adds the given edit <code>child</code> to this edit.
    # 
    # @param child the child edit to add
    # @exception MalformedTreeException is thrown if the child
    # edit can't be added to this edit. This is the case if the child
    # overlaps with one of its siblings or if the child edit's region
    # isn't fully covered by this edit.
    def add_child(child)
      internal_add(child)
    end
    
    typesig { [Array.typed(TextEdit)] }
    # Adds all edits in <code>edits</code> to this edit.
    # 
    # @param edits the text edits to add
    # @exception MalformedTreeException is thrown if one of
    # the given edits can't be added to this edit.
    # 
    # @see #addChild(TextEdit)
    def add_children(edits)
      i = 0
      while i < edits.attr_length
        internal_add(edits[i])
        i += 1
      end
    end
    
    typesig { [::Java::Int] }
    # Removes the edit specified by the given index from the list
    # of children. Returns the child edit that was removed from
    # the list of children. The parent of the returned edit is
    # set to <code>null</code>.
    # 
    # @param index the index of the edit to remove
    # @return the removed edit
    # @exception IndexOutOfBoundsException if the index
    # is out of range
    def remove_child(index)
      if ((@f_children).nil?)
        raise IndexOutOfBoundsException.new("Index: " + RJava.cast_to_string(index) + " Size: 0")
      end # $NON-NLS-1$//$NON-NLS-2$
      result = @f_children.remove(index)
      result.internal_set_parent(nil)
      if (@f_children.is_empty)
        @f_children = nil
      end
      return result
    end
    
    typesig { [TextEdit] }
    # Removes the first occurrence of the given child from the list
    # of children.
    # 
    # @param child the child to be removed
    # @return <code>true</code> if the edit contained the given
    # child; otherwise <code>false</code> is returned
    def remove_child(child)
      Assert.is_not_null(child)
      if ((@f_children).nil?)
        return false
      end
      result = @f_children.remove(child)
      if (result)
        child.internal_set_parent(nil)
        if (@f_children.is_empty)
          @f_children = nil
        end
      end
      return result
    end
    
    typesig { [] }
    # Removes all child edits from and returns them. The parent
    # of the removed edits is set to <code>null</code>.
    # 
    # @return an array of the removed edits
    def remove_children
      if ((@f_children).nil?)
        return EMPTY_ARRAY
      end
      size_ = @f_children.size
      result = Array.typed(TextEdit).new(size_) { nil }
      i = 0
      while i < size_
        result[i] = @f_children.get(i)
        result[i].internal_set_parent(nil)
        i += 1
      end
      @f_children = nil
      return result
    end
    
    typesig { [] }
    # Returns <code>true</code> if this edit has children. Otherwise
    # <code>false</code> is returned.
    # 
    # @return <code>true</code> if this edit has children; otherwise
    # <code>false</code> is returned
    def has_children
      return !(@f_children).nil? && !@f_children.is_empty
    end
    
    typesig { [] }
    # Returns the edit's children. If the edit doesn't have any
    # children an empty array is returned.
    # 
    # @return the edit's children
    def get_children
      if ((@f_children).nil?)
        return EMPTY_ARRAY
      end
      return @f_children.to_array(Array.typed(TextEdit).new(@f_children.size) { nil })
    end
    
    typesig { [] }
    # Returns the size of the managed children.
    # 
    # @return the size of the children
    def get_children_size
      if ((@f_children).nil?)
        return 0
      end
      return @f_children.size
    end
    
    class_module.module_eval {
      typesig { [Array.typed(TextEdit)] }
      # Returns the text range spawned by the given array of text edits.
      # The method requires that the given array contains at least one
      # edit. If all edits passed are deleted the method returns <code>
      # null</code>.
      # 
      # @param edits an array of edits
      # @return the text range spawned by the given array of edits or
      # <code>null</code> if all edits are marked as deleted
      def get_coverage(edits)
        Assert.is_true(!(edits).nil? && edits.attr_length > 0)
        offset = JavaInteger::MAX_VALUE
        end_ = JavaInteger::MIN_VALUE
        deleted = 0
        i = 0
        while i < edits.attr_length
          edit = edits[i]
          if (edit.is_deleted)
            deleted += 1
          else
            offset = Math.min(offset, edit.get_offset)
            end_ = Math.max(end_, edit.get_exclusive_end)
          end
          i += 1
        end
        if ((edits.attr_length).equal?(deleted))
          return nil
        end
        return Region.new(offset, end_ - offset)
      end
    }
    
    typesig { [TextEdit] }
    # Hook called before this edit gets added to the passed parent.
    # 
    # @param parent the parent text edit
    def about_to_be_added(parent)
    end
    
    typesig { [Object] }
    # ---- Object methods ------------------------------------------------------
    # 
    # The <code>Edit</code> implementation of this <code>Object</code>
    # method uses object identity (==).
    # 
    # @param obj the other object
    # @return <code>true</code> iff <code>this == obj</code>; otherwise
    # <code>false</code> is returned
    # 
    # @see Object#equals(java.lang.Object)
    def ==(obj)
      return (self).equal?(obj) # equivalent to Object.equals
    end
    
    typesig { [] }
    # The <code>Edit</code> implementation of this <code>Object</code>
    # method calls uses <code>Object#hashCode()</code> to compute its
    # hash code.
    # 
    # @return the object's hash code value
    # 
    # @see Object#hashCode()
    def hash_code
      return super
    end
    
    typesig { [] }
    # @see java.lang.Object#toString()
    def to_s
      buffer = StringBuffer.new
      to_string_with_children(buffer, 0)
      return buffer.to_s
    end
    
    typesig { [StringBuffer, ::Java::Int] }
    # Adds the string representation of this text edit without
    # children information to the given string buffer.
    # 
    # @param buffer	the string buffer
    # @param indent	the indent level in number of spaces
    # @since 3.3
    def internal_to_string(buffer, indent)
      i = indent
      while i > 0
        buffer.append("  ") # $NON-NLS-1$
        i -= 1
      end
      buffer.append("{") # $NON-NLS-1$
      name = get_class.get_name
      index = name.last_index_of(Character.new(?..ord))
      if (!(index).equal?(-1))
        buffer.append(name.substring(index + 1))
      else
        buffer.append(name)
      end
      buffer.append("} ") # $NON-NLS-1$
      if (is_deleted)
        buffer.append("[deleted]") # $NON-NLS-1$
      else
        buffer.append("[") # $NON-NLS-1$
        buffer.append(get_offset)
        buffer.append(",") # $NON-NLS-1$
        buffer.append(get_length)
        buffer.append("]") # $NON-NLS-1$
      end
    end
    
    typesig { [StringBuffer, ::Java::Int] }
    # Adds the string representation for this text edit
    # and its children to the given string buffer.
    # 
    # @param buffer	the string buffer
    # @param indent	the indent level in number of spaces
    # @since 3.3
    def to_string_with_children(buffer, indent)
      internal_to_string(buffer, indent)
      if (!(@f_children).nil?)
        iterator_ = @f_children.iterator
        while iterator_.has_next
          child = iterator_.next_
          buffer.append(Character.new(?\n.ord))
          child.to_string_with_children(buffer, indent + 1)
        end
      end
    end
    
    typesig { [] }
    # ---- Copying -------------------------------------------------------------
    # 
    # Creates a deep copy of the edit tree rooted at this
    # edit.
    # 
    # @return a deep copy of the edit tree
    # @see #doCopy()
    def copy
      copier = TextEditCopier.new(self)
      return copier.perform
    end
    
    typesig { [] }
    # Creates and returns a copy of this edit. The copy method should be
    # implemented in a way so that the copy can executed without causing
    # any harm to the original edit. Implementors of this method are
    # responsible for creating deep or shallow copies of referenced
    # object to fulfill this requirement.
    # <p>
    # Implementers of this method should use the copy constructor <code>
    # Edit#Edit(Edit source) to initialize the edit part of the copy.
    # Implementors aren't responsible to actually copy the children or
    # to set the right parent.
    # <p>
    # This method <b>should not be called</b> from outside the framework.
    # Please use <code>copy</code> to create a copy of a edit tree.
    # 
    # @return a copy of this edit.
    # @see #copy()
    # @see #postProcessCopy(TextEditCopier)
    # @see TextEditCopier
    def do_copy
      raise NotImplementedError
    end
    
    typesig { [TextEditCopier] }
    # This method is called on every edit of the copied tree to do some
    # post-processing like connected an edit to a different edit in the tree.
    # <p>
    # This default implementation does nothing
    # 
    # @param copier the copier that manages a map between original and
    # copied edit.
    # @see TextEditCopier
    def post_process_copy(copier)
    end
    
    typesig { [TextEditVisitor] }
    # ---- Visitor support -------------------------------------------------
    # 
    # Accepts the given visitor on a visit of the current edit.
    # 
    # @param visitor the visitor object
    # @exception IllegalArgumentException if the visitor is null
    def accept(visitor)
      Assert.is_not_null(visitor)
      # begin with the generic pre-visit
      visitor.pre_visit(self)
      # dynamic dispatch to internal method for type-specific visit/endVisit
      accept0(visitor)
      # end with the generic post-visit
      visitor.post_visit(self)
    end
    
    typesig { [TextEditVisitor] }
    # Accepts the given visitor on a type-specific visit of the current edit.
    # This method must be implemented in all concrete text edits.
    # <p>
    # General template for implementation on each concrete TextEdit class:
    # <pre>
    # <code>
    # boolean visitChildren= visitor.visit(this);
    # if (visitChildren) {
    # acceptChildren(visitor);
    # }
    # </code>
    # </pre>
    # Note that the caller (<code>accept</code>) takes care of invoking
    # <code>visitor.preVisit(this)</code> and <code>visitor.postVisit(this)</code>.
    # </p>
    # 
    # @param visitor the visitor object
    def accept0(visitor)
      raise NotImplementedError
    end
    
    typesig { [TextEditVisitor] }
    # Accepts the given visitor on the edits children.
    # <p>
    # This method must be used by the concrete implementations of
    # <code>accept</code> to traverse list-values properties; it
    # encapsulates the proper handling of on-the-fly changes to the list.
    # </p>
    # 
    # @param visitor the visitor object
    def accept_children(visitor)
      if ((@f_children).nil?)
        return
      end
      iterator_ = @f_children.iterator
      while (iterator_.has_next)
        curr = iterator_.next_
        curr.accept(visitor)
      end
    end
    
    typesig { [IDocument, ::Java::Int] }
    # ---- Execution -------------------------------------------------------
    # 
    # Applies the edit tree rooted by this edit to the given document. To check
    # if the edit tree can be applied to the document either catch <code>
    # MalformedTreeException</code> or use <code>TextEditProcessor</code> to
    # execute an edit tree.
    # 
    # @param document the document to be manipulated
    # @param style flags controlling the execution of the edit tree. Valid
    # flags are: <code>CREATE_UNDO</code> and </code>UPDATE_REGIONS</code>.
    # @return a undo edit, if <code>CREATE_UNDO</code> is specified. Otherwise
    # <code>null</code> is returned.
    # 
    # @exception MalformedTreeException is thrown if the tree isn't
    # in a valid state. This exception is thrown before any edit
    # is executed. So the document is still in its original state.
    # @exception BadLocationException is thrown if one of the edits
    # in the tree can't be executed. The state of the document is
    # undefined if this exception is thrown.
    # 
    # @see TextEditProcessor#performEdits()
    def apply(document, style)
      begin
        processor = TextEditProcessor.new(document, self, style)
        return processor.perform_edits
      ensure
        # disconnect from text edit processor
        @f_parent = nil
      end
    end
    
    typesig { [IDocument] }
    # Applies the edit tree rooted by this edit to the given document. This
    # method is a convenience method for <code>apply(document, CREATE_UNDO | UPDATE_REGIONS)
    # </code>
    # 
    # @param document the document to which to apply this edit
    # @return a undo edit, if <code>CREATE_UNDO</code> is specified. Otherwise
    # <code>null</code> is returned.
    # @exception MalformedTreeException is thrown if the tree isn't
    # in a valid state. This exception is thrown before any edit
    # is executed. So the document is still in its original state.
    # @exception BadLocationException is thrown if one of the edits
    # in the tree can't be executed. The state of the document is
    # undefined if this exception is thrown.
    # @see #apply(IDocument, int)
    def apply(document)
      return apply(document, CREATE_UNDO | UPDATE_REGIONS)
    end
    
    typesig { [TextEditProcessor] }
    def dispatch_perform_edits(processor)
      return processor.execute_do
    end
    
    typesig { [TextEditProcessor] }
    def dispatch_check_integrity(processor)
      processor.check_integrity_do
    end
    
    typesig { [TextEdit] }
    # ---- internal state accessors ----------------------------------------------------------
    def internal_set_parent(parent)
      if (!(parent).nil?)
        Assert.is_true((@f_parent).nil?)
      end
      @f_parent = parent
    end
    
    typesig { [::Java::Int] }
    def internal_set_offset(offset)
      Assert.is_true(offset >= 0)
      @f_offset = offset
    end
    
    typesig { [::Java::Int] }
    def internal_set_length(length)
      Assert.is_true(length >= 0)
      @f_length = length
    end
    
    typesig { [] }
    def internal_get_children
      return @f_children
    end
    
    typesig { [JavaList] }
    def internal_set_children(children)
      @f_children = children
    end
    
    typesig { [TextEdit] }
    def internal_add(child)
      child.about_to_be_added(self)
      if (child.is_deleted)
        raise MalformedTreeException.new(self, child, TextEditMessages.get_string("TextEdit.deleted_edit"))
      end # $NON-NLS-1$
      if (!covers(child))
        raise MalformedTreeException.new(self, child, TextEditMessages.get_string("TextEdit.range_outside"))
      end # $NON-NLS-1$
      if ((@f_children).nil?)
        @f_children = ArrayList.new(2)
      end
      index = compute_insertion_index(child)
      @f_children.add(index, child)
      child.internal_set_parent(self)
    end
    
    typesig { [TextEdit] }
    def compute_insertion_index(edit)
      size_ = @f_children.size
      if ((size_).equal?(0))
        return 0
      end
      last_index = size_ - 1
      last = @f_children.get(last_index)
      if (last.get_exclusive_end <= edit.get_offset)
        return size_
      end
      begin
        index = Collections.binary_search(@f_children, edit, INSERTION_COMPARATOR)
        if (index < 0)
          # edit is not in fChildren
          return -index - 1
        end
        # edit is already in fChildren
        # make sure that multiple insertion points at the same offset are inserted last.
        while (index < last_index && (INSERTION_COMPARATOR.compare(@f_children.get(index), @f_children.get(index + 1))).equal?(0))
          index += 1
        end
        return index + 1
      rescue MalformedTreeException => e
        e.set_parent(self)
        raise e
      end
    end
    
    typesig { [::Java::Int] }
    # ---- Offset & Length updating -------------------------------------------------
    # 
    # Adjusts the edits offset according to the given
    # delta. This method doesn't update any children.
    # 
    # @param delta the delta of the text replace operation
    def adjust_offset(delta)
      if (is_deleted)
        return
      end
      @f_offset += delta
      Assert.is_true(@f_offset >= 0)
    end
    
    typesig { [::Java::Int] }
    # Adjusts the edits length according to the given
    # delta. This method doesn't update any children.
    # 
    # @param delta the delta of the text replace operation
    def adjust_length(delta)
      if (is_deleted)
        return
      end
      @f_length += delta
      Assert.is_true(@f_length >= 0)
    end
    
    typesig { [] }
    # Marks the edit as deleted. This method doesn't update
    # any children.
    def mark_as_deleted
      @f_offset = DELETED_VALUE
      @f_length = DELETED_VALUE
    end
    
    typesig { [TextEditProcessor, IDocument, JavaList] }
    # ---- Edit processing ----------------------------------------------
    # 
    # Traverses the edit tree to perform the consistency check.
    # 
    # @param processor the text edit processor
    # @param document the document to be manipulated
    # @param sourceEdits the list of source edits to be performed before
    # the actual tree is applied to the document
    # 
    # @return the number of indirect move or copy target edit children
    def traverse_consistency_check(processor, document, source_edits)
      result = 0
      if (!(@f_children).nil?)
        i = @f_children.size - 1
        while i >= 0
          child = @f_children.get(i)
          result = Math.max(result, child.traverse_consistency_check(processor, document, source_edits))
          i -= 1
        end
      end
      if (processor.consider_edit(self))
        perform_consistency_check(processor, document)
      end
      return result
    end
    
    typesig { [TextEditProcessor, IDocument] }
    # Performs the consistency check.
    # 
    # @param processor the text edit processor
    # @param document the document to be manipulated
    def perform_consistency_check(processor, document)
    end
    
    typesig { [TextEditProcessor, IDocument] }
    # Traverses the source computation.
    # 
    # @param processor the text edit processor
    # @param document the document to be manipulated
    def traverse_source_computation(processor, document)
    end
    
    typesig { [TextEditProcessor, IDocument] }
    # Performs the source computation.
    # 
    # @param processor the text edit processor
    # @param document the document to be manipulated
    def perform_source_computation(processor, document)
    end
    
    typesig { [TextEditProcessor, IDocument] }
    def traverse_document_updating(processor, document)
      delta = 0
      if (!(@f_children).nil?)
        i = @f_children.size - 1
        while i >= 0
          child = @f_children.get(i)
          delta += child.traverse_document_updating(processor, document)
          child_document_updated
          i -= 1
        end
      end
      if (processor.consider_edit(self))
        if (!(delta).equal?(0))
          adjust_length(delta)
        end
        r = perform_document_updating(document)
        if (!(r).equal?(0))
          adjust_length(r)
        end
        delta += r
      end
      return delta
    end
    
    typesig { [] }
    # Hook method called when the document updating of a child edit has been
    # completed. When a client calls {@link #apply(IDocument)} or
    # {@link #apply(IDocument, int)} this method is called
    # {@link #getChildrenSize()} times.
    # <p>
    # May be overridden by subclasses of {@link MultiTextEdit}.
    # 
    # @since 3.1
    def child_document_updated
    end
    
    typesig { [IDocument] }
    def perform_document_updating(document)
      raise NotImplementedError
    end
    
    typesig { [TextEditProcessor, IDocument, ::Java::Int, ::Java::Boolean] }
    def traverse_region_updating(processor, document, accumulated_delta, delete)
      perform_region_updating(accumulated_delta, delete)
      if (!(@f_children).nil?)
        child_delete = delete || delete_children
        iter = @f_children.iterator
        while iter.has_next
          child = iter.next_
          accumulated_delta = child.traverse_region_updating(processor, document, accumulated_delta, child_delete)
          child_region_updated
        end
      end
      return accumulated_delta + @f_delta
    end
    
    typesig { [] }
    # Hook method called when the region updating of a child edit has been
    # completed. When a client calls {@link #apply(IDocument)} this method is
    # called {@link #getChildrenSize()} times. When calling
    # {@link #apply(IDocument, int)} this method is called
    # {@link #getChildrenSize()} times, when the style parameter contains the
    # {@link #UPDATE_REGIONS} flag.
    # <p>
    # May be overridden by subclasses of {@link MultiTextEdit}.
    # 
    # @since 3.1
    def child_region_updated
    end
    
    typesig { [::Java::Int, ::Java::Boolean] }
    def perform_region_updating(accumulated_delta, delete)
      if (delete)
        mark_as_deleted
      else
        adjust_offset(accumulated_delta)
      end
    end
    
    typesig { [] }
    def delete_children
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    def internal_move_tree(delta)
      adjust_offset(delta)
      if (!(@f_children).nil?)
        iter = @f_children.iterator
        while iter.has_next
          (iter.next_).internal_move_tree(delta)
        end
      end
    end
    
    typesig { [] }
    def delete_tree
      mark_as_deleted
      if (!(@f_children).nil?)
        iter = @f_children.iterator
        while iter.has_next
          child = iter.next_
          child.delete_tree
        end
      end
    end
    
    private
    alias_method :initialize__text_edit, :initialize
  end
  
end
