require "rjava"

# Copyright (c) 2006, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
# Tom Shindl <tom.schindl@bestsolution.at> - initial API and implementation
# - bug fixes for 182443
module Org::Eclipse::Jface::Viewers
  module CellLabelProviderImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Custom, :CLabel
      include_const ::Org::Eclipse::Swt::Graphics, :Color
      include_const ::Org::Eclipse::Swt::Graphics, :Font
      include_const ::Org::Eclipse::Swt::Graphics, :Image
      include_const ::Org::Eclipse::Swt::Graphics, :Point
    }
  end
  
  # The CellLabelProvider is an abstract implementation of a label provider for
  # structured viewers.
  # 
  # <p><b>This class is intended to be subclassed</b></p>
  # 
  # @since 3.3
  # @see ColumnLabelProvider as a concrete implementation
  class CellLabelProvider < CellLabelProviderImports.const_get :BaseLabelProvider
    include_class_members CellLabelProviderImports
    
    typesig { [] }
    # Create a new instance of the receiver.
    def initialize
      super()
    end
    
    class_module.module_eval {
      typesig { [ColumnViewer, IBaseLabelProvider] }
      # Create a ViewerLabelProvider for the column at index
      # 
      # @param labelProvider
      # The labelProvider to convert
      # @return ViewerLabelProvider
      # 
      # package
      def create_viewer_label_provider(viewer, label_provider)
        no_column_tree_viewer = viewer.is_a?(AbstractTreeViewer) && (viewer.do_get_column_count).equal?(0)
        if (!no_column_tree_viewer && (label_provider.is_a?(ITableLabelProvider) || label_provider.is_a?(ITableColorProvider) || label_provider.is_a?(ITableFontProvider)))
          return TableColumnViewerLabelProvider.new(label_provider)
        end
        if (label_provider.is_a?(CellLabelProvider))
          return label_provider
        end
        return WrappedViewerLabelProvider.new(label_provider)
      end
    }
    
    typesig { [Object] }
    # Get the image displayed in the tool tip for object.
    # 
    # <p>
    # <b>If {@link #getToolTipText(Object)} and
    # {@link #getToolTipImage(Object)} both return <code>null</code> the
    # control is set back to standard behavior</b>
    # </p>
    # 
    # @param object
    # the element for which the tool tip is shown
    # @return {@link Image} or <code>null</code> if there is not image.
    def get_tool_tip_image(object)
      return nil
    end
    
    typesig { [Object] }
    # Get the text displayed in the tool tip for object.
    # 
    # <p>
    # <b>If {@link #getToolTipText(Object)} and
    # {@link #getToolTipImage(Object)} both return <code>null</code> the
    # control is set back to standard behavior</b>
    # </p>
    # 
    # @param element
    # the element for which the tool tip is shown
    # @return the {@link String} or <code>null</code> if there is not text to
    # display
    def get_tool_tip_text(element)
      return nil
    end
    
    typesig { [Object] }
    # Return the background color used for the tool tip
    # 
    # @param object
    # the {@link Object} for which the tool tip is shown
    # 
    # @return the {@link Color} used or <code>null</code> if you want to use
    # the default color {@link SWT#COLOR_INFO_BACKGROUND}
    # @see SWT#COLOR_INFO_BACKGROUND
    def get_tool_tip_background_color(object)
      return nil
    end
    
    typesig { [Object] }
    # The foreground color used to display the the text in the tool tip
    # 
    # @param object
    # the {@link Object} for which the tool tip is shown
    # @return the {@link Color} used or <code>null</code> if you want to use
    # the default color {@link SWT#COLOR_INFO_FOREGROUND}
    # @see SWT#COLOR_INFO_FOREGROUND
    def get_tool_tip_foreground_color(object)
      return nil
    end
    
    typesig { [Object] }
    # Get the {@link Font} used to display the tool tip
    # 
    # @param object
    # the element for which the tool tip is shown
    # @return {@link Font} or <code>null</code> if the default font is to be
    # used.
    def get_tool_tip_font(object)
      return nil
    end
    
    typesig { [Object] }
    # Return the amount of pixels in x and y direction you want the tool tip to
    # pop up from the mouse pointer. The default shift is 10px right and 0px
    # below your mouse cursor. Be aware of the fact that you should at least
    # position the tool tip 1px right to your mouse cursor else click events
    # may not get propagated properly.
    # 
    # @param object
    # the element for which the tool tip is shown
    # @return {@link Point} to shift of the tool tip or <code>null</code> if the
    # default shift should be used.
    def get_tool_tip_shift(object)
      return nil
    end
    
    typesig { [Object] }
    # Return whether or not to use the native tool tip. If you switch to native
    # tool tips only the value from {@link #getToolTipText(Object)} is used all
    # other features from custom tool tips are not supported.
    # 
    # <p>
    # To reset the control to native behavior you should return
    # <code>true</code> from this method and <code>null</code> from
    # {@link #getToolTipText(Object)} or <code>null</code> from
    # {@link #getToolTipText(Object)} and {@link #getToolTipImage(Object)} at
    # the same time
    # </p>
    # 
    # @param object
    # the {@link Object} for which the tool tip is shown
    # @return <code>true</code> if native tool tips should be used
    def use_native_tool_tip(object)
      return false
    end
    
    typesig { [Object] }
    # The time in milliseconds the tool tip is shown for.
    # 
    # @param object
    # the {@link Object} for which the tool tip is shown
    # @return time in milliseconds the tool tip is shown for
    def get_tool_tip_time_displayed(object)
      return 0
    end
    
    typesig { [Object] }
    # The time in milliseconds until the tool tip is displayed.
    # 
    # @param object
    # the {@link Object} for which the tool tip is shown
    # @return time in milliseconds until the tool tip is displayed
    def get_tool_tip_display_delay_time(object)
      return 0
    end
    
    typesig { [Object] }
    # The {@link SWT} style used to create the {@link CLabel} (see there for
    # supported styles). By default {@link SWT#SHADOW_NONE} is used.
    # 
    # @param object
    # the element for which the tool tip is shown
    # @return the style used to create the label
    # @see CLabel
    def get_tool_tip_style(object)
      return SWT::SHADOW_NONE
    end
    
    typesig { [ViewerCell] }
    # Update the label for cell.
    # 
    # @param cell
    # {@link ViewerCell}
    def update(cell)
      raise NotImplementedError
    end
    
    typesig { [ColumnViewer, ViewerColumn] }
    # Initialize this label provider for use with the given column viewer for
    # the given column. Subclasses may extend but should call the super
    # implementation (which at this time is empty but may be changed in the
    # future).
    # 
    # @param viewer
    # the viewer
    # @param column
    # the column, or <code>null</code> if a column is not
    # available.
    # 
    # @since 3.4
    def initialize_(viewer, column)
    end
    
    typesig { [ColumnViewer, ViewerColumn] }
    # Dispose of this label provider which was used with the given column
    # viewer and column. Subclasses may extend but should call the super
    # implementation (which calls {@link #dispose()}).
    # 
    # @param viewer
    # the viewer
    # @param column
    # the column, or <code>null</code> if a column is not
    # available.
    # 
    # @since 3.4
    def dispose(viewer, column)
      dispose
    end
    
    private
    alias_method :initialize__cell_label_provider, :initialize
  end
  
end
