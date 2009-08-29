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
  module SubToolBarManagerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Action
    }
  end
  
  # A <code>SubToolBarManager</code> monitors the additional and removal of
  # items from a parent manager so that visibility of the entire set can be changed as a
  # unit.
  class SubToolBarManager < SubToolBarManagerImports.const_get :SubContributionManager
    include_class_members SubToolBarManagerImports
    overload_protected {
      include IToolBarManager
    }
    
    typesig { [IToolBarManager] }
    # Constructs a new manager.
    # 
    # @param mgr the parent manager.  All contributions made to the
    # <code>SubToolBarManager</code> are forwarded and appear in the
    # parent manager.
    def initialize(mgr)
      super(mgr)
    end
    
    typesig { [] }
    # @return the parent toolbar manager that this sub-manager contributes to
    def get_parent_tool_bar_manager
      # Cast is ok because that's the only
      # thing we accept in the construtor.
      return get_parent
    end
    
    typesig { [::Java::Boolean] }
    # (non-Javadoc)
    # Method declared on IToolBarManager.
    def update(force)
      # This method is not governed by visibility.  The client may
      # call <code>setVisible</code> and then force an update.  At that
      # point we need to update the parent.
      get_parent_tool_bar_manager.update(force)
    end
    
    private
    alias_method :initialize__sub_tool_bar_manager, :initialize
  end
  
end
