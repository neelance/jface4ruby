require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Viewers
  module TextCellEditorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
      include_const ::Java::Text, :MessageFormat
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Events, :FocusAdapter
      include_const ::Org::Eclipse::Swt::Events, :FocusEvent
      include_const ::Org::Eclipse::Swt::Events, :KeyAdapter
      include_const ::Org::Eclipse::Swt::Events, :KeyEvent
      include_const ::Org::Eclipse::Swt::Events, :ModifyEvent
      include_const ::Org::Eclipse::Swt::Events, :ModifyListener
      include_const ::Org::Eclipse::Swt::Events, :MouseAdapter
      include_const ::Org::Eclipse::Swt::Events, :MouseEvent
      include_const ::Org::Eclipse::Swt::Events, :SelectionAdapter
      include_const ::Org::Eclipse::Swt::Events, :SelectionEvent
      include_const ::Org::Eclipse::Swt::Events, :TraverseEvent
      include_const ::Org::Eclipse::Swt::Events, :TraverseListener
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Text
    }
  end
  
  # Not using ICU to support standalone JFace scenario
  # 
  # A cell editor that manages a text entry field.
  # The cell editor's value is the text string itself.
  # <p>
  # This class may be instantiated; it is not intended to be subclassed.
  # </p>
  # @noextend This class is not intended to be subclassed by clients.
  class TextCellEditor < TextCellEditorImports.const_get :CellEditor
    include_class_members TextCellEditorImports
    
    # The text control; initially <code>null</code>.
    attr_accessor :text
    alias_method :attr_text, :text
    undef_method :text
    alias_method :attr_text=, :text=
    undef_method :text=
    
    attr_accessor :modify_listener
    alias_method :attr_modify_listener, :modify_listener
    undef_method :modify_listener
    alias_method :attr_modify_listener=, :modify_listener=
    undef_method :modify_listener=
    
    # State information for updating action enablement
    attr_accessor :is_selection
    alias_method :attr_is_selection, :is_selection
    undef_method :is_selection
    alias_method :attr_is_selection=, :is_selection=
    undef_method :is_selection=
    
    attr_accessor :is_deleteable
    alias_method :attr_is_deleteable, :is_deleteable
    undef_method :is_deleteable
    alias_method :attr_is_deleteable=, :is_deleteable=
    undef_method :is_deleteable=
    
    attr_accessor :is_selectable
    alias_method :attr_is_selectable, :is_selectable
    undef_method :is_selectable
    alias_method :attr_is_selectable=, :is_selectable=
    undef_method :is_selectable=
    
    class_module.module_eval {
      # Default TextCellEditor style
      # specify no borders on text widget as cell outline in table already
      # provides the look of a border.
      const_set_lazy(:DefaultStyle) { SWT::SINGLE }
      const_attr_reader  :DefaultStyle
    }
    
    typesig { [] }
    # Creates a new text string cell editor with no control
    # The cell editor value is the string itself, which is initially the empty
    # string. Initially, the cell editor has no cell validator.
    # 
    # @since 2.1
    def initialize
      @text = nil
      @modify_listener = nil
      @is_selection = false
      @is_deleteable = false
      @is_selectable = false
      super()
      @is_selection = false
      @is_deleteable = false
      @is_selectable = false
      set_style(DefaultStyle)
    end
    
    typesig { [Composite] }
    # Creates a new text string cell editor parented under the given control.
    # The cell editor value is the string itself, which is initially the empty string.
    # Initially, the cell editor has no cell validator.
    # 
    # @param parent the parent control
    def initialize(parent)
      initialize__text_cell_editor(parent, DefaultStyle)
    end
    
    typesig { [Composite, ::Java::Int] }
    # Creates a new text string cell editor parented under the given control.
    # The cell editor value is the string itself, which is initially the empty string.
    # Initially, the cell editor has no cell validator.
    # 
    # @param parent the parent control
    # @param style the style bits
    # @since 2.1
    def initialize(parent, style)
      @text = nil
      @modify_listener = nil
      @is_selection = false
      @is_deleteable = false
      @is_selectable = false
      super(parent, style)
      @is_selection = false
      @is_deleteable = false
      @is_selectable = false
    end
    
    typesig { [] }
    # Checks to see if the "deletable" state (can delete/
    # nothing to delete) has changed and if so fire an
    # enablement changed notification.
    def check_deleteable
      old_is_deleteable = @is_deleteable
      @is_deleteable = is_delete_enabled
      if (!(old_is_deleteable).equal?(@is_deleteable))
        fire_enablement_changed(DELETE)
      end
    end
    
    typesig { [] }
    # Checks to see if the "selectable" state (can select)
    # has changed and if so fire an enablement changed notification.
    def check_selectable
      old_is_selectable = @is_selectable
      @is_selectable = is_select_all_enabled
      if (!(old_is_selectable).equal?(@is_selectable))
        fire_enablement_changed(SELECT_ALL)
      end
    end
    
    typesig { [] }
    # Checks to see if the selection state (selection /
    # no selection) has changed and if so fire an
    # enablement changed notification.
    def check_selection
      old_is_selection = @is_selection
      @is_selection = @text.get_selection_count > 0
      if (!(old_is_selection).equal?(@is_selection))
        fire_enablement_changed(COPY)
        fire_enablement_changed(CUT)
      end
    end
    
    typesig { [Composite] }
    # (non-Javadoc)
    # Method declared on CellEditor.
    def create_control(parent)
      @text = Text.new(parent, get_style)
      @text.add_selection_listener(Class.new(SelectionAdapter.class == Class ? SelectionAdapter : Object) do
        extend LocalClass
        include_class_members TextCellEditor
        include SelectionAdapter if SelectionAdapter.class == Module
        
        typesig { [SelectionEvent] }
        define_method :widget_default_selected do |e|
          handle_default_selection(e)
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      @text.add_key_listener(Class.new(KeyAdapter.class == Class ? KeyAdapter : Object) do
        extend LocalClass
        include_class_members TextCellEditor
        include KeyAdapter if KeyAdapter.class == Module
        
        typesig { [KeyEvent] }
        # hook key pressed - see PR 14201
        define_method :key_pressed do |e|
          key_release_occured(e)
          # as a result of processing the above call, clients may have
          # disposed this cell editor
          if (((get_control).nil?) || get_control.is_disposed)
            return
          end
          check_selection # see explanation below
          check_deleteable
          check_selectable
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      @text.add_traverse_listener(Class.new(TraverseListener.class == Class ? TraverseListener : Object) do
        extend LocalClass
        include_class_members TextCellEditor
        include TraverseListener if TraverseListener.class == Module
        
        typesig { [TraverseEvent] }
        define_method :key_traversed do |e|
          if ((e.attr_detail).equal?(SWT::TRAVERSE_ESCAPE) || (e.attr_detail).equal?(SWT::TRAVERSE_RETURN))
            e.attr_doit = false
          end
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      @text.add_mouse_listener(# We really want a selection listener but it is not supported so we
      # use a key listener and a mouse listener to know when selection changes
      # may have occurred
      Class.new(MouseAdapter.class == Class ? MouseAdapter : Object) do
        extend LocalClass
        include_class_members TextCellEditor
        include MouseAdapter if MouseAdapter.class == Module
        
        typesig { [MouseEvent] }
        define_method :mouse_up do |e|
          check_selection
          check_deleteable
          check_selectable
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      @text.add_focus_listener(Class.new(FocusAdapter.class == Class ? FocusAdapter : Object) do
        extend LocalClass
        include_class_members TextCellEditor
        include FocusAdapter if FocusAdapter.class == Module
        
        typesig { [FocusEvent] }
        define_method :focus_lost do |e|
          @local_class_parent.focus_lost
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      @text.set_font(parent.get_font)
      @text.set_background(parent.get_background)
      @text.set_text("") # $NON-NLS-1$
      @text.add_modify_listener(get_modify_listener)
      return @text
    end
    
    typesig { [] }
    # The <code>TextCellEditor</code> implementation of
    # this <code>CellEditor</code> framework method returns
    # the text string.
    # 
    # @return the text string
    def do_get_value
      return @text.get_text
    end
    
    typesig { [] }
    # (non-Javadoc)
    # Method declared on CellEditor.
    def do_set_focus
      if (!(@text).nil?)
        @text.select_all
        @text.set_focus
        check_selection
        check_deleteable
        check_selectable
      end
    end
    
    typesig { [Object] }
    # The <code>TextCellEditor</code> implementation of
    # this <code>CellEditor</code> framework method accepts
    # a text string (type <code>String</code>).
    # 
    # @param value a text string (type <code>String</code>)
    def do_set_value(value)
      Assert.is_true(!(@text).nil? && (value.is_a?(String)))
      @text.remove_modify_listener(get_modify_listener)
      @text.set_text(value)
      @text.add_modify_listener(get_modify_listener)
    end
    
    typesig { [ModifyEvent] }
    # Processes a modify event that occurred in this text cell editor.
    # This framework method performs validation and sets the error message
    # accordingly, and then reports a change via <code>fireEditorValueChanged</code>.
    # Subclasses should call this method at appropriate times. Subclasses
    # may extend or reimplement.
    # 
    # @param e the SWT modify event
    def edit_occured(e)
      value = @text.get_text
      if ((value).nil?)
        value = "" # $NON-NLS-1$
      end
      typed_value = value
      old_valid_state = is_value_valid
      new_valid_state = is_correct(typed_value)
      if ((typed_value).nil? && new_valid_state)
        Assert.is_true(false, "Validator isn't limiting the cell editor's type range") # $NON-NLS-1$
      end
      if (!new_valid_state)
        # try to insert the current value into the error message.
        set_error_message(MessageFormat.format(get_error_message, Array.typed(Object).new([value])))
      end
      value_changed(old_valid_state, new_valid_state)
    end
    
    typesig { [] }
    # Since a text editor field is scrollable we don't
    # set a minimumSize.
    def get_layout_data
      return LayoutData.new
    end
    
    typesig { [] }
    # Return the modify listener.
    def get_modify_listener
      if ((@modify_listener).nil?)
        @modify_listener = Class.new(ModifyListener.class == Class ? ModifyListener : Object) do
          extend LocalClass
          include_class_members TextCellEditor
          include ModifyListener if ModifyListener.class == Module
          
          typesig { [ModifyEvent] }
          define_method :modify_text do |e|
            edit_occured(e)
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self)
      end
      return @modify_listener
    end
    
    typesig { [SelectionEvent] }
    # Handles a default selection event from the text control by applying the editor
    # value and deactivating this cell editor.
    # 
    # @param event the selection event
    # 
    # @since 3.0
    def handle_default_selection(event)
      # same with enter-key handling code in keyReleaseOccured(e);
      fire_apply_editor_value
      deactivate
    end
    
    typesig { [] }
    # The <code>TextCellEditor</code>  implementation of this
    # <code>CellEditor</code> method returns <code>true</code> if
    # the current selection is not empty.
    def is_copy_enabled
      if ((@text).nil? || @text.is_disposed)
        return false
      end
      return @text.get_selection_count > 0
    end
    
    typesig { [] }
    # The <code>TextCellEditor</code>  implementation of this
    # <code>CellEditor</code> method returns <code>true</code> if
    # the current selection is not empty.
    def is_cut_enabled
      if ((@text).nil? || @text.is_disposed)
        return false
      end
      return @text.get_selection_count > 0
    end
    
    typesig { [] }
    # The <code>TextCellEditor</code>  implementation of this
    # <code>CellEditor</code> method returns <code>true</code>
    # if there is a selection or if the caret is not positioned
    # at the end of the text.
    def is_delete_enabled
      if ((@text).nil? || @text.is_disposed)
        return false
      end
      return @text.get_selection_count > 0 || @text.get_caret_position < @text.get_char_count
    end
    
    typesig { [] }
    # The <code>TextCellEditor</code>  implementation of this
    # <code>CellEditor</code> method always returns <code>true</code>.
    def is_paste_enabled
      if ((@text).nil? || @text.is_disposed)
        return false
      end
      return true
    end
    
    typesig { [] }
    # Check if save all is enabled
    # @return true if it is
    def is_save_all_enabled
      if ((@text).nil? || @text.is_disposed)
        return false
      end
      return true
    end
    
    typesig { [] }
    # Returns <code>true</code> if this cell editor is
    # able to perform the select all action.
    # <p>
    # This default implementation always returns
    # <code>false</code>.
    # </p>
    # <p>
    # Subclasses may override
    # </p>
    # @return <code>true</code> if select all is possible,
    # <code>false</code> otherwise
    def is_select_all_enabled
      if ((@text).nil? || @text.is_disposed)
        return false
      end
      return @text.get_char_count > 0
    end
    
    typesig { [KeyEvent] }
    # Processes a key release event that occurred in this cell editor.
    # <p>
    # The <code>TextCellEditor</code> implementation of this framework method
    # ignores when the RETURN key is pressed since this is handled in
    # <code>handleDefaultSelection</code>.
    # An exception is made for Ctrl+Enter for multi-line texts, since
    # a default selection event is not sent in this case.
    # </p>
    # 
    # @param keyEvent the key event
    def key_release_occured(key_event)
      if ((key_event.attr_character).equal?(Character.new(?\r.ord)))
        # Return key
        # Enter is handled in handleDefaultSelection.
        # Do not apply the editor value in response to an Enter key event
        # since this can be received from the IME when the intent is -not-
        # to apply the value.
        # See bug 39074 [CellEditors] [DBCS] canna input mode fires bogus event from Text Control
        # 
        # An exception is made for Ctrl+Enter for multi-line texts, since
        # a default selection event is not sent in this case.
        if (!(@text).nil? && !@text.is_disposed && !((@text.get_style & SWT::MULTI)).equal?(0))
          if (!((key_event.attr_state_mask & SWT::CTRL)).equal?(0))
            super(key_event)
          end
        end
        return
      end
      super(key_event)
    end
    
    typesig { [] }
    # The <code>TextCellEditor</code> implementation of this
    # <code>CellEditor</code> method copies the
    # current selection to the clipboard.
    def perform_copy
      @text.copy
    end
    
    typesig { [] }
    # The <code>TextCellEditor</code> implementation of this
    # <code>CellEditor</code> method cuts the
    # current selection to the clipboard.
    def perform_cut
      @text.cut
      check_selection
      check_deleteable
      check_selectable
    end
    
    typesig { [] }
    # The <code>TextCellEditor</code> implementation of this
    # <code>CellEditor</code> method deletes the
    # current selection or, if there is no selection,
    # the character next character from the current position.
    def perform_delete
      if (@text.get_selection_count > 0)
        # remove the contents of the current selection
        @text.insert("") # $NON-NLS-1$
      else
        # remove the next character
        pos = @text.get_caret_position
        if (pos < @text.get_char_count)
          @text.set_selection(pos, pos + 1)
          @text.insert("") # $NON-NLS-1$
        end
      end
      check_selection
      check_deleteable
      check_selectable
    end
    
    typesig { [] }
    # The <code>TextCellEditor</code> implementation of this
    # <code>CellEditor</code> method pastes the
    # the clipboard contents over the current selection.
    def perform_paste
      @text.paste
      check_selection
      check_deleteable
      check_selectable
    end
    
    typesig { [] }
    # The <code>TextCellEditor</code> implementation of this
    # <code>CellEditor</code> method selects all of the
    # current text.
    def perform_select_all
      @text.select_all
      check_selection
      check_deleteable
    end
    
    typesig { [] }
    # This implementation of
    # {@link CellEditor#dependsOnExternalFocusListener()} returns false if the
    # current instance's class is TextCellEditor, and true otherwise.
    # Subclasses that hook their own focus listener should override this method
    # and return false. See also bug 58777.
    # 
    # @since 3.4
    def depends_on_external_focus_listener
      return !(get_class).equal?(TextCellEditor)
    end
    
    private
    alias_method :initialize__text_cell_editor, :initialize
  end
  
end
