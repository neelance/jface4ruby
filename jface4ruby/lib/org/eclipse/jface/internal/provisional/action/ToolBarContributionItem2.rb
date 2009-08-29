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
  module ToolBarContributionItem2Imports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Internal::Provisional::Action
      include_const ::Org::Eclipse::Jface::Action, :IToolBarManager
      include_const ::Org::Eclipse::Jface::Action, :ToolBarContributionItem
    }
  end
  
  # Extends <code>ToolBarContributionItem</code> to implement <code>IToolBarContributionItem</code>.
  # 
  # <p>
  # <strong>EXPERIMENTAL</strong>. This class or interface has been added as
  # part of a work in progress. There is a guarantee neither that this API will
  # work nor that it will remain the same. Please do not use this API without
  # consulting with the Platform/UI team.
  # </p>
  # 
  # @since 3.2
  class ToolBarContributionItem2 < ToolBarContributionItem2Imports.const_get :ToolBarContributionItem
    include_class_members ToolBarContributionItem2Imports
    overload_protected {
      include IToolBarContributionItem
    }
    
    typesig { [] }
    def initialize
      super()
    end
    
    typesig { [IToolBarManager] }
    # @param toolBarManager
    def initialize(tool_bar_manager)
      super(tool_bar_manager)
    end
    
    typesig { [IToolBarManager, String] }
    # @param toolBarManager
    # @param id
    def initialize(tool_bar_manager, id)
      super(tool_bar_manager, id)
    end
    
    private
    alias_method :initialize__tool_bar_contribution_item2, :initialize
  end
  
end
