require "rjava"

# Copyright (c) 2000, 2009 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
# Sebastian Davids <sdavids@gmx.de> - Fix for bug 38729 - [Preferences]
# NPE PreferencePage isValid.
module Org::Eclipse::Jface::Preference
  module PreferencePageImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Preference
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Events, :SelectionAdapter
      include_const ::Org::Eclipse::Swt::Events, :SelectionEvent
      include_const ::Org::Eclipse::Swt::Graphics, :Font
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Layout, :GridData
      include_const ::Org::Eclipse::Swt::Layout, :GridLayout
      include_const ::Org::Eclipse::Swt::Widgets, :Button
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Event
      include_const ::Org::Eclipse::Swt::Widgets, :Label
      include_const ::Org::Eclipse::Jface::Dialogs, :Dialog
      include_const ::Org::Eclipse::Jface::Dialogs, :DialogPage
      include_const ::Org::Eclipse::Jface::Dialogs, :IDialogConstants
      include_const ::Org::Eclipse::Jface::Dialogs, :IDialogPage
      include_const ::Org::Eclipse::Jface::Resource, :ImageDescriptor
      include_const ::Org::Eclipse::Jface::Resource, :JFaceResources
    }
  end
  
  # Abstract base implementation for all preference page implementations.
  # <p>
  # Subclasses must implement the <code>createContents</code> framework
  # method to supply the page's main control.
  # </p>
  # <p>
  # Subclasses should extend the <code>doComputeSize</code> framework
  # method to compute the size of the page's control.
  # </p>
  # <p>
  # Subclasses may override the <code>performOk</code>, <code>performApply</code>,
  # <code>performDefaults</code>, <code>performCancel</code>, and <code>performHelp</code>
  # framework methods to react to the standard button events.
  # </p>
  # <p>
  # Subclasses may call the <code>noDefaultAndApplyButton</code> framework
  # method before the page's control has been created to suppress
  # the standard Apply and Defaults buttons.
  # </p>
  class PreferencePage < PreferencePageImports.const_get :DialogPage
    include_class_members PreferencePageImports
    overload_protected {
      include IPreferencePage
    }
    
    # Preference store, or <code>null</code>.
    attr_accessor :preference_store
    alias_method :attr_preference_store, :preference_store
    undef_method :preference_store
    alias_method :attr_preference_store=, :preference_store=
    undef_method :preference_store=
    
    # Valid state for this page; <code>true</code> by default.
    # 
    # @see #isValid
    attr_accessor :is_valid
    alias_method :attr_is_valid, :is_valid
    undef_method :is_valid
    alias_method :attr_is_valid=, :is_valid=
    undef_method :is_valid=
    
    # Body of page.
    attr_accessor :body
    alias_method :attr_body, :body
    undef_method :body
    alias_method :attr_body=, :body=
    undef_method :body=
    
    # Whether this page has the standard Apply and Defaults buttons;
    # <code>true</code> by default.
    # 
    # @see #noDefaultAndApplyButton
    attr_accessor :create_default_and_apply_button
    alias_method :attr_create_default_and_apply_button, :create_default_and_apply_button
    undef_method :create_default_and_apply_button
    alias_method :attr_create_default_and_apply_button=, :create_default_and_apply_button=
    undef_method :create_default_and_apply_button=
    
    # Standard Defaults button, or <code>null</code> if none.
    # This button has id <code>DEFAULTS_ID</code>.
    attr_accessor :defaults_button
    alias_method :attr_defaults_button, :defaults_button
    undef_method :defaults_button
    alias_method :attr_defaults_button=, :defaults_button=
    undef_method :defaults_button=
    
    # The container this preference page belongs to; <code>null</code>
    # if none.
    attr_accessor :container
    alias_method :attr_container, :container
    undef_method :container
    alias_method :attr_container=, :container=
    undef_method :container=
    
    # Standard Apply button, or <code>null</code> if none.
    # This button has id <code>APPLY_ID</code>.
    attr_accessor :apply_button
    alias_method :attr_apply_button, :apply_button
    undef_method :apply_button
    alias_method :attr_apply_button=, :apply_button=
    undef_method :apply_button=
    
    # Description label.
    # 
    # @see #createDescriptionLabel(Composite)
    attr_accessor :description_label
    alias_method :attr_description_label, :description_label
    undef_method :description_label
    alias_method :attr_description_label=, :description_label=
    undef_method :description_label=
    
    # Caches size of page.
    attr_accessor :size
    alias_method :attr_size, :size
    undef_method :size
    alias_method :attr_size=, :size=
    undef_method :size=
    
    typesig { [] }
    # Creates a new preference page with an empty title and no image.
    def initialize
      initialize__preference_page("") # $NON-NLS-1$
    end
    
    typesig { [String] }
    # Creates a new preference page with the given title and no image.
    # 
    # @param title the title of this preference page
    def initialize(title)
      @preference_store = nil
      @is_valid = false
      @body = nil
      @create_default_and_apply_button = false
      @defaults_button = nil
      @container = nil
      @apply_button = nil
      @description_label = nil
      @size = nil
      super(title)
      @is_valid = true
      @create_default_and_apply_button = true
      @defaults_button = nil
      @container = nil
      @apply_button = nil
      @size = nil
    end
    
    typesig { [String, ImageDescriptor] }
    # Creates a new abstract preference page with the given title and image.
    # 
    # @param title the title of this preference page
    # @param image the image for this preference page,
    # or <code>null</code> if none
    def initialize(title, image)
      @preference_store = nil
      @is_valid = false
      @body = nil
      @create_default_and_apply_button = false
      @defaults_button = nil
      @container = nil
      @apply_button = nil
      @description_label = nil
      @size = nil
      super(title, image)
      @is_valid = true
      @create_default_and_apply_button = true
      @defaults_button = nil
      @container = nil
      @apply_button = nil
      @size = nil
    end
    
    typesig { [] }
    # Computes the size for this page's UI control.
    # <p>
    # The default implementation of this <code>IPreferencePage</code>
    # method returns the size set by <code>setSize</code>; if no size
    # has been set, but the page has a UI control, the framework
    # method <code>doComputeSize</code> is called to compute the size.
    # </p>
    # 
    # @return the size of the preference page encoded as
    # <code>new Point(width,height)</code>, or
    # <code>(0,0)</code> if the page doesn't currently have any UI component
    def compute_size
      if (!(@size).nil?)
        return @size
      end
      control = get_control
      if (!(control).nil?)
        @size = do_compute_size
        return @size
      end
      return Point.new(0, 0)
    end
    
    typesig { [Composite] }
    # Contributes additional buttons to the given composite.
    # <p>
    # The default implementation of this framework hook method does
    # nothing. Subclasses should override this method to contribute buttons
    # to this page's button bar. For each button a subclass contributes,
    # it must also increase the parent's grid layout number of columns
    # by one; that is,
    # <pre>
    # ((GridLayout) parent.getLayout()).numColumns++);
    # </pre>
    # </p>
    # 
    # @param parent the button bar
    def contribute_buttons(parent)
    end
    
    typesig { [Composite] }
    # Creates and returns the SWT control for the customized body
    # of this preference page under the given parent composite.
    # <p>
    # This framework method must be implemented by concrete subclasses. Any
    # subclass returning a <code>Composite</code> object whose <code>Layout</code>
    # has default margins (for example, a <code>GridLayout</code>) are expected to
    # set the margins of this <code>Layout</code> to 0 pixels.
    # </p>
    # 
    # @param parent the parent composite
    # @return the new control
    def create_contents(parent)
      raise NotImplementedError
    end
    
    typesig { [Composite] }
    # The <code>PreferencePage</code> implementation of this
    # <code>IDialogPage</code> method creates a description label
    # and button bar for the page. It calls <code>createContents</code>
    # to create the custom contents of the page.
    # <p>
    # If a subclass that overrides this method creates a <code>Composite</code>
    # that has a layout with default margins (for example, a <code>GridLayout</code>)
    # it is expected to set the margins of this <code>Layout</code> to 0 pixels.
    # @see IDialogPage#createControl(Composite)
    def create_control(parent)
      gd = nil
      content = Composite.new(parent, SWT::NONE)
      set_control(content)
      layout = GridLayout.new
      layout.attr_margin_width = 0
      layout.attr_margin_height = 0
      content.set_layout(layout)
      # Apply the font on creation for backward compatibility
      apply_dialog_font(content)
      # initialize the dialog units
      initialize_dialog_units(content)
      @description_label = create_description_label(content)
      if (!(@description_label).nil?)
        @description_label.set_layout_data(GridData.new(GridData::FILL_HORIZONTAL))
      end
      @body = create_contents(content)
      if (!(@body).nil?)
        # null is not a valid return value but support graceful failure
        @body.set_layout_data(GridData.new(GridData::FILL_BOTH))
      end
      button_bar = Composite.new(content, SWT::NONE)
      layout = GridLayout.new
      layout.attr_num_columns = 0
      layout.attr_margin_height = 0
      layout.attr_margin_width = 0
      layout.attr_make_columns_equal_width = false
      button_bar.set_layout(layout)
      gd = GridData.new(GridData::HORIZONTAL_ALIGN_END)
      button_bar.set_layout_data(gd)
      contribute_buttons(button_bar)
      if (@create_default_and_apply_button)
        layout.attr_num_columns = layout.attr_num_columns + 2
        labels = JFaceResources.get_strings(Array.typed(String).new(["defaults", "apply"])) # $NON-NLS-2$//$NON-NLS-1$
        width_hint = convert_horizontal_dlus_to_pixels(IDialogConstants::BUTTON_WIDTH)
        @defaults_button = Button.new(button_bar, SWT::PUSH)
        @defaults_button.set_text(labels[0])
        Dialog.apply_dialog_font(@defaults_button)
        data = GridData.new(GridData::HORIZONTAL_ALIGN_FILL)
        min_button_size = @defaults_button.compute_size(SWT::DEFAULT, SWT::DEFAULT, true)
        data.attr_width_hint = Math.max(width_hint, min_button_size.attr_x)
        @defaults_button.set_layout_data(data)
        @defaults_button.add_selection_listener(Class.new(SelectionAdapter.class == Class ? SelectionAdapter : Object) do
          extend LocalClass
          include_class_members PreferencePage
          include SelectionAdapter if SelectionAdapter.class == Module
          
          typesig { [SelectionEvent] }
          define_method :widget_selected do |e|
            perform_defaults
          end
          
          typesig { [Object] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
        @apply_button = Button.new(button_bar, SWT::PUSH)
        @apply_button.set_text(labels[1])
        Dialog.apply_dialog_font(@apply_button)
        data = GridData.new(GridData::HORIZONTAL_ALIGN_FILL)
        min_button_size = @apply_button.compute_size(SWT::DEFAULT, SWT::DEFAULT, true)
        data.attr_width_hint = Math.max(width_hint, min_button_size.attr_x)
        @apply_button.set_layout_data(data)
        @apply_button.add_selection_listener(Class.new(SelectionAdapter.class == Class ? SelectionAdapter : Object) do
          extend LocalClass
          include_class_members PreferencePage
          include SelectionAdapter if SelectionAdapter.class == Module
          
          typesig { [SelectionEvent] }
          define_method :widget_selected do |e|
            perform_apply
          end
          
          typesig { [Object] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
        @apply_button.set_enabled(is_valid)
        apply_dialog_font(button_bar)
      else
        # Check if there are any other buttons on the button bar.
        # If not, throw away the button bar composite.  Otherwise
        # there is an unusually large button bar.
        if (button_bar.get_children.attr_length < 1)
          button_bar.dispose
        end
      end
    end
    
    typesig { [Composite] }
    # Apply the dialog font to the composite and it's children
    # if it is set. Subclasses may override if they wish to
    # set the font themselves.
    # @param composite
    def apply_dialog_font(composite)
      Dialog.apply_dialog_font(composite)
    end
    
    typesig { [Composite] }
    # Creates and returns an SWT label under the given composite.
    # 
    # @param parent the parent composite
    # @return the new label
    def create_description_label(parent)
      result = nil
      description = get_description
      if (!(description).nil?)
        result = Label.new(parent, SWT::WRAP)
        result.set_font(parent.get_font)
        result.set_text(description)
      end
      return result
    end
    
    typesig { [] }
    # Computes the size needed by this page's UI control.
    # <p>
    # All pages should override this method and set the appropriate sizes
    # of their widgets, and then call <code>super.doComputeSize</code>.
    # </p>
    # 
    # @return the size of the preference page encoded as
    # <code>new Point(width,height)</code>
    def do_compute_size
      if (!(@description_label).nil? && !(@body).nil?)
        body_size = @body.compute_size(SWT::DEFAULT, SWT::DEFAULT, true)
        gd = @description_label.get_layout_data
        gd.attr_width_hint = body_size.attr_x
      end
      return get_control.compute_size(SWT::DEFAULT, SWT::DEFAULT, true)
    end
    
    typesig { [] }
    # Returns the preference store of this preference page.
    # <p>
    # This is a framework hook method for subclasses to return a
    # page-specific preference store. The default implementation
    # returns <code>null</code>.
    # </p>
    # 
    # @return the preference store, or <code>null</code> if none
    def do_get_preference_store
      return nil
    end
    
    typesig { [] }
    # Returns the container of this page.
    # 
    # @return the preference page container, or <code>null</code> if this
    # page has yet to be added to a container
    def get_container
      return @container
    end
    
    typesig { [] }
    # Returns the preference store of this preference page.
    # 
    # @return the preference store , or <code>null</code> if none
    def get_preference_store
      if ((@preference_store).nil?)
        @preference_store = do_get_preference_store
      end
      if (!(@preference_store).nil?)
        return @preference_store
      else
        if (!(@container).nil?)
          return @container.get_preference_store
        end
      end
      return nil
    end
    
    typesig { [] }
    # The preference page implementation of an <code>IPreferencePage</code>
    # method returns whether this preference page is valid. Preference
    # pages are considered valid by default; call <code>setValid(false)</code>
    # to make a page invalid.
    # @see IPreferencePage#isValid()
    def is_valid
      return @is_valid
    end
    
    typesig { [] }
    # Suppresses creation of the standard Default and Apply buttons
    # for this page.
    # <p>
    # Subclasses wishing a preference page without these buttons
    # should call this framework method before the page's control
    # has been created.
    # </p>
    def no_default_and_apply_button
      @create_default_and_apply_button = false
    end
    
    typesig { [] }
    # The <code>PreferencePage</code> implementation of this
    # <code>IPreferencePage</code> method returns <code>true</code>
    # if the page is valid.
    # @see IPreferencePage#okToLeave()
    def ok_to_leave
      return is_valid
    end
    
    typesig { [] }
    # Performs special processing when this page's Apply button has been pressed.
    # <p>
    # This is a framework hook method for sublcasses to do special things when
    # the Apply button has been pressed.
    # The default implementation of this framework method simply calls
    # <code>performOk</code> to simulate the pressing of the page's OK button.
    # </p>
    # 
    # @see #performOk
    def perform_apply
      perform_ok
    end
    
    typesig { [] }
    # The preference page implementation of an <code>IPreferencePage</code>
    # method performs special processing when this page's Cancel button has
    # been pressed.
    # <p>
    # This is a framework hook method for subclasses to do special things when
    # the Cancel button has been pressed. The default implementation of this
    # framework method does nothing and returns <code>true</code>.
    # @see IPreferencePage#performCancel()
    def perform_cancel
      return true
    end
    
    typesig { [] }
    # Performs special processing when this page's Defaults button has been pressed.
    # <p>
    # This is a framework hook method for subclasses to do special things when
    # the Defaults button has been pressed.
    # Subclasses may override, but should call <code>super.performDefaults</code>.
    # </p>
    def perform_defaults
      update_apply_button
    end
    
    typesig { [] }
    # (non-Javadoc)
    # @see org.eclipse.jface.preference.IPreferencePage#performOk()
    def perform_ok
      return true
    end
    
    typesig { [IPreferencePageContainer] }
    # (non-Javadoc)
    # @see org.eclipse.jface.preference.IPreferencePage#setContainer(org.eclipse.jface.preference.IPreferencePageContainer)
    def set_container(container)
      @container = container
    end
    
    typesig { [IPreferenceStore] }
    # Sets the preference store for this preference page.
    # <p>
    # If preferenceStore is set to null, getPreferenceStore
    # will invoke doGetPreferenceStore the next time it is called.
    # </p>
    # 
    # @param store the preference store, or <code>null</code>
    # @see #getPreferenceStore
    def set_preference_store(store)
      @preference_store = store
    end
    
    typesig { [Point] }
    # (non-Javadoc)
    # @see org.eclipse.jface.preference.IPreferencePage#setSize(org.eclipse.swt.graphics.Point)
    def set_size(ui_size)
      control = get_control
      if (!(control).nil?)
        control.set_size(ui_size)
        @size = ui_size
      end
    end
    
    typesig { [String] }
    # The <code>PreferencePage</code> implementation of this <code>IDialogPage</code>
    # method extends the <code>DialogPage</code> implementation to update
    # the preference page container title. Subclasses may extend.
    # @see IDialogPage#setTitle(String)
    def set_title(title)
      super(title)
      if (!(get_container).nil?)
        get_container.update_title
      end
    end
    
    typesig { [::Java::Boolean] }
    # Sets whether this page is valid.
    # The enable state of the container buttons and the
    # apply button is updated when a page's valid state
    # changes.
    # <p>
    # 
    # @param b the new valid state
    def set_valid(b)
      old_value = @is_valid
      @is_valid = b
      if (!(old_value).equal?(@is_valid))
        # update container state
        if (!(get_container).nil?)
          get_container.update_buttons
        end
        # update page state
        update_apply_button
      end
    end
    
    typesig { [] }
    # (non-Javadoc)
    # @see java.lang.Object#toString()
    def to_s
      return get_title
    end
    
    typesig { [] }
    # Updates the enabled state of the Apply button to reflect whether
    # this page is valid.
    def update_apply_button
      if (!(@apply_button).nil?)
        @apply_button.set_enabled(is_valid)
      end
    end
    
    typesig { [Font, Composite, String, String] }
    # Creates a composite with a highlighted Note entry and a message text.
    # This is designed to take up the full width of the page.
    # 
    # @param font the font to use
    # @param composite the parent composite
    # @param title the title of the note
    # @param message the message for the note
    # @return the composite for the note
    def create_note_composite(font, composite, title, message)
      message_composite = Composite.new(composite, SWT::NONE)
      message_layout = GridLayout.new
      message_layout.attr_num_columns = 2
      message_layout.attr_margin_width = 0
      message_layout.attr_margin_height = 0
      message_composite.set_layout(message_layout)
      message_composite.set_layout_data(GridData.new(GridData::HORIZONTAL_ALIGN_FILL))
      message_composite.set_font(font)
      note_label = Label.new(message_composite, SWT::BOLD)
      note_label.set_text(title)
      note_label.set_font(JFaceResources.get_font_registry.get_bold(JFaceResources::DIALOG_FONT))
      note_label.set_layout_data(GridData.new(GridData::VERTICAL_ALIGN_BEGINNING))
      message_label = Label.new(message_composite, SWT::WRAP)
      message_label.set_text(message)
      message_label.set_font(font)
      return message_composite
    end
    
    typesig { [] }
    # Returns the Apply button.
    # 
    # @return the Apply button
    def get_apply_button
      return @apply_button
    end
    
    typesig { [] }
    # Returns the Restore Defaults button.
    # 
    # @return the Restore Defaults button
    def get_defaults_button
      return @defaults_button
    end
    
    typesig { [] }
    # (non-Javadoc)
    # @see org.eclipse.jface.dialogs.IDialogPage#performHelp()
    def perform_help
      get_control.notify_listeners(SWT::Help, Event.new)
    end
    
    typesig { [Object] }
    # Apply the data to the receiver. By default do nothing.
    # @param data
    # @since 3.1
    def apply_data(data)
    end
    
    typesig { [String] }
    # (non-Javadoc)
    # @see org.eclipse.jface.dialogs.DialogPage#setErrorMessage(java.lang.String)
    def set_error_message(new_message)
      super(new_message)
      if (!(get_container).nil?)
        get_container.update_message
      end
    end
    
    typesig { [String, ::Java::Int] }
    # (non-Javadoc)
    # @see org.eclipse.jface.dialogs.DialogPage#setMessage(java.lang.String, int)
    def set_message(new_message, new_type)
      super(new_message, new_type)
      if (!(get_container).nil?)
        get_container.update_message
      end
    end
    
    private
    alias_method :initialize__preference_page, :initialize
  end
  
end
