require "rjava"

# Copyright (c) 2006, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Internal::Text::Source
  module DiffPainterImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Internal::Text::Source
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Custom, :StyledText
      include_const ::Org::Eclipse::Swt::Events, :DisposeEvent
      include_const ::Org::Eclipse::Swt::Events, :DisposeListener
      include_const ::Org::Eclipse::Swt::Graphics, :Color
      include_const ::Org::Eclipse::Swt::Graphics, :SwtGC
      include_const ::Org::Eclipse::Swt::Graphics, :RGB
      include_const ::Org::Eclipse::Swt::Widgets, :Canvas
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Display
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Jface::Text, :ITextViewer
      include_const ::Org::Eclipse::Jface::Text, :JFaceTextUtil
      include_const ::Org::Eclipse::Jface::Text::Source, :CompositeRuler
      include_const ::Org::Eclipse::Jface::Text::Source, :IAnnotationHover
      include_const ::Org::Eclipse::Jface::Text::Source, :IAnnotationModel
      include_const ::Org::Eclipse::Jface::Text::Source, :IAnnotationModelExtension
      include_const ::Org::Eclipse::Jface::Text::Source, :IAnnotationModelListener
      include_const ::Org::Eclipse::Jface::Text::Source, :IChangeRulerColumn
      include_const ::Org::Eclipse::Jface::Text::Source, :ILineDiffInfo
      include_const ::Org::Eclipse::Jface::Text::Source, :ILineDiffer
      include_const ::Org::Eclipse::Jface::Text::Source, :ILineDifferExtension2
      include_const ::Org::Eclipse::Jface::Text::Source, :ILineRange
      include_const ::Org::Eclipse::Jface::Text::Source, :ISharedTextColors
      include_const ::Org::Eclipse::Jface::Text::Source, :IVerticalRulerColumn
    }
  end
  
  # A strategy for painting the quick diff colors onto the vertical ruler column. It also manages the
  # quick diff hover.
  # 
  # @since 3.2
  class DiffPainter 
    include_class_members DiffPainterImports
    
    class_module.module_eval {
      # Internal listener class that will update the ruler when the underlying model changes.
      const_set_lazy(:AnnotationListener) { Class.new do
        extend LocalClass
        include_class_members DiffPainter
        include IAnnotationModelListener
        
        typesig { [class_self::IAnnotationModel] }
        # @see org.eclipse.jface.text.source.IAnnotationModelListener#modelChanged(org.eclipse.jface.text.source.IAnnotationModel)
        def model_changed(model)
          post_redraw
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__annotation_listener, :initialize
      end }
    }
    
    # The vertical ruler column that delegates painting to this painter.
    attr_accessor :f_column
    alias_method :attr_f_column, :f_column
    undef_method :f_column
    alias_method :attr_f_column=, :f_column=
    undef_method :f_column=
    
    # The parent ruler.
    attr_accessor :f_parent_ruler
    alias_method :attr_f_parent_ruler, :f_parent_ruler
    undef_method :f_parent_ruler
    alias_method :attr_f_parent_ruler=, :f_parent_ruler=
    undef_method :f_parent_ruler=
    
    # The column's control, typically a {@link Canvas}, possibly <code>null</code>.
    attr_accessor :f_control
    alias_method :attr_f_control, :f_control
    undef_method :f_control
    alias_method :attr_f_control=, :f_control=
    undef_method :f_control=
    
    # The text viewer that the column is attached to.
    attr_accessor :f_viewer
    alias_method :attr_f_viewer, :f_viewer
    undef_method :f_viewer
    alias_method :attr_f_viewer=, :f_viewer=
    undef_method :f_viewer=
    
    # The viewer's text widget.
    attr_accessor :f_widget
    alias_method :attr_f_widget, :f_widget
    undef_method :f_widget
    alias_method :attr_f_widget=, :f_widget=
    undef_method :f_widget=
    
    # The line differ extracted from the annotation model.
    attr_accessor :f_line_differ
    alias_method :attr_f_line_differ, :f_line_differ
    undef_method :f_line_differ
    alias_method :attr_f_line_differ=, :f_line_differ=
    undef_method :f_line_differ=
    
    # Color for changed lines
    attr_accessor :f_added_color
    alias_method :attr_f_added_color, :f_added_color
    undef_method :f_added_color
    alias_method :attr_f_added_color=, :f_added_color=
    undef_method :f_added_color=
    
    # Color for added lines
    attr_accessor :f_changed_color
    alias_method :attr_f_changed_color, :f_changed_color
    undef_method :f_changed_color
    alias_method :attr_f_changed_color=, :f_changed_color=
    undef_method :f_changed_color=
    
    # Color for the deleted line indicator
    attr_accessor :f_deleted_color
    alias_method :attr_f_deleted_color, :f_deleted_color
    undef_method :f_deleted_color
    alias_method :attr_f_deleted_color=, :f_deleted_color=
    undef_method :f_deleted_color=
    
    # The background color.
    attr_accessor :f_background
    alias_method :attr_f_background, :f_background
    undef_method :f_background
    alias_method :attr_f_background=, :f_background=
    undef_method :f_background=
    
    # The ruler's hover
    attr_accessor :f_hover
    alias_method :attr_f_hover, :f_hover
    undef_method :f_hover
    alias_method :attr_f_hover=, :f_hover=
    undef_method :f_hover=
    
    # The internal listener
    attr_accessor :f_annotation_listener
    alias_method :attr_f_annotation_listener, :f_annotation_listener
    undef_method :f_annotation_listener
    alias_method :attr_f_annotation_listener=, :f_annotation_listener=
    undef_method :f_annotation_listener=
    
    # The shared color provider, possibly <code>null</code>.
    attr_accessor :f_shared_colors
    alias_method :attr_f_shared_colors, :f_shared_colors
    undef_method :f_shared_colors
    alias_method :attr_f_shared_colors=, :f_shared_colors=
    undef_method :f_shared_colors=
    
    typesig { [IVerticalRulerColumn, ISharedTextColors] }
    # Creates a new diff painter for a vertical ruler column.
    # 
    # @param column the column that will delegate{@link #paint(GC, ILineRange) painting} to the
    # newly created painter.
    # @param sharedColors a shared colors object to store shaded colors in, may be
    # <code>null</code>
    def initialize(column, shared_colors)
      @f_column = nil
      @f_parent_ruler = nil
      @f_control = nil
      @f_viewer = nil
      @f_widget = nil
      @f_line_differ = nil
      @f_added_color = nil
      @f_changed_color = nil
      @f_deleted_color = nil
      @f_background = nil
      @f_hover = nil
      @f_annotation_listener = AnnotationListener.new_local(self)
      @f_shared_colors = nil
      Assert.is_legal(!(column).nil?)
      @f_column = column
      @f_shared_colors = shared_colors
    end
    
    typesig { [CompositeRuler] }
    # Sets the parent ruler - the delegating column must call this method as soon as it creates its
    # control.
    # 
    # @param parentRuler the parent ruler
    def set_parent_ruler(parent_ruler)
      @f_parent_ruler = parent_ruler
    end
    
    typesig { [IAnnotationHover] }
    # Sets the quick diff hover later returned by {@link #getHover()}.
    # 
    # @param hover the hover
    def set_hover(hover)
      @f_hover = hover
    end
    
    typesig { [] }
    # Returns the quick diff hover set by {@link #setHover(IAnnotationHover)}.
    # 
    # @return the quick diff hover set by {@link #setHover(IAnnotationHover)}
    def get_hover
      return @f_hover
    end
    
    typesig { [Color] }
    # Sets the background color.
    # 
    # @param background the background color, <code>null</code> to use the platform's list background
    def set_background(background)
      @f_background = background
    end
    
    typesig { [SwtGC, ILineRange] }
    # Delegates the painting of the quick diff colors to this painter. The painter will draw the
    # color boxes onto the passed {@link GC} for all model (document) lines in
    # <code>visibleModelLines</code>.
    # 
    # @param gc the {@link GC} to draw onto
    # @param visibleModelLines the lines (in document offsets) that are currently (perhaps only
    # partially) visible
    def paint(gc, visible_model_lines)
      connect_if_needed
      if (!is_connected)
        return
      end
      # draw diff info
      last_line = end_(visible_model_lines)
      width = get_width
      deletion_color = get_deletion_color
      line = visible_model_lines.get_start_line
      while line < last_line
        paint_line(line, gc, width, deletion_color)
        line += 1
      end
    end
    
    typesig { [] }
    # Ensures that the column is fully instantiated, i.e. has a control, and that the viewer is
    # visible.
    def connect_if_needed
      if (is_connected || (@f_parent_ruler).nil?)
        return
      end
      @f_viewer = @f_parent_ruler.get_text_viewer
      if ((@f_viewer).nil?)
        return
      end
      @f_widget = @f_viewer.get_text_widget
      if ((@f_widget).nil?)
        return
      end
      @f_control = @f_column.get_control
      if ((@f_control).nil?)
        return
      end
      @f_control.add_dispose_listener(Class.new(DisposeListener.class == Class ? DisposeListener : Object) do
        extend LocalClass
        include_class_members DiffPainter
        include DisposeListener if DisposeListener.class == Module
        
        typesig { [DisposeEvent] }
        # @see org.eclipse.swt.events.DisposeListener#widgetDisposed(org.eclipse.swt.events.DisposeEvent)
        define_method :widget_disposed do |e|
          handle_dispose
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
    # Returns <code>true</code> if the column is fully connected.
    # 
    # @return <code>true</code> if the column is fully connected, false otherwise
    def is_connected
      return !(@f_control).nil?
    end
    
    typesig { [] }
    # Disposes of this painter and releases any resources.
    def handle_dispose
      if (!(@f_line_differ).nil?)
        (@f_line_differ).remove_annotation_model_listener(@f_annotation_listener)
        @f_line_differ = nil
      end
    end
    
    typesig { [::Java::Int, SwtGC, ::Java::Int, Color] }
    # Paints a single model line onto <code>gc</code>.
    # 
    # @param line the model line to paint
    # @param gc the {@link GC} to paint onto
    # @param width the width of the column
    # @param deletionColor the background color used to indicate deletions
    def paint_line(line, gc, width, deletion_color)
      widget_line = JFaceTextUtil.model_line_to_widget_line(@f_viewer, line)
      if ((widget_line).equal?(-1))
        return
      end
      info = get_diff_info(line)
      if (!(info).nil?)
        y = @f_widget.get_line_pixel(widget_line)
        line_height = @f_widget.get_line_height(@f_widget.get_offset_at_line(widget_line))
        # draw background color if special
        if (has_special_color(info))
          gc.set_background(get_color(info))
          gc.fill_rectangle(0, y, width, line_height)
        end
        # Deletion Indicator: Simply a horizontal line
        del_before = info.get_removed_lines_above
        del_below = info.get_removed_lines_below
        if (del_before > 0 || del_below > 0)
          gc.set_foreground(deletion_color)
          if (del_before > 0)
            gc.draw_line(0, y, width, y)
          end
          if (del_below > 0)
            gc.draw_line(0, y + line_height - 1, width, y + line_height - 1)
          end
        end
      end
    end
    
    typesig { [ILineDiffInfo] }
    # Returns whether the line background differs from the default.
    # 
    # @param info the info being queried
    # @return <code>true</code> if <code>info</code> describes either a changed or an added
    # line.
    def has_special_color(info)
      return (info.get_change_type).equal?(ILineDiffInfo::ADDED) || (info.get_change_type).equal?(ILineDiffInfo::CHANGED)
    end
    
    typesig { [::Java::Int] }
    # Retrieves the <code>ILineDiffInfo</code> for <code>line</code> from the model. There are
    # optimizations for direct access and sequential access patterns.
    # 
    # @param line the line we want the info for.
    # @return the <code>ILineDiffInfo</code> for <code>line</code>, or <code>null</code>.
    def get_diff_info(line)
      if (!(@f_line_differ).nil?)
        return @f_line_differ.get_line_info(line)
      end
      return nil
    end
    
    typesig { [] }
    # Returns the color for deleted lines.
    # 
    # @return the color to be used for the deletion indicator
    def get_deletion_color
      return (@f_deleted_color).nil? ? get_background : @f_deleted_color
    end
    
    typesig { [ILineDiffInfo] }
    # Returns the color for the given line diff info.
    # 
    # @param info the <code>ILineDiffInfo</code> being queried
    # @return the correct background color for the line type being described by <code>info</code>
    def get_color(info)
      Assert.is_true(!(info).nil? && !(info.get_change_type).equal?(ILineDiffInfo::UNCHANGED))
      ret = nil
      case (info.get_change_type)
      when ILineDiffInfo::CHANGED
        ret = get_shaded_color(@f_changed_color)
      when ILineDiffInfo::ADDED
        ret = get_shaded_color(@f_added_color)
      end
      return (ret).nil? ? get_background : ret
    end
    
    typesig { [Color] }
    # Sets the background color for changed lines.
    # 
    # @param color the new color to be used for the changed lines background
    # @return the shaded color
    def get_shaded_color(color)
      if ((color).nil?)
        return nil
      end
      if ((@f_shared_colors).nil?)
        return color
      end
      base_rgb = color.get_rgb
      background = get_background.get_rgb
      dark_base = is_dark(base_rgb)
      dark_background = is_dark(background)
      if (dark_base && dark_background)
        background = RGB.new(255, 255, 255)
      else
        if (!dark_base && !dark_background)
          background = RGB.new(0, 0, 0)
        end
      end
      return @f_shared_colors.get_color(interpolate(base_rgb, background, 0.6))
    end
    
    typesig { [IAnnotationModel] }
    # Sets the annotation model.
    # 
    # @param model the annotation model, possibly <code>null</code>
    # @see IVerticalRulerColumn#setModel(IAnnotationModel)
    def set_model(model)
      new_model = nil
      if (model.is_a?(IAnnotationModelExtension))
        new_model = (model).get_annotation_model(IChangeRulerColumn::QUICK_DIFF_MODEL_ID)
      else
        new_model = model
      end
      set_differ(new_model)
    end
    
    typesig { [IAnnotationModel] }
    # Sets the line differ.
    # 
    # @param differ the line differ
    def set_differ(differ)
      if (differ.is_a?(ILineDiffer))
        if (!(@f_line_differ).equal?(differ))
          if (!(@f_line_differ).nil?)
            (@f_line_differ).remove_annotation_model_listener(@f_annotation_listener)
          end
          @f_line_differ = differ
          if (!(@f_line_differ).nil?)
            (@f_line_differ).add_annotation_model_listener(@f_annotation_listener)
          end
        end
      end
    end
    
    typesig { [] }
    # Triggers a redraw in the display thread.
    def post_redraw
      if (is_connected && !@f_control.is_disposed)
        d = @f_control.get_display
        if (!(d).nil?)
          d.async_exec(Class.new(Runnable.class == Class ? Runnable : Object) do
            extend LocalClass
            include_class_members DiffPainter
            include Runnable if Runnable.class == Module
            
            typesig { [] }
            define_method :run do
              redraw
            end
            
            typesig { [Vararg.new(Object)] }
            define_method :initialize do |*args|
              super(*args)
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
        end
      end
    end
    
    typesig { [] }
    # Triggers redrawing of the column.
    def redraw
      @f_column.redraw
    end
    
    typesig { [] }
    # Returns the width of the column.
    # 
    # @return the width of the column
    def get_width
      return @f_column.get_width
    end
    
    class_module.module_eval {
      typesig { [ILineRange] }
      # Computes the end index of a line range.
      # 
      # @param range a line range
      # @return the last line (exclusive) of <code>range</code>
      def end_(range)
        return range.get_start_line + range.get_number_of_lines
      end
    }
    
    typesig { [] }
    # Returns the System background color for list widgets or the set background.
    # 
    # @return the System background color for list widgets
    def get_background
      if ((@f_background).nil?)
        return @f_widget.get_display.get_system_color(SWT::COLOR_LIST_BACKGROUND)
      end
      return @f_background
    end
    
    typesig { [Color] }
    # Sets the color for added lines.
    # 
    # @param addedColor the color for added lines
    # @see org.eclipse.jface.text.source.IChangeRulerColumn#setAddedColor(org.eclipse.swt.graphics.Color)
    def set_added_color(added_color)
      @f_added_color = added_color
    end
    
    typesig { [Color] }
    # Sets the color for changed lines.
    # 
    # @param changedColor the color for changed lines
    # @see org.eclipse.jface.text.source.IChangeRulerColumn#setChangedColor(org.eclipse.swt.graphics.Color)
    def set_changed_color(changed_color)
      @f_changed_color = changed_color
    end
    
    typesig { [Color] }
    # Sets the color for deleted lines.
    # 
    # @param deletedColor the color for deleted lines
    # @see org.eclipse.jface.text.source.IChangeRulerColumn#setDeletedColor(org.eclipse.swt.graphics.Color)
    def set_deleted_color(deleted_color)
      @f_deleted_color = deleted_color
    end
    
    typesig { [::Java::Int] }
    # Returns <code>true</code> if the receiver can provide a hover for a certain document line.
    # 
    # @param activeLine the document line of interest
    # @return <code>true</code> if the receiver can provide a hover
    def has_hover(active_line)
      return true
    end
    
    typesig { [::Java::Int] }
    # Returns the display character for the accessibility mode for a certain model line.
    # 
    # @param line the document line of interest
    # @return the display character for <code>line</code>
    def get_display_character(line)
      return get_display_character(get_diff_info(line))
    end
    
    typesig { [ILineDiffInfo] }
    # Returns the character to display in character display mode for the given
    # <code>ILineDiffInfo</code>
    # 
    # @param info the <code>ILineDiffInfo</code> being queried
    # @return the character indication for <code>info</code>
    def get_display_character(info)
      if ((info).nil?)
        return " "
      end # $NON-NLS-1$
      case (info.get_change_type)
      # $NON-NLS-1$
      when ILineDiffInfo::CHANGED
        return "~"
      when ILineDiffInfo::ADDED
        return "+"
      end # $NON-NLS-1$
      return " " # $NON-NLS-1$
    end
    
    class_module.module_eval {
      typesig { [RGB, RGB, ::Java::Double] }
      # Returns a specification of a color that lies between the given foreground and background
      # color using the given scale factor.
      # 
      # @param fg the foreground color
      # @param bg the background color
      # @param scale the scale factor
      # @return the interpolated color
      def interpolate(fg, bg, scale)
        return RGB.new(RJava.cast_to_int(((1.0 - scale) * fg.attr_red + scale * bg.attr_red)), RJava.cast_to_int(((1.0 - scale) * fg.attr_green + scale * bg.attr_green)), RJava.cast_to_int(((1.0 - scale) * fg.attr_blue + scale * bg.attr_blue)))
      end
      
      typesig { [RGB] }
      # Returns the grey value in which the given color would be drawn in grey-scale.
      # 
      # @param rgb the color
      # @return the grey-scale value
      def grey_level(rgb)
        if ((rgb.attr_red).equal?(rgb.attr_green) && (rgb.attr_green).equal?(rgb.attr_blue))
          return rgb.attr_red
        end
        return (0.299 * rgb.attr_red + 0.587 * rgb.attr_green + 0.114 * rgb.attr_blue + 0.5)
      end
      
      typesig { [RGB] }
      # Returns whether the given color is dark or light depending on the colors grey-scale level.
      # 
      # @param rgb the color
      # @return <code>true</code> if the color is dark, <code>false</code> if it is light
      def is_dark(rgb)
        return grey_level(rgb) > 128
      end
    }
    
    typesig { [] }
    # Returns <code>true</code> if diff information is being displayed, <code>false</code> otherwise.
    # 
    # @return <code>true</code> if diff information is being displayed, <code>false</code> otherwise
    # @since 3.3
    def has_information
      if (@f_line_differ.is_a?(ILineDifferExtension2))
        return !(@f_line_differ).is_suspended
      end
      return !(@f_line_differ).nil?
    end
    
    private
    alias_method :initialize__diff_painter, :initialize
  end
  
end
