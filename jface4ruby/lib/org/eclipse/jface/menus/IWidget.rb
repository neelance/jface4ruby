require "rjava"

# Copyright (c) 2005, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Menus
  module IWidgetImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Menus
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :CoolBar
      include_const ::Org::Eclipse::Swt::Widgets, :Menu
      include_const ::Org::Eclipse::Swt::Widgets, :ToolBar
    }
  end
  
  # <p>
  # Provides a hook by which third-party code can contribute SWT widgets to a
  # menu, tool bar or status line. This can be used, for example, to add a combo
  # box to the status line, or a "Location" bar to the tool bar.
  # </p>
  # <p>
  # It is possible for fill and dispose to be called multiple times for a single
  # instance of <code>IWidget</code>.
  # </p>
  # <p>
  # Clients may implement, but must not extend.
  # </p>
  # 
  # @since 3.2
  module IWidget
    include_class_members IWidgetImports
    
    typesig { [] }
    # Disposes of the underlying widgets. This can be called when the widget is
    # becoming hidden.
    def dispose
      raise NotImplementedError
    end
    
    typesig { [Composite] }
    # Fills the given composite control with controls representing this widget.
    # 
    # @param parent
    # the parent control
    def fill(parent)
      raise NotImplementedError
    end
    
    typesig { [Menu, ::Java::Int] }
    # Fills the given menu with controls representing this widget.
    # 
    # @param parent
    # the parent menu
    # @param index
    # the index where the controls are inserted, or <code>-1</code>
    # to insert at the end
    def fill(parent, index)
      raise NotImplementedError
    end
    
    typesig { [ToolBar, ::Java::Int] }
    # Fills the given tool bar with controls representing this contribution
    # item.
    # 
    # @param parent
    # the parent tool bar
    # @param index
    # the index where the controls are inserted, or <code>-1</code>
    # to insert at the end
    def fill(parent, index)
      raise NotImplementedError
    end
    
    typesig { [CoolBar, ::Java::Int] }
    # Fills the given cool bar with controls representing this contribution
    # item.
    # 
    # @param parent
    # the parent cool bar
    # @param index
    # the index where the controls are inserted, or <code>-1</code>
    # to insert at the end
    def fill(parent, index)
      raise NotImplementedError
    end
  end
  
end
