require "rjava"

# Copyright (c) 2006, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
# Tom Schindl <tom.schindl@bestsolution.at> - initial API and implementation
# bugfix in: 195137, 198089
# Fredy Dobler <fredy@dobler.net> - bug 159600
# Brock Janiczak <brockj@tpg.com.au> - bug 182443
module Org::Eclipse::Jface::Viewers
  module ColumnViewerToolTipSupportImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
      include_const ::Org::Eclipse::Jface::Util, :Policy
      include_const ::Org::Eclipse::Jface::Window, :DefaultToolTip
      include_const ::Org::Eclipse::Jface::Window, :ToolTip
      include_const ::Org::Eclipse::Swt::Graphics, :Image
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Event
    }
  end
  
  # The ColumnViewerTooltipSupport is the class that provides tool tips for
  # ColumnViewers.
  # 
  # @since 3.3
  class ColumnViewerToolTipSupport < ColumnViewerToolTipSupportImports.const_get :DefaultToolTip
    include_class_members ColumnViewerToolTipSupportImports
    
    attr_accessor :viewer
    alias_method :attr_viewer, :viewer
    undef_method :viewer
    alias_method :attr_viewer=, :viewer=
    undef_method :viewer=
    
    class_module.module_eval {
      const_set_lazy(:VIEWER_CELL_KEY) { RJava.cast_to_string(Policy::JFACE) + "_VIEWER_CELL_KEY" }
      const_attr_reader  :VIEWER_CELL_KEY
      
      # $NON-NLS-1$
      const_set_lazy(:DEFAULT_SHIFT_X) { 10 }
      const_attr_reader  :DEFAULT_SHIFT_X
      
      const_set_lazy(:DEFAULT_SHIFT_Y) { 0 }
      const_attr_reader  :DEFAULT_SHIFT_Y
    }
    
    typesig { [ColumnViewer, ::Java::Int, ::Java::Boolean] }
    # Enable ToolTip support for the viewer by creating an instance from this
    # class. To get all necessary informations this support class consults the
    # {@link CellLabelProvider}.
    # 
    # @param viewer
    # the viewer the support is attached to
    # @param style
    # style passed to control tool tip behavior
    # 
    # @param manualActivation
    # <code>true</code> if the activation is done manually using
    # {@link #show(Point)}
    def initialize(viewer, style, manual_activation)
      @viewer = nil
      super(viewer.get_control, style, manual_activation)
      @viewer = viewer
    end
    
    class_module.module_eval {
      typesig { [ColumnViewer] }
      # Enable ToolTip support for the viewer by creating an instance from this
      # class. To get all necessary informations this support class consults the
      # {@link CellLabelProvider}.
      # 
      # @param viewer
      # the viewer the support is attached to
      def enable_for(viewer)
        ColumnViewerToolTipSupport.new(viewer, ToolTip::NO_RECREATE, false)
      end
      
      typesig { [ColumnViewer, ::Java::Int] }
      # Enable ToolTip support for the viewer by creating an instance from this
      # class. To get all necessary informations this support class consults the
      # {@link CellLabelProvider}.
      # 
      # @param viewer
      # the viewer the support is attached to
      # @param style
      # style passed to control tool tip behavior
      # 
      # @see ToolTip#RECREATE
      # @see ToolTip#NO_RECREATE
      def enable_for(viewer, style)
        ColumnViewerToolTipSupport.new(viewer, style, false)
      end
    }
    
    typesig { [Event] }
    def get_tool_tip_area(event)
      return @viewer.get_cell(Point.new(event.attr_x, event.attr_y))
    end
    
    typesig { [Event, Composite] }
    # Instead of overwriting this method subclasses should overwrite
    # {@link #createViewerToolTipContentArea(Event, ViewerCell, Composite)}
    def create_tool_tip_content_area(event, parent)
      cell = get_data(VIEWER_CELL_KEY)
      set_data(VIEWER_CELL_KEY, nil)
      return create_viewer_tool_tip_content_area(event, cell, parent)
    end
    
    typesig { [Event, ViewerCell, Composite] }
    # Creates the content area of the tool tip giving access to the cell the
    # tip is shown for. Subclasses can overload this method to implement their
    # own tool tip design.
    # 
    # <p>
    # This method is called from
    # {@link #createToolTipContentArea(Event, Composite)} and by default calls
    # the {@link DefaultToolTip#createToolTipContentArea(Event, Composite)}.
    # </p>
    # 
    # @param event
    # the event that which
    # @param cell
    # the cell the tool tip is shown for
    # @param parent
    # the parent of the control to create
    # @return the control to be displayed in the tool tip area
    # @since 3.4
    def create_viewer_tool_tip_content_area(event, cell, parent)
      return DefaultToolTip.instance_method(:create_tool_tip_content_area).bind(self).call(event, parent)
    end
    
    typesig { [Event] }
    def should_create_tool_tip(event)
      if (!super(event))
        return false
      end
      rv = false
      row = @viewer.get_viewer_row(Point.new(event.attr_x, event.attr_y))
      @viewer.get_control.set_tool_tip_text("") # $NON-NLS-1$
      point = Point.new(event.attr_x, event.attr_y)
      if (!(row).nil?)
        element = row.get_item.get_data
        cell = row.get_cell(point)
        if ((cell).nil?)
          return false
        end
        view_part = @viewer.get_viewer_column(cell.get_column_index)
        if ((view_part).nil?)
          return false
        end
        label_provider = view_part.get_label_provider
        use_native = label_provider.use_native_tool_tip(element)
        text = label_provider.get_tool_tip_text(element)
        img = nil
        if (!use_native)
          img = label_provider.get_tool_tip_image(element)
        end
        if (use_native || ((text).nil? && (img).nil?))
          @viewer.get_control.set_tool_tip_text(text)
          rv = false
        else
          set_popup_delay(label_provider.get_tool_tip_display_delay_time(element))
          set_hide_delay(label_provider.get_tool_tip_time_displayed(element))
          shift = label_provider.get_tool_tip_shift(element)
          if ((shift).nil?)
            set_shift(Point.new(DEFAULT_SHIFT_X, DEFAULT_SHIFT_Y))
          else
            set_shift(Point.new(shift.attr_x, shift.attr_y))
          end
          set_data(VIEWER_CELL_KEY, cell)
          set_text(text)
          set_image(img)
          set_style(label_provider.get_tool_tip_style(element))
          set_foreground_color(label_provider.get_tool_tip_foreground_color(element))
          set_background_color(label_provider.get_tool_tip_background_color(element))
          set_font(label_provider.get_tool_tip_font(element))
          # Check if at least one of the values is set
          rv = !(get_text(event)).nil? || !(get_image(event)).nil?
        end
      end
      return rv
    end
    
    typesig { [Event] }
    def after_hide_tool_tip(event)
      super(event)
      # Clear the restored value else this could be a source of a leak
      set_data(VIEWER_CELL_KEY, nil)
      if (!(event).nil? && !(event.attr_widget).equal?(@viewer.get_control))
        @viewer.get_control.set_focus
      end
    end
    
    private
    alias_method :initialize__column_viewer_tool_tip_support, :initialize
  end
  
end
