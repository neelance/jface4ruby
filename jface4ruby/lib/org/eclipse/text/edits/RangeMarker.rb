require "rjava"

# Copyright (c) 2000, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Text::Edits
  module RangeMarkerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Text::Edits
      include_const ::Org::Eclipse::Jface::Text, :BadLocationException
      include_const ::Org::Eclipse::Jface::Text, :IDocument
    }
  end
  
  # A range marker can be used to track positions when executing
  # text edits.
  # 
  # @since 3.0
  class RangeMarker < RangeMarkerImports.const_get :TextEdit
    include_class_members RangeMarkerImports
    
    typesig { [::Java::Int, ::Java::Int] }
    # Creates a new range marker for the given offset and length.
    # 
    # @param offset the marker's offset
    # @param length the marker's length
    def initialize(offset, length)
      super(offset, length)
    end
    
    typesig { [RangeMarker] }
    # Copy constructor
    def initialize(other)
      super(other)
    end
    
    typesig { [] }
    # @see TextEdit#copy
    def do_copy
      return RangeMarker.new(self)
    end
    
    typesig { [TextEditVisitor] }
    # @see TextEdit#accept0
    def accept0(visitor)
      visit_children = visitor.visit(self)
      if (visit_children)
        accept_children(visitor)
      end
    end
    
    typesig { [IDocument] }
    # @see TextEdit#performDocumentUpdating
    def perform_document_updating(document)
      self.attr_f_delta = 0
      return self.attr_f_delta
    end
    
    typesig { [] }
    # @see TextEdit#deleteChildren
    def delete_children
      return false
    end
    
    private
    alias_method :initialize__range_marker, :initialize
  end
  
end
