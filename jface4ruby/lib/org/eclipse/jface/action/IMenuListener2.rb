require "rjava"

# Copyright (c) 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Action
  module IMenuListener2Imports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Action
    }
  end
  
  # A menu listener that gets informed when a menu is about to hide.
  # 
  # @see MenuManager#addMenuListener
  # @since 3.2
  module IMenuListener2
    include_class_members IMenuListener2Imports
    include IMenuListener
    
    typesig { [IMenuManager] }
    # Notifies this listener that the menu is about to be hidden by
    # the given menu manager.
    # 
    # @param manager the menu manager
    def menu_about_to_hide(manager)
      raise NotImplementedError
    end
  end
  
end
