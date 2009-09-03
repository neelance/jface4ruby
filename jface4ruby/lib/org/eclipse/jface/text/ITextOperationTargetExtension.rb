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
  module ITextOperationTargetExtensionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
    }
  end
  
  # Extension interface for {@link org.eclipse.jface.text.ITextOperationTarget}.
  # <p>
  # Allows a client to control the enable state of operations provided by this
  # target.
  # 
  # @see org.eclipse.jface.text.ITextOperationTarget
  # @since 2.0
  module ITextOperationTargetExtension
    include_class_members ITextOperationTargetExtensionImports
    
    typesig { [::Java::Int, ::Java::Boolean] }
    # Enables/disabled the given text operation.
    # 
    # @param operation the operation to enable/disable
    # @param enable <code>true</code> to enable the operation otherwise <code>false</code>
    def enable_operation(operation, enable)
      raise NotImplementedError
    end
  end
  
end
