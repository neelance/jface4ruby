require "rjava"

# Copyright (c) 2004, 2005 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Core::Commands
  module IHandlerListenerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Commands
    }
  end
  
  # An instance of this interface can be used by clients to receive notification
  # of changes to one or more instances of <code>IHandler</code>.
  # <p>
  # This interface may be implemented by clients.
  # </p>
  # 
  # @since 3.1
  # @see IHandler#addHandlerListener(IHandlerListener)
  # @see IHandler#removeHandlerListener(IHandlerListener)
  module IHandlerListener
    include_class_members IHandlerListenerImports
    
    typesig { [HandlerEvent] }
    # Notifies that one or more properties of an instance of
    # <code>IHandler</code> have changed. Specific details are described in
    # the <code>HandlerEvent</code>.
    # 
    # @param handlerEvent
    # the handler event. Guaranteed not to be <code>null</code>.
    def handler_changed(handler_event)
      raise NotImplementedError
    end
  end
  
end
