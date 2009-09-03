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
  module InsertEditImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Text::Edits
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Jface::Text, :BadLocationException
      include_const ::Org::Eclipse::Jface::Text, :IDocument
    }
  end
  
  # Text edit to insert a text at a given position in a
  # document.
  # <p>
  # An insert edit is equivalent to <code>ReplaceEdit(offset, 0, text)
  # </code>
  # 
  # @since 3.0
  class InsertEdit < InsertEditImports.const_get :TextEdit
    include_class_members InsertEditImports
    
    attr_accessor :f_text
    alias_method :attr_f_text, :f_text
    undef_method :f_text
    alias_method :attr_f_text=, :f_text=
    undef_method :f_text=
    
    typesig { [::Java::Int, String] }
    # Constructs a new insert edit.
    # 
    # @param offset the insertion offset
    # @param text the text to insert
    def initialize(offset, text)
      @f_text = nil
      super(offset, 0)
      Assert.is_not_null(text)
      @f_text = text
    end
    
    typesig { [InsertEdit] }
    # Copy constructor
    def initialize(other)
      @f_text = nil
      super(other)
      @f_text = RJava.cast_to_string(other.attr_f_text)
    end
    
    typesig { [] }
    # Returns the text to be inserted.
    # 
    # @return the edit's text.
    def get_text
      return @f_text
    end
    
    typesig { [] }
    # @see TextEdit#doCopy
    def do_copy
      return InsertEdit.new(self)
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
      document.replace(get_offset, get_length, @f_text)
      self.attr_f_delta = @f_text.length - get_length
      return self.attr_f_delta
    end
    
    typesig { [] }
    # @see TextEdit#deleteChildren
    def delete_children
      return false
    end
    
    typesig { [StringBuffer, ::Java::Int] }
    # @see org.eclipse.text.edits.TextEdit#internalToString(java.lang.StringBuffer, int)
    # @since 3.3
    def internal_to_string(buffer, indent)
      super(buffer, indent)
      buffer.append(" <<").append(@f_text) # $NON-NLS-1$
    end
    
    private
    alias_method :initialize__insert_edit, :initialize
  end
  
end
