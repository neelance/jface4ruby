require "rjava"

# Copyright (c) 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Dialogs
  module ControlAnimatorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Dialogs
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Graphics, :Rectangle
      include_const ::Org::Eclipse::Swt::Widgets, :Control
    }
  end
  
  # ControlAnimator provides a simple implementation to display or hide a control
  # at the bottom of the parent composite. Other animations will be written as
  # subclasses of this class. <p>
  # Instances of this class can be created using an AnimatorFactory.
  # 
  # @since 3.2
  class ControlAnimator 
    include_class_members ControlAnimatorImports
    
    # the control that will be displayed or hidden
    attr_accessor :control
    alias_method :attr_control, :control
    undef_method :control
    alias_method :attr_control=, :control=
    undef_method :control=
    
    typesig { [Control] }
    # Constructs a new ControlAnimator instance and passes along the
    # control that will be displayed or hidden.
    # 
    # @param control the control that will be displayed or hidden.
    def initialize(control)
      @control = nil
      @control = control
    end
    
    typesig { [::Java::Boolean] }
    # Displays or hides a control at the bottom of the parent composite
    # and makes use of the control's SWT visible flag.<p>
    # Subclasses should override this method.</p>
    # 
    # @param visible <code>true</code> if the control should be shown,
    # and <code>false</code> otherwise.
    def set_visible(visible)
      # Using the SWT visible flag to determine if the control has
      # already been displayed or hidden. Return if already displayed
      # and visible is true, or if already hidden and visible is false.
      if (!(@control.is_visible ^ visible))
        return
      end
      @control.set_visible(visible)
      parent_bounds = @control.get_parent.get_bounds
      bottom = parent_bounds.attr_height
      end_y = visible ? bottom - @control.get_bounds.attr_height : bottom
      loc = @control.get_location
      @control.set_location(loc.attr_x, end_y)
    end
    
    private
    alias_method :initialize__control_animator, :initialize
  end
  
end
