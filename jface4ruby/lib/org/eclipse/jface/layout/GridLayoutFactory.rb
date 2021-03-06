require "rjava"

# Copyright (c) 2005, 2007 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
# Stefan Xenos, IBM - initial implementation, bug 178888
# Karsten Stoeckmann - bug 156982
module Org::Eclipse::Jface::Layout
  module GridLayoutFactoryImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Layout
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Graphics, :Rectangle
      include_const ::Org::Eclipse::Swt::Layout, :GridLayout
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
    }
  end
  
  # GridLayoutFactory creates and initializes grid layouts. There are two ways to use GridLayoutFactory.
  # Normally, it is used as a shorthand for writing "new GridLayout()" and initializing a bunch
  # of fields. In this case the main benefit is a more concise syntax and the ability to create more
  # than one identical GridLayout from the same factory. Changing a property of the factory will affect
  # future layouts created by the factory, but has no effect on layouts that have already been created.
  # 
  # <p>
  # GridLayoutFactory can also generate grid data for all the controls in a layout. This is done with
  # the generateLayout method. To use this feature:
  # </p>
  # 
  # <ol>
  # <li>Create the composite</li>
  # <li>Create all the controls in the composite</li>
  # <li>Call generateLayout</li>
  # </ol>
  # 
  # <p>
  # The order here is important. generateLayout must be called after all the child controls have
  # been created. generateLayout will not change any layout data that has already been attached
  # to a child control and it will not recurse into nested composites.
  # </p>
  # 
  # @since 3.2
  class GridLayoutFactory 
    include_class_members GridLayoutFactoryImports
    
    # Template layout. The factory will create copies of this layout.
    attr_accessor :l
    alias_method :attr_l, :l
    undef_method :l
    alias_method :attr_l=, :l=
    undef_method :l=
    
    typesig { [GridLayout] }
    # Creates a new GridLayoutFactory that will create copies of the given layout.
    # 
    # @param l layout to copy
    def initialize(l)
      @l = nil
      @l = l
    end
    
    class_module.module_eval {
      typesig { [GridLayout] }
      # Creates a factory that creates copies of the given layout.
      # 
      # @param l layout to copy
      # @return a new GridLayoutFactory instance that creates copies of the given layout
      def create_from(l)
        return GridLayoutFactory.new(copy_layout(l))
      end
    }
    
    typesig { [] }
    # Creates a copy of the reciever.
    # 
    # @return a copy of the reciever
    def copy
      return GridLayoutFactory.new(create)
    end
    
    class_module.module_eval {
      typesig { [] }
      # Creates a GridLayoutFactory that creates GridLayouts with the default SWT
      # values.
      # 
      # <p>
      # Initial values are:
      # </p>
      # 
      # <ul>
      # <li>numColumns(1)</li>
      # <li>margins(5,5)</li>
      # <li>extendedMargins(0,0,0,0)</li>
      # <li>spacing(5,5)</li>
      # <li>equalWidth(false)</li>
      # </ul>
      # 
      # @return a GridLayoutFactory that creates GridLayouts as though created with
      # their default constructor
      # @see #fillDefaults
      def swt_defaults
        return GridLayoutFactory.new(GridLayout.new)
      end
      
      typesig { [] }
      # Creates a GridLayoutFactory that creates GridLayouts with no margins and
      # default dialog spacing.
      # 
      # <p>
      # Initial values are:
      # </p>
      # 
      # <ul>
      # <li>numColumns(1)</li>
      # <li>margins(0,0)</li>
      # <li>extendedMargins(0,0,0,0)</li>
      # <li>spacing(LayoutConstants.getSpacing())</li>
      # <li>equalWidth(false)</li>
      # </ul>
      # 
      # @return a GridLayoutFactory that creates GridLayouts as though created with
      # their default constructor
      # @see #swtDefaults
      def fill_defaults
        layout = GridLayout.new
        layout.attr_margin_width = 0
        layout.attr_margin_height = 0
        default_spacing = LayoutConstants.get_spacing
        layout.attr_horizontal_spacing = default_spacing.attr_x
        layout.attr_vertical_spacing = default_spacing.attr_y
        return GridLayoutFactory.new(layout)
      end
    }
    
    typesig { [::Java::Boolean] }
    # Sets whether the columns should be forced to be equal width
    # 
    # @param equal true iff the columns should be forced to be equal width
    # @return this
    def equal_width(equal)
      @l.attr_make_columns_equal_width = equal
      return self
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Sets the spacing for layouts created with this factory. The spacing
    # is the distance between cells within the layout.
    # 
    # @param hSpacing horizontal spacing (pixels)
    # @param vSpacing vertical spacing (pixels)
    # @return this
    # @see #margins(Point)
    # @see #margins(int, int)
    def spacing(h_spacing, v_spacing)
      @l.attr_horizontal_spacing = h_spacing
      @l.attr_vertical_spacing = v_spacing
      return self
    end
    
    typesig { [Point] }
    # Sets the spacing for layouts created with this factory. The spacing
    # is the distance between cells within the layout.
    # 
    # @param spacing space between controls in the layout (pixels)
    # @return this
    # @see #margins(Point)
    # @see #margins(int, int)
    def spacing(spacing)
      @l.attr_horizontal_spacing = spacing.attr_x
      @l.attr_vertical_spacing = spacing.attr_y
      return self
    end
    
    typesig { [Point] }
    # Sets the margins for layouts created with this factory. The margins
    # are the distance between the outer cells and the edge of the layout.
    # 
    # @param margins margin size (pixels)
    # @return this
    # @see #spacing(Point)
    # @see #spacing(int, int)
    def margins(margins)
      @l.attr_margin_width = margins.attr_x
      @l.attr_margin_height = margins.attr_y
      return self
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Sets the margins for layouts created with this factory. The margins
    # specify the number of pixels of horizontal and vertical margin that will
    # be placed along the left/right and top/bottom edges of the layout. Note
    # that thes margins will be added to the ones specified by
    # {@link #extendedMargins(int, int, int, int)}.
    # 
    # @param width
    # margin width (pixels)
    # @param height
    # margin height (pixels)
    # @return this
    # @see #spacing(Point)
    # * @see #spacing(int, int)
    def margins(width, height)
      @l.attr_margin_width = width
      @l.attr_margin_height = height
      return self
    end
    
    typesig { [::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int] }
    # Sets the margins for layouts created with this factory. The margins
    # specify the number of pixels of horizontal and vertical margin that will
    # be placed along the left, right, top, and bottom edges of the layout.
    # Note that thes margins will be added to the ones specified by
    # {@link #margins(int, int)}.
    # 
    # @param left
    # left margin size (pixels)
    # @param right
    # right margin size (pixels)
    # @param top
    # top margin size (pixels)
    # @param bottom
    # bottom margin size (pixels)
    # @return this
    # @see #spacing(Point)
    # @see #spacing(int, int)
    # 
    # @since 3.3
    def extended_margins(left, right, top, bottom)
      @l.attr_margin_left = left
      @l.attr_margin_right = right
      @l.attr_margin_top = top
      @l.attr_margin_bottom = bottom
      return self
    end
    
    typesig { [Rectangle] }
    # Sets the margins for layouts created with this factory. The margins
    # specify the number of pixels of horizontal and vertical margin that will
    # be placed along the left, right, top, and bottom edges of the layout.
    # Note that thes margins will be added to the ones specified by
    # {@link #margins(int, int)}.
    # 
    # <code><pre>
    # // Construct a GridLayout whose left, right, top, and bottom
    # // margin sizes are 10, 5, 0, and 15 respectively
    # 
    # Rectangle margins = Geometry.createDiffRectangle(10,5,0,15);
    # GridLayoutFactory.fillDefaults().extendedMargins(margins).applyTo(composite1);
    # </pre></code>
    # 
    # @param differenceRect rectangle which, when added to the client area of the
    # layout, returns the outer area of the layout. The x and y values of
    # the rectangle correspond to the position of the bounds of the
    # layout with respect to the client area. They should be negative.
    # The width and height correspond to the relative size of the bounds
    # of the layout with respect to the client area, and should be positive.
    # @return this
    # @see #spacing(Point)
    # @see #spacing(int, int)
    # 
    # @since 3.3
    def extended_margins(difference_rect)
      @l.attr_margin_left = -difference_rect.attr_x
      @l.attr_margin_top = -difference_rect.attr_y
      @l.attr_margin_bottom = difference_rect.attr_y + difference_rect.attr_height
      @l.attr_margin_right = difference_rect.attr_x + difference_rect.attr_width
      return self
    end
    
    typesig { [::Java::Int] }
    # Sets the number of columns in the layout
    # 
    # @param numColumns number of columns in the layout
    # @return this
    def num_columns(num_columns)
      @l.attr_num_columns = num_columns
      return self
    end
    
    typesig { [] }
    # Creates a new GridLayout, and initializes it with values from the factory.
    # 
    # @return a new initialized GridLayout.
    # @see #applyTo
    def create
      return copy_layout(@l)
    end
    
    typesig { [Composite] }
    # Creates a new GridLayout and attaches it to the given composite.
    # Does not create the GridData of any of the controls in the composite.
    # 
    # @param c composite whose layout will be set
    # @see #generateLayout
    # @see #create
    # @see GridLayoutFactory
    def apply_to(c)
      c.set_layout(copy_layout(@l))
    end
    
    class_module.module_eval {
      typesig { [GridLayout] }
      # Copies the given GridLayout instance
      # 
      # @param l layout to copy
      # @return a new GridLayout
      def copy_layout(l)
        result = GridLayout.new(l.attr_num_columns, l.attr_make_columns_equal_width)
        result.attr_horizontal_spacing = l.attr_horizontal_spacing
        result.attr_margin_bottom = l.attr_margin_bottom
        result.attr_margin_height = l.attr_margin_height
        result.attr_margin_left = l.attr_margin_left
        result.attr_margin_right = l.attr_margin_right
        result.attr_margin_top = l.attr_margin_top
        result.attr_margin_width = l.attr_margin_width
        result.attr_vertical_spacing = l.attr_vertical_spacing
        return result
      end
    }
    
    typesig { [Composite] }
    # Applies this layout to the given composite, and attaches default GridData
    # to all immediate children that don't have one. The layout is generated using
    # heuristics based on the widget types. In most cases, it will create exactly the same
    # layout that would have been hardcoded by the programmer. In any situation
    # where it does not produce the desired layout, the GridData for any child can be
    # overridden by attaching the layout data before calling this method. In these cases,
    # the special-case layout data can be hardcoded and the algorithm can supply defaults
    # to the rest.
    # 
    # <p>
    # This must be called <b>AFTER</b> all of the child controls have been created and their
    # layouts attached. This method will attach a layout to the given composite. If any new
    # children are created after calling this method, their GridData must be created manually.
    # The algorithm does not recurse into child composites. To generate all the layouts in
    # a widget hierarchy, the method must be called bottom-up for each Composite.
    # </p>
    # 
    # <p>
    # All controls are made to span a single cell. The algorithm tries to classify controls into one
    # of the following categories:
    # </p>
    # 
    # <ul>
    # <li>Pushbuttons: Set to a constant size large enough to fit their text and no smaller
    # than the default button size.</li>
    # <li>Wrapping with text (labels, read-only text boxes, etc.): override the preferred horizontal
    # size with the default wrapping point, fill horizontally, grab horizontal space, keep the
    # preferred vertical size</li>
    # <li>Wrapping without text (toolbars, coolbars, etc.): fill align, don't grab, use the preferred size</li>
    # <li>Horizontally scrolling controls (anything with horizontal scrollbars or where the user edits
    # text and can cursor through it from left-to-right): override the preferred horizontal size with
    # a constant, grab horizontal, fill horizontal.</li>
    # <li>Vertically scrolling controls (anything with vertical scrollbars or where the user edits
    # text and can cursor through it up and down): override the preferred vertical size with a constant,
    # grab vertical, fill vertical</li>
    # <li>Nested layouts: fill align both directions, grab along any dimension if the layout would
    # be able to expand along that dimension.</li>
    # <li>Non-wrapping non-scrollable read-only text: fill horizontally, center vertically, default size, don't grab </li>
    # <li>Non-wrapping non-scrollable non-text: fill both, default size, don't grab</li>
    # </ul>
    # 
    # @param c composite whose layout will be generated
    def generate_layout(c)
      apply_to(c)
      LayoutGenerator.generate_layout(c)
    end
    
    private
    alias_method :initialize__grid_layout_factory, :initialize
  end
  
end
