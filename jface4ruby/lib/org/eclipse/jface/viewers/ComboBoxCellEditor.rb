require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
# Tom Schindl <tom.schindl@bestsolution.at> - bugfix in 174739
module Org::Eclipse::Jface::Viewers
  module ComboBoxCellEditorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
      include_const ::Java::Text, :MessageFormat
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Custom, :CCombo
      include_const ::Org::Eclipse::Swt::Events, :FocusAdapter
      include_const ::Org::Eclipse::Swt::Events, :FocusEvent
      include_const ::Org::Eclipse::Swt::Events, :KeyAdapter
      include_const ::Org::Eclipse::Swt::Events, :KeyEvent
      include_const ::Org::Eclipse::Swt::Events, :SelectionAdapter
      include_const ::Org::Eclipse::Swt::Events, :SelectionEvent
      include_const ::Org::Eclipse::Swt::Events, :TraverseEvent
      include_const ::Org::Eclipse::Swt::Events, :TraverseListener
      include_const ::Org::Eclipse::Swt::Graphics, :SwtGC
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Control
    }
  end
  
  # Not using ICU to support standalone JFace
  # scenario
  # 
  # A cell editor that presents a list of items in a combo box. The cell editor's
  # value is the zero-based index of the selected item.
  # <p>
  # This class may be instantiated; it is not intended to be subclassed.
  # </p>
  # @noextend This class is not intended to be subclassed by clients.
  class ComboBoxCellEditor < ComboBoxCellEditorImports.const_get :AbstractComboBoxCellEditor
    include_class_members ComboBoxCellEditorImports
    
    # The list of items to present in the combo box.
    attr_accessor :items
    alias_method :attr_items, :items
    undef_method :items
    alias_method :attr_items=, :items=
    undef_method :items=
    
    # The zero-based index of the selected item.
    attr_accessor :selection
    alias_method :attr_selection, :selection
    undef_method :selection
    alias_method :attr_selection=, :selection=
    undef_method :selection=
    
    # The custom combo box control.
    attr_accessor :combo_box
    alias_method :attr_combo_box, :combo_box
    undef_method :combo_box
    alias_method :attr_combo_box=, :combo_box=
    undef_method :combo_box=
    
    class_module.module_eval {
      # Default ComboBoxCellEditor style
      const_set_lazy(:DefaultStyle) { SWT::NONE }
      const_attr_reader  :DefaultStyle
    }
    
    typesig { [] }
    # Creates a new cell editor with no control and no st of choices.
    # Initially, the cell editor has no cell validator.
    # 
    # @since 2.1
    # @see CellEditor#setStyle
    # @see CellEditor#create
    # @see ComboBoxCellEditor#setItems
    # @see CellEditor#dispose
    def initialize
      @items = nil
      @selection = 0
      @combo_box = nil
      super()
      set_style(DefaultStyle)
    end
    
    typesig { [Composite, Array.typed(String)] }
    # Creates a new cell editor with a combo containing the given list of
    # choices and parented under the given control. The cell editor value is
    # the zero-based index of the selected item. Initially, the cell editor has
    # no cell validator and the first item in the list is selected.
    # 
    # @param parent
    # the parent control
    # @param items
    # the list of strings for the combo box
    def initialize(parent, items)
      initialize__combo_box_cell_editor(parent, items, DefaultStyle)
    end
    
    typesig { [Composite, Array.typed(String), ::Java::Int] }
    # Creates a new cell editor with a combo containing the given list of
    # choices and parented under the given control. The cell editor value is
    # the zero-based index of the selected item. Initially, the cell editor has
    # no cell validator and the first item in the list is selected.
    # 
    # @param parent
    # the parent control
    # @param items
    # the list of strings for the combo box
    # @param style
    # the style bits
    # @since 2.1
    def initialize(parent, items, style)
      @items = nil
      @selection = 0
      @combo_box = nil
      super(parent, style)
      set_items(items)
    end
    
    typesig { [] }
    # Returns the list of choices for the combo box
    # 
    # @return the list of choices for the combo box
    def get_items
      return @items
    end
    
    typesig { [Array.typed(String)] }
    # Sets the list of choices for the combo box
    # 
    # @param items
    # the list of choices for the combo box
    def set_items(items)
      Assert.is_not_null(items)
      @items = items
      populate_combo_box_items
    end
    
    typesig { [Composite] }
    # (non-Javadoc) Method declared on CellEditor.
    def create_control(parent)
      @combo_box = CCombo.new(parent, get_style)
      @combo_box.set_font(parent.get_font)
      populate_combo_box_items
      @combo_box.add_key_listener(Class.new(KeyAdapter.class == Class ? KeyAdapter : Object) do
        local_class_in ComboBoxCellEditor
        include_class_members ComboBoxCellEditor
        include KeyAdapter if KeyAdapter.class == Module
        
        typesig { [KeyEvent] }
        # hook key pressed - see PR 14201
        define_method :key_pressed do |e|
          key_release_occured(e)
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      @combo_box.add_selection_listener(Class.new(SelectionAdapter.class == Class ? SelectionAdapter : Object) do
        local_class_in ComboBoxCellEditor
        include_class_members ComboBoxCellEditor
        include SelectionAdapter if SelectionAdapter.class == Module
        
        typesig { [SelectionEvent] }
        define_method :widget_default_selected do |event|
          apply_editor_value_and_deactivate
        end
        
        typesig { [SelectionEvent] }
        define_method :widget_selected do |event|
          self.attr_selection = self.attr_combo_box.get_selection_index
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      @combo_box.add_traverse_listener(Class.new(TraverseListener.class == Class ? TraverseListener : Object) do
        local_class_in ComboBoxCellEditor
        include_class_members ComboBoxCellEditor
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
      @combo_box.add_focus_listener(Class.new(FocusAdapter.class == Class ? FocusAdapter : Object) do
        local_class_in ComboBoxCellEditor
        include_class_members ComboBoxCellEditor
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
      return @combo_box
    end
    
    typesig { [] }
    # The <code>ComboBoxCellEditor</code> implementation of this
    # <code>CellEditor</code> framework method returns the zero-based index
    # of the current selection.
    # 
    # @return the zero-based index of the current selection wrapped as an
    # <code>Integer</code>
    def do_get_value
      return @selection
    end
    
    typesig { [] }
    # (non-Javadoc) Method declared on CellEditor.
    def do_set_focus
      @combo_box.set_focus
    end
    
    typesig { [] }
    # The <code>ComboBoxCellEditor</code> implementation of this
    # <code>CellEditor</code> framework method sets the minimum width of the
    # cell. The minimum width is 10 characters if <code>comboBox</code> is
    # not <code>null</code> or <code>disposed</code> else it is 60 pixels
    # to make sure the arrow button and some text is visible. The list of
    # CCombo will be wide enough to show its longest item.
    def get_layout_data
      layout_data = super
      if (((@combo_box).nil?) || @combo_box.is_disposed)
        layout_data.attr_minimum_width = 60
      else
        # make the comboBox 10 characters wide
        gc = SwtGC.new(@combo_box)
        layout_data.attr_minimum_width = (gc.get_font_metrics.get_average_char_width * 10) + 10
        gc.dispose
      end
      return layout_data
    end
    
    typesig { [Object] }
    # The <code>ComboBoxCellEditor</code> implementation of this
    # <code>CellEditor</code> framework method accepts a zero-based index of
    # a selection.
    # 
    # @param value
    # the zero-based index of the selection wrapped as an
    # <code>Integer</code>
    def do_set_value(value)
      Assert.is_true(!(@combo_box).nil? && (value.is_a?(JavaInteger)))
      @selection = (value).int_value
      @combo_box.select(@selection)
    end
    
    typesig { [] }
    # Updates the list of choices for the combo box for the current control.
    def populate_combo_box_items
      if (!(@combo_box).nil? && !(@items).nil?)
        @combo_box.remove_all
        i = 0
        while i < @items.attr_length
          @combo_box.add(@items[i], i)
          i += 1
        end
        set_value_valid(true)
        @selection = 0
      end
    end
    
    typesig { [] }
    # Applies the currently selected value and deactivates the cell editor
    def apply_editor_value_and_deactivate
      # must set the selection before getting value
      @selection = @combo_box.get_selection_index
      new_value = do_get_value
      mark_dirty
      is_valid = is_correct(new_value)
      set_value_valid(is_valid)
      if (!is_valid)
        # Only format if the 'index' is valid
        if (@items.attr_length > 0 && @selection >= 0 && @selection < @items.attr_length)
          # try to insert the current value into the error message.
          set_error_message(MessageFormat.format(get_error_message, Array.typed(Object).new([@items[@selection]])))
        else
          # Since we don't have a valid index, assume we're using an
          # 'edit'
          # combo so format using its text value
          set_error_message(MessageFormat.format(get_error_message, Array.typed(Object).new([@combo_box.get_text])))
        end
      end
      fire_apply_editor_value
      deactivate
    end
    
    typesig { [] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.viewers.CellEditor#focusLost()
    def focus_lost
      if (is_activated)
        apply_editor_value_and_deactivate
      end
    end
    
    typesig { [KeyEvent] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.viewers.CellEditor#keyReleaseOccured(org.eclipse.swt.events.KeyEvent)
    def key_release_occured(key_event)
      if ((key_event.attr_character).equal?(Character.new(0x001b)))
        # Escape character
        fire_cancel_editor
      else
        if ((key_event.attr_character).equal?(Character.new(?\t.ord)))
          # tab key
          apply_editor_value_and_deactivate
        end
      end
    end
    
    private
    alias_method :initialize__combo_box_cell_editor, :initialize
  end
  
end
