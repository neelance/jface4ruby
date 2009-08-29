require "rjava"

# Copyright (c) 2006, 2009 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
# Tom Schindl <tom.schindl@bestsolution.at> - initial API and implementation
# - fix in bug: 174355,195908,198035,215069,227421
module Org::Eclipse::Jface::Viewers
  module TableViewerRowImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
      include_const ::Org::Eclipse::Swt::Graphics, :Color
      include_const ::Org::Eclipse::Swt::Graphics, :Font
      include_const ::Org::Eclipse::Swt::Graphics, :Image
      include_const ::Org::Eclipse::Swt::Graphics, :Rectangle
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :TableItem
      include_const ::Org::Eclipse::Swt::Widgets, :Widget
    }
  end
  
  # TableViewerRow is the Table specific implementation of ViewerRow
  # @since 3.3
  class TableViewerRow < TableViewerRowImports.const_get :ViewerRow
    include_class_members TableViewerRowImports
    
    attr_accessor :item
    alias_method :attr_item, :item
    undef_method :item
    alias_method :attr_item=, :item=
    undef_method :item=
    
    typesig { [TableItem] }
    # Create a new instance of the receiver from item.
    # @param item
    def initialize(item)
      @item = nil
      super()
      @item = item
    end
    
    typesig { [::Java::Int] }
    # (non-Javadoc)
    # @see org.eclipse.jface.viewers.ViewerRow#getBounds(int)
    def get_bounds(column_index)
      return @item.get_bounds(column_index)
    end
    
    typesig { [] }
    # (non-Javadoc)
    # @see org.eclipse.jface.viewers.ViewerRow#getBounds()
    def get_bounds
      return @item.get_bounds
    end
    
    typesig { [] }
    # (non-Javadoc)
    # @see org.eclipse.jface.viewers.ViewerRow#getItem()
    def get_item
      return @item
    end
    
    typesig { [TableItem] }
    def set_item(item)
      @item = item
    end
    
    typesig { [] }
    # (non-Javadoc)
    # @see org.eclipse.jface.viewers.ViewerRow#getColumnCount()
    def get_column_count
      return @item.get_parent.get_column_count
    end
    
    typesig { [::Java::Int] }
    # (non-Javadoc)
    # @see org.eclipse.jface.viewers.ViewerRow#getBackground(int)
    def get_background(column_index)
      return @item.get_background(column_index)
    end
    
    typesig { [::Java::Int] }
    # (non-Javadoc)
    # @see org.eclipse.jface.viewers.ViewerRow#getFont(int)
    def get_font(column_index)
      return @item.get_font(column_index)
    end
    
    typesig { [::Java::Int] }
    # (non-Javadoc)
    # @see org.eclipse.jface.viewers.ViewerRow#getForeground(int)
    def get_foreground(column_index)
      return @item.get_foreground(column_index)
    end
    
    typesig { [::Java::Int] }
    # (non-Javadoc)
    # @see org.eclipse.jface.viewers.ViewerRow#getImage(int)
    def get_image(column_index)
      return @item.get_image(column_index)
    end
    
    typesig { [::Java::Int] }
    # (non-Javadoc)
    # @see org.eclipse.jface.viewers.ViewerRow#getText(int)
    def get_text(column_index)
      return @item.get_text(column_index)
    end
    
    typesig { [::Java::Int, Color] }
    # (non-Javadoc)
    # @see org.eclipse.jface.viewers.ViewerRow#setBackground(int, org.eclipse.swt.graphics.Color)
    def set_background(column_index, color)
      @item.set_background(column_index, color)
    end
    
    typesig { [::Java::Int, Font] }
    # (non-Javadoc)
    # @see org.eclipse.jface.viewers.ViewerRow#setFont(int, org.eclipse.swt.graphics.Font)
    def set_font(column_index, font)
      @item.set_font(column_index, font)
    end
    
    typesig { [::Java::Int, Color] }
    # (non-Javadoc)
    # @see org.eclipse.jface.viewers.ViewerRow#setForeground(int, org.eclipse.swt.graphics.Color)
    def set_foreground(column_index, color)
      @item.set_foreground(column_index, color)
    end
    
    typesig { [::Java::Int, Image] }
    # (non-Javadoc)
    # @see org.eclipse.jface.viewers.ViewerRow#setImage(int, org.eclipse.swt.graphics.Image)
    def set_image(column_index, image)
      old_image = @item.get_image(column_index)
      if (!(old_image).equal?(image))
        @item.set_image(column_index, image)
      end
    end
    
    typesig { [::Java::Int, String] }
    # (non-Javadoc)
    # @see org.eclipse.jface.viewers.ViewerRow#setText(int, java.lang.String)
    def set_text(column_index, text)
      @item.set_text(column_index, (text).nil? ? "" : text) # $NON-NLS-1$
    end
    
    typesig { [] }
    # (non-Javadoc)
    # @see org.eclipse.jface.viewers.ViewerRow#getControl()
    def get_control
      return @item.get_parent
    end
    
    typesig { [::Java::Int, ::Java::Boolean] }
    def get_neighbor(direction, same_level)
      if ((direction).equal?(ViewerRow::ABOVE))
        return get_row_above
      else
        if ((direction).equal?(ViewerRow::BELOW))
          return get_row_below
        else
          raise IllegalArgumentException.new("Illegal value of direction argument.") # $NON-NLS-1$
        end
      end
    end
    
    typesig { [] }
    def get_row_above
      index = @item.get_parent.index_of(@item) - 1
      if (index >= 0)
        return TableViewerRow.new(@item.get_parent.get_item(index))
      end
      return nil
    end
    
    typesig { [] }
    def get_row_below
      index = @item.get_parent.index_of(@item) + 1
      if (index < @item.get_parent.get_item_count)
        tmp = @item.get_parent.get_item(index)
        # TODO NULL can happen in case of VIRTUAL => How do we deal with that
        if (!(tmp).nil?)
          return TableViewerRow.new(tmp)
        end
      end
      return nil
    end
    
    typesig { [] }
    def get_tree_path
      return TreePath.new(Array.typed(Object).new([@item.get_data]))
    end
    
    typesig { [] }
    def clone
      return TableViewerRow.new(@item)
    end
    
    typesig { [] }
    def get_element
      return @item.get_data
    end
    
    typesig { [::Java::Int] }
    def get_visual_index(creation_index)
      order = @item.get_parent.get_column_order
      i = 0
      while i < order.attr_length
        if ((order[i]).equal?(creation_index))
          return i
        end
        i += 1
      end
      return super(creation_index)
    end
    
    typesig { [::Java::Int] }
    def get_creation_index(visual_index)
      if (!(@item).nil? && !@item.is_disposed && has_columns && is_valid_order_index(visual_index))
        return @item.get_parent.get_column_order[visual_index]
      end
      return super(visual_index)
    end
    
    typesig { [::Java::Int] }
    # (non-Javadoc)
    # @see org.eclipse.jface.viewers.ViewerRow#getTextBounds(int)
    def get_text_bounds(index)
      return @item.get_text_bounds(index)
    end
    
    typesig { [::Java::Int] }
    # (non-Javadoc)
    # @see org.eclipse.jface.viewers.ViewerRow#getImageBounds(int)
    def get_image_bounds(index)
      return @item.get_image_bounds(index)
    end
    
    typesig { [] }
    def has_columns
      return !(@item.get_parent.get_column_count).equal?(0)
    end
    
    typesig { [::Java::Int] }
    def is_valid_order_index(current_index)
      return current_index < @item.get_parent.get_column_order.attr_length
    end
    
    typesig { [::Java::Int] }
    def get_width(column_index)
      return @item.get_parent.get_column(column_index).get_width
    end
    
    typesig { [::Java::Int] }
    def scroll_cell_into_view(column_index)
      @item.get_parent.show_item(@item)
      if (has_columns)
        @item.get_parent.show_column(@item.get_parent.get_column(column_index))
      end
      return true
    end
    
    private
    alias_method :initialize__table_viewer_row, :initialize
  end
  
end
