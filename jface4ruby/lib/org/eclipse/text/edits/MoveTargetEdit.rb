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
  module MoveTargetEditImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Text::Edits
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :JavaList
      include_const ::Org::Eclipse::Jface::Text, :BadLocationException
      include_const ::Org::Eclipse::Jface::Text, :IDocument
    }
  end
  
  # A move target edit denotes the target of a move operation. Move
  # target edits are only valid inside an edit tree if they have a
  # corresponding source edit. Furthermore a target edit can't
  # can't be a direct or indirect child of its associated source edit.
  # Violating one of two requirements will result in a <code>
  # MalformedTreeException</code> when executing the edit tree.
  # <p>
  # Move target edits can't be used as a parent for other edits.
  # Trying to add an edit to a move target edit results in a <code>
  # MalformedTreeException</code> as well.
  # 
  # @see org.eclipse.text.edits.MoveSourceEdit
  # @see org.eclipse.text.edits.CopyTargetEdit
  # 
  # @since 3.0
  class MoveTargetEdit < MoveTargetEditImports.const_get :TextEdit
    include_class_members MoveTargetEditImports
    
    attr_accessor :f_source
    alias_method :attr_f_source, :f_source
    undef_method :f_source
    alias_method :attr_f_source=, :f_source=
    undef_method :f_source=
    
    typesig { [::Java::Int] }
    # Constructs a new move target edit
    # 
    # @param offset the edit's offset
    def initialize(offset)
      @f_source = nil
      super(offset, 0)
    end
    
    typesig { [::Java::Int, MoveSourceEdit] }
    # Constructs an new move target edit
    # 
    # @param offset the edit's offset
    # @param source the corresponding source edit
    def initialize(offset, source)
      initialize__move_target_edit(offset)
      set_source_edit(source)
    end
    
    typesig { [MoveTargetEdit] }
    # Copy constructor
    def initialize(other)
      @f_source = nil
      super(other)
    end
    
    typesig { [] }
    # Returns the associated source edit or <code>null</code>
    # if no source edit is associated yet.
    # 
    # @return the source edit or <code>null</code>
    def get_source_edit
      return @f_source
    end
    
    typesig { [MoveSourceEdit] }
    # Sets the source edit.
    # 
    # @param edit the source edit
    # 
    # @exception MalformedTreeException is thrown if the target edit
    # is a direct or indirect child of the source edit
    def set_source_edit(edit)
      if (!(@f_source).equal?(edit))
        @f_source = edit
        @f_source.set_target_edit(self)
        parent = get_parent
        while (!(parent).nil?)
          if ((parent).equal?(@f_source))
            raise MalformedTreeException.new(parent, self, TextEditMessages.get_string("MoveTargetEdit.wrong_parent"))
          end # $NON-NLS-1$
          parent = parent.get_parent
        end
      end
    end
    
    typesig { [] }
    # @see TextEdit#doCopy
    def do_copy
      return MoveTargetEdit.new(self)
    end
    
    typesig { [TextEditCopier] }
    # @see TextEdit#postProcessCopy
    def post_process_copy(copier)
      if (!(@f_source).nil?)
        target = copier.get_copy(self)
        source = copier.get_copy(@f_source)
        if (!(target).nil? && !(source).nil?)
          target.set_source_edit(source)
        end
      end
    end
    
    typesig { [TextEditVisitor] }
    # @see TextEdit#accept0
    def accept0(visitor)
      visit_children = visitor.visit(self)
      if (visit_children)
        accept_children(visitor)
      end
    end
    
    typesig { [TextEditProcessor, IDocument, JavaList] }
    # ---- consistency check ----------------------------------------------------------
    # 
    # @see TextEdit#traverseConsistencyCheck
    def traverse_consistency_check(processor, document, source_edits)
      return super(processor, document, source_edits) + 1
    end
    
    typesig { [TextEditProcessor, IDocument] }
    # @see TextEdit#performConsistencyCheck
    def perform_consistency_check(processor, document)
      if ((@f_source).nil?)
        raise MalformedTreeException.new(get_parent, self, TextEditMessages.get_string("MoveTargetEdit.no_source"))
      end # $NON-NLS-1$
      if (!(@f_source.get_target_edit).equal?(self))
        raise MalformedTreeException.new(get_parent, self, TextEditMessages.get_string("MoveTargetEdit.different_target"))
      end # $NON-NLS-1$
    end
    
    typesig { [IDocument] }
    # ---- document updating ----------------------------------------------------------------
    # 
    # @see TextEdit#performDocumentUpdating
    def perform_document_updating(document)
      source = @f_source.get_content
      document.replace(get_offset, get_length, source)
      self.attr_f_delta = source.length - get_length
      source_root = @f_source.get_source_root
      if (!(source_root).nil?)
        source_root.internal_move_tree(get_offset)
        source_children = source_root.remove_children
        children = ArrayList.new(source_children.attr_length)
        i = 0
        while i < source_children.attr_length
          child = source_children[i]
          child.internal_set_parent(self)
          children.add(child)
          i += 1
        end
        internal_set_children(children)
      end
      @f_source.clear_content
      return self.attr_f_delta
    end
    
    typesig { [TextEditProcessor, IDocument, ::Java::Int, ::Java::Boolean] }
    # ---- region updating --------------------------------------------------------------
    # 
    # @see org.eclipse.text.edits.TextEdit#traversePassThree
    def traverse_region_updating(processor, document, accumulated_delta, delete)
      # the children got already updated / normalized while they got removed
      # from the source edit. So we only have to adjust the offset computed to
      # far.
      if (delete)
        delete_tree
      else
        internal_move_tree(accumulated_delta)
      end
      return accumulated_delta + self.attr_f_delta
    end
    
    typesig { [] }
    def delete_children
      return false
    end
    
    private
    alias_method :initialize__move_target_edit, :initialize
  end
  
end
