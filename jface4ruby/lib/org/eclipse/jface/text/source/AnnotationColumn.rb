require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Source
  module AnnotationColumnImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Source
    }
  end
  
  # @deprecated use
  # {@link org.eclipse.jface.text.source.AnnotationRulerColumn#AnnotationRulerColumn(int)}
  # instead.
  # @since 2.0
  class AnnotationColumn < AnnotationColumnImports.const_get :AnnotationRulerColumn
    include_class_members AnnotationColumnImports
    
    typesig { [::Java::Int] }
    # Creates a new <code>AnnotationColumn</code> of the given width.
    # 
    # @param width the width of this column
    # @deprecated Use
    # {@link org.eclipse.jface.text.source.AnnotationRulerColumn#AnnotationRulerColumn(int)}
    # instead
    def initialize(width)
      super(width)
    end
    
    private
    alias_method :initialize__annotation_column, :initialize
  end
  
end
