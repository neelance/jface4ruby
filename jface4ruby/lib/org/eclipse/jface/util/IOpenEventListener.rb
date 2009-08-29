require "rjava"

# Copyright (c) 2000, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Util
  module IOpenEventListenerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Util
      include_const ::Org::Eclipse::Swt::Events, :SelectionEvent
    }
  end
  
  # Listener for open events which are generated on selection
  # of default selection depending on the user preferences.
  # 
  # <p>
  # Usage:
  # <pre>
  # OpenStrategy handler = new OpenStrategy(control);
  # handler.addOpenListener(new IOpenEventListener() {
  # public void handleOpen(SelectionEvent e) {
  # ... // code to handle the open event.
  # }
  # });
  # </pre>
  # </p>
  # 
  # @see OpenStrategy
  module IOpenEventListener
    include_class_members IOpenEventListenerImports
    
    typesig { [SelectionEvent] }
    # Called when a selection or default selection occurs
    # depending on the user preference.
    # @param e the selection event
    def handle_open(e)
      raise NotImplementedError
    end
  end
  
end
