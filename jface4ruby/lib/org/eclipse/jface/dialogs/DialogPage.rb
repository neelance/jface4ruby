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
  module DialogPageImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Dialogs
      include_const ::Org::Eclipse::Jface::Resource, :ImageDescriptor
      include_const ::Org::Eclipse::Jface::Resource, :JFaceResources
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Graphics, :Font
      include_const ::Org::Eclipse::Swt::Graphics, :FontMetrics
      include_const ::Org::Eclipse::Swt::Graphics, :SwtGC
      include_const ::Org::Eclipse::Swt::Graphics, :Image
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Layout, :GridData
      include_const ::Org::Eclipse::Swt::Widgets, :Button
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Shell
    }
  end
  
  # Abstract base implementation of a dialog page. All dialog pages are
  # subclasses of this one.
  class DialogPage 
    include_class_members DialogPageImports
    include IDialogPage
    include IMessageProvider
    
    # The control for this dialog page.
    attr_accessor :control
    alias_method :attr_control, :control
    undef_method :control
    alias_method :attr_control=, :control=
    undef_method :control=
    
    # Optional title; <code>null</code> if none.
    # 
    # @see #setTitle
    attr_accessor :title
    alias_method :attr_title, :title
    undef_method :title
    alias_method :attr_title=, :title=
    undef_method :title=
    
    # Optional description; <code>null</code> if none.
    # 
    # @see #setDescription
    attr_accessor :description
    alias_method :attr_description, :description
    undef_method :description
    alias_method :attr_description=, :description=
    undef_method :description=
    
    # Cached image; <code>null</code> if none.
    # 
    # @see #setImageDescriptor(ImageDescriptor)
    attr_accessor :image
    alias_method :attr_image, :image
    undef_method :image
    alias_method :attr_image=, :image=
    undef_method :image=
    
    # Optional image; <code>null</code> if none.
    # 
    # @see #setImageDescriptor(ImageDescriptor)
    attr_accessor :image_descriptor
    alias_method :attr_image_descriptor, :image_descriptor
    undef_method :image_descriptor
    alias_method :attr_image_descriptor=, :image_descriptor=
    undef_method :image_descriptor=
    
    # The current message; <code>null</code> if none.
    attr_accessor :message
    alias_method :attr_message, :message
    undef_method :message
    alias_method :attr_message=, :message=
    undef_method :message=
    
    # The current message type; default value <code>NONE</code>.
    attr_accessor :message_type
    alias_method :attr_message_type, :message_type
    undef_method :message_type
    alias_method :attr_message_type=, :message_type=
    undef_method :message_type=
    
    # The current error message; <code>null</code> if none.
    attr_accessor :error_message
    alias_method :attr_error_message, :error_message
    undef_method :error_message
    alias_method :attr_error_message=, :error_message=
    undef_method :error_message=
    
    # Font metrics to use for determining pixel sizes.
    attr_accessor :font_metrics
    alias_method :attr_font_metrics, :font_metrics
    undef_method :font_metrics
    alias_method :attr_font_metrics=, :font_metrics=
    undef_method :font_metrics=
    
    typesig { [] }
    # Creates a new empty dialog page.
    def initialize
      @control = nil
      @title = nil
      @description = nil
      @image = nil
      @image_descriptor = nil
      @message = nil
      @message_type = NONE
      @error_message = nil
      @font_metrics = nil
      # No initial behaviour
    end
    
    typesig { [String] }
    # Creates a new dialog page with the given title.
    # 
    # @param title
    # the title of this dialog page, or <code>null</code> if none
    def initialize(title)
      @control = nil
      @title = nil
      @description = nil
      @image = nil
      @image_descriptor = nil
      @message = nil
      @message_type = NONE
      @error_message = nil
      @font_metrics = nil
      @title = title
    end
    
    typesig { [String, ImageDescriptor] }
    # Creates a new dialog page with the given title and image.
    # 
    # @param title
    # the title of this dialog page, or <code>null</code> if none
    # @param image
    # the image for this dialog page, or <code>null</code> if none
    def initialize(title, image)
      initialize__dialog_page(title)
      @image_descriptor = image
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
      return Dialog.convert_height_in_chars_to_pixels(@font_metrics, chars)
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
      return Dialog.convert_horizontal_dlus_to_pixels(@font_metrics, dlus)
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
      return Dialog.convert_vertical_dlus_to_pixels(@font_metrics, dlus)
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
      return Dialog.convert_width_in_chars_to_pixels(@font_metrics, chars)
    end
    
    typesig { [] }
    # The <code>DialogPage</code> implementation of this
    # <code>IDialogPage</code> method disposes of the page
    # image if it has one.
    # Subclasses may extend.
    def dispose
      # deallocate SWT resources
      if (!(@image).nil?)
        @image.dispose
        @image = nil
      end
    end
    
    typesig { [] }
    # Returns the top level control for this dialog page.
    # 
    # @return the top level control
    def get_control
      return @control
    end
    
    typesig { [] }
    # (non-Javadoc) Method declared on IDialogPage.
    def get_description
      return @description
    end
    
    typesig { [] }
    # Returns the symbolic font name used by dialog pages.
    # 
    # @return the symbolic font name
    def get_dialog_font_name
      return JFaceResources::DIALOG_FONT
    end
    
    typesig { [] }
    # (non-Javadoc) Method declared on IDialogPage.
    def get_error_message
      return @error_message
    end
    
    typesig { [] }
    # Returns the default font to use for this dialog page.
    # 
    # @return the font
    def get_font
      return JFaceResources.get_font_registry.get(get_dialog_font_name)
    end
    
    typesig { [] }
    # (non-Javadoc) Method declared on IDialogPage.
    def get_image
      if ((@image).nil?)
        if (!(@image_descriptor).nil?)
          @image = @image_descriptor.create_image
        end
      end
      return @image
    end
    
    typesig { [] }
    # (non-Javadoc) Method declared on IDialogPage.
    def get_message
      return @message
    end
    
    typesig { [] }
    # (non-Javadoc) Method declared on IMessageProvider.
    def get_message_type
      return @message_type
    end
    
    typesig { [] }
    # Returns this dialog page's shell. Convenience method for
    # <code>getControl().getShell()</code>. This method may only be called
    # after the page's control has been created.
    # 
    # @return the shell
    def get_shell
      return get_control.get_shell
    end
    
    typesig { [] }
    # (non-Javadoc) Method declared on IDialogPage.
    def get_title
      return @title
    end
    
    typesig { [::Java::Int] }
    # Returns the tool tip text for the widget with the given id.
    # <p>
    # The default implementation of this framework method does nothing and
    # returns <code>null</code>. Subclasses may override.
    # </p>
    # 
    # @param widgetId
    # the id of the widget for which hover help is requested
    # @return the tool tip text, or <code>null</code> if none
    # @deprecated
    def get_tool_tip_text(widget_id)
      # return nothing by default
      return nil
    end
    
    typesig { [Control] }
    # Initializes the computation of horizontal and vertical dialog units based
    # on the size of current font.
    # <p>
    # This method must be called before any of the dialog unit based conversion
    # methods are called.
    # </p>
    # 
    # @param testControl
    # a control from which to obtain the current font
    def initialize_dialog_units(test_control)
      # Compute and store a font metric
      gc = SwtGC.new(test_control)
      gc.set_font(JFaceResources.get_dialog_font)
      @font_metrics = gc.get_font_metrics
      gc.dispose
    end
    
    typesig { [Button] }
    # Sets the <code>GridData</code> on the specified button to be one that
    # is spaced for the current dialog page units. The method
    # <code>initializeDialogUnits</code> must be called once before calling
    # this method for the first time.
    # 
    # @param button
    # the button to set the <code>GridData</code>
    # @return the <code>GridData</code> set on the specified button
    def set_button_layout_data(button)
      data = GridData.new(GridData::HORIZONTAL_ALIGN_FILL)
      width_hint = convert_horizontal_dlus_to_pixels(IDialogConstants::BUTTON_WIDTH)
      min_size = button.compute_size(SWT::DEFAULT, SWT::DEFAULT, true)
      data.attr_width_hint = Math.max(width_hint, min_size.attr_x)
      button.set_layout_data(data)
      return data
    end
    
    typesig { [] }
    # Tests whether this page's UI content has already been created.
    # 
    # @return <code>true</code> if the control has been created, and
    # <code>false</code> if not
    def is_control_created
      return !(@control).nil?
    end
    
    typesig { [] }
    # This default implementation of an <code>IDialogPage</code> method does
    # nothing. Subclasses should override to take some action in response to a
    # help request.
    def perform_help
      # No default help
    end
    
    typesig { [Control] }
    # Set the control for the receiver.
    # @param newControl
    def set_control(new_control)
      @control = new_control
    end
    
    typesig { [String] }
    # (non-Javadoc) Method declared on IDialogPage.
    def set_description(description)
      @description = description
    end
    
    typesig { [String] }
    # Sets or clears the error message for this page.
    # 
    # @param newMessage
    # the message, or <code>null</code> to clear the error message
    def set_error_message(new_message)
      @error_message = new_message
    end
    
    typesig { [ImageDescriptor] }
    # (non-Javadoc) Method declared on IDialogPage.
    def set_image_descriptor(desc)
      @image_descriptor = desc
      if (!(@image).nil?)
        @image.dispose
        @image = nil
      end
    end
    
    typesig { [String] }
    # Sets or clears the message for this page.
    # <p>
    # This is a shortcut for <code>setMessage(newMesasge, NONE)</code>
    # </p>
    # 
    # @param newMessage
    # the message, or <code>null</code> to clear the message
    def set_message(new_message)
      set_message(new_message, NONE)
    end
    
    typesig { [String, ::Java::Int] }
    # Sets the message for this page with an indication of what type of message
    # it is.
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
      @message = new_message
      @message_type = new_type
    end
    
    typesig { [String] }
    # The <code>DialogPage</code> implementation of this
    # <code>IDialogPage</code> method remembers the title in an internal
    # state variable. Subclasses may extend.
    def set_title(title)
      @title = title
    end
    
    typesig { [::Java::Boolean] }
    # The <code>DialogPage</code> implementation of this
    # <code>IDialogPage</code> method sets the control to the given
    # visibility state. Subclasses may extend.
    def set_visible(visible)
      @control.set_visible(visible)
    end
    
    private
    alias_method :initialize__dialog_page, :initialize
  end
  
end
