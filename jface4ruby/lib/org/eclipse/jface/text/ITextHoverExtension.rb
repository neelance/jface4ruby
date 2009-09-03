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
  module ITextHoverExtensionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
    }
  end
  
  # Extension interface for {@link org.eclipse.jface.text.ITextHover}.
  # <p>
  # It provides a way for hovers to specify the information control creator they
  # want to have used in order to create the hover control.</p>
  # 
  # @see org.eclipse.jface.text.IInformationControlCreator
  # @see org.eclipse.jface.text.ITextHover
  # @since 3.0
  module ITextHoverExtension
    include_class_members ITextHoverExtensionImports
    
    typesig { [] }
    # Returns the hover control creator of this text hover or <code>null</code>
    # 
    # @return the hover control creator or <code>null</code>
    def get_hover_control_creator
      raise NotImplementedError
    end
  end
  
end
