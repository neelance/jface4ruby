require "rjava"

# Copyright (c) 2000, 2007 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Action
  module SubMenuManagerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Action
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :Map
      include_const ::Org::Eclipse::Core::Runtime, :ListenerList
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :CoolBar
      include_const ::Org::Eclipse::Swt::Widgets, :Menu
      include_const ::Org::Eclipse::Swt::Widgets, :ToolBar
    }
  end
  
  # A <code>SubMenuManager</code> is used to define a set of contribution
  # items within a parent manager.  Once defined, the visibility of the entire set can
  # be changed as a unit.
  # <p>
  # A client may ask for and make additions to a submenu.  The visibility of these items
  # is also controlled by the visibility of the <code>SubMenuManager</code>.
  # </p>
  class SubMenuManager < SubMenuManagerImports.const_get :SubContributionManager
    include_class_members SubMenuManagerImports
    overload_protected {
      include IMenuManager
    }
    
    # Maps each submenu in the manager to a wrapper.  The wrapper is used to
    # monitor additions and removals.  If the visibility of the manager is modified
    # the visibility of the submenus is also modified.
    attr_accessor :map_menu_to_wrapper
    alias_method :attr_map_menu_to_wrapper, :map_menu_to_wrapper
    undef_method :map_menu_to_wrapper
    alias_method :attr_map_menu_to_wrapper=, :map_menu_to_wrapper=
    undef_method :map_menu_to_wrapper=
    
    # List of registered menu listeners (element type: <code>IMenuListener</code>).
    attr_accessor :menu_listeners
    alias_method :attr_menu_listeners, :menu_listeners
    undef_method :menu_listeners
    alias_method :attr_menu_listeners=, :menu_listeners=
    undef_method :menu_listeners=
    
    # The menu listener added to the parent.  Lazily initialized
    # in addMenuListener.
    attr_accessor :menu_listener
    alias_method :attr_menu_listener, :menu_listener
    undef_method :menu_listener
    alias_method :attr_menu_listener=, :menu_listener=
    undef_method :menu_listener=
    
    typesig { [IMenuManager] }
    # Constructs a new manager.
    # 
    # @param mgr the parent manager.  All contributions made to the
    # <code>SubMenuManager</code> are forwarded and appear in the
    # parent manager.
    def initialize(mgr)
      @map_menu_to_wrapper = nil
      @menu_listeners = nil
      @menu_listener = nil
      super(mgr)
      @menu_listeners = ListenerList.new
    end
    
    typesig { [IMenuListener] }
    # (non-Javadoc)
    # @see org.eclipse.jface.action.IMenuManager#addMenuListener(org.eclipse.jface.action.IMenuListener)
    def add_menu_listener(listener)
      @menu_listeners.add(listener)
      if ((@menu_listener).nil?)
        @menu_listener = Class.new(IMenuListener.class == Class ? IMenuListener : Object) do
          extend LocalClass
          include_class_members SubMenuManager
          include IMenuListener if IMenuListener.class == Module
          
          typesig { [IMenuManager] }
          define_method :menu_about_to_show do |manager|
            listeners = self.attr_menu_listeners.get_listeners
            i = 0
            while i < listeners.attr_length
              (listeners[i]).menu_about_to_show(@local_class_parent)
              (i += 1)
            end
          end
          
          typesig { [] }
          define_method :initialize do
            super()
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self)
      end
      get_parent_menu_manager.add_menu_listener(@menu_listener)
    end
    
    typesig { [] }
    # The default implementation of this <code>IContributionItem</code>
    # method does nothing. Subclasses may override.
    def dispose
      # do nothing
    end
    
    typesig { [] }
    # (non-Javadoc)
    # @see org.eclipse.jface.action.SubContributionManager#disposeManager()
    def dispose_manager
      if (!(@menu_listener).nil?)
        get_parent_menu_manager.remove_menu_listener(@menu_listener)
        @menu_listener = nil
        @menu_listeners.clear
      end
      # Dispose wrapped menus in addition to removing them.
      # See bugs 64024 and 73715 for details.
      # important to dispose menu wrappers before call to super,
      # otherwise super's call to removeAll will remove them
      # before they can be disposed
      if (!(@map_menu_to_wrapper).nil?)
        iter = @map_menu_to_wrapper.values.iterator
        while (iter.has_next)
          wrapper = iter.next_
          wrapper.dispose_manager
        end
        @map_menu_to_wrapper.clear
        @map_menu_to_wrapper = nil
      end
      super
    end
    
    typesig { [Composite] }
    # (non-Javadoc)
    # @see org.eclipse.jface.action.IContributionItem#fill(org.eclipse.swt.widgets.Composite)
    def fill(parent)
      if (is_visible)
        get_parent_menu_manager.fill(parent)
      end
    end
    
    typesig { [CoolBar, ::Java::Int] }
    # (non-Javadoc)
    # @see org.eclipse.jface.action.IContributionItem#fill(org.eclipse.swt.widgets.CoolBar, int)
    def fill(parent, index)
      # do nothing
    end
    
    typesig { [Menu, ::Java::Int] }
    # (non-Javadoc)
    # @see org.eclipse.jface.action.IContributionItem#fill(org.eclipse.swt.widgets.Menu, int)
    def fill(parent, index)
      if (is_visible)
        get_parent_menu_manager.fill(parent, index)
      end
    end
    
    typesig { [ToolBar, ::Java::Int] }
    # (non-Javadoc)
    # @see org.eclipse.jface.action.IContributionItem#fill(org.eclipse.swt.widgets.ToolBar, int)
    def fill(parent, index)
      if (is_visible)
        get_parent_menu_manager.fill(parent, index)
      end
    end
    
    typesig { [String] }
    # (non-Javadoc)
    # Method declared on IContributionManager.
    # 
    # Returns the item passed to us, not the wrapper.
    # In the case of menu's not added by this manager,
    # ensure that we return a wrapper for the menu.
    def find(id)
      item = get_parent_menu_manager.find(id)
      if (item.is_a?(SubContributionItem))
        # Return the item passed to us, not the wrapper.
        item = unwrap(item)
      end
      if (item.is_a?(IMenuManager))
        # if it is a menu manager wrap it before returning
        menu = item
        item = get_wrapper(menu)
      end
      return item
    end
    
    typesig { [String] }
    # <p>
    # The menu returned is wrapped within a <code>SubMenuManager</code> to
    # monitor additions and removals.  If the visibility of this menu is modified
    # the visibility of the submenus is also modified.
    # </p>
    def find_menu_using_path(path)
      item = find_using_path(path)
      if (item.is_a?(IMenuManager))
        return item
      end
      return nil
    end
    
    typesig { [String] }
    # (non-Javadoc)
    # Method declared on IMenuManager.
    # 
    # Returns the item passed to us, not the wrapper.
    # 
    # We use use the same algorithm as MenuManager.findUsingPath, but unwrap
    # submenus along so that SubMenuManagers are visible.
    def find_using_path(path)
      id = path
      rest = nil
      separator = path.index_of(Character.new(?/.ord))
      if (!(separator).equal?(-1))
        id = RJava.cast_to_string(path.substring(0, separator))
        rest = RJava.cast_to_string(path.substring(separator + 1))
      end
      item = find(id) # unwraps item
      if (!(rest).nil? && item.is_a?(IMenuManager))
        menu = item
        item = menu.find_using_path(rest)
      end
      return item
    end
    
    typesig { [] }
    # (non-Javadoc)
    # @see org.eclipse.jface.action.IContributionItem#getId()
    def get_id
      return get_parent_menu_manager.get_id
    end
    
    typesig { [] }
    # @return the parent menu manager that this sub-manager contributes to.
    def get_parent_menu_manager
      # Cast is ok because that's the only
      # thing we accept in the construtor.
      return get_parent
    end
    
    typesig { [] }
    # (non-Javadoc)
    # @see org.eclipse.jface.action.IMenuManager#getRemoveAllWhenShown()
    def get_remove_all_when_shown
      return false
    end
    
    typesig { [IMenuManager] }
    # Returns the menu wrapper for a menu manager.
    # <p>
    # The sub menus within this menu are wrapped within a <code>SubMenuManager</code> to
    # monitor additions and removals.  If the visibility of this menu is modified
    # the visibility of the sub menus is also modified.
    # <p>
    # @param mgr the menu manager to be wrapped
    # 
    # @return the menu wrapper
    def get_wrapper(mgr)
      if ((@map_menu_to_wrapper).nil?)
        @map_menu_to_wrapper = HashMap.new(4)
      end
      wrapper = @map_menu_to_wrapper.get(mgr)
      if ((wrapper).nil?)
        wrapper = wrap_menu(mgr)
        @map_menu_to_wrapper.put(mgr, wrapper)
      end
      return wrapper
    end
    
    typesig { [] }
    # (non-Javadoc)
    # @see org.eclipse.jface.action.IContributionItem#isDynamic()
    def is_dynamic
      return get_parent_menu_manager.is_dynamic
    end
    
    typesig { [] }
    # (non-Javadoc)
    # @see org.eclipse.jface.action.IContributionItem#isEnabled()
    def is_enabled
      return is_visible && get_parent_menu_manager.is_enabled
    end
    
    typesig { [] }
    # (non-Javadoc)
    # @see org.eclipse.jface.action.IContributionItem#isGroupMarker()
    def is_group_marker
      return get_parent_menu_manager.is_group_marker
    end
    
    typesig { [] }
    # (non-Javadoc)
    # @see org.eclipse.jface.action.IContributionItem#isSeparator()
    def is_separator
      return get_parent_menu_manager.is_separator
    end
    
    typesig { [] }
    # Remove all contribution items.
    def remove_all
      super
      if (!(@map_menu_to_wrapper).nil?)
        iter = @map_menu_to_wrapper.values.iterator
        while (iter.has_next)
          wrapper = iter.next_
          wrapper.remove_all
        end
        @map_menu_to_wrapper.clear
        @map_menu_to_wrapper = nil
      end
    end
    
    typesig { [IMenuListener] }
    # (non-Javadoc)
    # @see org.eclipse.jface.action.IMenuManager#removeMenuListener(org.eclipse.jface.action.IMenuListener)
    def remove_menu_listener(listener)
      @menu_listeners.remove(listener)
    end
    
    typesig { [] }
    # (non-Javadoc)
    # @see org.eclipse.jface.action.IContributionItem#saveWidgetState()
    def save_widget_state
      # do nothing
    end
    
    typesig { [IContributionManager] }
    # (non-Javadoc)
    # @see org.eclipse.jface.action.IContributionItem#setParent(org.eclipse.jface.action.IContributionManager)
    def set_parent(parent)
      # do nothing, our "parent manager's" parent
      # is set when it is added to a manager
    end
    
    typesig { [::Java::Boolean] }
    # (non-Javadoc)
    # @see org.eclipse.jface.action.IMenuManager#setRemoveAllWhenShown(boolean)
    def set_remove_all_when_shown(remove_all_)
      Assert.is_true(false, "Should not be called on submenu manager") # $NON-NLS-1$
    end
    
    typesig { [::Java::Boolean] }
    # (non-Javadoc)
    # @see org.eclipse.jface.action.SubContributionManager#setVisible(boolean)
    def set_visible(visible)
      super(visible)
      if (!(@map_menu_to_wrapper).nil?)
        iter = @map_menu_to_wrapper.values.iterator
        while (iter.has_next)
          wrapper = iter.next_
          wrapper.set_visible(visible)
        end
      end
    end
    
    typesig { [] }
    # (non-Javadoc)
    # @see org.eclipse.jface.action.IContributionItem#update()
    def update
      # This method is not governed by visibility.  The client may
      # call <code>setVisible</code> and then force an update.  At that
      # point we need to update the parent.
      get_parent_menu_manager.update
    end
    
    typesig { [::Java::Boolean] }
    # (non-Javadoc)
    # @see org.eclipse.jface.action.IContributionManager#update(boolean)
    def update(force)
      # This method is not governed by visibility.  The client may
      # call <code>setVisible</code> and then force an update.  At that
      # point we need to update the parent.
      get_parent_menu_manager.update(force)
    end
    
    typesig { [String] }
    # (non-Javadoc)
    # @see org.eclipse.jface.action.IContributionItem#update(java.lang.String)
    def update(id)
      get_parent_menu_manager.update(id)
    end
    
    typesig { [::Java::Boolean] }
    # (non-Javadoc)
    # @see org.eclipse.jface.action.IMenuManager#updateAll(boolean)
    def update_all(force)
      # This method is not governed by visibility.  The client may
      # call <code>setVisible</code> and then force an update.  At that
      # point we need to update the parent.
      get_parent_menu_manager.update_all(force)
    end
    
    typesig { [IMenuManager] }
    # Wraps a menu manager in a sub menu manager, and returns the new wrapper.
    # @param menu the menu manager to wrap
    # @return the new wrapped menu manager
    def wrap_menu(menu)
      mgr = SubMenuManager.new(menu)
      mgr.set_visible(is_visible)
      return mgr
    end
    
    private
    alias_method :initialize__sub_menu_manager, :initialize
  end
  
end
