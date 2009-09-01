require "rjava"

# Copyright (c) 2007, 2009 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# Tom Schindl <tom.schindl@bestsolution.at> - initial API and implementation
# - fix for bug 178280, 183999, 184609
# IBM Corporation - API refactoring and general maintenance
module Org::Eclipse::Jface::Layout
  module TreeColumnLayoutImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Layout
      include_const ::Org::Eclipse::Jface::Viewers, :ColumnLayoutData
      include_const ::Org::Eclipse::Jface::Viewers, :ColumnPixelData
      include_const ::Org::Eclipse::Swt::Events, :TreeEvent
      include_const ::Org::Eclipse::Swt::Events, :TreeListener
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Layout
      include_const ::Org::Eclipse::Swt::Widgets, :Scrollable
      include_const ::Org::Eclipse::Swt::Widgets, :Tree
      include_const ::Org::Eclipse::Swt::Widgets, :TreeColumn
      include_const ::Org::Eclipse::Swt::Widgets, :Widget
    }
  end
  
  # The TreeColumnLayout is the {@link Layout} used to maintain {@link TreeColumn} sizes in a
  # {@link Tree}.
  # 
  # <p>
  # <b>You can only add the {@link Layout} to a container whose <i>only</i>
  # child is the {@link Tree} control you want the {@link Layout} applied to.
  # Don't assign the layout directly the {@link Tree}</b>
  # </p>
  # 
  # @since 3.3
  class TreeColumnLayout < TreeColumnLayoutImports.const_get :AbstractColumnLayout
    include_class_members TreeColumnLayoutImports
    
    attr_accessor :add_listener
    alias_method :attr_add_listener, :add_listener
    undef_method :add_listener
    alias_method :attr_add_listener=, :add_listener=
    undef_method :add_listener=
    
    class_module.module_eval {
      const_set_lazy(:TreeLayoutListener) { Class.new do
        include_class_members TreeColumnLayout
        include TreeListener
        
        typesig { [class_self::TreeEvent] }
        def tree_collapsed(e)
          update(e.attr_widget)
        end
        
        typesig { [class_self::TreeEvent] }
        def tree_expanded(e)
          update(e.attr_widget)
        end
        
        typesig { [class_self::Tree] }
        def update(tree)
          tree.get_display.async_exec(Class.new(self.class::Runnable.class == Class ? self.class::Runnable : Object) do
            extend LocalClass
            include_class_members TreeLayoutListener
            include class_self::Runnable if class_self::Runnable.class == Module
            
            typesig { [] }
            define_method :run do
              tree.update
              tree.get_parent.layout
            end
            
            typesig { [Vararg.new(Object)] }
            define_method :initialize do |*args|
              super(*args)
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__tree_layout_listener, :initialize
      end }
      
      const_set_lazy(:Listener) { TreeLayoutListener.new }
      const_attr_reader  :Listener
    }
    
    typesig { [Composite, ::Java::Boolean] }
    def layout(composite, flush_cache)
      super(composite, flush_cache)
      if (@add_listener)
        @add_listener = false
        (get_control(composite)).add_tree_listener(Listener)
      end
    end
    
    typesig { [Scrollable] }
    # {@inheritDoc}
    # 
    # @since 3.5
    def get_column_count(tree)
      return (tree).get_column_count
    end
    
    typesig { [Scrollable, Array.typed(::Java::Int)] }
    # {@inheritDoc}
    # 
    # @since 3.5
    def set_column_widths(tree, widths)
      columns = (tree).get_columns
      i = 0
      while i < widths.attr_length
        columns[i].set_width(widths[i])
        i += 1
      end
    end
    
    typesig { [Scrollable, ::Java::Int] }
    # {@inheritDoc}
    # 
    # @since 3.5
    def get_layout_data(table_tree, column_index)
      column = (table_tree).get_column(column_index)
      return column.get_data(LAYOUT_DATA)
    end
    
    typesig { [Widget] }
    # {@inheritDoc}
    # 
    # @since 3.5
    def update_column_data(column)
      t_column = column
      t = t_column.get_parent
      if (!IS_GTK || !(t.get_column(t.get_column_count - 1)).equal?(t_column))
        t_column.set_data(LAYOUT_DATA, ColumnPixelData.new(t_column.get_width))
        layout(t.get_parent, true)
      end
    end
    
    typesig { [] }
    def initialize
      @add_listener = false
      super()
      @add_listener = true
    end
    
    private
    alias_method :initialize__tree_column_layout, :initialize
  end
  
end
