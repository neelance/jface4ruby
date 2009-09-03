require "rjava"

# Copyright (c) 2000, 2007 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text
  module ITextViewerExtension6Imports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
      include_const ::Org::Eclipse::Jface::Text::Hyperlink, :IHyperlinkDetector
    }
  end
  
  # Extension interface for {@link org.eclipse.jface.text.ITextViewer}.
  # Introduces the concept of text hyperlinks and adds access to the undo manager.
  # 
  # @see org.eclipse.jface.text.hyperlink.IHyperlink
  # @see org.eclipse.jface.text.hyperlink.IHyperlinkDetector
  # @since 3.1
  module ITextViewerExtension6
    include_class_members ITextViewerExtension6Imports
    
    typesig { [Array.typed(IHyperlinkDetector), ::Java::Int] }
    # Sets this viewer's hyperlink detectors for the given state mask.
    # 
    # @param hyperlinkDetectors	the new array of hyperlink detectors, <code>null</code>
    # or an empty array to disable hyperlinking
    # @param eventStateMask		the SWT event state mask to activate hyperlink mode
    def set_hyperlink_detectors(hyperlink_detectors, event_state_mask)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns this viewer's undo manager.
    # 
    # @return the undo manager or <code>null</code> if it has not been plugged-in
    # @since 3.1
    def get_undo_manager
      raise NotImplementedError
    end
  end
  
end
