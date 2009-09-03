require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Source::Projection
  module SourceViewerInformationControlImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Source::Projection
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Custom, :StyledText
      include_const ::Org::Eclipse::Swt::Events, :DisposeEvent
      include_const ::Org::Eclipse::Swt::Events, :DisposeListener
      include_const ::Org::Eclipse::Swt::Events, :FocusListener
      include_const ::Org::Eclipse::Swt::Events, :KeyEvent
      include_const ::Org::Eclipse::Swt::Events, :KeyListener
      include_const ::Org::Eclipse::Swt::Graphics, :Color
      include_const ::Org::Eclipse::Swt::Graphics, :Font
      include_const ::Org::Eclipse::Swt::Graphics, :FontData
      include_const ::Org::Eclipse::Swt::Graphics, :GC
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Graphics, :Rectangle
      include_const ::Org::Eclipse::Swt::Layout, :GridData
      include_const ::Org::Eclipse::Swt::Layout, :GridLayout
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Display
      include_const ::Org::Eclipse::Swt::Widgets, :Label
      include_const ::Org::Eclipse::Swt::Widgets, :Shell
      include_const ::Org::Eclipse::Jface::Resource, :JFaceResources
      include_const ::Org::Eclipse::Jface::Text, :Document
      include_const ::Org::Eclipse::Jface::Text, :IDocument
      include_const ::Org::Eclipse::Jface::Text, :IInformationControl
      include_const ::Org::Eclipse::Jface::Text, :IInformationControlCreator
      include_const ::Org::Eclipse::Jface::Text, :IInformationControlExtension
      include_const ::Org::Eclipse::Jface::Text, :IInformationControlExtension3
      include_const ::Org::Eclipse::Jface::Text, :IInformationControlExtension5
      include_const ::Org::Eclipse::Jface::Text::Source, :SourceViewer
      include_const ::Org::Eclipse::Jface::Text::Source, :SourceViewerConfiguration
    }
  end
  
  # Source viewer based implementation of {@link org.eclipse.jface.text.IInformationControl}.
  # Displays information in a source viewer.
  # 
  # @since 3.0
  class SourceViewerInformationControl 
    include_class_members SourceViewerInformationControlImports
    include IInformationControl
    include IInformationControlExtension
    include IInformationControlExtension3
    include IInformationControlExtension5
    include DisposeListener
    
    # The control's shell
    attr_accessor :f_shell
    alias_method :attr_f_shell, :f_shell
    undef_method :f_shell
    alias_method :attr_f_shell=, :f_shell=
    undef_method :f_shell=
    
    # The control's text widget
    attr_accessor :f_text
    alias_method :attr_f_text, :f_text
    undef_method :f_text
    alias_method :attr_f_text=, :f_text=
    undef_method :f_text=
    
    # The symbolic font name of the text font
    attr_accessor :f_symbolic_font_name
    alias_method :attr_f_symbolic_font_name, :f_symbolic_font_name
    undef_method :f_symbolic_font_name
    alias_method :attr_f_symbolic_font_name=, :f_symbolic_font_name=
    undef_method :f_symbolic_font_name=
    
    # The text font (do not dispose!)
    attr_accessor :f_text_font
    alias_method :attr_f_text_font, :f_text_font
    undef_method :f_text_font
    alias_method :attr_f_text_font=, :f_text_font=
    undef_method :f_text_font=
    
    # The control's source viewer
    attr_accessor :f_viewer
    alias_method :attr_f_viewer, :f_viewer
    undef_method :f_viewer
    alias_method :attr_f_viewer=, :f_viewer=
    undef_method :f_viewer=
    
    # The optional status field.
    attr_accessor :f_status_field
    alias_method :attr_f_status_field, :f_status_field
    undef_method :f_status_field
    alias_method :attr_f_status_field=, :f_status_field=
    undef_method :f_status_field=
    
    # The separator for the optional status field.
    attr_accessor :f_separator
    alias_method :attr_f_separator, :f_separator
    undef_method :f_separator
    alias_method :attr_f_separator=, :f_separator=
    undef_method :f_separator=
    
    # The font of the optional status text label.
    attr_accessor :f_status_text_font
    alias_method :attr_f_status_text_font, :f_status_text_font
    undef_method :f_status_text_font
    alias_method :attr_f_status_text_font=, :f_status_text_font=
    undef_method :f_status_text_font=
    
    # The maximal widget width.
    attr_accessor :f_max_width
    alias_method :attr_f_max_width, :f_max_width
    undef_method :f_max_width
    alias_method :attr_f_max_width=, :f_max_width=
    undef_method :f_max_width=
    
    # The maximal widget height.
    attr_accessor :f_max_height
    alias_method :attr_f_max_height, :f_max_height
    undef_method :f_max_height
    alias_method :attr_f_max_height=, :f_max_height=
    undef_method :f_max_height=
    
    typesig { [Shell, ::Java::Boolean, String, String] }
    # Creates a source viewer information control with the given shell as parent. The given shell
    # styles are applied to the created shell. The given styles are applied to the created styled
    # text widget. The text widget will be initialized with the given font. The status field will
    # contain the given text or be hidden.
    # 
    # @param parent the parent shell
    # @param isResizable <code>true</code> if resizable
    # @param symbolicFontName the symbolic font name
    # @param statusFieldText the text to be used in the optional status field or <code>null</code>
    # if the status field should be hidden
    def initialize(parent, is_resizable, symbolic_font_name, status_field_text)
      @f_shell = nil
      @f_text = nil
      @f_symbolic_font_name = nil
      @f_text_font = nil
      @f_viewer = nil
      @f_status_field = nil
      @f_separator = nil
      @f_status_text_font = nil
      @f_max_width = 0
      @f_max_height = 0
      layout = nil
      gd = nil
      shell_style = SWT::TOOL | SWT::ON_TOP | (is_resizable ? SWT::RESIZE : 0)
      text_style = is_resizable ? SWT::V_SCROLL | SWT::H_SCROLL : SWT::NONE
      @f_shell = Shell.new(parent, SWT::NO_FOCUS | SWT::ON_TOP | shell_style)
      display = @f_shell.get_display
      composite = @f_shell
      layout = GridLayout.new(1, false)
      layout.attr_margin_height = 0
      layout.attr_margin_width = 0
      composite.set_layout(layout)
      gd = GridData.new(GridData::FILL_HORIZONTAL)
      composite.set_layout_data(gd)
      if (!(status_field_text).nil?)
        composite = Composite.new(composite, SWT::NONE)
        layout = GridLayout.new(1, false)
        layout.attr_margin_height = 0
        layout.attr_margin_width = 0
        composite.set_layout(layout)
        gd = GridData.new(GridData::FILL_BOTH)
        composite.set_layout_data(gd)
        composite.set_foreground(display.get_system_color(SWT::COLOR_INFO_FOREGROUND))
        composite.set_background(display.get_system_color(SWT::COLOR_INFO_BACKGROUND))
      end
      # Source viewer
      @f_viewer = SourceViewer.new(composite, nil, text_style)
      @f_viewer.configure(SourceViewerConfiguration.new)
      @f_viewer.set_editable(false)
      @f_text = @f_viewer.get_text_widget
      gd = GridData.new(GridData::BEGINNING | GridData::FILL_BOTH)
      @f_text.set_layout_data(gd)
      @f_text.set_foreground(parent.get_display.get_system_color(SWT::COLOR_INFO_FOREGROUND))
      @f_text.set_background(parent.get_display.get_system_color(SWT::COLOR_INFO_BACKGROUND))
      @f_symbolic_font_name = symbolic_font_name
      @f_text_font = JFaceResources.get_font(symbolic_font_name)
      @f_text.set_font(@f_text_font)
      @f_text.add_key_listener(Class.new(KeyListener.class == Class ? KeyListener : Object) do
        extend LocalClass
        include_class_members SourceViewerInformationControl
        include KeyListener if KeyListener.class == Module
        
        typesig { [KeyEvent] }
        define_method :key_pressed do |e|
          if ((e.attr_character).equal?(0x1b))
            # ESC
            self.attr_f_shell.dispose
          end
        end
        
        typesig { [KeyEvent] }
        define_method :key_released do |e|
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      # Status field
      if (!(status_field_text).nil?)
        # Horizontal separator line
        @f_separator = Label.new(composite, SWT::SEPARATOR | SWT::HORIZONTAL | SWT::LINE_DOT)
        @f_separator.set_layout_data(GridData.new(GridData::FILL_HORIZONTAL))
        # Status field label
        @f_status_field = Label.new(composite, SWT::RIGHT)
        @f_status_field.set_text(status_field_text)
        font = @f_status_field.get_font
        font_datas = font.get_font_data
        i = 0
        while i < font_datas.attr_length
          font_datas[i].set_height(font_datas[i].get_height * 9 / 10)
          i += 1
        end
        @f_status_text_font = Font.new(@f_status_field.get_display, font_datas)
        @f_status_field.set_font(@f_status_text_font)
        gd2 = GridData.new(GridData::FILL_VERTICAL | GridData::FILL_HORIZONTAL | GridData::HORIZONTAL_ALIGN_BEGINNING | GridData::VERTICAL_ALIGN_BEGINNING)
        @f_status_field.set_layout_data(gd2)
        # Regarding the color see bug 41128
        @f_status_field.set_foreground(display.get_system_color(SWT::COLOR_WIDGET_DARK_SHADOW))
        @f_status_field.set_background(display.get_system_color(SWT::COLOR_INFO_BACKGROUND))
      end
      add_dispose_listener(self)
    end
    
    typesig { [Object] }
    # @see org.eclipse.jface.text.IInformationControlExtension2#setInput(java.lang.Object)
    # @param input the input object
    def set_input(input)
      if (input.is_a?(String))
        set_information(input)
      else
        set_information(nil)
      end
    end
    
    typesig { [String] }
    # @see IInformationControl#setInformation(String)
    def set_information(content)
      if ((content).nil?)
        @f_viewer.set_input(nil)
        return
      end
      doc = Document.new(content)
      @f_viewer.set_input(doc)
    end
    
    typesig { [::Java::Boolean] }
    # @see IInformationControl#setVisible(boolean)
    def set_visible(visible)
      @f_shell.set_visible(visible)
    end
    
    typesig { [DisposeEvent] }
    # @see org.eclipse.swt.events.DisposeListener#widgetDisposed(org.eclipse.swt.events.DisposeEvent)
    def widget_disposed(event)
      if (!(@f_status_text_font).nil? && !@f_status_text_font.is_disposed)
        @f_status_text_font.dispose
      end
      @f_status_text_font = nil
      @f_text_font = nil
      @f_shell = nil
      @f_text = nil
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.IInformationControl#dispose()
    def dispose
      if (!(@f_shell).nil? && !@f_shell.is_disposed)
        @f_shell.dispose
      else
        widget_disposed(nil)
      end
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # @see IInformationControl#setSize(int, int)
    def set_size(width, height)
      if (!(@f_status_field).nil?)
        gd = @f_viewer.get_text_widget.get_layout_data
        status_size = @f_status_field.compute_size(SWT::DEFAULT, SWT::DEFAULT, true)
        separator_size = @f_separator.compute_size(SWT::DEFAULT, SWT::DEFAULT, true)
        gd.attr_height_hint = height - status_size.attr_y - separator_size.attr_y
      end
      @f_shell.set_size(width, height)
      if (!(@f_status_field).nil?)
        @f_shell.pack(true)
      end
    end
    
    typesig { [Point] }
    # @see IInformationControl#setLocation(Point)
    def set_location(location)
      @f_shell.set_location(location)
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # @see IInformationControl#setSizeConstraints(int, int)
    def set_size_constraints(max_width, max_height)
      @f_max_width = max_width
      @f_max_height = max_height
    end
    
    typesig { [] }
    # @see IInformationControl#computeSizeHint()
    def compute_size_hint
      # compute the preferred size
      x = SWT::DEFAULT
      y = SWT::DEFAULT
      size = @f_shell.compute_size(x, y)
      if (size.attr_x > @f_max_width)
        x = @f_max_width
      end
      if (size.attr_y > @f_max_height)
        y = @f_max_height
      end
      # recompute using the constraints if the preferred size is larger than the constraints
      if (!(x).equal?(SWT::DEFAULT) || !(y).equal?(SWT::DEFAULT))
        size = @f_shell.compute_size(x, y, false)
      end
      return size
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
      @f_text.set_foreground(foreground)
    end
    
    typesig { [Color] }
    # @see IInformationControl#setBackgroundColor(Color)
    def set_background_color(background)
      @f_text.set_background(background)
    end
    
    typesig { [] }
    # @see IInformationControl#isFocusControl()
    def is_focus_control
      return (@f_shell.get_display.get_active_shell).equal?(@f_shell)
    end
    
    typesig { [] }
    # @see IInformationControl#setFocus()
    def set_focus
      @f_shell.force_focus
      @f_text.set_focus
    end
    
    typesig { [FocusListener] }
    # @see IInformationControl#addFocusListener(FocusListener)
    def add_focus_listener(listener)
      @f_text.add_focus_listener(listener)
    end
    
    typesig { [FocusListener] }
    # @see IInformationControl#removeFocusListener(FocusListener)
    def remove_focus_listener(listener)
      @f_text.remove_focus_listener(listener)
    end
    
    typesig { [] }
    # @see IInformationControlExtension#hasContents()
    def has_contents
      return @f_text.get_char_count > 0
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.IInformationControlExtension3#computeTrim()
    # @since 3.4
    def compute_trim
      trim = @f_shell.compute_trim(0, 0, 0, 0)
      add_internal_trim(trim)
      return trim
    end
    
    typesig { [Rectangle] }
    # Adds the internal trimmings to the given trim of the shell.
    # 
    # @param trim the shell's trim, will be updated
    # @since 3.4
    def add_internal_trim(trim)
      if (!(@f_status_field).nil?)
        trim.attr_height += @f_separator.compute_size(SWT::DEFAULT, SWT::DEFAULT).attr_y
        trim.attr_height += @f_status_field.compute_size(SWT::DEFAULT, SWT::DEFAULT).attr_y
      end
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.IInformationControlExtension3#getBounds()
    # @since 3.4
    def get_bounds
      return @f_shell.get_bounds
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.IInformationControlExtension3#restoresLocation()
    # @since 3.4
    def restores_location
      return false
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.IInformationControlExtension3#restoresSize()
    # @since 3.4
    def restores_size
      return false
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.IInformationControlExtension5#getInformationPresenterControlCreator()
    # @since 3.4
    def get_information_presenter_control_creator
      return Class.new(IInformationControlCreator.class == Class ? IInformationControlCreator : Object) do
        extend LocalClass
        include_class_members SourceViewerInformationControl
        include IInformationControlCreator if IInformationControlCreator.class == Module
        
        typesig { [Shell] }
        define_method :create_information_control do |parent|
          return self.class::SourceViewerInformationControl.new(parent, true, self.attr_f_symbolic_font_name, nil)
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
    end
    
    typesig { [Control] }
    # @see org.eclipse.jface.text.IInformationControlExtension5#containsControl(org.eclipse.swt.widgets.Control)
    # @since 3.4
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
    # @since 3.4
    def is_visible
      return !(@f_shell).nil? && !@f_shell.is_disposed && @f_shell.is_visible
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # @see org.eclipse.jface.text.IInformationControlExtension5#computeSizeConstraints(int, int)
    def compute_size_constraints(width_in_chars, height_in_chars)
      gc = GC.new(@f_text)
      gc.set_font(@f_text_font)
      width = gc.get_font_metrics.get_average_char_width
      height = gc.get_font_metrics.get_height
      gc.dispose
      return Point.new(width_in_chars * width, height_in_chars * height)
    end
    
    private
    alias_method :initialize__source_viewer_information_control, :initialize
  end
  
end
