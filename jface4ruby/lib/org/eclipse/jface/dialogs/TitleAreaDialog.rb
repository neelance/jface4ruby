require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
# Konstantin Scheglov <scheglov_ke@nlmk.ru > - Fix for bug 41172
# [Dialogs] Bug with Image in TitleAreaDialog
# Sebastian Davids <sdavids@gmx.de> - Fix for bug 82064
# [Dialogs] TitleAreaDialog#setTitleImage cannot be called before open()
module Org::Eclipse::Jface::Dialogs
  module TitleAreaDialogImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Dialogs
      include_const ::Org::Eclipse::Jface::Resource, :JFaceColors
      include_const ::Org::Eclipse::Jface::Resource, :JFaceResources
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Events, :DisposeEvent
      include_const ::Org::Eclipse::Swt::Events, :DisposeListener
      include_const ::Org::Eclipse::Swt::Graphics, :Color
      include_const ::Org::Eclipse::Swt::Graphics, :Image
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Graphics, :RGB
      include_const ::Org::Eclipse::Swt::Layout, :FormAttachment
      include_const ::Org::Eclipse::Swt::Layout, :FormData
      include_const ::Org::Eclipse::Swt::Layout, :FormLayout
      include_const ::Org::Eclipse::Swt::Layout, :GridData
      include_const ::Org::Eclipse::Swt::Layout, :GridLayout
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Display
      include_const ::Org::Eclipse::Swt::Widgets, :Label
      include_const ::Org::Eclipse::Swt::Widgets, :Shell
      include_const ::Org::Eclipse::Swt::Widgets, :Text
    }
  end
  
  # A dialog that has a title area for displaying a title and an image as well as
  # a common area for displaying a description, a message, or an error message.
  # <p>
  # This dialog class may be subclassed.
  class TitleAreaDialog < TitleAreaDialogImports.const_get :TrayDialog
    include_class_members TitleAreaDialogImports
    
    class_module.module_eval {
      # Image registry key for error message image.
      const_set_lazy(:DLG_IMG_TITLE_ERROR) { DLG_IMG_MESSAGE_ERROR }
      const_attr_reader  :DLG_IMG_TITLE_ERROR
      
      # Image registry key for banner image (value
      # <code>"dialog_title_banner_image"</code>).
      const_set_lazy(:DLG_IMG_TITLE_BANNER) { "dialog_title_banner_image" }
      const_attr_reader  :DLG_IMG_TITLE_BANNER
      
      # $NON-NLS-1$
      # 
      # Message type constant used to display an info icon with the message.
      # 
      # @since 2.0
      # @deprecated
      const_set_lazy(:INFO_MESSAGE) { "INFO_MESSAGE" }
      const_attr_reader  :INFO_MESSAGE
      
      # $NON-NLS-1$
      # 
      # Message type constant used to display a warning icon with the message.
      # 
      # @since 2.0
      # @deprecated
      const_set_lazy(:WARNING_MESSAGE) { "WARNING_MESSAGE" }
      const_attr_reader  :WARNING_MESSAGE
      
      # $NON-NLS-1$
      # Space between an image and a label
      const_set_lazy(:H_GAP_IMAGE) { 5 }
      const_attr_reader  :H_GAP_IMAGE
      
      # Minimum dialog width (in dialog units)
      const_set_lazy(:MIN_DIALOG_WIDTH) { 350 }
      const_attr_reader  :MIN_DIALOG_WIDTH
      
      # Minimum dialog height (in dialog units)
      const_set_lazy(:MIN_DIALOG_HEIGHT) { 150 }
      const_attr_reader  :MIN_DIALOG_HEIGHT
    }
    
    attr_accessor :title_label
    alias_method :attr_title_label, :title_label
    undef_method :title_label
    alias_method :attr_title_label=, :title_label=
    undef_method :title_label=
    
    attr_accessor :title_image_label
    alias_method :attr_title_image_label, :title_image_label
    undef_method :title_image_label
    alias_method :attr_title_image_label=, :title_image_label=
    undef_method :title_image_label=
    
    attr_accessor :bottom_filler_label
    alias_method :attr_bottom_filler_label, :bottom_filler_label
    undef_method :bottom_filler_label
    alias_method :attr_bottom_filler_label=, :bottom_filler_label=
    undef_method :bottom_filler_label=
    
    attr_accessor :left_filler_label
    alias_method :attr_left_filler_label, :left_filler_label
    undef_method :left_filler_label
    alias_method :attr_left_filler_label=, :left_filler_label=
    undef_method :left_filler_label=
    
    attr_accessor :title_area_rgb
    alias_method :attr_title_area_rgb, :title_area_rgb
    undef_method :title_area_rgb
    alias_method :attr_title_area_rgb=, :title_area_rgb=
    undef_method :title_area_rgb=
    
    attr_accessor :title_area_color
    alias_method :attr_title_area_color, :title_area_color
    undef_method :title_area_color
    alias_method :attr_title_area_color=, :title_area_color=
    undef_method :title_area_color=
    
    attr_accessor :message
    alias_method :attr_message, :message
    undef_method :message
    alias_method :attr_message=, :message=
    undef_method :message=
    
    # $NON-NLS-1$
    attr_accessor :error_message
    alias_method :attr_error_message, :error_message
    undef_method :error_message
    alias_method :attr_error_message=, :error_message=
    undef_method :error_message=
    
    attr_accessor :message_label
    alias_method :attr_message_label, :message_label
    undef_method :message_label
    alias_method :attr_message_label=, :message_label=
    undef_method :message_label=
    
    attr_accessor :work_area
    alias_method :attr_work_area, :work_area
    undef_method :work_area
    alias_method :attr_work_area=, :work_area=
    undef_method :work_area=
    
    attr_accessor :message_image_label
    alias_method :attr_message_image_label, :message_image_label
    undef_method :message_image_label
    alias_method :attr_message_image_label=, :message_image_label=
    undef_method :message_image_label=
    
    attr_accessor :message_image
    alias_method :attr_message_image, :message_image
    undef_method :message_image
    alias_method :attr_message_image=, :message_image=
    undef_method :message_image=
    
    attr_accessor :showing_error
    alias_method :attr_showing_error, :showing_error
    undef_method :showing_error
    alias_method :attr_showing_error=, :showing_error=
    undef_method :showing_error=
    
    attr_accessor :title_image_largest
    alias_method :attr_title_image_largest, :title_image_largest
    undef_method :title_image_largest
    alias_method :attr_title_image_largest=, :title_image_largest=
    undef_method :title_image_largest=
    
    attr_accessor :message_label_height
    alias_method :attr_message_label_height, :message_label_height
    undef_method :message_label_height
    alias_method :attr_message_label_height=, :message_label_height=
    undef_method :message_label_height=
    
    attr_accessor :title_area_image
    alias_method :attr_title_area_image, :title_area_image
    undef_method :title_area_image
    alias_method :attr_title_area_image=, :title_area_image=
    undef_method :title_area_image=
    
    typesig { [Shell] }
    # Instantiate a new title area dialog.
    # 
    # @param parentShell
    # the parent SWT shell
    def initialize(parent_shell)
      @title_label = nil
      @title_image_label = nil
      @bottom_filler_label = nil
      @left_filler_label = nil
      @title_area_rgb = nil
      @title_area_color = nil
      @message = nil
      @error_message = nil
      @message_label = nil
      @work_area = nil
      @message_image_label = nil
      @message_image = nil
      @showing_error = false
      @title_image_largest = false
      @message_label_height = 0
      @title_area_image = nil
      super(parent_shell)
      @message = ""
      @showing_error = false
      @title_image_largest = true
    end
    
    typesig { [Composite] }
    # @see Dialog.createContents(Composite)
    def create_contents(parent)
      # create the overall composite
      contents = Composite.new(parent, SWT::NONE)
      contents.set_layout_data(GridData.new(GridData::FILL_BOTH))
      # initialize the dialog units
      initialize_dialog_units(contents)
      layout = FormLayout.new
      contents.set_layout(layout)
      # Now create a work area for the rest of the dialog
      @work_area = Composite.new(contents, SWT::NONE)
      child_layout = GridLayout.new
      child_layout.attr_margin_height = 0
      child_layout.attr_margin_width = 0
      child_layout.attr_vertical_spacing = 0
      @work_area.set_layout(child_layout)
      top = create_title_area(contents)
      reset_work_area_attachments(top)
      @work_area.set_font(JFaceResources.get_dialog_font)
      # initialize the dialog units
      initialize_dialog_units(@work_area)
      # create the dialog area and button bar
      self.attr_dialog_area = create_dialog_area(@work_area)
      self.attr_button_bar = create_button_bar(@work_area)
      return contents
    end
    
    typesig { [Composite] }
    # Creates and returns the contents of the upper part of this dialog (above
    # the button bar).
    # <p>
    # The <code>Dialog</code> implementation of this framework method creates
    # and returns a new <code>Composite</code> with no margins and spacing.
    # Subclasses should override.
    # </p>
    # 
    # @param parent
    # The parent composite to contain the dialog area
    # @return the dialog area control
    def create_dialog_area(parent)
      # create the top level composite for the dialog area
      composite = Composite.new(parent, SWT::NONE)
      layout = GridLayout.new
      layout.attr_margin_height = 0
      layout.attr_margin_width = 0
      layout.attr_vertical_spacing = 0
      layout.attr_horizontal_spacing = 0
      composite.set_layout(layout)
      composite.set_layout_data(GridData.new(GridData::FILL_BOTH))
      composite.set_font(parent.get_font)
      # Build the separator line
      title_bar_separator = Label.new(composite, SWT::HORIZONTAL | SWT::SEPARATOR)
      title_bar_separator.set_layout_data(GridData.new(GridData::FILL_HORIZONTAL))
      return composite
    end
    
    typesig { [Composite] }
    # Creates the dialog's title area.
    # 
    # @param parent
    # the SWT parent for the title area widgets
    # @return Control with the highest x axis value.
    def create_title_area(parent)
      parent.add_dispose_listener(# add a dispose listener
      Class.new(DisposeListener.class == Class ? DisposeListener : Object) do
        extend LocalClass
        include_class_members TitleAreaDialog
        include DisposeListener if DisposeListener.class == Module
        
        typesig { [DisposeEvent] }
        define_method :widget_disposed do |e|
          if (!(self.attr_title_area_color).nil?)
            self.attr_title_area_color.dispose
          end
        end
        
        typesig { [Object] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      # Determine the background color of the title bar
      display = parent.get_display
      background = nil
      foreground = nil
      if (!(@title_area_rgb).nil?)
        @title_area_color = Color.new(display, @title_area_rgb)
        background = @title_area_color
        foreground = nil
      else
        background = JFaceColors.get_banner_background(display)
        foreground = JFaceColors.get_banner_foreground(display)
      end
      parent.set_background(background)
      vertical_spacing = convert_vertical_dlus_to_pixels(IDialogConstants::VERTICAL_SPACING)
      horizontal_spacing = convert_horizontal_dlus_to_pixels(IDialogConstants::HORIZONTAL_SPACING)
      # Dialog image @ right
      @title_image_label = Label.new(parent, SWT::CENTER)
      @title_image_label.set_background(background)
      if ((@title_area_image).nil?)
        @title_image_label.set_image(JFaceResources.get_image(DLG_IMG_TITLE_BANNER))
      else
        @title_image_label.set_image(@title_area_image)
      end
      image_data = FormData.new
      image_data.attr_top = FormAttachment.new(0, 0)
      # Note: do not use horizontalSpacing on the right as that would be a
      # regression from
      # the R2.x style where there was no margin on the right and images are
      # flush to the right
      # hand side. see reopened comments in 41172
      image_data.attr_right = FormAttachment.new(100, 0) # horizontalSpacing
      @title_image_label.set_layout_data(image_data)
      # Title label @ top, left
      @title_label = Label.new(parent, SWT::LEFT)
      JFaceColors.set_colors(@title_label, foreground, background)
      @title_label.set_font(JFaceResources.get_banner_font)
      @title_label.set_text(" ") # $NON-NLS-1$
      title_data = FormData.new
      title_data.attr_top = FormAttachment.new(0, vertical_spacing)
      title_data.attr_right = FormAttachment.new(@title_image_label)
      title_data.attr_left = FormAttachment.new(0, horizontal_spacing)
      @title_label.set_layout_data(title_data)
      # Message image @ bottom, left
      @message_image_label = Label.new(parent, SWT::CENTER)
      @message_image_label.set_background(background)
      # Message label @ bottom, center
      @message_label = Text.new(parent, SWT::WRAP | SWT::READ_ONLY)
      JFaceColors.set_colors(@message_label, foreground, background)
      @message_label.set_text(" \n ") # two lines//$NON-NLS-1$
      @message_label.set_font(JFaceResources.get_dialog_font)
      @message_label_height = @message_label.compute_size(SWT::DEFAULT, SWT::DEFAULT).attr_y
      # Filler labels
      @left_filler_label = Label.new(parent, SWT::CENTER)
      @left_filler_label.set_background(background)
      @bottom_filler_label = Label.new(parent, SWT::CENTER)
      @bottom_filler_label.set_background(background)
      set_layouts_for_normal_message(vertical_spacing, horizontal_spacing)
      determine_title_image_largest
      if (@title_image_largest)
        return @title_image_label
      end
      return @message_label
    end
    
    typesig { [] }
    # Determine if the title image is larger than the title message and message
    # area. This is used for layout decisions.
    def determine_title_image_largest
      title_y = @title_image_label.compute_size(SWT::DEFAULT, SWT::DEFAULT).attr_y
      vertical_spacing = convert_vertical_dlus_to_pixels(IDialogConstants::VERTICAL_SPACING)
      label_y = @title_label.compute_size(SWT::DEFAULT, SWT::DEFAULT).attr_y
      label_y += vertical_spacing
      label_y += @message_label_height
      label_y += vertical_spacing
      @title_image_largest = title_y > label_y
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Set the layout values for the messageLabel, messageImageLabel and
    # fillerLabel for the case where there is a normal message.
    # 
    # @param verticalSpacing
    # int The spacing between widgets on the vertical axis.
    # @param horizontalSpacing
    # int The spacing between widgets on the horizontal axis.
    def set_layouts_for_normal_message(vertical_spacing, horizontal_spacing)
      message_image_data = FormData.new
      message_image_data.attr_top = FormAttachment.new(@title_label, vertical_spacing)
      message_image_data.attr_left = FormAttachment.new(0, H_GAP_IMAGE)
      @message_image_label.set_layout_data(message_image_data)
      message_label_data = FormData.new
      message_label_data.attr_top = FormAttachment.new(@title_label, vertical_spacing)
      message_label_data.attr_right = FormAttachment.new(@title_image_label)
      message_label_data.attr_left = FormAttachment.new(@message_image_label, horizontal_spacing)
      message_label_data.attr_height = @message_label_height
      if (@title_image_largest)
        message_label_data.attr_bottom = FormAttachment.new(@title_image_label, 0, SWT::BOTTOM)
      end
      @message_label.set_layout_data(message_label_data)
      filler_data = FormData.new
      filler_data.attr_left = FormAttachment.new(0, horizontal_spacing)
      filler_data.attr_top = FormAttachment.new(@message_image_label, 0)
      filler_data.attr_bottom = FormAttachment.new(@message_label, 0, SWT::BOTTOM)
      @bottom_filler_label.set_layout_data(filler_data)
      data = FormData.new
      data.attr_top = FormAttachment.new(@message_image_label, 0, SWT::TOP)
      data.attr_left = FormAttachment.new(0, 0)
      data.attr_bottom = FormAttachment.new(@message_image_label, 0, SWT::BOTTOM)
      data.attr_right = FormAttachment.new(@message_image_label, 0)
      @left_filler_label.set_layout_data(data)
    end
    
    typesig { [] }
    # The <code>TitleAreaDialog</code> implementation of this
    # <code>Window</code> methods returns an initial size which is at least
    # some reasonable minimum.
    # 
    # @return the initial size of the dialog
    def get_initial_size
      shell_size = super
      return Point.new(Math.max(convert_horizontal_dlus_to_pixels(MIN_DIALOG_WIDTH), shell_size.attr_x), Math.max(convert_vertical_dlus_to_pixels(MIN_DIALOG_HEIGHT), shell_size.attr_y))
    end
    
    typesig { [] }
    # Retained for backward compatibility.
    # 
    # Returns the title area composite. There is no composite in this
    # implementation so the shell is returned.
    # 
    # @return Composite
    # @deprecated
    def get_title_area
      return get_shell
    end
    
    typesig { [] }
    # Returns the title image label.
    # 
    # @return the title image label
    def get_title_image_label
      return @title_image_label
    end
    
    typesig { [String] }
    # Display the given error message. The currently displayed message is saved
    # and will be redisplayed when the error message is set to
    # <code>null</code>.
    # 
    # @param newErrorMessage
    # the newErrorMessage to display or <code>null</code>
    def set_error_message(new_error_message)
      # Any change?
      if ((@error_message).nil? ? (new_error_message).nil? : (@error_message == new_error_message))
        return
      end
      @error_message = new_error_message
      # Clear or set error message.
      if ((@error_message).nil?)
        if (@showing_error)
          # we were previously showing an error
          @showing_error = false
        end
        # show the message
        # avoid calling setMessage in case it is overridden to call
        # setErrorMessage,
        # which would result in a recursive infinite loop
        if ((@message).nil?)
          # this should probably never happen since
          # setMessage does this conversion....
          @message = ""
        end # $NON-NLS-1$
        update_message(@message)
        @message_image_label.set_image(@message_image)
        set_image_label_visible(!(@message_image).nil?)
      else
        # Add in a space for layout purposes but do not
        # change the instance variable
        displayed_error_message = " " + @error_message # $NON-NLS-1$
        update_message(displayed_error_message)
        if (!@showing_error)
          # we were not previously showing an error
          @showing_error = true
          @message_image_label.set_image(JFaceResources.get_image(DLG_IMG_TITLE_ERROR))
          set_image_label_visible(true)
        end
      end
      layout_for_new_message
    end
    
    typesig { [] }
    # Re-layout the labels for the new message.
    def layout_for_new_message
      vertical_spacing = convert_vertical_dlus_to_pixels(IDialogConstants::VERTICAL_SPACING)
      horizontal_spacing = convert_horizontal_dlus_to_pixels(IDialogConstants::HORIZONTAL_SPACING)
      # If there are no images then layout as normal
      if ((@error_message).nil? && (@message_image).nil?)
        set_image_label_visible(false)
        set_layouts_for_normal_message(vertical_spacing, horizontal_spacing)
      else
        @message_image_label.set_visible(true)
        @bottom_filler_label.set_visible(true)
        @left_filler_label.set_visible(true)
        # Note that we do not use horizontalSpacing here as when the
        # background of the messages changes there will be gaps between the
        # icon label and the message that are the background color of the
        # shell. We add a leading space elsewhere to compendate for this.
        data = FormData.new
        data.attr_left = FormAttachment.new(0, H_GAP_IMAGE)
        data.attr_top = FormAttachment.new(@title_label, vertical_spacing)
        @message_image_label.set_layout_data(data)
        data = FormData.new
        data.attr_top = FormAttachment.new(@message_image_label, 0)
        data.attr_left = FormAttachment.new(0, 0)
        data.attr_bottom = FormAttachment.new(@message_label, 0, SWT::BOTTOM)
        data.attr_right = FormAttachment.new(@message_image_label, 0, SWT::RIGHT)
        @bottom_filler_label.set_layout_data(data)
        data = FormData.new
        data.attr_top = FormAttachment.new(@message_image_label, 0, SWT::TOP)
        data.attr_left = FormAttachment.new(0, 0)
        data.attr_bottom = FormAttachment.new(@message_image_label, 0, SWT::BOTTOM)
        data.attr_right = FormAttachment.new(@message_image_label, 0)
        @left_filler_label.set_layout_data(data)
        message_label_data = FormData.new
        message_label_data.attr_top = FormAttachment.new(@title_label, vertical_spacing)
        message_label_data.attr_right = FormAttachment.new(@title_image_label)
        message_label_data.attr_left = FormAttachment.new(@message_image_label, 0)
        message_label_data.attr_height = @message_label_height
        if (@title_image_largest)
          message_label_data.attr_bottom = FormAttachment.new(@title_image_label, 0, SWT::BOTTOM)
        end
        @message_label.set_layout_data(message_label_data)
      end
      # Do not layout before the dialog area has been created
      # to avoid incomplete calculations.
      if (!(self.attr_dialog_area).nil?)
        @work_area.get_parent.layout(true)
      end
    end
    
    typesig { [String] }
    # Set the message text. If the message line currently displays an error,
    # the message is saved and will be redisplayed when the error message is
    # set to <code>null</code>.
    # <p>
    # Shortcut for <code>setMessage(newMessage, IMessageProvider.NONE)</code>
    # </p>
    # This method should be called after the dialog has been opened as it
    # updates the message label immediately.
    # 
    # @param newMessage
    # the message, or <code>null</code> to clear the message
    def set_message(new_message)
      set_message(new_message, IMessageProvider::NONE)
    end
    
    typesig { [String, ::Java::Int] }
    # Sets the message for this dialog with an indication of what type of
    # message it is.
    # <p>
    # The valid message types are one of <code>NONE</code>,
    # <code>INFORMATION</code>,<code>WARNING</code>, or
    # <code>ERROR</code>.
    # </p>
    # <p>
    # Note that for backward compatibility, a message of type
    # <code>ERROR</code> is different than an error message (set using
    # <code>setErrorMessage</code>). An error message overrides the current
    # message until the error message is cleared. This method replaces the
    # current message and does not affect the error message.
    # </p>
    # 
    # @param newMessage
    # the message, or <code>null</code> to clear the message
    # @param newType
    # the message type
    # @since 2.0
    def set_message(new_message, new_type)
      new_image = nil
      if (!(new_message).nil?)
        case (new_type)
        when IMessageProvider::NONE
        when IMessageProvider::INFORMATION
          new_image = JFaceResources.get_image(DLG_IMG_MESSAGE_INFO)
        when IMessageProvider::WARNING
          new_image = JFaceResources.get_image(DLG_IMG_MESSAGE_WARNING)
        when IMessageProvider::ERROR
          new_image = JFaceResources.get_image(DLG_IMG_MESSAGE_ERROR)
        end
      end
      show_message(new_message, new_image)
    end
    
    typesig { [String, Image] }
    # Show the new message and image.
    # 
    # @param newMessage
    # @param newImage
    def show_message(new_message, new_image)
      # Any change?
      if ((@message == new_message) && (@message_image).equal?(new_image))
        return
      end
      @message = new_message
      if ((@message).nil?)
        @message = ""
      end # $NON-NLS-1$
      # Message string to be shown - if there is an image then add in
      # a space to the message for layout purposes
      shown_message = ((new_image).nil?) ? @message : " " + @message # $NON-NLS-1$
      @message_image = new_image
      if (!@showing_error)
        # we are not showing an error
        update_message(shown_message)
        @message_image_label.set_image(@message_image)
        set_image_label_visible(!(@message_image).nil?)
        layout_for_new_message
      end
    end
    
    typesig { [String] }
    # Update the contents of the messageLabel.
    # 
    # @param newMessage
    # the message to use
    def update_message(new_message)
      @message_label.set_text(new_message)
    end
    
    typesig { [String] }
    # Sets the title to be shown in the title area of this dialog.
    # 
    # @param newTitle
    # the title show
    def set_title(new_title)
      if ((@title_label).nil?)
        return
      end
      title = new_title
      if ((title).nil?)
        title = ""
      end # $NON-NLS-1$
      @title_label.set_text(title)
    end
    
    typesig { [RGB] }
    # Sets the title bar color for this dialog.
    # 
    # @param color
    # the title bar color
    def set_title_area_color(color)
      @title_area_rgb = color
    end
    
    typesig { [Image] }
    # Sets the title image to be shown in the title area of this dialog.
    # 
    # @param newTitleImage
    # the title image to be shown
    def set_title_image(new_title_image)
      @title_area_image = new_title_image
      if (!(@title_image_label).nil?)
        @title_image_label.set_image(new_title_image)
        determine_title_image_largest
        top = nil
        if (@title_image_largest)
          top = @title_image_label
        else
          top = @message_label
        end
        reset_work_area_attachments(top)
      end
    end
    
    typesig { [::Java::Boolean] }
    # Make the label used for displaying error images visible depending on
    # boolean.
    # 
    # @param visible
    # If <code>true</code> make the image visible, if not then
    # make it not visible.
    def set_image_label_visible(visible)
      @message_image_label.set_visible(visible)
      @bottom_filler_label.set_visible(visible)
      @left_filler_label.set_visible(visible)
    end
    
    typesig { [Control] }
    # Reset the attachment of the workArea to now attach to top as the top
    # control.
    # 
    # @param top
    def reset_work_area_attachments(top)
      child_data = FormData.new
      child_data.attr_top = FormAttachment.new(top)
      child_data.attr_right = FormAttachment.new(100, 0)
      child_data.attr_left = FormAttachment.new(0, 0)
      child_data.attr_bottom = FormAttachment.new(100, 0)
      @work_area.set_layout_data(child_data)
    end
    
    private
    alias_method :initialize__title_area_dialog, :initialize
  end
  
end
