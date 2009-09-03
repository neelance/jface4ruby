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
  module DeleteEditImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Text::Edits
      include_const ::Org::Eclipse::Jface::Text, :BadLocationException
      include_const ::Org::Eclipse::Jface::Text, :IDocument
    }
  end
  
  # Text edit to delete a range in a document.
  # <p>
  # A delete edit is equivalent to <code>ReplaceEdit(
  # offset, length, "")</code>.
  # 
  # @since 3.0
  class DeleteEdit < DeleteEditImports.const_get :TextEdit
    include_class_members DeleteEditImports
    
    typesig { [::Java::Int, ::Java::Int] }
    # Constructs a new delete edit.
    # 
    # @param offset the offset of the range to replace
    # @param length the length of the range to replace
    def initialize(offset, length)
      super(offset, length)
    end
    
    typesig { [DeleteEdit] }
    # Copy constructor
    def initialize(other)
      super(other)
    end
    
    typesig { [] }
    # @see TextEdit#doCopy
    def do_copy
      return DeleteEdit.new(self)
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
      document.replace(get_offset, get_length, "") # $NON-NLS-1$
      self.attr_f_delta = -get_length
      return self.attr_f_delta
    end
    
    typesig { [] }
    # @see TextEdit#deleteChildren
    def delete_children
      return true
    end
    
    private
    alias_method :initialize__delete_edit, :initialize
  end
  
end
