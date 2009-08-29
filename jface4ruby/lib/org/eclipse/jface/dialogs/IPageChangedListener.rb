require "rjava"

# Copyright (c) 2005 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Dialogs
  module IPageChangedListenerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Dialogs
    }
  end
  
  # A listener which is notified when the current page of the multi-page dialog
  # is changed.
  # 
  # @see IPageChangeProvider
  # @see PageChangedEvent
  # 
  # @since 3.1
  module IPageChangedListener
    include_class_members IPageChangedListenerImports
    
    typesig { [PageChangedEvent] }
    # Notifies that the selected page has changed.
    # 
    # @param event
    # event object describing the change
    def page_changed(event)
      raise NotImplementedError
    end
  end
  
end
