require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Viewers
  module ColumnPixelDataImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
      include_const ::Org::Eclipse::Core::Runtime, :Assert
    }
  end
  
  # Describes the width of a table column in pixels, and
  # whether the column is resizable.
  # <p>
  # This class may be instantiated; it is not intended to be subclassed.
  # </p>
  # @noextend This class is not intended to be subclassed by clients.
  class ColumnPixelData < ColumnPixelDataImports.const_get :ColumnLayoutData
    include_class_members ColumnPixelDataImports
    
    # The column's width in pixels.
    attr_accessor :width
    alias_method :attr_width, :width
    undef_method :width
    alias_method :attr_width=, :width=
    undef_method :width=
    
    # Whether to allocate extra width to the column to account for
    # trim taken by the column itself.
    # The default is <code>false</code> for backwards compatibility, but
    # the recommended practice is to specify <code>true</code>, and
    # specify the desired width for the content of the column, rather
    # than adding a fudge factor to the specified width.
    # 
    # @since 3.1
    attr_accessor :add_trim
    alias_method :attr_add_trim, :add_trim
    undef_method :add_trim
    alias_method :attr_add_trim=, :add_trim=
    undef_method :add_trim=
    
    typesig { [::Java::Int] }
    # Creates a resizable column width of the given number of pixels.
    # 
    # @param widthInPixels the width of column in pixels
    def initialize(width_in_pixels)
      initialize__column_pixel_data(width_in_pixels, true, false)
    end
    
    typesig { [::Java::Int, ::Java::Boolean] }
    # Creates a column width of the given number of pixels.
    # 
    # @param widthInPixels the width of column in pixels
    # @param resizable <code>true</code> if the column is resizable,
    # and <code>false</code> if size of the column is fixed
    def initialize(width_in_pixels, resizable)
      initialize__column_pixel_data(width_in_pixels, resizable, false)
    end
    
    typesig { [::Java::Int, ::Java::Boolean, ::Java::Boolean] }
    # Creates a column width of the given number of pixels.
    # 
    # @param widthInPixels
    # the width of column in pixels
    # @param resizable
    # <code>true</code> if the column is resizable, and
    # <code>false</code> if size of the column is fixed
    # @param addTrim
    # <code>true</code> to allocate extra width to the column to
    # account for trim taken by the column itself,
    # <code>false</code> to use the given width exactly
    # @since 3.1
    def initialize(width_in_pixels, resizable, add_trim)
      @width = 0
      @add_trim = false
      super(resizable)
      @add_trim = false
      Assert.is_true(width_in_pixels >= 0)
      @width = width_in_pixels
      @add_trim = add_trim
    end
    
    private
    alias_method :initialize__column_pixel_data, :initialize
  end
  
end
