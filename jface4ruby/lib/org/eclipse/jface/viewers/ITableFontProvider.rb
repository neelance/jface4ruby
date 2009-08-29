require "rjava"

# Copyright (c) 2004, 2005 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Viewers
  module ITableFontProviderImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
      include_const ::Org::Eclipse::Swt::Graphics, :Font
    }
  end
  
  # The ITableFontProvider is a font provider that provides fonts to
  # individual cells within tables.
  # @since 3.1
  module ITableFontProvider
    include_class_members ITableFontProviderImports
    
    typesig { [Object, ::Java::Int] }
    # Provides a font for the given element at index
    # columnIndex.
    # @param element The element being displayed
    # @param columnIndex The index of the column being displayed
    # @return Font
    def get_font(element, column_index)
      raise NotImplementedError
    end
  end
  
end
