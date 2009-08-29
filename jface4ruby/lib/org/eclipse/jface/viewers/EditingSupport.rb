require "rjava"

# Copyright (c) 2006, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
# Tom Schindl <tom.schindl@bestsolution.at> - initial API and implementation
# fix in bug 151295,167325,201905
module Org::Eclipse::Jface::Viewers
  module EditingSupportImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
      include_const ::Org::Eclipse::Core::Runtime, :Assert
    }
  end
  
  # EditingSupport is the abstract superclass of the support for cell editing.
  # 
  # @since 3.3
  class EditingSupport 
    include_class_members EditingSupportImports
    
    attr_accessor :viewer
    alias_method :attr_viewer, :viewer
    undef_method :viewer
    alias_method :attr_viewer=, :viewer=
    undef_method :viewer=
    
    typesig { [ColumnViewer] }
    # @param viewer
    # a new viewer
    def initialize(viewer)
      @viewer = nil
      Assert.is_not_null(viewer, "Viewer is not allowed to be null") # $NON-NLS-1$
      @viewer = viewer
    end
    
    typesig { [Object] }
    # The editor to be shown
    # 
    # @param element
    # the model element
    # @return the CellEditor
    def get_cell_editor(element)
      raise NotImplementedError
    end
    
    typesig { [Object] }
    # Is the cell editable
    # 
    # @param element
    # the model element
    # @return true if editable
    def can_edit(element)
      raise NotImplementedError
    end
    
    typesig { [Object] }
    # Get the value to set to the editor
    # 
    # @param element
    # the model element
    # @return the value shown
    def get_value(element)
      raise NotImplementedError
    end
    
    typesig { [Object, Object] }
    # Sets the new value on the given element. Note that implementers need to
    # ensure that <code>getViewer().update(element, null)</code> or similar
    # methods are called, either directly or through some kind of listener
    # mechanism on the implementer's model, to cause the new value to appear in
    # the viewer.
    # 
    # <p>
    # <b>Subclasses should overwrite.</b>
    # </p>
    # 
    # @param element
    # the model element
    # @param value
    # the new value
    def set_value(element, value)
      raise NotImplementedError
    end
    
    typesig { [] }
    # @return the viewer this editing support works for
    def get_viewer
      return @viewer
    end
    
    typesig { [CellEditor, ViewerCell] }
    # Initialize the editor. Frameworks like Databinding can hook in here and provide
    # a customized implementation. <p><b>Standard customers should not overwrite this method but {@link #getValue(Object)}</b></p>
    # 
    # @param cellEditor
    # the cell editor
    # @param cell
    # the cell the editor is working for
    def initialize_cell_editor_value(cell_editor, cell)
      value = get_value(cell.get_element)
      cell_editor.set_value(value)
    end
    
    typesig { [CellEditor, ViewerCell] }
    # Save the value of the cell editor back to the model. Frameworks like Databinding can hook in here and provide
    # a customized implementation. <p><b>Standard customers should not overwrite this method but {@link #setValue(Object, Object)} </b></p>
    # @param cellEditor
    # the cell-editor
    # @param cell
    # the cell the editor is working for
    def save_cell_editor_value(cell_editor, cell)
      value = cell_editor.get_value
      set_value(cell.get_element, value)
    end
    
    typesig { [] }
    def is_legacy_support
      return false
    end
    
    private
    alias_method :initialize__editing_support, :initialize
  end
  
end
