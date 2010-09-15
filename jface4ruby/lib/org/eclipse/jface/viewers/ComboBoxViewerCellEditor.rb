require "rjava"

# Copyright (c) 2006, 2008 Tom Schindl and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# Tom Schindl <tom.schindl@bestsolution.at> - initial API and implementation
# bugfix in 174739
# Eric Rizzo - bug 213315
module Org::Eclipse::Jface::Viewers
  module ComboBoxViewerCellEditorImports #:nodoc:
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
  # A cell editor that presents a list of items in a combo box. In contrast to
  # {@link ComboBoxCellEditor} it wraps the underlying {@link CCombo} using a
  # {@link ComboViewer}
  # @since 3.4
  class ComboBoxViewerCellEditor < ComboBoxViewerCellEditorImports.const_get :AbstractComboBoxCellEditor
    include_class_members ComboBoxViewerCellEditorImports
    
    # The custom combo box control.
    attr_accessor :viewer
    alias_method :attr_viewer, :viewer
    undef_method :viewer
    alias_method :attr_viewer=, :viewer=
    undef_method :viewer=
    
    attr_accessor :selected_value
    alias_method :attr_selected_value, :selected_value
    undef_method :selected_value
    alias_method :attr_selected_value=, :selected_value=
    undef_method :selected_value=
    
    class_module.module_eval {
      # Default ComboBoxCellEditor style
      const_set_lazy(:DefaultStyle) { SWT::NONE }
      const_attr_reader  :DefaultStyle
    }
    
    typesig { [Composite] }
    # Creates a new cell editor with a combo viewer and a default style
    # 
    # @param parent
    # the parent control
    def initialize(parent)
      initialize__combo_box_viewer_cell_editor(parent, DefaultStyle)
    end
    
    typesig { [Composite, ::Java::Int] }
    # Creates a new cell editor with a combo viewer and the given style
    # 
    # @param parent
    # the parent control
    # @param style
    # the style bits
    def initialize(parent, style)
      @viewer = nil
      @selected_value = nil
      super(parent, style)
      set_value_valid(true)
    end
    
    typesig { [Composite] }
    # (non-Javadoc) Method declared on CellEditor.
    def create_control(parent)
      combo_box = CCombo.new(parent, get_style)
      combo_box.set_font(parent.get_font)
      @viewer = ComboViewer.new(combo_box)
      combo_box.add_key_listener(Class.new(KeyAdapter.class == Class ? KeyAdapter : Object) do
        local_class_in ComboBoxViewerCellEditor
        include_class_members ComboBoxViewerCellEditor
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
      combo_box.add_selection_listener(Class.new(SelectionAdapter.class == Class ? SelectionAdapter : Object) do
        local_class_in ComboBoxViewerCellEditor
        include_class_members ComboBoxViewerCellEditor
        include SelectionAdapter if SelectionAdapter.class == Module
        
        typesig { [SelectionEvent] }
        define_method :widget_default_selected do |event|
          apply_editor_value_and_deactivate
        end
        
        typesig { [SelectionEvent] }
        define_method :widget_selected do |event|
          selection = self.attr_viewer.get_selection
          if (selection.is_empty)
            self.attr_selected_value = nil
          else
            self.attr_selected_value = (selection).get_first_element
          end
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      combo_box.add_traverse_listener(Class.new(TraverseListener.class == Class ? TraverseListener : Object) do
        local_class_in ComboBoxViewerCellEditor
        include_class_members ComboBoxViewerCellEditor
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
      combo_box.add_focus_listener(Class.new(FocusAdapter.class == Class ? FocusAdapter : Object) do
        local_class_in ComboBoxViewerCellEditor
        include_class_members ComboBoxViewerCellEditor
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
      return combo_box
    end
    
    typesig { [] }
    # The <code>ComboBoxCellEditor</code> implementation of this
    # <code>CellEditor</code> framework method returns the zero-based index
    # of the current selection.
    # 
    # @return the zero-based index of the current selection wrapped as an
    # <code>Integer</code>
    def do_get_value
      return @selected_value
    end
    
    typesig { [] }
    # (non-Javadoc) Method declared on CellEditor.
    def do_set_focus
      @viewer.get_control.set_focus
    end
    
    typesig { [] }
    # The <code>ComboBoxCellEditor</code> implementation of this
    # <code>CellEditor</code> framework method sets the minimum width of the
    # cell. The minimum width is 10 characters if <code>comboBox</code> is
    # not <code>null</code> or <code>disposed</code> eles it is 60 pixels
    # to make sure the arrow button and some text is visible. The list of
    # CCombo will be wide enough to show its longest item.
    def get_layout_data
      layout_data = super
      if (((@viewer.get_control).nil?) || @viewer.get_control.is_disposed)
        layout_data.attr_minimum_width = 60
      else
        # make the comboBox 10 characters wide
        gc = SwtGC.new(@viewer.get_control)
        layout_data.attr_minimum_width = (gc.get_font_metrics.get_average_char_width * 10) + 10
        gc.dispose
      end
      return layout_data
    end
    
    typesig { [Object] }
    # Set a new value
    # 
    # @param value
    # the new value
    def do_set_value(value)
      Assert.is_true(!(@viewer).nil?)
      @selected_value = value
      if ((value).nil?)
        @viewer.set_selection(StructuredSelection::EMPTY)
      else
        @viewer.set_selection(StructuredSelection.new(value))
      end
    end
    
    typesig { [IBaseLabelProvider] }
    # @param labelProvider
    # the label provider used
    # @see StructuredViewer#setLabelProvider(IBaseLabelProvider)
    def set_label_provider(label_provider)
      @viewer.set_label_provider(label_provider)
    end
    
    typesig { [IStructuredContentProvider] }
    # @param provider
    # the content provider used
    # @see StructuredViewer#setContentProvider(IContentProvider)
    def set_conten_provider(provider)
      @viewer.set_content_provider(provider)
    end
    
    typesig { [Object] }
    # @param input
    # the input used
    # @see StructuredViewer#setInput(Object)
    def set_input(input)
      @viewer.set_input(input)
    end
    
    typesig { [] }
    # @return get the viewer
    def get_viewer
      return @viewer
    end
    
    typesig { [] }
    # Applies the currently selected value and deactiavates the cell editor
    def apply_editor_value_and_deactivate
      # must set the selection before getting value
      selection = @viewer.get_selection
      if (selection.is_empty)
        @selected_value = nil
      else
        @selected_value = (selection).get_first_element
      end
      new_value = do_get_value
      mark_dirty
      is_valid = is_correct(new_value)
      set_value_valid(is_valid)
      if (!is_valid)
        MessageFormat.format(get_error_message, Array.typed(Object).new([@selected_value]))
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
    alias_method :initialize__combo_box_viewer_cell_editor, :initialize
  end
  
end
