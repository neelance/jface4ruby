require "rjava"

# Copyright (c) 2004, 2005 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Core::Commands
  module ICategoryListenerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Commands
    }
  end
  
  # An instance of this interface can be used by clients to receive notification
  # of changes to one or more instances of <code>Category</code>.
  # <p>
  # This interface may be implemented by clients.
  # </p>
  # 
  # @since 3.1
  # @see Category#addCategoryListener(ICategoryListener)
  # @see Category#removeCategoryListener(ICategoryListener)
  module ICategoryListener
    include_class_members ICategoryListenerImports
    
    typesig { [CategoryEvent] }
    # Notifies that one or more properties of an instance of
    # <code>Category</code> have changed. Specific details are described in
    # the <code>CategoryEvent</code>.
    # 
    # @param categoryEvent
    # the category event. Guaranteed not to be <code>null</code>.
    def category_changed(category_event)
      raise NotImplementedError
    end
  end
  
end
