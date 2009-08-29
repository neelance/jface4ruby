require "rjava"

# Copyright (c) 2000, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Preference
  module IPreferencePageImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Preference
      include_const ::Org::Eclipse::Jface::Dialogs, :IDialogPage
      include_const ::Org::Eclipse::Swt::Graphics, :Point
    }
  end
  
  # An interface for a preference page. This interface
  # is used primarily by the page's container
  module IPreferencePage
    include_class_members IPreferencePageImports
    include IDialogPage
    
    typesig { [] }
    # Computes a size for this page's UI component.
    # 
    # @return the size of the preference page encoded as
    # <code>new Point(width,height)</code>, or
    # <code>(0,0)</code> if the page doesn't currently have any UI component
    def compute_size
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns whether this dialog page is in a valid state.
    # 
    # @return <code>true</code> if the page is in a valid state,
    # and <code>false</code> if invalid
    def is_valid
      raise NotImplementedError
    end
    
    typesig { [] }
    # Checks whether it is alright to leave this page.
    # 
    # @return <code>false</code> to abort page flipping and the
    # have the current page remain visible, and <code>true</code>
    # to allow the page flip
    def ok_to_leave
      raise NotImplementedError
    end
    
    typesig { [] }
    # Notifies that the container of this preference page has been canceled.
    # 
    # @return <code>false</code> to abort the container's cancel
    # procedure and <code>true</code> to allow the cancel to happen
    def perform_cancel
      raise NotImplementedError
    end
    
    typesig { [] }
    # Notifies that the OK button of this page's container has been pressed.
    # 
    # @return <code>false</code> to abort the container's OK
    # processing and <code>true</code> to allow the OK to happen
    def perform_ok
      raise NotImplementedError
    end
    
    typesig { [IPreferencePageContainer] }
    # Sets or clears the container of this page.
    # 
    # @param preferencePageContainer the preference page container, or <code>null</code>
    def set_container(preference_page_container)
      raise NotImplementedError
    end
    
    typesig { [Point] }
    # Sets the size of this page's UI component.
    # 
    # @param size the size of the preference page encoded as
    # <code>new Point(width,height)</code>
    def set_size(size)
      raise NotImplementedError
    end
  end
  
end
