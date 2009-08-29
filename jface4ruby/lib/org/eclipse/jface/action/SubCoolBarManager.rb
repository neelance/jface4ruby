require "rjava"

# Copyright (c) 2003, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Action
  module SubCoolBarManagerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Action
      include_const ::Org::Eclipse::Core::Runtime, :Assert
    }
  end
  
  # A <code>SubCoolBarManager</code> monitors the additional and removal of
  # items from a parent manager so that visibility of the entire set can be changed as a
  # unit.
  # 
  # @since 3.0
  class SubCoolBarManager < SubCoolBarManagerImports.const_get :SubContributionManager
    include_class_members SubCoolBarManagerImports
    overload_protected {
      include ICoolBarManager
    }
    
    typesig { [ICoolBarManager] }
    # Constructs a new manager.
    # 
    # @param mgr the parent manager.  All contributions made to the
    # <code>SubCoolBarManager</code> are forwarded and appear in the
    # parent manager.
    def initialize(mgr)
      super(mgr)
      Assert.is_not_null(mgr)
    end
    
    typesig { [IToolBarManager] }
    # (non-Javadoc)
    # @see org.eclipse.jface.action.ICoolBarManager#add(org.eclipse.jface.action.IToolBarManager)
    def add(tool_bar_manager)
      Assert.is_not_null(tool_bar_manager)
      super(ToolBarContributionItem.new(tool_bar_manager))
    end
    
    typesig { [] }
    # (non-Javadoc)
    # @see org.eclipse.jface.action.ICoolBarManager#getStyle()
    def get_style
      # It is okay to cast down since we only accept coolBarManager objects in the
      # constructor
      return (get_parent).get_style
    end
    
    typesig { [] }
    # Returns the parent cool bar manager that this sub-manager contributes to.
    # 
    # @return the parent cool bar manager
    def get_parent_cool_bar_manager
      # Cast is ok because that's the only
      # thing we accept in the construtor.
      return get_parent
    end
    
    typesig { [] }
    # (non-Javadoc)
    # @see org.eclipse.jface.action.ICoolBarManager#isLayoutLocked()
    def get_lock_layout
      return get_parent_cool_bar_manager.get_lock_layout
    end
    
    typesig { [::Java::Boolean] }
    # (non-Javadoc)
    # @see org.eclipse.jface.action.ICoolBarManager#lockLayout(boolean)
    def set_lock_layout(value)
    end
    
    typesig { [] }
    # (non-Javadoc)
    # SubCoolBarManagers do not have control of the global context menu.
    def get_context_menu_manager
      return nil
    end
    
    typesig { [IMenuManager] }
    # (non-Javadoc)
    # In SubCoolBarManager we do nothing.
    def set_context_menu_manager(menu_manager)
      # do nothing
    end
    
    typesig { [::Java::Boolean] }
    # (non-Javadoc)
    # @see org.eclipse.jface.action.IContributionManager#update(boolean)
    def update(force)
      # This method is not governed by visibility.  The client may
      # call <code>setVisible</code> and then force an update.  At that
      # point we need to update the parent.
      get_parent_cool_bar_manager.update(force)
    end
    
    private
    alias_method :initialize__sub_cool_bar_manager, :initialize
  end
  
end
