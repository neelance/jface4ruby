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
  module MessageDialogWithToggleImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Dialogs
      include_const ::Org::Eclipse::Jface::Preference, :IPreferenceStore
      include_const ::Org::Eclipse::Jface::Resource, :JFaceResources
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Events, :SelectionAdapter
      include_const ::Org::Eclipse::Swt::Events, :SelectionEvent
      include_const ::Org::Eclipse::Swt::Graphics, :Image
      include_const ::Org::Eclipse::Swt::Layout, :GridData
      include_const ::Org::Eclipse::Swt::Widgets, :Button
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Shell
    }
  end
  
  # <p>
  # A message dialog which also allows the user to adjust a toggle setting. If a
  # preference store is provided and the user selects the toggle, then the user's
  # answer (yes/ok or no) will be persisted in the store. If no store is
  # provided, then this information can be queried after the dialog closes.
  # </p>
  # <p>
  # This type of dialog should be used whenever you want to user to be able to
  # avoid being prompted in the future. It is <strong>strongly </strong>
  # recommended that a cancel option be provided, so that the user has the option
  # of making the decision at a later point in time. The semantic for a cancel
  # button should be to cancel the operation (if it has not yet started), or stop
  # the operation (if it has already started).
  # </p>
  # <p>
  # It is the responsibility of the developer to provide a mechanism for the user
  # to change this preference at some later point in time (e.g., through a
  # preference page).
  # </p>
  # 
  # @since 3.0
  class MessageDialogWithToggle < MessageDialogWithToggleImports.const_get :MessageDialog
    include_class_members MessageDialogWithToggleImports
    
    class_module.module_eval {
      # The value of the preference when the user has asked that the answer to
      # the question always be "okay" or "yes".
      const_set_lazy(:ALWAYS) { "always" }
      const_attr_reader  :ALWAYS
      
      # $NON-NLS-1$
      # 
      # The value of the preference when the user has asked that the answer to
      # the question always be "no".
      const_set_lazy(:NEVER) { "never" }
      const_attr_reader  :NEVER
      
      # $NON-NLS-1$
      # 
      # The value of the preference when the user wishes to prompted for an
      # answer every time the question is to be asked.
      const_set_lazy(:PROMPT) { "prompt" }
      const_attr_reader  :PROMPT
      
      typesig { [::Java::Int, Shell, String, String, String, ::Java::Boolean, IPreferenceStore, String, ::Java::Int] }
      # $NON-NLS-1$
      # 
      # Convenience method to open a simple dialog as specified by the <code>kind</code> flag,
      # with a "don't show again' toggle.
      # 
      # @param kind
      # the kind of dialog to open, one of {@link #ERROR},
      # {@link #INFORMATION}, {@link #QUESTION}, {@link #WARNING},
      # {@link #CONFIRM}, or {#QUESTION_WITH_CANCEL}.
      # @param parent
      # the parent shell of the dialog, or <code>null</code> if none
      # @param title
      # the dialog's title, or <code>null</code> if none
      # @param message
      # the message
      # @param toggleMessage
      # the message for the toggle control, or <code>null</code> for
      # the default message
      # @param toggleState
      # the initial state for the toggle
      # @param store
      # the IPreference store in which the user's preference should be
      # persisted; <code>null</code> if you don't want it persisted
      # automatically.
      # @param key
      # the key to use when persisting the user's preference;
      # <code>null</code> if you don't want it persisted.
      # @param style
      # {@link SWT#NONE} for a default dialog, or {@link SWT#SHEET} for
      # a dialog with sheet behavior
      # @return the dialog, after being closed by the user, which the client can
      # only call <code>getReturnCode()</code> or
      # <code>getToggleState()</code>
      # @since 3.5
      def open(kind, parent, title, message, toggle_message, toggle_state, store, key, style)
        # accept the default window icon
        dialog = MessageDialogWithToggle.new(parent, title, nil, message, kind, get_button_labels(kind), 0, toggle_message, toggle_state)
        style &= SWT::SHEET
        dialog.set_shell_style(dialog.get_shell_style | style)
        dialog.attr_pref_store = store
        dialog.attr_pref_key = key
        dialog.open
        return dialog
      end
      
      typesig { [Shell, String, String, String, ::Java::Boolean, IPreferenceStore, String] }
      # Convenience method to open a standard error dialog.
      # 
      # @param parent
      # the parent shell of the dialog, or <code>null</code> if none
      # @param title
      # the dialog's title, or <code>null</code> if none
      # @param message
      # the message
      # @param toggleMessage
      # the message for the toggle control, or <code>null</code> for
      # the default message
      # @param toggleState
      # the initial state for the toggle
      # @param store
      # the IPreference store in which the user's preference should be
      # persisted; <code>null</code> if you don't want it persisted
      # automatically.
      # @param key
      # the key to use when persisting the user's preference;
      # <code>null</code> if you don't want it persisted.
      # @return the dialog, after being closed by the user, which the client can
      # only call <code>getReturnCode()</code> or
      # <code>getToggleState()</code>
      def open_error(parent, title, message, toggle_message, toggle_state, store, key)
        return open(ERROR, parent, title, message, toggle_message, toggle_state, store, key, SWT::NONE)
      end
      
      typesig { [Shell, String, String, String, ::Java::Boolean, IPreferenceStore, String] }
      # Convenience method to open a standard information dialog.
      # 
      # @param parent
      # the parent shell of the dialog, or <code>null</code> if none
      # @param title
      # the dialog's title, or <code>null</code> if none
      # @param message
      # the message
      # @param toggleMessage
      # the message for the toggle control, or <code>null</code> for
      # the default message
      # @param toggleState
      # the initial state for the toggle
      # @param store
      # the IPreference store in which the user's preference should be
      # persisted; <code>null</code> if you don't want it persisted
      # automatically.
      # @param key
      # the key to use when persisting the user's preference;
      # <code>null</code> if you don't want it persisted.
      # 
      # @return the dialog, after being closed by the user, which the client can
      # only call <code>getReturnCode()</code> or
      # <code>getToggleState()</code>
      def open_information(parent, title, message, toggle_message, toggle_state, store, key)
        return open(INFORMATION, parent, title, message, toggle_message, toggle_state, store, key, SWT::NONE)
      end
      
      typesig { [Shell, String, String, String, ::Java::Boolean, IPreferenceStore, String] }
      # Convenience method to open a simple confirm (OK/Cancel) dialog.
      # 
      # @param parent
      # the parent shell of the dialog, or <code>null</code> if none
      # @param title
      # the dialog's title, or <code>null</code> if none
      # @param message
      # the message
      # @param toggleMessage
      # the message for the toggle control, or <code>null</code> for
      # the default message
      # @param toggleState
      # the initial state for the toggle
      # @param store
      # the IPreference store in which the user's preference should be
      # persisted; <code>null</code> if you don't want it persisted
      # automatically.
      # @param key
      # the key to use when persisting the user's preference;
      # <code>null</code> if you don't want it persisted.
      # @return the dialog, after being closed by the user, which the client can
      # only call <code>getReturnCode()</code> or
      # <code>getToggleState()</code>
      def open_ok_cancel_confirm(parent, title, message, toggle_message, toggle_state, store, key)
        return open(CONFIRM, parent, title, message, toggle_message, toggle_state, store, key, SWT::NONE)
      end
      
      typesig { [Shell, String, String, String, ::Java::Boolean, IPreferenceStore, String] }
      # Convenience method to open a standard warning dialog.
      # 
      # @param parent
      # the parent shell of the dialog, or <code>null</code> if none
      # @param title
      # the dialog's title, or <code>null</code> if none
      # @param message
      # the message
      # @param toggleMessage
      # the message for the toggle control, or <code>null</code> for
      # the default message
      # @param toggleState
      # the initial state for the toggle
      # @param store
      # the IPreference store in which the user's preference should be
      # persisted; <code>null</code> if you don't want it persisted
      # automatically.
      # @param key
      # the key to use when persisting the user's preference;
      # <code>null</code> if you don't want it persisted.
      # @return the dialog, after being closed by the user, which the client can
      # only call <code>getReturnCode()</code> or
      # <code>getToggleState()</code>
      def open_warning(parent, title, message, toggle_message, toggle_state, store, key)
        return open(WARNING, parent, title, message, toggle_message, toggle_state, store, key, SWT::NONE)
      end
      
      typesig { [Shell, String, String, String, ::Java::Boolean, IPreferenceStore, String] }
      # Convenience method to open a simple question Yes/No/Cancel dialog.
      # 
      # @param parent
      # the parent shell of the dialog, or <code>null</code> if none
      # @param title
      # the dialog's title, or <code>null</code> if none
      # @param message
      # the message
      # @param toggleMessage
      # the message for the toggle control, or <code>null</code> for
      # the default message
      # @param toggleState
      # the initial state for the toggle
      # @param store
      # the IPreference store in which the user's preference should be
      # persisted; <code>null</code> if you don't want it persisted
      # automatically.
      # @param key
      # the key to use when persisting the user's preference;
      # <code>null</code> if you don't want it persisted.
      # @return the dialog, after being closed by the user, which the client can
      # only call <code>getReturnCode()</code> or
      # <code>getToggleState()</code>
      def open_yes_no_cancel_question(parent, title, message, toggle_message, toggle_state, store, key)
        return open(QUESTION_WITH_CANCEL, parent, title, message, toggle_message, toggle_state, store, key, SWT::NONE)
      end
      
      typesig { [Shell, String, String, String, ::Java::Boolean, IPreferenceStore, String] }
      # Convenience method to open a simple Yes/No question dialog.
      # 
      # @param parent
      # the parent shell of the dialog, or <code>null</code> if none
      # @param title
      # the dialog's title, or <code>null</code> if none
      # @param message
      # the message
      # @param toggleMessage
      # the message for the toggle control, or <code>null</code> for
      # the default message
      # @param toggleState
      # the initial state for the toggle
      # @param store
      # the IPreference store in which the user's preference should be
      # persisted; <code>null</code> if you don't want it persisted
      # automatically.
      # @param key
      # the key to use when persisting the user's preference;
      # <code>null</code> if you don't want it persisted.
      # 
      # @return the dialog, after being closed by the user, which the client can
      # only call <code>getReturnCode()</code> or
      # <code>getToggleState()</code>
      def open_yes_no_question(parent, title, message, toggle_message, toggle_state, store, key)
        return open(QUESTION, parent, title, message, toggle_message, toggle_state, store, key, SWT::NONE)
      end
    }
    
    # The key at which the toggle state should be stored within the
    # preferences. This value may be <code>null</code>, which indicates that
    # no preference should be updated automatically. It is then the
    # responsibility of the user of this API to use the information from the
    # toggle. Note: a <code>prefStore</code> is also needed.
    attr_accessor :pref_key
    alias_method :attr_pref_key, :pref_key
    undef_method :pref_key
    alias_method :attr_pref_key=, :pref_key=
    undef_method :pref_key=
    
    # The preference store which will be affected by the toggle button. This
    # value may be <code>null</code>, which indicates that no preference
    # should be updated automatically. It is then the responsibility of the
    # user of this API to use the information from the toggle. Note: a
    # <code>prefKey</code> is also needed.
    attr_accessor :pref_store
    alias_method :attr_pref_store, :pref_store
    undef_method :pref_store
    alias_method :attr_pref_store=, :pref_store=
    undef_method :pref_store=
    
    # The toggle button (widget). This value is <code>null</code> until the
    # dialog is created.
    attr_accessor :toggle_button
    alias_method :attr_toggle_button, :toggle_button
    undef_method :toggle_button
    alias_method :attr_toggle_button=, :toggle_button=
    undef_method :toggle_button=
    
    # The message displayed to the user, with the toggle button. This is the
    # text besides the toggle. If it is <code>null</code>, this means that
    # the default text for the toggle should be used.
    attr_accessor :toggle_message
    alias_method :attr_toggle_message, :toggle_message
    undef_method :toggle_message
    alias_method :attr_toggle_message=, :toggle_message=
    undef_method :toggle_message=
    
    # The initial selected state of the toggle.
    attr_accessor :toggle_state
    alias_method :attr_toggle_state, :toggle_state
    undef_method :toggle_state
    alias_method :attr_toggle_state=, :toggle_state=
    undef_method :toggle_state=
    
    typesig { [Shell, String, Image, String, ::Java::Int, Array.typed(String), ::Java::Int, String, ::Java::Boolean] }
    # Creates a message dialog with a toggle. See the superclass constructor
    # for info on the other parameters.
    # 
    # @param parentShell
    # the parent shell
    # @param dialogTitle
    # the dialog title, or <code>null</code> if none
    # @param image
    # the dialog title image, or <code>null</code> if none
    # @param message
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
    # @param toggleMessage
    # the message for the toggle control, or <code>null</code> for
    # the default message
    # @param toggleState
    # the initial state for the toggle
    def initialize(parent_shell, dialog_title, image, message, dialog_image_type, dialog_button_labels, default_index, toggle_message, toggle_state)
      @pref_key = nil
      @pref_store = nil
      @toggle_button = nil
      @toggle_message = nil
      @toggle_state = false
      super(parent_shell, dialog_title, image, message, dialog_image_type, dialog_button_labels, default_index)
      @pref_key = nil
      @pref_store = nil
      @toggle_button = nil
      @toggle_message = toggle_message
      @toggle_state = toggle_state
      set_button_labels(dialog_button_labels)
    end
    
    typesig { [::Java::Int] }
    # @see org.eclipse.jface.dialogs.Dialog#buttonPressed(int)
    def button_pressed(button_id)
      super(button_id)
      if (!(button_id).equal?(IDialogConstants::CANCEL_ID) && @toggle_state && !(@pref_store).nil? && !(@pref_key).nil?)
        case (button_id)
        when IDialogConstants::YES_ID, IDialogConstants::YES_TO_ALL_ID, IDialogConstants::PROCEED_ID, IDialogConstants::OK_ID
          @pref_store.set_value(@pref_key, ALWAYS)
        when IDialogConstants::NO_ID, IDialogConstants::NO_TO_ALL_ID
          @pref_store.set_value(@pref_key, NEVER)
        end
      end
    end
    
    typesig { [Composite] }
    # @see Dialog#createButtonBar(Composite)
    def create_buttons_for_button_bar(parent)
      button_labels = get_button_labels
      buttons = Array.typed(Button).new(button_labels.attr_length) { nil }
      default_button_index = get_default_button_index
      suggested_id = IDialogConstants::INTERNAL_ID
      i = 0
      while i < button_labels.attr_length
        label = button_labels[i]
        # get the JFace button ID that matches the label, or use the specified
        # id if there is no match.
        id = map_button_label_to_button_id(label, suggested_id)
        # if the suggested id was used, increment the default for next use
        if ((id).equal?(suggested_id))
          suggested_id += 1
        end
        button = create_button(parent, id, label, (default_button_index).equal?(i))
        buttons[i] = button
        i += 1
      end
      set_buttons(buttons)
    end
    
    typesig { [Composite] }
    # @see Dialog#createDialogArea(Composite)
    def create_dialog_area(parent)
      dialog_area_composite = super(parent)
      set_toggle_button(create_toggle_button(dialog_area_composite))
      return dialog_area_composite
    end
    
    typesig { [Composite] }
    # Creates a toggle button without any text or state.  The text and state
    # will be created by <code>createDialogArea</code>.
    # 
    # @param parent
    # The composite in which the toggle button should be placed;
    # must not be <code>null</code>.
    # @return The added toggle button; never <code>null</code>.
    def create_toggle_button(parent)
      button = Button.new(parent, SWT::CHECK | SWT::LEFT)
      data = GridData.new(SWT::NONE)
      data.attr_horizontal_span = 2
      button.set_layout_data(data)
      button.set_font(parent.get_font)
      button.add_selection_listener(Class.new(SelectionAdapter.class == Class ? SelectionAdapter : Object) do
        extend LocalClass
        include_class_members MessageDialogWithToggle
        include SelectionAdapter if SelectionAdapter.class == Module
        
        typesig { [SelectionEvent] }
        define_method :widget_selected do |e|
          self.attr_toggle_state = button.get_selection
        end
        
        typesig { [Object] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      return button
    end
    
    typesig { [] }
    # Returns the toggle button.
    # 
    # @return the toggle button
    def get_toggle_button
      return @toggle_button
    end
    
    typesig { [] }
    # An accessor for the current preference store for this dialog.
    # 
    # @return The preference store; this value may be <code>null</code> if no
    # preference is being used.
    def get_pref_store
      return @pref_store
    end
    
    typesig { [] }
    # An accessor for the current key of the toggle preference.
    # 
    # @return The preference key; this value may be <code>null</code> if no
    # preference is being used.
    def get_pref_key
      return @pref_key
    end
    
    typesig { [] }
    # Returns the toggle state. This can be called even after the dialog is
    # closed.
    # 
    # @return <code>true</code> if the toggle button is checked,
    # <code>false</code> if not
    def get_toggle_state
      return @toggle_state
    end
    
    typesig { [String] }
    # A mutator for the key of the preference to be modified by the toggle
    # button.
    # 
    # @param prefKey
    # The prefKey to set. If this value is <code>null</code>,
    # then no preference will be modified.
    def set_pref_key(pref_key)
      @pref_key = pref_key
    end
    
    typesig { [IPreferenceStore] }
    # A mutator for the preference store to be modified by the toggle button.
    # 
    # @param prefStore
    # The prefStore to set. If this value is <code>null</code>,
    # then no preference will be modified.
    def set_pref_store(pref_store)
      @pref_store = pref_store
    end
    
    typesig { [Button] }
    # A mutator for the button providing the toggle option. If the button
    # exists, then it will automatically get the text set to the current toggle
    # message, and its selection state set to the current selection state.
    # 
    # @param button
    # The button to use; must not be <code>null</code>.
    def set_toggle_button(button)
      if ((button).nil?)
        raise NullPointerException.new("A message dialog with toggle may not have a null toggle button.")
      end # $NON-NLS-1$
      if (!button.is_disposed)
        text = nil
        if ((@toggle_message).nil?)
          text = RJava.cast_to_string(JFaceResources.get_string("MessageDialogWithToggle.defaultToggleMessage")) # $NON-NLS-1$
        else
          text = @toggle_message
        end
        button.set_text(text)
        button.set_selection(@toggle_state)
      end
      @toggle_button = button
    end
    
    typesig { [String] }
    # A mutator for the text on the toggle button. The button will
    # automatically get updated with the new text, if it exists.
    # 
    # @param message
    # The new text of the toggle button; if it is <code>null</code>,
    # then used the default toggle message.
    def set_toggle_message(message)
      @toggle_message = message
      if ((!(@toggle_button).nil?) && (!@toggle_button.is_disposed))
        text = nil
        if ((@toggle_message).nil?)
          text = RJava.cast_to_string(JFaceResources.get_string("MessageDialogWithToggle.defaultToggleMessage")) # $NON-NLS-1$
        else
          text = @toggle_message
        end
        @toggle_button.set_text(text)
      end
    end
    
    typesig { [::Java::Boolean] }
    # A mutator for the state of the toggle button. This method will update the
    # button, if it exists.
    # 
    # @param toggleState
    # The desired state of the toggle button (<code>true</code>
    # means the toggle should be selected).
    def set_toggle_state(toggle_state)
      @toggle_state = toggle_state
      # Update the button, if it exists.
      if ((!(@toggle_button).nil?) && (!@toggle_button.is_disposed))
        @toggle_button.set_selection(toggle_state)
      end
    end
    
    typesig { [String, ::Java::Int] }
    # Attempt to find a standard JFace button id that matches the specified button
    # label.  If no match can be found, use the default id provided.
    # 
    # @param buttonLabel the button label whose id is sought
    # @param defaultId the id to use for the button if there is no standard id
    # @return the id for the specified button label
    def map_button_label_to_button_id(button_label, default_id)
      # Not pretty but does the job...
      if ((IDialogConstants::OK_LABEL == button_label))
        return IDialogConstants::OK_ID
      end
      if ((IDialogConstants::YES_LABEL == button_label))
        return IDialogConstants::YES_ID
      end
      if ((IDialogConstants::NO_LABEL == button_label))
        return IDialogConstants::NO_ID
      end
      if ((IDialogConstants::CANCEL_LABEL == button_label))
        return IDialogConstants::CANCEL_ID
      end
      if ((IDialogConstants::YES_TO_ALL_LABEL == button_label))
        return IDialogConstants::YES_TO_ALL_ID
      end
      if ((IDialogConstants::SKIP_LABEL == button_label))
        return IDialogConstants::SKIP_ID
      end
      if ((IDialogConstants::STOP_LABEL == button_label))
        return IDialogConstants::STOP_ID
      end
      if ((IDialogConstants::ABORT_LABEL == button_label))
        return IDialogConstants::ABORT_ID
      end
      if ((IDialogConstants::RETRY_LABEL == button_label))
        return IDialogConstants::RETRY_ID
      end
      if ((IDialogConstants::IGNORE_LABEL == button_label))
        return IDialogConstants::IGNORE_ID
      end
      if ((IDialogConstants::PROCEED_LABEL == button_label))
        return IDialogConstants::PROCEED_ID
      end
      if ((IDialogConstants::OPEN_LABEL == button_label))
        return IDialogConstants::OPEN_ID
      end
      if ((IDialogConstants::CLOSE_LABEL == button_label))
        return IDialogConstants::CLOSE_ID
      end
      if ((IDialogConstants::BACK_LABEL == button_label))
        return IDialogConstants::BACK_ID
      end
      if ((IDialogConstants::NEXT_LABEL == button_label))
        return IDialogConstants::NEXT_ID
      end
      if ((IDialogConstants::FINISH_LABEL == button_label))
        return IDialogConstants::FINISH_ID
      end
      if ((IDialogConstants::HELP_LABEL == button_label))
        return IDialogConstants::HELP_ID
      end
      if ((IDialogConstants::NO_TO_ALL_LABEL == button_label))
        return IDialogConstants::NO_TO_ALL_ID
      end
      if ((IDialogConstants::SHOW_DETAILS_LABEL == button_label))
        return IDialogConstants::DETAILS_ID
      end
      if ((IDialogConstants::HIDE_DETAILS_LABEL == button_label))
        return IDialogConstants::DETAILS_ID
      end
      # No XXX_LABEL in IDialogConstants for these. Unlikely
      # they would be used in a message dialog though.
      # public int SELECT_ALL_ID = 18;
      # public int DESELECT_ALL_ID = 19;
      # public int SELECT_TYPES_ID = 20;
      return default_id
    end
    
    private
    alias_method :initialize__message_dialog_with_toggle, :initialize
  end
  
end
