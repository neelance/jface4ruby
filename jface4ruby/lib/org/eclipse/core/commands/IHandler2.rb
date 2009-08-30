require "rjava"

# Copyright (c) 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Core::Commands
  module IHandler2Imports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Commands
    }
  end
  
  # Extend the IHandler interface to provide some context for isEnabled()
  # requests. Clients should use {@link AbstractHandler} unless they need to
  # provide their own listener mechanism.
  # 
  # @since 3.4
  # @see AbstractHandler
  module IHandler2
    include_class_members IHandler2Imports
    include IHandler
    
    typesig { [Object] }
    # Called by the framework to allow the handler to update its enabled state.
    # 
    # @param evaluationContext
    # the state to evaluate against. May be <code>null</code>
    # which indicates that the handler can query whatever model that
    # is necessary. This context must not be cached.
    def set_enabled(evaluation_context)
      raise NotImplementedError
    end
  end
  
end
