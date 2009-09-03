require "rjava"

# Copyright (c) 2000, 2005 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Hyperlink
  module IHyperlinkImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Hyperlink
      include_const ::Org::Eclipse::Jface::Text, :IRegion
    }
  end
  
  # Represents a hyperlink.
  # <p>
  # Clients may implement this interface.
  # </p>
  # 
  # @since 3.1
  module IHyperlink
    include_class_members IHyperlinkImports
    
    typesig { [] }
    # The region covered by this type of hyperlink.
    # 
    # @return the hyperlink region
    def get_hyperlink_region
      raise NotImplementedError
    end
    
    typesig { [] }
    # Optional label for this type of hyperlink.
    # <p>
    # This type label can be used by {@link IHyperlinkPresenter}s
    # which show several hyperlinks at once.
    # </p>
    # 
    # @return the type label or <code>null</code> if none
    def get_type_label
      raise NotImplementedError
    end
    
    typesig { [] }
    # Optional text for this hyperlink.
    # <p>
    # This can be used in situations where there are
    # several targets for the same hyperlink location.
    # </p>
    # 
    # @return the text or <code>null</code> if none
    def get_hyperlink_text
      raise NotImplementedError
    end
    
    typesig { [] }
    # Opens the given hyperlink.
    def open
      raise NotImplementedError
    end
  end
  
end
