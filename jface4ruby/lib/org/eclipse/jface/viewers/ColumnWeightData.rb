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
  module ColumnWeightDataImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
      include_const ::Org::Eclipse::Core::Runtime, :Assert
    }
  end
  
  # Describes the width of a table column in terms of a weight,
  # a minimum width, and whether the column is resizable.
  # <p>
  # This class may be instantiated; it is not intended to be subclassed.
  # </p>
  # @noextend This class is not intended to be subclassed by clients.
  class ColumnWeightData < ColumnWeightDataImports.const_get :ColumnLayoutData
    include_class_members ColumnWeightDataImports
    
    class_module.module_eval {
      # Default width of a column (in pixels).
      const_set_lazy(:MINIMUM_WIDTH) { 20 }
      const_attr_reader  :MINIMUM_WIDTH
    }
    
    # The column's minimum width in pixels.
    attr_accessor :minimum_width
    alias_method :attr_minimum_width, :minimum_width
    undef_method :minimum_width
    alias_method :attr_minimum_width=, :minimum_width=
    undef_method :minimum_width=
    
    # The column's weight.
    attr_accessor :weight
    alias_method :attr_weight, :weight
    undef_method :weight
    alias_method :attr_weight=, :weight=
    undef_method :weight=
    
    typesig { [::Java::Int] }
    # Creates a resizable column width with the given weight and a default
    # minimum width.
    # 
    # @param weight the weight of the column
    def initialize(weight)
      initialize__column_weight_data(weight, true)
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Creates a resizable column width with the given weight and minimum width.
    # 
    # @param weight the weight of the column
    # @param minimumWidth the minimum width of the column in pixels
    def initialize(weight, minimum_width)
      initialize__column_weight_data(weight, minimum_width, true)
    end
    
    typesig { [::Java::Int, ::Java::Int, ::Java::Boolean] }
    # Creates a column width with the given weight and minimum width.
    # 
    # @param weight the weight of the column
    # @param minimumWidth the minimum width of the column in pixels
    # @param resizable <code>true</code> if the column is resizable,
    # and <code>false</code> if size of the column is fixed
    def initialize(weight, minimum_width, resizable)
      @minimum_width = 0
      @weight = 0
      super(resizable)
      Assert.is_true(weight >= 0)
      Assert.is_true(minimum_width >= 0)
      @weight = weight
      @minimum_width = minimum_width
    end
    
    typesig { [::Java::Int, ::Java::Boolean] }
    # Creates a column width with the given weight and a default
    # minimum width.
    # 
    # @param weight the weight of the column
    # @param resizable <code>true</code> if the column is resizable,
    # and <code>false</code> if size of the column is fixed
    def initialize(weight, resizable)
      initialize__column_weight_data(weight, MINIMUM_WIDTH, resizable)
    end
    
    private
    alias_method :initialize__column_weight_data, :initialize
  end
  
end
