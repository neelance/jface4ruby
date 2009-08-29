require "rjava"

# Copyright (c) 2006, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Internal::Provisional::Action
  module ICoolBarManager2Imports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Internal::Provisional::Action
      include_const ::Org::Eclipse::Jface::Action, :IContributionItem
      include_const ::Org::Eclipse::Jface::Action, :IContributionManagerOverrides
      include_const ::Org::Eclipse::Jface::Action, :ICoolBarManager
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Control
    }
  end
  
  # Extends <code>ICoolBarManager</code> to allow clients to be decoupled
  # from the actual kind of control used.
  # 
  # <p>
  # <strong>EXPERIMENTAL</strong>. This class or interface has been added as
  # part of a work in progress. There is a guarantee neither that this API will
  # work nor that it will remain the same. Please do not use this API without
  # consulting with the Platform/UI team.
  # </p>
  # 
  # @since 3.2
  module ICoolBarManager2
    include_class_members ICoolBarManager2Imports
    include ICoolBarManager
    
    typesig { [Composite] }
    # Creates and returns this manager's control. Does not create a
    # new control if one already exists.
    # 
    # 
    # @param parent
    # the parent control
    # @return the control
    # @since 3.2
    def create_control2(parent)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the bar control for this manager.
    # 
    # <p>
    # <strong>EXPERIMENTAL</strong>. This class or interface has been added as
    # part of a work in progress. There is a guarantee neither that this API will
    # work nor that it will remain the same. Please do not use this API without
    # consulting with the Platform/UI team.
    # </p>
    # 
    # @return the bar control, or <code>null</code> if none
    # @since 3.2
    def get_control2
      raise NotImplementedError
    end
    
    typesig { [] }
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
    # 
    # <p>
    # <strong>EXPERIMENTAL</strong>. This class or interface has been added as
    # part of a work in progress. There is a guarantee neither that this API will
    # work nor that it will remain the same. Please do not use this API without
    # consulting with the Platform/UI team.
    # </p>
    # 
    # @since 3.2
    def refresh
      raise NotImplementedError
    end
    
    typesig { [] }
    # Disposes the resources for this manager.
    # 
    # <p>
    # <strong>EXPERIMENTAL</strong>. This class or interface has been added as
    # part of a work in progress. There is a guarantee neither that this API will
    # work nor that it will remain the same. Please do not use this API without
    # consulting with the Platform/UI team.
    # </p>
    # 
    # @since 3.2
    def dispose
      raise NotImplementedError
    end
    
    typesig { [] }
    # Restores the canonical order of this cool bar manager. The canonical
    # order is the order in which the contribution items where added.
    # 
    # <p>
    # <strong>EXPERIMENTAL</strong>. This class or interface has been added as
    # part of a work in progress. There is a guarantee neither that this API will
    # work nor that it will remain the same. Please do not use this API without
    # consulting with the Platform/UI team.
    # </p>
    # 
    # @since 3.2
    def reset_item_order
      raise NotImplementedError
    end
    
    typesig { [Array.typed(IContributionItem)] }
    # Replaces the current items with the given items.
    # Forces an update.
    # 
    # <p>
    # <strong>EXPERIMENTAL</strong>. This class or interface has been added as
    # part of a work in progress. There is a guarantee neither that this API will
    # work nor that it will remain the same. Please do not use this API without
    # consulting with the Platform/UI team.
    # </p>
    # 
    # @param newItems the items with which to replace the current items
    # @since 3.2
    def set_items(new_items)
      raise NotImplementedError
    end
    
    typesig { [IContributionManagerOverrides] }
    # Sets the overrides for this contribution manager
    # 
    # @param newOverrides
    # the overrides for the items of this manager
    # @since 3.5
    def set_overrides(new_overrides)
      raise NotImplementedError
    end
  end
  
end
