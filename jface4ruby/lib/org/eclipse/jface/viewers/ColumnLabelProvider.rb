require "rjava"

# Copyright (c) 2006, 2007 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Viewers
  module ColumnLabelProviderImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
      include_const ::Org::Eclipse::Swt::Graphics, :Color
      include_const ::Org::Eclipse::Swt::Graphics, :Font
      include_const ::Org::Eclipse::Swt::Graphics, :Image
    }
  end
  
  # The ColumnLabelProvider is the label provider for viewers
  # that have column support such as {@link TreeViewer} and
  # {@link TableViewer}
  # 
  # <p><b>This classes is intended to be subclassed</b></p>
  # 
  # @since 3.3
  class ColumnLabelProvider < ColumnLabelProviderImports.const_get :CellLabelProvider
    include_class_members ColumnLabelProviderImports
    overload_protected {
      include IFontProvider
      include IColorProvider
      include ILabelProvider
    }
    
    typesig { [ViewerCell] }
    # (non-Javadoc)
    # @see org.eclipse.jface.viewers.CellLabelProvider#update(org.eclipse.jface.viewers.ViewerCell)
    def update(cell)
      element = cell.get_element
      cell.set_text(get_text(element))
      image = get_image(element)
      cell.set_image(image)
      cell.set_background(get_background(element))
      cell.set_foreground(get_foreground(element))
      cell.set_font(get_font(element))
    end
    
    typesig { [Object] }
    # (non-Javadoc)
    # @see org.eclipse.jface.viewers.IFontProvider#getFont(java.lang.Object)
    def get_font(element)
      return nil
    end
    
    typesig { [Object] }
    # (non-Javadoc)
    # @see org.eclipse.jface.viewers.IColorProvider#getBackground(java.lang.Object)
    def get_background(element)
      return nil
    end
    
    typesig { [Object] }
    # (non-Javadoc)
    # @see org.eclipse.jface.viewers.IColorProvider#getForeground(java.lang.Object)
    def get_foreground(element)
      return nil
    end
    
    typesig { [Object] }
    # (non-Javadoc)
    # @see org.eclipse.jface.viewers.ILabelProvider#getImage(java.lang.Object)
    def get_image(element)
      return nil
    end
    
    typesig { [Object] }
    # (non-Javadoc)
    # @see org.eclipse.jface.viewers.ILabelProvider#getText(java.lang.Object)
    def get_text(element)
      return (element).nil? ? "" : element.to_s # $NON-NLS-1$
    end
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__column_label_provider, :initialize
  end
  
end
