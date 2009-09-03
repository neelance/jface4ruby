require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Source
  module ILineDifferExtension2Imports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Source
    }
  end
  
  # Extension interface for {@link ILineDiffer}.
  # <p>
  # Allows to query the suspension state.
  # </p>
  # 
  # @since 3.3
  module ILineDifferExtension2
    include_class_members ILineDifferExtension2Imports
    
    typesig { [] }
    # Returns <code>true</code> if the receiver is suspended, <code>false</code> otherwise.
    # 
    # @return <code>true</code> if the receiver is suspended, <code>false</code> otherwise
    def is_suspended
      raise NotImplementedError
    end
  end
  
end
