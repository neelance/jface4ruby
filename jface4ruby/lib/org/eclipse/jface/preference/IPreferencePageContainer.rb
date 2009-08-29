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
  module IPreferencePageContainerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Preference
    }
  end
  
  # An interface used by a preference page to talk to
  # its dialog.
  module IPreferencePageContainer
    include_class_members IPreferencePageContainerImports
    
    typesig { [] }
    # Returns the preference store.
    # 
    # @return the preference store, or <code>null</code> if none
    def get_preference_store
      raise NotImplementedError
    end
    
    typesig { [] }
    # Adjusts the enable state of the OK
    # button to reflect the state of the currently active
    # page in this container.
    # <p>
    # This method is called by the container itself
    # when its preference page changes and may be called
    # by the page at other times to force a button state
    # update.
    # </p>
    def update_buttons
      raise NotImplementedError
    end
    
    typesig { [] }
    # Updates the message (or error message) shown in the message line to
    # reflect the state of the currently active page in this container.
    # <p>
    # This method is called by the container itself
    # when its preference page changes and may be called
    # by the page at other times to force a message
    # update.
    # </p>
    def update_message
      raise NotImplementedError
    end
    
    typesig { [] }
    # Updates the title to reflect the state of the
    # currently active page in this container.
    # <p>
    # This method is called by the container itself
    # when its page changes and may be called
    # by the page at other times to force a title
    # update.
    # </p>
    def update_title
      raise NotImplementedError
    end
  end
  
end
