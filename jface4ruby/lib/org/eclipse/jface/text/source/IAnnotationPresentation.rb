require "rjava"

# Copyright (c) 2000, 2007 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Source
  module IAnnotationPresentationImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Source
      include_const ::Org::Eclipse::Swt::Graphics, :GC
      include_const ::Org::Eclipse::Swt::Graphics, :Rectangle
      include_const ::Org::Eclipse::Swt::Widgets, :Canvas
    }
  end
  
  # Interface for annotations that can take care of their own visible representation.
  # 
  # @since 3.0
  module IAnnotationPresentation
    include_class_members IAnnotationPresentationImports
    
    class_module.module_eval {
      # The default annotation layer.
      const_set_lazy(:DEFAULT_LAYER) { 0 }
      const_attr_reader  :DEFAULT_LAYER
    }
    
    typesig { [] }
    # Returns the annotations drawing layer.
    # 
    # @return the annotations drawing layer
    def get_layer
      raise NotImplementedError
    end
    
    typesig { [GC, Canvas, Rectangle] }
    # Implement this method to draw a graphical representation
    # of this annotation within the given bounds.
    # <p>
    # <em>Note that this method is not used when drawing annotations on the editor's
    # text widget. This is handled trough a {@link org.eclipse.jface.text.source.AnnotationPainter.IDrawingStrategy}.</em>
    # </p>
    # @param gc the drawing GC
    # @param canvas the canvas to draw on
    # @param bounds the bounds inside the canvas to draw on
    def paint(gc, canvas, bounds)
      raise NotImplementedError
    end
  end
  
end
