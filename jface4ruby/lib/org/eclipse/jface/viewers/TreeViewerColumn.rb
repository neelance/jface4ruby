require "rjava"

# Copyright (c) 2006 Tom Schindl and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# Tom Schindl - initial API and implementation
module Org::Eclipse::Jface::Viewers
  module TreeViewerColumnImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
      include_const ::Org::Eclipse::Swt::Widgets, :Tree
      include_const ::Org::Eclipse::Swt::Widgets, :TreeColumn
    }
  end
  
  # ViewerColumn implementation for TreeViewer to enable column-specific label
  # providers and editing support.
  # 
  # @since 3.3
  class TreeViewerColumn < TreeViewerColumnImports.const_get :ViewerColumn
    include_class_members TreeViewerColumnImports
    
    attr_accessor :column
    alias_method :attr_column, :column
    undef_method :column
    alias_method :attr_column=, :column=
    undef_method :column=
    
    typesig { [TreeViewer, ::Java::Int] }
    # Creates a new viewer column for the given {@link TreeViewer} on a new
    # {@link TreeColumn} with the given style bits. The column is inserted at
    # the given index into the list of columns.
    # 
    # @param viewer
    # the tree viewer to which this column belongs
    # @param style
    # the style bits used to create the column, for applicable style bits
    # see {@link TreeColumn}
    # @see TreeColumn#TreeColumn(Tree, int)
    def initialize(viewer, style)
      initialize__tree_viewer_column(viewer, style, -1)
    end
    
    typesig { [TreeViewer, ::Java::Int, ::Java::Int] }
    # Creates a new viewer column for the given {@link TreeViewer} on a new
    # {@link TreeColumn} with the given style bits. The column is added at the
    # end of the list of columns.
    # 
    # @param viewer
    # the tree viewer to which this column belongs
    # @param style
    # the style bits used to create the column, for applicable style bits
    # see {@link TreeColumn}
    # @param index
    # the index at which to place the newly created column
    # @see TreeColumn#TreeColumn(Tree, int, int)
    def initialize(viewer, style, index)
      initialize__tree_viewer_column(viewer, create_column(viewer.get_tree, style, index))
    end
    
    typesig { [TreeViewer, TreeColumn] }
    # Creates a new viewer column for the given {@link TreeViewer} on the given
    # {@link TreeColumn}.
    # 
    # @param viewer
    # the tree viewer to which this column belongs
    # @param column
    # the underlying tree column
    def initialize(viewer, column)
      @column = nil
      super(viewer, column)
      @column = column
    end
    
    class_module.module_eval {
      typesig { [Tree, ::Java::Int, ::Java::Int] }
      def create_column(table, style, index)
        if (index >= 0)
          return TreeColumn.new(table, style, index)
        end
        return TreeColumn.new(table, style)
      end
    }
    
    typesig { [] }
    # @return the underlying SWT column
    def get_column
      return @column
    end
    
    private
    alias_method :initialize__tree_viewer_column, :initialize
  end
  
end
