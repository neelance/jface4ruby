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
# - fix in bug: 174355,171126,,195908,198035,215069,227421
module Org::Eclipse::Jface::Viewers
  module TreeViewerRowImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
      include_const ::Java::Util, :LinkedList
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Swt::Graphics, :Color
      include_const ::Org::Eclipse::Swt::Graphics, :Font
      include_const ::Org::Eclipse::Swt::Graphics, :Image
      include_const ::Org::Eclipse::Swt::Graphics, :Rectangle
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Tree
      include_const ::Org::Eclipse::Swt::Widgets, :TreeItem
      include_const ::Org::Eclipse::Swt::Widgets, :Widget
    }
  end
  
  # TreeViewerRow is the Tree implementation of ViewerRow.
  # 
  # @since 3.3
  class TreeViewerRow < TreeViewerRowImports.const_get :ViewerRow
    include_class_members TreeViewerRowImports
    
    attr_accessor :item
    alias_method :attr_item, :item
    undef_method :item
    alias_method :attr_item=, :item=
    undef_method :item=
    
    typesig { [TreeItem] }
    # Create a new instance of the receiver.
    # 
    # @param item
    def initialize(item)
      @item = nil
      super()
      @item = item
    end
    
    typesig { [::Java::Int] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.viewers.ViewerRow#getBounds(int)
    def get_bounds(column_index)
      return @item.get_bounds(column_index)
    end
    
    typesig { [] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.viewers.ViewerRow#getBounds()
    def get_bounds
      return @item.get_bounds
    end
    
    typesig { [] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.viewers.ViewerRow#getColumnCount()
    def get_column_count
      return @item.get_parent.get_column_count
    end
    
    typesig { [] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.viewers.ViewerRow#getItem()
    def get_item
      return @item
    end
    
    typesig { [::Java::Int] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.viewers.ViewerRow#getBackground(int)
    def get_background(column_index)
      return @item.get_background(column_index)
    end
    
    typesig { [::Java::Int] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.viewers.ViewerRow#getFont(int)
    def get_font(column_index)
      return @item.get_font(column_index)
    end
    
    typesig { [::Java::Int] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.viewers.ViewerRow#getForeground(int)
    def get_foreground(column_index)
      return @item.get_foreground(column_index)
    end
    
    typesig { [::Java::Int] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.viewers.ViewerRow#getImage(int)
    def get_image(column_index)
      return @item.get_image(column_index)
    end
    
    typesig { [::Java::Int] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.viewers.ViewerRow#getText(int)
    def get_text(column_index)
      return @item.get_text(column_index)
    end
    
    typesig { [::Java::Int, Color] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.viewers.ViewerRow#setBackground(int,
    # org.eclipse.swt.graphics.Color)
    def set_background(column_index, color)
      @item.set_background(column_index, color)
    end
    
    typesig { [::Java::Int, Font] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.viewers.ViewerRow#setFont(int,
    # org.eclipse.swt.graphics.Font)
    def set_font(column_index, font)
      @item.set_font(column_index, font)
    end
    
    typesig { [::Java::Int, Color] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.viewers.ViewerRow#setForeground(int,
    # org.eclipse.swt.graphics.Color)
    def set_foreground(column_index, color)
      @item.set_foreground(column_index, color)
    end
    
    typesig { [::Java::Int, Image] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.viewers.ViewerRow#setImage(int,
    # org.eclipse.swt.graphics.Image)
    def set_image(column_index, image)
      old_image = @item.get_image(column_index)
      if (!(image).equal?(old_image))
        @item.set_image(column_index, image)
      end
    end
    
    typesig { [::Java::Int, String] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.viewers.ViewerRow#setText(int, java.lang.String)
    def set_text(column_index, text)
      @item.set_text(column_index, (text).nil? ? "" : text) # $NON-NLS-1$
    end
    
    typesig { [] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.viewers.ViewerRow#getControl()
    def get_control
      return @item.get_parent
    end
    
    typesig { [::Java::Int, ::Java::Boolean] }
    def get_neighbor(direction, same_level)
      if ((direction).equal?(ViewerRow::ABOVE))
        return get_row_above(same_level)
      else
        if ((direction).equal?(ViewerRow::BELOW))
          return get_row_below(same_level)
        else
          raise IllegalArgumentException.new("Illegal value of direction argument.") # $NON-NLS-1$
        end
      end
    end
    
    typesig { [::Java::Boolean] }
    def get_row_below(same_level)
      tree = @item.get_parent
      # This means we have top-level item
      if ((@item.get_parent_item).nil?)
        if (same_level || !@item.get_expanded)
          index = tree.index_of(@item) + 1
          if (index < tree.get_item_count)
            return TreeViewerRow.new(tree.get_item(index))
          end
        else
          if (@item.get_expanded && @item.get_item_count > 0)
            return TreeViewerRow.new(@item.get_item(0))
          end
        end
      else
        if (same_level || !@item.get_expanded)
          parent_item = @item.get_parent_item
          next_index = parent_item.index_of(@item) + 1
          total_index = parent_item.get_item_count
          item_after = nil
          # This would mean that it was the last item
          if ((next_index).equal?(total_index))
            item_after = find_next_item(parent_item)
          else
            item_after = parent_item.get_item(next_index)
          end
          if (!(item_after).nil?)
            return TreeViewerRow.new(item_after)
          end
        else
          if (@item.get_expanded && @item.get_item_count > 0)
            return TreeViewerRow.new(@item.get_item(0))
          end
        end
      end
      return nil
    end
    
    typesig { [::Java::Boolean] }
    def get_row_above(same_level)
      tree = @item.get_parent
      # This means we have top-level item
      if ((@item.get_parent_item).nil?)
        index = tree.index_of(@item) - 1
        next_top_item = nil
        if (index >= 0)
          next_top_item = tree.get_item(index)
        end
        if (!(next_top_item).nil?)
          if (same_level)
            return TreeViewerRow.new(next_top_item)
          end
          return TreeViewerRow.new(find_last_visible_item(next_top_item))
        end
      else
        parent_item = @item.get_parent_item
        previous_index = parent_item.index_of(@item) - 1
        item_before = nil
        if (previous_index >= 0)
          if (same_level)
            item_before = parent_item.get_item(previous_index)
          else
            item_before = find_last_visible_item(parent_item.get_item(previous_index))
          end
        else
          item_before = parent_item
        end
        if (!(item_before).nil?)
          return TreeViewerRow.new(item_before)
        end
      end
      return nil
    end
    
    typesig { [TreeItem] }
    def find_last_visible_item(parent_item)
      rv = parent_item
      while (rv.get_expanded && rv.get_item_count > 0)
        rv = rv.get_item(rv.get_item_count - 1)
      end
      return rv
    end
    
    typesig { [TreeItem] }
    def find_next_item(item)
      rv = nil
      tree = item.get_parent
      parent_item = item.get_parent_item
      next_index = 0
      total_items = 0
      if ((parent_item).nil?)
        next_index = tree.index_of(item) + 1
        total_items = tree.get_item_count
      else
        next_index = parent_item.index_of(item) + 1
        total_items = parent_item.get_item_count
      end
      # This is once more the last item in the tree
      # Search on
      if ((next_index).equal?(total_items))
        if (!(item.get_parent_item).nil?)
          rv = find_next_item(item.get_parent_item)
        end
      else
        if ((parent_item).nil?)
          rv = tree.get_item(next_index)
        else
          rv = parent_item.get_item(next_index)
        end
      end
      return rv
    end
    
    typesig { [] }
    def get_tree_path
      t_item = @item
      segments = LinkedList.new
      while (!(t_item).nil?)
        segment = t_item.get_data
        Assert.is_not_null(segment)
        segments.add_first(segment)
        t_item = t_item.get_parent_item
      end
      return TreePath.new(segments.to_array)
    end
    
    typesig { [TreeItem] }
    def set_item(item)
      @item = item
    end
    
    typesig { [] }
    def clone
      return TreeViewerRow.new(@item)
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
    alias_method :initialize__tree_viewer_row, :initialize
  end
  
end
