require "rjava"

# Copyright (c) 2000, 2005 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Dialogs
  module IPageChangeProviderImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Dialogs
    }
  end
  
  # Minimal interface to a page change provider. Used for dialogs which can
  # switch between multiple pages.
  # 
  # @since 3.1
  module IPageChangeProvider
    include_class_members IPageChangeProviderImports
    
    typesig { [] }
    # Returns the currently selected page in the dialog.
    # 
    # @return the selected page in the dialog or <code>null</code> if none is
    # selected. The type may be domain specific. In
    # the JFace provided dialogs this will be an instance of
    # <code>IDialogPage</code>.
    def get_selected_page
      raise NotImplementedError
    end
    
    typesig { [IPageChangedListener] }
    # Adds a listener for page changes in this page change provider. Has no
    # effect if an identical listener is already registered.
    # 
    # @param listener
    # a page changed listener
    def add_page_changed_listener(listener)
      raise NotImplementedError
    end
    
    typesig { [IPageChangedListener] }
    # Removes the given page change listener from this page change provider.
    # Has no effect if an identical listener is not registered.
    # 
    # @param listener
    # a page changed listener
    def remove_page_changed_listener(listener)
      raise NotImplementedError
    end
  end
  
end
