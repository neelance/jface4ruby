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
  module ReplaceEditImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Text::Edits
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Jface::Text, :BadLocationException
      include_const ::Org::Eclipse::Jface::Text, :IDocument
    }
  end
  
  # Text edit to replace a range in a document with a different
  # string.
  # 
  # @since 3.0
  class ReplaceEdit < ReplaceEditImports.const_get :TextEdit
    include_class_members ReplaceEditImports
    
    attr_accessor :f_text
    alias_method :attr_f_text, :f_text
    undef_method :f_text
    alias_method :attr_f_text=, :f_text=
    undef_method :f_text=
    
    typesig { [::Java::Int, ::Java::Int, String] }
    # Constructs a new replace edit.
    # 
    # @param offset the offset of the range to replace
    # @param length the length of the range to replace
    # @param text the new text
    def initialize(offset, length, text)
      @f_text = nil
      super(offset, length)
      Assert.is_not_null(text)
      @f_text = text
    end
    
    typesig { [ReplaceEdit] }
    # Copy constructor
    # 
    # @param other the edit to copy from
    def initialize(other)
      @f_text = nil
      super(other)
      @f_text = RJava.cast_to_string(other.attr_f_text)
    end
    
    typesig { [] }
    # Returns the new text replacing the text denoted
    # by the edit.
    # 
    # @return the edit's text.
    def get_text
      return @f_text
    end
    
    typesig { [] }
    # @see TextEdit#doCopy
    def do_copy
      return ReplaceEdit.new(self)
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
      return true
    end
    
    typesig { [StringBuffer, ::Java::Int] }
    # @see org.eclipse.text.edits.TextEdit#internalToString(java.lang.StringBuffer, int)
    # @since 3.3
    def internal_to_string(buffer, indent)
      super(buffer, indent)
      buffer.append(" <<").append(@f_text) # $NON-NLS-1$
    end
    
    private
    alias_method :initialize__replace_edit, :initialize
  end
  
end
