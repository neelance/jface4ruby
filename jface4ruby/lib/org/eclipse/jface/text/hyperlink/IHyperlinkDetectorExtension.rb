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
  module IHyperlinkDetectorExtensionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Hyperlink
    }
  end
  
  # Extends {@link IHyperlinkDetector} with ability
  # to dispose a hyperlink detector.
  # <p>
  # Clients may implement this interface.
  # </p>
  # 
  # @since 3.3
  module IHyperlinkDetectorExtension
    include_class_members IHyperlinkDetectorExtensionImports
    
    typesig { [] }
    # Disposes this hyperlink detector.
    def dispose
      raise NotImplementedError
    end
  end
  
end
