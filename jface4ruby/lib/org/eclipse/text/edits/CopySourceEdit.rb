require "rjava"

# Copyright (c) 2000, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Text::Edits
  module CopySourceEditImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Text::Edits
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :JavaList
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Jface::Text, :BadLocationException
      include_const ::Org::Eclipse::Jface::Text, :IDocument
    }
  end
  
  # A copy source edit denotes the source of a copy operation. Copy
  # source edits are only valid inside an edit tree if they have a
  # corresponding target edit. Furthermore the corresponding
  # target edit can't be a direct or indirect child of the source
  # edit. Violating one of two requirements will result in a <code>
  # MalformedTreeException</code> when executing the edit tree.
  # <p>
  # A copy source edit can manage an optional source modifier. A
  # source modifier can provide a set of replace edits which will
  # to applied to the source before it gets inserted at the target
  # position.
  # 
  # @see org.eclipse.text.edits.CopyTargetEdit
  # 
  # @since 3.0
  class CopySourceEdit < CopySourceEditImports.const_get :TextEdit
    include_class_members CopySourceEditImports
    
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
    
    class_module.module_eval {
      const_set_lazy(:PartialCopier) { Class.new(TextEditVisitor) do
        include_class_members CopySourceEdit
        
        attr_accessor :f_result
        alias_method :attr_f_result, :f_result
        undef_method :f_result
        alias_method :attr_f_result=, :f_result=
        undef_method :f_result=
        
        attr_accessor :f_parents
        alias_method :attr_f_parents, :f_parents
        undef_method :f_parents
        alias_method :attr_f_parents=, :f_parents=
        undef_method :f_parents=
        
        attr_accessor :f_current_parent
        alias_method :attr_f_current_parent, :f_current_parent
        undef_method :f_current_parent
        alias_method :attr_f_current_parent=, :f_current_parent=
        undef_method :f_current_parent=
        
        class_module.module_eval {
          typesig { [class_self::TextEdit] }
          def perform(source)
            copier = class_self::PartialCopier.new
            source.accept(copier)
            return copier.attr_f_result
          end
        }
        
        typesig { [class_self::TextEdit] }
        def manage_copy(copy)
          if ((@f_result).nil?)
            @f_result = copy
          end
          if (!(@f_current_parent).nil?)
            @f_current_parent.add_child(copy)
          end
          @f_parents.add(@f_current_parent)
          @f_current_parent = copy
        end
        
        typesig { [class_self::TextEdit] }
        def post_visit(edit)
          @f_current_parent = @f_parents.remove(@f_parents.size - 1)
        end
        
        typesig { [class_self::TextEdit] }
        def visit_node(edit)
          manage_copy(edit.do_copy)
          return true
        end
        
        typesig { [class_self::CopySourceEdit] }
        def visit(edit)
          manage_copy(self.class::RangeMarker.new(edit.get_offset, edit.get_length))
          return true
        end
        
        typesig { [class_self::CopyTargetEdit] }
        def visit(edit)
          manage_copy(self.class::InsertEdit.new(edit.get_offset, edit.get_source_edit.get_content))
          return true
        end
        
        typesig { [class_self::MoveSourceEdit] }
        def visit(edit)
          manage_copy(self.class::DeleteEdit.new(edit.get_offset, edit.get_length))
          return true
        end
        
        typesig { [class_self::MoveTargetEdit] }
        def visit(edit)
          manage_copy(self.class::InsertEdit.new(edit.get_offset, edit.get_source_edit.get_content))
          return true
        end
        
        typesig { [] }
        def initialize
          @f_result = nil
          @f_parents = nil
          @f_current_parent = nil
          super()
          @f_parents = self.class::ArrayList.new
        end
        
        private
        alias_method :initialize__partial_copier, :initialize
      end }
    }
    
    typesig { [::Java::Int, ::Java::Int] }
    # Constructs a new copy source edit.
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
    
    typesig { [::Java::Int, ::Java::Int, CopyTargetEdit] }
    # Constructs a new copy source edit.
    # 
    # @param offset the edit's offset
    # @param length the edit's length
    # @param target the edit's target
    def initialize(offset, length, target)
      initialize__copy_source_edit(offset, length)
      set_target_edit(target)
    end
    
    typesig { [CopySourceEdit] }
    # Copy Constructor
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
    
    typesig { [CopyTargetEdit] }
    # Sets the target edit.
    # 
    # @param edit the new target edit.
    # 
    # @exception MalformedTreeException is thrown if the target edit
    # is a direct or indirect child of the source edit
    def set_target_edit(edit)
      Assert.is_not_null(edit)
      if (!(@f_target).equal?(edit))
        @f_target = edit
        @f_target.set_source_edit(self)
      end
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
    # @see TextEdit#doCopy
    def do_copy
      return CopySourceEdit.new(self)
    end
    
    typesig { [TextEditVisitor] }
    # @see TextEdit#accept0
    def accept0(visitor)
      visit_children = visitor.visit(self)
      if (visit_children)
        accept_children(visitor)
      end
    end
    
    typesig { [] }
    # ---- API for CopyTargetEdit ------------------------------------------------
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
    def clear_content
      @f_source_content = RJava.cast_to_string(nil)
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
    
    typesig { [TextEditProcessor, IDocument, JavaList] }
    # ---- consistency check ----------------------------------------------------
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
        raise MalformedTreeException.new(get_parent, self, TextEditMessages.get_string("CopySourceEdit.no_target"))
      end # $NON-NLS-1$
      if (!(@f_target.get_source_edit).equal?(self))
        raise MalformedTreeException.new(get_parent, self, TextEditMessages.get_string("CopySourceEdit.different_source"))
      end # $NON-NLS-1$
      # causes ASTRewrite to fail
      # if (getRoot() != fTarget.getRoot())
      # throw new MalformedTreeException(getParent(), this, TextEditMessages.getString("CopySourceEdit.different_tree")); //$NON-NLS-1$
    end
    
    typesig { [TextEditProcessor, IDocument] }
    # ---- source computation -------------------------------------------------------
    def traverse_source_computation(processor, document)
      # always perform source computation independent of processor.considerEdit
      # The target might need the source and the source is computed in a
      # temporary buffer.
      perform_source_computation(processor, document)
    end
    
    typesig { [TextEditProcessor, IDocument] }
    def perform_source_computation(processor, document)
      begin
        root = MultiTextEdit.new(get_offset, get_length)
        root.internal_set_children(internal_get_children)
        @f_source_content = RJava.cast_to_string(document.get(get_offset, get_length))
        @f_source_root = PartialCopier.perform(root)
        @f_source_root.internal_move_tree(-get_offset)
        if (@f_source_root.has_children)
          sub_document = EditDocument.new(@f_source_content)
          sub_processor = TextEditProcessor.create_source_computation_processor(sub_document, @f_source_root, TextEdit::NONE)
          sub_processor.perform_edits
          if (needs_transformation)
            apply_transformation(sub_document)
          end
          @f_source_content = RJava.cast_to_string(sub_document.get)
          @f_source_root = nil
        else
          if (needs_transformation)
            sub_document = EditDocument.new(@f_source_content)
            apply_transformation(sub_document)
            @f_source_content = RJava.cast_to_string(sub_document.get)
          end
        end
      rescue BadLocationException => cannot_happen
        Assert.is_true(false)
      end
    end
    
    typesig { [] }
    def needs_transformation
      return !(@f_modifier).nil?
    end
    
    typesig { [IDocument] }
    def apply_transformation(document)
      new_edit = MultiTextEdit.new(0, document.get_length)
      replaces = @f_modifier.get_modifications(document.get)
      i = 0
      while i < replaces.attr_length
        new_edit.add_child(replaces[i])
        i += 1
      end
      begin
        new_edit.apply(document, TextEdit::NONE)
      rescue BadLocationException => cannot_happen
        Assert.is_true(false)
      end
    end
    
    typesig { [IDocument] }
    # ---- document updating ----------------------------------------------------------------
    def perform_document_updating(document)
      self.attr_f_delta = 0
      return self.attr_f_delta
    end
    
    typesig { [] }
    # ---- region updating ----------------------------------------------------------------
    # 
    # @see TextEdit#deleteChildren
    def delete_children
      return false
    end
    
    private
    alias_method :initialize__copy_source_edit, :initialize
  end
  
end
