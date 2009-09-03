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
  module CopyTargetEditImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Text::Edits
      include_const ::Java::Util, :JavaList
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Jface::Text, :BadLocationException
      include_const ::Org::Eclipse::Jface::Text, :IDocument
    }
  end
  
  # A copy target edit denotes the target of a copy operation. Copy
  # target edits are only valid inside an edit tree if they have a
  # corresponding source edit. Furthermore a target edit can't
  # can't be a direct or indirect child of the associated source edit.
  # Violating one of two requirements will result in a <code>
  # MalformedTreeException</code> when executing the edit tree.
  # <p>
  # Copy target edits can't be used as a parent for other edits.
  # Trying to add an edit to a copy target edit results in a <code>
  # MalformedTreeException</code> as well.
  # 
  # @see org.eclipse.text.edits.CopySourceEdit
  # 
  # @since 3.0
  class CopyTargetEdit < CopyTargetEditImports.const_get :TextEdit
    include_class_members CopyTargetEditImports
    
    attr_accessor :f_source
    alias_method :attr_f_source, :f_source
    undef_method :f_source
    alias_method :attr_f_source=, :f_source=
    undef_method :f_source=
    
    typesig { [::Java::Int] }
    # Constructs a new copy target edit
    # 
    # @param offset the edit's offset
    def initialize(offset)
      @f_source = nil
      super(offset, 0)
    end
    
    typesig { [::Java::Int, CopySourceEdit] }
    # Constructs an new copy target edit
    # 
    # @param offset the edit's offset
    # @param source the corresponding source edit
    def initialize(offset, source)
      initialize__copy_target_edit(offset)
      set_source_edit(source)
    end
    
    typesig { [CopyTargetEdit] }
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
    
    typesig { [CopySourceEdit] }
    # Sets the source edit.
    # 
    # @param edit the source edit
    # 
    # @exception MalformedTreeException is thrown if the target edit
    # is a direct or indirect child of the source edit
    def set_source_edit(edit)
      Assert.is_not_null(edit)
      if (!(@f_source).equal?(edit))
        @f_source = edit
        @f_source.set_target_edit(self)
        parent = get_parent
        while (!(parent).nil?)
          if ((parent).equal?(@f_source))
            raise MalformedTreeException.new(parent, self, TextEditMessages.get_string("CopyTargetEdit.wrong_parent"))
          end # $NON-NLS-1$
          parent = parent.get_parent
        end
      end
    end
    
    typesig { [] }
    # @see TextEdit#doCopy
    def do_copy
      return CopyTargetEdit.new(self)
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
    # @see TextEdit#traverseConsistencyCheck
    def traverse_consistency_check(processor, document, source_edits)
      return super(processor, document, source_edits) + 1
    end
    
    typesig { [TextEditProcessor, IDocument] }
    # @see TextEdit#performConsistencyCheck
    def perform_consistency_check(processor, document)
      if ((@f_source).nil?)
        raise MalformedTreeException.new(get_parent, self, TextEditMessages.get_string("CopyTargetEdit.no_source"))
      end # $NON-NLS-1$
      if (!(@f_source.get_target_edit).equal?(self))
        raise MalformedTreeException.new(get_parent, self, TextEditMessages.get_string("CopyTargetEdit.different_target"))
      end # $NON-NLS-1$
    end
    
    typesig { [IDocument] }
    # @see TextEdit#performDocumentUpdating
    def perform_document_updating(document)
      source = @f_source.get_content
      document.replace(get_offset, get_length, source)
      self.attr_f_delta = source.length - get_length
      @f_source.clear_content
      return self.attr_f_delta
    end
    
    typesig { [] }
    # @see TextEdit#deleteChildren
    def delete_children
      return false
    end
    
    private
    alias_method :initialize__copy_target_edit, :initialize
  end
  
end
