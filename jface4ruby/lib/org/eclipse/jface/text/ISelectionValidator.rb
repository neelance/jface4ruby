require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text
  module ISelectionValidatorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
      include_const ::Org::Eclipse::Jface::Viewers, :ISelection
    }
  end
  
  # A selection validator allows clients to test whether the selection they
  # received during selection changed notification is valid.
  # <p>
  # For example, selection and document changes that occur between the original
  # selection and the point in time the validator is called cause the selection
  # to be invalid.</p>
  # <p>
  # Clients may implement and use this interface.
  # </p>
  # 
  # @since 3.0
  module ISelectionValidator
    include_class_members ISelectionValidatorImports
    
    typesig { [ISelection] }
    # Tests whether the given post selection is still valid.
    # 
    # @param selection the selection
    # @return <code>true</code> if the selection is still valid
    def is_valid(selection)
      raise NotImplementedError
    end
  end
  
end
