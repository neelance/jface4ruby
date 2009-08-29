require "rjava"

# Copyright (c) 2006, 2009 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation (original file org.eclipse.ui.texteditor.templates.ColumnLayout)
# Tom Schindl <tom.schindl@bestsolution.at> - refactored to be widget independent (bug 171824)
# - fix for bug 178280, 184342, 184045, 208014, 214532
# Micah Hainline <micah_hainline@yahoo.com> - fix in bug: 208335
module Org::Eclipse::Jface::Layout
  module AbstractColumnLayoutImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Layout
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Jface::Util, :Policy
      include_const ::Org::Eclipse::Jface::Util, :Util
      include_const ::Org::Eclipse::Jface::Viewers, :ColumnLayoutData
      include_const ::Org::Eclipse::Jface::Viewers, :ColumnPixelData
      include_const ::Org::Eclipse::Jface::Viewers, :ColumnWeightData
      include_const ::Org::Eclipse::Jface::Viewers, :TableLayout
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Graphics, :Rectangle
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Event
      include_const ::Org::Eclipse::Swt::Widgets, :Layout
      include_const ::Org::Eclipse::Swt::Widgets, :Listener
      include_const ::Org::Eclipse::Swt::Widgets, :Scrollable
      include_const ::Org::Eclipse::Swt::Widgets, :Widget
    }
  end
  
  # The AbstractColumnLayout is a {@link Layout} used to set the size of a table
  # in a consistent way even during a resize unlike a {@link TableLayout} which
  # only sets initial sizes.
  # 
  # <p>
  # <b>You can only add the layout to a container whose only child is the
  # table/tree control you want the layouts applied to.</b>
  # </p>
  # 
  # @since 3.4
  class AbstractColumnLayout < AbstractColumnLayoutImports.const_get :Layout
    include_class_members AbstractColumnLayoutImports
    
    class_module.module_eval {
      
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
      
      const_set_lazy(:IS_GTK) { Util.is_gtk }
      const_attr_reader  :IS_GTK
      
      # Key used to restore the layout data in the columns data-slot
      # @since 3.5
      const_set_lazy(:LAYOUT_DATA) { RJava.cast_to_string(Policy::JFACE) + ".LAYOUT_DATA" }
      const_attr_reader  :LAYOUT_DATA
    }
    
    # $NON-NLS-1$
    attr_accessor :inupdate_mode
    alias_method :attr_inupdate_mode, :inupdate_mode
    undef_method :inupdate_mode
    alias_method :attr_inupdate_mode=, :inupdate_mode=
    undef_method :inupdate_mode=
    
    attr_accessor :relayout
    alias_method :attr_relayout, :relayout
    undef_method :relayout
    alias_method :attr_relayout=, :relayout=
    undef_method :relayout=
    
    attr_accessor :resize_listener
    alias_method :attr_resize_listener, :resize_listener
    undef_method :resize_listener
    alias_method :attr_resize_listener=, :resize_listener=
    undef_method :resize_listener=
    
    typesig { [Widget, ColumnLayoutData] }
    # Adds a new column of data to this table layout.
    # 
    # @param column
    # the column
    # 
    # @param data
    # the column layout data
    def set_column_data(column, data)
      if ((column.get_data(LAYOUT_DATA)).nil?)
        column.add_listener(SWT::Resize, @resize_listener)
      end
      column.set_data(LAYOUT_DATA, data)
    end
    
    typesig { [Scrollable, ::Java::Int, ::Java::Int] }
    # Compute the size of the table or tree based on the ColumnLayoutData and
    # the width and height hint.
    # 
    # @param scrollable
    # the widget to compute
    # @param wHint
    # the width hint
    # @param hHint
    # the height hint
    # @return Point where x is the width and y is the height
    def compute_table_tree_size(scrollable, w_hint, h_hint)
      result = scrollable.compute_size(w_hint, h_hint)
      width = 0
      size = get_column_count(scrollable)
      i = 0
      while i < size
        layout_data = get_layout_data(scrollable, i)
        if (layout_data.is_a?(ColumnPixelData))
          col = layout_data
          width += col.attr_width
          if (col.attr_add_trim)
            width += get_column_trim
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
    
    typesig { [Scrollable, ::Java::Int, Rectangle, ::Java::Boolean] }
    # Layout the scrollable based on the supplied width and area. Only increase
    # the size of the scrollable if increase is <code>true</code>.
    # 
    # @param scrollable
    # @param width
    # @param area
    # @param increase
    def layout_table_tree(scrollable, width, area, increase)
      number_of_columns = get_column_count(scrollable)
      widths = Array.typed(::Java::Int).new(number_of_columns) { 0 }
      weight_column_indices = Array.typed(::Java::Int).new(number_of_columns) { 0 }
      number_of_weight_columns = 0
      fixed_width = 0
      total_weight = 0
      # First calc space occupied by fixed columns
      i = 0
      while i < number_of_columns
        col = get_layout_data(scrollable, i)
        if (col.is_a?(ColumnPixelData))
          cpd = col
          pixels = cpd.attr_width
          if (cpd.attr_add_trim)
            pixels += get_column_trim
          end
          widths[i] = pixels
          fixed_width += pixels
        else
          if (col.is_a?(ColumnWeightData))
            cw = col
            weight_column_indices[number_of_weight_columns] = i
            number_of_weight_columns += 1
            total_weight += cw.attr_weight
          else
            Assert.is_true(false, "Unknown column layout data") # $NON-NLS-1$
          end
        end
        i += 1
      end
      recalculate = false
      begin
        recalculate = false
        i_ = 0
        while i_ < number_of_weight_columns
          col_index = weight_column_indices[i_]
          cw = get_layout_data(scrollable, col_index)
          min_width = cw.attr_minimum_width
          allowed_width = (total_weight).equal?(0) ? 0 : (width - fixed_width) * cw.attr_weight / total_weight
          if (allowed_width < min_width)
            # if the width assigned by weight is less than the minimum,
            # then treat this column as fixed, remove it from weight
            # calculations, and recalculate other weights.
            number_of_weight_columns -= 1
            total_weight -= cw.attr_weight
            fixed_width += min_width
            widths[col_index] = min_width
            System.arraycopy(weight_column_indices, i_ + 1, weight_column_indices, i_, number_of_weight_columns - i_)
            recalculate = true
            break
          end
          widths[col_index] = allowed_width
          i_ += 1
        end
      end while (recalculate)
      if (increase)
        scrollable.set_size(area.attr_width, area.attr_height)
      end
      @inupdate_mode = true
      set_column_widths(scrollable, widths)
      scrollable.update
      @inupdate_mode = false
      if (!increase)
        scrollable.set_size(area.attr_width, area.attr_height)
      end
    end
    
    typesig { [Composite, ::Java::Int, ::Java::Int, ::Java::Boolean] }
    # (non-Javadoc)
    # 
    # @see
    # org.eclipse.swt.widgets.Layout#computeSize(org.eclipse.swt.widgets.Composite
    # , int, int, boolean)
    def compute_size(composite, w_hint, h_hint, flush_cache)
      return compute_table_tree_size(get_control(composite), w_hint, h_hint)
    end
    
    typesig { [Composite, ::Java::Boolean] }
    # (non-Javadoc)
    # 
    # @see
    # org.eclipse.swt.widgets.Layout#layout(org.eclipse.swt.widgets.Composite,
    # boolean)
    def layout(composite, flush_cache)
      area = composite.get_client_area
      table = get_control(composite)
      table_width = table.get_size.attr_x
      trim = compute_trim(area, table, table_width)
      width = Math.max(0, area.attr_width - trim)
      if (width > 1)
        layout_table_tree(table, width, area, table_width < area.attr_width)
      end
      # For the first time we need to relayout because Scrollbars are not
      # calculate appropriately
      if (@relayout)
        @relayout = false
        composite.layout
      end
    end
    
    typesig { [Rectangle, Scrollable, ::Java::Int] }
    # Compute the area required for trim.
    # 
    # @param area
    # @param scrollable
    # @param currentWidth
    # @return int
    def compute_trim(area, scrollable, current_width)
      trim = 0
      if (current_width > 1)
        trim = current_width - scrollable.get_client_area.attr_width
      else
        # initially, the table has no extend and no client area - use the
        # border with
        # plus some padding as educated guess
        trim = 2 * scrollable.get_border_width + 1
      end
      return trim
    end
    
    typesig { [Composite] }
    # Get the control being laid out.
    # 
    # @param composite
    # the composite with the layout
    # @return {@link Scrollable}
    def get_control(composite)
      return composite.get_children[0]
    end
    
    typesig { [Scrollable] }
    # Get the number of columns for the receiver.
    # 
    # @param tableTree
    # the control
    # 
    # @return the number of columns
    # @since 3.5
    def get_column_count(table_tree)
      raise NotImplementedError
    end
    
    typesig { [Scrollable, Array.typed(::Java::Int)] }
    # Set the widths of the columns.
    # 
    # @param tableTree
    # the control
    # 
    # @param widths
    # the widths of the column
    # @since 3.5
    def set_column_widths(table_tree, widths)
      raise NotImplementedError
    end
    
    typesig { [Scrollable, ::Java::Int] }
    # Get the layout data for a column
    # 
    # @param tableTree
    # the control
    # @param columnIndex
    # the column index
    # @return the layout data, might <b>not</b> null
    # @since 3.5
    def get_layout_data(table_tree, column_index)
      raise NotImplementedError
    end
    
    typesig { [Widget] }
    # Update the layout data for a column
    # 
    # @param column
    # the column
    # @since 3.5
    def update_column_data(column)
      raise NotImplementedError
    end
    
    typesig { [] }
    # The number of extra pixels taken as horizontal trim by the table column.
    # To ensure there are N pixels available for the content of the column,
    # assign N+COLUMN_TRIM for the column width.
    # 
    # @return the trim used by the columns
    # @since 3.4
    def get_column_trim
      return self.attr_column_trim
    end
    
    typesig { [] }
    def initialize
      @inupdate_mode = false
      @relayout = false
      @resize_listener = nil
      super()
      @inupdate_mode = false
      @relayout = true
      @resize_listener = Class.new(Listener.class == Class ? Listener : Object) do
        extend LocalClass
        include_class_members AbstractColumnLayout
        include Listener if Listener.class == Module
        
        typesig { [Event] }
        define_method :handle_event do |event|
          if (!self.attr_inupdate_mode)
            update_column_data(event.attr_widget)
          end
        end
        
        typesig { [] }
        define_method :initialize do
          super()
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
    end
    
    private
    alias_method :initialize__abstract_column_layout, :initialize
  end
  
end
