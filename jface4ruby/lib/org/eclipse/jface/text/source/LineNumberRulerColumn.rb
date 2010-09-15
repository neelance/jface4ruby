require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
# Nikolay Botev <bono8106@hotmail.com> - [rulers] Shift clicking in line number column doesn't select range - https://bugs.eclipse.org/bugs/show_bug.cgi?id=32166
# Nikolay Botev <bono8106@hotmail.com> - [rulers] Clicking in line number ruler should not trigger annotation ruler - https://bugs.eclipse.org/bugs/show_bug.cgi?id=40889
module Org::Eclipse::Jface::Text::Source
  module LineNumberRulerColumnImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Source
      include_const ::Java::Util, :Arrays
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Custom, :StyledText
      include_const ::Org::Eclipse::Swt::Events, :DisposeEvent
      include_const ::Org::Eclipse::Swt::Events, :DisposeListener
      include_const ::Org::Eclipse::Swt::Events, :MouseEvent
      include_const ::Org::Eclipse::Swt::Events, :MouseListener
      include_const ::Org::Eclipse::Swt::Events, :MouseMoveListener
      include_const ::Org::Eclipse::Swt::Events, :PaintEvent
      include_const ::Org::Eclipse::Swt::Events, :PaintListener
      include_const ::Org::Eclipse::Swt::Graphics, :Color
      include_const ::Org::Eclipse::Swt::Graphics, :Font
      include_const ::Org::Eclipse::Swt::Graphics, :FontMetrics
      include_const ::Org::Eclipse::Swt::Graphics, :SwtGC
      include_const ::Org::Eclipse::Swt::Graphics, :Image
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Graphics, :Rectangle
      include_const ::Org::Eclipse::Swt::Widgets, :Canvas
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Display
      include_const ::Org::Eclipse::Swt::Widgets, :TypedListener
      include_const ::Org::Eclipse::Jface::Text, :BadLocationException
      include_const ::Org::Eclipse::Jface::Text, :IDocument
      include_const ::Org::Eclipse::Jface::Text, :IRegion
      include_const ::Org::Eclipse::Jface::Text, :ITextListener
      include_const ::Org::Eclipse::Jface::Text, :ITextViewer
      include_const ::Org::Eclipse::Jface::Text, :ITextViewerExtension
      include_const ::Org::Eclipse::Jface::Text, :ITextViewerExtension5
      include_const ::Org::Eclipse::Jface::Text, :IViewportListener
      include_const ::Org::Eclipse::Jface::Text, :JFaceTextUtil
      include_const ::Org::Eclipse::Jface::Text, :TextEvent
    }
  end
  
  # A vertical ruler column displaying line numbers.
  # Clients usually instantiate and configure object of this class.
  # 
  # @since 2.0
  class LineNumberRulerColumn 
    include_class_members LineNumberRulerColumnImports
    include IVerticalRulerColumn
    
    class_module.module_eval {
      # Internal listener class.
      const_set_lazy(:InternalListener) { Class.new do
        local_class_in LineNumberRulerColumn
        include_class_members LineNumberRulerColumn
        include IViewportListener
        include ITextListener
        
        # @since 3.1
        attr_accessor :f_cached_redraw_state
        alias_method :attr_f_cached_redraw_state, :f_cached_redraw_state
        undef_method :f_cached_redraw_state
        alias_method :attr_f_cached_redraw_state=, :f_cached_redraw_state=
        undef_method :f_cached_redraw_state=
        
        typesig { [::Java::Int] }
        # @see IViewportListener#viewportChanged(int)
        def viewport_changed(vertical_position)
          if (@f_cached_redraw_state && !(vertical_position).equal?(self.attr_f_scroll_pos))
            redraw
          end
        end
        
        typesig { [class_self::TextEvent] }
        # @see ITextListener#textChanged(TextEvent)
        def text_changed(event)
          @f_cached_redraw_state = event.get_viewer_redraw_state
          if (!@f_cached_redraw_state)
            return
          end
          if (update_number_of_digits)
            compute_indentations
            layout(event.get_viewer_redraw_state)
            return
          end
          viewer_completely_shown = is_viewer_completely_shown
          if (viewer_completely_shown || self.attr_f_sensitive_to_text_changes || (event.get_document_event).nil?)
            post_redraw
          end
          self.attr_f_sensitive_to_text_changes = viewer_completely_shown
        end
        
        typesig { [] }
        def initialize
          @f_cached_redraw_state = true
        end
        
        private
        alias_method :initialize__internal_listener, :initialize
      end }
      
      # Handles all the mouse interaction in this line number ruler column.
      const_set_lazy(:MouseHandler) { Class.new do
        local_class_in LineNumberRulerColumn
        include_class_members LineNumberRulerColumn
        include MouseListener
        include MouseMoveListener
        
        # The cached view port size.
        attr_accessor :f_cached_viewport_size
        alias_method :attr_f_cached_viewport_size, :f_cached_viewport_size
        undef_method :f_cached_viewport_size
        alias_method :attr_f_cached_viewport_size=, :f_cached_viewport_size=
        undef_method :f_cached_viewport_size=
        
        # The area of the line at which line selection started.
        attr_accessor :f_start_line_offset
        alias_method :attr_f_start_line_offset, :f_start_line_offset
        undef_method :f_start_line_offset
        alias_method :attr_f_start_line_offset=, :f_start_line_offset=
        undef_method :f_start_line_offset=
        
        # The number of the line at which line selection started.
        attr_accessor :f_start_line_number
        alias_method :attr_f_start_line_number, :f_start_line_number
        undef_method :f_start_line_number
        alias_method :attr_f_start_line_number=, :f_start_line_number=
        undef_method :f_start_line_number=
        
        # The auto scroll direction.
        attr_accessor :f_auto_scroll_direction
        alias_method :attr_f_auto_scroll_direction, :f_auto_scroll_direction
        undef_method :f_auto_scroll_direction
        alias_method :attr_f_auto_scroll_direction=, :f_auto_scroll_direction=
        undef_method :f_auto_scroll_direction=
        
        # @since 3.2
        attr_accessor :f_is_listening_for_move
        alias_method :attr_f_is_listening_for_move, :f_is_listening_for_move
        undef_method :f_is_listening_for_move
        alias_method :attr_f_is_listening_for_move=, :f_is_listening_for_move=
        undef_method :f_is_listening_for_move=
        
        typesig { [class_self::MouseEvent] }
        # @see org.eclipse.swt.events.MouseListener#mouseUp(org.eclipse.swt.events.MouseEvent)
        def mouse_up(event)
          # see bug 45700
          if ((event.attr_button).equal?(1))
            stop_selecting
            stop_auto_scroll
          end
        end
        
        typesig { [class_self::MouseEvent] }
        # @see org.eclipse.swt.events.MouseListener#mouseDown(org.eclipse.swt.events.MouseEvent)
        def mouse_down(event)
          self.attr_f_parent_ruler.set_location_of_last_mouse_button_activity(event.attr_x, event.attr_y)
          # see bug 45700
          if ((event.attr_button).equal?(1))
            start_selecting(!((event.attr_state_mask & SWT::SHIFT)).equal?(0))
          end
        end
        
        typesig { [class_self::MouseEvent] }
        # @see org.eclipse.swt.events.MouseListener#mouseDoubleClick(org.eclipse.swt.events.MouseEvent)
        def mouse_double_click(event)
          self.attr_f_parent_ruler.set_location_of_last_mouse_button_activity(event.attr_x, event.attr_y)
          stop_selecting
          stop_auto_scroll
        end
        
        typesig { [class_self::MouseEvent] }
        # @see org.eclipse.swt.events.MouseMoveListener#mouseMove(org.eclipse.swt.events.MouseEvent)
        def mouse_move(event)
          if (@f_is_listening_for_move && !auto_scroll(event))
            new_line = self.attr_f_parent_ruler.to_document_line_number(event.attr_y)
            expand_selection(new_line)
          end
          self.attr_f_parent_ruler.set_location_of_last_mouse_button_activity(event.attr_x, event.attr_y)
        end
        
        typesig { [::Java::Boolean] }
        # Called when line drag selection started. Adds mouse move and track
        # listeners to this column's control.
        # 
        # @param expandExistingSelection if <code>true</code> the existing selection will be expanded,
        # otherwise a new selection is started
        def start_selecting(expand_existing_selection)
          begin
            # select line
            document = self.attr_f_cached_text_viewer.get_document
            line_number = self.attr_f_parent_ruler.get_line_of_last_mouse_button_activity
            if (expand_existing_selection && self.attr_f_cached_text_viewer.is_a?(self.class::ITextViewerExtension5) && !(self.attr_f_cached_text_viewer.get_text_widget).nil?)
              extension5 = (self.attr_f_cached_text_viewer)
              # Find model curosr position
              widget_caret = self.attr_f_cached_text_viewer.get_text_widget.get_caret_offset
              model_caret = extension5.widget_offset2model_offset(widget_caret)
              # Find model selection range
              selection = self.attr_f_cached_text_viewer.get_selected_range
              # Start from tail of selection range (opposite of cursor position)
              start_offset = (model_caret).equal?(selection.attr_x) ? selection.attr_x + selection.attr_y : selection.attr_x
              @f_start_line_number = document.get_line_of_offset(start_offset)
              @f_start_line_offset = start_offset
              expand_selection(line_number)
            else
              @f_start_line_number = line_number
              @f_start_line_offset = document.get_line_information(@f_start_line_number).get_offset
              self.attr_f_cached_text_viewer.set_selected_range(@f_start_line_offset, 0)
            end
            @f_cached_viewport_size = get_visible_lines_in_viewport
            # prepare for drag selection
            @f_is_listening_for_move = true
          rescue self.class::BadLocationException => x
          end
        end
        
        typesig { [] }
        # Called when line drag selection stopped. Removes all previously
        # installed listeners from this column's control.
        def stop_selecting
          # drag selection stopped
          @f_is_listening_for_move = false
        end
        
        typesig { [::Java::Int] }
        # Expands the line selection from the remembered start line to the
        # given line.
        # 
        # @param lineNumber the line to which to expand the selection
        def expand_selection(line_number)
          begin
            document = self.attr_f_cached_text_viewer.get_document
            line_info = document.get_line_information(line_number)
            display = self.attr_f_cached_text_widget.get_display
            absolute_position = display.get_cursor_location
            relative_position = self.attr_f_cached_text_widget.to_control(absolute_position)
            offset = 0
            if (relative_position.attr_x < 0)
              offset = line_info.get_offset
            else
              begin
                widget_offset = self.attr_f_cached_text_widget.get_offset_at_location(relative_position)
                p = self.attr_f_cached_text_widget.get_location_at_offset(widget_offset)
                if (p.attr_x > relative_position.attr_x)
                  widget_offset -= 1
                end
                # Convert to model offset
                if (self.attr_f_cached_text_viewer.is_a?(self.class::ITextViewerExtension5))
                  extension = self.attr_f_cached_text_viewer
                  offset = extension.widget_offset2model_offset(widget_offset)
                else
                  offset = widget_offset + self.attr_f_cached_text_viewer.get_visible_region.get_offset
                end
              rescue self.class::IllegalArgumentException => ex
                line_end_offset = line_info.get_offset + line_info.get_length
                # Convert to widget offset
                line_end_widget_offset = 0
                if (self.attr_f_cached_text_viewer.is_a?(self.class::ITextViewerExtension5))
                  extension = self.attr_f_cached_text_viewer
                  line_end_widget_offset = extension.model_offset2widget_offset(line_end_offset)
                else
                  line_end_widget_offset = line_end_offset - self.attr_f_cached_text_viewer.get_visible_region.get_offset
                end
                p_ = self.attr_f_cached_text_widget.get_location_at_offset(line_end_widget_offset)
                if (p_.attr_x < relative_position.attr_x)
                  offset = line_end_offset
                else
                  offset = line_info.get_offset
                end
              end
            end
            start = Math.min(@f_start_line_offset, offset)
            end_ = Math.max(@f_start_line_offset, offset)
            if (line_number < @f_start_line_number)
              self.attr_f_cached_text_viewer.set_selected_range(end_, start - end_)
            else
              self.attr_f_cached_text_viewer.set_selected_range(start, end_ - start)
            end
          rescue self.class::BadLocationException => x
          end
        end
        
        typesig { [] }
        # Called when auto scrolling stopped. Clears the auto scroll direction.
        def stop_auto_scroll
          @f_auto_scroll_direction = SWT::NULL
        end
        
        typesig { [class_self::MouseEvent] }
        # Called on drag selection.
        # 
        # @param event the mouse event caught by the mouse move listener
        # @return <code>true</code> if scrolling happened, <code>false</code> otherwise
        def auto_scroll(event)
          area = self.attr_f_canvas.get_client_area
          if (event.attr_y > area.attr_height)
            auto_scroll(SWT::DOWN)
            return true
          end
          if (event.attr_y < 0)
            auto_scroll(SWT::UP)
            return true
          end
          stop_auto_scroll
          return false
        end
        
        typesig { [::Java::Int] }
        # Scrolls the viewer into the given direction.
        # 
        # @param direction the scroll direction
        def auto_scroll(direction)
          if ((@f_auto_scroll_direction).equal?(direction))
            return
          end
          timer_interval = 5
          display = self.attr_f_canvas.get_display
          timer = nil
          case (direction)
          when SWT::UP
            timer = Class.new(self.class::Runnable.class == Class ? self.class::Runnable : Object) do
              local_class_in MouseHandler
              include_class_members MouseHandler
              include class_self::Runnable if class_self::Runnable.class == Module
              
              typesig { [] }
              define_method :run do
                if ((self.attr_f_auto_scroll_direction).equal?(SWT::UP))
                  top = get_inclusive_top_index
                  if (top > 0)
                    self.attr_f_cached_text_viewer.set_top_index(top - 1)
                    expand_selection(top - 1)
                    display.timer_exec(timer_interval, self)
                  end
                end
              end
              
              typesig { [Vararg.new(Object)] }
              define_method :initialize do |*args|
                super(*args)
              end
              
              private
              alias_method :initialize_anonymous, :initialize
            end.new_local(self)
          when SWT::DOWN
            timer = Class.new(self.class::Runnable.class == Class ? self.class::Runnable : Object) do
              local_class_in MouseHandler
              include_class_members MouseHandler
              include class_self::Runnable if class_self::Runnable.class == Module
              
              typesig { [] }
              define_method :run do
                if ((self.attr_f_auto_scroll_direction).equal?(SWT::DOWN))
                  top = get_inclusive_top_index
                  self.attr_f_cached_text_viewer.set_top_index(top + 1)
                  expand_selection(top + 1 + self.attr_f_cached_viewport_size)
                  display.timer_exec(timer_interval, self)
                end
              end
              
              typesig { [Vararg.new(Object)] }
              define_method :initialize do |*args|
                super(*args)
              end
              
              private
              alias_method :initialize_anonymous, :initialize
            end.new_local(self)
          end
          if (!(timer).nil?)
            @f_auto_scroll_direction = direction
            display.timer_exec(timer_interval, timer)
          end
        end
        
        typesig { [] }
        # Returns the viewer's first visible line, even if only partially visible.
        # 
        # @return the viewer's first visible line
        def get_inclusive_top_index
          if (!(self.attr_f_cached_text_widget).nil? && !self.attr_f_cached_text_widget.is_disposed)
            return JFaceTextUtil.get_partial_top_index(self.attr_f_cached_text_viewer)
          end
          return -1
        end
        
        typesig { [] }
        def initialize
          @f_cached_viewport_size = 0
          @f_start_line_offset = 0
          @f_start_line_number = 0
          @f_auto_scroll_direction = 0
          @f_is_listening_for_move = false
        end
        
        private
        alias_method :initialize__mouse_handler, :initialize
      end }
    }
    
    # This column's parent ruler
    attr_accessor :f_parent_ruler
    alias_method :attr_f_parent_ruler, :f_parent_ruler
    undef_method :f_parent_ruler
    alias_method :attr_f_parent_ruler=, :f_parent_ruler=
    undef_method :f_parent_ruler=
    
    # Cached text viewer
    attr_accessor :f_cached_text_viewer
    alias_method :attr_f_cached_text_viewer, :f_cached_text_viewer
    undef_method :f_cached_text_viewer
    alias_method :attr_f_cached_text_viewer=, :f_cached_text_viewer=
    undef_method :f_cached_text_viewer=
    
    # Cached text widget
    attr_accessor :f_cached_text_widget
    alias_method :attr_f_cached_text_widget, :f_cached_text_widget
    undef_method :f_cached_text_widget
    alias_method :attr_f_cached_text_widget=, :f_cached_text_widget=
    undef_method :f_cached_text_widget=
    
    # The columns canvas
    attr_accessor :f_canvas
    alias_method :attr_f_canvas, :f_canvas
    undef_method :f_canvas
    alias_method :attr_f_canvas=, :f_canvas=
    undef_method :f_canvas=
    
    # Cache for the actual scroll position in pixels
    attr_accessor :f_scroll_pos
    alias_method :attr_f_scroll_pos, :f_scroll_pos
    undef_method :f_scroll_pos
    alias_method :attr_f_scroll_pos=, :f_scroll_pos=
    undef_method :f_scroll_pos=
    
    # The drawable for double buffering
    attr_accessor :f_buffer
    alias_method :attr_f_buffer, :f_buffer
    undef_method :f_buffer
    alias_method :attr_f_buffer=, :f_buffer=
    undef_method :f_buffer=
    
    # The internal listener
    attr_accessor :f_internal_listener
    alias_method :attr_f_internal_listener, :f_internal_listener
    undef_method :f_internal_listener
    alias_method :attr_f_internal_listener=, :f_internal_listener=
    undef_method :f_internal_listener=
    
    # The font of this column
    attr_accessor :f_font
    alias_method :attr_f_font, :f_font
    undef_method :f_font
    alias_method :attr_f_font=, :f_font=
    undef_method :f_font=
    
    # The indentation cache
    attr_accessor :f_indentation
    alias_method :attr_f_indentation, :f_indentation
    undef_method :f_indentation
    alias_method :attr_f_indentation=, :f_indentation=
    undef_method :f_indentation=
    
    # Indicates whether this column reacts on text change events
    attr_accessor :f_sensitive_to_text_changes
    alias_method :attr_f_sensitive_to_text_changes, :f_sensitive_to_text_changes
    undef_method :f_sensitive_to_text_changes
    alias_method :attr_f_sensitive_to_text_changes=, :f_sensitive_to_text_changes=
    undef_method :f_sensitive_to_text_changes=
    
    # The foreground color
    attr_accessor :f_foreground
    alias_method :attr_f_foreground, :f_foreground
    undef_method :f_foreground
    alias_method :attr_f_foreground=, :f_foreground=
    undef_method :f_foreground=
    
    # The background color
    attr_accessor :f_background
    alias_method :attr_f_background, :f_background
    undef_method :f_background
    alias_method :attr_f_background=, :f_background=
    undef_method :f_background=
    
    # Cached number of displayed digits
    attr_accessor :f_cached_number_of_digits
    alias_method :attr_f_cached_number_of_digits, :f_cached_number_of_digits
    undef_method :f_cached_number_of_digits
    alias_method :attr_f_cached_number_of_digits=, :f_cached_number_of_digits=
    undef_method :f_cached_number_of_digits=
    
    # Flag indicating whether a relayout is required
    attr_accessor :f_relayout_required
    alias_method :attr_f_relayout_required, :f_relayout_required
    undef_method :f_relayout_required
    alias_method :attr_f_relayout_required=, :f_relayout_required=
    undef_method :f_relayout_required=
    
    # Redraw runnable lock
    # @since 3.0
    attr_accessor :f_runnable_lock
    alias_method :attr_f_runnable_lock, :f_runnable_lock
    undef_method :f_runnable_lock
    alias_method :attr_f_runnable_lock=, :f_runnable_lock=
    undef_method :f_runnable_lock=
    
    # Redraw runnable state
    # @since 3.0
    attr_accessor :f_is_runnable_posted
    alias_method :attr_f_is_runnable_posted, :f_is_runnable_posted
    undef_method :f_is_runnable_posted
    alias_method :attr_f_is_runnable_posted=, :f_is_runnable_posted=
    undef_method :f_is_runnable_posted=
    
    # Redraw runnable
    # @since 3.0
    attr_accessor :f_runnable
    alias_method :attr_f_runnable, :f_runnable
    undef_method :f_runnable
    alias_method :attr_f_runnable=, :f_runnable=
    undef_method :f_runnable=
    
    # @since 3.2
    attr_accessor :f_mouse_handler
    alias_method :attr_f_mouse_handler, :f_mouse_handler
    undef_method :f_mouse_handler
    alias_method :attr_f_mouse_handler=, :f_mouse_handler=
    undef_method :f_mouse_handler=
    
    typesig { [] }
    # Constructs a new vertical ruler column.
    def initialize
      @f_parent_ruler = nil
      @f_cached_text_viewer = nil
      @f_cached_text_widget = nil
      @f_canvas = nil
      @f_scroll_pos = 0
      @f_buffer = nil
      @f_internal_listener = InternalListener.new_local(self)
      @f_font = nil
      @f_indentation = nil
      @f_sensitive_to_text_changes = false
      @f_foreground = nil
      @f_background = nil
      @f_cached_number_of_digits = -1
      @f_relayout_required = false
      @f_runnable_lock = Object.new
      @f_is_runnable_posted = false
      @f_runnable = Class.new(Runnable.class == Class ? Runnable : Object) do
        local_class_in LineNumberRulerColumn
        include_class_members LineNumberRulerColumn
        include Runnable if Runnable.class == Module
        
        typesig { [] }
        define_method :run do
          synchronized((self.attr_f_runnable_lock)) do
            self.attr_f_is_runnable_posted = false
          end
          redraw
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
      @f_mouse_handler = nil
    end
    
    typesig { [Color] }
    # Sets the foreground color of this column.
    # 
    # @param foreground the foreground color
    def set_foreground(foreground)
      @f_foreground = foreground
    end
    
    typesig { [] }
    # Returns the foreground color being used to print the line numbers.
    # 
    # @return the configured foreground color
    # @since 3.0
    def get_foreground
      return @f_foreground
    end
    
    typesig { [Color] }
    # Sets the background color of this column.
    # 
    # @param background the background color
    def set_background(background)
      @f_background = background
      if (!(@f_canvas).nil? && !@f_canvas.is_disposed)
        @f_canvas.set_background(get_background(@f_canvas.get_display))
      end
    end
    
    typesig { [Display] }
    # Returns the System background color for list widgets.
    # 
    # @param display the display
    # @return the System background color for list widgets
    def get_background(display)
      if ((@f_background).nil?)
        return display.get_system_color(SWT::COLOR_LIST_BACKGROUND)
      end
      return @f_background
    end
    
    typesig { [] }
    # @see IVerticalRulerColumn#getControl()
    def get_control
      return @f_canvas
    end
    
    typesig { [] }
    # @see IVerticalRuleColumnr#getWidth
    def get_width
      return @f_indentation[0]
    end
    
    typesig { [] }
    # Computes the number of digits to be displayed. Returns
    # <code>true</code> if the number of digits changed compared
    # to the previous call of this method. If the method is called
    # for the first time, the return value is also <code>true</code>.
    # 
    # @return whether the number of digits has been changed
    # @since 3.0
    def update_number_of_digits
      if ((@f_cached_text_viewer).nil?)
        return false
      end
      digits = compute_number_of_digits
      if (!(@f_cached_number_of_digits).equal?(digits))
        @f_cached_number_of_digits = digits
        return true
      end
      return false
    end
    
    typesig { [] }
    # Does the real computation of the number of digits. Subclasses may override this method if
    # they need extra space on the line number ruler.
    # 
    # @return the number of digits to be displayed on the line number ruler.
    def compute_number_of_digits
      document = @f_cached_text_viewer.get_document
      lines = (document).nil? ? 0 : document.get_number_of_lines
      digits = 2
      while (lines > Math.pow(10, digits) - 1)
        (digits += 1)
      end
      return digits
    end
    
    typesig { [::Java::Boolean] }
    # Layouts the enclosing viewer to adapt the layout to changes of the
    # size of the individual components.
    # 
    # @param redraw <code>true</code> if this column can be redrawn
    def layout(redraw)
      if (!redraw)
        @f_relayout_required = true
        return
      end
      @f_relayout_required = false
      if (@f_cached_text_viewer.is_a?(ITextViewerExtension))
        extension = @f_cached_text_viewer
        control = extension.get_control
        if (control.is_a?(Composite) && !control.is_disposed)
          composite = control
          composite.layout(true)
        end
      end
    end
    
    typesig { [] }
    # Computes the indentations for the given font and stores them in
    # <code>fIndentation</code>.
    def compute_indentations
      if ((@f_canvas).nil? || @f_canvas.is_disposed)
        return
      end
      gc = SwtGC.new(@f_canvas)
      begin
        gc.set_font(@f_canvas.get_font)
        @f_indentation = Array.typed(::Java::Int).new(@f_cached_number_of_digits + 1) { 0 }
        nines = CharArray.new(@f_cached_number_of_digits)
        Arrays.fill(nines, Character.new(?9.ord))
        nine_string = String.new(nines)
        p = gc.string_extent(nine_string)
        @f_indentation[0] = p.attr_x
        i = 1
        while i <= @f_cached_number_of_digits
          p = gc.string_extent(nine_string.substring(0, i))
          @f_indentation[i] = @f_indentation[0] - p.attr_x
          i += 1
        end
      ensure
        gc.dispose
      end
    end
    
    typesig { [CompositeRuler, Composite] }
    # @see IVerticalRulerColumn#createControl(CompositeRuler, Composite)
    def create_control(parent_ruler, parent_control)
      @f_parent_ruler = parent_ruler
      @f_cached_text_viewer = parent_ruler.get_text_viewer
      @f_cached_text_widget = @f_cached_text_viewer.get_text_widget
      @f_canvas = Class.new(Canvas.class == Class ? Canvas : Object) do
        local_class_in LineNumberRulerColumn
        include_class_members LineNumberRulerColumn
        include Canvas if Canvas.class == Module
        
        typesig { [MouseListener] }
        # @see org.eclipse.swt.widgets.Control#addMouseListener(org.eclipse.swt.events.MouseListener)
        # @since 3.4
        define_method :add_mouse_listener do |listener|
          # see bug 40889, bug 230073 and AnnotationRulerColumn#isPropagatingMouseListener()
          if ((listener).equal?(self.attr_f_mouse_handler))
            super(listener)
          else
            typed_listener = nil
            if (!(listener).nil?)
              typed_listener = self.class::TypedListener.new(listener)
            end
            add_listener(SWT::MouseDoubleClick, typed_listener)
          end
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self, parent_control, SWT::NO_FOCUS)
      @f_canvas.set_background(get_background(@f_canvas.get_display))
      @f_canvas.set_foreground(@f_foreground)
      @f_canvas.add_paint_listener(Class.new(PaintListener.class == Class ? PaintListener : Object) do
        local_class_in LineNumberRulerColumn
        include_class_members LineNumberRulerColumn
        include PaintListener if PaintListener.class == Module
        
        typesig { [PaintEvent] }
        define_method :paint_control do |event|
          if (!(self.attr_f_cached_text_viewer).nil?)
            double_buffer_paint(event.attr_gc)
          end
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      @f_canvas.add_dispose_listener(Class.new(DisposeListener.class == Class ? DisposeListener : Object) do
        local_class_in LineNumberRulerColumn
        include_class_members LineNumberRulerColumn
        include DisposeListener if DisposeListener.class == Module
        
        typesig { [DisposeEvent] }
        define_method :widget_disposed do |e|
          handle_dispose
          self.attr_f_cached_text_viewer = nil
          self.attr_f_cached_text_widget = nil
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      @f_mouse_handler = MouseHandler.new_local(self)
      @f_canvas.add_mouse_listener(@f_mouse_handler)
      @f_canvas.add_mouse_move_listener(@f_mouse_handler)
      if (!(@f_cached_text_viewer).nil?)
        @f_cached_text_viewer.add_viewport_listener(@f_internal_listener)
        @f_cached_text_viewer.add_text_listener(@f_internal_listener)
        if ((@f_font).nil?)
          if (!(@f_cached_text_widget).nil? && !@f_cached_text_widget.is_disposed)
            @f_font = @f_cached_text_widget.get_font
          end
        end
      end
      if (!(@f_font).nil?)
        @f_canvas.set_font(@f_font)
      end
      update_number_of_digits
      compute_indentations
      return @f_canvas
    end
    
    typesig { [] }
    # Disposes the column's resources.
    def handle_dispose
      if (!(@f_cached_text_viewer).nil?)
        @f_cached_text_viewer.remove_viewport_listener(@f_internal_listener)
        @f_cached_text_viewer.remove_text_listener(@f_internal_listener)
      end
      if (!(@f_buffer).nil?)
        @f_buffer.dispose
        @f_buffer = nil
      end
    end
    
    typesig { [SwtGC] }
    # Double buffer drawing.
    # 
    # @param dest the GC to draw into
    def double_buffer_paint(dest)
      size = @f_canvas.get_size
      if (size.attr_x <= 0 || size.attr_y <= 0)
        return
      end
      if (!(@f_buffer).nil?)
        r = @f_buffer.get_bounds
        if (!(r.attr_width).equal?(size.attr_x) || !(r.attr_height).equal?(size.attr_y))
          @f_buffer.dispose
          @f_buffer = nil
        end
      end
      if ((@f_buffer).nil?)
        @f_buffer = Image.new(@f_canvas.get_display, size.attr_x, size.attr_y)
      end
      gc = SwtGC.new(@f_buffer)
      gc.set_font(@f_canvas.get_font)
      if (!(@f_foreground).nil?)
        gc.set_foreground(@f_foreground)
      end
      begin
        gc.set_background(get_background(@f_canvas.get_display))
        gc.fill_rectangle(0, 0, size.attr_x, size.attr_y)
        visible_lines = JFaceTextUtil.get_visible_model_lines(@f_cached_text_viewer)
        if ((visible_lines).nil?)
          return
        end
        @f_scroll_pos = @f_cached_text_widget.get_top_pixel
        do_paint(gc, visible_lines)
      ensure
        gc.dispose
      end
      dest.draw_image(@f_buffer, 0, 0)
    end
    
    typesig { [] }
    # Returns the view port height in lines.
    # 
    # @return the view port height in lines
    # @deprecated as of 3.2 the number of lines in the viewport cannot be computed because
    # StyledText supports variable line heights
    def get_visible_lines_in_viewport
      return get_visible_lines_in_viewport(@f_cached_text_widget)
    end
    
    typesig { [] }
    # Returns <code>true</code> if the viewport displays the entire viewer contents, i.e. the
    # viewer is not vertically scrollable.
    # 
    # @return <code>true</code> if the viewport displays the entire contents, <code>false</code> otherwise
    # @since 3.2
    def is_viewer_completely_shown
      return JFaceTextUtil.is_showing_entire_contents(@f_cached_text_widget)
    end
    
    typesig { [SwtGC, ILineRange] }
    # Draws the ruler column.
    # 
    # @param gc the GC to draw into
    # @param visibleLines the visible model lines
    # @since 3.2
    def do_paint(gc, visible_lines)
      display = @f_cached_text_widget.get_display
      # draw diff info
      y = -JFaceTextUtil.get_hidden_top_line_pixels(@f_cached_text_widget)
      last_line = end_(visible_lines)
      line = visible_lines.get_start_line
      while line < last_line
        widget_line = JFaceTextUtil.model_line_to_widget_line(@f_cached_text_viewer, line)
        if ((widget_line).equal?(-1))
          line += 1
          next
        end
        line_height = @f_cached_text_widget.get_line_height(@f_cached_text_widget.get_offset_at_line(widget_line))
        paint_line(line, y, line_height, gc, display)
        y += line_height
        line += 1
      end
    end
    
    class_module.module_eval {
      typesig { [ILineRange] }
      # @since 3.2
      def end_(range)
        return range.get_start_line + range.get_number_of_lines
      end
    }
    
    typesig { [::Java::Int] }
    # Computes the string to be printed for <code>line</code>. The default implementation returns
    # <code>Integer.toString(line + 1)</code>.
    # 
    # @param line the line number for which the line number string is generated
    # @return the string to be printed on the line number bar for <code>line</code>
    # @since 3.0
    def create_display_string(line)
      return JavaInteger.to_s(line + 1)
    end
    
    typesig { [SwtGC, ::Java::Int] }
    # Returns the difference between the baseline of the widget and the
    # baseline as specified by the font for <code>gc</code>. When drawing
    # line numbers, the returned bias should be added to obtain text lined up
    # on the correct base line of the text widget.
    # 
    # @param gc the <code>GC</code> to get the font metrics from
    # @param widgetLine the widget line
    # @return the baseline bias to use when drawing text that is lined up with
    # <code>fCachedTextWidget</code>
    # @since 3.2
    def get_baseline_bias(gc, widget_line)
      # https://bugs.eclipse.org/bugs/show_bug.cgi?id=62951
      # widget line height may be more than the font height used for the
      # line numbers, since font styles (bold, italics...) can have larger
      # font metrics than the simple font used for the numbers.
      offset = @f_cached_text_widget.get_offset_at_line(widget_line)
      widget_baseline = @f_cached_text_widget.get_baseline(offset)
      fm = gc.get_font_metrics
      font_baseline = fm.get_ascent + fm.get_leading
      baseline_bias = widget_baseline - font_baseline
      return Math.max(0, baseline_bias)
    end
    
    typesig { [::Java::Int, ::Java::Int, ::Java::Int, SwtGC, Display] }
    # Paints the line. After this method is called the line numbers are painted on top
    # of the result of this method.
    # 
    # @param line the line of the document which the ruler is painted for
    # @param y the y-coordinate of the box being painted for <code>line</code>, relative to <code>gc</code>
    # @param lineheight the height of one line (and therefore of the box being painted)
    # @param gc the drawing context the client may choose to draw on.
    # @param display the display the drawing occurs on
    # @since 3.0
    def paint_line(line, y, lineheight, gc, display)
      widget_line = JFaceTextUtil.model_line_to_widget_line(@f_cached_text_viewer, line)
      s = create_display_string(line)
      indentation = @f_indentation[s.length]
      baseline_bias = get_baseline_bias(gc, widget_line)
      gc.draw_string(s, indentation, y + baseline_bias, true)
    end
    
    typesig { [] }
    # Triggers a redraw in the display thread.
    # 
    # @since 3.0
    def post_redraw
      if (!(@f_canvas).nil? && !@f_canvas.is_disposed)
        d = @f_canvas.get_display
        if (!(d).nil?)
          synchronized((@f_runnable_lock)) do
            if (@f_is_runnable_posted)
              return
            end
            @f_is_runnable_posted = true
          end
          d.async_exec(@f_runnable)
        end
      end
    end
    
    typesig { [] }
    # @see IVerticalRulerColumn#redraw()
    def redraw
      if (@f_relayout_required)
        layout(true)
        return
      end
      if (!(@f_cached_text_viewer).nil? && !(@f_canvas).nil? && !@f_canvas.is_disposed)
        gc = SwtGC.new(@f_canvas)
        double_buffer_paint(gc)
        gc.dispose
      end
    end
    
    typesig { [IAnnotationModel] }
    # @see IVerticalRulerColumn#setModel(IAnnotationModel)
    def set_model(model)
    end
    
    typesig { [Font] }
    # @see IVerticalRulerColumn#setFont(Font)
    def set_font(font)
      @f_font = font
      if (!(@f_canvas).nil? && !@f_canvas.is_disposed)
        @f_canvas.set_font(@f_font)
        update_number_of_digits
        compute_indentations
      end
    end
    
    typesig { [] }
    # Returns the parent (composite) ruler of this ruler column.
    # 
    # @return the parent ruler
    # @since 3.0
    def get_parent_ruler
      return @f_parent_ruler
    end
    
    class_module.module_eval {
      typesig { [StyledText] }
      # Returns the number of lines in the view port.
      # 
      # @param textWidget the styled text widget
      # @return the number of lines visible in the view port <code>-1</code> if there's no client
      # area
      # @deprecated this method should not be used - it relies on the widget using a uniform line
      # height
      def get_visible_lines_in_viewport(text_widget)
        if (!(text_widget).nil?)
          cl_area = text_widget.get_client_area
          if (!cl_area.is_empty)
            first_pixel = 0
            last_pixel = cl_area.attr_height - 1 # XXX: what about margins? don't take trims as they include scrollbars
            first = JFaceTextUtil.get_line_index(text_widget, first_pixel)
            last = JFaceTextUtil.get_line_index(text_widget, last_pixel)
            return last - first
          end
        end
        return -1
      end
    }
    
    private
    alias_method :initialize__line_number_ruler_column, :initialize
  end
  
end
