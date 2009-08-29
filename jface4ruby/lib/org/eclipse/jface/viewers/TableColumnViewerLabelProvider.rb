require "rjava"

# Copyright (c) 2006, 2007 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
# Tom Shindl <tom.schindl@bestsolution.at> - initial API and implementation
module Org::Eclipse::Jface::Viewers
  module TableColumnViewerLabelProviderImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
    }
  end
  
  # TableColumnViewerLabelProvider is the mapping from the table based providers
  # to the ViewerLabelProvider.
  # 
  # @since 3.3
  # @see ITableLabelProvider
  # @see ITableColorProvider
  # @see ITableFontProvider
  class TableColumnViewerLabelProvider < TableColumnViewerLabelProviderImports.const_get :WrappedViewerLabelProvider
    include_class_members TableColumnViewerLabelProviderImports
    
    attr_accessor :table_label_provider
    alias_method :attr_table_label_provider, :table_label_provider
    undef_method :table_label_provider
    alias_method :attr_table_label_provider=, :table_label_provider=
    undef_method :table_label_provider=
    
    attr_accessor :table_color_provider
    alias_method :attr_table_color_provider, :table_color_provider
    undef_method :table_color_provider
    alias_method :attr_table_color_provider=, :table_color_provider=
    undef_method :table_color_provider=
    
    attr_accessor :table_font_provider
    alias_method :attr_table_font_provider, :table_font_provider
    undef_method :table_font_provider
    alias_method :attr_table_font_provider=, :table_font_provider=
    undef_method :table_font_provider=
    
    typesig { [IBaseLabelProvider] }
    # Create a new instance of the receiver.
    # 
    # @param labelProvider
    # instance of a table based label provider
    # @see ITableLabelProvider
    # @see ITableColorProvider
    # @see ITableFontProvider
    def initialize(label_provider)
      @table_label_provider = nil
      @table_color_provider = nil
      @table_font_provider = nil
      super(label_provider)
      if (label_provider.is_a?(ITableLabelProvider))
        @table_label_provider = label_provider
      end
      if (label_provider.is_a?(ITableColorProvider))
        @table_color_provider = label_provider
      end
      if (label_provider.is_a?(ITableFontProvider))
        @table_font_provider = label_provider
      end
    end
    
    typesig { [ViewerCell] }
    # (non-Javadoc)
    # @see org.eclipse.jface.viewers.WrappedViewerLabelProvider#update(org.eclipse.jface.viewers.ViewerCell)
    def update(cell)
      element = cell.get_element
      index = cell.get_column_index
      if ((@table_label_provider).nil?)
        cell.set_text(get_label_provider.get_text(element))
        cell.set_image(get_label_provider.get_image(element))
      else
        cell.set_text(@table_label_provider.get_column_text(element, index))
        cell.set_image(@table_label_provider.get_column_image(element, index))
      end
      if ((@table_color_provider).nil?)
        if (!(get_color_provider).nil?)
          cell.set_background(get_color_provider.get_background(element))
          cell.set_foreground(get_color_provider.get_foreground(element))
        end
      else
        cell.set_background(@table_color_provider.get_background(element, index))
        cell.set_foreground(@table_color_provider.get_foreground(element, index))
      end
      if ((@table_font_provider).nil?)
        if (!(get_font_provider).nil?)
          cell.set_font(get_font_provider.get_font(element))
        end
      else
        cell.set_font(@table_font_provider.get_font(element, index))
      end
    end
    
    private
    alias_method :initialize__table_column_viewer_label_provider, :initialize
  end
  
end
