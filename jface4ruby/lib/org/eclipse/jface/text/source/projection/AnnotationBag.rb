require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Source::Projection
  module AnnotationBagImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Source::Projection
      include_const ::Java::Util, :HashSet
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :JavaSet
      include_const ::Org::Eclipse::Jface::Text::Source, :Annotation
    }
  end
  
  # A bag of annotations.
  # <p>
  # This class is not intended to be subclassed.
  # </p>
  # 
  # @since 3.0
  # @noextend This class is not intended to be subclassed by clients.
  class AnnotationBag < AnnotationBagImports.const_get :Annotation
    include_class_members AnnotationBagImports
    
    attr_accessor :f_annotations
    alias_method :attr_f_annotations, :f_annotations
    undef_method :f_annotations
    alias_method :attr_f_annotations=, :f_annotations=
    undef_method :f_annotations=
    
    typesig { [String] }
    # Creates a new annotation bag.
    # 
    # @param type the annotation type
    def initialize(type)
      @f_annotations = nil
      super(type, false, nil)
    end
    
    typesig { [Annotation] }
    # Adds the given annotation to the annotation bag.
    # 
    # @param annotation the annotation to add
    def add(annotation)
      if ((@f_annotations).nil?)
        @f_annotations = HashSet.new(2)
      end
      @f_annotations.add(annotation)
    end
    
    typesig { [Annotation] }
    # Removes the given annotation from the annotation bag.
    # 
    # @param annotation the annotation to remove
    def remove(annotation)
      if (!(@f_annotations).nil?)
        @f_annotations.remove(annotation)
        if (@f_annotations.is_empty)
          @f_annotations = nil
        end
      end
    end
    
    typesig { [] }
    # Returns whether the annotation bag is empty.
    # 
    # @return <code>true</code> if the annotation bag is empty, <code>false</code> otherwise
    def is_empty
      return (@f_annotations).nil?
    end
    
    typesig { [] }
    # Returns an iterator for all annotation inside this
    # annotation bag or <code>null</code> if the bag is empty.
    # 
    # @return an iterator for all annotations in the bag or <code>null</code>
    # @since 3.1
    def iterator
      if (!is_empty)
        return @f_annotations.iterator
      end
      return nil
    end
    
    private
    alias_method :initialize__annotation_bag, :initialize
  end
  
end
