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
  module SubContributionItemImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Action
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :CoolBar
      include_const ::Org::Eclipse::Swt::Widgets, :Menu
      include_const ::Org::Eclipse::Swt::Widgets, :ToolBar
    }
  end
  
  # A <code>SubContributionItem</code> is a wrapper for an <code>IContributionItem</code>.
  # It is used within a <code>SubContributionManager</code> to control the visibility
  # of items.
  # <p>
  # This class is not intended to be subclassed.
  # </p>
  # @noextend This class is not intended to be subclassed by clients.
  class SubContributionItem 
    include_class_members SubContributionItemImports
    include IContributionItem
    
    # The visibility of the item.
    attr_accessor :visible
    alias_method :attr_visible, :visible
    undef_method :visible
    alias_method :attr_visible=, :visible=
    undef_method :visible=
    
    # The inner item for this contribution.
    attr_accessor :inner_item
    alias_method :attr_inner_item, :inner_item
    undef_method :inner_item
    alias_method :attr_inner_item=, :inner_item=
    undef_method :inner_item=
    
    typesig { [IContributionItem] }
    # Creates a new <code>SubContributionItem</code>.
    # @param item the contribution item to be wrapped
    def initialize(item)
      @visible = false
      @inner_item = nil
      @inner_item = item
    end
    
    typesig { [] }
    # The default implementation of this <code>IContributionItem</code>
    # delegates to the inner item. Subclasses may override.
    def dispose
      @inner_item.dispose
    end
    
    typesig { [Composite] }
    # (non-Javadoc)
    # Method declared on IContributionItem.
    def fill(parent)
      if (@visible)
        @inner_item.fill(parent)
      end
    end
    
    typesig { [Menu, ::Java::Int] }
    # (non-Javadoc)
    # Method declared on IContributionItem.
    def fill(parent, index)
      if (@visible)
        @inner_item.fill(parent, index)
      end
    end
    
    typesig { [ToolBar, ::Java::Int] }
    # (non-Javadoc)
    # Method declared on IContributionItem.
    def fill(parent, index)
      if (@visible)
        @inner_item.fill(parent, index)
      end
    end
    
    typesig { [] }
    # (non-Javadoc)
    # Method declared on IContributionItem.
    def get_id
      return @inner_item.get_id
    end
    
    typesig { [] }
    # Returns the inner contribution item.
    # 
    # @return the inner contribution item
    def get_inner_item
      return @inner_item
    end
    
    typesig { [] }
    # (non-Javadoc)
    # Method declared on IContributionItem.
    def is_enabled
      return @inner_item.is_enabled
    end
    
    typesig { [] }
    # (non-Javadoc)
    # Method declared on IContributionItem.
    def is_dirty
      return @inner_item.is_dirty
    end
    
    typesig { [] }
    # (non-Javadoc)
    # Method declared on IContributionItem.
    def is_dynamic
      return @inner_item.is_dynamic
    end
    
    typesig { [] }
    # (non-Javadoc)
    # Method declared on IContributionItem.
    def is_group_marker
      return @inner_item.is_group_marker
    end
    
    typesig { [] }
    # (non-Javadoc)
    # Method declared on IContributionItem.
    def is_separator
      return @inner_item.is_separator
    end
    
    typesig { [] }
    # (non-Javadoc)
    # Method declared on IContributionItem.
    def is_visible
      return @visible && @inner_item.is_visible
    end
    
    typesig { [IContributionManager] }
    # (non-Javadoc)
    # Method declared on IContributionItem.
    def set_parent(parent)
      # do nothing, the parent of our inner item
      # is its SubContributionManager
    end
    
    typesig { [::Java::Boolean] }
    # (non-Javadoc)
    # Method declared on IContributionItem.
    def set_visible(visible)
      @visible = visible
    end
    
    typesig { [] }
    # (non-Javadoc)
    # Method declared on IContributionItem.
    def update
      @inner_item.update
    end
    
    typesig { [String] }
    # (non-Javadoc)
    # Method declared on IContributionItem.
    def update(id)
      @inner_item.update(id)
    end
    
    typesig { [CoolBar, ::Java::Int] }
    # (non-Javadoc)
    # @see org.eclipse.jface.action.IContributionItem#fill(org.eclipse.swt.widgets.CoolBar, int)
    def fill(parent, index)
      if (@visible)
        @inner_item.fill(parent, index)
      end
    end
    
    typesig { [] }
    # (non-Javadoc)
    # @see org.eclipse.jface.action.IContributionItem#saveWidgetState()
    def save_widget_state
    end
    
    private
    alias_method :initialize__sub_contribution_item, :initialize
  end
  
end
