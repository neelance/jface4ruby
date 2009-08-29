require "rjava"

# Copyright (c) 2005, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
# Stefan Xenos, IBM - initial implementation, bug 178888
module Org::Eclipse::Jface::Layout
  module GridDataFactoryImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Layout
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Layout, :GridData
      include_const ::Org::Eclipse::Swt::Widgets, :Control
    }
  end
  
  # This class provides a convienient shorthand for creating and initializing
  # GridData. This offers several benefits over creating GridData normal way:
  # 
  # <ul>
  # <li>The same factory can be used many times to create several GridData instances</li>
  # <li>The setters on GridDataFactory all return "this", allowing them to be chained</li>
  # <li>GridDataFactory uses vector setters (it accepts Points), making it easy to
  # set X and Y values together</li>
  # </ul>
  # 
  # <p>
  # GridDataFactory instances are created using one of the static methods on this class.
  # </p>
  # 
  # <p>
  # Example usage:
  # </p>
  # <code><pre>
  # 
  # ////////////////////////////////////////////////////////////
  # // Example 1: Typical grid data for a non-wrapping label
  # 
  # // GridDataFactory version
  # GridDataFactory.fillDefaults().applyTo(myLabel);
  # 
  # // Equivalent SWT version
  # GridData labelData = new GridData(GridData.HORIZONTAL_ALIGN_FILL | GridData.VERTICAL_ALIGN_FILL);
  # myLabel.setLayoutData(labelData);
  # 
  # ///////////////////////////////////////////////////////////
  # // Example 2: Typical grid data for a wrapping label
  # 
  # // GridDataFactory version
  # GridDataFactory.fillDefaults()
  # .align(SWT.FILL, SWT.CENTER)
  # .hint(150, SWT.DEFAULT)
  # .grab(true, false)
  # .applyTo(wrappingLabel);
  # 
  # // Equivalent SWT version
  # GridData wrappingLabelData = new GridData(GridData.FILL_HORIZONTAL | GridData.VERTICAL_ALIGN_CENTER);
  # wrappingLabelData.minimumWidth = 1;
  # wrappingLabelData.widthHint = 150;
  # wrappingLabel.setLayoutData(wrappingLabelData);
  # 
  # //////////////////////////////////////////////////////////////
  # // Example 3: Typical grid data for a scrollable control (a list box, tree, table, etc.)
  # 
  # // GridDataFactory version
  # GridDataFactory.fillDefaults().grab(true, true).hint(150, 150).applyTo(listBox);
  # 
  # // Equivalent SWT version
  # GridData listBoxData = new GridData(GridData.FILL_BOTH);
  # listBoxData.widthHint = 150;
  # listBoxData.heightHint = 150;
  # listBoxData.minimumWidth = 1;
  # listBoxData.minimumHeight = 1;
  # listBox.setLayoutData(listBoxData);
  # 
  # /////////////////////////////////////////////////////////////
  # // Example 4: Typical grid data for a button
  # 
  # // GridDataFactory version
  # Point preferredSize = button.computeSize(SWT.DEFAULT, SWT.DEFAULT, false);
  # Point hint = Geometry.max(LayoutConstants.getMinButtonSize(), preferredSize);
  # GridDataFactory.fillDefaults().align(SWT.FILL, SWT.CENTER).hint(hint).applyTo(button);
  # 
  # // Equivalent SWT version
  # Point preferredSize = button.computeSize(SWT.DEFAULT, SWT.DEFAULT, false);
  # Point hint = Geometry.max(LayoutConstants.getMinButtonSize(), preferredSize);
  # GridData buttonData = new GridData(GridData.HORIZONTAL_ALIGN_FILL | GridData.VERTICAL_ALIGN_CENTER);
  # buttonData.widthHint = hint.x;
  # buttonData.heightHint = hint.y;
  # button.setLayoutData(buttonData);
  # 
  # /////////////////////////////////////////////////////////////
  # // Example 5: Generated GridData
  # 
  # // Generates GridData a wrapping label that spans 2 columns
  # GridDataFactory.generate(wrappingLabel, 2, 1);
  # 
  # // Generates GridData for a listbox. and adjusts the preferred size to 300x400 pixels
  # GridDataFactory.defaultsFor(listBox).hint(300, 400).applyTo(listBox);
  # 
  # // Generates GridData equivalent to example 4
  # GridDataFactory.generate(button, 1, 1);
  # 
  # </pre></code>
  # 
  # @since 3.2
  class GridDataFactory 
    include_class_members GridDataFactoryImports
    
    attr_accessor :data
    alias_method :attr_data, :data
    undef_method :data
    alias_method :attr_data=, :data=
    undef_method :data=
    
    typesig { [GridData] }
    # Creates a GridDataFactory that creates copes of the given GridData.
    # 
    # @param d template GridData to copy
    def initialize(d)
      @data = nil
      @data = d
    end
    
    class_module.module_eval {
      typesig { [] }
      # Creates a new GridDataFactory initialized with the SWT defaults.
      # This factory will generate GridData that is equivalent to
      # "new GridData()".
      # 
      # <p>
      # Initial values are:
      # </p>
      # 
      # <ul>
      # <li>align(SWT.BEGINNING, SWT.CENTER)</li>
      # <li>exclude(false)</li>
      # <li>grab(false, false)</li>
      # <li>hint(SWT.DEFAULT, SWT.DEFAULT)</li>
      # <li>indent(0,0)</li>
      # <li>minSize(0,0)</li>
      # <li>span(1,1)</li>
      # </ul>
      # 
      # @return a new GridDataFactory instance
      # @see #fillDefaults()
      def swt_defaults
        return GridDataFactory.new(GridData.new)
      end
      
      typesig { [GridData] }
      # Creates a new GridDataFactory that creates copies of the given GridData
      # by default.
      # 
      # @param data GridData to copy
      # @return a new GridDataFactory that creates copies of the argument by default
      def create_from(data)
        return GridDataFactory.new(copy_data(data))
      end
      
      typesig { [] }
      # Creates a GridDataFactory initialized with defaults that will cause
      # the control to fill its cell. The minimum size is set to the smallest possible
      # minimum size supported by SWT. Currently, the smallest supported minimum size
      # is (1,1) so this is the default. If GridLayout ever adds support for grid data
      # with no minimum size, this will be changed to 0,0 in the future.
      # 
      # <p>
      # Initial values are:
      # </p>
      # 
      # <ul>
      # <li>align(SWT.FILL, SWT.FILL)</li>
      # <li>exclude(false)</li>
      # <li>grab(false, false)</li>
      # <li>hint(SWT.DEFAULT, SWT.DEFAULT)</li>
      # <li>indent(0,0)</li>
      # <li>minSize(1,1)</li>
      # <li>span(1,1)</li>
      # </ul>
      # 
      # @return a GridDataFactory that makes controls fill their grid by default
      # 
      # @see #swtDefaults()
      def fill_defaults
        data = GridData.new
        data.attr_minimum_width = 1
        data.attr_minimum_height = 1
        data.attr_horizontal_alignment = SWT::FILL
        data.attr_vertical_alignment = SWT::FILL
        return GridDataFactory.new(data)
      end
      
      typesig { [Control] }
      # Returns a GridDataFactory initialized with heuristicly generated defaults for the given control.
      # To be precise, this method picks the default values that GridLayoutFactory.generateLayout
      # would have assigned to the control. Does not attach GridData to the control. Callers must
      # additionally call applyTo(theControl) if they wish to use the generated values.
      # 
      # <p>
      # This method is intended for situations where generateLayout is generating layout data
      # for a particular control that is not quite right for the desired layout.
      # This allows callers to start with the generated values and tweak one or two settings
      # before applying the GridData to the control.
      # </p>
      # 
      # @see GridLayoutFactory#generateLayout(org.eclipse.swt.widgets.Composite)
      # @param theControl
      # @return a GridLayoutFactory initialized with defaults that GridLayoutFactory would have
      # @since 3.3
      def defaults_for(the_control)
        return LayoutGenerator.defaults_for(the_control)
      end
      
      typesig { [Control, ::Java::Int, ::Java::Int] }
      # Generates layout data to the given control, given the number of cells
      # spanned by the control. Attaches a GridData to the control. This method
      # allows generated layout data to be used with controls that span multiple cells.
      # <p>
      # The generated layout data is the same as what would be generated by
      # GridLayoutFactory.generateLayout, except that the span is configurable
      # </p>
      # 
      # @see GridLayoutFactory#generateLayout(org.eclipse.swt.widgets.Composite)
      # @param theControl
      # @param hSpan number of columns spanned by the control
      # @param vSpan number of rows spanned by the control
      # @since 3.3
      def generate(the_control, h_span, v_span)
        defaults_for(the_control).span(h_span, v_span).apply_to(the_control)
      end
      
      typesig { [Control, Point] }
      # Generates layout data to the given control, given the number of cells
      # spanned by the control. Attaches GridData to the control. This method
      # allows generated layout data to be used with controls that span multiple cells.
      # <p>
      # The generated layout data is the same as what would be generated by
      # GridLayoutFactory.generateLayout, except that the span is configurable
      # </p>
      # 
      # @see GridLayoutFactory#generateLayout(org.eclipse.swt.widgets.Composite)
      # @param theControl
      # @param span The x coordinate indicates the number of
      # columns spanned, and the y coordinate indicates the number of rows.
      # @since 3.3
      def generate(the_control, span)
        defaults_for(the_control).span(span).apply_to(the_control)
      end
    }
    
    typesig { [::Java::Int, ::Java::Int] }
    # Sets the GridData span. The span controls how many cells
    # are filled by the control.
    # 
    # @param hSpan number of columns spanned by the control
    # @param vSpan number of rows spanned by the control
    # @return this
    def span(h_span, v_span)
      @data.attr_horizontal_span = h_span
      @data.attr_vertical_span = v_span
      return self
    end
    
    typesig { [Point] }
    # Sets the GridData span. The span controls how many cells
    # are filled by the control.
    # 
    # @param span the new span. The x coordinate indicates the number of
    # columns spanned, and the y coordinate indicates the number of rows.
    # @return this
    def span(span)
      @data.attr_horizontal_span = span.attr_x
      @data.attr_vertical_span = span.attr_y
      return self
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Sets the width and height hints. The width and height hints override
    # the control's preferred size. If either hint is set to SWT.DEFAULT,
    # the control's preferred size is used.
    # 
    # @param xHint horizontal hint (pixels), or SWT.DEFAULT to use the control's preferred size
    # @param yHint vertical hint (pixels), or SWT.DEFAULT to use the control's preferred size
    # @return this
    def hint(x_hint, y_hint)
      @data.attr_width_hint = x_hint
      @data.attr_height_hint = y_hint
      return self
    end
    
    typesig { [Point] }
    # Sets the width and height hints. The width and height hints override
    # the control's preferred size. If either hint is set to SWT.DEFAULT,
    # the control's preferred size is used.
    # 
    # @param hint size (pixels) to be used instead of the control's preferred size. If
    # the x or y values are set to SWT.DEFAULT, the control's computeSize() method will
    # be used to obtain that dimension of the preferred size.
    # @return this
    def hint(hint)
      @data.attr_width_hint = hint.attr_x
      @data.attr_height_hint = hint.attr_y
      return self
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Sets the alignment of the control within its cell.
    # 
    # @param hAlign horizontal alignment. One of SWT.BEGINNING, SWT.CENTER, SWT.END, or SWT.FILL.
    # @param vAlign vertical alignment. One of SWT.BEGINNING, SWT.CENTER, SWT.END, or SWT.FILL.
    # @return this
    def align(h_align, v_align)
      if (!(h_align).equal?(SWT::BEGINNING) && !(h_align).equal?(SWT::CENTER) && !(h_align).equal?(GridData::CENTER) && !(h_align).equal?(SWT::END_) && !(h_align).equal?(GridData::END_) && !(h_align).equal?(SWT::FILL) && !(h_align).equal?(SWT::LEFT) && !(h_align).equal?(SWT::RIGHT))
        raise IllegalArgumentException.new
      end
      if (!(v_align).equal?(SWT::BEGINNING) && !(v_align).equal?(SWT::CENTER) && !(v_align).equal?(GridData::CENTER) && !(v_align).equal?(SWT::END_) && !(v_align).equal?(GridData::END_) && !(v_align).equal?(SWT::FILL) && !(v_align).equal?(SWT::TOP) && !(v_align).equal?(SWT::BOTTOM))
        raise IllegalArgumentException.new
      end
      @data.attr_horizontal_alignment = h_align
      @data.attr_vertical_alignment = v_align
      return self
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Sets the indent of the control within the cell. Moves the position of the control
    # by the given number of pixels. Positive values move toward the lower-right, negative
    # values move toward the upper-left.
    # 
    # @param hIndent distance to move to the right (negative values move left)
    # @param vIndent distance to move down (negative values move up)
    # @return this
    def indent(h_indent, v_indent)
      @data.attr_horizontal_indent = h_indent
      @data.attr_vertical_indent = v_indent
      return self
    end
    
    typesig { [Point] }
    # Sets the indent of the control within the cell. Moves the position of the control
    # by the given number of pixels. Positive values move toward the lower-right, negative
    # values move toward the upper-left.
    # 
    # @param indent offset to move the control
    # @return this
    def indent(indent)
      @data.attr_horizontal_indent = indent.attr_x
      @data.attr_vertical_indent = indent.attr_y
      return self
    end
    
    typesig { [::Java::Boolean, ::Java::Boolean] }
    # Determines whether extra horizontal or vertical space should be allocated to
    # this control's column when the layout resizes. If any control in the column
    # is set to grab horizontal then the whole column will grab horizontal space.
    # If any control in the row is set to grab vertical then the whole row will grab
    # vertical space.
    # 
    # @param horizontal true if the control's column should grow horizontally
    # @param vertical true if the control's row should grow vertically
    # @return this
    def grab(horizontal, vertical)
      @data.attr_grab_excess_horizontal_space = horizontal
      @data.attr_grab_excess_vertical_space = vertical
      return self
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Sets the minimum size for the control. The control will not be permitted
    # to shrink below this size. Note: GridLayout treats a minimum size of 0
    # as an undocumented special value, so the smallest possible minimum size
    # is a size of 1. A minimum size of SWT.DEFAULT indicates that the result
    # of computeSize(int, int, boolean) should be used as the control's minimum
    # size.
    # 
    # 
    # @param minX minimum a value of 1 or more is a horizontal size of the control (pixels).
    # SWT.DEFAULT indicates that the control's preferred size should be used. A size
    # of 0 has special semantics defined by GridLayout.
    # @param minY minimum a value of 1 or more is a vertical size of the control (pixels). SWT.DEFAULT
    # indicates that the control's preferred size should be used. A size
    # of 0 has special semantics defined by GridLayout.
    # @return this
    def min_size(min_x, min_y)
      @data.attr_minimum_width = min_x
      @data.attr_minimum_height = min_y
      return self
    end
    
    typesig { [Point] }
    # Sets the minimum size for the control. The control will not be permitted
    # to shrink below this size. Note: GridLayout treats a minimum size of 0
    # as an undocumented special value, so the smallest possible minimum size
    # is a size of 1. A minimum size of SWT.DEFAULT indicates that the result
    # of computeSize(int, int, boolean) should be used as the control's minimum
    # size.
    # 
    # @param min minimum size of the control
    # @return this
    def min_size(min)
      @data.attr_minimum_width = min.attr_x
      @data.attr_minimum_height = min.attr_y
      return self
    end
    
    typesig { [::Java::Boolean] }
    # Instructs the GridLayout to ignore this control when performing layouts.
    # 
    # @param shouldExclude true iff the control should be excluded from layouts
    # @return this
    def exclude(should_exclude)
      @data.attr_exclude = should_exclude
      return self
    end
    
    typesig { [] }
    # Creates a new GridData instance. All attributes of the GridData instance
    # will be initialized by the factory.
    # 
    # @return a new GridData instance
    def create
      return copy_data(@data)
    end
    
    typesig { [] }
    # Creates a copy of the receiver.
    # 
    # @return a copy of the receiver
    def copy
      return GridDataFactory.new(create)
    end
    
    class_module.module_eval {
      typesig { [GridData] }
      # Returns a copy of the given GridData
      # 
      # @param data GridData to copy
      # @return a copy of the argument
      def copy_data(data)
        new_data = GridData.new(data.attr_horizontal_alignment, data.attr_vertical_alignment, data.attr_grab_excess_horizontal_space, data.attr_grab_excess_vertical_space, data.attr_horizontal_span, data.attr_vertical_span)
        new_data.attr_exclude = data.attr_exclude
        new_data.attr_height_hint = data.attr_height_hint
        new_data.attr_horizontal_indent = data.attr_horizontal_indent
        new_data.attr_minimum_height = data.attr_minimum_height
        new_data.attr_minimum_width = data.attr_minimum_width
        new_data.attr_vertical_indent = data.attr_vertical_indent
        new_data.attr_width_hint = data.attr_width_hint
        return new_data
      end
    }
    
    typesig { [Control] }
    # Sets the layout data on the given control. Creates a new GridData instance and
    # assigns it to the control by calling control.setLayoutData.
    # 
    # @param control control whose layout data will be initialized
    def apply_to(control)
      control.set_layout_data(create)
    end
    
    private
    alias_method :initialize__grid_data_factory, :initialize
  end
  
end
