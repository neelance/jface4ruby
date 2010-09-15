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
  module ContributionManagerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Action
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :JavaList
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Jface::Util, :Policy
    }
  end
  
  # Abstract base class for all contribution managers, and standard
  # implementation of <code>IContributionManager</code>. This class provides
  # functionality common across the specific managers defined by this framework.
  # <p>
  # This class maintains a list of contribution items and a dirty flag, both as
  # internal state. In addition to providing implementations of most
  # <code>IContributionManager</code> methods, this class automatically
  # coalesces adjacent separators, hides beginning and ending separators, and
  # deals with dynamically changing sets of contributions. When the set of
  # contributions does change dynamically, the changes are propagated to the
  # control via the <code>update</code> method, which subclasses must
  # implement.
  # </p>
  # <p>
  # Note: A <code>ContributionItem</code> cannot be shared between different
  # <code>ContributionManager</code>s.
  # </p>
  class ContributionManager 
    include_class_members ContributionManagerImports
    include IContributionManager
    
    # Internal debug flag.
    # protected static final boolean DEBUG = false;
    # 
    # The list of contribution items.
    attr_accessor :contributions
    alias_method :attr_contributions, :contributions
    undef_method :contributions
    alias_method :attr_contributions=, :contributions=
    undef_method :contributions=
    
    # Indicates whether the widgets are in sync with the contributions.
    attr_accessor :is_dirty
    alias_method :attr_is_dirty, :is_dirty
    undef_method :is_dirty
    alias_method :attr_is_dirty=, :is_dirty=
    undef_method :is_dirty=
    
    # Number of dynamic contribution items.
    attr_accessor :dynamic_items
    alias_method :attr_dynamic_items, :dynamic_items
    undef_method :dynamic_items
    alias_method :attr_dynamic_items=, :dynamic_items=
    undef_method :dynamic_items=
    
    # The overrides for items of this manager
    attr_accessor :overrides
    alias_method :attr_overrides, :overrides
    undef_method :overrides
    alias_method :attr_overrides=, :overrides=
    undef_method :overrides=
    
    typesig { [] }
    # Creates a new contribution manager.
    def initialize
      @contributions = ArrayList.new
      @is_dirty = true
      @dynamic_items = 0
      @overrides = nil
      # Do nothing.
    end
    
    typesig { [IAction] }
    # (non-Javadoc) Method declared on IContributionManager.
    def add(action)
      Assert.is_not_null(action, "Action must not be null") # $NON-NLS-1$
      add(ActionContributionItem.new(action))
    end
    
    typesig { [IContributionItem] }
    # (non-Javadoc) Method declared on IContributionManager.
    def add(item)
      Assert.is_not_null(item, "Item must not be null") # $NON-NLS-1$
      if (allow_item(item))
        @contributions.add(item)
        item_added(item)
      end
    end
    
    typesig { [String, IContributionItem, ::Java::Boolean] }
    # Adds a contribution item to the start or end of the group with the given
    # name.
    # 
    # @param groupName
    # the name of the group
    # @param item
    # the contribution item
    # @param append
    # <code>true</code> to add to the end of the group, and
    # <code>false</code> to add the beginning of the group
    # @exception IllegalArgumentException
    # if there is no group with the given name
    def add_to_group(group_name, item, append)
      i = 0
      items = @contributions.iterator
      i = 0
      while items.has_next
        o = items.next_
        if (o.is_group_marker)
          id = o.get_id
          if (!(id).nil? && id.equals_ignore_case(group_name))
            i += 1
            if (append)
              while items.has_next
                ci = items.next_
                if (ci.is_group_marker)
                  break
                end
                i += 1
              end
            end
            if (allow_item(item))
              @contributions.add(i, item)
              item_added(item)
            end
            return
          end
        end
        i += 1
      end
      raise IllegalArgumentException.new("Group not found: " + group_name) # $NON-NLS-1$
    end
    
    typesig { [String, IAction] }
    # (non-Javadoc) Method declared on IContributionManager.
    def append_to_group(group_name, action)
      add_to_group(group_name, ActionContributionItem.new(action), true)
    end
    
    typesig { [String, IContributionItem] }
    # (non-Javadoc) Method declared on IContributionManager.
    def append_to_group(group_name, item)
      add_to_group(group_name, item, true)
    end
    
    typesig { [IContributionItem] }
    # This method allows subclasses of <code>ContributionManager</code> to
    # prevent certain items in the contributions list.
    # <code>ContributionManager</code> will either block or allow an addition
    # based on the result of this method call. This can be used to prevent
    # duplication, for example.
    # 
    # @param itemToAdd
    # The contribution item to be added; may be <code>null</code>.
    # @return <code>true</code> if the addition should be allowed;
    # <code>false</code> otherwise. The default implementation allows
    # all items.
    # @since 3.0
    def allow_item(item_to_add)
      return true
    end
    
    typesig { [] }
    # Internal debug method for printing statistics about this manager to
    # <code>System.out</code>.
    def dump_statistics
      size = 0
      if (!(@contributions).nil?)
        size = @contributions.size
      end
      System.out.println(self.to_s)
      System.out.println("   Number of elements: " + RJava.cast_to_string(size)) # $NON-NLS-1$
      sum = 0
      i = 0
      while i < size
        if ((@contributions.get(i)).is_visible)
          sum += 1
        end
        i += 1
      end
      System.out.println("   Number of visible elements: " + RJava.cast_to_string(sum)) # $NON-NLS-1$
      System.out.println("   Is dirty: " + RJava.cast_to_string(is_dirty)) # $NON-NLS-1$
    end
    
    typesig { [String] }
    # (non-Javadoc) Method declared on IContributionManager.
    def find(id)
      e = @contributions.iterator
      while (e.has_next)
        item = e.next_
        item_id = item.get_id
        if (!(item_id).nil? && item_id.equals_ignore_case(id))
          return item
        end
      end
      return nil
    end
    
    typesig { [] }
    # (non-Javadoc) Method declared on IContributionManager.
    def get_items
      items = Array.typed(IContributionItem).new(@contributions.size) { nil }
      @contributions.to_array(items)
      return items
    end
    
    typesig { [] }
    # Return the number of contributions in this manager.
    # 
    # @return the number of contributions in this manager
    # @since 3.3
    def get_size
      return @contributions.size
    end
    
    typesig { [] }
    # The <code>ContributionManager</code> implementation of this method
    # declared on <code>IContributionManager</code> returns the current
    # overrides. If there is no overrides it lazily creates one which overrides
    # no item state.
    # 
    # @since 2.0
    def get_overrides
      if ((@overrides).nil?)
        @overrides = Class.new(IContributionManagerOverrides.class == Class ? IContributionManagerOverrides : Object) do
          local_class_in ContributionManager
          include_class_members ContributionManager
          include IContributionManagerOverrides if IContributionManagerOverrides.class == Module
          
          typesig { [IContributionItem] }
          define_method :get_enabled do |item|
            return nil
          end
          
          typesig { [IContributionItem] }
          define_method :get_accelerator do |item|
            return nil
          end
          
          typesig { [IContributionItem] }
          define_method :get_accelerator_text do |item|
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
      end
      return @overrides
    end
    
    typesig { [] }
    # Returns whether this contribution manager contains dynamic items. A
    # dynamic contribution item contributes items conditionally, dependent on
    # some internal state.
    # 
    # @return <code>true</code> if this manager contains dynamic items, and
    # <code>false</code> otherwise
    def has_dynamic_items
      return (@dynamic_items > 0)
    end
    
    typesig { [String] }
    # Returns the index of the item with the given id.
    # 
    # @param id
    # The id of the item whose index is requested.
    # 
    # @return <code>int</code> the index or -1 if the item is not found
    def index_of(id)
      i = 0
      while i < @contributions.size
        item = @contributions.get(i)
        item_id = item.get_id
        if (!(item_id).nil? && item_id.equals_ignore_case(id))
          return i
        end
        i += 1
      end
      return -1
    end
    
    typesig { [IContributionItem] }
    # Returns the index of the object in the internal structure. This is
    # different from <code>indexOf(String id)</code> since some contribution
    # items may not have an id.
    # 
    # @param item
    # The contribution item
    # @return the index, or -1 if the item is not found
    # @since 3.0
    def index_of(item)
      return @contributions.index_of(item)
    end
    
    typesig { [::Java::Int, IContributionItem] }
    # Insert the item at the given index.
    # 
    # @param index
    # The index to be used for insertion
    # @param item
    # The item to be inserted
    def insert(index, item)
      if (index > @contributions.size)
        raise IndexOutOfBoundsException.new("inserting " + RJava.cast_to_string(item.get_id) + " at " + RJava.cast_to_string(index)) # $NON-NLS-1$ //$NON-NLS-2$
      end
      if (allow_item(item))
        @contributions.add(index, item)
        item_added(item)
      end
    end
    
    typesig { [String, IAction] }
    # (non-Javadoc) Method declared on IContributionManager.
    def insert_after(id, action)
      insert_after(id, ActionContributionItem.new(action))
    end
    
    typesig { [String, IContributionItem] }
    # (non-Javadoc) Method declared on IContributionManager.
    def insert_after(id, item)
      ci = find(id)
      if ((ci).nil?)
        raise IllegalArgumentException.new("can't find ID" + id) # $NON-NLS-1$
      end
      ix = @contributions.index_of(ci)
      if (ix >= 0)
        # System.out.println("insert after: " + ix);
        if (allow_item(item))
          @contributions.add(ix + 1, item)
          item_added(item)
        end
      end
    end
    
    typesig { [String, IAction] }
    # (non-Javadoc) Method declared on IContributionManager.
    def insert_before(id, action)
      insert_before(id, ActionContributionItem.new(action))
    end
    
    typesig { [String, IContributionItem] }
    # (non-Javadoc) Method declared on IContributionManager.
    def insert_before(id, item)
      ci = find(id)
      if ((ci).nil?)
        raise IllegalArgumentException.new("can't find ID " + id) # $NON-NLS-1$
      end
      ix = @contributions.index_of(ci)
      if (ix >= 0)
        # System.out.println("insert before: " + ix);
        if (allow_item(item))
          @contributions.add(ix, item)
          item_added(item)
        end
      end
    end
    
    typesig { [] }
    # (non-Javadoc) Method declared on IContributionManager.
    def is_dirty
      if (@is_dirty)
        return true
      end
      if (has_dynamic_items)
        iter = @contributions.iterator
        while iter.has_next
          item = iter.next_
          if (item.is_dirty)
            return true
          end
        end
      end
      return false
    end
    
    typesig { [] }
    # (non-Javadoc) Method declared on IContributionManager.
    def is_empty
      return @contributions.is_empty
    end
    
    typesig { [IContributionItem] }
    # The given item was added to the list of contributions. Marks the manager
    # as dirty and updates the number of dynamic items, and the memento.
    # 
    # @param item
    # the item to be added
    def item_added(item)
      item.set_parent(self)
      mark_dirty
      if (item.is_dynamic)
        @dynamic_items += 1
      end
    end
    
    typesig { [IContributionItem] }
    # The given item was removed from the list of contributions. Marks the
    # manager as dirty and updates the number of dynamic items.
    # 
    # @param item
    # remove given parent from list of contributions
    def item_removed(item)
      item.set_parent(nil)
      mark_dirty
      if (item.is_dynamic)
        @dynamic_items -= 1
      end
    end
    
    typesig { [] }
    # (non-Javadoc) Method declared on IContributionManager.
    def mark_dirty
      set_dirty(true)
    end
    
    typesig { [String, IAction] }
    # (non-Javadoc) Method declared on IContributionManager.
    def prepend_to_group(group_name, action)
      add_to_group(group_name, ActionContributionItem.new(action), false)
    end
    
    typesig { [String, IContributionItem] }
    # (non-Javadoc) Method declared on IContributionManager.
    def prepend_to_group(group_name, item)
      add_to_group(group_name, item, false)
    end
    
    typesig { [String] }
    # (non-Javadoc) Method declared on IContributionManager.
    def remove(id)
      ci = find(id)
      if ((ci).nil?)
        return nil
      end
      return remove(ci)
    end
    
    typesig { [IContributionItem] }
    # (non-Javadoc) Method declared on IContributionManager.
    def remove(item)
      if (@contributions.remove(item))
        item_removed(item)
        return item
      end
      return nil
    end
    
    typesig { [] }
    # (non-Javadoc) Method declared on IContributionManager.
    def remove_all
      items = get_items
      @contributions.clear
      i = 0
      while i < items.attr_length
        item = items[i]
        item_removed(item)
        i += 1
      end
      @dynamic_items = 0
      mark_dirty
    end
    
    typesig { [String, IContributionItem] }
    # Replaces the item of the given identifier with another contribution item.
    # This can be used, for example, to replace large contribution items with
    # placeholders to avoid memory leaks. If the identifier cannot be found in
    # the current list of items, then this does nothing. If multiple
    # occurrences are found, then the replacement items is put in the first
    # position and the other positions are removed.
    # 
    # @param identifier
    # The identifier to look for in the list of contributions;
    # should not be <code>null</code>.
    # @param replacementItem
    # The contribution item to replace the old item; must not be
    # <code>null</code>. Use
    # {@link org.eclipse.jface.action.ContributionManager#remove(java.lang.String) remove}
    # if that is what you want to do.
    # @return <code>true</code> if the given identifier can be; <code>
    # @since 3.0
    def replace_item(identifier, replacement_item)
      if ((identifier).nil?)
        return false
      end
      index = index_of(identifier)
      if (index < 0)
        return false # couldn't find the item.
      end
      # Remove the old item.
      old_item = @contributions.get(index)
      item_removed(old_item)
      # Add the new item.
      @contributions.set(index, replacement_item)
      item_added(replacement_item) # throws NPE if (replacementItem == null)
      # Go through and remove duplicates.
      i = @contributions.size - 1
      while i > index
        item = @contributions.get(i)
        if ((!(item).nil?) && ((identifier == item.get_id)))
          if (Policy::TRACE_TOOLBAR)
            System.out.println("Removing duplicate on replace: " + identifier) # $NON-NLS-1$
          end
          @contributions.remove(i)
          item_removed(item)
        end
        i -= 1
      end
      return true # success
    end
    
    typesig { [::Java::Boolean] }
    # Sets whether this manager is dirty. When dirty, the list of contributions
    # is not accurately reflected in the corresponding widgets.
    # 
    # @param dirty
    # <code>true</code> if this manager is dirty, and
    # <code>false</code> if it is up-to-date
    def set_dirty(dirty)
      @is_dirty = dirty
    end
    
    typesig { [IContributionManagerOverrides] }
    # Sets the overrides for this contribution manager
    # 
    # @param newOverrides
    # the overrides for the items of this manager
    # @since 2.0
    def set_overrides(new_overrides)
      @overrides = new_overrides
    end
    
    typesig { [Array.typed(IContributionItem)] }
    # An internal method for setting the order of the contribution items.
    # 
    # @param items
    # the contribution items in the specified order
    # @since 3.0
    def internal_set_items(items)
      @contributions.clear
      i = 0
      while i < items.attr_length
        if (allow_item(items[i]))
          @contributions.add(items[i])
        end
        i += 1
      end
    end
    
    private
    alias_method :initialize__contribution_manager, :initialize
  end
  
end
