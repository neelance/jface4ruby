require "rjava"

# Copyright (c) 2000, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Dialogs
  module StatusDialogImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Dialogs
      include_const ::Org::Eclipse::Core::Runtime, :IStatus
      include_const ::Org::Eclipse::Core::Runtime, :Status
      include_const ::Org::Eclipse::Jface::Resource, :JFaceColors
      include_const ::Org::Eclipse::Jface::Resource, :JFaceResources
      include_const ::Org::Eclipse::Jface::Util, :Policy
      include_const ::Org::Eclipse::Jface::Util, :Util
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Custom, :CLabel
      include_const ::Org::Eclipse::Swt::Graphics, :Color
      include_const ::Org::Eclipse::Swt::Graphics, :Image
      include_const ::Org::Eclipse::Swt::Layout, :GridData
      include_const ::Org::Eclipse::Swt::Layout, :GridLayout
      include_const ::Org::Eclipse::Swt::Widgets, :Button
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Shell
    }
  end
  
  # An abstract base class for dialogs with a status bar and OK/CANCEL buttons.
  # The status message is specified in an IStatus which can be of severity ERROR,
  # WARNING, INFO or OK. The OK button is enabled or disabled depending on the
  # status.
  # 
  # @since 3.1
  class StatusDialog < StatusDialogImports.const_get :TrayDialog
    include_class_members StatusDialogImports
    
    attr_accessor :f_ok_button
    alias_method :attr_f_ok_button, :f_ok_button
    undef_method :f_ok_button
    alias_method :attr_f_ok_button=, :f_ok_button=
    undef_method :f_ok_button=
    
    attr_accessor :f_status_line
    alias_method :attr_f_status_line, :f_status_line
    undef_method :f_status_line
    alias_method :attr_f_status_line=, :f_status_line=
    undef_method :f_status_line=
    
    attr_accessor :f_last_status
    alias_method :attr_f_last_status, :f_last_status
    undef_method :f_last_status
    alias_method :attr_f_last_status=, :f_last_status=
    undef_method :f_last_status=
    
    attr_accessor :f_title
    alias_method :attr_f_title, :f_title
    undef_method :f_title
    alias_method :attr_f_title=, :f_title=
    undef_method :f_title=
    
    attr_accessor :f_image
    alias_method :attr_f_image, :f_image
    undef_method :f_image
    alias_method :attr_f_image=, :f_image=
    undef_method :f_image=
    
    attr_accessor :f_status_line_above_buttons
    alias_method :attr_f_status_line_above_buttons, :f_status_line_above_buttons
    undef_method :f_status_line_above_buttons
    alias_method :attr_f_status_line_above_buttons=, :f_status_line_above_buttons=
    undef_method :f_status_line_above_buttons=
    
    class_module.module_eval {
      # A message line displaying a status.
      const_set_lazy(:MessageLine) { Class.new(CLabel) do
        local_class_in StatusDialog
        include_class_members StatusDialog
        
        attr_accessor :f_normal_msg_area_background
        alias_method :attr_f_normal_msg_area_background, :f_normal_msg_area_background
        undef_method :f_normal_msg_area_background
        alias_method :attr_f_normal_msg_area_background=, :f_normal_msg_area_background=
        undef_method :f_normal_msg_area_background=
        
        typesig { [class_self::Composite] }
        # Creates a new message line as a child of the given parent.
        # 
        # @param parent
        def initialize(parent)
          initialize__message_line(parent, SWT::LEFT)
        end
        
        typesig { [class_self::Composite, ::Java::Int] }
        # Creates a new message line as a child of the parent and with the
        # given SWT stylebits.
        # 
        # @param parent
        # @param style
        def initialize(parent, style)
          @f_normal_msg_area_background = nil
          super(parent, style)
          @f_normal_msg_area_background = get_background
        end
        
        typesig { [class_self::IStatus] }
        # Find an image assocated with the status.
        # 
        # @param status
        # @return Image
        def find_image(status)
          if (status.is_ok)
            return nil
          else
            if (status.matches(IStatus::ERROR))
              return JFaceResources.get_image(Dialog::DLG_IMG_MESSAGE_ERROR)
            else
              if (status.matches(IStatus::WARNING))
                return JFaceResources.get_image(Dialog::DLG_IMG_MESSAGE_WARNING)
              else
                if (status.matches(IStatus::INFO))
                  return JFaceResources.get_image(Dialog::DLG_IMG_MESSAGE_INFO)
                end
              end
            end
          end
          return nil
        end
        
        typesig { [class_self::IStatus] }
        # Sets the message and image to the given status.
        # 
        # @param status
        # IStatus or <code>null</code>. <code>null</code> will
        # set the empty text and no image.
        def set_error_status(status)
          if (!(status).nil? && !status.is_ok)
            message = status.get_message
            if (!(message).nil? && message.length > 0)
              set_text(message)
              # unqualified call of setImage is too ambiguous for
              # Foundation 1.0 compiler
              # see https://bugs.eclipse.org/bugs/show_bug.cgi?id=140576
              self.set_image(find_image(status))
              set_background(JFaceColors.get_error_background(get_display))
              return
            end
          end
          set_text("") # $NON-NLS-1$
          # unqualified call of setImage is too ambiguous for Foundation 1.0
          # compiler
          # see https://bugs.eclipse.org/bugs/show_bug.cgi?id=140576
          self.set_image(nil)
          set_background(@f_normal_msg_area_background)
        end
        
        private
        alias_method :initialize__message_line, :initialize
      end }
    }
    
    typesig { [Shell] }
    # Creates an instance of a status dialog.
    # 
    # @param parent
    # the parent Shell of the dialog
    def initialize(parent)
      @f_ok_button = nil
      @f_status_line = nil
      @f_last_status = nil
      @f_title = nil
      @f_image = nil
      @f_status_line_above_buttons = false
      super(parent)
      @f_status_line_above_buttons = true
      @f_last_status = Status.new(IStatus::OK, Policy::JFACE, IStatus::OK, Util::ZERO_LENGTH_STRING, nil)
    end
    
    typesig { [::Java::Boolean] }
    # Specifies whether status line appears to the left of the buttons
    # (default) or above them.
    # 
    # @param aboveButtons
    # if <code>true</code> status line is placed above buttons; if
    # <code>false</code> to the right
    def set_status_line_above_buttons(above_buttons)
      @f_status_line_above_buttons = above_buttons
    end
    
    typesig { [IStatus] }
    # Update the dialog's status line to reflect the given status. It is safe
    # to call this method before the dialog has been opened.
    # 
    # @param status
    # the status to set
    def update_status(status)
      @f_last_status = status
      if (!(@f_status_line).nil? && !@f_status_line.is_disposed)
        update_buttons_enable_state(status)
        @f_status_line.set_error_status(status)
      end
    end
    
    typesig { [] }
    # Returns the last status.
    # 
    # @return IStatus
    def get_status
      return @f_last_status
    end
    
    typesig { [IStatus] }
    # Updates the status of the ok button to reflect the given status.
    # Subclasses may override this method to update additional buttons.
    # 
    # @param status
    # the status.
    def update_buttons_enable_state(status)
      if (!(@f_ok_button).nil? && !@f_ok_button.is_disposed)
        @f_ok_button.set_enabled(!status.matches(IStatus::ERROR))
      end
    end
    
    typesig { [Shell] }
    # @see Window#create(Shell)
    def configure_shell(shell)
      super(shell)
      if (!(@f_title).nil?)
        shell.set_text(@f_title)
      end
    end
    
    typesig { [] }
    # @see Window#create()
    def create
      super
      if (!(@f_last_status).nil?)
        # policy: dialogs are not allowed to come up with an error message
        if (@f_last_status.matches(IStatus::ERROR))
          # remove the message
          @f_last_status = Status.new(IStatus::ERROR, @f_last_status.get_plugin, @f_last_status.get_code, "", @f_last_status.get_exception) # $NON-NLS-1$
        end
        update_status(@f_last_status)
      end
    end
    
    typesig { [Composite] }
    # @see Dialog#createButtonsForButtonBar(Composite)
    def create_buttons_for_button_bar(parent)
      @f_ok_button = create_button(parent, IDialogConstants::OK_ID, IDialogConstants::OK_LABEL, true)
      create_button(parent, IDialogConstants::CANCEL_ID, IDialogConstants::CANCEL_LABEL, false)
    end
    
    typesig { [Composite] }
    # @see Dialog#createButtonBar(Composite)
    def create_button_bar(parent)
      composite = Composite.new(parent, SWT::NULL)
      layout = GridLayout.new
      if (@f_status_line_above_buttons)
        layout.attr_num_columns = 1
      else
        layout.attr_num_columns = 2
      end
      layout.attr_margin_height = 0
      layout.attr_margin_left = convert_horizontal_dlus_to_pixels(IDialogConstants::HORIZONTAL_MARGIN)
      layout.attr_margin_width = 0
      composite.set_layout(layout)
      composite.set_layout_data(GridData.new(GridData::FILL_HORIZONTAL))
      if (!@f_status_line_above_buttons && is_help_available)
        create_help_control(composite)
      end
      @f_status_line = MessageLine.new_local(self, composite)
      @f_status_line.set_alignment(SWT::LEFT)
      status_data = GridData.new(GridData::FILL_HORIZONTAL)
      @f_status_line.set_error_status(nil)
      if (@f_status_line_above_buttons && is_help_available)
        status_data.attr_horizontal_span = 2
        create_help_control(composite)
      end
      @f_status_line.set_layout_data(status_data)
      apply_dialog_font(composite)
      # Create the rest of the button bar, but tell it not to create a help
      # button (we've already created it).
      help_available = is_help_available
      set_help_available(false)
      super(composite)
      set_help_available(help_available)
      return composite
    end
    
    typesig { [String] }
    # Sets the title for this dialog.
    # 
    # @param title
    # the title.
    def set_title(title)
      @f_title = RJava.cast_to_string(!(title).nil? ? title : "") # $NON-NLS-1$
      shell = get_shell
      if ((!(shell).nil?) && !shell.is_disposed)
        shell.set_text(@f_title)
      end
    end
    
    typesig { [Image] }
    # Sets the image for this dialog.
    # 
    # @param image
    # the image.
    def set_image(image)
      @f_image = image
      shell = get_shell
      if ((!(shell).nil?) && !shell.is_disposed)
        shell.set_image(@f_image)
      end
    end
    
    private
    alias_method :initialize__status_dialog, :initialize
  end
  
end
