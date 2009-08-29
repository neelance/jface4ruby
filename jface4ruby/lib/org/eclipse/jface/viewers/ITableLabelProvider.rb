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
  module ITableLabelProviderImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
      include_const ::Org::Eclipse::Swt::Graphics, :Image
    }
  end
  
  # Extends <code>IBaseLabelProvider</code> with the methods
  # to provide the text and/or image for each column of a given element.
  # Used by table viewers.
  # 
  # @see TableViewer
  module ITableLabelProvider
    include_class_members ITableLabelProviderImports
    include IBaseLabelProvider
    
    typesig { [Object, ::Java::Int] }
    # Returns the label image for the given column of the given element.
    # 
    # @param element the object representing the entire row, or
    # <code>null</code> indicating that no input object is set
    # in the viewer
    # @param columnIndex the zero-based index of the column in which
    # the label appears
    # @return Image or <code>null</code> if there is no image for the
    # given object at columnIndex
    def get_column_image(element, column_index)
      raise NotImplementedError
    end
    
    typesig { [Object, ::Java::Int] }
    # Returns the label text for the given column of the given element.
    # 
    # @param element the object representing the entire row, or
    # <code>null</code> indicating that no input object is set
    # in the viewer
    # @param columnIndex the zero-based index of the column in which the label appears
    # @return String or or <code>null</code> if there is no text for the
    # given object at columnIndex
    def get_column_text(element, column_index)
      raise NotImplementedError
    end
  end
  
end
