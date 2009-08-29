require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Window
  module WindowImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Window
      include_const ::Java::Util, :ArrayList
      include_const ::Org::Eclipse::Jface::Resource, :JFaceResources
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Jface::Util, :Geometry
      include_const ::Org::Eclipse::Jface::Util, :IPropertyChangeListener
      include_const ::Org::Eclipse::Jface::Util, :PropertyChangeEvent
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Events, :ShellAdapter
      include_const ::Org::Eclipse::Swt::Events, :ShellEvent
      include_const ::Org::Eclipse::Swt::Events, :ShellListener
      include_const ::Org::Eclipse::Swt::Graphics, :Image
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Graphics, :Rectangle
      include_const ::Org::Eclipse::Swt::Layout, :GridLayout
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Display
      include_const ::Org::Eclipse::Swt::Widgets, :Event
      include_const ::Org::Eclipse::Swt::Widgets, :Layout
      include_const ::Org::Eclipse::Swt::Widgets, :Listener
      include_const ::Org::Eclipse::Swt::Widgets, :Monitor
      include_const ::Org::Eclipse::Swt::Widgets, :Shell
    }
  end
  
  # A JFace window is an object that has no visual representation (no widgets)
  # until it is told to open.
  # <p>
  # Creating a window involves the following steps:
  # <ul>
  # <li>creating an instance of a concrete subclass of <code>Window</code>
  # </li>
  # <li>creating the window's shell and widget tree by calling
  # <code>create</code> (optional)</li>
  # <li>assigning the window to a window manager using
  # <code>WindowManager.add</code> (optional)</li>
  # <li>opening the window by calling <code>open</code></li>
  # </ul>
  # Opening the window will create its shell and widget tree if they have not
  # already been created. When the window is closed, the shell and widget tree
  # are disposed of and are no longer referenced, and the window is automatically
  # removed from its window manager. A window may be reopened.
  # </p>
  # <p>
  # The JFace window framework (this package) consists of this class,
  # <code>Window</code>, the abstract base of all windows, and one concrete
  # window classes (<code>ApplicationWindow</code>) which may also be
  # subclassed. Clients may define additional window subclasses as required.
  # </p>
  # <p>
  # The <code>Window</code> class provides methods that subclasses may
  # override to configure the window, including:
  # <ul>
  # <li><code>close</code>- extend to free other SWT resources</li>
  # <li><code>configureShell</code>- extend or reimplement to set shell
  # properties before window opens</li>
  # <li><code>createContents</code>- extend or reimplement to create controls
  # before window opens</li>
  # <li><code>getInitialSize</code>- reimplement to give the initial size for
  # the shell</li>
  # <li><code>getInitialLocation</code>- reimplement to give the initial
  # location for the shell</li>
  # <li><code>getShellListener</code>- extend or reimplement to receive shell
  # events</li>
  # <li><code>handleFontChange</code>- reimplement to respond to font changes
  # </li>
  # <li><code>handleShellCloseEvent</code>- extend or reimplement to handle
  # shell closings</li>
  # </ul>
  # </p>
  class Window 
    include_class_members WindowImports
    include IShellProvider
    
    class_module.module_eval {
      # Standard return code constant (value 0) indicating that the window was
      # opened.
      # 
      # @see #open
      const_set_lazy(:OK) { 0 }
      const_attr_reader  :OK
      
      # Standard return code constant (value 1) indicating that the window was
      # canceled.
      # 
      # @see #open
      const_set_lazy(:CANCEL) { 1 }
      const_attr_reader  :CANCEL
      
      # An array of images to be used for the window. It is expected that the
      # array will contain the same icon rendered at different resolutions.
      
      def default_images
        defined?(@@default_images) ? @@default_images : @@default_images= nil
      end
      alias_method :attr_default_images, :default_images
      
      def default_images=(value)
        @@default_images = value
      end
      alias_method :attr_default_images=, :default_images=
      
      # This interface defines a Exception Handler which can be set as a global
      # handler and will be called if an exception happens in the event loop.
      const_set_lazy(:IExceptionHandler) { Module.new do
        include_class_members Window
        
        typesig { [JavaThrowable] }
        # Handle the exception.
        # 
        # @param t
        # The exception that occured.
        def handle_exception(t)
          raise NotImplementedError
        end
      end }
      
      # Defines a default exception handler.
      const_set_lazy(:DefaultExceptionHandler) { Class.new do
        include_class_members Window
        include IExceptionHandler
        
        typesig { [class_self::JavaThrowable] }
        # (non-Javadoc)
        # 
        # @see org.eclipse.jface.window.Window.IExceptionHandler#handleException(java.lang.Throwable)
        def handle_exception(t)
          if (t.is_a?(self.class::ThreadDeath))
            # Don't catch ThreadDeath as this is a normal occurrence when
            # the thread dies
            raise t
          end
          # Try to keep running.
          t.print_stack_trace
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__default_exception_handler, :initialize
      end }
      
      # The exception handler for this application.
      
      def exception_handler
        defined?(@@exception_handler) ? @@exception_handler : @@exception_handler= DefaultExceptionHandler.new
      end
      alias_method :attr_exception_handler, :exception_handler
      
      def exception_handler=(value)
        @@exception_handler = value
      end
      alias_method :attr_exception_handler=, :exception_handler=
      
      # The default orientation of the window. By default
      # it is SWT#NONE but it can also be SWT#LEFT_TO_RIGHT
      # or SWT#RIGHT_TO_LEFT
      
      def orientation
        defined?(@@orientation) ? @@orientation : @@orientation= SWT::NONE
      end
      alias_method :attr_orientation, :orientation
      
      def orientation=(value)
        @@orientation = value
      end
      alias_method :attr_orientation=, :orientation=
      
      
      def default_modal_parent
        defined?(@@default_modal_parent) ? @@default_modal_parent : @@default_modal_parent= # Object used to locate the default parent for modal shells
        Class.new(IShellProvider.class == Class ? IShellProvider : Object) do
          extend LocalClass
          include_class_members Window
          include IShellProvider if IShellProvider.class == Module
          
          typesig { [] }
          define_method :get_shell do
            d = Display.get_current
            if ((d).nil?)
              return nil
            end
            parent = d.get_active_shell
            # Make sure we don't pick a parent that has a modal child (this can lock the app)
            if ((parent).nil?)
              # If this is a top-level window, then there must not be any open modal windows.
              parent = get_modal_child(Display.get_current.get_shells)
            else
              # If we picked a parent with a modal child, use the modal child instead
              modal_child = get_modal_child(parent.get_shells)
              if (!(modal_child).nil?)
                parent = modal_child
              end
            end
            return parent
          end
          
          typesig { [] }
          define_method :initialize do
            super()
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self)
      end
      alias_method :attr_default_modal_parent, :default_modal_parent
      
      def default_modal_parent=(value)
        @@default_modal_parent = value
      end
      alias_method :attr_default_modal_parent=, :default_modal_parent=
    }
    
    # Object that returns the parent shell.
    attr_accessor :parent_shell
    alias_method :attr_parent_shell, :parent_shell
    undef_method :parent_shell
    alias_method :attr_parent_shell=, :parent_shell=
    undef_method :parent_shell=
    
    # Shell style bits.
    # 
    # @see #setShellStyle
    attr_accessor :shell_style
    alias_method :attr_shell_style, :shell_style
    undef_method :shell_style
    alias_method :attr_shell_style=, :shell_style=
    undef_method :shell_style=
    
    # Window manager, or <code>null</code> if none.
    # 
    # @see #setWindowManager
    attr_accessor :window_manager
    alias_method :attr_window_manager, :window_manager
    undef_method :window_manager
    alias_method :attr_window_manager=, :window_manager=
    undef_method :window_manager=
    
    # Window shell, or <code>null</code> if none.
    attr_accessor :shell
    alias_method :attr_shell, :shell
    undef_method :shell
    alias_method :attr_shell=, :shell=
    undef_method :shell=
    
    # Top level SWT control, or <code>null</code> if none
    attr_accessor :contents
    alias_method :attr_contents, :contents
    undef_method :contents
    alias_method :attr_contents=, :contents=
    undef_method :contents=
    
    # Window return code; initially <code>OK</code>.
    # 
    # @see #setReturnCode
    attr_accessor :return_code
    alias_method :attr_return_code, :return_code
    undef_method :return_code
    alias_method :attr_return_code=, :return_code=
    undef_method :return_code=
    
    # <code>true</code> if the <code>open</code> method should not return
    # until the window closes, and <code>false</code> if the
    # <code>open</code> method should return immediately; initially
    # <code>false</code> (non-blocking).
    # 
    # @see #setBlockOnOpen
    attr_accessor :block
    alias_method :attr_block, :block
    undef_method :block
    alias_method :attr_block=, :block=
    undef_method :block=
    
    class_module.module_eval {
      # Internal class for informing this window when fonts change.
      const_set_lazy(:FontChangeListener) { Class.new do
        extend LocalClass
        include_class_members Window
        include IPropertyChangeListener
        
        typesig { [class_self::PropertyChangeEvent] }
        def property_change(event)
          handle_font_change(event)
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__font_change_listener, :initialize
      end }
    }
    
    # Internal font change listener.
    attr_accessor :font_change_listener
    alias_method :attr_font_change_listener, :font_change_listener
    undef_method :font_change_listener
    alias_method :attr_font_change_listener=, :font_change_listener=
    undef_method :font_change_listener=
    
    # Internal fields to detect if shell size has been set
    attr_accessor :resize_has_occurred
    alias_method :attr_resize_has_occurred, :resize_has_occurred
    undef_method :resize_has_occurred
    alias_method :attr_resize_has_occurred=, :resize_has_occurred=
    undef_method :resize_has_occurred=
    
    attr_accessor :resize_listener
    alias_method :attr_resize_listener, :resize_listener
    undef_method :resize_listener
    alias_method :attr_resize_listener=, :resize_listener=
    undef_method :resize_listener=
    
    typesig { [Shell] }
    # Creates a window instance, whose shell will be created under the given
    # parent shell. Note that the window will have no visual representation
    # until it is told to open. By default, <code>open</code> does not block.
    # 
    # @param parentShell
    # the parent shell, or <code>null</code> to create a top-level
    # shell. Try passing "(Shell)null" to this method instead of "null"
    # if your compiler complains about an ambiguity error.
    # @see #setBlockOnOpen
    # @see #getDefaultOrientation()
    def initialize(parent_shell)
      initialize__window(SameShellProvider.new(parent_shell))
      if ((parent_shell).nil?)
        set_shell_style(get_shell_style | get_default_orientation)
      end
    end
    
    typesig { [IShellProvider] }
    # Creates a new window which will create its shell as a child of whatever
    # the given shellProvider returns.
    # 
    # @param shellProvider object that will return the current parent shell. Not null.
    # 
    # @since 3.1
    def initialize(shell_provider)
      @parent_shell = nil
      @shell_style = SWT::SHELL_TRIM
      @window_manager = nil
      @shell = nil
      @contents = nil
      @return_code = OK
      @block = false
      @font_change_listener = nil
      @resize_has_occurred = false
      @resize_listener = nil
      Assert.is_not_null(shell_provider)
      @parent_shell = shell_provider
    end
    
    typesig { [] }
    # Determines if the window should handle the close event or do nothing.
    # <p>
    # The default implementation of this framework method returns
    # <code>true</code>, which will allow the
    # <code>handleShellCloseEvent</code> method to be called. Subclasses may
    # extend or reimplement.
    # </p>
    # 
    # @return whether the window should handle the close event.
    def can_handle_shell_close_event
      return true
    end
    
    typesig { [] }
    # Closes this window, disposes its shell, and removes this window from its
    # window manager (if it has one).
    # <p>
    # This framework method may be extended (<code>super.close</code> must
    # be called).
    # </p>
    # <p>
    # Note that in order to prevent recursive calls to this method
    # it does not call <code>Shell#close()</code>. As a result <code>ShellListener</code>s
    # will not receive a <code>shellClosed</code> event.
    # </p>
    # 
    # @return <code>true</code> if the window is (or was already) closed, and
    # <code>false</code> if it is still open
    def close
      # stop listening for font changes
      if (!(@font_change_listener).nil?)
        JFaceResources.get_font_registry.remove_listener(@font_change_listener)
        @font_change_listener = nil
      end
      # remove this window from a window manager if it has one
      if (!(@window_manager).nil?)
        @window_manager.remove(self)
        @window_manager = nil
      end
      if ((@shell).nil? || @shell.is_disposed)
        return true
      end
      # If we "close" the shell recursion will occur.
      # Instead, we need to "dispose" the shell to remove it from the
      # display.
      @shell.dispose
      @shell = nil
      @contents = nil
      return true
    end
    
    typesig { [Shell] }
    # Configures the given shell in preparation for opening this window in it.
    # <p>
    # The default implementation of this framework method sets the shell's
    # image and gives it a grid layout. Subclasses may extend or reimplement.
    # </p>
    # 
    # @param newShell
    # the shell
    def configure_shell(new_shell)
      # The single image version of this code had a comment related to bug
      # 46624,
      # and some code that did nothing if the stored image was already
      # disposed.
      # The equivalent in the multi-image version seems to be to remove the
      # disposed images from the array passed to the shell.
      if (!(self.attr_default_images).nil? && self.attr_default_images.attr_length > 0)
        non_disposed_images = ArrayList.new(self.attr_default_images.attr_length)
        i = 0
        while i < self.attr_default_images.attr_length
          if (!(self.attr_default_images[i]).nil? && !self.attr_default_images[i].is_disposed)
            non_disposed_images.add(self.attr_default_images[i])
          end
          (i += 1)
        end
        if (non_disposed_images.size <= 0)
          System.err.println("Window.configureShell: images disposed") # $NON-NLS-1$
        else
          array = Array.typed(Image).new(non_disposed_images.size) { nil }
          non_disposed_images.to_array(array)
          new_shell.set_images(array)
        end
      end
      layout = get_layout
      if (!(layout).nil?)
        new_shell.set_layout(layout)
      end
    end
    
    typesig { [] }
    # Creates the layout for the shell. The layout created here will be
    # attached to the composite passed into createContents. The default
    # implementation returns a GridLayout with no margins. Subclasses that
    # change the layout type by overriding this method should also override
    # createContents.
    # 
    # <p>
    # A return value of null indicates that no layout should be attached to the
    # composite. In this case, the layout may be attached within
    # createContents.
    # </p>
    # 
    # @return a newly created Layout or null if no layout should be attached.
    # @since 3.0
    def get_layout
      layout = GridLayout.new
      layout.attr_margin_height = 0
      layout.attr_margin_width = 0
      return layout
    end
    
    typesig { [] }
    # Constrain the shell size to be no larger than the display bounds.
    # 
    # @since 2.0
    def constrain_shell_size
      # limit the shell size to the display size
      bounds = @shell.get_bounds
      constrained = get_constrained_shell_bounds(bounds)
      if (!(bounds == constrained))
        @shell.set_bounds(constrained)
      end
    end
    
    typesig { [] }
    # Creates this window's widgetry in a new top-level shell.
    # <p>
    # The default implementation of this framework method creates this window's
    # shell (by calling <code>createShell</code>), and its controls (by
    # calling <code>createContents</code>), then initializes this window's
    # shell bounds (by calling <code>initializeBounds</code>).
    # </p>
    def create
      @shell = create_shell
      @contents = create_contents(@shell)
      # initialize the bounds of the shell to that appropriate for the
      # contents
      initialize_bounds
    end
    
    typesig { [Composite] }
    # Creates and returns this window's contents. Subclasses may attach any
    # number of children to the parent. As a convenience, the return value of
    # this method will be remembered and returned by subsequent calls to
    # getContents(). Subclasses may modify the parent's layout if they overload
    # getLayout() to return null.
    # 
    # <p>
    # It is common practise to create and return a single composite that
    # contains the entire window contents.
    # </p>
    # 
    # <p>
    # The default implementation of this framework method creates an instance
    # of <code>Composite</code>. Subclasses may override.
    # </p>
    # 
    # @param parent
    # the parent composite for the controls in this window. The type
    # of layout used is determined by getLayout()
    # 
    # @return the control that will be returned by subsequent calls to
    # getContents()
    def create_contents(parent)
      # by default, just create a composite
      return Composite.new(parent, SWT::NONE)
    end
    
    typesig { [] }
    # Creates and returns this window's shell.
    # <p>
    # This method creates a new shell and configures
    # it using <code>configureShell</code>. Subclasses
    # should  override <code>configureShell</code> if the
    # shell needs to be customized.
    # </p>
    # 
    # @return the shell
    def create_shell
      new_parent = get_parent_shell
      if (!(new_parent).nil? && new_parent.is_disposed)
        @parent_shell = SameShellProvider.new(nil)
        new_parent = get_parent_shell # Find a better parent
      end
      # Create the shell
      new_shell = Shell.new(new_parent, get_shell_style)
      @resize_listener = Class.new(Listener.class == Class ? Listener : Object) do
        extend LocalClass
        include_class_members Window
        include Listener if Listener.class == Module
        
        typesig { [Event] }
        define_method :handle_event do |e|
          self.attr_resize_has_occurred = true
        end
        
        typesig { [] }
        define_method :initialize do
          super()
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
      new_shell.add_listener(SWT::Resize, @resize_listener)
      new_shell.set_data(self)
      # Add a listener
      new_shell.add_shell_listener(get_shell_listener)
      # Set the layout
      configure_shell(new_shell)
      # Register for font changes
      if ((@font_change_listener).nil?)
        @font_change_listener = FontChangeListener.new_local(self)
      end
      JFaceResources.get_font_registry.add_listener(@font_change_listener)
      return new_shell
    end
    
    typesig { [] }
    # Returns the top level control for this window. The parent of this control
    # is the shell.
    # 
    # @return the top level control, or <code>null</code> if this window's
    # control has not been created yet
    def get_contents
      return @contents
    end
    
    class_module.module_eval {
      typesig { [] }
      # Returns the default image. This is the image that will be used for
      # windows that have no shell image at the time they are opened. There is no
      # default image unless one is installed via <code>setDefaultImage</code>.
      # 
      # @return the default image, or <code>null</code> if none
      # @see #setDefaultImage
      def get_default_image
        return ((self.attr_default_images).nil? || self.attr_default_images.attr_length < 1) ? nil : self.attr_default_images[0]
      end
      
      typesig { [] }
      # Returns the array of default images to use for newly opened windows. It
      # is expected that the array will contain the same icon rendered at
      # different resolutions.
      # 
      # @see org.eclipse.swt.widgets.Decorations#setImages(org.eclipse.swt.graphics.Image[])
      # 
      # @return the array of images to be used when a new window is opened
      # @see #setDefaultImages
      # @since 3.0
      def get_default_images
        return ((self.attr_default_images).nil? ? Array.typed(Image).new(0) { nil } : self.attr_default_images)
      end
    }
    
    typesig { [Point] }
    # Returns the initial location to use for the shell. The default
    # implementation centers the shell horizontally (1/2 of the difference to
    # the left and 1/2 to the right) and vertically (1/3 above and 2/3 below)
    # relative to the parent shell, or display bounds if there is no parent
    # shell.
    # 
    # @param initialSize
    # the initial size of the shell, as returned by
    # <code>getInitialSize</code>.
    # @return the initial location of the shell
    def get_initial_location(initial_size)
      parent = @shell.get_parent
      monitor = @shell.get_display.get_primary_monitor
      if (!(parent).nil?)
        monitor = parent.get_monitor
      end
      monitor_bounds = monitor.get_client_area
      center_point = nil
      if (!(parent).nil?)
        center_point = Geometry.center_point(parent.get_bounds)
      else
        center_point = Geometry.center_point(monitor_bounds)
      end
      return Point.new(center_point.attr_x - (initial_size.attr_x / 2), Math.max(monitor_bounds.attr_y, Math.min(center_point.attr_y - (initial_size.attr_y * 2 / 3), monitor_bounds.attr_y + monitor_bounds.attr_height - initial_size.attr_y)))
    end
    
    typesig { [] }
    # Returns the initial size to use for the shell. The default implementation
    # returns the preferred size of the shell, using
    # <code>Shell.computeSize(SWT.DEFAULT, SWT.DEFAULT, true)</code>.
    # 
    # @return the initial size of the shell
    def get_initial_size
      return @shell.compute_size(SWT::DEFAULT, SWT::DEFAULT, true)
    end
    
    class_module.module_eval {
      typesig { [Array.typed(Shell)] }
      # Returns the most specific modal child from the given list of Shells.
      # 
      # @param toSearch shells to search for modal children
      # @return the most specific modal child, or null if none
      # 
      # @since 3.1
      def get_modal_child(to_search)
        modal = SWT::APPLICATION_MODAL | SWT::SYSTEM_MODAL | SWT::PRIMARY_MODAL
        i = to_search.attr_length - 1
        while i >= 0
          shell = to_search[i]
          # Check if this shell has a modal child
          children = shell.get_shells
          modal_child = get_modal_child(children)
          if (!(modal_child).nil?)
            return modal_child
          end
          # If not, check if this shell is modal itself
          if (shell.is_visible && !((shell.get_style & modal)).equal?(0))
            return shell
          end
          i -= 1
        end
        return nil
      end
    }
    
    typesig { [] }
    # Returns parent shell, under which this window's shell is created.
    # 
    # @return the parent shell, or <code>null</code> if there is no parent
    # shell
    def get_parent_shell
      parent = @parent_shell.get_shell
      modal = SWT::APPLICATION_MODAL | SWT::SYSTEM_MODAL | SWT::PRIMARY_MODAL
      if (!((get_shell_style & modal)).equal?(0))
        # If this is a modal shell with no parent, pick a shell using defaultModalParent.
        if ((parent).nil?)
          parent = self.attr_default_modal_parent.get_shell
        end
      end
      return parent
    end
    
    typesig { [] }
    # Returns this window's return code. A window's return codes are
    # window-specific, although two standard return codes are predefined:
    # <code>OK</code> and <code>CANCEL</code>.
    # 
    # @return the return code
    def get_return_code
      return @return_code
    end
    
    typesig { [] }
    # Returns this window's shell.
    # 
    # @return this window's shell, or <code>null</code> if this window's
    # shell has not been created yet
    def get_shell
      return @shell
    end
    
    typesig { [] }
    # Returns a shell listener. This shell listener gets registered with this
    # window's shell.
    # <p>
    # The default implementation of this framework method returns a new
    # listener that makes this window the active window for its window manager
    # (if it has one) when the shell is activated, and calls the framework
    # method <code>handleShellCloseEvent</code> when the shell is closed.
    # Subclasses may extend or reimplement.
    # </p>
    # 
    # @return a shell listener
    def get_shell_listener
      return Class.new(ShellAdapter.class == Class ? ShellAdapter : Object) do
        extend LocalClass
        include_class_members Window
        include ShellAdapter if ShellAdapter.class == Module
        
        typesig { [ShellEvent] }
        define_method :shell_closed do |event|
          event.attr_doit = false # don't close now
          if (can_handle_shell_close_event)
            handle_shell_close_event
          end
        end
        
        typesig { [] }
        define_method :initialize do
          super()
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
    end
    
    typesig { [] }
    # Returns the shell style bits.
    # <p>
    # The default value is <code>SWT.CLOSE|SWT.MIN|SWT.MAX|SWT.RESIZE</code>.
    # Subclassers should call <code>setShellStyle</code> to change this
    # value, rather than overriding this method.
    # </p>
    # 
    # @return the shell style bits
    def get_shell_style
      return @shell_style
    end
    
    typesig { [] }
    # Returns the window manager of this window.
    # 
    # @return the WindowManager, or <code>null</code> if none
    def get_window_manager
      return @window_manager
    end
    
    typesig { [PropertyChangeEvent] }
    # Notifies of a font property change.
    # <p>
    # The default implementation of this framework method does nothing.
    # Subclasses may reimplement.
    # </p>
    # 
    # @param event
    # the property change event detailing what changed
    def handle_font_change(event)
      # do nothing
    end
    
    typesig { [] }
    # Notifies that the window's close button was pressed, the close menu was
    # selected, or the ESCAPE key pressed.
    # <p>
    # The default implementation of this framework method sets the window's
    # return code to <code>CANCEL</code> and closes the window using
    # <code>close</code>. Subclasses may extend or reimplement.
    # </p>
    def handle_shell_close_event
      set_return_code(CANCEL)
      close
    end
    
    typesig { [] }
    # Initializes the location and size of this window's SWT shell after it has
    # been created.
    # <p>
    # This framework method is called by the <code>create</code> framework
    # method. The default implementation calls <code>getInitialSize</code>
    # and <code>getInitialLocation</code> and passes the results to
    # <code>Shell.setBounds</code>. This is only done if the bounds of the
    # shell have not already been modified. Subclasses may extend or
    # reimplement.
    # </p>
    def initialize_bounds
      if (!(@resize_listener).nil?)
        @shell.remove_listener(SWT::Resize, @resize_listener)
      end
      if (@resize_has_occurred)
        # Check if shell size has been set already.
        return
      end
      size_ = get_initial_size
      location = get_initial_location(size_)
      @shell.set_bounds(get_constrained_shell_bounds(Rectangle.new(location.attr_x, location.attr_y, size_.attr_x, size_.attr_y)))
    end
    
    typesig { [] }
    # Opens this window, creating it first if it has not yet been created.
    # <p>
    # If this window has been configured to block on open (
    # <code>setBlockOnOpen</code>), this method waits until the window is
    # closed by the end user, and then it returns the window's return code;
    # otherwise, this method returns immediately. A window's return codes are
    # window-specific, although two standard return codes are predefined:
    # <code>OK</code> and <code>CANCEL</code>.
    # </p>
    # 
    # @return the return code
    # 
    # @see #create()
    def open
      if ((@shell).nil? || @shell.is_disposed)
        @shell = nil
        # create the window
        create
      end
      # limit the shell size to the display size
      constrain_shell_size
      # open the window
      @shell.open
      # run the event loop if specified
      if (@block)
        run_event_loop(@shell)
      end
      return @return_code
    end
    
    typesig { [Shell] }
    # Runs the event loop for the given shell.
    # 
    # @param loopShell
    # the shell
    def run_event_loop(loop_shell)
      # Use the display provided by the shell if possible
      display = nil
      if ((@shell).nil?)
        display = Display.get_current
      else
        display = loop_shell.get_display
      end
      while (!(loop_shell).nil? && !loop_shell.is_disposed)
        begin
          if (!display.read_and_dispatch)
            display.sleep
          end
        rescue JavaThrowable => e
          self.attr_exception_handler.handle_exception(e)
        end
      end
      if (!display.is_disposed)
        display.update
      end
    end
    
    typesig { [::Java::Boolean] }
    # Sets whether the <code>open</code> method should block until the window
    # closes.
    # 
    # @param shouldBlock
    # <code>true</code> if the <code>open</code> method should
    # not return until the window closes, and <code>false</code>
    # if the <code>open</code> method should return immediately
    def set_block_on_open(should_block)
      @block = should_block
    end
    
    class_module.module_eval {
      typesig { [Image] }
      # Sets the default image. This is the image that will be used for windows
      # that have no shell image at the time they are opened. There is no default
      # image unless one is installed via this method.
      # 
      # @param image
      # the default image, or <code>null</code> if none
      def set_default_image(image)
        self.attr_default_images = (image).nil? ? nil : Array.typed(Image).new([image])
      end
      
      typesig { [Array.typed(Image)] }
      # Sets the array of default images to use for newly opened windows. It is
      # expected that the array will contain the same icon rendered at different
      # resolutions.
      # 
      # @see org.eclipse.swt.widgets.Decorations#setImages(org.eclipse.swt.graphics.Image[])
      # 
      # @param images
      # the array of images to be used when this window is opened
      # @since 3.0
      def set_default_images(images)
        new_array = Array.typed(Image).new(images.attr_length) { nil }
        System.arraycopy(images, 0, new_array, 0, new_array.attr_length)
        self.attr_default_images = new_array
      end
    }
    
    typesig { [Shell] }
    # Changes the parent shell. This is only safe to use when the shell is not
    # yet realized (i.e., created). Once the shell is created, it must be
    # disposed (i.e., closed) before this method can be called.
    # 
    # @param newParentShell
    # The new parent shell; this value may be <code>null</code> if
    # there is to be no parent.
    # @since 3.1
    def set_parent_shell(new_parent_shell)
      Assert.is_true(((@shell).nil?), "There must not be an existing shell.") # $NON-NLS-1$
      @parent_shell = SameShellProvider.new(new_parent_shell)
    end
    
    typesig { [::Java::Int] }
    # Sets this window's return code. The return code is automatically returned
    # by <code>open</code> if block on open is enabled. For non-blocking
    # opens, the return code needs to be retrieved manually using
    # <code>getReturnCode</code>.
    # 
    # @param code
    # the return code
    def set_return_code(code)
      @return_code = code
    end
    
    class_module.module_eval {
      typesig { [Display, Point] }
      # Returns the monitor whose client area contains the given point. If no
      # monitor contains the point, returns the monitor that is closest to the
      # point. If this is ever made public, it should be moved into a separate
      # utility class.
      # 
      # @param toSearch
      # point to find (display coordinates)
      # @param toFind
      # point to find (display coordinates)
      # @return the montor closest to the given point
      def get_closest_monitor(to_search, to_find)
        closest = JavaInteger::MAX_VALUE
        monitors = to_search.get_monitors
        result = monitors[0]
        idx = 0
        while idx < monitors.attr_length
          current = monitors[idx]
          client_area = current.get_client_area
          if (client_area.contains(to_find))
            return current
          end
          distance = Geometry.distance_squared(Geometry.center_point(client_area), to_find)
          if (distance < closest)
            closest = distance
            result = current
          end
          idx += 1
        end
        return result
      end
    }
    
    typesig { [Rectangle] }
    # Given the desired position of the window, this method returns an adjusted
    # position such that the window is no larger than its monitor, and does not
    # extend beyond the edge of the monitor. This is used for computing the
    # initial window position, and subclasses can use this as a utility method
    # if they want to limit the region in which the window may be moved.
    # 
    # @param preferredSize
    # the preferred position of the window
    # @return a rectangle as close as possible to preferredSize that does not
    # extend outside the monitor
    # 
    # @since 3.0
    def get_constrained_shell_bounds(preferred_size)
      result = Rectangle.new(preferred_size.attr_x, preferred_size.attr_y, preferred_size.attr_width, preferred_size.attr_height)
      mon = get_closest_monitor(get_shell.get_display, Geometry.center_point(result))
      bounds = mon.get_client_area
      if (result.attr_height > bounds.attr_height)
        result.attr_height = bounds.attr_height
      end
      if (result.attr_width > bounds.attr_width)
        result.attr_width = bounds.attr_width
      end
      result.attr_x = Math.max(bounds.attr_x, Math.min(result.attr_x, bounds.attr_x + bounds.attr_width - result.attr_width))
      result.attr_y = Math.max(bounds.attr_y, Math.min(result.attr_y, bounds.attr_y + bounds.attr_height - result.attr_height))
      return result
    end
    
    typesig { [::Java::Int] }
    # Sets the shell style bits. This method has no effect after the shell is
    # created.
    # <p>
    # The shell style bits are used by the framework method
    # <code>createShell</code> when creating this window's shell.
    # </p>
    # 
    # @param newShellStyle
    # the new shell style bits
    def set_shell_style(new_shell_style)
      @shell_style = new_shell_style
    end
    
    typesig { [WindowManager] }
    # Sets the window manager of this window.
    # <p>
    # Note that this method is used by <code>WindowManager</code> to maintain
    # a backpointer. Clients must not call the method directly.
    # </p>
    # 
    # @param manager
    # the window manager, or <code>null</code> if none
    def set_window_manager(manager)
      @window_manager = manager
      # Code to detect invalid usage
      if (!(manager).nil?)
        windows = manager.get_windows
        i = 0
        while i < windows.attr_length
          if ((windows[i]).equal?(self))
            return
          end
          i += 1
        end
        manager.add(self)
      end
    end
    
    class_module.module_eval {
      typesig { [IExceptionHandler] }
      # Sets the exception handler for this application.
      # <p>
      # Note that the handler may only be set once.  Subsequent calls to this method will be
      # ignored.
      # <p>
      # 
      # @param handler
      # the exception handler for the application.
      def set_exception_handler(handler)
        if (self.attr_exception_handler.is_a?(DefaultExceptionHandler))
          self.attr_exception_handler = handler
        end
      end
      
      typesig { [IShellProvider] }
      # Sets the default parent for modal Windows. This will be used to locate
      # the parent for any modal Window constructed with a null parent.
      # 
      # @param provider shell provider that will be used to locate the parent shell
      # whenever a Window is created with a null parent
      # @since 3.1
      def set_default_modal_parent(provider)
        self.attr_default_modal_parent = provider
      end
      
      typesig { [] }
      # Gets the default orientation for windows. If it is not
      # set the default value will be unspecified (SWT#NONE).
      # 
      # 
      # @return SWT#NONE, SWT.RIGHT_TO_LEFT or SWT.LEFT_TO_RIGHT
      # @see SWT#RIGHT_TO_LEFT
      # @see SWT#LEFT_TO_RIGHT
      # @see SWT#NONE
      # @since 3.1
      def get_default_orientation
        return self.attr_orientation
      end
      
      typesig { [::Java::Int] }
      # Sets the default orientation of windows.
      # @param defaultOrientation one of
      # SWT#RIGHT_TO_LEFT, SWT#LEFT_TO_RIGHT ,SWT#NONE
      # @see SWT#RIGHT_TO_LEFT
      # @see SWT#LEFT_TO_RIGHT
      # @see SWT#NONE
      # @since 3.1
      def set_default_orientation(default_orientation)
        self.attr_orientation = default_orientation
      end
    }
    
    private
    alias_method :initialize__window, :initialize
  end
  
end
