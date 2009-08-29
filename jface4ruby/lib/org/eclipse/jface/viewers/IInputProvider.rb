require "rjava"

# Copyright (c) 2000, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Viewers
  module IInputProviderImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
    }
  end
  
  # Interface common to all objects that provide an input.
  module IInputProvider
    include_class_members IInputProviderImports
    
    typesig { [] }
    # Returns the input.
    # 
    # @return the input object
    def get_input
      raise NotImplementedError
    end
  end
  
end
