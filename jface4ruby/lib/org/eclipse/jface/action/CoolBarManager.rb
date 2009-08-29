require "rjava"

# Copyright (c) 2003, 2009 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Action
  module CoolBarManagerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Action
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :ListIterator
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Jface::Internal::Provisional::Action, :IToolBarManager2
      include_const ::Org::Eclipse::Jface::Util, :Policy
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :CoolBar
      include_const ::Org::Eclipse::Swt::Widgets, :CoolItem
      include_const ::Org::Eclipse::Swt::Widgets, :Menu
    }
  end
  
  # A cool bar manager is a contribution manager which realizes itself and its
  # items in a cool bar control.
  # <p>
  # This class may be instantiated; it may also be subclassed.
  # </p>
  # 
  # @since 3.0
  class CoolBarManager < CoolBarManagerImports.const_get :ContributionManager
    include_class_members CoolBarManagerImports
    overload_protected {
      include ICoolBarManager
    }
    
    class_module.module_eval {
      # A separator created by the end user.
      const_set_lazy(:USER_SEPARATOR) { "UserSeparator" }
      const_attr_reader  :USER_SEPARATOR
    }
    
    # $NON-NLS-1$
    # 
    # The original creation order of the contribution items.
    attr_accessor :cb_items_creation_order
    alias_method :attr_cb_items_creation_order, :cb_items_creation_order
    undef_method :cb_items_creation_order
    alias_method :attr_cb_items_creation_order=, :cb_items_creation_order=
    undef_method :cb_items_creation_order=
    
    # MenuManager for cool bar pop-up menu, or null if none.
    attr_accessor :context_menu_manager
    alias_method :attr_context_menu_manager, :context_menu_manager
    undef_method :context_menu_manager
    alias_method :attr_context_menu_manager=, :context_menu_manager=
    undef_method :context_menu_manager=
    
    # The cool bar control; <code>null</code> before creation and after
    # disposal.
    attr_accessor :cool_bar
    alias_method :attr_cool_bar, :cool_bar
    undef_method :cool_bar
    alias_method :attr_cool_bar=, :cool_bar=
    undef_method :cool_bar=
    
    # The cool bar items style; <code>SWT.NONE</code> by default.
    attr_accessor :item_style
    alias_method :attr_item_style, :item_style
    undef_method :item_style
    alias_method :attr_item_style=, :item_style=
    undef_method :item_style=
    
    typesig { [] }
    # Creates a new cool bar manager with the default style. Equivalent to
    # <code>CoolBarManager(SWT.NONE)</code>.
    def initialize
      @cb_items_creation_order = nil
      @context_menu_manager = nil
      @cool_bar = nil
      @item_style = 0
      super()
      @cb_items_creation_order = ArrayList.new
      @context_menu_manager = nil
      @cool_bar = nil
      @item_style = SWT::NONE
      # do nothing
    end
    
    typesig { [CoolBar] }
    # Creates a cool bar manager for an existing cool bar control. This
    # manager becomes responsible for the control, and will dispose of it when
    # the manager is disposed.
    # 
    # @param coolBar
    # the cool bar control
    def initialize(cool_bar)
      initialize__cool_bar_manager()
      Assert.is_not_null(cool_bar)
      @cool_bar = cool_bar
      @item_style = cool_bar.get_style
    end
    
    typesig { [::Java::Int] }
    # Creates a cool bar manager with the given SWT style. Calling <code>createControl</code>
    # will create the cool bar control.
    # 
    # @param style
    # the cool bar item style; see
    # {@link org.eclipse.swt.widgets.CoolBar CoolBar}for for valid
    # style bits
    def initialize(style)
      @cb_items_creation_order = nil
      @context_menu_manager = nil
      @cool_bar = nil
      @item_style = 0
      super()
      @cb_items_creation_order = ArrayList.new
      @context_menu_manager = nil
      @cool_bar = nil
      @item_style = SWT::NONE
      @item_style = style
    end
    
    typesig { [IToolBarManager] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.action.ICoolBarManager#add(org.eclipse.jface.action.IToolBarManager)
    def add(tool_bar_manager)
      Assert.is_not_null(tool_bar_manager)
      super(ToolBarContributionItem.new(tool_bar_manager))
    end
    
    typesig { [ArrayList] }
    # Collapses consecutive separators and removes a separator from the
    # beginning and end of the list.
    # 
    # @param contributionList
    # the list of contributions; must not be <code>null</code>.
    # @return The contribution list provided with extraneous separators
    # removed; this value is never <code>null</code>, but may be
    # empty.
    def adjust_contribution_list(contribution_list)
      item = nil
      # Fist remove a separator if it is the first element of the list
      if (!(contribution_list.size).equal?(0))
        item = contribution_list.get(0)
        if (item.is_separator)
          contribution_list.remove(0)
        end
        iterator = contribution_list.list_iterator
        # collapse consecutive separators
        while (iterator.has_next)
          item = iterator.next_
          if (item.is_separator)
            while (iterator.has_next)
              item = iterator.next_
              if (item.is_separator)
                iterator.remove
              else
                break
              end
            end
          end
        end
        if (!(contribution_list.size).equal?(0))
          # Now check last element to see if there is a separator
          item = contribution_list.get(contribution_list.size - 1)
          if (item.is_separator)
            contribution_list.remove(contribution_list.size - 1)
          end
        end
      end
      return contribution_list
    end
    
    typesig { [IContributionItem] }
    # (non-Javadoc)
    # @see org.eclipse.jface.action.ContributionManager#checkDuplication(org.eclipse.jface.action.IContributionItem)
    def allow_item(item_to_add)
      # We will allow as many null entries as they like, though there should
      # be none.
      if ((item_to_add).nil?)
        return true
      end
      # Null identifiers can be expected in generic contribution items.
      first_id = item_to_add.get_id
      if ((first_id).nil?)
        return true
      end
      # Cycle through the current list looking for duplicates.
      current_items = get_items
      i = 0
      while i < current_items.attr_length
        current_item = current_items[i]
        # We ignore null entries.
        if ((current_item).nil?)
          i += 1
          next
        end
        second_id = current_item.get_id
        if ((first_id == second_id))
          if (Policy::TRACE_TOOLBAR)
            System.out.println("Trying to add a duplicate item.") # $NON-NLS-1$
            JavaException.new.print_stack_trace(System.out)
            System.out.println("DONE --------------------------") # $NON-NLS-1$
          end
          return false
        end
        i += 1
      end
      return true
    end
    
    typesig { [ListIterator] }
    # Positions the list iterator to the end of all the separators. Calling
    # <code>next()</code> the iterator should return the immediate object
    # following the last separator.
    # 
    # @param iterator
    # the list iterator.
    def collapse_separators(iterator)
      while (iterator.has_next)
        item = iterator.next_
        if (!item.is_separator)
          iterator.previous
          return
        end
      end
    end
    
    typesig { [] }
    # Returns whether the cool bar control has been created and not yet
    # disposed.
    # 
    # @return <code>true</code> if the control has been created and not yet
    # disposed, <code>false</code> otherwise
    def cool_bar_exist
      return !(@cool_bar).nil? && !@cool_bar.is_disposed
    end
    
    typesig { [Composite] }
    # Creates and returns this manager's cool bar control. Does not create a
    # new control if one already exists.
    # 
    # @param parent
    # the parent control
    # @return the cool bar control
    def create_control(parent)
      Assert.is_not_null(parent)
      if (!cool_bar_exist)
        @cool_bar = CoolBar.new(parent, @item_style)
        @cool_bar.set_menu(get_context_menu_control)
        @cool_bar.set_locked(false)
        update(false)
      end
      return @cool_bar
    end
    
    typesig { [] }
    # Disposes of this cool bar manager and frees all allocated SWT resources.
    # Notifies all contribution items of the dispose. Note that this method
    # does not clean up references between this cool bar manager and its
    # associated contribution items. Use <code>removeAll</code> for that
    # purpose.
    def dispose
      if (cool_bar_exist)
        @cool_bar.dispose
        @cool_bar = nil
      end
      items = get_items
      i = 0
      while i < items.attr_length
        # Disposes of the contribution item.
        # If Contribution Item is a toolbar then it will dispose of
        # all the nested
        # contribution items.
        items[i].dispose
        i += 1
      end
      # If a context menu existed then dispose of it.
      if (!(@context_menu_manager).nil?)
        @context_menu_manager.dispose
        @context_menu_manager = nil
      end
    end
    
    typesig { [CoolItem] }
    # Disposes the given cool item.
    # 
    # @param item
    # the cool item to dispose
    def dispose(item)
      if ((!(item).nil?) && !item.is_disposed)
        item.set_data(nil)
        control = item.get_control
        # if the control is already disposed, setting the coolitem
        # control to null will cause an SWT exception, workaround
        # for 19630
        if ((!(control).nil?) && !control.is_disposed)
          item.set_control(nil)
        end
        item.dispose
      end
    end
    
    typesig { [IContributionItem] }
    # Finds the cool item associated with the given contribution item.
    # 
    # @param item
    # the contribution item
    # @return the associated cool item, or <code>null</code> if not found
    def find_cool_item(item)
      cool_items = ((@cool_bar).nil?) ? nil : @cool_bar.get_items
      return find_cool_item(cool_items, item)
    end
    
    typesig { [Array.typed(CoolItem), IContributionItem] }
    def find_cool_item(items, item)
      if ((items).nil?)
        return nil
      end
      i = 0
      while i < items.attr_length
        cool_item = items[i]
        data = cool_item.get_data
        if (!(data).nil? && (data == item))
          return cool_item
        end
        i += 1
      end
      return nil
    end
    
    typesig { [Array.typed(::Java::Int)] }
    # Return a consistent set of wrap indices. The return value will always
    # include at least one entry and the first entry will always be zero.
    # CoolBar.getWrapIndices() is inconsistent in whether or not it returns an
    # index for the first row.
    # 
    # @param wraps
    # the wrap indicies from the cool bar widget
    # @return the adjusted wrap indicies.
    def get_adjusted_wrap_indices(wraps)
      adjusted_wrap_indices = nil
      if ((wraps.attr_length).equal?(0))
        adjusted_wrap_indices = Array.typed(::Java::Int).new([0])
      else
        if (!(wraps[0]).equal?(0))
          adjusted_wrap_indices = Array.typed(::Java::Int).new(wraps.attr_length + 1) { 0 }
          adjusted_wrap_indices[0] = 0
          i = 0
          while i < wraps.attr_length
            adjusted_wrap_indices[i + 1] = wraps[i]
            i += 1
          end
        else
          adjusted_wrap_indices = wraps
        end
      end
      return adjusted_wrap_indices
    end
    
    typesig { [] }
    # Returns the control of the Menu Manager. If the menu manager does not
    # have a control then one is created.
    # 
    # @return menu control associated with manager, or null if none
    def get_context_menu_control
      if ((!(@context_menu_manager).nil?) && (!(@cool_bar).nil?))
        menu_widget = @context_menu_manager.get_menu
        if (((menu_widget).nil?) || (menu_widget.is_disposed))
          menu_widget = @context_menu_manager.create_context_menu(@cool_bar)
        end
        return menu_widget
      end
      return nil
    end
    
    typesig { [] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.action.ICoolBarManager#isLayoutLocked()
    def get_context_menu_manager
      return @context_menu_manager
    end
    
    typesig { [] }
    # Returns the cool bar control for this manager.
    # 
    # @return the cool bar control, or <code>null</code> if none
    def get_control
      return @cool_bar
    end
    
    typesig { [] }
    # Returns an array list of all the contribution items in the manager.
    # 
    # @return an array list of contribution items.
    def get_item_list
      cb_items = get_items
      list = ArrayList.new(cb_items.attr_length)
      i = 0
      while i < cb_items.attr_length
        list.add(cb_items[i])
        i += 1
      end
      return list
    end
    
    typesig { [] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.action.ICoolBarManager#isLayoutLocked()
    def get_lock_layout
      if (!cool_bar_exist)
        return false
      end
      return @cool_bar.get_locked
    end
    
    typesig { [Array.typed(IContributionItem)] }
    # Returns the number of rows that should be displayed visually.
    # 
    # @param items
    # the array of contributin items
    # @return the number of rows
    def get_num_rows(items)
      num_rows = 1
      separator_found = false
      i = 0
      while i < items.attr_length
        if (items[i].is_separator)
          separator_found = true
        end
        if ((separator_found) && (is_child_visible(items[i])) && (!items[i].is_group_marker) && (!items[i].is_separator))
          num_rows += 1
          separator_found = false
        end
        i += 1
      end
      return num_rows
    end
    
    typesig { [] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.action.ICoolBarManager#getStyle()
    def get_style
      return @item_style
    end
    
    typesig { [IContributionItem] }
    # Subclasses may extend this <code>ContributionManager</code> method,
    # but must call <code>super.itemAdded</code>.
    # 
    # @see org.eclipse.jface.action.ContributionManager#itemAdded(org.eclipse.jface.action.IContributionItem)
    def item_added(item)
      Assert.is_not_null(item)
      super(item)
      inserted_at = index_of(item)
      replaced = false
      size_ = @cb_items_creation_order.size
      i = 0
      while i < size_
        created = @cb_items_creation_order.get(i)
        if (!(created.get_id).nil? && (created.get_id == item.get_id))
          @cb_items_creation_order.set(i, item)
          replaced = true
          break
        end
        i += 1
      end
      if (!replaced)
        @cb_items_creation_order.add(Math.min(Math.max(inserted_at, 0), @cb_items_creation_order.size), item)
      end
    end
    
    typesig { [IContributionItem] }
    # Subclasses may extend this <code>ContributionManager</code> method,
    # but must call <code>super.itemRemoved</code>.
    # 
    # @see org.eclipse.jface.action.ContributionManager#itemRemoved(org.eclipse.jface.action.IContributionItem)
    def item_removed(item)
      Assert.is_not_null(item)
      super(item)
      cool_item = find_cool_item(item)
      if (!(cool_item).nil?)
        cool_item.set_data(nil)
      end
    end
    
    typesig { [ListIterator, ::Java::Boolean] }
    # Positions the list iterator to the starting of the next row. By calling
    # next on the returned iterator, it will return the first element of the
    # next row.
    # 
    # @param iterator
    # the list iterator of contribution items
    # @param ignoreCurrentItem
    # Whether the current item in the iterator should be considered
    # (as well as subsequent items).
    def next_row(iterator, ignore_current_item)
      current_element = nil
      if (!ignore_current_item && iterator.has_previous)
        current_element = iterator.previous
        iterator.next_
      end
      if ((!(current_element).nil?) && (current_element.is_separator))
        collapse_separators(iterator)
        return
      end
      # Find next separator
      while (iterator.has_next)
        item = iterator.next_
        if (item.is_separator)
          # we we find a separator, collapse any consecutive
          # separators
          # and return
          collapse_separators(iterator)
          return
        end
      end
    end
    
    typesig { [] }
    # Used for debuging. Prints all the items in the internal structures.
    # 
    # private void printContributions(ArrayList contributionList) {
    # int index = 0;
    # System.out.println("----------------------------------\n"); //$NON-NLS-1$
    # for (Iterator i = contributionList.iterator(); i.hasNext(); index++) {
    # IContributionItem item = (IContributionItem) i.next();
    # if (item.isSeparator()) {
    # System.out.println("Separator"); //$NON-NLS-1$
    # } else {
    # System.out.println(index + ". Item id: " + item.getId() //$NON-NLS-1$
    # + " - is Visible: " //$NON-NLS-1$
    # + item.isVisible());
    # }
    # }
    # }
    # 
    # Synchronizes the visual order of the cool items in the control with this
    # manager's internal data structures. This method should be called before
    # requesting the order of the contribution items to ensure that the order
    # is accurate.
    # <p>
    # Note that <code>update()</code> and <code>refresh()</code> are
    # converses: <code>update()</code> changes the visual order to match the
    # internal structures, and <code>refresh</code> changes the internal
    # structures to match the visual order.
    # </p>
    def refresh
      if (!cool_bar_exist)
        return
      end
      # Retreives the list of contribution items as an array list
      contribution_list = get_item_list
      # Check the size of the list
      if ((contribution_list.size).equal?(0))
        return
      end
      # The list of all the cool items in their visual order
      cool_items = @cool_bar.get_items
      # The wrap indicies of the coolbar
      wrap_indicies = get_adjusted_wrap_indices(@cool_bar.get_wrap_indices)
      row = 0
      cool_item_index = 0
      # Traverse through all cool items in the coolbar add them to a new
      # data structure
      # in the correct order
      displayed_items = ArrayList.new(@cool_bar.get_item_count)
      i = 0
      while i < cool_items.attr_length
        cool_item = cool_items[i]
        if (cool_item.get_data.is_a?(IContributionItem))
          cb_item = cool_item.get_data
          displayed_items.add(Math.min(i, displayed_items.size), cb_item)
        end
        i += 1
      end
      # Add separators to the displayed Items data structure
      offset = 0
      i_ = 1
      while i_ < wrap_indicies.attr_length
        insert_at = wrap_indicies[i_] + offset
        displayed_items.add(insert_at, Separator.new(USER_SEPARATOR))
        offset += 1
        i_ += 1
      end
      # Determine which rows are invisible
      existing_visible_rows = ArrayList.new(4)
      row_iterator = contribution_list.list_iterator
      collapse_separators(row_iterator)
      num_row = 0
      while (row_iterator.has_next)
        # Scan row
        while (row_iterator.has_next)
          cb_item = row_iterator.next_
          if (displayed_items.contains(cb_item))
            existing_visible_rows.add(num_row)
            break
          end
          if (cb_item.is_separator)
            break
          end
        end
        next_row(row_iterator, false)
        num_row += 1
      end
      existing_rows = existing_visible_rows.iterator
      # Adjust row number to the first visible
      if (existing_rows.has_next)
        row = (existing_rows.next_).int_value
      end
      item_location = HashMap.new
      location_iterator = displayed_items.list_iterator
      while location_iterator.has_next
        item = location_iterator.next_
        if (item.is_separator)
          if (existing_rows.has_next)
            value = existing_rows.next_
            row = value.int_value
          else
            row += 1
          end
        else
          item_location.put(item, row)
        end
      end
      # Insert the contribution items in their correct location
      iterator_ = displayed_items.list_iterator
      while iterator_.has_next
        cb_item = iterator_.next_
        if (cb_item.is_separator)
          cool_item_index = 0
        else
          relocate(cb_item, cool_item_index, contribution_list, item_location)
          cb_item.save_widget_state
          cool_item_index += 1
        end
      end
      contribution_list = adjust_contribution_list(contribution_list)
      if (!(contribution_list.size).equal?(0))
        array = Array.typed(IContributionItem).new(contribution_list.size - 1) { nil }
        array = contribution_list.to_array(array)
        internal_set_items(array)
      end
    end
    
    typesig { [IContributionItem, ::Java::Int, ArrayList, HashMap] }
    # Relocates the given contribution item to the specified index.
    # 
    # @param cbItem
    # the conribution item to relocate
    # @param index
    # the index to locate this item
    # @param contributionList
    # the current list of conrtributions
    # @param itemLocation
    def relocate(cb_item, index, contribution_list, item_location)
      if (!(item_location.get(cb_item).is_a?(JavaInteger)))
        return
      end
      target_row = (item_location.get(cb_item)).int_value
      cb_internal_index = contribution_list.index_of(cb_item)
      # by default add to end of list
      insert_at = contribution_list.size
      # Find the row to place this item in.
      iterator_ = contribution_list.list_iterator
      # bypass any separators at the begining
      collapse_separators(iterator_)
      current_row = -1
      while (iterator_.has_next)
        current_row += 1
        if ((current_row).equal?(target_row))
          # We found the row to insert the item
          virtual_index = 0
          insert_at = iterator_.next_index
          # first check the position of the current element (item)
          # then get the next element
          while (iterator_.has_next)
            item = iterator_.next_
            item_row = item_location.get(item)
            if (item.is_separator)
              break
            end
            # if the item has an associate widget
            if ((!(item_row).nil?) && ((item_row.int_value).equal?(target_row)))
              # if the next element is the index we are looking for
              # then break
              if (virtual_index >= index)
                break
              end
              virtual_index += 1
            end
            insert_at += 1
          end
          # If we don't need to move it then we return
          if ((cb_internal_index).equal?(insert_at))
            return
          end
          break
        end
        next_row(iterator_, true)
      end
      contribution_list.remove(cb_item)
      # Adjust insertAt index
      if (cb_internal_index < insert_at)
        insert_at -= 1
      end
      # if we didn't find the row then add a new row
      if (!(current_row).equal?(target_row))
        contribution_list.add(Separator.new(USER_SEPARATOR))
        insert_at = contribution_list.size
      end
      insert_at = Math.min(insert_at, contribution_list.size)
      contribution_list.add(insert_at, cb_item)
    end
    
    typesig { [] }
    # Restores the canonical order of this cool bar manager. The canonical
    # order is the order in which the contribution items where added.
    def reset_item_order
      iterator_ = @cb_items_creation_order.list_iterator
      while iterator_.has_next
        item = iterator_.next_
        # if its a user separator then do not include in original order.
        if ((!(item.get_id).nil?) && ((item.get_id == USER_SEPARATOR)))
          iterator_.remove
        end
      end
      items_to_set = Array.typed(IContributionItem).new(@cb_items_creation_order.size) { nil }
      @cb_items_creation_order.to_array(items_to_set)
      set_items(items_to_set)
    end
    
    typesig { [IMenuManager] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.action.ICoolBarManager#setContextMenuManager(org.eclipse.jface.action.IMenuManager)
    def set_context_menu_manager(context_menu_manager)
      @context_menu_manager = context_menu_manager
      if (!(@cool_bar).nil?)
        @cool_bar.set_menu(get_context_menu_control)
      end
    end
    
    typesig { [Array.typed(IContributionItem)] }
    # Replaces the current items with the given items.
    # Forces an update.
    # 
    # @param newItems the items with which to replace the current items
    def set_items(new_items)
      # dispose of all the cool items on the cool bar manager
      if (!(@cool_bar).nil?)
        cool_items = @cool_bar.get_items
        i = 0
        while i < cool_items.attr_length
          dispose(cool_items[i])
          i += 1
        end
      end
      # Set the internal structure to this order
      internal_set_items(new_items)
      # Force and update
      update(true)
    end
    
    typesig { [::Java::Boolean] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.action.ICoolBarManager#lockLayout(boolean)
    def set_lock_layout(value)
      if (!cool_bar_exist)
        return
      end
      @cool_bar.set_locked(value)
    end
    
    typesig { [::Java::Boolean] }
    # Subclasses may extend this <code>IContributionManager</code> method,
    # but must call <code>super.update</code>.
    # 
    # @see org.eclipse.jface.action.IContributionManager#update(boolean)
    def update(force)
      if ((!is_dirty && !force) || (!cool_bar_exist))
        return
      end
      relock = false
      changed = false
      begin
        @cool_bar.set_redraw(false)
        # Refresh the widget data with the internal data structure.
        refresh
        if (@cool_bar.get_locked)
          @cool_bar.set_locked(false)
          relock = true
        end
        # Make a list of items including only those items that are
        # visible. Separators should stay because they mark line breaks in
        # a cool bar.
        items = get_items
        visible_items = ArrayList.new(items.attr_length)
        i = 0
        while i < items.attr_length
          item = items[i]
          if (is_child_visible(item))
            visible_items.add(item)
          end
          i += 1
        end
        # Make a list of CoolItem widgets in the cool bar for which there
        # is no current visible contribution item. These are the widgets
        # to be disposed. Dynamic items are also removed.
        cool_items = @cool_bar.get_items
        cool_items_to_remove = ArrayList.new(cool_items.attr_length)
        i_ = 0
        while i_ < cool_items.attr_length
          data = cool_items[i_].get_data
          if (((data).nil?) || (!visible_items.contains(data)) || ((data.is_a?(IContributionItem)) && (data).is_dynamic))
            cool_items_to_remove.add(cool_items[i_])
          end
          i_ += 1
        end
        # Dispose of any items in the list to be removed.
        i__ = cool_items_to_remove.size - 1
        while i__ >= 0
          cool_item = cool_items_to_remove.get(i__)
          if (!cool_item.is_disposed)
            control = cool_item.get_control
            if (!(control).nil?)
              cool_item.set_control(nil)
              control.dispose
            end
            cool_item.dispose
          end
          i__ -= 1
        end
        # Add any new items by telling them to fill.
        cool_items = @cool_bar.get_items
        source_item = nil
        destination_item = nil
        source_index = 0
        destination_index = 0
        visible_item_itr = visible_items.iterator
        while (visible_item_itr.has_next)
          source_item = visible_item_itr.next_
          # Retrieve the corresponding contribution item from SWT's
          # data.
          if (source_index < cool_items.attr_length)
            destination_item = cool_items[source_index].get_data
          else
            destination_item = nil
          end
          # The items match is they are equal or both separators.
          if (!(destination_item).nil?)
            if ((source_item == destination_item))
              source_index += 1
              destination_index += 1
              source_item.update
              next
            else
              if ((destination_item.is_separator) && (source_item.is_separator))
                cool_items[source_index].set_data(source_item)
                source_index += 1
                destination_index += 1
                source_item.update
                next
              end
            end
          end
          # Otherwise, a new item has to be added.
          start = @cool_bar.get_item_count
          if (source_item.is_a?(ToolBarContributionItem))
            manager = (source_item).get_tool_bar_manager
            if (manager.is_a?(IToolBarManager2))
              (manager).set_overrides(get_overrides)
            end
          end
          source_item.fill(@cool_bar, destination_index)
          new_items = @cool_bar.get_item_count - start
          i___ = 0
          while i___ < new_items
            @cool_bar.get_item(((destination_index += 1) - 1)).set_data(source_item)
            i___ += 1
          end
          changed = true
        end
        # Remove any old widgets not accounted for.
        i___ = cool_items.attr_length - 1
        while i___ >= source_index
          item = cool_items[i___]
          if (!item.is_disposed)
            control = item.get_control
            if (!(control).nil?)
              item.set_control(nil)
              control.dispose
            end
            item.dispose
            changed = true
          end
          i___ -= 1
        end
        # Update wrap indices.
        update_wrap_indices
        # Update the sizes.
        i____ = 0
        while i____ < items.attr_length
          item = items[i____]
          item.update(SIZE)
          i____ += 1
        end
        # if the coolBar was previously locked then lock it
        if (relock)
          @cool_bar.set_locked(true)
        end
        if (changed)
          update_tab_order
        end
        # We are no longer dirty.
        set_dirty(false)
      ensure
        @cool_bar.set_redraw(true)
      end
    end
    
    typesig { [] }
    # Sets the tab order of the coolbar to the visual order of its items.
    # 
    # package
    def update_tab_order
      if (!(@cool_bar).nil?)
        items = @cool_bar.get_items
        if (!(items).nil?)
          children = ArrayList.new(items.attr_length)
          i = 0
          while i < items.attr_length
            if ((!(items[i].get_control).nil?) && (!items[i].get_control.is_disposed))
              children.add(items[i].get_control)
            end
            i += 1
          end
          # Convert array
          children_array = Array.typed(Control).new(0) { nil }
          children_array = children.to_array(children_array)
          if (!(children_array).nil?)
            @cool_bar.set_tab_list(children_array)
          end
        end
      end
    end
    
    typesig { [] }
    # Updates the indices at which the cool bar should wrap.
    def update_wrap_indices
      items = get_items
      num_rows = get_num_rows(items) - 1
      # Generate the list of wrap indices.
      wrap_indices = Array.typed(::Java::Int).new(num_rows) { 0 }
      found_separator = false
      j = 0
      cool_items = ((@cool_bar).nil?) ? nil : @cool_bar.get_items
      i = 0
      while i < items.attr_length
        item = items[i]
        cool_item = find_cool_item(cool_items, item)
        if (item.is_separator)
          found_separator = true
        end
        if ((!item.is_separator) && (!item.is_group_marker) && (is_child_visible(item)) && (!(cool_item).nil?) && (found_separator))
          wrap_indices[j] = @cool_bar.index_of(cool_item)
          j += 1
          found_separator = false
        end
        i += 1
      end
      # Check to see if these new wrap indices are different than the old
      # ones.
      old_indices = @cool_bar.get_wrap_indices
      should_update = false
      if ((old_indices.attr_length).equal?(wrap_indices.attr_length))
        i_ = 0
        while i_ < old_indices.attr_length
          if (!(old_indices[i_]).equal?(wrap_indices[i_]))
            should_update = true
            break
          end
          i_ += 1
        end
      else
        should_update = true
      end
      if (should_update)
        @cool_bar.set_wrap_indices(wrap_indices)
      end
    end
    
    typesig { [IContributionItem] }
    def is_child_visible(item)
      v = nil
      overrides = get_overrides
      if ((overrides).nil?)
        v = nil
      else
        v = get_overrides.get_visible(item)
      end
      if (!(v).nil?)
        return v.boolean_value
      end
      return item.is_visible
    end
    
    private
    alias_method :initialize__cool_bar_manager, :initialize
  end
  
end
