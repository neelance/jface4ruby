require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Viewers
  module IStructuredContentProviderImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
    }
  end
  
  # An interface to content providers for structured viewers.
  # 
  # @see StructuredViewer
  module IStructuredContentProvider
    include_class_members IStructuredContentProviderImports
    include IContentProvider
    
    typesig { [Object] }
    # Returns the elements to display in the viewer
    # when its input is set to the given element.
    # These elements can be presented as rows in a table, items in a list, etc.
    # The result is not modified by the viewer.
    # <p>
    # <b>NOTE:</b> For instances where the viewer is displaying a tree
    # containing a single 'root' element it is still necessary that the
    # 'input' does not return <i>itself</i> from this method. This leads
    # to recursion issues (see bug 9262).
    # </p>
    # @param inputElement the input element
    # @return the array of elements to display in the viewer
    def get_elements(input_element)
      raise NotImplementedError
    end
  end
  
end
