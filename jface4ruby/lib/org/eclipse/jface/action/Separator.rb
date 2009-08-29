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
  module SeparatorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Action
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Widgets, :Menu
      include_const ::Org::Eclipse::Swt::Widgets, :MenuItem
      include_const ::Org::Eclipse::Swt::Widgets, :ToolBar
      include_const ::Org::Eclipse::Swt::Widgets, :ToolItem
    }
  end
  
  # A separator is a special kind of contribution item which acts
  # as a visual separator and, optionally, acts as a group marker.
  # Unlike group markers, separators do have a visual representation for
  # menus and toolbars.
  # <p>
  # This class may be instantiated; it is not intended to be
  # subclassed outside the framework.
  # </p>
  # @noextend This class is not intended to be subclassed by clients.
  class Separator < SeparatorImports.const_get :AbstractGroupMarker
    include_class_members SeparatorImports
    
    typesig { [] }
    # Creates a separator which does not start a new group.
    def initialize
      super()
    end
    
    typesig { [String] }
    # Creates a new separator which also defines a new group having the given group name.
    # The group name must not be <code>null</code> or the empty string.
    # The group name is also used as the item id.
    # 
    # @param groupName the group name of the separator
    def initialize(group_name)
      super(group_name)
    end
    
    typesig { [Menu, ::Java::Int] }
    # (non-Javadoc)
    # Method declared on IContributionItem.
    # Fills the given menu with a SWT separator MenuItem.
    def fill(menu, index)
      if (index >= 0)
        MenuItem.new(menu, SWT::SEPARATOR, index)
      else
        MenuItem.new(menu, SWT::SEPARATOR)
      end
    end
    
    typesig { [ToolBar, ::Java::Int] }
    # (non-Javadoc)
    # Method declared on IContributionItem.
    # Fills the given tool bar with a SWT separator ToolItem.
    def fill(toolbar, index)
      if (index >= 0)
        ToolItem.new(toolbar, SWT::SEPARATOR, index)
      else
        ToolItem.new(toolbar, SWT::SEPARATOR)
      end
    end
    
    typesig { [] }
    # The <code>Separator</code> implementation of this <code>IContributionItem</code>
    # method returns <code>true</code>
    def is_separator
      return true
    end
    
    private
    alias_method :initialize__separator, :initialize
  end
  
end
