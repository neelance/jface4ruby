require "rjava"

# Copyright (c) 2000, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Viewers
  module IDoubleClickListenerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
    }
  end
  
  # A listener which is notified of double-click events on viewers.
  module IDoubleClickListener
    include_class_members IDoubleClickListenerImports
    
    typesig { [DoubleClickEvent] }
    # Notifies of a double click.
    # 
    # @param event event object describing the double-click
    def double_click(event)
      raise NotImplementedError
    end
  end
  
end
