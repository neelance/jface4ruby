require "rjava"

# Copyright (c) 2000, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Action
  module IToolBarManagerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Action
    }
  end
  
  # The <code>IToolBarManager</code> interface provides protocol for managing
  # contributions to a tool bar. It extends <code>IContributionManager</code>
  # but does not declare any new members; it exists only to increase the
  # readability of code using tool bars.
  # <p>
  # This package also provides a concrete tool bar manager implementation,
  # {@link ToolBarManager <code>ToolBarManager</code>}.
  # </p>
  module IToolBarManager
    include_class_members IToolBarManagerImports
    include IContributionManager
  end
  
end
