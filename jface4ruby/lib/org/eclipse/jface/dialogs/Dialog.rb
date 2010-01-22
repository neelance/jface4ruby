require "rjava"

# Copyright (c) 2000, 2009 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
# Remy Chi Jian Suen <remy.suen@gmail.com> - Bug 218553 [JFace] mis-spelling of their in applyDialogFont(...)
module Org::Eclipse::Jface::Dialogs
  module DialogImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Dialogs
      include_const ::Java::Util, :Arrays
      include_const ::Java::Util, :HashMap
      include_const ::Org::Eclipse::Core::Runtime, :IProgressMonitor
      include_const ::Org::Eclipse::Core::Runtime, :IStatus
      include_const ::Org::Eclipse::Core::Runtime, :Status
      include_const ::Org::Eclipse::Jface::Resource, :JFaceResources
      include_const ::Org::Eclipse::Jface::Util, :Policy
      include_const ::Org::Eclipse::Jface::Window, :IShellProvider
      include_const ::Org::Eclipse::Jface::Window, :SameShellProvider
      include_const ::Org::Eclipse::Jface::Window, :Window
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Events, :SelectionAdapter
      include_const ::Org::Eclipse::Swt::Events, :SelectionEvent
      include_const ::Org::Eclipse::Swt::Graphics, :Font
      include_const ::Org::Eclipse::Swt::Graphics, :FontData
      include_const ::Org::Eclipse::Swt::Graphics, :FontMetrics
      include_const ::Org::Eclipse::Swt::Graphics, :SwtGC
      include_const ::Org::Eclipse::Swt::Graphics, :Image
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Layout, :FormData
      include_const ::Org::Eclipse::Swt::Layout, :GridData
      include_const ::Org::Eclipse::Swt::Layout, :GridLayout
      include_const ::Org::Eclipse::Swt::Widgets, :Button
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Display
      include_const ::Org::Eclipse::Swt::Widgets, :Shell
    }
  end
  
  # A dialog is a specialized window used for narrow-focused communication with
  # the user.
  # <p>
  # Dialogs are usually modal. Consequently, it is generally bad practice to open
  # a dialog without a parent. A modal dialog without a parent is not prevented
  # from disappearing behind the application's other windows, making it very
  # confusing for the user.
  # </p>
  # <p>
  # If there is more than one modal dialog is open the second one should be
  # parented off of the shell of the first one otherwise it is possible that the
  # OS will give focus to the first dialog potentially blocking the UI.
  # </p>
  class Dialog < DialogImports.const_get :Window
    include_class_members DialogImports
    
    class_module.module_eval {
      # Image registry key for error image (value
      # <code>"dialog_error_image"</code>).
      # 
      # @deprecated use
      # org.eclipse.swt.widgets.Display.getSystemImage(SWT.ICON_ERROR)
      const_set_lazy(:DLG_IMG_ERROR) { "dialog_error_image" }
      const_attr_reader  :DLG_IMG_ERROR
      
      # $NON-NLS-1$
      # 
      # Image registry key for info image (value <code>"dialog_info_image"</code>).
      # 
      # @deprecated use
      # org.eclipse.swt.widgets.Display.getSystemImage(SWT.ICON_INFORMATION)
      const_set_lazy(:DLG_IMG_INFO) { "dialog_info_imageg" }
      const_attr_reader  :DLG_IMG_INFO
      
      # $NON-NLS-1$
      # 
      # Image registry key for question image (value
      # <code>"dialog_question_image"</code>).
      # 
      # @deprecated org.eclipse.swt.widgets.Display.getSystemImage(SWT.ICON_QUESTION)
      const_set_lazy(:DLG_IMG_QUESTION) { "dialog_question_image" }
      const_attr_reader  :DLG_IMG_QUESTION
      
      # $NON-NLS-1$
      # 
      # Image registry key for warning image (value
      # <code>"dialog_warning_image"</code>).
      # 
      # @deprecated use
      # org.eclipse.swt.widgets.Display.getSystemImage(SWT.ICON_WARNING)
      const_set_lazy(:DLG_IMG_WARNING) { "dialog_warning_image" }
      const_attr_reader  :DLG_IMG_WARNING
      
      # $NON-NLS-1$
      # 
      # Image registry key for info message image (value
      # <code>"dialog_messasge_info_image"</code>).
      # 
      # @since 2.0
      const_set_lazy(:DLG_IMG_MESSAGE_INFO) { "dialog_messasge_info_image" }
      const_attr_reader  :DLG_IMG_MESSAGE_INFO
      
      # $NON-NLS-1$
      # 
      # Image registry key for info message image (value
      # <code>"dialog_messasge_warning_image"</code>).
      # 
      # @since 2.0
      const_set_lazy(:DLG_IMG_MESSAGE_WARNING) { "dialog_messasge_warning_image" }
      const_attr_reader  :DLG_IMG_MESSAGE_WARNING
      
      # $NON-NLS-1$
      # 
      # Image registry key for info message image (value
      # <code>"dialog_message_error_image"</code>).
      # 
      # @since 2.0
      const_set_lazy(:DLG_IMG_MESSAGE_ERROR) { "dialog_message_error_image" }
      const_attr_reader  :DLG_IMG_MESSAGE_ERROR
      
      # $NON-NLS-1$
      # 
      # Image registry key for help image (value
      # <code>"dialog_help_image"</code>).
      # 
      # @since 3.2
      const_set_lazy(:DLG_IMG_HELP) { "dialog_help_image" }
      const_attr_reader  :DLG_IMG_HELP
      
      # $NON-NLS-1$
      # 
      # The ellipsis is the string that is used to represent shortened text.
      # 
      # @since 3.0
      const_set_lazy(:ELLIPSIS) { "..." }
      const_attr_reader  :ELLIPSIS
      
      # $NON-NLS-1$
      # 
      # The dialog settings key name for stored dialog x location.
      # 
      # @since 3.2
      const_set_lazy(:DIALOG_ORIGIN_X) { "DIALOG_X_ORIGIN" }
      const_attr_reader  :DIALOG_ORIGIN_X
      
      # $NON-NLS-1$
      # 
      # The dialog settings key name for stored dialog y location.
      # 
      # @since 3.2
      const_set_lazy(:DIALOG_ORIGIN_Y) { "DIALOG_Y_ORIGIN" }
      const_attr_reader  :DIALOG_ORIGIN_Y
      
      # $NON-NLS-1$
      # 
      # The dialog settings key name for stored dialog width.
      # 
      # @since 3.2
      const_set_lazy(:DIALOG_WIDTH) { "DIALOG_WIDTH" }
      const_attr_reader  :DIALOG_WIDTH
      
      # $NON-NLS-1$
      # 
      # The dialog settings key name for stored dialog height.
      # 
      # @since 3.2
      const_set_lazy(:DIALOG_HEIGHT) { "DIALOG_HEIGHT" }
      const_attr_reader  :DIALOG_HEIGHT
      
      # $NON-NLS-1$
      # 
      # The dialog settings key name for the font used when the dialog
      # height and width was stored.
      # 
      # @since 3.2
      const_set_lazy(:DIALOG_FONT_DATA) { "DIALOG_FONT_NAME" }
      const_attr_reader  :DIALOG_FONT_DATA
      
      # $NON-NLS-1$
      # 
      # A value that can be used for stored dialog width or height that
      # indicates that the default bounds should be used.
      # 
      # @since 3.2
      const_set_lazy(:DIALOG_DEFAULT_BOUNDS) { -1 }
      const_attr_reader  :DIALOG_DEFAULT_BOUNDS
      
      # Constants that can be used for specifying the strategy for persisting
      # dialog bounds.  These constants represent bit masks that can be used
      # together.
      # 
      # @since 3.2
      # 
      # 
      # Persist the last location of the dialog.
      # @since 3.2
      const_set_lazy(:DIALOG_PERSISTLOCATION) { 0x1 }
      const_attr_reader  :DIALOG_PERSISTLOCATION
      
      # Persist the last known size of the dialog.
      # @since 3.2
      const_set_lazy(:DIALOG_PERSISTSIZE) { 0x2 }
      const_attr_reader  :DIALOG_PERSISTSIZE
    }
    
    # The dialog area; <code>null</code> until dialog is layed out.
    attr_accessor :dialog_area
    alias_method :attr_dialog_area, :dialog_area
    undef_method :dialog_area
    alias_method :attr_dialog_area=, :dialog_area=
    undef_method :dialog_area=
    
    # The button bar; <code>null</code> until dialog is layed out.
    attr_accessor :button_bar
    alias_method :attr_button_bar, :button_bar
    undef_method :button_bar
    alias_method :attr_button_bar=, :button_bar=
    undef_method :button_bar=
    
    # Collection of buttons created by the <code>createButton</code> method.
    attr_accessor :buttons
    alias_method :attr_buttons, :buttons
    undef_method :buttons
    alias_method :attr_buttons=, :buttons=
    undef_method :buttons=
    
    # Font metrics to use for determining pixel sizes.
    attr_accessor :font_metrics
    alias_method :attr_font_metrics, :font_metrics
    undef_method :font_metrics
    alias_method :attr_font_metrics=, :font_metrics=
    undef_method :font_metrics=
    
    class_module.module_eval {
      # Number of horizontal dialog units per character, value <code>4</code>.
      const_set_lazy(:HORIZONTAL_DIALOG_UNIT_PER_CHAR) { 4 }
      const_attr_reader  :HORIZONTAL_DIALOG_UNIT_PER_CHAR
      
      # Number of vertical dialog units per character, value <code>8</code>.
      const_set_lazy(:VERTICAL_DIALOG_UNITS_PER_CHAR) { 8 }
      const_attr_reader  :VERTICAL_DIALOG_UNITS_PER_CHAR
      
      typesig { [FontMetrics, ::Java::Int] }
      # Returns the number of pixels corresponding to the height of the given
      # number of characters.
      # <p>
      # The required <code>FontMetrics</code> parameter may be created in the
      # following way: <code>
      # GC gc = new GC(control);
      # gc.setFont(control.getFont());
      # fontMetrics = gc.getFontMetrics();
      # gc.dispose();
      # </code>
      # </p>
      # 
      # @param fontMetrics
      # used in performing the conversion
      # @param chars
      # the number of characters
      # @return the number of pixels
      # @since 2.0
      def convert_height_in_chars_to_pixels(font_metrics, chars)
        return font_metrics.get_height * chars
      end
      
      typesig { [FontMetrics, ::Java::Int] }
      # Returns the number of pixels corresponding to the given number of
      # horizontal dialog units.
      # <p>
      # The required <code>FontMetrics</code> parameter may be created in the
      # following way: <code>
      # GC gc = new GC(control);
      # gc.setFont(control.getFont());
      # fontMetrics = gc.getFontMetrics();
      # gc.dispose();
      # </code>
      # </p>
      # 
      # @param fontMetrics
      # used in performing the conversion
      # @param dlus
      # the number of horizontal dialog units
      # @return the number of pixels
      # @since 2.0
      def convert_horizontal_dlus_to_pixels(font_metrics, dlus)
        # round to the nearest pixel
        return (font_metrics.get_average_char_width * dlus + HORIZONTAL_DIALOG_UNIT_PER_CHAR / 2) / HORIZONTAL_DIALOG_UNIT_PER_CHAR
      end
      
      typesig { [FontMetrics, ::Java::Int] }
      # Returns the number of pixels corresponding to the given number of
      # vertical dialog units.
      # <p>
      # The required <code>FontMetrics</code> parameter may be created in the
      # following way: <code>
      # GC gc = new GC(control);
      # gc.setFont(control.getFont());
      # fontMetrics = gc.getFontMetrics();
      # gc.dispose();
      # </code>
      # </p>
      # 
      # @param fontMetrics
      # used in performing the conversion
      # @param dlus
      # the number of vertical dialog units
      # @return the number of pixels
      # @since 2.0
      def convert_vertical_dlus_to_pixels(font_metrics, dlus)
        # round to the nearest pixel
        return (font_metrics.get_height * dlus + VERTICAL_DIALOG_UNITS_PER_CHAR / 2) / VERTICAL_DIALOG_UNITS_PER_CHAR
      end
      
      typesig { [FontMetrics, ::Java::Int] }
      # Returns the number of pixels corresponding to the width of the given
      # number of characters.
      # <p>
      # The required <code>FontMetrics</code> parameter may be created in the
      # following way: <code>
      # GC gc = new GC(control);
      # gc.setFont(control.getFont());
      # fontMetrics = gc.getFontMetrics();
      # gc.dispose();
      # </code>
      # </p>
      # 
      # @param fontMetrics
      # used in performing the conversion
      # @param chars
      # the number of characters
      # @return the number of pixels
      # @since 2.0
      def convert_width_in_chars_to_pixels(font_metrics, chars)
        return font_metrics.get_average_char_width * chars
      end
      
      typesig { [String, Control] }
      # Shortens the given text <code>textValue</code> so that its width in
      # pixels does not exceed the width of the given control. Overrides
      # characters in the center of the original string with an ellipsis ("...")
      # if necessary. If a <code>null</code> value is given, <code>null</code>
      # is returned.
      # 
      # @param textValue
      # the original string or <code>null</code>
      # @param control
      # the control the string will be displayed on
      # @return the string to display, or <code>null</code> if null was passed
      # in
      # 
      # @since 3.0
      def shorten_text(text_value, control)
        if ((text_value).nil?)
          return nil
        end
        gc = SwtGC.new(control)
        max_width = control.get_bounds.attr_width - 5
        max_extent = gc.text_extent(text_value).attr_x
        if (max_extent < max_width)
          gc.dispose
          return text_value
        end
        length_ = text_value.length
        chars_to_clip = Math.round(0.95 * length_ * (1 - ((max_width).to_f / max_extent)))
        pivot = length_ / 2
        start = pivot - (chars_to_clip / 2)
        end_ = pivot + (chars_to_clip / 2) + 1
        while (start >= 0 && end_ < length_)
          s1 = text_value.substring(0, start)
          s2 = text_value.substring(end_, length_)
          s = s1 + ELLIPSIS + s2
          l = gc.text_extent(s).attr_x
          if (l < max_width)
            gc.dispose
            return s
          end
          start -= 1
          end_ += 1
        end
        gc.dispose
        return text_value
      end
      
      
      def blocked_handler
        defined?(@@blocked_handler) ? @@blocked_handler : @@blocked_handler= # Create a default instance of the blocked handler which does not do
        # anything.
        Class.new(IDialogBlockedHandler.class == Class ? IDialogBlockedHandler : Object) do
          extend LocalClass
          include_class_members Dialog
          include IDialogBlockedHandler if IDialogBlockedHandler.class == Module
          
          typesig { [] }
          # (non-Javadoc)
          # 
          # @see org.eclipse.jface.dialogs.IDialogBlockedHandler#clearBlocked()
          define_method :clear_blocked do
            # No default behaviour
          end
          
          typesig { [IProgressMonitor, IStatus, String] }
          # (non-Javadoc)
          # 
          # @see org.eclipse.jface.dialogs.IDialogBlockedHandler#showBlocked(org.eclipse.core.runtime.IProgressMonitor,
          # org.eclipse.core.runtime.IStatus, java.lang.String)
          define_method :show_blocked do |blocking, blocking_status, blocked_name|
            # No default behaviour
          end
          
          typesig { [Shell, IProgressMonitor, IStatus, String] }
          # (non-Javadoc)
          # 
          # @see org.eclipse.jface.dialogs.IDialogBlockedHandler#showBlocked(org.eclipse.swt.widgets.Shell,
          # org.eclipse.core.runtime.IProgressMonitor,
          # org.eclipse.core.runtime.IStatus, java.lang.String)
          define_method :show_blocked do |parent_shell, blocking, blocking_status, blocked_name|
            # No default behaviour
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self)
      end
      alias_method :attr_blocked_handler, :blocked_handler
      
      def blocked_handler=(value)
        @@blocked_handler = value
      end
      alias_method :attr_blocked_handler=, :blocked_handler=
    }
    
    typesig { [Shell] }
    # Creates a dialog instance. Note that the window will have no visual
    # representation (no widgets) until it is told to open. By default,
    # <code>open</code> blocks for dialogs.
    # 
    # @param parentShell
    # the parent shell, or <code>null</code> to create a top-level
    # shell
    def initialize(parent_shell)
      initialize__dialog(SameShellProvider.new(parent_shell))
      if ((parent_shell).nil? && Policy::DEBUG_DIALOG_NO_PARENT)
        # $NON-NLS-1$
        Policy.get_log.log(Status.new(IStatus::INFO, Policy::JFACE, IStatus::INFO, RJava.cast_to_string(self.get_class) + " created with no shell", JavaException.new))
      end
    end
    
    typesig { [IShellProvider] }
    # Creates a dialog with the given parent.
    # 
    # @param parentShell
    # object that returns the current parent shell
    # 
    # @since 3.1
    def initialize(parent_shell)
      @dialog_area = nil
      @button_bar = nil
      @buttons = nil
      @font_metrics = nil
      super(parent_shell)
      @buttons = HashMap.new
      if (is_resizable)
        set_shell_style(SWT::DIALOG_TRIM | SWT::APPLICATION_MODAL | SWT::MAX | SWT::RESIZE | get_default_orientation)
      else
        set_shell_style(SWT::DIALOG_TRIM | SWT::APPLICATION_MODAL | get_default_orientation)
      end
      set_block_on_open(true)
    end
    
    typesig { [::Java::Int] }
    # Notifies that this dialog's button with the given id has been pressed.
    # <p>
    # The <code>Dialog</code> implementation of this framework method calls
    # <code>okPressed</code> if the ok button is the pressed, and
    # <code>cancelPressed</code> if the cancel button is the pressed. All
    # other button presses are ignored. Subclasses may override to handle other
    # buttons, but should call <code>super.buttonPressed</code> if the
    # default handling of the ok and cancel buttons is desired.
    # </p>
    # 
    # @param buttonId
    # the id of the button that was pressed (see
    # <code>IDialogConstants.*_ID</code> constants)
    def button_pressed(button_id)
      if ((IDialogConstants::OK_ID).equal?(button_id))
        ok_pressed
      else
        if ((IDialogConstants::CANCEL_ID).equal?(button_id))
          cancel_pressed
        end
      end
    end
    
    typesig { [] }
    # Notifies that the cancel button of this dialog has been pressed.
    # <p>
    # The <code>Dialog</code> implementation of this framework method sets
    # this dialog's return code to <code>Window.CANCEL</code> and closes the
    # dialog. Subclasses may override if desired.
    # </p>
    def cancel_pressed
      set_return_code(CANCEL)
      close
    end
    
    typesig { [::Java::Int] }
    # Returns the number of pixels corresponding to the height of the given
    # number of characters.
    # <p>
    # This method may only be called after <code>initializeDialogUnits</code>
    # has been called.
    # </p>
    # <p>
    # Clients may call this framework method, but should not override it.
    # </p>
    # 
    # @param chars
    # the number of characters
    # @return the number of pixels
    def convert_height_in_chars_to_pixels(chars)
      # test for failure to initialize for backward compatibility
      if ((@font_metrics).nil?)
        return 0
      end
      return convert_height_in_chars_to_pixels(@font_metrics, chars)
    end
    
    typesig { [::Java::Int] }
    # Returns the number of pixels corresponding to the given number of
    # horizontal dialog units.
    # <p>
    # This method may only be called after <code>initializeDialogUnits</code>
    # has been called.
    # </p>
    # <p>
    # Clients may call this framework method, but should not override it.
    # </p>
    # 
    # @param dlus
    # the number of horizontal dialog units
    # @return the number of pixels
    def convert_horizontal_dlus_to_pixels(dlus)
      # test for failure to initialize for backward compatibility
      if ((@font_metrics).nil?)
        return 0
      end
      return convert_horizontal_dlus_to_pixels(@font_metrics, dlus)
    end
    
    typesig { [::Java::Int] }
    # Returns the number of pixels corresponding to the given number of
    # vertical dialog units.
    # <p>
    # This method may only be called after <code>initializeDialogUnits</code>
    # has been called.
    # </p>
    # <p>
    # Clients may call this framework method, but should not override it.
    # </p>
    # 
    # @param dlus
    # the number of vertical dialog units
    # @return the number of pixels
    def convert_vertical_dlus_to_pixels(dlus)
      # test for failure to initialize for backward compatibility
      if ((@font_metrics).nil?)
        return 0
      end
      return convert_vertical_dlus_to_pixels(@font_metrics, dlus)
    end
    
    typesig { [::Java::Int] }
    # Returns the number of pixels corresponding to the width of the given
    # number of characters.
    # <p>
    # This method may only be called after <code>initializeDialogUnits</code>
    # has been called.
    # </p>
    # <p>
    # Clients may call this framework method, but should not override it.
    # </p>
    # 
    # @param chars
    # the number of characters
    # @return the number of pixels
    def convert_width_in_chars_to_pixels(chars)
      # test for failure to initialize for backward compatibility
      if ((@font_metrics).nil?)
        return 0
      end
      return convert_width_in_chars_to_pixels(@font_metrics, chars)
    end
    
    typesig { [Composite, ::Java::Int, String, ::Java::Boolean] }
    # Creates a new button with the given id.
    # <p>
    # The <code>Dialog</code> implementation of this framework method creates
    # a standard push button, registers it for selection events including
    # button presses, and registers default buttons with its shell. The button
    # id is stored as the button's client data. If the button id is
    # <code>IDialogConstants.CANCEL_ID</code>, the new button will be
    # accessible from <code>getCancelButton()</code>. If the button id is
    # <code>IDialogConstants.OK_ID</code>, the new button will be accesible
    # from <code>getOKButton()</code>. Note that the parent's layout is
    # assumed to be a <code>GridLayout</code> and the number of columns in
    # this layout is incremented. Subclasses may override.
    # </p>
    # 
    # @param parent
    # the parent composite
    # @param id
    # the id of the button (see <code>IDialogConstants.*_ID</code>
    # constants for standard dialog button ids)
    # @param label
    # the label from the button
    # @param defaultButton
    # <code>true</code> if the button is to be the default button,
    # and <code>false</code> otherwise
    # 
    # @return the new button
    # 
    # @see #getCancelButton
    # @see #getOKButton()
    def create_button(parent, id, label, default_button)
      # increment the number of columns in the button bar
      (parent.get_layout).attr_num_columns += 1
      button = Button.new(parent, SWT::PUSH)
      button.set_text(label)
      button.set_font(JFaceResources.get_dialog_font)
      button.set_data(id)
      button.add_selection_listener(Class.new(SelectionAdapter.class == Class ? SelectionAdapter : Object) do
        extend LocalClass
        include_class_members Dialog
        include SelectionAdapter if SelectionAdapter.class == Module
        
        typesig { [SelectionEvent] }
        define_method :widget_selected do |event|
          button_pressed((event.attr_widget.get_data).int_value)
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      if (default_button)
        shell = parent.get_shell
        if (!(shell).nil?)
          shell.set_default_button(button)
        end
      end
      @buttons.put(id, button)
      set_button_layout_data(button)
      return button
    end
    
    typesig { [Composite] }
    # Creates and returns the contents of this dialog's button bar.
    # <p>
    # The <code>Dialog</code> implementation of this framework method lays
    # out a button bar and calls the <code>createButtonsForButtonBar</code>
    # framework method to populate it. Subclasses may override.
    # </p>
    # <p>
    # The returned control's layout data must be an instance of
    # <code>GridData</code>.
    # </p>
    # 
    # @param parent
    # the parent composite to contain the button bar
    # @return the button bar control
    def create_button_bar(parent)
      composite = Composite.new(parent, SWT::NONE)
      # create a layout with spacing and margins appropriate for the font
      # size.
      layout = GridLayout.new
      layout.attr_num_columns = 0 # this is incremented by createButton
      layout.attr_make_columns_equal_width = true
      layout.attr_margin_width = convert_horizontal_dlus_to_pixels(IDialogConstants::HORIZONTAL_MARGIN)
      layout.attr_margin_height = convert_vertical_dlus_to_pixels(IDialogConstants::VERTICAL_MARGIN)
      layout.attr_horizontal_spacing = convert_horizontal_dlus_to_pixels(IDialogConstants::HORIZONTAL_SPACING)
      layout.attr_vertical_spacing = convert_vertical_dlus_to_pixels(IDialogConstants::VERTICAL_SPACING)
      composite.set_layout(layout)
      data = GridData.new(GridData::HORIZONTAL_ALIGN_END | GridData::VERTICAL_ALIGN_CENTER)
      composite.set_layout_data(data)
      composite.set_font(parent.get_font)
      # Add the buttons to the button bar.
      create_buttons_for_button_bar(composite)
      return composite
    end
    
    typesig { [Composite] }
    # Adds buttons to this dialog's button bar.
    # <p>
    # The <code>Dialog</code> implementation of this framework method adds
    # standard ok and cancel buttons using the <code>createButton</code>
    # framework method. These standard buttons will be accessible from
    # <code>getCancelButton</code>, and <code>getOKButton</code>.
    # Subclasses may override.
    # </p>
    # 
    # @param parent
    # the button bar composite
    def create_buttons_for_button_bar(parent)
      # create OK and Cancel buttons by default
      create_button(parent, IDialogConstants::OK_ID, IDialogConstants::OK_LABEL, true)
      create_button(parent, IDialogConstants::CANCEL_ID, IDialogConstants::CANCEL_LABEL, false)
    end
    
    typesig { [] }
    # @see Window.initializeBounds()
    def initialize_bounds
      shell = get_shell
      if (!(shell).nil?)
        if ((shell.get_display.get_dismissal_alignment).equal?(SWT::RIGHT))
          # make the default button the right-most button
          default_button = shell.get_default_button
          if (!(default_button).nil? && is_contained(@button_bar, default_button))
            default_button.move_below(nil)
            (@button_bar).layout
          end
        end
      end
      super
    end
    
    typesig { [Control, Control] }
    # Returns true if the given Control is a direct or indirect child of
    # container.
    # 
    # @param container
    # the potential parent
    # @param control
    # @return boolean <code>true</code> if control is a child of container
    def is_contained(container, control)
      parent = nil
      while (!((parent = control.get_parent)).nil?)
        if ((parent).equal?(container))
          return true
        end
        control = parent
      end
      return false
    end
    
    typesig { [Composite] }
    # The <code>Dialog</code> implementation of this <code>Window</code>
    # method creates and lays out the top level composite for the dialog, and
    # determines the appropriate horizontal and vertical dialog units based on
    # the font size. It then calls the <code>createDialogArea</code> and
    # <code>createButtonBar</code> methods to create the dialog area and
    # button bar, respectively. Overriding <code>createDialogArea</code> and
    # <code>createButtonBar</code> are recommended rather than overriding
    # this method.
    def create_contents(parent)
      # create the top level composite for the dialog
      composite = Composite.new(parent, 0)
      layout = GridLayout.new
      layout.attr_margin_height = 0
      layout.attr_margin_width = 0
      layout.attr_vertical_spacing = 0
      composite.set_layout(layout)
      composite.set_layout_data(GridData.new(GridData::FILL_BOTH))
      apply_dialog_font(composite)
      # initialize the dialog units
      initialize_dialog_units(composite)
      # create the dialog area and button bar
      @dialog_area = create_dialog_area(composite)
      @button_bar = create_button_bar(composite)
      return composite
    end
    
    typesig { [Composite] }
    # Creates and returns the contents of the upper part of this dialog (above
    # the button bar).
    # <p>
    # The <code>Dialog</code> implementation of this framework method creates
    # and returns a new <code>Composite</code> with standard margins and
    # spacing.
    # </p>
    # <p>
    # The returned control's layout data must be an instance of
    # <code>GridData</code>. This method must not modify the parent's
    # layout.
    # </p>
    # <p>
    # Subclasses must override this method but may call <code>super</code> as
    # in the following example:
    # </p>
    # 
    # <pre>
    # Composite composite = (Composite) super.createDialogArea(parent);
    # //add controls to composite as necessary
    # return composite;
    # </pre>
    # 
    # @param parent
    # the parent composite to contain the dialog area
    # @return the dialog area control
    def create_dialog_area(parent)
      # create a composite with standard margins and spacing
      composite = Composite.new(parent, SWT::NONE)
      layout = GridLayout.new
      layout.attr_margin_height = convert_vertical_dlus_to_pixels(IDialogConstants::VERTICAL_MARGIN)
      layout.attr_margin_width = convert_horizontal_dlus_to_pixels(IDialogConstants::HORIZONTAL_MARGIN)
      layout.attr_vertical_spacing = convert_vertical_dlus_to_pixels(IDialogConstants::VERTICAL_SPACING)
      layout.attr_horizontal_spacing = convert_horizontal_dlus_to_pixels(IDialogConstants::HORIZONTAL_SPACING)
      composite.set_layout(layout)
      composite.set_layout_data(GridData.new(GridData::FILL_BOTH))
      apply_dialog_font(composite)
      return composite
    end
    
    typesig { [::Java::Int] }
    # Returns the button created by the method <code>createButton</code> for
    # the specified ID as defined on <code>IDialogConstants</code>. If
    # <code>createButton</code> was never called with this ID, or if
    # <code>createButton</code> is overridden, this method will return
    # <code>null</code>.
    # 
    # @param id
    # the id of the button to look for
    # 
    # @return the button for the ID or <code>null</code>
    # 
    # @see #createButton(Composite, int, String, boolean)
    # @since 2.0
    def get_button(id)
      return @buttons.get(id)
    end
    
    typesig { [] }
    # Returns the button bar control.
    # <p>
    # Clients may call this framework method, but should not override it.
    # </p>
    # 
    # @return the button bar, or <code>null</code> if the button bar has not
    # been created yet
    def get_button_bar
      return @button_bar
    end
    
    typesig { [] }
    # Returns the button created when <code>createButton</code> is called
    # with an ID of <code>IDialogConstants.CANCEL_ID</code>. If
    # <code>createButton</code> was never called with this parameter, or if
    # <code>createButton</code> is overridden, <code>getCancelButton</code>
    # will return <code>null</code>.
    # 
    # @return the cancel button or <code>null</code>
    # 
    # @see #createButton(Composite, int, String, boolean)
    # @since 2.0
    # @deprecated Use <code>getButton(IDialogConstants.CANCEL_ID)</code>
    # instead. This method will be removed soon.
    def get_cancel_button
      return get_button(IDialogConstants::CANCEL_ID)
    end
    
    typesig { [] }
    # Returns the dialog area control.
    # <p>
    # Clients may call this framework method, but should not override it.
    # </p>
    # 
    # @return the dialog area, or <code>null</code> if the dialog area has
    # not been created yet
    def get_dialog_area
      return @dialog_area
    end
    
    class_module.module_eval {
      typesig { [String] }
      # Returns the standard dialog image with the given key. Note that these
      # images are managed by the dialog framework, and must not be disposed by
      # another party.
      # 
      # @param key
      # one of the <code>Dialog.DLG_IMG_* </code> constants
      # @return the standard dialog image
      # 
      # NOTE: Dialog does not use the following images in the registry
      # DLG_IMG_ERROR DLG_IMG_INFO DLG_IMG_QUESTION DLG_IMG_WARNING
      # 
      # They are now coming directly from SWT, see ImageRegistry. For backwards
      # compatibility they are still supported, however new code should use SWT
      # for these.
      # 
      # @see Display#getSystemImage(int)
      def get_image(key)
        return JFaceResources.get_image_registry.get(key)
      end
    }
    
    typesig { [] }
    # Returns the button created when <code>createButton</code> is called
    # with an ID of <code>IDialogConstants.OK_ID</code>. If
    # <code>createButton</code> was never called with this parameter, or if
    # <code>createButton</code> is overridden, <code>getOKButton</code>
    # will return <code>null</code>.
    # 
    # @return the OK button or <code>null</code>
    # 
    # @see #createButton(Composite, int, String, boolean)
    # @since 2.0
    # @deprecated Use <code>getButton(IDialogConstants.OK_ID)</code> instead.
    # This method will be removed soon.
    def get_okbutton
      return get_button(IDialogConstants::OK_ID)
    end
    
    typesig { [Control] }
    # Initializes the computation of horizontal and vertical dialog units based
    # on the size of current font.
    # <p>
    # This method must be called before any of the dialog unit based conversion
    # methods are called.
    # </p>
    # 
    # @param control
    # a control from which to obtain the current font
    def initialize_dialog_units(control)
      # Compute and store a font metric
      gc = SwtGC.new(control)
      gc.set_font(JFaceResources.get_dialog_font)
      @font_metrics = gc.get_font_metrics
      gc.dispose
    end
    
    typesig { [] }
    # Notifies that the ok button of this dialog has been pressed.
    # <p>
    # The <code>Dialog</code> implementation of this framework method sets
    # this dialog's return code to <code>Window.OK</code> and closes the
    # dialog. Subclasses may override.
    # </p>
    def ok_pressed
      set_return_code(OK)
      close
    end
    
    typesig { [Button] }
    # Set the layout data of the button to a GridData with appropriate heights
    # and widths.
    # 
    # @param button
    def set_button_layout_data(button)
      data = GridData.new(GridData::HORIZONTAL_ALIGN_FILL)
      width_hint = convert_horizontal_dlus_to_pixels(IDialogConstants::BUTTON_WIDTH)
      min_size = button.compute_size(SWT::DEFAULT, SWT::DEFAULT, true)
      data.attr_width_hint = Math.max(width_hint, min_size.attr_x)
      button.set_layout_data(data)
    end
    
    typesig { [Button] }
    # Set the layout data of the button to a FormData with appropriate heights
    # and widths.
    # 
    # @param button
    def set_button_layout_form_data(button)
      data = FormData.new
      width_hint = convert_horizontal_dlus_to_pixels(IDialogConstants::BUTTON_WIDTH)
      min_size = button.compute_size(SWT::DEFAULT, SWT::DEFAULT, true)
      data.attr_width = Math.max(width_hint, min_size.attr_x)
      button.set_layout_data(data)
    end
    
    typesig { [] }
    # @see org.eclipse.jface.window.Window#close()
    def close
      if (!(get_shell).nil? && !get_shell.is_disposed)
        save_dialog_bounds(get_shell)
      end
      return_value = super
      if (return_value)
        @buttons = HashMap.new
        @button_bar = nil
        @dialog_area = nil
      end
      return return_value
    end
    
    class_module.module_eval {
      typesig { [Control] }
      # Applies the dialog font to all controls that currently have the default
      # font.
      # 
      # @param control
      # the control to apply the font to. Font will also be applied to
      # its children. If the control is <code>null</code> nothing
      # happens.
      def apply_dialog_font(control)
        if ((control).nil? || dialog_font_is_default)
          return
        end
        dialog_font = JFaceResources.get_dialog_font
        apply_dialog_font(control, dialog_font)
      end
      
      typesig { [Control, Font] }
      # Sets the dialog font on the control and any of its children if their font
      # is not otherwise set.
      # 
      # @param control
      # the control to apply the font to. Font will also be applied to
      # its children.
      # @param dialogFont
      # the dialog font to set
      def apply_dialog_font(control, dialog_font)
        if (has_default_font(control))
          control.set_font(dialog_font)
        end
        if (control.is_a?(Composite))
          children = (control).get_children
          i = 0
          while i < children.attr_length
            apply_dialog_font(children[i], dialog_font)
            i += 1
          end
        end
      end
      
      typesig { [Control] }
      # Return whether or not this control has the same font as it's default.
      # 
      # @param control
      # Control
      # @return boolean
      def has_default_font(control)
        control_font_data = control.get_font.get_font_data
        default_font_data = get_default_font(control).get_font_data
        if ((control_font_data.attr_length).equal?(default_font_data.attr_length))
          i = 0
          while i < control_font_data.attr_length
            if ((control_font_data[i] == default_font_data[i]))
              i += 1
              next
            end
            return false
            i += 1
          end
          return true
        end
        return false
      end
      
      typesig { [Control] }
      # Get the default font for this type of control.
      # 
      # @param control
      # @return the default font
      def get_default_font(control)
        font_name = "DEFAULT_FONT_" + RJava.cast_to_string(control.get_class.get_name) # $NON-NLS-1$
        if (JFaceResources.get_font_registry.has_value_for(font_name))
          return JFaceResources.get_font_registry.get(font_name)
        end
        cached = control.get_font
        control.set_font(nil)
        default_font = control.get_font
        control.set_font(cached)
        JFaceResources.get_font_registry.put(font_name, default_font.get_font_data)
        return default_font
      end
      
      typesig { [] }
      # Return whether or not the dialog font is currently the same as the
      # default font.
      # 
      # @return boolean if the two are the same
      def dialog_font_is_default
        dialog_font_data = JFaceResources.get_font_registry.get_font_data(JFaceResources::DIALOG_FONT)
        default_font_data = JFaceResources.get_font_registry.get_font_data(JFaceResources::DEFAULT_FONT)
        return (Arrays == dialog_font_data)
      end
    }
    
    typesig { [] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.window.Window#create()
    def create
      super
      apply_dialog_font(@button_bar)
    end
    
    class_module.module_eval {
      typesig { [] }
      # Get the IDialogBlockedHandler to be used by WizardDialogs and
      # ModalContexts.
      # 
      # @return Returns the blockedHandler.
      def get_blocked_handler
        return self.attr_blocked_handler
      end
      
      typesig { [IDialogBlockedHandler] }
      # Set the IDialogBlockedHandler to be used by WizardDialogs and
      # ModalContexts.
      # 
      # @param blockedHandler
      # The blockedHandler for the dialogs.
      def set_blocked_handler(blocked_handler)
        self.attr_blocked_handler = blocked_handler
      end
    }
    
    typesig { [] }
    # Gets the dialog settings that should be used for remembering the bounds of
    # of the dialog, according to the dialog bounds strategy.
    # 
    # @return settings the dialog settings used to store the dialog's location
    # and/or size, or <code>null</code> if the dialog's bounds should
    # never be stored.
    # 
    # @since 3.2
    # @see Dialog#getDialogBoundsStrategy()
    def get_dialog_bounds_settings
      return nil
    end
    
    typesig { [] }
    # Get the integer constant that describes the strategy for persisting the
    # dialog bounds. This strategy is ignored if the implementer does not also
    # specify the dialog settings for storing the bounds in
    # Dialog.getDialogBoundsSettings().
    # 
    # @return the constant describing the strategy for persisting the dialog
    # bounds.
    # 
    # @since 3.2
    # @see Dialog#DIALOG_PERSISTLOCATION
    # @see Dialog#DIALOG_PERSISTSIZE
    # @see Dialog#getDialogBoundsSettings()
    def get_dialog_bounds_strategy
      return DIALOG_PERSISTLOCATION | DIALOG_PERSISTSIZE
    end
    
    typesig { [Shell] }
    # Saves the bounds of the shell in the appropriate dialog settings. The
    # bounds are recorded relative to the parent shell, if there is one, or
    # display coordinates if there is no parent shell.
    # 
    # @param shell
    # The shell whose bounds are to be stored
    # 
    # @since 3.2
    def save_dialog_bounds(shell)
      settings = get_dialog_bounds_settings
      if (!(settings).nil?)
        shell_location = shell.get_location
        shell_size = shell.get_size
        parent = get_parent_shell
        if (!(parent).nil?)
          parent_location = parent.get_location
          shell_location.attr_x -= parent_location.attr_x
          shell_location.attr_y -= parent_location.attr_y
        end
        strategy = get_dialog_bounds_strategy
        if (!((strategy & DIALOG_PERSISTLOCATION)).equal?(0))
          settings.put(DIALOG_ORIGIN_X, shell_location.attr_x)
          settings.put(DIALOG_ORIGIN_Y, shell_location.attr_y)
        end
        if (!((strategy & DIALOG_PERSISTSIZE)).equal?(0))
          settings.put(DIALOG_WIDTH, shell_size.attr_x)
          settings.put(DIALOG_HEIGHT, shell_size.attr_y)
          font_datas = JFaceResources.get_dialog_font.get_font_data
          if (font_datas.attr_length > 0)
            settings.put(DIALOG_FONT_DATA, font_datas[0].to_s)
          end
        end
      end
    end
    
    typesig { [] }
    # Returns the initial size to use for the shell. Overridden
    # to check whether a size has been stored in dialog settings.
    # If a size has been stored, it is returned.
    # 
    # @return the initial size of the shell
    # 
    # @since 3.2
    # @see #getDialogBoundsSettings()
    # @see #getDialogBoundsStrategy()
    def get_initial_size
      result = super
      # Check the dialog settings for a stored size.
      if (!((get_dialog_bounds_strategy & DIALOG_PERSISTSIZE)).equal?(0))
        settings = get_dialog_bounds_settings
        if (!(settings).nil?)
          # Check that the dialog font matches the font used
          # when the bounds was stored.  If the font has changed,
          # we do not honor the stored settings.
          # See https://bugs.eclipse.org/bugs/show_bug.cgi?id=132821
          use_stored_bounds = true
          previous_dialog_font_data = settings.get(DIALOG_FONT_DATA)
          # There is a previously stored font, so we will check it.
          # Note that if we haven't stored the font before, then we will
          # use the stored bounds.  This allows restoring of dialog bounds
          # that were stored before we started storing the fontdata.
          if (!(previous_dialog_font_data).nil? && previous_dialog_font_data.length > 0)
            font_datas = JFaceResources.get_dialog_font.get_font_data
            if (font_datas.attr_length > 0)
              current_dialog_font_data = font_datas[0].to_s
              use_stored_bounds = current_dialog_font_data.equals_ignore_case(previous_dialog_font_data)
            end
          end
          if (use_stored_bounds)
            begin
              # Get the stored width and height.
              width = settings.get_int(DIALOG_WIDTH)
              if (!(width).equal?(DIALOG_DEFAULT_BOUNDS))
                result.attr_x = width
              end
              height = settings.get_int(DIALOG_HEIGHT)
              if (!(height).equal?(DIALOG_DEFAULT_BOUNDS))
                result.attr_y = height
              end
            rescue NumberFormatException => e
            end
          end
        end
      end
      # No attempt is made to constrain the bounds. The default
      # constraining behavior in Window will be used.
      return result
    end
    
    typesig { [Point] }
    # Returns the initial location to use for the shell. Overridden
    # to check whether the bounds of the dialog have been stored in
    # dialog settings.  If a location has been stored, it is returned.
    # 
    # @param initialSize
    # the initial size of the shell, as returned by
    # <code>getInitialSize</code>.
    # @return the initial location of the shell
    # 
    # @since 3.2
    # @see #getDialogBoundsSettings()
    # @see #getDialogBoundsStrategy()
    def get_initial_location(initial_size)
      result = super(initial_size)
      if (!((get_dialog_bounds_strategy & DIALOG_PERSISTLOCATION)).equal?(0))
        settings = get_dialog_bounds_settings
        if (!(settings).nil?)
          begin
            x = settings.get_int(DIALOG_ORIGIN_X)
            y = settings.get_int(DIALOG_ORIGIN_Y)
            result = Point.new(x, y)
            # The coordinates were stored relative to the parent shell.
            # Convert to display coordinates.
            parent = get_parent_shell
            if (!(parent).nil?)
              parent_location = parent.get_location
              result.attr_x += parent_location.attr_x
              result.attr_y += parent_location.attr_y
            end
          rescue NumberFormatException => e
          end
        end
      end
      # No attempt is made to constrain the bounds. The default
      # constraining behavior in Window will be used.
      return result
    end
    
    typesig { [] }
    # Returns a boolean indicating whether the dialog should be
    # considered resizable when the shell style is initially
    # set.
    # 
    # This method is used to ensure that all style
    # bits appropriate for resizable dialogs are added to the
    # shell style.  Individual dialogs may always set the shell
    # style to ensure that a dialog is resizable, but using this
    # method ensures that resizable dialogs will be created with
    # the same set of style bits.
    # 
    # Style bits will never be removed based on the return value
    # of this method.  For example, if a dialog returns
    # <code>false</code>, but also sets a style bit for a
    # SWT.RESIZE border, the style bit will be honored.
    # 
    # @return a boolean indicating whether the dialog is
    # resizable and should have the default style bits for
    # resizable dialogs
    # 
    # @since 3.4
    def is_resizable
      return false
    end
    
    private
    alias_method :initialize__dialog, :initialize
  end
  
end
