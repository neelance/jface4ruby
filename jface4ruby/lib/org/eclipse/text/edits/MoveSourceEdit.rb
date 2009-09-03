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
  module MoveSourceEditImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Text::Edits
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :Arrays
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :Map
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Jface::Text, :BadLocationException
      include_const ::Org::Eclipse::Jface::Text, :IDocument
      include_const ::Org::Eclipse::Jface::Text, :IRegion
      include_const ::Org::Eclipse::Jface::Text, :Region
    }
  end
  
  # A move source edit denotes the source of a move operation. Move
  # source edits are only valid inside an edit tree if they have a
  # corresponding target edit. Furthermore the corresponding target
  # edit can't be a direct or indirect child of the source edit.
  # Violating one of two requirements will result in a <code>
  # MalformedTreeException</code> when executing the edit tree.
  # <p>
  # A move source edit can manage an optional source modifier. A
  # source modifier can provide a set of replace edits which will
  # to applied to the source before it gets inserted at the target
  # position.
  # 
  # @see org.eclipse.text.edits.MoveTargetEdit
  # @see org.eclipse.text.edits.CopySourceEdit
  # 
  # @since 3.0
  class MoveSourceEdit < MoveSourceEditImports.const_get :TextEdit
    include_class_members MoveSourceEditImports
    
    attr_accessor :f_target
    alias_method :attr_f_target, :f_target
    undef_method :f_target
    alias_method :attr_f_target=, :f_target=
    undef_method :f_target=
    
    attr_accessor :f_modifier
    alias_method :attr_f_modifier, :f_modifier
    undef_method :f_modifier
    alias_method :attr_f_modifier=, :f_modifier=
    undef_method :f_modifier=
    
    attr_accessor :f_source_content
    alias_method :attr_f_source_content, :f_source_content
    undef_method :f_source_content
    alias_method :attr_f_source_content=, :f_source_content=
    undef_method :f_source_content=
    
    attr_accessor :f_source_root
    alias_method :attr_f_source_root, :f_source_root
    undef_method :f_source_root
    alias_method :attr_f_source_root=, :f_source_root=
    undef_method :f_source_root=
    
    typesig { [::Java::Int, ::Java::Int] }
    # Constructs a new move source edit.
    # 
    # @param offset the edit's offset
    # @param length the edit's length
    def initialize(offset, length)
      @f_target = nil
      @f_modifier = nil
      @f_source_content = nil
      @f_source_root = nil
      super(offset, length)
    end
    
    typesig { [::Java::Int, ::Java::Int, MoveTargetEdit] }
    # Constructs a new copy source edit.
    # 
    # @param offset the edit's offset
    # @param length the edit's length
    # @param target the edit's target
    def initialize(offset, length, target)
      initialize__move_source_edit(offset, length)
      set_target_edit(target)
    end
    
    typesig { [MoveSourceEdit] }
    # Copy constructor
    def initialize(other)
      @f_target = nil
      @f_modifier = nil
      @f_source_content = nil
      @f_source_root = nil
      super(other)
      if (!(other.attr_f_modifier).nil?)
        @f_modifier = other.attr_f_modifier.copy
      end
    end
    
    typesig { [] }
    # Returns the associated target edit or <code>null</code>
    # if no target edit is associated yet.
    # 
    # @return the target edit or <code>null</code>
    def get_target_edit
      return @f_target
    end
    
    typesig { [MoveTargetEdit] }
    # Sets the target edit.
    # 
    # @param edit the new target edit.
    # 
    # @exception MalformedTreeException is thrown if the target edit
    # is a direct or indirect child of the source edit
    def set_target_edit(edit)
      @f_target = edit
      @f_target.set_source_edit(self)
    end
    
    typesig { [] }
    # Returns the current source modifier or <code>null</code>
    # if no source modifier is set.
    # 
    # @return the source modifier
    def get_source_modifier
      return @f_modifier
    end
    
    typesig { [ISourceModifier] }
    # Sets the optional source modifier.
    # 
    # @param modifier the source modifier or <code>null</code>
    # if no source modification is need.
    def set_source_modifier(modifier)
      @f_modifier = modifier
    end
    
    typesig { [] }
    # ---- API for MoveTargetEdit ---------------------------------------------
    def get_content
      # The source content can be null if the edit wasn't executed
      # due to an exclusion list of the text edit processor. Return
      # the empty string which can be moved without any harm.
      if ((@f_source_content).nil?)
        return ""
      end # $NON-NLS-1$
      return @f_source_content
    end
    
    typesig { [] }
    def get_source_root
      return @f_source_root
    end
    
    typesig { [] }
    def clear_content
      @f_source_content = RJava.cast_to_string(nil)
      @f_source_root = nil
    end
    
    typesig { [] }
    # ---- Copying -------------------------------------------------------------
    # 
    # @see TextEdit#doCopy
    def do_copy
      return MoveSourceEdit.new(self)
    end
    
    typesig { [TextEditCopier] }
    # @see TextEdit#postProcessCopy
    def post_process_copy(copier)
      if (!(@f_target).nil?)
        source = copier.get_copy(self)
        target = copier.get_copy(@f_target)
        if (!(source).nil? && !(target).nil?)
          source.set_target_edit(target)
        end
      end
    end
    
    typesig { [TextEditVisitor] }
    # ---- Visitor -------------------------------------------------------------
    # 
    # @see TextEdit#accept0
    def accept0(visitor)
      visit_children = visitor.visit(self)
      if (visit_children)
        accept_children(visitor)
      end
    end
    
    typesig { [TextEditProcessor, IDocument, JavaList] }
    # ---- consistency check ----------------------------------------------------------------
    def traverse_consistency_check(processor, document, source_edits)
      result = super(processor, document, source_edits)
      # Since source computation takes place in a recursive fashion (see
      # performSourceComputation) we only do something if we don't have a
      # computed source already.
      if ((@f_source_content).nil?)
        if (source_edits.size <= result)
          list = ArrayList.new
          list.add(self)
          i = source_edits.size
          while i < result
            source_edits.add(nil)
            i += 1
          end
          source_edits.add(list)
        else
          list = source_edits.get(result)
          if ((list).nil?)
            list = ArrayList.new
            source_edits.add(result, list)
          end
          list.add(self)
        end
      end
      return result
    end
    
    typesig { [TextEditProcessor, IDocument] }
    def perform_consistency_check(processor, document)
      if ((@f_target).nil?)
        raise MalformedTreeException.new(get_parent, self, TextEditMessages.get_string("MoveSourceEdit.no_target"))
      end # $NON-NLS-1$
      if (!(@f_target.get_source_edit).equal?(self))
        raise MalformedTreeException.new(get_parent, self, TextEditMessages.get_string("MoveSourceEdit.different_source"))
      end # $NON-NLS-1$
      # Causes AST rewrite to fail
      # if (getRoot() != fTarget.getRoot())
      # throw new MalformedTreeException(getParent(), this, TextEditMessages.getString("MoveSourceEdit.different_tree")); //$NON-NLS-1$
    end
    
    typesig { [TextEditProcessor, IDocument] }
    # ---- source computation --------------------------------------------------------------
    def traverse_source_computation(processor, document)
      # always perform source computation independent of processor.considerEdit
      # The target might need the source and the source is computed in a
      # temporary buffer.
      perform_source_computation(processor, document)
    end
    
    typesig { [TextEditProcessor, IDocument] }
    def perform_source_computation(processor, document)
      begin
        children = remove_children
        if (children.attr_length > 0)
          content = document.get(get_offset, get_length)
          sub_document = EditDocument.new(content)
          @f_source_root = MultiTextEdit.new(get_offset, get_length)
          @f_source_root.add_children(children)
          @f_source_root.internal_move_tree(-get_offset)
          processing_style = get_style(processor)
          sub_processor = TextEditProcessor.create_source_computation_processor(sub_document, @f_source_root, processing_style)
          sub_processor.perform_edits
          if (needs_transformation)
            apply_transformation(sub_document, processing_style)
          end
          @f_source_content = RJava.cast_to_string(sub_document.get)
        else
          @f_source_content = RJava.cast_to_string(document.get(get_offset, get_length))
          if (needs_transformation)
            sub_document = EditDocument.new(@f_source_content)
            apply_transformation(sub_document, get_style(processor))
            @f_source_content = RJava.cast_to_string(sub_document.get)
          end
        end
      rescue BadLocationException => cannot_happen
        Assert.is_true(false)
      end
    end
    
    typesig { [TextEditProcessor] }
    def get_style(processor)
      # we never need undo while performing local edits.
      if (!((processor.get_style & TextEdit::UPDATE_REGIONS)).equal?(0))
        return TextEdit::UPDATE_REGIONS
      end
      return TextEdit::NONE
    end
    
    typesig { [IDocument] }
    # ---- document updating ----------------------------------------------------------------
    def perform_document_updating(document)
      document.replace(get_offset, get_length, "") # $NON-NLS-1$
      self.attr_f_delta = -get_length
      return self.attr_f_delta
    end
    
    typesig { [] }
    # ---- region updating --------------------------------------------------------------
    # 
    # @see TextEdit#deleteChildren
    def delete_children
      return false
    end
    
    typesig { [] }
    # ---- content transformation --------------------------------------------------
    def needs_transformation
      return !(@f_modifier).nil?
    end
    
    typesig { [IDocument, ::Java::Int] }
    def apply_transformation(document, style)
      if (!((style & TextEdit::UPDATE_REGIONS)).equal?(0) && !(@f_source_root).nil?)
        edit_map = HashMap.new
        new_edit = create_edit(edit_map)
        replaces = ArrayList.new(Arrays.as_list(@f_modifier.get_modifications(document.get)))
        insert_edits(new_edit, replaces)
        begin
          new_edit.apply(document, style)
        rescue BadLocationException => cannot_happen
          Assert.is_true(false)
        end
        restore_positions(edit_map)
      else
        new_edit = MultiTextEdit.new(0, document.get_length)
        replaces = @f_modifier.get_modifications(document.get)
        i = 0
        while i < replaces.attr_length
          new_edit.add_child(replaces[i])
          i += 1
        end
        begin
          new_edit.apply(document, style)
        rescue BadLocationException => cannot_happen
          Assert.is_true(false)
        end
      end
    end
    
    typesig { [Map] }
    def create_edit(edit_map)
      result = MultiTextEdit.new(0, @f_source_root.get_length)
      edit_map.put(result, @f_source_root)
      create_edit(@f_source_root, result, edit_map)
      return result
    end
    
    class_module.module_eval {
      typesig { [TextEdit, TextEdit, Map] }
      def create_edit(source, target, edit_map)
        children = source.get_children
        i = 0
        while i < children.attr_length
          child = children[i]
          # a deleted child remains deleted even if the temporary buffer
          # gets modified.
          if (child.is_deleted)
            i += 1
            next
          end
          marker = RangeMarker.new(child.get_offset, child.get_length)
          target.add_child(marker)
          edit_map.put(marker, child)
          create_edit(child, marker, edit_map)
          i += 1
        end
      end
    }
    
    typesig { [TextEdit, JavaList] }
    def insert_edits(root, edits)
      while (edits.size > 0)
        edit = edits.remove(0)
        insert(root, edit, edits)
      end
    end
    
    class_module.module_eval {
      typesig { [TextEdit, ReplaceEdit, JavaList] }
      def insert(parent, edit, edits)
        if (!parent.has_children)
          parent.add_child(edit)
          return
        end
        children = parent.get_children
        # First dive down to find the right parent.
        removed = 0
        i = 0
        while i < children.attr_length
          child = children[i]
          if (child.covers(edit))
            insert(child, edit, edits)
            return
          else
            if (edit.covers(child))
              parent.remove_child(i - ((removed += 1) - 1))
              edit.add_child(child)
            else
              intersect_ = intersect(edit, child)
              if (!(intersect_).nil?)
                splits = split_edit(edit, intersect_)
                insert(child, splits[0], edits)
                edits.add(splits[1])
                return
              end
            end
          end
          i += 1
        end
        parent.add_child(edit)
      end
      
      typesig { [TextEdit, TextEdit] }
      def intersect(op1, op2)
        offset1 = op1.get_offset
        length1 = op1.get_length
        end1 = offset1 + length1 - 1
        offset2 = op2.get_offset
        if (end1 < offset2)
          return nil
        end
        length2 = op2.get_length
        end2 = offset2 + length2 - 1
        if (end2 < offset1)
          return nil
        end
        end_ = Math.min(end1, end2)
        if (offset1 < offset2)
          return Region.new(offset2, end_ - offset2 + 1)
        end
        return Region.new(offset1, end_ - offset1 + 1)
      end
      
      typesig { [ReplaceEdit, IRegion] }
      def split_edit(edit, intersect_)
        if (!(edit.get_offset).equal?(intersect_.get_offset))
          return split_intersect_right(edit, intersect_)
        end
        return split_intersect_left(edit, intersect_)
      end
      
      typesig { [ReplaceEdit, IRegion] }
      def split_intersect_right(edit, intersect_)
        result = Array.typed(ReplaceEdit).new(2) { nil }
        # this is the actual delete. We use replace to only deal with one type
        result[0] = ReplaceEdit.new(intersect_.get_offset, intersect_.get_length, "") # $NON-NLS-1$
        result[1] = ReplaceEdit.new(edit.get_offset, intersect_.get_offset - edit.get_offset, edit.get_text)
        return result
      end
      
      typesig { [ReplaceEdit, IRegion] }
      def split_intersect_left(edit, intersect_)
        result = Array.typed(ReplaceEdit).new(2) { nil }
        result[0] = ReplaceEdit.new(intersect_.get_offset, intersect_.get_length, edit.get_text)
        # this is the actual delete. We use replace to only deal with one type
        result[1] = ReplaceEdit.new(intersect_.get_offset + intersect_.get_length, edit.get_length - intersect_.get_length, "") # $NON-NLS-1$
        return result
      end
      
      typesig { [Map] }
      def restore_positions(edit_map)
        iter = edit_map.key_set.iterator
        while iter.has_next
          marker = iter.next_
          edit = edit_map.get(marker)
          if (marker.is_deleted)
            edit.mark_as_deleted
          else
            edit.adjust_offset(marker.get_offset - edit.get_offset)
            edit.adjust_length(marker.get_length - edit.get_length)
          end
        end
      end
    }
    
    private
    alias_method :initialize__move_source_edit, :initialize
  end
  
end
