require "rjava"

# Copyright (c) 2004, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Viewers
  module IFontProviderImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
      include_const ::Org::Eclipse::Swt::Graphics, :Font
    }
  end
  
  # Interface to provide font representation for a given element.
  # @see org.eclipse.jface.viewers.IFontDecorator
  # 
  # @since 3.0
  module IFontProvider
    include_class_members IFontProviderImports
    
    typesig { [Object] }
    # Provides a font for the given element.
    # 
    # @param element the element
    # @return the font for the element, or <code>null</code>
    # to use the default font
    def get_font(element)
      raise NotImplementedError
    end
  end
  
end
