require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text
  module DocumentRewriteSessionTypeImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
    }
  end
  
  # A document rewrite session type.
  # <p>
  # Allowed values are:
  # <ul>
  # <li>{@link DocumentRewriteSessionType#UNRESTRICTED}</li>
  # <li>{@link DocumentRewriteSessionType#UNRESTRICTED_SMALL} (since 3.3)</li>
  # <li>{@link DocumentRewriteSessionType#SEQUENTIAL}</li>
  # <li>{@link DocumentRewriteSessionType#STRICTLY_SEQUENTIAL}</li>
  # </ul>
  # </p>
  # 
  # @see org.eclipse.jface.text.IDocument
  # @see org.eclipse.jface.text.IDocumentExtension4
  # @see org.eclipse.jface.text.IDocumentRewriteSessionListener
  # @since 3.1
  class DocumentRewriteSessionType 
    include_class_members DocumentRewriteSessionTypeImports
    
    class_module.module_eval {
      # An unrestricted rewrite session is a sequence of unrestricted replace operations. This
      # session type should only be used for <em>large</em> operations that touch more than about
      # fifty lines. Use {@link #UNRESTRICTED_SMALL} for small operations.
      const_set_lazy(:UNRESTRICTED) { DocumentRewriteSessionType.new }
      const_attr_reader  :UNRESTRICTED
      
      # An small unrestricted rewrite session is a short sequence of unrestricted replace operations.
      # This should be used for changes that touch less than about fifty lines.
      # 
      # @since 3.3
      const_set_lazy(:UNRESTRICTED_SMALL) { DocumentRewriteSessionType.new }
      const_attr_reader  :UNRESTRICTED_SMALL
      
      # A sequential rewrite session is a sequence of non-overlapping replace
      # operations starting at an arbitrary document offset.
      const_set_lazy(:SEQUENTIAL) { DocumentRewriteSessionType.new }
      const_attr_reader  :SEQUENTIAL
      
      # A strictly sequential rewrite session is a sequence of non-overlapping
      # replace operations from the start of the document to its end.
      const_set_lazy(:STRICTLY_SEQUENTIAL) { DocumentRewriteSessionType.new }
      const_attr_reader  :STRICTLY_SEQUENTIAL
    }
    
    typesig { [] }
    # Prohibit external object creation.
    def initialize
    end
    
    private
    alias_method :initialize__document_rewrite_session_type, :initialize
  end
  
end
