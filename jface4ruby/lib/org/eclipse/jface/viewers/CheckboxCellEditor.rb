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
  module CheckboxCellEditorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Control
    }
  end
  
  # A cell editor that manages a checkbox.
  # The cell editor's value is a boolean.
  # <p>
  # This class may be instantiated; it is not intended to be subclassed.
  # </p>
  # <p>
  # Note that this implementation simply fakes it and does does not create
  # any new controls. The mere activation of this editor means that the value
  # of the check box is being toggled by the end users; the listener method
  # <code>applyEditorValue</code> is immediately called to signal the change.
  # </p>
  # @noextend This class is not intended to be subclassed by clients.
  class CheckboxCellEditor < CheckboxCellEditorImports.const_get :CellEditor
    include_class_members CheckboxCellEditorImports
    
    # The checkbox value.
    # 
    # package
    attr_accessor :value
    alias_method :attr_value, :value
    undef_method :value
    alias_method :attr_value=, :value=
    undef_method :value=
    
    class_module.module_eval {
      # Default CheckboxCellEditor style
      const_set_lazy(:DefaultStyle) { SWT::NONE }
      const_attr_reader  :DefaultStyle
    }
    
    typesig { [] }
    # Creates a new checkbox cell editor with no control
    # @since 2.1
    def initialize
      @value = false
      super()
      @value = false
      set_style(DefaultStyle)
    end
    
    typesig { [Composite] }
    # Creates a new checkbox cell editor parented under the given control.
    # The cell editor value is a boolean value, which is initially <code>false</code>.
    # Initially, the cell editor has no cell validator.
    # 
    # @param parent the parent control
    def initialize(parent)
      initialize__checkbox_cell_editor(parent, DefaultStyle)
    end
    
    typesig { [Composite, ::Java::Int] }
    # Creates a new checkbox cell editor parented under the given control.
    # The cell editor value is a boolean value, which is initially <code>false</code>.
    # Initially, the cell editor has no cell validator.
    # 
    # @param parent the parent control
    # @param style the style bits
    # @since 2.1
    def initialize(parent, style)
      @value = false
      super(parent, style)
      @value = false
    end
    
    typesig { [] }
    # The <code>CheckboxCellEditor</code> implementation of
    # this <code>CellEditor</code> framework method simulates
    # the toggling of the checkbox control and notifies
    # listeners with <code>ICellEditorListener.applyEditorValue</code>.
    def activate
      @value = !@value
      fire_apply_editor_value
    end
    
    typesig { [Composite] }
    # The <code>CheckboxCellEditor</code> implementation of
    # this <code>CellEditor</code> framework method does
    # nothing and returns <code>null</code>.
    def create_control(parent)
      return nil
    end
    
    typesig { [] }
    # The <code>CheckboxCellEditor</code> implementation of
    # this <code>CellEditor</code> framework method returns
    # the checkbox setting wrapped as a <code>Boolean</code>.
    # 
    # @return the Boolean checkbox value
    def do_get_value
      return @value ? Boolean::TRUE : Boolean::FALSE
    end
    
    typesig { [] }
    # (non-Javadoc)
    # Method declared on CellEditor.
    def do_set_focus
      # Ignore
    end
    
    typesig { [Object] }
    # The <code>CheckboxCellEditor</code> implementation of
    # this <code>CellEditor</code> framework method accepts
    # a value wrapped as a <code>Boolean</code>.
    # 
    # @param value a Boolean value
    def do_set_value(value)
      Assert.is_true(value.is_a?(Boolean))
      @value = (value).boolean_value
    end
    
    typesig { [ColumnViewerEditorActivationEvent] }
    def activate(activation_event)
      if (!(activation_event.attr_event_type).equal?(ColumnViewerEditorActivationEvent::TRAVERSAL))
        super(activation_event)
      end
    end
    
    private
    alias_method :initialize__checkbox_cell_editor, :initialize
  end
  
end
