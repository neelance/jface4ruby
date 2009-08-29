require "rjava"

# Copyright (c) 2006, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Viewers
  module OwnerDrawLabelProviderImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
      include_const ::Java::Util, :HashSet
      include_const ::Java::Util, :JavaSet
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Graphics, :Color
      include_const ::Org::Eclipse::Swt::Graphics, :Rectangle
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Event
      include_const ::Org::Eclipse::Swt::Widgets, :Listener
    }
  end
  
  # OwnerDrawLabelProvider is an abstract implementation of a label provider that
  # handles custom draw.
  # 
  # <p>
  # <b>This class is intended to be subclassed by implementors.</b>
  # </p>
  # 
  # @since 3.3
  class OwnerDrawLabelProvider < OwnerDrawLabelProviderImports.const_get :CellLabelProvider
    include_class_members OwnerDrawLabelProviderImports
    
    class_module.module_eval {
      const_set_lazy(:OwnerDrawListener) { Class.new do
        include_class_members OwnerDrawLabelProvider
        include Listener
        
        attr_accessor :enabled_columns
        alias_method :attr_enabled_columns, :enabled_columns
        undef_method :enabled_columns
        alias_method :attr_enabled_columns=, :enabled_columns=
        undef_method :enabled_columns=
        
        attr_accessor :enabled_globally
        alias_method :attr_enabled_globally, :enabled_globally
        undef_method :enabled_globally
        alias_method :attr_enabled_globally=, :enabled_globally=
        undef_method :enabled_globally=
        
        attr_accessor :viewer
        alias_method :attr_viewer, :viewer
        undef_method :viewer
        alias_method :attr_viewer=, :viewer=
        undef_method :viewer=
        
        typesig { [class_self::ColumnViewer] }
        def initialize(viewer)
          @enabled_columns = self.class::HashSet.new
          @enabled_globally = 0
          @viewer = nil
          @viewer = viewer
        end
        
        typesig { [class_self::Event] }
        def handle_event(event)
          provider = @viewer.get_viewer_column(event.attr_index).get_label_provider
          column = @viewer.get_viewer_column(event.attr_index)
          if (@enabled_globally > 0 || @enabled_columns.contains(column))
            if (provider.is_a?(self.class::OwnerDrawLabelProvider))
              element = event.attr_item.get_data
              owner_draw_provider = provider
              case (event.attr_type)
              when SWT::MeasureItem
                owner_draw_provider.measure(event, element)
              when SWT::PaintItem
                owner_draw_provider.paint(event, element)
              when SWT::EraseItem
                owner_draw_provider.erase(event, element)
              end
            end
          end
        end
        
        private
        alias_method :initialize__owner_draw_listener, :initialize
      end }
      
      const_set_lazy(:OWNER_DRAW_LABEL_PROVIDER_LISTENER) { "owner_draw_label_provider_listener" }
      const_attr_reader  :OWNER_DRAW_LABEL_PROVIDER_LISTENER
      
      typesig { [ColumnViewer] }
      # $NON-NLS-1$
      # 
      # Set up the owner draw callbacks for the viewer.
      # 
      # @param viewer
      # the viewer the owner draw is set up
      # 
      # @deprecated Since 3.4, the default implementation of
      # {@link CellLabelProvider#initialize(ColumnViewer, ViewerColumn)}
      # in this class will set up the necessary owner draw callbacks
      # automatically. Calls to this method can be removed.
      def set_up_owner_draw(viewer)
        get_or_create_owner_draw_listener(viewer).attr_enabled_globally += 1
      end
      
      typesig { [ColumnViewer] }
      # @param viewer
      # @param control
      # @return
      def get_or_create_owner_draw_listener(viewer)
        control = viewer.get_control
        listener = control.get_data(OWNER_DRAW_LABEL_PROVIDER_LISTENER)
        if ((listener).nil?)
          listener = OwnerDrawListener.new(viewer)
          control.set_data(OWNER_DRAW_LABEL_PROVIDER_LISTENER, listener)
          control.add_listener(SWT::MeasureItem, listener)
          control.add_listener(SWT::EraseItem, listener)
          control.add_listener(SWT::PaintItem, listener)
        end
        return listener
      end
    }
    
    typesig { [] }
    # Create a new instance of the receiver based on a column viewer.
    def initialize
      super()
    end
    
    typesig { [ColumnViewer, ViewerColumn] }
    def dispose(viewer, column)
      if (!viewer.get_control.is_disposed)
        set_owner_draw_enabled(viewer, column, false)
      end
      super(viewer, column)
    end
    
    typesig { [ColumnViewer, ViewerColumn] }
    # This implementation of
    # {@link CellLabelProvider#initialize(ColumnViewer, ViewerColumn)}
    # delegates to {@link #initialize(ColumnViewer, ViewerColumn, boolean)}
    # with a value of <code>true</code> for <code>enableOwnerDraw</code>.
    # Subclasses may override this method but should either call the super
    # implementation or, alternatively,
    # {@link #initialize(ColumnViewer, ViewerColumn, boolean)}.
    def initialize_(viewer, column)
      self.initialize_(viewer, column, true)
    end
    
    typesig { [ColumnViewer, ViewerColumn, ::Java::Boolean] }
    # May be called from subclasses that override
    # {@link #initialize(ColumnViewer, ViewerColumn)} but want to customize
    # whether owner draw will be enabled. This method calls
    # <code>super.initialize(ColumnViewer, ViewerColumn)</code>, and then
    # enables or disables owner draw by calling
    # {@link #setOwnerDrawEnabled(ColumnViewer, ViewerColumn, boolean)}.
    # 
    # @param viewer
    # the viewer
    # @param column
    # the column, or <code>null</code> if a column is not
    # available.
    # @param enableOwnerDraw
    # <code>true</code> if owner draw should be enabled for the
    # given viewer and column, <code>false</code> otherwise.
    # 
    # @since 3.4
    def initialize_(viewer, column, enable_owner_draw)
      super(viewer, column)
      set_owner_draw_enabled(viewer, column, enable_owner_draw)
    end
    
    typesig { [ViewerCell] }
    def update(cell)
      # Force a redraw
      cell_bounds = cell.get_bounds
      cell.get_control.redraw(cell_bounds.attr_x, cell_bounds.attr_y, cell_bounds.attr_width, cell_bounds.attr_height, true)
    end
    
    typesig { [Event, Object] }
    # Handle the erase event. The default implementation colors the background
    # of selected areas with {@link SWT#COLOR_LIST_SELECTION} and foregrounds
    # with {@link SWT#COLOR_LIST_SELECTION_TEXT}. Note that this
    # implementation causes non-native behavior on some platforms. Subclasses
    # should override this method and <b>not</b> call the super
    # implementation.
    # 
    # @param event
    # the erase event
    # @param element
    # the model object
    # @see SWT#EraseItem
    # @see SWT#COLOR_LIST_SELECTION
    # @see SWT#COLOR_LIST_SELECTION_TEXT
    def erase(event, element)
      bounds = event.get_bounds
      if (!((event.attr_detail & SWT::SELECTED)).equal?(0))
        old_foreground = event.attr_gc.get_foreground
        old_background = event.attr_gc.get_background
        event.attr_gc.set_background(event.attr_item.get_display.get_system_color(SWT::COLOR_LIST_SELECTION))
        event.attr_gc.set_foreground(event.attr_item.get_display.get_system_color(SWT::COLOR_LIST_SELECTION_TEXT))
        event.attr_gc.fill_rectangle(bounds)
        # restore the old GC colors
        event.attr_gc.set_foreground(old_foreground)
        event.attr_gc.set_background(old_background)
        # ensure that default selection is not drawn
        event.attr_detail &= ~SWT::SELECTED
      end
    end
    
    typesig { [Event, Object] }
    # Handle the measure event.
    # 
    # @param event
    # the measure event
    # @param element
    # the model element
    # @see SWT#MeasureItem
    def measure(event, element)
      raise NotImplementedError
    end
    
    typesig { [Event, Object] }
    # Handle the paint event.
    # 
    # @param event
    # the paint event
    # @param element
    # the model element
    # @see SWT#PaintItem
    def paint(event, element)
      raise NotImplementedError
    end
    
    typesig { [ColumnViewer, ViewerColumn, ::Java::Boolean] }
    # Enables or disables owner draw for the given viewer and column. This
    # method will attach or remove a listener to the underlying control as
    # necessary. This method is called from
    # {@link #initialize(ColumnViewer, ViewerColumn)} and
    # {@link #dispose(ColumnViewer, ViewerColumn)} but may be called from
    # subclasses to enable or disable owner draw dynamically.
    # 
    # @param viewer
    # the viewer
    # @param column
    # the column, or <code>null</code> if a column is not
    # available
    # @param enabled
    # <code>true</code> if owner draw should be enabled,
    # <code>false</code> otherwise
    # 
    # @since 3.4
    def set_owner_draw_enabled(viewer, column, enabled)
      if (enabled)
        listener = get_or_create_owner_draw_listener(viewer)
        if ((column).nil?)
          listener.attr_enabled_globally += 1
        else
          listener.attr_enabled_columns.add(column)
        end
      else
        listener = viewer.get_control.get_data(OWNER_DRAW_LABEL_PROVIDER_LISTENER)
        if (!(listener).nil?)
          if ((column).nil?)
            listener.attr_enabled_globally -= 1
          else
            listener.attr_enabled_columns.remove(column)
          end
          if (listener.attr_enabled_columns.is_empty && listener.attr_enabled_globally <= 0)
            viewer.get_control.remove_listener(SWT::MeasureItem, listener)
            viewer.get_control.remove_listener(SWT::EraseItem, listener)
            viewer.get_control.remove_listener(SWT::PaintItem, listener)
            viewer.get_control.set_data(OWNER_DRAW_LABEL_PROVIDER_LISTENER, nil)
          end
        end
      end
    end
    
    private
    alias_method :initialize__owner_draw_label_provider, :initialize
  end
  
end
