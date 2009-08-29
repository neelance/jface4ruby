require "rjava"

# Copyright (c) 2004, 2005 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Contexts
  module IContextIdsImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Contexts
    }
  end
  
  # $NON-NLS-1$
  # 
  # <p>
  # A list of well-known context identifiers. The context identifiers use the
  # prefix "org.eclipse.ui" for historical reasons. These contexts exist as part
  # of JFace.
  # </p>
  # <p>
  # This interface should not be implemented or extended by clients.
  # </p>
  # 
  # @since 3.1
  module IContextIds
    include_class_members IContextIdsImports
    
    class_module.module_eval {
      # The identifier for the context that is active when a shell registered as
      # a dialog.
      const_set_lazy(:CONTEXT_ID_DIALOG) { "org.eclipse.ui.contexts.dialog" }
      const_attr_reader  :CONTEXT_ID_DIALOG
      
      # $NON-NLS-1$
      # 
      # The identifier for the context that is active when a shell is registered
      # as either a window or a dialog.
      const_set_lazy(:CONTEXT_ID_DIALOG_AND_WINDOW) { "org.eclipse.ui.contexts.dialogAndWindow" }
      const_attr_reader  :CONTEXT_ID_DIALOG_AND_WINDOW
      
      # $NON-NLS-1$
      # 
      # The identifier for the context that is active when a shell is registered
      # as a window.
      const_set_lazy(:CONTEXT_ID_WINDOW) { "org.eclipse.ui.contexts.window" }
      const_attr_reader  :CONTEXT_ID_WINDOW
    }
  end
  
end
