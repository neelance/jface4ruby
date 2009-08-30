require "rjava"

# Copyright (c) 2005, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Core::Commands
  module ITypedParameterImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Commands
    }
  end
  
  # A command parameter that has a declared type. This interface is intended to
  # be implemented by implementors of {@link IParameter} that will support
  # parameter types.
  # 
  # @since 3.2
  module ITypedParameter
    include_class_members ITypedParameterImports
    
    typesig { [] }
    # Returns the {@link ParameterType} associated with a command parameter or
    # <code>null</code> if the parameter does not declare a type.
    # <p>
    # Note that the parameter type returned may be undefined.
    # </p>
    # 
    # @return the parameter type associated with a command parameter or
    # <code>null</code> if the parameter does not declare a type
    def get_parameter_type
      raise NotImplementedError
    end
  end
  
end
