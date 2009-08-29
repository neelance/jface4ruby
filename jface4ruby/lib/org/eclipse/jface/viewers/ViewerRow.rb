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
# - fix in bug: 166346,167325,174355,195908,198035,215069,227421
module Org::Eclipse::Jface::Viewers
  module ViewerRowImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
      include_const ::Org::Eclipse::Swt::Custom, :StyleRange
      include_const ::Org::Eclipse::Swt::Graphics, :Color
      include_const ::Org::Eclipse::Swt::Graphics, :Font
      include_const ::Org::Eclipse::Swt::Graphics, :Image
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Graphics, :Rectangle
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Widget
      include_const ::Org::Eclipse::Jface::Util, :Policy
    }
  end
  
  # ViewerRow is the abstract superclass of the part that represents items in a
  # Table or Tree. Implementors of {@link ColumnViewer} have to provide a
  # concrete implementation for the underlying widget
  # 
  # @since 3.3
  class ViewerRow 
    include_class_members ViewerRowImports
    include Cloneable
    
    class_module.module_eval {
      # Constant denoting the row above the current one (value is 1).
      # 
      # @see #getNeighbor(int, boolean)
      const_set_lazy(:ABOVE) { 1 }
      const_attr_reader  :ABOVE
      
      # Constant denoting the row below the current one (value is 2).
      # 
      # @see #getNeighbor(int, boolean)
      const_set_lazy(:BELOW) { 2 }
      const_attr_reader  :BELOW
      
      const_set_lazy(:KEY_TEXT_LAYOUT) { RJava.cast_to_string(Policy::JFACE) + "styled_label_key_" }
      const_attr_reader  :KEY_TEXT_LAYOUT
      
      # $NON-NLS-1$
      const_set_lazy(:KEY_TEXT_LAYOUT_0) { RJava.cast_to_string(Policy::JFACE) + "styled_label_key_0" }
      const_attr_reader  :KEY_TEXT_LAYOUT_0
      
      # $NON-NLS-1$
      
      def cached_data_keys
        defined?(@@cached_data_keys) ? @@cached_data_keys : @@cached_data_keys= nil
      end
      alias_method :attr_cached_data_keys, :cached_data_keys
      
      def cached_data_keys=(value)
        @@cached_data_keys = value
      end
      alias_method :attr_cached_data_keys=, :cached_data_keys=
    }
    
    typesig { [::Java::Int] }
    # Get the bounds of the entry at the columnIndex,
    # 
    # @param columnIndex
    # @return {@link Rectangle}
    def get_bounds(column_index)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Return the bounds for the whole item.
    # 
    # @return {@link Rectangle}
    def get_bounds
      raise NotImplementedError
    end
    
    typesig { [] }
    # Return the item for the receiver.
    # 
    # @return {@link Widget}
    def get_item
      raise NotImplementedError
    end
    
    typesig { [] }
    # Return the number of columns for the receiver.
    # 
    # @return the number of columns
    def get_column_count
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    # Return the image at the columnIndex.
    # 
    # @param columnIndex
    # @return {@link Image} or <code>null</code>
    def get_image(column_index)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int, Image] }
    # Set the image at the columnIndex
    # 
    # @param columnIndex
    # @param image
    def set_image(column_index, image)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    # Get the text at the columnIndex.
    # 
    # @param columnIndex
    # @return {@link String}
    def get_text(column_index)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int, String] }
    # Set the text at the columnIndex
    # 
    # @param columnIndex
    # @param text
    def set_text(column_index, text)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    # Get the background at the columnIndex,
    # 
    # @param columnIndex
    # @return {@link Color} or <code>null</code>
    def get_background(column_index)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int, Color] }
    # Set the background at the columnIndex.
    # 
    # @param columnIndex
    # @param color
    def set_background(column_index, color)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    # Get the foreground at the columnIndex.
    # 
    # @param columnIndex
    # @return {@link Color} or <code>null</code>
    def get_foreground(column_index)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int, Color] }
    # Set the foreground at the columnIndex.
    # 
    # @param columnIndex
    # @param color
    def set_foreground(column_index, color)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    # Get the font at the columnIndex.
    # 
    # @param columnIndex
    # @return {@link Font} or <code>null</code>
    def get_font(column_index)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int, Font] }
    # Set the {@link Font} at the columnIndex.
    # 
    # @param columnIndex
    # @param font
    def set_font(column_index, font)
      raise NotImplementedError
    end
    
    typesig { [Point] }
    # Get the ViewerCell at point.
    # 
    # @param point
    # @return @return {@link ViewerCell} or <code>null</code> if the point is
    # not in the bounds of a cell
    def get_cell(point)
      index = get_column_index(point)
      return get_cell(index)
    end
    
    typesig { [Point] }
    # Get the columnIndex of the point.
    # 
    # @param point
    # @return int or -1 if it cannot be found.
    def get_column_index(point)
      count = get_column_count
      # If there are no columns the column-index is 0
      if ((count).equal?(0))
        return 0
      end
      i = 0
      while i < count
        if (get_bounds(i).contains(point))
          return i
        end
        i += 1
      end
      return -1
    end
    
    typesig { [::Java::Int] }
    # Get a ViewerCell for the column at index.
    # 
    # @param column
    # @return {@link ViewerCell} or <code>null</code> if the index is negative.
    def get_cell(column)
      if (column >= 0)
        return ViewerCell.new(clone, column, get_element)
      end
      return nil
    end
    
    typesig { [] }
    # Get the Control for the receiver.
    # 
    # @return {@link Control}
    def get_control
      raise NotImplementedError
    end
    
    typesig { [::Java::Int, ::Java::Boolean] }
    # Returns a neighboring row, or <code>null</code> if no neighbor exists in
    # the given direction. If <code>sameLevel</code> is <code>true</code>, only
    # sibling rows (under the same parent) will be considered.
    # 
    # @param direction
    # the direction {@link #BELOW} or {@link #ABOVE}
    # 
    # @param sameLevel
    # if <code>true</code>, search only within sibling rows
    # @return the row above/below, or <code>null</code> if not found
    def get_neighbor(direction, same_level)
      raise NotImplementedError
    end
    
    typesig { [] }
    # The tree path used to identify an element by the unique path
    # 
    # @return the path
    def get_tree_path
      raise NotImplementedError
    end
    
    typesig { [] }
    def clone
      raise NotImplementedError
    end
    
    typesig { [] }
    # @return the model element
    def get_element
      raise NotImplementedError
    end
    
    typesig { [] }
    def hash_code
      prime = 31
      result = 1
      result = prime * result + (((get_item).nil?) ? 0 : get_item.hash_code)
      return result
    end
    
    typesig { [Object] }
    def ==(obj)
      if ((self).equal?(obj))
        return true
      end
      if ((obj).nil?)
        return false
      end
      if (!(get_class).equal?(obj.get_class))
        return false
      end
      other = obj
      if ((get_item).nil?)
        if (!(other.get_item).nil?)
          return false
        end
      else
        if (!(get_item == other.get_item))
          return false
        end
      end
      return true
    end
    
    typesig { [::Java::Int] }
    # The cell at the current index (as shown in the UI). This can be different
    # to the original index when columns are reordered.
    # 
    # @param visualIndex
    # the current index (as shown in the UI)
    # @return the cell at the currently visible index
    def get_cell_at_visual_index(visual_index)
      return get_cell(get_creation_index(visual_index))
    end
    
    typesig { [::Java::Int] }
    # Translate the original column index to the actual one.
    # <p>
    # <b>Because of backwards API compatibility the default implementation
    # returns the original index. Implementators of {@link ColumnViewer} should
    # overwrite this method if their widget supports reordered columns</b>
    # </p>
    # 
    # @param creationIndex
    # the original index
    # @return the current index (as shown in the UI)
    # @since 3.4
    def get_visual_index(creation_index)
      return creation_index
    end
    
    typesig { [::Java::Int] }
    # Translate the current column index (as shown in the UI) to the original
    # one.
    # <p>
    # <b>Because of backwards API compatibility the default implementation
    # returns the original index. Implementators of {@link ColumnViewer} should
    # overwrite this method if their widget supports reordered columns</b>
    # </p>
    # 
    # @param visualIndex
    # the current index (as shown in the UI)
    # @return the original index
    # @since 3.4
    def get_creation_index(visual_index)
      return visual_index
    end
    
    typesig { [::Java::Int] }
    # The location and bounds of the area where the text is drawn depends on
    # various things (image displayed, control with SWT.CHECK)
    # 
    # @param index
    # the column index
    # @return the bounds of the of the text area. May return <code>null</code>
    # if the underlying widget implementation doesn't provide this
    # information
    # @since 3.4
    def get_text_bounds(index)
      return nil
    end
    
    typesig { [::Java::Int] }
    # Returns the location and bounds of the area where the image is drawn.
    # 
    # @param index
    # the column index
    # @return the bounds of the of the image area. May return <code>null</code>
    # if the underlying widget implementation doesn't provide this
    # information
    # @since 3.4
    def get_image_bounds(index)
      return nil
    end
    
    typesig { [::Java::Int, Array.typed(StyleRange)] }
    # Set the style ranges to be applied on the text label at the column index
    # Note: Requires {@link StyledCellLabelProvider} with owner draw enabled.
    # 
    # @param columnIndex
    # the index of the column
    # @param styleRanges
    # the styled ranges
    # 
    # @since 3.4
    def set_style_ranges(column_index, style_ranges)
      get_item.set_data(get_style_ranges_data_key(column_index), style_ranges)
    end
    
    typesig { [::Java::Int] }
    # @param columnIndex
    # @return
    def get_style_ranges_data_key(column_index)
      if ((column_index).equal?(0))
        return KEY_TEXT_LAYOUT_0
      end
      if ((self.attr_cached_data_keys).nil?)
        size = Math.max(10, column_index + 1)
        self.attr_cached_data_keys = Array.typed(String).new(size) { nil }
        i = 1
        while i < self.attr_cached_data_keys.attr_length
          self.attr_cached_data_keys[i] = KEY_TEXT_LAYOUT + RJava.cast_to_string(i)
          i += 1
        end
      else
        if (column_index >= self.attr_cached_data_keys.attr_length)
          new_cached_data_keys = Array.typed(String).new(column_index + 1) { nil }
          System.arraycopy(self.attr_cached_data_keys, 0, new_cached_data_keys, 0, self.attr_cached_data_keys.attr_length)
          i = self.attr_cached_data_keys.attr_length
          while i < new_cached_data_keys.attr_length
            new_cached_data_keys[i] = KEY_TEXT_LAYOUT + RJava.cast_to_string(i)
            i += 1
          end
          self.attr_cached_data_keys = new_cached_data_keys
        end
      end
      return self.attr_cached_data_keys[column_index]
    end
    
    typesig { [::Java::Int] }
    # Returns the style ranges to be applied on the text label at the column
    # index or <code>null</code> if no style ranges have been set.
    # 
    # @param columnIndex
    # the index of the column
    # @return styleRanges the styled ranges
    # 
    # @since 3.4
    def get_style_ranges(column_index)
      return get_item.get_data(get_style_ranges_data_key(column_index))
    end
    
    typesig { [::Java::Int] }
    def get_width(column_index)
      return get_bounds(column_index).attr_width
    end
    
    typesig { [::Java::Int] }
    # Scrolls the cell at this index into view
    # <p>
    # <b>Because of backwards API compatibility the default implementation is a
    # no-op. Implementators of {@link ColumnViewer} should overwrite this
    # method if their widget supports reordered columns</b>
    # </p>
    # 
    # @param columnIndex
    # the column index
    # @return return <code>true</code> when the cell is scrolled into view
    # @since 3.5
    def scroll_cell_into_view(column_index)
      return false
    end
    
    typesig { [::Java::Int] }
    # Returns <code>true</code> if the column with the given index is visible
    # 
    # @param columnIndex
    # the column index
    # 
    # @return <code>true</code> if the column is visible
    # @since 3.5
    def is_column_visible(column_index)
      return get_width(column_index) > 0
    end
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__viewer_row, :initialize
  end
  
end
