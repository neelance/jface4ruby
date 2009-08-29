require "rjava"

# Copyright (c) 2004, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# Initial implementation - Gunnar Ahlberg (IBS AB, www.ibs.net)
# IBM Corporation - further revisions
module Org::Eclipse::Jface::Viewers
  module ITableColorProviderImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
      include_const ::Org::Eclipse::Swt::Graphics, :Color
    }
  end
  
  # Interface to provide color representation for a given cell within
  # the row for an element in a table.
  # @since 3.1
  module ITableColorProvider
    include_class_members ITableColorProviderImports
    
    typesig { [Object, ::Java::Int] }
    # Provides a foreground color for the given element.
    # 
    # @param element the element
    # @param columnIndex the zero-based index of the column in which
    # the color appears
    # @return the foreground color for the element, or <code>null</code> to
    # use the default foreground color
    def get_foreground(element, column_index)
      raise NotImplementedError
    end
    
    typesig { [Object, ::Java::Int] }
    # Provides a background color for the given element at the specified index
    # 
    # @param element the element
    # @param columnIndex the zero-based index of the column in which the color appears
    # @return the background color for the element, or <code>null</code> to
    # use the default background color
    def get_background(element, column_index)
      raise NotImplementedError
    end
  end
  
end
