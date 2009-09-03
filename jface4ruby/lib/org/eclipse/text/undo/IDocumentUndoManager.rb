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
  module IDocumentUndoManagerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Text::Undo
      include_const ::Org::Eclipse::Core::Commands, :ExecutionException
      include_const ::Org::Eclipse::Core::Commands::Operations, :IUndoContext
    }
  end
  
  # Interface for a document undo manager. Tracks changes in a document and
  # builds a history of text commands that describe the undoable changes to the
  # document.
  # <p>
  # Clients must explicitly connect to the undo manager to express their interest
  # in the undo history. Clients should disconnect from the undo manager when
  # they are no longer interested in tracking the undo history. If there are no
  # clients connected to the undo manager, it will not track the document's
  # changes and will dispose of any history that was previously kept.</p>
  # <p>
  # Clients may also listen to the undo manager for notifications before and
  # after undo or redo events are performed. Clients must connect to the undo
  # manager in addition to registering listeners.</p>
  # <p>
  # Clients may implement this interface.
  # </p>
  # 
  # @see DocumentUndoManagerRegistry
  # @see IDocumentUndoListener
  # @see org.eclipse.jface.text.IDocument
  # @since 3.2
  module IDocumentUndoManager
    include_class_members IDocumentUndoManagerImports
    
    typesig { [IDocumentUndoListener] }
    # Adds the specified listener to the list of document undo listeners that
    # are notified before and after changes are undone or redone in the
    # document. This method has no effect if the instance being added is
    # already in the list.
    # <p>
    # Notifications will not be received if there are no clients connected to
    # the receiver. Registering a document undo listener does not implicitly
    # connect the listener to the receiver.</p>
    # <p>
    # Document undo listeners must be prepared to receive notifications from a
    # background thread. Any UI access occurring inside the implementation must
    # be properly synchronized using the techniques specified by the client's
    # widget library.</p>
    # 
    # @param listener the document undo listener to be added as a listener
    def add_document_undo_listener(listener)
      raise NotImplementedError
    end
    
    typesig { [IDocumentUndoListener] }
    # Removes the specified listener from the list of document undo listeners.
    # <p>
    # Removing a listener which is not registered has no effect
    # </p>
    # 
    # @param listener the document undo listener to be removed
    def remove_document_undo_listener(listener)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the undo context registered for this document
    # 
    # @return the undo context registered for this document
    def get_undo_context
      raise NotImplementedError
    end
    
    typesig { [] }
    # Closes the currently open text edit and open a new one.
    def commit
      raise NotImplementedError
    end
    
    typesig { [Object] }
    # Connects to the undo manager. Used to signify that a client is monitoring
    # the history kept by the undo manager. This message has no effect if the
    # client is already connected.
    # 
    # @param client the object connecting to the undo manager
    def connect(client)
      raise NotImplementedError
    end
    
    typesig { [Object] }
    # Disconnects from the undo manager. Used to signify that a client is no
    # longer monitoring the history kept by the undo manager. If all clients
    # have disconnected from the undo manager, the undo history will be
    # deleted.
    # 
    # @param client the object disconnecting from the undo manager
    def disconnect(client)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Signals the undo manager that all subsequent changes until
    # <code>endCompoundChange</code> is called are to be undone in one piece.
    def begin_compound_change
      raise NotImplementedError
    end
    
    typesig { [] }
    # Signals the undo manager that the sequence of changes which started with
    # <code>beginCompoundChange</code> has been finished. All subsequent
    # changes are considered to be individually undo-able.
    def end_compound_change
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    # Sets the limit of the undo history to the specified value. The provided
    # limit will supersede any previously set limit.
    # 
    # @param undoLimit the length of this undo manager's history
    def set_maximal_undo_level(undo_limit)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Resets the history of the undo manager. After that call,
    # there aren't any undo-able or redo-able text changes.
    def reset
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns whether at least one text change can be rolled back.
    # 
    # @return <code>true</code> if at least one text change can be rolled back
    def undoable
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns whether at least one text change can be repeated. A text change
    # can be repeated only if it was executed and rolled back.
    # 
    # @return <code>true</code> if at least on text change can be repeated
    def redoable
      raise NotImplementedError
    end
    
    typesig { [] }
    # Rolls back the most recently executed text change.
    # 
    # @throws ExecutionException if an exception occurred during undo
    def undo
      raise NotImplementedError
    end
    
    typesig { [] }
    # Repeats the most recently rolled back text change.
    # 
    # @throws ExecutionException if an exception occurred during redo
    def redo_
      raise NotImplementedError
    end
    
    typesig { [IDocumentUndoManager] }
    # Transfers the undo history from the specified document undo manager to
    # this undo manager.  This message should only be used when it is known
    # that the content of the document of the original undo manager when the
    # last undo operation was recorded is the same as this undo manager's
    # current document content, since the undo history is based on document
    # indexes.  It is the responsibility of the caller
    # to ensure that this call is used correctly.
    # 
    # @param manager the document undo manger whose history is to be transferred to the receiver
    def transfer_undo_history(manager)
      raise NotImplementedError
    end
  end
  
end
