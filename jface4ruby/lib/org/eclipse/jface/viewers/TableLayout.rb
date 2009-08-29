require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
# Florian Priester - bug 106059
module Org::Eclipse::Jface::Viewers
  module TableLayoutImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :JavaList
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Jface::Layout, :TableColumnLayout
      include_const ::Org::Eclipse::Jface::Util, :Util
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Item
      include_const ::Org::Eclipse::Swt::Widgets, :Layout
      include_const ::Org::Eclipse::Swt::Widgets, :Table
      include_const ::Org::Eclipse::Swt::Widgets, :TableColumn
      include_const ::Org::Eclipse::Swt::Widgets, :Tree
      include_const ::Org::Eclipse::Swt::Widgets, :TreeColumn
    }
  end
  
  # A layout for a table. Call <code>addColumnData</code> to add columns.
  # The TableLayout {@link ColumnLayoutData} is only valid until the table
  # is resized. To keep the proportions constant when the table is resized
  # see {@link TableColumnLayout}
  class TableLayout < TableLayoutImports.const_get :Layout
    include_class_members TableLayoutImports
    
    class_module.module_eval {
      # The number of extra pixels taken as horizontal trim by the table column.
      # To ensure there are N pixels available for the content of the column,
      # assign N+COLUMN_TRIM for the column width.
      # 
      # @since 3.1
      
      def column_trim
        defined?(@@column_trim) ? @@column_trim : @@column_trim= 0
      end
      alias_method :attr_column_trim, :column_trim
      
      def column_trim=(value)
        @@column_trim = value
      end
      alias_method :attr_column_trim=, :column_trim=
      
      when_class_loaded do
        if (Util.is_windows)
          self.attr_column_trim = 4
        else
          if (Util.is_mac)
            self.attr_column_trim = 24
          else
            self.attr_column_trim = 3
          end
        end
      end
    }
    
    # The list of column layout data (element type:
    # <code>ColumnLayoutData</code>).
    attr_accessor :columns
    alias_method :attr_columns, :columns
    undef_method :columns
    alias_method :attr_columns=, :columns=
    undef_method :columns=
    
    # Indicates whether <code>layout</code> has yet to be called.
    attr_accessor :first_time
    alias_method :attr_first_time, :first_time
    undef_method :first_time
    alias_method :attr_first_time=, :first_time=
    undef_method :first_time=
    
    typesig { [] }
    # Creates a new table layout.
    def initialize
      @columns = nil
      @first_time = false
      super()
      @columns = ArrayList.new
      @first_time = true
    end
    
    typesig { [ColumnLayoutData] }
    # Adds a new column of data to this table layout.
    # 
    # @param data
    # the column layout data
    def add_column_data(data)
      @columns.add(data)
    end
    
    typesig { [Composite, ::Java::Int, ::Java::Int, ::Java::Boolean] }
    # (non-Javadoc) Method declared on Layout.
    def compute_size(c, w_hint, h_hint, flush)
      if (!(w_hint).equal?(SWT::DEFAULT) && !(h_hint).equal?(SWT::DEFAULT))
        return Point.new(w_hint, h_hint)
      end
      table = c
      # To avoid recursions.
      table.set_layout(nil)
      # Use native layout algorithm
      result = table.compute_size(w_hint, h_hint, flush)
      table.set_layout(self)
      width = 0
      size_ = @columns.size
      i = 0
      while i < size_
        layout_data = @columns.get(i)
        if (layout_data.is_a?(ColumnPixelData))
          col = layout_data
          width += col.attr_width
          if (col.attr_add_trim)
            width += self.attr_column_trim
          end
        else
          if (layout_data.is_a?(ColumnWeightData))
            col = layout_data
            width += col.attr_minimum_width
          else
            Assert.is_true(false, "Unknown column layout data") # $NON-NLS-1$
          end
        end
        (i += 1)
      end
      if (width > result.attr_x)
        result.attr_x = width
      end
      return result
    end
    
    typesig { [Composite, ::Java::Boolean] }
    # (non-Javadoc) Method declared on Layout.
    def layout(c, flush)
      # Only do initial layout. Trying to maintain proportions when resizing
      # is too hard,
      # causes lots of widget flicker, causes scroll bars to appear and
      # occasionally stick around (on Windows),
      # requires hooking column resizing as well, and may not be what the
      # user wants anyway.
      if (!@first_time)
        return
      end
      width = c.get_client_area.attr_width
      # XXX: Layout is being called with an invalid value the first time
      # it is being called on Linux. This method resets the
      # Layout to null so we make sure we run it only when
      # the value is OK.
      if (width <= 1)
        return
      end
      table_columns = get_columns(c)
      size_ = Math.min(@columns.size, table_columns.attr_length)
      widths = Array.typed(::Java::Int).new(size_) { 0 }
      fixed_width = 0
      number_of_weight_columns = 0
      total_weight = 0
      # First calc space occupied by fixed columns
      i = 0
      while i < size_
        col = @columns.get(i)
        if (col.is_a?(ColumnPixelData))
          cpd = col
          pixels = cpd.attr_width
          if (cpd.attr_add_trim)
            pixels += self.attr_column_trim
          end
          widths[i] = pixels
          fixed_width += pixels
        else
          if (col.is_a?(ColumnWeightData))
            cw = col
            number_of_weight_columns += 1
            # first time, use the weight specified by the column data,
            # otherwise use the actual width as the weight
            # int weight = firstTime ? cw.weight :
            # tableColumns[i].getWidth();
            weight = cw.attr_weight
            total_weight += weight
          else
            Assert.is_true(false, "Unknown column layout data") # $NON-NLS-1$
          end
        end
        i += 1
      end
      # Do we have columns that have a weight
      if (number_of_weight_columns > 0)
        # Now distribute the rest to the columns with weight.
        rest = width - fixed_width
        total_distributed = 0
        i_ = 0
        while i_ < size_
          col = @columns.get(i_)
          if (col.is_a?(ColumnWeightData))
            cw = col
            # calculate weight as above
            # int weight = firstTime ? cw.weight :
            # tableColumns[i].getWidth();
            weight = cw.attr_weight
            pixels = (total_weight).equal?(0) ? 0 : weight * rest / total_weight
            if (pixels < cw.attr_minimum_width)
              pixels = cw.attr_minimum_width
            end
            total_distributed += pixels
            widths[i_] = pixels
          end
          (i_ += 1)
        end
        # Distribute any remaining pixels to columns with weight.
        diff = rest - total_distributed
        i__ = 0
        while diff > 0
          if ((i__).equal?(size_))
            i__ = 0
          end
          col = @columns.get(i__)
          if (col.is_a?(ColumnWeightData))
            (widths[i__] += 1)
            (diff -= 1)
          end
          (i__ += 1)
        end
      end
      @first_time = false
      i_ = 0
      while i_ < size_
        set_width(table_columns[i_], widths[i_])
        i_ += 1
      end
    end
    
    typesig { [Item, ::Java::Int] }
    # Set the width of the item.
    # 
    # @param item
    # @param width
    def set_width(item, width)
      if (item.is_a?(TreeColumn))
        (item).set_width(width)
      else
        (item).set_width(width)
      end
    end
    
    typesig { [Composite] }
    # Return the columns for the receiver.
    # 
    # @param composite
    # @return Item[]
    def get_columns(composite)
      if (composite.is_a?(Tree))
        return (composite).get_columns
      end
      return (composite).get_columns
    end
    
    private
    alias_method :initialize__table_layout, :initialize
  end
  
end
