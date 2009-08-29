require "rjava"

# Copyright (c) 2004, 2005 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Bindings
  module IBindingManagerListenerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Bindings
    }
  end
  
  # <p>
  # An instance of <code>BindingManagerListener</code> can be used by clients to
  # receive notification of changes to an instance of
  # <code>BindingManager</code>.
  # </p>
  # <p>
  # This interface may be implemented by clients.
  # </p>
  # 
  # @since 3.1
  # @see BindingManager#addBindingManagerListener(IBindingManagerListener)
  # @see org.eclipse.jface.bindings.BindingManager#addBindingManagerListener(IBindingManagerListener)
  # @see BindingManagerEvent
  module IBindingManagerListener
    include_class_members IBindingManagerListenerImports
    
    typesig { [BindingManagerEvent] }
    # Notifies that attributes inside an instance of <code>BindingManager</code> have changed.
    # Specific details are described in the <code>BindingManagerEvent</code>.  Changes in the
    # binding manager can cause the set of defined or active schemes or bindings to change.
    # 
    # @param event
    # the binding manager event. Guaranteed not to be <code>null</code>.
    def binding_manager_changed(event)
      raise NotImplementedError
    end
  end
  
end
