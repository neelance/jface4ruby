require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Action
  module IContributionItemImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Action
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :CoolBar
      include_const ::Org::Eclipse::Swt::Widgets, :Menu
      include_const ::Org::Eclipse::Swt::Widgets, :ToolBar
    }
  end
  
  # A contribution item represents a contribution to a shared UI resource such as a
  # menu or tool bar. More generally, contribution items are managed by a contribution
  # manager.
  # For instance, in a tool bar a contribution item is a tool bar button or a separator.
  # In a menu bar a contribution item is a menu, and in a menu a contribution item
  # is a menu item or separator.
  # <p>
  # A contribution item can realize itself in different SWT widgets, using the different
  # <code>fill</code> methods.  The same type of contribution item can be used with a
  # <code>MenuBarManager</code>, <code>ToolBarManager</code>, <code>CoolBarManager</code>,
  # </code>or a <code>StatusLineManager</code>.
  # </p>
  # <p>
  # This interface is internal to the framework; it should not be implemented outside
  # the framework.
  # </p>
  # 
  # @see IContributionManager
  # @noimplement This interface is not intended to be implemented by clients.
  module IContributionItem
    include_class_members IContributionItemImports
    
    typesig { [] }
    # Disposes of this contribution item. Called by the parent
    # contribution manager when the manager is being disposed.
    # Clients should not call this method directly, unless they
    # have removed this contribution item from the containing
    # IContributionManager before the contribution lifecycle
    # has ended.
    # 
    # @since 2.1
    def dispose
      raise NotImplementedError
    end
    
    typesig { [Composite] }
    # Fills the given composite control with controls representing this
    # contribution item.  Used by <code>StatusLineManager</code>.
    # 
    # @param parent the parent control
    def fill(parent)
      raise NotImplementedError
    end
    
    typesig { [Menu, ::Java::Int] }
    # Fills the given menu with controls representing this contribution item.
    # Used by <code>MenuManager</code>.
    # 
    # @param parent the parent menu
    # @param index the index where the controls are inserted,
    # or <code>-1</code> to insert at the end
    def fill(parent, index)
      raise NotImplementedError
    end
    
    typesig { [ToolBar, ::Java::Int] }
    # Fills the given tool bar with controls representing this contribution item.
    # Used by <code>ToolBarManager</code>.
    # 
    # @param parent the parent tool bar
    # @param index the index where the controls are inserted,
    # or <code>-1</code> to insert at the end
    def fill(parent, index)
      raise NotImplementedError
    end
    
    typesig { [CoolBar, ::Java::Int] }
    # Fills the given cool bar with controls representing this contribution item.
    # Used by <code>CoolBarManager</code>.
    # 
    # @param parent the parent cool bar
    # @param index the index where the controls are inserted,
    # or <code>-1</code> to insert at the end
    # @since 3.0
    def fill(parent, index)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the identifier of this contribution item.
    # The id is used for retrieving an item from its manager.
    # 
    # @return the contribution item identifier, or <code>null</code>
    # if none
    def get_id
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns whether this contribution item is enabled.
    # 
    # @return <code>true</code> if this item is enabled
    def is_enabled
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns whether this contribution item is dirty. A dirty item will be
    # recreated when the action bar is updated.
    # 
    # @return <code>true</code> if this item is dirty
    def is_dirty
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns whether this contribution item is dynamic. A dynamic contribution
    # item contributes items conditionally, dependent on some internal state.
    # 
    # @return <code>true</code> if this item is dynamic, and
    # <code>false</code> for normal items
    def is_dynamic
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns whether this contribution item is a group marker.
    # This information is used when adding items to a group.
    # 
    # @return <code>true</code> if this item is a group marker, and
    # <code>false</code> for normal items
    # 
    # @see GroupMarker
    # @see IContributionManager#appendToGroup(String, IContributionItem)
    # @see IContributionManager#prependToGroup(String, IContributionItem)
    def is_group_marker
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns whether this contribution item is a separator.
    # This information is used to enable hiding of unnecessary separators.
    # 
    # @return <code>true</code> if this item is a separator, and
    # <code>false</code> for normal items
    # @see Separator
    def is_separator
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns whether this contribution item is visibile within its manager.
    # 
    # @return <code>true</code> if this item is visible, and
    # <code>false</code> otherwise
    def is_visible
      raise NotImplementedError
    end
    
    typesig { [] }
    # Saves any state information of the control(s) owned by this contribution item.
    # The contribution manager calls this method before disposing of the controls.
    # 
    # @since 3.0
    def save_widget_state
      raise NotImplementedError
    end
    
    typesig { [IContributionManager] }
    # Sets the parent manager of this item
    # 
    # @param parent the parent contribution manager
    # @since 2.0
    def set_parent(parent)
      raise NotImplementedError
    end
    
    typesig { [::Java::Boolean] }
    # Sets whether this contribution item is visibile within its manager.
    # 
    # @param visible <code>true</code> if this item should be visible, and
    # <code>false</code> otherwise
    def set_visible(visible)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Updates any SWT controls cached by this contribution item with any
    # changes which have been made to this contribution item since the last update.
    # Called by contribution manager update methods.
    def update
      raise NotImplementedError
    end
    
    typesig { [String] }
    # Updates any SWT controls cached by this contribution item with changes
    # for the the given property.
    # 
    # @param id the id of the changed property
    # @since 2.0
    def update(id)
      raise NotImplementedError
    end
  end
  
end
