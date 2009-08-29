require "rjava"

# Copyright (c) 2000, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Action
  module ControlContributionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Action
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Menu
      include_const ::Org::Eclipse::Swt::Widgets, :ToolBar
      include_const ::Org::Eclipse::Swt::Widgets, :ToolItem
    }
  end
  
  # An abstract contribution item implementation for adding an arbitrary
  # SWT control to a tool bar.
  # Note, however, that these items cannot be contributed to menu bars.
  # <p>
  # The <code>createControl</code> framework method must be implemented
  # by concrete subclasses.
  # </p>
  class ControlContribution < ControlContributionImports.const_get :ContributionItem
    include_class_members ControlContributionImports
    
    typesig { [String] }
    # Creates a control contribution item with the given id.
    # 
    # @param id the contribution item id
    def initialize(id)
      super(id)
    end
    
    typesig { [Control] }
    # Computes the width of the given control which is being added
    # to a tool bar.  This is needed to determine the width of the tool bar item
    # containing the given control.
    # <p>
    # The default implementation of this framework method returns
    # <code>control.computeSize(SWT.DEFAULT, SWT.DEFAULT, true).x</code>.
    # Subclasses may override if required.
    # </p>
    # 
    # @param control the control being added
    # @return the width of the control
    def compute_width(control)
      return control.compute_size(SWT::DEFAULT, SWT::DEFAULT, true).attr_x
    end
    
    typesig { [Composite] }
    # Creates and returns the control for this contribution item
    # under the given parent composite.
    # <p>
    # This framework method must be implemented by concrete
    # subclasses.
    # </p>
    # 
    # @param parent the parent composite
    # @return the new control
    def create_control(parent)
      raise NotImplementedError
    end
    
    typesig { [Composite] }
    # The control item implementation of this <code>IContributionItem</code>
    # method calls the <code>createControl</code> framework method.
    # Subclasses must implement <code>createControl</code> rather than
    # overriding this method.
    def fill(parent)
      create_control(parent)
    end
    
    typesig { [Menu, ::Java::Int] }
    # The control item implementation of this <code>IContributionItem</code>
    # method throws an exception since controls cannot be added to menus.
    def fill(parent, index)
      Assert.is_true(false, "Can't add a control to a menu") # $NON-NLS-1$
    end
    
    typesig { [ToolBar, ::Java::Int] }
    # The control item implementation of this <code>IContributionItem</code>
    # method calls the <code>createControl</code> framework method to
    # create a control under the given parent, and then creates
    # a new tool item to hold it.
    # Subclasses must implement <code>createControl</code> rather than
    # overriding this method.
    def fill(parent, index)
      control = create_control(parent)
      ti = ToolItem.new(parent, SWT::SEPARATOR, index)
      ti.set_control(control)
      ti.set_width(compute_width(control))
    end
    
    private
    alias_method :initialize__control_contribution, :initialize
  end
  
end
