require "rjava"

# Copyright (c) 2005 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Core::Commands::Operations
  module IOperationHistoryListenerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Commands::Operations
    }
  end
  
  # <p>
  # This interface is used to listen to notifications from an IOperationHistory.
  # The supplied OperationHistoryEvent describes the particular notification.
  # </p>
  # <p>
  # Operation history listeners must be prepared to receive notifications from a
  # background thread. Any UI access occurring inside the implementation must be
  # properly synchronized using the techniques specified by the client's widget
  # library.
  # </p>
  # 
  # @since 3.1
  module IOperationHistoryListener
    include_class_members IOperationHistoryListenerImports
    
    typesig { [OperationHistoryEvent] }
    # Something of note has happened in the IOperationHistory. Listeners should
    # check the supplied event for details.
    # 
    # @param event
    # the OperationHistoryEvent that describes the particular
    # notification.
    def history_notification(event)
      raise NotImplementedError
    end
  end
  
end
