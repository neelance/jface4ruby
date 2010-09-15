require "rjava"

# Copyright (c) 2000, 2009 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
# Chris Gross (schtoo@schtoo.com) - patch for bug 16179
module Org::Eclipse::Jface::Wizard
  module WizardDialogImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Wizard
      include_const ::Java::Lang::Reflect, :InvocationTargetException
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :Map
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Core::Runtime, :IProgressMonitor
      include_const ::Org::Eclipse::Core::Runtime, :IStatus
      include_const ::Org::Eclipse::Core::Runtime, :ListenerList
      include_const ::Org::Eclipse::Jface::Dialogs, :ControlEnableState
      include_const ::Org::Eclipse::Jface::Dialogs, :IDialogConstants
      include_const ::Org::Eclipse::Jface::Dialogs, :IMessageProvider
      include_const ::Org::Eclipse::Jface::Dialogs, :IPageChangeProvider
      include_const ::Org::Eclipse::Jface::Dialogs, :IPageChangedListener
      include_const ::Org::Eclipse::Jface::Dialogs, :IPageChangingListener
      include_const ::Org::Eclipse::Jface::Dialogs, :MessageDialog
      include_const ::Org::Eclipse::Jface::Dialogs, :PageChangedEvent
      include_const ::Org::Eclipse::Jface::Dialogs, :PageChangingEvent
      include_const ::Org::Eclipse::Jface::Dialogs, :TitleAreaDialog
      include_const ::Org::Eclipse::Jface::Operation, :IRunnableWithProgress
      include_const ::Org::Eclipse::Jface::Operation, :ModalContext
      include_const ::Org::Eclipse::Jface::Resource, :JFaceResources
      include_const ::Org::Eclipse::Jface::Util, :SafeRunnable
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Custom, :BusyIndicator
      include_const ::Org::Eclipse::Swt::Events, :HelpEvent
      include_const ::Org::Eclipse::Swt::Events, :HelpListener
      include_const ::Org::Eclipse::Swt::Events, :SelectionAdapter
      include_const ::Org::Eclipse::Swt::Events, :SelectionEvent
      include_const ::Org::Eclipse::Swt::Graphics, :Cursor
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Graphics, :Rectangle
      include_const ::Org::Eclipse::Swt::Layout, :GridData
      include_const ::Org::Eclipse::Swt::Layout, :GridLayout
      include_const ::Org::Eclipse::Swt::Widgets, :Button
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Display
      include_const ::Org::Eclipse::Swt::Widgets, :Label
      include_const ::Org::Eclipse::Swt::Widgets, :Layout
      include_const ::Org::Eclipse::Swt::Widgets, :Shell
    }
  end
  
  # A dialog to show a wizard to the end user.
  # <p>
  # In typical usage, the client instantiates this class with a particular
  # wizard. The dialog serves as the wizard container and orchestrates the
  # presentation of its pages.
  # <p>
  # The standard layout is roughly as follows: it has an area at the top
  # containing both the wizard's title, description, and image; the actual wizard
  # page appears in the middle; below that is a progress indicator (which is made
  # visible if needed); and at the bottom of the page is message line and a
  # button bar containing Help, Next, Back, Finish, and Cancel buttons (or some
  # subset).
  # </p>
  # <p>
  # Clients may subclass <code>WizardDialog</code>, although this is rarely
  # required.
  # </p>
  class WizardDialog < WizardDialogImports.const_get :TitleAreaDialog
    include_class_members WizardDialogImports
    overload_protected {
      include IWizardContainer2
      include IPageChangeProvider
    }
    
    class_module.module_eval {
      # Image registry key for error message image (value
      # <code>"dialog_title_error_image"</code>).
      const_set_lazy(:WIZ_IMG_ERROR) { "dialog_title_error_image" }
      const_attr_reader  :WIZ_IMG_ERROR
    }
    
    # $NON-NLS-1$
    # The wizard the dialog is currently showing.
    attr_accessor :wizard
    alias_method :attr_wizard, :wizard
    undef_method :wizard
    alias_method :attr_wizard=, :wizard=
    undef_method :wizard=
    
    # Wizards to dispose
    attr_accessor :created_wizards
    alias_method :attr_created_wizards, :created_wizards
    undef_method :created_wizards
    alias_method :attr_created_wizards=, :created_wizards=
    undef_method :created_wizards=
    
    # Current nested wizards
    attr_accessor :nested_wizards
    alias_method :attr_nested_wizards, :nested_wizards
    undef_method :nested_wizards
    alias_method :attr_nested_wizards=, :nested_wizards=
    undef_method :nested_wizards=
    
    # The currently displayed page.
    attr_accessor :current_page
    alias_method :attr_current_page, :current_page
    undef_method :current_page
    alias_method :attr_current_page=, :current_page=
    undef_method :current_page=
    
    # The number of long running operation executed from the dialog.
    attr_accessor :active_running_operations
    alias_method :attr_active_running_operations, :active_running_operations
    undef_method :active_running_operations
    alias_method :attr_active_running_operations=, :active_running_operations=
    undef_method :active_running_operations=
    
    # The current page message and description
    attr_accessor :page_message
    alias_method :attr_page_message, :page_message
    undef_method :page_message
    alias_method :attr_page_message=, :page_message=
    undef_method :page_message=
    
    attr_accessor :page_message_type
    alias_method :attr_page_message_type, :page_message_type
    undef_method :page_message_type
    alias_method :attr_page_message_type=, :page_message_type=
    undef_method :page_message_type=
    
    attr_accessor :page_description
    alias_method :attr_page_description, :page_description
    undef_method :page_description
    alias_method :attr_page_description=, :page_description=
    undef_method :page_description=
    
    # The progress monitor
    attr_accessor :progress_monitor_part
    alias_method :attr_progress_monitor_part, :progress_monitor_part
    undef_method :progress_monitor_part
    alias_method :attr_progress_monitor_part=, :progress_monitor_part=
    undef_method :progress_monitor_part=
    
    attr_accessor :wait_cursor
    alias_method :attr_wait_cursor, :wait_cursor
    undef_method :wait_cursor
    alias_method :attr_wait_cursor=, :wait_cursor=
    undef_method :wait_cursor=
    
    attr_accessor :arrow_cursor
    alias_method :attr_arrow_cursor, :arrow_cursor
    undef_method :arrow_cursor
    alias_method :attr_arrow_cursor=, :arrow_cursor=
    undef_method :arrow_cursor=
    
    attr_accessor :window_closing_dialog
    alias_method :attr_window_closing_dialog, :window_closing_dialog
    undef_method :window_closing_dialog
    alias_method :attr_window_closing_dialog=, :window_closing_dialog=
    undef_method :window_closing_dialog=
    
    # Navigation buttons
    attr_accessor :back_button
    alias_method :attr_back_button, :back_button
    undef_method :back_button
    alias_method :attr_back_button=, :back_button=
    undef_method :back_button=
    
    attr_accessor :next_button
    alias_method :attr_next_button, :next_button
    undef_method :next_button
    alias_method :attr_next_button=, :next_button=
    undef_method :next_button=
    
    attr_accessor :finish_button
    alias_method :attr_finish_button, :finish_button
    undef_method :finish_button
    alias_method :attr_finish_button=, :finish_button=
    undef_method :finish_button=
    
    attr_accessor :cancel_button
    alias_method :attr_cancel_button, :cancel_button
    undef_method :cancel_button
    alias_method :attr_cancel_button=, :cancel_button=
    undef_method :cancel_button=
    
    attr_accessor :help_button
    alias_method :attr_help_button, :help_button
    undef_method :help_button
    alias_method :attr_help_button=, :help_button=
    undef_method :help_button=
    
    attr_accessor :cancel_listener
    alias_method :attr_cancel_listener, :cancel_listener
    undef_method :cancel_listener
    alias_method :attr_cancel_listener=, :cancel_listener=
    undef_method :cancel_listener=
    
    attr_accessor :is_moving_to_previous_page
    alias_method :attr_is_moving_to_previous_page, :is_moving_to_previous_page
    undef_method :is_moving_to_previous_page
    alias_method :attr_is_moving_to_previous_page=, :is_moving_to_previous_page=
    undef_method :is_moving_to_previous_page=
    
    attr_accessor :page_container
    alias_method :attr_page_container, :page_container
    undef_method :page_container
    alias_method :attr_page_container=, :page_container=
    undef_method :page_container=
    
    attr_accessor :page_container_layout
    alias_method :attr_page_container_layout, :page_container_layout
    undef_method :page_container_layout
    alias_method :attr_page_container_layout=, :page_container_layout=
    undef_method :page_container_layout=
    
    attr_accessor :page_width
    alias_method :attr_page_width, :page_width
    undef_method :page_width
    alias_method :attr_page_width=, :page_width=
    undef_method :page_width=
    
    attr_accessor :page_height
    alias_method :attr_page_height, :page_height
    undef_method :page_height
    alias_method :attr_page_height=, :page_height=
    undef_method :page_height=
    
    class_module.module_eval {
      const_set_lazy(:FOCUS_CONTROL) { "focusControl" }
      const_attr_reader  :FOCUS_CONTROL
    }
    
    # $NON-NLS-1$
    attr_accessor :locked_ui
    alias_method :attr_locked_ui, :locked_ui
    undef_method :locked_ui
    alias_method :attr_locked_ui=, :locked_ui=
    undef_method :locked_ui=
    
    attr_accessor :page_changed_listeners
    alias_method :attr_page_changed_listeners, :page_changed_listeners
    undef_method :page_changed_listeners
    alias_method :attr_page_changed_listeners=, :page_changed_listeners=
    undef_method :page_changed_listeners=
    
    attr_accessor :page_changing_listeners
    alias_method :attr_page_changing_listeners, :page_changing_listeners
    undef_method :page_changing_listeners
    alias_method :attr_page_changing_listeners=, :page_changing_listeners=
    undef_method :page_changing_listeners=
    
    class_module.module_eval {
      # A layout for a container which includes several pages, like a notebook,
      # wizard, or preference dialog. The size computed by this layout is the
      # maximum width and height of all pages currently inserted into the
      # container.
      const_set_lazy(:PageContainerFillLayout) { Class.new(Layout) do
        local_class_in WizardDialog
        include_class_members WizardDialog
        
        # The margin width; <code>5</code> pixels by default.
        attr_accessor :margin_width
        alias_method :attr_margin_width, :margin_width
        undef_method :margin_width
        alias_method :attr_margin_width=, :margin_width=
        undef_method :margin_width=
        
        # The margin height; <code>5</code> pixels by default.
        attr_accessor :margin_height
        alias_method :attr_margin_height, :margin_height
        undef_method :margin_height
        alias_method :attr_margin_height=, :margin_height=
        undef_method :margin_height=
        
        # The minimum width; <code>0</code> pixels by default.
        attr_accessor :minimum_width
        alias_method :attr_minimum_width, :minimum_width
        undef_method :minimum_width
        alias_method :attr_minimum_width=, :minimum_width=
        undef_method :minimum_width=
        
        # The minimum height; <code>0</code> pixels by default.
        attr_accessor :minimum_height
        alias_method :attr_minimum_height, :minimum_height
        undef_method :minimum_height
        alias_method :attr_minimum_height=, :minimum_height=
        undef_method :minimum_height=
        
        typesig { [::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int] }
        # Creates new layout object.
        # 
        # @param mw
        # the margin width
        # @param mh
        # the margin height
        # @param minW
        # the minimum width
        # @param minH
        # the minimum height
        def initialize(mw, mh, min_w, min_h)
          @margin_width = 0
          @margin_height = 0
          @minimum_width = 0
          @minimum_height = 0
          super()
          @margin_width = 5
          @margin_height = 5
          @minimum_width = 0
          @minimum_height = 0
          @margin_width = mw
          @margin_height = mh
          @minimum_width = min_w
          @minimum_height = min_h
        end
        
        typesig { [class_self::Composite, ::Java::Int, ::Java::Int, ::Java::Boolean] }
        # (non-Javadoc) Method declared on Layout.
        def compute_size(composite, w_hint, h_hint, force)
          if (!(w_hint).equal?(SWT::DEFAULT) && !(h_hint).equal?(SWT::DEFAULT))
            return self.class::Point.new(w_hint, h_hint)
          end
          result = nil
          children = composite.get_children
          if (children.attr_length > 0)
            result = self.class::Point.new(0, 0)
            i = 0
            while i < children.attr_length
              cp = children[i].compute_size(w_hint, h_hint, force)
              result.attr_x = Math.max(result.attr_x, cp.attr_x)
              result.attr_y = Math.max(result.attr_y, cp.attr_y)
              i += 1
            end
            result.attr_x = result.attr_x + 2 * @margin_width
            result.attr_y = result.attr_y + 2 * @margin_height
          else
            rect = composite.get_client_area
            result = self.class::Point.new(rect.attr_width, rect.attr_height)
          end
          result.attr_x = Math.max(result.attr_x, @minimum_width)
          result.attr_y = Math.max(result.attr_y, @minimum_height)
          if (!(w_hint).equal?(SWT::DEFAULT))
            result.attr_x = w_hint
          end
          if (!(h_hint).equal?(SWT::DEFAULT))
            result.attr_y = h_hint
          end
          return result
        end
        
        typesig { [class_self::Composite] }
        # Returns the client area for the given composite according to this
        # layout.
        # 
        # @param c
        # the composite
        # @return the client area rectangle
        def get_client_area(c)
          rect = c.get_client_area
          rect.attr_x = rect.attr_x + @margin_width
          rect.attr_y = rect.attr_y + @margin_height
          rect.attr_width = rect.attr_width - 2 * @margin_width
          rect.attr_height = rect.attr_height - 2 * @margin_height
          return rect
        end
        
        typesig { [class_self::Composite, ::Java::Boolean] }
        # (non-Javadoc) Method declared on Layout.
        def layout(composite, force)
          rect = get_client_area(composite)
          children = composite.get_children
          i = 0
          while i < children.attr_length
            children[i].set_bounds(rect)
            i += 1
          end
        end
        
        typesig { [class_self::Control] }
        # Lays outs the page according to this layout.
        # 
        # @param w
        # the control
        def layout_page(w)
          w.set_bounds(get_client_area(w.get_parent))
        end
        
        typesig { [class_self::Control] }
        # Sets the location of the page so that its origin is in the upper left
        # corner.
        # 
        # @param w
        # the control
        def set_page_location(w)
          w.set_location(@margin_width, @margin_height)
        end
        
        private
        alias_method :initialize__page_container_fill_layout, :initialize
      end }
    }
    
    typesig { [Shell, IWizard] }
    # Creates a new wizard dialog for the given wizard.
    # 
    # @param parentShell
    # the parent shell
    # @param newWizard
    # the wizard this dialog is working on
    def initialize(parent_shell, new_wizard)
      @wizard = nil
      @created_wizards = nil
      @nested_wizards = nil
      @current_page = nil
      @active_running_operations = 0
      @page_message = nil
      @page_message_type = 0
      @page_description = nil
      @progress_monitor_part = nil
      @wait_cursor = nil
      @arrow_cursor = nil
      @window_closing_dialog = nil
      @back_button = nil
      @next_button = nil
      @finish_button = nil
      @cancel_button = nil
      @help_button = nil
      @cancel_listener = nil
      @is_moving_to_previous_page = false
      @page_container = nil
      @page_container_layout = nil
      @page_width = 0
      @page_height = 0
      @locked_ui = false
      @page_changed_listeners = nil
      @page_changing_listeners = nil
      super(parent_shell)
      @created_wizards = ArrayList.new
      @nested_wizards = ArrayList.new
      @current_page = nil
      @active_running_operations = 0
      @page_message_type = IMessageProvider::NONE
      @is_moving_to_previous_page = false
      @page_container_layout = PageContainerFillLayout.new_local(self, 5, 5, 300, 225)
      @page_width = SWT::DEFAULT
      @page_height = SWT::DEFAULT
      @locked_ui = false
      @page_changed_listeners = ListenerList.new
      @page_changing_listeners = ListenerList.new
      set_shell_style(SWT::CLOSE | SWT::MAX | SWT::TITLE | SWT::BORDER | SWT::APPLICATION_MODAL | SWT::RESIZE | get_default_orientation)
      set_wizard(new_wizard)
      @cancel_listener = # since VAJava can't initialize an instance var with an anonymous
      # class outside a constructor we do it here:
      Class.new(SelectionAdapter.class == Class ? SelectionAdapter : Object) do
        local_class_in WizardDialog
        include_class_members WizardDialog
        include SelectionAdapter if SelectionAdapter.class == Module
        
        typesig { [SelectionEvent] }
        define_method :widget_selected do |e|
          cancel_pressed
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
    end
    
    typesig { [::Java::Boolean] }
    # About to start a long running operation triggered through the wizard.
    # Shows the progress monitor and disables the wizard's buttons and
    # controls.
    # 
    # @param enableCancelButton
    # <code>true</code> if the Cancel button should be enabled,
    # and <code>false</code> if it should be disabled
    # @return the saved UI state
    def about_to_start(enable_cancel_button)
      saved_state = nil
      if (!(get_shell).nil?)
        # Save focus control
        focus_control = get_shell.get_display.get_focus_control
        if (!(focus_control).nil? && !(focus_control.get_shell).equal?(get_shell))
          focus_control = nil
        end
        needs_progress_monitor_ = @wizard.needs_progress_monitor
        @cancel_button.remove_selection_listener(@cancel_listener)
        # Set the busy cursor to all shells.
        d = get_shell.get_display
        @wait_cursor = Cursor.new(d, SWT::CURSOR_WAIT)
        set_display_cursor(@wait_cursor)
        # Set the arrow cursor to the cancel component.
        @arrow_cursor = Cursor.new(d, SWT::CURSOR_ARROW)
        @cancel_button.set_cursor(@arrow_cursor)
        # Deactivate shell
        saved_state = save_uistate(needs_progress_monitor_ && enable_cancel_button)
        if (!(focus_control).nil?)
          saved_state.put(FOCUS_CONTROL, focus_control)
        end
        # Attach the progress monitor part to the cancel button
        if (needs_progress_monitor_)
          @progress_monitor_part.attach_to_cancel_component(@cancel_button)
          @progress_monitor_part.set_visible(true)
        end
      end
      return saved_state
    end
    
    typesig { [] }
    # The Back button has been pressed.
    def back_pressed
      page = @current_page.get_previous_page
      if ((page).nil?)
        # should never happen since we have already visited the page
        return
      end
      # set flag to indicate that we are moving back
      @is_moving_to_previous_page = true
      # show the page
      show_page(page)
    end
    
    typesig { [::Java::Int] }
    # (non-Javadoc) Method declared on Dialog.
    def button_pressed(button_id)
      case (button_id)
      when IDialogConstants::HELP_ID
        help_pressed
      when IDialogConstants::BACK_ID
        back_pressed
      when IDialogConstants::NEXT_ID
        next_pressed
      when IDialogConstants::FINISH_ID
        finish_pressed
      end
      # The Cancel button has a listener which calls cancelPressed
      # directly
    end
    
    typesig { [IWizardPage] }
    # Calculates the difference in size between the given page and the page
    # container. A larger page results in a positive delta.
    # 
    # @param page
    # the page
    # @return the size difference encoded as a
    # <code>new Point(deltaWidth,deltaHeight)</code>
    def calculate_page_size_delta(page)
      page_control = page.get_control
      if ((page_control).nil?)
        # control not created yet
        return Point.new(0, 0)
      end
      content_size = page_control.compute_size(SWT::DEFAULT, SWT::DEFAULT, true)
      rect = @page_container_layout.get_client_area(@page_container)
      container_size = Point.new(rect.attr_width, rect.attr_height)
      return Point.new(Math.max(0, content_size.attr_x - container_size.attr_x), Math.max(0, content_size.attr_y - container_size.attr_y))
    end
    
    typesig { [] }
    # (non-Javadoc) Method declared on Dialog.
    def cancel_pressed
      if (@active_running_operations <= 0)
        # Close the dialog. The check whether the dialog can be
        # closed or not is done in <code>okToClose</code>.
        # This ensures that the check is also evaluated when the user
        # presses the window's close button.
        set_return_code(CANCEL)
        close
      else
        @cancel_button.set_enabled(false)
      end
    end
    
    typesig { [] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.window.Window#close()
    def close
      if (ok_to_close)
        return hard_close
      end
      return false
    end
    
    typesig { [Shell] }
    # (non-Javadoc) Method declared on Window.
    def configure_shell(new_shell)
      super(new_shell)
      new_shell.add_help_listener(# Register help listener on the shell
      Class.new(HelpListener.class == Class ? HelpListener : Object) do
        local_class_in WizardDialog
        include_class_members WizardDialog
        include HelpListener if HelpListener.class == Module
        
        typesig { [HelpEvent] }
        define_method :help_requested do |event|
          # call perform help on the current page
          if (!(self.attr_current_page).nil?)
            self.attr_current_page.perform_help
          end
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
    end
    
    typesig { [Composite] }
    # Creates the buttons for this dialog's button bar.
    # <p>
    # The <code>WizardDialog</code> implementation of this framework method
    # prevents the parent composite's columns from being made equal width in
    # order to remove the margin between the Back and Next buttons.
    # </p>
    # 
    # @param parent
    # the parent composite to contain the buttons
    def create_buttons_for_button_bar(parent)
      (parent.get_layout).attr_make_columns_equal_width = false
      if (@wizard.is_help_available)
        @help_button = create_button(parent, IDialogConstants::HELP_ID, IDialogConstants::HELP_LABEL, false)
      end
      if (@wizard.needs_previous_and_next_buttons)
        create_previous_and_next_buttons(parent)
      end
      @finish_button = create_button(parent, IDialogConstants::FINISH_ID, IDialogConstants::FINISH_LABEL, true)
      @cancel_button = create_cancel_button(parent)
      if ((parent.get_display.get_dismissal_alignment).equal?(SWT::RIGHT))
        # Make the default button the right-most button.
        # See also special code in org.eclipse.jface.dialogs.Dialog#initializeBounds()
        @finish_button.move_below(nil)
      end
    end
    
    typesig { [Button] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.dialogs.Dialog#setButtonLayoutData(org.eclipse.swt.widgets.Button)
    def set_button_layout_data(button)
      data = GridData.new(GridData::HORIZONTAL_ALIGN_FILL)
      width_hint = convert_horizontal_dlus_to_pixels(IDialogConstants::BUTTON_WIDTH)
      # On large fonts this can make this dialog huge
      width_hint = Math.min(width_hint, button.get_display.get_bounds.attr_width / 5)
      min_size = button.compute_size(SWT::DEFAULT, SWT::DEFAULT, true)
      data.attr_width_hint = Math.max(width_hint, min_size.attr_x)
      button.set_layout_data(data)
    end
    
    typesig { [Composite] }
    # Creates the Cancel button for this wizard dialog. Creates a standard (<code>SWT.PUSH</code>)
    # button and registers for its selection events. Note that the number of
    # columns in the button bar composite is incremented. The Cancel button is
    # created specially to give it a removeable listener.
    # 
    # @param parent
    # the parent button bar
    # @return the new Cancel button
    def create_cancel_button(parent)
      # increment the number of columns in the button bar
      (parent.get_layout).attr_num_columns += 1
      button = Button.new(parent, SWT::PUSH)
      button.set_text(IDialogConstants::CANCEL_LABEL)
      set_button_layout_data(button)
      button.set_font(parent.get_font)
      button.set_data(IDialogConstants::CANCEL_ID)
      button.add_selection_listener(@cancel_listener)
      return button
    end
    
    typesig { [::Java::Int] }
    # Return the cancel button if the id is a the cancel id.
    # 
    # @param id
    # the button id
    # @return the button corresponding to the button id
    def get_button(id)
      if ((id).equal?(IDialogConstants::CANCEL_ID))
        return @cancel_button
      end
      return super(id)
    end
    
    typesig { [Composite] }
    # The <code>WizardDialog</code> implementation of this
    # <code>Window</code> method calls call <code>IWizard.addPages</code>
    # to allow the current wizard to add extra pages, then
    # <code>super.createContents</code> to create the controls. It then calls
    # <code>IWizard.createPageControls</code> to allow the wizard to
    # pre-create their page controls prior to opening, so that the wizard opens
    # to the correct size. And finally it shows the first page.
    def create_contents(parent)
      # Allow the wizard to add pages to itself
      # Need to call this now so page count is correct
      # for determining if next/previous buttons are needed
      @wizard.add_pages
      contents = super(parent)
      # Allow the wizard pages to precreate their page controls
      create_page_controls
      # Show the first page
      show_starting_page
      return contents
    end
    
    typesig { [Composite] }
    # (non-Javadoc) Method declared on Dialog.
    def create_dialog_area(parent)
      composite = super(parent)
      # Build the Page container
      @page_container = create_page_container(composite)
      gd = GridData.new(GridData::FILL_BOTH)
      gd.attr_width_hint = @page_width
      gd.attr_height_hint = @page_height
      @page_container.set_layout_data(gd)
      @page_container.set_font(parent.get_font)
      # Insert a progress monitor
      pmlayout = GridLayout.new
      pmlayout.attr_num_columns = 1
      @progress_monitor_part = create_progress_monitor_part(composite, pmlayout)
      grid_data = GridData.new(GridData::FILL_HORIZONTAL)
      @progress_monitor_part.set_layout_data(grid_data)
      @progress_monitor_part.set_visible(false)
      # Build the separator line
      separator = Label.new(composite, SWT::HORIZONTAL | SWT::SEPARATOR)
      separator.set_layout_data(GridData.new(GridData::FILL_HORIZONTAL))
      apply_dialog_font(@progress_monitor_part)
      return composite
    end
    
    typesig { [Composite, GridLayout] }
    # Create the progress monitor part in the receiver.
    # 
    # @param composite
    # @param pmlayout
    # @return ProgressMonitorPart
    def create_progress_monitor_part(composite, pmlayout)
      return Class.new(ProgressMonitorPart.class == Class ? ProgressMonitorPart : Object) do
        local_class_in WizardDialog
        include_class_members WizardDialog
        include ProgressMonitorPart if ProgressMonitorPart.class == Module
        
        attr_accessor :current_task
        alias_method :attr_current_task, :current_task
        undef_method :current_task
        alias_method :attr_current_task=, :current_task=
        undef_method :current_task=
        
        typesig { [IStatus] }
        # (non-Javadoc)
        # 
        # @see org.eclipse.jface.wizard.ProgressMonitorPart#setBlocked(org.eclipse.core.runtime.IStatus)
        define_method :set_blocked do |reason|
          super(reason)
          if (!self.attr_locked_ui)
            get_blocked_handler.show_blocked(get_shell, self, reason, @current_task)
          end
        end
        
        typesig { [] }
        # (non-Javadoc)
        # 
        # @see org.eclipse.jface.wizard.ProgressMonitorPart#clearBlocked()
        define_method :clear_blocked do
          super
          if (!self.attr_locked_ui)
            get_blocked_handler.clear_blocked
          end
        end
        
        typesig { [String, ::Java::Int] }
        # (non-Javadoc)
        # 
        # @see org.eclipse.jface.wizard.ProgressMonitorPart#beginTask(java.lang.String,
        # int)
        define_method :begin_task do |name, total_work|
          super(name, total_work)
          @current_task = name
        end
        
        typesig { [String] }
        # (non-Javadoc)
        # 
        # @see org.eclipse.jface.wizard.ProgressMonitorPart#setTaskName(java.lang.String)
        define_method :set_task_name do |name|
          super(name)
          @current_task = name
        end
        
        typesig { [String] }
        # (non-Javadoc)
        # 
        # @see org.eclipse.jface.wizard.ProgressMonitorPart#subTask(java.lang.String)
        define_method :sub_task do |name|
          super(name)
          # If we haven't got anything yet use this value for more
          # context
          if ((@current_task).nil?)
            @current_task = name
          end
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          @current_task = nil
          super(*args)
          @current_task = nil
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self, composite, pmlayout, SWT::DEFAULT)
    end
    
    typesig { [Composite] }
    # Creates the container that holds all pages.
    # 
    # @param parent
    # @return Composite
    def create_page_container(parent)
      result = Composite.new(parent, SWT::NULL)
      result.set_layout(@page_container_layout)
      return result
    end
    
    typesig { [] }
    # Allow the wizard's pages to pre-create their page controls. This allows
    # the wizard dialog to open to the correct size.
    def create_page_controls
      # Allow the wizard pages to precreate their page controls
      # This allows the wizard to open to the correct size
      @wizard.create_page_controls(@page_container)
      # Ensure that all of the created pages are initially not visible
      pages = @wizard.get_pages
      i = 0
      while i < pages.attr_length
        page = pages[i]
        if (!(page.get_control).nil?)
          page.get_control.set_visible(false)
        end
        i += 1
      end
    end
    
    typesig { [Composite] }
    # Creates the Previous and Next buttons for this wizard dialog. Creates
    # standard (<code>SWT.PUSH</code>) buttons and registers for their
    # selection events. Note that the number of columns in the button bar
    # composite is incremented. These buttons are created specially to prevent
    # any space between them.
    # 
    # @param parent
    # the parent button bar
    # @return a composite containing the new buttons
    def create_previous_and_next_buttons(parent)
      # increment the number of columns in the button bar
      (parent.get_layout).attr_num_columns += 1
      composite = Composite.new(parent, SWT::NONE)
      # create a layout with spacing and margins appropriate for the font
      # size.
      layout = GridLayout.new
      layout.attr_num_columns = 0 # will be incremented by createButton
      layout.attr_margin_width = 0
      layout.attr_margin_height = 0
      layout.attr_horizontal_spacing = 0
      layout.attr_vertical_spacing = 0
      composite.set_layout(layout)
      data = GridData.new(GridData::HORIZONTAL_ALIGN_CENTER | GridData::VERTICAL_ALIGN_CENTER)
      composite.set_layout_data(data)
      composite.set_font(parent.get_font)
      @back_button = create_button(composite, IDialogConstants::BACK_ID, IDialogConstants::BACK_LABEL, false)
      @next_button = create_button(composite, IDialogConstants::NEXT_ID, IDialogConstants::NEXT_LABEL, false)
      return composite
    end
    
    typesig { [] }
    # Creates and return a new wizard closing dialog without openiong it.
    # 
    # @return MessageDalog
    def create_wizard_closing_dialog
      result = # $NON-NLS-1$
      # $NON-NLS-1$
      Class.new(MessageDialog.class == Class ? MessageDialog : Object) do
        local_class_in WizardDialog
        include_class_members WizardDialog
        include MessageDialog if MessageDialog.class == Module
        
        typesig { [] }
        define_method :get_shell_style do
          return super | SWT::SHEET
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self, get_shell, JFaceResources.get_string("WizardClosingDialog.title"), nil, JFaceResources.get_string("WizardClosingDialog.message"), MessageDialog::QUESTION, Array.typed(String).new([IDialogConstants::OK_LABEL]), 0)
      return result
    end
    
    typesig { [] }
    # The Finish button has been pressed.
    def finish_pressed
      # Wizards are added to the nested wizards list in setWizard.
      # This means that the current wizard is always the last wizard in the
      # list.
      # Note that we first call the current wizard directly (to give it a
      # chance to
      # abort, do work, and save state) then call the remaining n-1 wizards
      # in the
      # list (to save state).
      if (@wizard.perform_finish)
        # Call perform finish on outer wizards in the nested chain
        # (to allow them to save state for example)
        i = 0
        while i < @nested_wizards.size - 1
          (@nested_wizards.get(i)).perform_finish
          i += 1
        end
        # Hard close the dialog.
        set_return_code(OK)
        hard_close
      end
    end
    
    typesig { [] }
    # (non-Javadoc) Method declared on IWizardContainer.
    def get_current_page
      return @current_page
    end
    
    typesig { [] }
    # Returns the progress monitor for this wizard dialog (if it has one).
    # 
    # @return the progress monitor, or <code>null</code> if this wizard
    # dialog does not have one
    def get_progress_monitor
      return @progress_monitor_part
    end
    
    typesig { [] }
    # Returns the wizard this dialog is currently displaying.
    # 
    # @return the current wizard
    def get_wizard
      return @wizard
    end
    
    typesig { [] }
    # Closes this window.
    # 
    # @return <code>true</code> if the window is (or was already) closed, and
    # <code>false</code> if it is still open
    def hard_close
      # inform wizards
      i = 0
      while i < @created_wizards.size
        created_wizard = @created_wizards.get(i)
        created_wizard.dispose
        # Remove this dialog as a parent from the managed wizard.
        # Note that we do this after calling dispose as the wizard or
        # its pages may need access to the container during
        # dispose code
        created_wizard.set_container(nil)
        i += 1
      end
      return TitleAreaDialog.instance_method(:close).bind(self).call
    end
    
    typesig { [] }
    # The Help button has been pressed.
    def help_pressed
      if (!(@current_page).nil?)
        @current_page.perform_help
      end
    end
    
    typesig { [] }
    # The Next button has been pressed.
    def next_pressed
      page = @current_page.get_next_page
      if ((page).nil?)
        # something must have happend getting the next page
        return
      end
      # show the next page
      show_page(page)
    end
    
    typesig { [IWizardPage] }
    # Notifies page changing listeners and returns result of page changing
    # processing to the sender.
    # 
    # @param eventType
    # @return <code>true</code> if page changing listener completes
    # successfully, <code>false</code> otherwise
    def do_page_changing(target_page)
      e = PageChangingEvent.new(self, get_current_page, target_page)
      fire_page_changing(e)
      # Prevent navigation if necessary
      return e.attr_doit
    end
    
    typesig { [] }
    # Checks whether it is alright to close this wizard dialog and performed
    # standard cancel processing. If there is a long running operation in
    # progress, this method posts an alert message saying that the wizard
    # cannot be closed.
    # 
    # @return <code>true</code> if it is alright to close this dialog, and
    # <code>false</code> if it is not
    def ok_to_close
      if (@active_running_operations > 0)
        synchronized((self)) do
          @window_closing_dialog = create_wizard_closing_dialog
        end
        @window_closing_dialog.open
        synchronized((self)) do
          @window_closing_dialog = nil
        end
        return false
      end
      return @wizard.perform_cancel
    end
    
    typesig { [Control, Map, String] }
    # Restores the enabled/disabled state of the given control.
    # 
    # @param w
    # the control
    # @param h
    # the map (key type: <code>String</code>, element type:
    # <code>Boolean</code>)
    # @param key
    # the key
    # @see #saveEnableStateAndSet
    def restore_enable_state(w, h, key)
      if (!(w).nil?)
        b = h.get(key)
        if (!(b).nil?)
          w.set_enabled(b.boolean_value)
        end
      end
    end
    
    typesig { [Map] }
    # Restores the enabled/disabled state of the wizard dialog's buttons and
    # the tree of controls for the currently showing page.
    # 
    # @param state
    # a map containing the saved state as returned by
    # <code>saveUIState</code>
    # @see #saveUIState
    def restore_uistate(state)
      restore_enable_state(@back_button, state, "back") # $NON-NLS-1$
      restore_enable_state(@next_button, state, "next") # $NON-NLS-1$
      restore_enable_state(@finish_button, state, "finish") # $NON-NLS-1$
      restore_enable_state(@cancel_button, state, "cancel") # $NON-NLS-1$
      restore_enable_state(@help_button, state, "help") # $NON-NLS-1$
      page_value = state.get("page") # $NON-NLS-1$
      if (!(page_value).nil?)
        (page_value).restore
      end
    end
    
    typesig { [::Java::Boolean, ::Java::Boolean, IRunnableWithProgress] }
    # This implementation of IRunnableContext#run(boolean, boolean,
    # IRunnableWithProgress) blocks until the runnable has been run, regardless
    # of the value of <code>fork</code>. It is recommended that
    # <code>fork</code> is set to true in most cases. If <code>fork</code>
    # is set to <code>false</code>, the runnable will run in the UI thread
    # and it is the runnable's responsibility to call
    # <code>Display.readAndDispatch()</code> to ensure UI responsiveness.
    # 
    # UI state is saved prior to executing the long-running operation and is
    # restored after the long-running operation completes executing. Any
    # attempt to change the UI state of the wizard in the long-running
    # operation will be nullified when original UI state is restored.
    def run(fork, cancelable, runnable)
      # The operation can only be canceled if it is executed in a separate
      # thread.
      # Otherwise the UI is blocked anyway.
      state = nil
      if ((@active_running_operations).equal?(0))
        state = about_to_start(fork && cancelable)
      end
      @active_running_operations += 1
      begin
        if (!fork)
          @locked_ui = true
        end
        ModalContext.run(runnable, fork, get_progress_monitor, get_shell.get_display)
        @locked_ui = false
      ensure
        @active_running_operations -= 1
        # Stop if this is the last one
        if (!(state).nil?)
          stopped(state)
        end
      end
    end
    
    typesig { [Control, Map, String, ::Java::Boolean] }
    # Saves the enabled/disabled state of the given control in the given map,
    # which must be modifiable.
    # 
    # @param w
    # the control, or <code>null</code> if none
    # @param h
    # the map (key type: <code>String</code>, element type:
    # <code>Boolean</code>)
    # @param key
    # the key
    # @param enabled
    # <code>true</code> to enable the control, and
    # <code>false</code> to disable it
    # @see #restoreEnableState(Control, Map, String)
    def save_enable_state_and_set(w, h, key, enabled)
      if (!(w).nil?)
        h.put(key, w.get_enabled ? Boolean::TRUE : Boolean::FALSE)
        w.set_enabled(enabled)
      end
    end
    
    typesig { [::Java::Boolean] }
    # Captures and returns the enabled/disabled state of the wizard dialog's
    # buttons and the tree of controls for the currently showing page. All
    # these controls are disabled in the process, with the possible exception
    # of the Cancel button.
    # 
    # @param keepCancelEnabled
    # <code>true</code> if the Cancel button should remain
    # enabled, and <code>false</code> if it should be disabled
    # @return a map containing the saved state suitable for restoring later
    # with <code>restoreUIState</code>
    # @see #restoreUIState
    def save_uistate(keep_cancel_enabled)
      saved_state = HashMap.new(10)
      save_enable_state_and_set(@back_button, saved_state, "back", false) # $NON-NLS-1$
      save_enable_state_and_set(@next_button, saved_state, "next", false) # $NON-NLS-1$
      save_enable_state_and_set(@finish_button, saved_state, "finish", false) # $NON-NLS-1$
      save_enable_state_and_set(@cancel_button, saved_state, "cancel", keep_cancel_enabled) # $NON-NLS-1$
      save_enable_state_and_set(@help_button, saved_state, "help", false) # $NON-NLS-1$
      if (!(@current_page).nil?)
        saved_state.put("page", ControlEnableState.disable(@current_page.get_control)) # $NON-NLS-1$
      end
      return saved_state
    end
    
    typesig { [Cursor] }
    # Sets the given cursor for all shells currently active for this window's
    # display.
    # 
    # @param c
    # the cursor
    def set_display_cursor(c)
      shells = get_shell.get_display.get_shells
      i = 0
      while i < shells.attr_length
        shells[i].set_cursor(c)
        i += 1
      end
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Sets the minimum page size used for the pages.
    # 
    # @param minWidth
    # the minimum page width
    # @param minHeight
    # the minimum page height
    # @see #setMinimumPageSize(Point)
    def set_minimum_page_size(min_width, min_height)
      Assert.is_true(min_width >= 0 && min_height >= 0)
      @page_container_layout.attr_minimum_width = min_width
      @page_container_layout.attr_minimum_height = min_height
    end
    
    typesig { [Point] }
    # Sets the minimum page size used for the pages.
    # 
    # @param size
    # the page size encoded as <code>new Point(width,height)</code>
    # @see #setMinimumPageSize(int,int)
    def set_minimum_page_size(size_)
      set_minimum_page_size(size_.attr_x, size_.attr_y)
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Sets the size of all pages. The given size takes precedence over computed
    # sizes.
    # 
    # @param width
    # the page width
    # @param height
    # the page height
    # @see #setPageSize(Point)
    def set_page_size(width, height)
      @page_width = width
      @page_height = height
    end
    
    typesig { [Point] }
    # Sets the size of all pages. The given size takes precedence over computed
    # sizes.
    # 
    # @param size
    # the page size encoded as <code>new Point(width,height)</code>
    # @see #setPageSize(int,int)
    def set_page_size(size_)
      set_page_size(size_.attr_x, size_.attr_y)
    end
    
    typesig { [IWizard] }
    # Sets the wizard this dialog is currently displaying.
    # 
    # @param newWizard
    # the wizard
    def set_wizard(new_wizard)
      @wizard = new_wizard
      @wizard.set_container(self)
      if (!@created_wizards.contains(@wizard))
        @created_wizards.add(@wizard)
        # New wizard so just add it to the end of our nested list
        @nested_wizards.add(@wizard)
        if (!(@page_container).nil?)
          # Dialog is already open
          # Allow the wizard pages to precreate their page controls
          # This allows the wizard to open to the correct size
          create_page_controls
          # Ensure the dialog is large enough for the wizard
          update_size_for_wizard(@wizard)
          @page_container.layout(true)
        end
      else
        # We have already seen this wizard, if it is the previous wizard
        # on the nested list then we assume we have gone back and remove
        # the last wizard from the list
        size_ = @nested_wizards.size
        if (size_ >= 2 && (@nested_wizards.get(size_ - 2)).equal?(@wizard))
          @nested_wizards.remove(size_ - 1)
        else
          # Assume we are going forward to revisit a wizard
          @nested_wizards.add(@wizard)
        end
      end
    end
    
    typesig { [IWizardPage] }
    # (non-Javadoc) Method declared on IWizardContainer.
    def show_page(page)
      if ((page).nil? || (page).equal?(@current_page))
        return
      end
      if (!@is_moving_to_previous_page)
        # remember my previous page.
        page.set_previous_page(@current_page)
      else
        @is_moving_to_previous_page = false
      end
      # If page changing evaluation unsuccessful, do not change the page
      if (!do_page_changing(page))
        return
      end
      # Update for the new page in a busy cursor if possible
      if ((get_contents).nil?)
        update_for_page(page)
      else
        final_page = page
        BusyIndicator.show_while(get_contents.get_display, Class.new(Runnable.class == Class ? Runnable : Object) do
          local_class_in WizardDialog
          include_class_members WizardDialog
          include Runnable if Runnable.class == Module
          
          typesig { [] }
          define_method :run do
            update_for_page(final_page)
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      end
    end
    
    typesig { [IWizardPage] }
    # Update the receiver for the new page.
    # 
    # @param page
    def update_for_page(page)
      # ensure this page belongs to the current wizard
      if (!(@wizard).equal?(page.get_wizard))
        set_wizard(page.get_wizard)
      end
      # ensure that page control has been created
      # (this allows lazy page control creation)
      if ((page.get_control).nil?)
        page.create_control(@page_container)
        # the page is responsible for ensuring the created control is
        # accessable
        # via getControl.
        # $NON-NLS-1$
        Assert.is_not_null(page.get_control, JFaceResources.format(JFaceResources.get_string("WizardDialog.missingSetControl"), Array.typed(Object).new([page.get_name])))
        # ensure the dialog is large enough for this page
        update_size(page)
      end
      # make the new page visible
      old_page = @current_page
      @current_page = page
      @current_page.set_visible(true)
      if (!(old_page).nil?)
        old_page.set_visible(false)
      end
      # update the dialog controls
      update
    end
    
    typesig { [] }
    # Shows the starting page of the wizard.
    def show_starting_page
      @current_page = @wizard.get_starting_page
      if ((@current_page).nil?)
        # something must have happend getting the page
        return
      end
      # ensure the page control has been created
      if ((@current_page.get_control).nil?)
        @current_page.create_control(@page_container)
        # the page is responsible for ensuring the created control is
        # accessable
        # via getControl.
        Assert.is_not_null(@current_page.get_control)
        # we do not need to update the size since the call
        # to initialize bounds has not been made yet.
      end
      # make the new page visible
      @current_page.set_visible(true)
      # update the dialog controls
      update
    end
    
    typesig { [Object] }
    # A long running operation triggered through the wizard was stopped either
    # by user input or by normal end. Hides the progress monitor and restores
    # the enable state wizard's buttons and controls.
    # 
    # @param savedState
    # the saved UI state as returned by <code>aboutToStart</code>
    # @see #aboutToStart
    def stopped(saved_state)
      if (!(get_shell).nil? && !get_shell.is_disposed)
        if (@wizard.needs_progress_monitor)
          @progress_monitor_part.set_visible(false)
          @progress_monitor_part.remove_from_cancel_component(@cancel_button)
        end
        state = saved_state
        restore_uistate(state)
        @cancel_button.add_selection_listener(@cancel_listener)
        set_display_cursor(nil)
        @cancel_button.set_cursor(nil)
        @wait_cursor.dispose
        @wait_cursor = nil
        @arrow_cursor.dispose
        @arrow_cursor = nil
        focus_control = state.get(FOCUS_CONTROL)
        if (!(focus_control).nil? && !focus_control.is_disposed)
          focus_control.set_focus
        end
      end
    end
    
    typesig { [] }
    # Updates this dialog's controls to reflect the current page.
    def update
      # Update the window title
      update_window_title
      # Update the title bar
      update_title_bar
      # Update the buttons
      update_buttons
      # Fires the page change event
      fire_page_changed(PageChangedEvent.new(self, get_current_page))
    end
    
    typesig { [] }
    # (non-Javadoc) Method declared on IWizardContainer.
    def update_buttons
      can_flip_to_next_page = false
      can_finish_ = @wizard.can_finish
      if (!(@back_button).nil?)
        @back_button.set_enabled(!(@current_page.get_previous_page).nil?)
      end
      if (!(@next_button).nil?)
        can_flip_to_next_page = @current_page.can_flip_to_next_page
        @next_button.set_enabled(can_flip_to_next_page)
      end
      @finish_button.set_enabled(can_finish_)
      # finish is default unless it is diabled and next is enabled
      if (can_flip_to_next_page && !can_finish_)
        get_shell.set_default_button(@next_button)
      else
        get_shell.set_default_button(@finish_button)
      end
    end
    
    typesig { [] }
    # Update the message line with the page's description.
    # <p>
    # A discription is shown only if there is no message or error message.
    # </p>
    def update_description_message
      @page_description = RJava.cast_to_string(@current_page.get_description)
      set_message(@page_description)
    end
    
    typesig { [] }
    # (non-Javadoc) Method declared on IWizardContainer.
    def update_message
      if ((@current_page).nil?)
        return
      end
      @page_message = RJava.cast_to_string(@current_page.get_message)
      if (!(@page_message).nil? && @current_page.is_a?(IMessageProvider))
        @page_message_type = (@current_page).get_message_type
      else
        @page_message_type = IMessageProvider::NONE
      end
      if ((@page_message).nil?)
        set_message(@page_description)
      else
        set_message(@page_message, @page_message_type)
      end
      set_error_message(@current_page.get_error_message)
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Changes the shell size to the given size, ensuring that it is no larger
    # than the display bounds.
    # 
    # @param width
    # the shell width
    # @param height
    # the shell height
    def set_shell_size(width, height)
      size_ = get_shell.get_bounds
      size_.attr_height = height
      size_.attr_width = width
      get_shell.set_bounds(get_constrained_shell_bounds(size_))
    end
    
    typesig { [IWizardPage] }
    # Computes the correct dialog size for the current page and resizes its
    # shell if nessessary. Also causes the container to refresh its layout.
    # 
    # @param page
    # the wizard page to use to resize the dialog
    # @since 2.0
    def update_size(page)
      if ((page).nil? || (page.get_control).nil?)
        return
      end
      update_size_for_page(page)
      @page_container_layout.layout_page(page.get_control)
    end
    
    typesig { [] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.wizard.IWizardContainer2#updateSize()
    def update_size
      update_size(@current_page)
    end
    
    typesig { [IWizardPage] }
    # Computes the correct dialog size for the given page and resizes its shell
    # if nessessary.
    # 
    # @param page
    # the wizard page
    def update_size_for_page(page)
      # ensure the page container is large enough
      delta = calculate_page_size_delta(page)
      if (delta.attr_x > 0 || delta.attr_y > 0)
        # increase the size of the shell
        shell = get_shell
        shell_size = shell.get_size
        set_shell_size(shell_size.attr_x + delta.attr_x, shell_size.attr_y + delta.attr_y)
        constrain_shell_size
      end
    end
    
    typesig { [IWizard] }
    # Computes the correct dialog size for the given wizard and resizes its
    # shell if nessessary.
    # 
    # @param sizingWizard
    # the wizard
    def update_size_for_wizard(sizing_wizard)
      delta = Point.new(0, 0)
      pages = sizing_wizard.get_pages
      i = 0
      while i < pages.attr_length
        # ensure the page container is large enough
        page_delta = calculate_page_size_delta(pages[i])
        delta.attr_x = Math.max(delta.attr_x, page_delta.attr_x)
        delta.attr_y = Math.max(delta.attr_y, page_delta.attr_y)
        i += 1
      end
      if (delta.attr_x > 0 || delta.attr_y > 0)
        # increase the size of the shell
        shell = get_shell
        shell_size = shell.get_size
        set_shell_size(shell_size.attr_x + delta.attr_x, shell_size.attr_y + delta.attr_y)
      end
    end
    
    typesig { [] }
    # (non-Javadoc) Method declared on IWizardContainer.
    def update_title_bar
      s = nil
      if (!(@current_page).nil?)
        s = RJava.cast_to_string(@current_page.get_title)
      end
      if ((s).nil?)
        s = "" # $NON-NLS-1$
      end
      set_title(s)
      if (!(@current_page).nil?)
        set_title_image(@current_page.get_image)
        update_description_message
      end
      update_message
    end
    
    typesig { [] }
    # (non-Javadoc) Method declared on IWizardContainer.
    def update_window_title
      if ((get_shell).nil?)
        # Not created yet
        return
      end
      title = @wizard.get_window_title
      if ((title).nil?)
        title = "" # $NON-NLS-1$
      end
      get_shell.set_text(title)
    end
    
    typesig { [] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.dialogs.IPageChangeProvider#getSelectedPage()
    def get_selected_page
      return get_current_page
    end
    
    typesig { [IPageChangedListener] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.dialog.IPageChangeProvider#addPageChangedListener()
    def add_page_changed_listener(listener)
      @page_changed_listeners.add(listener)
    end
    
    typesig { [IPageChangedListener] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.dialog.IPageChangeProvider#removePageChangedListener()
    def remove_page_changed_listener(listener)
      @page_changed_listeners.remove(listener)
    end
    
    typesig { [PageChangedEvent] }
    # Notifies any selection changed listeners that the selected page has
    # changed. Only listeners registered at the time this method is called are
    # notified.
    # 
    # @param event
    # a selection changed event
    # 
    # @see IPageChangedListener#pageChanged
    # 
    # @since 3.1
    def fire_page_changed(event)
      listeners = @page_changed_listeners.get_listeners
      i = 0
      while i < listeners.attr_length
        l = listeners[i]
        SafeRunnable.run(Class.new(SafeRunnable.class == Class ? SafeRunnable : Object) do
          local_class_in WizardDialog
          include_class_members WizardDialog
          include SafeRunnable if SafeRunnable.class == Module
          
          typesig { [] }
          define_method :run do
            l.page_changed(event)
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
        (i += 1)
      end
    end
    
    typesig { [IPageChangingListener] }
    # Adds a listener for page changes to the list of page changing listeners
    # registered for this dialog. Has no effect if an identical listener is
    # already registered.
    # 
    # @param listener
    # a page changing listener
    # @since 3.3
    def add_page_changing_listener(listener)
      @page_changing_listeners.add(listener)
    end
    
    typesig { [IPageChangingListener] }
    # Removes the provided page changing listener from the list of page
    # changing listeners registered for the dialog.
    # 
    # @param listener
    # a page changing listener
    # @since 3.3
    def remove_page_changing_listener(listener)
      @page_changing_listeners.remove(listener)
    end
    
    typesig { [PageChangingEvent] }
    # Notifies any page changing listeners that the currently selected dialog
    # page is changing. Only listeners registered at the time this method is
    # called are notified.
    # 
    # @param event
    # a selection changing event
    # 
    # @see IPageChangingListener#handlePageChanging(PageChangingEvent)
    # @since 3.3
    def fire_page_changing(event)
      listeners = @page_changing_listeners.get_listeners
      i = 0
      while i < listeners.attr_length
        l = listeners[i]
        SafeRunnable.run(Class.new(SafeRunnable.class == Class ? SafeRunnable : Object) do
          local_class_in WizardDialog
          include_class_members WizardDialog
          include SafeRunnable if SafeRunnable.class == Module
          
          typesig { [] }
          define_method :run do
            l.handle_page_changing(event)
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
        (i += 1)
      end
    end
    
    private
    alias_method :initialize__wizard_dialog, :initialize
  end
  
end
