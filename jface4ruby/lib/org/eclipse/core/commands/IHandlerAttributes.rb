require "rjava"

# Copyright (c) 2005 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Core::Commands
  module IHandlerAttributesImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Commands
    }
  end
  
  # $NON-NLS-1$
  # 
  # <p>
  # Attribute constants that have special meanings within this package.  These
  # attributes can be used to communicate extra information from the handler to
  # either the command or the command manager.
  # </p>
  # 
  # @since 3.1
  module IHandlerAttributes
    include_class_members IHandlerAttributesImports
    
    class_module.module_eval {
      # <p>
      # The name of the attribute indicating whether the handler is handled.
      # This is intended largely for backward compatibility with the workbench
      # <code>RetargetAction</code> class.  It is used to indicate that while
      # the handler is handling a command, it should not be treated as such.
      # The command should act and behave as if it has no handler.
      # </p>
      const_set_lazy(:ATTRIBUTE_HANDLED) { "handled" }
      const_attr_reader  :ATTRIBUTE_HANDLED
    }
  end
  
end
