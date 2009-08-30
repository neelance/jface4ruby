require "rjava"

# Copyright (c) 2005, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Dialogs
  module TrayDialogImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Dialogs
      include_const ::Org::Eclipse::Jface::Resource, :JFaceResources
      include_const ::Org::Eclipse::Jface::Window, :IShellProvider
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Events, :ControlAdapter
      include_const ::Org::Eclipse::Swt::Events, :ControlEvent
      include_const ::Org::Eclipse::Swt::Events, :DisposeEvent
      include_const ::Org::Eclipse::Swt::Events, :DisposeListener
      include_const ::Org::Eclipse::Swt::Events, :SelectionAdapter
      include_const ::Org::Eclipse::Swt::Events, :SelectionEvent
      include_const ::Org::Eclipse::Swt::Graphics, :Cursor
      include_const ::Org::Eclipse::Swt::Graphics, :Image
      include_const ::Org::Eclipse::Swt::Graphics, :Rectangle
      include_const ::Org::Eclipse::Swt::Layout, :GridData
      include_const ::Org::Eclipse::Swt::Layout, :GridLayout
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Event
      include_const ::Org::Eclipse::Swt::Widgets, :Label
      include_const ::Org::Eclipse::Swt::Widgets, :Layout
      include_const ::Org::Eclipse::Swt::Widgets, :Link
      include_const ::Org::Eclipse::Swt::Widgets, :Listener
      include_const ::Org::Eclipse::Swt::Widgets, :Sash
      include_const ::Org::Eclipse::Swt::Widgets, :Shell
      include_const ::Org::Eclipse::Swt::Widgets, :ToolBar
      include_const ::Org::Eclipse::Swt::Widgets, :ToolItem
    }
  end
  
  # A <code>TrayDialog</code> is a specialized <code>Dialog</code> that can contain
  # a tray on its side. The tray's content is provided as a <code>DialogTray</code>.
  # <p>
  # It is recommended to subclass this class instead of <code>Dialog</code> in all
  # cases except where the dialog should never show a tray. For example, dialogs
  # which are very short, simple, and quick to dismiss (e.g. a message dialog with
  # an OK button) should subclass <code>Dialog</code>.
  # </p>
  # <p>
  # Note: Trays are not supported on dialogs that use a custom layout on the <code>
  # Shell</code> by overriding <code>Window#getLayout()</code>.
  # </p>
  # 
  # @see org.eclipse.jface.dialogs.DialogTray
  # @see org.eclipse.jface.window.Window#getLayout()
  # @since 3.2
  class TrayDialog < TrayDialogImports.const_get :Dialog
    include_class_members TrayDialogImports
    
    class_module.module_eval {
      const_set_lazy(:ResizeListener) { Class.new(ControlAdapter) do
        extend LocalClass
        include_class_members TrayDialog
        
        attr_accessor :data
        alias_method :attr_data, :data
        undef_method :data
        alias_method :attr_data=, :data=
        undef_method :data=
        
        attr_accessor :shell
        alias_method :attr_shell, :shell
        undef_method :shell
        alias_method :attr_shell=, :shell=
        undef_method :shell=
        
        attr_accessor :tray_ratio
        alias_method :attr_tray_ratio, :tray_ratio
        undef_method :tray_ratio
        alias_method :attr_tray_ratio=, :tray_ratio=
        undef_method :tray_ratio=
        
        # Percentage of extra width devoted to tray when resizing
        attr_accessor :remainder
        alias_method :attr_remainder, :remainder
        undef_method :remainder
        alias_method :attr_remainder=, :remainder=
        undef_method :remainder=
        
        typesig { [class_self::GridData, class_self::Shell] }
        # Used to prevent rounding errors from accumulating
        def initialize(data, shell)
          @data = nil
          @shell = nil
          @tray_ratio = 0
          @remainder = 0
          super()
          @tray_ratio = 100
          @remainder = 0
          @data = data
          @shell = shell
        end
        
        typesig { [class_self::ControlEvent] }
        def control_resized(event)
          new_width = @shell.get_size.attr_x
          if (!(new_width).equal?(self.attr_shell_width))
            shell_width_increase = new_width - self.attr_shell_width
            tray_width_increase_times100 = (shell_width_increase * @tray_ratio) + @remainder
            tray_width_increase = tray_width_increase_times100 / 100
            @remainder = tray_width_increase_times100 - (100 * tray_width_increase)
            @data.attr_width_hint = @data.attr_width_hint + tray_width_increase
            self.attr_shell_width = new_width
            if (!@shell.is_disposed)
              @shell.layout
            end
          end
        end
        
        private
        alias_method :initialize__resize_listener, :initialize
      end }
      
      
      def dialog_help_available
        defined?(@@dialog_help_available) ? @@dialog_help_available : @@dialog_help_available= false
      end
      alias_method :attr_dialog_help_available, :dialog_help_available
      
      def dialog_help_available=(value)
        @@dialog_help_available = value
      end
      alias_method :attr_dialog_help_available=, :dialog_help_available=
    }
    
    # The dialog's tray (null if none).
    attr_accessor :tray
    alias_method :attr_tray, :tray
    undef_method :tray
    alias_method :attr_tray=, :tray=
    undef_method :tray=
    
    # The tray's control.
    attr_accessor :tray_control
    alias_method :attr_tray_control, :tray_control
    undef_method :tray_control
    alias_method :attr_tray_control=, :tray_control=
    undef_method :tray_control=
    
    # The separator to the left of the sash.
    attr_accessor :left_separator
    alias_method :attr_left_separator, :left_separator
    undef_method :left_separator
    alias_method :attr_left_separator=, :left_separator=
    undef_method :left_separator=
    
    # The separator to the right of the sash.
    attr_accessor :right_separator
    alias_method :attr_right_separator, :right_separator
    undef_method :right_separator
    alias_method :attr_right_separator=, :right_separator=
    undef_method :right_separator=
    
    # The sash that allows the user to resize the tray.
    attr_accessor :sash
    alias_method :attr_sash, :sash
    undef_method :sash
    alias_method :attr_sash=, :sash=
    undef_method :sash=
    
    # Whether or not help is available for this dialog.
    attr_accessor :help_available
    alias_method :attr_help_available, :help_available
    undef_method :help_available
    alias_method :attr_help_available=, :help_available=
    undef_method :help_available=
    
    attr_accessor :shell_width
    alias_method :attr_shell_width, :shell_width
    undef_method :shell_width
    alias_method :attr_shell_width=, :shell_width=
    undef_method :shell_width=
    
    attr_accessor :resize_listener
    alias_method :attr_resize_listener, :resize_listener
    undef_method :resize_listener
    alias_method :attr_resize_listener=, :resize_listener=
    undef_method :resize_listener=
    
    typesig { [Shell] }
    # Creates a tray dialog instance. Note that the window will have no visual
    # representation (no widgets) until it is told to open.
    # 
    # @param shell the parent shell, or <code>null</code> to create a top-level shell
    def initialize(shell)
      @tray = nil
      @tray_control = nil
      @left_separator = nil
      @right_separator = nil
      @sash = nil
      @help_available = false
      @shell_width = 0
      @resize_listener = nil
      super(shell)
      @help_available = is_dialog_help_available
    end
    
    typesig { [IShellProvider] }
    # Creates a tray dialog with the given parent.
    # 
    # @param parentShell the object that returns the current parent shell
    def initialize(parent_shell)
      @tray = nil
      @tray_control = nil
      @left_separator = nil
      @right_separator = nil
      @sash = nil
      @help_available = false
      @shell_width = 0
      @resize_listener = nil
      super(parent_shell)
      @help_available = is_dialog_help_available
    end
    
    typesig { [] }
    # Closes this dialog's tray, disposing its widgets.
    # 
    # @throws IllegalStateException if the tray was not open
    def close_tray
      if ((get_tray).nil?)
        raise IllegalStateException.new("Tray was not open") # $NON-NLS-1$
      end
      shell = get_shell
      shell.remove_control_listener(@resize_listener)
      @resize_listener = nil
      tray_width = @tray_control.get_size.attr_x + @left_separator.get_size.attr_x + @sash.get_size.attr_x + @right_separator.get_size.attr_x
      @tray_control.dispose
      @tray_control = nil
      @tray = nil
      @left_separator.dispose
      @left_separator = nil
      @right_separator.dispose
      @right_separator = nil
      @sash.dispose
      @sash = nil
      bounds = shell.get_bounds
      shell.set_bounds(bounds.attr_x + (((get_default_orientation).equal?(SWT::RIGHT_TO_LEFT)) ? tray_width : 0), bounds.attr_y, bounds.attr_width - tray_width, bounds.attr_height)
    end
    
    typesig { [] }
    # (non-Javadoc)
    # @see org.eclipse.jface.dialogs.Dialog#close()
    def close
      # Close the tray to ensure that those dialogs that remember their
      # size do not store the tray size.
      if (!(get_tray).nil?)
        close_tray
      end
      return super
    end
    
    typesig { [Composite] }
    # (non-Javadoc)
    # @see org.eclipse.jface.dialogs.Dialog#createButtonBar(org.eclipse.swt.widgets.Composite)
    def create_button_bar(parent)
      composite = Composite.new(parent, SWT::NONE)
      layout = GridLayout.new
      layout.attr_margin_width = 0
      layout.attr_margin_height = 0
      layout.attr_horizontal_spacing = 0
      composite.set_layout(layout)
      composite.set_layout_data(GridData.new(SWT::FILL, SWT::CENTER, false, false))
      composite.set_font(parent.get_font)
      # create help control if needed
      if (is_help_available)
        help_control = create_help_control(composite)
        (help_control.get_layout_data).attr_horizontal_indent = convert_horizontal_dlus_to_pixels(IDialogConstants::HORIZONTAL_MARGIN)
      end
      button_section = super(composite)
      (button_section.get_layout_data).attr_grab_excess_horizontal_space = true
      return composite
    end
    
    typesig { [Composite] }
    # Creates a new help control that provides access to context help.
    # <p>
    # The <code>TrayDialog</code> implementation of this method creates
    # the control, registers it for selection events including selection,
    # Note that the parent's layout is assumed to be a <code>GridLayout</code>
    # and the number of columns in this layout is incremented. Subclasses may
    # override.
    # </p>
    # 
    # @param parent the parent composite
    # @return the help control
    def create_help_control(parent)
      help_image = JFaceResources.get_image(DLG_IMG_HELP)
      if (!(help_image).nil?)
        return create_help_image_button(parent, help_image)
      end
      return create_help_link(parent)
    end
    
    typesig { [Composite, Image] }
    # Creates a button with a help image. This is only used if there
    # is an image available.
    def create_help_image_button(parent, image)
      tool_bar = ToolBar.new(parent, SWT::FLAT | SWT::NO_FOCUS)
      (parent.get_layout).attr_num_columns += 1
      tool_bar.set_layout_data(GridData.new(GridData::HORIZONTAL_ALIGN_CENTER))
      cursor = Cursor.new(parent.get_display, SWT::CURSOR_HAND)
      tool_bar.set_cursor(cursor)
      tool_bar.add_dispose_listener(Class.new(DisposeListener.class == Class ? DisposeListener : Object) do
        extend LocalClass
        include_class_members TrayDialog
        include DisposeListener if DisposeListener.class == Module
        
        typesig { [DisposeEvent] }
        define_method :widget_disposed do |e|
          cursor.dispose
        end
        
        typesig { [Object] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      item = ToolItem.new(tool_bar, SWT::NONE)
      item.set_image(image)
      item.set_tool_tip_text(JFaceResources.get_string("helpToolTip")) # $NON-NLS-1$
      item.add_selection_listener(Class.new(SelectionAdapter.class == Class ? SelectionAdapter : Object) do
        extend LocalClass
        include_class_members TrayDialog
        include SelectionAdapter if SelectionAdapter.class == Module
        
        typesig { [SelectionEvent] }
        define_method :widget_selected do |e|
          help_pressed
        end
        
        typesig { [Object] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      return tool_bar
    end
    
    typesig { [Composite] }
    # Creates a help link. This is used when there is no help image
    # available.
    def create_help_link(parent)
      link = Link.new(parent, SWT::WRAP | SWT::NO_FOCUS)
      (parent.get_layout).attr_num_columns += 1
      link.set_layout_data(GridData.new(GridData::HORIZONTAL_ALIGN_CENTER))
      link.set_text("<a>" + RJava.cast_to_string(IDialogConstants::HELP_LABEL) + "</a>") # $NON-NLS-1$ //$NON-NLS-2$
      link.set_tool_tip_text(IDialogConstants::HELP_LABEL)
      link.add_selection_listener(Class.new(SelectionAdapter.class == Class ? SelectionAdapter : Object) do
        extend LocalClass
        include_class_members TrayDialog
        include SelectionAdapter if SelectionAdapter.class == Module
        
        typesig { [SelectionEvent] }
        define_method :widget_selected do |e|
          help_pressed
        end
        
        typesig { [Object] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      return link
    end
    
    typesig { [Layout] }
    # Returns whether or not the given layout can support the addition of a tray.
    def is_compatible_layout(layout)
      if (!(layout).nil? && layout.is_a?(GridLayout))
        grid = layout
        return !grid.attr_make_columns_equal_width && ((grid.attr_horizontal_spacing).equal?(0)) && ((grid.attr_margin_width).equal?(0)) && ((grid.attr_margin_height).equal?(0)) && ((grid.attr_num_columns).equal?(5))
      end
      return false
    end
    
    typesig { [] }
    # Returns whether or not context help is available for this dialog. This
    # can affect whether or not the dialog will display additional help
    # mechanisms such as a help control in the button bar.
    # 
    # @return whether or not context help is available for this dialog
    def is_help_available
      return @help_available
    end
    
    typesig { [] }
    # The tray dialog's default layout is a modified version of the default
    # <code>Window</code> layout that can accomodate a tray, however it still
    # conforms to the description of the <code>Window</code> default layout.
    # <p>
    # Note: Trays may not be supported with all custom layouts on the dialog's
    # Shell. To avoid problems, use a single outer <code>Composite</code> for
    # your dialog area, and set your custom layout on that <code>Composite</code>.
    # </p>
    # 
    # @see org.eclipse.jface.window.Window#getLayout()
    # @return a newly created layout or <code>null</code> for no layout
    def get_layout
      layout = super
      layout.attr_num_columns = 5
      layout.attr_horizontal_spacing = 0
      return layout
    end
    
    typesig { [] }
    # Returns the tray currently shown in the dialog, or <code>null</code>
    # if there is no tray.
    # 
    # @return the dialog's current tray, or <code>null</code> if there is none
    def get_tray
      return @tray
    end
    
    typesig { [] }
    # Called when the help control is invoked. This emulates the keyboard
    # context help behavior (e.g. F1 on Windows). It traverses the widget
    # tree upward until it finds a widget that has a help listener on it,
    # then invokes a help event on that widget.
    def help_pressed
      if (!(get_shell).nil?)
        c = get_shell.get_display.get_focus_control
        while (!(c).nil?)
          if (c.is_listening(SWT::Help))
            c.notify_listeners(SWT::Help, Event.new)
            break
          end
          c = c.get_parent
        end
      end
    end
    
    typesig { [DialogTray] }
    # Constructs the tray's widgets and displays the tray in this dialog. The
    # dialog's size will be adjusted to accomodate the tray.
    # 
    # @param tray the tray to show in this dialog
    # @throws IllegalStateException if the dialog already has a tray open
    # @throws UnsupportedOperationException if the dialog does not support trays,
    # for example if it uses a custom layout.
    def open_tray(tray)
      if ((tray).nil?)
        raise NullPointerException.new("Tray was null") # $NON-NLS-1$
      end
      if (!(get_tray).nil?)
        raise IllegalStateException.new("Tray was already open") # $NON-NLS-1$
      end
      if (!is_compatible_layout(get_shell.get_layout))
        raise UnsupportedOperationException.new("Trays not supported with custom layouts") # $NON-NLS-1$
      end
      shell = get_shell
      @left_separator = Label.new(shell, SWT::SEPARATOR | SWT::VERTICAL)
      @left_separator.set_layout_data(GridData.new(GridData::FILL_VERTICAL))
      @sash = Sash.new(shell, SWT::VERTICAL)
      @sash.set_layout_data(GridData.new(GridData::FILL_VERTICAL))
      @right_separator = Label.new(shell, SWT::SEPARATOR | SWT::VERTICAL)
      @right_separator.set_layout_data(GridData.new(GridData::FILL_VERTICAL))
      @tray_control = tray.create_contents(shell)
      client_area = shell.get_client_area
      data = GridData.new(GridData::FILL_VERTICAL)
      data.attr_width_hint = @tray_control.compute_size(SWT::DEFAULT, client_area.attr_height).attr_x
      @tray_control.set_layout_data(data)
      tray_width = @left_separator.compute_size(SWT::DEFAULT, client_area.attr_height).attr_x + @sash.compute_size(SWT::DEFAULT, client_area.attr_height).attr_x + @right_separator.compute_size(SWT::DEFAULT, client_area.attr_height).attr_x + data.attr_width_hint
      bounds = shell.get_bounds
      shell.set_bounds(bounds.attr_x - (((get_default_orientation).equal?(SWT::RIGHT_TO_LEFT)) ? tray_width : 0), bounds.attr_y, bounds.attr_width + tray_width, bounds.attr_height)
      @sash.add_listener(SWT::Selection, Class.new(Listener.class == Class ? Listener : Object) do
        extend LocalClass
        include_class_members TrayDialog
        include Listener if Listener.class == Module
        
        typesig { [Event] }
        define_method :handle_event do |event|
          if (!(event.attr_detail).equal?(SWT::DRAG))
            client_area_ = shell.get_client_area
            new_width = client_area_.attr_width - event.attr_x - (self.attr_sash.get_size.attr_x + self.attr_right_separator.get_size.attr_x)
            if (!(new_width).equal?(data.attr_width_hint))
              data.attr_width_hint = new_width
              shell.layout
            end
          end
        end
        
        typesig { [Object] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      @shell_width = shell.get_size.attr_x
      @resize_listener = ResizeListener.new_local(self, data, shell)
      shell.add_control_listener(@resize_listener)
      @tray = tray
    end
    
    typesig { [::Java::Boolean] }
    # Sets whether or not context help is available for this dialog. This
    # can affect whether or not the dialog will display additional help
    # mechanisms such as a help control in the button bar.
    # 
    # @param helpAvailable whether or not context help is available for the dialog
    def set_help_available(help_available)
      @help_available = help_available
    end
    
    class_module.module_eval {
      typesig { [] }
      # Tests if dialogs that have help control should show it
      # all the time or only when explicitly requested for
      # each dialog instance.
      # 
      # @return <code>true</code> if dialogs that support help
      # control should show it by default, <code>false</code> otherwise.
      # @since 3.2
      def is_dialog_help_available
        return self.attr_dialog_help_available
      end
      
      typesig { [::Java::Boolean] }
      # Sets whether JFace dialogs that support help control should
      # show the control by default. If set to <code>false</code>,
      # help control can still be shown on a per-dialog basis.
      # 
      # @param helpAvailable <code>true</code> to show the help
      # control, <code>false</code> otherwise.
      # @since 3.2
      def set_dialog_help_available(help_available)
        self.attr_dialog_help_available = help_available
      end
    }
    
    private
    alias_method :initialize__tray_dialog, :initialize
  end
  
end
