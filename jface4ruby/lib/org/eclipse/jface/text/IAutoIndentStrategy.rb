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
  module IAutoIndentStrategyImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
    }
  end
  
  # Exists for backward compatibility.
  # 
  # @deprecated since 3.0, use <code>IAutoEditStrategy</code> directly
  module IAutoIndentStrategy
    include_class_members IAutoIndentStrategyImports
    include IAutoEditStrategy
  end
  
end
