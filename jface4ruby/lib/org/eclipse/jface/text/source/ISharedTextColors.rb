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
  module ISharedTextColorsImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Source
      include_const ::Org::Eclipse::Swt::Graphics, :Color
      include_const ::Org::Eclipse::Swt::Graphics, :RGB
    }
  end
  
  # Manages SWT color objects. Until the <code>dispose</code> method is called,
  # the same color object is returned for equal <code>RGB</code> values.
  # <p>
  # This interface may be implemented by clients.
  # </p>
  # 
  # @since 2.1
  module ISharedTextColors
    include_class_members ISharedTextColorsImports
    
    typesig { [RGB] }
    # Returns the color object for the value represented by the given
    # <code>RGB</code> object.
    # 
    # @param rgb the RBG color specification
    # @return the color object for the given RGB value
    def get_color(rgb)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Tells this object to dispose all its managed colors.
    def dispose
      raise NotImplementedError
    end
  end
  
end
