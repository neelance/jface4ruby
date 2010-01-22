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
  module IAnnotationAccessExtensionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Source
      include_const ::Org::Eclipse::Swt::Graphics, :SwtGC
      include_const ::Org::Eclipse::Swt::Graphics, :Rectangle
      include_const ::Org::Eclipse::Swt::Widgets, :Canvas
    }
  end
  
  # Extension interface for {@link org.eclipse.jface.text.source.IAnnotationAccess}.<p>
  # This interface replaces the methods of <code>IAnnotationAccess</code>.<p>
  # This interface provides
  # <ul>
  # <li> a label for the annotation type of a given annotation</li>
  # <li> the paint layer of a given annotation</li>
  # <li> means to paint a given annotation</li>
  # <li> information about the type hierarchy of the annotation type of a given annotation</li>
  # <ul>.
  # 
  # @see org.eclipse.jface.text.source.IAnnotationAccess
  # @since 3.0
  module IAnnotationAccessExtension
    include_class_members IAnnotationAccessExtensionImports
    
    class_module.module_eval {
      # The default annotation layer.
      const_set_lazy(:DEFAULT_LAYER) { IAnnotationPresentation::DEFAULT_LAYER }
      const_attr_reader  :DEFAULT_LAYER
    }
    
    typesig { [Annotation] }
    # Returns the label for the given annotation's type.
    # 
    # @param annotation the annotation
    # @return the label the given annotation's type or <code>null</code> if no such label exists
    def get_type_label(annotation)
      raise NotImplementedError
    end
    
    typesig { [Annotation] }
    # Returns the layer for given annotation. Annotations are considered
    # being located at layers and are considered being painted starting with
    # layer 0 upwards. Thus an annotation at layer 5 will be drawn on top of
    # all co-located annotations at the layers 4 - 0.
    # 
    # @param annotation the annotation
    # @return the layer of the given annotation
    def get_layer(annotation)
      raise NotImplementedError
    end
    
    typesig { [Annotation, SwtGC, Canvas, Rectangle] }
    # Draws a graphical representation of the given annotation within the given bounds.
    # <p>
    # <em>Note that this method is not used when drawing annotations on the editor's
    # text widget. This is handled trough a {@link org.eclipse.jface.text.source.AnnotationPainter.IDrawingStrategy}.</em>
    # </p>
    # @param annotation the given annotation
    # @param gc the drawing GC
    # @param canvas the canvas to draw on
    # @param bounds the bounds inside the canvas to draw on
    def paint(annotation, gc, canvas, bounds)
      raise NotImplementedError
    end
    
    typesig { [Annotation] }
    # Returns <code>true</code> if painting <code>annotation</code> will produce something
    # meaningful, <code>false</code> if not. E.g. if no image is available.
    # <p>
    # <em>Note that this method is not used when drawing annotations on the editor's
    # text widget. This is handled trough a {@link org.eclipse.jface.text.source.AnnotationPainter.IDrawingStrategy}.</em>
    # </p>
    # @param annotation the annotation to check whether it can be painted
    # @return <code>true</code> if painting <code>annotation</code> will succeed
    def is_paintable(annotation)
      raise NotImplementedError
    end
    
    typesig { [Object, Object] }
    # Returns <code>true</code> if the given annotation is of the given type
    # or <code>false</code> otherwise.
    # 
    # @param annotationType the annotation type
    # @param potentialSupertype the potential super annotation type
    # @return <code>true</code> if annotation type is a sub-type of the potential annotation super type
    def is_subtype(annotation_type, potential_supertype)
      raise NotImplementedError
    end
    
    typesig { [Object] }
    # Returns the list of super types for the given annotation type. This does not include the type
    # itself. The index in the array of super types indicates the length of the path in the hierarchy
    # graph to the given annotation type.
    # 
    # @param annotationType the annotation type to check
    # @return the super types for the given annotation type
    def get_supertypes(annotation_type)
      raise NotImplementedError
    end
  end
  
end
