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
# - fix in bug: 195908,198035,215069,215735,227421
module Org::Eclipse::Jface::Viewers
  module ViewerCellImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
      include_const ::Org::Eclipse::Swt::Custom, :StyleRange
      include_const ::Org::Eclipse::Swt::Graphics, :Color
      include_const ::Org::Eclipse::Swt::Graphics, :Font
      include_const ::Org::Eclipse::Swt::Graphics, :Image
      include_const ::Org::Eclipse::Swt::Graphics, :Rectangle
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Item
      include_const ::Org::Eclipse::Swt::Widgets, :Widget
    }
  end
  
  # The ViewerCell is the JFace representation of a cell entry in a ViewerRow.
  # 
  # @since 3.3
  class ViewerCell 
    include_class_members ViewerCellImports
    
    attr_accessor :column_index
    alias_method :attr_column_index, :column_index
    undef_method :column_index
    alias_method :attr_column_index=, :column_index=
    undef_method :column_index=
    
    attr_accessor :row
    alias_method :attr_row, :row
    undef_method :row
    alias_method :attr_row=, :row=
    undef_method :row=
    
    attr_accessor :element
    alias_method :attr_element, :element
    undef_method :element
    alias_method :attr_element=, :element=
    undef_method :element=
    
    class_module.module_eval {
      # Constant denoting the cell above current one (value is 1).
      
      def above
        defined?(@@above) ? @@above : @@above= 1
      end
      alias_method :attr_above, :above
      
      def above=(value)
        @@above = value
      end
      alias_method :attr_above=, :above=
      
      # Constant denoting the cell below current one (value is 2).
      
      def below
        defined?(@@below) ? @@below : @@below= 1 << 1
      end
      alias_method :attr_below, :below
      
      def below=(value)
        @@below = value
      end
      alias_method :attr_below=, :below=
      
      # Constant denoting the cell to the left of the current one (value is 4).
      
      def left
        defined?(@@left) ? @@left : @@left= 1 << 2
      end
      alias_method :attr_left, :left
      
      def left=(value)
        @@left = value
      end
      alias_method :attr_left=, :left=
      
      # Constant denoting the cell to the right of the current one (value is 8).
      
      def right
        defined?(@@right) ? @@right : @@right= 1 << 3
      end
      alias_method :attr_right, :right
      
      def right=(value)
        @@right = value
      end
      alias_method :attr_right=, :right=
    }
    
    typesig { [ViewerRow, ::Java::Int, Object] }
    # Create a new instance of the receiver on the row.
    # 
    # @param row
    # @param columnIndex
    def initialize(row, column_index, element)
      @column_index = 0
      @row = nil
      @element = nil
      @row = row
      @column_index = column_index
      @element = element
    end
    
    typesig { [] }
    # Get the index of the cell.
    # 
    # @return the index
    def get_column_index
      return @column_index
    end
    
    typesig { [] }
    # Get the bounds of the cell.
    # 
    # @return {@link Rectangle}
    def get_bounds
      return @row.get_bounds(@column_index)
    end
    
    typesig { [] }
    # Get the element this row represents.
    # 
    # @return {@link Object}
    def get_element
      if (!(@element).nil?)
        return @element
      end
      if (!(@row).nil?)
        return @row.get_element
      end
      return nil
    end
    
    typesig { [] }
    # Return the text for the cell.
    # 
    # @return {@link String}
    def get_text
      return @row.get_text(@column_index)
    end
    
    typesig { [] }
    # Return the Image for the cell.
    # 
    # @return {@link Image} or <code>null</code>
    def get_image
      return @row.get_image(@column_index)
    end
    
    typesig { [Color] }
    # Set the background color of the cell.
    # 
    # @param background
    def set_background(background)
      @row.set_background(@column_index, background)
    end
    
    typesig { [Color] }
    # Set the foreground color of the cell.
    # 
    # @param foreground
    def set_foreground(foreground)
      @row.set_foreground(@column_index, foreground)
    end
    
    typesig { [Font] }
    # Set the font of the cell.
    # 
    # @param font
    def set_font(font)
      @row.set_font(@column_index, font)
    end
    
    typesig { [String] }
    # Set the text for the cell.
    # 
    # @param text
    def set_text(text)
      @row.set_text(@column_index, text)
    end
    
    typesig { [Image] }
    # Set the Image for the cell.
    # 
    # @param image
    def set_image(image)
      @row.set_image(@column_index, image)
    end
    
    typesig { [Array.typed(StyleRange)] }
    # Set the style ranges to be applied on the text label Note: Requires
    # {@link StyledCellLabelProvider} with owner draw enabled.
    # 
    # @param styleRanges
    # the styled ranges
    # 
    # @since 3.4
    def set_style_ranges(style_ranges)
      @row.set_style_ranges(@column_index, style_ranges)
    end
    
    typesig { [] }
    # Returns the style ranges to be applied on the text label or
    # <code>null</code> if no style ranges have been set.
    # 
    # @return styleRanges the styled ranges
    # 
    # @since 3.4
    def get_style_ranges
      return @row.get_style_ranges(@column_index)
    end
    
    typesig { [::Java::Int] }
    # Set the columnIndex.
    # 
    # @param column
    def set_column(column)
      @column_index = column
    end
    
    typesig { [ViewerRow, ::Java::Int, Object] }
    # Set the row to rowItem and the columnIndex to column.
    # 
    # @param rowItem
    # @param column
    def update(row_item, column, element)
      @row = row_item
      @column_index = column
      @element = element
    end
    
    typesig { [] }
    # Return the item for the receiver.
    # 
    # @return {@link Item}
    def get_item
      return @row.get_item
    end
    
    typesig { [] }
    # Get the control for this cell.
    # 
    # @return {@link Control}
    def get_control
      return @row.get_control
    end
    
    typesig { [] }
    # Get the current index. This can be different from the original index when
    # columns are reordered
    # 
    # @return the current index (as shown in the UI)
    # @since 3.4
    def get_visual_index
      return @row.get_visual_index(get_column_index)
    end
    
    typesig { [::Java::Int, ::Java::Boolean] }
    # Returns the specified neighbor of this cell, or <code>null</code> if no
    # neighbor exists in the given direction. Direction constants can be
    # combined by bitwise OR; for example, this method will return the cell to
    # the upper-left of the current cell by passing {@link #ABOVE} |
    # {@link #LEFT}. If <code>sameLevel</code> is <code>true</code>, only cells
    # in sibling rows (under the same parent) will be considered.
    # 
    # @param directionMask
    # the direction mask used to identify the requested neighbor
    # cell
    # @param sameLevel
    # if <code>true</code>, only consider cells from sibling rows
    # @return the requested neighbor cell, or <code>null</code> if not found
    def get_neighbor(direction_mask, same_level)
      row = nil
      if (((direction_mask & self.attr_above)).equal?(self.attr_above))
        row = @row.get_neighbor(ViewerRow::ABOVE, same_level)
      else
        if (((direction_mask & self.attr_below)).equal?(self.attr_below))
          row = @row.get_neighbor(ViewerRow::BELOW, same_level)
        else
          row = @row
        end
      end
      if (!(row).nil?)
        column_index = 0
        column_index = get_visual_index
        modifier = 0
        if (((direction_mask & self.attr_left)).equal?(self.attr_left))
          modifier = -1
        else
          if (((direction_mask & self.attr_right)).equal?(self.attr_right))
            modifier = 1
          end
        end
        column_index += modifier
        if (column_index >= 0 && column_index < row.get_column_count)
          cell = row.get_cell_at_visual_index(column_index)
          if (!(cell).nil?)
            while (!(cell).nil? && column_index < row.get_column_count - 1 && column_index > 0)
              if (cell.is_visible)
                break
              end
              column_index += modifier
              cell = row.get_cell_at_visual_index(column_index)
              if ((cell).nil?)
                break
              end
            end
          end
          return cell
        end
      end
      return nil
    end
    
    typesig { [] }
    # @return the row
    def get_viewer_row
      return @row
    end
    
    typesig { [] }
    # The location and bounds of the area where the text is drawn depends on
    # various things (image displayed, control with SWT.CHECK)
    # 
    # @return The bounds of the of the text area. May return <code>null</code>
    # if the underlying widget implementation doesn't provide this
    # information
    # @since 3.4
    def get_text_bounds
      return @row.get_text_bounds(@column_index)
    end
    
    typesig { [] }
    # Returns the location and bounds of the area where the image is drawn
    # 
    # @return The bounds of the of the image area. May return <code>null</code>
    # if the underlying widget implementation doesn't provide this
    # information
    # @since 3.4
    def get_image_bounds
      return @row.get_image_bounds(@column_index)
    end
    
    typesig { [] }
    # Gets the foreground color of the cell.
    # 
    # @return the foreground of the cell or <code>null</code> for the default
    # foreground
    # 
    # @since 3.4
    def get_foreground
      return @row.get_foreground(@column_index)
    end
    
    typesig { [] }
    # Gets the background color of the cell.
    # 
    # @return the background of the cell or <code>null</code> for the default
    # background
    # 
    # @since 3.4
    def get_background
      return @row.get_background(@column_index)
    end
    
    typesig { [] }
    # Gets the font of the cell.
    # 
    # @return the font of the cell or <code>null</code> for the default font
    # 
    # @since 3.4
    def get_font
      return @row.get_font(@column_index)
    end
    
    typesig { [] }
    # (non-Javadoc)
    # 
    # @see java.lang.Object#hashCode()
    def hash_code
      prime = 31
      result = 1
      result = prime * result + @column_index
      result = prime * result + (((@row).nil?) ? 0 : @row.hash_code)
      return result
    end
    
    typesig { [Object] }
    # (non-Javadoc)
    # 
    # @see java.lang.Object#equals(java.lang.Object)
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
      if (!(@column_index).equal?(other.attr_column_index))
        return false
      end
      if ((@row).nil?)
        if (!(other.attr_row).nil?)
          return false
        end
      else
        if (!(@row == other.attr_row))
          return false
        end
      end
      return true
    end
    
    typesig { [] }
    def is_visible
      return @row.is_column_visible(@column_index)
    end
    
    typesig { [] }
    # Scroll the cell into view
    # 
    # @return true if the cell was scrolled into view
    # @since 3.5
    def scroll_into_view
      return @row.scroll_cell_into_view(@column_index)
    end
    
    private
    alias_method :initialize__viewer_cell, :initialize
  end
  
end
