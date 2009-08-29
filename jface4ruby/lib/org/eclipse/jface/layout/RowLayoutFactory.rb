require "rjava"

# Copyright (c) 2008 Micah Hainline and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# Micah Hainline - initial API and implementation
# Stefan Xenos, IBM Corporation - review, javadoc, and extendedMargins(Rectangle)
module Org::Eclipse::Jface::Layout
  module RowLayoutFactoryImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Layout
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Layout, :RowLayout
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
    }
  end
  
  # RowLayoutFactory creates and initializes row layouts. There are two ways to
  # use RowLayoutFactory. Normally, it is used as a shorthand for writing
  # "new RowLayout()" and initializing a bunch of fields. In this case the main
  # benefit is a more concise syntax and the ability to create more than one
  # identical RowLayout from the same factory. Changing a property of the factory
  # will affect future layouts created by the factory, but has no effect on
  # layouts that have already been created.
  # 
  # @since 3.5
  class RowLayoutFactory 
    include_class_members RowLayoutFactoryImports
    
    # Template layout. The factory will create copies of this layout.
    attr_accessor :layout
    alias_method :attr_layout, :layout
    undef_method :layout
    alias_method :attr_layout=, :layout=
    undef_method :layout=
    
    typesig { [RowLayout] }
    # Creates a new RowLayoutFactory that will create copies of the given
    # layout.
    # 
    # @param layout
    # layout to copy
    def initialize(layout)
      @layout = nil
      @layout = layout
    end
    
    class_module.module_eval {
      typesig { [RowLayout] }
      # Creates a factory that creates copies of the given layout.
      # 
      # @param layout
      # layout to copy
      # @return a new RowLayoutFactory instance that creates copies of the given
      # layout
      def create_from(layout)
        return RowLayoutFactory.new(copy_layout(layout))
      end
    }
    
    typesig { [] }
    # Creates a copy of the receiver.
    # 
    # @return a copy of the receiver
    def copy
      return RowLayoutFactory.new(create)
    end
    
    class_module.module_eval {
      typesig { [] }
      # Creates a RowLayoutFactory that creates RowLayouts with the default SWT
      # values.
      # 
      # <p>
      # Initial values are:
      # </p>
      # 
      # <ul>
      # <li>margins(0,0)</li>
      # <li>extendedMargins(3,3,3,3)</li>
      # <li>wrap(true)</li>
      # <li>pack(true)</li>
      # <li>fill(false)</li>
      # <li>justify(false)</li>
      # <li>spacing(3)</li>
      # </ul>
      # 
      # @return a RowLayoutFactory that creates RowLayouts as though created with
      # their default constructor
      # @see #fillDefaults
      def swt_defaults
        return RowLayoutFactory.new(RowLayout.new)
      end
      
      typesig { [] }
      # Creates a RowLayoutFactory that creates RowLayouts with no margins, fill
      # behavior, and default dialog spacing.
      # 
      # <p>
      # Initial values are:
      # </p>
      # 
      # <ul>
      # <li>margins(0,0)</li>
      # <li>extendedMargins(0,0,0,0)</li>
      # <li>wrap(true)</li>
      # <li>pack(true)</li>
      # <li>fill(false)</li>
      # <li>justify(false)</li>
      # <li>spacing(LayoutConstants.getSpacing().x</li>
      # </ul>
      # 
      # @return a RowLayoutFactory that creates RowLayouts with no margins
      # @see #swtDefaults
      def fill_defaults
        layout = RowLayout.new
        layout.attr_margin_top = 0
        layout.attr_margin_bottom = 0
        layout.attr_margin_left = 0
        layout.attr_margin_right = 0
        layout.attr_spacing = LayoutConstants.get_spacing.attr_x
        return RowLayoutFactory.new(layout)
      end
    }
    
    typesig { [::Java::Int] }
    # Sets the spacing for layouts created with this factory. The spacing is
    # the distance between items within the layout.
    # 
    # @param spacing
    # spacing (pixels)
    # @return this
    # @see #margins(Point)
    # @see #margins(int, int)
    def spacing(spacing)
      @layout.attr_spacing = spacing
      return self
    end
    
    typesig { [Point] }
    # Sets the margins for layouts created with this factory. The margins are
    # the distance between the outer cells and the edge of the layout.
    # 
    # @param margins
    # margin size (pixels)
    # @return this
    # @see #spacing(int)
    def margins(margins)
      @layout.attr_margin_width = margins.attr_x
      @layout.attr_margin_height = margins.attr_y
      return self
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Sets the margins for layouts created with this factory. The margins
    # specify the number of pixels of horizontal and vertical margin that will
    # be placed along the left/right and top/bottom edges of the layout. Note
    # that these margins will be added to the ones specified by
    # {@link #extendedMargins(int, int, int, int)}.
    # 
    # @param width
    # margin width (pixels)
    # @param height
    # margin height (pixels)
    # @return this
    # @see #spacing(int)
    def margins(width, height)
      @layout.attr_margin_width = width
      @layout.attr_margin_height = height
      return self
    end
    
    typesig { [::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int] }
    # Sets the margins for layouts created with this factory. The margins
    # specify the number of pixels of horizontal and vertical margin that will
    # be placed along the left, right, top, and bottom edges of the layout.
    # Note that these margins will be added to the ones specified by
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
    # @see #spacing(int)
    # 
    # @since 3.3
    def extended_margins(left, right, top, bottom)
      @layout.attr_margin_left = left
      @layout.attr_margin_right = right
      @layout.attr_margin_top = top
      @layout.attr_margin_bottom = bottom
      return self
    end
    
    typesig { [::Java::Boolean] }
    # Fill specifies whether the controls in a row should be all the same
    # height for horizontal layouts, or the same width for vertical layouts.
    # 
    # @param fill
    # the fill status
    # @return this
    def fill(fill)
      @layout.attr_fill = fill
      return self
    end
    
    typesig { [::Java::Boolean] }
    # Justify specifies whether the controls in a row should be fully
    # justified, with any extra space placed between the controls.
    # 
    # @param justify
    # the justify status
    # @return this
    def justify(justify)
      @layout.attr_justify = justify
      return self
    end
    
    typesig { [::Java::Boolean] }
    # Pack specifies whether all controls in the layout take their preferred
    # size. If pack is false, all controls will have the same size which is the
    # size required to accommodate the largest preferred height and the largest
    # preferred width of all the controls in the layout.
    # 
    # @param pack
    # the pack status
    # @return this
    def pack(pack)
      @layout.attr_pack = pack
      return self
    end
    
    typesig { [::Java::Boolean] }
    # Wrap specifies whether a control will be wrapped to the next row if there
    # is insufficient space on the current row.
    # 
    # @param wrap
    # the wrap status
    # @return this
    def wrap(wrap)
      @layout.attr_wrap = wrap
      return self
    end
    
    typesig { [::Java::Int] }
    # type specifies whether the layout places controls in rows or columns.
    # 
    # Possible values are:
    # <ul>
    # <li>HORIZONTAL: Position the controls horizontally from left to right</li>
    # <li>VERTICAL: Position the controls vertically from top to bottom</li>
    # </ul>
    # 
    # @param type
    # One of SWT.HORIZONTAL or SWT.VERTICAL
    # @return this
    # 
    # @throws IllegalArgumentException
    # if type is not one of HORIZONTAL or VERTICAL
    def type(type)
      if (!(type).equal?(SWT::HORIZONTAL) && !(type).equal?(SWT::VERTICAL))
        raise IllegalArgumentException.new
      end
      @layout.attr_type = type
      return self
    end
    
    typesig { [] }
    # Creates a new RowLayout, and initializes it with values from the factory.
    # 
    # @return a new initialized RowLayout.
    # @see #applyTo
    def create
      return copy_layout(@layout)
    end
    
    typesig { [Composite] }
    # Creates a new RowLayout and attaches it to the given composite. Does not
    # create the rowData of any of the controls in the composite.
    # 
    # @param c
    # composite whose layout will be set
    # @see #create
    # @see RowLayoutFactory
    def apply_to(c)
      c.set_layout(copy_layout(@layout))
    end
    
    class_module.module_eval {
      typesig { [RowLayout] }
      # Copies the given RowLayout instance
      # 
      # @param layout
      # layout to copy
      # @return a new RowLayout
      def copy_layout(layout)
        result = RowLayout.new(layout.attr_type)
        result.attr_margin_bottom = layout.attr_margin_bottom
        result.attr_margin_top = layout.attr_margin_top
        result.attr_margin_left = layout.attr_margin_left
        result.attr_margin_right = layout.attr_margin_right
        result.attr_margin_height = layout.attr_margin_height
        result.attr_margin_width = layout.attr_margin_width
        result.attr_fill = layout.attr_fill
        result.attr_justify = layout.attr_justify
        result.attr_pack = layout.attr_pack
        result.attr_spacing = layout.attr_spacing
        result.attr_wrap = layout.attr_wrap
        result.attr_type = layout.attr_type
        return result
      end
    }
    
    private
    alias_method :initialize__row_layout_factory, :initialize
  end
  
end
