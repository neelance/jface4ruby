require "rjava"

# Copyright (c) 2006, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Revisions
  module IRevisionListenerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Revisions
    }
  end
  
  # A listener which is notified when revision information changes.
  # 
  # @see RevisionInformation
  # @see IRevisionRulerColumnExtension
  # @since 3.3
  module IRevisionListener
    include_class_members IRevisionListenerImports
    
    typesig { [RevisionEvent] }
    # Notifies the receiver that the revision information has been updated. This typically occurs
    # when revision information is being displayed in an editor and the annotated document is
    # modified.
    # 
    # @param e the revision event describing the change
    def revision_information_changed(e)
      raise NotImplementedError
    end
  end
  
end
