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
  module AnimatorFactoryImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Dialogs
      include_const ::Org::Eclipse::Swt::Widgets, :Control
    }
  end
  
  # Factory for control animators used by JFace to animate the display of an SWT
  # Control. Through the use of the method
  # {@link org.eclipse.jface.util.Policy#setAnimatorFactory(AnimatorFactory)}
  # a new type of animator factory can be plugged into JFace.
  # 
  # @since 3.2
  # @deprecated as of 3.3, this class is no longer used.
  class AnimatorFactory 
    include_class_members AnimatorFactoryImports
    
    typesig { [Control] }
    # Creates a new ControlAnimator for use by JFace in animating
    # the display of an SWT Control. <p>
    # Subclasses should override this method.
    # 
    # @param control the SWT Control to de displayed
    # @return the ControlAnimator.
    # @since 3.2
    def create_animator(control)
      return ControlAnimator.new(control)
    end
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__animator_factory, :initialize
  end
  
end
