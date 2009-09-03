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
  module IDocumentRewriteSessionListenerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
    }
  end
  
  # Interface for objects which are interested in getting informed about document
  # rewrite sessions.
  # <p>
  # Clients may implement this interface.
  # </p>
  # 
  # @see org.eclipse.jface.text.IDocument
  # @see org.eclipse.jface.text.IDocumentExtension4
  # @since 3.1
  module IDocumentRewriteSessionListener
    include_class_members IDocumentRewriteSessionListenerImports
    
    typesig { [DocumentRewriteSessionEvent] }
    # Signals a change in a document's rewrite session state.
    # 
    # @param event the event describing the document rewrite session state change
    def document_rewrite_session_changed(event)
      raise NotImplementedError
    end
  end
  
end
