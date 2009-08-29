require "rjava"

# Copyright (c) 2006 Tom Schindl and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# Tom Schindl - initial API and implementation
# Boris Bokowski (IBM Corporation) - Javadoc improvements
module Org::Eclipse::Jface::Viewers
  module TableViewerColumnImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
      include_const ::Org::Eclipse::Swt::Widgets, :Table
      include_const ::Org::Eclipse::Swt::Widgets, :TableColumn
    }
  end
  
  # ViewerColumn implementation for TableViewer to enable column-specific label
  # providers and editing support.
  # 
  # @since 3.3
  class TableViewerColumn < TableViewerColumnImports.const_get :ViewerColumn
    include_class_members TableViewerColumnImports
    
    attr_accessor :column
    alias_method :attr_column, :column
    undef_method :column
    alias_method :attr_column=, :column=
    undef_method :column=
    
    typesig { [TableViewer, ::Java::Int] }
    # Creates a new viewer column for the given {@link TableViewer} on a new
    # {@link TableColumn} with the given style bits. The column is added at the
    # end of the list of columns.
    # 
    # @param viewer
    # the table viewer to which this column belongs
    # @param style
    # the style used to create the column, for applicable style bits
    # see {@link TableColumn}
    # @see TableColumn#TableColumn(Table, int)
    def initialize(viewer, style)
      initialize__table_viewer_column(viewer, style, -1)
    end
    
    typesig { [TableViewer, ::Java::Int, ::Java::Int] }
    # Creates a new viewer column for the given {@link TableViewer} on a new
    # {@link TableColumn} with the given style bits. The column is inserted at
    # the given index into the list of columns.
    # 
    # @param viewer
    # the table viewer to which this column belongs
    # @param style
    # the style used to create the column, for applicable style bits
    # see {@link TableColumn}
    # @param index
    # the index at which to place the newly created column
    # @see TableColumn#TableColumn(Table, int, int)
    def initialize(viewer, style, index)
      initialize__table_viewer_column(viewer, create_column(viewer.get_table, style, index))
    end
    
    typesig { [TableViewer, TableColumn] }
    # Creates a new viewer column for the given {@link TableViewer} on the given
    # {@link TableColumn}.
    # 
    # @param viewer
    # the table viewer to which this column belongs
    # @param column
    # the underlying table column
    def initialize(viewer, column)
      @column = nil
      super(viewer, column)
      @column = column
    end
    
    class_module.module_eval {
      typesig { [Table, ::Java::Int, ::Java::Int] }
      def create_column(table, style, index)
        if (index >= 0)
          return TableColumn.new(table, style, index)
        end
        return TableColumn.new(table, style)
      end
    }
    
    typesig { [] }
    # @return the underlying SWT table column
    def get_column
      return @column
    end
    
    private
    alias_method :initialize__table_viewer_column, :initialize
  end
  
end
