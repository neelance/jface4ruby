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
  module ITextPresentationListenerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
    }
  end
  
  # Text presentation listeners registered with an
  # {@link org.eclipse.jface.text.ITextViewer} are informed when a
  # {@link org.eclipse.jface.text.TextPresentation} is about to be applied to the
  # text viewer. The listener can apply changes to the text presentation and thus
  # participate in the process of text presentation creation.
  # 
  # @since 3.0
  module ITextPresentationListener
    include_class_members ITextPresentationListenerImports
    
    typesig { [TextPresentation] }
    # This method is called when a text presentation is about to be applied to
    # the text viewer. The receiver is allowed to change the text presentation
    # during that call.
    # 
    # @param textPresentation the current text presentation
    def apply_text_presentation(text_presentation)
      raise NotImplementedError
    end
  end
  
end
