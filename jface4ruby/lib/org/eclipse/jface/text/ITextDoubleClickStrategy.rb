require "rjava"

# Copyright (c) 2000, 2005 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text
  module ITextDoubleClickStrategyImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
    }
  end
  
  # A text double click strategy defines the reaction of a text viewer to mouse
  # double click events. The strategy must be installed on an
  # {@link org.eclipse.jface.text.ITextViewer}.
  # <p>
  # Clients may implement this interface or use the standard implementation
  # <code>DefaultTextDoubleClickStrategy</code>.</p>
  # 
  # @see org.eclipse.jface.text.ITextViewer
  # @see org.eclipse.swt.events.MouseListener#mouseDoubleClick(org.eclipse.swt.events.MouseEvent)
  module ITextDoubleClickStrategy
    include_class_members ITextDoubleClickStrategyImports
    
    typesig { [ITextViewer] }
    # The mouse has been double clicked on the given text viewer.
    # 
    # @param viewer the viewer into which has been double clicked
    def double_clicked(viewer)
      raise NotImplementedError
    end
  end
  
end
