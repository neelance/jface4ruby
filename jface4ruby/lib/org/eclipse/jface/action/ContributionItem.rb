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
  module ContributionItemImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Action
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :CoolBar
      include_const ::Org::Eclipse::Swt::Widgets, :Menu
      include_const ::Org::Eclipse::Swt::Widgets, :ToolBar
    }
  end
  
  # An abstract base implementation for contribution items.
  class ContributionItem 
    include_class_members ContributionItemImports
    include IContributionItem
    
    # The identifier for this contribution item, of <code>null</code> if none.
    attr_accessor :id
    alias_method :attr_id, :id
    undef_method :id
    alias_method :attr_id=, :id=
    undef_method :id=
    
    # Indicates this item is visible in its manager; <code>true</code>
    # by default.
    attr_accessor :visible
    alias_method :attr_visible, :visible
    undef_method :visible
    alias_method :attr_visible=, :visible=
    undef_method :visible=
    
    # The parent contribution manager for this item
    attr_accessor :parent
    alias_method :attr_parent, :parent
    undef_method :parent
    alias_method :attr_parent=, :parent=
    undef_method :parent=
    
    typesig { [] }
    # Creates a contribution item with a <code>null</code> id.
    # Calls <code>this(String)</code> with <code>null</code>.
    def initialize
      initialize__contribution_item(nil)
    end
    
    typesig { [String] }
    # Creates a contribution item with the given (optional) id.
    # The given id is used to find items in a contribution manager,
    # and for positioning items relative to other items.
    # 
    # @param id the contribution item identifier, or <code>null</code>
    def initialize(id)
      @id = nil
      @visible = true
      @parent = nil
      @id = id
    end
    
    typesig { [] }
    # The default implementation of this <code>IContributionItem</code>
    # method does nothing. Subclasses may override.
    def dispose
    end
    
    typesig { [Composite] }
    # The default implementation of this <code>IContributionItem</code>
    # method does nothing. Subclasses may override.
    def fill(parent)
    end
    
    typesig { [Menu, ::Java::Int] }
    # The default implementation of this <code>IContributionItem</code>
    # method does nothing. Subclasses may override.
    def fill(menu, index)
    end
    
    typesig { [ToolBar, ::Java::Int] }
    # The default implementation of this <code>IContributionItem</code>
    # method does nothing. Subclasses may override.
    def fill(parent, index)
    end
    
    typesig { [CoolBar, ::Java::Int] }
    # The default implementation of this <code>IContributionItem</code>
    # method does nothing. Subclasses may override.
    # 
    # @since 3.0
    def fill(parent, index)
    end
    
    typesig { [] }
    # The default implementation of this <code>IContributionItem</code>
    # method does nothing. Subclasses may override.
    # 
    # @since 3.0
    def save_widget_state
    end
    
    typesig { [] }
    # (non-Javadoc)
    # Method declared on IContributionItem.
    def get_id
      return @id
    end
    
    typesig { [] }
    # Returns the parent contribution manager, or <code>null</code> if this
    # contribution item is not currently added to a contribution manager.
    # 
    # @return the parent contribution manager, or <code>null</code>
    # @since 2.0
    def get_parent
      return @parent
    end
    
    typesig { [] }
    # The default implementation of this <code>IContributionItem</code>
    # method returns <code>false</code>. Subclasses may override.
    def is_dirty
      # @issue should this be false instead of calling isDynamic()?
      return is_dynamic
    end
    
    typesig { [] }
    # The default implementation of this <code>IContributionItem</code>
    # method returns <code>true</code>. Subclasses may override.
    def is_enabled
      return true
    end
    
    typesig { [] }
    # The default implementation of this <code>IContributionItem</code>
    # method returns <code>false</code>. Subclasses may override.
    def is_dynamic
      return false
    end
    
    typesig { [] }
    # The default implementation of this <code>IContributionItem</code>
    # method returns <code>false</code>. Subclasses may override.
    def is_group_marker
      return false
    end
    
    typesig { [] }
    # The default implementation of this <code>IContributionItem</code>
    # method returns <code>false</code>. Subclasses may override.
    def is_separator
      return false
    end
    
    typesig { [] }
    # The default implementation of this <code>IContributionItem</code>
    # method returns the value recorded in an internal state variable,
    # which is <code>true</code> by default. <code>setVisible</code>
    # should be used to change this setting.
    def is_visible
      return @visible
    end
    
    typesig { [::Java::Boolean] }
    # The default implementation of this <code>IContributionItem</code>
    # method stores the value in an internal state variable,
    # which is <code>true</code> by default.
    def set_visible(visible)
      @visible = visible
    end
    
    typesig { [] }
    # Returns a string representation of this contribution item
    # suitable only for debugging.
    def to_s
      return RJava.cast_to_string(get_class.get_name) + "(id=" + RJava.cast_to_string(get_id) + ")" # $NON-NLS-2$//$NON-NLS-1$
    end
    
    typesig { [] }
    # The default implementation of this <code>IContributionItem</code>
    # method does nothing. Subclasses may override.
    def update
    end
    
    typesig { [IContributionManager] }
    # (non-Javadoc)
    # Method declared on IContributionItem.
    def set_parent(parent)
      @parent = parent
    end
    
    typesig { [String] }
    # The <code>ContributionItem</code> implementation of this
    # method declared on <code>IContributionItem</code> does nothing.
    # Subclasses should override to update their state.
    def update(id)
    end
    
    typesig { [String] }
    # The ID for this contribution item. It should be set once either in the
    # constructor or using this method.
    # 
    # @param itemId
    # @since 3.4
    # @see #getId()
    def set_id(item_id)
      @id = item_id
    end
    
    private
    alias_method :initialize__contribution_item, :initialize
  end
  
end
