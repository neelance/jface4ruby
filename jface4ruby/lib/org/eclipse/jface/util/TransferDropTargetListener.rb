require "rjava"

# Copyright (c) 2000, 2005 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Util
  module TransferDropTargetListenerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Util
      include_const ::Org::Eclipse::Swt::Dnd, :DropTargetEvent
      include_const ::Org::Eclipse::Swt::Dnd, :DropTargetListener
      include_const ::Org::Eclipse::Swt::Dnd, :Transfer
    }
  end
  
  # A <code>TransferDropTargetListener</code> is a <code>DropTragetListener</code>
  # that handles one type of SWT {@link Transfer}.
  # The purpose of a <code>TransferDropTargetListener</code> is to:
  # <ul>
  # <li>Determine enablement for a drop operation. A <code>TransferDropTargetListener</code>
  # will not be used if <code>isEnabled</code> returns false.
  # <li>When enabled, optionally show feedback on the <code>DropTarget</code>.
  # <li>Perform the actual drop
  # </ul>
  # A <code>DelegatingDropAdapter</code> allows these functions to be implemented
  # separately for unrelated types of drags. <code>DelegatingDropAdapter</code> then
  # combines the function of each <code>TransferDropTargetListener</code>, while
  # allowing them to be implemented as if they were the only <code>DragSourceListener</code>.
  # @since 3.0
  module TransferDropTargetListener
    include_class_members TransferDropTargetListenerImports
    include DropTargetListener
    
    typesig { [] }
    # Returns the <code>Transfer</code> type that this listener can
    # accept a drop operation for.
    # 
    # @return the <code>Transfer</code> for this listener
    def get_transfer
      raise NotImplementedError
    end
    
    typesig { [DropTargetEvent] }
    # Returns <code>true</code> if this listener can handle the drop
    # based on the given <code>DropTargetEvent</code>.
    # <p>
    # This method is called by the <code>DelegatingDropAdapter</code> only
    # if the <code>DropTargetEvent</code> contains a transfer data type
    # supported by this listener. The <code>Transfer</code> returned by the
    # <code>#getTransfer()</code> method is used for this purpose.
    # </p>
    # 
    # @param event the drop target event
    # @return <code>true</code> if the listener is enabled for the given
    # drop target event.
    def is_enabled(event)
      raise NotImplementedError
    end
  end
  
end
