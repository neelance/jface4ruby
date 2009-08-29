require "rjava"

# Copyright (c) 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Menus
  module AbstractTrimWidgetImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Menus
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :CoolBar
      include_const ::Org::Eclipse::Swt::Widgets, :Menu
      include_const ::Org::Eclipse::Swt::Widgets, :ToolBar
    }
  end
  
  # This extension to the {@link IWidget} interface allows clients adding
  # elements to the trim to receive notifications if the User moves the widget to
  # another trim area.
  # <p>
  # This class is intended to be the base for any trim contributions.
  # </p>
  # @since 3.2
  class AbstractTrimWidget 
    include_class_members AbstractTrimWidgetImports
    include IWidget
    
    typesig { [Composite, ::Java::Int, ::Java::Int] }
    # This method is called to initially construct the widget and is also
    # called whenever the widget's composite has been moved to a trim area on a
    # different side of the workbench. It is the client's responsibility to
    # control the life-cycle of the Control it manages.
    # <p>
    # For example: If the implementation is constructing a {@link ToolBar} and
    # the orientation were to change from horizontal to vertical it would have
    # to <code>dispose</code> its old ToolBar and create a new one with the
    # correct orientation.
    # </p>
    # <p>
    # The sides can be one of:
    # <ul>
    # <li>{@link SWT#TOP}</li>
    # <li>{@link SWT#BOTTOM}</li>
    # <li>{@link SWT#LEFT}</li>
    # <li>{@link SWT#RIGHT}</li>
    # </ul>
    # </p>
    # <p>
    # 
    # @param parent
    # The parent to (re)create the widget under
    # 
    # @param oldSide
    # The previous side ({@link SWT#DEFAULT} on the initial fill)
    # @param newSide
    # The current side
    def fill(parent, old_side, new_side)
      raise NotImplementedError
    end
    
    typesig { [] }
    # (non-Javadoc)
    # @see org.eclipse.jface.menus.IWidget#dispose()
    def dispose
      raise NotImplementedError
    end
    
    typesig { [Composite] }
    # (non-Javadoc)
    # @see org.eclipse.jface.menus.IWidget#fill(org.eclipse.swt.widgets.Composite)
    def fill(parent)
    end
    
    typesig { [Menu, ::Java::Int] }
    # (non-Javadoc)
    # @see org.eclipse.jface.menus.IWidget#fill(org.eclipse.swt.widgets.Menu, int)
    def fill(parent, index)
    end
    
    typesig { [ToolBar, ::Java::Int] }
    # (non-Javadoc)
    # @see org.eclipse.jface.menus.IWidget#fill(org.eclipse.swt.widgets.ToolBar, int)
    def fill(parent, index)
    end
    
    typesig { [CoolBar, ::Java::Int] }
    # (non-Javadoc)
    # @see org.eclipse.jface.menus.IWidget#fill(org.eclipse.swt.widgets.CoolBar, int)
    def fill(parent, index)
    end
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__abstract_trim_widget, :initialize
  end
  
end
