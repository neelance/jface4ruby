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
  module IUndoManagerExtensionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
      include_const ::Org::Eclipse::Core::Commands::Operations, :IUndoContext
    }
  end
  
  # Extension interface for {@link org.eclipse.jface.text.IUndoManager}.
  # Introduces access to the undo context.
  # 
  # @see org.eclipse.jface.text.IUndoManager
  # @since 3.1
  module IUndoManagerExtension
    include_class_members IUndoManagerExtensionImports
    
    typesig { [] }
    # Returns this undo manager's undo context.
    # 
    # @return the undo context or <code>null</code> if the undo manager is not connected
    # @see org.eclipse.core.commands.operations.IUndoContext
    def get_undo_context
      raise NotImplementedError
    end
  end
  
end
