require "rjava"

# Copyright (c) 2000, 2009 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
# Remy Chi Jian Suen <remy.suen@gmail.com> - Bug 12116 [Contributions] widgets: MenuManager.setImageDescriptor() method needed
module Org::Eclipse::Jface::Action
  module MenuManagerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Action
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :JavaList
      include_const ::Org::Eclipse::Core::Runtime, :ListenerList
      include_const ::Org::Eclipse::Jface::Resource, :ImageDescriptor
      include_const ::Org::Eclipse::Jface::Resource, :JFaceResources
      include_const ::Org::Eclipse::Jface::Resource, :LocalResourceManager
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Events, :MenuAdapter
      include_const ::Org::Eclipse::Swt::Events, :MenuEvent
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :CoolBar
      include_const ::Org::Eclipse::Swt::Widgets, :Decorations
      include_const ::Org::Eclipse::Swt::Widgets, :Item
      include_const ::Org::Eclipse::Swt::Widgets, :Menu
      include_const ::Org::Eclipse::Swt::Widgets, :MenuItem
      include_const ::Org::Eclipse::Swt::Widgets, :Shell
      include_const ::Org::Eclipse::Swt::Widgets, :ToolBar
    }
  end
  
  # A menu manager is a contribution manager which realizes itself and its items
  # in a menu control; either as a menu bar, a sub-menu, or a context menu.
  # <p>
  # This class may be instantiated; it may also be subclassed.
  # </p>
  class MenuManager < MenuManagerImports.const_get :ContributionManager
    include_class_members MenuManagerImports
    overload_protected {
      include IMenuManager
    }
    
    # The menu id.
    attr_accessor :id
    alias_method :attr_id, :id
    undef_method :id
    alias_method :attr_id=, :id=
    undef_method :id=
    
    # List of registered menu listeners (element type: <code>IMenuListener</code>).
    attr_accessor :listeners
    alias_method :attr_listeners, :listeners
    undef_method :listeners
    alias_method :attr_listeners=, :listeners=
    undef_method :listeners=
    
    # The menu control; <code>null</code> before
    # creation and after disposal.
    attr_accessor :menu
    alias_method :attr_menu, :menu
    undef_method :menu
    alias_method :attr_menu=, :menu=
    undef_method :menu=
    
    # The menu item widget; <code>null</code> before
    # creation and after disposal. This field is used
    # when this menu manager is a sub-menu.
    attr_accessor :menu_item
    alias_method :attr_menu_item, :menu_item
    undef_method :menu_item
    alias_method :attr_menu_item=, :menu_item=
    undef_method :menu_item=
    
    # The text for a sub-menu.
    attr_accessor :menu_text
    alias_method :attr_menu_text, :menu_text
    undef_method :menu_text
    alias_method :attr_menu_text=, :menu_text=
    undef_method :menu_text=
    
    # The image for a sub-menu.
    attr_accessor :image
    alias_method :attr_image, :image
    undef_method :image
    alias_method :attr_image=, :image=
    undef_method :image=
    
    # A resource manager to remember all of the images that have been used by this menu.
    attr_accessor :image_manager
    alias_method :attr_image_manager, :image_manager
    undef_method :image_manager
    alias_method :attr_image_manager=, :image_manager=
    undef_method :image_manager=
    
    # The overrides for items of this manager
    attr_accessor :overrides
    alias_method :attr_overrides, :overrides
    undef_method :overrides
    alias_method :attr_overrides=, :overrides=
    undef_method :overrides=
    
    # The parent contribution manager.
    attr_accessor :parent
    alias_method :attr_parent, :parent
    undef_method :parent
    alias_method :attr_parent=, :parent=
    undef_method :parent=
    
    # Indicates whether <code>removeAll</code> should be
    # called just before the menu is displayed.
    attr_accessor :remove_all_when_shown
    alias_method :attr_remove_all_when_shown, :remove_all_when_shown
    undef_method :remove_all_when_shown
    alias_method :attr_remove_all_when_shown=, :remove_all_when_shown=
    undef_method :remove_all_when_shown=
    
    # Indicates this item is visible in its manager; <code>true</code>
    # by default.
    # @since 3.3
    attr_accessor :visible
    alias_method :attr_visible, :visible
    undef_method :visible
    alias_method :attr_visible=, :visible=
    undef_method :visible=
    
    # allows a submenu to display a shortcut key. This is often used with the
    # QuickMenu command or action which can pop up a menu using the shortcut.
    attr_accessor :definition_id
    alias_method :attr_definition_id, :definition_id
    undef_method :definition_id
    alias_method :attr_definition_id=, :definition_id=
    undef_method :definition_id=
    
    typesig { [] }
    # Creates a menu manager.  The text and id are <code>null</code>.
    # Typically used for creating a context menu, where it doesn't need to be referred to by id.
    def initialize
      initialize__menu_manager(nil, nil, nil)
    end
    
    typesig { [String] }
    # Creates a menu manager with the given text. The id of the menu
    # is <code>null</code>.
    # Typically used for creating a sub-menu, where it doesn't need to be referred to by id.
    # 
    # @param text the text for the menu, or <code>null</code> if none
    def initialize(text)
      initialize__menu_manager(text, nil, nil)
    end
    
    typesig { [String, String] }
    # Creates a menu manager with the given text and id.
    # Typically used for creating a sub-menu, where it needs to be referred to by id.
    # 
    # @param text the text for the menu, or <code>null</code> if none
    # @param id the menu id, or <code>null</code> if it is to have no id
    def initialize(text, id)
      initialize__menu_manager(text, nil, id)
    end
    
    typesig { [String, ImageDescriptor, String] }
    # Creates a menu manager with the given text, image, and id.
    # Typically used for creating a sub-menu, where it needs to be referred to by id.
    # 
    # @param text the text for the menu, or <code>null</code> if none
    # @param image the image for the menu, or <code>null</code> if none
    # @param id the menu id, or <code>null</code> if it is to have no id
    # @since 3.4
    def initialize(text, image, id)
      @id = nil
      @listeners = nil
      @menu = nil
      @menu_item = nil
      @menu_text = nil
      @image = nil
      @image_manager = nil
      @overrides = nil
      @parent = nil
      @remove_all_when_shown = false
      @visible = false
      @definition_id = nil
      super()
      @listeners = ListenerList.new
      @menu = nil
      @remove_all_when_shown = false
      @visible = true
      @definition_id = nil
      @menu_text = text
      @image = image
      @id = id
    end
    
    typesig { [IMenuListener] }
    # (non-Javadoc)
    # @see org.eclipse.jface.action.IMenuManager#addMenuListener(org.eclipse.jface.action.IMenuListener)
    def add_menu_listener(listener)
      @listeners.add(listener)
    end
    
    typesig { [Control] }
    # Creates and returns an SWT context menu control for this menu,
    # and installs all registered contributions.
    # Does not create a new control if one already exists.
    # <p>
    # Note that the menu is not expected to be dynamic.
    # </p>
    # 
    # @param parent the parent control
    # @return the menu control
    def create_context_menu(parent)
      if (!menu_exist)
        @menu = Menu.new(parent)
        initialize_menu
      end
      return @menu
    end
    
    typesig { [Decorations] }
    # Creates and returns an SWT menu bar control for this menu,
    # for use in the given <code>Decorations</code>, and installs all registered
    # contributions. Does not create a new control if one already exists.
    # 
    # @param parent the parent decorations
    # @return the menu control
    # @since 2.1
    def create_menu_bar(parent)
      if (!menu_exist)
        @menu = Menu.new(parent, SWT::BAR)
        update(false)
      end
      return @menu
    end
    
    typesig { [Shell] }
    # Creates and returns an SWT menu bar control for this menu, for use in the
    # given <code>Shell</code>, and installs all registered contributions. Does not
    # create a new control if one already exists. This implementation simply calls
    # the <code>createMenuBar(Decorations)</code> method
    # 
    # @param parent the parent decorations
    # @return the menu control
    # @deprecated use <code>createMenuBar(Decorations)</code> instead.
    def create_menu_bar(parent)
      return create_menu_bar(parent)
    end
    
    typesig { [] }
    # Disposes of this menu manager and frees all allocated SWT resources.
    # Notifies all contribution items of the dispose. Note that this method does
    # not clean up references between this menu manager and its associated
    # contribution items. Use <code>removeAll</code> for that purpose.
    def dispose
      if (menu_exist)
        @menu.dispose
      end
      @menu = nil
      if (!(@menu_item).nil?)
        @menu_item.dispose
        @menu_item = nil
      end
      dispose_old_images
      items = get_items
      i = 0
      while i < items.attr_length
        items[i].dispose
        i += 1
      end
      mark_dirty
    end
    
    typesig { [Composite] }
    # (non-Javadoc)
    # @see org.eclipse.jface.action.IContributionItem#fill(org.eclipse.swt.widgets.Composite)
    def fill(parent)
    end
    
    typesig { [CoolBar, ::Java::Int] }
    # (non-Javadoc)
    # @see org.eclipse.jface.action.IContributionItem#fill(org.eclipse.swt.widgets.CoolBar, int)
    def fill(parent, index)
    end
    
    typesig { [Menu, ::Java::Int] }
    # (non-Javadoc)
    # @see org.eclipse.jface.action.IContributionItem#fill(org.eclipse.swt.widgets.Menu, int)
    def fill(parent, index)
      if ((@menu_item).nil? || @menu_item.is_disposed)
        if (index >= 0)
          @menu_item = MenuItem.new(parent, SWT::CASCADE, index)
        else
          @menu_item = MenuItem.new(parent, SWT::CASCADE)
        end
        text = get_menu_text
        if (!(text).nil?)
          @menu_item.set_text(text)
        end
        if (!(@image).nil?)
          local_manager = LocalResourceManager.new(JFaceResources.get_resources)
          @menu_item.set_image(local_manager.create_image(@image))
          dispose_old_images
          @image_manager = local_manager
        end
        if (!menu_exist)
          @menu = Menu.new(parent)
        end
        @menu_item.set_menu(@menu)
        initialize_menu
        set_dirty(true)
      end
    end
    
    typesig { [ToolBar, ::Java::Int] }
    # (non-Javadoc)
    # @see org.eclipse.jface.action.IContributionItem#fill(org.eclipse.swt.widgets.ToolBar, int)
    def fill(parent, index)
    end
    
    typesig { [String] }
    # (non-Javadoc)
    # @see org.eclipse.jface.action.IMenuManager#findMenuUsingPath(java.lang.String)
    def find_menu_using_path(path)
      item = find_using_path(path)
      if (item.is_a?(IMenuManager))
        return item
      end
      return nil
    end
    
    typesig { [String] }
    # (non-Javadoc)
    # @see org.eclipse.jface.action.IMenuManager#findUsingPath(java.lang.String)
    def find_using_path(path)
      id = path
      rest = nil
      separator = path.index_of(Character.new(?/.ord))
      if (!(separator).equal?(-1))
        id = RJava.cast_to_string(path.substring(0, separator))
        rest = RJava.cast_to_string(path.substring(separator + 1))
      else
        return ContributionManager.instance_method(:find).bind(self).call(path)
      end
      item = ContributionManager.instance_method(:find).bind(self).call(id)
      if (item.is_a?(IMenuManager))
        manager = item
        return manager.find_using_path(rest)
      end
      return nil
    end
    
    typesig { [IMenuManager] }
    # Notifies any menu listeners that a menu is about to show.
    # Only listeners registered at the time this method is called are notified.
    # 
    # @param manager the menu manager
    # 
    # @see IMenuListener#menuAboutToShow
    def fire_about_to_show(manager)
      listeners = @listeners.get_listeners
      i = 0
      while i < listeners.attr_length
        (listeners[i]).menu_about_to_show(manager)
        (i += 1)
      end
    end
    
    typesig { [IMenuManager] }
    # Notifies any menu listeners that a menu is about to hide.
    # Only listeners registered at the time this method is called are notified.
    # 
    # @param manager the menu manager
    def fire_about_to_hide(manager)
      listeners = @listeners.get_listeners
      i = 0
      while i < listeners.attr_length
        listener = listeners[i]
        if (listener.is_a?(IMenuListener2))
          listener2 = listener
          listener2.menu_about_to_hide(manager)
        end
        (i += 1)
      end
    end
    
    typesig { [] }
    # Returns the menu id. The menu id is used when creating a contribution
    # item for adding this menu as a sub menu of another.
    # 
    # @return the menu id
    def get_id
      return @id
    end
    
    typesig { [] }
    # Returns the SWT menu control for this menu manager.
    # 
    # @return the menu control
    def get_menu
      return @menu
    end
    
    typesig { [] }
    # Returns the text shown in the menu, potentially with a shortcut
    # appended.
    # 
    # @return the menu text
    def get_menu_text
      if ((@definition_id).nil?)
        return @menu_text
      end
      callback = ExternalActionManager.get_instance.get_callback
      if (!(callback).nil?)
        short_cut = callback.get_accelerator_text(@definition_id)
        if ((short_cut).nil?)
          return @menu_text
        end
        return @menu_text + "\t" + short_cut # $NON-NLS-1$
      end
      return @menu_text
    end
    
    typesig { [] }
    # Returns the image for this menu as an image descriptor.
    # 
    # @return the image, or <code>null</code> if this menu has no image
    # @since 3.4
    def get_image_descriptor
      return @image
    end
    
    typesig { [] }
    # (non-Javadoc)
    # @see org.eclipse.jface.action.IContributionManager#getOverrides()
    def get_overrides
      if ((@overrides).nil?)
        if ((@parent).nil?)
          @overrides = Class.new(IContributionManagerOverrides.class == Class ? IContributionManagerOverrides : Object) do
            extend LocalClass
            include_class_members MenuManager
            include IContributionManagerOverrides if IContributionManagerOverrides.class == Module
            
            typesig { [IContributionItem] }
            define_method :get_accelerator do |item|
              return nil
            end
            
            typesig { [IContributionItem] }
            define_method :get_accelerator_text do |item|
              return nil
            end
            
            typesig { [IContributionItem] }
            define_method :get_enabled do |item|
              return nil
            end
            
            typesig { [IContributionItem] }
            define_method :get_text do |item|
              return nil
            end
            
            typesig { [IContributionItem] }
            define_method :get_visible do |item|
              return nil
            end
            
            typesig { [Vararg.new(Object)] }
            define_method :initialize do |*args|
              super(*args)
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self)
        else
          @overrides = @parent.get_overrides
        end
        ContributionManager.instance_method(:set_overrides).bind(self).call(@overrides)
      end
      return @overrides
    end
    
    typesig { [] }
    # Returns the parent contribution manager of this manger.
    # 
    # @return the parent contribution manager
    # @since 2.0
    def get_parent
      return @parent
    end
    
    typesig { [] }
    # (non-Javadoc)
    # @see org.eclipse.jface.action.IMenuManager#getRemoveAllWhenShown()
    def get_remove_all_when_shown
      return @remove_all_when_shown
    end
    
    typesig { [] }
    # Notifies all listeners that this menu is about to appear.
    def handle_about_to_show
      if (@remove_all_when_shown)
        remove_all
      end
      fire_about_to_show(self)
      update(false, false)
    end
    
    typesig { [] }
    # Notifies all listeners that this menu is about to disappear.
    def handle_about_to_hide
      fire_about_to_hide(self)
    end
    
    typesig { [] }
    # Initializes the menu control.
    def initialize_menu
      @menu.add_menu_listener(Class.new(MenuAdapter.class == Class ? MenuAdapter : Object) do
        extend LocalClass
        include_class_members MenuManager
        include MenuAdapter if MenuAdapter.class == Module
        
        typesig { [MenuEvent] }
        define_method :menu_hidden do |e|
          # ApplicationWindow.resetDescription(e.widget);
          handle_about_to_hide
        end
        
        typesig { [MenuEvent] }
        define_method :menu_shown do |e|
          handle_about_to_show
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      # Don't do an update(true) here, in case menu is never opened.
      # Always do it lazily in handleAboutToShow().
    end
    
    typesig { [] }
    # (non-Javadoc)
    # @see org.eclipse.jface.action.IContributionItem#isDynamic()
    def is_dynamic
      return false
    end
    
    typesig { [] }
    # Returns whether this menu should be enabled or not.
    # Used to enable the menu item containing this menu when it is realized as a sub-menu.
    # <p>
    # The default implementation of this framework method
    # returns <code>true</code>. Subclasses may reimplement.
    # </p>
    # 
    # @return <code>true</code> if enabled, and
    # <code>false</code> if disabled
    def is_enabled
      return true
    end
    
    typesig { [] }
    # (non-Javadoc)
    # @see org.eclipse.jface.action.IContributionItem#isGroupMarker()
    def is_group_marker
      return false
    end
    
    typesig { [] }
    # (non-Javadoc)
    # @see org.eclipse.jface.action.IContributionItem#isSeparator()
    def is_separator
      return false
    end
    
    typesig { [IContributionItem] }
    # Check if the contribution is item is a subsitute for ourselves
    # 
    # @param item the contribution item
    # @return <code>true</code> if give item is a substitution for ourselves
    # @deprecated this method is no longer a part of the
    # {@link org.eclipse.jface.action.IContributionItem} API.
    def is_substitute_for(item)
      return (self == item)
    end
    
    typesig { [] }
    # (non-Javadoc)
    # @see org.eclipse.jface.action.IContributionItem#isVisible()
    def is_visible
      if (!@visible)
        return false # short circuit calculations in this case
      end
      if (@remove_all_when_shown)
        # we have no way of knowing if the menu has children
        return true
      end
      # menus aren't visible if all of its children are invisible (or only contains visible separators).
      child_items = get_items
      visible_children = false
      j = 0
      while j < child_items.attr_length
        if (is_child_visible(child_items[j]) && !child_items[j].is_separator)
          visible_children = true
          break
        end
        j += 1
      end
      return visible_children
    end
    
    typesig { [] }
    # The <code>MenuManager</code> implementation of this <code>ContributionManager</code> method
    # also propagates the dirty flag up the parent chain.
    # 
    # @since 3.1
    def mark_dirty
      super
      # Can't optimize by short-circuiting when the first dirty manager is encountered,
      # since non-visible children are not even processed.
      # That is, it's possible to have a dirty sub-menu under a non-dirty parent menu
      # even after the parent menu has been updated.
      # If items are added/removed in the sub-menu, we still need to propagate the dirty flag up,
      # even if the sub-menu is already dirty, since the result of isVisible() may change
      # due to the added/removed items.
      parent = get_parent
      if (!(parent).nil?)
        parent.mark_dirty
      end
    end
    
    typesig { [] }
    # Returns whether the menu control is created
    # and not disposed.
    # 
    # @return <code>true</code> if the control is created
    # and not disposed, <code>false</code> otherwise
    # @since 3.4 protected, was added in 3.1 as private method
    def menu_exist
      return !(@menu).nil? && !@menu.is_disposed
    end
    
    typesig { [IMenuListener] }
    # (non-Javadoc)
    # @see org.eclipse.jface.action.IMenuManager#removeMenuListener(org.eclipse.jface.action.IMenuListener)
    def remove_menu_listener(listener)
      @listeners.remove(listener)
    end
    
    typesig { [] }
    # (non-Javadoc)
    # @see org.eclipse.jface.action.IContributionItem#saveWidgetState()
    def save_widget_state
    end
    
    typesig { [IContributionManagerOverrides] }
    # Sets the overrides for this contribution manager
    # 
    # @param newOverrides the overrides for the items of this manager
    # @since 2.0
    def set_overrides(new_overrides)
      @overrides = new_overrides
      super(@overrides)
    end
    
    typesig { [IContributionManager] }
    # (non-Javadoc)
    # @see org.eclipse.jface.action.IContributionItem#setParent(org.eclipse.jface.action.IContributionManager)
    def set_parent(manager)
      @parent = manager
    end
    
    typesig { [::Java::Boolean] }
    # (non-Javadoc)
    # @see org.eclipse.jface.action.IMenuManager#setRemoveAllWhenShown(boolean)
    def set_remove_all_when_shown(remove_all_)
      @remove_all_when_shown = remove_all_
    end
    
    typesig { [::Java::Boolean] }
    # (non-Javadoc)
    # @see org.eclipse.jface.action.IContributionItem#setVisible(boolean)
    def set_visible(visible)
      @visible = visible
    end
    
    typesig { [String] }
    # Sets the action definition id of this action. This simply allows the menu
    # item text to include a short cut if available.  It can be used to
    # notify a user of a key combination that will open a quick menu.
    # 
    # @param definitionId
    # the command definition id
    # @since 3.4
    def set_action_definition_id(definition_id)
      @definition_id = definition_id
    end
    
    typesig { [] }
    # (non-Javadoc)
    # @see org.eclipse.jface.action.IContributionItem#update()
    def update
      update_menu_item
    end
    
    typesig { [::Java::Boolean] }
    # The <code>MenuManager</code> implementation of this <code>IContributionManager</code>
    # updates this menu, but not any of its submenus.
    # 
    # @see #updateAll
    def update(force)
      update(force, false)
    end
    
    typesig { [] }
    # Get all the items from the implementation's widget.
    # 
    # @return the menu items
    # @since 3.4
    def get_menu_items
      if (!(@menu).nil?)
        return @menu.get_items
      end
      return nil
    end
    
    typesig { [::Java::Int] }
    # Get an item from the implementation's widget.
    # 
    # @param index
    # of the item
    # @return the menu item
    # @since 3.4
    def get_menu_item(index)
      if (!(@menu).nil?)
        return @menu.get_item(index)
      end
      return nil
    end
    
    typesig { [] }
    # Get the menu item count for the implementation's widget.
    # 
    # @return the number of items
    # @since 3.4
    def get_menu_item_count
      if (!(@menu).nil?)
        return @menu.get_item_count
      end
      return 0
    end
    
    typesig { [IContributionItem, ::Java::Int] }
    # Call an <code>IContributionItem</code>'s fill method with the
    # implementation's widget. The default is to use the <code>Menu</code>
    # widget.<br>
    # <code>fill(Menu menu, int index)</code>
    # 
    # @param ci
    # An <code>IContributionItem</code> whose <code>fill()</code>
    # method should be called.
    # @param index
    # The position the <code>fill()</code> method should start
    # inserting at.
    # @since 3.4
    def do_item_fill(ci, index)
      ci.fill(@menu, index)
    end
    
    typesig { [::Java::Boolean, ::Java::Boolean] }
    # Incrementally builds the menu from the contribution items.
    # This method leaves out double separators and separators in the first
    # or last position.
    # 
    # @param force <code>true</code> means update even if not dirty,
    # and <code>false</code> for normal incremental updating
    # @param recursive <code>true</code> means recursively update
    # all submenus, and <code>false</code> means just this menu
    def update(force, recursive)
      if (is_dirty || force)
        if (menu_exist)
          # clean contains all active items without double separators
          items = get_items
          clean = ArrayList.new(items.attr_length)
          separator = nil
          i = 0
          while i < items.attr_length
            ci = items[i]
            if (!is_child_visible(ci))
              (i += 1)
              next
            end
            if (ci.is_separator)
              # delay creation until necessary
              # (handles both adjacent separators, and separator at end)
              separator = ci
            else
              if (!(separator).nil?)
                if (clean.size > 0)
                  clean.add(separator)
                end
                separator = nil
              end
              clean.add(ci)
            end
            (i += 1)
          end
          # remove obsolete (removed or non active)
          mi = get_menu_items
          i_ = 0
          while i_ < mi.attr_length
            data = mi[i_].get_data
            if ((data).nil? || !clean.contains(data))
              mi[i_].dispose
            else
              if (data.is_a?(IContributionItem) && (data).is_dynamic && (data).is_dirty)
                mi[i_].dispose
              end
            end
            i_ += 1
          end
          # add new
          mi = get_menu_items
          src_ix = 0
          dest_ix = 0
          e = clean.iterator
          while e.has_next
            src = e.next_
            dest = nil
            # get corresponding item in SWT widget
            if (src_ix < mi.attr_length)
              dest = mi[src_ix].get_data
            else
              dest = nil
            end
            if (!(dest).nil? && (src == dest))
              src_ix += 1
              dest_ix += 1
            else
              if (!(dest).nil? && dest.is_separator && src.is_separator)
                mi[src_ix].set_data(src)
                src_ix += 1
                dest_ix += 1
              else
                start = get_menu_item_count
                do_item_fill(src, dest_ix)
                new_items = get_menu_item_count - start
                i__ = 0
                while i__ < new_items
                  item = get_menu_item(((dest_ix += 1) - 1))
                  item.set_data(src)
                  i__ += 1
                end
              end
            end
            # May be we can optimize this call. If the menu has just
            # been created via the call src.fill(fMenuBar, destIx) then
            # the menu has already been updated with update(true)
            # (see MenuManager). So if force is true we do it again. But
            # we can't set force to false since then information for the
            # sub sub menus is lost.
            if (recursive)
              item = src
              if (item.is_a?(SubContributionItem))
                item = (item).get_inner_item
              end
              if (item.is_a?(IMenuManager))
                (item).update_all(force)
              end
            end
          end
          # remove any old menu items not accounted for
          while src_ix < mi.attr_length
            mi[src_ix].dispose
            src_ix += 1
          end
          set_dirty(false)
        end
      else
        # I am not dirty. Check if I must recursivly walk down the hierarchy.
        if (recursive)
          items = get_items
          i = 0
          while i < items.attr_length
            ci = items[i]
            if (ci.is_a?(IMenuManager))
              mm = ci
              if (is_child_visible(mm))
                mm.update_all(force)
              end
            end
            (i += 1)
          end
        end
      end
      update_menu_item
    end
    
    typesig { [String] }
    # (non-Javadoc)
    # @see org.eclipse.jface.action.IContributionItem#update(java.lang.String)
    def update(property)
      items = get_items
      i = 0
      while i < items.attr_length
        items[i].update(property)
        i += 1
      end
      if (!(@menu).nil? && !@menu.is_disposed && !(@menu.get_parent_item).nil?)
        if ((IAction::TEXT == property))
          text = get_overrides.get_text(self)
          if ((text).nil?)
            text = RJava.cast_to_string(get_menu_text)
          end
          if (!(text).nil?)
            callback = ExternalActionManager.get_instance.get_callback
            if (!(callback).nil?)
              index = text.index_of(Character.new(?&.ord))
              if (index >= 0 && index < text.length - 1)
                character = Character.to_upper_case(text.char_at(index + 1))
                if (callback.is_accelerator_in_use(SWT::ALT | character))
                  if ((index).equal?(0))
                    text = RJava.cast_to_string(text.substring(1))
                  else
                    text = RJava.cast_to_string(text.substring(0, index) + text.substring(index + 1))
                  end
                end
              end
            end
            @menu.get_parent_item.set_text(text)
          end
        else
          if ((IAction::IMAGE == property) && !(@image).nil?)
            local_manager = LocalResourceManager.new(JFaceResources.get_resources)
            @menu.get_parent_item.set_image(local_manager.create_image(@image))
            dispose_old_images
            @image_manager = local_manager
          end
        end
      end
    end
    
    typesig { [] }
    # Dispose any images allocated for this menu
    def dispose_old_images
      if (!(@image_manager).nil?)
        @image_manager.dispose
        @image_manager = nil
      end
    end
    
    typesig { [::Java::Boolean] }
    # (non-Javadoc)
    # @see org.eclipse.jface.action.IMenuManager#updateAll(boolean)
    def update_all(force)
      update(force, true)
    end
    
    typesig { [] }
    # Updates the menu item for this sub menu.
    # The menu item is disabled if this sub menu is empty.
    # Does nothing if this menu is not a submenu.
    def update_menu_item
      # Commented out until proper solution to enablement of
      # menu item for a sub-menu is found. See bug 30833 for
      # more details.
      # 
      # if (menuItem != null && !menuItem.isDisposed() && menuExist()) {
      # IContributionItem items[] = getItems();
      # boolean enabled = false;
      # for (int i = 0; i < items.length; i++) {
      # IContributionItem item = items[i];
      # enabled = item.isEnabled();
      # if(enabled) break;
      # }
      # // Workaround for 1GDDCN2: SWT:Linux - MenuItem.setEnabled() always causes a redraw
      # if (menuItem.getEnabled() != enabled)
      # menuItem.setEnabled(enabled);
      # }
      # 
      # Partial fix for bug #34969 - diable the menu item if no
      # items in sub-menu (for context menus).
      if (!(@menu_item).nil? && !@menu_item.is_disposed && menu_exist)
        enabled = @remove_all_when_shown || @menu.get_item_count > 0
        # Workaround for 1GDDCN2: SWT:Linux - MenuItem.setEnabled() always causes a redraw
        if (!(@menu_item.get_enabled).equal?(enabled))
          # We only do this for context menus (for bug #34969)
          top_menu = @menu
          while (!(top_menu.get_parent_menu).nil?)
            top_menu = top_menu.get_parent_menu
          end
          if (((top_menu.get_style & SWT::BAR)).equal?(0))
            @menu_item.set_enabled(enabled)
          end
        end
      end
    end
    
    typesig { [IContributionItem] }
    def is_child_visible(item)
      v = get_overrides.get_visible(item)
      if (!(v).nil?)
        return v.boolean_value
      end
      return item.is_visible
    end
    
    private
    alias_method :initialize__menu_manager, :initialize
  end
  
end
