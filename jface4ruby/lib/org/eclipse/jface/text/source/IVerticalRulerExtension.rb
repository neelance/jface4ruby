require "rjava"

# Copyright (c) 2000, 2005 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Source
  module IVerticalRulerExtensionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Source
      include_const ::Org::Eclipse::Swt::Graphics, :Font
    }
  end
  
  # Extension interface for {@link IVerticalRuler}.
  # <p>
  # Allows to set the font of the vertical ruler and to set the location of the
  # last mouse button activity.
  # 
  # @since 2.0
  module IVerticalRulerExtension
    include_class_members IVerticalRulerExtensionImports
    
    typesig { [Font] }
    # Sets the font of this vertical ruler.
    # 
    # @param font the new font of the vertical ruler
    def set_font(font)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Sets the location of the last mouse button activity. This method is used for
    # example by external mouse listeners.
    # 
    # @param x the x-coordinate
    # @param y the y-coordinate
    def set_location_of_last_mouse_button_activity(x, y)
      raise NotImplementedError
    end
  end
  
end
