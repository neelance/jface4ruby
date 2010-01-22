require "rjava"

# Copyright (c) 2000, 2009 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Internal::Text::Html
  module BrowserInformationControlImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Internal::Text::Html
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :StringReader
      include_const ::Java::Util, :Iterator
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt, :SWTError
      include_const ::Org::Eclipse::Swt::Browser, :Browser
      include_const ::Org::Eclipse::Swt::Browser, :LocationListener
      include_const ::Org::Eclipse::Swt::Browser, :OpenWindowListener
      include_const ::Org::Eclipse::Swt::Browser, :ProgressAdapter
      include_const ::Org::Eclipse::Swt::Browser, :ProgressEvent
      include_const ::Org::Eclipse::Swt::Browser, :WindowEvent
      include_const ::Org::Eclipse::Swt::Custom, :StyleRange
      include_const ::Org::Eclipse::Swt::Events, :KeyEvent
      include_const ::Org::Eclipse::Swt::Events, :KeyListener
      include_const ::Org::Eclipse::Swt::Graphics, :Color
      include_const ::Org::Eclipse::Swt::Graphics, :Font
      include_const ::Org::Eclipse::Swt::Graphics, :SwtGC
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Graphics, :Rectangle
      include_const ::Org::Eclipse::Swt::Graphics, :TextLayout
      include_const ::Org::Eclipse::Swt::Graphics, :TextStyle
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Display
      include_const ::Org::Eclipse::Swt::Widgets, :Menu
      include_const ::Org::Eclipse::Swt::Widgets, :Shell
      include_const ::Org::Eclipse::Swt::Widgets, :Slider
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Core::Runtime, :ListenerList
      include_const ::Org::Eclipse::Jface::Action, :ToolBarManager
      include_const ::Org::Eclipse::Jface::Resource, :JFaceResources
      include_const ::Org::Eclipse::Jface::Text, :AbstractInformationControl
      include_const ::Org::Eclipse::Jface::Text, :IDelayedInputChangeProvider
      include_const ::Org::Eclipse::Jface::Text, :IInformationControlExtension2
      include_const ::Org::Eclipse::Jface::Text, :IInputChangedListener
      include_const ::Org::Eclipse::Jface::Text, :TextPresentation
    }
  end
  
  # Displays HTML information in a {@link org.eclipse.swt.browser.Browser} widget.
  # <p>
  # This {@link IInformationControlExtension2} expects {@link #setInput(Object)} to be
  # called with an argument of type {@link BrowserInformationControlInput}.
  # </p>
  # <p>
  # Moved into this package from <code>org.eclipse.jface.internal.text.revisions</code>.</p>
  # <p>
  # This class may be instantiated; it is not intended to be subclassed.</p>
  # <p>
  # Current problems:
  # <ul>
  # <li>the size computation is too small</li>
  # <li>focusLost event is not sent - see https://bugs.eclipse.org/bugs/show_bug.cgi?id=84532</li>
  # </ul>
  # </p>
  # 
  # @since 3.2
  class BrowserInformationControl < BrowserInformationControlImports.const_get :AbstractInformationControl
    include_class_members BrowserInformationControlImports
    overload_protected {
      include IInformationControlExtension2
      include IDelayedInputChangeProvider
    }
    
    class_module.module_eval {
      typesig { [Composite] }
      # Tells whether the SWT Browser widget and hence this information
      # control is available.
      # 
      # @param parent the parent component used for checking or <code>null</code> if none
      # @return <code>true</code> if this control is available
      def is_available(parent)
        if (!self.attr_fg_availability_checked)
          begin
            browser = Browser.new(parent, SWT::NONE)
            browser.dispose
            self.attr_fg_is_available = true
            slider_v = Slider.new(parent, SWT::VERTICAL)
            slider_h = Slider.new(parent, SWT::HORIZONTAL)
            width = slider_v.compute_size(SWT::DEFAULT, SWT::DEFAULT).attr_x
            height = slider_h.compute_size(SWT::DEFAULT, SWT::DEFAULT).attr_y
            self.attr_fg_scroll_bar_size = Point.new(width, height)
            slider_v.dispose
            slider_h.dispose
          rescue SWTError => er
            self.attr_fg_is_available = false
          ensure
            self.attr_fg_availability_checked = true
          end
        end
        return self.attr_fg_is_available
      end
      
      # Minimal size constraints.
      # @since 3.2
      const_set_lazy(:MIN_WIDTH) { 80 }
      const_attr_reader  :MIN_WIDTH
      
      const_set_lazy(:MIN_HEIGHT) { 50 }
      const_attr_reader  :MIN_HEIGHT
      
      # Availability checking cache.
      
      def fg_is_available
        defined?(@@fg_is_available) ? @@fg_is_available : @@fg_is_available= false
      end
      alias_method :attr_fg_is_available, :fg_is_available
      
      def fg_is_available=(value)
        @@fg_is_available = value
      end
      alias_method :attr_fg_is_available=, :fg_is_available=
      
      
      def fg_availability_checked
        defined?(@@fg_availability_checked) ? @@fg_availability_checked : @@fg_availability_checked= false
      end
      alias_method :attr_fg_availability_checked, :fg_availability_checked
      
      def fg_availability_checked=(value)
        @@fg_availability_checked = value
      end
      alias_method :attr_fg_availability_checked=, :fg_availability_checked=
      
      # Cached scroll bar width and height
      # @since 3.4
      
      def fg_scroll_bar_size
        defined?(@@fg_scroll_bar_size) ? @@fg_scroll_bar_size : @@fg_scroll_bar_size= nil
      end
      alias_method :attr_fg_scroll_bar_size, :fg_scroll_bar_size
      
      def fg_scroll_bar_size=(value)
        @@fg_scroll_bar_size = value
      end
      alias_method :attr_fg_scroll_bar_size=, :fg_scroll_bar_size=
    }
    
    # The control's browser widget
    attr_accessor :f_browser
    alias_method :attr_f_browser, :f_browser
    undef_method :f_browser
    alias_method :attr_f_browser=, :f_browser=
    undef_method :f_browser=
    
    # Tells whether the browser has content
    attr_accessor :f_browser_has_content
    alias_method :attr_f_browser_has_content, :f_browser_has_content
    undef_method :f_browser_has_content
    alias_method :attr_f_browser_has_content=, :f_browser_has_content=
    undef_method :f_browser_has_content=
    
    # Text layout used to approximate size of content when rendered in browser
    attr_accessor :f_text_layout
    alias_method :attr_f_text_layout, :f_text_layout
    undef_method :f_text_layout
    alias_method :attr_f_text_layout=, :f_text_layout=
    undef_method :f_text_layout=
    
    # Bold text style
    attr_accessor :f_bold_style
    alias_method :attr_f_bold_style, :f_bold_style
    undef_method :f_bold_style
    alias_method :attr_f_bold_style=, :f_bold_style=
    undef_method :f_bold_style=
    
    attr_accessor :f_input
    alias_method :attr_f_input, :f_input
    undef_method :f_input
    alias_method :attr_f_input=, :f_input=
    undef_method :f_input=
    
    # <code>true</code> iff the browser has completed loading of the last
    # input set via {@link #setInformation(String)}.
    # @since 3.4
    attr_accessor :f_completed
    alias_method :attr_f_completed, :f_completed
    undef_method :f_completed
    alias_method :attr_f_completed=, :f_completed=
    undef_method :f_completed=
    
    # The listener to be notified when a delayed location changing event happened.
    # @since 3.4
    attr_accessor :f_delayed_input_change_listener
    alias_method :attr_f_delayed_input_change_listener, :f_delayed_input_change_listener
    undef_method :f_delayed_input_change_listener
    alias_method :attr_f_delayed_input_change_listener=, :f_delayed_input_change_listener=
    undef_method :f_delayed_input_change_listener=
    
    # The listeners to be notified when the input changed.
    # @since 3.4
    # 
    # <IInputChangedListener>
    attr_accessor :f_input_change_listeners
    alias_method :attr_f_input_change_listeners, :f_input_change_listeners
    undef_method :f_input_change_listeners
    alias_method :attr_f_input_change_listeners=, :f_input_change_listeners=
    undef_method :f_input_change_listeners=
    
    # The symbolic name of the font used for size computations, or <code>null</code> to use dialog font.
    # @since 3.4
    attr_accessor :f_symbolic_font_name
    alias_method :attr_f_symbolic_font_name, :f_symbolic_font_name
    undef_method :f_symbolic_font_name
    alias_method :attr_f_symbolic_font_name=, :f_symbolic_font_name=
    undef_method :f_symbolic_font_name=
    
    typesig { [Shell, String, ::Java::Boolean] }
    # Creates a browser information control with the given shell as parent.
    # 
    # @param parent the parent shell
    # @param symbolicFontName the symbolic name of the font used for size computations
    # @param resizable <code>true</code> if the control should be resizable
    # @since 3.4
    def initialize(parent, symbolic_font_name, resizable)
      @f_browser = nil
      @f_browser_has_content = false
      @f_text_layout = nil
      @f_bold_style = nil
      @f_input = nil
      @f_completed = false
      @f_delayed_input_change_listener = nil
      @f_input_change_listeners = nil
      @f_symbolic_font_name = nil
      super(parent, resizable)
      @f_completed = false
      @f_input_change_listeners = ListenerList.new(ListenerList::IDENTITY)
      @f_symbolic_font_name = symbolic_font_name
      create
    end
    
    typesig { [Shell, String, String] }
    # Creates a browser information control with the given shell as parent.
    # 
    # @param parent the parent shell
    # @param symbolicFontName the symbolic name of the font used for size computations
    # @param statusFieldText the text to be used in the optional status field
    # or <code>null</code> if the status field should be hidden
    # @since 3.4
    def initialize(parent, symbolic_font_name, status_field_text)
      @f_browser = nil
      @f_browser_has_content = false
      @f_text_layout = nil
      @f_bold_style = nil
      @f_input = nil
      @f_completed = false
      @f_delayed_input_change_listener = nil
      @f_input_change_listeners = nil
      @f_symbolic_font_name = nil
      super(parent, status_field_text)
      @f_completed = false
      @f_input_change_listeners = ListenerList.new(ListenerList::IDENTITY)
      @f_symbolic_font_name = symbolic_font_name
      create
    end
    
    typesig { [Shell, String, ToolBarManager] }
    # Creates a browser information control with the given shell as parent.
    # 
    # @param parent the parent shell
    # @param symbolicFontName the symbolic name of the font used for size computations
    # @param toolBarManager the manager or <code>null</code> if toolbar is not desired
    # @since 3.4
    def initialize(parent, symbolic_font_name, tool_bar_manager)
      @f_browser = nil
      @f_browser_has_content = false
      @f_text_layout = nil
      @f_bold_style = nil
      @f_input = nil
      @f_completed = false
      @f_delayed_input_change_listener = nil
      @f_input_change_listeners = nil
      @f_symbolic_font_name = nil
      super(parent, tool_bar_manager)
      @f_completed = false
      @f_input_change_listeners = ListenerList.new(ListenerList::IDENTITY)
      @f_symbolic_font_name = symbolic_font_name
      create
    end
    
    typesig { [Composite] }
    # @see org.eclipse.jface.text.AbstractInformationControl#createContent(org.eclipse.swt.widgets.Composite)
    def create_content(parent)
      @f_browser = Browser.new(parent, SWT::NONE)
      @f_browser.set_javascript_enabled(false)
      display = get_shell.get_display
      @f_browser.set_foreground(display.get_system_color(SWT::COLOR_INFO_FOREGROUND))
      @f_browser.set_background(display.get_system_color(SWT::COLOR_INFO_BACKGROUND))
      @f_browser.add_key_listener(Class.new(KeyListener.class == Class ? KeyListener : Object) do
        extend LocalClass
        include_class_members BrowserInformationControl
        include KeyListener if KeyListener.class == Module
        
        typesig { [KeyEvent] }
        define_method :key_pressed do |e|
          if ((e.attr_character).equal?(0x1b))
            # ESC
            dispose
          end # XXX: Just hide? Would avoid constant recreations.
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
      @f_browser.add_progress_listener(Class.new(ProgressAdapter.class == Class ? ProgressAdapter : Object) do
        extend LocalClass
        include_class_members BrowserInformationControl
        include ProgressAdapter if ProgressAdapter.class == Module
        
        typesig { [ProgressEvent] }
        define_method :completed do |event|
          self.attr_f_completed = true
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      @f_browser.add_open_window_listener(Class.new(OpenWindowListener.class == Class ? OpenWindowListener : Object) do
        extend LocalClass
        include_class_members BrowserInformationControl
        include OpenWindowListener if OpenWindowListener.class == Module
        
        typesig { [WindowEvent] }
        define_method :open do |event|
          event.attr_required = true # Cancel opening of new windows
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      # Replace browser's built-in context menu with none
      @f_browser.set_menu(Menu.new(get_shell, SWT::NONE))
      create_text_layout
    end
    
    typesig { [String] }
    # {@inheritDoc}
    # @deprecated use {@link #setInput(Object)}
    def set_information(content)
      set_input(Class.new(BrowserInformationControlInput.class == Class ? BrowserInformationControlInput : Object) do
        extend LocalClass
        include_class_members BrowserInformationControl
        include BrowserInformationControlInput if BrowserInformationControlInput.class == Module
        
        typesig { [] }
        define_method :get_html do
          return content
        end
        
        typesig { [] }
        define_method :get_input_name do
          return "" # $NON-NLS-1$
        end
        
        typesig { [] }
        define_method :get_input_element do
          return content
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self, nil))
    end
    
    typesig { [Object] }
    # {@inheritDoc} This control can handle {@link String} and
    # {@link BrowserInformationControlInput}.
    def set_input(input)
      Assert.is_legal((input).nil? || input.is_a?(String) || input.is_a?(BrowserInformationControlInput))
      if (input.is_a?(String))
        set_information(input)
        return
      end
      @f_input = input
      content = nil
      if (!(@f_input).nil?)
        content = RJava.cast_to_string(@f_input.get_html)
      end
      @f_browser_has_content = !(content).nil? && content.length > 0
      if (!@f_browser_has_content)
        content = "<html><body ></html>"
      end # $NON-NLS-1$
      rtl = !((get_shell.get_style & SWT::RIGHT_TO_LEFT)).equal?(0)
      resizable = is_resizable
      # The default "overflow:auto" would not result in a predictable width for the client area
      # and the re-wrapping would cause visual noise
      styles = nil
      if (rtl && resizable)
        styles = Array.typed(String).new(["direction:rtl;", "overflow:scroll;", "word-wrap:break-word;"])
         # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
      else
        if (rtl && !resizable)
          styles = Array.typed(String).new(["direction:rtl;", "overflow:hidden;", "word-wrap:break-word;"])
           # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
        else
          if (!resizable)
            # XXX: In IE, "word-wrap: break-word;" causes bogus wrapping even in non-broken words :-(see e.g. Javadoc of String).
            # Re-check whether we really still need this now that the Javadoc Hover header already sets this style.
            # , "word-wrap: break-word;"
            styles = Array.typed(String).new(["overflow:hidden;"])
             # $NON-NLS-1$
          else
            styles = Array.typed(String).new(["overflow:scroll;"])
          end
        end
      end # $NON-NLS-1$
      buffer = StringBuffer.new(content)
      HTMLPrinter.insert_styles(buffer, styles)
      content = RJava.cast_to_string(buffer.to_s)
      # XXX: Should add some JavaScript here that shows something like
      # "(continued...)" or "..." at the end of the visible area when the page overflowed
      # with "overflow:hidden;".
      @f_completed = false
      @f_browser.set_text(content)
      listeners = @f_input_change_listeners.get_listeners
      i = 0
      while i < listeners.attr_length
        (listeners[i]).input_changed(@f_input)
        i += 1
      end
    end
    
    typesig { [::Java::Boolean] }
    # @see IInformationControl#setVisible(boolean)
    def set_visible(visible)
      shell = get_shell
      if ((shell.is_visible).equal?(visible))
        return
      end
      if (!visible)
        super(false)
        set_input(nil)
        return
      end
      # The Browser widget flickers when made visible while it is not completely loaded.
      # The fix is to delay the call to setVisible until either loading is completed
      # (see ProgressListener in constructor), or a timeout has been reached.
      display = shell.get_display
      display.timer_exec(100, # Make sure the display wakes from sleep after timeout:
      Class.new(Runnable.class == Class ? Runnable : Object) do
        extend LocalClass
        include_class_members BrowserInformationControl
        include Runnable if Runnable.class == Module
        
        typesig { [] }
        define_method :run do
          self.attr_f_completed = true
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      while (!@f_completed)
        # Drive the event loop to process the events required to load the browser widget's contents:
        if (!display.read_and_dispatch)
          display.sleep
        end
      end
      shell = get_shell
      if ((shell).nil? || shell.is_disposed)
        return
      end
      # Avoids flickering when replacing hovers, especially on Vista in ON_CLICK mode.
      # Causes flickering on GTK. Carbon does not care.
      if (("win32" == SWT.get_platform))
        # $NON-NLS-1$
        shell.move_above(nil)
      end
      super(true)
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # @see org.eclipse.jface.text.AbstractInformationControl#setSize(int, int)
    def set_size(width, height)
      @f_browser.set_redraw(false) # avoid flickering
      begin
        super(width, height)
      ensure
        @f_browser.set_redraw(true)
      end
    end
    
    typesig { [] }
    # Creates and initializes the text layout used
    # to compute the size hint.
    # 
    # @since 3.2
    def create_text_layout
      @f_text_layout = TextLayout.new(@f_browser.get_display)
      # Initialize fonts
      symbolic_font_name = (@f_symbolic_font_name).nil? ? JFaceResources::DIALOG_FONT : @f_symbolic_font_name
      font = JFaceResources.get_font(symbolic_font_name)
      @f_text_layout.set_font(font)
      @f_text_layout.set_width(-1)
      font = JFaceResources.get_font_registry.get_bold(symbolic_font_name)
      @f_bold_style = TextStyle.new(font, nil, nil)
      # Compute and set tab width
      @f_text_layout.set_text("    ") # $NON-NLS-1$
      tab_width = @f_text_layout.get_bounds.attr_width
      @f_text_layout.set_tabs(Array.typed(::Java::Int).new([tab_width]))
      @f_text_layout.set_text("") # $NON-NLS-1$
    end
    
    typesig { [] }
    # @see IInformationControl#dispose()
    def dispose
      if (!(@f_text_layout).nil?)
        @f_text_layout.dispose
        @f_text_layout = nil
      end
      @f_browser = nil
      super
    end
    
    typesig { [] }
    # @see IInformationControl#computeSizeHint()
    def compute_size_hint
      size_constraints = get_size_constraints
      trim = compute_trim
      height = trim.attr_height
      # FIXME: The HTML2TextReader does not render <p> like a browser.
      # Instead of inserting an empty line, it just adds a single line break.
      # Furthermore, the indentation of <dl><dd> elements is too small (e.g with a long @see line)
      presentation = TextPresentation.new
      reader = HTML2TextReader.new(StringReader.new(@f_input.get_html), presentation)
      text = nil
      begin
        text = RJava.cast_to_string(reader.get_string)
      rescue IOException => e
        text = "" # $NON-NLS-1$
      end
      @f_text_layout.set_text(text)
      @f_text_layout.set_width((size_constraints).nil? ? SWT::DEFAULT : size_constraints.attr_x - trim.attr_width)
      iter = presentation.get_all_style_range_iterator
      while (iter.has_next)
        sr = iter.next_
        if ((sr.attr_font_style).equal?(SWT::BOLD))
          @f_text_layout.set_style(@f_bold_style, sr.attr_start, sr.attr_start + sr.attr_length - 1)
        end
      end
      bounds = @f_text_layout.get_bounds # does not return minimum width, see https://bugs.eclipse.org/bugs/show_bug.cgi?id=217446
      line_count = @f_text_layout.get_line_count
      text_width = 0
      i = 0
      while i < line_count
        rect = @f_text_layout.get_line_bounds(i)
        line_width = rect.attr_x + rect.attr_width
        if ((i).equal?(0))
          line_width += @f_input.get_leading_image_width
        end
        text_width = Math.max(text_width, line_width)
        i += 1
      end
      bounds.attr_width = text_width
      @f_text_layout.set_text("") # $NON-NLS-1$
      min_width = bounds.attr_width
      height = height + bounds.attr_height
      # Add some air to accommodate for different browser renderings
      min_width += 15
      height += 15
      # Apply max size constraints
      if (!(size_constraints).nil?)
        if (!(size_constraints.attr_x).equal?(SWT::DEFAULT))
          min_width = Math.min(size_constraints.attr_x, min_width + trim.attr_width)
        end
        if (!(size_constraints.attr_y).equal?(SWT::DEFAULT))
          height = Math.min(size_constraints.attr_y, height)
        end
      end
      # Ensure minimal size
      width = Math.max(MIN_WIDTH, min_width)
      height = Math.max(MIN_HEIGHT, height)
      return Point.new(width, height)
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.IInformationControlExtension3#computeTrim()
    def compute_trim
      trim = super
      if (is_resizable)
        rtl = !((get_shell.get_style & SWT::RIGHT_TO_LEFT)).equal?(0)
        if (rtl)
          trim.attr_x -= self.attr_fg_scroll_bar_size.attr_x
        end
        trim.attr_width += self.attr_fg_scroll_bar_size.attr_x
        trim.attr_height += self.attr_fg_scroll_bar_size.attr_y
      end
      return trim
    end
    
    typesig { [LocationListener] }
    # Adds the listener to the collection of listeners who will be
    # notified when the current location has changed or is about to change.
    # 
    # @param listener the location listener
    # @since 3.4
    def add_location_listener(listener)
      @f_browser.add_location_listener(listener)
    end
    
    typesig { [Color] }
    # @see IInformationControl#setForegroundColor(Color)
    def set_foreground_color(foreground)
      super(foreground)
      @f_browser.set_foreground(foreground)
    end
    
    typesig { [Color] }
    # @see IInformationControl#setBackgroundColor(Color)
    def set_background_color(background)
      super(background)
      @f_browser.set_background(background)
    end
    
    typesig { [] }
    # @see IInformationControlExtension#hasContents()
    def has_contents
      return @f_browser_has_content
    end
    
    typesig { [IInputChangedListener] }
    # Adds a listener for input changes to this input change provider.
    # Has no effect if an identical listener is already registered.
    # 
    # @param inputChangeListener the listener to add
    # @since 3.4
    def add_input_change_listener(input_change_listener)
      Assert.is_not_null(input_change_listener)
      @f_input_change_listeners.add(input_change_listener)
    end
    
    typesig { [IInputChangedListener] }
    # Removes the given input change listener from this input change provider.
    # Has no effect if an identical listener is not registered.
    # 
    # @param inputChangeListener the listener to remove
    # @since 3.4
    def remove_input_change_listener(input_change_listener)
      @f_input_change_listeners.remove(input_change_listener)
    end
    
    typesig { [IInputChangedListener] }
    # @see org.eclipse.jface.text.IDelayedInputChangeProvider#setDelayedInputChangeListener(org.eclipse.jface.text.IInputChangedListener)
    # @since 3.4
    def set_delayed_input_change_listener(input_change_listener)
      @f_delayed_input_change_listener = input_change_listener
    end
    
    typesig { [] }
    # Tells whether a delayed input change listener is registered.
    # 
    # @return <code>true</code> iff a delayed input change
    # listener is currently registered
    # @since 3.4
    def has_delayed_input_change_listener
      return !(@f_delayed_input_change_listener).nil?
    end
    
    typesig { [Object] }
    # Notifies listeners of a delayed input change.
    # 
    # @param newInput the new input, or <code>null</code> to request cancellation
    # @since 3.4
    def notify_delayed_input_change(new_input)
      if (!(@f_delayed_input_change_listener).nil?)
        @f_delayed_input_change_listener.input_changed(new_input)
      end
    end
    
    typesig { [] }
    # @see java.lang.Object#toString()
    # @since 3.4
    def to_s
      style = ((get_shell.get_style & SWT::RESIZE)).equal?(0) ? "fixed" : "resizeable" # $NON-NLS-1$ //$NON-NLS-2$
      return RJava.cast_to_string(super) + " -  style: " + style # $NON-NLS-1$
    end
    
    typesig { [] }
    # @return the current browser input or <code>null</code>
    def get_input
      return @f_input
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # @see org.eclipse.jface.text.IInformationControlExtension5#computeSizeConstraints(int, int)
    def compute_size_constraints(width_in_chars, height_in_chars)
      if ((@f_symbolic_font_name).nil?)
        return nil
      end
      gc = SwtGC.new(@f_browser)
      font = (@f_symbolic_font_name).nil? ? JFaceResources.get_dialog_font : JFaceResources.get_font(@f_symbolic_font_name)
      gc.set_font(font)
      width = gc.get_font_metrics.get_average_char_width
      height = gc.get_font_metrics.get_height
      gc.dispose
      return Point.new(width_in_chars * width, height_in_chars * height)
    end
    
    private
    alias_method :initialize__browser_information_control, :initialize
  end
  
end
