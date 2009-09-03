require "rjava"

# Copyright (c) 2000, 2005 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text
  module ISlaveDocumentManagerExtensionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
    }
  end
  
  # Extension interface for {@link org.eclipse.jface.text.ISlaveDocumentManager}.
  # <p>
  # Adds access to the list of all slave documents for a given master document.
  # 
  # @see org.eclipse.jface.text.ISlaveDocumentManager
  # @since 3.0
  module ISlaveDocumentManagerExtension
    include_class_members ISlaveDocumentManagerExtensionImports
    
    typesig { [IDocument] }
    # Returns the list of slave documents for the given master document or
    # <code>null</code> if there are no such slave document.
    # 
    # @param master the master document
    # @return the list of slave documents or <code>null</code>
    def get_slave_documents(master)
      raise NotImplementedError
    end
  end
  
end
