require "rjava"

# Copyright (c) 2000, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Viewers
  module IColorProviderImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
      include_const ::Org::Eclipse::Swt::Graphics, :Color
    }
  end
  
  # Interface to provide color representation for a given element.
  # @see org.eclipse.jface.viewers.IColorDecorator
  module IColorProvider
    include_class_members IColorProviderImports
    
    typesig { [Object] }
    # Provides a foreground color for the given element.
    # 
    # @param element the element
    # @return	the foreground color for the element, or <code>null</code>
    # to use the default foreground color
    def get_foreground(element)
      raise NotImplementedError
    end
    
    typesig { [Object] }
    # Provides a background color for the given element.
    # 
    # @param element the element
    # @return	the background color for the element, or <code>null</code>
    # to use the default background color
    def get_background(element)
      raise NotImplementedError
    end
  end
  
end
