require "rjava"

# Copyright (c) 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Hyperlink
  module IHyperlinkPresenterExtensionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Hyperlink
    }
  end
  
  # Extends {@link IHyperlinkPresenter} with ability
  # to query whether the currently shown hyperlinks
  # can be hidden.
  # <p>
  # Clients may implement this interface.
  # </p>
  # 
  # @since 3.4
  module IHyperlinkPresenterExtension
    include_class_members IHyperlinkPresenterExtensionImports
    
    typesig { [] }
    # Tells whether the currently shown hyperlinks
    # can be hidden.
    # 
    # @return <code>true</code> if the hyperlink manager can hide the current hyperlinks
    def can_hide_hyperlinks
      raise NotImplementedError
    end
  end
  
end
