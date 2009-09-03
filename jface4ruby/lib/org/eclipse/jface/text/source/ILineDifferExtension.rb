require "rjava"

# Copyright (c) 2000, 2005 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Source
  module ILineDifferExtensionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Source
    }
  end
  
  # Extension interface for {@link ILineDiffer}.
  # <p>
  # Introduces the concept of suspending a differ. A <code>ILineDiffer</code> may
  # be suspended into a dormant state, and resumed to normal operation.
  # </p>
  # 
  # @since 3.1
  module ILineDifferExtension
    include_class_members ILineDifferExtensionImports
    
    typesig { [] }
    # Suspends the receiver. All differences are cleared.
    def suspend
      raise NotImplementedError
    end
    
    typesig { [] }
    # Resumes the receiver. Must only be called after suspend.
    def resume
      raise NotImplementedError
    end
  end
  
end
