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
  module VerticalRulerEventImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Source
    }
  end
  
  # An event sent to {@link org.eclipse.jface.text.source.IVerticalRulerListener} instances when annotation
  # related event occurs on the vertical ruler.
  # 
  # @since 3.0
  class VerticalRulerEvent 
    include_class_members VerticalRulerEventImports
    
    attr_accessor :f_annotation
    alias_method :attr_f_annotation, :f_annotation
    undef_method :f_annotation
    alias_method :attr_f_annotation=, :f_annotation=
    undef_method :f_annotation=
    
    typesig { [Annotation] }
    # Creates a new event.
    # 
    # @param annotation the annotation concerned, or <code>null</code>
    def initialize(annotation)
      @f_annotation = nil
      @f_annotation = annotation
    end
    
    typesig { [] }
    # @return the concerned annotation or <code>null</code>
    def get_selected_annotation
      return @f_annotation
    end
    
    typesig { [Annotation] }
    # @param annotation the concerned annotation, or <code>null</code>
    def set_selected_annotation(annotation)
      @f_annotation = annotation
    end
    
    private
    alias_method :initialize__vertical_ruler_event, :initialize
  end
  
end
