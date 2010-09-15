require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Source
  module AnnotationBarHoverManagerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Source
      include_const ::Java::Util, :Iterator
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Custom, :StyledText
      include_const ::Org::Eclipse::Swt::Events, :ControlEvent
      include_const ::Org::Eclipse::Swt::Events, :ControlListener
      include_const ::Org::Eclipse::Swt::Events, :DisposeEvent
      include_const ::Org::Eclipse::Swt::Events, :DisposeListener
      include_const ::Org::Eclipse::Swt::Events, :KeyEvent
      include_const ::Org::Eclipse::Swt::Events, :KeyListener
      include_const ::Org::Eclipse::Swt::Events, :MouseEvent
      include_const ::Org::Eclipse::Swt::Events, :MouseListener
      include_const ::Org::Eclipse::Swt::Events, :MouseMoveListener
      include_const ::Org::Eclipse::Swt::Events, :MouseTrackAdapter
      include_const ::Org::Eclipse::Swt::Events, :ShellEvent
      include_const ::Org::Eclipse::Swt::Events, :ShellListener
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Graphics, :Rectangle
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Display
      include_const ::Org::Eclipse::Swt::Widgets, :Event
      include_const ::Org::Eclipse::Swt::Widgets, :Listener
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Jface::Internal::Text, :InformationControlReplacer
      include_const ::Org::Eclipse::Jface::Internal::Text, :InternalAccessor
      include_const ::Org::Eclipse::Jface::Text, :AbstractHoverInformationControlManager
      include_const ::Org::Eclipse::Jface::Text, :AbstractInformationControlManager
      include_const ::Org::Eclipse::Jface::Text, :BadLocationException
      include_const ::Org::Eclipse::Jface::Text, :IDocument
      include_const ::Org::Eclipse::Jface::Text, :IInformationControl
      include_const ::Org::Eclipse::Jface::Text, :IInformationControlCreator
      include_const ::Org::Eclipse::Jface::Text, :IRegion
      include_const ::Org::Eclipse::Jface::Text, :ITextViewerExtension5
      include_const ::Org::Eclipse::Jface::Text, :JFaceTextUtil
      include_const ::Org::Eclipse::Jface::Text, :Region
      include_const ::Org::Eclipse::Jface::Text, :TextUtilities
      include_const ::Org::Eclipse::Jface::Text::ITextViewerExtension8, :EnrichMode
    }
  end
  
  # This manager controls the layout, content, and visibility of an information
  # control in reaction to mouse hover events issued by the vertical ruler of a
  # source viewer.
  # @since 2.0
  class AnnotationBarHoverManager < AnnotationBarHoverManagerImports.const_get :AbstractHoverInformationControlManager
    include_class_members AnnotationBarHoverManagerImports
    
    class_module.module_eval {
      # The information control closer for the hover information. Closes the information control as soon as the mouse pointer leaves the subject area, a mouse button is pressed, the user presses a key, or the subject control is resized or moved.
      # 
      # @since 3.0
      # @deprecated As of 3.4, no longer used as closer from super class is used
      const_set_lazy(:Closer) { Class.new(MouseTrackAdapter) do
        local_class_in AnnotationBarHoverManager
        include_class_members AnnotationBarHoverManager
        overload_protected {
          include IInformationControlCloser
          include MouseListener
          include MouseMoveListener
          include ControlListener
          include KeyListener
          include DisposeListener
          include ShellListener
          include Listener
        }
        
        # The closer's subject control
        attr_accessor :f_subject_control
        alias_method :attr_f_subject_control, :f_subject_control
        undef_method :f_subject_control
        alias_method :attr_f_subject_control=, :f_subject_control=
        undef_method :f_subject_control=
        
        # The subject area
        attr_accessor :f_subject_area
        alias_method :attr_f_subject_area, :f_subject_area
        undef_method :f_subject_area
        alias_method :attr_f_subject_area=, :f_subject_area=
        undef_method :f_subject_area=
        
        # Indicates whether this closer is active
        attr_accessor :f_is_active
        alias_method :attr_f_is_active, :f_is_active
        undef_method :f_is_active
        alias_method :attr_f_is_active=, :f_is_active=
        undef_method :f_is_active=
        
        # The information control.
        attr_accessor :f_information_control_to_close
        alias_method :attr_f_information_control_to_close, :f_information_control_to_close
        undef_method :f_information_control_to_close
        alias_method :attr_f_information_control_to_close=, :f_information_control_to_close=
        undef_method :f_information_control_to_close=
        
        # <code>true</code> if a wheel handler is installed.
        # @since 3.2
        attr_accessor :f_has_wheel_filter
        alias_method :attr_f_has_wheel_filter, :f_has_wheel_filter
        undef_method :f_has_wheel_filter
        alias_method :attr_f_has_wheel_filter=, :f_has_wheel_filter=
        undef_method :f_has_wheel_filter=
        
        # The cached display.
        # @since 3.2
        attr_accessor :f_display
        alias_method :attr_f_display, :f_display
        undef_method :f_display
        alias_method :attr_f_display=, :f_display=
        undef_method :f_display=
        
        typesig { [] }
        # Creates a new information control closer.
        def initialize
          @f_subject_control = nil
          @f_subject_area = nil
          @f_is_active = false
          @f_information_control_to_close = nil
          @f_has_wheel_filter = false
          @f_display = nil
          super()
          @f_is_active = false
          @f_has_wheel_filter = false
        end
        
        typesig { [class_self::Control] }
        # @see IInformationControlCloser#setSubjectControl(Control)
        def set_subject_control(control)
          @f_subject_control = control
        end
        
        typesig { [class_self::IInformationControl] }
        # @see IInformationControlCloser#setHoverControl(IHoverControl)
        def set_information_control(control)
          @f_information_control_to_close = control
        end
        
        typesig { [class_self::Rectangle] }
        # @see IInformationControlCloser#start(Rectangle)
        def start(subject_area)
          if (@f_is_active)
            return
          end
          @f_is_active = true
          @f_subject_area = subject_area
          @f_information_control_to_close.add_dispose_listener(self)
          if (!(@f_subject_control).nil? && !@f_subject_control.is_disposed)
            @f_subject_control.add_mouse_listener(self)
            @f_subject_control.add_mouse_move_listener(self)
            @f_subject_control.add_mouse_track_listener(self)
            @f_subject_control.get_shell.add_shell_listener(self)
            @f_subject_control.add_control_listener(self)
            @f_subject_control.add_key_listener(self)
            @f_display = @f_subject_control.get_display
            if (!@f_display.is_disposed && self.attr_f_hide_on_mouse_wheel)
              @f_has_wheel_filter = true
              @f_display.add_filter(SWT::MouseWheel, self)
            end
          end
        end
        
        typesig { [] }
        # @see IInformationControlCloser#stop()
        def stop
          if (!@f_is_active)
            return
          end
          @f_is_active = false
          if (!(@f_subject_control).nil? && !@f_subject_control.is_disposed)
            @f_subject_control.remove_mouse_listener(self)
            @f_subject_control.remove_mouse_move_listener(self)
            @f_subject_control.remove_mouse_track_listener(self)
            @f_subject_control.get_shell.remove_shell_listener(self)
            @f_subject_control.remove_control_listener(self)
            @f_subject_control.remove_key_listener(self)
          end
          if (!(@f_display).nil? && !@f_display.is_disposed && @f_has_wheel_filter)
            @f_display.remove_filter(SWT::MouseWheel, self)
          end
          @f_has_wheel_filter = false
          @f_display = nil
        end
        
        typesig { [::Java::Boolean] }
        # Stops the information control and if <code>delayRestart</code> is set allows restart only after a certain delay.
        # 
        # @param delayRestart <code>true</code> if restart should be delayed
        # @deprecated As of 3.4, replaced by {@link #stop()}. Note that <code>delayRestart</code> was never honored.
        def stop(delay_restart)
          stop
        end
        
        typesig { [class_self::MouseEvent] }
        # @see org.eclipse.swt.events.MouseMoveListener#mouseMove(org.eclipse.swt.events.MouseEvent)
        def mouse_move(event)
          if (!@f_subject_area.contains(event.attr_x, event.attr_y))
            hide_information_control
          end
        end
        
        typesig { [class_self::MouseEvent] }
        # @see org.eclipse.swt.events.MouseListener#mouseUp(org.eclipse.swt.events.MouseEvent)
        def mouse_up(event)
        end
        
        typesig { [class_self::MouseEvent] }
        # @see MouseListener#mouseDown(MouseEvent)
        def mouse_down(event)
          hide_information_control
        end
        
        typesig { [class_self::MouseEvent] }
        # @see MouseListener#mouseDoubleClick(MouseEvent)
        def mouse_double_click(event)
          hide_information_control
        end
        
        typesig { [class_self::Event] }
        # @see org.eclipse.swt.widgets.Listener#handleEvent(org.eclipse.swt.widgets.Event)
        # @since 3.2
        def handle_event(event)
          if ((event.attr_type).equal?(SWT::MouseWheel))
            hide_information_control
          end
        end
        
        typesig { [class_self::MouseEvent] }
        # @see MouseTrackAdapter#mouseExit(MouseEvent)
        def mouse_exit(event)
          if (!self.attr_f_allow_mouse_exit)
            hide_information_control
          end
        end
        
        typesig { [class_self::ControlEvent] }
        # @see ControlListener#controlResized(ControlEvent)
        def control_resized(event)
          hide_information_control
        end
        
        typesig { [class_self::ControlEvent] }
        # @see ControlListener#controlMoved(ControlEvent)
        def control_moved(event)
          hide_information_control
        end
        
        typesig { [class_self::KeyEvent] }
        # @see KeyListener#keyReleased(KeyEvent)
        def key_released(event)
        end
        
        typesig { [class_self::KeyEvent] }
        # @see KeyListener#keyPressed(KeyEvent)
        def key_pressed(event)
          hide_information_control
        end
        
        typesig { [class_self::ShellEvent] }
        # @see org.eclipse.swt.events.ShellListener#shellActivated(org.eclipse.swt.events.ShellEvent)
        # @since 3.1
        def shell_activated(e)
        end
        
        typesig { [class_self::ShellEvent] }
        # @see org.eclipse.swt.events.ShellListener#shellClosed(org.eclipse.swt.events.ShellEvent)
        # @since 3.1
        def shell_closed(e)
        end
        
        typesig { [class_self::ShellEvent] }
        # @see org.eclipse.swt.events.ShellListener#shellDeactivated(org.eclipse.swt.events.ShellEvent)
        # @since 3.1
        def shell_deactivated(e)
          hide_information_control
        end
        
        typesig { [class_self::ShellEvent] }
        # @see org.eclipse.swt.events.ShellListener#shellDeiconified(org.eclipse.swt.events.ShellEvent)
        # @since 3.1
        def shell_deiconified(e)
        end
        
        typesig { [class_self::ShellEvent] }
        # @see org.eclipse.swt.events.ShellListener#shellIconified(org.eclipse.swt.events.ShellEvent)
        # @since 3.1
        def shell_iconified(e)
        end
        
        typesig { [class_self::DisposeEvent] }
        # @see org.eclipse.swt.events.DisposeListener#widgetDisposed(org.eclipse.swt.events.DisposeEvent)
        def widget_disposed(e)
          hide_information_control
        end
        
        private
        alias_method :initialize__closer, :initialize
      end }
    }
    
    # The source viewer the manager is connected to
    attr_accessor :f_source_viewer
    alias_method :attr_f_source_viewer, :f_source_viewer
    undef_method :f_source_viewer
    alias_method :attr_f_source_viewer=, :f_source_viewer=
    undef_method :f_source_viewer=
    
    # The vertical ruler the manager is registered with
    attr_accessor :f_vertical_ruler_info
    alias_method :attr_f_vertical_ruler_info, :f_vertical_ruler_info
    undef_method :f_vertical_ruler_info
    alias_method :attr_f_vertical_ruler_info=, :f_vertical_ruler_info=
    undef_method :f_vertical_ruler_info=
    
    # The annotation hover the manager uses to retrieve the information to display. Can be <code>null</code>.
    attr_accessor :f_annotation_hover
    alias_method :attr_f_annotation_hover, :f_annotation_hover
    undef_method :f_annotation_hover
    alias_method :attr_f_annotation_hover=, :f_annotation_hover=
    undef_method :f_annotation_hover=
    
    # Indicates whether the mouse cursor is allowed to leave the subject area without closing the hover.
    # @since 3.0
    attr_accessor :f_allow_mouse_exit
    alias_method :attr_f_allow_mouse_exit, :f_allow_mouse_exit
    undef_method :f_allow_mouse_exit
    alias_method :attr_f_allow_mouse_exit=, :f_allow_mouse_exit=
    undef_method :f_allow_mouse_exit=
    
    # Whether we should hide the over on mouse wheel action.
    # 
    # @since 3.2
    attr_accessor :f_hide_on_mouse_wheel
    alias_method :attr_f_hide_on_mouse_wheel, :f_hide_on_mouse_wheel
    undef_method :f_hide_on_mouse_wheel
    alias_method :attr_f_hide_on_mouse_wheel=, :f_hide_on_mouse_wheel=
    undef_method :f_hide_on_mouse_wheel=
    
    # The current annotation hover.
    # @since 3.2
    attr_accessor :f_current_hover
    alias_method :attr_f_current_hover, :f_current_hover
    undef_method :f_current_hover
    alias_method :attr_f_current_hover=, :f_current_hover=
    undef_method :f_current_hover=
    
    typesig { [ISourceViewer, IVerticalRuler, IAnnotationHover, IInformationControlCreator] }
    # Creates an annotation hover manager with the given parameters. In addition,
    # the hovers anchor is RIGHT and the margin is 5 points to the right.
    # 
    # @param sourceViewer the source viewer this manager connects to
    # @param ruler the vertical ruler this manager connects to
    # @param annotationHover the annotation hover providing the information to be displayed
    # @param creator the information control creator
    # @deprecated As of 2.1, replaced by {@link AnnotationBarHoverManager#AnnotationBarHoverManager(IVerticalRulerInfo, ISourceViewer, IAnnotationHover, IInformationControlCreator)}
    def initialize(source_viewer, ruler, annotation_hover, creator)
      initialize__annotation_bar_hover_manager(ruler, source_viewer, annotation_hover, creator)
    end
    
    typesig { [IVerticalRulerInfo, ISourceViewer, IAnnotationHover, IInformationControlCreator] }
    # Creates an annotation hover manager with the given parameters. In addition,
    # the hovers anchor is RIGHT and the margin is 5 points to the right.
    # 
    # @param rulerInfo the vertical ruler this manager connects to
    # @param sourceViewer the source viewer this manager connects to
    # @param annotationHover the annotation hover providing the information to be displayed or <code>null</code> if none
    # @param creator the information control creator
    # @since 2.1
    def initialize(ruler_info, source_viewer, annotation_hover, creator)
      @f_source_viewer = nil
      @f_vertical_ruler_info = nil
      @f_annotation_hover = nil
      @f_allow_mouse_exit = false
      @f_hide_on_mouse_wheel = false
      @f_current_hover = nil
      super(creator)
      @f_allow_mouse_exit = false
      @f_hide_on_mouse_wheel = true
      Assert.is_not_null(source_viewer)
      @f_source_viewer = source_viewer
      @f_vertical_ruler_info = ruler_info
      @f_annotation_hover = annotation_hover
      set_anchor(ANCHOR_RIGHT)
      set_margins(5, 0)
      # use closer from super class
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.AbstractInformationControlManager#computeInformation()
    def compute_information
      @f_allow_mouse_exit = false
      event = get_hover_event
      if (!((event.attr_state_mask & SWT::BUTTON_MASK)).equal?(0))
        set_information(nil, nil)
        return
      end
      hover = get_hover(event)
      if ((hover).nil?)
        set_information(nil, nil)
        return
      end
      line = get_hover_line(event)
      if (hover.is_a?(IAnnotationHoverExtension))
        extension = hover
        range = extension.get_hover_line_range(@f_source_viewer, line)
        set_custom_information_control_creator(extension.get_hover_control_creator)
        range = adapt_line_range(range, line)
        if (!(range).nil?)
          set_information(extension.get_hover_info(@f_source_viewer, range, compute_number_of_visible_lines), compute_area(range))
        else
          set_information(nil, nil)
        end
      else
        set_custom_information_control_creator(nil)
        set_information(hover.get_hover_info(@f_source_viewer, line), compute_area(line))
      end
    end
    
    typesig { [Rectangle] }
    # @see org.eclipse.jface.text.AbstractInformationControlManager#showInformationControl(org.eclipse.swt.graphics.Rectangle)
    # @since 3.2
    def show_information_control(subject_area)
      super(subject_area)
      @f_current_hover = get_hover(get_hover_event)
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.AbstractInformationControlManager#hideInformationControl()
    # @since 3.2
    def hide_information_control
      @f_current_hover = nil
      super
    end
    
    typesig { [ILineRange, ::Java::Int] }
    # Adapts a given line range so that the result is a line range that does
    # not overlap with any collapsed region and fits into the view port of the
    # attached viewer.
    # 
    # @param lineRange the original line range
    # @param line the anchor line
    # @return the adapted line range
    # @since 3.0
    def adapt_line_range(line_range, line)
      if (!(line_range).nil?)
        line_range = adapt_line_range_to_folding(line_range, line)
        if (!(line_range).nil?)
          return adapt_line_range_to_viewport(line_range)
        end
      end
      return nil
    end
    
    typesig { [ILineRange, ::Java::Int] }
    # Adapts a given line range so that the result is a line range that does
    # not overlap with any collapsed region of the attached viewer.
    # 
    # @param lineRange the original line range
    # @param line the anchor line
    # @return the adapted line range
    # @since 3.0
    def adapt_line_range_to_folding(line_range, line)
      if (@f_source_viewer.is_a?(ITextViewerExtension5))
        extension = @f_source_viewer
        begin
          region = convert_to_region(line_range)
          coverage = extension.get_covered_model_ranges(region)
          if (!(coverage).nil? && coverage.attr_length > 0)
            container = find_region_containing_line(coverage, line)
            if (!(container).nil?)
              return convert_to_line_range(container)
            end
          end
        rescue BadLocationException => x
        end
        return nil
      end
      return line_range
    end
    
    typesig { [ILineRange] }
    # Adapts a given line range so that the result is a line range that fits
    # into the view port of the attached viewer.
    # 
    # @param lineRange the original line range
    # @return the adapted line range
    # @since 3.0
    def adapt_line_range_to_viewport(line_range)
      begin
        text = @f_source_viewer.get_text_widget
        top_line = text.get_top_index
        range_top_line = get_widget_line_number(line_range.get_start_line)
        top_delta = Math.max(top_line - range_top_line, 0)
        size = text.get_client_area
        trim = text.compute_trim(0, 0, 0, 0)
        height = size.attr_height - trim.attr_height
        lines = JFaceTextUtil.get_line_index(text, height) - text.get_top_index
        bottom_line = top_line + lines
        range_bottom_line = get_widget_line_number(line_range.get_start_line + line_range.get_number_of_lines - 1)
        bottom_delta = Math.max(range_bottom_line - bottom_line, 0)
        return LineRange.new(line_range.get_start_line + top_delta, line_range.get_number_of_lines - bottom_delta - top_delta)
      rescue BadLocationException => ex
      end
      return nil
    end
    
    typesig { [ILineRange] }
    # Converts a line range into a character range.
    # 
    # @param lineRange the line range
    # @return the corresponding character range
    # @throws BadLocationException in case the given line range is invalid
    def convert_to_region(line_range)
      document = @f_source_viewer.get_document
      start_offset = document.get_line_offset(line_range.get_start_line)
      end_line = line_range.get_start_line + Math.max(0, line_range.get_number_of_lines - 1)
      line_info = document.get_line_information(end_line)
      end_offset = line_info.get_offset + line_info.get_length
      return Region.new(start_offset, end_offset - start_offset)
    end
    
    typesig { [Array.typed(IRegion), ::Java::Int] }
    # Returns the region out of the given set that contains the given line or
    # <code>null</code>.
    # 
    # @param regions the set of regions
    # @param line the line
    # @return the region of the set that contains the line
    # @throws BadLocationException in case line is invalid
    def find_region_containing_line(regions, line)
      document = @f_source_viewer.get_document
      line_info = document.get_line_information(line)
      i = 0
      while i < regions.attr_length
        if (TextUtilities.overlaps(regions[i], line_info))
          return regions[i]
        end
        i += 1
      end
      return nil
    end
    
    typesig { [IRegion] }
    # Converts a given character region into a line range.
    # 
    # @param region the character region
    # @return the corresponding line range
    # @throws BadLocationException in case the given region in invalid
    def convert_to_line_range(region)
      document = @f_source_viewer.get_document
      start_line = document.get_line_of_offset(region.get_offset)
      end_line = document.get_line_of_offset(region.get_offset + region.get_length)
      return LineRange.new(start_line, end_line - start_line + 1)
    end
    
    typesig { [ILineRange] }
    # Returns the visible area of the vertical ruler covered by the given line
    # range.
    # 
    # @param lineRange the line range
    # @return the visible area
    def compute_area(line_range)
      begin
        text = @f_source_viewer.get_text_widget
        start_line = get_widget_line_number(line_range.get_start_line)
        y = JFaceTextUtil.compute_line_height(text, 0, start_line, start_line) - text.get_top_pixel
        height = JFaceTextUtil.compute_line_height(text, start_line, start_line + line_range.get_number_of_lines, line_range.get_number_of_lines)
        size = @f_vertical_ruler_info.get_control.get_size
        return Rectangle.new(0, y, size.attr_x, height)
      rescue BadLocationException => x
      end
      return nil
    end
    
    typesig { [] }
    # Returns the number of the currently visible lines.
    # 
    # @return the number of the currently visible lines
    # @deprecated to avoid deprecation warning
    def compute_number_of_visible_lines
      # Hack to reduce amount of copied code.
      return LineNumberRulerColumn.get_visible_lines_in_viewport(@f_source_viewer.get_text_widget)
    end
    
    typesig { [MouseEvent] }
    # Determines the hover to be used to display information based on the source of the
    # mouse hover event. If <code>fVerticalRulerInfo</code> is not a composite ruler, the
    # standard hover is returned.
    # 
    # @param event the source of the mouse hover event
    # @return the hover depending on <code>source</code>, or <code>fAnnotationHover</code> if none can be found.
    # @since 3.0
    def get_hover(event)
      if ((event).nil? || (event.get_source).nil?)
        return @f_annotation_hover
      end
      if (@f_vertical_ruler_info.is_a?(CompositeRuler))
        comp = @f_vertical_ruler_info
        it = comp.get_decorator_iterator
        while it.has_next
          o = it.next_
          if (o.is_a?(IVerticalRulerInfoExtension) && o.is_a?(IVerticalRulerInfo))
            if (((o).get_control).equal?(event.get_source))
              hover = (o).get_hover
              if (!(hover).nil?)
                return hover
              end
            end
          end
        end
      end
      return @f_annotation_hover
    end
    
    typesig { [MouseEvent] }
    # Returns the line of interest deduced from the mouse hover event.
    # 
    # @param event a mouse hover event that triggered hovering
    # @return the document model line number on which the hover event occurred or <code>-1</code> if there is no event
    # @since 3.0
    def get_hover_line(event)
      return (event).nil? ? -1 : @f_vertical_ruler_info.to_document_line_number(event.attr_y)
    end
    
    typesig { [::Java::Int] }
    # Returns for the widget line number for the given document line number.
    # 
    # @param line the absolute line number
    # @return the line number relative to the viewer's visible region
    # @throws BadLocationException if <code>line</code> is not valid in the viewer's document
    def get_widget_line_number(line)
      if (@f_source_viewer.is_a?(ITextViewerExtension5))
        extension = @f_source_viewer
        return extension.model_line2widget_line(line)
      end
      region = @f_source_viewer.get_visible_region
      first_line = @f_source_viewer.get_document.get_line_of_offset(region.get_offset)
      return line - first_line
    end
    
    typesig { [::Java::Int] }
    # Determines graphical area covered by the given line.
    # 
    # @param line the number of the line in the viewer whose graphical extend in the vertical ruler must be computed
    # @return the graphical extend of the given line
    def compute_area(line)
      begin
        text = @f_source_viewer.get_text_widget
        widget_line = get_widget_line_number(line)
        y = JFaceTextUtil.compute_line_height(text, 0, widget_line, widget_line) - text.get_top_pixel
        size = @f_vertical_ruler_info.get_control.get_size
        return Rectangle.new(0, y, size.attr_x, text.get_line_height(text.get_offset_at_line(widget_line)))
      rescue IllegalArgumentException => ex
      rescue BadLocationException => ex
      end
      return nil
    end
    
    typesig { [] }
    # Returns the annotation hover for this hover manager.
    # 
    # @return the annotation hover for this hover manager or <code>null</code> if none
    # @since 2.1
    def get_annotation_hover
      return @f_annotation_hover
    end
    
    typesig { [] }
    # Returns the source viewer for this hover manager.
    # 
    # @return the source viewer for this hover manager
    # @since 2.1
    def get_source_viewer
      return @f_source_viewer
    end
    
    typesig { [] }
    # Returns the vertical ruler info for this hover manager
    # 
    # @return the vertical ruler info for this hover manager
    # @since 2.1
    def get_vertical_ruler_info
      return @f_vertical_ruler_info
    end
    
    typesig { [Control, Rectangle, IInformationControl] }
    # @see org.eclipse.jface.text.AbstractInformationControlManager#computeSizeConstraints(org.eclipse.swt.widgets.Control, org.eclipse.swt.graphics.Rectangle, org.eclipse.jface.text.IInformationControl)
    # @since 3.0
    def compute_size_constraints(subject_control, subject_area, information_control)
      constraints = super(subject_control, subject_area, information_control)
      # make as big as text area, if possible
      styled_text = @f_source_viewer.get_text_widget
      if (!(styled_text).nil?)
        r = styled_text.get_client_area
        if (!(r).nil?)
          constraints.attr_x = r.attr_width
          constraints.attr_y = r.attr_height
        end
      end
      return constraints
    end
    
    typesig { [Rectangle, Point, Anchor] }
    # @see org.eclipse.jface.text.AbstractInformationControlManager#computeLocation(org.eclipse.swt.graphics.Rectangle, org.eclipse.swt.graphics.Point, org.eclipse.jface.text.AbstractInformationControlManager.Anchor)
    # @since 3.0
    def compute_location(subject_area, control_size, anchor)
      event = get_hover_event
      hover = get_hover(event)
      allow_mouse_exit = false
      if (hover.is_a?(IAnnotationHoverExtension))
        extension = hover
        allow_mouse_exit = extension.can_handle_mouse_cursor
      end
      hide_on_mouse_wheel = true
      if (hover.is_a?(IAnnotationHoverExtension2))
        extension = hover
        hide_on_mouse_wheel = !extension.can_handle_mouse_wheel
      end
      @f_hide_on_mouse_wheel = hide_on_mouse_wheel
      if (allow_mouse_exit)
        @f_allow_mouse_exit = true
        subject_control = get_subject_control
        # return a location that just overlaps the annotation on the bar
        if ((anchor).equal?(AbstractInformationControlManager::ANCHOR_RIGHT))
          return subject_control.to_display(subject_area.attr_x - 4, subject_area.attr_y - 2)
        else
          if ((anchor).equal?(AbstractInformationControlManager::ANCHOR_LEFT))
            return subject_control.to_display(subject_area.attr_x + subject_area.attr_width - control_size.attr_x + 4, subject_area.attr_y - 2)
          end
        end
      end
      @f_allow_mouse_exit = false
      return super(subject_area, control_size, anchor)
    end
    
    typesig { [] }
    # Returns the currently shown annotation hover or <code>null</code> if none
    # hover is shown.
    # 
    # @return the currently shown annotation hover or <code>null</code>
    # @since 3.2
    def get_current_annotation_hover
      return @f_current_hover
    end
    
    typesig { [] }
    # Returns an adapter that gives access to internal methods.
    # <p>
    # <strong>Note:</strong> This method is not intended to be referenced or overridden by clients.
    # </p>
    # 
    # @return the replaceable information control accessor
    # @since 3.4
    # @noreference This method is not intended to be referenced by clients.
    # @nooverride This method is not intended to be re-implemented or extended by clients.
    def get_internal_accessor
      return Class.new(InternalAccessor.class == Class ? InternalAccessor : Object) do
        local_class_in AnnotationBarHoverManager
        include_class_members AnnotationBarHoverManager
        include InternalAccessor if InternalAccessor.class == Module
        
        typesig { [] }
        define_method :get_current_information_control do
          return AnnotationBarHoverManager.superclass.instance_method(:get_internal_accessor).bind(self).call.get_current_information_control
        end
        
        typesig { [InformationControlReplacer] }
        define_method :set_information_control_replacer do |replacer|
          AnnotationBarHoverManager.superclass.instance_method(:get_internal_accessor).bind(self).call.set_information_control_replacer(replacer)
        end
        
        typesig { [] }
        define_method :get_information_control_replacer do
          return AnnotationBarHoverManager.superclass.instance_method(:get_internal_accessor).bind(self).call.get_information_control_replacer
        end
        
        typesig { [IInformationControl] }
        define_method :can_replace do |control|
          return AnnotationBarHoverManager.superclass.instance_method(:get_internal_accessor).bind(self).call.can_replace(control)
        end
        
        typesig { [] }
        define_method :is_replace_in_progress do
          return AnnotationBarHoverManager.superclass.instance_method(:get_internal_accessor).bind(self).call.is_replace_in_progress
        end
        
        typesig { [::Java::Boolean] }
        define_method :replace_information_control do |take_focus|
          AnnotationBarHoverManager.superclass.instance_method(:get_internal_accessor).bind(self).call.replace_information_control(take_focus)
        end
        
        typesig { [Rectangle] }
        define_method :crop_to_closest_monitor do |bounds|
          AnnotationBarHoverManager.superclass.instance_method(:get_internal_accessor).bind(self).call.crop_to_closest_monitor(bounds)
        end
        
        typesig { [EnrichMode] }
        define_method :set_hover_enrich_mode do |mode|
          AnnotationBarHoverManager.superclass.instance_method(:get_internal_accessor).bind(self).call.set_hover_enrich_mode(mode)
        end
        
        typesig { [] }
        define_method :get_allow_mouse_exit do
          return self.attr_f_allow_mouse_exit
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
    end
    
    private
    alias_method :initialize__annotation_bar_hover_manager, :initialize
  end
  
end
