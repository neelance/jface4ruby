require "rjava"

# Copyright (c) 2008 Tom Schindl and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# Tom Schindl <tom.schindl@bestsolution.at> - initial API and implementation (bug 174739)
module Org::Eclipse::Jface::Viewers
  module AbstractComboBoxCellEditorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Custom, :CCombo
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
    }
  end
  
  # Abstract base class for Cell-Editors presented as combo boxes
  # 
  # @since 3.4
  class AbstractComboBoxCellEditor < AbstractComboBoxCellEditorImports.const_get :CellEditor
    include_class_members AbstractComboBoxCellEditorImports
    
    class_module.module_eval {
      # The list is dropped down when the activation is done through the mouse
      const_set_lazy(:DROP_DOWN_ON_MOUSE_ACTIVATION) { 1 }
      const_attr_reader  :DROP_DOWN_ON_MOUSE_ACTIVATION
      
      # The list is dropped down when the activation is done through the keyboard
      const_set_lazy(:DROP_DOWN_ON_KEY_ACTIVATION) { 1 << 1 }
      const_attr_reader  :DROP_DOWN_ON_KEY_ACTIVATION
      
      # The list is dropped down when the activation is done without
      # ui-interaction
      const_set_lazy(:DROP_DOWN_ON_PROGRAMMATIC_ACTIVATION) { 1 << 2 }
      const_attr_reader  :DROP_DOWN_ON_PROGRAMMATIC_ACTIVATION
      
      # The list is dropped down when the activation is done by traversing from
      # cell to cell
      const_set_lazy(:DROP_DOWN_ON_TRAVERSE_ACTIVATION) { 1 << 3 }
      const_attr_reader  :DROP_DOWN_ON_TRAVERSE_ACTIVATION
    }
    
    attr_accessor :activation_style
    alias_method :attr_activation_style, :activation_style
    undef_method :activation_style
    alias_method :attr_activation_style=, :activation_style=
    undef_method :activation_style=
    
    typesig { [Composite, ::Java::Int] }
    # Create a new cell-editor
    # 
    # @param parent
    # the parent of the combo
    # @param style
    # the style used to create the combo
    def initialize(parent, style)
      @activation_style = 0
      super(parent, style)
      @activation_style = SWT::NONE
    end
    
    typesig { [] }
    # Creates a new cell editor with no control and no st of choices.
    # Initially, the cell editor has no cell validator.
    def initialize
      @activation_style = 0
      super()
      @activation_style = SWT::NONE
    end
    
    typesig { [ColumnViewerEditorActivationEvent] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.viewers.CellEditor#activate(org.eclipse.jface.viewers.ColumnViewerEditorActivationEvent)
    def activate(activation_event)
      super(activation_event)
      if (!(@activation_style).equal?(SWT::NONE))
        drop_down = false
        if (((activation_event.attr_event_type).equal?(ColumnViewerEditorActivationEvent::MOUSE_CLICK_SELECTION) || (activation_event.attr_event_type).equal?(ColumnViewerEditorActivationEvent::MOUSE_DOUBLE_CLICK_SELECTION)) && !((@activation_style & DROP_DOWN_ON_MOUSE_ACTIVATION)).equal?(0))
          drop_down = true
        else
          if ((activation_event.attr_event_type).equal?(ColumnViewerEditorActivationEvent::KEY_PRESSED) && !((@activation_style & DROP_DOWN_ON_KEY_ACTIVATION)).equal?(0))
            drop_down = true
          else
            if ((activation_event.attr_event_type).equal?(ColumnViewerEditorActivationEvent::PROGRAMMATIC) && !((@activation_style & DROP_DOWN_ON_PROGRAMMATIC_ACTIVATION)).equal?(0))
              drop_down = true
            else
              if ((activation_event.attr_event_type).equal?(ColumnViewerEditorActivationEvent::TRAVERSAL) && !((@activation_style & DROP_DOWN_ON_TRAVERSE_ACTIVATION)).equal?(0))
                drop_down = true
              end
            end
          end
        end
        if (drop_down)
          get_control.get_display.async_exec(Class.new(Runnable.class == Class ? Runnable : Object) do
            extend LocalClass
            include_class_members AbstractComboBoxCellEditor
            include Runnable if Runnable.class == Module
            
            typesig { [] }
            define_method :run do
              (get_control).set_list_visible(true)
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
    end
    
    typesig { [::Java::Int] }
    # This method allows to control how the combo reacts when activated
    # 
    # @param activationStyle
    # the style used
    def set_activation_style(activation_style)
      @activation_style = activation_style
    end
    
    private
    alias_method :initialize__abstract_combo_box_cell_editor, :initialize
  end
  
end
