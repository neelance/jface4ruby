require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
# Roman Dawydkin - bug 55116
module Org::Eclipse::Jface::Window
  module ApplicationWindowImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Window
      include_const ::Java::Lang::Reflect, :InvocationTargetException
      include_const ::Org::Eclipse::Core::Runtime, :NullProgressMonitor
      include_const ::Org::Eclipse::Jface::Action, :CoolBarManager
      include_const ::Org::Eclipse::Jface::Action, :ICoolBarManager
      include_const ::Org::Eclipse::Jface::Action, :IToolBarManager
      include_const ::Org::Eclipse::Jface::Action, :MenuManager
      include_const ::Org::Eclipse::Jface::Action, :StatusLineManager
      include_const ::Org::Eclipse::Jface::Action, :ToolBarManager
      include_const ::Org::Eclipse::Jface::Internal::Provisional::Action, :ICoolBarManager2
      include_const ::Org::Eclipse::Jface::Internal::Provisional::Action, :IToolBarManager2
      include_const ::Org::Eclipse::Jface::Operation, :IRunnableContext
      include_const ::Org::Eclipse::Jface::Operation, :IRunnableWithProgress
      include_const ::Org::Eclipse::Jface::Operation, :ModalContext
      include_const ::Org::Eclipse::Jface::Resource, :JFaceResources
      include_const ::Org::Eclipse::Jface::Util, :Util
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Custom, :BusyIndicator
      include_const ::Org::Eclipse::Swt::Graphics, :Font
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Graphics, :Rectangle
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :CoolBar
      include_const ::Org::Eclipse::Swt::Widgets, :Decorations
      include_const ::Org::Eclipse::Swt::Widgets, :Display
      include_const ::Org::Eclipse::Swt::Widgets, :Label
      include_const ::Org::Eclipse::Swt::Widgets, :Layout
      include_const ::Org::Eclipse::Swt::Widgets, :Menu
      include_const ::Org::Eclipse::Swt::Widgets, :Shell
      include_const ::Org::Eclipse::Swt::Widgets, :ToolBar
    }
  end
  
  # An application window is a high-level "main window", with built-in
  # support for an optional menu bar with standard menus, an optional toolbar,
  # and an optional status line.
  # <p>
  # Creating an application window involves the following steps:
  # <ul>
  # <li>creating an instance of <code>ApplicationWindow</code>
  # </li>
  # <li>assigning the window to a window manager (optional)
  # </li>
  # <li>opening the window by calling <code>open</code>
  # </li>
  # </ul>
  # Only on the last step, when the window is told to open, are
  # the window's shell and widget tree created. When the window is
  # closed, the shell and widget tree are disposed of and are no longer
  # referenced, and the window is automatically removed from its window
  # manager. Like all windows, an application window may be reopened.
  # </p>
  # <p>
  # An application window is also a suitable context in which to perform
  # long-running operations (that is, it implements <code>IRunnableContext</code>).
  # </p>
  class ApplicationWindow < ApplicationWindowImports.const_get :Window
    include_class_members ApplicationWindowImports
    overload_protected {
      include IRunnableContext
    }
    
    # Menu bar manager, or <code>null</code> if none (default).
    # 
    # @see #addMenuBar
    attr_accessor :menu_bar_manager
    alias_method :attr_menu_bar_manager, :menu_bar_manager
    undef_method :menu_bar_manager
    alias_method :attr_menu_bar_manager=, :menu_bar_manager=
    undef_method :menu_bar_manager=
    
    # Tool bar manager, or <code>null</code> if none (default).
    # 
    # @see #addToolBar
    attr_accessor :tool_bar_manager
    alias_method :attr_tool_bar_manager, :tool_bar_manager
    undef_method :tool_bar_manager
    alias_method :attr_tool_bar_manager=, :tool_bar_manager=
    undef_method :tool_bar_manager=
    
    # Status line manager, or <code>null</code> if none (default).
    # 
    # @see #addStatusLine
    attr_accessor :status_line_manager
    alias_method :attr_status_line_manager, :status_line_manager
    undef_method :status_line_manager
    alias_method :attr_status_line_manager=, :status_line_manager=
    undef_method :status_line_manager=
    
    # Cool bar manager, or <code>null</code> if none (default).
    # 
    # @see #addCoolBar
    # @since 3.0
    attr_accessor :cool_bar_manager
    alias_method :attr_cool_bar_manager, :cool_bar_manager
    undef_method :cool_bar_manager
    alias_method :attr_cool_bar_manager=, :cool_bar_manager=
    undef_method :cool_bar_manager=
    
    # The seperator between the menu bar and the rest of the window.
    attr_accessor :seperator1
    alias_method :attr_seperator1, :seperator1
    undef_method :seperator1
    alias_method :attr_seperator1=, :seperator1=
    undef_method :seperator1=
    
    # A flag indicating that an operation is running.
    attr_accessor :operation_in_progress
    alias_method :attr_operation_in_progress, :operation_in_progress
    undef_method :operation_in_progress
    alias_method :attr_operation_in_progress=, :operation_in_progress=
    undef_method :operation_in_progress=
    
    class_module.module_eval {
      # Internal application window layout class.
      # This vertical layout supports a tool bar area (fixed size),
      # a separator line, the content area (variable size), and a
      # status line (fixed size).
      # 
      # package
      const_set_lazy(:ApplicationWindowLayout) { Class.new(Layout) do
        extend LocalClass
        include_class_members ApplicationWindow
        
        class_module.module_eval {
          const_set_lazy(:VGAP) { 2 }
          const_attr_reader  :VGAP
          
          const_set_lazy(:BAR_SIZE) { 23 }
          const_attr_reader  :BAR_SIZE
        }
        
        typesig { [class_self::Composite, ::Java::Int, ::Java::Int, ::Java::Boolean] }
        def compute_size(composite, w_hint, h_hint, flush_cache)
          if (!(w_hint).equal?(SWT::DEFAULT) && !(h_hint).equal?(SWT::DEFAULT))
            return self.class::Point.new(w_hint, h_hint)
          end
          result = self.class::Point.new(0, 0)
          ws = composite.get_children
          i = 0
          while i < ws.attr_length
            w = ws[i]
            hide = false
            if ((get_tool_bar_control).equal?(w))
              if (!tool_bar_children_exist)
                hide = true
                result.attr_y += self.class::BAR_SIZE # REVISIT
              end
            else
              if ((get_cool_bar_control).equal?(w))
                if (!cool_bar_children_exist)
                  hide = true
                  result.attr_y += self.class::BAR_SIZE
                end
              else
                if (!(self.attr_status_line_manager).nil? && (self.attr_status_line_manager.get_control).equal?(w))
                else
                  if (i > 0)
                    # we assume this window is contents
                    hide = false
                  end
                end
              end
            end
            if (!hide)
              e = w.compute_size(w_hint, h_hint, flush_cache)
              result.attr_x = Math.max(result.attr_x, e.attr_x)
              result.attr_y += e.attr_y + self.class::VGAP
            end
            i += 1
          end
          if (!(w_hint).equal?(SWT::DEFAULT))
            result.attr_x = w_hint
          end
          if (!(h_hint).equal?(SWT::DEFAULT))
            result.attr_y = h_hint
          end
          return result
        end
        
        typesig { [class_self::Composite, ::Java::Boolean] }
        def layout(composite, flush_cache)
          client_area = composite.get_client_area
          ws = composite.get_children
          # Lay out the separator, the tool bar control, the cool bar control, the status line, and the page composite.
          # The following code assumes that the page composite is the last child, and that there are no unexpected other controls.
          i = 0
          while i < ws.attr_length
            w = ws[i]
            if ((w).equal?(self.attr_seperator1))
              # Separator
              e = w.compute_size(SWT::DEFAULT, SWT::DEFAULT, flush_cache)
              w.set_bounds(client_area.attr_x, client_area.attr_y, client_area.attr_width, e.attr_y)
              client_area.attr_y += e.attr_y
              client_area.attr_height -= e.attr_y
            else
              if ((get_tool_bar_control).equal?(w))
                if (tool_bar_children_exist)
                  e = w.compute_size(SWT::DEFAULT, SWT::DEFAULT, flush_cache)
                  w.set_bounds(client_area.attr_x, client_area.attr_y, client_area.attr_width, e.attr_y)
                  client_area.attr_y += e.attr_y + self.class::VGAP
                  client_area.attr_height -= e.attr_y + self.class::VGAP
                end
              else
                if ((get_cool_bar_control).equal?(w))
                  if (cool_bar_children_exist)
                    e = w.compute_size(client_area.attr_width, SWT::DEFAULT, flush_cache)
                    w.set_bounds(client_area.attr_x, client_area.attr_y, client_area.attr_width, e.attr_y)
                    client_area.attr_y += e.attr_y + self.class::VGAP
                    client_area.attr_height -= e.attr_y + self.class::VGAP
                  end
                else
                  if (!(self.attr_status_line_manager).nil? && (self.attr_status_line_manager.get_control).equal?(w))
                    e = w.compute_size(SWT::DEFAULT, SWT::DEFAULT, flush_cache)
                    w.set_bounds(client_area.attr_x, client_area.attr_y + client_area.attr_height - e.attr_y, client_area.attr_width, e.attr_y)
                    client_area.attr_height -= e.attr_y + self.class::VGAP
                  else
                    w.set_bounds(client_area.attr_x, client_area.attr_y + self.class::VGAP, client_area.attr_width, client_area.attr_height - self.class::VGAP)
                  end
                end
              end
            end
            i += 1
          end
        end
        
        typesig { [] }
        def initialize
          super()
        end
        
        private
        alias_method :initialize__application_window_layout, :initialize
      end }
    }
    
    typesig { [] }
    # Return the top seperator.
    # @return Label
    def get_seperator1
      return @seperator1
    end
    
    typesig { [Shell] }
    # Create an application window instance, whose shell will be created under the
    # given parent shell.
    # Note that the window will have no visual representation (no widgets)
    # until it is told to open. By default, <code>open</code> does not block.
    # 
    # @param parentShell the parent shell, or <code>null</code> to create a top-level shell
    def initialize(parent_shell)
      @menu_bar_manager = nil
      @tool_bar_manager = nil
      @status_line_manager = nil
      @cool_bar_manager = nil
      @seperator1 = nil
      @operation_in_progress = false
      super(parent_shell)
      @menu_bar_manager = nil
      @tool_bar_manager = nil
      @status_line_manager = nil
      @cool_bar_manager = nil
      @operation_in_progress = false
    end
    
    typesig { [] }
    # Configures this window to have a menu bar.
    # Does nothing if it already has one.
    # This method must be called before this window's shell is created.
    def add_menu_bar
      if (((get_shell).nil?) && ((@menu_bar_manager).nil?))
        @menu_bar_manager = create_menu_manager
      end
    end
    
    typesig { [] }
    # Configures this window to have a status line.
    # Does nothing if it already has one.
    # This method must be called before this window's shell is created.
    def add_status_line
      if (((get_shell).nil?) && ((@status_line_manager).nil?))
        @status_line_manager = create_status_line_manager
      end
    end
    
    typesig { [::Java::Int] }
    # Configures this window to have a tool bar.
    # Does nothing if it already has one.
    # This method must be called before this window's shell is created.
    # @param style swt style bits used to create the Toolbar
    # @see ToolBarManager#ToolBarManager(int)
    # @see ToolBar for style bits
    def add_tool_bar(style)
      if (((get_shell).nil?) && ((@tool_bar_manager).nil?) && ((@cool_bar_manager).nil?))
        @tool_bar_manager = create_tool_bar_manager2(style)
      end
    end
    
    typesig { [::Java::Int] }
    # Configures this window to have a cool bar.
    # Does nothing if it already has one.
    # This method must be called before this window's shell is created.
    # 
    # @param style the cool bar style
    # @since 3.0
    def add_cool_bar(style)
      if (((get_shell).nil?) && ((@tool_bar_manager).nil?) && ((@cool_bar_manager).nil?))
        @cool_bar_manager = create_cool_bar_manager2(style)
      end
    end
    
    typesig { [] }
    # (non-Javadoc)
    # Method declared on Window.
    def can_handle_shell_close_event
      return super && !@operation_in_progress
    end
    
    typesig { [] }
    # (non-Javadoc)
    # Method declared on Window.
    def close
      if (@operation_in_progress)
        return false
      end
      if (super)
        if (!(@menu_bar_manager).nil?)
          @menu_bar_manager.dispose
          @menu_bar_manager = nil
        end
        if (!(@tool_bar_manager).nil?)
          if (@tool_bar_manager.is_a?(IToolBarManager2))
            (@tool_bar_manager).dispose
          else
            if (@tool_bar_manager.is_a?(ToolBarManager))
              (@tool_bar_manager).dispose
            end
          end
          @tool_bar_manager = nil
        end
        if (!(@status_line_manager).nil?)
          @status_line_manager.dispose
          @status_line_manager = nil
        end
        if (!(@cool_bar_manager).nil?)
          if (@cool_bar_manager.is_a?(ICoolBarManager2))
            (@cool_bar_manager).dispose
          else
            if (@cool_bar_manager.is_a?(CoolBarManager))
              (@cool_bar_manager).dispose
            end
          end
          @cool_bar_manager = nil
        end
        return true
      end
      return false
    end
    
    typesig { [Shell] }
    # Extends the super implementation by creating the trim widgets using <code>createTrimWidgets</code>.
    def configure_shell(shell)
      super(shell)
      create_trim_widgets(shell)
    end
    
    typesig { [Shell] }
    # Creates the trim widgets around the content area.
    # 
    # @param shell the shell
    # @since 3.0
    def create_trim_widgets(shell)
      if (!(@menu_bar_manager).nil?)
        shell.set_menu_bar(@menu_bar_manager.create_menu_bar(shell))
        @menu_bar_manager.update_all(true)
      end
      if (show_top_seperator)
        @seperator1 = Label.new(shell, SWT::SEPARATOR | SWT::HORIZONTAL)
      end
      # will create either a cool bar or a tool bar
      create_tool_bar_control(shell)
      create_cool_bar_control(shell)
      create_status_line(shell)
    end
    
    typesig { [] }
    # (non-Javadoc)
    # @see org.eclipse.jface.window.Window#getLayout()
    def get_layout
      return ApplicationWindowLayout.new_local(self)
    end
    
    typesig { [] }
    # Returns whether to show a top separator line between the menu bar
    # and the rest of the window contents.  On some platforms such as the Mac,
    # the menu is separated from the main window already, so a separator line
    # is not desired.
    # 
    # @return <code>true</code> to show the top separator, <code>false</code>
    # to not show it
    # @since 3.0
    def show_top_seperator
      return !Util.is_mac
    end
    
    typesig { [Shell] }
    # Create the status line if required.
    # @param shell
    def create_status_line(shell)
      if (!(@status_line_manager).nil?)
        @status_line_manager.create_control(shell, SWT::NONE)
      end
    end
    
    typesig { [] }
    # Returns a new menu manager for the window.
    # <p>
    # Subclasses may override this method to customize the menu manager.
    # </p>
    # @return a menu manager
    def create_menu_manager
      return MenuManager.new
    end
    
    typesig { [] }
    # Returns a new status line manager for the window.
    # <p>
    # Subclasses may override this method to customize the status line manager.
    # </p>
    # @return a status line manager
    def create_status_line_manager
      return StatusLineManager.new
    end
    
    typesig { [::Java::Int] }
    # Returns a new tool bar manager for the window.
    # <p>
    # Subclasses may override this method to customize the tool bar manager.
    # </p>
    # @param style swt style bits used to create the Toolbar
    # 
    # @return a tool bar manager
    # @see ToolBarManager#ToolBarManager(int)
    # @see ToolBar for style bits
    def create_tool_bar_manager(style)
      return ToolBarManager.new(style)
    end
    
    typesig { [::Java::Int] }
    # Returns a new tool bar manager for the window.
    # <p>
    # By default this method calls <code>createToolBarManager</code>.  Subclasses
    # may override this method to provide an alternative implementation for the
    # tool bar manager.
    # </p>
    # 
    # @param style swt style bits used to create the Toolbar
    # 
    # @return a tool bar manager
    # @since 3.2
    # @see #createToolBarManager(int)
    def create_tool_bar_manager2(style)
      return create_tool_bar_manager(style)
    end
    
    typesig { [::Java::Int] }
    # Returns a new cool bar manager for the window.
    # <p>
    # Subclasses may override this method to customize the cool bar manager.
    # </p>
    # 
    # @param style swt style bits used to create the Coolbar
    # 
    # @return a cool bar manager
    # @since 3.0
    # @see CoolBarManager#CoolBarManager(int)
    # @see CoolBar for style bits
    def create_cool_bar_manager(style)
      return CoolBarManager.new(style)
    end
    
    typesig { [::Java::Int] }
    # Returns a new cool bar manager for the window.
    # <p>
    # By default this method calls <code>createCoolBarManager</code>.  Subclasses
    # may override this method to provide an alternative implementation for the
    # cool bar manager.
    # </p>
    # 
    # @param style swt style bits used to create the Coolbar
    # 
    # @return a cool bar manager
    # @since 3.2
    # @see #createCoolBarManager(int)
    def create_cool_bar_manager2(style)
      return create_cool_bar_manager(style)
    end
    
    typesig { [Composite] }
    # Creates the control for the tool bar manager.
    # <p>
    # Subclasses may override this method to customize the tool bar manager.
    # </p>
    # @param parent the parent used for the control
    # @return a Control
    def create_tool_bar_control(parent)
      if (!(@tool_bar_manager).nil?)
        if (@tool_bar_manager.is_a?(IToolBarManager2))
          return (@tool_bar_manager).create_control2(parent)
        end
        if (@tool_bar_manager.is_a?(ToolBarManager))
          return (@tool_bar_manager).create_control(parent)
        end
      end
      return nil
    end
    
    typesig { [Composite] }
    # Creates the control for the cool bar manager.
    # <p>
    # Subclasses may override this method to customize the cool bar manager.
    # </p>
    # @param composite the parent used for the control
    # 
    # @return an instance of <code>CoolBar</code>
    # @since 3.0
    def create_cool_bar_control(composite)
      if (!(@cool_bar_manager).nil?)
        if (@cool_bar_manager.is_a?(ICoolBarManager2))
          return (@cool_bar_manager).create_control2(composite)
        end
        if (@cool_bar_manager.is_a?(CoolBarManager))
          return (@cool_bar_manager).create_control(composite)
        end
      end
      return nil
    end
    
    typesig { [] }
    # Returns the default font used for this window.
    # <p>
    # The default implementation of this framework method
    # obtains the symbolic name of the font from the
    # <code>getSymbolicFontName</code> framework method
    # and retrieves this font from JFace's font
    # registry using <code>JFaceResources.getFont</code>.
    # Subclasses may override to use a different registry,
    # etc.
    # </p>
    # 
    # @return the default font, or <code>null</code> if none
    def get_font
      return JFaceResources.get_font(get_symbolic_font_name)
    end
    
    typesig { [] }
    # Returns the menu bar manager for this window (if it has one).
    # 
    # @return the menu bar manager, or <code>null</code> if
    # this window does not have a menu bar
    # @see #addMenuBar()
    def get_menu_bar_manager
      return @menu_bar_manager
    end
    
    typesig { [] }
    # Returns the status line manager for this window (if it has one).
    # 
    # @return the status line manager, or <code>null</code> if
    # this window does not have a status line
    # @see #addStatusLine
    def get_status_line_manager
      return @status_line_manager
    end
    
    typesig { [] }
    # Returns the symbolic font name of the font to be
    # used to display text in this window.
    # This is not recommended and is included for backwards
    # compatability.
    # It is recommended to use the default font provided by
    # SWT (that is, do not set the font).
    # 
    # @return the symbolic font name
    def get_symbolic_font_name
      return JFaceResources::TEXT_FONT
    end
    
    typesig { [] }
    # Returns the tool bar manager for this window (if it has one).
    # 
    # @return the tool bar manager, or <code>null</code> if
    # this window does not have a tool bar
    # @see #addToolBar(int)
    def get_tool_bar_manager
      if (@tool_bar_manager.is_a?(ToolBarManager))
        return @tool_bar_manager
      end
      return nil
    end
    
    typesig { [] }
    # Returns the tool bar manager for this window (if it has one).
    # 
    # @return the tool bar manager, or <code>null</code> if
    # this window does not have a tool bar
    # @see #addToolBar(int)
    # @since 3.2
    def get_tool_bar_manager2
      return @tool_bar_manager
    end
    
    typesig { [] }
    # Returns the cool bar manager for this window.
    # 
    # @return the cool bar manager, or <code>null</code> if
    # this window does not have a cool bar
    # @see #addCoolBar(int)
    # @since 3.0
    def get_cool_bar_manager
      if (@cool_bar_manager.is_a?(CoolBarManager))
        return @cool_bar_manager
      end
      return nil
    end
    
    typesig { [] }
    # Returns the cool bar manager for this window.
    # 
    # @return the cool bar manager, or <code>null</code> if
    # this window does not have a cool bar
    # @see #addCoolBar(int)
    # @since 3.2
    def get_cool_bar_manager2
      return @cool_bar_manager
    end
    
    typesig { [] }
    # Returns the control for the window's toolbar.
    # <p>
    # Subclasses may override this method to customize the tool bar manager.
    # </p>
    # @return a Control
    def get_tool_bar_control
      if (!(@tool_bar_manager).nil?)
        if (@tool_bar_manager.is_a?(IToolBarManager2))
          return (@tool_bar_manager).get_control2
        end
        if (@tool_bar_manager.is_a?(ToolBarManager))
          return (@tool_bar_manager).get_control
        end
      end
      return nil
    end
    
    typesig { [] }
    # Returns the control for the window's cool bar.
    # <p>
    # Subclasses may override this method to customize the cool bar manager.
    # </p>
    # 
    # @return an instance of <code>CoolBar</code>
    # @since 3.0
    def get_cool_bar_control
      if (!(@cool_bar_manager).nil?)
        if (@cool_bar_manager.is_a?(ICoolBarManager2))
          return (@cool_bar_manager).get_control2
        end
        if (@cool_bar_manager.is_a?(CoolBarManager))
          return (@cool_bar_manager).get_control
        end
      end
      return nil
    end
    
    typesig { [::Java::Boolean, ::Java::Boolean, IRunnableWithProgress] }
    # This implementation of IRunnableContext#run(boolean, boolean,
    # IRunnableWithProgress) blocks until the runnable has been run,
    # regardless of the value of <code>fork</code>.
    # It is recommended that <code>fork</code> is set to
    # true in most cases. If <code>fork</code> is set to <code>false</code>,
    # the runnable will run in the UI thread and it is the runnable's
    # responsibility to call <code>Display.readAndDispatch()</code>
    # to ensure UI responsiveness.
    def run(fork, cancelable, runnable)
      begin
        @operation_in_progress = true
        mgr = get_status_line_manager
        if ((mgr).nil?)
          runnable.run(NullProgressMonitor.new)
          return
        end
        cancel_was_enabled = mgr.is_cancel_enabled
        contents = get_contents
        display = contents.get_display
        shell = get_shell
        contents_was_enabled = contents.get_enabled
        manager = get_menu_bar_manager
        menu_bar = nil
        if (!(manager).nil?)
          menu_bar = manager.get_menu
          manager = nil
        end
        menu_bar_was_enabled = false
        if (!(menu_bar).nil?)
          menu_bar_was_enabled = menu_bar.get_enabled
        end
        toolbar_control = get_tool_bar_control
        toolbar_was_enabled = false
        if (!(toolbar_control).nil?)
          toolbar_was_enabled = toolbar_control.get_enabled
        end
        coolbar_control = get_cool_bar_control
        coolbar_was_enabled = false
        if (!(coolbar_control).nil?)
          coolbar_was_enabled = coolbar_control.get_enabled
        end
        # Disable the rest of the shells on the current display
        shells = display.get_shells
        enabled = Array.typed(::Java::Boolean).new(shells.attr_length) { false }
        i = 0
        while i < shells.attr_length
          current = shells[i]
          if ((current).equal?(shell))
            i += 1
            next
          end
          if (!(current).nil? && !current.is_disposed)
            enabled[i] = current.get_enabled
            current.set_enabled(false)
          end
          i += 1
        end
        current_focus = display.get_focus_control
        begin
          contents.set_enabled(false)
          if (!(menu_bar).nil?)
            menu_bar.set_enabled(false)
          end
          if (!(toolbar_control).nil?)
            toolbar_control.set_enabled(false)
          end
          if (!(coolbar_control).nil?)
            coolbar_control.set_enabled(false)
          end
          mgr.set_cancel_enabled(cancelable)
          holder = Array.typed(JavaException).new(1) { nil }
          BusyIndicator.show_while(display, Class.new(Runnable.class == Class ? Runnable : Object) do
            extend LocalClass
            include_class_members ApplicationWindow
            include Runnable if Runnable.class == Module
            
            typesig { [] }
            define_method :run do
              begin
                ModalContext.run(runnable, fork, mgr.get_progress_monitor, display)
              rescue self.class::InvocationTargetException => ite
                holder[0] = ite
              rescue self.class::InterruptedException => ie
                holder[0] = ie
              end
            end
            
            typesig { [] }
            define_method :initialize do
              super()
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
          if (!(holder[0]).nil?)
            if (holder[0].is_a?(InvocationTargetException))
              raise holder[0]
            else
              if (holder[0].is_a?(InterruptedException))
                raise holder[0]
              end
            end
          end
        ensure
          @operation_in_progress = false
          # Enable the rest of the shells on the current display
          i_ = 0
          while i_ < shells.attr_length
            current = shells[i_]
            if ((current).equal?(shell))
              i_ += 1
              next
            end
            if (!(current).nil? && !current.is_disposed)
              current.set_enabled(enabled[i_])
            end
            i_ += 1
          end
          if (!contents.is_disposed)
            contents.set_enabled(contents_was_enabled)
          end
          if (!(menu_bar).nil? && !menu_bar.is_disposed)
            menu_bar.set_enabled(menu_bar_was_enabled)
          end
          if (!(toolbar_control).nil? && !toolbar_control.is_disposed)
            toolbar_control.set_enabled(toolbar_was_enabled)
          end
          if (!(coolbar_control).nil? && !coolbar_control.is_disposed)
            coolbar_control.set_enabled(coolbar_was_enabled)
          end
          mgr.set_cancel_enabled(cancel_was_enabled)
          if (!(current_focus).nil? && !current_focus.is_disposed)
            # It's necessary to restore focus after reenabling the controls
            # because disabling them causes focus to jump elsewhere.
            # Use forceFocus rather than setFocus to avoid SWT's
            # search for children which can take focus, so focus
            # ends up back on the actual control that previously had it.
            current_focus.force_focus
          end
        end
      ensure
        @operation_in_progress = false
      end
    end
    
    typesig { [String] }
    # Sets or clears the message displayed in this window's status
    # line (if it has one). This method has no effect if the
    # window does not have a status line.
    # 
    # @param message the status message, or <code>null</code> to clear it
    def set_status(message)
      if (!(@status_line_manager).nil?)
        @status_line_manager.set_message(message)
      end
    end
    
    typesig { [] }
    # Returns whether or not children exist for the Application Window's
    # toolbar control.
    # <p>
    # @return boolean true if children exist, false otherwise
    def tool_bar_children_exist
      tool_control = get_tool_bar_control
      if (tool_control.is_a?(ToolBar))
        return (tool_control).get_item_count > 0
      end
      return false
    end
    
    typesig { [] }
    # Returns whether or not children exist for this application window's
    # cool bar control.
    # 
    # @return boolean true if children exist, false otherwise
    # @since 3.0
    def cool_bar_children_exist
      cool_control = get_cool_bar_control
      if (cool_control.is_a?(CoolBar))
        return (cool_control).get_item_count > 0
      end
      return false
    end
    
    private
    alias_method :initialize__application_window, :initialize
  end
  
end
