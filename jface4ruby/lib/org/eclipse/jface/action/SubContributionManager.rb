require "rjava"

# Copyright (c) 2000, 2009 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Action
  module SubContributionManagerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Action
      include_const ::Java::Util, :Enumeration
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :Map
    }
  end
  
  # A <code>SubContributionManager</code> is used to define a set of contribution
  # items within a parent manager.  Once defined, the visibility of the entire set can
  # be changed as a unit.
  class SubContributionManager 
    include_class_members SubContributionManagerImports
    include IContributionManager
    
    # The parent contribution manager.
    attr_accessor :parent_mgr
    alias_method :attr_parent_mgr, :parent_mgr
    undef_method :parent_mgr
    alias_method :attr_parent_mgr=, :parent_mgr=
    undef_method :parent_mgr=
    
    # Maps each item in the manager to a wrapper.  The wrapper is used to
    # control the visibility of each item.
    attr_accessor :map_item_to_wrapper
    alias_method :attr_map_item_to_wrapper, :map_item_to_wrapper
    undef_method :map_item_to_wrapper
    alias_method :attr_map_item_to_wrapper=, :map_item_to_wrapper=
    undef_method :map_item_to_wrapper=
    
    # The visibility of the manager,
    attr_accessor :visible
    alias_method :attr_visible, :visible
    undef_method :visible
    alias_method :attr_visible=, :visible=
    undef_method :visible=
    
    typesig { [IContributionManager] }
    # Constructs a new <code>SubContributionManager</code>
    # 
    # @param mgr the parent contribution manager.  All contributions made to the
    # <code>SubContributionManager</code> are forwarded and appear in the
    # parent manager.
    def initialize(mgr)
      @parent_mgr = nil
      @map_item_to_wrapper = HashMap.new
      @visible = false
      @parent_mgr = mgr
    end
    
    typesig { [IAction] }
    # (non-Javadoc)
    # Method declared on IContributionManager.
    def add(action)
      add(ActionContributionItem.new(action))
    end
    
    typesig { [IContributionItem] }
    # (non-Javadoc)
    # Method declared on IContributionManager.
    def add(item)
      wrap_ = wrap(item)
      wrap_.set_visible(@visible)
      @parent_mgr.add(wrap_)
      item_added(item, wrap_)
    end
    
    typesig { [String, IAction] }
    # (non-Javadoc)
    # Method declared on IContributionManager.
    def append_to_group(group_name, action)
      append_to_group(group_name, ActionContributionItem.new(action))
    end
    
    typesig { [String, IContributionItem] }
    # (non-Javadoc)
    # Method declared on IContributionManager.
    def append_to_group(group_name, item)
      wrap_ = wrap(item)
      wrap_.set_visible(@visible)
      @parent_mgr.append_to_group(group_name, wrap_)
      item_added(item, wrap_)
    end
    
    typesig { [] }
    # Disposes this sub contribution manager, removing all its items
    # and cleaning up any other resources allocated by it.
    # This must leave no trace of this sub contribution manager
    # in the parent manager.  Subclasses may extend.
    # 
    # @since 3.0
    def dispose_manager
      it = @map_item_to_wrapper.values.iterator
      # Dispose items in addition to removing them.
      # See bugs 64024 and 73715 for details.
      # Do not use getItems() here as subclasses can override that in bad ways.
      while (it.has_next)
        item = it.next_
        item.dispose
      end
      remove_all
    end
    
    typesig { [String] }
    # (non-Javadoc)
    # Method declared on IContributionManager.
    # 
    # Returns the item passed to us, not the wrapper.
    def find(id)
      item = @parent_mgr.find(id)
      # Return the item passed to us, not the wrapper.
      item = unwrap(item)
      return item
    end
    
    typesig { [] }
    # (non-Javadoc)
    # Method declared on IContributionManager.
    # 
    # Returns the items passed to us, not the wrappers.
    def get_items
      result = Array.typed(IContributionItem).new(@map_item_to_wrapper.size) { nil }
      @map_item_to_wrapper.key_set.to_array(result)
      return result
    end
    
    typesig { [] }
    # Returns the parent manager.
    # 
    # @return the parent manager
    def get_parent
      return @parent_mgr
    end
    
    typesig { [] }
    # (non-Javadoc)
    # Method declared on IContributionManager.
    def get_overrides
      return @parent_mgr.get_overrides
    end
    
    typesig { [String, IAction] }
    # (non-Javadoc)
    # Method declared on IContributionManager.
    def insert_after(id, action)
      insert_after(id, ActionContributionItem.new(action))
    end
    
    typesig { [String, IContributionItem] }
    # (non-Javadoc)
    # Method declared on IContributionManager.
    def insert_after(id, item)
      wrap_ = wrap(item)
      wrap_.set_visible(@visible)
      @parent_mgr.insert_after(id, wrap_)
      item_added(item, wrap_)
    end
    
    typesig { [String, IAction] }
    # (non-Javadoc)
    # Method declared on IContributionManager.
    def insert_before(id, action)
      insert_before(id, ActionContributionItem.new(action))
    end
    
    typesig { [String, IContributionItem] }
    # (non-Javadoc)
    # Method declared on IContributionManager.
    def insert_before(id, item)
      wrap_ = wrap(item)
      wrap_.set_visible(@visible)
      @parent_mgr.insert_before(id, wrap_)
      item_added(item, wrap_)
    end
    
    typesig { [] }
    # (non-Javadoc)
    # Method declared on IContributionManager.
    def is_dirty
      return @parent_mgr.is_dirty
    end
    
    typesig { [] }
    # (non-Javadoc)
    # Method declared on IContributionManager.
    def is_empty
      return @parent_mgr.is_empty
    end
    
    typesig { [] }
    # Returns whether the contribution list is visible.
    # If the visibility is <code>true</code> then each item within the manager
    # appears within the parent manager.  Otherwise, the items are not visible.
    # 
    # @return <code>true</code> if the manager is visible
    def is_visible
      return @visible
    end
    
    typesig { [IContributionItem, SubContributionItem] }
    # Notifies that an item has been added.
    # <p>
    # Subclasses are not expected to override this method.
    # </p>
    # 
    # @param item the item contributed by the client
    # @param wrap the item contributed to the parent manager as a proxy for the item
    # contributed by the client
    def item_added(item, wrap_)
      item.set_parent(self)
      @map_item_to_wrapper.put(item, wrap_)
    end
    
    typesig { [IContributionItem] }
    # Notifies that an item has been removed.
    # <p>
    # Subclasses are not expected to override this method.
    # </p>
    # 
    # @param item the item contributed by the client
    def item_removed(item)
      @map_item_to_wrapper.remove(item)
      item.set_parent(nil)
    end
    
    typesig { [] }
    # @return fetch all enumeration of wrappers for the item
    # @deprecated Use getItems(String value) instead.
    def items
      i = @map_item_to_wrapper.values.iterator
      return Class.new(Enumeration.class == Class ? Enumeration : Object) do
        extend LocalClass
        include_class_members SubContributionManager
        include Enumeration if Enumeration.class == Module
        
        typesig { [] }
        define_method :has_more_elements do
          return i.has_next
        end
        
        typesig { [] }
        define_method :next_element do
          return i.next_
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
    end
    
    typesig { [] }
    # (non-Javadoc)
    # Method declared on IContributionManager.
    def mark_dirty
      @parent_mgr.mark_dirty
    end
    
    typesig { [String, IAction] }
    # (non-Javadoc)
    # Method declared on IContributionManager.
    def prepend_to_group(group_name, action)
      prepend_to_group(group_name, ActionContributionItem.new(action))
    end
    
    typesig { [String, IContributionItem] }
    # (non-Javadoc)
    # Method declared on IContributionManager.
    def prepend_to_group(group_name, item)
      wrap_ = wrap(item)
      wrap_.set_visible(@visible)
      @parent_mgr.prepend_to_group(group_name, wrap_)
      item_added(item, wrap_)
    end
    
    typesig { [String] }
    # (non-Javadoc)
    # Method declared on IContributionManager.
    def remove(id)
      result = @parent_mgr.remove(id)
      # result is the wrapped item
      if (!(result).nil?)
        item = unwrap(result)
        item_removed(item)
      end
      return result
    end
    
    typesig { [IContributionItem] }
    # (non-Javadoc)
    # Method declared on IContributionManager.
    def remove(item)
      wrap_ = @map_item_to_wrapper.get(item)
      if ((wrap_).nil?)
        return nil
      end
      result = @parent_mgr.remove(wrap_)
      if ((result).nil?)
        return nil
      end
      item_removed(item)
      return item
    end
    
    typesig { [] }
    # (non-Javadoc)
    # Method declared on IContributionManager.
    def remove_all
      array = @map_item_to_wrapper.key_set.to_array
      i = 0
      while i < array.attr_length
        item = array[i]
        remove(item)
        i += 1
      end
      @map_item_to_wrapper.clear
    end
    
    typesig { [::Java::Boolean] }
    # Sets the visibility of the manager.  If the visibility is <code>true</code>
    # then each item within the manager appears within the parent manager.
    # Otherwise, the items are not visible.
    # 
    # @param visible the new visibility
    def set_visible(visible)
      @visible = visible
      if (@map_item_to_wrapper.size > 0)
        it = @map_item_to_wrapper.values.iterator
        while (it.has_next)
          item = it.next_
          item.set_visible(visible)
        end
        @parent_mgr.mark_dirty
      end
    end
    
    typesig { [IContributionItem] }
    # Wraps a contribution item in a sub contribution item, and returns the new wrapper.
    # @param item the contribution item to be wrapped
    # @return the wrapped item
    def wrap(item)
      return SubContributionItem.new(item)
    end
    
    typesig { [IContributionItem] }
    # Unwraps a nested contribution item. If the contribution item is an
    # instance of <code>SubContributionItem</code>, then its inner item is
    # returned. Otherwise, the item itself is returned.
    # 
    # @param item
    # The item to unwrap; may be <code>null</code>.
    # @return The inner item of <code>item</code>, if <code>item</code> is
    # a <code>SubContributionItem</code>;<code>item</code>
    # otherwise.
    def unwrap(item)
      if (item.is_a?(SubContributionItem))
        return (item).get_inner_item
      end
      return item
    end
    
    private
    alias_method :initialize__sub_contribution_manager, :initialize
  end
  
end
