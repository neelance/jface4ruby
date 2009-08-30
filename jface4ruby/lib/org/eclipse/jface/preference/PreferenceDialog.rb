require "rjava"

# Copyright (c) 2000, 2009 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
# Teddy Walker <teddy.walker@googlemail.com>
# - Bug 188056 [Preferences] PreferencePages have to less indent in PreferenceDialog
module Org::Eclipse::Jface::Preference
  module PreferenceDialogImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Preference
      include_const ::Java::Io, :IOException
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :JavaList
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Core::Runtime, :ISafeRunnable
      include_const ::Org::Eclipse::Core::Runtime, :IStatus
      include_const ::Org::Eclipse::Core::Runtime, :ListenerList
      include_const ::Org::Eclipse::Core::Runtime, :SafeRunner
      include_const ::Org::Eclipse::Core::Runtime, :Status
      include_const ::Org::Eclipse::Jface::Dialogs, :DialogMessageArea
      include_const ::Org::Eclipse::Jface::Dialogs, :IDialogConstants
      include_const ::Org::Eclipse::Jface::Dialogs, :IMessageProvider
      include_const ::Org::Eclipse::Jface::Dialogs, :IPageChangeProvider
      include_const ::Org::Eclipse::Jface::Dialogs, :IPageChangedListener
      include_const ::Org::Eclipse::Jface::Dialogs, :MessageDialog
      include_const ::Org::Eclipse::Jface::Dialogs, :PageChangedEvent
      include_const ::Org::Eclipse::Jface::Dialogs, :TrayDialog
      include_const ::Org::Eclipse::Jface::Resource, :JFaceResources
      include_const ::Org::Eclipse::Jface::Util, :IPropertyChangeListener
      include_const ::Org::Eclipse::Jface::Util, :Policy
      include_const ::Org::Eclipse::Jface::Util, :PropertyChangeEvent
      include_const ::Org::Eclipse::Jface::Util, :SafeRunnable
      include_const ::Org::Eclipse::Jface::Viewers, :ISelection
      include_const ::Org::Eclipse::Jface::Viewers, :ISelectionChangedListener
      include_const ::Org::Eclipse::Jface::Viewers, :IStructuredSelection
      include_const ::Org::Eclipse::Jface::Viewers, :SelectionChangedEvent
      include_const ::Org::Eclipse::Jface::Viewers, :StructuredSelection
      include_const ::Org::Eclipse::Jface::Viewers, :TreeViewer
      include_const ::Org::Eclipse::Jface::Viewers, :ViewerComparator
      include_const ::Org::Eclipse::Jface::Viewers, :ViewerFilter
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Custom, :BusyIndicator
      include_const ::Org::Eclipse::Swt::Custom, :ScrolledComposite
      include_const ::Org::Eclipse::Swt::Events, :ControlAdapter
      include_const ::Org::Eclipse::Swt::Events, :ControlEvent
      include_const ::Org::Eclipse::Swt::Events, :DisposeEvent
      include_const ::Org::Eclipse::Swt::Events, :DisposeListener
      include_const ::Org::Eclipse::Swt::Events, :HelpEvent
      include_const ::Org::Eclipse::Swt::Events, :HelpListener
      include_const ::Org::Eclipse::Swt::Events, :SelectionAdapter
      include_const ::Org::Eclipse::Swt::Events, :SelectionEvent
      include_const ::Org::Eclipse::Swt::Events, :ShellAdapter
      include_const ::Org::Eclipse::Swt::Events, :ShellEvent
      include_const ::Org::Eclipse::Swt::Graphics, :Font
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Graphics, :Rectangle
      include_const ::Org::Eclipse::Swt::Layout, :FormAttachment
      include_const ::Org::Eclipse::Swt::Layout, :FormData
      include_const ::Org::Eclipse::Swt::Layout, :FormLayout
      include_const ::Org::Eclipse::Swt::Layout, :GridData
      include_const ::Org::Eclipse::Swt::Layout, :GridLayout
      include_const ::Org::Eclipse::Swt::Widgets, :Button
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Event
      include_const ::Org::Eclipse::Swt::Widgets, :Label
      include_const ::Org::Eclipse::Swt::Widgets, :Layout
      include_const ::Org::Eclipse::Swt::Widgets, :Listener
      include_const ::Org::Eclipse::Swt::Widgets, :Sash
      include_const ::Org::Eclipse::Swt::Widgets, :Shell
      include_const ::Org::Eclipse::Swt::Widgets, :Tree
    }
  end
  
  # A preference dialog is a hierarchical presentation of preference pages. Each
  # page is represented by a node in the tree shown on the left hand side of the
  # dialog; when a node is selected, the corresponding page is shown on the right
  # hand side.
  class PreferenceDialog < PreferenceDialogImports.const_get :TrayDialog
    include_class_members PreferenceDialogImports
    overload_protected {
      include IPreferencePageContainer
      include IPageChangeProvider
    }
    
    class_module.module_eval {
      # Layout for the page container.
      const_set_lazy(:PageLayout) { Class.new(Layout) do
        extend LocalClass
        include_class_members PreferenceDialog
        
        typesig { [class_self::Composite, ::Java::Int, ::Java::Int, ::Java::Boolean] }
        def compute_size(composite, w_hint, h_hint, force)
          if (!(w_hint).equal?(SWT::DEFAULT) && !(h_hint).equal?(SWT::DEFAULT))
            return self.class::Point.new(w_hint, h_hint)
          end
          x = self.attr_minimum_page_size.attr_x
          y = self.attr_minimum_page_size.attr_y
          children = composite.get_children
          i = 0
          while i < children.attr_length
            size = children[i].compute_size(SWT::DEFAULT, SWT::DEFAULT, force)
            x = Math.max(x, size.attr_x)
            y = Math.max(y, size.attr_y)
            i += 1
          end
          # As pages can implement thier own computeSize
          # take it into account
          if (!(self.attr_current_page).nil?)
            size = self.attr_current_page.compute_size
            x = Math.max(x, size.attr_x)
            y = Math.max(y, size.attr_y)
          end
          if (!(w_hint).equal?(SWT::DEFAULT))
            x = w_hint
          end
          if (!(h_hint).equal?(SWT::DEFAULT))
            y = h_hint
          end
          return self.class::Point.new(x, y)
        end
        
        typesig { [class_self::Composite, ::Java::Boolean] }
        def layout(composite, force)
          rect = composite.get_client_area
          children = composite.get_children
          i = 0
          while i < children.attr_length
            children[i].set_size(rect.attr_width, rect.attr_height)
            i += 1
          end
        end
        
        typesig { [] }
        def initialize
          super()
        end
        
        private
        alias_method :initialize__page_layout, :initialize
      end }
      
      # The id of the last page that was selected
      
      def last_preference_id
        defined?(@@last_preference_id) ? @@last_preference_id : @@last_preference_id= nil
      end
      alias_method :attr_last_preference_id, :last_preference_id
      
      def last_preference_id=(value)
        @@last_preference_id = value
      end
      alias_method :attr_last_preference_id=, :last_preference_id=
      
      # The last known tree width
      
      def last_tree_width
        defined?(@@last_tree_width) ? @@last_tree_width : @@last_tree_width= 180
      end
      alias_method :attr_last_tree_width, :last_tree_width
      
      def last_tree_width=(value)
        @@last_tree_width = value
      end
      alias_method :attr_last_tree_width=, :last_tree_width=
      
      # Indentifier for the error image
      const_set_lazy(:PREF_DLG_IMG_TITLE_ERROR) { DLG_IMG_MESSAGE_ERROR }
      const_attr_reader  :PREF_DLG_IMG_TITLE_ERROR
      
      # Title area fields
      const_set_lazy(:PREF_DLG_TITLE_IMG) { "preference_dialog_title_image" }
      const_attr_reader  :PREF_DLG_TITLE_IMG
      
      # $NON-NLS-1$
      # 
      # Return code used when dialog failed
      const_set_lazy(:FAILED) { 2 }
      const_attr_reader  :FAILED
    }
    
    # The current preference page, or <code>null</code> if there is none.
    attr_accessor :current_page
    alias_method :attr_current_page, :current_page
    undef_method :current_page
    alias_method :attr_current_page=, :current_page=
    undef_method :current_page=
    
    attr_accessor :message_area
    alias_method :attr_message_area, :message_area
    undef_method :message_area
    alias_method :attr_message_area=, :message_area=
    undef_method :message_area=
    
    attr_accessor :last_shell_size
    alias_method :attr_last_shell_size, :last_shell_size
    undef_method :last_shell_size
    alias_method :attr_last_shell_size=, :last_shell_size=
    undef_method :last_shell_size=
    
    attr_accessor :last_successful_node
    alias_method :attr_last_successful_node, :last_successful_node
    undef_method :last_successful_node
    alias_method :attr_last_successful_node=, :last_successful_node=
    undef_method :last_successful_node=
    
    # The minimum page size; 400 by 400 by default.
    # 
    # @see #setMinimumPageSize(Point)
    attr_accessor :minimum_page_size
    alias_method :attr_minimum_page_size, :minimum_page_size
    undef_method :minimum_page_size
    alias_method :attr_minimum_page_size=, :minimum_page_size=
    undef_method :minimum_page_size=
    
    # The OK button.
    attr_accessor :ok_button
    alias_method :attr_ok_button, :ok_button
    undef_method :ok_button
    alias_method :attr_ok_button=, :ok_button=
    undef_method :ok_button=
    
    # The Composite in which a page is shown.
    attr_accessor :page_container
    alias_method :attr_page_container, :page_container
    undef_method :page_container
    alias_method :attr_page_container=, :page_container=
    undef_method :page_container=
    
    # The preference manager.
    attr_accessor :preference_manager
    alias_method :attr_preference_manager, :preference_manager
    undef_method :preference_manager
    alias_method :attr_preference_manager=, :preference_manager=
    undef_method :preference_manager=
    
    # Flag for the presence of the error message.
    attr_accessor :showing_error
    alias_method :attr_showing_error, :showing_error
    undef_method :showing_error
    alias_method :attr_showing_error=, :showing_error=
    undef_method :showing_error=
    
    # Preference store, initially <code>null</code> meaning none.
    # 
    # @see #setPreferenceStore
    attr_accessor :preference_store
    alias_method :attr_preference_store, :preference_store
    undef_method :preference_store
    alias_method :attr_preference_store=, :preference_store=
    undef_method :preference_store=
    
    attr_accessor :title_area
    alias_method :attr_title_area, :title_area
    undef_method :title_area
    alias_method :attr_title_area=, :title_area=
    undef_method :title_area=
    
    # The tree viewer.
    attr_accessor :tree_viewer
    alias_method :attr_tree_viewer, :tree_viewer
    undef_method :tree_viewer
    alias_method :attr_tree_viewer=, :tree_viewer=
    undef_method :tree_viewer=
    
    attr_accessor :page_changed_listeners
    alias_method :attr_page_changed_listeners, :page_changed_listeners
    undef_method :page_changed_listeners
    alias_method :attr_page_changed_listeners=, :page_changed_listeners=
    undef_method :page_changed_listeners=
    
    # Composite with a FormLayout to contain the title area
    attr_accessor :form_title_composite
    alias_method :attr_form_title_composite, :form_title_composite
    undef_method :form_title_composite
    alias_method :attr_form_title_composite=, :form_title_composite=
    undef_method :form_title_composite=
    
    attr_accessor :scrolled
    alias_method :attr_scrolled, :scrolled
    undef_method :scrolled
    alias_method :attr_scrolled=, :scrolled=
    undef_method :scrolled=
    
    typesig { [Shell, PreferenceManager] }
    # Creates a new preference dialog under the control of the given preference
    # manager.
    # 
    # @param parentShell
    # the parent shell
    # @param manager
    # the preference manager
    def initialize(parent_shell, manager)
      @current_page = nil
      @message_area = nil
      @last_shell_size = nil
      @last_successful_node = nil
      @minimum_page_size = nil
      @ok_button = nil
      @page_container = nil
      @preference_manager = nil
      @showing_error = false
      @preference_store = nil
      @title_area = nil
      @tree_viewer = nil
      @page_changed_listeners = nil
      @form_title_composite = nil
      @scrolled = nil
      super(parent_shell)
      @minimum_page_size = Point.new(400, 400)
      @showing_error = false
      @page_changed_listeners = ListenerList.new
      @preference_manager = manager
    end
    
    typesig { [::Java::Int] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.dialogs.Dialog#buttonPressed(int)
    def button_pressed(button_id)
      case (button_id)
      when IDialogConstants::OK_ID
        ok_pressed
        return
      when IDialogConstants::CANCEL_ID
        cancel_pressed
        return
      when IDialogConstants::HELP_ID
        help_pressed
        return
      end
    end
    
    typesig { [] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.dialogs.Dialog#cancelPressed()
    def cancel_pressed
      # Inform all pages that we are cancelling
      nodes = @preference_manager.get_elements(PreferenceManager::PRE_ORDER).iterator
      while (nodes.has_next)
        node = nodes.next_
        if (!(get_page(node)).nil?)
          SafeRunnable.run(Class.new(SafeRunnable.class == Class ? SafeRunnable : Object) do
            extend LocalClass
            include_class_members PreferenceDialog
            include SafeRunnable if SafeRunnable.class == Module
            
            typesig { [] }
            define_method :run do
              if (!get_page(node).perform_cancel)
                return
              end
            end
            
            typesig { [Object] }
            define_method :initialize do |*args|
              super(*args)
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
        end
      end
      # Give subclasses the choice to save the state of the preference pages if needed
      handle_save
      set_return_code(CANCEL)
      close
    end
    
    typesig { [] }
    # Clear the last selected node. This is so that we not chache the last
    # selection in case of an error.
    def clear_selected_node
      set_selected_node_preference(nil)
    end
    
    typesig { [] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.window.Window#close()
    def close
      runnable = # Do this is in a SafeRunnable as it may run client code
      Class.new(SafeRunnable.class == Class ? SafeRunnable : Object) do
        extend LocalClass
        include_class_members PreferenceDialog
        include SafeRunnable if SafeRunnable.class == Module
        
        typesig { [] }
        # (non-Javadoc)
        # @see org.eclipse.core.runtime.ISafeRunnable#run()
        define_method :run do
          nodes = self.attr_preference_manager.get_elements(PreferenceManager::PRE_ORDER)
          i = 0
          while i < nodes.size
            node = nodes.get(i)
            node.dispose_resources
            i += 1
          end
        end
        
        typesig { [JavaThrowable] }
        # (non-Javadoc)
        # @see org.eclipse.jface.util.SafeRunnable#handleException(java.lang.Throwable)
        define_method :handle_exception do |e|
          super(e)
          clear_selected_node # Do not cache a node with problems
        end
        
        typesig { [Object] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
      SafeRunner.run(runnable)
      return super
    end
    
    typesig { [Shell] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.window.Window#configureShell(org.eclipse.swt.widgets.Shell)
    def configure_shell(new_shell)
      super(new_shell)
      new_shell.set_text(JFaceResources.get_string("PreferenceDialog.title")) # $NON-NLS-1$
      new_shell.add_shell_listener(Class.new(ShellAdapter.class == Class ? ShellAdapter : Object) do
        extend LocalClass
        include_class_members PreferenceDialog
        include ShellAdapter if ShellAdapter.class == Module
        
        typesig { [ShellEvent] }
        define_method :shell_activated do |e|
          if ((self.attr_last_shell_size).nil?)
            self.attr_last_shell_size = get_shell.get_size
          end
        end
        
        typesig { [Object] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
    end
    
    typesig { [] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.window.Window#constrainShellSize()
    def constrain_shell_size
      super
      # record opening shell size
      if ((@last_shell_size).nil?)
        @last_shell_size = get_shell.get_size
      end
    end
    
    typesig { [Composite] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.dialogs.Dialog#createButtonsForButtonBar(org.eclipse.swt.widgets.Composite)
    def create_buttons_for_button_bar(parent)
      # create OK and Cancel buttons by default
      @ok_button = create_button(parent, IDialogConstants::OK_ID, IDialogConstants::OK_LABEL, true)
      get_shell.set_default_button(@ok_button)
      create_button(parent, IDialogConstants::CANCEL_ID, IDialogConstants::CANCEL_LABEL, false)
    end
    
    typesig { [Composite] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.window.Window#createContents(org.eclipse.swt.widgets.Composite)
    def create_contents(parent)
      control = Array.typed(Control).new(1) { nil }
      BusyIndicator.show_while(get_shell.get_display, Class.new(Runnable.class == Class ? Runnable : Object) do
        extend LocalClass
        include_class_members PreferenceDialog
        include Runnable if Runnable.class == Module
        
        typesig { [] }
        define_method :run do
          control[0] = PreferenceDialog.superclass.instance_method(:create_contents).bind(self).call(parent)
          # Add the first page
          select_saved_item
        end
        
        typesig { [Object] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      return control[0]
    end
    
    typesig { [Composite] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.dialogs.Dialog#createDialogArea(org.eclipse.swt.widgets.Composite)
    def create_dialog_area(parent)
      composite = super(parent)
      parent_layout = (composite.get_layout)
      parent_layout.attr_num_columns = 4
      parent_layout.attr_margin_height = 0
      parent_layout.attr_margin_width = 0
      parent_layout.attr_vertical_spacing = 0
      parent_layout.attr_horizontal_spacing = 0
      composite.set_background(parent.get_display.get_system_color(SWT::COLOR_LIST_BACKGROUND))
      tree_control = create_tree_area_contents(composite)
      create_sash(composite, tree_control)
      versep = Label.new(composite, SWT::SEPARATOR | SWT::VERTICAL)
      ver_gd = GridData.new(GridData::FILL_VERTICAL | GridData::GRAB_VERTICAL)
      versep.set_layout_data(ver_gd)
      versep.set_layout_data(GridData.new(SWT::LEFT, SWT::FILL, false, true))
      page_area_composite = Composite.new(composite, SWT::NONE)
      page_area_composite.set_layout_data(GridData.new(GridData::FILL_BOTH))
      layout = GridLayout.new(1, true)
      layout.attr_margin_height = 0
      layout.attr_margin_width = 0
      layout.attr_vertical_spacing = 0
      page_area_composite.set_layout(layout)
      @form_title_composite = Composite.new(page_area_composite, SWT::NONE)
      title_layout = FormLayout.new
      title_layout.attr_margin_width = 0
      title_layout.attr_margin_height = 0
      @form_title_composite.set_layout(title_layout)
      title_grid_data = GridData.new(GridData::FILL_HORIZONTAL)
      title_grid_data.attr_horizontal_indent = IDialogConstants::HORIZONTAL_MARGIN
      @form_title_composite.set_layout_data(title_grid_data)
      # Build the title area and separator line
      title_composite = Composite.new(@form_title_composite, SWT::NONE)
      layout = GridLayout.new
      layout.attr_margin_bottom = 5
      layout.attr_margin_height = 0
      layout.attr_margin_width = 0
      layout.attr_horizontal_spacing = 0
      title_composite.set_layout(layout)
      title_form_data = FormData.new
      title_form_data.attr_top = FormAttachment.new(0, 0)
      title_form_data.attr_left = FormAttachment.new(0, 0)
      title_form_data.attr_right = FormAttachment.new(100, 0)
      title_form_data.attr_bottom = FormAttachment.new(100, 0)
      title_composite.set_layout_data(title_form_data)
      create_title_area(title_composite)
      separator = Label.new(page_area_composite, SWT::HORIZONTAL | SWT::SEPARATOR)
      separator.set_layout_data(GridData.new(GridData::FILL_HORIZONTAL | GridData::GRAB_HORIZONTAL))
      # Build the Page container
      @page_container = create_page_container(page_area_composite)
      page_container_data = GridData.new(GridData::FILL_BOTH)
      page_container_data.attr_horizontal_indent = IDialogConstants::HORIZONTAL_MARGIN
      @page_container.set_layout_data(page_container_data)
      # Build the separator line
      bottom_separator = Label.new(parent, SWT::HORIZONTAL | SWT::SEPARATOR)
      bottom_separator.set_layout_data(GridData.new(GridData::FILL_HORIZONTAL | GridData::GRAB_HORIZONTAL))
      return composite
    end
    
    typesig { [Composite, Control] }
    # Create the sash with right control on the right. Note
    # that this method assumes GridData for the layout data
    # of the rightControl.
    # @param composite
    # @param rightControl
    # @return Sash
    # 
    # @since 3.1
    def create_sash(composite, right_control)
      sash = Sash.new(composite, SWT::VERTICAL)
      sash.set_layout_data(GridData.new(GridData::FILL_VERTICAL))
      sash.set_background(composite.get_display.get_system_color(SWT::COLOR_LIST_BACKGROUND))
      sash.add_listener(SWT::Selection, # the following listener resizes the tree control based on sash deltas.
      # If necessary, it will also grow/shrink the dialog.
      Class.new(Listener.class == Class ? Listener : Object) do
        extend LocalClass
        include_class_members PreferenceDialog
        include Listener if Listener.class == Module
        
        typesig { [Event] }
        # (non-Javadoc)
        # 
        # @see org.eclipse.swt.widgets.Listener#handleEvent(org.eclipse.swt.widgets.Event)
        define_method :handle_event do |event|
          if ((event.attr_detail).equal?(SWT::DRAG))
            return
          end
          shift = event.attr_x - sash.get_bounds.attr_x
          data = right_control.get_layout_data
          new_width_hint = data.attr_width_hint + shift
          if (new_width_hint < 20)
            return
          end
          computed_size = get_shell.compute_size(SWT::DEFAULT, SWT::DEFAULT)
          current_size = get_shell.get_size
          # if the dialog wasn't of a custom size we know we can shrink
          # it if necessary based on sash movement.
          custom_size = !(computed_size == current_size)
          data.attr_width_hint = new_width_hint
          set_last_tree_width(new_width_hint)
          composite.layout(true)
          # recompute based on new widget size
          computed_size = get_shell.compute_size(SWT::DEFAULT, SWT::DEFAULT)
          # if the dialog was of a custom size then increase it only if
          # necessary.
          if (custom_size)
            computed_size.attr_x = Math.max(computed_size.attr_x, current_size.attr_x)
          end
          computed_size.attr_y = Math.max(computed_size.attr_y, current_size.attr_y)
          if ((computed_size == current_size))
            return
          end
          set_shell_size(computed_size.attr_x, computed_size.attr_y)
          self.attr_last_shell_size = get_shell.get_size
        end
        
        typesig { [Object] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      return sash
    end
    
    typesig { [Composite] }
    # Creates the inner page container.
    # 
    # @param parent
    # @return Composite
    def create_page_container(parent)
      outer = Composite.new(parent, SWT::NONE)
      outer_data = GridData.new(GridData::FILL_BOTH | GridData::GRAB_HORIZONTAL | GridData::GRAB_VERTICAL)
      outer_data.attr_horizontal_indent = IDialogConstants::HORIZONTAL_MARGIN
      outer.set_layout(GridLayout.new)
      outer.set_layout_data(outer_data)
      # Create an outer composite for spacing
      @scrolled = ScrolledComposite.new(outer, SWT::V_SCROLL | SWT::H_SCROLL)
      # always show the focus control
      @scrolled.set_show_focused_control(true)
      @scrolled.set_expand_horizontal(true)
      @scrolled.set_expand_vertical(true)
      scrolled_data = GridData.new(GridData::FILL_BOTH | GridData::GRAB_HORIZONTAL | GridData::GRAB_VERTICAL)
      @scrolled.set_layout_data(scrolled_data)
      result = Composite.new(@scrolled, SWT::NONE)
      result_data = GridData.new(GridData::FILL_BOTH | GridData::GRAB_HORIZONTAL | GridData::GRAB_VERTICAL)
      result.set_layout(get_page_layout)
      result.set_layout_data(result_data)
      @scrolled.set_content(result)
      return result
    end
    
    typesig { [] }
    # Return the layout for the composite that contains
    # the pages.
    # @return PageLayout
    # 
    # @since 3.1
    def get_page_layout
      return PageLayout.new_local(self)
    end
    
    typesig { [Composite] }
    # Creates the wizard's title area.
    # 
    # @param parent
    # the SWT parent for the title area composite.
    # @return the created title area composite.
    def create_title_area(parent)
      # Create the title area which will contain
      # a title, message, and image.
      margins = 2
      @title_area = Composite.new(parent, SWT::NONE)
      layout = FormLayout.new
      layout.attr_margin_height = 0
      layout.attr_margin_width = margins
      @title_area.set_layout(layout)
      layout_data = GridData.new(GridData::FILL_HORIZONTAL)
      layout_data.attr_vertical_alignment = SWT::TOP
      @title_area.set_layout_data(layout_data)
      # Message label
      @message_area = DialogMessageArea.new
      @message_area.create_contents(@title_area)
      @title_area.add_control_listener(Class.new(ControlAdapter.class == Class ? ControlAdapter : Object) do
        extend LocalClass
        include_class_members PreferenceDialog
        include ControlAdapter if ControlAdapter.class == Module
        
        typesig { [ControlEvent] }
        # (non-Javadoc)
        # @see org.eclipse.swt.events.ControlAdapter#controlResized(org.eclipse.swt.events.ControlEvent)
        define_method :control_resized do |e|
          update_message
        end
        
        typesig { [Object] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      font_listener = Class.new(IPropertyChangeListener.class == Class ? IPropertyChangeListener : Object) do
        extend LocalClass
        include_class_members PreferenceDialog
        include IPropertyChangeListener if IPropertyChangeListener.class == Module
        
        typesig { [PropertyChangeEvent] }
        define_method :property_change do |event|
          if ((JFaceResources::BANNER_FONT == event.get_property))
            update_message
          end
          if ((JFaceResources::DIALOG_FONT == event.get_property))
            update_message
            dialog_font = JFaceResources.get_dialog_font
            update_tree_font(dialog_font)
            children = (self.attr_button_bar).get_children
            i = 0
            while i < children.attr_length
              children[i].set_font(dialog_font)
              i += 1
            end
          end
        end
        
        typesig { [Object] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
      @title_area.add_dispose_listener(Class.new(DisposeListener.class == Class ? DisposeListener : Object) do
        extend LocalClass
        include_class_members PreferenceDialog
        include DisposeListener if DisposeListener.class == Module
        
        typesig { [DisposeEvent] }
        define_method :widget_disposed do |event|
          JFaceResources.get_font_registry.remove_listener(font_listener)
        end
        
        typesig { [Object] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      JFaceResources.get_font_registry.add_listener(font_listener)
      @message_area.set_title_layout_data(create_message_area_data)
      @message_area.set_message_layout_data(create_message_area_data)
      return @title_area
    end
    
    typesig { [] }
    # Create the layout data for the message area.
    # 
    # @return FormData for the message area.
    def create_message_area_data
      message_data = FormData.new
      message_data.attr_top = FormAttachment.new(0)
      message_data.attr_bottom = FormAttachment.new(100)
      message_data.attr_right = FormAttachment.new(100)
      message_data.attr_left = FormAttachment.new(0)
      return message_data
    end
    
    typesig { [Composite] }
    # @param parent
    # the SWT parent for the tree area controls.
    # @return the new <code>Control</code>.
    # @since 3.0
    def create_tree_area_contents(parent)
      # Build the tree an put it into the composite.
      @tree_viewer = create_tree_viewer(parent)
      @tree_viewer.set_input(get_preference_manager)
      update_tree_font(JFaceResources.get_dialog_font)
      layout_tree_area_control(@tree_viewer.get_control)
      return @tree_viewer.get_control
    end
    
    typesig { [Composite] }
    # Create a new <code>TreeViewer</code>.
    # 
    # @param parent
    # the parent <code>Composite</code>.
    # @return the <code>TreeViewer</code>.
    # @since 3.0
    def create_tree_viewer(parent)
      viewer = TreeViewer.new(parent, SWT::NONE)
      add_listeners(viewer)
      viewer.set_label_provider(PreferenceLabelProvider.new)
      viewer.set_content_provider(PreferenceContentProvider.new)
      return viewer
    end
    
    typesig { [TreeViewer] }
    # Add the listeners to the tree viewer.
    # @param viewer
    # 
    # @since 3.1
    def add_listeners(viewer)
      viewer.add_post_selection_changed_listener(Class.new(ISelectionChangedListener.class == Class ? ISelectionChangedListener : Object) do
        extend LocalClass
        include_class_members PreferenceDialog
        include ISelectionChangedListener if ISelectionChangedListener.class == Module
        
        typesig { [] }
        define_method :handle_error do
          begin
            # remove the listener temporarily so that the events caused
            # by the error handling dont further cause error handling
            # to occur.
            viewer.remove_post_selection_changed_listener(self)
            show_page_flipping_abort_dialog
            select_current_page_again
            clear_selected_node
          ensure
            viewer.add_post_selection_changed_listener(self)
          end
        end
        
        typesig { [SelectionChangedEvent] }
        define_method :selection_changed do |event|
          selection = get_single_selection(event.get_selection)
          if (selection.is_a?(self.class::IPreferenceNode))
            iselection_changed_listener_class = self.class
            BusyIndicator.show_while(get_shell.get_display, Class.new(self.class::Runnable.class == Class ? self.class::Runnable : Object) do
              extend LocalClass
              include_class_members iselection_changed_listener_class
              include class_self::Runnable if class_self::Runnable.class == Module
              
              typesig { [] }
              define_method :run do
                if (!is_current_page_valid)
                  handle_error
                else
                  if (!show_page(selection))
                    # Page flipping wasn't successful
                    handle_error
                  else
                    # Everything went well
                    self.attr_last_successful_node = selection
                  end
                end
              end
              
              typesig { [Object] }
              define_method :initialize do |*args|
                super(*args)
              end
              
              private
              alias_method :initialize_anonymous, :initialize
            end.new_local(self))
          end
        end
        
        typesig { [Object] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      (viewer.get_control).add_selection_listener(Class.new(SelectionAdapter.class == Class ? SelectionAdapter : Object) do
        extend LocalClass
        include_class_members PreferenceDialog
        include SelectionAdapter if SelectionAdapter.class == Module
        
        typesig { [SelectionEvent] }
        define_method :widget_default_selected do |event|
          selection = viewer.get_selection
          if (selection.is_empty)
            return
          end
          single_selection = get_single_selection(selection)
          expanded = viewer.get_expanded_state(single_selection)
          viewer.set_expanded_state(single_selection, !expanded)
        end
        
        typesig { [Object] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      viewer.get_control.add_help_listener(# Register help listener on the tree to use context sensitive help
      Class.new(HelpListener.class == Class ? HelpListener : Object) do
        extend LocalClass
        include_class_members PreferenceDialog
        include HelpListener if HelpListener.class == Module
        
        typesig { [HelpEvent] }
        define_method :help_requested do |event|
          if ((self.attr_current_page).nil?)
            # no current page? open dialog's help
            open_dialog_help
            return
          end
          # A) A typical path: the current page has registered its own help link
          # via WorkbenchHelpSystem#setHelp(). When just call it and let
          # it handle the help request.
          page_control = self.attr_current_page.get_control
          if (!(page_control).nil? && page_control.is_listening(SWT::Help))
            self.attr_current_page.perform_help
            return
          end
          # B) Less typical path: no standard listener has been created for the page.
          # In this case we may or may not have an override of page's #performHelp().
          # 1) Try to get default help opened for the dialog;
          open_dialog_help
          # 2) Next call currentPage's #performHelp(). If it was overridden, it might switch help
          # to something else.
          self.attr_current_page.perform_help
        end
        
        typesig { [] }
        define_method :open_dialog_help do
          if ((self.attr_page_container).nil?)
            return
          end
          current_control = self.attr_page_container
          while !(current_control).nil?
            if (current_control.is_listening(SWT::Help))
              current_control.notify_listeners(SWT::Help, self.class::Event.new)
              break
            end
            current_control = current_control.get_parent
          end
        end
        
        typesig { [Object] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
    end
    
    typesig { [String] }
    # Find the <code>IPreferenceNode</code> that has data the same id as the
    # supplied value.
    # 
    # @param nodeId
    # the id to search for.
    # @return <code>IPreferenceNode</code> or <code>null</code> if not
    # found.
    def find_node_matching(node_id)
      nodes = @preference_manager.get_elements(PreferenceManager::POST_ORDER)
      i = nodes.iterator
      while i.has_next
        node = i.next_
        if ((node.get_id == node_id))
          return node
        end
      end
      return nil
    end
    
    typesig { [] }
    # Get the last known right side width.
    # 
    # @return the width.
    def get_last_right_width
      return self.attr_last_tree_width
    end
    
    typesig { [] }
    # Returns the preference mananger used by this preference dialog.
    # 
    # @return the preference mananger
    def get_preference_manager
      return @preference_manager
    end
    
    typesig { [] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.preference.IPreferencePageContainer#getPreferenceStore()
    def get_preference_store
      return @preference_store
    end
    
    typesig { [] }
    # Get the name of the selected item preference
    # 
    # @return String
    def get_selected_node_preference
      return self.attr_last_preference_id
    end
    
    typesig { [ISelection] }
    # @param selection
    # the <code>ISelection</code> to examine.
    # @return the first element, or null if empty.
    def get_single_selection(selection)
      if (!selection.is_empty)
        structured = selection
        if (structured.get_first_element.is_a?(IPreferenceNode))
          return structured.get_first_element
        end
      end
      return nil
    end
    
    typesig { [] }
    # @return the <code>TreeViewer</code> for this dialog.
    # @since 3.3
    def get_tree_viewer
      return @tree_viewer
    end
    
    typesig { [] }
    # Save the values specified in the pages.
    # <p>
    # The default implementation of this framework method saves all pages of
    # type <code>PreferencePage</code> (if their store needs saving and is a
    # <code>PreferenceStore</code>).
    # </p>
    # <p>
    # Subclasses may override.
    # </p>
    def handle_save
      nodes = @preference_manager.get_elements(PreferenceManager::PRE_ORDER).iterator
      while (nodes.has_next)
        node = nodes.next_
        page = node.get_page
        if (page.is_a?(PreferencePage))
          # Save now in case tbe workbench does not shutdown cleanly
          store = (page).get_preference_store
          if (!(store).nil? && store.needs_saving && store.is_a?(IPersistentPreferenceStore))
            begin
              (store).save
            rescue IOException => e
              message = JFaceResources.format("PreferenceDialog.saveErrorMessage", Array.typed(Object).new([page.get_title, e.get_message])) # $NON-NLS-1$
              Policy.get_status_handler.show(Status.new(IStatus::ERROR, Policy::JFACE, message, e), JFaceResources.get_string("PreferenceDialog.saveErrorTitle")) # $NON-NLS-1$
            end
          end
        end
      end
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
      # handle the same as pressing cancel
      cancel_pressed
    end
    
    typesig { [] }
    # Notifies of the pressing of the Help button.
    # <p>
    # The default implementation of this framework method calls
    # <code>performHelp</code> on the currently active page.
    # </p>
    def help_pressed
      if (!(@current_page).nil?)
        @current_page.perform_help
      end
    end
    
    typesig { [] }
    # Returns whether the current page is valid.
    # 
    # @return <code>false</code> if the current page is not valid, or or
    # <code>true</code> if the current page is valid or there is no
    # current page
    def is_current_page_valid
      if ((@current_page).nil?)
        return true
      end
      return @current_page.is_valid
    end
    
    typesig { [Control] }
    # @param control
    # the <code>Control</code> to lay out.
    # @since 3.0
    def layout_tree_area_control(control)
      gd = GridData.new(GridData::FILL_VERTICAL)
      gd.attr_width_hint = get_last_right_width
      gd.attr_vertical_span = 1
      control.set_layout_data(gd)
    end
    
    typesig { [] }
    # The preference dialog implementation of this <code>Dialog</code>
    # framework method sends <code>performOk</code> to all pages of the
    # preference dialog, then calls <code>handleSave</code> on this dialog to
    # save any state, and then calls <code>close</code> to close this dialog.
    def ok_pressed
      SafeRunnable.run(Class.new(SafeRunnable.class == Class ? SafeRunnable : Object) do
        extend LocalClass
        include_class_members PreferenceDialog
        include SafeRunnable if SafeRunnable.class == Module
        
        attr_accessor :error_occurred
        alias_method :attr_error_occurred, :error_occurred
        undef_method :error_occurred
        alias_method :attr_error_occurred=, :error_occurred=
        undef_method :error_occurred=
        
        typesig { [] }
        # (non-Javadoc)
        # 
        # @see org.eclipse.core.runtime.ISafeRunnable#run()
        define_method :run do
          get_button(IDialogConstants::OK_ID).set_enabled(false)
          @error_occurred = false
          has_failed_ok = false
          begin
            # Notify all the pages and give them a chance to abort
            nodes = self.attr_preference_manager.get_elements(PreferenceManager::PRE_ORDER).iterator
            while (nodes.has_next)
              node = nodes.next_
              page = node.get_page
              if (!(page).nil?)
                if (!page.perform_ok)
                  has_failed_ok = true
                  return
                end
              end
            end
          rescue self.class::JavaException => e
            handle_exception(e)
          ensure
            # Don't bother closing if the OK failed
            if (has_failed_ok)
              set_return_code(FAILED)
              get_button(IDialogConstants::OK_ID).set_enabled(true)
              return
            end
            if (!@error_occurred)
              # Give subclasses the choice to save the state of the
              # preference pages.
              handle_save
            end
            set_return_code(OK)
            close
          end
        end
        
        typesig { [JavaThrowable] }
        # (non-Javadoc)
        # 
        # @see org.eclipse.core.runtime.ISafeRunnable#handleException(java.lang.Throwable)
        define_method :handle_exception do |e|
          @error_occurred = true
          Policy.get_log.log(self.class::Status.new(IStatus::ERROR, Policy::JFACE, 0, e.to_s, e))
          clear_selected_node
          message = JFaceResources.get_string("SafeRunnable.errorMessage") # $NON-NLS-1$
          Policy.get_status_handler.show(self.class::Status.new(IStatus::ERROR, Policy::JFACE, message, e), JFaceResources.get_string("Error")) # $NON-NLS-1$
        end
        
        typesig { [Object] }
        define_method :initialize do |*args|
          @error_occurred = false
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
    end
    
    typesig { [] }
    # Selects the page determined by <code>lastSuccessfulNode</code> in the
    # page hierarchy.
    def select_current_page_again
      if ((@last_successful_node).nil?)
        return
      end
      get_tree_viewer.set_selection(StructuredSelection.new(@last_successful_node))
      @current_page.set_visible(true)
    end
    
    typesig { [] }
    # Selects the saved item in the tree of preference pages. If it cannot do
    # this it saves the first one.
    def select_saved_item
      node = find_node_matching(get_selected_node_preference)
      if ((node).nil?)
        nodes = @preference_manager.get_root_sub_nodes
        comparator = get_tree_viewer.get_comparator
        if (!(comparator).nil?)
          comparator.sort(nil, nodes)
        end
        filters = get_tree_viewer.get_filters
        i = 0
        while i < nodes.attr_length
          selected_node = nodes[i]
          # See if it passes all filters
          j = 0
          while j < filters.attr_length
            if (!filters[j].select(@tree_viewer, @preference_manager.get_root, selected_node))
              selected_node = nil
              break
            end
            j += 1
          end
          # if it passes all filters select it
          if (!(selected_node).nil?)
            node = selected_node
            break
          end
          i += 1
        end
      end
      if (!(node).nil?)
        get_tree_viewer.set_selection(StructuredSelection.new(node), true)
        # Keep focus in tree. See bugs 2692, 2621, and 6775.
        get_tree_viewer.get_control.set_focus
      end
    end
    
    typesig { [String] }
    # Display the given error message. The currently displayed message is saved
    # and will be redisplayed when the error message is set to
    # <code>null</code>.
    # 
    # @param newErrorMessage
    # the errorMessage to display or <code>null</code>
    def set_error_message(new_error_message)
      if ((new_error_message).nil?)
        @message_area.clear_error_message
      else
        @message_area.update_text(new_error_message, IMessageProvider::ERROR)
      end
    end
    
    typesig { [::Java::Int] }
    # Save the last known tree width.
    # 
    # @param width
    # the width.
    def set_last_tree_width(width)
      self.attr_last_tree_width = width
    end
    
    typesig { [String] }
    # Set the message text. If the message line currently displays an error,
    # the message is stored and will be shown after a call to clearErrorMessage
    # <p>
    # Shortcut for <code>setMessage(newMessage, NONE)</code>
    # </p>
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
      @message_area.update_text(new_message, new_type)
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Sets the minimum page size.
    # 
    # @param minWidth
    # the minimum page width
    # @param minHeight
    # the minimum page height
    # @see #setMinimumPageSize(Point)
    def set_minimum_page_size(min_width, min_height)
      @minimum_page_size.attr_x = min_width
      @minimum_page_size.attr_y = min_height
    end
    
    typesig { [Point] }
    # Sets the minimum page size.
    # 
    # @param size
    # the page size encoded as <code>new Point(width,height)</code>
    # @see #setMinimumPageSize(int,int)
    def set_minimum_page_size(size)
      @minimum_page_size.attr_x = size.attr_x
      @minimum_page_size.attr_y = size.attr_y
    end
    
    typesig { [IPreferenceStore] }
    # Sets the preference store for this preference dialog.
    # 
    # @param store
    # the preference store
    # @see #getPreferenceStore
    def set_preference_store(store)
      Assert.is_not_null(store)
      @preference_store = store
    end
    
    typesig { [] }
    # Save the currently selected node.
    def set_selected_node
      store_value = nil
      selection = get_tree_viewer.get_selection
      if ((selection.size).equal?(1))
        node = selection.get_first_element
        store_value = RJava.cast_to_string(node.get_id)
      end
      set_selected_node_preference(store_value)
    end
    
    typesig { [String] }
    # Sets the name of the selected item preference. Public equivalent to
    # <code>setSelectedNodePreference</code>.
    # 
    # @param pageId
    # The identifier for the page
    # @since 3.0
    def set_selected_node(page_id)
      set_selected_node_preference(page_id)
    end
    
    typesig { [String] }
    # Sets the name of the selected item preference.
    # 
    # @param pageId
    # The identifier for the page
    def set_selected_node_preference(page_id)
      self.attr_last_preference_id = page_id
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
      preferred = get_shell.get_bounds
      preferred.attr_width = width
      preferred.attr_height = height
      get_shell.set_bounds(get_constrained_shell_bounds(preferred))
    end
    
    typesig { [IPreferenceNode] }
    # Shows the preference page corresponding to the given preference node.
    # Does nothing if that page is already current.
    # 
    # @param node
    # the preference node, or <code>null</code> if none
    # @return <code>true</code> if the page flip was successful, and
    # <code>false</code> is unsuccessful
    def show_page(node)
      if ((node).nil?)
        return false
      end
      # Create the page if nessessary
      if ((node.get_page).nil?)
        create_page(node)
      end
      if ((node.get_page).nil?)
        return false
      end
      new_page = get_page(node)
      if ((new_page).equal?(@current_page))
        return true
      end
      if (!(@current_page).nil?)
        if (!@current_page.ok_to_leave)
          return false
        end
      end
      old_page = @current_page
      @current_page = new_page
      # Set the new page's container
      @current_page.set_container(self)
      # Ensure that the page control has been created
      # (this allows lazy page control creation)
      if ((@current_page.get_control).nil?)
        failed = Array.typed(::Java::Boolean).new([false])
        SafeRunnable.run(Class.new(ISafeRunnable.class == Class ? ISafeRunnable : Object) do
          extend LocalClass
          include_class_members PreferenceDialog
          include ISafeRunnable if ISafeRunnable.class == Module
          
          typesig { [JavaThrowable] }
          define_method :handle_exception do |e|
            failed[0] = true
          end
          
          typesig { [] }
          define_method :run do
            create_page_control(self.attr_current_page, self.attr_page_container)
          end
          
          typesig { [Object] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
        if (failed[0])
          return false
        end
        # the page is responsible for ensuring the created control is
        # accessable
        # via getControl.
        Assert.is_not_null(@current_page.get_control)
      end
      # Force calculation of the page's description label because
      # label can be wrapped.
      size_ = Array.typed(Point).new(1) { nil }
      failed = Point.new(-1, -1)
      SafeRunnable.run(Class.new(ISafeRunnable.class == Class ? ISafeRunnable : Object) do
        extend LocalClass
        include_class_members PreferenceDialog
        include ISafeRunnable if ISafeRunnable.class == Module
        
        typesig { [JavaThrowable] }
        define_method :handle_exception do |e|
          size_[0] = failed
        end
        
        typesig { [] }
        define_method :run do
          size_[0] = self.attr_current_page.compute_size
        end
        
        typesig { [Object] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      if ((size_[0] == failed))
        return false
      end
      content_size = size_[0]
      # Do we need resizing. Computation not needed if the
      # first page is inserted since computing the dialog's
      # size is done by calling dialog.open().
      # Also prevent auto resize if the user has manually resized
      shell = get_shell
      shell_size = shell.get_size
      if (!(old_page).nil?)
        rect = @page_container.get_client_area
        container_size = Point.new(rect.attr_width, rect.attr_height)
        hdiff = content_size.attr_x - container_size.attr_x
        vdiff = content_size.attr_y - container_size.attr_y
        if ((hdiff > 0 || vdiff > 0) && (shell_size == @last_shell_size))
          hdiff = Math.max(0, hdiff)
          vdiff = Math.max(0, vdiff)
          set_shell_size(shell_size.attr_x + hdiff, shell_size.attr_y + vdiff)
          @last_shell_size = shell.get_size
          if ((@current_page.get_control.get_size.attr_x).equal?(0))
            @current_page.get_control.set_size(container_size)
          end
        else
          @current_page.set_size(container_size)
        end
      end
      @scrolled.set_min_size(content_size)
      # Ensure that all other pages are invisible
      # (including ones that triggered an exception during
      # their creation).
      children = @page_container.get_children
      current_control = @current_page.get_control
      i = 0
      while i < children.attr_length
        if (!(children[i]).equal?(current_control))
          children[i].set_visible(false)
        end
        i += 1
      end
      # Make the new page visible
      @current_page.set_visible(true)
      if (!(old_page).nil?)
        old_page.set_visible(false)
      end
      # update the dialog controls
      update
      return true
    end
    
    typesig { [IPreferenceNode] }
    # Create the page for the node.
    # @param node
    # 
    # @since 3.1
    def create_page(node)
      node.create_page
    end
    
    typesig { [IPreferenceNode] }
    # Get the page for the node.
    # @param node
    # @return IPreferencePage
    # 
    # @since 3.1
    def get_page(node)
      return node.get_page
    end
    
    typesig { [] }
    # Shows the "Page Flipping abort" dialog.
    def show_page_flipping_abort_dialog
      # $NON-NLS-1$
      MessageDialog.open(MessageDialog::ERROR, get_shell, JFaceResources.get_string("AbortPageFlippingDialog.title"), JFaceResources.get_string("AbortPageFlippingDialog.message"), SWT::SHEET) # $NON-NLS-1$
    end
    
    typesig { [] }
    # Updates this dialog's controls to reflect the current page.
    def update
      # Update the title bar
      update_title
      # Update the message line
      update_message
      # Update the buttons
      update_buttons
      # Saved the selected node in the preferences
      set_selected_node
      fire_page_changed(PageChangedEvent.new(self, get_current_page))
    end
    
    typesig { [] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.preference.IPreferencePageContainer#updateButtons()
    def update_buttons
      @ok_button.set_enabled(is_current_page_valid)
    end
    
    typesig { [] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.preference.IPreferencePageContainer#updateMessage()
    def update_message
      message = nil
      error_message = nil
      if (!(@current_page).nil?)
        message = RJava.cast_to_string(@current_page.get_message)
        error_message = RJava.cast_to_string(@current_page.get_error_message)
      end
      message_type = IMessageProvider::NONE
      if (!(message).nil? && @current_page.is_a?(IMessageProvider))
        message_type = (@current_page).get_message_type
      end
      if ((error_message).nil?)
        if (@showing_error)
          # we were previously showing an error
          @showing_error = false
        end
      else
        message = error_message
        message_type = IMessageProvider::ERROR
        if (!@showing_error)
          # we were not previously showing an error
          @showing_error = true
        end
      end
      @message_area.update_text(message, message_type)
    end
    
    typesig { [] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.preference.IPreferencePageContainer#updateTitle()
    def update_title
      if ((@current_page).nil?)
        return
      end
      @message_area.show_title(@current_page.get_title, @current_page.get_image)
    end
    
    typesig { [Font] }
    # Update the tree to use the specified <code>Font</code>.
    # 
    # @param dialogFont
    # the <code>Font</code> to use.
    # @since 3.0
    def update_tree_font(dialog_font)
      get_tree_viewer.get_control.set_font(dialog_font)
    end
    
    typesig { [] }
    # Returns the currentPage.
    # @return IPreferencePage
    # @since 3.1
    def get_current_page
      return @current_page
    end
    
    typesig { [IPreferencePage] }
    # Sets the current page.
    # @param currentPage
    # 
    # @since 3.1
    def set_current_page(current_page)
      @current_page = current_page
    end
    
    typesig { [TreeViewer] }
    # Set the treeViewer.
    # @param treeViewer
    # 
    # @since 3.1
    def set_tree_viewer(tree_viewer)
      @tree_viewer = tree_viewer
    end
    
    typesig { [] }
    # Get the composite that is showing the page.
    # 
    # @return Composite.
    # 
    # @since 3.1
    def get_page_container
      return @page_container
    end
    
    typesig { [Composite] }
    # Set the composite that is showing the page.
    # @param pageContainer Composite
    # 
    # @since 3.1
    def set_page_container(page_container)
      @page_container = page_container
    end
    
    typesig { [IPreferencePage, Composite] }
    # Create the page control for the supplied page.
    # 
    # @param page - the preference page to be shown
    # @param parent - the composite to parent the page
    # 
    # @since 3.1
    def create_page_control(page, parent)
      page.create_control(parent)
    end
    
    typesig { [] }
    # @see org.eclipse.jface.dialogs.IPageChangeProvider#getSelectedPage()
    # 
    # @since 3.1
    def get_selected_page
      return get_current_page
    end
    
    typesig { [IPageChangedListener] }
    # @see org.eclipse.jface.dialogs.IPageChangeProvider#addPageChangedListener(org.eclipse.jface.dialogs.IPageChangedListener)
    # @since 3.1
    def add_page_changed_listener(listener)
      @page_changed_listeners.add(listener)
    end
    
    typesig { [IPageChangedListener] }
    # @see org.eclipse.jface.dialogs.IPageChangeProvider#removePageChangedListener(org.eclipse.jface.dialogs.IPageChangedListener)
    # @since 3.1
    def remove_page_changed_listener(listener)
      @page_changed_listeners.remove(listener)
    end
    
    typesig { [PageChangedEvent] }
    # Notifies any selection changed listeners that the selected page
    # has changed.
    # Only listeners registered at the time this method is called are notified.
    # 
    # @param event a selection changed event
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
          extend LocalClass
          include_class_members PreferenceDialog
          include SafeRunnable if SafeRunnable.class == Module
          
          typesig { [] }
          define_method :run do
            l.page_changed(event)
          end
          
          typesig { [Object] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
        i += 1
      end
    end
    
    typesig { [] }
    # (non-Javadoc)
    # @see org.eclipse.jface.dialogs.Dialog#isResizable()
    def is_resizable
      return true
    end
    
    private
    alias_method :initialize__preference_dialog, :initialize
  end
  
end
