require "rjava"

# Copyright (c) 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text
  module AbstractInformationControlImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Events, :DisposeListener
      include_const ::Org::Eclipse::Swt::Events, :FocusEvent
      include_const ::Org::Eclipse::Swt::Events, :FocusListener
      include_const ::Org::Eclipse::Swt::Events, :MouseAdapter
      include_const ::Org::Eclipse::Swt::Events, :MouseEvent
      include_const ::Org::Eclipse::Swt::Events, :MouseMoveListener
      include_const ::Org::Eclipse::Swt::Events, :PaintEvent
      include_const ::Org::Eclipse::Swt::Events, :PaintListener
      include_const ::Org::Eclipse::Swt::Graphics, :Color
      include_const ::Org::Eclipse::Swt::Graphics, :Font
      include_const ::Org::Eclipse::Swt::Graphics, :FontData
      include_const ::Org::Eclipse::Swt::Graphics, :SwtGC
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Graphics, :Rectangle
      include_const ::Org::Eclipse::Swt::Layout, :FillLayout
      include_const ::Org::Eclipse::Swt::Layout, :GridData
      include_const ::Org::Eclipse::Swt::Layout, :GridLayout
      include_const ::Org::Eclipse::Swt::Widgets, :Canvas
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Display
      include_const ::Org::Eclipse::Swt::Widgets, :Event
      include_const ::Org::Eclipse::Swt::Widgets, :Label
      include_const ::Org::Eclipse::Swt::Widgets, :Listener
      include_const ::Org::Eclipse::Swt::Widgets, :Shell
      include_const ::Org::Eclipse::Swt::Widgets, :Slider
      include_const ::Org::Eclipse::Swt::Widgets, :ToolBar
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Core::Runtime, :ListenerList
      include_const ::Org::Eclipse::Jface::Action, :ToolBarManager
      include_const ::Org::Eclipse::Jface::Resource, :JFaceResources
      include_const ::Org::Eclipse::Jface::Util, :Geometry
    }
  end
  
  # An abstract information control that can show content inside a shell.
  # The information control can be created in two styles:
  # <ul>
  # <li>non-resizable tooltip with optional status</li>
  # <li>resizable tooltip with optional tool bar</li>
  # </ul>
  # Additionally it can present either a status line containing a status text or
  # a toolbar containing toolbar buttons.
  # <p>
  # Subclasses must either override {@link IInformationControl#setInformation(String)}
  # or implement {@link IInformationControlExtension2}.
  # They should also extend {@link #computeTrim()} if they create a content area
  # with additional trim (e.g. scrollbars) and override {@link #getInformationPresenterControlCreator()}.
  # </p>
  # 
  # @since 3.4
  class AbstractInformationControl 
    include_class_members AbstractInformationControlImports
    include IInformationControl
    include IInformationControlExtension
    include IInformationControlExtension3
    include IInformationControlExtension4
    include IInformationControlExtension5
    
    # The information control's shell.
    attr_accessor :f_shell
    alias_method :attr_f_shell, :f_shell
    undef_method :f_shell
    alias_method :attr_f_shell=, :f_shell=
    undef_method :f_shell=
    
    # Composite containing the content created by subclasses.
    attr_accessor :f_content_composite
    alias_method :attr_f_content_composite, :f_content_composite
    undef_method :f_content_composite
    alias_method :attr_f_content_composite=, :f_content_composite=
    undef_method :f_content_composite=
    
    # Whether the information control is resizable.
    attr_accessor :f_resizable
    alias_method :attr_f_resizable, :f_resizable
    undef_method :f_resizable
    alias_method :attr_f_resizable=, :f_resizable=
    undef_method :f_resizable=
    
    # Composite containing the status line content or <code>null</code> if none.
    attr_accessor :f_status_composite
    alias_method :attr_f_status_composite, :f_status_composite
    undef_method :f_status_composite
    alias_method :attr_f_status_composite=, :f_status_composite=
    undef_method :f_status_composite=
    
    # Separator between content and status line or <code>null</code> if none.
    attr_accessor :f_separator
    alias_method :attr_f_separator, :f_separator
    undef_method :f_separator
    alias_method :attr_f_separator=, :f_separator=
    undef_method :f_separator=
    
    # Label in the status line or <code>null</code> if none.
    attr_accessor :f_status_label
    alias_method :attr_f_status_label, :f_status_label
    undef_method :f_status_label
    alias_method :attr_f_status_label=, :f_status_label=
    undef_method :f_status_label=
    
    # Font for the label in the status line or <code>null</code> if none.
    # @since 3.4.2
    attr_accessor :f_status_label_font
    alias_method :attr_f_status_label_font, :f_status_label_font
    undef_method :f_status_label_font
    alias_method :attr_f_status_label_font=, :f_status_label_font=
    undef_method :f_status_label_font=
    
    # The toolbar manager used by the toolbar or <code>null</code> if none.
    attr_accessor :f_tool_bar_manager
    alias_method :attr_f_tool_bar_manager, :f_tool_bar_manager
    undef_method :f_tool_bar_manager
    alias_method :attr_f_tool_bar_manager=, :f_tool_bar_manager=
    undef_method :f_tool_bar_manager=
    
    # Status line toolbar or <code>null</code> if none.
    attr_accessor :f_tool_bar
    alias_method :attr_f_tool_bar, :f_tool_bar
    undef_method :f_tool_bar
    alias_method :attr_f_tool_bar=, :f_tool_bar=
    undef_method :f_tool_bar=
    
    # Listener for shell activation and deactivation.
    attr_accessor :f_shell_listener
    alias_method :attr_f_shell_listener, :f_shell_listener
    undef_method :f_shell_listener
    alias_method :attr_f_shell_listener=, :f_shell_listener=
    undef_method :f_shell_listener=
    
    # All focus listeners registered to this information control.
    attr_accessor :f_focus_listeners
    alias_method :attr_f_focus_listeners, :f_focus_listeners
    undef_method :f_focus_listeners
    alias_method :attr_f_focus_listeners=, :f_focus_listeners=
    undef_method :f_focus_listeners=
    
    # Size constraints, x is the maxWidth and y is the maxHeight, or <code>null</code> if not set.
    attr_accessor :f_size_constraints
    alias_method :attr_f_size_constraints, :f_size_constraints
    undef_method :f_size_constraints
    alias_method :attr_f_size_constraints=, :f_size_constraints=
    undef_method :f_size_constraints=
    
    # The size of the resize handle if already set, -1 otherwise
    attr_accessor :f_resize_handle_size
    alias_method :attr_f_resize_handle_size, :f_resize_handle_size
    undef_method :f_resize_handle_size
    alias_method :attr_f_resize_handle_size=, :f_resize_handle_size=
    undef_method :f_resize_handle_size=
    
    typesig { [Shell, String] }
    # Creates an abstract information control with the given shell as parent.
    # The control will not be resizable and optionally show a status line with
    # the given status field text.
    # <p>
    # <em>Important: Subclasses are required to call {@link #create()} at the end of their constructor.</em>
    # </p>
    # 
    # @param parentShell the parent of this control's shell
    # @param statusFieldText the text to be used in the status field or <code>null</code> to hide the status field
    def initialize(parent_shell, status_field_text)
      initialize__abstract_information_control(parent_shell, SWT::TOOL | SWT::ON_TOP, status_field_text, nil)
    end
    
    typesig { [Shell, ToolBarManager] }
    # Creates an abstract information control with the given shell as parent.
    # The control will be resizable and optionally show a tool bar managed by
    # the given tool bar manager.
    # <p>
    # <em>Important: Subclasses are required to call {@link #create()} at the end of their constructor.</em>
    # </p>
    # 
    # @param parentShell the parent of this control's shell
    # @param toolBarManager the manager or <code>null</code> if toolbar is not desired
    def initialize(parent_shell, tool_bar_manager)
      initialize__abstract_information_control(parent_shell, SWT::TOOL | SWT::ON_TOP | SWT::RESIZE, nil, tool_bar_manager)
    end
    
    typesig { [Shell, ::Java::Boolean] }
    # Creates an abstract information control with the given shell as parent.
    # <p>
    # <em>Important: Subclasses are required to call {@link #create()} at the end of their constructor.</em>
    # </p>
    # 
    # @param parentShell the parent of this control's shell
    # @param isResizable <code>true</code> if the control should be resizable
    def initialize(parent_shell, is_resizable)
      initialize__abstract_information_control(parent_shell, SWT::TOOL | SWT::ON_TOP | (is_resizable ? SWT::RESIZE : 0), nil, nil)
    end
    
    typesig { [Shell, ::Java::Int, String, ToolBarManager] }
    # Creates an abstract information control with the given shell as parent.
    # The given shell style is used for the shell (NO_TRIM will be removed to make sure there's a border).
    # <p>
    # The control will optionally show either a status line or a tool bar.
    # At most one of <code>toolBarManager</code> or <code>statusFieldText</code> can be non-null.
    # </p>
    # <p>
    # <strong>Important:</strong>: Subclasses are required to call {@link #create()} at the end of their constructor.
    # </p>
    # 
    # @param parentShell the parent of this control's shell
    # @param shellStyle style of this control's shell
    # @param statusFieldText the text to be used in the status field or <code>null</code> to hide the status field
    # @param toolBarManager the manager or <code>null</code> if toolbar is not desired
    # 
    # @deprecated clients should use one of the public constructors
    def initialize(parent_shell, shell_style, status_field_text, tool_bar_manager)
      @f_shell = nil
      @f_content_composite = nil
      @f_resizable = false
      @f_status_composite = nil
      @f_separator = nil
      @f_status_label = nil
      @f_status_label_font = nil
      @f_tool_bar_manager = nil
      @f_tool_bar = nil
      @f_shell_listener = nil
      @f_focus_listeners = ListenerList.new(ListenerList::IDENTITY)
      @f_size_constraints = nil
      @f_resize_handle_size = 0
      Assert.is_true((status_field_text).nil? || (tool_bar_manager).nil?)
      @f_resize_handle_size = -1
      @f_tool_bar_manager = tool_bar_manager
      if (!((shell_style & SWT::NO_TRIM)).equal?(0))
        shell_style &= ~(SWT::NO_TRIM | SWT::SHELL_TRIM)
      end # make sure we get the OS border but no other trims
      @f_resizable = !((shell_style & SWT::RESIZE)).equal?(0) # on GTK, Shell removes SWT.RESIZE if SWT.ON_TOP is set
      @f_shell = Shell.new(parent_shell, shell_style)
      display = @f_shell.get_display
      foreground = display.get_system_color(SWT::COLOR_INFO_FOREGROUND)
      background = display.get_system_color(SWT::COLOR_INFO_BACKGROUND)
      set_color(@f_shell, foreground, background)
      layout = GridLayout.new(1, false)
      layout.attr_margin_height = 0
      layout.attr_margin_width = 0
      layout.attr_vertical_spacing = 0
      @f_shell.set_layout(layout)
      @f_content_composite = Composite.new(@f_shell, SWT::NONE)
      @f_content_composite.set_layout_data(GridData.new(SWT::FILL, SWT::FILL, true, true))
      @f_content_composite.set_layout(FillLayout.new)
      set_color(@f_content_composite, foreground, background)
      create_status_composite(status_field_text, tool_bar_manager, foreground, background)
    end
    
    typesig { [String, ToolBarManager, Color, Color] }
    def create_status_composite(status_field_text, tool_bar_manager, foreground, background)
      if ((tool_bar_manager).nil? && (status_field_text).nil?)
        return
      end
      @f_status_composite = Composite.new(@f_shell, SWT::NONE)
      grid_data = GridData.new(SWT::FILL, SWT::BOTTOM, true, false)
      @f_status_composite.set_layout_data(grid_data)
      status_layout = GridLayout.new(1, false)
      status_layout.attr_margin_height = 0
      status_layout.attr_margin_width = 0
      status_layout.attr_vertical_spacing = 1
      @f_status_composite.set_layout(status_layout)
      @f_separator = Label.new(@f_status_composite, SWT::SEPARATOR | SWT::HORIZONTAL)
      @f_separator.set_layout_data(GridData.new(GridData::FILL_HORIZONTAL))
      if (!(status_field_text).nil?)
        create_status_label(status_field_text, foreground, background)
      else
        create_tool_bar(tool_bar_manager)
      end
    end
    
    typesig { [String, Color, Color] }
    def create_status_label(status_field_text, foreground, background)
      @f_status_label = Label.new(@f_status_composite, SWT::RIGHT)
      @f_status_label.set_layout_data(GridData.new(SWT::FILL, SWT::CENTER, true, false))
      @f_status_label.set_text(status_field_text)
      font_datas = JFaceResources.get_dialog_font.get_font_data
      i = 0
      while i < font_datas.attr_length
        font_datas[i].set_height(font_datas[i].get_height * 9 / 10)
        i += 1
      end
      @f_status_label_font = Font.new(@f_status_label.get_display, font_datas)
      @f_status_label.set_font(@f_status_label_font)
      @f_status_label.set_foreground(@f_status_label.get_display.get_system_color(SWT::COLOR_WIDGET_DARK_SHADOW))
      @f_status_label.set_background(background)
      set_color(@f_status_composite, foreground, background)
    end
    
    typesig { [ToolBarManager] }
    def create_tool_bar(tool_bar_manager)
      bars = Composite.new(@f_status_composite, SWT::NONE)
      bars.set_layout_data(GridData.new(SWT::FILL, SWT::FILL, false, false))
      layout = GridLayout.new(3, false)
      layout.attr_margin_height = 0
      layout.attr_margin_width = 0
      layout.attr_horizontal_spacing = 0
      layout.attr_vertical_spacing = 0
      bars.set_layout(layout)
      @f_tool_bar = tool_bar_manager.create_control(bars)
      gd = GridData.new(SWT::BEGINNING, SWT::BEGINNING, false, false)
      @f_tool_bar.set_layout_data(gd)
      spacer = Composite.new(bars, SWT::NONE)
      gd = GridData.new(SWT::FILL, SWT::FILL, true, true)
      gd.attr_width_hint = 0
      gd.attr_height_hint = 0
      spacer.set_layout_data(gd)
      add_move_support(spacer)
      add_resize_support_if_necessary(bars)
    end
    
    typesig { [Composite] }
    def add_resize_support_if_necessary(bars)
      # XXX: workarounds for
      # - https://bugs.eclipse.org/bugs/show_bug.cgi?id=219139 : API to add resize grip / grow box in lower right corner of shell
      # - https://bugs.eclipse.org/bugs/show_bug.cgi?id=23980 : platform specific shell resize behavior
      platform = SWT.get_platform
      is_win = (platform == "win32") # $NON-NLS-1$
      if (!is_win && !(platform == "gtk"))
        # $NON-NLS-1$
        return
      end
      resizer = Canvas.new(bars, SWT::NONE)
      size = get_resize_handle_size(bars)
      data = GridData.new(SWT::END_, SWT::END_, false, true)
      data.attr_width_hint = size
      data.attr_height_hint = size
      resizer.set_layout_data(data)
      resizer.add_paint_listener(Class.new(PaintListener.class == Class ? PaintListener : Object) do
        local_class_in AbstractInformationControl
        include_class_members AbstractInformationControl
        include PaintListener if PaintListener.class == Module
        
        typesig { [PaintEvent] }
        define_method :paint_control do |e|
          s = resizer.get_size
          x = s.attr_x - 2
          y = s.attr_y - 2
          min_ = Math.min(x, y)
          if (is_win)
            # draw dots
            e.attr_gc.set_background(resizer.get_display.get_system_color(SWT::COLOR_WIDGET_HIGHLIGHT_SHADOW))
            end_ = min_ - 1
            i = 0
            while i <= 2
              j = 0
              while j <= 2 - i
                e.attr_gc.fill_rectangle(end_ - 4 * i, end_ - 4 * j, 2, 2)
                j += 1
              end
              i += 1
            end
            end_ -= 1
            e.attr_gc.set_background(resizer.get_display.get_system_color(SWT::COLOR_WIDGET_NORMAL_SHADOW))
            i_ = 0
            while i_ <= 2
              j = 0
              while j <= 2 - i_
                e.attr_gc.fill_rectangle(end_ - 4 * i_, end_ - 4 * j, 2, 2)
                j += 1
              end
              i_ += 1
            end
          else
            # draw diagonal lines
            e.attr_gc.set_foreground(resizer.get_display.get_system_color(SWT::COLOR_WIDGET_NORMAL_SHADOW))
            i = 1
            while i < min_
              e.attr_gc.draw_line(i, y, x, i)
              i += 4
            end
            e.attr_gc.set_foreground(resizer.get_display.get_system_color(SWT::COLOR_WIDGET_HIGHLIGHT_SHADOW))
            i_ = 2
            while i_ < min_
              e.attr_gc.draw_line(i_, y, x, i_)
              i_ += 4
            end
          end
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      is_rtl = !((resizer.get_shell.get_style & SWT::RIGHT_TO_LEFT)).equal?(0)
      resizer.set_cursor(resizer.get_display.get_system_cursor(is_rtl ? SWT::CURSOR_SIZESW : SWT::CURSOR_SIZESE))
      resize_support = Class.new(MouseAdapter.class == Class ? MouseAdapter : Object) do
        local_class_in AbstractInformationControl
        include_class_members AbstractInformationControl
        include MouseAdapter if MouseAdapter.class == Module
        
        attr_accessor :f_resize_listener
        alias_method :attr_f_resize_listener, :f_resize_listener
        undef_method :f_resize_listener
        alias_method :attr_f_resize_listener=, :f_resize_listener=
        undef_method :f_resize_listener=
        
        typesig { [MouseEvent] }
        define_method :mouse_down do |e|
          shell_bounds = self.attr_f_shell.get_bounds
          shell_x = shell_bounds.attr_x
          shell_y = shell_bounds.attr_y
          shell_width = shell_bounds.attr_width
          shell_height = shell_bounds.attr_height
          mouse_loc = resizer.to_display(e.attr_x, e.attr_y)
          mouse_x = mouse_loc.attr_x
          mouse_y = mouse_loc.attr_y
          mouse_adapter_class = self.class
          @f_resize_listener = Class.new(self.class::MouseMoveListener.class == Class ? self.class::MouseMoveListener : Object) do
            local_class_in mouse_adapter_class
            include_class_members mouse_adapter_class
            include class_self::MouseMoveListener if class_self::MouseMoveListener.class == Module
            
            typesig { [class_self::MouseEvent] }
            define_method :mouse_move do |e2|
              mouse_loc2 = resizer.to_display(e2.attr_x, e2.attr_y)
              dx = mouse_loc2.attr_x - mouse_x
              dy = mouse_loc2.attr_y - mouse_y
              if (is_rtl)
                set_location(self.class::Point.new(shell_x + dx, shell_y))
                set_size(shell_width - dx, shell_height + dy)
              else
                set_size(shell_width + dx, shell_height + dy)
              end
            end
            
            typesig { [Vararg.new(Object)] }
            define_method :initialize do |*args|
              super(*args)
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self)
          resizer.add_mouse_move_listener(@f_resize_listener)
        end
        
        typesig { [MouseEvent] }
        define_method :mouse_up do |e|
          resizer.remove_mouse_move_listener(@f_resize_listener)
          @f_resize_listener = nil
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          @f_resize_listener = nil
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
      resizer.add_mouse_listener(resize_support)
    end
    
    typesig { [Composite] }
    def get_resize_handle_size(parent)
      if ((@f_resize_handle_size).equal?(-1))
        slider_v = Slider.new(parent, SWT::VERTICAL)
        slider_h = Slider.new(parent, SWT::HORIZONTAL)
        width = slider_v.compute_size(SWT::DEFAULT, SWT::DEFAULT).attr_x
        height = slider_h.compute_size(SWT::DEFAULT, SWT::DEFAULT).attr_y
        slider_v.dispose
        slider_h.dispose
        @f_resize_handle_size = Math.min(width, height)
      end
      return @f_resize_handle_size
    end
    
    typesig { [Control] }
    # Adds support to move the shell by dragging the given control.
    # 
    # @param control the control that can be used to move the shell
    def add_move_support(control)
      move_support = Class.new(MouseAdapter.class == Class ? MouseAdapter : Object) do
        local_class_in AbstractInformationControl
        include_class_members AbstractInformationControl
        include MouseAdapter if MouseAdapter.class == Module
        
        attr_accessor :f_move_listener
        alias_method :attr_f_move_listener, :f_move_listener
        undef_method :f_move_listener
        alias_method :attr_f_move_listener=, :f_move_listener=
        undef_method :f_move_listener=
        
        typesig { [MouseEvent] }
        define_method :mouse_down do |e|
          shell_loc = self.attr_f_shell.get_location
          shell_x = shell_loc.attr_x
          shell_y = shell_loc.attr_y
          mouse_loc = control.to_display(e.attr_x, e.attr_y)
          mouse_x = mouse_loc.attr_x
          mouse_y = mouse_loc.attr_y
          mouse_adapter_class = self.class
          @f_move_listener = Class.new(self.class::MouseMoveListener.class == Class ? self.class::MouseMoveListener : Object) do
            local_class_in mouse_adapter_class
            include_class_members mouse_adapter_class
            include class_self::MouseMoveListener if class_self::MouseMoveListener.class == Module
            
            typesig { [class_self::MouseEvent] }
            define_method :mouse_move do |e2|
              mouse_loc2 = control.to_display(e2.attr_x, e2.attr_y)
              dx = mouse_loc2.attr_x - mouse_x
              dy = mouse_loc2.attr_y - mouse_y
              self.attr_f_shell.set_location(shell_x + dx, shell_y + dy)
            end
            
            typesig { [Vararg.new(Object)] }
            define_method :initialize do |*args|
              super(*args)
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self)
          control.add_mouse_move_listener(@f_move_listener)
        end
        
        typesig { [MouseEvent] }
        define_method :mouse_up do |e|
          control.remove_mouse_move_listener(@f_move_listener)
          @f_move_listener = nil
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          @f_move_listener = nil
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
      control.add_mouse_listener(move_support)
    end
    
    class_module.module_eval {
      typesig { [Control, Color, Color] }
      # Utility to set the foreground and the background color of the given
      # control
      # 
      # @param control the control to modify
      # @param foreground the color to use for the foreground
      # @param background the color to use for the background
      def set_color(control, foreground, background)
        control.set_foreground(foreground)
        control.set_background(background)
      end
    }
    
    typesig { [] }
    # The shell of the popup window.
    # 
    # @return the shell used for the popup window
    def get_shell
      return @f_shell
    end
    
    typesig { [] }
    # The toolbar manager used to manage the toolbar, or <code>null</code> if
    # no toolbar is shown.
    # 
    # @return the tool bar manager or <code>null</code>
    def get_tool_bar_manager
      return @f_tool_bar_manager
    end
    
    typesig { [] }
    # Creates the content of this information control. Subclasses must call
    # this method at the end of their constructor(s).
    def create
      create_content(@f_content_composite)
    end
    
    typesig { [Composite] }
    # Creates the content of the popup window.
    # <p>
    # Implementors will usually take over {@link Composite#getBackground()} and
    # {@link Composite#getForeground()} from <code>parent</code>.
    # </p>
    # <p>
    # Implementors are expected to consider {@link #isResizable()}: If
    # <code>true</code>, they should show scrollbars if their content may
    # exceed the size of the information control. If <code>false</code>,
    # they should never show scrollbars.
    # </p>
    # <p>
    # The given <code>parent</code> comes with a {@link FillLayout}.
    # Subclasses may set a different layout.
    # </p>
    # 
    # @param parent the container of the content
    def create_content(parent)
      raise NotImplementedError
    end
    
    typesig { [String] }
    # Sets the information to be presented by this information control.
    # <p>
    # The default implementation does nothing. Subclasses must either override this method
    # or implement {@link IInformationControlExtension2}.
    # 
    # @param information the information to be presented
    # 
    # @see org.eclipse.jface.text.IInformationControl#setInformation(java.lang.String)
    def set_information(information)
    end
    
    typesig { [] }
    # Returns whether the information control is resizable.
    # 
    # @return <code>true</code> if the information control is resizable,
    # <code>false</code> if it is not resizable.
    def is_resizable
      return @f_resizable
    end
    
    typesig { [::Java::Boolean] }
    # @see IInformationControl#setVisible(boolean)
    def set_visible(visible)
      if ((@f_shell.is_visible).equal?(visible))
        return
      end
      @f_shell.set_visible(visible)
    end
    
    typesig { [] }
    # @see IInformationControl#dispose()
    def dispose
      if (!(@f_status_label_font).nil?)
        @f_status_label_font.dispose
        @f_status_label_font = nil
      end
      if (!(@f_shell).nil? && !@f_shell.is_disposed)
        @f_shell.dispose
      end
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # @see IInformationControl#setSize(int, int)
    def set_size(width, height)
      @f_shell.set_size(width, height)
    end
    
    typesig { [Point] }
    # @see IInformationControl#setLocation(Point)
    def set_location(location)
      @f_shell.set_location(location)
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # @see IInformationControl#setSizeConstraints(int, int)
    def set_size_constraints(max_width, max_height)
      @f_size_constraints = Point.new(max_width, max_height)
    end
    
    typesig { [] }
    # Returns the size constraints.
    # 
    # @return the size constraints or <code>null</code> if not set
    # @see #setSizeConstraints(int, int)
    def get_size_constraints
      return !(@f_size_constraints).nil? ? Geometry.copy(@f_size_constraints) : nil
    end
    
    typesig { [] }
    # @see IInformationControl#computeSizeHint()
    def compute_size_hint
      # XXX: Verify whether this is a good default implementation. If yes, document it.
      constrains = get_size_constraints
      if ((constrains).nil?)
        return @f_shell.compute_size(SWT::DEFAULT, SWT::DEFAULT, true)
      end
      return @f_shell.compute_size(constrains.attr_x, constrains.attr_y, true)
    end
    
    typesig { [] }
    # Computes the trim (status text and tool bar are considered as trim).
    # Subclasses can extend this method to add additional trim (e.g. scroll
    # bars for resizable information controls).
    # 
    # @see org.eclipse.jface.text.IInformationControlExtension3#computeTrim()
    def compute_trim
      trim = @f_shell.compute_trim(0, 0, 0, 0)
      if (!(@f_status_composite).nil?)
        trim.attr_height += @f_status_composite.compute_size(SWT::DEFAULT, SWT::DEFAULT).attr_y
      end
      return trim
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.IInformationControlExtension3#getBounds()
    def get_bounds
      return @f_shell.get_bounds
    end
    
    typesig { [] }
    # {@inheritDoc}
    # <p>
    # The default implementation always returns <code>false</code>.
    # </p>
    # @see org.eclipse.jface.text.IInformationControlExtension3#restoresLocation()
    def restores_location
      return false
    end
    
    typesig { [] }
    # {@inheritDoc}
    # <p>
    # The default implementation always returns <code>false</code>.
    # </p>
    # @see org.eclipse.jface.text.IInformationControlExtension3#restoresSize()
    def restores_size
      return false
    end
    
    typesig { [DisposeListener] }
    # @see IInformationControl#addDisposeListener(DisposeListener)
    def add_dispose_listener(listener)
      @f_shell.add_dispose_listener(listener)
    end
    
    typesig { [DisposeListener] }
    # @see IInformationControl#removeDisposeListener(DisposeListener)
    def remove_dispose_listener(listener)
      @f_shell.remove_dispose_listener(listener)
    end
    
    typesig { [Color] }
    # @see IInformationControl#setForegroundColor(Color)
    def set_foreground_color(foreground)
      @f_content_composite.set_foreground(foreground)
    end
    
    typesig { [Color] }
    # @see IInformationControl#setBackgroundColor(Color)
    def set_background_color(background)
      @f_content_composite.set_background(background)
    end
    
    typesig { [] }
    # {@inheritDoc}
    # This method is not intended to be overridden by subclasses.
    def is_focus_control
      return (@f_shell.get_display.get_active_shell).equal?(@f_shell)
    end
    
    typesig { [] }
    # This default implementation sets the focus on the popup shell.
    # Subclasses can override or extend.
    # 
    # @see IInformationControl#setFocus()
    def set_focus
      focus_taken = @f_shell.set_focus
      if (!focus_taken)
        @f_shell.force_focus
      end
    end
    
    typesig { [FocusListener] }
    # {@inheritDoc}
    # This method is not intended to be overridden by subclasses.
    def add_focus_listener(listener)
      if (@f_focus_listeners.is_empty)
        @f_shell_listener = Class.new(Listener.class == Class ? Listener : Object) do
          local_class_in AbstractInformationControl
          include_class_members AbstractInformationControl
          include Listener if Listener.class == Module
          
          typesig { [Event] }
          define_method :handle_event do |event|
            listeners = self.attr_f_focus_listeners.get_listeners
            i = 0
            while i < listeners.attr_length
              focus_listener = listeners[i]
              if ((event.attr_type).equal?(SWT::Activate))
                focus_listener.focus_gained(self.class::FocusEvent.new(event))
              else
                focus_listener.focus_lost(self.class::FocusEvent.new(event))
              end
              i += 1
            end
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self)
        @f_shell.add_listener(SWT::Deactivate, @f_shell_listener)
        @f_shell.add_listener(SWT::Activate, @f_shell_listener)
      end
      @f_focus_listeners.add(listener)
    end
    
    typesig { [FocusListener] }
    # {@inheritDoc}
    # This method is not intended to be overridden by subclasses.
    def remove_focus_listener(listener)
      @f_focus_listeners.remove(listener)
      if (@f_focus_listeners.is_empty)
        @f_shell.remove_listener(SWT::Activate, @f_shell_listener)
        @f_shell.remove_listener(SWT::Deactivate, @f_shell_listener)
        @f_shell_listener = nil
      end
    end
    
    typesig { [String] }
    # Sets the text of the status field.
    # <p>
    # The default implementation currently only updates the status field when
    # the popup shell is not visible. The status field can currently only be
    # shown if the information control has been created with a non-null status
    # field text.
    # </p>
    # 
    # @param statusFieldText the text to be used in the optional status field
    # or <code>null</code> if the status field should be hidden
    # 
    # @see org.eclipse.jface.text.IInformationControlExtension4#setStatusText(java.lang.String)
    def set_status_text(status_field_text)
      if (!(@f_status_label).nil? && !get_shell.is_visible)
        if ((status_field_text).nil?)
          @f_status_composite.set_visible(false)
        else
          @f_status_label.set_text(status_field_text)
          @f_status_composite.set_visible(true)
        end
      end
    end
    
    typesig { [Control] }
    # @see org.eclipse.jface.text.IInformationControlExtension5#containsControl(org.eclipse.swt.widgets.Control)
    def contains_control(control)
      begin
        if ((control).equal?(@f_shell))
          return true
        end
        if (control.is_a?(Shell))
          return false
        end
        control = control.get_parent
      end while (!(control).nil?)
      return false
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.IInformationControlExtension5#isVisible()
    def is_visible
      return !(@f_shell).nil? && !@f_shell.is_disposed && @f_shell.is_visible
    end
    
    typesig { [] }
    # {@inheritDoc}
    # This default implementation returns <code>null</code>. Subclasses may override.
    def get_information_presenter_control_creator
      return nil
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Computes the size constraints based on the
    # {@link JFaceResources#getDialogFont() dialog font}. Subclasses can
    # override or extend.
    # 
    # @see org.eclipse.jface.text.IInformationControlExtension5#computeSizeConstraints(int, int)
    def compute_size_constraints(width_in_chars, height_in_chars)
      gc = SwtGC.new(@f_content_composite)
      gc.set_font(JFaceResources.get_dialog_font)
      width = gc.get_font_metrics.get_average_char_width
      height = gc.get_font_metrics.get_height
      gc.dispose
      return Point.new(width_in_chars * width, height_in_chars * height)
    end
    
    private
    alias_method :initialize__abstract_information_control, :initialize
  end
  
end
