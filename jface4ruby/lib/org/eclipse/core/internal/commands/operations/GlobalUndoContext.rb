require "rjava"

# Copyright (c) 2005 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Core::Internal::Commands::Operations
  module GlobalUndoContextImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Internal::Commands::Operations
      include_const ::Org::Eclipse::Core::Commands::Operations, :IUndoContext
    }
  end
  
  # <p>
  # An operation context that matches to any context.  It can be used to
  # get an unfiltered (global) history.
  # </p>
  # 
  # @since 3.1
  class GlobalUndoContext 
    include_class_members GlobalUndoContextImports
    include IUndoContext
    
    typesig { [] }
    # (non-Javadoc)
    # @see org.eclipse.core.commands.operations.IUndoContext#getLabel()
    def get_label
      return "Global Undo Context" # $NON-NLS-1$
    end
    
    typesig { [IUndoContext] }
    # (non-Javadoc)
    # @see org.eclipse.core.commands.operations.IUndoContext#matches(IUndoContext context)
    def matches(context)
      return true
    end
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__global_undo_context, :initialize
  end
  
end
