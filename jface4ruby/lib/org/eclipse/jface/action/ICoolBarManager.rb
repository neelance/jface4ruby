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
  module ICoolBarManagerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Action
      include_const ::Org::Eclipse::Swt::Widgets, :CoolBar
    }
  end
  
  # The <code>ICoolBarManager</code> interface provides protocol for managing
  # contributions to a cool bar. A cool bar manager delegates responsibility for
  # creating child controls to its contribution items by calling
  # {@link IContributionItem#fill(CoolBar, int)}.
  # <p>
  # This interface is internal to the framework; it should not be implemented
  # outside the framework. This package provides a concrete cool bar manager
  # implementation, {@link CoolBarManager}, which
  # clients may instantiate or subclass.
  # </p>
  # 
  # @see ToolBarContributionItem
  # @since 3.0
  module ICoolBarManager
    include_class_members ICoolBarManagerImports
    include IContributionManager
    
    class_module.module_eval {
      # Property name of a cool item's size (value <code>"size"</code>).
      # <p>
      # The cool bar manager uses this property to tell its cool items to update
      # their size.
      # </p>
      # 
      # @see IContributionItem#update(String) @issue consider declaring this
      # constant elsewhere
      const_set_lazy(:SIZE) { "size" }
      const_attr_reader  :SIZE
    }
    
    typesig { [IToolBarManager] }
    # $NON-NLS-1$
    # 
    # A convenience method to add a tool bar as a contribution item to this
    # cool bar manager. Equivalent to <code>add(new ToolBarContributionManager(toolBarManager))</code>.
    # 
    # @param toolBarManager
    # the tool bar manager to be added
    # @see ToolBarContributionItem
    def add(tool_bar_manager)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the context menu manager used by this cool bar manager. This
    # context menu manager is used by the cool bar manager except for cool
    # items that provide their own.
    # 
    # @return the context menu manager, or <code>null</code> if none
    # @see #setContextMenuManager
    def get_context_menu_manager
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns whether the layout of the underlying cool bar widget is locked.
    # 
    # @return <code>true</code> if cool bar layout is locked, <code>false</code>
    # otherwise
    def get_lock_layout
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the style of the underlying cool bar widget.
    # 
    # @return the style of the cool bar
    def get_style
      raise NotImplementedError
    end
    
    typesig { [IMenuManager] }
    # Sets the context menu of this cool bar manager to the given menu
    # manager.
    # 
    # @param menuManager
    # the context menu manager, or <code>null</code> if none
    # @see #getContextMenuManager
    def set_context_menu_manager(menu_manager)
      raise NotImplementedError
    end
    
    typesig { [::Java::Boolean] }
    # Locks or unlocks the layout of the underlying cool bar widget. Once the
    # cool bar is locked, cool items cannot be repositioned by the user.
    # <p>
    # Note that items can be added or removed programmatically even while the
    # cool bar is locked.
    # </p>
    # 
    # @param value
    # <code>true</code> to lock the cool bar, <code>false</code>
    # to unlock
    def set_lock_layout(value)
      raise NotImplementedError
    end
  end
  
end
