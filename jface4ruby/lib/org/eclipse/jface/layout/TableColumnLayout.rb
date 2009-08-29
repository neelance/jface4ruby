require "rjava"

# Copyright (c) 2007, 2009 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# Tom Schindl <tom.schindl@bestsolution.at> - initial API and implementation
# - fix for bug 178280
# IBM Corporation - API refactoring and general maintenance
module Org::Eclipse::Jface::Layout
  module TableColumnLayoutImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Layout
      include_const ::Org::Eclipse::Jface::Viewers, :ColumnLayoutData
      include_const ::Org::Eclipse::Jface::Viewers, :ColumnPixelData
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Layout
      include_const ::Org::Eclipse::Swt::Widgets, :Scrollable
      include_const ::Org::Eclipse::Swt::Widgets, :Table
      include_const ::Org::Eclipse::Swt::Widgets, :TableColumn
      include_const ::Org::Eclipse::Swt::Widgets, :Widget
    }
  end
  
  # The TableColumnLayout is the {@link Layout} used to maintain
  # {@link TableColumn} sizes in a {@link Table}.
  # 
  # <p>
  # <b>You can only add the {@link Layout} to a container whose <i>only</i> child
  # is the {@link Table} control you want the {@link Layout} applied to. Don't
  # assign the layout directly the {@link Table}</b>
  # </p>
  # 
  # @since 3.3
  class TableColumnLayout < TableColumnLayoutImports.const_get :AbstractColumnLayout
    include_class_members TableColumnLayoutImports
    
    typesig { [Scrollable] }
    # {@inheritDoc}
    # 
    # @since 3.5
    def get_column_count(table_tree)
      return (table_tree).get_column_count
    end
    
    typesig { [Scrollable, Array.typed(::Java::Int)] }
    # {@inheritDoc}
    # 
    # @since 3.5
    def set_column_widths(table_tree, widths)
      columns = (table_tree).get_columns
      i = 0
      while i < widths.attr_length
        columns[i].set_width(widths[i])
        i += 1
      end
    end
    
    typesig { [Scrollable, ::Java::Int] }
    # {@inheritDoc}
    # 
    # @since 3.5
    def get_layout_data(table_tree, column_index)
      column = (table_tree).get_column(column_index)
      return column.get_data(LAYOUT_DATA)
    end
    
    typesig { [Widget] }
    def get_composite(column)
      return (column).get_parent.get_parent
    end
    
    typesig { [Widget] }
    # @since 3.5
    def update_column_data(column)
      t_column = column
      t = t_column.get_parent
      if (!IS_GTK || !(t.get_column(t.get_column_count - 1)).equal?(t_column))
        t_column.set_data(LAYOUT_DATA, ColumnPixelData.new(t_column.get_width))
        layout(t.get_parent, true)
      end
    end
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__table_column_layout, :initialize
  end
  
end
