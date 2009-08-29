require "rjava"

# Copyright (c) 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# Stefan Xenos, IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Layout
  module RowDataFactoryImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Layout
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Layout, :RowData
      include_const ::Org::Eclipse::Swt::Widgets, :Control
    }
  end
  
  # This class provides a convenient shorthand for creating and initialising
  # RowData. This offers several benefits over creating RowData the normal way:
  # 
  # <ul>
  # <li>The same factory can be used many times to create several RowData
  # instances</li>
  # <li>The setters on RowDataFactory all return "this", allowing them to be
  # chained</li>
  # </ul>
  # 
  # @since 3.5
  class RowDataFactory 
    include_class_members RowDataFactoryImports
    
    attr_accessor :data
    alias_method :attr_data, :data
    undef_method :data
    alias_method :attr_data=, :data=
    undef_method :data=
    
    typesig { [RowData] }
    # Creates a RowDataFactory that creates copies of the given RowData.
    # 
    # @param data
    # object to be copied
    def initialize(data)
      @data = nil
      @data = data
    end
    
    class_module.module_eval {
      typesig { [] }
      # Creates a new RowDataFactory initialized with the SWT defaults.
      # 
      # <p>
      # Initial values are:
      # </p>
      # 
      # <ul>
      # <li>exclude(false)</li>
      # <li>hint(SWT.DEFAULT, SWT.DEFAULT)</li>
      # </ul>
      # 
      # @return a new GridDataFactory instance
      def swt_defaults
        return RowDataFactory.new(RowData.new)
      end
      
      typesig { [RowData] }
      # Creates a new RowDataFactory that creates copies of the given RowData by
      # default.
      # 
      # @param data
      # RowData to copy
      # @return a new RowDataFactory that creates copies of the argument by
      # default
      def create_from(data)
        return RowDataFactory.new(copy_data(data))
      end
      
      typesig { [RowData] }
      # Returns a copy of the given RowData
      # 
      # @param data
      # RowData to copy
      # @return a copy of the argument
      def copy_data(data)
        new_data = RowData.new(data.attr_width, data.attr_height)
        new_data.attr_exclude = data.attr_exclude
        return new_data
      end
    }
    
    typesig { [::Java::Boolean] }
    # Instructs the GridLayout to ignore this control when performing layouts.
    # 
    # @param shouldExclude
    # true iff the control should be excluded from layouts
    # @return this
    def exclude(should_exclude)
      @data.attr_exclude = should_exclude
      return self
    end
    
    typesig { [] }
    # Creates a new GridData instance. All attributes of the GridData instance
    # will be initialised by the factory.
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
      return RowDataFactory.new(create)
    end
    
    typesig { [Control] }
    # Sets the layout data on the given control. Creates a new RowData instance
    # and assigns it to the control by calling control.setLayoutData.
    # 
    # @param control
    # control whose layout data will be initialised
    def apply_to(control)
      control.set_layout_data(create)
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Sets the width and height hints. The width and height hints override the
    # control's preferred size. If either hint is set to SWT.DEFAULT, the
    # control's preferred size is used.
    # 
    # @param xHint
    # horizontal hint (pixels), or SWT.DEFAULT to use the control's
    # preferred size
    # @param yHint
    # vertical hint (pixels), or SWT.DEFAULT to use the control's
    # preferred size
    # @return this
    def hint(x_hint, y_hint)
      @data.attr_width = x_hint
      @data.attr_height = y_hint
      return self
    end
    
    typesig { [Point] }
    # Sets the width and height hints. The width and height hints override the
    # control's preferred size. If either hint is set to SWT.DEFAULT, the
    # control's preferred size is used.
    # 
    # @param hint
    # size (pixels) to be used instead of the control's preferred
    # size. If the x or y values are set to SWT.DEFAULT, the
    # control's computeSize() method will be used to obtain that
    # dimension of the preferred size.
    # @return this
    def hint(hint)
      @data.attr_width = hint.attr_x
      @data.attr_height = hint.attr_y
      return self
    end
    
    private
    alias_method :initialize__row_data_factory, :initialize
  end
  
end
