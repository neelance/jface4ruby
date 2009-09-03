require "rjava"

# Copyright (c) 2000, 2007 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text
  module DocumentRewriteSessionEventImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
      include_const ::Org::Eclipse::Core::Runtime, :Assert
    }
  end
  
  # Description of the state of document rewrite sessions.
  # 
  # @see org.eclipse.jface.text.IDocument
  # @see org.eclipse.jface.text.IDocumentExtension4
  # @see org.eclipse.jface.text.IDocumentRewriteSessionListener
  # @since 3.1
  class DocumentRewriteSessionEvent 
    include_class_members DocumentRewriteSessionEventImports
    
    class_module.module_eval {
      const_set_lazy(:SESSION_START) { Object.new }
      const_attr_reader  :SESSION_START
      
      const_set_lazy(:SESSION_STOP) { Object.new }
      const_attr_reader  :SESSION_STOP
    }
    
    # The changed document
    attr_accessor :f_document
    alias_method :attr_f_document, :f_document
    undef_method :f_document
    alias_method :attr_f_document=, :f_document=
    undef_method :f_document=
    
    # The session
    attr_accessor :f_session
    alias_method :attr_f_session, :f_session
    undef_method :f_session
    alias_method :attr_f_session=, :f_session=
    undef_method :f_session=
    
    # The change type
    attr_accessor :f_change_type
    alias_method :attr_f_change_type, :f_change_type
    undef_method :f_change_type
    alias_method :attr_f_change_type=, :f_change_type=
    undef_method :f_change_type=
    
    typesig { [IDocument, DocumentRewriteSession, Object] }
    # Creates a new document event.
    # 
    # @param doc the changed document
    # @param session the session
    # @param changeType the change type. This is either
    # {@link DocumentRewriteSessionEvent#SESSION_START} or
    # {@link DocumentRewriteSessionEvent#SESSION_STOP}.
    def initialize(doc, session, change_type)
      @f_document = nil
      @f_session = nil
      @f_change_type = nil
      Assert.is_not_null(doc)
      Assert.is_not_null(session)
      @f_document = doc
      @f_session = session
      @f_change_type = change_type
    end
    
    typesig { [] }
    # Returns the changed document.
    # 
    # @return the changed document
    def get_document
      return @f_document
    end
    
    typesig { [] }
    # Returns the change type of this event. This is either
    # {@link DocumentRewriteSessionEvent#SESSION_START}or
    # {@link DocumentRewriteSessionEvent#SESSION_STOP}.
    # 
    # @return the change type of this event
    def get_change_type
      return @f_change_type
    end
    
    typesig { [] }
    # Returns the rewrite session.
    # 
    # @return the rewrite session
    def get_session
      return @f_session
    end
    
    private
    alias_method :initialize__document_rewrite_session_event, :initialize
  end
  
end
