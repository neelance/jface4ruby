require "rjava"

# Copyright (c) 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Internal::Text
  module TableOwnerDrawSupportImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Internal::Text
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Custom, :StyleRange
      include_const ::Org::Eclipse::Swt::Graphics, :Color
      include_const ::Org::Eclipse::Swt::Graphics, :SwtGC
      include_const ::Org::Eclipse::Swt::Graphics, :Image
      include_const ::Org::Eclipse::Swt::Graphics, :Rectangle
      include_const ::Org::Eclipse::Swt::Graphics, :TextLayout
      include_const ::Org::Eclipse::Swt::Widgets, :Event
      include_const ::Org::Eclipse::Swt::Widgets, :Listener
      include_const ::Org::Eclipse::Swt::Widgets, :Table
      include_const ::Org::Eclipse::Swt::Widgets, :TableItem
    }
  end
  
  # Adds owner draw support for tables.
  # 
  # @since 3.4
  class TableOwnerDrawSupport 
    include_class_members TableOwnerDrawSupportImports
    include Listener
    
    class_module.module_eval {
      const_set_lazy(:STYLED_RANGES_KEY) { "styled_ranges" }
      const_attr_reader  :STYLED_RANGES_KEY
    }
    
    # $NON-NLS-1$
    attr_accessor :f_layout
    alias_method :attr_f_layout, :f_layout
    undef_method :f_layout
    alias_method :attr_f_layout=, :f_layout=
    undef_method :f_layout=
    
    class_module.module_eval {
      typesig { [Table] }
      def install(table)
        listener = TableOwnerDrawSupport.new(table)
        table.add_listener(SWT::Dispose, listener)
        table.add_listener(SWT::MeasureItem, listener)
        table.add_listener(SWT::EraseItem, listener)
        table.add_listener(SWT::PaintItem, listener)
      end
      
      typesig { [TableItem, ::Java::Int, Array.typed(StyleRange)] }
      # Stores the styled ranges in the given table item.
      # 
      # @param item table item
      # @param column the column index
      # @param ranges the styled ranges or <code>null</code> to remove them
      def store_style_ranges(item, column, ranges)
        item.set_data(STYLED_RANGES_KEY + RJava.cast_to_string(column), ranges)
      end
      
      typesig { [TableItem, ::Java::Int] }
      # Returns the styled ranges which are stored in the given table item.
      # 
      # @param item table item
      # @param column the column index
      # @return the styled ranges
      def get_styled_ranges(item, column)
        return item.get_data(STYLED_RANGES_KEY + RJava.cast_to_string(column))
      end
    }
    
    typesig { [Table] }
    def initialize(table)
      @f_layout = nil
      orientation = table.get_style & (SWT::LEFT_TO_RIGHT | SWT::RIGHT_TO_LEFT)
      @f_layout = TextLayout.new(table.get_display)
      @f_layout.set_orientation(orientation)
    end
    
    typesig { [Event] }
    # @see org.eclipse.swt.widgets.Listener#handleEvent(org.eclipse.swt.widgets.Event)
    def handle_event(event)
      case (event.attr_type)
      when SWT::MeasureItem
      when SWT::EraseItem
        event.attr_detail &= ~SWT::FOREGROUND
      when SWT::PaintItem
        perform_paint(event)
      when SWT::Dispose
        widget_disposed
      end
    end
    
    typesig { [Event] }
    # Performs the paint operation.
    # 
    # @param event the event
    def perform_paint(event)
      item = event.attr_item
      gc = event.attr_gc
      index = event.attr_index
      is_selected = !((event.attr_detail & SWT::SELECTED)).equal?(0)
      # Remember colors to restore the GC later
      old_foreground = gc.get_foreground
      old_background = gc.get_background
      if (!is_selected)
        foreground = item.get_foreground(index)
        gc.set_foreground(foreground)
        background = item.get_background(index)
        gc.set_background(background)
      end
      image = item.get_image(index)
      if (!(image).nil?)
        image_bounds = item.get_image_bounds(index)
        bounds = image.get_bounds
        x = image_bounds.attr_x + Math.max(0, (image_bounds.attr_width - bounds.attr_width) / 2)
        y = image_bounds.attr_y + Math.max(0, (image_bounds.attr_height - bounds.attr_height) / 2)
        gc.draw_image(image, x, y)
      end
      @f_layout.set_font(item.get_font(index))
      # XXX: needed to clear the style info, see https://bugs.eclipse.org/bugs/show_bug.cgi?id=226090
      @f_layout.set_text("") # $NON-NLS-1$
      @f_layout.set_text(item.get_text(index))
      ranges = get_styled_ranges(item, index)
      if (!(ranges).nil?)
        i = 0
        while i < ranges.attr_length
          curr = ranges[i]
          if (is_selected)
            curr = curr.clone
            curr.attr_foreground = nil
            curr.attr_background = nil
          end
          @f_layout.set_style(curr, curr.attr_start, curr.attr_start + curr.attr_length - 1)
          i += 1
        end
      end
      text_bounds = item.get_text_bounds(index)
      if (!(text_bounds).nil?)
        layout_bounds = @f_layout.get_bounds
        x = text_bounds.attr_x
        y = text_bounds.attr_y + Math.max(0, (text_bounds.attr_height - layout_bounds.attr_height) / 2)
        @f_layout.draw(gc, x, y)
      end
      if (!((event.attr_detail & SWT::FOCUSED)).equal?(0))
        focus_bounds = item.get_bounds
        gc.draw_focus(focus_bounds.attr_x, focus_bounds.attr_y, focus_bounds.attr_width, focus_bounds.attr_height)
      end
      if (!is_selected)
        gc.set_foreground(old_foreground)
        gc.set_background(old_background)
      end
    end
    
    typesig { [] }
    def widget_disposed
      @f_layout.dispose
    end
    
    private
    alias_method :initialize__table_owner_draw_support, :initialize
  end
  
end
