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
  module IOverviewRulerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Source
      include_const ::Org::Eclipse::Swt::Graphics, :Color
      include_const ::Org::Eclipse::Swt::Widgets, :Control
    }
  end
  
  # This interface defines a visual component which may serve
  # text viewers as an overview annotation presentation area.  This means,
  # presentation of annotations is independent from the actual view port of
  # the text viewer. The annotations of the viewer's whole document are
  # visible in the overview ruler.
  # <p>
  # This interfaces embodies three contracts:
  # <ul>
  # <li>	The overview ruler retrieves the annotations it presents from an annotation model.
  # <li>	The ruler is a visual component which must be integrated in a hierarchy of SWT controls.
  # <li> The ruler provides interested clients with mapping and
  # interaction information. This covers the mapping between
  # coordinates of the ruler's control and line numbers based
  # on the connected text viewer's document (<code>IVerticalRulerInfo</code>).
  # </ul></p>
  # <p>
  # Clients may implement this interface or use the default implementation provided
  # by <code>OverviewlRuler</code>.</p>
  # 
  # @see org.eclipse.jface.text.ITextViewer
  # @since 2.1
  module IOverviewRuler
    include_class_members IOverviewRulerImports
    include IVerticalRuler
    
    typesig { [::Java::Int] }
    # Returns whether there is an annotation an the given vertical coordinate. This
    # method takes the compression factor of the overview ruler into account.
    # 
    # @param y the y-coordinate
    # @return <code>true</code> if there is an annotation, <code>false</code> otherwise
    def has_annotation(y)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the height of the visual presentation of an annotation in this
    # overview ruler. Assumes that all annotations are represented using the
    # same height.
    # 
    # @return int the visual height of an annotation
    def get_annotation_height
      raise NotImplementedError
    end
    
    typesig { [Object, Color] }
    # Sets the color for the given annotation type in this overview ruler.
    # 
    # @param annotationType the annotation type
    # @param color the color
    def set_annotation_type_color(annotation_type, color)
      raise NotImplementedError
    end
    
    typesig { [Object, ::Java::Int] }
    # Sets the drawing layer for the given annotation type in this overview ruler.
    # 
    # @param annotationType the annotation type
    # @param layer the drawing layer
    def set_annotation_type_layer(annotation_type, layer)
      raise NotImplementedError
    end
    
    typesig { [Object] }
    # Adds the given annotation type to this overview ruler. Starting with this
    # call, annotations of the given type are shown in the overview ruler.
    # 
    # @param annotationType the annotation type
    def add_annotation_type(annotation_type)
      raise NotImplementedError
    end
    
    typesig { [Object] }
    # Removes the given annotation type from this overview ruler. Annotations
    # of the given type are no longer shown in the overview ruler.
    # 
    # @param annotationType the annotation type
    def remove_annotation_type(annotation_type)
      raise NotImplementedError
    end
    
    typesig { [Object] }
    # Adds the given annotation type to the header of this ruler. Starting with
    # this call, the presence of annotations is tracked and the header is drawn
    # in the configured color.
    # 
    # @param annotationType the annotation type to be tracked
    def add_header_annotation_type(annotation_type)
      raise NotImplementedError
    end
    
    typesig { [Object] }
    # Removes the given annotation type from the header of this ruler. The
    # presence of annotations of the given type is no longer tracked and the
    # header is drawn in the default color, depending on the other configured
    # configured annotation types.
    # 
    # @param annotationType the annotation type to be removed
    def remove_header_annotation_type(annotation_type)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns this rulers header control. This is the little area between the
    # top of the text widget and the top of this overview ruler.
    # 
    # @return the header control of this overview ruler.
    def get_header_control
      raise NotImplementedError
    end
  end
  
end
