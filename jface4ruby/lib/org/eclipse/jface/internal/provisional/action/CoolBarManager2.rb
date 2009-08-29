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
  module CoolBarManager2Imports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Internal::Provisional::Action
      include_const ::Org::Eclipse::Jface::Action, :CoolBarManager
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :CoolBar
    }
  end
  
  # Extends <code>CoolBarManager</code> to implement <code>ICoolBarManager2</code>
  # 
  # <p>
  # <strong>EXPERIMENTAL</strong>. This class or interface has been added as
  # part of a work in progress. There is a guarantee neither that this API will
  # work nor that it will remain the same. Please do not use this API without
  # consulting with the Platform/UI team.
  # </p>
  # 
  # @since 3.2
  class CoolBarManager2 < CoolBarManager2Imports.const_get :CoolBarManager
    include_class_members CoolBarManager2Imports
    overload_protected {
      include ICoolBarManager2
    }
    
    typesig { [] }
    # Creates a new cool bar manager with the default style. Equivalent to
    # <code>CoolBarManager(SWT.NONE)</code>.
    def initialize
      super()
    end
    
    typesig { [CoolBar] }
    # Creates a cool bar manager for an existing cool bar control. This
    # manager becomes responsible for the control, and will dispose of it when
    # the manager is disposed.
    # 
    # @param coolBar
    # the cool bar control
    def initialize(cool_bar)
      super(cool_bar)
    end
    
    typesig { [::Java::Int] }
    # Creates a cool bar manager with the given SWT style. Calling <code>createControl</code>
    # will create the cool bar control.
    # 
    # @param style
    # the cool bar item style; see
    # {@link org.eclipse.swt.widgets.CoolBar CoolBar}for for valid
    # style bits
    def initialize(style)
      super(style)
    end
    
    typesig { [Composite] }
    # Creates and returns this manager's cool bar control. Does not create a
    # new control if one already exists.
    # 
    # @param parent
    # the parent control
    # @return the cool bar control
    # @since 3.2
    def create_control2(parent)
      return create_control(parent)
    end
    
    typesig { [] }
    # Returns the control for this manager.
    # 
    # @return the control, or <code>null</code> if none
    # @since 3.2
    def get_control2
      return get_control
    end
    
    private
    alias_method :initialize__cool_bar_manager2, :initialize
  end
  
end
