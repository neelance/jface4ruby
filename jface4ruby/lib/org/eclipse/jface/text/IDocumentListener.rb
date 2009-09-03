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
  module IDocumentListenerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
    }
  end
  
  # Interface for objects which are interested in getting informed about
  # document changes. A listener is informed about document changes before
  # they are applied and after they have been applied. It is ensured that
  # the document event passed into the listener is the same for the two
  # notifications, i.e. the two document events can be checked using object identity.
  # <p>
  # Clients may implement this interface.
  # </p>
  # 
  # @see org.eclipse.jface.text.IDocument
  module IDocumentListener
    include_class_members IDocumentListenerImports
    
    typesig { [DocumentEvent] }
    # The manipulation described by the document event will be performed.
    # 
    # @param event the document event describing the document change
    def document_about_to_be_changed(event)
      raise NotImplementedError
    end
    
    typesig { [DocumentEvent] }
    # The manipulation described by the document event has been performed.
    # 
    # @param event the document event describing the document change
    def document_changed(event)
      raise NotImplementedError
    end
  end
  
end
