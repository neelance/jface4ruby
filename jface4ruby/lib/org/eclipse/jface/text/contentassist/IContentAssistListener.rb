require "rjava"

# Copyright (c) 2000, 2005 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Contentassist
  module IContentAssistListenerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Contentassist
      include_const ::Org::Eclipse::Swt::Events, :VerifyEvent
      include_const ::Org::Eclipse::Jface::Text, :IEventConsumer
    }
  end
  
  # An interface whereby listeners can not only receive key events,
  # but can also consume them to prevent subsequent listeners from
  # processing the event.
  module IContentAssistListener
    include_class_members IContentAssistListenerImports
    include IEventConsumer
    
    typesig { [VerifyEvent] }
    # Verifies the key event.
    # 
    # @param event the verify event
    # @return <code>true</code> if processing should be continued by additional listeners
    # @see org.eclipse.swt.custom.VerifyKeyListener#verifyKey(VerifyEvent)
    def verify_key(event)
      raise NotImplementedError
    end
  end
  
end
