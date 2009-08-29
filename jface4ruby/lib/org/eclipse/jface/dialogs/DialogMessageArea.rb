require "rjava"

# Copyright (c) 2004, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Dialogs
  module DialogMessageAreaImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Dialogs
      include_const ::Org::Eclipse::Jface::Resource, :JFaceResources
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Custom, :CLabel
      include_const ::Org::Eclipse::Swt::Graphics, :Image
      include_const ::Org::Eclipse::Swt::Layout, :GridData
      include_const ::Org::Eclipse::Swt::Layout, :GridLayout
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Label
      include_const ::Org::Eclipse::Swt::Widgets, :Text
    }
  end
  
  # The DialogMessageArea is a resusable component for adding an accessible
  # message area to a dialog.
  # 
  # When the message is normal a CLabel is used but an errors replaces the
  # message area with a non editable text that can take focus for use by screen
  # readers.
  # 
  # @since 3.0
  class DialogMessageArea < DialogMessageAreaImports.const_get :Object
    include_class_members DialogMessageAreaImports
    
    attr_accessor :message_text
    alias_method :attr_message_text, :message_text
    undef_method :message_text
    alias_method :attr_message_text=, :message_text=
    undef_method :message_text=
    
    attr_accessor :message_image_label
    alias_method :attr_message_image_label, :message_image_label
    undef_method :message_image_label
    alias_method :attr_message_image_label=, :message_image_label=
    undef_method :message_image_label=
    
    attr_accessor :message_composite
    alias_method :attr_message_composite, :message_composite
    undef_method :message_composite
    alias_method :attr_message_composite=, :message_composite=
    undef_method :message_composite=
    
    attr_accessor :last_message_text
    alias_method :attr_last_message_text, :last_message_text
    undef_method :last_message_text
    alias_method :attr_last_message_text=, :last_message_text=
    undef_method :last_message_text=
    
    attr_accessor :last_message_type
    alias_method :attr_last_message_type, :last_message_type
    undef_method :last_message_type
    alias_method :attr_last_message_type=, :last_message_type=
    undef_method :last_message_type=
    
    attr_accessor :title_label
    alias_method :attr_title_label, :title_label
    undef_method :title_label
    alias_method :attr_title_label=, :title_label=
    undef_method :title_label=
    
    typesig { [] }
    # Create a new instance of the receiver.
    def initialize
      @message_text = nil
      @message_image_label = nil
      @message_composite = nil
      @last_message_text = nil
      @last_message_type = 0
      @title_label = nil
      super()
      # No initial behaviour
    end
    
    typesig { [Composite] }
    # Create the contents for the receiver.
    # 
    # @param parent
    # the Composite that the children will be created in
    def create_contents(parent)
      # Message label
      @title_label = CLabel.new(parent, SWT::NONE)
      @title_label.set_font(JFaceResources.get_banner_font)
      @message_composite = Composite.new(parent, SWT::NONE)
      message_layout = GridLayout.new
      message_layout.attr_num_columns = 2
      message_layout.attr_margin_width = 0
      message_layout.attr_margin_height = 0
      message_layout.attr_make_columns_equal_width = false
      @message_composite.set_layout(message_layout)
      @message_image_label = Label.new(@message_composite, SWT::NONE)
      @message_image_label.set_image(JFaceResources.get_image(Dialog::DLG_IMG_MESSAGE_INFO))
      @message_image_label.set_layout_data(GridData.new(GridData::VERTICAL_ALIGN_CENTER))
      @message_text = Text.new(@message_composite, SWT::NONE)
      @message_text.set_editable(false)
      text_data = GridData.new(GridData::GRAB_HORIZONTAL | GridData::FILL_HORIZONTAL | GridData::VERTICAL_ALIGN_CENTER)
      @message_text.set_layout_data(text_data)
    end
    
    typesig { [Object] }
    # Set the layoutData for the title area. In most cases this will be a copy
    # of the layoutData used in setMessageLayoutData.
    # 
    # @param layoutData
    # the layoutData for the title
    # @see #setMessageLayoutData(Object)
    def set_title_layout_data(layout_data)
      @title_label.set_layout_data(layout_data)
    end
    
    typesig { [Object] }
    # Set the layoutData for the messageArea. In most cases this will be a copy
    # of the layoutData used in setTitleLayoutData.
    # 
    # @param layoutData
    # the layoutData for the message area composite.
    # @see #setTitleLayoutData(Object)
    def set_message_layout_data(layout_data)
      @message_composite.set_layout_data(layout_data)
    end
    
    typesig { [String, Image] }
    # Show the title.
    # 
    # @param titleMessage
    # String for the titke
    # @param titleImage
    # Image or <code>null</code>
    def show_title(title_message, title_image)
      @title_label.set_image(title_image)
      @title_label.set_text(title_message)
      restore_title
      return
    end
    
    typesig { [] }
    # Enable the title and disable the message text and image.
    def restore_title
      @title_label.set_visible(true)
      @message_composite.set_visible(false)
      @last_message_text = RJava.cast_to_string(nil)
      @last_message_type = IMessageProvider::NONE
    end
    
    typesig { [String, ::Java::Int] }
    # Show the new message in the message text and update the image. Base the
    # background color on whether or not there are errors.
    # 
    # @param newMessage
    # The new value for the message
    # @param newType
    # One of the IMessageProvider constants. If newType is
    # IMessageProvider.NONE show the title.
    # @see IMessageProvider
    def update_text(new_message, new_type)
      new_image = nil
      case (new_type)
      when IMessageProvider::NONE
        if ((new_message).nil?)
          restore_title
        else
          show_title(new_message, nil)
        end
        return
      when IMessageProvider::INFORMATION
        new_image = JFaceResources.get_image(Dialog::DLG_IMG_MESSAGE_INFO)
      when IMessageProvider::WARNING
        new_image = JFaceResources.get_image(Dialog::DLG_IMG_MESSAGE_WARNING)
      when IMessageProvider::ERROR
        new_image = JFaceResources.get_image(Dialog::DLG_IMG_MESSAGE_ERROR)
      end
      @message_composite.set_visible(true)
      @title_label.set_visible(false)
      # Any more updates required?
      # If the message text equals the tooltip (i.e. non-shortened text is the same)
      # and shortened text is the same (i.e. not a resize)
      # and the image is the same then nothing to do
      short_text = Dialog.shorten_text(new_message, @message_text)
      if ((new_message == @message_text.get_tool_tip_text) && (new_image).equal?(@message_image_label.get_image) && (short_text == @message_text.get_text))
        return
      end
      @message_image_label.set_image(new_image)
      @message_text.set_text(Dialog.shorten_text(new_message, @message_text))
      @message_text.set_tool_tip_text(new_message)
      @last_message_text = new_message
    end
    
    typesig { [] }
    # Clear the error message. Restore the previously displayed message if
    # there is one, if not restore the title label.
    def clear_error_message
      if ((@last_message_text).nil?)
        restore_title
      else
        update_text(@last_message_text, @last_message_type)
      end
    end
    
    private
    alias_method :initialize__dialog_message_area, :initialize
  end
  
end
