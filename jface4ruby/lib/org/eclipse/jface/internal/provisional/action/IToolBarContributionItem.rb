require "rjava"

# Copyright (c) 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Internal::Provisional::Action
  module IToolBarContributionItemImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Internal::Provisional::Action
      include_const ::Org::Eclipse::Jface::Action, :IContributionItem
      include_const ::Org::Eclipse::Jface::Action, :IContributionManager
      include_const ::Org::Eclipse::Jface::Action, :IToolBarManager
    }
  end
  
  # The intention of this interface is to provide in interface for
  # ToolBarContributionItem so that the implementation can be replaced.
  # 
  # <p>
  # <strong>EXPERIMENTAL</strong>. This class or interface has been added as
  # part of a work in progress. There is a guarantee neither that this API will
  # work nor that it will remain the same. Please do not use this API without
  # consulting with the Platform/UI team.
  # </p>
  # 
  # @since 3.2
  module IToolBarContributionItem
    include_class_members IToolBarContributionItemImports
    include IContributionItem
    
    typesig { [] }
    # Returns the current height of the corresponding cool item.
    # 
    # @return the current height
    def get_current_height
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the current width of the corresponding cool item.
    # 
    # @return the current size
    def get_current_width
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the minimum number of tool items to show in the cool item.
    # 
    # @return the minimum number of tool items to show, or <code>SHOW_ALL_ITEMS</code>
    # if a value was not set
    # @see #setMinimumItemsToShow(int)
    def get_minimum_items_to_show
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns whether chevron support is enabled.
    # 
    # @return <code>true</code> if chevron support is enabled, <code>false</code>
    # otherwise
    def get_use_chevron
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    # Sets the current height of the cool item. Update(SIZE) should be called
    # to adjust the widget.
    # 
    # @param currentHeight
    # the current height to set
    def set_current_height(current_height)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    # Sets the current width of the cool item. Update(SIZE) should be called
    # to adjust the widget.
    # 
    # @param currentWidth
    # the current width to set
    def set_current_width(current_width)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    # Sets the minimum number of tool items to show in the cool item. If this
    # number is less than the total tool items, a chevron will appear and the
    # hidden tool items appear in a drop down menu. By default, all the tool
    # items are shown in the cool item.
    # 
    # @param minimumItemsToShow
    # the minimum number of tool items to show.
    # @see #getMinimumItemsToShow()
    # @see #setUseChevron(boolean)
    def set_minimum_items_to_show(minimum_items_to_show)
      raise NotImplementedError
    end
    
    typesig { [::Java::Boolean] }
    # Enables or disables chevron support for the cool item. By default,
    # chevron support is enabled.
    # 
    # @param value
    # <code>true</code> to enable chevron support, <code>false</code>
    # otherwise.
    def set_use_chevron(value)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the internal tool bar manager of the contribution item.
    # 
    # @return the tool bar manager, or <code>null</code> if one is not
    # defined.
    # @see IToolBarManager
    def get_tool_bar_manager
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the parent contribution manager, or <code>null</code> if this
    # contribution item is not currently added to a contribution manager.
    # 
    # @return the parent contribution manager, or <code>null</code>
    # 
    # TODO may not need this, getToolBarManager may be enough.
    def get_parent
      raise NotImplementedError
    end
  end
  
end
