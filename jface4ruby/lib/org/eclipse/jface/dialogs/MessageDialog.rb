require "rjava"

# Copyright (c) 2000, 2009 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Dialogs
  module MessageDialogImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Dialogs
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Custom, :CLabel
      include_const ::Org::Eclipse::Swt::Graphics, :Image
      include_const ::Org::Eclipse::Swt::Layout, :GridData
      include_const ::Org::Eclipse::Swt::Layout, :GridLayout
      include_const ::Org::Eclipse::Swt::Widgets, :Button
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Label
      include_const ::Org::Eclipse::Swt::Widgets, :Shell
    }
  end
  
  # A dialog for showing messages to the user.
  # <p>
  # This concrete dialog class can be instantiated as is, or further subclassed
  # as required.
  # </p>
  class MessageDialog < MessageDialogImports.const_get :IconAndMessageDialog
    include_class_members MessageDialogImports
    
    class_module.module_eval {
      # Constant for no image (value 0).
      # 
      # @see #MessageDialog(Shell, String, Image, String, int, String[], int)
      const_set_lazy(:NONE) { 0 }
      const_attr_reader  :NONE
      
      # Constant for the error image, or a simple dialog with the error image and a single OK button (value 1).
      # 
      # @see #MessageDialog(Shell, String, Image, String, int, String[], int)
      # @see #open(int, Shell, String, String, int)
      const_set_lazy(:ERROR) { 1 }
      const_attr_reader  :ERROR
      
      # Constant for the info image, or a simple dialog with the info image and a single OK button (value 2).
      # 
      # @see #MessageDialog(Shell, String, Image, String, int, String[], int)
      # @see #open(int, Shell, String, String, int)
      const_set_lazy(:INFORMATION) { 2 }
      const_attr_reader  :INFORMATION
      
      # Constant for the question image, or a simple dialog with the question image and Yes/No buttons (value 3).
      # 
      # @see #MessageDialog(Shell, String, Image, String, int, String[], int)
      # @see #open(int, Shell, String, String, int)
      const_set_lazy(:QUESTION) { 3 }
      const_attr_reader  :QUESTION
      
      # Constant for the warning image, or a simple dialog with the warning image and a single OK button (value 4).
      # 
      # @see #MessageDialog(Shell, String, Image, String, int, String[], int)
      # @see #open(int, Shell, String, String, int)
      const_set_lazy(:WARNING) { 4 }
      const_attr_reader  :WARNING
      
      # Constant for a simple dialog with the question image and OK/Cancel buttons (value 5).
      # 
      # @see #open(int, Shell, String, String, int)
      # @since 3.5
      const_set_lazy(:CONFIRM) { 5 }
      const_attr_reader  :CONFIRM
      
      # Constant for a simple dialog with the question image and Yes/No/Cancel buttons (value 6).
      # 
      # @see #open(int, Shell, String, String, int)
      # @since 3.5
      const_set_lazy(:QUESTION_WITH_CANCEL) { 6 }
      const_attr_reader  :QUESTION_WITH_CANCEL
    }
    
    # Labels for buttons in the button bar (localized strings).
    attr_accessor :button_labels
    alias_method :attr_button_labels, :button_labels
    undef_method :button_labels
    alias_method :attr_button_labels=, :button_labels=
    undef_method :button_labels=
    
    # The buttons. Parallels <code>buttonLabels</code>.
    attr_accessor :buttons
    alias_method :attr_buttons, :buttons
    undef_method :buttons
    alias_method :attr_buttons=, :buttons=
    undef_method :buttons=
    
    # Index into <code>buttonLabels</code> of the default button.
    attr_accessor :default_button_index
    alias_method :attr_default_button_index, :default_button_index
    undef_method :default_button_index
    alias_method :attr_default_button_index=, :default_button_index=
    undef_method :default_button_index=
    
    # Dialog title (a localized string).
    attr_accessor :title
    alias_method :attr_title, :title
    undef_method :title
    alias_method :attr_title=, :title=
    undef_method :title=
    
    # Dialog title image.
    attr_accessor :title_image
    alias_method :attr_title_image, :title_image
    undef_method :title_image
    alias_method :attr_title_image=, :title_image=
    undef_method :title_image=
    
    # Image, or <code>null</code> if none.
    attr_accessor :image
    alias_method :attr_image, :image
    undef_method :image
    alias_method :attr_image=, :image=
    undef_method :image=
    
    # The custom dialog area.
    attr_accessor :custom_area
    alias_method :attr_custom_area, :custom_area
    undef_method :custom_area
    alias_method :attr_custom_area=, :custom_area=
    undef_method :custom_area=
    
    typesig { [Shell, String, Image, String, ::Java::Int, Array.typed(String), ::Java::Int] }
    # Create a message dialog. Note that the dialog will have no visual
    # representation (no widgets) until it is told to open.
    # <p>
    # The labels of the buttons to appear in the button bar are supplied in
    # this constructor as an array. The <code>open</code> method will return
    # the index of the label in this array corresponding to the button that was
    # pressed to close the dialog.
    # </p>
    # <p>
    # <strong>Note:</strong> If the dialog was dismissed without pressing
    # a button (ESC key, close box, etc.) then {@link SWT#DEFAULT} is returned.
    # Note that the <code>open</code> method blocks.
    # </p>
    # 
    # @param parentShell
    # the parent shell
    # @param dialogTitle
    # the dialog title, or <code>null</code> if none
    # @param dialogTitleImage
    # the dialog title image, or <code>null</code> if none
    # @param dialogMessage
    # the dialog message
    # @param dialogImageType
    # one of the following values:
    # <ul>
    # <li><code>MessageDialog.NONE</code> for a dialog with no
    # image</li>
    # <li><code>MessageDialog.ERROR</code> for a dialog with an
    # error image</li>
    # <li><code>MessageDialog.INFORMATION</code> for a dialog
    # with an information image</li>
    # <li><code>MessageDialog.QUESTION </code> for a dialog with a
    # question image</li>
    # <li><code>MessageDialog.WARNING</code> for a dialog with a
    # warning image</li>
    # </ul>
    # @param dialogButtonLabels
    # an array of labels for the buttons in the button bar
    # @param defaultIndex
    # the index in the button label array of the default button
    def initialize(parent_shell, dialog_title, dialog_title_image, dialog_message, dialog_image_type, dialog_button_labels, default_index)
      @button_labels = nil
      @buttons = nil
      @default_button_index = 0
      @title = nil
      @title_image = nil
      @image = nil
      @custom_area = nil
      super(parent_shell)
      @image = nil
      @title = dialog_title
      @title_image = dialog_title_image
      self.attr_message = dialog_message
      case (dialog_image_type)
      when ERROR
        @image = get_error_image
      when INFORMATION
        @image = get_info_image
      when QUESTION, QUESTION_WITH_CANCEL, CONFIRM
        @image = get_question_image
      when WARNING
        @image = get_warning_image
      end
      @button_labels = dialog_button_labels
      @default_button_index = default_index
    end
    
    typesig { [::Java::Int] }
    # (non-Javadoc)
    # @see org.eclipse.jface.dialogs.Dialog#buttonPressed(int)
    def button_pressed(button_id)
      set_return_code(button_id)
      close
    end
    
    typesig { [Shell] }
    # (non-Javadoc)
    # @see org.eclipse.jface.window.Window#configureShell(org.eclipse.swt.widgets.Shell)
    def configure_shell(shell)
      super(shell)
      if (!(@title).nil?)
        shell.set_text(@title)
      end
      if (!(@title_image).nil?)
        shell.set_image(@title_image)
      end
    end
    
    typesig { [Composite] }
    # (non-Javadoc) Method declared on Dialog.
    def create_buttons_for_button_bar(parent)
      @buttons = Array.typed(Button).new(@button_labels.attr_length) { nil }
      i = 0
      while i < @button_labels.attr_length
        label = @button_labels[i]
        button = create_button(parent, i, label, (@default_button_index).equal?(i))
        @buttons[i] = button
        i += 1
      end
    end
    
    typesig { [Composite] }
    # Creates and returns the contents of an area of the dialog which appears
    # below the message and above the button bar.
    # <p>
    # The default implementation of this framework method returns
    # <code>null</code>. Subclasses may override.
    # </p>
    # 
    # @param parent
    # parent composite to contain the custom area
    # @return the custom area control, or <code>null</code>
    def create_custom_area(parent)
      return nil
    end
    
    typesig { [Composite] }
    # This implementation of the <code>Dialog</code> framework method creates
    # and lays out a composite and calls <code>createMessageArea</code> and
    # <code>createCustomArea</code> to populate it. Subclasses should
    # override <code>createCustomArea</code> to add contents below the
    # message.
    def create_dialog_area(parent)
      # create message area
      create_message_area(parent)
      # create the top level composite for the dialog area
      composite = Composite.new(parent, SWT::NONE)
      layout = GridLayout.new
      layout.attr_margin_height = 0
      layout.attr_margin_width = 0
      composite.set_layout(layout)
      data = GridData.new(GridData::FILL_BOTH)
      data.attr_horizontal_span = 2
      composite.set_layout_data(data)
      # allow subclasses to add custom controls
      @custom_area = create_custom_area(composite)
      # If it is null create a dummy label for spacing purposes
      if ((@custom_area).nil?)
        @custom_area = Label.new(composite, SWT::NULL)
      end
      return composite
    end
    
    typesig { [::Java::Int] }
    # Gets a button in this dialog's button bar.
    # 
    # @param index
    # the index of the button in the dialog's button bar
    # @return a button in the dialog's button bar
    def get_button(index)
      return @buttons[index]
    end
    
    typesig { [] }
    # Returns the minimum message area width in pixels This determines the
    # minimum width of the dialog.
    # <p>
    # Subclasses may override.
    # </p>
    # 
    # @return the minimum message area width (in pixels)
    def get_minimum_message_width
      return convert_horizontal_dlus_to_pixels(IDialogConstants::MINIMUM_MESSAGE_AREA_WIDTH)
    end
    
    typesig { [] }
    # Handle the shell close. Set the return code to <code>SWT.DEFAULT</code>
    # as there has been no explicit close by the user.
    # 
    # @see org.eclipse.jface.window.Window#handleShellCloseEvent()
    def handle_shell_close_event
      # Sets a return code of SWT.DEFAULT since none of the dialog buttons
      # were pressed to close the dialog.
      super
      set_return_code(SWT::DEFAULT)
    end
    
    typesig { [] }
    # Opens this message dialog, creating it first if it has not yet been created.
    # <p>
    # This method waits until the dialog is closed by the end user, and then it
    # returns the dialog's return code. The dialog's return code is either the
    # index of the button the user pressed, or {@link SWT#DEFAULT} if the dialog
    # has been closed by other means.
    # </p>
    # 
    # @return the return code
    # 
    # @see org.eclipse.jface.window.Window#open()
    def open
      return super
    end
    
    class_module.module_eval {
      typesig { [::Java::Int, Shell, String, String, ::Java::Int] }
      # Convenience method to open a simple dialog as specified by the
      # <code>kind</code> flag.
      # 
      # @param kind
      # the kind of dialog to open, one of {@link #ERROR},
      # {@link #INFORMATION}, {@link #QUESTION}, {@link #WARNING},
      # {@link #CONFIRM}, or {@link #QUESTION_WITH_CANCEL}.
      # @param parent
      # the parent shell of the dialog, or <code>null</code> if none
      # @param title
      # the dialog's title, or <code>null</code> if none
      # @param message
      # the message
      # @param style
      # {@link SWT#NONE} for a default dialog, or {@link SWT#SHEET} for
      # a dialog with sheet behavior
      # @return <code>true</code> if the user presses the OK or Yes button,
      # <code>false</code> otherwise
      # @since 3.5
      def open(kind, parent, title, message, style)
        dialog = MessageDialog.new(parent, title, nil, message, kind, get_button_labels(kind), 0)
        style &= SWT::SHEET
        dialog.set_shell_style(dialog.get_shell_style | style)
        return (dialog.open).equal?(0)
      end
      
      typesig { [::Java::Int] }
      # @param kind
      # @return
      def get_button_labels(kind)
        dialog_button_labels = nil
        case (kind)
        when ERROR, INFORMATION, WARNING
          dialog_button_labels = Array.typed(String).new([IDialogConstants::OK_LABEL])
        when CONFIRM
          dialog_button_labels = Array.typed(String).new([IDialogConstants::OK_LABEL, IDialogConstants::CANCEL_LABEL])
        when QUESTION
          dialog_button_labels = Array.typed(String).new([IDialogConstants::YES_LABEL, IDialogConstants::NO_LABEL])
        when QUESTION_WITH_CANCEL
          dialog_button_labels = Array.typed(String).new([IDialogConstants::YES_LABEL, IDialogConstants::NO_LABEL, IDialogConstants::CANCEL_LABEL])
        else
          raise IllegalArgumentException.new("Illegal value for kind in MessageDialog.open()") # $NON-NLS-1$
        end
        return dialog_button_labels
      end
      
      typesig { [Shell, String, String] }
      # Convenience method to open a simple confirm (OK/Cancel) dialog.
      # 
      # @param parent
      # the parent shell of the dialog, or <code>null</code> if none
      # @param title
      # the dialog's title, or <code>null</code> if none
      # @param message
      # the message
      # @return <code>true</code> if the user presses the OK button,
      # <code>false</code> otherwise
      def open_confirm(parent, title, message)
        return open(CONFIRM, parent, title, message, SWT::NONE)
      end
      
      typesig { [Shell, String, String] }
      # Convenience method to open a standard error dialog.
      # 
      # @param parent
      # the parent shell of the dialog, or <code>null</code> if none
      # @param title
      # the dialog's title, or <code>null</code> if none
      # @param message
      # the message
      def open_error(parent, title, message)
        open(ERROR, parent, title, message, SWT::NONE)
      end
      
      typesig { [Shell, String, String] }
      # Convenience method to open a standard information dialog.
      # 
      # @param parent
      # the parent shell of the dialog, or <code>null</code> if none
      # @param title
      # the dialog's title, or <code>null</code> if none
      # @param message
      # the message
      def open_information(parent, title, message)
        open(INFORMATION, parent, title, message, SWT::NONE)
      end
      
      typesig { [Shell, String, String] }
      # Convenience method to open a simple Yes/No question dialog.
      # 
      # @param parent
      # the parent shell of the dialog, or <code>null</code> if none
      # @param title
      # the dialog's title, or <code>null</code> if none
      # @param message
      # the message
      # @return <code>true</code> if the user presses the Yes button,
      # <code>false</code> otherwise
      def open_question(parent, title, message)
        return open(QUESTION, parent, title, message, SWT::NONE)
      end
      
      typesig { [Shell, String, String] }
      # Convenience method to open a standard warning dialog.
      # 
      # @param parent
      # the parent shell of the dialog, or <code>null</code> if none
      # @param title
      # the dialog's title, or <code>null</code> if none
      # @param message
      # the message
      def open_warning(parent, title, message)
        open(WARNING, parent, title, message, SWT::NONE)
      end
    }
    
    typesig { [Composite, ::Java::Int, String, ::Java::Boolean] }
    # @see org.eclipse.jface.dialogs.Dialog#createButton(org.eclipse.swt.widgets.Composite,
    # int, java.lang.String, boolean)
    def create_button(parent, id, label, default_button)
      button = super(parent, id, label, default_button)
      # Be sure to set the focus if the custom area cannot so as not
      # to lose the defaultButton.
      if (default_button && !custom_should_take_focus)
        button.set_focus
      end
      return button
    end
    
    typesig { [] }
    # Return whether or not we should apply the workaround where we take focus
    # for the default button or if that should be determined by the dialog. By
    # default only return true if the custom area is a label or CLabel that
    # cannot take focus.
    # 
    # @return boolean
    def custom_should_take_focus
      if (@custom_area.is_a?(Label))
        return false
      end
      if (@custom_area.is_a?(CLabel))
        return (@custom_area.get_style & SWT::NO_FOCUS) > 0
      end
      return true
    end
    
    typesig { [] }
    # (non-Javadoc)
    # @see org.eclipse.jface.dialogs.IconAndMessageDialog#getImage()
    def get_image
      return @image
    end
    
    typesig { [] }
    # An accessor for the labels to use on the buttons.
    # 
    # @return The button labels to used; never <code>null</code>.
    def get_button_labels
      return @button_labels
    end
    
    typesig { [] }
    # An accessor for the index of the default button in the button array.
    # 
    # @return The default button index.
    def get_default_button_index
      return @default_button_index
    end
    
    typesig { [Array.typed(Button)] }
    # A mutator for the array of buttons in the button bar.
    # 
    # @param buttons
    # The buttons in the button bar; must not be <code>null</code>.
    def set_buttons(buttons)
      if ((buttons).nil?)
        raise NullPointerException.new("The array of buttons cannot be null.")
      end # $NON-NLS-1$
      @buttons = buttons
    end
    
    typesig { [Array.typed(String)] }
    # A mutator for the button labels.
    # 
    # @param buttonLabels
    # The button labels to use; must not be <code>null</code>.
    def set_button_labels(button_labels)
      if ((button_labels).nil?)
        raise NullPointerException.new("The array of button labels cannot be null.")
      end # $NON-NLS-1$
      @button_labels = button_labels
    end
    
    private
    alias_method :initialize__message_dialog, :initialize
  end
  
end
