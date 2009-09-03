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
  module IDocumentPartitioningListenerExtension2Imports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
    }
  end
  
  # Extension interface to
  # {@link org.eclipse.jface.text.IDocumentPartitioningListener}.
  # <p>
  # 
  # Replaces the previous notification mechanisms by introducing an explicit
  # document partitioning changed event.
  # 
  # @see org.eclipse.jface.text.DocumentPartitioningChangedEvent
  # @since 3.0
  module IDocumentPartitioningListenerExtension2
    include_class_members IDocumentPartitioningListenerExtension2Imports
    
    typesig { [DocumentPartitioningChangedEvent] }
    # Signals the change of document partitionings.
    # <p>
    # This method replaces
    # {@link IDocumentPartitioningListener#documentPartitioningChanged(IDocument)}
    # and
    # {@link IDocumentPartitioningListenerExtension#documentPartitioningChanged(IDocument, IRegion)}
    # 
    # @param event the event describing the change
    # @see IDocument#addDocumentPartitioningListener(IDocumentPartitioningListener)
    def document_partitioning_changed(event)
      raise NotImplementedError
    end
  end
  
end
