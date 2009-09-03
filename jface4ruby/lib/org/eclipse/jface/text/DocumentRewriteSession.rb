require "rjava"

# Copyright (c) 2000, 2005 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text
  module DocumentRewriteSessionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
    }
  end
  
  # A document rewrite session.
  # 
  # @see org.eclipse.jface.text.IDocument
  # @see org.eclipse.jface.text.IDocumentExtension4
  # @see org.eclipse.jface.text.IDocumentRewriteSessionListener
  # @since 3.1
  class DocumentRewriteSession 
    include_class_members DocumentRewriteSessionImports
    
    attr_accessor :f_session_type
    alias_method :attr_f_session_type, :f_session_type
    undef_method :f_session_type
    alias_method :attr_f_session_type=, :f_session_type=
    undef_method :f_session_type=
    
    typesig { [DocumentRewriteSessionType] }
    # Prohibit package external object creation.
    # 
    # @param sessionType the type of this session
    def initialize(session_type)
      @f_session_type = nil
      @f_session_type = session_type
    end
    
    typesig { [] }
    # Returns the type of this session.
    # 
    # @return the type of this session
    def get_session_type
      return @f_session_type
    end
    
    typesig { [] }
    # @see java.lang.Object#toString()
    def to_s
      return StringBuffer.new.append(hash_code).to_s
    end
    
    private
    alias_method :initialize__document_rewrite_session, :initialize
  end
  
end
