require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
# Sebastian Davids <sdavids@gmx.de> - Fix for bug 19346 - Dialog font should
# be activated and used by other components.
module Org::Eclipse::Jface::Dialogs
  module ErrorDialogImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Dialogs
      include_const ::Org::Eclipse::Core::Runtime, :CoreException
      include_const ::Org::Eclipse::Core::Runtime, :IStatus
      include_const ::Org::Eclipse::Jface::Resource, :JFaceResources
      include_const ::Org::Eclipse::Jface::Util, :Policy
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Dnd, :Clipboard
      include_const ::Org::Eclipse::Swt::Dnd, :TextTransfer
      include_const ::Org::Eclipse::Swt::Dnd, :Transfer
      include_const ::Org::Eclipse::Swt::Events, :SelectionEvent
      include_const ::Org::Eclipse::Swt::Events, :SelectionListener
      include_const ::Org::Eclipse::Swt::Graphics, :Image
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Layout, :GridData
      include_const ::Org::Eclipse::Swt::Layout, :GridLayout
      include_const ::Org::Eclipse::Swt::Widgets, :Button
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Label
      include_const ::Org::Eclipse::Swt::Widgets, :JavaList
      include_const ::Org::Eclipse::Swt::Widgets, :Menu
      include_const ::Org::Eclipse::Swt::Widgets, :MenuItem
      include_const ::Org::Eclipse::Swt::Widgets, :Shell
    }
  end
  
  # A dialog to display one or more errors to the user, as contained in an
  # <code>IStatus</code> object. If an error contains additional detailed
  # information then a Details button is automatically supplied, which shows or
  # hides an error details viewer when pressed by the user.
  # 
  # <p>
  # This dialog should be considered being a "local" way of error handling. It
  # cannot be changed or replaced by "global" error handling facility (
  # <code>org.eclipse.ui.statushandler.StatusManager</code>). If product defines
  # its own way of handling errors, this error dialog may cause UI inconsistency,
  # so until it is absolutely necessary, <code>StatusManager</code> should be
  # used.
  # </p>
  # 
  # @see org.eclipse.core.runtime.IStatus
  class ErrorDialog < ErrorDialogImports.const_get :IconAndMessageDialog
    include_class_members ErrorDialogImports
    
    class_module.module_eval {
      # Static to prevent opening of error dialogs for automated testing.
      
      def automated_mode
        defined?(@@automated_mode) ? @@automated_mode : @@automated_mode= false
      end
      alias_method :attr_automated_mode, :automated_mode
      
      def automated_mode=(value)
        @@automated_mode = value
      end
      alias_method :attr_automated_mode=, :automated_mode=
      
      # Reserve room for this many list items.
      const_set_lazy(:LIST_ITEM_COUNT) { 7 }
      const_attr_reader  :LIST_ITEM_COUNT
      
      # The nesting indent.
      const_set_lazy(:NESTING_INDENT) { "  " }
      const_attr_reader  :NESTING_INDENT
    }
    
    # $NON-NLS-1$
    # 
    # The Details button.
    attr_accessor :details_button
    alias_method :attr_details_button, :details_button
    undef_method :details_button
    alias_method :attr_details_button=, :details_button=
    undef_method :details_button=
    
    # The title of the dialog.
    attr_accessor :title
    alias_method :attr_title, :title
    undef_method :title
    alias_method :attr_title=, :title=
    undef_method :title=
    
    # The SWT list control that displays the error details.
    attr_accessor :list
    alias_method :attr_list, :list
    undef_method :list
    alias_method :attr_list=, :list=
    undef_method :list=
    
    # Indicates whether the error details viewer is currently created.
    attr_accessor :list_created
    alias_method :attr_list_created, :list_created
    undef_method :list_created
    alias_method :attr_list_created=, :list_created=
    undef_method :list_created=
    
    # Filter mask for determining which status items to display.
    attr_accessor :display_mask
    alias_method :attr_display_mask, :display_mask
    undef_method :display_mask
    alias_method :attr_display_mask=, :display_mask=
    undef_method :display_mask=
    
    # The main status object.
    attr_accessor :status
    alias_method :attr_status, :status
    undef_method :status
    alias_method :attr_status=, :status=
    undef_method :status=
    
    # The current clipboard. To be disposed when closing the dialog.
    attr_accessor :clipboard
    alias_method :attr_clipboard, :clipboard
    undef_method :clipboard
    alias_method :attr_clipboard=, :clipboard=
    undef_method :clipboard=
    
    attr_accessor :should_include_top_level_error_in_details
    alias_method :attr_should_include_top_level_error_in_details, :should_include_top_level_error_in_details
    undef_method :should_include_top_level_error_in_details
    alias_method :attr_should_include_top_level_error_in_details=, :should_include_top_level_error_in_details=
    undef_method :should_include_top_level_error_in_details=
    
    typesig { [Shell, String, String, IStatus, ::Java::Int] }
    # Creates an error dialog. Note that the dialog will have no visual
    # representation (no widgets) until it is told to open.
    # <p>
    # Normally one should use <code>openError</code> to create and open one
    # of these. This constructor is useful only if the error object being
    # displayed contains child items <it>and </it> you need to specify a mask
    # which will be used to filter the displaying of these children. The error
    # dialog will only be displayed if there is at least one child status
    # matching the mask.
    # </p>
    # 
    # @param parentShell
    # the shell under which to create this dialog
    # @param dialogTitle
    # the title to use for this dialog, or <code>null</code> to
    # indicate that the default title should be used
    # @param message
    # the message to show in this dialog, or <code>null</code> to
    # indicate that the error's message should be shown as the
    # primary message
    # @param status
    # the error to show to the user
    # @param displayMask
    # the mask to use to filter the displaying of child items, as
    # per <code>IStatus.matches</code>
    # @see org.eclipse.core.runtime.IStatus#matches(int)
    def initialize(parent_shell, dialog_title, message, status, display_mask)
      @details_button = nil
      @title = nil
      @list = nil
      @list_created = false
      @display_mask = 0
      @status = nil
      @clipboard = nil
      @should_include_top_level_error_in_details = false
      super(parent_shell)
      @list_created = false
      @display_mask = 0xffff
      @should_include_top_level_error_in_details = false
      # $NON-NLS-1$
      @title = (dialog_title).nil? ? JFaceResources.get_string("Problem_Occurred") : dialog_title
      self.attr_message = (message).nil? ? status.get_message : JFaceResources.format("Reason", Array.typed(Object).new([message, status.get_message])) # $NON-NLS-1$
      @status = status
      @display_mask = display_mask
    end
    
    typesig { [::Java::Int] }
    # (non-Javadoc) Method declared on Dialog. Handles the pressing of the Ok
    # or Details button in this dialog. If the Ok button was pressed then close
    # this dialog. If the Details button was pressed then toggle the displaying
    # of the error details area. Note that the Details button will only be
    # visible if the error being displayed specifies child details.
    def button_pressed(id)
      if ((id).equal?(IDialogConstants::DETAILS_ID))
        # was the details button pressed?
        toggle_details_area
      else
        super(id)
      end
    end
    
    typesig { [Shell] }
    # (non-Javadoc) Method declared in Window.
    def configure_shell(shell)
      super(shell)
      shell.set_text(@title)
    end
    
    typesig { [Composite] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.dialogs.Dialog#createButtonsForButtonBar(org.eclipse.swt.widgets.Composite)
    def create_buttons_for_button_bar(parent)
      # create OK and Details buttons
      create_button(parent, IDialogConstants::OK_ID, IDialogConstants::OK_LABEL, true)
      create_details_button(parent)
    end
    
    typesig { [Composite] }
    # Create the area for extra error support information.
    # 
    # @param parent
    def create_support_area(parent)
      provider = Policy.get_error_support_provider
      if ((provider).nil?)
        return
      end
      support_area = Composite.new(parent, SWT::NONE)
      provider.create_support_area(support_area, @status)
      support_data = GridData.new(SWT::FILL, SWT::FILL, true, true)
      support_data.attr_vertical_span = 3
      support_area.set_layout_data(support_data)
      if ((support_area.get_layout).nil?)
        layout = GridLayout.new
        layout.attr_margin_width = 0
        layout.attr_margin_height = 0
        support_area.set_layout(layout) # Give it a default layout if one isn't set
      end
    end
    
    typesig { [Composite] }
    # Create the details button if it should be included.
    # 
    # @param parent
    # the parent composite
    # @since 3.2
    def create_details_button(parent)
      if (should_show_details_button)
        @details_button = create_button(parent, IDialogConstants::DETAILS_ID, IDialogConstants::SHOW_DETAILS_LABEL, false)
      end
    end
    
    typesig { [Composite] }
    # This implementation of the <code>Dialog</code> framework method creates
    # and lays out a composite. Subclasses that require a different dialog area
    # may either override this method, or call the <code>super</code>
    # implementation and add controls to the created composite.
    # 
    # Note:  Since 3.4, the created composite no longer grabs excess vertical space.
    # See https://bugs.eclipse.org/bugs/show_bug.cgi?id=72489.
    # If the old behavior is desired by subclasses, get the returned composite's
    # layout data and set grabExcessVerticalSpace to true.
    def create_dialog_area(parent)
      # Create a composite with standard margins and spacing
      # Add the messageArea to this composite so that as subclasses add widgets to the messageArea
      # and dialogArea, the number of children of parent remains fixed and with consistent layout.
      # Fixes bug #240135
      composite = Composite.new(parent, SWT::NONE)
      create_message_area(composite)
      create_support_area(parent)
      layout = GridLayout.new
      layout.attr_margin_height = convert_vertical_dlus_to_pixels(IDialogConstants::VERTICAL_MARGIN)
      layout.attr_margin_width = convert_horizontal_dlus_to_pixels(IDialogConstants::HORIZONTAL_MARGIN)
      layout.attr_vertical_spacing = convert_vertical_dlus_to_pixels(IDialogConstants::VERTICAL_SPACING)
      layout.attr_horizontal_spacing = convert_horizontal_dlus_to_pixels(IDialogConstants::HORIZONTAL_SPACING)
      layout.attr_num_columns = 2
      composite.set_layout(layout)
      child_data = GridData.new(GridData::FILL_BOTH)
      child_data.attr_horizontal_span = 2
      child_data.attr_grab_excess_vertical_space = false
      composite.set_layout_data(child_data)
      composite.set_font(parent.get_font)
      return composite
    end
    
    typesig { [Composite] }
    # @see IconAndMessageDialog#createDialogAndButtonArea(Composite)
    def create_dialog_and_button_area(parent)
      super(parent)
      if (self.attr_dialog_area.is_a?(Composite))
        # Create a label if there are no children to force a smaller layout
        dialog_composite = self.attr_dialog_area
        if ((dialog_composite.get_children.attr_length).equal?(0))
          Label.new(dialog_composite, SWT::NULL)
        end
      end
    end
    
    typesig { [] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.dialogs.IconAndMessageDialog#getImage()
    def get_image
      if (!(@status).nil?)
        if ((@status.get_severity).equal?(IStatus::WARNING))
          return get_warning_image
        end
        if ((@status.get_severity).equal?(IStatus::INFO))
          return get_info_image
        end
      end
      # If it was not a warning or an error then return the error image
      return get_error_image
    end
    
    typesig { [Composite] }
    # Create this dialog's drop-down list component.
    # 
    # @param parent
    # the parent composite
    # @return the drop-down list component
    def create_drop_down_list(parent)
      # create the list
      @list = JavaList.new(parent, SWT::BORDER | SWT::H_SCROLL | SWT::V_SCROLL | SWT::MULTI)
      # fill the list
      populate_list(@list)
      data = GridData.new(GridData::HORIZONTAL_ALIGN_FILL | GridData::GRAB_HORIZONTAL | GridData::VERTICAL_ALIGN_FILL | GridData::GRAB_VERTICAL)
      data.attr_height_hint = @list.get_item_height * LIST_ITEM_COUNT
      data.attr_horizontal_span = 2
      @list.set_layout_data(data)
      @list.set_font(parent.get_font)
      copy_menu = Menu.new(@list)
      copy_item = MenuItem.new(copy_menu, SWT::NONE)
      copy_item.add_selection_listener(Class.new(SelectionListener.class == Class ? SelectionListener : Object) do
        extend LocalClass
        include_class_members ErrorDialog
        include SelectionListener if SelectionListener.class == Module
        
        typesig { [SelectionEvent] }
        # @see SelectionListener.widgetSelected (SelectionEvent)
        define_method :widget_selected do |e|
          copy_to_clipboard
        end
        
        typesig { [SelectionEvent] }
        # @see SelectionListener.widgetDefaultSelected(SelectionEvent)
        define_method :widget_default_selected do |e|
          copy_to_clipboard
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      copy_item.set_text(JFaceResources.get_string("copy")) # $NON-NLS-1$
      @list.set_menu(copy_menu)
      @list_created = true
      return @list
    end
    
    typesig { [] }
    # (non-Javadoc) Method declared on Window.
    # 
    # 
    # Extends <code>Window.open()</code>. Opens an error dialog to display
    # the error. If you specified a mask to filter the displaying of these
    # children, the error dialog will only be displayed if there is at least
    # one child status matching the mask.
    def open
      if (!self.attr_automated_mode && should_display(@status, @display_mask))
        return super
      end
      set_return_code(OK)
      return OK
    end
    
    class_module.module_eval {
      typesig { [Shell, String, String, IStatus] }
      # Opens an error dialog to display the given error. Use this method if the
      # error object being displayed does not contain child items, or if you wish
      # to display all such items without filtering.
      # 
      # @param parent
      # the parent shell of the dialog, or <code>null</code> if none
      # @param dialogTitle
      # the title to use for this dialog, or <code>null</code> to
      # indicate that the default title should be used
      # @param message
      # the message to show in this dialog, or <code>null</code> to
      # indicate that the error's message should be shown as the
      # primary message
      # @param status
      # the error to show to the user
      # @return the code of the button that was pressed that resulted in this
      # dialog closing. This will be <code>Dialog.OK</code> if the OK
      # button was pressed, or <code>Dialog.CANCEL</code> if this
      # dialog's close window decoration or the ESC key was used.
      def open_error(parent, dialog_title, message, status)
        return open_error(parent, dialog_title, message, status, IStatus::OK | IStatus::INFO | IStatus::WARNING | IStatus::ERROR)
      end
      
      typesig { [Shell, String, String, IStatus, ::Java::Int] }
      # Opens an error dialog to display the given error. Use this method if the
      # error object being displayed contains child items <it>and </it> you wish
      # to specify a mask which will be used to filter the displaying of these
      # children. The error dialog will only be displayed if there is at least
      # one child status matching the mask.
      # 
      # @param parentShell
      # the parent shell of the dialog, or <code>null</code> if none
      # @param title
      # the title to use for this dialog, or <code>null</code> to
      # indicate that the default title should be used
      # @param message
      # the message to show in this dialog, or <code>null</code> to
      # indicate that the error's message should be shown as the
      # primary message
      # @param status
      # the error to show to the user
      # @param displayMask
      # the mask to use to filter the displaying of child items, as
      # per <code>IStatus.matches</code>
      # @return the code of the button that was pressed that resulted in this
      # dialog closing. This will be <code>Dialog.OK</code> if the OK
      # button was pressed, or <code>Dialog.CANCEL</code> if this
      # dialog's close window decoration or the ESC key was used.
      # @see org.eclipse.core.runtime.IStatus#matches(int)
      def open_error(parent_shell, title, message, status, display_mask)
        dialog = ErrorDialog.new(parent_shell, title, message, status, display_mask)
        return dialog.open
      end
    }
    
    typesig { [JavaList] }
    # Populates the list using this error dialog's status object. This walks
    # the child static of the status object and displays them in a list. The
    # format for each entry is status_path : status_message If the status's
    # path was null then it (and the colon) are omitted.
    # 
    # @param listToPopulate
    # The list to fill.
    def populate_list(list_to_populate)
      populate_list(list_to_populate, @status, 0, @should_include_top_level_error_in_details)
    end
    
    typesig { [JavaList, IStatus, ::Java::Int, ::Java::Boolean] }
    # Populate the list with the messages from the given status. Traverse the
    # children of the status deeply and also traverse CoreExceptions that
    # appear in the status.
    # 
    # @param listToPopulate
    # the list to populate
    # @param buildingStatus
    # the status being displayed
    # @param nesting
    # the nesting level (increases one level for each level of
    # children)
    # @param includeStatus
    # whether to include the buildingStatus in the display or just
    # its children
    def populate_list(list_to_populate, building_status, nesting, include_status)
      if (!building_status.matches(@display_mask))
        return
      end
      t = building_status.get_exception
      is_core_exception = t.is_a?(CoreException)
      increment_nesting = false
      if (include_status)
        sb = StringBuffer.new
        i = 0
        while i < nesting
          sb.append(NESTING_INDENT)
          i += 1
        end
        message = building_status.get_message
        sb.append(message)
        list_to_populate.add(sb.to_s)
        increment_nesting = true
      end
      if (!is_core_exception && !(t).nil?)
        # Include low-level exception message
        sb = StringBuffer.new
        i = 0
        while i < nesting
          sb.append(NESTING_INDENT)
          i += 1
        end
        message = t.get_localized_message
        if ((message).nil?)
          message = RJava.cast_to_string(t.to_s)
        end
        sb.append(message)
        list_to_populate.add(sb.to_s)
        increment_nesting = true
      end
      if (increment_nesting)
        nesting += 1
      end
      # Look for a nested core exception
      if (is_core_exception)
        ce = t
        e_status = ce.get_status
        # Only print the exception message if it is not contained in the
        # parent message
        if ((self.attr_message).nil? || (self.attr_message.index_of(e_status.get_message)).equal?(-1))
          populate_list(list_to_populate, e_status, nesting, true)
        end
      end
      # Look for child status
      children = building_status.get_children
      i = 0
      while i < children.attr_length
        populate_list(list_to_populate, children[i], nesting, true)
        i += 1
      end
    end
    
    class_module.module_eval {
      typesig { [IStatus, ::Java::Int] }
      # Returns whether the given status object should be displayed.
      # 
      # @param status
      # a status object
      # @param mask
      # a mask as per <code>IStatus.matches</code>
      # @return <code>true</code> if the given status should be displayed, and
      # <code>false</code> otherwise
      # @see org.eclipse.core.runtime.IStatus#matches(int)
      def should_display(status, mask)
        children = status.get_children
        if ((children).nil? || (children.attr_length).equal?(0))
          return status.matches(mask)
        end
        i = 0
        while i < children.attr_length
          if (children[i].matches(mask))
            return true
          end
          i += 1
        end
        return false
      end
    }
    
    typesig { [] }
    # Toggles the unfolding of the details area. This is triggered by the user
    # pressing the details button.
    def toggle_details_area
      window_size = get_shell.get_size
      old_size = get_shell.compute_size(SWT::DEFAULT, SWT::DEFAULT)
      if (@list_created)
        @list.dispose
        @list_created = false
        @details_button.set_text(IDialogConstants::SHOW_DETAILS_LABEL)
      else
        @list = create_drop_down_list(get_contents)
        @details_button.set_text(IDialogConstants::HIDE_DETAILS_LABEL)
        get_contents.get_shell.layout
      end
      new_size = get_shell.compute_size(SWT::DEFAULT, SWT::DEFAULT)
      get_shell.set_size(Point.new(window_size.attr_x, window_size.attr_y + (new_size.attr_y - old_size.attr_y)))
    end
    
    typesig { [IStatus, StringBuffer, ::Java::Int] }
    # Put the details of the status of the error onto the stream.
    # 
    # @param buildingStatus
    # @param buffer
    # @param nesting
    def populate_copy_buffer(building_status, buffer, nesting)
      if (!building_status.matches(@display_mask))
        return
      end
      i = 0
      while i < nesting
        buffer.append(NESTING_INDENT)
        i += 1
      end
      buffer.append(building_status.get_message)
      buffer.append("\n") # $NON-NLS-1$
      # Look for a nested core exception
      t = building_status.get_exception
      if (t.is_a?(CoreException))
        ce = t
        populate_copy_buffer(ce.get_status, buffer, nesting + 1)
      else
        if (!(t).nil?)
          # Include low-level exception message
          i_ = 0
          while i_ < nesting
            buffer.append(NESTING_INDENT)
            i_ += 1
          end
          message = t.get_localized_message
          if ((message).nil?)
            message = RJava.cast_to_string(t.to_s)
          end
          buffer.append(message)
          buffer.append("\n") # $NON-NLS-1$
        end
      end
      children = building_status.get_children
      i_ = 0
      while i_ < children.attr_length
        populate_copy_buffer(children[i_], buffer, nesting + 1)
        i_ += 1
      end
    end
    
    typesig { [] }
    # Copy the contents of the statuses to the clipboard.
    def copy_to_clipboard
      if (!(@clipboard).nil?)
        @clipboard.dispose
      end
      status_buffer = StringBuffer.new
      populate_copy_buffer(@status, status_buffer, 0)
      @clipboard = Clipboard.new(@list.get_display)
      @clipboard.set_contents(Array.typed(Object).new([status_buffer.to_s]), Array.typed(Transfer).new([TextTransfer.get_instance]))
    end
    
    typesig { [] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.window.Window#close()
    def close
      if (!(@clipboard).nil?)
        @clipboard.dispose
      end
      return super
    end
    
    typesig { [] }
    # Show the details portion of the dialog if it is not already visible. This
    # method will only work when it is invoked after the control of the dialog
    # has been set. In other words, after the <code>createContents</code>
    # method has been invoked and has returned the control for the content area
    # of the dialog. Invoking the method before the content area has been set
    # or after the dialog has been disposed will have no effect.
    # 
    # @since 3.1
    def show_details_area
      if (!@list_created)
        control = get_contents
        if (!(control).nil? && !control.is_disposed)
          toggle_details_area
        end
      end
    end
    
    typesig { [] }
    # Return whether the Details button should be included. This method is
    # invoked once when the dialog is built. By default, the Details button is
    # only included if the status used when creating the dialog was a
    # multi-status or if the status contains an exception. Subclasses may
    # override.
    # 
    # @return whether the Details button should be included
    # @since 3.1
    def should_show_details_button
      return @status.is_multi_status || !(@status.get_exception).nil?
    end
    
    typesig { [IStatus] }
    # Set the status displayed by this error dialog to the given status. This
    # only affects the status displayed by the Details list. The message, image
    # and title should be updated by the subclass, if desired.
    # 
    # @param status
    # the status to be displayed in the details list
    # @since 3.1
    def set_status(status)
      if (!(@status).equal?(status))
        @status = status
      end
      @should_include_top_level_error_in_details = true
      if (@list_created)
        repopulate_list
      end
    end
    
    typesig { [] }
    # Repopulate the supplied list widget.
    def repopulate_list
      if (!(@list).nil? && !@list.is_disposed)
        @list.remove_all
        populate_list(@list)
      end
    end
    
    typesig { [] }
    # (non-Javadoc)
    # @see org.eclipse.jface.dialogs.IconAndMessageDialog#getColumnCount()
    def get_column_count
      if ((Policy.get_error_support_provider).nil?)
        return 2
      end
      return 3
    end
    
    typesig { [] }
    # (non-Javadoc)
    # @see org.eclipse.jface.dialogs.Dialog#isResizable()
    def is_resizable
      return true
    end
    
    private
    alias_method :initialize__error_dialog, :initialize
  end
  
end
