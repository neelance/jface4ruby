require "rjava"

# Copyright (c) 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Source
  module IAnnotationHoverExtension2Imports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Source
    }
  end
  
  # Extension interface for {@link org.eclipse.jface.text.source.IAnnotationHover} for
  # <ul>
  # <li>providing whether the information control can interact with the mouse wheel</li>
  # </ul>
  # 
  # @see org.eclipse.jface.text.source.IAnnotationHover
  # @since 3.2
  module IAnnotationHoverExtension2
    include_class_members IAnnotationHoverExtension2Imports
    
    typesig { [] }
    # Returns whether the provided information control can interact with the mouse wheel. I.e. the
    # hover will not be closed when the mouse wheel is moved.
    # 
    # @return <code>true</code> if the mouse wheel is handled by the hover
    def can_handle_mouse_wheel
      raise NotImplementedError
    end
  end
  
end
