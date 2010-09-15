require "rjava"

# Copyright (c) 2008, 2009 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Util
  module ConfigureColumnsImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Util
      include_const ::Org::Eclipse::Jface::Dialogs, :Dialog
      include_const ::Org::Eclipse::Jface::Layout, :GridDataFactory
      include_const ::Org::Eclipse::Jface::Layout, :GridLayoutFactory
      include_const ::Org::Eclipse::Jface::Resource, :JFaceResources
      include_const ::Org::Eclipse::Jface::Window, :IShellProvider
      include_const ::Org::Eclipse::Jface::Window, :Window
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Graphics, :Image
      include_const ::Org::Eclipse::Swt::Widgets, :Button
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Event
      include_const ::Org::Eclipse::Swt::Widgets, :Item
      include_const ::Org::Eclipse::Swt::Widgets, :Label
      include_const ::Org::Eclipse::Swt::Widgets, :Listener
      include_const ::Org::Eclipse::Swt::Widgets, :Table
      include_const ::Org::Eclipse::Swt::Widgets, :TableColumn
      include_const ::Org::Eclipse::Swt::Widgets, :TableItem
      include_const ::Org::Eclipse::Swt::Widgets, :Text
      include_const ::Org::Eclipse::Swt::Widgets, :Tree
      include_const ::Org::Eclipse::Swt::Widgets, :TreeColumn
    }
  end
  
  # Utilities for configuring columns of trees and tables in a
  # keyboard-accessible way.
  # 
  # @since 3.5
  class ConfigureColumns 
    include_class_members ConfigureColumnsImports
    
    class_module.module_eval {
      typesig { [Tree, IShellProvider] }
      # Configure the columns of the given tree in a keyboard-accessible way,
      # using the given shell provider to parent dialogs.
      # 
      # @param tree the tree
      # @param shellProvider a shell provider
      # @return <code>false</code> if the user canceled, <code>true</code>
      # otherwise
      def for_tree(tree, shell_provider)
        return (ConfigureColumnsDialog.new(shell_provider, tree).open).equal?(Window::OK)
      end
      
      typesig { [Table, IShellProvider] }
      # Configure the columns of the given tree in a keyboard-accessible way,
      # using the given shell provider to parent dialogs.
      # 
      # @param table the table
      # @param shellProvider a shell provider
      # @return <code>false</code> if the user canceled, <code>true</code>
      # otherwise
      def for_table(table, shell_provider)
        return (ConfigureColumnsDialog.new(shell_provider, table).open).equal?(Window::OK)
      end
      
      # NON-API - This class is internal.
      const_set_lazy(:ConfigureColumnsDialog) { Class.new(Dialog) do
        include_class_members ConfigureColumns
        
        attr_accessor :target_control
        alias_method :attr_target_control, :target_control
        undef_method :target_control
        alias_method :attr_target_control=, :target_control=
        undef_method :target_control=
        
        attr_accessor :column_objects
        alias_method :attr_column_objects, :column_objects
        undef_method :column_objects
        alias_method :attr_column_objects=, :column_objects=
        undef_method :column_objects=
        
        attr_accessor :table
        alias_method :attr_table, :table
        undef_method :table
        alias_method :attr_table=, :table=
        undef_method :table=
        
        attr_accessor :up_button
        alias_method :attr_up_button, :up_button
        undef_method :up_button
        alias_method :attr_up_button=, :up_button=
        undef_method :up_button=
        
        attr_accessor :down_button
        alias_method :attr_down_button, :down_button
        undef_method :down_button
        alias_method :attr_down_button=, :down_button=
        undef_method :down_button=
        
        attr_accessor :text
        alias_method :attr_text, :text
        undef_method :text
        alias_method :attr_text=, :text=
        undef_method :text=
        
        attr_accessor :moveable_columns_found
        alias_method :attr_moveable_columns_found, :moveable_columns_found
        undef_method :moveable_columns_found
        alias_method :attr_moveable_columns_found=, :moveable_columns_found=
        undef_method :moveable_columns_found=
        
        class_module.module_eval {
          const_set_lazy(:ColumnObject) { Class.new do
            local_class_in ConfigureColumnsDialog
            include_class_members ConfigureColumnsDialog
            
            attr_accessor :column
            alias_method :attr_column, :column
            undef_method :column
            alias_method :attr_column=, :column=
            undef_method :column=
            
            attr_accessor :index
            alias_method :attr_index, :index
            undef_method :index
            alias_method :attr_index=, :index=
            undef_method :index=
            
            attr_accessor :name
            alias_method :attr_name, :name
            undef_method :name
            alias_method :attr_name=, :name=
            undef_method :name=
            
            attr_accessor :image
            alias_method :attr_image, :image
            undef_method :image
            alias_method :attr_image=, :image=
            undef_method :image=
            
            attr_accessor :visible
            alias_method :attr_visible, :visible
            undef_method :visible
            alias_method :attr_visible=, :visible=
            undef_method :visible=
            
            attr_accessor :width
            alias_method :attr_width, :width
            undef_method :width
            alias_method :attr_width=, :width=
            undef_method :width=
            
            attr_accessor :moveable
            alias_method :attr_moveable, :moveable
            undef_method :moveable
            alias_method :attr_moveable=, :moveable=
            undef_method :moveable=
            
            attr_accessor :resizable
            alias_method :attr_resizable, :resizable
            undef_method :resizable
            alias_method :attr_resizable=, :resizable=
            undef_method :resizable=
            
            typesig { [class_self::Item, ::Java::Int, String, class_self::Image, ::Java::Int, ::Java::Boolean, ::Java::Boolean, ::Java::Boolean] }
            def initialize(column, index, text, image, width, moveable, resizable, visible)
              @column = nil
              @index = 0
              @name = nil
              @image = nil
              @visible = false
              @width = 0
              @moveable = false
              @resizable = false
              @column = column
              @index = index
              @name = text
              @image = image
              @width = width
              @moveable = moveable
              @resizable = resizable
              @visible = visible
            end
            
            private
            alias_method :initialize__column_object, :initialize
          end }
        }
        
        typesig { [class_self::IShellProvider, class_self::Table] }
        # NON-API - This class is internal and will be moved to another package
        # in 3.5. Creates a new dialog for configuring columns of the given
        # column viewer. The column viewer must have an underlying {@link Tree}
        # or {@link Table}, other controls are not supported.
        # 
        # @param shellProvider
        # @param table
        def initialize(shell_provider, table)
          initialize__configure_columns_dialog(shell_provider, table)
        end
        
        typesig { [class_self::IShellProvider, class_self::Tree] }
        # NON-API - This class is internal and will be moved to another package
        # in 3.5. Creates a new dialog for configuring columns of the given
        # column viewer. The column viewer must have an underlying {@link Tree}
        # or {@link Table}, other controls are not supported.
        # 
        # @param shellProvider
        # @param tree
        def initialize(shell_provider, tree)
          initialize__configure_columns_dialog(shell_provider, tree)
        end
        
        typesig { [class_self::IShellProvider, class_self::Control] }
        # @param shellProvider
        # @param control
        def initialize(shell_provider, control)
          @target_control = nil
          @column_objects = nil
          @table = nil
          @up_button = nil
          @down_button = nil
          @text = nil
          @moveable_columns_found = false
          super(shell_provider)
          @target_control = control
          @moveable_columns_found = create_column_objects
        end
        
        typesig { [] }
        def is_resizable
          return true
        end
        
        typesig { [] }
        def create
          super
          get_shell.set_text(JFaceResources.get_string("ConfigureColumnsDialog_Title")) # $NON-NLS-1$
        end
        
        typesig { [] }
        def initialize_bounds
          super
          @table.set_selection(0)
          handle_selection_changed(0)
        end
        
        typesig { [] }
        # Returns true if any of the columns is moveable (can be reordered).
        def create_column_objects
          result = true
          columns = get_viewer_columns
          c_objects = Array.typed(self.class::ColumnObject).new(columns.attr_length) { nil }
          i = 0
          while i < columns.attr_length
            c = columns[i]
            moveable = get_moveable(c)
            result = result && moveable
            c_objects[i] = self.class::ColumnObject.new_local(self, c, i, get_column_name(c), get_column_image(c), get_column_width(c), moveable, get_resizable(c), true)
            i += 1
          end
          column_order = get_column_order
          @column_objects = Array.typed(self.class::ColumnObject).new(columns.attr_length) { nil }
          i_ = 0
          while i_ < column_order.attr_length
            @column_objects[i_] = c_objects[column_order[i_]]
            i_ += 1
          end
          return result
        end
        
        typesig { [class_self::Item] }
        # @param c
        # @return
        def get_column_image(item)
          if (item.is_a?(self.class::TableColumn))
            return (item).get_image
          else
            if (item.is_a?(self.class::TreeColumn))
              return (item).get_image
            end
          end
          return nil
        end
        
        typesig { [] }
        # @return
        def get_column_order
          if (@target_control.is_a?(self.class::Table))
            return (@target_control).get_column_order
          else
            if (@target_control.is_a?(self.class::Tree))
              return (@target_control).get_column_order
            end
          end
          return Array.typed(::Java::Int).new(0) { 0 }
        end
        
        typesig { [class_self::Item] }
        # @param c
        # @return
        def get_moveable(item)
          if (item.is_a?(self.class::TableColumn))
            return (item).get_moveable
          else
            if (item.is_a?(self.class::TreeColumn))
              return (item).get_moveable
            end
          end
          return false
        end
        
        typesig { [class_self::Item] }
        # @param c
        # @return
        def get_resizable(item)
          if (item.is_a?(self.class::TableColumn))
            return (item).get_resizable
          else
            if (item.is_a?(self.class::TreeColumn))
              return (item).get_resizable
            end
          end
          return false
        end
        
        typesig { [class_self::Composite] }
        def create_dialog_area(parent)
          composite = super(parent)
          # | SWT.CHECK
          @table = self.class::Table.new(composite, SWT::BORDER | SWT::SINGLE | SWT::V_SCROLL | SWT::H_SCROLL)
          i = 0
          while i < @column_objects.attr_length
            table_item = self.class::TableItem.new(@table, SWT::NONE)
            table_item.set_text(@column_objects[i].attr_name)
            table_item.set_image(@column_objects[i].attr_image)
            table_item.set_data(@column_objects[i])
            i += 1
          end
          GridDataFactory.defaults_for(@table).span(1, @moveable_columns_found ? 3 : 1).apply_to(@table)
          if (@moveable_columns_found)
            @up_button = self.class::Button.new(composite, SWT::PUSH)
            @up_button.set_text(JFaceResources.get_string("ConfigureColumnsDialog_up")) # $NON-NLS-1$
            @up_button.add_listener(SWT::Selection, Class.new(self.class::Listener.class == Class ? self.class::Listener : Object) do
              local_class_in ConfigureColumnsDialog
              include_class_members ConfigureColumnsDialog
              include class_self::Listener if class_self::Listener.class == Module
              
              typesig { [class_self::Event] }
              define_method :handle_event do |event|
                handle_move(self.attr_table, true)
              end
              
              typesig { [Vararg.new(Object)] }
              define_method :initialize do |*args|
                super(*args)
              end
              
              private
              alias_method :initialize_anonymous, :initialize
            end.new_local(self))
            set_button_layout_data(@up_button)
            @down_button = self.class::Button.new(composite, SWT::PUSH)
            @down_button.set_text(JFaceResources.get_string("ConfigureColumnsDialog_down")) # $NON-NLS-1$
            @down_button.add_listener(SWT::Selection, Class.new(self.class::Listener.class == Class ? self.class::Listener : Object) do
              local_class_in ConfigureColumnsDialog
              include_class_members ConfigureColumnsDialog
              include class_self::Listener if class_self::Listener.class == Module
              
              typesig { [class_self::Event] }
              define_method :handle_event do |event|
                handle_move(self.attr_table, false)
              end
              
              typesig { [Vararg.new(Object)] }
              define_method :initialize do |*args|
                super(*args)
              end
              
              private
              alias_method :initialize_anonymous, :initialize
            end.new_local(self))
            set_button_layout_data(@down_button)
            # filler label
            create_label(composite, "") # $NON-NLS-1$
          end
          width_composite = self.class::Composite.new(composite, SWT::NONE)
          create_label(width_composite, JFaceResources.get_string("ConfigureColumnsDialog_WidthOfSelectedColumn")) # $NON-NLS-1$
          @text = self.class::Text.new(width_composite, SWT::SINGLE | SWT::BORDER)
          # see #initializeBounds
          @text.set_text(JavaInteger.to_s(1000))
          GridLayoutFactory.fill_defaults.num_columns(2).apply_to(width_composite)
          num_columns = @moveable_columns_found ? 2 : 1
          GridDataFactory.defaults_for(width_composite).grab(false, false).span(num_columns, 1).apply_to(width_composite)
          GridLayoutFactory.swt_defaults.num_columns(num_columns).apply_to(composite)
          @table.add_listener(SWT::Selection, Class.new(self.class::Listener.class == Class ? self.class::Listener : Object) do
            local_class_in ConfigureColumnsDialog
            include_class_members ConfigureColumnsDialog
            include class_self::Listener if class_self::Listener.class == Module
            
            typesig { [class_self::Event] }
            define_method :handle_event do |event|
              handle_selection_changed(self.attr_table.index_of(event.attr_item))
            end
            
            typesig { [Vararg.new(Object)] }
            define_method :initialize do |*args|
              super(*args)
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
          @text.add_listener(SWT::Modify, Class.new(self.class::Listener.class == Class ? self.class::Listener : Object) do
            local_class_in ConfigureColumnsDialog
            include_class_members ConfigureColumnsDialog
            include class_self::Listener if class_self::Listener.class == Module
            
            typesig { [class_self::Event] }
            define_method :handle_event do |event|
              column_object = self.attr_column_objects[self.attr_table.get_selection_index]
              if (!column_object.attr_resizable)
                return
              end
              begin
                width = JavaInteger.parse_int(self.attr_text.get_text)
                column_object.attr_width = width
              rescue self.class::NumberFormatException => ex
                # ignore for now
              end
            end
            
            typesig { [Vararg.new(Object)] }
            define_method :initialize do |*args|
              super(*args)
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
          Dialog.apply_dialog_font(composite)
          return composite
        end
        
        typesig { [class_self::Table, ::Java::Boolean] }
        # @param table
        # @param up
        def handle_move(table, up)
          index = table.get_selection_index
          new_index = index + (up ? -1 : 1)
          if (index < 0 || index >= table.get_item_count)
            return
          end
          column_object = @column_objects[index]
          @column_objects[index] = @column_objects[new_index]
          @column_objects[new_index] = column_object
          table.get_item(index).dispose
          new_item = self.class::TableItem.new(table, SWT::NONE, new_index)
          new_item.set_text(column_object.attr_name)
          new_item.set_image(column_object.attr_image)
          new_item.set_data(column_object)
          table.set_selection(new_index)
          handle_selection_changed(new_index)
        end
        
        typesig { [class_self::Composite, String] }
        def create_label(composite, string)
          label = self.class::Label.new(composite, SWT::NONE)
          label.set_text(string)
        end
        
        typesig { [class_self::Item] }
        # @param item
        # @return
        def get_column_name(item)
          result = "" # $NON-NLS-1$
          if (item.is_a?(self.class::TableColumn))
            result = RJava.cast_to_string((item).get_text)
            if ((result.trim == ""))
              # $NON-NLS-1$
              result = RJava.cast_to_string((item).get_tool_tip_text)
            end
          else
            if (item.is_a?(self.class::TreeColumn))
              result = RJava.cast_to_string((item).get_text)
              if ((result.trim == ""))
                # $NON-NLS-1$
                result = RJava.cast_to_string((item).get_tool_tip_text)
              end
            end
          end
          return result
        end
        
        typesig { [class_self::Item] }
        # @param item
        # @return
        def get_column_width(item)
          if (item.is_a?(self.class::TableColumn))
            return (item).get_width
          else
            if (item.is_a?(self.class::TreeColumn))
              return (item).get_width
            end
          end
          return 0
        end
        
        typesig { [] }
        # @return
        def get_viewer_columns
          if (@target_control.is_a?(self.class::Table))
            return (@target_control).get_columns
          else
            if (@target_control.is_a?(self.class::Tree))
              return (@target_control).get_columns
            end
          end
          return Array.typed(self.class::Item).new(0) { nil }
        end
        
        typesig { [::Java::Int] }
        def handle_selection_changed(index)
          c = @column_objects[index]
          @text.set_text(JavaInteger.to_s(c.attr_width))
          @text.set_enabled(c.attr_resizable)
          if (@moveable_columns_found)
            @up_button.set_enabled(c.attr_moveable && index > 0)
            @down_button.set_enabled(c.attr_moveable && index + 1 < @table.get_item_count)
          end
        end
        
        typesig { [] }
        def ok_pressed
          column_order = Array.typed(::Java::Int).new(@column_objects.attr_length) { 0 }
          i = 0
          while i < @column_objects.attr_length
            column_object = @column_objects[i]
            column_order[i] = column_object.attr_index
            set_column_width(column_object.attr_column, column_object.attr_width)
            i += 1
          end
          set_column_order(column_order)
          super
        end
        
        typesig { [class_self::Item, ::Java::Int] }
        # @param column
        # @param width
        def set_column_width(item, width)
          if (item.is_a?(self.class::TableColumn))
            (item).set_width(width)
          else
            if (item.is_a?(self.class::TreeColumn))
              (item).set_width(width)
            end
          end
        end
        
        typesig { [Array.typed(::Java::Int)] }
        # @param columnOrder
        def set_column_order(order)
          if (@target_control.is_a?(self.class::Table))
            (@target_control).set_column_order(order)
          else
            if (@target_control.is_a?(self.class::Tree))
              (@target_control).set_column_order(order)
            end
          end
        end
        
        private
        alias_method :initialize__configure_columns_dialog, :initialize
      end }
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__configure_columns, :initialize
  end
  
end
