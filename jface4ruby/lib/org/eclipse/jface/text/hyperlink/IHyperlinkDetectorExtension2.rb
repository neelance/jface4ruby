require "rjava"

# Copyright (c) 2007, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Hyperlink
  module IHyperlinkDetectorExtension2Imports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Hyperlink
    }
  end
  
  # Extends {@link IHyperlinkDetector} with ability
  # to specify the state mask of the modifier keys that
  # need to be pressed for this hyperlink detector.
  # <p>
  # Clients may implement this interface.
  # </p>
  # 
  # @since 3.3
  module IHyperlinkDetectorExtension2
    include_class_members IHyperlinkDetectorExtension2Imports
    
    typesig { [] }
    # Returns the state mask of the modifier keys that
    # need to be pressed for this hyperlink detector.
    # 
    # @return the state mask
    def get_state_mask
      raise NotImplementedError
    end
  end
  
end
