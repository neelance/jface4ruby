require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Dialogs
  module InputDialogImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Dialogs
      include_const ::Org::Eclipse::Jface::Resource, :StringConverter
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Events, :ModifyEvent
      include_const ::Org::Eclipse::Swt::Events, :ModifyListener
      include_const ::Org::Eclipse::Swt::Layout, :GridData
      include_const ::Org::Eclipse::Swt::Widgets, :Button
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Label
      include_const ::Org::Eclipse::Swt::Widgets, :Shell
      include_const ::Org::Eclipse::Swt::Widgets, :Text
    }
  end
  
  # A simple input dialog for soliciting an input string from the user.
  # <p>
  # This concrete dialog class can be instantiated as is, or further subclassed as
  # required.
  # </p>
  class InputDialog < InputDialogImports.const_get :Dialog
    include_class_members InputDialogImports
    
    # The title of the dialog.
    attr_accessor :title
    alias_method :attr_title, :title
    undef_method :title
    alias_method :attr_title=, :title=
    undef_method :title=
    
    # The message to display, or <code>null</code> if none.
    attr_accessor :message
    alias_method :attr_message, :message
    undef_method :message
    alias_method :attr_message=, :message=
    undef_method :message=
    
    # The input value; the empty string by default.
    attr_accessor :value
    alias_method :attr_value, :value
    undef_method :value
    alias_method :attr_value=, :value=
    undef_method :value=
    
    # $NON-NLS-1$
    # 
    # The input validator, or <code>null</code> if none.
    attr_accessor :validator
    alias_method :attr_validator, :validator
    undef_method :validator
    alias_method :attr_validator=, :validator=
    undef_method :validator=
    
    # Ok button widget.
    attr_accessor :ok_button
    alias_method :attr_ok_button, :ok_button
    undef_method :ok_button
    alias_method :attr_ok_button=, :ok_button=
    undef_method :ok_button=
    
    # Input text widget.
    attr_accessor :text
    alias_method :attr_text, :text
    undef_method :text
    alias_method :attr_text=, :text=
    undef_method :text=
    
    # Error message label widget.
    attr_accessor :error_message_text
    alias_method :attr_error_message_text, :error_message_text
    undef_method :error_message_text
    alias_method :attr_error_message_text=, :error_message_text=
    undef_method :error_message_text=
    
    # Error message string.
    attr_accessor :error_message
    alias_method :attr_error_message, :error_message
    undef_method :error_message
    alias_method :attr_error_message=, :error_message=
    undef_method :error_message=
    
    typesig { [Shell, String, String, String, IInputValidator] }
    # Creates an input dialog with OK and Cancel buttons. Note that the dialog
    # will have no visual representation (no widgets) until it is told to open.
    # <p>
    # Note that the <code>open</code> method blocks for input dialogs.
    # </p>
    # 
    # @param parentShell
    # the parent shell, or <code>null</code> to create a top-level
    # shell
    # @param dialogTitle
    # the dialog title, or <code>null</code> if none
    # @param dialogMessage
    # the dialog message, or <code>null</code> if none
    # @param initialValue
    # the initial input value, or <code>null</code> if none
    # (equivalent to the empty string)
    # @param validator
    # an input validator, or <code>null</code> if none
    def initialize(parent_shell, dialog_title, dialog_message, initial_value, validator)
      @title = nil
      @message = nil
      @value = nil
      @validator = nil
      @ok_button = nil
      @text = nil
      @error_message_text = nil
      @error_message = nil
      super(parent_shell)
      @value = ""
      @title = dialog_title
      @message = dialog_message
      if ((initial_value).nil?)
        @value = "" # $NON-NLS-1$
      else
        @value = initial_value
      end
      @validator = validator
    end
    
    typesig { [::Java::Int] }
    # (non-Javadoc) Method declared on Dialog.
    def button_pressed(button_id)
      if ((button_id).equal?(IDialogConstants::OK_ID))
        @value = RJava.cast_to_string(@text.get_text)
      else
        @value = RJava.cast_to_string(nil)
      end
      super(button_id)
    end
    
    typesig { [Shell] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.window.Window#configureShell(org.eclipse.swt.widgets.Shell)
    def configure_shell(shell)
      super(shell)
      if (!(@title).nil?)
        shell.set_text(@title)
      end
    end
    
    typesig { [Composite] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.dialogs.Dialog#createButtonsForButtonBar(org.eclipse.swt.widgets.Composite)
    def create_buttons_for_button_bar(parent)
      # create OK and Cancel buttons by default
      @ok_button = create_button(parent, IDialogConstants::OK_ID, IDialogConstants::OK_LABEL, true)
      create_button(parent, IDialogConstants::CANCEL_ID, IDialogConstants::CANCEL_LABEL, false)
      # do this here because setting the text will set enablement on the ok
      # button
      @text.set_focus
      if (!(@value).nil?)
        @text.set_text(@value)
        @text.select_all
      end
    end
    
    typesig { [Composite] }
    # (non-Javadoc) Method declared on Dialog.
    def create_dialog_area(parent)
      # create composite
      composite = super(parent)
      # create message
      if (!(@message).nil?)
        label = Label.new(composite, SWT::WRAP)
        label.set_text(@message)
        data = GridData.new(GridData::GRAB_HORIZONTAL | GridData::GRAB_VERTICAL | GridData::HORIZONTAL_ALIGN_FILL | GridData::VERTICAL_ALIGN_CENTER)
        data.attr_width_hint = convert_horizontal_dlus_to_pixels(IDialogConstants::MINIMUM_MESSAGE_AREA_WIDTH)
        label.set_layout_data(data)
        label.set_font(parent.get_font)
      end
      @text = Text.new(composite, get_input_text_style)
      @text.set_layout_data(GridData.new(GridData::GRAB_HORIZONTAL | GridData::HORIZONTAL_ALIGN_FILL))
      @text.add_modify_listener(Class.new(ModifyListener.class == Class ? ModifyListener : Object) do
        local_class_in InputDialog
        include_class_members InputDialog
        include ModifyListener if ModifyListener.class == Module
        
        typesig { [ModifyEvent] }
        define_method :modify_text do |e|
          validate_input
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      @error_message_text = Text.new(composite, SWT::READ_ONLY | SWT::WRAP)
      @error_message_text.set_layout_data(GridData.new(GridData::GRAB_HORIZONTAL | GridData::HORIZONTAL_ALIGN_FILL))
      @error_message_text.set_background(@error_message_text.get_display.get_system_color(SWT::COLOR_WIDGET_BACKGROUND))
      # Set the error message text
      # See https://bugs.eclipse.org/bugs/show_bug.cgi?id=66292
      set_error_message(@error_message)
      apply_dialog_font(composite)
      return composite
    end
    
    typesig { [] }
    # Returns the error message label.
    # 
    # @return the error message label
    # @deprecated use setErrorMessage(String) instead
    def get_error_message_label
      return nil
    end
    
    typesig { [] }
    # Returns the ok button.
    # 
    # @return the ok button
    def get_ok_button
      return @ok_button
    end
    
    typesig { [] }
    # Returns the text area.
    # 
    # @return the text area
    def get_text
      return @text
    end
    
    typesig { [] }
    # Returns the validator.
    # 
    # @return the validator
    def get_validator
      return @validator
    end
    
    typesig { [] }
    # Returns the string typed into this input dialog.
    # 
    # @return the input string
    def get_value
      return @value
    end
    
    typesig { [] }
    # Validates the input.
    # <p>
    # The default implementation of this framework method delegates the request
    # to the supplied input validator object; if it finds the input invalid,
    # the error message is displayed in the dialog's message line. This hook
    # method is called whenever the text changes in the input field.
    # </p>
    def validate_input
      error_message = nil
      if (!(@validator).nil?)
        error_message = RJava.cast_to_string(@validator.is_valid(@text.get_text))
      end
      # Bug 16256: important not to treat "" (blank error) the same as null
      # (no error)
      set_error_message(error_message)
    end
    
    typesig { [String] }
    # Sets or clears the error message.
    # If not <code>null</code>, the OK button is disabled.
    # 
    # @param errorMessage
    # the error message, or <code>null</code> to clear
    # @since 3.0
    def set_error_message(error_message)
      @error_message = error_message
      if (!(@error_message_text).nil? && !@error_message_text.is_disposed)
        @error_message_text.set_text((error_message).nil? ? " \n " : error_message) # $NON-NLS-1$
        # Disable the error message text control if there is no error, or
        # no error text (empty or whitespace only).  Hide it also to avoid
        # color change.
        # See https://bugs.eclipse.org/bugs/show_bug.cgi?id=130281
        has_error = !(error_message).nil? && (StringConverter.remove_white_spaces(error_message)).length > 0
        @error_message_text.set_enabled(has_error)
        @error_message_text.set_visible(has_error)
        @error_message_text.get_parent.update
        # Access the ok button by id, in case clients have overridden button creation.
        # See https://bugs.eclipse.org/bugs/show_bug.cgi?id=113643
        button = get_button(IDialogConstants::OK_ID)
        if (!(button).nil?)
          button.set_enabled((error_message).nil?)
        end
      end
    end
    
    typesig { [] }
    # Returns the style bits that should be used for the input text field.
    # Defaults to a single line entry. Subclasses may override.
    # 
    # @return the integer style bits that should be used when creating the
    # input text
    # 
    # @since 3.4
    def get_input_text_style
      return SWT::SINGLE | SWT::BORDER
    end
    
    private
    alias_method :initialize__input_dialog, :initialize
  end
  
end
