require "rjava"

# Copyright (c) 2006, 2007 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# Chris Gross (schtoo@schtoo.com) - initial API and implementation for bug 16179
# IBM Corporation - revisions to initial contribution
module Org::Eclipse::Jface::Dialogs
  module IPageChangingListenerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Dialogs
    }
  end
  
  # A listener which is notified when the current page of a multi-page dialog is
  # changing. Use this listener to perform long-running work that should only be
  # executed once, when the page is in the process of changing, rather then
  # during validation of page controls.
  # 
  # @see PageChangingEvent
  # @since 3.3
  module IPageChangingListener
    include_class_members IPageChangingListenerImports
    
    typesig { [PageChangingEvent] }
    # Handle the an <code>IDialogPage</code> changing.
    # 
    # The <code>doit</code> field of the <code>PageChangingEvent</code>
    # must be set to false to prevent the page from changing.
    # 
    # @param event
    # event object describing the change
    def handle_page_changing(event)
      raise NotImplementedError
    end
  end
  
end
