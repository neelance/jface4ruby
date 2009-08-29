require "rjava"

# Copyright (c) 2000, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Dialogs
  module IInputValidatorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Dialogs
    }
  end
  
  # The IInputValidator is the interface for simple validators.
  # @see org.eclipse.jface.dialogs.InputDialog
  module IInputValidator
    include_class_members IInputValidatorImports
    
    typesig { [String] }
    # Validates the given string.  Returns an error message to display
    # if the new text is invalid.  Returns <code>null</code> if there
    # is no error.  Note that the empty string is not treated the same
    # as <code>null</code>; it indicates an error state but with no message
    # to display.
    # 
    # @param newText the text to check for validity
    # 
    # @return an error message or <code>null</code> if no error
    def is_valid(new_text)
      raise NotImplementedError
    end
  end
  
end
