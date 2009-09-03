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
  module UndoEditImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Text::Edits
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :JavaList
      include_const ::Org::Eclipse::Jface::Text, :BadLocationException
      include_const ::Org::Eclipse::Jface::Text, :IDocument
    }
  end
  
  # This class encapsulates the reverse changes of an executed text
  # edit tree. To apply an undo memento to a document use method
  # <code>apply(IDocument)</code>.
  # <p>
  # Clients can't add additional children to an undo edit nor can they
  # add an undo edit as a child to another edit. Doing so results in
  # both cases in a <code>MalformedTreeException<code>.
  # 
  # @since 3.0
  # @noinstantiate This class is not intended to be instantiated by clients.
  class UndoEdit < UndoEditImports.const_get :TextEdit
    include_class_members UndoEditImports
    
    typesig { [] }
    def initialize
      super(0, JavaInteger::MAX_VALUE)
    end
    
    typesig { [UndoEdit] }
    def initialize(other)
      super(other)
    end
    
    typesig { [TextEdit] }
    # @see org.eclipse.text.edits.TextEdit#internalAdd(org.eclipse.text.edits.TextEdit)
    def internal_add(child)
      raise MalformedTreeException.new(nil, self, TextEditMessages.get_string("UndoEdit.no_children")) # $NON-NLS-1$
    end
    
    typesig { [TextEdit] }
    # @see org.eclipse.text.edits.MultiTextEdit#aboutToBeAdded(org.eclipse.text.edits.TextEdit)
    def about_to_be_added(parent)
      raise MalformedTreeException.new(parent, self, TextEditMessages.get_string("UndoEdit.can_not_be_added")) # $NON-NLS-1$
    end
    
    typesig { [TextEditProcessor] }
    def dispatch_perform_edits(processor)
      return processor.execute_undo
    end
    
    typesig { [TextEditProcessor] }
    def dispatch_check_integrity(processor)
      processor.check_integrity_undo
    end
    
    typesig { [] }
    # @see org.eclipse.text.edits.TextEdit#doCopy()
    def do_copy
      return UndoEdit.new(self)
    end
    
    typesig { [TextEditVisitor] }
    # @see TextEdit#accept0
    def accept0(visitor)
      visit_children = visitor.visit(self)
      if (visit_children)
        accept_children(visitor)
      end
    end
    
    typesig { [IDocument] }
    # @see TextEdit#performDocumentUpdating
    def perform_document_updating(document)
      self.attr_f_delta = 0
      return self.attr_f_delta
    end
    
    typesig { [ReplaceEdit] }
    def add(edit)
      children = internal_get_children
      if ((children).nil?)
        children = ArrayList.new(2)
        internal_set_children(children)
      end
      children.add(edit)
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    def define_region(offset, length)
      internal_set_offset(offset)
      internal_set_length(length)
    end
    
    typesig { [] }
    def delete_children
      return false
    end
    
    private
    alias_method :initialize__undo_edit, :initialize
  end
  
end
