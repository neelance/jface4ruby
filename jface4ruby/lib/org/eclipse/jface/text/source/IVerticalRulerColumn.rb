require "rjava"

# Copyright (c) 2000, 2005 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Source
  module IVerticalRulerColumnImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Source
      include_const ::Org::Eclipse::Swt::Graphics, :Font
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Control
    }
  end
  
  # A vertical ruler column is an element that can be added to a composite
  # vertical ruler ({@link org.eclipse.jface.text.source.CompositeRuler}). A
  # composite vertical ruler is a vertical ruler with  dynamically changing
  # appearance and behavior depending on its actual arrangement of ruler columns.
  # A vertical ruler column supports a subset of the contract of a vertical
  # ruler.
  # 
  # @see org.eclipse.jface.text.source.CompositeRuler
  # @since 2.0
  module IVerticalRulerColumn
    include_class_members IVerticalRulerColumnImports
    
    typesig { [IAnnotationModel] }
    # Associates an annotation model with this ruler column.
    # A value <code>null</code> is acceptable and clears the ruler.
    # 
    # @param model the new annotation model, may be <code>null</code>
    def set_model(model)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Redraws this column.
    def redraw
      raise NotImplementedError
    end
    
    typesig { [CompositeRuler, Composite] }
    # Creates the column's SWT control.
    # 
    # @param parentRuler the parent ruler of this column
    # @param parentControl the control of the parent ruler
    # @return the column's SWT control
    def create_control(parent_ruler, parent_control)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the column's SWT control.
    # 
    # @return the column's SWT control
    def get_control
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the width of this column's control.
    # 
    # @return the width of this column's control
    def get_width
      raise NotImplementedError
    end
    
    typesig { [Font] }
    # Sets the font of this ruler column.
    # 
    # @param font the new font of the ruler column
    def set_font(font)
      raise NotImplementedError
    end
  end
  
end
