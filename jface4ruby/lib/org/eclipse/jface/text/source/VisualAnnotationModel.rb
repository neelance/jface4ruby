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
  module VisualAnnotationModelImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Source
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :Iterator
      include_const ::Org::Eclipse::Jface::Text, :IDocument
      include_const ::Org::Eclipse::Jface::Text, :Position
    }
  end
  
  # Annotation model for visual annotations. Assume a viewer's input element is annotated with
  # some semantic annotation such as a breakpoint and that it is simultaneously shown in multiple
  # viewers. A source viewer, e.g., supports visual range indication for which it utilizes
  # annotations. The range indicating annotation is specific to the visual presentation
  # of the input element in this viewer and thus should only be visible in this viewer. The
  # breakpoints however are independent from the input element's presentation and thus should
  # be shown in all viewers in which the element is shown. As a viewer supports one vertical
  # ruler which is based on one annotation model, there must be a visual annotation model for
  # each viewer which all wrap the same element specific model annotation model.
  class VisualAnnotationModel < VisualAnnotationModelImports.const_get :AnnotationModel
    include_class_members VisualAnnotationModelImports
    overload_protected {
      include IAnnotationModelListener
    }
    
    # The wrapped model annotation model
    attr_accessor :f_model
    alias_method :attr_f_model, :f_model
    undef_method :f_model
    alias_method :attr_f_model=, :f_model=
    undef_method :f_model=
    
    typesig { [IAnnotationModel] }
    # Constructs a visual annotation model which wraps the given
    # model based annotation model
    # 
    # @param modelAnnotationModel the model based annotation model
    def initialize(model_annotation_model)
      @f_model = nil
      super()
      @f_model = model_annotation_model
    end
    
    typesig { [] }
    # Returns the visual annotation model's wrapped model based annotation model.
    # 
    # @return the model based annotation model
    def get_model_annotation_model
      return @f_model
    end
    
    typesig { [IAnnotationModelListener] }
    # @see IAnnotationModel#addAnnotationModelListener(IAnnotationModelListener)
    def add_annotation_model_listener(listener)
      if (!(@f_model).nil? && self.attr_f_annotation_model_listeners.is_empty)
        @f_model.add_annotation_model_listener(self)
      end
      super(listener)
    end
    
    typesig { [IDocument] }
    # @see IAnnotationModel#connect(IDocument)
    def connect(document)
      super(document)
      if (!(@f_model).nil?)
        @f_model.connect(document)
      end
    end
    
    typesig { [IDocument] }
    # @see IAnnotationModel#disconnect(IDocument)
    def disconnect(document)
      super(document)
      if (!(@f_model).nil?)
        @f_model.disconnect(document)
      end
    end
    
    typesig { [] }
    # @see IAnnotationModel#getAnnotationIterator()
    def get_annotation_iterator
      if ((@f_model).nil?)
        return super
      end
      a = ArrayList.new(20)
      e = @f_model.get_annotation_iterator
      while (e.has_next)
        a.add(e.next_)
      end
      e = super
      while (e.has_next)
        a.add(e.next_)
      end
      return a.iterator
    end
    
    typesig { [Annotation] }
    # @see IAnnotationModel#getPosition(Annotation)
    def get_position(annotation)
      p = get_annotation_map.get(annotation)
      if (!(p).nil?)
        return p
      end
      if (!(@f_model).nil?)
        return @f_model.get_position(annotation)
      end
      return nil
    end
    
    typesig { [IAnnotationModel] }
    # @see IAnnotationModelListener#modelChanged(IAnnotationModel)
    def model_changed(model)
      if ((model).equal?(@f_model))
        iter = ArrayList.new(self.attr_f_annotation_model_listeners).iterator
        while (iter.has_next)
          l = iter.next_
          l.model_changed(self)
        end
      end
    end
    
    typesig { [IAnnotationModelListener] }
    # @see IAnnotationModel#removeAnnotationModelListener(IAnnotationModelListener)
    def remove_annotation_model_listener(listener)
      super(listener)
      if (!(@f_model).nil? && self.attr_f_annotation_model_listeners.is_empty)
        @f_model.remove_annotation_model_listener(self)
      end
    end
    
    private
    alias_method :initialize__visual_annotation_model, :initialize
  end
  
end
