require "rjava"

# Copyright (c) 2000, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Action
  module IMenuListenerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Action
    }
  end
  
  # A menu listener that gets informed when a menu is about to show.
  # 
  # @see MenuManager#addMenuListener
  module IMenuListener
    include_class_members IMenuListenerImports
    
    typesig { [IMenuManager] }
    # Notifies this listener that the menu is about to be shown by
    # the given menu manager.
    # 
    # @param manager the menu manager
    def menu_about_to_show(manager)
      raise NotImplementedError
    end
  end
  
end
