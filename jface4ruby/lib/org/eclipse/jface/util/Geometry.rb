require "rjava"

# Copyright (c) 2004, 2007 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Util
  module GeometryImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Util
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Graphics, :Rectangle
      include_const ::Org::Eclipse::Swt::Widgets, :Control
    }
  end
  
  # Contains static methods for performing simple geometric operations
  # on the SWT geometry classes.
  # 
  # @since 3.0
  class Geometry 
    include_class_members GeometryImports
    
    typesig { [] }
    # Prevent this class from being instantiated.
    # 
    # @since 3.0
    def initialize
      # This is not instantiated
    end
    
    class_module.module_eval {
      typesig { [Point, Point] }
      # Returns the square of the distance between two points.
      # <p>This is preferred over the real distance when searching
      # for the closest point, since it avoids square roots.</p>
      # 
      # @param p1 first endpoint
      # @param p2 second endpoint
      # @return the square of the distance between the two points
      # 
      # @since 3.0
      def distance_squared(p1, p2)
        term1 = p1.attr_x - p2.attr_x
        term2 = p1.attr_y - p2.attr_y
        return term1 * term1 + term2 * term2
      end
      
      typesig { [Point] }
      # Returns the magnitude of the given 2d vector (represented as a Point)
      # 
      # @param p point representing the 2d vector whose magnitude is being computed
      # @return the magnitude of the given 2d vector
      # @since 3.0
      def magnitude(p)
        return Math.sqrt(magnitude_squared(p))
      end
      
      typesig { [Point] }
      # Returns the square of the magnitude of the given 2-space vector (represented
      # using a point)
      # 
      # @param p the point whose magnitude is being computed
      # @return the square of the magnitude of the given vector
      # @since 3.0
      def magnitude_squared(p)
        return p.attr_x * p.attr_x + p.attr_y * p.attr_y
      end
      
      typesig { [Point, Point] }
      # Returns the dot product of the given vectors (expressed as Points)
      # 
      # @param p1 the first vector
      # @param p2 the second vector
      # @return the dot product of the two vectors
      # @since 3.0
      def dot_product(p1, p2)
        return p1.attr_x * p2.attr_x + p1.attr_y * p2.attr_y
      end
      
      typesig { [Point, Point] }
      # Returns a new point whose coordinates are the minimum of the coordinates of the
      # given points
      # 
      # @param p1 a Point
      # @param p2 a Point
      # @return a new point whose coordinates are the minimum of the coordinates of the
      # given points
      # @since 3.0
      def min(p1, p2)
        return Point.new(Math.min(p1.attr_x, p2.attr_x), Math.min(p1.attr_y, p2.attr_y))
      end
      
      typesig { [Point, Point] }
      # Returns a new point whose coordinates are the maximum of the coordinates
      # of the given points
      # @param p1 a Point
      # @param p2 a Point
      # @return point a new point whose coordinates are the maximum of the coordinates
      # @since 3.0
      def max(p1, p2)
        return Point.new(Math.max(p1.attr_x, p2.attr_x), Math.max(p1.attr_y, p2.attr_y))
      end
      
      typesig { [::Java::Int, ::Java::Int] }
      # Returns a vector in the given direction with the given
      # magnitude. Directions are given using SWT direction constants, and
      # the resulting vector is in the screen's coordinate system. That is,
      # the vector (0, 1) is down and the vector (1, 0) is right.
      # 
      # @param distance magnitude of the vector
      # @param direction one of SWT.TOP, SWT.BOTTOM, SWT.LEFT, or SWT.RIGHT
      # @return a point representing a vector in the given direction with the given magnitude
      # @since 3.0
      def get_direction_vector(distance, direction)
        case (direction)
        when SWT::TOP
          return Point.new(0, -distance)
        when SWT::BOTTOM
          return Point.new(0, distance)
        when SWT::LEFT
          return Point.new(-distance, 0)
        when SWT::RIGHT
          return Point.new(distance, 0)
        end
        return Point.new(0, 0)
      end
      
      typesig { [Rectangle] }
      # Returns the point in the center of the given rectangle.
      # 
      # @param rect rectangle being computed
      # @return a Point at the center of the given rectangle.
      # @since 3.0
      def center_point(rect)
        return Point.new(rect.attr_x + rect.attr_width / 2, rect.attr_y + rect.attr_height / 2)
      end
      
      typesig { [Point] }
      # Returns a copy of the given point
      # 
      # @param toCopy point to copy
      # @return a copy of the given point
      def copy(to_copy)
        return Point.new(to_copy.attr_x, to_copy.attr_y)
      end
      
      typesig { [Point, Point] }
      # Sets result equal to toCopy
      # 
      # @param result object that will be modified
      # @param toCopy object that will be copied
      # @since 3.1
      def set(result, to_copy)
        result.attr_x = to_copy.attr_x
        result.attr_y = to_copy.attr_y
      end
      
      typesig { [Rectangle, Rectangle] }
      # Sets result equal to toCopy
      # 
      # @param result object that will be modified
      # @param toCopy object that will be copied
      # @since 3.1
      def set(result, to_copy)
        result.attr_x = to_copy.attr_x
        result.attr_y = to_copy.attr_y
        result.attr_width = to_copy.attr_width
        result.attr_height = to_copy.attr_height
      end
      
      typesig { [Rectangle, Rectangle] }
      # <p>Returns a new difference Rectangle whose x, y, width, and height are equal to the difference of the corresponding
      # attributes from the given rectangles</p>
      # 
      # <p></p>
      # <b>Example: Compute the margins for a given Composite, and apply those same margins to a new GridLayout</b>
      # 
      # <code><pre>
      # // Compute the client area, in the coordinate system of the input composite's parent
      # Rectangle clientArea = Display.getCurrent().map(inputComposite,
      # inputComposite.getParent(), inputComposite.getClientArea());
      # 
      # // Compute the margins for a given Composite by subtracting the client area from the composite's bounds
      # Rectangle margins = Geometry.subtract(inputComposite.getBounds(), clientArea);
      # 
      # // Now apply these margins to a new GridLayout
      # GridLayout layout = GridLayoutFactory.fillDefaults().margins(margins).create();
      # </pre></code>
      # 
      # @param rect1 first rectangle
      # @param rect2 rectangle to subtract
      # @return the difference between the two rectangles (computed as rect1 - rect2)
      # @since 3.3
      def subtract(rect1, rect2)
        return Rectangle.new(rect1.attr_x - rect2.attr_x, rect1.attr_y - rect2.attr_y, rect1.attr_width - rect2.attr_width, rect1.attr_height - rect2.attr_height)
      end
      
      typesig { [Rectangle, Rectangle] }
      # <p>Returns a new Rectangle whose x, y, width, and height is the sum of the x, y, width, and height values of
      # both rectangles respectively.</p>
      # 
      # @param rect1 first rectangle to add
      # @param rect2 second rectangle to add
      # @return a new rectangle whose x, y, height, and width attributes are the sum of the corresponding attributes from
      # the arguments.
      # @since 3.3
      def add(rect1, rect2)
        return Rectangle.new(rect1.attr_x + rect2.attr_x, rect1.attr_y + rect2.attr_y, rect1.attr_width + rect2.attr_width, rect1.attr_height + rect2.attr_height)
      end
      
      typesig { [Point, Point] }
      # Adds two points as 2d vectors. Returns a new point whose coordinates are
      # the sum of the original two points.
      # 
      # @param point1 the first point (not null)
      # @param point2 the second point (not null)
      # @return a new point whose coordinates are the sum of the given points
      # @since 3.0
      def add(point1, point2)
        return Point.new(point1.attr_x + point2.attr_x, point1.attr_y + point2.attr_y)
      end
      
      typesig { [Point, ::Java::Int] }
      # Divides both coordinates of the given point by the given scalar.
      # 
      # @since 3.1
      # 
      # @param toDivide point to divide
      # @param scalar denominator
      # @return a new Point whose coordinates are equal to the original point divided by the scalar
      def divide(to_divide, scalar)
        return Point.new(to_divide.attr_x / scalar, to_divide.attr_y / scalar)
      end
      
      typesig { [Point, Point] }
      # Performs vector subtraction on two points. Returns a new point equal to
      # (point1 - point2).
      # 
      # @param point1 initial point
      # @param point2 vector to subtract
      # @return the difference (point1 - point2)
      # @since 3.0
      def subtract(point1, point2)
        return Point.new(point1.attr_x - point2.attr_x, point1.attr_y - point2.attr_y)
      end
      
      typesig { [Point] }
      # Swaps the X and Y coordinates of the given point.
      # 
      # @param toFlip modifies this point
      # @since 3.1
      def flip_xy(to_flip)
        temp = to_flip.attr_x
        to_flip.attr_x = to_flip.attr_y
        to_flip.attr_y = temp
      end
      
      typesig { [Rectangle] }
      # Swaps the X and Y coordinates of the given rectangle, along with the height and width.
      # 
      # @param toFlip modifies this rectangle
      # @since 3.1
      def flip_xy(to_flip)
        temp = to_flip.attr_x
        to_flip.attr_x = to_flip.attr_y
        to_flip.attr_y = temp
        temp = to_flip.attr_width
        to_flip.attr_width = to_flip.attr_height
        to_flip.attr_height = temp
      end
      
      typesig { [Rectangle, ::Java::Boolean] }
      # Returns the height or width of the given rectangle.
      # 
      # @param toMeasure rectangle to measure
      # @param width returns the width if true, and the height if false
      # @return the width or height of the given rectangle
      # @since 3.0
      def get_dimension(to_measure, width)
        if (width)
          return to_measure.attr_width
        end
        return to_measure.attr_height
      end
      
      typesig { [Point, ::Java::Boolean] }
      # Returns the x or y coordinates of the given point.
      # 
      # @param toMeasure point being measured
      # @param width if true, returns x. Otherwise, returns y.
      # @return the x or y coordinate
      # @since 3.1
      def get_coordinate(to_measure, width)
        return width ? to_measure.attr_x : to_measure.attr_y
      end
      
      typesig { [Rectangle, ::Java::Boolean] }
      # Returns the x or y coordinates of the given rectangle.
      # 
      # @param toMeasure rectangle being measured
      # @param width if true, returns x. Otherwise, returns y.
      # @return the x or y coordinate
      # @since 3.1
      def get_coordinate(to_measure, width)
        return width ? to_measure.attr_x : to_measure.attr_y
      end
      
      typesig { [Rectangle, ::Java::Boolean, ::Java::Int] }
      # Sets one dimension of the given rectangle. Modifies the given rectangle.
      # 
      # @param toSet rectangle to modify
      # @param width if true, the width is modified. If false, the height is modified.
      # @param newCoordinate new value of the width or height
      # @since 3.1
      def set_dimension(to_set, width, new_coordinate)
        if (width)
          to_set.attr_width = new_coordinate
        else
          to_set.attr_height = new_coordinate
        end
      end
      
      typesig { [Rectangle, ::Java::Boolean, ::Java::Int] }
      # Sets one coordinate of the given rectangle. Modifies the given rectangle.
      # 
      # @param toSet rectangle to modify
      # @param width if true, the x coordinate is modified. If false, the y coordinate is modified.
      # @param newCoordinate new value of the x or y coordinates
      # @since 3.1
      def set_coordinate(to_set, width, new_coordinate)
        if (width)
          to_set.attr_x = new_coordinate
        else
          to_set.attr_y = new_coordinate
        end
      end
      
      typesig { [Point, ::Java::Boolean, ::Java::Int] }
      # Sets one coordinate of the given point. Modifies the given point.
      # 
      # @param toSet point to modify
      # @param width if true, the x coordinate is modified. If false, the y coordinate is modified.
      # @param newCoordinate new value of the x or y coordinates
      # @since 3.1
      def set_coordinate(to_set, width, new_coordinate)
        if (width)
          to_set.attr_x = new_coordinate
        else
          to_set.attr_y = new_coordinate
        end
      end
      
      typesig { [Rectangle, Point, ::Java::Int] }
      # Returns the distance of the given point from a particular side of the given rectangle.
      # Returns negative values for points outside the rectangle.
      # 
      # @param rectangle a bounding rectangle
      # @param testPoint a point to test
      # @param edgeOfInterest side of the rectangle to test against
      # @return the distance of the given point from the given edge of the rectangle
      # @since 3.0
      def get_distance_from_edge(rectangle, test_point, edge_of_interest)
        case (edge_of_interest)
        when SWT::TOP
          return test_point.attr_y - rectangle.attr_y
        when SWT::BOTTOM
          return rectangle.attr_y + rectangle.attr_height - test_point.attr_y
        when SWT::LEFT
          return test_point.attr_x - rectangle.attr_x
        when SWT::RIGHT
          return rectangle.attr_x + rectangle.attr_width - test_point.attr_x
        end
        return 0
      end
      
      typesig { [Rectangle, ::Java::Int, ::Java::Int] }
      # Extrudes the given edge inward by the given distance. That is, if one side of the rectangle
      # was sliced off with a given thickness, this returns the rectangle that forms the slice. Note
      # that the returned rectangle will be inside the given rectangle if size > 0.
      # 
      # @param toExtrude the rectangle to extrude. The resulting rectangle will share three sides
      # with this rectangle.
      # @param size distance to extrude. A negative size will extrude outwards (that is, the resulting
      # rectangle will overlap the original iff this is positive).
      # @param orientation the side to extrude.  One of SWT.LEFT, SWT.RIGHT, SWT.TOP, or SWT.BOTTOM. The
      # resulting rectangle will always share this side with the original rectangle.
      # @return a rectangle formed by extruding the given side of the rectangle by the given distance.
      # @since 3.0
      def get_extruded_edge(to_extrude, size, orientation)
        bounds = Rectangle.new(to_extrude.attr_x, to_extrude.attr_y, to_extrude.attr_width, to_extrude.attr_height)
        if (!is_horizontal(orientation))
          bounds.attr_width = size
        else
          bounds.attr_height = size
        end
        case (orientation)
        when SWT::RIGHT
          bounds.attr_x = to_extrude.attr_x + to_extrude.attr_width - bounds.attr_width
        when SWT::BOTTOM
          bounds.attr_y = to_extrude.attr_y + to_extrude.attr_height - bounds.attr_height
        end
        normalize(bounds)
        return bounds
      end
      
      typesig { [::Java::Int] }
      # Returns the opposite of the given direction. That is, returns SWT.LEFT if
      # given SWT.RIGHT and visa-versa.
      # 
      # @param swtDirectionConstant one of SWT.LEFT, SWT.RIGHT, SWT.TOP, or SWT.BOTTOM
      # @return one of SWT.LEFT, SWT.RIGHT, SWT.TOP, or SWT.BOTTOM
      # @since 3.0
      def get_opposite_side(swt_direction_constant)
        case (swt_direction_constant)
        when SWT::TOP
          return SWT::BOTTOM
        when SWT::BOTTOM
          return SWT::TOP
        when SWT::LEFT
          return SWT::RIGHT
        when SWT::RIGHT
          return SWT::LEFT
        end
        return swt_direction_constant
      end
      
      typesig { [::Java::Boolean] }
      # Converts the given boolean into an SWT orientation constant.
      # 
      # @param horizontal if true, returns SWT.HORIZONTAL. If false, returns SWT.VERTICAL
      # @return SWT.HORIZONTAL or SWT.VERTICAL.
      # @since 3.0
      def get_swt_horizontal_or_vertical_constant(horizontal)
        if (horizontal)
          return SWT::HORIZONTAL
        end
        return SWT::VERTICAL
      end
      
      typesig { [::Java::Int] }
      # Returns true iff the given SWT side constant corresponds to a horizontal side
      # of a rectangle. That is, returns true for the top and bottom but false for the
      # left and right.
      # 
      # @param swtSideConstant one of SWT.TOP, SWT.BOTTOM, SWT.LEFT, or SWT.RIGHT
      # @return true iff the given side is horizontal.
      # @since 3.0
      def is_horizontal(swt_side_constant)
        return !((swt_side_constant).equal?(SWT::LEFT) || (swt_side_constant).equal?(SWT::RIGHT))
      end
      
      typesig { [Rectangle, Point] }
      # Moves the given rectangle by the given delta.
      # 
      # @param rect rectangle to move (will be modified)
      # @param delta direction vector to move the rectangle by
      # @since 3.0
      def move_rectangle(rect, delta)
        rect.attr_x += delta.attr_x
        rect.attr_y += delta.attr_y
      end
      
      typesig { [Rectangle, Rectangle] }
      # Moves each edge of the given rectangle outward by the given amount. Negative values
      # cause the rectangle to contract. Does not allow the rectangle's width or height to be
      # reduced below zero.
      # 
      # @param rect normalized rectangle to modify
      # @param differenceRect difference rectangle to be added to rect
      # @since 3.3
      def expand(rect, difference_rect)
        rect.attr_x += difference_rect.attr_x
        rect.attr_y += difference_rect.attr_y
        rect.attr_height = Math.max(0, rect.attr_height + difference_rect.attr_height)
        rect.attr_width = Math.max(0, rect.attr_width + difference_rect.attr_width)
      end
      
      typesig { [::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int] }
      # <p>Returns a rectangle which, when added to another rectangle, will expand each side
      # by the given number of units.</p>
      # 
      # <p>This is commonly used to store margin sizes. For example:</p>
      # 
      # <code><pre>
      # // Expands the left, right, top, and bottom
      # // of the given control by 10, 5, 1, and 15 units respectively
      # 
      # Rectangle margins = Geometry.createDifferenceRect(10,5,1,15);
      # Rectangle bounds = someControl.getBounds();
      # someControl.setBounds(Geometry.add(bounds, margins));
      # </pre></code>
      # 
      # @param left distance to expand the left side (negative values move the edge inward)
      # @param right distance to expand the right side (negative values move the edge inward)
      # @param top distance to expand the top (negative values move the edge inward)
      # @param bottom distance to expand the bottom (negative values move the edge inward)
      # 
      # @return a difference rectangle that, when added to another rectangle, will cause each
      # side to expand by the given number of units
      # @since 3.3
      def create_diff_rectangle(left, right, top, bottom)
        return Rectangle.new(-left, -top, left + right, top + bottom)
      end
      
      typesig { [Rectangle, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int] }
      # Moves each edge of the given rectangle outward by the given amount. Negative values
      # cause the rectangle to contract. Does not allow the rectangle's width or height to be
      # reduced below zero.
      # 
      # @param rect normalized rectangle to modify
      # @param left distance to move the left edge outward (negative values move the edge inward)
      # @param right distance to move the right edge outward (negative values move the edge inward)
      # @param top distance to move the top edge outward (negative values move the edge inward)
      # @param bottom distance to move the bottom edge outward (negative values move the edge inward)
      # @since 3.1
      def expand(rect, left, right, top, bottom)
        rect.attr_x -= left
        rect.attr_width = Math.max(0, rect.attr_width + left + right)
        rect.attr_y -= top
        rect.attr_height = Math.max(0, rect.attr_height + top + bottom)
      end
      
      typesig { [Rectangle] }
      # Normalizes the given rectangle. That is, any rectangle with
      # negative width or height becomes a rectangle with positive
      # width or height that extends to the upper-left of the original
      # rectangle.
      # 
      # @param rect rectangle to modify
      # @since 3.0
      def normalize(rect)
        if (rect.attr_width < 0)
          rect.attr_width = -rect.attr_width
          rect.attr_x -= rect.attr_width
        end
        if (rect.attr_height < 0)
          rect.attr_height = -rect.attr_height
          rect.attr_y -= rect.attr_height
        end
      end
      
      typesig { [Control, Rectangle] }
      # Converts the given rectangle from display coordinates to the local coordinate system
      # of the given object into display coordinates.
      # 
      # @param coordinateSystem local coordinate system being converted to
      # @param toConvert rectangle to convert
      # @return a rectangle in control coordinates
      # @since 3.0
      def to_control(coordinate_system, to_convert)
        return (coordinate_system.get_display.map(nil, coordinate_system, to_convert))
      end
      
      typesig { [Control, Rectangle] }
      # Converts the given rectangle from the local coordinate system of the given object
      # into display coordinates.
      # 
      # @param coordinateSystem local coordinate system being converted from
      # @param toConvert rectangle to convert
      # @return a rectangle in display coordinates
      # @since 3.0
      def to_display(coordinate_system, to_convert)
        return (coordinate_system.get_display.map(coordinate_system, nil, to_convert))
      end
      
      typesig { [Rectangle, Point] }
      # Determines where the given point lies with respect to the given rectangle.
      # Returns a combination of SWT.LEFT, SWT.RIGHT, SWT.TOP, and SWT.BOTTOM, combined
      # with bitwise or (for example, returns SWT.TOP | SWT.LEFT if the point is to the
      # upper-left of the rectangle). Returns 0 if the point lies within the rectangle.
      # Positions are in screen coordinates (ie: a point is to the upper-left of the
      # rectangle if its x and y coordinates are smaller than any point in the rectangle)
      # 
      # @param boundary normalized boundary rectangle
      # @param toTest point whose relative position to the rectangle is being computed
      # @return one of SWT.LEFT | SWT.TOP, SWT.TOP, SWT.RIGHT | SWT.TOP, SWT.LEFT, 0,
      # SWT.RIGHT, SWT.LEFT | SWT.BOTTOM, SWT.BOTTOM, SWT.RIGHT | SWT.BOTTOM
      # @since 3.0
      def get_relative_position(boundary, to_test)
        result = 0
        if (to_test.attr_x < boundary.attr_x)
          result |= SWT::LEFT
        else
          if (to_test.attr_x >= boundary.attr_x + boundary.attr_width)
            result |= SWT::RIGHT
          end
        end
        if (to_test.attr_y < boundary.attr_y)
          result |= SWT::TOP
        else
          if (to_test.attr_y >= boundary.attr_y + boundary.attr_height)
            result |= SWT::BOTTOM
          end
        end
        return result
      end
      
      typesig { [Rectangle, Point] }
      # Returns the distance from the point to the nearest edge of the given
      # rectangle. Returns negative values if the point lies outside the rectangle.
      # 
      # @param boundary rectangle to test
      # @param toTest point to test
      # @return the distance between the given point and the nearest edge of the rectangle.
      # Returns positive values for points inside the rectangle and negative values for points
      # outside the rectangle.
      # @since 3.1
      def get_distance_from(boundary, to_test)
        side = get_closest_side(boundary, to_test)
        return get_distance_from_edge(boundary, to_test, side)
      end
      
      typesig { [Rectangle, Point] }
      # Returns the edge of the given rectangle is closest to the given
      # point.
      # 
      # @param boundary rectangle to test
      # @param toTest point to compare
      # @return one of SWT.LEFT, SWT.RIGHT, SWT.TOP, or SWT.BOTTOM
      # 
      # @since 3.0
      def get_closest_side(boundary, to_test)
        sides = Array.typed(::Java::Int).new([SWT::LEFT, SWT::RIGHT, SWT::TOP, SWT::BOTTOM])
        closest_side = SWT::LEFT
        closest_distance = JavaInteger::MAX_VALUE
        idx = 0
        while idx < sides.attr_length
          side = sides[idx]
          distance = get_distance_from_edge(boundary, to_test, side)
          if (distance < closest_distance)
            closest_distance = distance
            closest_side = side
          end
          idx += 1
        end
        return closest_side
      end
      
      typesig { [Rectangle] }
      # Returns a copy of the given rectangle
      # 
      # @param toCopy rectangle to copy
      # @return a copy of the given rectangle
      # @since 3.0
      def copy(to_copy)
        return Rectangle.new(to_copy.attr_x, to_copy.attr_y, to_copy.attr_width, to_copy.attr_height)
      end
      
      typesig { [Rectangle] }
      # Returns the size of the rectangle, as a Point
      # 
      # @param rectangle rectangle whose size is being computed
      # @return the size of the given rectangle
      # @since 3.0
      def get_size(rectangle)
        return Point.new(rectangle.attr_width, rectangle.attr_height)
      end
      
      typesig { [Rectangle, Point] }
      # Sets the size of the given rectangle to the given size
      # 
      # @param rectangle rectangle to modify
      # @param newSize new size of the rectangle
      # @since 3.0
      def set_size(rectangle, new_size)
        rectangle.attr_width = new_size.attr_x
        rectangle.attr_height = new_size.attr_y
      end
      
      typesig { [Rectangle, Point] }
      # Sets the x,y position of the given rectangle. For a normalized
      # rectangle (a rectangle with positive width and height), this will
      # be the upper-left corner of the rectangle.
      # 
      # @param rectangle rectangle to modify
      # @param newLocation new location of the rectangle
      # 
      # @since 3.0
      def set_location(rectangle, new_location)
        rectangle.attr_x = new_location.attr_x
        rectangle.attr_y = new_location.attr_y
      end
      
      typesig { [Rectangle] }
      # Returns the x,y position of the given rectangle. For normalized rectangles
      # (rectangles with positive width and height), this is the upper-left
      # corner of the rectangle.
      # 
      # @param toQuery rectangle to query
      # @return a Point containing the x,y position of the rectangle
      # 
      # @since 3.0
      def get_location(to_query)
        return Point.new(to_query.attr_x, to_query.attr_y)
      end
      
      typesig { [Point, Point] }
      # Returns a new rectangle with the given position and dimensions, expressed
      # as points.
      # 
      # @param position the (x,y) position of the rectangle
      # @param size the size of the new rectangle, where (x,y) -> (width, height)
      # @return a new Rectangle with the given position and size
      # 
      # @since 3.0
      def create_rectangle(position, size)
        return Rectangle.new(position.attr_x, position.attr_y, size.attr_x, size.attr_y)
      end
      
      typesig { [Rectangle, Rectangle] }
      # Repositions the 'inner' rectangle to lie completely within the bounds of the 'outer'
      # rectangle if possible. One use for this is to ensure that, when setting a control's bounds,
      # that they will always lie within its parent's client area (to avoid clipping).
      # 
      # @param inner The 'inner' rectangle to be repositioned (should be smaller than the 'outer' rectangle)
      # @param outer The 'outer' rectangle
      def move_inside(inner, outer)
        # adjust X
        if (inner.attr_x < outer.attr_x)
          inner.attr_x = outer.attr_x
        end
        if ((inner.attr_x + inner.attr_width) > (outer.attr_x + outer.attr_width))
          inner.attr_x -= (inner.attr_x + inner.attr_width) - (outer.attr_x + outer.attr_width)
        end
        # Adjust Y
        if (inner.attr_y < outer.attr_y)
          inner.attr_y = outer.attr_y
        end
        if ((inner.attr_y + inner.attr_height) > (outer.attr_y + outer.attr_height))
          inner.attr_y -= (inner.attr_y + inner.attr_height) - (outer.attr_y + outer.attr_height)
        end
      end
    }
    
    private
    alias_method :initialize__geometry, :initialize
  end
  
end
