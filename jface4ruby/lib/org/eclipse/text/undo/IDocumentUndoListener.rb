require "rjava"

# Copyright (c) 2006, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Text::Undo
  module IDocumentUndoListenerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Text::Undo
    }
  end
  
  # This interface is used to listen to notifications from a DocumentUndoManager.
  # The supplied DocumentUndoEvent describes the particular notification.
  # <p>
  # Document undo listeners must be prepared to receive notifications from a
  # background thread. Any UI access occurring inside the implementation must be
  # properly synchronized using the techniques specified by the client's widget
  # library.</p>
  # <p>
  # Clients may implement this interface.
  # </p>
  # 
  # @since 3.2
  module IDocumentUndoListener
    include_class_members IDocumentUndoListenerImports
    
    typesig { [DocumentUndoEvent] }
    # The document is involved in an undo-related change.  Notify listeners
    # with an event describing the change.
    # 
    # @param event the document undo event that describes the particular notification
    def document_undo_notification(event)
      raise NotImplementedError
    end
  end
  
end
