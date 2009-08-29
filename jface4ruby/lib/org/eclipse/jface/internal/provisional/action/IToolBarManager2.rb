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
  module IToolBarManager2Imports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Internal::Provisional::Action
      include_const ::Org::Eclipse::Jface::Action, :IContributionManagerOverrides
      include_const ::Org::Eclipse::Jface::Action, :IToolBarManager
      include_const ::Org::Eclipse::Jface::Util, :IPropertyChangeListener
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :ToolBar
    }
  end
  
  # The <code>IToolBarManager2</code> extends <code>IToolBarManager</code> to
  # allow clients to be isolated from the actual kind of SWT control used by the
  # manager.
  # <p>
  # <strong>EXPERIMENTAL</strong>. This class or interface has been added as
  # part of a work in progress. There is a guarantee neither that this API will
  # work nor that it will remain the same. Please do not use this API without
  # consulting with the Platform/UI team.
  # </p>
  # 
  # @since 3.2
  module IToolBarManager2
    include_class_members IToolBarManager2Imports
    include IToolBarManager
    
    class_module.module_eval {
      # The property id for changes to the control's layout
      const_set_lazy(:PROP_LAYOUT) { "PROP_LAYOUT" }
      const_attr_reader  :PROP_LAYOUT
    }
    
    typesig { [Composite] }
    # $NON-NLS-1$
    # 
    # Creates and returns this manager's toolbar control. Does not create a new
    # control if one already exists.
    # 
    # @param parent
    # the parent control
    # @return the toolbar control
    def create_control(parent)
      raise NotImplementedError
    end
    
    typesig { [Composite] }
    # Creates and returns this manager's control. Does not create a new control
    # if one already exists.
    # 
    # @param parent
    # the parent control
    # @return the control
    def create_control2(parent)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the toolbar control for this manager.
    # 
    # @return the toolbar control, or <code>null</code> if none
    def get_control
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the control for this manager.
    # 
    # @return the control, or <code>null</code> if none
    def get_control2
      raise NotImplementedError
    end
    
    typesig { [] }
    # Disposes the resources for this manager.
    def dispose
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the item count of the control used by this manager.
    # 
    # @return the number of items in the control
    def get_item_count
      raise NotImplementedError
    end
    
    typesig { [IPropertyChangeListener] }
    # Registers a property change listner with this manager.
    # 
    # @param listener
    def add_property_change_listener(listener)
      raise NotImplementedError
    end
    
    typesig { [IPropertyChangeListener] }
    # Removes a property change listner from this manager.
    # 
    # @param listener
    def remove_property_change_listener(listener)
      raise NotImplementedError
    end
    
    typesig { [IContributionManagerOverrides] }
    # Sets the overrides for this contribution manager
    # 
    # @param newOverrides
    # the overrides for the items of this manager
    def set_overrides(new_overrides)
      raise NotImplementedError
    end
  end
  
end
