require "rjava"

# Copyright (c) 2000, 2009 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text
  module IViewportListenerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
    }
  end
  
  # Registered with a text viewer, view port listeners are informed about changes of a text viewer's
  # view port. The view port is that portion of the viewer's document which is visible in the viewer.
  # <p>
  # <strong>Note:</strong> This listener will not be notified when the viewer is resized.
  # </p>
  # <p>
  # Clients may implement this interface.
  # </p>
  # 
  # @see org.eclipse.jface.text.ITextViewer#addViewportListener(IViewportListener)
  module IViewportListener
    include_class_members IViewportListenerImports
    
    typesig { [::Java::Int] }
    # Informs that the view port changed. The given vertical position is the new vertical scrolling
    # offset measured in pixels.
    # <p>
    # <strong>Note:</strong> This event will not be sent when the viewer is resized.
    # </p>
    # 
    # @param verticalOffset the vertical offset measured in pixels
    def viewport_changed(vertical_offset)
      raise NotImplementedError
    end
  end
  
end
